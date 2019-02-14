; *****************************************************************************
; STUNT CAR RACER
; *****************************************************************************

; *****************************************************************************
; BEEB OS DEFINES
; *****************************************************************************

INCLUDE "lib/bbc.h.asm"

; *****************************************************************************
; GLOBAL DEFINES
; *****************************************************************************

bootstrap_address = $3f00
disksys_loadto_addr = $4300     ; SCR only (TEMP)

MAX_LOADABLE_ROM_SIZE = $8000 - disksys_loadto_addr

_TODO = FALSE
_NOT_BEEB = FALSE
_DEBUG = TRUE

DEFAULT_TRACK_DRAW_DISTANCE = $02		; $06 for longer draw

BEEB_SCREEN_MODE = 4
BEEB_KERNEL_SLOT = 4
BEEB_CART_SLOT = 5
BEEB_GRAPHICS_SLOT = 6

BEEB_PIXELS_COLOUR1 = &0F	; C64=$55
BEEB_PIXELS_COLOUR2 = &F0	; C64=$AA
BEEB_PIXELS_COLOUR3 = &FF	; C64=$FF

; C64 controls
; Left/Right = S/D
; Boost = Return
; Brake = '='
; Reverse = Space
; Pause = P
; Resume = O
; Redefine Keys whilst paused = F1
; Quit = 'Commodore'

KEY_DEF_FIRE = IKN_return				; Return
KEY_DEF_LEFT = IKN_s					; S
KEY_DEF_RIGHT = IKN_d					; D
KEY_DEF_BACK = IKN_space				; Space
KEY_DEF_BRAKE = IKN_colon				; =

KEY_DEF_PAUSE = IKN_p			;$0D	; P
KEY_DEF_REDEFINE = IKN_f1		;$20	; F1
KEY_DEF_QUIT = IKN_esc			;$2F	; Commodore
KEY_DEF_CONTINUE = IKN_o		;$34	; O
KEY_DEF_CANCEL = IKN_esc		;$3F	; run stop?

KEY_MENU_OPTION_1 = IKN_1
KEY_MENU_OPTION_2 = IKN_2
KEY_MENU_OPTION_3 = IKN_3
KEY_MENU_OPTION_4 = IKN_4

KEY_RETURN = IKN_return
KEY_RIGHT_SHIFT = IKN_shift		;$26	; right shift
KEY_LEFT_SHIFT = IKN_shift		;$39	; left shift

; *****************************************************************************
; MACROS
; *****************************************************************************

MACRO PAGE_ALIGN
    PRINT "  ALIGN LOST ", ~LO(((P% AND &FF) EOR &FF)+1), " BYTES"
    ALIGN &100
ENDMACRO

MACRO SWR_SELECT_SLOT bank
{
	LDA #bank:STA &F4:STA &FE30
}
ENDMACRO

; *****************************************************************************
; C64 KERNEL DEFINES
; *****************************************************************************

KERNEL_RAM_VECTORS = $FD30

KERNEL_READST	= $FFB7	; Read the I/O Status Word
KERNEL_SETLFS	= $FFBA	; Set Logical File Number, Device Number, and Secondary Address
KERNEL_SETNAM	= $FFBD	; Set Filename Parameters
KERNEL_OPEN 	= $FFC0	; Open a Logical I/O File
KERNEL_CLOSE	= $FFC3	; Close a Logical I/O File
;KERNEL_LOAD	= $FFD5	; Load RAM from a device
;KERNEL_SAVE	= $FFD8	; Save RAM to a device
KERNEL_GETIN	= $FFE4	; Get One Byte from the Input Device

BEEB_VIC_BASE	= $300	; $D000
BEEB_SID_BASE	= $330	; $D400
; BEEB_COLOR_BASE = $D800	
BEEB_CIA1_BASE	= $350	; $DC00
BEEB_CIA2_BASE	= $360	; $DD00

; Not sure what this is used for - depends on which C64 bank is paged in?
L_A000 = $370	;$A000		; Cold Start Vector?

; NOTE! space from $03A0 to $03D0 is used to store ZP vars during FS operations

VIC_SP0X 	= BEEB_VIC_BASE + $00	; Sprite 0 Horizontal Position
VIC_SP0Y	= BEEB_VIC_BASE + $01 	; Sprite 0 Vertical Position
VIC_SP1X	= BEEB_VIC_BASE + $02 	; Sprite 1 Horizontal Position
VIC_SP1Y	= BEEB_VIC_BASE + $03 	; Sprite 1 Vertical Position
VIC_SP2X	= BEEB_VIC_BASE + $04	; Sprite 2 Horizontal Position
VIC_SP2Y	= BEEB_VIC_BASE + $05	; Sprite 2 Vertical Position
VIC_SP3X	= BEEB_VIC_BASE + $06	; Sprite 3 Horizontal Position
VIC_SP3Y	= BEEB_VIC_BASE + $07	; Sprite 3 Vertical Position
VIC_SP4X	= BEEB_VIC_BASE + $08	; Sprite 4 Horizontal Position
VIC_SP4Y	= BEEB_VIC_BASE + $09	; Sprite 4 Vertical Position
VIC_SP5X	= BEEB_VIC_BASE + $0A	; Sprite 5 Horizontal Position
VIC_SP5Y	= BEEB_VIC_BASE + $0B	; Sprite 5 Vertical Position
VIC_SP6X	= BEEB_VIC_BASE + $0C	; Sprite 6 Horizontal Position
VIC_SP6Y	= BEEB_VIC_BASE + $0D	; Sprite 6 Vertical Position
VIC_SP7X	= BEEB_VIC_BASE + $0E	; Sprite 7 Horizontal Position
VIC_SP7Y	= BEEB_VIC_BASE + $0F	; Sprite 7 Vertical Position
VIC_MSIGX	= BEEB_VIC_BASE + $10 	; Most Significant Bits of Sprites 0-7 Horizontal Position

VIC_SCROLY	= BEEB_VIC_BASE + $11	; Vertical Fine Scrolling and Control Register
VIC_RASTER	= BEEB_VIC_BASE + $12	; Read Current Raster Scan Line/Write Line to Compare for Raster IRQ
VIC_SPENA	= BEEB_VIC_BASE + $15	; Sprite Enable Register
VIC_SCROLX	= BEEB_VIC_BASE + $16	; Horizontal Fine Scrolling and Control Register
VIC_YXPAND	= BEEB_VIC_BASE + $17	; Sprite Vertical Expansion Register
VIC_VMCSB	= BEEB_VIC_BASE + $18	; VIC-II Chip Memory Control Register
VIC_VICIRQ	= BEEB_VIC_BASE + $19	; VIC Interrupt Flag Register
VIC_IRQMASK	= BEEB_VIC_BASE + $1A	; IRQ Mask Register
VIC_SPBGPR	= BEEB_VIC_BASE + $1B	; Sprite to Foreground Display Priority Register
VIC_SPMC	= BEEB_VIC_BASE + $1C	; Sprite Multicolor Registers
VIC_XXPAND	= BEEB_VIC_BASE + $1D	; Sprite Horizontal Expansion Register
VIC_SPSPCL	= BEEB_VIC_BASE + $1E	; Sprite to Sprite Collision Register
VIC_SPBGCL	= BEEB_VIC_BASE + $1F	; Sprite to Foreground Collision Register

VIC_EXTCOL	= BEEB_VIC_BASE + $20	; Border Color Register
VIC_BGCOL0	= BEEB_VIC_BASE + $21	; Background Color 0
VIC_BGCOL1	= BEEB_VIC_BASE + $22	; Background Color 1
VIC_BGCOL2	= BEEB_VIC_BASE + $23	; Background Color 2
VIC_BGCOL3	= BEEB_VIC_BASE + $24	; Background Color 3
VIC_SPMC0	= BEEB_VIC_BASE + $25	; Sprite Multicolor Register 0
VIC_SPMC1	= BEEB_VIC_BASE + $26	; Sprite Multicolor Register 1
VIC_SP0COL	= BEEB_VIC_BASE + $27	; Sprite 0 Color Register (the default color value is 1, white)
VIC_SP1COL	= BEEB_VIC_BASE + $28	; Sprite 1 Color Register (the default color value is 2, red)
VIC_SP2COL	= BEEB_VIC_BASE + $29	; Sprite 2 Color Register (the default color value is 3, cyan)
VIC_SP3COL	= BEEB_VIC_BASE + $2A	; Sprite 3 Color Register (the default color value is 4, purple)
VIC_SP4COL	= BEEB_VIC_BASE + $2B	; Sprite 4 Color Register (the default color value is 5, green)
VIC_SP5COL	= BEEB_VIC_BASE + $2C	; Sprite 5 Color Register (the default color value is 6, blue)
VIC_SP6COL	= BEEB_VIC_BASE + $2D	; Sprite 6 Color Register (the default color value is 7, yellow)
VIC_SP7COL	= BEEB_VIC_BASE + $2E	; Sprite 7 Color Register (the default color value is 12, medium gray)

