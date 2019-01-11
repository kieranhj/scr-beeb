; *****************************************************************************
; BEEB specific routines (not boot)
; *****************************************************************************

.beeb_code_start

TIMER_PartA = 32*64 - 2*64 + 1*64 -2    ; character row 0, scanline 1
TIMER_PartB = 8*64 -2                   ; character row 1, scanline 1
TIMER_PartC = 18*8*64 -2                  ; character row 19, scanline 1

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
    BMI in_game

    \\ Front end

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

.old_irqv
EQUW 0

.beeb_code_end
