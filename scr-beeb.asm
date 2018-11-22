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

_TODO = FALSE
_NOT_BEEB = FALSE
_DEBUG = TRUE

BEEB_SCREEN_MODE = 4
BEEB_SCREEN_ADDR = $4000
BEEB_KERNEL_SLOT = 4
BEEB_CART_SLOT = 5

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

KEY_RETURN = IKN_return
KEY_RIGHT_SHIFT = IKN_shift		;$26	; right shift
KEY_LEFT_SHIFT = IKN_shift		;$39	; left shift

; *****************************************************************************
; MACROS
; *****************************************************************************

MACRO PAGE_ALIGN
    PRINT "ALIGN LOST ", ~LO(((P% AND &FF) EOR &FF)+1), " BYTES"
    ALIGN &100
ENDMACRO

MACRO SWR_SELECT_SLOT bank
{
	LDA #bank:STA &F4:STA &FE30
}
ENDMACRO

; *****************************************************************************
; C64 MEMORY DEFINES
; *****************************************************************************

BEEB_RAM_OFFSET = $0				; map C64 memory from $D000 to $D000

L_CFFF = $CFFF + BEEB_RAM_OFFSET

L_D000 = $D000 + BEEB_RAM_OFFSET
L_D001 = $D001 + BEEB_RAM_OFFSET
L_D002 = $D002 + BEEB_RAM_OFFSET
L_D003 = $D003 + BEEB_RAM_OFFSET
L_D004 = $D004 + BEEB_RAM_OFFSET
L_D005 = $D005 + BEEB_RAM_OFFSET
L_D006 = $D006 + BEEB_RAM_OFFSET
L_D007 = $D007 + BEEB_RAM_OFFSET
L_D008 = $D000 + BEEB_RAM_OFFSET
L_D009 = $D009 + BEEB_RAM_OFFSET
L_D00A = $D00A + BEEB_RAM_OFFSET
L_D00B = $D00B + BEEB_RAM_OFFSET
L_D00C = $D00C + BEEB_RAM_OFFSET
L_D00D = $D00D + BEEB_RAM_OFFSET
L_D00E = $D00E + BEEB_RAM_OFFSET
L_D00F = $D00F + BEEB_RAM_OFFSET
L_D010 = $D010 + BEEB_RAM_OFFSET
L_D011 = $D011 + BEEB_RAM_OFFSET
L_D012 = $D012 + BEEB_RAM_OFFSET
L_D013 = $D013 + BEEB_RAM_OFFSET
L_D014 = $D014 + BEEB_RAM_OFFSET
L_D015 = $D015 + BEEB_RAM_OFFSET
L_D016 = $D016 + BEEB_RAM_OFFSET
L_D017 = $D017 + BEEB_RAM_OFFSET
L_D018 = $D018 + BEEB_RAM_OFFSET
L_D019 = $D019 + BEEB_RAM_OFFSET
L_D01A = $D01A + BEEB_RAM_OFFSET
L_D01B = $D01B + BEEB_RAM_OFFSET
L_D01C = $D01C + BEEB_RAM_OFFSET
L_D01D = $D01D + BEEB_RAM_OFFSET
L_D01E = $D01E + BEEB_RAM_OFFSET
L_D01F = $D01F + BEEB_RAM_OFFSET
L_D020 = $D020 + BEEB_RAM_OFFSET
L_D021 = $D021 + BEEB_RAM_OFFSET
L_D022 = $D022 + BEEB_RAM_OFFSET
L_D023 = $D023 + BEEB_RAM_OFFSET
L_D024 = $D024 + BEEB_RAM_OFFSET
L_D025 = $D025 + BEEB_RAM_OFFSET
L_D026 = $D026 + BEEB_RAM_OFFSET
L_D027 = $D027 + BEEB_RAM_OFFSET
L_D028 = $D028 + BEEB_RAM_OFFSET
L_D029 = $D029 + BEEB_RAM_OFFSET
L_D02A = $D02A + BEEB_RAM_OFFSET
L_D02B = $D02B + BEEB_RAM_OFFSET
L_D02C = $D02C + BEEB_RAM_OFFSET
L_D02D = $D02D + BEEB_RAM_OFFSET
L_D02E = $D02E + BEEB_RAM_OFFSET
L_D02F = $D02F + BEEB_RAM_OFFSET

L_D100 = $D100 + BEEB_RAM_OFFSET		; CHARACTER ROM?
L_D200 = $D200 + BEEB_RAM_OFFSET		; CHARACTER ROM?
L_D300 = $D300 + BEEB_RAM_OFFSET		; CHARACTER ROM?