SID_FRELO1	= BEEB_SID_BASE + $00	; Voice 1 Frequency Control (low byte)
SID_FREHI1	= BEEB_SID_BASE + $01	; Voice 1 Frequency Control (high byte)
SID_PWLO1	= BEEB_SID_BASE + $02	; Voice 1 Pulse Waveform Width (low byte)
SID_PWHI1	= BEEB_SID_BASE + $03	; Voice 1 Pulse Waveform Width (high nybble)
SID_VCREG1	= BEEB_SID_BASE + $04	; Voice 1 Control Register
SID_ATDCY1	= BEEB_SID_BASE + $05	; Voice 1 Attack/Decay Register
SID_SUREL1	= BEEB_SID_BASE + $06	; Voice 1 Sustain/Release Control Register

SID_FRELO2	= BEEB_SID_BASE + $07	; Voice 2 Frequency Control (low byte)
SID_FREHI2	= BEEB_SID_BASE + $08	; Voice 2 Frequency Control (high byte)
SID_PWLO2	= BEEB_SID_BASE + $09	; Voice 2 Pulse Waveform Width (low byte)
SID_PWHI2	= BEEB_SID_BASE + $0A	; Voice 2 Pulse Waveform Width (high nybble)
SID_VCREG2	= BEEB_SID_BASE + $0B	; Voice 2 Control Register
SID_ATDCY2	= BEEB_SID_BASE + $0C	; Voice 2 Attack/Decay Register
SID_SUREL2	= BEEB_SID_BASE + $0D	; Voice 2 Sustain/Release Control Register

SID_FRELO3	= BEEB_SID_BASE + $0E	; Voice 3 Frequency Control (low byte)
SID_FREHI3	= BEEB_SID_BASE + $0F	; Voice 3 Frequency Control (high byte)
SID_PWLO3	= BEEB_SID_BASE + $10	; Voice 3 Pulse Waveform Width (low byte)
SID_PWHI3	= BEEB_SID_BASE + $11	; Voice 3 Pulse Waveform Width (high nybble)
SID_VCREG3	= BEEB_SID_BASE + $12	; Voice 3 Control Register
SID_ATDCY3	= BEEB_SID_BASE + $13	; Voice 3 Attack/Decay Register
SID_SUREL3	= BEEB_SID_BASE + $14	; Voice 3 Sustain/Release Control Register

SID_CUTLO	= BEEB_SID_BASE + $15	; Bits 0-2:  Low portion of filter cutoff frequency
SID_CUTHI	= BEEB_SID_BASE + $16	; Filter Cutoff Frequency (high byte)
SID_RESON	= BEEB_SID_BASE + $17	; Filter Resonance Control Register
SID_SIGVOL	= BEEB_SID_BASE + $18	; Volume and Filter Select Register

CIA1_CIAPRA	= BEEB_CIA1_BASE + $00	; Data Port Register A
CIA1_CIAPRB	= BEEB_CIA1_BASE + $01	; Data Port Register B
CIA1_CIDDRA	= BEEB_CIA1_BASE + $02	; Data Direction Register A
CIA1_CIDDRB	= BEEB_CIA1_BASE + $03	; Data Direction Register B
CIA1_TIMALO	= BEEB_CIA1_BASE + $04	; Timer A (low byte)
CIA1_TIMAHI	= BEEB_CIA1_BASE + $05	; Timer A (high byte)
CIA1_TIMBLO	= BEEB_CIA1_BASE + $06	; Timer B (low byte)
CIA1_TIMBHI	= BEEB_CIA1_BASE + $07	; Timer B (high byte)
CIA1_CIAICR	= BEEB_CIA1_BASE + $0D	; Interrupt Control Register
CIA1_CIACRA	= BEEB_CIA1_BASE + $0E	; Control Register A
CIA1_CIACRB	= BEEB_CIA1_BASE + $0F	; Control Register B

CIA2_CI2PRA = BEEB_CIA2_BASE + $00
CIA2_C2DDRA = BEEB_CIA2_BASE + $02
CIA2_CIAICR	= BEEB_CIA2_BASE + $0D	; Interrupt Control Register

C64_NO_IO_NO_KERNAL = $34
C64_IO_NO_KERNAL = $35
C64_IO_AND_KERNAL = $36

C64_VIC_BITMAP_SCREEN1 = $70
C64_VIC_BITMAP_SCREEN2 = $78

C64_VIC_IRQ_DISABLE = $00
C64_VIC_IRQ_RASTERCMP = $01

; *****************************************************************************
; VARIABLES
; *****************************************************************************

BEEB_ZP_OFFSET = &800
BEEB_ZP_REMAP = $E0 - $50		; remap $E0 onwards to $40 onwards

