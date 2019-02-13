; *****************************************************************************
; BEEB specific routines (not boot)
; *****************************************************************************

beeb_writeptr   = ZP_1E             ; write ptr
beeb_readptr    = ZP_20             ; read ptr

.beeb_code_start

TIMER_PartA = 32*64 - 2*64 + 1*64 -2    ; character row 0, scanline 1
TIMER_PartB = 8*64 -2                   ; character row 1, scanline 1
TIMER_PartC = 18*8*64 -2                ; character row 19, scanline 1

TIMER_Preview = 8*21*64 - 1*64 -2              ; character row 20, scanline 1
TIMER_Menu = 8*8*64 + 4*64 -2                  ; character row 8, scanline 1

CRTC_R8_DisplayEnableValue=%11000000
;                           ^^^^^^^^
;                           ||||||++ - 00 = non-interlaced sync mode
;                           ||||++-- - <<unused bits>>
;                           ||++---- - 00 = no display blanking delay
;                           ||         11 = disable display
;                           ++------ - 11 = disable cursor
CRTC_R8_DisplayDisableValue=CRTC_R8_DisplayEnableValue OR %00110000

.irq_handler
{
	LDA &FE4D
    AND #2
    BEQ irq_timer1

    \\ Otherwise vsync
    .irq_vsync
    STA &FE4D

	LDA #LO(TIMER_PartA):STA &FE44		; R4=T1 Low-Order Latches (write)
	LDA #HI(TIMER_PartA):STA &FE45		; R5=T1 High-Order Counter

    INC vsync_counter
    LDA #0
    STA irq_part

	lda #8:sta $fe00

    ; space is a bit tight in main RAM, so save a few bytes with some
    ; self-modifying code...
.*irq_handler_load_r8_value
	lda #CRTC_R8_DisplayDisableValue ;! _SELF_MOD
									;_ensure_screen_enabled,
									;_disable_screen
	sta $fe01

    LDA &FC
    RTI

    .irq_timer1
    LDA #&40
    STA &FE4D

    LDA irq_mode
    BEQ enter_frontend			; taken if $00

    BPL in_frontend				; taken if <$80
    JMP in_game

    .in_frontend
    CMP #&40					
    BEQ track_preview			; taken if $40

    \\ Menus

IF 0
    ; LDA irq_part
    ; BNE menu_options

    ; \\ Header
    ; LDA irq_part
    ; BNE menu_options

	; LDA #LO(TIMER_Menu):STA &FE44		; R4=T1 Low-Order Latches (write)
	; LDA #HI(TIMER_Menu):STA &FE45		; R5=T1 High-Order Counter
    
    ; TXA:PHA:TYA:PHA
    ; JSR beeb_set_mode_5
    ; PLA:TAY:PLA:TAX
    ; INC irq_part
    ; JMP also_return

    ; .menu_options
    ; TXA:PHA:TYA:PHA
    ; JSR beeb_set_mode_4
    ; PLA:TAY:PLA:TAX
ENDIF

    JMP also_return

    .not_header

    \\ Front end

    .enter_frontend
    LDA #4:STA &FE00        ; R4 = vertical total
    LDA #39:STA &FE01       ; 39 rows standard

	LDA #6:STA &FE00		; R6 = vertical displayed
	LDA #25:STA &FE01		; 25 rows = 200 scanlines

    LDA #7:STA &FE00        ; R7 = vsync
    LDA #35:STA &FE01       ; vsync at row 35

    \\ Set screen1 visible as our front end

	LDA #12:STA &FE00
	LDA #HI(screen1_address/8):STA &FE01

	LDA #13:STA &FE00
	LDA #LO(screen1_address/8):STA &FE01

    \\ Don't set a new timer, just return

    .also_return
    LDA &FC
    RTI

    .track_preview
    LDA irq_part
    BNE preview_bottom

	LDA #LO(TIMER_Preview):STA &FE44		; R4=T1 Low-Order Latches (write)
	LDA #HI(TIMER_Preview):STA &FE45		; R5=T1 High-Order Counter
    
    TXA:PHA:TYA:PHA
    JSR beeb_set_mode_5
    PLA:TAY:PLA:TAX
    INC irq_part
    JMP also_return

    .preview_bottom
    TXA:PHA:TYA:PHA
    JSR beeb_set_mode_4
    PLA:TAY:PLA:TAX
    JMP also_return

    .in_game

    \\ In Game

    LDA irq_part
    BNE not_partA

    \\ Part A

	LDA #LO(TIMER_PartB):STA &FE44		; R4=T1 Low-Order Latches (write)
	LDA #HI(TIMER_PartB):STA &FE45		; R5=T1 High-Order Counter

    LDA #4:STA &FE00        ; R4 = vertical total
    LDA #0:STA &FE01        ; status bar is just one character row

    LDA #6:STA &FE00        ; R6 = vertical displayed
    LDA #1:STA &FE01        ; just one row visible

    LDA #7:STA &FE00        ; R7 = vsync
    LDA #&FF:STA &FE01      ; vsync never - vertical rupture

    INC irq_part

    \\ Set screen2 character row 19 as top line of next frame

    LDA screen_buffer_next_vsync
    BPL show_screen2

    \\ Screen 1

	LDA #12:STA &FE00
	LDA #HI((screen1_address + 320)/8):STA &FE01

	LDA #13:STA &FE00
	LDA #LO((screen1_address + 320)/8):STA &FE01

    BNE also_return

    .show_screen2

    \\ Screen 2

	LDA #12:STA &FE00
	LDA #HI((screen2_address + 320)/8):STA &FE01

	LDA #13:STA &FE00
	LDA #LO((screen2_address + 320)/8):STA &FE01

    BNE irq_return

    .not_partA
    CMP #1
    BNE not_partB

    \\ Part B

	LDA #LO(TIMER_PartC):STA &FE44		; R4=T1 Low-Order Latches (write)
	LDA #HI(TIMER_PartC):STA &FE45		; R5=T1 High-Order Counter

    LDA #4:STA &FE00        ; R4 = vertical total
    LDA #17:STA &FE01       ; gameplay part is 18 rows

    LDA #6:STA &FE00        ; R6 = vertical displayed
    LDA #18:STA &FE01       ; all 18 rows are visible

    \\ Set screen2 character row 19 contains the dashboard etc.

	LDA #12:STA &FE00
	LDA #HI((screen2_address + 19*320)/8):STA &FE01

	LDA #13:STA &FE00
	LDA #LO((screen2_address + 19*320)/8):STA &FE01

    INC irq_part
    BNE irq_return

    .not_partB
    IF _DEBUG
    CMP #2
    \\ Shouldn't get here
    BNE not_partB
    ENDIF

    .part_C

    \\ Part C

    LDA #4:STA &FE00        ; R4 = vertical total
    LDA #19:STA &FE01       ; require 39 rows total, 20 left to go

    LDA #6:STA &FE00        ; R6 = vertical displayed
    LDA #6:STA &FE01        ; at row 19, with 25 total in the display

    LDA #7:STA &FE00        ; R7 = vsync
    LDA #16:STA &FE01       ; vsync at row 35

    \\ Set screen2 character row 0 as top line of next frame

	LDA #12:STA &FE00
	LDA #HI(screen2_address/8):STA &FE01

	LDA #13:STA &FE00
	LDA #LO(screen2_address/8):STA &FE01

    \\ Don't set a new timer as this is the last one

    INC irq_part

    \\ An audio test...
    TXA:PHA:TYA:PHA
    JSR irq_audio_update
    PLA:TAY:PLA:TAX

    .irq_return
    LDA &FC
    RTI

    .irq_part
    EQUB 0
}