L_D400 = $D400 + BEEB_RAM_OFFSET
L_D401 = $D401 + BEEB_RAM_OFFSET
L_D402 = $D402 + BEEB_RAM_OFFSET
L_D403 = $D403 + BEEB_RAM_OFFSET
L_D404 = $D404 + BEEB_RAM_OFFSET
L_D405 = $D405 + BEEB_RAM_OFFSET
L_D406 = $D406 + BEEB_RAM_OFFSET
L_D407 = $D407 + BEEB_RAM_OFFSET
L_D408 = $D408 + BEEB_RAM_OFFSET
L_D409 = $D409 + BEEB_RAM_OFFSET
L_D40A = $D40A + BEEB_RAM_OFFSET
L_D40B = $D40B + BEEB_RAM_OFFSET
L_D40C = $D40C + BEEB_RAM_OFFSET
L_D40D = $D40D + BEEB_RAM_OFFSET
L_D40E = $D40E + BEEB_RAM_OFFSET
L_D40F = $D40F + BEEB_RAM_OFFSET
L_D410 = $D410 + BEEB_RAM_OFFSET
L_D411 = $D411 + BEEB_RAM_OFFSET
L_D412 = $D412 + BEEB_RAM_OFFSET
L_D413 = $D413 + BEEB_RAM_OFFSET
L_D414 = $D414 + BEEB_RAM_OFFSET
L_D415 = $D415 + BEEB_RAM_OFFSET
L_D416 = $D416 + BEEB_RAM_OFFSET
L_D417 = $D417 + BEEB_RAM_OFFSET
L_D418 = $D418 + BEEB_RAM_OFFSET
L_D419 = $D419 + BEEB_RAM_OFFSET
L_D41A = $D41A + BEEB_RAM_OFFSET
L_D41B = $D41B + BEEB_RAM_OFFSET
L_D41C = $D41C + BEEB_RAM_OFFSET
L_D41D = $D41D + BEEB_RAM_OFFSET
L_D41E = $D41E + BEEB_RAM_OFFSET
L_D41F = $D41F + BEEB_RAM_OFFSET

L_D440 = $D440 + BEEB_RAM_OFFSET

L_D800 = $D800 + BEEB_RAM_OFFSET		; COLOR RAM
L_D805 = $D805 + BEEB_RAM_OFFSET		; COLOR RAM
L_D900 = $D900 + BEEB_RAM_OFFSET		; COLOR RAM
L_DA00 = $DA00 + BEEB_RAM_OFFSET		; COLOR RAM
L_DB00 = $DB00 + BEEB_RAM_OFFSET		; COLOR RAM
L_DAB6 = $DAB6 + BEEB_RAM_OFFSET		; COLOR RAM
L_DAAC = $DAAC + BEEB_RAM_OFFSET		; COLOR RAM
L_DACB = $DACB + BEEB_RAM_OFFSET		; COLOR RAM
L_DBDA = $DBDA + BEEB_RAM_OFFSET		; COLOR RAM
L_DBDB = $DBDB + BEEB_RAM_OFFSET		; COLOR RAM
L_DBCC = $DBCC + BEEB_RAM_OFFSET		; COLOR RAM
L_DBCD = $DBCD + BEEB_RAM_OFFSET		; COLOR RAM

L_DC00 = $DC00 + BEEB_RAM_OFFSET
L_DC01 = $DC01 + BEEB_RAM_OFFSET
L_DC02 = $DC02 + BEEB_RAM_OFFSET
L_DC03 = $DC03 + BEEB_RAM_OFFSET
L_DC04 = $DC04 + BEEB_RAM_OFFSET
L_DC05 = $DC05 + BEEB_RAM_OFFSET
L_DC06 = $DC06 + BEEB_RAM_OFFSET
L_DC07 = $DC07 + BEEB_RAM_OFFSET
L_DC08 = $DC08 + BEEB_RAM_OFFSET
L_DC09 = $DC09 + BEEB_RAM_OFFSET
L_DC0A = $DC0A + BEEB_RAM_OFFSET
L_DC0B = $DC0B + BEEB_RAM_OFFSET
L_DC0C = $DC0C + BEEB_RAM_OFFSET
L_DC0D = $DC0D + BEEB_RAM_OFFSET
L_DC0E = $DC0E + BEEB_RAM_OFFSET
L_DC0F = $DC0F + BEEB_RAM_OFFSET

L_DCE0 = $DCE0 + BEEB_RAM_OFFSET		; SPARE RAM? CAN'T STAY HERE ON BEEB!

L_DD00 = $DD00 + BEEB_RAM_OFFSET
L_DD02 = $DD02 + BEEB_RAM_OFFSET
L_DD0D = $DD0D + BEEB_RAM_OFFSET

L_DE00 = $DE00 + BEEB_RAM_OFFSET		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DE01 = $DE01 + BEEB_RAM_OFFSET		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DE02 = $DE02 + BEEB_RAM_OFFSET		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DE0C = $DE0C + BEEB_RAM_OFFSET		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DE0D = $DE0D + BEEB_RAM_OFFSET		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DE0E = $DE0E + BEEB_RAM_OFFSET		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DF00 = $DF00 + BEEB_RAM_OFFSET		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DF01 = $DF01 + BEEB_RAM_OFFSET		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DF02 = $DF02 + BEEB_RAM_OFFSET		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DF0C = $DF0C + BEEB_RAM_OFFSET		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DF0D = $DF0D + BEEB_RAM_OFFSET		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DF0E = $DF0E + BEEB_RAM_OFFSET		; SPARE RAM? CAN'T STAY HERE ON BEEB!