DATA_6510	= $00	; 6510 On-Chip I/O DATA Direction Register
RAM_SELECT	= $01	; 6510 RAM Selection Register
ZP_02	= $02
ZP_03	= $03
ZP_04	= $04
ZP_05	= $05
ZP_06	= $06
ZP_07	= $07
ZP_08	= $08
ZP_09	= $09
ZP_0A	= $0A
ZP_0B	= $0B
ZP_0C	= $0C
ZP_0D	= $0D
ZP_0E	= $0E
ZP_0F	= $0F
ZP_10	= $10
ZP_11	= $11
ZP_12	= $12			; display buffer page
ZP_13	= $13
ZP_14	= $14
ZP_15	= $15
ZP_16	= $16
ZP_17	= $17
ZP_18	= $18
ZP_19	= $19
ZP_1A	= $1A
ZP_1B	= $1B
ZP_1C	= $1C
ZP_1D	= $1D
ZP_1E	= $1E		; used as generic read_ptr
ZP_1F	= $1F
ZP_20	= $20		; used as ptr in cart-ram.asm
ZP_21	= $21
ZP_22	= $22
ZP_23	= $23
ZP_24	= $24
ZP_25	= $25
ZP_27	= $27
ZP_28	= $28
ZP_29	= $29
ZP_2A	= $2A
ZP_2B	= $2B
ZP_2C	= $2C
ZP_2D	= $2D
ZP_2E	= $2E
ZP_2F	= $2F		; some sort of timer for crane
ZP_30	= $30
ZP_31	= $31
ZP_32	= $32
ZP_33	= $33
ZP_34	= $34
ZP_35	= $35
ZP_36	= $36
ZP_37	= $37
ZP_38	= $38
ZP_39	= $39
ZP_3A	= $3A
ZP_3B	= $3B
ZP_3C	= $3C
ZP_3D	= $3D
ZP_3E	= $3E
ZP_3F	= $3F
ZP_40	= $40
ZP_41	= $41
ZP_43	= $43
ZP_44	= $44
ZP_45	= $45
ZP_46	= $46
ZP_48	= $48
ZP_49	= $49
ZP_4A	= $4A
ZP_4B	= $4B
ZP_4C	= $4C
ZP_4D	= $4D
ZP_4E	= $4E
ZP_4F	= $4F
ZP_50	= $50
ZP_51	= $51
ZP_52	= $52
ZP_53	= $53
ZP_54	= $54
ZP_55	= $55
ZP_56	= $56
ZP_57	= $57
ZP_58	= $58
ZP_59	= $59
ZP_5A	= $5A
ZP_5B	= $5B
ZP_5C	= $5C + BEEB_ZP_OFFSET
ZP_5D	= $5D + BEEB_ZP_OFFSET
ZP_5E	= $5E + BEEB_ZP_OFFSET
ZP_5F	= $5F + BEEB_ZP_OFFSET
ZP_60	= $60 + BEEB_ZP_OFFSET
ZP_61	= $61 + BEEB_ZP_OFFSET
ZP_62	= $62 + BEEB_ZP_OFFSET
ZP_63	= $63 + BEEB_ZP_OFFSET
ZP_64	= $64 + BEEB_ZP_OFFSET
ZP_66	= $66 + BEEB_ZP_OFFSET
ZP_68	= $68 + BEEB_ZP_OFFSET
ZP_69	= $69 + BEEB_ZP_OFFSET
ZP_6A	= $6A + BEEB_ZP_OFFSET
ZP_6B	= $6B + BEEB_ZP_OFFSET		; 0=on track,$80=off track (sometimes $C0)
ZP_6C	= $6C + BEEB_ZP_OFFSET		; end of game timer (either too much damage or lost to opponent)
ZP_6D	= $6D + BEEB_ZP_OFFSET
ZP_6E	= $6E + BEEB_ZP_OFFSET
ZP_6F	= $6F + BEEB_ZP_OFFSET	; dashboard_sprites_enabled
ZP_70	= $70
ZP_71	= $71
ZP_72	= $72
ZP_73	= $73
ZP_74	= $74
ZP_75	= $75
ZP_76	= $76
ZP_77	= $77
ZP_78	= $78
ZP_79	= $79
ZP_7A	= $7A
ZP_7B	= $7B
ZP_7C	= $7C
ZP_7D	= $7D
ZP_7E	= $7E
ZP_7F	= $7F
ZP_80	= $80
ZP_81	= $81
ZP_82	= $82
ZP_83	= $83
ZP_86	= $86
ZP_89	= $89
ZP_8A	= $8A
ZP_8B	= $8B
ZP_8C	= $8C
ZP_8D	= $8D
ZP_8E	= $8E
ZP_8F	= $8F
ZP_90	= $90
ZP_91	= $91
ZP_92	= $92
ZP_93	= $93
ZP_94	= $94
ZP_95	= $95
; $96
ZP_97	= $97
ZP_98	= $98			; used as ptr for track stuff
ZP_99	= $99
ZP_9A	= $9A			; used as ptr for track stuff
ZP_9B	= $9B
ZP_9C	= $9C
ZP_9D	= $9D
ZP_9E	= $9E
ZP_9F	= $9F
ZP_A0	= $A0
ZP_A1	= $A1
ZP_A2	= $A2
ZP_A3	= $A3
ZP_A4	= $A4
ZP_A5	= $A5
ZP_A6	= $A6
ZP_A7	= $A7
ZP_A8	= $A8
ZP_A9	= $A9
ZP_AA	= $AA
ZP_AB	= $AB
ZP_AC	= $AC
ZP_AD	= $AD
ZP_AF	= $AF
ZP_B0	= $B0
ZP_B1	= $B1
ZP_B2	= $B2
ZP_B3	= $B3
ZP_B4	= $B4
ZP_B5	= $B5
ZP_B6	= $B6
ZP_B7	= $B7
ZP_B8	= $B8
ZP_B9	= $B9
ZP_BA	= $BA
ZP_BB	= $BB
ZP_BC	= $BC
ZP_BD	= $BD
ZP_BE	= $BE
ZP_BF	= $BF
ZP_C0	= $C0
ZP_C1	= $C1
ZP_C2	= $C2
ZP_C3	= $C3
ZP_C4	= $C4
ZP_C5	= $C5
ZP_C6	= $C6
ZP_C7	= $C7
ZP_C8	= $C8
ZP_C9	= $C9
ZP_CA	= $CA			; frequently used as ptr
ZP_CB	= $CB
ZP_CC	= $CC
ZP_CD	= $CD
ZP_CE	= $CE
ZP_CF	= $CF
ZP_D0	= $D0
ZP_D1	= $D1
ZP_D2	= $D2
ZP_D3	= $D3
ZP_D4	= $D4
ZP_D5	= $D5
ZP_D6	= $D6
ZP_D7	= $D7
ZP_D8	= $D8
ZP_D9	= $D9
ZP_DA	= $DA
ZP_DB	= $DB
ZP_DC	= $DC
ZP_DD	= $DD
ZP_DE	= $DE
ZP_DF	= $DF
ZP_E0	= $E0 + BEEB_ZP_OFFSET
ZP_E1	= $E1 + BEEB_ZP_OFFSET
ZP_E3	= $E3 + BEEB_ZP_OFFSET
ZP_E4	= $E4 + BEEB_ZP_OFFSET
ZP_E7	= $E7 + BEEB_ZP_OFFSET
ZP_E8	= $E8 + BEEB_ZP_OFFSET
ZP_E9	= $E9 + BEEB_ZP_OFFSET
ZP_EA	= $EA + BEEB_ZP_OFFSET
ZP_EB	= $EB + BEEB_ZP_OFFSET
ZP_EC	= $EC - BEEB_ZP_REMAP
ZP_ED	= $ED - BEEB_ZP_REMAP
ZP_EE	= $EE - BEEB_ZP_REMAP
ZP_EF	= $EF - BEEB_ZP_REMAP
ZP_F0	= $F0 - BEEB_ZP_REMAP			; frequently used as ptr
ZP_F1	= $F1 - BEEB_ZP_REMAP
ZP_F2	= $F2 - BEEB_ZP_REMAP
ZP_F4	= $F4 - BEEB_ZP_REMAP			; frequently used as ptr
ZP_F5	= $F5 - BEEB_ZP_REMAP
ZP_F6	= $F6 - BEEB_ZP_REMAP			; frequently used as ptr
ZP_F7	= $F7 - BEEB_ZP_REMAP
ZP_F8	= $F8 - BEEB_ZP_REMAP			; frequently used as ptr
ZP_F9	= $F9 - BEEB_ZP_REMAP
ZP_FA	= $FA - BEEB_ZP_REMAP
ZP_FB	= $FB - BEEB_ZP_REMAP
ZP_FC	= $FC - BEEB_ZP_REMAP
ZP_FD	= $FD - BEEB_ZP_REMAP
ZP_FE	= $FE - BEEB_ZP_REMAP

; *****************************************************************************
; VARIABLES IN LOWER RAM
; *****************************************************************************

BEEB_LOWER_OFFSET = $800

