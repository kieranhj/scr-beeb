; *****************************************************************************
; BEEB specific routines (not boot)
; *****************************************************************************

beeb_writeptr   = ZP_1E             ; write ptr
beeb_readptr    = ZP_20             ; read ptr

.beeb_code_start
TIMER_PartA = 32*64 + 3*8*64 - 2*64 + 1*64 -2    ; character row 0, scanline 1
TIMER_PartA_Ingame = 32*64 + 3*8*64 - 2*64 + 11*64 -2    ; character row 1, scanline 6
TIMER_PartB = 5*64 -2                   ; character row 2, scanline 1
TIMER_PartC = (17*8+4)*64 -2                ; character row 19, scanline 1

;TIMER_PartA = 32*64 + 3*8*64 - 2*64 + 8*64 -2 ; character row 0, scanline 1
;TIMER_PartB = (17*8+2)*64 -2                   ; character row 2, scanline 1
;TIMER_PartC = (6*8)*64 -2                   ; character row 19, scanline 1

TIMER_Preview = 8*20*64 - 1*64 -2              ; character row 20, scanline 1
TIMER_Menu = 8*8*64 + 4*64 -2                  ; character row 8, scanline 1

CRTC_R8_DisplayEnableValue=%11000000
;                           ^^^^^^^^
;                           ||||||++ - 00 = non-interlaced sync mode
;                           ||||++-- - <<unused bits>>
;                           ||++---- - 00 = no display blanking delay
;                           ||         11 = disable display
;                           ++------ - 11 = disable cursor
CRTC_R8_DisplayDisableValue=CRTC_R8_DisplayEnableValue OR %00110000

CPU 1