; *****************************************************************************
; C64 KERNEL DEFINES
; *****************************************************************************

; Not sure what this is used for - depends on which C64 bank is paged in?
L_A000 = $A000		; Cold Start Vector?

KERNEL_RAM_VECTORS = $FD30

KERNEL_READST	= $FFB7	; Read the I/O Status Word
KERNEL_SETLFS	= $FFBA	; Set Logical File Number, Device Number, and Secondary Address
KERNEL_SETNAM	= $FFBD	; Set Filename Parameters
KERNEL_OPEN 	= $FFC0	; Open a Logical I/O File
KERNEL_CLOSE	= $FFC3	; Close a Logical I/O File
KERNEL_LOAD		= $FFD5	; Load RAM from a device
KERNEL_SAVE		= $FFD8	; Save RAM to a device
KERNEL_GETIN	= $FFE4	; Get One Byte from the Input Device

VIC_SP0X 	= L_D000	; Sprite 0 Horizontal Position
VIC_SP0Y	= L_D001 	; Sprite 0 Vertical Position
VIC_SP1X	= L_D002 	; Sprite 1 Horizontal Position
VIC_SP1Y	= L_D003 	; Sprite 1 Vertical Position
VIC_SP2X	= L_D004	; Sprite 2 Horizontal Position
VIC_SP2Y	= L_D005	; Sprite 2 Vertical Position
VIC_SP3X	= L_D006	; Sprite 3 Horizontal Position
VIC_SP3Y	= L_D007	; Sprite 3 Vertical Position
VIC_SP4X	= L_D008	; Sprite 4 Horizontal Position
VIC_SP4Y	= L_D009	; Sprite 4 Vertical Position
VIC_SP5X	= L_D00A	; Sprite 5 Horizontal Position
VIC_SP5Y	= L_D00B	; Sprite 5 Vertical Position
VIC_SP6X	= L_D00C	; Sprite 6 Horizontal Position
VIC_SP6Y	= L_D00D	; Sprite 6 Vertical Position
VIC_SP7X	= L_D00E	; Sprite 7 Horizontal Position
VIC_SP7Y	= L_D00F	; Sprite 7 Vertical Position
VIC_MSIGX	= L_D010 	; Most Significant Bits of Sprites 0-7 Horizontal Position

VIC_SCROLY	= L_D011	; Vertical Fine Scrolling and Control Register
VIC_RASTER	= L_D012	; Read Current Raster Scan Line/Write Line to Compare for Raster IRQ
VIC_SPENA	= L_D015	; Sprite Enable Register
VIC_SCROLX	= L_D016	; Horizontal Fine Scrolling and Control Register
VIC_YXPAND	= L_D017	; Sprite Vertical Expansion Register
VIC_VMCSB	= L_D018	; VIC-II Chip Memory Control Register
VIC_VICIRQ	= L_D019	; VIC Interrupt Flag Register
VIC_IRQMASK	= L_D01A	; IRQ Mask Register
VIC_SPBGPR	= L_D01B	; Sprite to Foreground Display Priority Register
VIC_SPMC	= L_D01C	; Sprite Multicolor Registers
VIC_XXPAND	= L_D01D	; Sprite Horizontal Expansion Register
VIC_SPSPCL	= L_D01E	; Sprite to Sprite Collision Register
VIC_SPBGCL	= L_D01F	; Sprite to Foreground Collision Register

VIC_EXTCOL	= L_D020	; Border Color Register
VIC_BGCOL0	= L_D021	; Background Color 0
VIC_BGCOL1	= L_D022	; Background Color 1
VIC_BGCOL2	= L_D023	; Background Color 2
VIC_BGCOL3	= L_D024	; Background Color 3
VIC_SPMC0	= L_D025	; Sprite Multicolor Register 0
VIC_SPMC1	= L_D026	; Sprite Multicolor Register 1
VIC_SP0COL	= L_D027	; Sprite 0 Color Register (the default color value is 1, white)
VIC_SP1COL	= L_D028	; Sprite 1 Color Register (the default color value is 2, red)
VIC_SP2COL	= L_D029	; Sprite 2 Color Register (the default color value is 3, cyan)
VIC_SP3COL	= L_D02A	; Sprite 3 Color Register (the default color value is 4, purple)
VIC_SP4COL	= L_D02B	; Sprite 4 Color Register (the default color value is 5, green)
VIC_SP5COL	= L_D02C	; Sprite 5 Color Register (the default color value is 6, blue)
VIC_SP6COL	= L_D02D	; Sprite 6 Color Register (the default color value is 7, yellow)
VIC_SP7COL	= L_D02E	; Sprite 7 Color Register (the default color value is 12, medium gray)

SID_FRELO1	= L_D400	; Voice 1 Frequency Control (low byte)
SID_FREHI1	= L_D401	; Voice 1 Frequency Control (high byte)
SID_PWLO1	= L_D402	; Voice 1 Pulse Waveform Width (low byte)
SID_PWHI1	= L_D403	; Voice 1 Pulse Waveform Width (high nybble)
SID_VCREG1	= L_D404	; Voice 1 Control Register
SID_ATDCY1	= L_D405	; Voice 1 Attack/Decay Register
SID_SUREL1	= L_D406	; Voice 1 Sustain/Release Control Register