L_0100	= $0100 + BEEB_LOWER_OFFSET
L_0101	= $0101 + BEEB_LOWER_OFFSET
L_0102	= $0102 + BEEB_LOWER_OFFSET
L_0103	= $0103 + BEEB_LOWER_OFFSET
L_0104	= $0104 + BEEB_LOWER_OFFSET
L_0105	= $0105 + BEEB_LOWER_OFFSET
L_0106	= $0106 + BEEB_LOWER_OFFSET
L_0107	= $0107 + BEEB_LOWER_OFFSET
L_0108	= $0108 + BEEB_LOWER_OFFSET
L_0109	= $0109 + BEEB_LOWER_OFFSET
L_010A	= $010A + BEEB_LOWER_OFFSET
L_010B	= $010B + BEEB_LOWER_OFFSET
L_010C	= $010C + BEEB_LOWER_OFFSET
L_010D	= $010D + BEEB_LOWER_OFFSET
L_010E	= $010E + BEEB_LOWER_OFFSET
L_010F	= $010F + BEEB_LOWER_OFFSET
L_0110	= $0110 + BEEB_LOWER_OFFSET
L_0111	= $0111 + BEEB_LOWER_OFFSET
L_0112	= $0112 + BEEB_LOWER_OFFSET
L_0113	= $0113 + BEEB_LOWER_OFFSET
L_0114	= $0114 + BEEB_LOWER_OFFSET
L_0115	= $0115 + BEEB_LOWER_OFFSET
L_0118	= $0118 + BEEB_LOWER_OFFSET
L_0119	= $0119 + BEEB_LOWER_OFFSET
L_011A	= $011A + BEEB_LOWER_OFFSET
L_011B	= $011B + BEEB_LOWER_OFFSET
L_011E	= $011E + BEEB_LOWER_OFFSET
L_011F	= $011F + BEEB_LOWER_OFFSET
L_0120	= $0120 + BEEB_LOWER_OFFSET
L_0121	= $0121 + BEEB_LOWER_OFFSET
L_0122	= $0122 + BEEB_LOWER_OFFSET
L_0123	= $0123 + BEEB_LOWER_OFFSET
L_0124	= $0124 + BEEB_LOWER_OFFSET
L_0125	= $0125 + BEEB_LOWER_OFFSET
L_0126	= $0126 + BEEB_LOWER_OFFSET
L_0130	= $0130 + BEEB_LOWER_OFFSET
L_0131	= $0131 + BEEB_LOWER_OFFSET
L_0132	= $0132 + BEEB_LOWER_OFFSET
L_0133	= $0133 + BEEB_LOWER_OFFSET
L_0134	= $0134 + BEEB_LOWER_OFFSET
L_0135	= $0135 + BEEB_LOWER_OFFSET
L_0136	= $0136 + BEEB_LOWER_OFFSET
L_0137	= $0137 + BEEB_LOWER_OFFSET
L_0138	= $0138 + BEEB_LOWER_OFFSET
L_0139	= $0139 + BEEB_LOWER_OFFSET
L_013A	= $013A + BEEB_LOWER_OFFSET
L_013B	= $013B + BEEB_LOWER_OFFSET
L_013C	= $013C + BEEB_LOWER_OFFSET
L_013D	= $013D + BEEB_LOWER_OFFSET
L_013E	= $013E + BEEB_LOWER_OFFSET
L_013F	= $013F + BEEB_LOWER_OFFSET
L_0140	= $0140 + BEEB_LOWER_OFFSET
L_0141	= $0141 + BEEB_LOWER_OFFSET
L_0142	= $0142 + BEEB_LOWER_OFFSET
L_0145	= $0145 + BEEB_LOWER_OFFSET
L_0148	= $0148 + BEEB_LOWER_OFFSET
L_0149	= $0149 + BEEB_LOWER_OFFSET
L_014A	= $014A + BEEB_LOWER_OFFSET
L_014B	= $014B + BEEB_LOWER_OFFSET
L_014C	= $014C + BEEB_LOWER_OFFSET
L_014D	= $014D + BEEB_LOWER_OFFSET
L_014E	= $014E + BEEB_LOWER_OFFSET
L_014F	= $014F + BEEB_LOWER_OFFSET
L_0150	= $0150 + BEEB_LOWER_OFFSET
L_0151	= $0151 + BEEB_LOWER_OFFSET
L_0154	= $0154 + BEEB_LOWER_OFFSET
L_0156	= $0156 + BEEB_LOWER_OFFSET
L_0157	= $0157 + BEEB_LOWER_OFFSET
L_0159	= $0159 + BEEB_LOWER_OFFSET
L_015A	= $015A + BEEB_LOWER_OFFSET
L_015B	= $015B + BEEB_LOWER_OFFSET
L_015C	= $015C + BEEB_LOWER_OFFSET
L_015D	= $015D + BEEB_LOWER_OFFSET
L_015E	= $015E + BEEB_LOWER_OFFSET
L_015F	= $015F + BEEB_LOWER_OFFSET
L_0160	= $0160 + BEEB_LOWER_OFFSET
L_0161	= $0161 + BEEB_LOWER_OFFSET
L_0166	= $0166 + BEEB_LOWER_OFFSET
L_0167	= $0167 + BEEB_LOWER_OFFSET
L_016A	= $016A + BEEB_LOWER_OFFSET
L_016B	= $016B + BEEB_LOWER_OFFSET
L_016C	= $016C + BEEB_LOWER_OFFSET
L_016D	= $016D + BEEB_LOWER_OFFSET
L_016E	= $016E + BEEB_LOWER_OFFSET
L_016F	= $016F + BEEB_LOWER_OFFSET
L_0170	= $0170 + BEEB_LOWER_OFFSET
L_0171	= $0171 + BEEB_LOWER_OFFSET
L_0172	= $0172 + BEEB_LOWER_OFFSET
L_0173	= $0173 + BEEB_LOWER_OFFSET
L_0174	= $0174 + BEEB_LOWER_OFFSET
L_0175	= $0175 + BEEB_LOWER_OFFSET
L_0176	= $0176 + BEEB_LOWER_OFFSET
L_0177	= $0177 + BEEB_LOWER_OFFSET
L_0178	= $0178 + BEEB_LOWER_OFFSET
L_0179	= $0179 + BEEB_LOWER_OFFSET
L_017A	= $017A + BEEB_LOWER_OFFSET
L_017B	= $017B + BEEB_LOWER_OFFSET
L_017C	= $017C + BEEB_LOWER_OFFSET
L_017D	= $017D + BEEB_LOWER_OFFSET
L_017E	= $017E + BEEB_LOWER_OFFSET
L_017F	= $017F + BEEB_LOWER_OFFSET
L_0180	= $0180 + BEEB_LOWER_OFFSET
L_0181	= $0181 + BEEB_LOWER_OFFSET
L_0182	= $0182 + BEEB_LOWER_OFFSET
L_0183	= $0183 + BEEB_LOWER_OFFSET
L_0184	= $0184 + BEEB_LOWER_OFFSET
L_0188	= $0188 + BEEB_LOWER_OFFSET
L_0189	= $0189 + BEEB_LOWER_OFFSET
L_018A	= $018A + BEEB_LOWER_OFFSET
L_0190	= $0190 + BEEB_LOWER_OFFSET
L_01C1	= $01C1 + BEEB_LOWER_OFFSET
\\ Pretty sure these need to be contiguous
L_0200	= $0200 + BEEB_LOWER_OFFSET
L_0240	= $0240 + BEEB_LOWER_OFFSET
L_0241	= $0241 + BEEB_LOWER_OFFSET
L_0242	= $0242 + BEEB_LOWER_OFFSET
L_0243	= $0243 + BEEB_LOWER_OFFSET
L_0280	= $0280 + BEEB_LOWER_OFFSET
L_0291	= $0291 + BEEB_LOWER_OFFSET
L_02C0	= $02C0 + BEEB_LOWER_OFFSET
\\ These have to be contiguous as the value at $300 are indexed from L_0280
; Camera matrices?
L_0300	= $0300 + BEEB_LOWER_OFFSET
L_0314	= $0314 + BEEB_LOWER_OFFSET
L_0380	= $0380 + BEEB_LOWER_OFFSET

; Some sort of track variables?
; MAX ROAD SECTIONS = $4E = 78

L_0400	= $0400
L_0401	= $0401
L_0402	= $0402

road_section_angle_and_piece	= $0400
L_042A	= $042A
road_section_xz_positions	= $044E
L_0480	= $0480
left_y_coordinate_IDs	= $049C
L_04A0	= $04A0
right_y_coordinate_IDs	= $04EA
L_04FA	= $04FA

L_0500	= $0500
overall_left_y_shifts_LSBs	= $0538
overall_left_y_shifts_MSBs	= $0586
overall_right_y_shifts_LSBs	= $05D4
L_05F4	= $05F4

L_0600	= $0600
overall_right_y_shifts_MSBs	= $0622
distances_around_road_LSBs	= $0670
distances_around_road_MSBs	= $06BE
L_06EE	= $06EE

L_0700	= $0700

L_0710	= $0710
L_0740	= $0740
L_0743	= $0743
L_0744	= $0744
L_075E	= $075E
L_0769	= $0769
L_0774	= $0774
L_0775	= $0775
L_077A	= $077A
L_077B	= $077B
L_077C	= $077C
L_077D	= $077D
L_077E	= $077E
L_077F	= $077F
L_0780	= $0780
L_0781	= $0781
L_0782	= $0782
L_0784	= $0784
L_0786	= $0786
L_0788	= $0788
L_0789	= $0789
L_078A	= $078A
L_078B	= $078B
L_078C	= $078C
L_078E	= $078E
L_0790	= $0790
L_0793	= $0793
L_0795	= $0795
L_0796	= $0796
L_0797	= $0797
L_079C	= $079C
L_079D	= $079D
L_07A2	= $07A2
L_07A3	= $07A3
L_07A4	= $07A4
L_07A5	= $07A5
L_07A6	= $07A6
L_07A7	= $07A7
L_07A8	= $07A8
L_07A9	= $07A9
L_07AA	= $07AA
L_07AC	= $07AC
L_07AE	= $07AE
L_07B0	= $07B0
L_07B1	= $07B1
L_07B2	= $07B2
L_07B3	= $07B3
L_07B4	= $07B4
L_07B6	= $07B6
L_07B8	= $07B8
L_07BB	= $07BB
L_07BD	= $07BD
L_07BE	= $07BE
L_07BF	= $07BF
L_07C4	= $07C4
L_07C8	= $07C8
L_07CC	= $07CC
L_07D0	= $07D0
L_07D4	= $07D4
L_07D8	= $07D8
L_07DC	= $07DC
L_07DE	= $07DE
L_07E0	= $07E0
L_07E2	= $07E2
L_07E4	= $07E4
L_07E6	= $07E6
L_07E8	= $07E8
L_07EA	= $07EA
L_07EC	= $07EC
L_07ED	= $07ED
L_07EE	= $07EE
L_07F0	= $07F0
L_07F1	= $07F1
L_07F2	= $07F2

L_5800 = $5800
L_5900 = $5900
L_5A00 = $5A00
L_5B00 = $5B00
L_5C00 = $5C00
L_5D00 = $5D00
L_5E00 = $5E00
L_5F00 = $5f00

; this is where the VIC fetches the sprite pointers from, so I've left
; the addresses as-is for now. But these 8 bytes could go pretty much
; anywhere, really...
vic_sprite_ptr0=$5ff8
vic_sprite_ptr1=$5ff9
vic_sprite_ptr2=$5ffa
vic_sprite_ptr3=$5ffb
vic_sprite_ptr4=$5ffc
vic_sprite_ptr5=$5ffd
vic_sprite_ptr6=$5ffe
vic_sprite_ptr7=$5fff