.irq_handler
{
	LDA &FE4D
    AND #2
    BEQ irq_timer1

    \\ Otherwise vsync
    .irq_vsync
    STA &FE4D
{
    LDA game_control_state
    STA irq_mode
    BPL vsync_frontend				; taken if <$80
	; in game
    LDA #LO(TIMER_PartA_Ingame):STA &FE44		; R4=T1 Low-Order Latches (write)
    LDA #HI(TIMER_PartA_Ingame):STA &FE45		; R5=T1 High-Order Counter
    BRA back
.vsync_frontend

    LDA #LO(TIMER_PartA):STA &FE44		; R4=T1 Low-Order Latches (write)
    LDA #HI(TIMER_PartA):STA &FE45		; R5=T1 High-Order Counter

.back
}

	INC vsync_counter


    STZ irq_part

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
    BRA in_game

    .in_frontend
    CMP #&40					
    BEQ track_preview			; taken if $40

    \\ Menus

    JSR beeb_music_update

    BRA also_return

    .not_header

    \\ Front end

    .enter_frontend
    \\ Don't actually need any of this code now as set all CRTC regs directly when required
    IF 0
    LDA #4:STA &FE00        ; R4 = vertical total
    LDA #39:STA &FE01       ; 39 rows standard  <- this was causing a resync! Should be 38 but actually not needed at all

	LDA #6:STA &FE00		; R6 = vertical displayed
	LDA #25:STA &FE01		; 25 rows = 200 scanlines

    LDA #7:STA &FE00        ; R7 = vsync
    LDA #32:STA &FE01       ; vsync at row 35
    
    \\ Set screen1 visible as our front end

	LDA #12:STA &FE00
	LDA #HI(screen1_address/8):STA &FE01

	LDA #13:STA &FE00
	LDA #LO(screen1_address/8):STA &FE01
    ENDIF

    \\ Don't set a new timer, just return

    .also_return
    LDA &FC
    RTI

    .track_preview
    LDA irq_part
    BNE preview_bottom

	LDA #LO(TIMER_Preview):STA &FE44		; R4=T1 Low-Order Latches (write)
	LDA #HI(TIMER_Preview):STA &FE45		; R5=T1 High-Order Counter
    
    PHX:PHY
    JSR beeb_set_mode_5
    PLY:PLX
    INC irq_part
    BRA also_return

    .preview_bottom
    PHX:PHY
    JSR beeb_set_mode_4
    PLY:PLX
    BRA also_return

    .in_game

    \\ In Game

    LDA irq_part
    BNE not_partA

    \\ Part A

	LDA #LO(TIMER_PartB):STA &FE44		; R4=T1 Low-Order Latches (write)
	LDA #HI(TIMER_PartB):STA &FE45		; R5=T1 High-Order Counter

    LDA #4:STA &FE00        ; R4 = vertical total
    LDA #1:STA &FE01        ; status bar is two rows

    LDA #6:STA &FE00        ; R6 = vertical displayed
    LDA #2:STA &FE01        ; two rows visible

    LDA #7:STA &FE00        ; R7 = vsync
    LDA #&FF:STA &FE01      ; vsync never - vertical rupture

    INC irq_part

    \\ Set screen2 character row 19 as top line of next frame

    LDA screen_buffer_next_vsync
    BPL show_screen2

    \\ Screen 1

	LDA #12:STA &FE00
	LDA #HI((screen1_address + 640)/8):STA &FE01

	LDA #13:STA &FE00
	LDA #LO((screen1_address + 640)/8):STA &FE01

    BNE return_the_third

    .show_screen2

    \\ Screen 2

	LDA #12:STA &FE00
	LDA #HI((screen2_address + 640)/8):STA &FE01

	LDA #13:STA &FE00
	LDA #LO((screen2_address + 640)/8):STA &FE01

    .return_the_third
	;; set palette
	LDA #&80 + PAL_cyan : STA &FE21
	LDA #&90 + PAL_cyan : STA &FE21
	LDA #&C0 + PAL_cyan : STA &FE21
	LDA #&D0 + PAL_cyan : STA &FE21
    LDA &FC
    RTI

    .not_partA
    CMP #1
    BNE not_partB

    \\ Part B

	LDA #LO(TIMER_PartC):STA &FE44		; R4=T1 Low-Order Latches (write)
	LDA #HI(TIMER_PartC):STA &FE45		; R5=T1 High-Order Counter

    LDA #4:STA &FE00        ; R4 = vertical total
    LDA #16:STA &FE01       ; gameplay part is 18 rows

    LDA #6:STA &FE00        ; R6 = vertical displayed
    LDA #18:STA &FE01       ; all 18 rows are visible

    \\ Set screen2 character row 19 contains the dashboard etc.

	LDA #12:STA &FE00
	LDA #HI((screen2_address + 19*320)/8):STA &FE01

	LDA #13:STA &FE00
	LDA #LO((screen2_address + 19*320)/8):STA &FE01

    INC irq_part
    BRA irq_return

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
    LDA #16-3:STA &FE01       ; vsync at row 35-3=32

    \\ Set screen2 character row 0 as top line of next frame

	LDA #12:STA &FE00
	LDA #HI(screen2_address/8):STA &FE01

	LDA #13:STA &FE00
	LDA #LO(screen2_address/8):STA &FE01

	;; set palette
	LDA #&80 + PAL_blue : STA &FE21
	LDA #&90 + PAL_blue : STA &FE21
	LDA #&C0 + PAL_blue : STA &FE21
	LDA #&D0 + PAL_blue : STA &FE21

    \\ Don't set a new timer as this is the last one

    INC irq_part

    \\ An audio test...
    PHX:PHY
    JSR irq_audio_update
    PLY:PLX

    .irq_return
    LDA &FC
    RTI

    .irq_mode
    EQUB 0

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

    \\ Update Voice 2 for sound effects

		jsr sid_update_voice_2		;CF34 20 EF 86

    \\ BEEB - skip audio handling if paused

        LDA irq_audio_pause
        BNE return

    \\ BEEB - skip audio handling if we're exiting

        LDA game_control_state
        BPL return

    \\ BEEB AUDIO - handle engine tone generation

        LDA noise_sfx_override_engine
        BEQ handle_engine_tone

    \\ Otherwise we're handling noise

        LDA SID_FREHI2
        ASL A:ASL A         ; BEEB multiple by 4 otherwise sounds crap
        TAY

    \\ Low and high frequency bytes for tone 1 that controls periodic noise freq

        LDA sid_to_psg_freq_tone_LO, Y
        ORA #$C0            ; tone 1
        JSR sn_write

        LDA sid_to_psg_freq_tone_HI, Y
        JSR sn_write

        RTS

    .handle_engine_tone

    \\ Select 8 bits from Voice 1 frequency high & low bytes

        LDA SID_FRELO1
        FOR n,1,SID_MSB_SHIFT,1
        ASL A
        ROL SID_FREHI1
        NEXT

    \\ Use them to index our conversion table

        LDA SID_FREHI1
        TAY

    \\ Low and high frequency bytes for tone 1 that controls periodic noise freq

        LDA sid_to_psg_freq_noise_LO, Y
        ORA #$C0            ; tone 1
        JSR sn_write

        LDA sid_to_psg_freq_noise_HI, Y
        JSR sn_write

    \\ We can't twiddle the pulse width but we can just tickle the volume
    \\ Gives a slight reverbaration effect to give some texture to the tone

        LDA SID_PWLO1
        AND #$01
        ORA #%11110000
        JSR sn_write

        .return
        rts
}



;-------------------------------------------
; Sound chip routines
;-------------------------------------------