SID_FRELO2	= L_D407	; Voice 2 Frequency Control (low byte)
SID_FREHI2	= L_D408	; Voice 2 Frequency Control (high byte)
SID_PWLO2	= L_D409	; Voice 2 Pulse Waveform Width (low byte)
SID_PWHI2	= L_D40A	; Voice 2 Pulse Waveform Width (high nybble)
SID_VCREG2	= L_D40B	; Voice 2 Control Register
SID_ATDCY2	= L_D40C	; Voice 2 Attack/Decay Register
SID_SUREL2	= L_D40D	; Voice 2 Sustain/Release Control Register

SID_FRELO3	= L_D40E	; Voice 3 Frequency Control (low byte)
SID_FREHI3	= L_D40F	; Voice 3 Frequency Control (high byte)
SID_PWLO3	= L_D410	; Voice 3 Pulse Waveform Width (low byte)
SID_PWHI3	= L_D411	; Voice 3 Pulse Waveform Width (high nybble)
SID_VCREG3	= L_D412	; Voice 3 Control Register
SID_ATDCY3	= L_D413	; Voice 3 Attack/Decay Register
SID_SUREL3	= L_D414	; Voice 3 Sustain/Release Control Register

SID_CUTLO	= L_D415	; Bits 0-2:  Low portion of filter cutoff frequency
SID_CUTHI	= L_D416	; Filter Cutoff Frequency (high byte)
SID_RESON	= L_D417	; Filter Resonance Control Register
SID_SIGVOL	= L_D418	; Volume and Filter Select Register

CIA1_CIAPRA	= L_DC00	; Data Port Register A
CIA1_CIAPRB	= L_DC01	; Data Port Register B
CIA1_CIDDRA	= L_DC02	; Data Direction Register A
CIA1_CIDDRB	= L_DC03	; Data Direction Register B
CIA1_TIMALO	= L_DC04	; Timer A (low byte)
CIA1_TIMAHI	= L_DC05	; Timer A (high byte)
CIA1_TIMBLO	= L_DC06	; Timer B (low byte)
CIA1_TIMBHI	= L_DC07	; Timer B (high byte)
CIA1_CIAICR	= L_DC0D	; Interrupt Control Register
CIA1_CIACRA	= L_DC0E	; Control Register A
CIA1_CIACRB	= L_DC0F	; Control Register B

CIA2_CI2PRA = L_DD00
CIA2_C2DDRA = L_DD02
CIA2_CIAICR	= L_DD0D	; Interrupt Control Register

; *****************************************************************************
; VARIABLES
; *****************************************************************************
BEEB_ZP_OFFSET = &900

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
ZP_12	= $12
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
ZP_1E	= $1E
ZP_1F	= $1F
ZP_20	= $20
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
ZP_2F	= $2F
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
ZP_5C	= $5C
ZP_5D	= $5D
ZP_5E	= $5E
ZP_5F	= $5F
ZP_60	= $60
ZP_61	= $61
ZP_62	= $62
ZP_63	= $63
ZP_64	= $64
ZP_66	= $66
ZP_68	= $68
ZP_69	= $69
ZP_6A	= $6A
ZP_6B	= $6B
ZP_6C	= $6C
ZP_6D	= $6D
ZP_6E	= $6E
ZP_6F	= $6F
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
ZP_90	= $90 + BEEB_ZP_OFFSET
ZP_91	= $91 + BEEB_ZP_OFFSET
ZP_92	= $92 + BEEB_ZP_OFFSET
ZP_93	= $93 + BEEB_ZP_OFFSET
ZP_94	= $94 + BEEB_ZP_OFFSET
ZP_95	= $95 + BEEB_ZP_OFFSET
; $96
ZP_97	= $97 + BEEB_ZP_OFFSET
ZP_98	= $98
ZP_99	= $99
ZP_9A	= $9A
ZP_9B	= $9B
ZP_9C	= $9C + BEEB_ZP_OFFSET
ZP_9D	= $9D + BEEB_ZP_OFFSET
ZP_9E	= $9E + BEEB_ZP_OFFSET
ZP_9F	= $9F + BEEB_ZP_OFFSET
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
ZP_CA	= $CA
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
ZP_E0	= $E0
ZP_E1	= $E1
ZP_E3	= $E3
ZP_E4	= $E4 + BEEB_ZP_OFFSET
ZP_E7	= $E7 + BEEB_ZP_OFFSET
ZP_E8	= $E8 + BEEB_ZP_OFFSET
ZP_E9	= $E9 + BEEB_ZP_OFFSET
ZP_EA	= $EA + BEEB_ZP_OFFSET
ZP_EB	= $EB + BEEB_ZP_OFFSET
ZP_EC	= $EC + BEEB_ZP_OFFSET
ZP_ED	= $ED + BEEB_ZP_OFFSET
ZP_EE	= $EE + BEEB_ZP_OFFSET
ZP_EF	= $EF + BEEB_ZP_OFFSET
ZP_F0	= $90;$F0
ZP_F1	= $91;$F1
ZP_F2	= $F2 + BEEB_ZP_OFFSET
ZP_F4	= $94;$F4
ZP_F5	= $95;$F5
ZP_F6	= $96;$F6
ZP_F7	= $97;$F7
ZP_F8	= $9C;$F8
ZP_F9	= $9D;$F9
ZP_FA	= $FA + BEEB_ZP_OFFSET
ZP_FB	= $FB + BEEB_ZP_OFFSET
ZP_FC	= $FC + BEEB_ZP_OFFSET
ZP_FD	= $FD + BEEB_ZP_OFFSET
ZP_FE	= $FE + BEEB_ZP_OFFSET