SID_MSB_SHIFT = 3

.irq_audio_update
{
		lda ZP_09		;CF0F A5 09
		clc				;CF11 18
		adc ZP_10		;CF12 65 10
		tax				;CF14 AA
		lda ZP_0A		;CF15 A5 0A
		adc ZP_11		;CF17 65 11
		bpl L_CF1E		;CF19 10 03
		lda #$00		;CF1B A9 00
		tax				;CF1D AA
.L_CF1E	sta ZP_0A		;CF1E 85 0A

    \\ Voice 1 Frequency Control
    ; 
    ; Together, these two locations control the frequency or pitch of the
    ; musical output of voice 1.  Some frequency must be selected in order
    ; for voice 1 to be heard.  This frequency may be changed in the middle
    ; of a note to achieve special effects.  The 16-bit range of the
    ; Frequency Control Register covers over eight full octaves, and allows
    ; you to vary the pitch from 0 (very low) to about 4000 Hz (very high),
    ; in 65536 steps.  The exact frequency of the output can be determined
    ; by the equation
    ; 
    ; FREQUENCY=(REGISTER VALUE*CLOCK/16777216)Hz
    ; 
    ; where CLOCK equals the system clock frequency, 1022730 for American
    ; (NTSC) systems, 985250 for European (PAL), and REGISTER VALUE is the
    ; combined value of these frequency registers.  That combined value
    ; equals the value of the low byte plus 256 times the value of the high
    ; byte.  Using the American (NTSC) clock value, the equation works out
    ; to
    ; 
    ; FREQUENCY=REGISTER VALUE*.060959458 Hz

    \\ Voice 1 Frequency Control (high byte)

		sta SID_FREHI1		;CF20 8D 01 D4	; SID
		stx ZP_09		;CF23 86 09
		lsr A			;CF25 4A

    \\ Voice 3 Frequency Control (high byte)

		sta SID_FREHI3		;CF26 8D 0F D4	; SID
		lda ZP_09		;CF29 A5 09
		and #$FE		;CF2B 29 FE

    \\ Voice 1 Frequency Control (low byte)

		sta SID_FRELO1		;CF2D 8D 00 D4	; SID
		ror A			;CF30 6A

    \\ Voice 3 Frequency Control (low byte)

		sta SID_FRELO3		;CF31 8D 0E D4	; SID
		jsr sid_update_voice_2		;CF34 20 EF 86

    \\ Select 8 bits from Voice 1 frequency high & low bytes

        LDA SID_FRELO1
        FOR n,1,SID_MSB_SHIFT,1
        ASL A
        ROL SID_FREHI1
        NEXT

    \\ Use them to index our conversion table

        LDA SID_FREHI1
        TAX

    \\ Low and high frequency bytes for tone 1 that controls periodic noise freq

        LDA sid_to_psg_freq_table_LO, X
        ORA #$C0            ; tone 1
        JSR psg_strobe

        LDA sid_to_psg_freq_table_HI, X
        JSR psg_strobe

    \\ We can't twiddle the pulse width but we can just tickle the volume
    \\ Gives a slight reverbaration effect to give some texture to the tone

        LDA SID_PWLO1
        AND #$01
        ORA #%11110000
        JSR psg_strobe

        rts
}

