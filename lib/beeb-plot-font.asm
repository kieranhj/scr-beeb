; beeb-plot-font
; BBC Micro plot functions
; Font data only

_UNROLL_FONT = FALSE         ; unroll 1x 2x 3x byte versions of font plot

.small_font
INCBIN "lib/small_font.bin"

SMALL_FONT_HEIGHT = 7

TABLE           = (small_font+1)    ; font data
IMAGE           = ZP_F0             ; glyph ptr

.beeb_plot_font_start

;.beeb_plot_font_prep jmp BEEB_PLOT_FONT_PREP
.beeb_plot_font_glyph jmp BEEB_PLOT_FONT_GLYPH
.beeb_plot_font_string jmp BEEB_PLOT_FONT_STRING
.beeb_plot_font_bcd jmp BEEB_PLOT_FONT_BCD

IF 0
.BEEB_PLOT_FONT_PREP
{
    LDA #LO(small_font+1)
    STA TABLE
    LDA #HI(small_font+1)
    STA TABLE+1

    LDA small_font
    STA HEIGHT

IF _UNROLL_FONT
IF _DEBUG
    CMP #SMALL_FONT_HEIGHT
    BEQ height_ok
    BRK
    .height_ok
ENDIF
ENDIF

    RTS
}
ENDIF

.BEEB_FONT_INIT
{
    LDA #LO(small_font)
    STA beeb_readptr
    LDA #HI(small_font)
    STA beeb_readptr+1

    LDY #1      ; not 0!
    LDA (beeb_readptr), Y
    TAX

.beeb_plot_reloc_img_loop
    INY

    CLC
    LDA (beeb_readptr), Y
    ADC beeb_readptr
    STA (beeb_readptr), Y

    INY
    LDA (beeb_readptr), Y
    ADC beeb_readptr+1
    STA (beeb_readptr), Y

    DEX
    BPL beeb_plot_reloc_img_loop
    RTS
}


\*-------------------------------
\*
\*  S E T   I M A G E
\*
\*  In: TABLE (2 bytes), IMAGE (image #)
\*  Out: IMAGE = image start address (2 bytes)
\*
\*-------------------------------

.setimage
{
\\ Bounds check that image# is not out of range of the table
IF _DEBUG
 LDA IMAGE
 BNE not_zero
 BRK
 .not_zero

 LDA TABLE
 CMP IMAGE
 BCS image_ok
 BRK
 .image_ok
ENDIF

 lda IMAGE
 asl A
 sec
 sbc #1

 tay
 lda TABLE,y
 sta IMAGE

 iny
 lda TABLE,y
 sta IMAGE+1

 rts
}

\\ A=glyph#
\\ Plot at beeb_writeptr on screen
\\ Preload TABLE with font address
\\ No clip, no handling of plotting across character rows

.BEEB_PLOT_FONT_GLYPH
{
    STA IMAGE
    JSR setimage        ; set IMAGE address of glyph data

    LDY #0
    LDA (IMAGE), Y
;    STA WIDTH          ; get WIDTH but don't store it

    ASL A:ASL A         ; just x4 as POP sprites stored as #MODE2 bytes for <reasons>
    STA smYMAX1+1
    STA smYMAX3+1
    
    LDA IMAGE
    CLC
    ADC #1
    STA smFont+1
    LDA IMAGE+1
    ADC #0
    STA smFont+2

    LDX #0
    LDY #0

    .row_loop
    STY beeb_yoffset+1

    .line_loop

\ Load 4 pixels of sprite data

    .smFont
    LDA &FFFF, X

    INX

\ Write to screen

    STA (beeb_writeptr), Y

\ Increment write pointer

    CLC
    TYA:ADC #8:TAY

    .smYMAX1
    CPY #0
    BCS done_line

\ Increment sprite index

    BNE line_loop

    .done_line

    .beeb_yoffset
    LDY #0
    INY
    CPY #SMALL_FONT_HEIGHT
    BNE row_loop

    CLC
    LDA beeb_writeptr
    .smYMAX3
    ADC #0
    STA beeb_writeptr
    BCC no_carry
    INC beeb_writeptr+1
    .no_carry

    RTS
}

.YLO
FOR y,0,24,1
EQUB LO(screen1_address + y * $140)
NEXT

.YHI
FOR y,0,24,1
EQUB HI(screen1_address + y * $140)
NEXT

\ X,Y = column, row on screen
\ beeb_readptr = string terminated with -1
\ A=PALETTE
.BEEB_PLOT_FONT_STRING
{
    STX beeb_writeptr
    LDA #0
    STA beeb_writeptr+1

    ; X*8
    ASL beeb_writeptr
    ROL beeb_writeptr+1
    ASL beeb_writeptr
    ROL beeb_writeptr+1
    ASL beeb_writeptr
    ROL beeb_writeptr+1

    CLC
    LDA beeb_writeptr
    ADC YLO,Y
    STA beeb_writeptr
    LDA beeb_writeptr+1
    ADC YHI,Y
    ADC ZP_12               ; $00 or $20 for display page
    STA beeb_writeptr+1

    INC beeb_writeptr       ; only as font is 7 scanlines (can't overflow)

;    JSR beeb_plot_font_prep

    .loop
    LDY #0
    LDA (beeb_readptr), Y
    BMI done_loop
    BNE not_space

    CLC
    LDA beeb_writeptr
    ADC #8
    STA beeb_writeptr
    BCC no_carry
    INC beeb_writeptr+1
    .no_carry
    BNE next_char

    .not_space

IF _DEBUG
    CMP small_font+1
    BEQ glyph_ok
    BCC glyph_ok
    BRK             ; glyph not found
    .glyph_ok
ENDIF

    JSR beeb_plot_font_glyph

    .next_char
    INC beeb_readptr
    BNE loop
    INC beeb_readptr+1
    BNE loop

    .done_loop
    INC beeb_readptr
    BNE return
    INC beeb_readptr+1
    .return
    RTS
}

.BEEB_PLOT_FONT_BCD
{
  PHA
  LSR A:LSR A:LSR A:LSR A
  CLC
  ADC #1
  JSR beeb_plot_font_glyph

  PLA
  AND #&F
  CLC
  ADC #1
  JMP beeb_plot_font_glyph
}



IF 0
SMALL_FONT_MAPCHAR
.string1
EQUB "This is a call", &FF
.string2
EQUB "TO ALL MY PAST", &FF
.string3
EQUB "RESIGNATIONS!!", &FF
.string4
EQUB "..HELLO WORLD..", &FF
ASCII_MAPCHAR

.test_font
{
  LDA #LO(string1):STA beeb_readptr
  LDA #HI(string1):STA beeb_readptr+1;
  LDX #0
  LDY #0
  LDA #PAL_BRW
  JSR beeb_plot_font_string

  LDA #LO(string2):STA beeb_readptr
  LDA #HI(string2):STA beeb_readptr+1
  LDX #10
  LDY #2
  LDA #PAL_BMW
  JSR beeb_plot_font_string

  LDA #LO(string3):STA beeb_readptr
  LDA #HI(string3):STA beeb_readptr+1
  LDX #40
  LDY #4
  LDA #PAL_RYW
  JSR beeb_plot_font_string

  LDA #LO(string4):STA beeb_readptr
  LDA #HI(string4):STA beeb_readptr+1
  LDX #15
  LDY #24
  LDA #PAL_RCW
  JSR beeb_plot_font_string
 
  RTS
}
ENDIF

.beeb_plot_font_end
