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

    LDA &FC
    RTI

    .irq_timer1
    LDA #&40
    STA &FE4D

    LDA irq_mode
    BEQ enter_frontend

    BPL in_frontend
    JMP in_game

    .in_frontend
    CMP #&40
    BEQ track_preview

    \\ Menus

    LDA irq_part
    BNE menu_options

    \\ Header
    LDA irq_part
    BNE menu_options

	LDA #LO(TIMER_Menu):STA &FE44		; R4=T1 Low-Order Latches (write)
	LDA #HI(TIMER_Menu):STA &FE45		; R5=T1 High-Order Counter
    
    TXA:PHA:TYA:PHA
    JSR beeb_set_mode_5
    PLA:TAY:PLA:TAX
    INC irq_part
    JMP also_return

    .menu_options
    TXA:PHA:TYA:PHA
    JSR beeb_set_mode_4
    PLA:TAY:PLA:TAX
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

    .irq_return
    LDA &FC
    RTI

    .irq_part
    EQUB 0
}

.vsync_counter
EQUB 0

.prev_vsync
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
	EQUB &F0 + PAL_white
	EQUB &E0 + PAL_white
	EQUB &D0 + PAL_white
	EQUB &C0 + PAL_white
	EQUB &B0 + PAL_white
	EQUB &A0 + PAL_white
	EQUB &90 + PAL_white
	EQUB &80 + PAL_white
	EQUB &70 + PAL_black
	EQUB &60 + PAL_black
	EQUB &50 + PAL_black
	EQUB &40 + PAL_black
	EQUB &30 + PAL_black
	EQUB &20 + PAL_black
	EQUB &10 + PAL_black
	EQUB &00 + PAL_black
}

IF _DEBUG
.beeb_debug_framerate
{
    LDA #0
    STA beeb_writeptr
    CLC
    LDA ZP_12
    ADC #HI(screen1_address)
    STA beeb_writeptr+1

    SEC
    LDA vsync_counter
    TAX
    SBC prev_vsync
    CMP #10
    BCC ok

    LDA #9
    .ok
    STX prev_vsync

    CLC
    ADC #1  ; glyph 1 = '0'
    JSR beeb_plot_font_glyph

    RTS
}
ENDIF

.beeb_code_end