; *****************************************************************************
; VARIABLES IN LOWER RAM
; *****************************************************************************

L_0100	= $0100
L_0101	= $0101
L_0102	= $0102
L_0103	= $0103
L_0104	= $0104
L_0105	= $0105
L_0106	= $0106
L_0107	= $0107
L_0108	= $0108
L_0109	= $0109
L_010A	= $010A
L_010B	= $010B
L_010C	= $010C
L_010D	= $010D
L_010E	= $010E
L_010F	= $010F
L_0110	= $0110
L_0111	= $0111
L_0112	= $0112
L_0113	= $0113
L_0114	= $0114
L_0115	= $0115
L_0118	= $0118
L_0119	= $0119
L_011A	= $011A
L_011B	= $011B
L_011E	= $011E
L_011F	= $011F
L_0120	= $0120
L_0121	= $0121
L_0122	= $0122
L_0123	= $0123
L_0124	= $0124
L_0125	= $0125
L_0126	= $0126
L_0130	= $0130
L_0131	= $0131
L_0132	= $0132
L_0133	= $0133
L_0134	= $0134
L_0135	= $0135
L_0136	= $0136
L_0137	= $0137
L_0138	= $0138
L_0139	= $0139
L_013A	= $013A
L_013B	= $013B
L_013C	= $013C
L_013D	= $013D
L_013E	= $013E
L_013F	= $013F
L_0140	= $0140
L_0141	= $0141
L_0142	= $0142
L_0145	= $0145
L_0148	= $0148
L_0149	= $0149
L_014A	= $014A
L_014B	= $014B
L_014C	= $014C
L_014D	= $014D
L_014E	= $014E
L_014F	= $014F
L_0150	= $0150
L_0151	= $0151
L_0154	= $0154
L_0156	= $0156
L_0157	= $0157
L_0159	= $0159
L_015A	= $015A
L_015B	= $015B
L_015C	= $015C
L_015D	= $015D
L_015E	= $015E
L_015F	= $015F
L_0160	= $0160
L_0161	= $0161
L_0166	= $0166
L_0167	= $0167
L_016A	= $016A
L_016B	= $016B
L_016C	= $016C
L_016D	= $016D
L_016E	= $016E
L_016F	= $016F
L_0170	= $0170
L_0171	= $0171
L_0172	= $0172
L_0173	= $0173
L_0174	= $0174
L_0175	= $0175
L_0176	= $0176
L_0177	= $0177
L_0178	= $0178
L_0179	= $0179
L_017A	= $017A
L_017B	= $017B
L_017C	= $017C
L_017D	= $017D
L_017E	= $017E
L_017F	= $017F
L_0180	= $0180
L_0181	= $0181
L_0182	= $0182
L_0183	= $0183
L_0184	= $0184
L_0188	= $0188
L_0189	= $0189
L_018A	= $018A
L_0190	= $0190
L_01C1	= $01C1

\\ These can't stay here on BEEB obviously!!
BEEB_VEC_OFFSET = $600

L_0200	= $0200 + BEEB_VEC_OFFSET
L_0201	= $0201 + BEEB_VEC_OFFSET
L_0240	= $0240 + BEEB_VEC_OFFSET
L_0241	= $0241 + BEEB_VEC_OFFSET
L_0242	= $0242 + BEEB_VEC_OFFSET
L_0243	= $0243 + BEEB_VEC_OFFSET
L_0280	= $0280 + BEEB_VEC_OFFSET
L_0291	= $0291 + BEEB_VEC_OFFSET
L_02C0	= $02C0 + BEEB_VEC_OFFSET

; Camera matrices?
L_0300	= $0300
L_0314	= $0314
L_0380	= $0380

; Some sort of track variables?
road_section_angle_and_piece	= $0400
L_042A	= $042A
road_section_xz_positions	= $044E
L_0480	= $0480
left_y_coordinate_IDs	= $049C
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

ORG &E00
GUARD &4000

INCLUDE "game/core-ram.asm"
INCLUDE "game/beeb-dll.asm"
.core_data_start
INCLUDE "game/core-data.asm"
.core_data_end

; *****************************************************************************
\\ Core RAM area
; *****************************************************************************