; *****************************************************************************
; CORE RAM: $0800 - $4000
;
; $0800 = Game code? (inc. game_update)
; $1400 = Rendering code? (inc. font, sprites, lines?)
; $1C00 = Game code? (inc. AI, )
; $2700 = Camera code?
; $2F00 = Rendering code? (track preview)
; $3000 = Front end (game select etc.)
; $3900 = Rendering code? (color map, menus)
; $3D00 = Main loop?
; $3F00 = System code? (page flip, VIC control, misc)
; *****************************************************************************

PRINT "***"
ORG &E00
GUARD bootstrap_address		; using .boot_start doesn't seem to guard?

\\ Core Code

INCLUDE "game/core-ram.asm"
INCLUDE "game/beeb-dll.asm"
INCLUDE "game/beeb-code.asm"
INCLUDE "lib/unpack.asm"		; could probably be move to SWRAM beeb-graphics

\\ Core Data

INCLUDE "game/core-data.asm"

; *****************************************************************************
\\ Core RAM area
; *****************************************************************************

PRINT "--------"
PRINT "CORE RAM"
PRINT "--------"
PRINT "  Start =", ~core_start
PRINT "  End =", ~P%
PRINT "  Size =", ~(P% - core_start)
PRINT "  Free =", ~(boot_start - P%)
PRINT "  DLL Jump Table Size =", ~(beeb_dll_end - beeb_dll_start)
PRINT "  Core Data Size =", ~(core_data_end - core_data_start)
PRINT "--------"
SAVE "Core", core_start, P%, 0
PRINT "--------"

CLEAR &3f00, &8000
ORG bootstrap_address
GUARD disksys_loadto_addr

.boot_start

; *****************************************************************************
; BEEB APP ENTRY
; *****************************************************************************