; Write data to SN76489 sound chip
; A contains data to be written to sound chip
; clobbers X, A is non-zero on exit
.sn_write
{
	tax
	bpl write					; taken if latch byte
	bit sn_attenuation_register_mask
	beq write					; taken if not attenuation register

	and #$f0					; %xrrr0000
	sta remask+1
	txa							; %xrrrvvvv
	and #$0f					; %0000vvvv
	tax
 	lda sn_volume_table,x
.remask:ora #$ff

.write
    ldx #255
    stx &fe43
    sta &fe4f
    inx
    stx &fe40
    lda &fe40
    ora #8
    sta &fe40
    rts ; 21 bytes

.sn_attenuation_register_mask:equb $10
}

.sn_volume_table:equb 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

; Reset SN76489 sound chip to a default (silent) state
.sn_reset
{
	\\ Zero volume on all channels
	lda #&9f : jsr sn_write
	lda #&bf : jsr sn_write
	lda #&df : jsr sn_write
	lda #&ff : jmp sn_write
}


.irq_audio_pause
EQUB 0

.noise_sfx_override_engine
EQUB 0

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
	EQUB &80 + PAL_cyan
	EQUB &90 + PAL_cyan
	EQUB &A0 + PAL_yellow
	EQUB &B0 + PAL_yellow
	EQUB &C0 + PAL_cyan
	EQUB &D0 + PAL_cyan
	EQUB &E0 + PAL_yellow
	EQUB &F0 + PAL_yellow
}

.beeb_mode1_palette
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
lda #BEEB_CART_SLOT:sta $f4:sta $fe30
jmp debug_handle_brk
}
endif

.file_error_handler
{
; reset stack
ldx #$ff:txs
; switch to KERNEL bank
lda #BEEB_KERNEL_SLOT:sta $f4:sta $fe30
; restore SCR HAZEL
jsr hazel_scr
; flag file error
lda #$80:sta file_error_flag
; push main loop return address onto stack
LDA #HI(game_start_return_here_after_brk-1):PHA
LDA #LO(game_start_return_here_after_brk-1):PHA
; copy error string
ldx #0
ldy #1
.loop
lda ($fd),y
STA file_error_string,X
BEQ done
iny
INX
CPX #40
BCC loop
.done
; jump back into frontend to report error
jmp do_file_result_message
}

.file_error_string
SKIP 40

.beeb_music_playing
EQUB 0

.beeb_music_state
EQUB 1

.beeb_music_debounce
EQUB 0

.beeb_music_play
{
    LDA beeb_music_state
    STA beeb_music_playing
    RTS
}

.beeb_music_stop
{
    LDA #0
    STA beeb_music_playing
    JMP sn_reset
}

.beeb_music_toggle
{
	ldx #KEY_MENU_MUSIC
	jsr poll_key_with_sysctl
    beq pressing_m
    
    \\ Not pressing M
    LDA #0
    STA beeb_music_debounce
    .return
    RTS

    .pressing_m
    LDA beeb_music_debounce
    BNE return

    LDA #1
    STA beeb_music_debounce

    \\ Toggle music state
    LDA beeb_music_state
    EOR #1
    STA beeb_music_state    
    BEQ beeb_music_stop

    JMP beeb_music_play
}

.beeb_music_update
{
    LDA beeb_music_playing
    BEQ not_playing

    lda $f4:pha
    lda #BEEB_MUSIC_SLOT:sta $f4:sta $fe30
    TXA:PHA:TYA:PHA
    JSR vgm_update
    PLA:TAY:PLA:TAX
    pla:sta $f4:sta $fe30

    .not_playing
    rts
}

.decoder_start


;-------------------------------
; lz4 decoder
;-------------------------------



; fetch a byte from the current decode buffer at the current read ptr offset
; returns byte in A, clobbers Y
.lz_fetch_buffer
{
    lda &ffff           ; *** SELF MODIFIED ***
    inc lz_fetch_buffer+1
    rts
}

; push byte into decode buffer
; clobbers Y, preserves A
.lz_store_buffer    ; called twice - 4 byte overhead, 6 byte function. Cheaper to inline.
{
    sta &ffff   ; *** SELF MODIFIED ***
    inc lz_store_buffer+1
    rts                 ; [6] (1)
}

; provide these vars as cleaner addresses for the code address to be self modified
lz_window_src = lz_fetch_buffer + 1 ; window read ptr LO (2 bytes) - index, 3 references
lz_window_dst = lz_store_buffer + 1 ; window write ptr LO (2 bytes) - index, 3 references



; Calculate a multi-byte lz4 style length into zp_temp
; On entry A contains the initial counter value (LO)
; Returns 16-bit length in A/X (A=LO, X=HI)
; Clobbers Y, zp_temp+0, zp_temp+1
.lz_fetch_count

    ldx #0
    cmp #15             ; >=15 signals byte extend
    bne lz_fetch_count_done
    sta zp_temp+0
    stx zp_temp+1