PRINT "--------"
PRINT "CORE RAM"
PRINT "--------"
PRINT "Start =", ~core_start
PRINT "End =", ~P%
PRINT "Size =", ~(P% - core_start)
PRINT "Free =", ~(&4000 - P%)
PRINT "DLL Jump Table Size =", ~(beeb_dll_end - beeb_dll_start)
PRINT "Core Data Size =", ~(core_data_end - core_data_start)
PRINT "--------"
SAVE "Core", core_start, P%, 0
PRINT "--------"

CLEAR &4000, &8000
ORG $4000
GUARD &8000

.boot_start

; *****************************************************************************
; BEEB APP ENTRY
; *****************************************************************************

.scr_entry
{
	; BEEB TODO SET VECTORS
	; BEEB TODO SET INTERRUPTS etc.

	; BEEB SET SCREEN MODE 5

	LDA #22
	JSR oswrch
	LDA #BEEB_SCREEN_MODE
	JSR oswrch

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

	; MISCELLANEOUS DATA

	LDX #LO(data_filename)
	LDY #HI(data_filename)
	LDA #HI(boot_data_start)
	JSR disksys_load_file

	\\ SCR loader copies data from screen RAM to Hazel
	\\ Manually moved much of this data to Hazel Module

\		ldx #$7F		;40A5 A2 7F
\.L_40A7	lda L_5780,X	;40A7 BD 80 57
\		sta L_C280,X	;40AA 9D 80 C2
\		dex				;40AD CA
\		bpl L_40A7		;40AE 10 F7         ; copy $80 bytes from $5780 to $C280

\		ldx #$00		;414B A2 00
\.L_414D	lda L_72E0,X	;414D BD E0 72
\.L_4150	sta L_C000,X	;4150 9D 00 C0
\		lda L_7420,X	;4153 BD 20 74
\		sta L_C100,X	;4156 9D 00 C1
\		dex				;4159 CA
\		bne L_414D		;415A D0 F1     ; copy 2x pages from $72E0 to $C000

\		ldx #$17		;415C A2 17
\.L_415E	lda L_75A0,X	;415E BD A0 75
\		sta L_C200,X	;4161 9D 00 C2
\		lda L_7608,X	;4164 BD 08 76
\		sta L_C218,X	;4167 9D 18 C2
\		lda L_7560,X	;416A BD 60 75
\		sta L_C230,X	;416D 9D 30 C2
\		lda L_7648,X	;4170 BD 48 76
\		sta L_C248,X	;4173 9D 48 C2
\		dex				;4176 CA
\		bpl L_415E		;4177 10 E5     ; copy $18*4 = 96 bytes from $75XX to C2XX

	\\ Final copy stage uses fn in SWRAM so has to be after module load

		ldx #$00		;4253 A2 00
		lda #$34		;4255 A9 34
		jsr cart_sysctl		;4257 20 25 87  ; copy stuff using sysctl

	\\ HAZEL must be last as stomping on FS workspace

	LDX #LO(hazel_filename)
	LDY #HI(hazel_filename)
	LDA #HI(hazel_start)
	JSR disksys_load_file

	\\ Not sure what this is doing! Copying from C64 COLOR RAM
	\\ $D800-$DBFF Color RAM

		ldx #$0B		;40B0 A2 0B
.L_40B2	lda L_DAB6,X	;40B2 BD B6 DA		; 
		sta L_C6C0,X	;40B5 9D C0 C6
		dex				;40B8 CA
		bpl L_40B2		;40B9 10 F7         ; copy 13 bytes from $DAB6 to $C6C0

	; BEEB SET SCREEN TO 8K

	LDA #6:STA &FE00		; R6 = vertical displayed
	LDA #25:STA &FE01		; 25 rows = 200 scanlines

	LDA #12:STA &FE00
	LDA #HI(BEEB_SCREEN_ADDR/8):STA &FE01

	LDA #13:STA &FE00
	LDA #LO(BEEB_SCREEN_ADDR/8):STA &FE01

		jmp game_start		;425A 4C 22 3B

        ; ^^^ JUMP TO GAME START
}

.core_filename EQUS "Core", 13
.kernel_filename EQUS "Kernel", 13
.cart_filename EQUS "Cart", 13
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
PRINT "Start =", ~boot_start
PRINT "End =", ~boot_end
PRINT "Size =", ~(boot_end - boot_start)
PRINT "Entry =", ~scr_entry
PRINT "--------"
SAVE "Loader", boot_start, boot_end, scr_entry
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

L_4000	= screen1_address+$0000
L_4001	= screen1_address+$0001
L_4008	= screen1_address+$0008
L_400C	= screen1_address+$000c
L_400D	= screen1_address+$000d
L_400E	= screen1_address+$000e
L_4010	= screen1_address+$0010
L_4020	= screen1_address+$0020	
L_40A0	= screen1_address+$00a0
L_40DC	= screen1_address+$00dc
L_40E0	= screen1_address+$00e0
L_4100	= screen1_address+$0100
L_410C	= screen1_address+$010c
L_410D	= screen1_address+$010d
L_410E	= screen1_address+$010e
L_4120	= screen1_address+$0120
L_4130	= screen1_address+$0130
L_4136	= screen1_address+$0136			