.scr_entry
{
	; BEEB EARLY INIT

	LDA #200
	LDX #2
	JSR osbyte

	lda #15
	ldx #0
	ldy #0
	jsr osbyte

	; BEEB SET SCREEN MODE 4

	; LDA #22
	; JSR oswrch
	; LDA #BEEB_SCREEN_MODE
	; JSR oswrch

	; LDA #10: STA &FE00		; turn off cursor
	; LDA #32: STA &FE01

	; ; BEEB SET SCREEN TO 8K

	; LDA #6:STA &FE00		; R6 = vertical displayed
	; LDA #25:STA &FE01		; 25 rows = 200 scanlines

	; LDA #12:STA &FE00
	; LDA #HI(screen1_address/8):STA &FE01

	; LDA #13:STA &FE00
	; LDA #LO(screen1_address/8):STA &FE01

\ Ensure HAZEL RAM is writeable - assume this says writable throughout?

    LDA &FE34:ORA #&8:STA &FE34

	; BEEB LOAD MODULES

	LDX #LO(core_filename)
	LDY #HI(core_filename)
	LDA #HI(core_start)
	JSR disksys_load_file

	SWR_SELECT_SLOT BEEB_CART_SLOT

	LDX #LO(cart_filename)
	LDY #HI(cart_filename)
	LDA #HI(cart_start)
	JSR disksys_load_file

	SWR_SELECT_SLOT BEEB_KERNEL_SLOT

	LDX #LO(kernel_filename)
	LDY #HI(kernel_filename)
	LDA #HI(kernel_start)
	JSR disksys_load_file

	SWR_SELECT_SLOT BEEB_GRAPHICS_SLOT
	
	ldx #lo(beeb_graphics_filename)
	ldy #hi(beeb_graphics_filename)
	lda #hi(beeb_graphics_start)
	jsr disksys_load_file

	\\ HAZEL must be last as stomping on FS workspace

	LDX #LO(hazel_filename)
	LDY #HI(hazel_filename)
	LDA #HI(disksys_loadto_addr)
	JSR disksys_load_direct

	\\ Load boot data to screen

	LDX #LO(data_filename)
	LDY #HI(data_filename)
	LDA #HI(boot_data_start)
	JSR disksys_load_file

	\\ Clear Hazel RAM for BSS

	{
		ldx #0
		lda #0
		.clear_loop
		sta hazel_start, X
		inx
		bne clear_loop
		inc clear_loop+2
		ldy clear_loop+2
		cpy #HI(hazel_end) + 1
		bcc clear_loop
	}

	\\ Now copy data from screen1 up to Hazel

	LDA #HI(disksys_loadto_addr)
	LDX #HI(hazel_data_start)
	LDY #HI(hazel_data_end - hazel_data_start + &FF)
	JSR disksys_copy_block

	\\ FS is now unusable as HAZEL has been trashed

	; Save off original top of HUD.
{
		SWR_SELECT_SLOT BEEB_KERNEL_SLOT
	
		ldx #0
.save_top_of_hud_loop
		lda L_6028,x
		sta original_top_of_hud_data,x
		inx
		cpx #$f0
		bne save_top_of_hud_loop
}

	; C64 init at L_400F
	; Set up VIC etc.
	; Set up COLOR RAM

		ldx #$7F		;40A5 A2 7F
.L_40A7	lda L_5780,X	;40A7 BD 80 57
		sta L_C280,X	;40AA 9D 80 C2
		dex				;40AD CA
		bpl L_40A7		;40AE 10 F7         ; copy $80 bytes from $5780 to $C280

; 		ldx #$0B		;40B0 A2 0B
; .L_40B2	lda L_DAB6,X	;40B2 BD B6 DA
; 		sta L_C6C0,X	;40B5 9D C0 C6
; 		dex				;40B8 CA
; 		bpl L_40B2		;40B9 10 F7         ; copy 13 bytes from $DAB6 to $C6C0

; Blats $1F to a load of locations around $5CXX - screen RAM?

; 		ldx #$1F		;40BB A2 1F
; 		ldy #$00		;40BD A0 00
; .L_40BF	lda #$0F		;40BF A9 0F
; 		sta ZP_08		;40C1 85 08
; 		lda #HI(vic_screen_mem_page0)		;40C3 A9 5C
; 		sta ZP_1F		;40C5 85 1F
; 		txa				;40C7 8A
; 		clc				;40C8 18
; 		adc #$54		;40C9 69 54
; 		sta ZP_1E		;40CB 85 1E
; .L_40CD	lda ZP_08		;40CD A5 08
; 		cmp L_40EF,X	;40CF DD EF 40
; 		bcc L_40E9		;40D2 90 15
; 		lda #$1E		;40D4 A9 1E
; 		sta (ZP_1E),Y	;40D6 91 1E
; 		lda ZP_1E		;40D8 A5 1E
; 		clc				;40DA 18
; 		adc #$28		;40DB 69 28
; 		sta ZP_1E		;40DD 85 1E
; 		lda ZP_1F		;40DF A5 1F
; 		adc #$00		;40E1 69 00
; 		sta ZP_1F		;40E3 85 1F
; 		dec ZP_08		;40E5 C6 08
; 		bpl L_40CD		;40E7 10 E4
; .L_40E9	dex				;40E9 CA
; 		bpl L_40BF		;40EA 10 D3

; More setup weirdness for COLOR RAM

; .L_411F	ldx #$0F		;411F A2 0F
; .L_4121	lda #$08		;4121 A9 08
; 		sta L_DB54,X	;4123 9D 54 DB
; 		dex				;4126 CA
; 		bpl L_4121		;4127 10 F8     ; write 16 bytes COLOR RAM
		
        ; lda #$21		;4129 A9 21
		; sta L_5EAC		;412B 8D AC 5E
		; sta L_5ED4		;412E 8D D4 5E
		; sta L_5EFC		;4131 8D FC 5E
		; sta L_5ECB		;4134 8D CB 5E
		; sta L_5EF3		;4137 8D F3 5E
		; sta L_5F1B		;413A 8D 1B 5F  ; setup screen RAM?

		; lda #$0C		;413D A9 0C
		; sta L_DAD4		;413F 8D D4 DA
		; sta L_DAFC		;4142 8D FC DA
		; sta L_DAF3		;4145 8D F3 DA
		; sta L_DB1B		;4148 8D 1B DB  ; COLOR RAM

		ldx #$00		;414B A2 00
.L_414D

; top row of engine

		lda L_72E0,X	;414D BD E0 72
		sta L_C000,X	;4150 9D 00 C0

; next row of engine

		lda L_7420,X	;4153 BD 20 74
		sta L_C100,X	;4156 9D 00 C1
		dex				;4159 CA
		bne L_414D		;415A D0 F1     ; copy 2x pages from $72E0 to $C000

		ldx #$17		;415C A2 17
.L_415E

; gap between left exhausts and left side of engine

		lda L_75A0,X	;415E BD A0 75
		sta L_C200,X	;4161 9D 00 C2

; gap between right exhausts and right side of engine

		lda L_7608,X	;4164 BD 08 76
		sta L_C218,X	;4167 9D 18 C2

; left edge of screen and left half of left exhausts

		lda L_7560,X	;416A BD 60 75
		sta L_C230,X	;416D 9D 30 C2

; right edge of screen and right half of right exhausts

		lda L_7648,X	;4170 BD 48 76
		sta L_C248,X	;4173 9D 48 C2
		dex				;4176 CA
		bpl L_415E		;4177 10 E5     ; copy $18*4 = 96 bytes from $75XX to C2XX

\\ Think this is sprite data

; 		ldx #$00		;4179 A2 00
; .L_417B
; 		lda #0;L_63E0,X	;417B BD E0 63
; 		sta L_5800,X	;417E 9D 00 58
; 		lda #0;L_6520,X	;4181 BD 20 65
; 		sta L_5900,X	;4184 9D 00 59
; 		dex				;4187 CA
; 		bne L_417B		;4188 D0 F1     ; copy 2x pages from $63E0 to $5800

\\ Think this is sprite data

; 		ldx #$3F		;418A A2 3F
; .L_418C	lda #0;L_66E0,X	;418C BD E0 66
; 		sta L_5A00,X	;418F 9D 00 5A
; 		lda #0;L_6920,X	;4192 BD 20 69
; 		sta L_5A40,X	;4195 9D 40 5A
; 		; lda L_6B60,X	;4198 BD 60 6B
; 		; sta L_7F40,X	;419B 9D 40 7F
; 		; lda #0;L_6BA0,X	;419E BD A0 6B
; 		; sta L_57C0,X	;41A1 9D C0 57
; 		dex				;41A4 CA
; 		bpl L_418C		;41A5 10 E5     ; copy $40*4 = 256 bytes from $6XX0 to $5XX0

\\ Think this is sprite data

; 		ldx #$7F		;41A7 A2 7F
; .L_41A9	lda #0;L_6D20,X	;41A9 BD 20 6D
; 		sta L_5A80,X	;41AC 9D 80 5A
; 		lda #0;L_6A20,X	;41AF BD 20 6A
; 		sta L_5B00,X	;41B2 9D 00 5B
; 		lda #0;L_6DE0,X	;41B5 BD E0 6D
; 		sta L_5B80,X	;41B8 9D 80 5B
; 		dex				;41BB CA
; 		bpl L_41A9		;41BC 10 EB     ; copy $80*3 = 384 bytes from $6DX0 to $5XX0

\\ Think this is screen RAM area

; 		lda #$00		;41BE A9 00
; 		ldx #$03		;41C0 A2 03
; .L_41C2	sta L_5C26,X	;41C2 9D 26 5C
; 		sta L_5C4E,X	;41C5 9D 4E 5C
; 		sta L_5C76,X	;41C8 9D 76 5C
; 		sta L_5C9E,X	;41CB 9D 9E 5C
; 		sta L_5CC6,X	;41CE 9D C6 5C
; 		sta L_5CEE,X	;41D1 9D EE 5C
; 		sta L_5D16,X	;41D4 9D 16 5D
; 		sta L_5D3E,X	;41D7 9D 3E 5D
; 		dex				;41DA CA
; 		bpl L_41C2		;41DB 10 E5     ; wipe 4*8 = 32 bytes in $5XXX

	; C64 page in RAM over IO space at $D000
	; jsr L_33F1 (disable_ints_and_page_in_RAM)
	; C64 copy 14x pages to $D000 through $DD00

.L_41E0	ldx #$00		;41E0 A2 00
.L_41E2

; Anything in this loop that's filled with 0 is unused (hopefully!)
; and could be left as-is - it's initialised explicitly so it's easy
; to spot in a hex view.

; These areas are display RAM during the track preview screen, and
; invisible during game. C64 version uses them to hold sprite data
; while in game.

		lda #0:sta L_5800,x
		lda #0:sta L_5900,x
		lda #0:sta L_5A00,x
		lda #0:sta L_5B00,x
		lda #0:sta L_5C00,x
		lda #0:sta L_5D00,x
		lda #0:sta L_5E00,x
		lda #0:sta L_5F00,x

; HAZEL.

; Claimed for SID>SN76489 frequency tables
;		lda #0:sta _L_D000,X	; d0
;		lda #0:sta _L_D100,X	; d1

; Claimed for file operation workspace
;		lda #0:sta _L_D200,X	; d2
;		lda #0:sta _L_D300,X	; d3
;		lda #0:sta _L_D400,x	; d4

; Claimed for cosine table
;		lda #0:sta _L_D500,x	; d5

; Claimed for SID>SN76489 frequency tables
;		lda #0:sta _L_D600,x	; d6
;		lda #0:sta _L_D700,x	; d7

; Claimed back for MOS FS workspace
;		lda #0:sta _L_D800,x	; d8
;		lda #0:sta _L_D900,x	; d9
;		lda #0:sta _L_DA00,x	; da
;		lda #0:sta _L_DB00,x	; db
		
		lda L_AE00,X	;422A BD 00 AE
		sta L_DC00,X	;422D 9D 00 DC

		lda L_7B00,X	;4230 BD 00 7B
		sta L_DD00,X	;4233 9D 00 DD
		dex				;4236 CA
		bne L_41E2		;4237 D0 A9

	\\ Copy blank entries for high score tables

		ldx #$00		;4239 A2 00
		ldy #$00		;423B A0 00
.L_423D	lda L_410F,Y	;423D B9 0F 41
		sta L_DE00,X	;4240 9D 00 DE
		sta L_DF00,X	;4243 9D 00 DF
		dey				;4246 88
		bpl L_424B		;4247 10 02     ; copy values from $410F to $DE00 and $DF00 (I/O)

		ldy #$0F		;4249 A0 0F
.L_424B	dex				;424B CA
		bne L_423D		;424C D0 EF

	\\ Final copy stage uses fn in SWRAM so has to be after module load

		ldx #$00		;4253 A2 00
		lda #$34		;4255 A9 34
		jsr cart_sysctl		;4257 20 25 87  ; copy stuff using sysctl

	; BEEB LATE INIT

	; BEEB SET INTERRUPT HANDLER

    SEI
	LDA #&7F		; A=01111111
	STA &FE4E		; R14=Interrupt Enable (disable all interrupts)

	LDA #0			; A=00000000
	STA &FE4B		; R11=Auxillary Control Register (timer 1 one shot mode)

	LDA #&C2		; A=11000010
	STA &FE4E		; R14=Interrupt Enable (enable main_vsync and timer interrupt)

	LDA IRQ1V:STA old_irqv
	LDA IRQ1V+1:STA old_irqv+1      ; remember old interrupt handler
	
	LDA #LO(irq_handler):STA IRQ1V
	LDA #HI(irq_handler):STA IRQ1V+1		; set interrupt handler

	LDA #LO(cart_write_char):STA WRCHV
	LDA #HI(cart_write_char):STA WRCHV+1

if _DEBUG
    lda #LO(brk_handler):sta BRKV+0
	lda #HI(brk_handler):sta BRKV+1
endif

    CLI

	jsr disable_screen

	\\ Need to copy data from &3000 - &3FFF into SHADOW RAM as this may be
	\\ accessed by the frontend system whilst the MODE 1 SHADOW screen is
	\\ paged in. As we're in the loader above $3000 we need to copy some
	\\ code down to spare RAM ($300) to copy a page at a time w/ bank swaps.

	{
		LDX #0

		.reloc_loop
		LDA copy_to_shadow, X
		STA &300, X
		INX
		CPX #(copy_to_shadow_end - copy_to_shadow)
		BNE reloc_loop

		JSR &300
	}

	\\ Clear lower RAM

	{
		ldx #0
		lda #0
		.clear_loop
		sta &300, X
		inx
		bne clear_loop
		inc clear_loop+2
		ldy clear_loop+2
		cpy #&0D
		bcc clear_loop
	}

	; Sort out display.
	jsr set_up_beeb_display
	
		jmp game_start		;425A 4C 22 3B

        ; ^^^ JUMP TO GAME START

; .L_40EF	EQUB $00,$00,$00,$01,$01,$01,$02,$02,$00,$00,$01,$01,$01,$02,$02,$01,$01
;     	EQUB $02,$02,$01,$01,$01,$00,$00,$02,$02,$01,$01,$01
;     	EQUB $00
;     	EQUB $00
;     	EQUB $00
.L_410F	EQUB $2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$09,$00,$00,$00

; Was part of boot-data, but it's only needed on startup, so it can go
; here.
;
; It's the initial horizon table when in game.
.L_5780	EQUB $BC,$BC,$BC,$BC,$BC,$BC,$BC,$BA,$B9,$B9,$B9,$B9,$B9,$B9,$B7,$B5
		EQUB $B4,$B4,$B4,$B4,$B4,$B2,$B1,$B0
		EQUB $B0,$B0,$B0,$AE,$AD,$AD,$AD,$AD,$AF,$BD,$BF,$C0,$C0,$BF,$BE,$BC
		EQUB $B8,$B8,$B8,$B7,$B6,$B6,$B5,$B5,$B2,$B1,$AF,$AC,$AB,$AB,$AB,$AB
		EQUB $AB,$AB,$AB,$AC,$B4,$B4,$B4,$B1
		EQUB $B1,$B4,$B4,$B4,$AC,$AB,$AB,$AB
		EQUB $AB,$AB,$AB,$AB,$AC,$AD,$AF,$B1
		EQUB $B5,$B5,$B5,$B6,$B7,$B8,$B8,$B8,$BC,$BD,$BE,$BF,$C0,$BF,$BD,$AF
		EQUB $AD,$AD,$AD,$AD,$AE,$B0,$B0,$B0,$B0,$B1,$B2,$B4,$B4,$B4,$B4,$B4
		EQUB $B5,$B7,$B9,$B9,$B9,$B9,$B9,$B9,$BA,$BC,$BC,$BC,$BC,$BC,$BC,$BC
}