.fetch
.fetchByte1

    jsr lz_fetch_byte
    tay
    clc
    adc zp_temp+0
    sta zp_temp+0

    lda zp_temp+1   ; [3zp 4abs](2)
    adc #0          ; [2](2)
    sta zp_temp+1   ; [3zp 4abs](2)

    cpy #255            ; 255 signals byte extend       
    beq fetch
    tax
    lda zp_temp+0

.lz_fetch_count_done

    ; A/X now contain count (LO/HI)
    rts





; decode a byte from the currently selected register stream
; unlike typical lz style unpackers we are using a state machine
; because it is necessary for us to be able to decode a byte at a time from 8 separate streams
.lz_decode_byte

    ; decoder state is:
    ;  empty - fetch new token & prepare
    ;  literal - decode new literal
    ;  match - decode new match

    ; lz4 block format:
    ;  [TOKEN][LITERAL LENGTH][LITERALS][...][MATCH OFFSET][MATCH LENGTH]

; try fetching a literal byte from the stream
.try_literal

    lda zp_literal_cnt+0        ; [3 zp][4 abs]
    bne is_literal              ; [2, +1, +2]
    lda zp_literal_cnt+1        ; [3 zp][4 abs]
    beq try_match               ; [2, +1, +2]

.is_literal
.fetchByte2

    ; fetch a literal & stash in decode buffer
    jsr lz_fetch_byte           ; [6] +6 RTS
    jsr lz_store_buffer         ; [6] +6 RTS
    sta stashA+1   ; **SELF MODIFICATION**

    ; for all literals
    dec zp_literal_cnt+0        ; [5 zp][6 abs]
    bne end_literal             ; [2, +1, +2]
    lda zp_literal_cnt+1        ; [3 zp][4 abs]
    beq begin_matches           ; [2, +1, +2]
    dec zp_literal_cnt+1        ; [5 zp][6 abs]
    bne end_literal

.begin_matches

    ; literals run completed
    ; now fetch match offset & length

.fetchByte3

    ; get match offset LO
    jsr lz_fetch_byte     

    ; set buffer read ptr
    ;sta zp_temp
    sta stashS+1 ; **SELF MODIFICATION**
    lda lz_window_dst + 0 ; *** SELF MODIFYING CODE ***
    sec
.stashS
    sbc #0 ; **SELFMODIFIED**
    ;sbc zp_temp
    sta lz_window_src + 0 ; *** SELF MODIFYING CODE ***

IF LZ4_FORMAT
    ; fetch match offset HI, but ignore it.
    ; this implementation only supports 8-bit windows.
.fetchByte4
    jsr lz_fetch_byte    
ENDIF

    ; fetch match length
    lda zp_match_cnt+0
    jsr lz_fetch_count
    ; match length is always+4 (0=4)
    ; cant do this before because we need to detect 15

    clc                  ; [2] (1)
    adc #4               ; [2] (2)
    sta zp_match_cnt+0   ; [3 zp, 4 abs] (2)
    bcc store_hi         ; [2, +1, +2]    (2)
    inx                  ; [2] (1)
    ;inc zp_match_cnt+1  ; [5 zp, 6 abs]  (2)
.store_hi
    stx zp_match_cnt+1   ; [3 zp, 4 abs](2)

.end_literal
.stashA
    lda #0 ;**SELFMODIFIED - See above**
    rts


; try fetching a matched byte from the stream
.try_match

    lda zp_match_cnt+1
    bne is_match
    lda zp_match_cnt+0
    ; all matches done, so get a new token.
    beq try_token

.is_match

    jsr lz_fetch_buffer    ; fetch matched byte from decode buffer
    jsr lz_store_buffer    ; stash in decode buffer
    sta stashAA+1 ; **SELF MODIFICATION**

    ; for all matches
    ; we know match cnt is at least 1
    lda zp_match_cnt+0
    bne skiphi
    dec zp_match_cnt+1
.skiphi
    dec zp_match_cnt+0

.end_match
.stashAA
    lda #0 ; **SELF MODIFIED - See above **
    rts


; then token parser
.try_token
.fetchByte5
    ; fetch a token
    jsr lz_fetch_byte     

    tax
    ldy #0

    ; unpack match length from token (bottom 4 bits)
    and #&0f
    sta zp_match_cnt+0
    sty zp_match_cnt+1

    ; unpack literal length from token (top 4 bits)
    txa
    lsr a
    lsr a
    lsr a
    lsr a

    ; fetch literal extended length, passing in A
    jsr lz_fetch_count
    sta zp_literal_cnt+0
    stx zp_literal_cnt+1

    ; if no literals, begin the match sequence
    ; and fetch one match byte
    cmp #0
    bne has_literals

    jsr begin_matches
    jmp try_match

.has_literals
    ; ok now go back to literal parser so we can return a byte
    ; if no literals, logic will fall through to matches
    jmp try_literal






.decoder_end

.beeb_code_end