L_4150	= screen1_address+$0150
L_41E0	= screen1_address+$01e0
L_4268	= screen1_address+$0268
L_42A0	= screen1_address+$02a0
L_4300	= screen1_address+$0300
L_43E0	= screen1_address+$03e0
L_4520	= screen1_address+$0520
L_4660	= screen1_address+$0660
L_47A0	= screen1_address+$07a0
L_48E0	= screen1_address+$08e0
L_4A20	= screen1_address+$0a20
L_4B60	= screen1_address+$0b60
L_4CA0	= screen1_address+$0ca0
L_4DE0	= screen1_address+$0de0
L_4F20	= screen1_address+$0f20
L_5060	= screen1_address+$1060
L_51A0 	= screen1_address+$11a0
L_52E0 	= screen1_address+$12e0
L_5420 	= screen1_address+$1420
L_5560 	= screen1_address+$1560
L_5578 	= screen1_address+$1578
L_55A0 	= screen1_address+$15a0
L_5608	= screen1_address+$1608
L_5640	= screen1_address+$1640
L_5648	= screen1_address+$1648
L_5658	= screen1_address+$1658
L_5690	= screen1_address+$1690
L_56A0	= screen1_address+$16a0
L_5720	= screen1_address+$1720

\\ Data at L_5780 manually moved to destination at L_C280

L_5798	= screen1_address+$1798
L_57C0	= screen1_address+$17c0
L_57C8	= screen1_address+$17c8
L_57D0	= screen1_address+$17d0
L_5860	= screen1_address+$1860
L_58F0	= screen1_address+$18f0
L_5C00	= screen1_address+$1c00
L_5D00	= screen1_address+$1d00
L_5E00	= screen1_address+$1e00
L_5F00	= screen1_address+$1f00

; sprite pointers?
L_5FF8	= screen1_address+$1ff8
L_5FF9	= screen1_address+$1ff9
L_5FFA	= screen1_address+$1ffa
L_5FFB	= screen1_address+$1ffb
L_5FFC	= screen1_address+$1ffc
L_5FFD	= screen1_address+$1ffd
L_5FFF	= screen1_address+$1fff

L_6026	= screen2_address+$0026
L_6027	= screen2_address+$0027
L_6028	= screen2_address+$0028
L_6130	= screen2_address+$0130

L_6270	= screen2_address+$0270
L_62A0	= screen2_address+$02a0
L_63B0	= screen2_address+$03b0
L_63E0	= screen2_address+$03e0
L_64F0	= screen2_address+$04f0
L_6520	= screen2_address+$0520
L_6660	= screen2_address+$0660
L_66E0	= screen2_address+$06e0
L_67A0	= screen2_address+$07a0
L_68E0	= screen2_address+$08e0
L_6920	= screen2_address+$0920
L_6A20	= screen2_address+$0a20
L_6B60	= screen2_address+$0b60
L_6BA0	= screen2_address+$0ba0
L_6CA0	= screen2_address+$0ca0
L_6D20	= screen2_address+$0d20
L_6D6A	= screen2_address+$0d6a
L_6DE0	= screen2_address+$0de0
L_6F20	= screen2_address+$0f20
L_7060	= screen2_address+$1060
L_71A0	= screen2_address+$11a0
L_7658  = screen2_address+$1658
L_76A0	= screen2_address+$16a0 ; the bottom of the left wheel ($7680 is beginning C64 row)
L_7798	= screen2_address+$1798 ; the bottom of the right wheel
L_77E0	= screen2_address+$17e0 ; bottom of the left wheel ($77c0 is beginning C64 row)
L_78D8	= screen2_address+$18d8 ; the bottom of the right wheel
L_7AA6	= screen2_address+$1aa6 ; left upper corner of the speedometer ($7A40 is beginning C64 row)
L_7AA7	= screen2_address+$1aa7 ; left upper corner of the speedometer
L_7B00	= screen2_address+$1b00
L_7C00	= screen2_address+$1c00
L_7C53	= screen2_address+$1c53
L_7C74	= screen2_address+$1c74
L_7D00	= screen2_address+$1d00
L_7E00	= screen2_address+$1e00 ; OK
L_7F00	= screen2_address+$1f00 ; OK

		; space behind the screen 2 ($7f40-$7fff) - 192 byte

L_7F80	= screen2_address+$1f80
L_7F81	= screen2_address+$1f81
L_7F82	= screen2_address+$1f82
L_7FC0	= screen2_address+$1fc0
L_7FC1	= screen2_address+$1fc1
L_7FC2	= screen2_address+$1fc2

ORG &7200
.boot_data_start
		skip &E0

.L_72E0	skip &100
\ Data moved to Cart RAM manually
		EQUB $69,$69,$69,$69,$69,$69,$69,$69,$58,$58,$58,$58,$58,$58,$58,$58
		EQUB $1B,$1B,$1B,$16,$16,$16,$16,$16,$6A,$6A,$5A,$5A,$5A,$56,$D6,$D6
		EQUB $AB,$AF,$AD,$AD,$BD,$BD,$B5,$F5,$68,$68,$68,$68,$68,$68,$68,$68
		EQUB $25,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$69,$69,$69,$69,$69,$69,$69,$69