.set_up_beeb_display
{
; show main RAM, not shadow RAM.
lda $fe34:and #$fe:sta $fe34

; set up Mode 4 + palette.
jsr beeb_set_mode_4

; set up CRTC.
ldx #13
.loop
lda crtc,x:stx $fe00:sta $fe01
dex:bpl loop

rts

.crtc
equb $3f						; R0
equb $28						; R1
equb $31						; R2
equb $42						; R3
equb $26						; R4
equb $00						; R5
equb $19						; R6
equb $22						; R7
equb CRTC_R8_DisplayDisableValue ; R8
equb $07						; R9
equb $20						; R10
equb $08						; R11
equb HI(screen1_address/8) 		; R12
equb LO(screen1_address/8)		; R13

	; ; BEEB SET SCREEN TO 8K

	; LDA #6:STA &FE00		; R6 = vertical displayed
	; LDA #25:STA &FE01		; 25 rows = 200 scanlines

	; LDA #12:STA &FE00
	; LDA #HI(screen1_address/8):STA &FE01

	; LDA #13:STA &FE00
	; LDA #LO(screen1_address/8):STA &FE01
}

.copy_to_shadow
{
	; COPY DATA FROM MAIN TO SHADOW RAM
	LDX #0
	.read_loop
	read_loop_reloc = read_loop - copy_to_shadow + &300
	LDA &3000, X
	STA &400,X
	INX
	BNE read_loop

	; Page in SHADOW
	LDA &FE34
	ORA #4
	STA &FE34

	.write_loop
	write_loop_reloc = write_loop - copy_to_shadow + &300
	LDA &400,X
	STA &3000,X
	INX
	BNE write_loop

	; Page in MAIN
	LDA &FE34
	AND #&FB
	STA &FE34

	INC read_loop_reloc+2
	INC write_loop_reloc+5

	LDA read_loop_reloc+2
	CMP #HI(core_data_end + &FF)
	BNE read_loop

	RTS
}
.copy_to_shadow_end

.core_filename EQUS "Core", 13
.kernel_filename EQUS "Kernel", 13
.cart_filename EQUS "Cart", 13
.beeb_graphics_filename EQUS "Beebgfx",13
.hazel_filename EQUS "Hazel", 13
.data_filename EQUS "Data", 13

INCLUDE "lib/disksys.asm"

.boot_end

; *****************************************************************************
\\ Boot RAM area
; *****************************************************************************

PRINT "---------"
PRINT "BOOT CODE"
PRINT "---------"
PRINT "  Start =", ~boot_start
PRINT "  End =", ~boot_end
PRINT "  Size =", ~(boot_end - boot_start)
PRINT "  Entry =", ~scr_entry
PRINT "--------"
SAVE "Loader2", boot_start, boot_end, scr_entry
PRINT "--------"

; *****************************************************************************
; SCREEN BUFFERS: $4000 - $8000
; *****************************************************************************

PAGE_ALIGN
PRINT "SAFE TO LOAD TO =", ~P%

	; Comments from Fandal:

		;;; screen 1 - originally od $4000, nyni od $0800
		
		;;; from screen 1 was actually a picture area used $4140 until $57bf
		;;; the first line ($4000 - $413f) was used for other purposes
		;;; the last sixth row ($57c0- $5fff) was used for other purposes ($840 bytes)
		
		; first line screens 1, which is not displayed and which is used for other purposes - 320 bytes

screen1_address = $4000
screen2_address = $6000

		; pointing to screen 1

;L_3FF1	= screen1_address-$F
;L_3FF6	= screen1_address-$A
;L_3FFA	= screen1_address-$6

\L_4000	= screen1_address+$0000	; screen
\IF (L_4000 AND 255)<>0
\error "L_4000 must be page aligned"
\ENDIF
;L_4001	= screen1_address+$0001
;L_4008	= screen1_address+$0008
\L_400C	= screen1_address+$000c	; save
\L_400D	= screen1_address+$000d	; save
\L_400E	= screen1_address+$000e	; save
;L_4010	= screen1_address+$0010
\L_4020	= screen1_address+$0020	; save
\L_4025	= screen1_address+$0025	; save
\L_40A0	= screen1_address+$00a0	; save
\L_40DC	= screen1_address+$00dc	; save
\L_40E0	= screen1_address+$00e0 ; save
\L_4100	= screen1_address+$0100 ; crash
\L_410C	= screen1_address+$010c ; save
\L_410D	= screen1_address+$010d ; save
\L_410E	= screen1_address+$010e	; save
\L_4120	= screen1_address+$0120	; crash
;L_4130	= screen1_address+$0130
;L_4136	= screen1_address+$0136			
;L_4148	= screen1_address+$0148			
;L_4150	= screen1_address+$0150
;L_41E0	= screen1_address+$01e0
;L_4268	= screen1_address+$0268
;L_42A0	= screen1_address+$02a0
\L_4300	= screen1_address+$0300	; save
;L_43E0	= screen1_address+$03e0
;L_4520	= screen1_address+$0520
;L_4660	= screen1_address+$0660
;L_47A0	= screen1_address+$07a0
;L_48E0	= screen1_address+$08e0
;L_4A00	= screen1_address+$0a00
;L_4A20	= screen1_address+$0a20
;L_4B60	= screen1_address+$0b60
;L_4CA0	= screen1_address+$0ca0
;L_4DE0	= screen1_address+$0de0
;L_4F20	= screen1_address+$0f20

L_5740	= screen1_address+$1740

;L_6026	= screen2_address+$0026
;L_6027	= screen2_address+$0027
;L_6028	= screen2_address+$0028
;track_preview_border_0	= screen2_address+$0130

;track_preview_border_1	= screen2_address+$0270
;L_62A0	= screen2_address+$02a0
;track_preview_border_2	= screen2_address+$03b0
;L_63E0	= screen2_address+$03e0
;track_preview_border_3	= screen2_address+$04f0
;L_6520	= screen2_address+$0520
;L_6660	= screen2_address+$0660
;L_66E0	= screen2_address+$06e0
;L_67A0	= screen2_address+$07a0
;L_68E0	= screen2_address+$08e0
;L_6920	= screen2_address+$0920
;L_6A20	= screen2_address+$0a20
;L_6B60	= screen2_address+$0b60
;L_6BA0	= screen2_address+$0ba0
;L_6CA0	= screen2_address+$0ca0
;L_6D20	= screen2_address+$0d20
;L_6D6A	= screen2_address+$0d6a
;L_6DE0	= screen2_address+$0de0
;L_6F20	= screen2_address+$0f20
;L_7060	= screen2_address+$1060
;L_71A0	= screen2_address+$11a0
;L_7658  = screen2_address+$1658
;L_76A0	= screen2_address+$16a0 ; the bottom of the left wheel ($7680 is beginning C64 row)

L_7740	= screen2_address+$1740

;L_7798	= screen2_address+$1798 ; the bottom of the right wheel
;L_77E0	= screen2_address+$17e0 ; bottom of the left wheel ($77c0 is beginning C64 row)
;L_78D8	= screen2_address+$18d8 ; the bottom of the right wheel
;L_7AA6	= screen2_address+$1aa6 ; left upper corner of the speedometer ($7A40 is beginning C64 row)
;L_7AA7	= screen2_address+$1aa7 ; left upper corner of the speedometer
;L_7B00	= screen2_address+$1b00
;L_7C00	= screen2_address+$1c00
;L_7C53	= screen2_address+$1c53
;L_7C74	= screen2_address+$1c74
;L_7D00	= screen2_address+$1d00
;L_7E00	= screen2_address+$1e00 ; OK
;L_7F00	= screen2_address+$1f00 ; OK

		; space behind the screen 2 ($7f40-$7fff) - 192 byte