.psg_strobe
{
	ldy #255
	sty $fe43
	
	sta $fe41
	lda #0
	sta $fe40
	nop
	nop
	nop
	nop
	nop
	nop
	lda #$08
	sta $fe40
    rts
}

.vsync_counter
EQUB 0

.old_irqv
EQUW 0

.beeb_set_mode_4
{
    \\ BEEB ULA SET PALETTE
    LDX #LO(beeb_mode4_palette)
    LDY #HI(beeb_mode4_palette)
    JSR beeb_set_palette

    \\ BEEB ULA SET MODE 4
    LDA #ULA_MODE_4			; 40 chars per line = 1bpp
    STA &FE20

    RTS
}

.beeb_set_mode_5
{
    \\ BEEB ULA SET MODE 5
    LDA #ULA_MODE_5			; 20 chars per line = 2bpp
    STA &FE20

    \\ BEEB ULA SET PALETTE
    LDX #LO(beeb_mode5_palette)
    LDY #HI(beeb_mode5_palette)
    JMP beeb_set_palette
}

.beeb_mode5_palette
{
	EQUB &00 + PAL_black
	EQUB &10 + PAL_black
	EQUB &20 + PAL_red
	EQUB &30 + PAL_red
	EQUB &40 + PAL_black
	EQUB &50 + PAL_black
	EQUB &60 + PAL_red
	EQUB &70 + PAL_red
	EQUB &80 + PAL_blue
	EQUB &90 + PAL_blue
	EQUB &A0 + PAL_yellow
	EQUB &B0 + PAL_yellow
	EQUB &C0 + PAL_blue
	EQUB &D0 + PAL_blue
	EQUB &E0 + PAL_yellow
	EQUB &F0 + PAL_yellow
}

.beeb_set_palette
{
	STX pal_read+1
	STY pal_read+2

	LDX #15
	.pal_read
	LDA &FFFF, X
	STA &FE21
	DEX
	BPL pal_read

	RTS
}

.beeb_mode4_palette
{
	EQUB &F0 + PAL_yellow
	EQUB &E0 + PAL_yellow
	EQUB &D0 + PAL_yellow
	EQUB &C0 + PAL_yellow
	EQUB &B0 + PAL_yellow
	EQUB &A0 + PAL_yellow
	EQUB &90 + PAL_yellow
	EQUB &80 + PAL_yellow
	EQUB &70 + PAL_black
	EQUB &60 + PAL_black
	EQUB &50 + PAL_black
	EQUB &40 + PAL_black
	EQUB &30 + PAL_black
	EQUB &20 + PAL_black
	EQUB &10 + PAL_black
	EQUB &00 + PAL_black
}

.beeb_set_mode_5_full
{
    LDX #LO(beeb_mode5_crtc_regs)
    LDY #HI(beeb_mode5_crtc_regs)
    JSR beeb_set_crtc_regs

    \\ BEEB SHADOW
    LDA &FE34
    AND #&FA          ; page in MAIN and display MAIN
    STA &FE34

    JMP beeb_set_mode_5
}

.beeb_set_crtc_regs
{
    STX load_regs+1
    STY load_regs+2

	LDX beeb_max_crtc_reg
.loop
; Always leave R8 as it is. The vsync routine sets it to an
; appropriate value.
	cpx #8:beq next_reg
	STX &FE00
.load_regs
	LDA &FFFF,X
	STA &FE01
.next_reg
	DEX
	BPL loop
	lda #3:sta beeb_max_crtc_reg
    RTS
}

; Max CRTC register index to set on the next call to
; beeb_set_crtc_regs. Reset to 3 on exit from beeb_set_crtc_regs.
.beeb_max_crtc_reg:equb 3

if _DEBUG
.brk_handler
{
lda $f4:pha
lda #BEEB_GRAPHICS_SLOT:sta $f4:sta $fe30
jmp graphics_debug_handle_brk
}
endif

.file_error_handler
{
; reset stack
ldx #$ff:txs
; switch to KERNEL bank
lda #BEEB_KERNEL_SLOT:sta $f4:sta $fe30
; flag file error
lda #$80:sta file_error_flag
; push main loop return address onto stack
LDA #HI(game_start_return_here_after_brk-1):PHA
LDA #LO(game_start_return_here_after_brk-1):PHA
; jump back into frontend to report error
jmp do_file_result_message
}

.beeb_code_end