.L_7420 skip &100
\ Data moved to Cart RAM manually
		EQUB $69,$69,$69,$69,$69,$69,$69,$69,$58,$5A,$5A,$5A,$5A,$5A,$5A,$5A
		EQUB $29,$29,$29,$29,$29,$29,$29,$29,$EA,$FA,$7A,$7A,$7E,$7E,$5E,$5F
		EQUB $A5,$95,$95,$95,$95,$55,$55,$55,$68,$68,$68,$68,$68,$68,$68,$68
		EQUB $A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$69,$69,$69,$69,$69,$69,$69,$69

.L_7560 skip $18
\ Data moved to Cart RAM manually
.L_7578	EQUB $F0,$50,$08,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00,$40,$80,$80
		EQUB $02,$02,$02,$02,$02,$09,$09,$15,$02,$06,$62,$11,$11,$11,$11,$05
		EQUB $45,$45,$44,$40,$50,$90,$90,$90

.L_75A0	skip $18
\ Data moved to Cart RAM manually
		EQUB $EA,$9A,$98,$50,$58,$6C,$7F,$7F
		EQUB $00,$AA,$5A,$15,$00,$00,$04,$19,$00,$AA,$A5,$54,$00,$00,$01,$40
		EQUB $28,$A4,$07,$0F,$10,$5F,$40,$80,$00,$00,$F1,$A1,$01,$F1,$01,$01
		EQUB $C0,$C0,$C5,$8A,$80,$85,$80,$80,$28,$3A,$5C,$50,$00,$57,$03,$03
		EQUB $00,$AA,$5A,$05,$00,$00,$40,$40,$00,$AA,$A5,$54,$00,$00,$41,$55
		EQUB $AA,$A6,$85,$35,$19,$39,$36,$F8

.L_7608	skip $18
\ Data moved to Cart RAM manually
		EQUB $81,$81,$91,$51,$51,$11,$11,$41
		EQUB $80,$90,$99,$94,$94,$94,$84,$44,$80,$80,$80,$80,$A0,$60,$68,$55
		EQUB $00,$00,$00,$00,$00,$01,$02,$02
.L_7640	EQUB $0F,$05,$20,$80,$80,$00,$00,$00

.L_7648 skip $18
\ Data moved to Cart RAM manually
		EQUB $69,$69,$69,$69,$69,$69,$69,$69
		EQUB $5A,$5A,$5A,$5A,$5A,$5A,$5A,$5A,$29,$29,$29,$29,$29,$29,$29,$29
		EQUB $5A,$56,$56,$56,$56,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
		EQUB $68,$68,$68,$68,$68,$68,$68,$68,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5
		EQUB $69,$69,$69,$69,$69,$69,$69,$69
.boot_data_end

; *****************************************************************************
\\ Boot DATA area
; *****************************************************************************

PRINT "---------"
PRINT "BOOT DATA"
PRINT "---------"
PRINT "Start =", ~boot_data_start
PRINT "End =", ~boot_data_end
PRINT "Size =", ~(boot_data_end - boot_data_start)
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

CLEAR &8000, &C000
ORG &8000
GUARD &C000

INCLUDE "game/cart-ram.asm"

; *****************************************************************************
\\ Cart RAM area
; *****************************************************************************

PRINT "--------"
PRINT "CART RAM"
PRINT "--------"
PRINT "Start =", ~cart_start
PRINT "End =", ~cart_end
PRINT "Size =", ~(cart_end - cart_start)
PRINT "Free =", ~(&C000 - cart_end)
PRINT "--------"
SAVE "Cart", cart_start, cart_end, 0
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

CLEAR &C000, &E000
ORG &C000
;GUARD &E000

INCLUDE "game/hazel-ram.asm"

; *****************************************************************************
; HAZEL RAM Area
; *****************************************************************************

PRINT "---------"
PRINT "HAZEL RAM"
PRINT "---------"
PRINT "Start =", ~hazel_start
PRINT "End =", ~hazel_end
PRINT "Size =", ~(hazel_end - hazel_start)
PRINT "Free =", ~(&E000 - hazel_end)
PRINT "--------"
SAVE "Hazel", hazel_start, hazel_end, 0
PRINT "--------"

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

CLEAR &8000,&C000
ORG &8000
GUARD &C000

INCLUDE "game/kernel-ram.asm"

; *****************************************************************************
; KERNEL RAM Area
; *****************************************************************************

PRINT "-----------"
PRINT "KERNEL RAM"
PRINT "-----------"
PRINT "Start =", ~kernel_start
PRINT "End =", ~kernel_end
PRINT "Size =", ~(kernel_end - kernel_start)
PRINT "Free =", ~(&C000 - kernel_end)
PRINT "-------"
SAVE "Kernel", kernel_start, kernel_end, 0
PRINT "-------"