;L_7F80	= screen2_address+$1f80
;L_7F81	= screen2_address+$1f81
;L_7F82	= screen2_address+$1f82
;L_7FC0	= screen2_address+$1fc0
;L_7FC1	= screen2_address+$1fc1
;L_7FC2	= screen2_address+$1fc2

PRINT "***"
ORG &6000
GUARD &8000
INCLUDE "game/boot-data.asm"

; *****************************************************************************
\\ Boot DATA area
; *****************************************************************************

PRINT "---------"
PRINT "BOOT DATA"
PRINT "---------"
PRINT "  Start =", ~boot_data_start
PRINT "  End =", ~boot_data_end
PRINT "  Size =", ~(boot_data_end - boot_data_start)
PRINT "--------"
SAVE "Data", boot_data_start, boot_data_end, 0
PRINT "--------"

; *****************************************************************************
; CART RAM: $8000 - $A000
; $8300 = More code VIC, color map
; $8400 = oswrch
; $8500 = read keyboard
; $8600 = SID update
; $8700 = sysctl
; $8A00 = draw horizon
; $8E00 = draw speedo
; $8F00 = clear screen
; $9000 = update color map
; $9100 = PETSCII fns?
; $9500 = Save file strings
; $9800 = Practice menu, Hall of Fame etc.
; $9A00 = More track & camera code; ...
; $A100 = Calculate camera sines
; *****************************************************************************

PRINT "***"
CLEAR &8000, &C000
ORG &8000
GUARD &8000 + MAX_LOADABLE_ROM_SIZE

INCLUDE "game/cart-ram.asm"

; *****************************************************************************
\\ Cart RAM area
; *****************************************************************************

PRINT "--------"
PRINT "CART RAM"
PRINT "--------"
PRINT "  Start =", ~cart_start
PRINT "  End =", ~cart_end
PRINT "  Size =", ~(cart_end - cart_start)
PRINT "  Free =", ~(&C000 - cart_end)
PRINT "--------"
SAVE "Cart", cart_start, cart_end, 0
PRINT "--------"

PRINT "***"
CLEAR &8000,&C000
ORG &8000
GUARD &C000

include "game/beeb-graphics.asm"

PRINT "--------"
PRINT "Beeb graphics RAM"
PRINT "--------"
PRINT "  Start =", ~beeb_graphics_start
PRINT "  End =", ~beeb_graphics_end
PRINT "  Size =", ~(beeb_graphics_end - beeb_graphics_start)
PRINT "  Free =", ~(&C000 - beeb_graphics_end)
PRINT "--------"
SAVE "Beebgfx", beeb_graphics_start, beeb_graphics_end, 0
PRINT "--------"

; *****************************************************************************
; HAZEL RAM: $C000 - $D000
; $C700 = Maths routines
; ...
; $CD00 = IRQ handler
; $CE00 = Sprite code
; $CF00 = Raster interrupts
; *****************************************************************************

; Engine screen data (copied at boot time from elsewhere)

PRINT "***"
CLEAR &C000, &E000
\\ Need to keep PAGES $C000 - $C300 free for MOS DFS workspace
ORG &C300
\\ Need to keep PAGE $DF00 free for MOS FS workspace
GUARD &DF00

INCLUDE "game/hazel-ram.asm"

; *****************************************************************************
; HAZEL RAM Area
; *****************************************************************************

PRINT "---------"
PRINT "HAZEL RAM"
PRINT "---------"
PRINT "  Start =", ~hazel_start
PRINT "  End =", ~hazel_end
PRINT "  Size =", ~(hazel_end - hazel_start)
PRINT "  Data Size =", ~(hazel_data_end - hazel_data_start)
PRINT "  Free =", ~(&DF00 - hazel_end)
; print "data_start =",~boot_data_start
; print "end of HAZEL data when loaded =", ~(disksys_loadto_addr+(hazel_end-hazel_start))
PRINT "--------"
SAVE "Hazel", hazel_data_start, hazel_data_end, 0
PRINT "--------"

; Manual guard, as hazel_end and hazel_start are forward references
; above.
IF disksys_loadto_addr+(hazel_data_end-hazel_data_start)>boot_data_start
ERROR "Hazel data too large"
ENDIF

; *****************************************************************************
; KERNEL RAM: $E000 - $FFFF
; $E000 = Menu strings
; $E100 = Additional game code
; $E200 = Draw AI car
; $E800 = More subroutines
; $EE00 = Do menus
; $F000 = Menu data
; $F200 = Draw track preview
; $F600 = Update boosting
; $F800 = Drawing code?
; $FC00 = Line drawing code
; $FF00 = Vectors
; *****************************************************************************

PRINT "***"
CLEAR &8000,&C000
ORG &8000
GUARD &8000 + MAX_LOADABLE_ROM_SIZE

INCLUDE "game/kernel-ram.asm"

; *****************************************************************************
; KERNEL RAM Area
; *****************************************************************************

PRINT "-----------"
PRINT "KERNEL RAM"
PRINT "-----------"
PRINT "  Start =", ~kernel_start
PRINT "  End =", ~kernel_end
PRINT "  Size =", ~(kernel_end - kernel_start)
PRINT "  Free =", ~(&C000 - kernel_end)
PRINT "-------"
SAVE "Kernel", kernel_start, kernel_end, 0
PRINT "-------"

; *****************************************************************************
; Title screen
; *****************************************************************************
CLEAR $0,$8000
ORG $3000
GUARD $8000
INCBIN "build/scr-beeb-title-screen.dat"
SAVE "Title",$3000,$8000,0

; *****************************************************************************
; Title screen loader
; *****************************************************************************
PRINT "***"
CLEAR $0,$8000
ORG $1900

.title_screen_loader_start
{
lda #0:ldx #$ff:jsr osbyte		; query machine type
cpx #3:beq type_ok				; Master 128
cpx #5:beq type_ok				; Master Compact

ldx #master_required-text
.print
lda text,x:jsr osasci:cmp #13:beq done:inx:bne print
.done:rts

.type_ok
lda #$ea:ldx #0:ldy #255:jsr osbyte ; query Tube presence
cpx #0:beq tube_ok
ldx #disable_tube-text:jmp print

.tube_ok

ldx #0:jsr clear_display_ram	; clear main RAM
ldx #1:jsr clear_display_ram	; clear shadow RAM

lda #19:jsr osbyte

lda #22:jsr oswrch
lda #2:jsr oswrch

lda #10:sta $fe00:lda #32:sta $fe01 ; disable cursor

lda #113:ldx #1:jsr osbyte		; display main RAM
lda #108:ldx #1:jsr osbyte		; page in shadow RAM

lda #19:jsr osbyte

ldx #LO(load_title):ldy #HI(load_title):jsr oscli

lda #113:ldx #2:jsr osbyte		; display shadow RAM
lda #108:ldx #0:jsr osbyte		; page in main RAM

lda #19:jsr osbyte

ldx #LO(run_loader2):ldy #HI(run_loader2):jmp oscli

.load_title:equs "LOAD Title":equb 13
.run_loader2:equs "RUN Loader2":equb 13

.text
.master_required:equs "Master required",13
.disable_tube:equs "Please disable the Tube",13

.clear_display_ram
lda #108:jsr osbyte				; page in main (X=1) or shadow (X=1)
lda #$30:sta clear_loop_store+2
lda #0:sta clear_loop_store+1
.clear_loop
.clear_loop_store:sta $3000
inc clear_loop_store+1:bne clear_loop
inc clear_loop_store+2:bpl clear_loop
rts
}
.title_screen_loader_end

PRINT "-----------"
PRINT "Title Screen Loader"
PRINT "-----------"
PRINT "  Start =", ~title_screen_loader_start
PRINT "  End =", ~title_screen_loader_end
PRINT "  Size =", ~(title_screen_loader_end - title_screen_loader_start)
PRINT "  Free =", ~(&3000 - title_screen_loader_end)
PRINT "-------"
SAVE "Loader",title_screen_loader_start,title_screen_loader_end
PRINT "-------"

; *****************************************************************************
; Additional files for the disk...
; *****************************************************************************

PUTFILE "data/Hall.bin", "HALL", &0
PUTFILE "data/KCSave.bin", "KCSAVE", &0
PUTFILE "data/MPSave.bin", "MPSAVE", &0
