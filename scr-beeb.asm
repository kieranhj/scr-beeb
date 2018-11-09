; *****************************************************************************
; STUNT CAR RACER
; *****************************************************************************

; *****************************************************************************
; GLOBAL DEFINES
; *****************************************************************************

_TODO = FALSE
_NOT_BEEB = FALSE

; *****************************************************************************
; C64 KERNEL DEFINES
; *****************************************************************************

KERNEL_READST	= $FFB7	; Read the I/O Status Word
KERNEL_SETLFS	= $FFBA	; Set Logical File Number, Device Number, and Secondary Address
KERNEL_SETNAM	= $FFBD	; Set Filename Parameters
KERNEL_OPEN 	= $FFC0	; Open a Logical I/O File
KERNEL_CLOSE	= $FFC3	; Close a Logical I/O File
KERNEL_LOAD		= $FFD5	; Load RAM from a device
KERNEL_SAVE		= $FFD8	; Save RAM to a device
KERNEL_GETIN	= $FFE4	; Get One Byte from the Input Device

VIC_SP0X 	= $D000	; Sprite 0 Horizontal Position
VIC_SP0Y	= $D001 ; Sprite 0 Vertical Position
VIC_SP1X	= $D002 ; Sprite 1 Horizontal Position
VIC_SP1Y	= $D003 ; Sprite 1 Vertical Position
VIC_SP2X	= $D004	; Sprite 2 Horizontal Position
VIC_SP2Y	= $D005	; Sprite 2 Vertical Position
VIC_SP3X	= $D006	; Sprite 3 Horizontal Position
VIC_SP3Y	= $D007	; Sprite 3 Vertical Position
VIC_SP4X	= $D008	; Sprite 4 Horizontal Position
VIC_SP4Y	= $D009	; Sprite 4 Vertical Position
VIC_SP5X	= $D00A	; Sprite 5 Horizontal Position
VIC_SP5Y	= $D00B	; Sprite 5 Vertical Position
VIC_SP6X	= $D00C	; Sprite 6 Horizontal Position
VIC_SP6Y	= $D00D	; Sprite 6 Vertical Position
VIC_SP7X	= $D00E	; Sprite 7 Horizontal Position
VIC_SP7Y	= $D00F	; Sprite 7 Vertical Position
VIC_MSIGX	= $D010 ; Most Significant Bits of Sprites 0-7 Horizontal Position

VIC_SCROLY	= $D011	; Vertical Fine Scrolling and Control Register
VIC_RASTER	= $D012	; Read Current Raster Scan Line/Write Line to Compare for Raster IRQ
VIC_SPENA	= $D015	; Sprite Enable Register
VIC_SCROLX	= $D016	; Horizontal Fine Scrolling and Control Register
VIC_YXPAND	= $D017	; Sprite Vertical Expansion Register
VIC_VMCSB	= $D018	; VIC-II Chip Memory Control Register
VIC_VICIRQ	= $D019	; VIC Interrupt Flag Register
VIC_IRQMASK	= $D01A	; IRQ Mask Register
VIC_SPBGPR	= $D01B	; Sprite to Foreground Display Priority Register
VIC_SPMC	= $D01C	; Sprite Multicolor Registers
VIC_XXPAND	= $D01D	; Sprite Horizontal Expansion Register
VIC_SPSPCL	= $D01E	; Sprite to Sprite Collision Register
VIC_SPBGCL	= $D01F	; Sprite to Foreground Collision Register

VIC_EXTCOL	= $D020	; Border Color Register
VIC_BGCOL0	= $D021	; Background Color 0
VIC_BGCOL1	= $D022	; Background Color 1
VIC_BGCOL2	= $D023	; Background Color 2
VIC_BGCOL3	= $D024	; Background Color 3
VIC_SPMC0	= $D025	; Sprite Multicolor Register 0
VIC_SPMC1	= $D026	; Sprite Multicolor Register 1
VIC_SP0COL	= $D027	; Sprite 0 Color Register (the default color value is 1, white)
VIC_SP1COL	= $D028	; Sprite 1 Color Register (the default color value is 2, red)
VIC_SP2COL	= $D029	; Sprite 2 Color Register (the default color value is 3, cyan)
VIC_SP3COL	= $D02A	; Sprite 3 Color Register (the default color value is 4, purple)
VIC_SP4COL	= $D02B	; Sprite 4 Color Register (the default color value is 5, green)
VIC_SP5COL	= $D02C	; Sprite 5 Color Register (the default color value is 6, blue)
VIC_SP6COL	= $D02D	; Sprite 6 Color Register (the default color value is 7, yellow)
VIC_SP7COL	= $D02E	; Sprite 7 Color Register (the default color value is 12, medium gray)

SID_FRELO1	= $D400	; Voice 1 Frequency Control (low byte)
SID_FREHI1	= $D401	; Voice 1 Frequency Control (high byte)
SID_PWLO1	= $D402	; Voice 1 Pulse Waveform Width (low byte)
SID_PWHI1	= $D403	; Voice 1 Pulse Waveform Width (high nybble)
SID_VCREG1	= $D404	; Voice 1 Control Register
SID_ATDCY1	= $D405	; Voice 1 Attack/Decay Register
SID_SUREL1	= $D406	; Voice 1 Sustain/Release Control Register

SID_FRELO2	= $D407	; Voice 2 Frequency Control (low byte)
SID_FREHI2	= $D408	; Voice 2 Frequency Control (high byte)
SID_PWLO2	= $D409	; Voice 2 Pulse Waveform Width (low byte)
SID_PWHI2	= $D40A	; Voice 2 Pulse Waveform Width (high nybble)
SID_VCREG2	= $D40B	; Voice 2 Control Register
SID_ATDCY2	= $D40C	; Voice 2 Attack/Decay Register
SID_SUREL2	= $D40D	; Voice 2 Sustain/Release Control Register

SID_FRELO3	= $D40E	; Voice 3 Frequency Control (low byte)
SID_FREHI3	= $D40F	; Voice 3 Frequency Control (high byte)
SID_PWLO3	= $D410	; Voice 3 Pulse Waveform Width (low byte)
SID_PWHI3	= $D411	; Voice 3 Pulse Waveform Width (high nybble)
SID_VCREG3	= $D412	; Voice 3 Control Register
SID_ATDCY3	= $D413	; Voice 3 Attack/Decay Register
SID_SUREL3	= $D414	; Voice 3 Sustain/Release Control Register

SID_CUTLO	= $D415	; Bits 0-2:  Low portion of filter cutoff frequency
SID_CUTHI	= $D416	; Filter Cutoff Frequency (high byte)
SID_RESON	= $D417	; Filter Resonance Control Register
SID_SIGVOL	= $D418	; Volume and Filter Select Register

CIA1_CIAPRA	= $DC00	; Data Port Register A
CIA1_CIAPRB	= $DC01	; Data Port Register B
CIA1_CIDDRA	= $DC02	; Data Direction Register A
CIA1_CIDDRB	= $DC03	; Data Direction Register B
CIA1_TIMALO	= $DC04	; Timer A (low byte)
CIA1_TIMAHI	= $DC05	; Timer A (high byte)
CIA1_TIMBLO	= $DC06	; Timer B (low byte)
CIA1_TIMBHI	= $DC07	; Timer B (high byte)
CIA1_CIAICR	= $DC0D	; Interrupt Control Register
CIA1_CIACRA	= $DC0E	; Control Register A
CIA1_CIACRB	= $DC0F	; Control Register B

CIA2_CI2PRA = $DD00
CIA2_C2DDRA = $DD02
CIA2_CIAICR	= $DD0D	; Interrupt Control Register

; *****************************************************************************
; BEEB OS DEFINES
; *****************************************************************************

oswrch = &FFEE

; *****************************************************************************
; VARIABLES
; *****************************************************************************

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
ZP_90	= $90
ZP_91	= $91
ZP_92	= $92
ZP_93	= $93
ZP_94	= $94
ZP_95	= $95
ZP_97	= $97
ZP_98	= $98
ZP_99	= $99
ZP_9A	= $9A
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
ZP_E4	= $E4
ZP_E7	= $E7
ZP_E8	= $E8
ZP_E9	= $E9
ZP_EA	= $EA
ZP_EB	= $EB
ZP_EC	= $EC
ZP_ED	= $ED
ZP_EE	= $EE
ZP_EF	= $EF
ZP_F0	= $F0
ZP_F1	= $F1
ZP_F2	= $F2
ZP_F4	= $F4
ZP_F5	= $F5
ZP_F6	= $F6
ZP_F7	= $F7
ZP_F8	= $F8
ZP_F9	= $F9
ZP_FA	= $FA
ZP_FB	= $FB
ZP_FC	= $FC
ZP_FD	= $FD
ZP_FE	= $FE

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
L_0200	= $0200
L_0201	= $0201
L_0240	= $0240
L_0241	= $0241
L_0242	= $0242
L_0243	= $0243
L_0280	= $0280
L_0291	= $0291
L_02C0	= $02C0
\\ BEEB_STUB

; Camera matrices?
L_0300	= $0300
L_0314	= $0314
L_0380	= $0380

; Some sort of track variables?
L_0400	= $0400
L_0401	= $0401
L_0402	= $0402
L_042A	= $042A
L_044E	= $044E
L_0480	= $0480
L_049C	= $049C
L_04EA	= $04EA
L_04FA	= $04FA

L_0500	= $0500
L_0538	= $0538
L_0586	= $0586
L_05D4	= $05D4
L_05F4	= $05F4

L_0600	= $0600
L_0622	= $0622
L_0670	= $0670
L_06BE	= $06BE
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

ORG $4000

; *****************************************************************************
; BEEB APP ENTRY
; *****************************************************************************

.scr_entry
{
	; BEEB TODO set VECTORS

	; BEEB TODO set INTERRUPTS

	; BEEB SET SCREEN MODE 5

	LDA #22
	JSR oswrch
	LDA #5
	JSR oswrch

	; BEEB TODO SET UP SCREEN RAM?

	; BEEB TODO COPY SCREEN DATA?

		ldx #$7F		;40A5 A2 7F
.L_40A7	lda L_5780,X	;40A7 BD 80 57
		sta L_C280,X	;40AA 9D 80 C2
		dex				;40AD CA
		bpl L_40A7		;40AE 10 F7         ; copy $80 bytes from $5780 to $C280

		ldx #$0B		;40B0 A2 0B
.L_40B2	lda L_DAB6,X	;40B2 BD B6 DA		; 
		sta L_C6C0,X	;40B5 9D C0 C6
		dex				;40B8 CA
		bpl L_40B2		;40B9 10 F7         ; copy 13 bytes from $DAB6 to $C6C0

		ldx #$00		;414B A2 00
.L_414D	lda L_72E0,X	;414D BD E0 72
.L_4150	sta L_C000,X	;4150 9D 00 C0
		lda L_7420,X	;4153 BD 20 74
		sta L_C100,X	;4156 9D 00 C1
		dex				;4159 CA
		bne L_414D		;415A D0 F1     ; copy 2x pages from $72E0 to $C000

		ldx #$17		;415C A2 17
.L_415E	lda L_75A0,X	;415E BD A0 75
		sta L_C200,X	;4161 9D 00 C2
		lda L_7608,X	;4164 BD 08 76
		sta L_C218,X	;4167 9D 18 C2
		lda L_7560,X	;416A BD 60 75
		sta L_C230,X	;416D 9D 30 C2
		lda L_7648,X	;4170 BD 48 76
		sta L_C248,X	;4173 9D 48 C2
		dex				;4176 CA
		bpl L_415E		;4177 10 E5     ; copy $18*4 = 96 bytes from $75XX to C2XX

		ldx #$00		;4253 A2 00
		lda #$34		;4255 A9 34
		jsr sysctl		;4257 20 25 87  ; copy stuff using sysctl

		jmp game_start		;425A 4C 22 3B

        ; ^^^ JUMP TO GAME START
}

; *****************************************************************************
; MAIN RAM: $0800 - $4000
;
; $0800 = Game code? (inc. game_update)
; ...
; $1300 = Some strings.
; $1400 = Rendering code? (inc. font, sprites, lines?)
; ...
; $1C00 = Game code? (inc. AI, )
; ...
; $2700 = Camera code?
; ...
; $2F00 = Rendering code? (track preview)
; $3000 = Front end (game select etc.)
; $3900 = Rendering code? (color map, menus)
; ...
; $3D00 = Main loop?
; ...
; $3F00 = System code? (page flip, VIC control, misc)
; *****************************************************************************

ORG &800

.L_0800
{
	 	jsr $FF90
;L_0803
		lda #$15		;0803 A9 15
		sta VIC_VMCSB		;0805 8D 18 D0			; VIC
		lda #$80		;0808 A9 80
		sta L_0291		;080A 8D 91 02
		lda #$00		;080D A9 00
		sta ZP_9D		;080F 85 9D
		lda #$1B		;0811 A9 1B
		sta VIC_SCROLY		;0813 8D 11 D0			; VIC
		rts				;0816 60
}

.check_debug_keys
{
		sta CIA1_CIDDRB		;0817 8D 03 DC			; CIA1
		lda #$7F		;081A A9 7F
		sta CIA1_CIAPRA		;081C 8D 00 DC			; CIA1
		lda CIA1_CIAPRB		;081F AD 01 DC			; CIA1
		cmp #$BF		;0822 C9 BF
		beq L_0826		;0824 F0 00
;L_0825	= *-1			;!
.L_0826	rts				;0826 60
}

\\ Presumably these are debug fns previously called from above?
IF _TODO
L_0827	lda L_C354		;0827 AD 54 C3
		sta L_C378		;082A 8D 78 C3
		rts				;082D 60
L_082E	txa				;082E 8A
		cmp #$01		;082F C9 01
		beq L_0837		;0831 F0 04
		inc L_C378,X	;0833 FE 78 C3
		rts				;0836 60
L_0837	jmp L_0FD5		;0837 4C D5 0F
ENDIF

ORG &83A

.L_083A	equb $00,$00,$00,$00,$00,$00
.L_0840	equb $01

.game_update			; aka L_0841
{
		jsr update_colour_map_if_dirty		;0841 20 6B 3F
		jsr update_state		;0844 20 EA C9
		jsr L_0897_from_game_update		;0847 20 97 08
		jsr update_colour_map_if_dirty		;084A 20 6B 3F
		jsr L_9CBA_from_game_update		;084D 20 BA 9C
		jsr calculate_camera_sines		;0850 20 32 A1
		jsr update_colour_map_if_dirty		;0853 20 6B 3F
		jsr L_CC31_from_game_update		;0856 20 31 CC
		jsr L_2D89_from_game_update		;0859 20 89 2D
		jsr calculate_friction_and_gravity		;085C 20 84 CC
		jsr L_0A97_from_game_update		;085F 20 97 0A
		jsr update_colour_map_if_dirty		;0862 20 6B 3F
		lda L_C307		;0865 AD 07 C3
		beq L_0885		;0868 F0 1B
		jsr L_0C71_from_game_update		;086A 20 71 0C
		jsr L_2DC2_from_game_update		;086D 20 C2 2D
		jsr L_CCB3_from_game_update		;0870 20 B3 CC
		jsr update_colour_map_if_dirty		;0873 20 6B 3F
		jsr L_0DE8_from_game_update		;0876 20 E8 0D
		jsr L_0CF2_from_game_update		;0879 20 F2 0C
		jsr apply_torqueQ		;087C 20 78 0A
		jsr L_CD05_from_game_update		;087F 20 05 CD
		jsr update_colour_map_if_dirty		;0882 20 6B 3F

.L_0885	jsr L_0A59_from_game_update		;0885 20 59 0A
		jsr integrate_plcar		;0888 20 57 09
		jsr update_camera_roll_tables		;088B 20 26 27
		lda L_C37A		;088E AD 7A C3
		beq L_0896		;0891 F0 03

		jsr update_colour_map_always		;0893 20 70 3F
.L_0896	rts				;0896 60
}

; only called from game_update
.L_0897_from_game_update
{
		lda L_0796		;0897 AD 96 07
		sta ZP_52		;089A 85 52
		lda L_07BE		;089C AD BE 07
		sta ZP_78		;089F 85 78
		lda L_0797		;08A1 AD 97 07
		sta ZP_7E		;08A4 85 7E
		lda L_07BF		;08A6 AD BF 07
		sta ZP_80		;08A9 85 80
		lda L_0793		;08AB AD 93 07
		clc				;08AE 18
		adc L_078E		;08AF 6D 8E 07
		sta ZP_51		;08B2 85 51
		lda L_07BB		;08B4 AD BB 07
		adc L_07B6		;08B7 6D B6 07
		clc				;08BA 18
		bpl L_08BE		;08BB 10 01
		sec				;08BD 38
.L_08BE	ror A			;08BE 6A
		ror ZP_51		;08BF 66 51
		sta ZP_77		;08C1 85 77
		lda L_0790		;08C3 AD 90 07
		sec				;08C6 38
		sbc L_0795		;08C7 ED 95 07
		sta ZP_7D		;08CA 85 7D
		lda L_07B8		;08CC AD B8 07
		sbc L_07BD		;08CF ED BD 07
		clc				;08D2 18
		bpl L_08D6		;08D3 10 01
		sec				;08D5 38
.L_08D6	ror A			;08D6 6A
		ror ZP_7D		;08D7 66 7D
		sta ZP_7F		;08D9 85 7F
		lda #$00		;08DB A9 00
		sec				;08DD 38
		sbc ZP_52		;08DE E5 52
		sta L_0132		;08E0 8D 32 01
		lda #$00		;08E3 A9 00
		sbc ZP_78		;08E5 E5 78
		sta L_0135		;08E7 8D 35 01
		lda #$00		;08EA A9 00
		sec				;08EC 38
		sbc ZP_7E		;08ED E5 7E
		sta L_0138		;08EF 8D 38 01
		lda #$00		;08F2 A9 00
		sbc ZP_80		;08F4 E5 80
		sta L_013B		;08F6 8D 3B 01
		ldx #$01		;08F9 A2 01
.L_08FB	lda ZP_52		;08FB A5 52
		sta L_0130,X	;08FD 9D 30 01
		lda ZP_78		;0900 A5 78
		sta L_0133,X	;0902 9D 33 01
		lda ZP_7E		;0905 A5 7E
		sta L_0136,X	;0907 9D 36 01
		lda ZP_80		;090A A5 80
		sta L_0139,X	;090C 9D 39 01
		dex				;090F CA
		bpl L_08FB		;0910 10 E9
		lda L_0130		;0912 AD 30 01
		sec				;0915 38
		sbc ZP_51		;0916 E5 51
		sta L_0130		;0918 8D 30 01
		lda L_0133		;091B AD 33 01
		sbc ZP_77		;091E E5 77
		sta L_0133		;0920 8D 33 01
		lda L_0136		;0923 AD 36 01
		sec				;0926 38
		sbc ZP_7D		;0927 E5 7D
		sta L_0136		;0929 8D 36 01
		lda L_0139		;092C AD 39 01
		sbc ZP_7F		;092F E5 7F
		sta L_0139		;0931 8D 39 01
		lda L_0131		;0934 AD 31 01
		clc				;0937 18
		adc ZP_51		;0938 65 51
		sta L_0131		;093A 8D 31 01
		lda L_0134		;093D AD 34 01
		adc ZP_77		;0940 65 77
		sta L_0134		;0942 8D 34 01
		lda L_0137		;0945 AD 37 01
		clc				;0948 18
		adc ZP_7D		;0949 65 7D
		sta L_0137		;094B 8D 37 01
		lda L_013A		;094E AD 3A 01
		adc ZP_7F		;0951 65 7F
		sta L_013A		;0953 8D 3A 01
		rts				;0956 60
}

.integrate_plcar
{
		ldx #$02		;0957 A2 02
.L_0959	lda #$00		;0959 A9 00
		sta ZP_16		;095B 85 16
		lda L_0109,X	;095D BD 09 01
		sta ZP_14		;0960 85 14
		lda L_010F,X	;0962 BD 0F 01
		sta ZP_15		;0965 85 15
		bpl L_096B		;0967 10 02
		dec ZP_16		;0969 C6 16
.L_096B	lda ZP_16		;096B A5 16
		ldy #$02		;096D A0 02
		cpx #$01		;096F E0 01
		bne L_0974		;0971 D0 01
		dey				;0973 88
.L_0974	lsr A			;0974 4A
		ror ZP_15		;0975 66 15
		ror ZP_14		;0977 66 14
		dey				;0979 88
		bne L_0974		;097A D0 F8
		lda ZP_15		;097C A5 15
		jsr L_FF8E		;097E 20 8E FF
		ldy #$00		;0981 A0 00
		bit ZP_15		;0983 24 15
		bpl L_0988		;0985 10 01
		dey				;0987 88
.L_0988	sty ZP_16		;0988 84 16
		adc L_0100,X	;098A 7D 00 01
		sta L_0100,X	;098D 9D 00 01
		lda L_0103,X	;0990 BD 03 01
		adc ZP_15		;0993 65 15
		sta L_0103,X	;0995 9D 03 01
		lda L_0106,X	;0998 BD 06 01
		adc ZP_16		;099B 65 16
		sta L_0106,X	;099D 9D 06 01
		dex				;09A0 CA
		bpl L_0959		;09A1 10 B6
		lda L_0107		;09A3 AD 07 01
		bmi L_09BF		;09A6 30 17
		cmp #$03		;09A8 C9 03
		bcc L_09BF		;09AA 90 13
		bne L_09B5		;09AC D0 07
		lda L_0104		;09AE AD 04 01
		cmp #$E8		;09B1 C9 E8
		bcc L_09BF		;09B3 90 0A
.L_09B5	lda #$E7		;09B5 A9 E7
		sta L_0104		;09B7 8D 04 01
		lda #$03		;09BA A9 03
		sta L_0107		;09BC 8D 07 01
.L_09BF	ldx #$02		;09BF A2 02
.L_09C1	lda L_016A,X	;09C1 BD 6A 01
		sta ZP_14		;09C4 85 14
		lda L_016D,X	;09C6 BD 6D 01
		jsr L_FF8E		;09C9 20 8E FF
		adc L_0121,X	;09CC 7D 21 01
		sta L_0121,X	;09CF 9D 21 01
		lda L_0124,X	;09D2 BD 24 01
		adc ZP_15		;09D5 65 15
		sta L_0124,X	;09D7 9D 24 01
		cpx #$01		;09DA E0 01
		beq L_0A19		;09DC F0 3B
		ldy #$00		;09DE A0 00
		bit L_C373		;09E0 2C 73 C3
		bpl L_09ED		;09E3 10 08
		lda L_C359		;09E5 AD 59 C3
		cmp #$E0		;09E8 C9 E0
		bne L_09ED		;09EA D0 01
		iny				;09EC C8
.L_09ED	lda L_0124,X	;09ED BD 24 01
		bmi L_09FC		;09F0 30 0A
		lda L_0A55,Y	;09F2 B9 55 0A
		cmp L_0124,X	;09F5 DD 24 01
		bcs L_0A19		;09F8 B0 1F
		bcc L_0A04		;09FA 90 08
.L_09FC	lda L_0A57,Y	;09FC B9 57 0A
		cmp L_0124,X	;09FF DD 24 01
		bcc L_0A19		;0A02 90 15
.L_0A04	sta L_0124,X	;0A04 9D 24 01
		eor L_0112,X	;0A07 5D 12 01
		bmi L_0A14		;0A0A 30 08
		lda #$00		;0A0C A9 00
		sta L_0112,X	;0A0E 9D 12 01
		sta L_010C,X	;0A11 9D 0C 01
.L_0A14	lda #$00		;0A14 A9 00
		sta L_0121,X	;0A16 9D 21 01
.L_0A19	dex				;0A19 CA
		bpl L_09C1		;0A1A 10 A5
		lda L_0126		;0A1C AD 26 01
		bpl L_0A26		;0A1F 10 05
		eor #$FF		;0A21 49 FF
		clc				;0A23 18
		adc #$01		;0A24 69 01
.L_0A26	cmp #$0F		;0A26 C9 0F
		ror L_C3DC		;0A28 6E DC C3
		lda #$00		;0A2B A9 00
		sta ZP_16		;0A2D 85 16
		ldy #$05		;0A2F A0 05
		lda L_0121		;0A31 AD 21 01
		sta ZP_14		;0A34 85 14
		lda L_0124		;0A36 AD 24 01
		bpl L_0A3D		;0A39 10 02
		dec ZP_16		;0A3B C6 16
.L_0A3D	lsr ZP_16		;0A3D 46 16
		ror A			;0A3F 6A
		ror ZP_14		;0A40 66 14
		dey				;0A42 88
		bne L_0A3D		;0A43 D0 F8
		sta ZP_15		;0A45 85 15
		lda ZP_3C		;0A47 A5 3C
		sec				;0A49 38
		sbc ZP_14		;0A4A E5 14
		sta ZP_33		;0A4C 85 33
		lda #$00		;0A4E A9 00
		sbc ZP_15		;0A50 E5 15
		sta ZP_69		;0A52 85 69
		rts				;0A54 60
}

.L_0A55	equb $2C,$0A
.L_0A57	equb $D3,$F5

; only called from game update
.L_0A59_from_game_update
{
		ldx #$02		;0A59 A2 02
.L_0A5B	lda L_0115,X	;0A5B BD 15 01
		sta ZP_14		;0A5E 85 14
		lda L_011B,X	;0A60 BD 1B 01
		jsr L_FF8E		;0A63 20 8E FF
		adc L_0109,X	;0A66 7D 09 01
		sta L_0109,X	;0A69 9D 09 01
		lda L_010F,X	;0A6C BD 0F 01
		adc ZP_15		;0A6F 65 15
		sta L_010F,X	;0A71 9D 0F 01
		dex				;0A74 CA
		bpl L_0A5B		;0A75 10 E4
		rts				;0A77 60
}

.apply_torqueQ
{
		ldx #$02		;0A78 A2 02
.L_0A7A	lda L_0118,X	;0A7A BD 18 01
		sta ZP_14		;0A7D 85 14
		lda L_011E,X	;0A7F BD 1E 01
		jsr L_FF8E		;0A82 20 8E FF
		adc L_010C,X	;0A85 7D 0C 01
		sta L_010C,X	;0A88 9D 0C 01
		lda L_0112,X	;0A8B BD 12 01
		adc ZP_15		;0A8E 65 15
		sta L_0112,X	;0A90 9D 12 01
		dex				;0A93 CA
		bpl L_0A7A		;0A94 10 E4
		rts				;0A96 60
}

; only called from game update
.L_0A97_from_game_update
{
		lda #$00		;0A97 A9 00
		sta L_C3BC		;0A99 8D BC C3
		sta L_C35C		;0A9C 8D 5C C3
		ldx #$02		;0A9F A2 02
.L_0AA1	lda L_C340,X	;0AA1 BD 40 C3
		sec				;0AA4 38
		sbc L_C346,X	;0AA5 FD 46 C3
		sta ZP_83,X		;0AA8 95 83
		sta L_0179,X	;0AAA 9D 79 01
		sta ZP_18		;0AAD 85 18
		lda L_C343,X	;0AAF BD 43 C3
		sbc L_C349,X	;0AB2 FD 49 C3
		sta ZP_15		;0AB5 85 15
		lda L_C3CE,X	;0AB7 BD CE C3
		sbc L_C3D1,X	;0ABA FD D1 C3
		sta ZP_16		;0ABD 85 16
		lda ZP_15		;0ABF A5 15
		sec				;0AC1 38
		sbc ZP_0E		;0AC2 E5 0E
		sta L_017C,X	;0AC4 9D 7C 01
		sta ZP_15		;0AC7 85 15
		lda ZP_16		;0AC9 A5 16
		sbc #$00		;0ACB E9 00
		sta L_C3D4,X	;0ACD 9D D4 C3
		beq L_0AE9		;0AD0 F0 17
		bpl L_0AEF		;0AD2 10 1B
		cmp #$FF		;0AD4 C9 FF
		bne L_0ADE		;0AD6 D0 06
		lda ZP_15		;0AD8 A5 15
		cmp #$FD		;0ADA C9 FD
		bcs L_0AF1		;0ADC B0 13
.L_0ADE	lda #$00		;0ADE A9 00
		sta ZP_83,X		;0AE0 95 83
		lda #$FD		;0AE2 A9 FD
		sta ZP_86,X		;0AE4 95 86
		jmp L_0B6E		;0AE6 4C 6E 0B
.L_0AE9	lda ZP_15		;0AE9 A5 15
		cmp #$14		;0AEB C9 14
		bcc L_0AF1		;0AED 90 02
.L_0AEF	lda #$14		;0AEF A9 14
.L_0AF1	sta ZP_86,X		;0AF1 95 86
		sta ZP_19		;0AF3 85 19
		lda ZP_18		;0AF5 A5 18
		sec				;0AF7 38
		sbc L_0142,X	;0AF8 FD 42 01
		sta ZP_14		;0AFB 85 14
		lda ZP_19		;0AFD A5 19
		sbc L_0145,X	;0AFF FD 45 01
		jsr L_CFB7		;0B02 20 B7 CF
		bmi L_0B6E		;0B05 30 67
		tay				;0B07 A8
		lda ZP_14		;0B08 A5 14
		sta L_0148,X	;0B0A 9D 48 01
		tya				;0B0D 98
		sta ZP_17		;0B0E 85 17
		cmp #$04		;0B10 C9 04
		bcc L_0B1E		;0B12 90 0A
		ldy L_014B,X	;0B14 BC 4B 01
		cpy #$02		;0B17 C0 02
		bcs L_0B1E		;0B19 B0 03
		inc L_C3BC		;0B1B EE BC C3
.L_0B1E	sta L_014B,X	;0B1E 9D 4B 01
		sec				;0B21 38
		sbc L_C38B		;0B22 ED 8B C3
		bmi L_0B76		;0B25 30 4F
		cmp #$07		;0B27 C9 07
		bcc L_0B76		;0B29 90 4B
		cmp L_C35C		;0B2B CD 5C C3
		bcc L_0B33		;0B2E 90 03
		sta L_C35C		;0B30 8D 5C C3
.L_0B33	sec				;0B33 38
		sbc #$06		;0B34 E9 06
		inc ZP_E1		;0B36 E6 E1
		ldy ZP_E1		;0B38 A4 E1
		cpy L_209B		;0B3A CC 9B 20
		bcs L_0B5B		;0B3D B0 1C
		cmp #$80		;0B3F C9 80
		bcc L_0B45		;0B41 90 02
		lda #$7F		;0B43 A9 7F
.L_0B45	sta ZP_15		;0B45 85 15
		lsr A			;0B47 4A
		clc				;0B48 18
		adc ZP_15		;0B49 65 15
		clc				;0B4B 18
		adc L_C3C3,X	;0B4C 7D C3 C3
		bcc L_0B53		;0B4F 90 02
		lda #$FF		;0B51 A9 FF
.L_0B53	sta L_C3C3,X	;0B53 9D C3 C3
		lda #$80		;0B56 A9 80
		sta L_C352		;0B58 8D 52 C3
.L_0B5B	lda ZP_17		;0B5B A5 17
		cmp #$12		;0B5D C9 12
		bcc L_0B68		;0B5F 90 07
		lda #$FF		;0B61 A9 FF
		sta L_0148,X	;0B63 9D 48 01
		lda #$11		;0B66 A9 11
.L_0B68	sta L_014B,X	;0B68 9D 4B 01
		jmp L_0B7A		;0B6B 4C 7A 0B
.L_0B6E	lda #$00		;0B6E A9 00
		sta L_0148,X	;0B70 9D 48 01
		sta L_014B,X	;0B73 9D 4B 01
.L_0B76	lda #$00		;0B76 A9 00
		sta ZP_E1		;0B78 85 E1
.L_0B7A	lda ZP_83,X		;0B7A B5 83
		sta L_0142,X	;0B7C 9D 42 01
		lda ZP_86,X		;0B7F B5 86
		sta L_0145,X	;0B81 9D 45 01
		dex				;0B84 CA
		bmi L_0B8A		;0B85 30 03
		jmp L_0AA1		;0B87 4C A1 0A
.L_0B8A	lda L_0148		;0B8A AD 48 01
		clc				;0B8D 18
		adc L_0149		;0B8E 6D 49 01
		sta ZP_51		;0B91 85 51
		lda L_014B		;0B93 AD 4B 01
		adc L_014C		;0B96 6D 4C 01
		clc				;0B99 18
		bpl L_0B9D		;0B9A 10 01
		sec				;0B9C 38
.L_0B9D	ror A			;0B9D 6A
		ror ZP_51		;0B9E 66 51
		sta ZP_77		;0BA0 85 77
		lda ZP_51		;0BA2 A5 51
		clc				;0BA4 18
		adc L_014A		;0BA5 6D 4A 01
		sta L_0160		;0BA8 8D 60 01
		lda ZP_77		;0BAB A5 77
		adc L_014D		;0BAD 6D 4D 01
		clc				;0BB0 18
		bpl L_0BB4		;0BB1 10 01
		sec				;0BB3 38
.L_0BB4	ror A			;0BB4 6A
		ror L_0160		;0BB5 6E 60 01
		sta L_0161		;0BB8 8D 61 01
		jsr L_0E73		;0BBB 20 73 0E
		lda L_0148		;0BBE AD 48 01
		sec				;0BC1 38
		sbc L_0149		;0BC2 ED 49 01
		sta ZP_16		;0BC5 85 16
		sta ZP_14		;0BC7 85 14
		lda L_014B		;0BC9 AD 4B 01
		sbc L_014C		;0BCC ED 4C 01
		sta ZP_17		;0BCF 85 17
		sta ZP_15		;0BD1 85 15
		asl ZP_14		;0BD3 06 14
		rol ZP_15		;0BD5 26 15
		lda ZP_16		;0BD7 A5 16
		clc				;0BD9 18
		adc ZP_14		;0BDA 65 14
		sta ZP_14		;0BDC 85 14
		lda ZP_17		;0BDE A5 17
		adc ZP_15		;0BE0 65 15
		sta ZP_17		;0BE2 85 17
		jsr negate_if_N_set		;0BE4 20 BD C8
		cmp #$10		;0BE7 C9 10
		bcc L_0BF1		;0BE9 90 06
		lda #$00		;0BEB A9 00
		sta ZP_14		;0BED 85 14
		lda #$10		;0BEF A9 10
.L_0BF1	bit ZP_17		;0BF1 24 17
		jsr negate_if_N_set		;0BF3 20 BD C8
		sta L_0167		;0BF6 8D 67 01
		lda ZP_14		;0BF9 A5 14
		sta L_0166		;0BFB 8D 66 01
		lda ZP_51		;0BFE A5 51
		sec				;0C00 38
		sbc L_014A		;0C01 ED 4A 01
		sta L_014E		;0C04 8D 4E 01
		lda ZP_77		;0C07 A5 77
		sbc L_014D		;0C09 ED 4D 01
		sta L_014F		;0C0C 8D 4F 01
		lda L_0161		;0C0F AD 61 01
		ora L_0160		;0C12 0D 60 01
		sta ZP_6A		;0C15 85 6A
		bne L_0C5B		;0C17 D0 42
		lda ZP_2F		;0C19 A5 2F
		bne L_0C5B		;0C1B D0 3E
		ldx #$80		;0C1D A2 80
		ldy #$FF		;0C1F A0 FF
		lda L_0124		;0C21 AD 24 01
		bpl L_0C39		;0C24 10 13
		lda L_C77D		;0C26 AD 7D C7
		cmp #$07		;0C29 C9 07
		bne L_0C31		;0C2B D0 04
		ldx #$F0		;0C2D A2 F0
		bne L_0C41		;0C2F D0 10
.L_0C31	cmp #$04		;0C31 C9 04
		bne L_0C5B		;0C33 D0 26
		ldx #$F8		;0C35 A2 F8
		bne L_0C41		;0C37 D0 08
.L_0C39	cmp #$10		;0C39 C9 10
		bcc L_0C41		;0C3B 90 04
		ldx #$00		;0C3D A2 00
		ldy #$FF		;0C3F A0 FF
.L_0C41	txa				;0C41 8A
		sec				;0C42 38
		sbc L_014E		;0C43 ED 4E 01
		tya				;0C46 98
		sbc L_014F		;0C47 ED 4F 01
		bpl L_0C5B		;0C4A 10 0F
		lda L_0112		;0C4C AD 12 01
		bpl L_0C55		;0C4F 10 04
		cmp #$FF		;0C51 C9 FF
		bcc L_0C5B		;0C53 90 06
.L_0C55	stx L_014E		;0C55 8E 4E 01
		sty L_014F		;0C58 8C 4F 01
.L_0C5B	jsr L_EC11		;0C5B 20 11 EC
		lda L_0175		;0C5E AD 75 01
		sta ZP_E4		;0C61 85 E4
		jsr L_2176		;0C63 20 76 21
		lda L_C3BC		;0C66 AD BC C3
		beq L_0C70		;0C69 F0 05
		lda #$03		;0C6B A9 03
		jsr L_CF68		;0C6D 20 68 CF
.L_0C70	rts				;0C70 60
}

; only caled from game update
.L_0C71_from_game_update
{
		lda L_013D		;0C71 AD 3D 01
		clc				;0C74 18
		adc L_0171		;0C75 6D 71 01
		sta L_015B		;0C78 8D 5B 01
		lda L_0140		;0C7B AD 40 01
		adc L_0174		;0C7E 6D 74 01
		sta L_015E		;0C81 8D 5E 01
		lda L_0151		;0C84 AD 51 01
		ora L_0159		;0C87 0D 59 01
		bmi L_0C9D		;0C8A 30 11
		lda L_0150		;0C8C AD 50 01
		beq L_0C9D		;0C8F F0 0C
		sec				;0C91 38
		sbc L_0159		;0C92 ED 59 01
		sta L_0150		;0C95 8D 50 01
		bcs L_0C9D		;0C98 B0 03
		dec L_0151		;0C9A CE 51 01
.L_0C9D	lda L_0150		;0C9D AD 50 01
		sta ZP_14		;0CA0 85 14
		lda L_0151		;0CA2 AD 51 01
		jsr negate_if_N_set		;0CA5 20 BD C8
		sta ZP_17		;0CA8 85 17
		lda ZP_14		;0CAA A5 14
		sta ZP_16		;0CAC 85 16
		jsr L_0DCD		;0CAE 20 CD 0D
		lda ZP_16		;0CB1 A5 16
		sec				;0CB3 38
		sbc ZP_14		;0CB4 E5 14
		lda ZP_17		;0CB6 A5 17
		sbc ZP_15		;0CB8 E5 15
		bcc L_0CCC		;0CBA 90 10
		lda ZP_15		;0CBC A5 15
		bit L_0151		;0CBE 2C 51 01
		jsr negate_if_N_set		;0CC1 20 BD C8
		sta L_0151		;0CC4 8D 51 01
		lda ZP_14		;0CC7 A5 14
		sta L_0150		;0CC9 8D 50 01
.L_0CCC	lda L_0150		;0CCC AD 50 01
		clc				;0CCF 18
		adc L_0172		;0CD0 6D 72 01
		sta ZP_14		;0CD3 85 14
		lda L_0151		;0CD5 AD 51 01
		adc L_0175		;0CD8 6D 75 01
		sta ZP_15		;0CDB 85 15
		lda ZP_14		;0CDD A5 14
		clc				;0CDF 18
		adc L_013E		;0CE0 6D 3E 01
		sta L_015C		;0CE3 8D 5C 01
		lda ZP_15		;0CE6 A5 15
		adc L_0141		;0CE8 6D 41 01
		sta L_015F		;0CEB 8D 5F 01
		jsr L_0D60		;0CEE 20 60 0D
		rts				;0CF1 60
}

; only called from game update
.L_0CF2_from_game_update
{
		lda L_010C		;0CF2 AD 0C 01
		sta ZP_14		;0CF5 85 14
		lda L_0112		;0CF7 AD 12 01
		ldy #$04		;0CFA A0 04
		jsr shift_16bit		;0CFC 20 BF C9
		sta ZP_15		;0CFF 85 15
		lda L_014E		;0D01 AD 4E 01
		sec				;0D04 38
		sbc ZP_14		;0D05 E5 14
		sta ZP_16		;0D07 85 16
		lda L_014F		;0D09 AD 4F 01
		sbc ZP_15		;0D0C E5 15
		sta ZP_17		;0D0E 85 17
		lda #$00		;0D10 A9 00
		sta ZP_14		;0D12 85 14
		ldx ZP_6A		;0D14 A6 6A
		beq L_0D2E		;0D16 F0 16
		lda L_015C		;0D18 AD 5C 01
		sta ZP_14		;0D1B 85 14
		lda L_015F		;0D1D AD 5F 01
		jsr negate_if_N_set		;0D20 20 BD C8
		ldy #$02		;0D23 A0 02
		jsr shift_16bit		;0D25 20 BF C9
		bit L_015F		;0D28 2C 5F 01
		jsr negate_if_N_set		;0D2B 20 BD C8
.L_0D2E	sta ZP_15		;0D2E 85 15
		lda ZP_16		;0D30 A5 16
		clc				;0D32 18
		adc ZP_14		;0D33 65 14
		sta L_0118		;0D35 8D 18 01
		lda ZP_17		;0D38 A5 17
		adc ZP_15		;0D3A 65 15
		sta L_011E		;0D3C 8D 1E 01
		lda L_010E		;0D3F AD 0E 01
		sta ZP_14		;0D42 85 14
		lda L_0114		;0D44 AD 14 01
		ldy #$04		;0D47 A0 04
		jsr shift_16bit		;0D49 20 BF C9
		sta ZP_15		;0D4C 85 15
		lda L_0166		;0D4E AD 66 01
		sec				;0D51 38
		sbc ZP_14		;0D52 E5 14
		sta L_011A		;0D54 8D 1A 01
		lda L_0167		;0D57 AD 67 01
		sbc ZP_15		;0D5A E5 15
		sta L_0120		;0D5C 8D 20 01
		rts				;0D5F 60
}

.L_0D60
{
		lda L_013C		;0D60 AD 3C 01
		clc				;0D63 18
		adc L_0170		;0D64 6D 70 01
		sta ZP_51		;0D67 85 51
		lda L_013F		;0D69 AD 3F 01
		adc L_0173		;0D6C 6D 73 01
		sta ZP_77		;0D6F 85 77
		lda ZP_51		;0D71 A5 51
		sec				;0D73 38
		sbc L_0154		;0D74 ED 54 01
		sta ZP_14		;0D77 85 14
		lda ZP_77		;0D79 A5 77
		sbc L_0157		;0D7B ED 57 01
		jsr negate_if_N_set		;0D7E 20 BD C8
		sta ZP_17		;0D81 85 17
		lda ZP_14		;0D83 A5 14
		sta ZP_16		;0D85 85 16
		jsr L_0DCD		;0D87 20 CD 0D
		lda ZP_16		;0D8A A5 16
		sec				;0D8C 38
		sbc ZP_14		;0D8D E5 14
		lda ZP_17		;0D8F A5 17
		sbc ZP_15		;0D91 E5 15
		bcc L_0DB4		;0D93 90 1F
		lda ZP_15		;0D95 A5 15
		bit L_0157		;0D97 2C 57 01
		jsr negate_if_N_set		;0D9A 20 BD C8
		sta ZP_15		;0D9D 85 15
		lda ZP_51		;0D9F A5 51
		sec				;0DA1 38
		sbc ZP_14		;0DA2 E5 14
		sta L_015A		;0DA4 8D 5A 01
		lda ZP_77		;0DA7 A5 77
		sbc ZP_15		;0DA9 E5 15
		sta L_015D		;0DAB 8D 5D 01
		lda #$80		;0DAE A9 80
		sta L_C3C6		;0DB0 8D C6 C3
		rts				;0DB3 60
.L_0DB4	lda L_0170		;0DB4 AD 70 01
		sec				;0DB7 38
		sbc L_0154		;0DB8 ED 54 01
		sta L_015A		;0DBB 8D 5A 01
		lda L_0173		;0DBE AD 73 01
		sbc L_0157		;0DC1 ED 57 01
		sta L_015D		;0DC4 8D 5D 01
		lda #$00		;0DC7 A9 00
		sta L_C3C6		;0DC9 8D C6 C3
		rts				;0DCC 60
}

.L_0DCD
{
		lda ZP_6A		;0DCD A5 6A
		beq L_0DE1		;0DCF F0 10
		lda L_0171		;0DD1 AD 71 01
		sta ZP_14		;0DD4 85 14
		lda L_0174		;0DD6 AD 74 01
		bmi L_0DE1		;0DD9 30 06
		asl ZP_14		;0DDB 06 14
		rol A			;0DDD 2A
		sta ZP_15		;0DDE 85 15
		rts				;0DE0 60
.L_0DE1	lda #$00		;0DE1 A9 00
		sta ZP_14		;0DE3 85 14
		sta ZP_15		;0DE5 85 15
		rts				;0DE7 60
}

; only called from game update
.L_0DE8_from_game_update
{
		ldy #$02		;0DE8 A0 02
		lda ZP_6A		;0DEA A5 6A
		beq L_0E00		;0DEC F0 12
		lda ZP_E4		;0DEE A5 E4
		bpl L_0DF4		;0DF0 10 02
		eor #$FF		;0DF2 49 FF
.L_0DF4	cmp #$03		;0DF4 C9 03
		bcs L_0E06		;0DF6 B0 0E
		bit ZP_6B		;0DF8 24 6B
		bmi L_0E06		;0DFA 30 0A
		lda ZP_0E		;0DFC A5 0E
		bne L_0E04		;0DFE D0 04
.L_0E00	lda ZP_2F		;0E00 A5 2F
		beq L_0E0A		;0E02 F0 06
.L_0E04	ldy #$04		;0E04 A0 04
.L_0E06	lda #$C0		;0E06 A9 C0
		bne L_0E40		;0E08 D0 36
.L_0E0A	ldx #$02		;0E0A A2 02
.L_0E0C	lda L_0154,X	;0E0C BD 54 01
		sta ZP_14		;0E0F 85 14
		lda L_0157,X	;0E11 BD 57 01
		jsr negate_if_N_set		;0E14 20 BD C8
		asl ZP_14		;0E17 06 14
		rol A			;0E19 2A
		sta ZP_15,X		;0E1A 95 15
		dex				;0E1C CA
		bpl L_0E0C		;0E1D 10 ED
		ldy #$06		;0E1F A0 06
		lda ZP_15		;0E21 A5 15
		cmp ZP_16		;0E23 C5 16
		bcs L_0E29		;0E25 B0 02
		lda ZP_16		;0E27 A5 16
.L_0E29	cmp ZP_17		;0E29 C5 17
		bcs L_0E2F		;0E2B B0 02
		lda ZP_17		;0E2D A5 17
.L_0E2F	bit L_C308		;0E2F 2C 08 C3
		bpl L_0E40		;0E32 10 0C
		bit L_C36A		;0E34 2C 6A C3
		bmi L_0E40		;0E37 30 07
		sec				;0E39 38
		sbc #$14		;0E3A E9 14
		bcs L_0E40		;0E3C B0 02
		lda #$00		;0E3E A9 00
.L_0E40	sta L_C350		;0E40 8D 50 C3
		sty ZP_1A		;0E43 84 1A
		ldx #$02		;0E45 A2 02
.L_0E47	lda L_C350		;0E47 AD 50 C3
		sta ZP_15		;0E4A 85 15
		lda L_0109,X	;0E4C BD 09 01
		sta ZP_14		;0E4F 85 14
		lda L_010F,X	;0E51 BD 0F 01
		jsr mul_8_16_16bit		;0E54 20 45 C8
		ldy ZP_1A		;0E57 A4 1A
		jsr shift_16bit		;0E59 20 BF C9
		sta ZP_15		;0E5C 85 15
		lda L_0115,X	;0E5E BD 15 01
		sec				;0E61 38
		sbc ZP_14		;0E62 E5 14
		sta L_0115,X	;0E64 9D 15 01
		lda L_011B,X	;0E67 BD 1B 01
		sbc ZP_15		;0E6A E5 15
		sta L_011B,X	;0E6C 9D 1B 01
		dex				;0E6F CA
		bpl L_0E47		;0E70 10 D5
		rts				;0E72 60
}

.L_0E73
{
		lda #$00		;0E73 A9 00
		sta L_0177		;0E75 8D 77 01
		ldx #$02		;0E78 A2 02
.L_0E7A	ldy #$03		;0E7A A0 03
.L_0E7C	lsr L_C3D4,X	;0E7C 5E D4 C3
		ror L_017C,X	;0E7F 7E 7C 01
		ror L_0179,X	;0E82 7E 79 01
		dey				;0E85 88
		bne L_0E7C		;0E86 D0 F4
		dex				;0E88 CA
		bpl L_0E7A		;0E89 10 EF
		lda L_0179		;0E8B AD 79 01
		clc				;0E8E 18
		adc L_017A		;0E8F 6D 7A 01
		sta ZP_14		;0E92 85 14
		lda L_017C		;0E94 AD 7C 01
		adc L_017D		;0E97 6D 7D 01
		clc				;0E9A 18
		bpl L_0E9E		;0E9B 10 01
		sec				;0E9D 38
.L_0E9E	ror A			;0E9E 6A
		ror ZP_14		;0E9F 66 14
		sta ZP_15		;0EA1 85 15
		lda ZP_14		;0EA3 A5 14
		sec				;0EA5 38
		sbc L_017B		;0EA6 ED 7B 01
		sta ZP_14		;0EA9 85 14
		lda ZP_15		;0EAB A5 15
		sbc L_017E		;0EAD ED 7E 01
		clc				;0EB0 18
		bpl L_0EB4		;0EB1 10 01
		sec				;0EB3 38
.L_0EB4	ror A			;0EB4 6A
		ror ZP_14		;0EB5 66 14
		eor #$80		;0EB7 49 80
		sta L_0178		;0EB9 8D 78 01
		eor #$80		;0EBC 49 80
		jsr L_0F12		;0EBE 20 12 0F
		lda ZP_57		;0EC1 A5 57
		sta ZP_44		;0EC3 85 44
		lda ZP_56		;0EC5 A5 56
		sta ZP_91		;0EC7 85 91
		lda L_0179		;0EC9 AD 79 01
		sec				;0ECC 38
		sbc L_017A		;0ECD ED 7A 01
		sta ZP_14		;0ED0 85 14
		lda L_017C		;0ED2 AD 7C 01
		sbc L_017D		;0ED5 ED 7D 01
		sta L_0176		;0ED8 8D 76 01
		jsr L_0F12		;0EDB 20 12 0F
		lda ZP_44		;0EDE A5 44
		sta ZP_15		;0EE0 85 15
		lda ZP_57		;0EE2 A5 57
		jsr mul_8_8_16bit		;0EE4 20 82 C7
		sta ZP_90		;0EE7 85 90
		lda ZP_56		;0EE9 A5 56
		jsr mul_8_8_16bit		;0EEB 20 82 C7
		sta ZP_8F		;0EEE 85 8F
		ldx #$02		;0EF0 A2 02
.L_0EF2	lda ZP_8F,X		;0EF2 B5 8F
		sta ZP_15		;0EF4 85 15
		lda L_0176,X	;0EF6 BD 76 01
		sta ZP_5A		;0EF9 85 5A
		lda L_0160		;0EFB AD 60 01
		sta ZP_14		;0EFE 85 14
		lda L_0161		;0F00 AD 61 01
		jsr mul_8_16_16bit_2		;0F03 20 47 C8
		sta L_0173,X	;0F06 9D 73 01
		lda ZP_14		;0F09 A5 14
		sta L_0170,X	;0F0B 9D 70 01
		dex				;0F0E CA
		bpl L_0EF2		;0F0F 10 E1
		rts				;0F11 60
}

.L_0F12
{
		and #$FF		;0F12 29 FF
		jsr negate_if_N_set		;0F14 20 BD C8
		ldx #$FF		;0F17 A2 FF
		cmp #$00		;0F19 C9 00
		bne L_0F1F		;0F1B D0 02
		ldx ZP_14		;0F1D A6 14
.L_0F1F	stx ZP_56		;0F1F 86 56
		txa				;0F21 8A
		lsr A			;0F22 4A
		tax				;0F23 AA
		lda L_B080,X	;0F24 BD 80 B0
		sta ZP_57		;0F27 85 57
		rts				;0F29 60
}

.L_0F2A
{
		lda ZP_82		;0F2A A5 82
		beq L_0F35		;0F2C F0 07
		dec ZP_82		;0F2E C6 82
		bne L_0F35		;0F30 D0 03
		jsr L_0F9C		;0F32 20 9C 0F
.L_0F35	ldx #$01		;0F35 A2 01
.L_0F37	jsr L_109C		;0F37 20 9C 10
		jsr L_0FAD		;0F3A 20 AD 0F
		dex				;0F3D CA
		bpl L_0F37		;0F3E 10 F7
		jsr L_1020		;0F40 20 20 10
		bit L_C373		;0F43 2C 73 C3
		bpl L_0F4B		;0F46 10 03
		jsr L_0F4B		;0F48 20 4B 0F
.L_0F4B	lda ZP_6C		;0F4B A5 6C
		beq L_0F71		;0F4D F0 22
		bmi L_0F71		;0F4F 30 20
		lsr A			;0F51 4A
		lsr A			;0F52 4A
		and #$01		;0F53 29 01
		sta L_C399		;0F55 8D 99 C3
		lda ZP_2F		;0F58 A5 2F
		bne L_0F66		;0F5A D0 0A
		lda ZP_6A		;0F5C A5 6A
		bne L_0F66		;0F5E D0 06
		lda ZP_6C		;0F60 A5 6C
		cmp #$06		;0F62 C9 06
		bcc L_0F71		;0F64 90 0B
.L_0F66	dec ZP_6C		;0F66 C6 6C
		bne L_0F71		;0F68 D0 07
		lda #$80		;0F6A A9 80
		sta L_C351		;0F6C 8D 51 C3
		sta ZP_6C		;0F6F 85 6C
.L_0F71	rts				;0F71 60
}

.L_0F72
{
		sed				;0F72 F8
		lda L_8298,X	;0F73 BD 98 82
		sec				;0F76 38
		sbc L_8298,Y	;0F77 F9 98 82
		lda L_82B0,X	;0F7A BD B0 82
		sbc L_82B0,Y	;0F7D F9 B0 82
		lda L_8398,X	;0F80 BD 98 83
		sbc L_8398,Y	;0F83 F9 98 83
		cld				;0F86 D8
		bcs L_0F9B		;0F87 B0 12
		lda L_8298,X	;0F89 BD 98 82
		sta L_8298,Y	;0F8C 99 98 82
		lda L_82B0,X	;0F8F BD B0 82
		sta L_82B0,Y	;0F92 99 B0 82
		lda L_8398,X	;0F95 BD 98 83
		sta L_8398,Y	;0F98 99 98 83
.L_0F9B	rts				;0F9B 60
}

.L_0F9C
{
		txa				;0F9C 8A
		pha				;0F9D 48
		jsr L_1144_with_color_ram		;0F9E 20 44 11
		ldy #$02		;0FA1 A0 02
		ldx #$03		;0FA3 A2 03
		lda #$80		;0FA5 A9 80
		jsr L_121F		;0FA7 20 1F 12
		pla				;0FAA 68
		tax				;0FAB AA
		rts				;0FAC 60
}

.L_0FAD
		cpx #$00		;0FAD E0 00
		bne L_0FB5		;0FAF D0 04
		bit ZP_6B		;0FB1 24 6B
		bvs L_0FC7		;0FB3 70 12
.L_0FB5	lda L_C374,X	;0FB5 BD 74 C3
		ldy L_C376,X	;0FB8 BC 76 C3
		bpl L_0FC8		;0FBB 10 0B
		cmp L_C767		;0FBD CD 67 C7
		bne L_0FC7		;0FC0 D0 05
		lda #$00		;0FC2 A9 00
		sta L_C376,X	;0FC4 9D 76 C3
.L_0FC7	rts				;0FC7 60
.L_0FC8	cmp L_C77C		;0FC8 CD 7C C7
		bne L_0FC7		;0FCB D0 FA
		lda #$80		;0FCD A9 80
		sta L_C376,X	;0FCF 9D 76 C3
;.L_0FD2
		inc L_C378,X	;0FD2 FE 78 C3
;L_0FD3	= *-2			;!
;L_0FD4	= *-1			;!
.L_0FD5	lda L_C378,X	;0FD5 BD 78 C3
		cmp #$01		;0FD8 C9 01
		beq L_0FDF		;0FDA F0 03
		jsr L_F811		;0FDC 20 11 F8
.L_0FDF	txa				;0FDF 8A
		bne L_0FFF		;0FE0 D0 1D
		lda L_C378		;0FE2 AD 78 C3
		cmp #$01		;0FE5 C9 01
		beq L_0FF3		;0FE7 F0 0A
		jsr L_92A2		;0FE9 20 A2 92
		lda #$19		;0FEC A9 19
		sta ZP_82		;0FEE 85 82
		jsr L_1078		;0FF0 20 78 10
.L_0FF3	stx ZP_C6		;0FF3 86 C6
		lda L_C378		;0FF5 AD 78 C3
		ldx #$04		;0FF8 A2 04
		jsr L_1426		;0FFA 20 26 14
		ldx ZP_C6		;0FFD A6 C6
.L_0FFF	lda L_C378,X	;0FFF BD 78 C3
		cmp #$01		;1002 C9 01
		beq L_101D		;1004 F0 17
		ldy #$02		;1006 A0 02
		jsr L_0F72		;1008 20 72 0F
		bcs L_101D		;100B B0 10
		txa				;100D 8A
		lsr A			;100E 4A
		ror A			;100F 6A

.L_1010
		ror A			;1010 6A
		sta L_C395		;1011 8D 95 C3
		beq L_101D		;1014 F0 07
		lda #$00		;1016 A9 00
		sta ZP_82		;1018 85 82
		jsr L_0F9C		;101A 20 9C 0F
.L_101D	jmp L_1090		;101D 4C 90 10

.L_1020
		ldx #$01		;1020 A2 01
.L_1022
		lda L_C364		;1022 AD 64 C3
		bne L_105C		;1025 D0 35
		lda L_C378,X	;1027 BD 78 C3
		cmp L_C354		;102A CD 54 C3
		bne L_105C		;102D D0 2D
		sta L_C364		;102F 8D 64 C3
		lda ZP_6C		;1032 A5 6C
		bne L_103A		;1034 D0 04
		lda #$2C		;1036 A9 2C
		sta ZP_6C		;1038 85 6C
.L_103A	txa				;103A 8A
		pha				;103B 48
		jsr L_1154_with_color_ram		;103C 20 54 11
		pla				;103F 68
		tax				;1040 AA
		cpy #$0B		;1041 C0 0B
		beq L_1050		;1043 F0 0B
		ldy #$54		;1045 A0 54
		bit L_C76C		;1047 2C 6C C7
		bpl L_1057		;104A 10 0B
		ldy #$08		;104C A0 08
		bne L_1057		;104E D0 07
.L_1050	lda #$80		;1050 A9 80
		sta L_C362		;1052 8D 62 C3
		ldy #$1C		;1055 A0 1C
.L_1057	lda #$04		;1057 A9 04
		jsr set_up_text_sprite		;1059 20 A9 12
.L_105C	lda L_C362		;105C AD 62 C3
		and #$BF		;105F 29 BF
		ora L_C395		;1061 0D 95 C3
		sta L_C362		;1064 8D 62 C3
		dex				;1067 CA
		bpl L_1022		;1068 10 B8
		rts				;106A 60

; Issues equivalent to VDU 31,x,y
.set_text_cursor
{
		lda #$1F		;106B A9 1F
		jsr write_char		;106D 20 6F 84
		txa				;1070 8A
		jsr write_char		;1071 20 6F 84
		tya				;1074 98
		jmp write_char		;1075 4C 6F 84
}

.L_1078
{
		txa				;1078 8A
		pha				;1079 48
		ldx #$02		;107A A2 02
		ldy #$00		;107C A0 00
		lda ZP_82		;107E A5 82
		beq L_1084		;1080 F0 02
		lda #$80		;1082 A9 80
.L_1084	jsr L_121F		;1084 20 1F 12
		pla				;1087 68
		tax				;1088 AA
		rts				;1089 60
}

.print_single_digit
{
		clc				;108A 18
		adc #$30		;108B 69 30
		jmp write_char		;108D 4C 6F 84
}

.L_1090
{
		lda #$00		;1090 A9 00
		sta L_82B0,X	;1092 9D B0 82
		sta L_8298,X	;1095 9D 98 82
		sta L_8398,X	;1098 9D 98 83
		rts				;109B 60
}

.L_109C
		lda #$14		;109C A9 14
.L_109E
{
		sed				;109E F8
		clc				;109F 18
		adc L_8298,X	;10A0 7D 98 82
		sta L_8298,X	;10A3 9D 98 82
		bcc L_10D7		;10A6 90 2F
		lda L_82B0,X	;10A8 BD B0 82
		adc #$00		;10AB 69 00
		sta L_82B0,X	;10AD 9D B0 82
		cmp #$60		;10B0 C9 60
		bcc L_10C6		;10B2 90 12
		lda #$00		;10B4 A9 00
		sta L_82B0,X	;10B6 9D B0 82
		lda L_8398,X	;10B9 BD 98 83
		clc				;10BC 18
		adc #$01		;10BD 69 01
		cmp #$0A		;10BF C9 0A
		bcs L_10C6		;10C1 B0 03
		sta L_8398,X	;10C3 9D 98 83
.L_10C6	cpx #$00		;10C6 E0 00
		bne L_10D7		;10C8 D0 0D
		lda ZP_82		;10CA A5 82
		bne L_10D7		;10CC D0 09
		lda L_C378		;10CE AD 78 C3
		beq L_10D7		;10D1 F0 04
		cld				;10D3 D8
		jsr L_1078		;10D4 20 78 10
.L_10D7	cld				;10D7 D8
		rts				;10D8 60
}

.L_10D9
{
		lda L_C352		;10D9 AD 52 C3
		beq L_10F2		;10DC F0 14
		lda L_C3C3		;10DE AD C3 C3
		clc				;10E1 18
		adc L_C3C4		;10E2 6D C4 C3
		ror A			;10E5 6A
		clc				;10E6 18
		adc L_C3C5		;10E7 6D C5 C3
		ror A			;10EA 6A
		lsr A			;10EB 4A
		sta L_C3CB		;10EC 8D CB C3
		jsr update_damage_display		;10EF 20 88 1B
.L_10F2	lda L_C302		;10F2 AD 02 C3
		beq L_1110		;10F5 F0 19
		dec L_C302		;10F7 CE 02 C3
		cmp #$40		;10FA C9 40
		beq L_1104		;10FC F0 06
		lda L_C352		;10FE AD 52 C3
		bne L_1139		;1101 D0 36
		rts				;1103 60
.L_1104	ldy L_C719		;1104 AC 19 C7
		jsr L_F021		;1107 20 21 F0
		jsr L_F668		;110A 20 68 F6
		jmp L_1130		;110D 4C 30 11
.L_1110	lda L_C352		;1110 AD 52 C3
		beq L_1143		;1113 F0 2E
		lda L_C35C		;1115 AD 5C C3
		cmp #$14		;1118 C9 14
		bcc L_1139		;111A 90 1D
		ldy L_C719		;111C AC 19 C7
		beq L_1139		;111F F0 18
		dey				;1121 88
		sty L_C719		;1122 8C 19 C7
		jsr L_F021		;1125 20 21 F0
		jsr L_F673		;1128 20 73 F6
		lda #$40		;112B A9 40
		sta L_C302		;112D 8D 02 C3
.L_1130	lda #$20		;1130 A9 20
		sta L_AF8C		;1132 8D 8C AF
		lda #$01		;1135 A9 01
		bne L_113B		;1137 D0 02
.L_1139	lda #$04		;1139 A9 04
.L_113B	jsr L_CF68		;113B 20 68 CF
		lda #$00		;113E A9 00
		sta L_C352		;1140 8D 52 C3
.L_1143	rts				;1143 60
}

.L_1144_with_color_ram
		ldy #$0B		;1144 A0 0B
		lda L_C395		;1146 AD 95 C3
		bne L_114D_with_color_ram		;1149 D0 02
		ldy #$07		;114B A0 07
.L_114D_with_color_ram
		sty L_DBDA		;114D 8C DA DB		; COLOR RAM
		sty L_DBDB		;1150 8C DB DB		; COLOR RAM
		rts				;1153 60

.L_1154_with_color_ram
		ldy #$0B		;1154 A0 0B
		jsr L_F5E9		;1156 20 E9 F5
		bpl L_115D_with_color_ram		;1159 10 02
		ldy #$07		;115B A0 07
.L_115D_with_color_ram
		sty L_DBCC		;115D 8C CC DB		; COLOR RAM
		sty L_DBCD		;1160 8C CD DB		; COLOR RAM
		rts				;1163 60

.update_distance_to_ai_car_readout
{
		lda L_C30C		;1164 AD 0C C3
		and #$03		;1167 29 03
		beq L_116C		;1169 F0 01
		rts				;116B 60
.L_116C	ldx #$00		;116C A2 00
		stx ZP_18		;116E 86 18
		ldy #$00		;1170 A0 00
		lda ZP_3A		;1172 A5 3A
		sta ZP_15		;1174 85 15
		lda ZP_39		;1176 A5 39
		lsr ZP_15		;1178 46 15
		ror A			;117A 6A
		lsr ZP_15		;117B 46 15
		ror A			;117D 6A
		clc				;117E 18
		adc ZP_39		;117F 65 39
		sta ZP_14		;1181 85 14
		lda ZP_15		;1183 A5 15
		adc ZP_3A		;1185 65 3A
		lsr A			;1187 4A
		ror ZP_14		;1188 66 14
		lsr A			;118A 4A
		ror ZP_14		;118B 66 14
		sta ZP_15		;118D 85 15
		jmp L_11A1		;118F 4C A1 11
.L_1192	lda ZP_14		;1192 A5 14
		sec				;1194 38
		sbc #$E8		;1195 E9 E8
		sta ZP_14		;1197 85 14
		lda ZP_15		;1199 A5 15
		sbc #$03		;119B E9 03
		sta ZP_15		;119D 85 15
		inc ZP_18		;119F E6 18
.L_11A1	cmp #$03		;11A1 C9 03
		bcc L_11AD		;11A3 90 08
		bne L_1192		;11A5 D0 EB
		lda ZP_14		;11A7 A5 14
		cmp #$E8		;11A9 C9 E8
		bcs L_1192		;11AB B0 E5
.L_11AD	lda ZP_14		;11AD A5 14
		jmp L_11B5		;11AF 4C B5 11
.L_11B2	sbc #$64		;11B2 E9 64
		iny				;11B4 C8
.L_11B5	cmp #$64		;11B5 C9 64
		bcs L_11B2		;11B7 B0 F9
		dec ZP_15		;11B9 C6 15
		bpl L_11B2		;11BB 10 F5
		jmp L_11C3		;11BD 4C C3 11
.L_11C0	sbc #$0A		;11C0 E9 0A
		inx				;11C2 E8
.L_11C3	cmp #$0A		;11C3 C9 0A
		bcs L_11C0		;11C5 B0 F9
		sta ZP_17		;11C7 85 17
		stx ZP_15		;11C9 86 15
		sty ZP_16		;11CB 84 16
		lda #$F0		;11CD A9 F0
		bit L_C36A		;11CF 2C 6A C3
		bpl L_11D6		;11D2 10 02
		lda #$FD		;11D4 A9 FD
.L_11D6	ldx #$22		;11D6 A2 22
		jsr L_142E		;11D8 20 2E 14
		lda ZP_18		;11DB A5 18
		ldx #$23		;11DD A2 23
		jsr L_142E		;11DF 20 2E 14
		lda ZP_16		;11E2 A5 16
		ldx #$61		;11E4 A2 61
		jsr L_142E		;11E6 20 2E 14
		lda ZP_15		;11E9 A5 15
		ldx #$62		;11EB A2 62
		jsr L_142E		;11ED 20 2E 14
		lda ZP_17		;11F0 A5 17
		ldx #$63		;11F2 A2 63
		jsr L_142E		;11F4 20 2E 14
		lda L_C364		;11F7 AD 64 C3
		bne L_11FF		;11FA D0 03
		jsr L_1154_with_color_ram		;11FC 20 54 11
.L_11FF	lda ZP_6F		;11FF A5 6F
		ora #$03		;1201 09 03
		sta ZP_6F		;1203 85 6F
		rts				;1205 60
}

.draw_tachometer_in_game
{
		lda L_0159		;1206 AD 59 01
		sec				;1209 38
		sbc #$11		;120A E9 11
		bpl L_1211		;120C 10 03
		lda #$00		;120E A9 00
		clc				;1210 18
.L_1211	rol A			;1211 2A
		sta ZP_15		;1212 85 15
		lda #$B7		;1214 A9 B7
		jsr mul_8_8_16bit		;1216 20 82 C7
		tax				;1219 AA
		lda #$43		;121A A9 43
		jmp sysctl		;121C 4C 25 87
}

; Something to do with plotting the dashboard sprite?

.L_121F
{
		sty ZP_C7		;121F 84 C7
		sta L_C3CC		;1221 8D CC C3
		lda L_1296,X	;1224 BD 96 12
		sta ZP_C6		;1227 85 C6
		tax				;1229 AA
		lda L_8398,Y	;122A B9 98 83
		and #$0F		;122D 29 0F
		jsr L_1422		;122F 20 22 14
		ldy ZP_C7		;1232 A4 C7
		ldx ZP_C6		;1234 A6 C6
		inx				;1236 E8
		lda L_82B0,Y	;1237 B9 B0 82
		lsr A			;123A 4A
		lsr A			;123B 4A
		lsr A			;123C 4A
		lsr A			;123D 4A
		jsr L_1426		;123E 20 26 14
		jsr L_1411		;1241 20 11 14
		ldy ZP_C7		;1244 A4 C7
		ldx ZP_C6		;1246 A6 C6
		inx				;1248 E8
		inx				;1249 E8
		lda L_82B0,Y	;124A B9 B0 82
		and #$0F		;124D 29 0F
		jsr L_142A		;124F 20 2A 14
		ldy ZP_C7		;1252 A4 C7
		lda ZP_C6		;1254 A5 C6
		clc				;1256 18
		adc #$41		;1257 69 41
		tax				;1259 AA
		lda L_8298,Y	;125A B9 98 82
		lsr A			;125D 4A
		lsr A			;125E 4A
		lsr A			;125F 4A
		lsr A			;1260 4A
		bit L_C3CC		;1261 2C CC C3
		bmi L_1268		;1264 30 02
		lda #$F0		;1266 A9 F0
.L_1268	jsr L_142E		;1268 20 2E 14
		lda #$02		;126B A9 02
		sta L_3FF6,X	;126D 9D F6 3F
		ldy ZP_C7		;1270 A4 C7
		lda ZP_C6		;1272 A5 C6
		clc				;1274 18
		adc #$42		;1275 69 42
		tax				;1277 AA
		lda L_8298,Y	;1278 B9 98 82
		and #$0F		;127B 29 0F
		bit L_C3CC		;127D 2C CC C3
		bmi L_1284		;1280 30 02
		lda #$F0		;1282 A9 F0
.L_1284	jsr L_1422		;1284 20 22 14
		lda ZP_6F		;1287 A5 6F
		ldx ZP_C6		;1289 A6 C6
		bpl L_1291		;128B 10 04
		ora #$0C		;128D 09 0C
		bne L_1293		;128F D0 02
.L_1291	ora #$03		;1291 09 03
.L_1293	sta ZP_6F		;1293 85 6F
		rts				;1295 60

.L_1296	equb $03,$21,$83,$A1
}

.initialise_hud_sprites
{
		ldx #$03		;129A A2 03
		lda #$1C		;129C A9 1C
		jsr L_1426		;129E 20 26 14
		ldx #$43		;12A1 A2 43
		lda #$12		;12A3 A9 12
		jsr L_142E		;12A5 20 2E 14
		rts				;12A8 60
}

.set_up_text_sprite
{
		sty L_1327		;12A9 8C 27 13
		sta L_1328		;12AC 8D 28 13
		sta ZP_A0		;12AF 85 A0
		txa				;12B1 8A
		pha				;12B2 48
		ldx #$7F		;12B3 A2 7F
		lda #$00		;12B5 A9 00
		sta ZP_18		;12B7 85 18
.L_12B9	sta L_7F80,X	;12B9 9D 80 7F
		dex				;12BC CA
		bpl L_12B9		;12BD 10 FA
.L_12BF	ldx text_sprite_data,Y	;12BF BE 29 13
		iny				;12C2 C8
		lda #$03		;12C3 A9 03
		sta ZP_08		;12C5 85 08
.L_12C7	lda text_sprite_data,Y	;12C7 B9 29 13
		cmp #$3C		;12CA C9 3C
		bne L_12D2		;12CC D0 04
		stx ZP_18		;12CE 86 18
		lda #$20		;12D0 A9 20
.L_12D2	sec				;12D2 38
		sbc #$30		;12D3 E9 30
		sty ZP_C7		;12D5 84 C7
		stx ZP_C6		;12D7 86 C6
		jsr L_1469		;12D9 20 69 14
.L_12DC	lda (ZP_1E),Y	;12DC B1 1E
		sta L_7F80,X	;12DE 9D 80 7F
		inx				;12E1 E8
		inx				;12E2 E8
		inx				;12E3 E8
		iny				;12E4 C8
		cpy #$07		;12E5 C0 07
		bne L_12DC		;12E7 D0 F3
		ldy ZP_C7		;12E9 A4 C7
		ldx ZP_C6		;12EB A6 C6
		iny				;12ED C8
		inx				;12EE E8
		dec ZP_08		;12EF C6 08
		bne L_12C7		;12F1 D0 D4
		dec ZP_A0		;12F3 C6 A0
		bne L_12BF		;12F5 D0 C8
		lda ZP_18		;12F7 A5 18
		beq L_131F		;12F9 F0 24
		lda #$06		;12FB A9 06
		sta ZP_08		;12FD 85 08
		ldx ZP_18		;12FF A6 18
.L_1301	ldy #$04		;1301 A0 04
.L_1303	asl L_7FC2,X	;1303 1E C2 7F
		rol L_7FC1,X	;1306 3E C1 7F
		rol L_7FC0,X	;1309 3E C0 7F
		rol L_7F82,X	;130C 3E 82 7F
		rol L_7F81,X	;130F 3E 81 7F
		rol L_7F80,X	;1312 3E 80 7F
		dey				;1315 88
		bne L_1303		;1316 D0 EB
		inx				;1318 E8
		inx				;1319 E8
		inx				;131A E8
		dec ZP_08		;131B C6 08
		bne L_1301		;131D D0 E2
.L_131F	lda #$80		;131F A9 80
		sta L_C355		;1321 8D 55 C3
		pla				;1324 68
		tax				;1325 AA
		rts				;1326 60
}

.L_1327	equb $00
.L_1328	equb $02

.text_sprite_data
		equb $03,$3C,$57,$52,$43,$45,$43,$4B,$03,$20,$52,$41,$43,$43,$45,$20
		equb $21,$3C,$20,$57,$61,$4F,$4E,$20,$61,$54,$20,$20,$03,$20,$52,$41
		equb $43,$43,$45,$20,$21,$20,$4C,$4F,$61,$53,$54,$20,$03,$20,$44,$52
		equb $43,$4F,$50,$20,$21,$3C,$53,$54,$61,$41,$52,$54,$03,$3C,$50,$52
		equb $43,$45,$53,$53,$21,$20,$46,$49,$61,$52,$45,$20,$03,$50,$41,$55
		equb $43,$53,$45,$44,$03,$20,$4C,$41,$43,$50,$53,$20,$21,$20,$4F,$56
		equb $61,$45,$52,$20,$03,$44,$45,$46,$43,$49,$4E,$45,$21,$20,$4B,$45
		equb $61,$59,$53,$20,$03,$3C,$53,$54,$43,$45,$45,$52,$21,$20,$4C,$45
		equb $61,$46,$54,$20,$03,$20,$53,$54,$43,$45,$45,$52,$21,$20,$52,$49
		equb $61,$47,$48,$54,$03,$3C,$41,$48,$43,$45,$41,$44,$21,$2B,$42,$4F
		equb $61,$4F,$53,$54,$03,$20,$42,$41,$43,$43,$4B,$20,$21,$2B,$42,$4F
		equb $61,$4F,$53,$54,$03,$20,$42,$41,$43,$43,$4B,$20,$21,$20,$20,$20
		equb $61,$20,$20,$20,$03,$56,$45,$52,$43,$49,$46,$59,$21,$20,$4B,$45
		equb $61,$59,$53,$20,$03,$20,$46,$41,$43,$55,$4C,$54,$21,$20,$46,$4F
		equb $61,$55,$4E,$44
.L_140D	equb $3C
.L_140E	equb $54
.L_140F	equb $06
.L_1410	equb $1A

.L_1411
{
		lda L_3FFA,X	;1411 BD FA 3F
		ora #$80		;1414 09 80
		sta L_3FFA,X	;1416 9D FA 3F
		lda L_3FF1,X	;1419 BD F1 3F
		ora #$80		;141C 09 80
		sta L_3FF1,X	;141E 9D F1 3F
		rts				;1421 60
}

.L_1422
		ldy #$00		;1422 A0 00
		beq L_1430		;1424 F0 0A

.L_1426
		ldy #$80		;1426 A0 80
		bne L_1430		;1428 D0 06

.L_142A
		ldy #$C0		;142A A0 C0
		bne L_1430		;142C D0 02

.L_142E
		ldy #$40		;142E A0 40

.L_1430
{
		sty ZP_DB		;1430 84 DB
		jsr L_1469		;1432 20 69 14
.L_1435	lda (ZP_1E),Y	;1435 B1 1E
		bit ZP_DB		;1437 24 DB
		bpl L_145A		;1439 10 1F
		lsr A			;143B 4A
		bit ZP_DB		;143C 24 DB
		bvs L_1441		;143E 70 01
		lsr A			;1440 4A
.L_1441	sta ZP_14		;1441 85 14
		lda L_4000,X	;1443 BD 00 40
		and #$80		;1446 29 80
		ora ZP_14		;1448 05 14
		sta L_4000,X	;144A 9D 00 40
		bit ZP_DB		;144D 24 DB
		bvs L_1460		;144F 70 0F
		lda #$00		;1451 A9 00
		ror A			;1453 6A
		sta L_4001,X	;1454 9D 01 40
		jmp L_1460		;1457 4C 60 14
.L_145A	bvs L_145D		;145A 70 01
		asl A			;145C 0A
.L_145D	sta L_4000,X	;145D 9D 00 40
.L_1460	inx				;1460 E8
		inx				;1461 E8
		inx				;1462 E8
		iny				;1463 C8
		cpy #$07		;1464 C0 07
		bne L_1435		;1466 D0 CD
		rts				;1468 60
}

.L_1469
{
		ldy #$00		;1469 A0 00
		sty ZP_14		;146B 84 14
		clc				;146D 18
		adc #$30		;146E 69 30
		asl A			;1470 0A
		asl A			;1471 0A
		rol ZP_14		;1472 26 14
		asl A			;1474 0A
		rol ZP_14		;1475 26 14
		clc				;1477 18
		adc #$C0		;1478 69 C0
		sta ZP_1E		;147A 85 1E
		lda ZP_14		;147C A5 14
		adc #$7F		;147E 69 7F
		sta ZP_1F		;1480 85 1F
		iny				;1482 C8
		rts				;1483 60
}

.reset_sprites
{
		ldx #$07		;1484 A2 07
.L_1486	txa				;1486 8A
		asl A			;1487 0A
		tay				;1488 A8
		lda L_14C2,X	;1489 BD C2 14
		sta VIC_SP0X,Y	;148C 99 00 D0
		lda L_14C8,X	;148F BD C8 14
		sta VIC_SP0Y,Y	;1492 99 01 D0
		lda L_14B6,X	;1495 BD B6 14
		sta L_5FF8,X	;1498 9D F8 5F
		lda L_14BC,X	;149B BD BC 14
		sta VIC_SP0COL,X	;149E 9D 27 D0
		dex				;14A1 CA
		cpx #$02		;14A2 E0 02
		bcs L_1486		;14A4 B0 E0
		lda #$00		;14A6 A9 00
		sta VIC_SPMC0		;14A8 8D 25 D0
		lda #$01		;14AB A9 01
		sta VIC_SPMC1		;14AD 8D 26 D0
		lda #$FC		;14B0 A9 FC
		sta ZP_6E		;14B2 85 6E
		sta VIC_SPENA		;14B4 8D 15 D0
		rts				;14B7 60
		
.L_14B8	equb $64,$63,$69,$67
L_14B6 = L_14B8-2
.L_14BC	equb $68,$60,$03,$03,$0C,$0C
.L_14C2	equb $0C,$0C,$38,$20,$38,$38
.L_14C8	equb $20,$20,$BB,$BB,$8C,$77,$8C,$77
}

; update scratches and scrapes?
; only called from main loop
.L_14D0_from_main_loop
{
		ldx #$00		;14D0 A2 00
		ldy #$0A		;14D2 A0 0A
		lda #$04		;14D4 A9 04
.L_14D6	sta ZP_16		;14D6 85 16
		lda ZP_83,X		;14D8 B5 83
		sta ZP_14		;14DA 85 14
		lda ZP_86,X		;14DC B5 86
		clc				;14DE 18
		adc #$01		;14DF 69 01
		bpl L_14E7		;14E1 10 04
		lda #$00		;14E3 A9 00
		sta ZP_14		;14E5 85 14
.L_14E7	cmp #$08		;14E7 C9 08
		bcc L_14F1		;14E9 90 06
		lda #$FF		;14EB A9 FF
		sta ZP_14		;14ED 85 14
		lda #$07		;14EF A9 07
.L_14F1	lsr A			;14F1 4A
		sta ZP_15		;14F2 85 15
		lda ZP_14		;14F4 A5 14
		ror A			;14F6 6A
		lsr ZP_15		;14F7 46 15
		ror A			;14F9 6A
		lsr ZP_15		;14FA 46 15
		ror A			;14FC 6A
		eor #$FF		;14FD 49 FF
		stx ZP_17		;14FF 86 17
		tax				;1501 AA
		lda cosine_table,X	;1502 BD 00 A7
		lsr A			;1505 4A
		lsr A			;1506 4A
		lsr A			;1507 4A
		ldx ZP_17		;1508 A6 17
		eor #$FF		;150A 49 FF
		clc				;150C 18
		adc ZP_1C		;150D 65 1C
		asl L_C30A		;150F 0E 0A C3
		bcs L_1518		;1512 B0 04
		cmp #$BA		;1514 C9 BA
		bcc L_151A		;1516 90 02
.L_1518	lda #$B9		;1518 A9 B9
.L_151A	cmp #$97		;151A C9 97
		bcs L_1520		;151C B0 02
		lda #$97		;151E A9 97
.L_1520	sta VIC_SP0Y,Y	;1520 99 01 D0
		clc				;1523 18
		adc #$15		;1524 69 15
		cmp #$BE		;1526 C9 BE
		bcc L_1544		;1528 90 1A
		ldy ZP_16		;152A A4 16
		pha				;152C 48
		lda VIC_SPENA		;152D AD 15 D0
		and L_38B4,Y	;1530 39 B4 38
		sta VIC_SPENA		;1533 8D 15 D0
		pla				;1536 68
		jsr L_156B		;1537 20 6B 15
		ldy ZP_16		;153A A4 16
		lda ZP_6E		;153C A5 6E
		and L_38B4,Y	;153E 39 B4 38
		jmp L_155C		;1541 4C 5C 15
.L_1544	sta L_CFFF,Y	;1544 99 FF CF
		ldy ZP_16		;1547 A4 16
		lda ZP_6E		;1549 A5 6E
		and L_38BC,Y	;154B 39 BC 38
		bne L_1557		;154E D0 07
		lda #$B2		;1550 A9 B2
		jsr L_156B		;1552 20 6B 15
		ldy ZP_16		;1555 A4 16
.L_1557	lda ZP_6E		;1557 A5 6E
		ora L_38BC,Y	;1559 19 BC 38
.L_155C	sta ZP_6E		;155C 85 6E
		ldy #$0E		;155E A0 0E
		lda #$06		;1560 A9 06
		inx				;1562 E8
		cpx #$02		;1563 E0 02
		beq L_156A		;1565 F0 03
		jmp L_14D6		;1567 4C D6 14
.L_156A	rts				;156A 60
.L_156B	sta ZP_14		;156B 85 14
		lda #$40		;156D A9 40
		jmp sysctl		;156F 4C 25 87
}

.L_1572
{
		lda ZP_6C		;1572 A5 6C
		bne L_158D		;1574 D0 17
		lda #$02		;1576 A9 02
		sta ZP_0E		;1578 85 0E
		lda #$92		;157A A9 92
		sta ZP_1C		;157C 85 1C
		lda #$82		;157E A9 82
		sta ZP_3C		;1580 85 3C
		lda #$3C		;1582 A9 3C
		sta ZP_6C		;1584 85 6C
		lda #$02		;1586 A9 02
		ldy #$00		;1588 A0 00
		jsr set_up_text_sprite		;158A 20 A9 12
.L_158D	rts				;158D 60
}

.L_158E
{
		lda ZP_C9		;158E A5 C9
		beq L_1600		;1590 F0 6E
		ldx #$00		;1592 A2 00
		stx L_C30D		;1594 8E 0D C3
		stx L_C30E		;1597 8E 0E C3
		stx L_C357		;159A 8E 57 C3
		lda L_C30F		;159D AD 0F C3
		beq L_15CA		;15A0 F0 28
		dec L_C30F		;15A2 CE 0F C3
		clc				;15A5 18
		adc L_C358		;15A6 6D 58 C3
		and #$0F		;15A9 29 0F
		tay				;15AB A8
		lda L_1601,Y	;15AC B9 01 16
		bpl L_15B7		;15AF 10 06
		eor #$FF		;15B1 49 FF
		clc				;15B3 18
		adc #$01		;15B4 69 01
		inx				;15B6 E8
.L_15B7	sta L_C30D,X	;15B7 9D 0D C3
		tya				;15BA 98
		clc				;15BB 18
		adc #$05		;15BC 69 05
		and #$0F		;15BE 29 0F
		tay				;15C0 A8
		lda L_1601,Y	;15C1 B9 01 16
		sta L_C357		;15C4 8D 57 C3
		jmp L_15F8		;15C7 4C F8 15
.L_15CA	ldy L_C375		;15CA AC 75 C3
		lda L_0710,Y	;15CD B9 10 07
		ora L_C36A		;15D0 0D 6A C3
		ora ZP_B2		;15D3 05 B2
		bmi L_15F8		;15D5 30 21
		ldy #$08		;15D7 A0 08
		bit L_C353		;15D9 2C 53 C3
		bpl L_15F8		;15DC 10 1A
		bvc L_15E2		;15DE 50 02
		ldy #$10		;15E0 A0 10
.L_15E2	sty L_C358		;15E2 8C 58 C3
		jsr rndQ		;15E5 20 B9 29
		and #$1F		;15E8 29 1F
		sta ZP_14		;15EA 85 14
		lda L_C773		;15EC AD 73 C7
		cmp ZP_14		;15EF C5 14
		bcc L_15F8		;15F1 90 05
		lda #$10		;15F3 A9 10
		sta L_C30F		;15F5 8D 0F C3
.L_15F8	lda ZP_A4		;15F8 A5 A4
		lsr A			;15FA 4A
		eor ZP_B2		;15FB 45 B2
		sta L_C353		;15FD 8D 53 C3

.L_1600	rts				;1600 60

.L_1601	equb $20,$50,$60,$70,$70,$60,$50,$20,$E0,$B0,$A0,$90,$90,$A0,$B0,$E0
}

.L_1611
{
		ldx #$3B		;1611 A2 3B
.L_1613	lda #$00		;1613 A9 00
		sta L_C77F		;1615 8D 7F C7
		sta L_C728,X	;1618 9D 28 C7
		cpx #$0C		;161B E0 0C
		bcs L_1628		;161D B0 09
		txa				;161F 8A
		sta L_C758,X	;1620 9D 58 C7
		lda #$0A		;1623 A9 0A
		sta L_83B0,X	;1625 9D B0 83
.L_1628	dex				;1628 CA
.L_1629	bpl L_1613		;1629 10 E8
		rts				;162B 60
}

.save_rndQ_stateQ
{
		ldx #$04		;162C A2 04
.L_162E	lda ZP_02,X		;162E B5 02
		sta L_1648,X	;1630 9D 48 16
		dex				;1633 CA
		bpl L_162E		;1634 10 F8
		rts				;1636 60
}

.L_1637
{
		ldx #$04		;1637 A2 04
.L_1639	lda L_1643,Y	;1639 B9 43 16
		sta ZP_02,X		;163C 95 02
		dey				;163E 88
		dex				;163F CA
		bpl L_1639		;1640 10 F7
		rts				;1642 60

.L_1643	equb $B1,$86,$77,$8F,$8D
}

.L_1648	equb $B1,$65,$3B,$17,$3B

.start_of_frame
{
		ldx #$3F		;164D A2 3F
.L_164F	lda L_C280,X	;164F BD 80 C2
		sta L_C640,X	;1652 9D 40 C6
		lda L_C2C0,X	;1655 BD C0 C2
		sta L_C680,X	;1658 9D 80 C6
		lda #$00		;165B A9 00
		sta L_0280,X	;165D 9D 80 02
		sta L_02C0,X	;1660 9D C0 02
		dex				;1663 CA
		bpl L_164F		;1664 10 E9
		jsr clear_screen_with_sysctl		;1666 20 23 2C
		jsr L_F1DC		;1669 20 DC F1
		lda #$00		;166C A9 00
		sta L_C3A9		;166E 8D A9 C3
		sta L_C3DA		;1671 8D DA C3
		sta ZP_6D		;1674 85 6D
;L_1676
		sta L_C303		;1676 8D 03 C3
		rts				;1679 60
}

; only called from main loop
.L_167A_from_main_loop
{
		jsr start_of_frame		;167A 20 4D 16
		lda ZP_2F		;167D A5 2F
		bne L_1688		;167F D0 07
		bit ZP_6B		;1681 24 6B
		bpl L_1688		;1683 10 03
		jsr L_2C51		;1685 20 51 2C
.L_1688	lda #$00		;1688 A9 00
		sta ZP_0B		;168A 85 0B
		sta ZP_0C		;168C 85 0C
		jsr L_FF6A		;168E 20 6A FF
		bcs L_16A2		;1691 B0 0F
		cmp #$FF		;1693 C9 FF
		bne L_16B4		;1695 D0 1D
		lda ZP_AF		;1697 A5 AF
		ldy ZP_B1		;1699 A4 B1
		jsr L_F117		;169B 20 17 F1
		cmp #$FF		;169E C9 FF
		bne L_16B4		;16A0 D0 12
.L_16A2	lda #$C0		;16A2 A9 C0
		sta ZP_6B		;16A4 85 6B
		lda L_C76C		;16A6 AD 6C C7
		bpl L_16B1		;16A9 10 06
		jsr update_aicar		;16AB 20 85 1E
		jsr L_E4DA		;16AE 20 DA E4
.L_16B1	jmp L_1757		;16B1 4C 57 17
.L_16B4	sta ZP_2E		;16B4 85 2E
		jsr L_9A38		;16B6 20 38 9A
		jsr L_F2B7		;16B9 20 B7 F2
		lda ZP_2E		;16BC A5 2E
		sta L_C374		;16BE 8D 74 C3
		bit ZP_6B		;16C1 24 6B
		bvs L_16C8		;16C3 70 03
		sta L_C309		;16C5 8D 09 C3
.L_16C8	jsr L_9C79		;16C8 20 79 9C
		lda #$80		;16CB A9 80
		sta ZP_CC		;16CD 85 CC
		sta ZP_CD		;16CF 85 CD
		lda L_C76C		;16D1 AD 6C C7
		bpl L_16E2		;16D4 10 0C
		jsr update_aicar		;16D6 20 85 1E
		jsr L_F585		;16D9 20 85 F5
		jsr L_1D25		;16DC 20 25 1D
		jsr L_E4DA		;16DF 20 DA E4
.L_16E2	lda L_C374		;16E2 AD 74 C3
		sta ZP_2E		;16E5 85 2E
		lda #$00		;16E7 A9 00
		sta ZP_D0		;16E9 85 D0
		lda ZP_8E		;16EB A5 8E
		bpl L_16F6		;16ED 10 07
		jsr L_CFC5		;16EF 20 C5 CF
		lda #$00		;16F2 A9 00
		sta ZP_8E		;16F4 85 8E
.L_16F6	lda ZP_8E		;16F6 A5 8E
		bne L_1707		;16F8 D0 0D
		jsr L_CFD2		;16FA 20 D2 CF
		cpx ZP_A6		;16FD E4 A6
		bne L_1704		;16FF D0 03
		jsr L_E195		;1701 20 95 E1
.L_1704	jsr L_CFC5		;1704 20 C5 CF
.L_1707	jsr L_177D		;1707 20 7D 17
		jsr L_1B0B		;170A 20 0B 1B
		jsr L_1A3B		;170D 20 3B 1A
		lda #$00		;1710 A9 00
		sta ZP_27		;1712 85 27
		lda #$02		;1714 A9 02
		sta ZP_D0		;1716 85 D0
		jsr L_1909		;1718 20 09 19
		jsr L_CFC5		;171B 20 C5 CF
		jsr L_177D		;171E 20 7D 17
		jsr L_1A3B		;1721 20 3B 1A
		jsr L_1909		;1724 20 09 19
		ldy L_C77D		;1727 AC 7D C7
		cpy #$05		;172A C0 05
		bne L_173D		;172C D0 0F
		lda #$31		;172E A9 31
		sec				;1730 38
		sbc L_C374		;1731 ED 74 C3
		cmp #$03		;1734 C9 03
		bcs L_173D		;1736 B0 05
		clc				;1738 18
		adc #$02		;1739 69 02
		bne L_173F		;173B D0 02

\\ According to https://www.c64-wiki.com/wiki/Stunt_Car_Racer changing this number to $06 will increase the draw distance...

.L_173D	lda #$02		;173D A9 02
.L_173F	ldy ZP_2F		;173F A4 2F
		beq L_1745		;1741 F0 02
		lda #$05		;1743 A9 05
.L_1745	sta ZP_28		;1745 85 28
.L_1747	jsr L_CFC5		;1747 20 C5 CF
		jsr L_177D		;174A 20 7D 17
		jsr L_1A3B		;174D 20 3B 1A
		jsr L_1909		;1750 20 09 19
		dec ZP_28		;1753 C6 28
		bne L_1747		;1755 D0 F0
.L_1757	jsr L_2C44_with_sysctl		;1757 20 44 2C
		jsr L_2C3A_with_sysctl		;175A 20 3A 2C
		bit L_C303		;175D 2C 03 C3
		bpl L_1779		;1760 10 17
		ldx ZP_60		;1762 A6 60
		jmp L_1773		;1764 4C 73 17
.L_1767	lda L_C500,X	;1767 BD 00 C5
		cmp L_C600,X	;176A DD 00 C6
		bcs L_1772		;176D B0 03
		sta L_C600,X	;176F 9D 00 C6
.L_1772	inx				;1772 E8
.L_1773	cpx ZP_61		;1773 E4 61
		bcc L_1767		;1775 90 F0
		beq L_1767		;1777 F0 EE
.L_1779	jsr L_2C2B_with_sysctl		;1779 20 2B 2C
		rts				;177C 60
}

.L_177D
{
		ldx ZP_2E		;177D A6 2E
		jsr get_track_segment_detailsQ		;177F 20 2F F0
		ldx ZP_2E		;1782 A6 2E
		jsr L_F0C5		;1784 20 C5 F0
		lda ZP_68		;1787 A5 68
		sec				;1789 38
		sbc ZP_1D		;178A E5 1D
		sta ZP_3D		;178C 85 3D
		jsr L_1948		;178E 20 48 19
		ldx ZP_27		;1791 A6 27
		beq L_17A1		;1793 F0 0C
		lda L_A32E,X	;1795 BD 2E A3
		sta L_C396		;1798 8D 96 C3
		lda L_A32F,X	;179B BD 2F A3
		sta L_C397		;179E 8D 97 C3
.L_17A1	lda ZP_3D		;17A1 A5 3D
		eor ZP_A4		;17A3 45 A4
		bit L_C361		;17A5 2C 61 C3
		bpl L_17B0		;17A8 10 06
		bit ZP_B2		;17AA 24 B2
		bmi L_17B4		;17AC 30 06
		bvc L_17B4		;17AE 50 04
.L_17B0	bit ZP_9D		;17B0 24 9D
		bpl L_17B7		;17B2 10 03
.L_17B4	clc				;17B4 18
		adc #$40		;17B5 69 40
.L_17B7	sta L_C3A8		;17B7 8D A8 C3
		and #$FF		;17BA 29 FF
		bpl L_17D8		;17BC 10 1A
		sta L_C3A9		;17BE 8D A9 C3
		lda #$00		;17C1 A9 00
		sta ZP_D0		;17C3 85 D0
		jsr L_F440		;17C5 20 40 F4
		lda ZP_D8		;17C8 A5 D8
		clc				;17CA 18
		adc ZP_62		;17CB 65 62
		and #$02		;17CD 29 02
		sta ZP_D8		;17CF 85 D8
		lda ZP_A4		;17D1 A5 A4
		bne L_17DF		;17D3 D0 0A
		jmp L_1829		;17D5 4C 29 18
.L_17D8	lda ZP_A4		;17D8 A5 A4
		beq L_17DF		;17DA F0 03
		jmp L_1829		;17DC 4C 29 18
.L_17DF	ldy #$00		;17DF A0 00
		lda (ZP_9A),Y	;17E1 B1 9A
		clc				;17E3 18
		adc #$07		;17E4 69 07
		sta ZP_9F		;17E6 85 9F
		ldx ZP_D0		;17E8 A6 D0
.L_17EA	lda L_A330,X	;17EA BD 30 A3
		bmi L_1821		;17ED 30 32
		lda #$80		;17EF A9 80
		sta L_A350,X	;17F1 9D 50 A3
		cpx ZP_27		;17F4 E4 27
		bcs L_1800		;17F6 B0 08
		lda #$80		;17F8 A9 80
		sta L_A330,X	;17FA 9D 30 A3
		jmp L_1821		;17FD 4C 21 18
.L_1800	txa				;1800 8A
		asl A			;1801 0A
		asl A			;1802 0A
		adc ZP_9F		;1803 65 9F
		tay				;1805 A8
		jsr L_A026		;1806 20 26 A0
		jsr L_2458		;1809 20 58 24
		jsr L_25EA		;180C 20 EA 25
		txa				;180F 8A
		eor ZP_D8		;1810 45 D8
		and #$02		;1812 29 02
		bne L_1819		;1814 D0 03
		jsr L_18AB		;1816 20 AB 18
.L_1819	txa				;1819 8A
		and #$01		;181A 29 01
		tay				;181C A8
		txa				;181D 8A
		sta ZP_CC,Y		;181E 99 CC 00
.L_1821	inx				;1821 E8
		cpx ZP_9E		;1822 E4 9E
		bne L_17EA		;1824 D0 C4
		jmp L_1883		;1826 4C 83 18
.L_1829	lda ZP_9E		;1829 A5 9E
		sec				;182B 38
		sbc #$01		;182C E9 01
		asl A			;182E 0A
		asl A			;182F 0A
		sta ZP_14		;1830 85 14
		ldy #$00		;1832 A0 00
		lda (ZP_9A),Y	;1834 B1 9A
		clc				;1836 18
		adc #$07		;1837 69 07
		clc				;1839 18
		adc ZP_14		;183A 65 14
		sta ZP_A0		;183C 85 A0
		sta ZP_9F		;183E 85 9F
		ldx ZP_D0		;1840 A6 D0
.L_1842	lda L_A330,X	;1842 BD 30 A3
		bmi L_187E		;1845 30 37
		lda #$80		;1847 A9 80
		sta L_A350,X	;1849 9D 50 A3
		cpx ZP_27		;184C E4 27
		bcs L_1858		;184E B0 08
		lda #$80		;1850 A9 80
		sta L_A330,X	;1852 9D 30 A3
		jmp L_187E		;1855 4C 7E 18
.L_1858	txa				;1858 8A
		asl A			;1859 0A
		asl A			;185A 0A
		sta ZP_14		;185B 85 14
		lda ZP_9F		;185D A5 9F
		sec				;185F 38
		sbc ZP_14		;1860 E5 14
		tay				;1862 A8
		jsr L_A026		;1863 20 26 A0
		jsr L_2458		;1866 20 58 24
		jsr L_25EA		;1869 20 EA 25
		txa				;186C 8A
		eor ZP_D8		;186D 45 D8
		and #$02		;186F 29 02
		bne L_1876		;1871 D0 03
		jsr L_18AB		;1873 20 AB 18
.L_1876	txa				;1876 8A
		and #$01		;1877 29 01
		tay				;1879 A8
		txa				;187A 8A
		sta ZP_CC,Y		;187B 99 CC 00
.L_187E	inx				;187E E8
		cpx ZP_9E		;187F E4 9E
		bne L_1842		;1881 D0 BF
.L_1883	lda L_A1FE,X	;1883 BD FE A1
		sta L_A21E		;1886 8D 1E A2
		lda L_A296,X	;1889 BD 96 A2
		sta L_A2B6		;188C 8D B6 A2
		lda L_A1FF,X	;188F BD FF A1
		sta L_A21F		;1892 8D 1F A2
		lda L_A297,X	;1895 BD 97 A2
		sta L_A2B7		;1898 8D B7 A2
		ldx ZP_D0		;189B A6 D0
.L_189D	lda L_A330,X	;189D BD 30 A3
		bmi L_18A5		;18A0 30 03
		jsr L_280E		;18A2 20 0E 28
.L_18A5	inx				;18A5 E8
		cpx ZP_9E		;18A6 E4 9E
		bne L_189D		;18A8 D0 F3
		rts				;18AA 60
.L_18AB	txa				;18AB 8A
		and #$01		;18AC 29 01
		tay				;18AE A8
		lda ZP_CC,Y		;18AF B9 CC 00
		bmi L_1908		;18B2 30 54
		tay				;18B4 A8
		cpy #$02		;18B5 C0 02
		bcs L_18BE		;18B7 B0 05
		tya				;18B9 98
		clc				;18BA 18
		adc #$1E		;18BB 69 1E
		tay				;18BD A8
.L_18BE	txa				;18BE 8A
		and #$01		;18BF 29 01
		bne L_18D5		;18C1 D0 12
		lda L_A200,X	;18C3 BD 00 A2
		sec				;18C6 38
		sbc L_A200,Y	;18C7 F9 00 A2
		lda L_A298,X	;18CA BD 98 A2
		sbc L_A298,Y	;18CD F9 98 A2
		bpl L_1908		;18D0 10 36
		jmp L_18E4		;18D2 4C E4 18
.L_18D5	lda L_A200,Y	;18D5 B9 00 A2
		sec				;18D8 38
		sbc L_A200,X	;18D9 FD 00 A2
		lda L_A298,Y	;18DC B9 98 A2
		sbc L_A298,X	;18DF FD 98 A2
		bpl L_1908		;18E2 10 24
.L_18E4	lda #$02		;18E4 A9 02
		sta L_A350,X	;18E6 9D 50 A3
		lda #$00		;18E9 A9 00
		sta L_8060,X	;18EB 9D 60 80
		lda L_A298,X	;18EE BD 98 A2
		sta L_A2B8,X	;18F1 9D B8 A2
		lda L_A200,X	;18F4 BD 00 A2
		sta L_A220,X	;18F7 9D 20 A2
		txa				;18FA 8A
		ora #$20		;18FB 09 20
		tax				;18FD AA
		jsr L_25EA		;18FE 20 EA 25
		jsr L_2809		;1901 20 09 28
		txa				;1904 8A
		and #$1F		;1905 29 1F
		tax				;1907 AA
.L_1908	rts				;1908 60
}

.L_1909
{
		bit L_C3A9		;1909 2C A9 C3
		bmi L_1943		;190C 30 35
		ldx ZP_9E		;190E A6 9E
		ldy #$01		;1910 A0 01
.L_1912	dex				;1912 CA
		lda L_A200,X	;1913 BD 00 A2
		sta L_A200,Y	;1916 99 00 A2
		lda L_A298,X	;1919 BD 98 A2
		sta L_A298,Y	;191C 99 98 A2
		lda L_A24C,X	;191F BD 4C A2
		sta L_A24C,Y	;1922 99 4C A2
		lda L_A2E4,X	;1925 BD E4 A2
		sta L_A2E4,Y	;1928 99 E4 A2
		lda L_A330,X	;192B BD 30 A3
		sta L_A330,Y	;192E 99 30 A3
		lda L_8040,X	;1931 BD 40 80
		sta L_8040,Y	;1934 99 40 80
		dey				;1937 88
		bpl L_1912		;1938 10 D8
		lda #$00		;193A A9 00
		sta ZP_CC		;193C 85 CC
		lda #$01		;193E A9 01
		sta ZP_CD		;1940 85 CD
		rts				;1942 60
.L_1943	lda #$00		;1943 A9 00
		sta ZP_D0		;1945 85 D0
		rts				;1947 60
}

.L_1948
{
		lda #$2A		;1948 A9 2A
		sec				;194A 38
		sbc ZP_D3		;194B E5 D3
		bpl L_1951		;194D 10 02
		lda #$00		;194F A9 00
.L_1951	sta ZP_19		;1951 85 19
		lda ZP_D3		;1953 A5 D3
		clc				;1955 18
		adc ZP_BE		;1956 65 BE
		sta ZP_D3		;1958 85 D3
		lda #$00		;195A A9 00
		ldx ZP_62		;195C A6 62
		ldy ZP_2E		;195E A4 2E
		cpy L_C766		;1960 CC 66 C7
		bne L_1967		;1963 D0 02
		lda #$01		;1965 A9 01
.L_1967	sta L_8080,X	;1967 9D 80 80
		ldy #$00		;196A A0 00
		ldx ZP_D0		;196C A6 D0
		bne L_1987		;196E D0 17
		sty ZP_97		;1970 84 97
		bit ZP_A2		;1972 24 A2
		bpl L_1980		;1974 10 0A
		lda (ZP_98),Y	;1976 B1 98
		bmi L_197D		;1978 30 03
		jmp L_19FB		;197A 4C FB 19
.L_197D	jmp L_19F6		;197D 4C F6 19
.L_1980	lda (ZP_98),Y	;1980 B1 98
		bmi L_19A5		;1982 30 21
		jmp L_19AA		;1984 4C AA 19
.L_1987	ldy #$01		;1987 A0 01
		sty ZP_97		;1989 84 97
		bit ZP_A2		;198B 24 A2
		bpl L_1992		;198D 10 03
		jmp L_19DD		;198F 4C DD 19
.L_1992	lda (ZP_98),Y	;1992 B1 98
		bmi L_19A5		;1994 30 0F
		cpy ZP_19		;1996 C4 19
		bcc L_19AA		;1998 90 10
		lda #$80		;199A A9 80
		sta L_A330,X	;199C 9D 30 A3
		sta L_A331,X	;199F 9D 31 A3
		jmp L_19D2		;19A2 4C D2 19
.L_19A5	lda #$00		;19A5 A9 00
		sta L_8080,X	;19A7 9D 80 80
.L_19AA	lda (ZP_98),Y	;19AA B1 98
		asl A			;19AC 0A
		and #$E0		;19AD 29 E0
		clc				;19AF 18
		adc ZP_3F		;19B0 65 3F
		sta L_8040,X	;19B2 9D 40 80
		lda (ZP_98),Y	;19B5 B1 98
		and #$0F		;19B7 29 0F
		adc ZP_35		;19B9 65 35
		sta L_A330,X	;19BB 9D 30 A3
		lda (ZP_CA),Y	;19BE B1 CA
		asl A			;19C0 0A
		and #$E0		;19C1 29 E0
		clc				;19C3 18
		adc ZP_40		;19C4 65 40
		sta L_8041,X	;19C6 9D 41 80
		lda (ZP_CA),Y	;19C9 B1 CA
		and #$0F		;19CB 29 0F
		adc ZP_36		;19CD 65 36
		sta L_A331,X	;19CF 9D 31 A3
.L_19D2	iny				;19D2 C8
		inx				;19D3 E8
		inx				;19D4 E8
		cpx ZP_62		;19D5 E4 62
		bcc L_1992		;19D7 90 B9
		beq L_19AA		;19D9 F0 CF
		bne L_1A32		;19DB D0 55
.L_19DD	lda ZP_97		;19DD A5 97
		asl A			;19DF 0A
		tay				;19E0 A8
		lda (ZP_98),Y	;19E1 B1 98
		bmi L_19F6		;19E3 30 11
		lda ZP_97		;19E5 A5 97
		cmp ZP_19		;19E7 C5 19
		bcc L_19FB		;19E9 90 10
		lda #$80		;19EB A9 80
		sta L_A330,X	;19ED 9D 30 A3
		sta L_A331,X	;19F0 9D 31 A3
		jmp L_1A21		;19F3 4C 21 1A
.L_19F6	lda #$00		;19F6 A9 00
		sta L_8080,X	;19F8 9D 80 80
.L_19FB	iny				;19FB C8
		lda (ZP_98),Y	;19FC B1 98
		clc				;19FE 18
		adc ZP_3F		;19FF 65 3F
		sta L_8040,X	;1A01 9D 40 80
		dey				;1A04 88
		lda (ZP_98),Y	;1A05 B1 98
		and #$7F		;1A07 29 7F
		adc ZP_35		;1A09 65 35
		sta L_A330,X	;1A0B 9D 30 A3
		iny				;1A0E C8
		lda (ZP_CA),Y	;1A0F B1 CA
		clc				;1A11 18
		adc ZP_40		;1A12 65 40
		sta L_8041,X	;1A14 9D 41 80
		dey				;1A17 88
		lda (ZP_CA),Y	;1A18 B1 CA
		and #$7F		;1A1A 29 7F
		adc ZP_36		;1A1C 65 36
		sta L_A331,X	;1A1E 9D 31 A3
.L_1A21	inc ZP_97		;1A21 E6 97
		inx				;1A23 E8
		inx				;1A24 E8
		cpx ZP_62		;1A25 E4 62
		bcc L_19DD		;1A27 90 B4
		bne L_1A33		;1A29 D0 08
		lda ZP_97		;1A2B A5 97
		asl A			;1A2D 0A
		tay				;1A2E A8
		jmp L_19FB		;1A2F 4C FB 19
.L_1A32	dey				;1A32 88
.L_1A33	lda (ZP_98),Y	;1A33 B1 98
		bpl L_1A3A		;1A35 10 03
		sta L_807E,X	;1A37 9D 7E 80
.L_1A3A	rts				;1A3A 60
}

.L_1A3B
{
		lda #$01		;1A3B A9 01
		bit L_C3A8		;1A3D 2C A8 C3
		bvc L_1A44		;1A40 50 02
		eor #$01		;1A42 49 01
.L_1A44	sta ZP_CD		;1A44 85 CD
		tax				;1A46 AA
		eor #$01		;1A47 49 01
		sta ZP_CC		;1A49 85 CC
		inx				;1A4B E8
		inx				;1A4C E8
		stx ZP_C6		;1A4D 86 C6
.L_1A4F	lda #$01		;1A4F A9 01
		sta ZP_A0		;1A51 85 A0
		lda ZP_D2		;1A53 A5 D2
		cmp #$28		;1A55 C9 28
		bcc L_1A5D		;1A57 90 04
		ldx #$00		;1A59 A2 00
		beq L_1A65		;1A5B F0 08
.L_1A5D	lda ZP_C6		;1A5D A5 C6
		eor ZP_D8		;1A5F 45 D8
		lsr A			;1A61 4A
		and #$01		;1A62 29 01
		tax				;1A64 AA
.L_1A65	jsr set_linedraw_colour		;1A65 20 01 FC
		lda ZP_C6		;1A68 A5 C6
		lsr A			;1A6A 4A
		sec				;1A6B 38
		sbc #$01		;1A6C E9 01
		cmp ZP_A3		;1A6E C5 A3
		bne L_1A7B		;1A70 D0 09
		lda ZP_A6		;1A72 A5 A6
		cmp ZP_2E		;1A74 C5 2E
		bne L_1A7B		;1A76 D0 03
		jsr L_E195		;1A78 20 95 E1
.L_1A7B	ldx ZP_C6		;1A7B A6 C6
		lda L_A330,X	;1A7D BD 30 A3
		bmi L_1ABA		;1A80 30 38
		lda L_A350,X	;1A82 BD 50 A3
		bmi L_1AA8		;1A85 30 21
		lda L_C3DC		;1A87 AD DC C3
		bpl L_1AA5		;1A8A 10 19
		lda ZP_C6		;1A8C A5 C6
		and #$01		;1A8E 29 01
		beq L_1AA0		;1A90 F0 0E
		bit L_0126		;1A92 2C 26 01
		bmi L_1AA5		;1A95 30 0E
.L_1A97	jsr L_1AF7		;1A97 20 F7 1A
		jsr L_1B02		;1A9A 20 02 1B
		jmp L_1AAB		;1A9D 4C AB 1A
.L_1AA0	bit L_0126		;1AA0 2C 26 01
		bmi L_1A97		;1AA3 30 F2
.L_1AA5	jsr L_1B02		;1AA5 20 02 1B
.L_1AA8	jsr L_1AF7		;1AA8 20 F7 1A
.L_1AAB	ldy ZP_A0		;1AAB A4 A0
		lda ZP_C6		;1AAD A5 C6
		sta ZP_CC,Y		;1AAF 99 CC 00
		bit L_C366		;1AB2 2C 66 C3
		bpl L_1ABA		;1AB5 10 03
		jsr L_E1B1		;1AB7 20 B1 E1
.L_1ABA	lda ZP_C6		;1ABA A5 C6
		eor #$01		;1ABC 49 01
		sta ZP_C6		;1ABE 85 C6
		dec ZP_A0		;1AC0 C6 A0
		bpl L_1A7B		;1AC2 10 B7
		ldx ZP_C6		;1AC4 A6 C6
		txa				;1AC6 8A
		and #$FE		;1AC7 29 FE
		tay				;1AC9 A8
		lda L_8080,Y	;1ACA B9 80 80
		bmi L_1AE6		;1ACD 30 17
		and #$03		;1ACF 29 03
		tax				;1AD1 AA
		lda #$80		;1AD2 A9 80
		sta L_8080,Y	;1AD4 99 80 80
		jsr set_linedraw_colour		;1AD7 20 01 FC
		jsr L_CF73		;1ADA 20 73 CF
		ldx ZP_C6		;1ADD A6 C6
		txa				;1ADF 8A
		eor #$01		;1AE0 49 01
		tay				;1AE2 A8
		jsr L_FE91_with_draw_line		;1AE3 20 91 FE
.L_1AE6	inc ZP_D2		;1AE6 E6 D2
		lda ZP_C6		;1AE8 A5 C6
		clc				;1AEA 18
		adc #$02		;1AEB 69 02
		sta ZP_C6		;1AED 85 C6
		cmp ZP_9E		;1AEF C5 9E
		bcs L_1AF6		;1AF1 B0 03
		jmp L_1A4F		;1AF3 4C 4F 1A
.L_1AF6	rts				;1AF6 60
}

.L_1AF7
{
		ldx ZP_C6		;1AF7 A6 C6
		ldy ZP_A0		;1AF9 A4 A0
		lda ZP_CC,Y		;1AFB B9 CC 00
		tay				;1AFE A8
		jmp L_FE91_with_draw_line		;1AFF 4C 91 FE
}

.L_1B02
{
		ldx ZP_C6		;1B02 A6 C6
		txa				;1B04 8A
		ora #$20		;1B05 09 20
		tay				;1B07 A8
		jmp L_FE91_with_draw_line		;1B08 4C 91 FE
}

.L_1B0B
{
		ldx ZP_27		;1B0B A6 27
		lda #$02		;1B0D A9 02
		sta ZP_A0		;1B0F 85 A0
.L_1B11	lda L_A298,X	;1B11 BD 98 A2
		bne L_1B2F		;1B14 D0 19
		lda L_A200,X	;1B16 BD 00 A2
		cmp #$40		;1B19 C9 40
		bcc L_1B2F		;1B1B 90 12
		cmp #$C0		;1B1D C9 C0
		bcs L_1B2F		;1B1F B0 0E
		lda L_A2E4,X	;1B21 BD E4 A2
		bmi L_1B35		;1B24 30 0F
		bne L_1B2F		;1B26 D0 07
		lda L_A24C,X	;1B28 BD 4C A2
		cmp #$C0		;1B2B C9 C0
		bcc L_1B35		;1B2D 90 06
.L_1B2F	inx				;1B2F E8
		dec ZP_A0		;1B30 C6 A0
		bne L_1B11		;1B32 D0 DD
		rts				;1B34 60
.L_1B35	stx ZP_C6		;1B35 86 C6
		txa				;1B37 8A
		and #$01		;1B38 29 01
		sta ZP_C7		;1B3A 85 C7
		tay				;1B3C A8
		lda L_C396,Y	;1B3D B9 96 C3
		sta L_A32E,X	;1B40 9D 2E A3
		lda ZP_8E		;1B43 A5 8E
		jsr L_E808		;1B45 20 08 E8
		ldx ZP_C7		;1B48 A6 C7
		ldy #$04		;1B4A A0 04
		lda ZP_8D		;1B4C A5 8D
		jsr L_E631		;1B4E 20 31 E6
		ldx ZP_C6		;1B51 A6 C6
		lda ZP_8D		;1B53 A5 8D
		sta ZP_15		;1B55 85 15
		lda L_8040,X	;1B57 BD 40 80
		sec				;1B5A 38
		sbc L_803E,X	;1B5B FD 3E 80
		sta ZP_14		;1B5E 85 14
		lda L_A330,X	;1B60 BD 30 A3
		sbc L_A32E,X	;1B63 FD 2E A3
		jsr mul_8_16_16bit		;1B66 20 45 C8
		sta ZP_15		;1B69 85 15
		lda L_803E,X	;1B6B BD 3E 80
		clc				;1B6E 18
		adc ZP_14		;1B6F 65 14
		sta L_803E,X	;1B71 9D 3E 80
		lda L_A32E,X	;1B74 BD 2E A3
		adc ZP_15		;1B77 65 15
		sta L_A32E,X	;1B79 9D 2E A3
		dex				;1B7C CA
		dex				;1B7D CA
		ldy #$04		;1B7E A0 04
		jsr L_E641		;1B80 20 41 E6
		ldx ZP_C6		;1B83 A6 C6
		jmp L_1B2F		;1B85 4C 2F 1B
}

.update_damage_display
{
		lda L_C3CB		;1B88 AD CB C3
		cmp ZP_25		;1B8B C5 25
		beq L_1B91		;1B8D F0 02
		bcs L_1B92		;1B8F B0 01
.L_1B91	rts				;1B91 60
.L_1B92	inc ZP_25		;1B92 E6 25
		ldy L_1C15		;1B94 AC 15 1C
		jsr rndQ		;1B97 20 B9 29
		lsr A			;1B9A 4A
		bcc L_1BB5		;1B9B 90 18
		lsr A			;1B9D 4A
		bcc L_1BAC		;1B9E 90 0C
		cpy #$05		;1BA0 C0 05
		bcc L_1BA8		;1BA2 90 04
		lsr A			;1BA4 4A
		bcc L_1BAC		;1BA5 90 05
		dey				;1BA7 88
.L_1BA8	iny				;1BA8 C8
		jmp L_1BB5		;1BA9 4C B5 1B
.L_1BAC	cpy #$03		;1BAC C0 03
		bcs L_1BB4		;1BAE B0 04
		lsr A			;1BB0 4A
		bcc L_1BA8		;1BB1 90 F5
		iny				;1BB3 C8
.L_1BB4	dey				;1BB4 88
.L_1BB5	sty L_1C15		;1BB5 8C 15 1C
		lda ZP_25		;1BB8 A5 25
		cmp #$78		;1BBA C9 78
		bcc L_1BC3		;1BBC 90 05
		dec ZP_25		;1BBE C6 25
.L_1BC0	jmp L_1572		;1BC0 4C 72 15
.L_1BC3	lsr A			;1BC3 4A
		lsr A			;1BC4 4A
		tay				;1BC5 A8
		lda ZP_25		;1BC6 A5 25
		and #$03		;1BC8 29 03
		tax				;1BCA AA
		lda ZP_25		;1BCB A5 25
		asl A			;1BCD 0A
		and #$F8		;1BCE 29 F8
		ora L_1C15		;1BD0 0D 15 1C
		tay				;1BD3 A8
		lda L_6028,Y	;1BD4 B9 28 60
		and L_1C1A,X	;1BD7 3D 1A 1C
		beq L_1BFD		;1BDA F0 21
		lda L_6028,Y	;1BDC B9 28 60
		and L_1C16,X	;1BDF 3D 16 1C
		sta L_6028,Y	;1BE2 99 28 60
		lda L_6027,Y	;1BE5 B9 27 60
		and L_1C16,X	;1BE8 3D 16 1C
		sta L_6027,Y	;1BEB 99 27 60
		lda L_6026,Y	;1BEE B9 26 60
		and L_1C16,X	;1BF1 3D 16 1C
		ora L_1C1A,X	;1BF4 1D 1A 1C
		sta L_6026,Y	;1BF7 99 26 60
		jmp update_damage_display		;1BFA 4C 88 1B
.L_1BFD	inc L_C3CB		;1BFD EE CB C3
		bmi L_1BC0		;1C00 30 BE
		jsr L_1C08		;1C02 20 08 1C
		jmp update_damage_display		;1C05 4C 88 1B
.L_1C08	ldy #$02		;1C08 A0 02
.L_1C0A	lda L_C3CB		;1C0A AD CB C3
		asl A			;1C0D 0A
		sta L_C3C3,Y	;1C0E 99 C3 C3
		dey				;1C11 88
		bpl L_1C0A		;1C12 10 F6
		rts				;1C14 60

.L_1C15	equb $04
.L_1C16	equb $3F,$CF,$F3,$FC
.L_1C1A	equb $C0,$30,$0C,$03
}

.draw_crane_with_sysctl
{
		lda #$3F		;1C1E A9 3F
		jmp sysctl		;1C20 4C 25 87
}

.clear_menu_area
{
		ldx #$10		;1C23 A2 10
		lda #$4B		;1C25 A9 4B
		sta ZP_1F		;1C27 85 1F
		lda #$60		;1C29 A9 60
		sta ZP_1E		;1C2B 85 1E
.L_1C2D	ldy #$DF		;1C2D A0 DF
		lda #$00		;1C2F A9 00
.L_1C31	sta (ZP_1E),Y	;1C31 91 1E
		dey				;1C33 88
		cpy #$FF		;1C34 C0 FF
		bne L_1C31		;1C36 D0 F9
		lda ZP_1E		;1C38 A5 1E
		clc				;1C3A 18
		adc #$40		;1C3B 69 40
		sta ZP_1E		;1C3D 85 1E
		lda ZP_1F		;1C3F A5 1F
		adc #$01		;1C41 69 01
		sta ZP_1F		;1C43 85 1F
		dex				;1C45 CA
		bne L_1C2D		;1C46 D0 E5
		rts				;1C48 60
}

.draw_menu_header
{
		lda #$08		;1C49 A9 08
		sta ZP_52		;1C4B 85 52
		ldy #$40		;1C4D A0 40
		ldx #$00		;1C4F A2 00
		lda #$55		;1C51 A9 55
		jsr sysctl		;1C53 20 25 87
		ldx #$38		;1C56 A2 38
		ldy #$5F		;1C58 A0 5F
		lda #$20		;1C5A A9 20
		jsr L_3A3C		;1C5C 20 3C 3A
		lda #$32		;1C5F A9 32
		jmp sysctl		;1C61 4C 25 87
}

.L_1C64_with_keys
{
		jsr check_game_keys		;1C64 20 9E F7
		lda ZP_6A		;1C67 A5 6A
		beq L_1C7F		;1C69 F0 14
		lda ZP_2F		;1C6B A5 2F
		bne L_1C7F		;1C6D D0 10
		lda ZP_66		;1C6F A5 66
		and #$0C		;1C71 29 0C
		beq L_1C7F		;1C73 F0 0A
		cmp #$04		;1C75 C9 04
		beq L_1C7D		;1C77 F0 04
		lda #$0F		;1C79 A9 0F
		bne L_1C7F		;1C7B D0 02
.L_1C7D	lda #$F1		;1C7D A9 F1
.L_1C7F	sta ZP_C5		;1C7F 85 C5
		lda ZP_66		;1C81 A5 66
		and #$10		;1C83 29 10
		eor #$10		;1C85 49 10
		sta L_C398		;1C87 8D 98 C3
		ldy #$00		;1C8A A0 00
		ldx #$00		;1C8C A2 00
		lda L_0159		;1C8E AD 59 01
		bmi L_1C97		;1C91 30 04
		cmp #$78		;1C93 C9 78
		bcs L_1CC1		;1C95 B0 2A
.L_1C97	lda ZP_2F		;1C97 A5 2F
		bne L_1CC1		;1C99 D0 26
		lda ZP_0E		;1C9B A5 0E
		bne L_1CC1		;1C9D D0 22
		lda ZP_66		;1C9F A5 66
		and #$03		;1CA1 29 03
		cmp #$01		;1CA3 C9 01
		beq L_1CAE		;1CA5 F0 07
		bcs L_1CB8		;1CA7 B0 0F
		lda L_C39B		;1CA9 AD 9B C3
		bpl L_1CC1		;1CAC 10 13
.L_1CAE	ldx L_C384		;1CAE AE 84 C3
		ldy L_C385		;1CB1 AC 85 C3
		lda #$80		;1CB4 A9 80
		bne L_1CBE		;1CB6 D0 06
.L_1CB8	ldx #$10		;1CB8 A2 10
		ldy #$FF		;1CBA A0 FF
		lda #$00		;1CBC A9 00
.L_1CBE	sta L_C39B		;1CBE 8D 9B C3
.L_1CC1	stx L_0150		;1CC1 8E 50 01
		sty L_0151		;1CC4 8C 51 01
		jsr update_boosting		;1CC7 20 0F F6
		rts				;1CCA 60
}

.L_1CCB
{
		lda L_0124		;1CCB AD 24 01
		and #$80		;1CCE 29 80
		sta L_C365		;1CD0 8D 65 C3
		lda #$02		;1CD3 A9 02
		sta L_A29B		;1CD5 8D 9B A2
		lda #$FE		;1CD8 A9 FE
		sta L_A29A		;1CDA 8D 9A A2
		lda #$88		;1CDD A9 88
		sta L_A202		;1CDF 8D 02 A2
		lda #$78		;1CE2 A9 78
		sta L_A203		;1CE4 8D 03 A2
		ldx #$03		;1CE7 A2 03
.L_1CE9	lda #$00		;1CE9 A9 00
		sta L_A330,X	;1CEB 9D 30 A3
		sec				;1CEE 38
		sbc ZP_33		;1CEF E5 33
		sta L_A24C,X	;1CF1 9D 4C A2
		lda #$01		;1CF4 A9 01
		sbc ZP_69		;1CF6 E5 69
		sta L_A2E4,X	;1CF8 9D E4 A2
		jsr L_2809		;1CFB 20 09 28
		dex				;1CFE CA
		cpx #$02		;1CFF E0 02
		bcs L_1CE9		;1D01 B0 E6
		lda #$2C		;1D03 A9 2C
		jsr set_linedraw_op		;1D05 20 16 FC
		ldx #$02		;1D08 A2 02
		ldy #$03		;1D0A A0 03
		jsr L_FE91_with_draw_line		;1D0C 20 91 FE
		lda #$3D		;1D0F A9 3D
		jsr set_linedraw_op		;1D11 20 16 FC
		asl L_C365		;1D14 0E 65 C3
		rts				;1D17 60
}

.update_per_track_stuff
{
		lda L_C77D		;1D18 AD 7D C7
		cmp #$05		;1D1B C9 05
		beq L_1D20		;1D1D F0 01
		rts				;1D1F 60
.L_1D20	lda #$3C		;1D20 A9 3C
		jmp sysctl		;1D22 4C 25 87
}

.L_1D25
{
		ldx L_C773		;1D25 AE 73 C7
		ldy #$00		;1D28 A0 00
		sty L_C308		;1D2A 8C 08 C3
		lda ZP_B0		;1D2D A5 B0
		sta ZP_2C		;1D2F 85 2C
		sec				;1D31 38
		sbc ZP_2B		;1D32 E5 2B
		bcs L_1D3C		;1D34 B0 06
		eor #$FF		;1D36 49 FF
		clc				;1D38 18
		adc #$01		;1D39 69 01
		dey				;1D3B 88
.L_1D3C	sta ZP_51		;1D3C 85 51
		sty ZP_77		;1D3E 84 77
		lda ZP_3A		;1D40 A5 3A
		beq L_1D47		;1D42 F0 03
		jmp L_1DCB		;1D44 4C CB 1D
.L_1D47	lda ZP_39		;1D47 A5 39
		cmp #$40		;1D49 C9 40
		bcs L_1D5B		;1D4B B0 0E
		bit L_C36A		;1D4D 2C 6A C3
		bmi L_1D58		;1D50 30 06
		ldy ZP_51		;1D52 A4 51
		cpy #$32		;1D54 C0 32
		bcs L_1D5B		;1D56 B0 03
.L_1D58	dec L_C308		;1D58 CE 08 C3
.L_1D5B	cmp #$10		;1D5B C9 10
		bcs L_1D79		;1D5D B0 1A
		lda ZP_51		;1D5F A5 51
		cmp #$32		;1D61 C9 32
		bcs L_1D79		;1D63 B0 14
		lda ZP_B8		;1D65 A5 B8
		cmp #$01		;1D67 C9 01
		bcc L_1D73		;1D69 90 08
		bne L_1D79		;1D6B D0 0C
		lda ZP_B7		;1D6D A5 B7
		cmp #$80		;1D6F C9 80
		bcs L_1D79		;1D71 B0 06
.L_1D73	jsr L_209C		;1D73 20 9C 20
		jmp L_1D86		;1D76 4C 86 1D
.L_1D79	lda #$00		;1D79 A9 00
		sta L_C369		;1D7B 8D 69 C3
		sta ZP_E0		;1D7E 85 E0
		lda ZP_39		;1D80 A5 39
		cmp #$18		;1D82 C9 18
		bcs L_1D9E		;1D84 B0 18
.L_1D86	lda L_AEE0,X	;1D86 BD E0 AE
		and #$08		;1D89 29 08
		beq L_1D98		;1D8B F0 0B
		bit L_C36A		;1D8D 2C 6A C3
		bmi L_1D98		;1D90 30 06
		lda ZP_39		;1D92 A5 39
		cmp #$0E		;1D94 C9 0E
		bcs L_1DCB		;1D96 B0 33
.L_1D98	jsr L_1E30		;1D98 20 30 1E
		jmp L_1E00		;1D9B 4C 00 1E
.L_1D9E	bit L_C36A		;1D9E 2C 6A C3
		bmi L_1DC5		;1DA1 30 22
		cmp #$32		;1DA3 C9 32
		bcs L_1DB4		;1DA5 B0 0D
		lda L_AEE0,X	;1DA7 BD E0 AE
		and #$02		;1DAA 29 02
		beq L_1DBF		;1DAC F0 11
		jsr L_1E5A		;1DAE 20 5A 1E
		jmp L_1DE1		;1DB1 4C E1 1D
.L_1DB4	cmp #$C8		;1DB4 C9 C8
		bcs L_1DCB		;1DB6 B0 13
		lda L_AEE0,X	;1DB8 BD E0 AE
		and #$20		;1DBB 29 20
		beq L_1DCB		;1DBD F0 0C
.L_1DBF	jsr L_1E3C		;1DBF 20 3C 1E
		jmp L_1DE1		;1DC2 4C E1 1D
.L_1DC5	jsr L_1E3C		;1DC5 20 3C 1E
		jmp L_1E00		;1DC8 4C 00 1E
.L_1DCB	ldy #$40		;1DCB A0 40
		lda L_AEE0,X	;1DCD BD E0 AE
		and #$08		;1DD0 29 08
		beq L_1DD6		;1DD2 F0 02
		ldy #$6E		;1DD4 A0 6E
.L_1DD6	txa				;1DD6 8A
		and #$01		;1DD7 29 01
		beq L_1DDF		;1DD9 F0 04
		tya				;1DDB 98
		eor #$FF		;1DDC 49 FF
		tay				;1DDE A8
.L_1DDF	sty ZP_2C		;1DDF 84 2C
.L_1DE1	lda #$02		;1DE1 A9 02
		sta ZP_16		;1DE3 85 16
		ldx L_C375		;1DE5 AE 75 C3
		stx ZP_2E		;1DE8 86 2E
.L_1DEA	lda L_0400,X	;1DEA BD 00 04
		and #$0F		;1DED 29 0F
		tay				;1DEF A8
		lda L_B240,Y	;1DF0 B9 40 B2
		bpl L_1DF9		;1DF3 10 04
		lda #$80		;1DF5 A9 80
		sta ZP_2C		;1DF7 85 2C
.L_1DF9	jsr L_CFC5		;1DF9 20 C5 CF
		dec ZP_16		;1DFC C6 16
		bne L_1DEA		;1DFE D0 EA
.L_1E00	lda L_C357		;1E00 AD 57 C3
		bmi L_1E10		;1E03 30 0B
		bne L_1E18		;1E05 D0 11
		lda ZP_2C		;1E07 A5 2C
		sec				;1E09 38
		sbc ZP_B0		;1E0A E5 B0
		beq L_1E2F		;1E0C F0 21
		bcs L_1E18		;1E0E B0 08
.L_1E10	cmp #$F0		;1E10 C9 F0
		bcs L_1E2F		;1E12 B0 1B
		lda #$F6		;1E14 A9 F6
		bne L_1E1E		;1E16 D0 06
.L_1E18	cmp #$10		;1E18 C9 10
		bcc L_1E2F		;1E1A 90 13
		lda #$0A		;1E1C A9 0A
.L_1E1E	clc				;1E1E 18
		adc ZP_B0		;1E1F 65 B0
		ldy ZP_C9		;1E21 A4 C9
		beq L_1E2F		;1E23 F0 0A
		cmp #$E1		;1E25 C9 E1
		bcs L_1E2F		;1E27 B0 06
		cmp #$20		;1E29 C9 20
		bcc L_1E2F		;1E2B 90 02
		sta ZP_B0		;1E2D 85 B0
.L_1E2F	rts				;1E2F 60
.L_1E30	lda ZP_51		;1E30 A5 51
		cmp #$38		;1E32 C9 38
		bcs L_1E59		;1E34 B0 23
		bit ZP_77		;1E36 24 77
		bmi L_1E55		;1E38 30 1B
		bpl L_1E4C		;1E3A 10 10
.L_1E3C	lda ZP_51		;1E3C A5 51
		cmp #$38		;1E3E C9 38
		bcs L_1E59		;1E40 B0 17
		lda ZP_2B		;1E42 A5 2B
		bit ZP_77		;1E44 24 77
		bmi L_1E51		;1E46 30 09
		cmp #$A0		;1E48 C9 A0
		bcs L_1E55		;1E4A B0 09
.L_1E4C	lda #$E0		;1E4C A9 E0
		sta ZP_2C		;1E4E 85 2C
		rts				;1E50 60
.L_1E51	cmp #$60		;1E51 C9 60
		bcc L_1E4C		;1E53 90 F7
.L_1E55	lda #$20		;1E55 A9 20
		sta ZP_2C		;1E57 85 2C
.L_1E59	rts				;1E59 60
.L_1E5A	lda ZP_2B		;1E5A A5 2B
		sta ZP_2C		;1E5C 85 2C
		rts				;1E5E 60
}

.find_track_segment_index
{
		stx L_1E84		;1E5F 8E 84 1E
		txa				;1E62 8A
		ldx L_C374		;1E63 AE 74 C3
		cpx L_C764		;1E66 EC 64 C7
		bcs L_1E7D		;1E69 B0 12
.L_1E6B	cmp L_044E,X	;1E6B DD 4E 04
		beq L_1E7F		;1E6E F0 0F
		inx				;1E70 E8
		cpx L_C764		;1E71 EC 64 C7
		bcc L_1E78		;1E74 90 02
		ldx #$00		;1E76 A2 00
.L_1E78	cpx L_C374		;1E78 EC 74 C3
		bne L_1E6B		;1E7B D0 EE
.L_1E7D	ldx #$FF		;1E7D A2 FF
.L_1E7F	txa				;1E7F 8A
		ldx L_1E84		;1E80 AE 84 1E
		rts				;1E83 60

.L_1E84	equb $00
}

.update_aicar
{
		lda L_C37C		;1E85 AD 7C C3
		beq L_1EE1		;1E88 F0 57
		ldx L_C375		;1E8A AE 75 C3
		jsr get_track_segment_detailsQ		;1E8D 20 2F F0
		jsr L_21DE		;1E90 20 DE 21
		jsr L_158E		;1E93 20 8E 15
		jsr L_201B		;1E96 20 1B 20
		jsr L_2037		;1E99 20 37 20
		jsr L_1F48		;1E9C 20 48 1F
		lda ZP_BD		;1E9F A5 BD
		sta ZP_15		;1EA1 85 15
		lda ZP_D6		;1EA3 A5 D6
		sta ZP_14		;1EA5 85 14
		lda ZP_D7		;1EA7 A5 D7
		jsr mul_8_16_16bit		;1EA9 20 45 C8
		jsr L_FF8E		;1EAC 20 8E FF
		lda ZP_15		;1EAF A5 15
		ldy #$FD		;1EB1 A0 FD
		jsr shift_16bit		;1EB3 20 BF C9
		sta ZP_15		;1EB6 85 15
		lda ZP_A1		;1EB8 A5 A1
		clc				;1EBA 18
		adc ZP_14		;1EBB 65 14
		sta ZP_A1		;1EBD 85 A1
		lda ZP_23		;1EBF A5 23
		adc ZP_15		;1EC1 65 15
		sta ZP_23		;1EC3 85 23
		lda ZP_C4		;1EC5 A5 C4
		adc ZP_2D		;1EC7 65 2D
		sta ZP_C4		;1EC9 85 C4
		cmp ZP_BE		;1ECB C5 BE
		bcc L_1EE1		;1ECD 90 12
		sbc ZP_BE		;1ECF E5 BE
		sta ZP_C4		;1ED1 85 C4
		ldx L_C375		;1ED3 AE 75 C3
		inx				;1ED6 E8
		cpx L_C764		;1ED7 EC 64 C7
		bcc L_1EDE		;1EDA 90 02
		ldx #$00		;1EDC A2 00
.L_1EDE	stx L_C375		;1EDE 8E 75 C3
.L_1EE1	rts				;1EE1 60
}

; only called from main loop
.L_1EE2_from_main_loop
{
		jsr L_E4DA		;1EE2 20 DA E4
		jsr rndQ		;1EE5 20 B9 29
		and #$7F		;1EE8 29 7F
		clc				;1EEA 18
		adc #$68		;1EEB 69 68
		sta ZP_14		;1EED 85 14
		ldx #$03		;1EEF A2 03
.L_1EF1	lda L_07EC,X	;1EF1 BD EC 07
		clc				;1EF4 18
		adc ZP_14		;1EF5 65 14
		sta L_07CC,X	;1EF7 9D CC 07
		lda L_07F0,X	;1EFA BD F0 07
		adc #$00		;1EFD 69 00
		sta L_07D0,X	;1EFF 9D D0 07
		dex				;1F02 CA
		bpl L_1EF1		;1F03 10 EC
		rts				;1F05 60
}

.L_1F06
{
		lda L_31A1		;1F06 AD A1 31
		beq L_1F10		;1F09 F0 05
		lda L_C77F		;1F0B AD 7F C7
		bne L_1F47		;1F0E D0 37
.L_1F10	ldx #$00		;1F10 A2 00
.L_1F12	jsr rndQ		;1F12 20 B9 29
		dex				;1F15 CA
		bne L_1F12		;1F16 D0 FA
		lda L_C77D		;1F18 AD 7D C7
		ldy L_C774		;1F1B AC 74 C7
		ldx L_C71A		;1F1E AE 1A C7
		beq L_1F29		;1F21 F0 06
		clc				;1F23 18
		adc #$20		;1F24 69 20
		ldy L_C775		;1F26 AC 75 C7
.L_1F29	tax				;1F29 AA
		sty L_209B		;1F2A 8C 9B 20
		jsr rndQ		;1F2D 20 B9 29
		and L_BFAA,X	;1F30 3D AA BF
		clc				;1F33 18
		adc L_BFB2,X	;1F34 7D B2 BF
		sta L_2099		;1F37 8D 99 20
		jsr rndQ		;1F3A 20 B9 29
		and L_BFBA,X	;1F3D 3D BA BF
		clc				;1F40 18
		adc L_BFC2,X	;1F41 7D C2 BF
		sta L_209A		;1F44 8D 9A 20
.L_1F47	rts				;1F47 60
}

.L_1F48
{
		lda #$00		;1F48 A9 00
		sta ZP_17		;1F4A 85 17
		sta ZP_16		;1F4C 85 16
		lda ZP_D6		;1F4E A5 D6
		asl A			;1F50 0A
		lda ZP_D7		;1F51 A5 D7
		bmi L_1FA3		;1F53 30 4E
		rol A			;1F55 2A
		bit L_C308		;1F56 2C 08 C3
		bpl L_1F67		;1F59 10 0C
		bit L_C36A		;1F5B 2C 6A C3
		bpl L_1F67		;1F5E 10 07
		sec				;1F60 38
		sbc #$14		;1F61 E9 14
		bcs L_1F67		;1F63 B0 02
		lda #$00		;1F65 A9 00
.L_1F67	sta ZP_15		;1F67 85 15
		lda ZP_D7		;1F69 A5 D7
		jsr mul_8_8_16bit		;1F6B 20 82 C7
		asl ZP_14		;1F6E 06 14
		rol A			;1F70 2A
		rol ZP_17		;1F71 26 17
		asl ZP_14		;1F73 06 14
		rol A			;1F75 2A
		rol ZP_17		;1F76 26 17
		sta ZP_16		;1F78 85 16
		lda ZP_C9		;1F7A A5 C9
		beq L_1FA3		;1F7C F0 25
		lda L_C3B7		;1F7E AD B7 C3
		bmi L_1FA3		;1F81 30 20
		tay				;1F83 A8
		lda L_C3B6		;1F84 AD B6 C3
		sec				;1F87 38
		sbc ZP_D7		;1F88 E5 D7
		bcs L_1F8D		;1F8A B0 01
		dey				;1F8C 88
.L_1F8D	bit ZP_B2		;1F8D 24 B2
		bpl L_1F9D		;1F8F 10 0C
		sec				;1F91 38
		sbc ZP_D7		;1F92 E5 D7
		bcs L_1F97		;1F94 B0 01
		dey				;1F96 88
.L_1F97	sec				;1F97 38
		sbc #$23		;1F98 E9 23
		bcs L_1F9D		;1F9A B0 01
		dey				;1F9C 88
.L_1F9D	sta L_C3B6		;1F9D 8D B6 C3
		sty L_C3B7		;1FA0 8C B7 C3
.L_1FA3	lda L_C3B6		;1FA3 AD B6 C3
		sec				;1FA6 38
		sbc ZP_16		;1FA7 E5 16
		sta ZP_16		;1FA9 85 16
		sta ZP_14		;1FAB 85 14
		lda L_C3B7		;1FAD AD B7 C3
		sbc ZP_17		;1FB0 E5 17
		sta ZP_17		;1FB2 85 17
		ldy ZP_C9		;1FB4 A4 C9
		beq L_2009		;1FB6 F0 51
		lda L_07EC		;1FB8 AD EC 07
		clc				;1FBB 18
		adc L_07ED		;1FBC 6D ED 07
		sta ZP_14		;1FBF 85 14
		lda L_07F0		;1FC1 AD F0 07
		adc L_07F1		;1FC4 6D F1 07
		ror A			;1FC7 6A
		ror ZP_14		;1FC8 66 14
		sta ZP_15		;1FCA 85 15
		lda ZP_14		;1FCC A5 14
		sec				;1FCE 38
		sbc L_07EE		;1FCF ED EE 07
		sta ZP_14		;1FD2 85 14
		lda ZP_15		;1FD4 A5 15
		sbc L_07F2		;1FD6 ED F2 07
		sta ZP_18		;1FD9 85 18
		jsr negate_if_N_set		;1FDB 20 BD C8
		cmp #$02		;1FDE C9 02
		bcc L_1FE6		;1FE0 90 04
		lda #$FF		;1FE2 A9 FF
		bne L_1FEB		;1FE4 D0 05
.L_1FE6	lsr A			;1FE6 4A
		ror ZP_14		;1FE7 66 14
		lda ZP_14		;1FE9 A5 14
.L_1FEB	sta ZP_14		;1FEB 85 14
		lsr A			;1FED 4A
		lsr A			;1FEE 4A
		clc				;1FEF 18
		adc ZP_14		;1FF0 65 14
		sta ZP_14		;1FF2 85 14
		lda #$00		;1FF4 A9 00
		rol A			;1FF6 2A
		bit ZP_18		;1FF7 24 18
		jsr negate_if_N_set		;1FF9 20 BD C8
		sta ZP_15		;1FFC 85 15
		lda ZP_16		;1FFE A5 16
		clc				;2000 18
		adc ZP_14		;2001 65 14
		sta ZP_14		;2003 85 14
		lda ZP_17		;2005 A5 17
		adc ZP_15		;2007 65 15
.L_2009	jsr L_FF8E		;2009 20 8E FF
		adc ZP_D6		;200C 65 D6
		sta ZP_D6		;200E 85 D6
		lda ZP_D7		;2010 A5 D7
		adc ZP_15		;2012 65 15
		bpl L_2018		;2014 10 02
		lda #$00		;2016 A9 00
.L_2018	sta ZP_D7		;2018 85 D7
		rts				;201A 60
}

.L_201B
{
		lda L_C386		;201B AD 86 C3
		ldy L_C387		;201E AC 87 C3
		ldx L_C30F		;2021 AE 0F C3
		beq L_2029		;2024 F0 03
		sec				;2026 38
		sbc #$19		;2027 E9 19
.L_2029	ldx ZP_C9		;2029 A6 C9
		bne L_2030		;202B D0 03
		lda #$00		;202D A9 00
		tay				;202F A8
.L_2030	sta L_C3B6		;2030 8D B6 C3
		sty L_C3B7		;2033 8C B7 C3
		rts				;2036 60
}

.L_2037
{
		lda ZP_C9		;2037 A5 C9
		bne L_203C		;2039 D0 01
		rts				;203B 60
.L_203C	ldx L_C375		;203C AE 75 C3
		lda L_0710,X	;203F BD 10 07
		bmi L_204C		;2042 30 08
		cmp L_2099		;2044 CD 99 20
		bcc L_204C		;2047 90 03
		lda L_2099		;2049 AD 99 20
.L_204C	and #$7F		;204C 29 7F
		sta ZP_E3		;204E 85 E3
		lda ZP_D7		;2050 A5 D7
		sec				;2052 38
		sbc ZP_E3		;2053 E5 E3
		sta ZP_15		;2055 85 15
		bcc L_2077		;2057 90 1E
		beq L_2093		;2059 F0 38
		lda #$80		;205B A9 80
		sta L_C3C7		;205D 8D C7 C3
		lda #$00		;2060 A9 00
		sec				;2062 38
		sbc L_C3B6		;2063 ED B6 C3
		sta L_C3B6		;2066 8D B6 C3
		lda #$00		;2069 A9 00
		sbc L_C3B7		;206B ED B7 C3
		sta L_C3B7		;206E 8D B7 C3
		lda ZP_15		;2071 A5 15
		cmp #$0E		;2073 C9 0E
		bcc L_2092		;2075 90 1B
.L_2077	lda L_0710,X	;2077 BD 10 07
		bmi L_208C		;207A 30 10
		lda ZP_15		;207C A5 15
		bpl L_208C		;207E 10 0C
		ldy L_C3C7		;2080 AC C7 C3
		beq L_208C		;2083 F0 07
		cmp #$FE		;2085 C9 FE
		bcs L_2092		;2087 B0 09
		asl L_C3C7		;2089 0E C7 C3
.L_208C	asl L_C3B6		;208C 0E B6 C3
		rol L_C3B7		;208F 2E B7 C3
.L_2092	rts				;2092 60
.L_2093	lda #$80		;2093 A9 80
		sta L_C3C7		;2095 8D C7 C3
		rts				;2098 60
}

.L_2099	equb $78
.L_209A	equb $6E
.L_209B	equb $05

.L_209C
{
		lda L_C37C		;209C AD 7C C3
		bne L_20A8		;209F D0 07
		rts				;20A1 60
.L_20A2	lda #$03		;20A2 A9 03
		sta L_C369		;20A4 8D 69 C3
		rts				;20A7 60
.L_20A8	lda ZP_C9		;20A8 A5 C9
		beq L_20B0		;20AA F0 04
		lda ZP_6A		;20AC A5 6A
		bne L_20FE		;20AE D0 4E
.L_20B0	lda ZP_46		;20B0 A5 46
		sec				;20B2 38
		sbc L_07CC		;20B3 ED CC 07
		sta ZP_14		;20B6 85 14
		lda ZP_64		;20B8 A5 64
		sbc L_07D0		;20BA ED D0 07
		sta ZP_17		;20BD 85 17
		lda ZP_14		;20BF A5 14
		clc				;20C1 18
		adc #$28		;20C2 69 28
		sta ZP_14		;20C4 85 14
		lda ZP_17		;20C6 A5 17
		adc #$00		;20C8 69 00
		sta ZP_17		;20CA 85 17
		jsr negate_if_N_set		;20CC 20 BD C8
		cmp #$00		;20CF C9 00
		bne L_20A2		;20D1 D0 CF
		lda ZP_14		;20D3 A5 14
		cmp #$C0		;20D5 C9 C0
		bcs L_20A2		;20D7 B0 C9
		lda L_C369		;20D9 AD 69 C3
		beq L_20FE		;20DC F0 20
		dec L_C369		;20DE CE 69 C3
		lda #$00		;20E1 A9 00
		sec				;20E3 38
		sbc ZP_14		;20E4 E5 14
		sta ZP_14		;20E6 85 14
		lda #$01		;20E8 A9 01
		sbc #$00		;20EA E9 00
		bit ZP_17		;20EC 24 17
		jsr negate_if_N_set		;20EE 20 BD C8
		ldy #$FC		;20F1 A0 FC
		jsr shift_16bit		;20F3 20 BF C9
		sta L_0183		;20F6 8D 83 01
		lda ZP_14		;20F9 A5 14
		sta L_0180		;20FB 8D 80 01
.L_20FE	lda ZP_51		;20FE A5 51
		cmp #$2D		;2100 C9 2D
		bcs L_2115		;2102 B0 11
		lda ZP_39		;2104 A5 39
		cmp #$08		;2106 C9 08
		bcs L_2115		;2108 B0 0B
		lda #$08		;210A A9 08
		bit ZP_77		;210C 24 77
		bmi L_2112		;210E 30 02
		lda #$F8		;2110 A9 F8
.L_2112	sta L_0182		;2112 8D 82 01
.L_2115	bit ZP_E0		;2115 24 E0
		bmi L_213E		;2117 30 25
		ldy #$03		;2119 A0 03
		sec				;211B 38
		lda ZP_D6		;211C A5 D6
		sbc L_0156		;211E ED 56 01
		sta ZP_14		;2121 85 14
		lda ZP_D7		;2123 A5 D7
		sbc L_0159		;2125 ED 59 01
		clc				;2128 18
		bpl L_212E		;2129 10 03
		sec				;212B 38
		ldy #$FD		;212C A0 FD
.L_212E	ror A			;212E 6A
		ror ZP_14		;212F 66 14
		sty ZP_15		;2131 84 15
		clc				;2133 18
		adc ZP_15		;2134 65 15
		sta L_0184		;2136 8D 84 01
		lda ZP_14		;2139 A5 14
		sta L_0181		;213B 8D 81 01
.L_213E	lda #$80		;213E A9 80
		sta L_C371		;2140 8D 71 C3
		sta ZP_E0		;2143 85 E0
		ldy #$02		;2145 A0 02
		lda #$02		;2147 A9 02
		sta ZP_16		;2149 85 16
.L_214B	lda L_017F,Y	;214B B9 7F 01
		sta ZP_14		;214E 85 14
		lda L_0182,Y	;2150 B9 82 01
		jsr negate_if_N_set		;2153 20 BD C8
		clc				;2156 18
		adc ZP_16		;2157 65 16
		sta ZP_16		;2159 85 16
		dey				;215B 88
		bpl L_214B		;215C 10 ED
		ldy #$02		;215E A0 02
.L_2160	lda L_C3C3,Y	;2160 B9 C3 C3
		clc				;2163 18
		adc ZP_16		;2164 65 16
		bcc L_216A		;2166 90 02
		lda #$FF		;2168 A9 FF
.L_216A	sta L_C3C3,Y	;216A 99 C3 C3
		dey				;216D 88
		bpl L_2160		;216E 10 F0
		lda #$80		;2170 A9 80
		sta L_C352		;2172 8D 52 C3
		rts				;2175 60
}

.L_2176
{
		lda L_C371		;2176 AD 71 C3
		beq L_21DD		;2179 F0 62
		lda #$00		;217B A9 00
		sta L_C371		;217D 8D 71 C3
		lda ZP_D6		;2180 A5 D6
		sec				;2182 38
		sbc L_0181		;2183 ED 81 01
		sta ZP_D6		;2186 85 D6
		lda ZP_D7		;2188 A5 D7
		sbc L_0184		;218A ED 84 01
		bpl L_2191		;218D 10 02
		lda #$00		;218F A9 00
.L_2191	sta ZP_D7		;2191 85 D7
		lda L_0180		;2193 AD 80 01
		sta ZP_14		;2196 85 14
		lda L_0183		;2198 AD 83 01
		ldy #$04		;219B A0 04
		jsr shift_16bit		;219D 20 BF C9
		sta ZP_15		;21A0 85 15
		ldx #$02		;21A2 A2 02
.L_21A4	lda L_07DC,X	;21A4 BD DC 07
		sec				;21A7 38
		sbc ZP_14		;21A8 E5 14
		sta L_07DC,X	;21AA 9D DC 07
		lda L_07E0,X	;21AD BD E0 07
		sbc ZP_15		;21B0 E5 15
		sta L_07E0,X	;21B2 9D E0 07
		dex				;21B5 CA
		bpl L_21A4		;21B6 10 EC
		ldx #$02		;21B8 A2 02
.L_21BA	lda L_0170,X	;21BA BD 70 01
		clc				;21BD 18
		adc L_017F,X	;21BE 7D 7F 01
		sta L_0170,X	;21C1 9D 70 01
		lda L_0173,X	;21C4 BD 73 01
		adc L_0182,X	;21C7 7D 82 01
		sta L_0173,X	;21CA 9D 73 01
		lda #$00		;21CD A9 00
		sta L_017F,X	;21CF 9D 7F 01
		sta L_0182,X	;21D2 9D 82 01
		dex				;21D5 CA
		bpl L_21BA		;21D6 10 E2
		lda #$02		;21D8 A9 02
		jsr L_CF68		;21DA 20 68 CF
.L_21DD	rts				;21DD 60
}

.L_21DE
{
		lda #$00		;21DE A9 00
		sta ZP_C9		;21E0 85 C9
		ldx #$28		;21E2 A2 28
		lda ZP_B2		;21E4 A5 B2
		bpl L_21EA		;21E6 10 02
		ldx #$7C		;21E8 A2 7C
.L_21EA	stx ZP_52		;21EA 86 52
		ldx #$02		;21EC A2 02
.L_21EE	lda L_07EC,X	;21EE BD EC 07
		sec				;21F1 38
		sbc L_07CC,X	;21F2 FD CC 07
		sta ZP_18		;21F5 85 18
		lda L_07F0,X	;21F7 BD F0 07
		sbc L_07D0,X	;21FA FD D0 07
		tay				;21FD A8
		lda ZP_18		;21FE A5 18
		clc				;2200 18
		adc ZP_52		;2201 65 52
		sta ZP_18		;2203 85 18
		tya				;2205 98
		adc #$00		;2206 69 00
		bpl L_221A		;2208 10 10
		cmp #$FF		;220A C9 FF
		bne L_2214		;220C D0 06
		lda ZP_18		;220E A5 18
		cmp #$A0		;2210 C9 A0
		bcs L_2218		;2212 B0 04
.L_2214	lda #$A0		;2214 A9 A0
		sta ZP_18		;2216 85 18
.L_2218	lda #$FF		;2218 A9 FF
.L_221A	sta ZP_19		;221A 85 19
		lda ZP_18		;221C A5 18
		sec				;221E 38
		sbc L_07D4,X	;221F FD D4 07
		sta ZP_14		;2222 85 14
		lda ZP_19		;2224 A5 19
		sbc L_07D8,X	;2226 FD D8 07
		jsr L_CFB7		;2229 20 B7 CF
		bpl L_2232		;222C 10 04
		lda #$00		;222E A9 00
		sta ZP_14		;2230 85 14
.L_2232	cmp #$04		;2232 C9 04
		bcc L_223C		;2234 90 06
		lda #$FF		;2236 A9 FF
		sta ZP_14		;2238 85 14
		lda #$03		;223A A9 03
.L_223C	tay				;223C A8
		ora ZP_14		;223D 05 14
		ora ZP_C9		;223F 05 C9
		sta ZP_C9		;2241 85 C9
		lda ZP_14		;2243 A5 14
		sec				;2245 38
		sbc ZP_52		;2246 E5 52
		sta L_07C4,X	;2248 9D C4 07
		tya				;224B 98
		sbc #$00		;224C E9 00
		sta L_07C8,X	;224E 9D C8 07
		lda ZP_18		;2251 A5 18
		sta L_07D4,X	;2253 9D D4 07
		lda ZP_19		;2256 A5 19
		sta L_07D8,X	;2258 9D D8 07
		dex				;225B CA
		bpl L_21EE		;225C 10 90
		ldx #$02		;225E A2 02
		lda #$00		;2260 A9 00
		sta ZP_16		;2262 85 16
		sta ZP_17		;2264 85 17
.L_2266	lda ZP_16		;2266 A5 16
		clc				;2268 18
		adc L_07C4,X	;2269 7D C4 07
		sta ZP_16		;226C 85 16
		lda ZP_17		;226E A5 17
		adc L_07C8,X	;2270 7D C8 07
		sta ZP_17		;2273 85 17
		dex				;2275 CA
		bpl L_2266		;2276 10 EE
		ldx #$02		;2278 A2 02
.L_227A	lda L_07C4,X	;227A BD C4 07
		sta ZP_1A		;227D 85 1A
		lda L_07C8,X	;227F BD C8 07
		asl ZP_1A		;2282 06 1A
		rol A			;2284 2A
		asl ZP_1A		;2285 06 1A
		rol A			;2287 2A
		sta ZP_1B		;2288 85 1B
		lda ZP_16		;228A A5 16
		clc				;228C 18
		adc L_07C4,X	;228D 7D C4 07
		sta ZP_14		;2290 85 14
		lda ZP_17		;2292 A5 17
		adc L_07C8,X	;2294 7D C8 07
		sta ZP_15		;2297 85 15
		lda ZP_14		;2299 A5 14
		clc				;229B 18
		adc ZP_1A		;229C 65 1A
		sta ZP_14		;229E 85 14
		lda ZP_15		;22A0 A5 15
		adc ZP_1B		;22A2 65 1B
		ldy #$03		;22A4 A0 03
		jsr shift_16bit		;22A6 20 BF C9
		sta L_07E8,X	;22A9 9D E8 07
		lda ZP_14		;22AC A5 14
		sta L_07E4,X	;22AE 9D E4 07
		dex				;22B1 CA
		bpl L_227A		;22B2 10 C6
		ldx L_C773		;22B4 AE 73 C7
		lda L_AEE0,X	;22B7 BD E0 AE
		and #$04		;22BA 29 04
		beq L_22DA		;22BC F0 1C
		lda L_07E2		;22BE AD E2 07
		ora L_07DE		;22C1 0D DE 07
		ora L_07EA		;22C4 0D EA 07
		ora L_07E6		;22C7 0D E6 07
		and #$FC		;22CA 29 FC
		bne L_22DA		;22CC D0 0C
		jsr rndQ		;22CE 20 B9 29
		and #$0F		;22D1 29 0F
		bne L_22DA		;22D3 D0 05
		lda #$A0		;22D5 A9 A0
		sta L_07DE		;22D7 8D DE 07
.L_22DA	ldx #$02		;22DA A2 02
.L_22DC	lda L_07E4,X	;22DC BD E4 07
		sta ZP_14		;22DF 85 14
		lda L_07E8,X	;22E1 BD E8 07
		jsr L_FF8E		;22E4 20 8E FF
		adc L_07DC,X	;22E7 7D DC 07
		sta L_07DC,X	;22EA 9D DC 07
		sta ZP_14		;22ED 85 14
		lda L_07E0,X	;22EF BD E0 07
		adc ZP_15		;22F2 65 15
		sta L_07E0,X	;22F4 9D E0 07
		jsr L_FF8E		;22F7 20 8E FF
		lda ZP_15		;22FA A5 15
		clc				;22FC 18
		bpl L_2300		;22FD 10 01
		sec				;22FF 38
.L_2300	ror ZP_15		;2300 66 15
		lda ZP_14		;2302 A5 14
		ror A			;2304 6A
		clc				;2305 18
		adc L_07CC,X	;2306 7D CC 07
		sta L_07CC,X	;2309 9D CC 07
		lda L_07D0,X	;230C BD D0 07
		adc ZP_15		;230F 65 15
		sta L_07D0,X	;2311 9D D0 07
		dex				;2314 CA
		bpl L_22DC		;2315 10 C5
		lda #$28		;2317 A9 28
		sta ZP_51		;2319 85 51
		lda #$01		;231B A9 01
		ldx #$00		;231D A2 00
		ldy #$01		;231F A0 01
		jsr L_23A2		;2321 20 A2 23
		lda #$70		;2324 A9 70
		sta ZP_51		;2326 85 51
		lda #$01		;2328 A9 01
		ldx #$00		;232A A2 00
		bit ZP_17		;232C 24 17
		bpl L_2331		;232E 10 01
		inx				;2330 E8
.L_2331	ldy #$02		;2331 A0 02
		jsr L_23A2		;2333 20 A2 23
		ldx #$02		;2336 A2 02
.L_2338	ldy L_238A,X	;2338 BC 8A 23
		lda L_07CC,X	;233B BD CC 07
		clc				;233E 18
		adc #$50		;233F 69 50
		sta L_8040,Y	;2341 99 40 80
		lda L_07D0,X	;2344 BD D0 07
		adc #$00		;2347 69 00
		sta L_A330,Y	;2349 99 30 A3
		dex				;234C CA
		bpl L_2338		;234D 10 E9
		lda L_807E		;234F AD 7E 80
		sec				;2352 38
		sbc L_807C		;2353 ED 7C 80
		sta ZP_14		;2356 85 14
		lda L_A36E		;2358 AD 6E A3
		sbc L_A36C		;235B ED 6C A3
		clc				;235E 18
		bpl L_2362		;235F 10 01
		sec				;2361 38
.L_2362	ror A			;2362 6A
		ror ZP_14		;2363 66 14
		sta ZP_15		;2365 85 15
		lda L_807D		;2367 AD 7D 80
		clc				;236A 18
		adc ZP_14		;236B 65 14
		sta L_807F		;236D 8D 7F 80
		lda L_A36D		;2370 AD 6D A3
		adc ZP_15		;2373 65 15
		sta L_A36F		;2375 8D 6F A3
		lda L_807D		;2378 AD 7D 80
		sec				;237B 38
		sbc ZP_14		;237C E5 14
		sta L_807D		;237E 8D 7D 80
		lda L_A36D		;2381 AD 6D A3
		sbc ZP_15		;2384 E5 15
		sta L_A36D		;2386 8D 6D A3
		rts				;2389 60

.L_238A	equb $3C,$3E,$3D,$3F
}

.L_238E
{
		lda L_07CC,X	;238E BD CC 07
		sec				;2391 38
		sbc L_07CC,Y	;2392 F9 CC 07
		sta ZP_14		;2395 85 14
		lda L_07D0,X	;2397 BD D0 07
		sbc L_07D0,Y	;239A F9 D0 07
		sta ZP_17		;239D 85 17
		jmp negate_if_N_set		;239F 4C BD C8
}

.L_23A2
{
		sta ZP_77		;23A2 85 77
		stx ZP_52		;23A4 86 52
		jsr L_238E		;23A6 20 8E 23
		sta ZP_15		;23A9 85 15
		lda ZP_51		;23AB A5 51
		sec				;23AD 38
		sbc ZP_14		;23AE E5 14
		sta ZP_14		;23B0 85 14
		lda ZP_77		;23B2 A5 77
		sbc ZP_15		;23B4 E5 15
		bpl L_23EF		;23B6 10 37
		sta ZP_15		;23B8 85 15
		bit ZP_17		;23BA 24 17
		bpl L_23C0		;23BC 10 02
		tya				;23BE 98
		tax				;23BF AA
.L_23C0	lda L_07CC,X	;23C0 BD CC 07
		clc				;23C3 18
		adc ZP_14		;23C4 65 14
		sta L_07CC,X	;23C6 9D CC 07
		lda L_07D0,X	;23C9 BD D0 07
		adc ZP_15		;23CC 65 15
		sta L_07D0,X	;23CE 9D D0 07
		cpy #$02		;23D1 C0 02
		beq L_23DA		;23D3 F0 05
		ldx #$00		;23D5 A2 00
		jmp L_2433		;23D7 4C 33 24
.L_23DA	ldx #$00		;23DA A2 00
		ldy #$01		;23DC A0 01
		jsr L_2433		;23DE 20 33 24
		ldx #$02		;23E1 A2 02
		jsr L_2433		;23E3 20 33 24
		ldx #$00		;23E6 A2 00
		jsr L_2433		;23E8 20 33 24
		ldy #$02		;23EB A0 02
		ldx ZP_52		;23ED A6 52
.L_23EF	cpy #$02		;23EF C0 02
		bne L_242C		;23F1 D0 39
		lda ZP_C9		;23F3 A5 C9
		bne L_242C		;23F5 D0 35
		bit ZP_17		;23F7 24 17
		bmi L_23FB		;23F9 30 00
.L_23FB	lda L_07DC,X	;23FB BD DC 07
		sec				;23FE 38
		sbc L_07DE		;23FF ED DE 07
		sta ZP_14		;2402 85 14
		lda L_07E0,X	;2404 BD E0 07
		sbc L_07E2		;2407 ED E2 07
		bmi L_2414		;240A 30 08
		bne L_242C		;240C D0 1E
		lda ZP_14		;240E A5 14
		cmp #$10		;2410 C9 10
		bcs L_242C		;2412 B0 18
.L_2414	ldx #$02		;2414 A2 02
.L_2416	lda L_07DC,X	;2416 BD DC 07
		clc				;2419 18
		adc L_242D,X	;241A 7D 2D 24
		sta L_07DC,X	;241D 9D DC 07
		lda L_07E0,X	;2420 BD E0 07
		adc L_2430,X	;2423 7D 30 24
		sta L_07E0,X	;2426 9D E0 07
		dex				;2429 CA
		bpl L_2416		;242A 10 EA
.L_242C	rts				;242C 60

.L_242D	equb $04,$04,$FC
.L_2430	equb $00,$00,$FF
}

.L_2433
{
		lda L_07DC,X	;2433 BD DC 07
		clc				;2436 18
		adc L_07DC,Y	;2437 79 DC 07
		sta ZP_14		;243A 85 14
		lda L_07E0,X	;243C BD E0 07
		adc L_07E0,Y	;243F 79 E0 07
		clc				;2442 18
		bpl L_2446		;2443 10 01
		sec				;2445 38
.L_2446	ror A			;2446 6A
		ror ZP_14		;2447 66 14
		sta L_07E0,X	;2449 9D E0 07
		sta L_07E0,Y	;244C 99 E0 07
		lda ZP_14		;244F A5 14
		sta L_07DC,X	;2451 9D DC 07
		sta L_07DC,Y	;2454 99 DC 07
		rts				;2457 60
}

.L_2458
		stx ZP_16		;2458 86 16
		lda ZP_52		;245A A5 52
.L_245C
{
		sta ZP_14		;245C 85 14
		ldy #$00		;245E A0 00
		lda ZP_78		;2460 A5 78
		bpl L_247B		;2462 10 17
		ldy #$08		;2464 A0 08
		lda #$00		;2466 A9 00
		sec				;2468 38
		sbc ZP_52		;2469 E5 52
		sta ZP_14		;246B 85 14
		lda #$00		;246D A9 00
		sbc ZP_78		;246F E5 78
		bpl L_247B		;2471 10 08
		ldy #$0F		;2473 A0 0F
		lda #$FF		;2475 A9 FF
		sta ZP_14		;2477 85 14
		bne L_2487		;2479 D0 0C
.L_247B	bne L_2481		;247B D0 04
		beq L_2487		;247D F0 08
.L_247F	ror ZP_14		;247F 66 14
.L_2481	iny				;2481 C8
		lsr A			;2482 4A
		bne L_247F		;2483 D0 FA
		ror ZP_14		;2485 66 14
.L_2487	ldx ZP_14		;2487 A6 14
		cpy #$08		;2489 C0 08
		bcc L_24AD		;248B 90 20
		lda #$B0		;248D A9 B0			; opcode BCS
		sta L_24F8		;248F 8D F8 24
		jsr L_24AD		;2492 20 AD 24
		lda #$90		;2495 A9 90			; opcode BCC
		sta L_24F8		;2497 8D F8 24
		lda L_A298,X	;249A BD 98 A2
		bpl L_24A6		;249D 10 07
		clc				;249F 18
		adc #$02		;24A0 69 02
		sta L_A298,X	;24A2 9D 98 A2
		rts				;24A5 60
.L_24A6	sec				;24A6 38
		sbc #$02		;24A7 E9 02
		sta L_A298,X	;24A9 9D 98 A2
		rts				;24AC 60
.L_24AD	lda log_msb,X	;24AD BD 00 AB
		clc				;24B0 18
		adc L_A610,Y	;24B1 79 10 A6
		sta ZP_71		;24B4 85 71
		lda log_lsb,X	;24B6 BD 00 AA
		sta ZP_70		;24B9 85 70
		lda ZP_51		;24BB A5 51
		sta ZP_14		;24BD 85 14
		ldy #$00		;24BF A0 00
		lda ZP_77		;24C1 A5 77
		bpl L_24DA		;24C3 10 15
		ldy #$08		;24C5 A0 08
		lda #$00		;24C7 A9 00
		sec				;24C9 38
		sbc ZP_51		;24CA E5 51
		sta ZP_14		;24CC 85 14
		lda #$00		;24CE A9 00
		sbc ZP_77		;24D0 E5 77
		bpl L_24DA		;24D2 10 06
		ldy #$0F		;24D4 A0 0F
		lda #$FF		;24D6 A9 FF
		bne L_24E6		;24D8 D0 0C
.L_24DA	bne L_24E0		;24DA D0 04
		beq L_24E6		;24DC F0 08
.L_24DE	ror ZP_14		;24DE 66 14
.L_24E0	iny				;24E0 C8
		lsr A			;24E1 4A
		bne L_24DE		;24E2 D0 FA
		ror ZP_14		;24E4 66 14
.L_24E6	ldx ZP_14		;24E6 A6 14
		lda log_msb,X	;24E8 BD 00 AB
		clc				;24EB 18
		adc L_A610,Y	;24EC 79 10 A6
		sta ZP_AA		;24EF 85 AA
		lda log_lsb,X	;24F1 BD 00 AA
		sta ZP_A9		;24F4 85 A9
		cpy #$08		;24F6 C0 08
.L_24F8	bcc L_2572		;24F8 90 78		;! self-mod
		lda ZP_A9		;24FA A5 A9
		sec				;24FC 38
		sbc ZP_70		;24FD E5 70
		sta ZP_14		;24FF 85 14
		lda ZP_AA		;2501 A5 AA
		sbc ZP_71		;2503 E5 71
		bpl L_2537		;2505 10 30
		jsr pow36Q		;2507 20 D2 26
		lsr A			;250A 4A
		adc #$00		;250B 69 00
		sta ZP_14		;250D 85 14
		tay				;250F A8
		ldx cosine_table,Y	;2510 BE 00 A7
		lda ZP_70		;2513 A5 70
		sec				;2515 38
		sbc log_lsb,X	;2516 FD 00 AA
		sta ZP_AB		;2519 85 AB
		lda ZP_71		;251B A5 71
		sbc log_msb,X	;251D FD 00 AB
		clc				;2520 18
		adc #$20		;2521 69 20
		sta ZP_AC		;2523 85 AC
		ldx ZP_16		;2525 A6 16
		lda ZP_A7		;2527 A5 A7
		sec				;2529 38
		sbc ZP_14		;252A E5 14
		sta L_A200,X	;252C 9D 00 A2
		lda ZP_A8		;252F A5 A8
		sbc #$00		;2531 E9 00
		sta L_A298,X	;2533 9D 98 A2
		rts				;2536 60
.L_2537	sta ZP_15		;2537 85 15
		lda #$00		;2539 A9 00
		sec				;253B 38
		sbc ZP_14		;253C E5 14
		sta ZP_14		;253E 85 14
		lda #$00		;2540 A9 00
		sbc ZP_15		;2542 E5 15
		jsr pow36Q		;2544 20 D2 26
		lsr A			;2547 4A
		sta ZP_14		;2548 85 14
		tay				;254A A8
		ldx cosine_table,Y	;254B BE 00 A7
		lda ZP_A9		;254E A5 A9
		sec				;2550 38
		sbc log_lsb,X	;2551 FD 00 AA
		sta ZP_AB		;2554 85 AB
		lda ZP_AA		;2556 A5 AA
		sbc log_msb,X	;2558 FD 00 AB
		clc				;255B 18
		adc #$20		;255C 69 20
		sta ZP_AC		;255E 85 AC
		ldx ZP_16		;2560 A6 16
		lda ZP_14		;2562 A5 14
		sec				;2564 38
		sbc ZP_32		;2565 E5 32
		sta L_A200,X	;2567 9D 00 A2
		lda #$FF		;256A A9 FF
		sbc ZP_3E		;256C E5 3E
		sta L_A298,X	;256E 9D 98 A2
		rts				;2571 60
.L_2572	lda ZP_A9		;2572 A5 A9
		sec				;2574 38
		sbc ZP_70		;2575 E5 70
		sta ZP_14		;2577 85 14
		lda ZP_AA		;2579 A5 AA
		sbc ZP_71		;257B E5 71
		bpl L_25AD		;257D 10 2E
		jsr pow36Q		;257F 20 D2 26
		lsr A			;2582 4A
		sta ZP_14		;2583 85 14
		tay				;2585 A8
		ldx cosine_table,Y	;2586 BE 00 A7
		lda ZP_70		;2589 A5 70
		sec				;258B 38
		sbc log_lsb,X	;258C FD 00 AA
		sta ZP_AB		;258F 85 AB
		lda ZP_71		;2591 A5 71
		sbc log_msb,X	;2593 FD 00 AB
		clc				;2596 18
		adc #$20		;2597 69 20
		sta ZP_AC		;2599 85 AC
		ldx ZP_16		;259B A6 16
		lda ZP_14		;259D A5 14
		sec				;259F 38
		sbc ZP_32		;25A0 E5 32
		sta L_A200,X	;25A2 9D 00 A2
		lda #$00		;25A5 A9 00
		sbc ZP_3E		;25A7 E5 3E
		sta L_A298,X	;25A9 9D 98 A2
		rts				;25AC 60
.L_25AD	sta ZP_15		;25AD 85 15
		lda #$00		;25AF A9 00
		sec				;25B1 38
		sbc ZP_14		;25B2 E5 14
		sta ZP_14		;25B4 85 14
		lda #$00		;25B6 A9 00
		sbc ZP_15		;25B8 E5 15
		jsr pow36Q		;25BA 20 D2 26
		lsr A			;25BD 4A
		adc #$00		;25BE 69 00
		sta ZP_14		;25C0 85 14
		tay				;25C2 A8
		ldx cosine_table,Y	;25C3 BE 00 A7
		lda ZP_A9		;25C6 A5 A9
		sec				;25C8 38
		sbc log_lsb,X	;25C9 FD 00 AA
		sta ZP_AB		;25CC 85 AB
		lda ZP_AA		;25CE A5 AA
		sbc log_msb,X	;25D0 FD 00 AB
		clc				;25D3 18
		adc #$20		;25D4 69 20
		sta ZP_AC		;25D6 85 AC
		ldx ZP_16		;25D8 A6 16
		lda ZP_A7		;25DA A5 A7
		sec				;25DC 38
		sbc ZP_14		;25DD E5 14
		sta L_A200,X	;25DF 9D 00 A2
		lda ZP_A8		;25E2 A5 A8
		sbc #$FF		;25E4 E9 FF
		sta L_A298,X	;25E6 9D 98 A2
		rts				;25E9 60
}

.L_25EA
		stx ZP_16		;25EA 86 16
		ldy #$00		;25EC A0 00
		lda L_8040,X	;25EE BD 40 80
		sec				;25F1 38
		sbc ZP_37		;25F2 E5 37
		sta ZP_14		;25F4 85 14
		lda L_A330,X	;25F6 BD 30 A3
		sbc ZP_38		;25F9 E5 38
		bpl L_2614		;25FB 10 17
		ldy #$08		;25FD A0 08
		sta ZP_15		;25FF 85 15
		lda #$00		;2601 A9 00
		sec				;2603 38
		sbc ZP_14		;2604 E5 14
		sta ZP_14		;2606 85 14
		lda #$00		;2608 A9 00
		sbc ZP_15		;260A E5 15
		bpl L_2614		;260C 10 06
		ldy #$0F		;260E A0 0F
		lda #$FF		;2610 A9 FF
		bne L_2620		;2612 D0 0C
.L_2614	bne L_261A		;2614 D0 04
		beq L_2620		;2616 F0 08
.L_2618	ror ZP_14		;2618 66 14
.L_261A	iny				;261A C8
		lsr A			;261B 4A
		bne L_2618		;261C D0 FA
		ror ZP_14		;261E 66 14
.L_2620	ldx ZP_14		;2620 A6 14
		lda log_msb,X	;2622 BD 00 AB
		clc				;2625 18
		adc L_A610,Y	;2626 79 10 A6
		sec				;2629 38
		sbc #$08		;262A E9 08
L_262B	= *-1			;! self-mod!
		sta ZP_AD		;262C 85 AD
		cpy #$08		;262E C0 08
		bcs L_2682		;2630 B0 50
		lda log_lsb,X	;2632 BD 00 AA
		sec				;2635 38
		sbc ZP_AB		;2636 E5 AB
		sta ZP_14		;2638 85 14
		lda ZP_AD		;263A A5 AD
		sbc ZP_AC		;263C E5 AC
		bpl L_2662		;263E 10 22
		jsr pow36Q		;2640 20 D2 26
		sta ZP_14		;2643 85 14
		ldx #$00		;2645 A2 00
		stx ZP_15		;2647 86 15
		ldx ZP_16		;2649 A6 16
		lda #$00		;264B A9 00
		sec				;264D 38
		sbc ZP_14		;264E E5 14
		bcc L_2654		;2650 90 02
		inc ZP_15		;2652 E6 15
.L_2654	sec				;2654 38
		sbc ZP_33		;2655 E5 33
		sta L_A24C,X	;2657 9D 4C A2
		lda ZP_15		;265A A5 15
		sbc ZP_69		;265C E5 69
		sta L_A2E4,X	;265E 9D E4 A2
		rts				;2661 60
.L_2662	sta ZP_15		;2662 85 15
		lda #$00		;2664 A9 00
		sec				;2666 38
		sbc ZP_14		;2667 E5 14
		sta ZP_14		;2669 85 14
		lda #$00		;266B A9 00
		sbc ZP_15		;266D E5 15
		jsr pow36Q		;266F 20 D2 26
		ldx ZP_16		;2672 A6 16
		sec				;2674 38
		sbc ZP_33		;2675 E5 33
		sta L_A24C,X	;2677 9D 4C A2
		lda #$FF		;267A A9 FF
		sbc ZP_69		;267C E5 69
		sta L_A2E4,X	;267E 9D E4 A2
		rts				;2681 60
.L_2682	lda log_lsb,X	;2682 BD 00 AA
		sec				;2685 38
		sbc ZP_AB		;2686 E5 AB
		sta ZP_14		;2688 85 14
		lda ZP_AD		;268A A5 AD
		sbc ZP_AC		;268C E5 AC
		bpl L_26A3		;268E 10 13
		jsr pow36Q		;2690 20 D2 26
		ldx ZP_16		;2693 A6 16
		sec				;2695 38
		sbc ZP_33		;2696 E5 33
		sta L_A24C,X	;2698 9D 4C A2
		lda #$01		;269B A9 01
		sbc ZP_69		;269D E5 69
		sta L_A2E4,X	;269F 9D E4 A2
		rts				;26A2 60
.L_26A3	sta ZP_15		;26A3 85 15
		lda #$00		;26A5 A9 00
		sec				;26A7 38
		sbc ZP_14		;26A8 E5 14
		sta ZP_14		;26AA 85 14
		lda #$00		;26AC A9 00
		sbc ZP_15		;26AE E5 15
		jsr pow36Q		;26B0 20 D2 26
		sta ZP_14		;26B3 85 14
		ldx #$02		;26B5 A2 02
		stx ZP_15		;26B7 86 15
		ldx ZP_16		;26B9 A6 16
		lda #$00		;26BB A9 00
		sec				;26BD 38
		sbc ZP_14		;26BE E5 14
		bcc L_26C4		;26C0 90 02
		inc ZP_15		;26C2 E6 15
.L_26C4	sec				;26C4 38
		sbc ZP_33		;26C5 E5 33
		sta L_A24C,X	;26C7 9D 4C A2
		lda ZP_15		;26CA A5 15
		sbc ZP_69		;26CC E5 69
		sta L_A2E4,X	;26CE 9D E4 A2
		rts				;26D1 60

; raises number to	the power of 36	(? - experimentally determined)
; entry: A	= MSB; byte_14 = LSB

.pow36Q
{
		cmp #$E0		;26D2 C9 E0
		bcc L_271B		;26D4 90 45
		asl ZP_14		;26D6 06 14
		rol A			;26D8 2A
		asl ZP_14		;26D9 06 14
		rol A			;26DB 2A
		asl ZP_14		;26DC 06 14
		rol A			;26DE 2A
		bpl L_270B		;26DF 10 2A
		asl ZP_14		;26E1 06 14
		rol A			;26E3 2A
		bpl L_26FD		;26E4 10 17
		asl ZP_14		;26E6 06 14
		rol A			;26E8 2A
		tax				;26E9 AA
		lda L_AD00,X	;26EA BD 00 AD
		and #$F8		;26ED 29 F8
		cmp ZP_14		;26EF C5 14
		lda L_A900,X	;26F1 BD 00 A9
		bcs L_26FC		;26F4 B0 06
		adc #$01		;26F6 69 01
		bcc L_26FC		;26F8 90 02
		lda #$FF		;26FA A9 FF
.L_26FC	rts				;26FC 60
.L_26FD	tax				;26FD AA
		lda ZP_14		;26FE A5 14
		cmp L_AC80,X	;2700 DD 80 AC
		lda L_A880,X	;2703 BD 80 A8
		bcc L_270A		;2706 90 02
		adc #$00		;2708 69 00
.L_270A	rts				;270A 60
.L_270B	tax				;270B AA
		lda ZP_14		;270C A5 14
		and #$FE		;270E 29 FE
		cmp L_AC00,X	;2710 DD 00 AC
		lda L_A800,X	;2713 BD 00 A8
		bcc L_271A		;2716 90 02
		adc #$00		;2718 69 00
.L_271A	rts				;271A 60
.L_271B	cmp #$00		;271B C9 00
		beq L_2722		;271D F0 03
		lda #$00		;271F A9 00
		rts				;2721 60
.L_2722	lda #$FF		;2722 A9 FF
		rts				;2724 60
}

.L_2725	rts				;2725 60

.update_camera_roll_tables
{
		lda L_0126		;2726 AD 26 01
		cmp L_2806		;2729 CD 06 28
		bne L_2738		;272C D0 0A
		lda L_0123		;272E AD 23 01
		and #$C0		;2731 29 C0
		cmp L_2807		;2733 CD 07 28
		beq L_2725		;2736 F0 ED
.L_2738	lda L_0123		;2738 AD 23 01
		and #$C0		;273B 29 C0
		sta L_2807		;273D 8D 07 28
		sta ZP_14		;2740 85 14
		lda L_0126		;2742 AD 26 01
		sta L_2806		;2745 8D 06 28
		asl ZP_14		;2748 06 14
		rol A			;274A 2A
		asl ZP_14		;274B 06 14
		rol A			;274D 2A
		bcc L_2754		;274E 90 04
		eor #$FF		;2750 49 FF
		adc #$00		;2752 69 00
.L_2754	tay				;2754 A8
		lda cosine_table,Y	;2755 B9 00 A7
		sta L_277B		;2758 8D 7B 27
		sta ZP_14		;275B 85 14
		tya				;275D 98
		eor #$FF		;275E 49 FF
		clc				;2760 18
		adc #$01		;2761 69 01
		beq L_2769		;2763 F0 04
		tay				;2765 A8
		lda cosine_table,Y	;2766 B9 00 A7
.L_2769	sta L_27B8		;2769 8D B8 27
		sta ZP_15		;276C 85 15
		lda #$00		;276E A9 00
		sta L_2781		;2770 8D 81 27
		clc				;2773 18
		ldy #$00		;2774 A0 00
		lda #$80		;2776 A9 80
		bne L_2780		;2778 D0 06
.L_277A	adc #$01		;277A 69 01
L_277B	= *-1			;!
		bcc L_2780		;277C 90 02
		iny				;277E C8
		clc				;277F 18
.L_2780	sty L_0300		;2780 8C 00 03
L_2781	= *-2			;!
		inc L_2781		;2783 EE 81 27
		bpl L_277A		;2786 10 F2
		lda #$80		;2788 A9 80
		sta L_27BE		;278A 8D BE 27
		ldy #$00		;278D A0 00
		lda #$80		;278F A9 80
		asl L_27B8		;2791 0E B8 27
		bcc L_27BD		;2794 90 27
		clc				;2796 18
		lda L_27B8		;2797 AD B8 27
		sta L_27A6		;279A 8D A6 27
		lda #$80		;279D A9 80
		sta L_27AD		;279F 8D AD 27
		jmp L_27AC		;27A2 4C AC 27
.L_27A5	adc #$01		;27A5 69 01
L_27A6	= *-1			;!
		iny				;27A7 C8
		bcc L_27AC		;27A8 90 02
		iny				;27AA C8
		clc				;27AB 18
.L_27AC	sty L_0380		;27AC 8C 80 03
L_27AD	= *-2			;!
		inc L_27AD		;27AF EE AD 27
		bmi L_27A5		;27B2 30 F1
		jmp L_27C5		;27B4 4C C5 27
.L_27B7	adc #$01		;27B7 69 01
L_27B8	= *-1			;!
		bcc L_27BD		;27B9 90 02
		iny				;27BB C8
		clc				;27BC 18
.L_27BD	sty L_0380		;27BD 8C 80 03
L_27BE	= *-2			;!
		inc L_27BE		;27C0 EE BE 27
		bmi L_27B7		;27C3 30 F2
.L_27C5	lda #$80		;27C5 A9 80
		sta L_C328		;27C7 8D 28 C3
		ldy #$01		;27CA A0 01
		ldx #$01		;27CC A2 01
		clc				;27CE 18
		lda #$00		;27CF A9 00
.L_27D1	adc ZP_14		;27D1 65 14
		bcc L_27D6		;27D3 90 01
		iny				;27D5 C8
.L_27D6	sta L_C328,X	;27D6 9D 28 C3
		tya				;27D9 98
		sta L_C334,X	;27DA 9D 34 C3
		lda L_C328,X	;27DD BD 28 C3
		lsr L_C334,X	;27E0 5E 34 C3
		ror L_C328,X	;27E3 7E 28 C3
		inx				;27E6 E8
		cpx #$09		;27E7 E0 09
		bcc L_27D1		;27E9 90 E6
		ldy #$00		;27EB A0 00
		ldx #$01		;27ED A2 01
		clc				;27EF 18
		tya				;27F0 98
.L_27F1	adc ZP_15		;27F1 65 15
		bcc L_27F6		;27F3 90 01
		iny				;27F5 C8
.L_27F6	sta L_C310,X	;27F6 9D 10 C3
		tya				;27F9 98
		sta L_C31C,X	;27FA 9D 1C C3
		lda L_C310,X	;27FD BD 10 C3
		inx				;2800 E8
		cpx #$09		;2801 E0 09
		bcc L_27F1		;2803 90 EC
		rts				;2805 60
}

.L_2806	equb $FF
.L_2807	equb $00

.L_2808	rts				;2808 60

.L_2809
		lda L_A330,X	;2809 BD 30 A3
		bmi L_2808		;280C 30 FA
.L_280E
{
		lda L_A298,X	;280E BD 98 A2
		ora L_A2E4,X	;2811 1D E4 A2
		bne L_285C		;2814 D0 46
		ldy L_A200,X	;2816 BC 00 A2
		bpl L_282A		;2819 10 0F
		lda L_0300,Y	;281B B9 00 03
		bmi L_285C		;281E 30 3C
		sta ZP_14		;2820 85 14
		lda L_0280,Y	;2822 B9 80 02
		sta ZP_15		;2825 85 15
		jmp L_2846		;2827 4C 46 28
.L_282A	tya				;282A 98
		eor #$7F		;282B 49 7F
		tay				;282D A8
		iny				;282E C8
		bpl L_2832		;282F 10 01
		dey				;2831 88
.L_2832	lda #$00		;2832 A9 00
		sec				;2834 38
		sbc L_0380,Y	;2835 F9 80 03
		bmi L_283C		;2838 30 02
		bne L_285C		;283A D0 20
.L_283C	sta ZP_14		;283C 85 14
		lda #$00		;283E A9 00
		sec				;2840 38
		sbc L_0300,Y	;2841 F9 00 03
		sta ZP_15		;2844 85 15
.L_2846	ldy L_A24C,X	;2846 BC 4C A2
		sty ZP_18		;2849 84 18
		bpl L_285F		;284B 10 12
		lda L_0300,Y	;284D B9 00 03
		lsr A			;2850 4A
		adc #$00		;2851 69 00
		lsr A			;2853 4A
		sta ZP_16		;2854 85 16
		lda L_0280,Y	;2856 B9 80 02
		jmp L_287B		;2859 4C 7B 28
.L_285C	jmp L_28B0		;285C 4C B0 28
.L_285F	tya				;285F 98
		eor #$7F		;2860 49 7F
		tay				;2862 A8
		iny				;2863 C8
		bpl L_2867		;2864 10 01
		dey				;2866 88
.L_2867	lda L_0380,Y	;2867 B9 80 03
		lsr A			;286A 4A
		adc #$00		;286B 69 00
		lsr A			;286D 4A
		eor #$FF		;286E 49 FF
		clc				;2870 18
		adc #$01		;2871 69 01
		sta ZP_16		;2873 85 16
		lda #$00		;2875 A9 00
		sec				;2877 38
		sbc L_0300,Y	;2878 F9 00 03
.L_287B	bit L_0126		;287B 2C 26 01
		bmi L_2894		;287E 30 14
		sec				;2880 38
		sbc ZP_14		;2881 E5 14
		bvs L_28B0		;2883 70 2B
		eor #$80		;2885 49 80
		sta L_A24C,X	;2887 9D 4C A2
		lda ZP_15		;288A A5 15
		clc				;288C 18
		adc ZP_16		;288D 65 16
		bvc L_28A5		;288F 50 14
		jmp L_28AB		;2891 4C AB 28
.L_2894	clc				;2894 18
		adc ZP_14		;2895 65 14
		bvs L_28B0		;2897 70 17
		eor #$80		;2899 49 80
		sta L_A24C,X	;289B 9D 4C A2
		lda ZP_15		;289E A5 15
		sec				;28A0 38
		sbc ZP_16		;28A1 E5 16
		bvs L_28AB		;28A3 70 06
.L_28A5	eor #$80		;28A5 49 80
		sta L_A200,X	;28A7 9D 00 A2
		rts				;28AA 60
.L_28AB	lda ZP_18		;28AB A5 18
		sta L_A24C,X	;28AD 9D 4C A2
.L_28B0	stx ZP_0D		;28B0 86 0D
		lda L_A200,X	;28B2 BD 00 A2
		sec				;28B5 38
		sbc #$80		;28B6 E9 80
		sta ZP_14		;28B8 85 14
		lda L_A298,X	;28BA BD 98 A2
		sbc #$00		;28BD E9 00
		sta ZP_79		;28BF 85 79
		bpl L_28CE		;28C1 10 0B
		lda #$00		;28C3 A9 00
		sec				;28C5 38
		sbc ZP_14		;28C6 E5 14
		sta ZP_14		;28C8 85 14
		lda #$00		;28CA A9 00
		sbc ZP_79		;28CC E5 79
.L_28CE	asl ZP_14		;28CE 06 14
		rol A			;28D0 2A
		tax				;28D1 AA
		lda ZP_14		;28D2 A5 14
		lsr A			;28D4 4A
		tay				;28D5 A8
		lda L_0380,Y	;28D6 B9 80 03
		clc				;28D9 18
		adc L_C310,X	;28DA 7D 10 C3
		sta ZP_7E		;28DD 85 7E
		lda #$00		;28DF A9 00
		adc L_C31C,X	;28E1 7D 1C C3
		sta ZP_80		;28E4 85 80
		lda L_0300,Y	;28E6 B9 00 03
		clc				;28E9 18
		adc L_C328,X	;28EA 7D 28 C3
		sta ZP_51		;28ED 85 51
		lda #$00		;28EF A9 00
		adc L_C334,X	;28F1 7D 34 C3
		sta ZP_77		;28F4 85 77
		ldx ZP_0D		;28F6 A6 0D
		lda L_A24C,X	;28F8 BD 4C A2
		sec				;28FB 38
		sbc #$80		;28FC E9 80
		sta ZP_14		;28FE 85 14
		lda L_A2E4,X	;2900 BD E4 A2
		sbc #$00		;2903 E9 00
		sta ZP_7A		;2905 85 7A
		bpl L_2914		;2907 10 0B
		lda #$00		;2909 A9 00
		sec				;290B 38
		sbc ZP_14		;290C E5 14
		sta ZP_14		;290E 85 14
		lda #$00		;2910 A9 00
		sbc ZP_7A		;2912 E5 7A
.L_2914	asl ZP_14		;2914 06 14
		rol A			;2916 2A
		tax				;2917 AA
		lda ZP_14		;2918 A5 14
		lsr A			;291A 4A
		tay				;291B A8
		lda L_C31C,X	;291C BD 1C C3
		sta ZP_7F		;291F 85 7F
		lda L_0380,Y	;2921 B9 80 03
		clc				;2924 18
		adc L_C310,X	;2925 7D 10 C3
;L_2927	= *-1			;!
		bcc L_292C		;2928 90 02
		inc ZP_7F		;292A E6 7F
.L_292C	lsr ZP_7F		;292C 46 7F
		ror A			;292E 6A
		adc #$00		;292F 69 00
		bcc L_2935		;2931 90 02
		inc ZP_7F		;2933 E6 7F
.L_2935	lsr ZP_7F		;2935 46 7F
		ror A			;2937 6A
		sta ZP_7D		;2938 85 7D
		lda L_0300,Y	;293A B9 00 03
		clc				;293D 18
		adc L_C328,X	;293E 7D 28 C3
		sta ZP_52		;2941 85 52
		lda #$00		;2943 A9 00
		adc L_C334,X	;2945 7D 34 C3
		sta ZP_78		;2948 85 78
		ldx ZP_0D		;294A A6 0D
		bit ZP_79		;294C 24 79
		bpl L_295D		;294E 10 0D
		lda #$00		;2950 A9 00
		sec				;2952 38
		sbc ZP_51		;2953 E5 51
		sta ZP_51		;2955 85 51
		lda #$01		;2957 A9 01
		sbc ZP_77		;2959 E5 77
		sta ZP_77		;295B 85 77
.L_295D	bit ZP_7A		;295D 24 7A
		bpl L_296E		;295F 10 0D
		lda #$00		;2961 A9 00
		sec				;2963 38
		sbc ZP_52		;2964 E5 52
		sta ZP_52		;2966 85 52
		lda #$01		;2968 A9 01
		sbc ZP_78		;296A E5 78
		sta ZP_78		;296C 85 78
.L_296E	lda ZP_7A		;296E A5 7A
		eor L_0126		;2970 4D 26 01
		bmi L_2984		;2973 30 0F
		lda ZP_51		;2975 A5 51
		clc				;2977 18
		adc ZP_7D		;2978 65 7D
		sta L_A200,X	;297A 9D 00 A2
		lda ZP_77		;297D A5 77
		adc ZP_7F		;297F 65 7F
		jmp L_2990		;2981 4C 90 29
.L_2984	lda ZP_51		;2984 A5 51
		sec				;2986 38
		sbc ZP_7D		;2987 E5 7D
		sta L_A200,X	;2989 9D 00 A2
		lda ZP_77		;298C A5 77
		sbc ZP_7F		;298E E5 7F
.L_2990	sta L_A298,X	;2990 9D 98 A2
		lda ZP_79		;2993 A5 79
		eor L_0126		;2995 4D 26 01
		bmi L_29A9		;2998 30 0F
		lda ZP_52		;299A A5 52
		sec				;299C 38
		sbc ZP_7E		;299D E5 7E
		sta L_A24C,X	;299F 9D 4C A2
		lda ZP_78		;29A2 A5 78
		sbc ZP_80		;29A4 E5 80
		jmp L_29B5		;29A6 4C B5 29
.L_29A9	lda ZP_52		;29A9 A5 52
		clc				;29AB 18
		adc ZP_7E		;29AC 65 7E
		sta L_A24C,X	;29AE 9D 4C A2
		lda ZP_78		;29B1 A5 78
		adc ZP_80		;29B3 65 80
.L_29B5	sta L_A2E4,X	;29B5 9D E4 A2
		rts				;29B8 60
}

.rndQ
{
		lda ZP_06		;29B9 A5 06
		lsr A			;29BB 4A
		lda ZP_05		;29BC A5 05
		sta ZP_06		;29BE 85 06
		ror A			;29C0 6A
		sta ZP_54		;29C1 85 54
		lda ZP_04		;29C3 A5 04
		sta ZP_05		;29C5 85 05
		and #$0F		;29C7 29 0F
		lsr A			;29C9 4A
		sta ZP_53		;29CA 85 53
		lda ZP_03		;29CC A5 03
		sta ZP_04		;29CE 85 04
		lda ZP_02		;29D0 A5 02
		sta ZP_03		;29D2 85 03
		lda ZP_04		;29D4 A5 04
		and #$F0		;29D6 29 F0
		ora ZP_53		;29D8 05 53
		ror A			;29DA 6A
		ror A			;29DB 6A
		ror A			;29DC 6A
		ror A			;29DD 6A
		eor ZP_54		;29DE 45 54
		sta ZP_02		;29E0 85 02
		rts				;29E2 60
}

.draw_crash_smokeQ
{
		ldy #$00		;29E3 A0 00
		txa				;29E5 8A
		and #$01		;29E6 29 01
		bne L_29EB		;29E8 D0 01
		iny				;29EA C8
.L_29EB	lda L_2A36,Y	;29EB B9 36 2A
		sta ZP_A0		;29EE 85 A0
		lda L_2A38,Y	;29F0 B9 38 2A
		sta ZP_08		;29F3 85 08
		txa				;29F5 8A
		lsr A			;29F6 4A
		and #$01		;29F7 29 01
		tax				;29F9 AA
		jsr set_linedraw_colour		;29FA 20 01 FC
		ldx ZP_C6		;29FD A6 C6
		lda L_80A0,X	;29FF BD A0 80
		clc				;2A02 18
		adc L_2A3C,Y	;2A03 79 3C 2A
		ldy L_C260,X	;2A06 BC 60 C2
.L_2A09	sta L_A220		;2A09 8D 20 A2
		sty L_A26C		;2A0C 8C 6C A2
		ldy ZP_A0		;2A0F A4 A0
		clc				;2A11 18
		adc L_2A3E,Y	;2A12 79 3E 2A
		sta L_A221		;2A15 8D 21 A2
		lda L_A26C		;2A18 AD 6C A2
		clc				;2A1B 18
		adc L_2A4D,Y	;2A1C 79 4D 2A
		sta L_A26D		;2A1F 8D 6D A2
		ldx #$20		;2A22 A2 20
		ldy #$21		;2A24 A0 21
		jsr draw_line		;2A26 20 C9 FE
		lda L_A221		;2A29 AD 21 A2
		ldy L_A26D		;2A2C AC 6D A2
		dec ZP_A0		;2A2F C6 A0
		dec ZP_08		;2A31 C6 08
		bpl L_2A09		;2A33 10 D4
		rts				;2A35 60

.L_2A36	equb $09,$0E
.L_2A38	equb $09,$04,$01,$00
.L_2A3C	equb $2A,$36
.L_2A3E	equb $03,$05,$06,$04,$07,$05,$03,$04,$04,$02,$03,$04,$06,$05,$02
.L_2A4D	equb $03,$02,$FE,$07,$03,$FC,$F9,$01,$FF,$FD,$06,$05,$FF,$FC,$FB
}

.L_2A5C
{
		ldy #$40		;2A5C A0 40
		sty ZP_08		;2A5E 84 08
.L_2A60	lda L_C640,Y	;2A60 B9 40 C6
		sec				;2A63 38
		sbc L_C63F,Y	;2A64 F9 3F C6
		sta ZP_14		;2A67 85 14
		bpl L_2A70		;2A69 10 05
		eor #$FF		;2A6B 49 FF
		clc				;2A6D 18
		adc #$01		;2A6E 69 01
.L_2A70	cmp #$04		;2A70 C9 04
		bcs L_2A88		;2A72 B0 14
		bit ZP_08		;2A74 24 08
		bmi L_2A7F		;2A76 30 07
		iny				;2A78 C8
		bpl L_2A60		;2A79 10 E5
		ldy #$40		;2A7B A0 40
		asl ZP_08		;2A7D 06 08
.L_2A7F	dey				;2A7F 88
		bne L_2A60		;2A80 D0 DE
		lda #$D2		;2A82 A9 D2
		sta L_C260,X	;2A84 9D 60 C2
		rts				;2A87 60
.L_2A88	bit ZP_14		;2A88 24 14
		bmi L_2A8D		;2A8A 30 01
		dey				;2A8C 88
.L_2A8D	sty ZP_16		;2A8D 84 16
		jsr rndQ		;2A8F 20 B9 29
		and #$07		;2A92 29 07
		sec				;2A94 38
		sbc #$02		;2A95 E9 02
		clc				;2A97 18
		adc L_C640,Y	;2A98 79 40 C6
		sta L_C260,X	;2A9B 9D 60 C2
		jsr rndQ		;2A9E 20 B9 29
		and #$07		;2AA1 29 07
		sec				;2AA3 38
		sbc #$04		;2AA4 E9 04
		clc				;2AA6 18
		adc ZP_16		;2AA7 65 16
		sta L_80A0,X	;2AA9 9D A0 80
		tay				;2AAC A8
		rts				;2AAD 60
}

.L_2AAE_with_load_save
{
		lda #$00		;2AAE A9 00
		sta L_C39A		;2AB0 8D 9A C3
		lda #$07		;2AB3 A9 07
		sta L_3953		;2AB5 8D 53 39
		ldy #$13		;2AB8 A0 13
		jsr L_3848		;2ABA 20 48 38
		ldy #$14		;2ABD A0 14
		jsr L_3848		;2ABF 20 48 38
		lda #$0F		;2AC2 A9 0F
		sta L_3953		;2AC4 8D 53 39
		jsr L_3884		;2AC7 20 84 38
		lda L_C77B		;2ACA AD 7B C7
		beq L_2AE9		;2ACD F0 1A
		ldx #$71		;2ACF A2 71
		jsr L_95E2		;2AD1 20 E2 95
		lda L_0840		;2AD4 AD 40 08
		clc				;2AD7 18
		adc #$09		;2AD8 69 09
		tay				;2ADA A8
		ldx L_952A,Y	;2ADB BE 2A 95
		jsr L_95E2		;2ADE 20 E2 95
		jsr debounce_fire_and_wait_for_fire		;2AE1 20 96 36
		ldx #$99		;2AE4 A2 99
		jsr L_95E2		;2AE6 20 E2 95
.L_2AE9	ldx #$94		;2AE9 A2 94
		jsr print_msg_2		;2AEB 20 CB A1
		ldx #$78		;2AEE A2 78
		ldy #$D5		;2AF0 A0 D5
		lda #$C0		;2AF2 A9 C0
		jsr L_EDAB		;2AF4 20 AB ED
		bit L_EE35		;2AF7 2C 35 EE
		bpl L_2AFD		;2AFA 10 01
		rts				;2AFC 60
.L_2AFD	jsr L_9448		;2AFD 20 48 94
		bcs L_2AE9		;2B00 B0 E7
		jsr L_361F		;2B02 20 1F 36
		jsr save_rndQ_stateQ		;2B05 20 2C 16
		lda #$00		;2B08 A9 00
		jsr L_3FBB_with_VIC		;2B0A 20 BB 3F
		lda #$01		;2B0D A9 01
		jsr L_93A8		;2B0F 20 A8 93
		ldx #$00		;2B12 A2 00
		lda #$20		;2B14 A9 20
.L_2B16	sta L_0400,X	;2B16 9D 00 04
		sta L_04FA,X	;2B19 9D FA 04
		sta L_05F4,X	;2B1C 9D F4 05
		sta L_06EE,X	;2B1F 9D EE 06
		inx				;2B22 E8
		cpx #$FA		;2B23 E0 FA
		bne L_2B16		;2B25 D0 EF

		lda #$00		;2B27 A9 00
		sta VIC_IRQMASK		;2B29 8D 1A D0		; VIC

		sei				;2B2C 78
		lda L_A000		;2B2D AD 00 A0
		pha				;2B30 48
		lda #$36		;2B31 A9 36
		sta RAM_SELECT		;2B33 85 01
		jsr L_FF84		;2B35 20 84 FF
		jsr L_FF87		;2B38 20 87 FF
		ldx #$1F		;2B3B A2 1F
.L_2B3D	lda L_FD30,X	;2B3D BD 30 FD
		sta L_0314,X	;2B40 9D 14 03
		dex				;2B43 CA
		bpl L_2B3D		;2B44 10 F7
		jsr L_E544		;2B46 20 44 E5

		lda #$C0		;2B49 A9 C0
		sta VIC_EXTCOL		;2B4B 8D 20 D0		; VIC
		sta VIC_BGCOL0		;2B4E 8D 21 D0		; VIC

		jsr L_0800		;2B51 20 00 08
		lda #$36		;2B54 A9 36
		sta RAM_SELECT		;2B56 85 01
		cli				;2B58 58
;L_2B59
		lda #$47		;2B59 A9 47
;L_2B5A	= *-1			;!
;L_2B5B
		ldx #$00		;2B5B A2 00
		jsr sysctl		;2B5D 20 25 87
		ldy L_0840		;2B60 AC 40 08
		ldx L_2C21,Y	;2B63 BE 21 2C
		lda #$00		;2B66 A9 00
		ldy #$00		;2B68 A0 00
		jsr KERNEL_SETLFS		;2B6A 20 BA FF
		bit L_C367		;2B6D 2C 67 C3
		bpl L_2B7B		;2B70 10 09
		lda #$01		;2B72 A9 01
		ldx #$D6		;2B74 A2 D6
		ldy #$94		;2B76 A0 94
		jmp L_2B8A		;2B78 4C 8A 2B
.L_2B7B	lda #$47		;2B7B A9 47
		ldx #$80		;2B7D A2 80
		jsr sysctl		;2B7F 20 25 87
		bcs L_2BC9		;2B82 B0 45
		lda #$0C		;2B84 A9 0C
		ldx #$C1		;2B86 A2 C1
		ldy #$AE		;2B88 A0 AE
.L_2B8A	jsr KERNEL_SETNAM		;2B8A 20 BD FF
		lda L_C77B		;2B8D AD 7B C7
		beq L_2BB9		;2B90 F0 27
		lda #$00		;2B92 A9 00
		sta ZP_FB		;2B94 85 FB
		lda L_C367		;2B96 AD 67 C3
		beq L_2BAB		;2B99 F0 10
		and #$01		;2B9B 29 01
		eor #$03		;2B9D 49 03
		clc				;2B9F 18
		adc #$3F		;2BA0 69 3F
		tay				;2BA2 A8
		ldx #$00		;2BA3 A2 00
		lda #$40		;2BA5 A9 40
		sta ZP_FC		;2BA7 85 FC
		bne L_2BB1		;2BA9 D0 06
.L_2BAB	ldx #$C0		;2BAB A2 C0
		ldy #$80		;2BAD A0 80
		sty ZP_FC		;2BAF 84 FC
.L_2BB1	lda #$FB		;2BB1 A9 FB
		jsr KERNEL_SAVE		;2BB3 20 D8 FF
		jmp L_2BC9		;2BB6 4C C9 2B
.L_2BB9	ldx #$00		;2BB9 A2 00
		ldy #$80		;2BBB A0 80
		lda L_C367		;2BBD AD 67 C3
		beq L_2BC4		;2BC0 F0 02
		ldy #$40		;2BC2 A0 40
.L_2BC4	lda #$00		;2BC4 A9 00
		jsr KERNEL_LOAD			;2BC6 20 D5 FF
.L_2BC9	ror L_C301		;2BC9 6E 01 C3
		jsr KERNEL_READST		;2BCC 20 B7 FF
		and #$BF		;2BCF 29 BF
		beq L_2BD7		;2BD1 F0 04
		sec				;2BD3 38
		ror L_C301		;2BD4 6E 01 C3
.L_2BD7	bit L_C301		;2BD7 2C 01 C3
		bpl L_2BE3		;2BDA 10 07
		lda #$47		;2BDC A9 47
		ldx #$00		;2BDE A2 00
		jsr sysctl		;2BE0 20 25 87
.L_2BE3	pla				;2BE3 68
		sta L_A000		;2BE4 8D 00 A0
		ldy #$4B		;2BE7 A0 4B
		jsr delay_approx_Y_25ths_sec		;2BE9 20 EB 3F
		lda #$35		;2BEC A9 35
		sta RAM_SELECT		;2BEE 85 01
		bit L_C301		;2BF0 2C 01 C3
		bpl L_2BFC		;2BF3 10 07
		lda #$80		;2BF5 A9 80
		sta L_C39A		;2BF7 8D 9A C3
		bne L_2C04		;2BFA D0 08
.L_2BFC	lda L_C367		;2BFC AD 67 C3
		bpl L_2C04		;2BFF 10 03
		jsr L_95EA		;2C01 20 EA 95
.L_2C04	jsr L_3FBE_with_VIC		;2C04 20 BE 3F
		sei				;2C07 78
		lda #$2B		;2C08 A9 2B
		sta VIC_SCROLY		;2C0A 8D 11 D0		; VIC
		jsr set_up_single_page_display		;2C0D 20 8B 3F
		cli				;2C10 58
		lda #$01		;2C11 A9 01
		sta VIC_IRQMASK		;2C13 8D 1A D0		; VIC
		lda #$00		;2C16 A9 00
		jsr L_93A8		;2C18 20 A8 93
		ldy #$09		;2C1B A0 09
		jsr L_1637		;2C1D 20 37 16
		rts				;2C20 60
}

.L_2C21	equb $01,$08	;2C21 01 08

.clear_screen_with_sysctl	;'F'
{
		ldx L_3DF8		;2C23 AE F8 3D
		lda #$45		;2C26 A9 45
		jmp sysctl		;2C28 4C 25 87
}

.L_2C2B_with_sysctl		;'>'
{
		lda #$3E		;2C2B A9 3E
		jmp sysctl		;2C2D 4C 25 87
}

.update_colour_map_with_sysctl	;'G'
{
		lda #$46		;2C30 A9 46
		jmp sysctl		;2C32 4C 25 87
}

.do_ai_depth_stuff		;'A'
{
		lda #$41		;2C35 A9 41
		jmp sysctl		;2C37 4C 25 87
}

.L_2C3A_with_sysctl		; 'B'
{
		bit ZP_6D		;2C3A 24 6D
		bmi L_2C3F		;2C3C 30 01
		rts				;2C3E 60
.L_2C3F
		lda #$42		;2C3F A9 42
		jmp sysctl		;2C41 4C 25 87
}

.L_2C44_with_sysctl
{
		lda L_C359		;2C44 AD 59 C3
		beq L_2C4C		;2C47 F0 03
		jmp L_1CCB		;2C49 4C CB 1C

.L_2C4C
		lda #$3D		;2C4C A9 3D
		jmp sysctl		;2C4E 4C 25 87
}

.L_2C51
		lda L_0188		;2C51 AD 88 01
		cmp #$10		;2C54 C9 10
		bcc L_2C5A		;2C56 90 02
		lda #$10		;2C58 A9 10
.L_2C5A	sta L_C350		;2C5A 8D 50 C3
		ldx #$0F		;2C5D A2 0F
		lda #$08		;2C5F A9 08
		bne L_2CAB		;2C61 D0 48
.L_2C63	rts				;2C63 60

.L_2C64
		ldx #$1F		;2C64 A2 1F
		lda #$D4		;2C66 A9 D4
.L_2C68	sta L_C260,X	;2C68 9D 60 C2
		dex				;2C6B CA
		bpl L_2C68		;2C6C 10 FA
		rts				;2C6E 60
.L_2C6F	lda L_C30A		;2C6F AD 0A C3
		bne L_2C78		;2C72 D0 04
		lda ZP_0E		;2C74 A5 0E
		beq L_2C63		;2C76 F0 EB
.L_2C78	bit ZP_6B		;2C78 24 6B
		bmi L_2C63		;2C7A 30 E7
		lda L_0188		;2C7C AD 88 01
		cmp #$01		;2C7F C9 01
		bcc L_2C63		;2C81 90 E0
		cmp #$32		;2C83 C9 32
		bcc L_2C89		;2C85 90 02
		lda #$32		;2C87 A9 32
.L_2C89	sta L_C350		;2C89 8D 50 C3
		ldx #$1F		;2C8C A2 1F
		jsr rndQ		;2C8E 20 B9 29
		and #$07		;2C91 29 07
		tay				;2C93 A8
		lda L_C350		;2C94 AD 50 C3
		cmp #$08		;2C97 C9 08
		bcs L_2C9F		;2C99 B0 04
		lda #$08		;2C9B A9 08
		bne L_2CAB		;2C9D D0 0C
.L_2C9F	cpy #$06		;2C9F C0 06
		bcc L_2CAB		;2CA1 90 08
		lda #$0D		;2CA3 A9 0D
		cpy #$07		;2CA5 C0 07
		bne L_2CAB		;2CA7 D0 02
		lda #$03		;2CA9 A9 03

.L_2CAB
		clc				;2CAB 18
		adc #$02		;2CAC 69 02
		sta L_AF8C		;2CAE 8D 8C AF
		stx ZP_2C		;2CB1 86 2C
		lda ZP_6A		;2CB3 A5 6A
		beq L_2C64		;2CB5 F0 AD
		lda #$01		;2CB7 A9 01
		jsr L_CF68		;2CB9 20 68 CF
		ldx ZP_2C		;2CBC A6 2C
.L_2CBE	jsr L_2D3D		;2CBE 20 3D 2D
		bne L_2CDD		;2CC1 D0 1A
		lda L_4120,X	;2CC3 BD 20 41
		clc				;2CC6 18
		adc #$02		;2CC7 69 02
		sta L_4120,X	;2CC9 9D 20 41
		clc				;2CCC 18
		adc L_C260,X	;2CCD 7D 60 C2
		sta L_C260,X	;2CD0 9D 60 C2
		lda L_80A0,X	;2CD3 BD A0 80
		clc				;2CD6 18
		adc L_4100,X	;2CD7 7D 00 41
		sta L_80A0,X	;2CDA 9D A0 80
.L_2CDD	dex				;2CDD CA
		bpl L_2CBE		;2CDE 10 DE
		ldx ZP_2C		;2CE0 A6 2C
.L_2CE2	lda L_C260,X	;2CE2 BD 60 C2
		cmp #$B8		;2CE5 C9 B8
		bcc L_2D39		;2CE7 90 50
		jsr rndQ		;2CE9 20 B9 29
		and #$07		;2CEC 29 07
		sta ZP_14		;2CEE 85 14
		lda L_C350		;2CF0 AD 50 C3
		lsr A			;2CF3 4A
		lsr A			;2CF4 4A
		clc				;2CF5 18
		adc ZP_14		;2CF6 65 14
		eor #$FF		;2CF8 49 FF
		sta L_4120,X	;2CFA 9D 20 41
		bit ZP_6B		;2CFD 24 6B
		bpl L_2D07		;2CFF 10 06
		jsr L_2A5C		;2D01 20 5C 2A
		jmp L_2D1F		;2D04 4C 1F 2D
.L_2D07	jsr rndQ		;2D07 20 B9 29
		and #$3F		;2D0A 29 3F
		clc				;2D0C 18
		adc #$20		;2D0D 69 20
		sta L_80A0,X	;2D0F 9D A0 80
		tay				;2D12 A8
		jsr rndQ		;2D13 20 B9 29
		ora #$F8		;2D16 09 F8
		clc				;2D18 18
		adc L_C280,Y	;2D19 79 80 C2
		sta L_C260,X	;2D1C 9D 60 C2
.L_2D1F	lda #$00		;2D1F A9 00
		sta ZP_14		;2D21 85 14
		tya				;2D23 98
		ldy #$03		;2D24 A0 03
		sec				;2D26 38
		sbc #$40		;2D27 E9 40
		bpl L_2D2D		;2D29 10 02
		dec ZP_14		;2D2B C6 14
.L_2D2D	lsr ZP_14		;2D2D 46 14
		ror A			;2D2F 6A
		dey				;2D30 88
		bne L_2D2D		;2D31 D0 FA
		sta L_4100,X	;2D33 9D 00 41
		jsr L_2D3D		;2D36 20 3D 2D
.L_2D39	dex				;2D39 CA
		bpl L_2CE2		;2D3A 10 A6
		rts				;2D3C 60
.L_2D3D	stx ZP_C6		;2D3D 86 C6
		ldy L_C260,X	;2D3F BC 60 C2
		cpy #$B8		;2D42 C0 B8
		bcs L_2D4F		;2D44 B0 09
		lda L_80A0,X	;2D46 BD A0 80
		bmi L_2D4F		;2D49 30 04
		cpy #$41		;2D4B C0 41
		bcs L_2D55		;2D4D B0 06
.L_2D4F	lda #$D2		;2D4F A9 D2
		sta L_C260,X	;2D51 9D 60 C2
		rts				;2D54 60
.L_2D55	bit ZP_6B		;2D55 24 6B
		bpl L_2D5F		;2D57 10 06
		jsr draw_crash_smokeQ		;2D59 20 E3 29
		jmp L_2D71		;2D5C 4C 71 2D
.L_2D5F	tax				;2D5F AA
		jsr L_2D76		;2D60 20 76 2D
		and L_A4C0,X	;2D63 3D C0 A4
		sta (ZP_1E),Y	;2D66 91 1E
		dey				;2D68 88
		jsr L_2D76		;2D69 20 76 2D
		and L_A4C0,X	;2D6C 3D C0 A4
		sta (ZP_1E),Y	;2D6F 91 1E
.L_2D71	ldx ZP_C6		;2D71 A6 C6
		lda #$00		;2D73 A9 00
		rts				;2D75 60
.L_2D76	txa				;2D76 8A
		and #$7C		;2D77 29 7C
		asl A			;2D79 0A
		adc Q_pointers_LO,Y	;2D7A 79 00 A5
		sta ZP_1E		;2D7D 85 1E
		lda Q_pointers_HI,Y	;2D7F B9 00 A6
		adc ZP_12		;2D82 65 12
		sta ZP_1F		;2D84 85 1F
		lda (ZP_1E),Y	;2D86 B1 1E
		rts				;2D88 60

; only called from game update
.L_2D89_from_game_update
{
		lda L_0156		;2D89 AD 56 01
		sta ZP_14		;2D8C 85 14
		lda L_0159		;2D8E AD 59 01
		jsr negate_if_N_set		;2D91 20 BD C8
		sta L_0188		;2D94 8D 88 01
		ldx ZP_6A		;2D97 A6 6A
		bne L_2DA9		;2D99 D0 0E
		lda ZP_5D		;2D9B A5 5D
		lsr A			;2D9D 4A
		lsr A			;2D9E 4A
		sta ZP_14		;2D9F 85 14
		lda ZP_5D		;2DA1 A5 5D
		sec				;2DA3 38
		sbc ZP_14		;2DA4 E5 14
		sta ZP_5D		;2DA6 85 5D
		rts				;2DA8 60
.L_2DA9	cmp #$08		;2DA9 C9 08
		bcs L_2DB5		;2DAB B0 08
		ldy #$FD		;2DAD A0 FD
		jsr shift_16bit		;2DAF 20 BF C9
		sta ZP_5D		;2DB2 85 5D
		rts				;2DB4 60
.L_2DB5	asl ZP_14		;2DB5 06 14
		rol A			;2DB7 2A
		clc				;2DB8 18
		adc #$30		;2DB9 69 30
		bcc L_2DBF		;2DBB 90 02
		lda #$FF		;2DBD A9 FF
.L_2DBF	sta ZP_5D		;2DBF 85 5D
		rts				;2DC1 60
}

; only called from game update
.L_2DC2_from_game_update
{
		ldx L_C374		;2DC2 AE 74 C3
		stx ZP_2E		;2DC5 86 2E
		jsr get_track_segment_detailsQ		;2DC7 20 2F F0
		lda L_0189		;2DCA AD 89 01
		sec				;2DCD 38
		sbc L_0122		;2DCE ED 22 01
		sta ZP_14		;2DD1 85 14
		lda L_018A		;2DD3 AD 8A 01
		eor ZP_A4		;2DD6 45 A4
		sbc L_0125		;2DD8 ED 25 01
		sta ZP_15		;2DDB 85 15
		ldy #$00		;2DDD A0 00
		lda ZP_B2		;2DDF A5 B2
		bpl L_2DEB		;2DE1 10 08
		iny				;2DE3 C8
		lda ZP_9D		;2DE4 A5 9D
		eor ZP_A4		;2DE6 45 A4
		bpl L_2DEB		;2DE8 10 01
		iny				;2DEA C8
.L_2DEB	lda ZP_14		;2DEB A5 14
		clc				;2DED 18
		adc L_2EFD,Y	;2DEE 79 FD 2E
		sta ZP_14		;2DF1 85 14
		lda ZP_15		;2DF3 A5 15
		adc L_2F00,Y	;2DF5 79 00 2F
		sta ZP_77		;2DF8 85 77
		jsr negate_if_N_set		;2DFA 20 BD C8
		sta ZP_7F		;2DFD 85 7F
		ldy ZP_14		;2DFF A4 14
		sty ZP_7D		;2E01 84 7D
		cmp #$08		;2E03 C9 08
		bcc L_2E0B		;2E05 90 04
		lda #$7F		;2E07 A9 7F
		bne L_2E10		;2E09 D0 05
.L_2E0B	ldy #$FC		;2E0B A0 FC
		jsr shift_16bit		;2E0D 20 BF C9
.L_2E10	sta ZP_A5		;2E10 85 A5
		lda ZP_BE		;2E12 A5 BE
		sec				;2E14 38
		sbc ZP_C3		;2E15 E5 C3
		cmp #$02		;2E17 C9 02
		bcs L_2E21		;2E19 B0 06
		jsr L_CFC5		;2E1B 20 C5 CF
		jsr get_track_segment_detailsQ		;2E1E 20 2F F0
.L_2E21	lda ZP_9D		;2E21 A5 9D
		eor ZP_A4		;2E23 45 A4
		sta ZP_79		;2E25 85 79
		lda ZP_C5		;2E27 A5 C5
		beq L_2E59		;2E29 F0 2E
		eor ZP_77		;2E2B 45 77
		sta ZP_14		;2E2D 85 14
		lda ZP_B2		;2E2F A5 B2
		bpl L_2E4D		;2E31 10 1A
		lda ZP_C5		;2E33 A5 C5
		eor ZP_79		;2E35 45 79
		bmi L_2E41		;2E37 30 08
		lda ZP_C8		;2E39 A5 C8
		clc				;2E3B 18
		adc #$2D		;2E3C 69 2D
		jmp L_2E4F		;2E3E 4C 4F 2E
.L_2E41	lda ZP_79		;2E41 A5 79
		sta ZP_C5		;2E43 85 C5
		lda ZP_C8		;2E45 A5 C8
		sec				;2E47 38
		sbc #$23		;2E48 E9 23
		jmp L_2E56		;2E4A 4C 56 2E
.L_2E4D	lda ZP_C8		;2E4D A5 C8
.L_2E4F	bit ZP_14		;2E4F 24 14
		bmi L_2E56		;2E51 30 03
		clc				;2E53 18
		adc ZP_A5		;2E54 65 A5
.L_2E56	jmp L_2ED7		;2E56 4C D7 2E
.L_2E59	lda #$00		;2E59 A9 00
		sta ZP_16		;2E5B 85 16
		sta ZP_17		;2E5D 85 17
		lda ZP_B2		;2E5F A5 B2
		bpl L_2E6C		;2E61 10 09
		lda ZP_79		;2E63 A5 79
		sta ZP_C5		;2E65 85 C5
		lda ZP_C8		;2E67 A5 C8
		jmp L_2ED7		;2E69 4C D7 2E
.L_2E6C	ldy ZP_7D		;2E6C A4 7D
		sty ZP_14		;2E6E 84 14
		lda ZP_7F		;2E70 A5 7F
		beq L_2E7B		;2E72 F0 07
		sec				;2E74 38
		sbc #$1E		;2E75 E9 1E
		bpl L_2E98		;2E77 10 1F
		ldy #$FF		;2E79 A0 FF
.L_2E7B	sty ZP_15		;2E7B 84 15
		lda L_0159		;2E7D AD 59 01
		bpl L_2E87		;2E80 10 05
		eor #$FF		;2E82 49 FF
		clc				;2E84 18
		adc #$01		;2E85 69 01
.L_2E87	clc				;2E87 18
		adc #$0A		;2E88 69 0A
		jsr mul_8_8_16bit		;2E8A 20 82 C7
		ldy #$07		;2E8D A0 07
		jsr shift_16bit		;2E8F 20 BF C9
		ldy ZP_14		;2E92 A4 14
		bne L_2E98		;2E94 D0 02
		inc ZP_14		;2E96 E6 14
.L_2E98	bit ZP_77		;2E98 24 77
		jsr negate_if_N_set		;2E9A 20 BD C8
		sta ZP_15		;2E9D 85 15
		lda L_0122		;2E9F AD 22 01
		clc				;2EA2 18
		adc ZP_14		;2EA3 65 14
		sta L_0122		;2EA5 8D 22 01
		lda L_0125		;2EA8 AD 25 01
		adc ZP_15		;2EAB 65 15
		sta L_0125		;2EAD 8D 25 01
.L_2EB0	ldy #$00		;2EB0 A0 00
		lda L_010D		;2EB2 AD 0D 01
		sta ZP_14		;2EB5 85 14
		lda L_0113		;2EB7 AD 13 01
		jsr shift_16bit		;2EBA 20 BF C9
		sta ZP_15		;2EBD 85 15
		lda ZP_16		;2EBF A5 16
		sec				;2EC1 38
		sbc ZP_14		;2EC2 E5 14
		sta L_0119		;2EC4 8D 19 01
		lda ZP_17		;2EC7 A5 17
		sbc ZP_15		;2EC9 E5 15
		ldy ZP_6A		;2ECB A4 6A
		bne L_2ED3		;2ECD D0 04
		sty L_0119		;2ECF 8C 19 01
		tya				;2ED2 98
.L_2ED3	sta L_011F		;2ED3 8D 1F 01
		rts				;2ED6 60
.L_2ED7	sta ZP_15		;2ED7 85 15
		lda L_0156		;2ED9 AD 56 01
		sta ZP_14		;2EDC 85 14
		lda L_0159		;2EDE AD 59 01
		jsr mul_8_16_16bit		;2EE1 20 45 C8
		bit ZP_C5		;2EE4 24 C5
		jsr negate_if_N_set		;2EE6 20 BD C8
		ldy #$03		;2EE9 A0 03
		jsr shift_16bit		;2EEB 20 BF C9
		sta ZP_17		;2EEE 85 17
		lda ZP_14		;2EF0 A5 14
		sta ZP_16		;2EF2 85 16
		lda ZP_7F		;2EF4 A5 7F
		cmp #$1E		;2EF6 C9 1E
		bcc L_2EB0		;2EF8 90 B6
		jmp L_2E6C		;2EFA 4C 6C 2E
}

.L_2EFD	equb $00,$D9,$27
.L_2F00	equb $00,$00,$FF

.draw_track_preview_border
{
		ldy #$00		;2F03 A0 00
		ldx #$00		;2F05 A2 00
.L_2F07	lda L_6130,X	;2F07 BD 30 61
		sta L_4010,Y	;2F0A 99 10 40
		sta L_40A0,Y	;2F0D 99 A0 40
		lda L_6270,X	;2F10 BD 70 62
		sta L_4150,Y	;2F13 99 50 41
		sta L_41E0,Y	;2F16 99 E0 41
		lda L_63B0,X	;2F19 BD B0 63
		sta L_5690,Y	;2F1C 99 90 56
		sta L_5720,Y	;2F1F 99 20 57
		lda L_64F0,X	;2F22 BD F0 64
		sta L_57D0,Y	;2F25 99 D0 57
		sta L_5860,Y	;2F28 99 60 58
		inx				;2F2B E8
		iny				;2F2C C8
		cpx #$18		;2F2D E0 18
		bne L_2F33		;2F2F D0 02
		ldx #$00		;2F31 A2 00
.L_2F33	cpy #$90		;2F33 C0 90
		bne L_2F07		;2F35 D0 D0
		ldx #$30		;2F37 A2 30
		ldy #$66		;2F39 A0 66
		lda #$48		;2F3B A9 48
		sta ZP_1E		;2F3D 85 1E
		lda #$41		;2F3F A9 41
		jsr L_2F4E		;2F41 20 4E 2F
		ldx #$40		;2F44 A2 40
		ldy #$66		;2F46 A0 66
		lda #$68		;2F48 A9 68
		sta ZP_1E		;2F4A 85 1E
		lda #$42		;2F4C A9 42
.L_2F4E	sta ZP_1F		;2F4E 85 1F
		stx ZP_16		;2F50 86 16
		sty ZP_17		;2F52 84 17
		lda #$12		;2F54 A9 12
		sta ZP_14		;2F56 85 14
.L_2F58	lda ZP_17		;2F58 A5 17
		sta ZP_99		;2F5A 85 99
		lda ZP_16		;2F5C A5 16
		sta ZP_98		;2F5E 85 98
		lda #$03		;2F60 A9 03
		sta ZP_15		;2F62 85 15
.L_2F64	ldy #$00		;2F64 A0 00
.L_2F66	lda (ZP_98),Y	;2F66 B1 98
		sta (ZP_1E),Y	;2F68 91 1E
		iny				;2F6A C8
		cpy #$10		;2F6B C0 10
		bne L_2F66		;2F6D D0 F7
		dec ZP_14		;2F6F C6 14
		beq L_2F94		;2F71 F0 21
		lda ZP_1E		;2F73 A5 1E
		clc				;2F75 18
		adc #$40		;2F76 69 40
		sta ZP_1E		;2F78 85 1E
		lda ZP_1F		;2F7A A5 1F
		adc #$01		;2F7C 69 01
		sta ZP_1F		;2F7E 85 1F
		dec ZP_15		;2F80 C6 15
		beq L_2F58		;2F82 F0 D4
		lda ZP_98		;2F84 A5 98
		clc				;2F86 18
		adc #$40		;2F87 69 40
		sta ZP_98		;2F89 85 98
		lda ZP_99		;2F8B A5 99
		adc #$01		;2F8D 69 01
		sta ZP_99		;2F8F 85 99
		jmp L_2F64		;2F91 4C 64 2F
.L_2F94	ldx #$05		;2F94 A2 05
		ldy #$02		;2F96 A0 02
.L_2F98	lda #$AA		;2F98 A9 AA
		sta L_4008,X	;2F9A 9D 08 40
		sta L_4130,X	;2F9D 9D 30 41
		sta L_57C8,Y	;2FA0 99 C8 57
		sta L_58F0,Y	;2FA3 99 F0 58
		lda #$80		;2FA6 A9 80
		sta L_4268,X	;2FA8 9D 68 42
		lda #$02		;2FAB A9 02
		sta L_5690,Y	;2FAD 99 90 56
		iny				;2FB0 C8
		dex				;2FB1 CA
		bpl L_2F98		;2FB2 10 E4
		ldx #$01		;2FB4 A2 01
.L_2FB6	lda #$A9		;2FB6 A9 A9
		sta L_400E,X	;2FB8 9D 0E 40
		lda #$2A		;2FBB A9 2A
		sta L_4136,X	;2FBD 9D 36 41
		lda #$A8		;2FC0 A9 A8
		sta L_57C8,X	;2FC2 9D C8 57
		lda #$6A		;2FC5 A9 6A
		sta L_58F0,X	;2FC7 9D F0 58
		dex				;2FCA CA
		bpl L_2FB6		;2FCB 10 E9
		rts				;2FCD 60
}

.draw_track_preview_track_name
{
		jsr L_3884		;2FCE 20 84 38
		ldx L_C77D		;2FD1 AE 7D C7
		lda L_301B,X	;2FD4 BD 1B 30
		sta L_3460		;2FD7 8D 60 34
		ldx #$58		;2FDA A2 58
		jsr print_msg_4		;2FDC 20 27 30
		ldx L_C77D		;2FDF AE 7D C7
		jsr print_track_name		;2FE2 20 92 38
		jsr L_361F		;2FE5 20 1F 36
		lda #$03		;2FE8 A9 03
		sta ZP_17		;2FEA 85 17
.L_2FEC	ldx ZP_17		;2FEC A6 17
		ldy L_3017,X	;2FEE BC 17 30
		ldx #$58		;2FF1 A2 58
		lda #$14		;2FF3 A9 14
		jsr L_3A4F		;2FF5 20 4F 3A
		dec ZP_17		;2FF8 C6 17
		bpl L_2FEC		;2FFA 10 F0
		lda #$03		;2FFC A9 03
		sta ZP_15		;2FFE 85 15
		ldx #$54		;3000 A2 54
		ldy #$E9		;3002 A0 E9
		lda #$14		;3004 A9 14
		jsr L_3A66		;3006 20 66 3A
		lda #$C0		;3009 A9 C0
		sta ZP_15		;300B 85 15
		ldx #$A8		;300D A2 A8
		ldy #$E9		;300F A0 E9
		lda #$14		;3011 A9 14
		jsr L_3A66		;3013 20 66 3A
		rts				;3016 60
}

.L_3017	equb $D6,$D7,$E8,$E9
.L_301B	equb $F,$D,$10,$10,$10,$F,$10,$D

.L_3023	jsr write_char		;3023 20 6F 84
		inx				;3026 E8
.print_msg_4
{
		lda frontend_strings_4,X	;3027 BD 07 34
		cmp #$FF		;302A C9 FF
		bne L_3023		;302C D0 F5
		rts				;302E 60
}

.select_track
{
		tax				;302F AA
		lda track_order,X	;3030 BD 28 37
		sta L_C77D		;3033 8D 7D C7
		lda L_C71A		;3036 AD 1A C7
		beq L_303F		;3039 F0 04
		txa				;303B 8A
		eor #$01		;303C 49 01
		tax				;303E AA
.L_303F	lda track_background_colours,X	;303F BD 30 37
		sta L_C76B		;3042 8D 6B C7
		rts				;3045 60
}

.L_3046
{
		ldx #$0B		;3046 A2 0B
.L_3048	lda L_C6C0,X	;3048 BD C0 C6
		sta L_DAB6,X	;304B 9D B6 DA		; COLOR RAM
		dex				;304E CA
		bpl L_3048		;304F 10 F7
		rts				;3051 60
}

.do_initial_screen
{
		lda #$80		;3052 A9 80
		sta L_31A0		;3054 8D A0 31
		lda #$00		;3057 A9 00
		sta L_31A1		;3059 8D A1 31
		ldy #$01		;305C A0 01
		ldx #$10		;305E A2 10
		jsr do_menu_screen		;3060 20 36 EE
		cmp #$00		;3063 C9 00
		bne L_307D		;3065 D0 16
		jsr get_entered_name		;3067 20 7F ED
		jmp L_308C		;306A 4C 8C 30
.L_306D	lda #$00		;306D A9 00
		ldy #$01		;306F A0 01
		ldx #$14		;3071 A2 14
		jsr do_menu_screen		;3073 20 36 EE
		cmp #$00		;3076 C9 00
		bne L_3087		;3078 D0 0D
		inc L_31A1		;307A EE A1 31
.L_307D	jsr get_entered_name		;307D 20 7F ED
		lda L_31A1		;3080 AD A1 31
		cmp #$07		;3083 C9 07
		bcc L_306D		;3085 90 E6
.L_3087	lda L_31A1		;3087 AD A1 31
		beq L_306D		;308A F0 E1
.L_308C	lda #$00		;308C A9 00
		sta L_31A0		;308E 8D A0 31
		rts				;3091 60
}

.L_3092
{
		jsr L_E9A3		;3092 20 A3 E9
		lda #$10		;3095 A9 10
		sta L_3845		;3097 8D 45 38
		lda #$0E		;309A A9 0E
		sta L_321D		;309C 8D 1D 32
		lda L_C39C		;309F AD 9C C3
		and L_31A5		;30A2 2D A5 31
		bpl L_3110		;30A5 10 69
		jsr clear_menu_area		;30A7 20 23 1C
		jsr menu_colour_map_stuff		;30AA 20 C4 38
		ldx #$04		;30AD A2 04
		ldy #$09		;30AF A0 09
		jsr get_colour_map_ptr		;30B1 20 FA 38
		ldx #$10		;30B4 A2 10
		lda #$01		;30B6 A9 01
		jsr fill_colourmap_solid		;30B8 20 16 39
		ldy #$09		;30BB A0 09
		ldx #$0B		;30BD A2 0B
		ldy #$09		;30BF A0 09
		jsr set_text_cursor		;30C1 20 6B 10
		ldx #$00		;30C4 A2 00
		jsr print_msg_1		;30C6 20 A5 32
		lda L_31A1		;30C9 AD A1 31
		cmp #$05		;30CC C9 05
		bcc L_30D3		;30CE 90 03
		jsr L_3884		;30D0 20 84 38
.L_30D3	ldx L_31A1		;30D3 AE A1 31
		lda L_3190,X	;30D6 BD 90 31
		tay				;30D9 A8
		clc				;30DA 18
		adc #$02		;30DB 69 02
		sta L_3845		;30DD 8D 45 38
		jsr L_3170		;30E0 20 70 31
		jsr L_91CF		;30E3 20 CF 91
		lda L_31A1		;30E6 AD A1 31
		cmp #$06		;30E9 C9 06
		beq L_30F4		;30EB F0 07
		cmp #$05		;30ED C9 05
		beq L_30F4		;30EF F0 03
		jsr L_361F		;30F1 20 1F 36
.L_30F4	ldx L_31A1		;30F4 AE A1 31
		lda L_3198,X	;30F7 BD 98 31
		sta L_321D		;30FA 8D 1D 32
		clc				;30FD 18
		adc #$02		;30FE 69 02
		ldy L_31A1		;3100 AC A1 31
		cpy #$07		;3103 C0 07
		bne L_310A		;3105 D0 03
		sec				;3107 38
		sbc #$01		;3108 E9 01
.L_310A	sta L_3845		;310A 8D 45 38
		jmp L_3153		;310D 4C 53 31

.L_3110
		jsr set_up_screen_for_menu		;3110 20 1F 35
		bit L_C39C		;3113 2C 9C C3
		bmi L_314E		;3116 30 36
		ldx #$86		;3118 A2 86
		jsr print_msg_4		;311A 20 27 30
		lda L_C74B		;311D AD 4B C7
		cmp #$07		;3120 C9 07
		bcc L_3158		;3122 90 34
		ldx #$04		;3124 A2 04
		ldy #$0C		;3126 A0 0C
		jsr get_colour_map_ptr		;3128 20 FA 38
		ldx #$10		;312B A2 10
		lda #$01		;312D A9 01
		jsr fill_colourmap_solid		;312F 20 16 39
		ldx #$04		;3132 A2 04
		ldy #$0D		;3134 A0 0D
		jsr get_colour_map_ptr		;3136 20 FA 38
		ldx #$10		;3139 A2 10
		lda #$01		;313B A9 01
		jsr fill_colourmap_solid		;313D 20 16 39
		jsr L_3884		;3140 20 84 38
		ldx #$13		;3143 A2 13
		jsr print_msg_1		;3145 20 A5 32
		jsr L_361F		;3148 20 1F 36
		jmp L_3158		;314B 4C 58 31
.L_314E	ldy #$0B		;314E A0 0B
		jsr L_3170		;3150 20 70 31
.L_3153	ldx #$71		;3153 A2 71
		jsr print_msg_3		;3155 20 DC A1
.L_3158	lda #$0E		;3158 A9 0E
		sta ZP_19		;315A 85 19
		lda L_31A1		;315C AD A1 31
		clc				;315F 18
		adc #$02		;3160 69 02
		jsr highlight_current_menu_item		;3162 20 5A 38
.L_3165	jsr L_387B		;3165 20 7B 38
		inc ZP_7A		;3168 E6 7A
		jsr L_364F		;316A 20 4F 36
		bne L_3165		;316D D0 F6
		rts				;316F 60
}

.L_3170
{
		ldx #$06		;3170 A2 06
		jsr set_text_cursor		;3172 20 6B 10
		ldx #$93		;3175 A2 93
		jsr print_msg_3		;3177 20 DC A1
		ldx L_C77D		;317A AE 7D C7
		jsr print_track_name		;317D 20 92 38
		lda L_31A1		;3180 AD A1 31
		beq L_318F		;3183 F0 0A
		lda L_C71A		;3185 AD 1A C7
		beq L_318F		;3188 F0 05
		ldx #$63		;318A A2 63
		jsr print_msg_3		;318C 20 DC A1
.L_318F	rts				;318F 60
}

.L_3190	equb $0C,$0C,$0C,$0C,$0B,$0B,$0A,$0A
.L_3198	equb $13,$13,$13,$12,$11,$10,$0F,$0F
.L_31A0	equb $00
.L_31A1	equb $00
.L_31A2	equb $00
.L_31A3	equb $06
.L_31A4	equb $0B
.L_31A5	equb $00
.L_31A6	equb $00
.L_31A7	equb $00
.L_31A8	equb $00
.L_31A9	equb $00

; FRONTEND STRINGS

.frontend_strings_3
		equb $1F,$11,$0B,"SELECT",$FF
		equb "Single Player League",$FF
		equb "Multiplayer",$FF
		equb "Enter another driver",$FF
		equb "Continue",$FF
		equb "Tracks in DIVISION ",$FF
		equb $00,$00,$00
		equb $00,$00,$00," S.",$FF
		equb "        s",$FF
		equb $1F,$06
.L_321D	equb $0E,"DRIVER      BEST-LAP RACE-TIME",$FF
		equb "Track:  The ",$FF
		equb $1F,$0A,$09
		equb "DRIVERS CHAMPIONSHIP",$FF
		equb $1F,$0E,$14,"Track record",$FF
		equb $00
.L_3273	equb "------------",$FF
.L_3280	equb "------------",$FF
		equb $1F,$0C,$0F
		equb "New track record",$FF

.L_32A1	jsr write_char		;32A1 20 6F 84
		inx				;32A4 E8
.print_msg_1
{
		lda frontend_strings_1,X	;32A5 BD AD 32
		cmp #$FF		;32A8 C9 FF
		bne L_32A1		;32AA D0 F5
		rts				;32AC 60
}

; FRONTEND STRINGS

.frontend_strings_1
		equb "TRACK BONUS POINTS",$FF
		equb $1F,$0E,$0C,"FINAL SEASON",$FF
		equb "Race Time: ",$FF
		equb "Best Lap : ",$FF
		equb $1F,$10,$01
		equb "HALL of FAME",$FF
		equb $1F,$10,$03
		equb "SUPER LEAGUE",$FF
		equb $1F,$00,$06
		equb "TRACK  DRIVER   LAP-TIME    DRIVER  RACE-TIME",$FF

.print_number_pad4
		pha				;3339 48
		jsr print_2space		;333A 20 AA 91
		pla				;333D 68
		jmp print_number_pad2		;333E 4C 45 33

.print_number_unpadded
		cmp #$0A		;3341 C9 0A
		bcc L_335E		;3343 90 19

.print_number_pad2
		cmp #$0A		;3345 C9 0A
		bcs L_3350		;3347 B0 07
		pha				;3349 48
		jsr print_space		;334A 20 AF 91
		jmp L_335B		;334D 4C 5B 33

.L_3350	jsr convert_X_to_BCD		;3350 20 15 92

.print_BCD_double_digits
		pha				;3353 48
		lsr A			;3354 4A
		lsr A			;3355 4A
		lsr A			;3356 4A
		lsr A			;3357 4A
		jsr print_single_digit		;3358 20 8A 10
.L_335B
		pla				;335B 68
		and #$0F		;335C 29 0F
.L_335E	jmp print_single_digit		;335E 4C 8A 10

.L_3361_with_decimal
{
		sed				;3361 F8
		lda L_8298,X	;3362 BD 98 82
		clc				;3365 18
		adc L_8298,Y	;3366 79 98 82
		sta L_8298,Y	;3369 99 98 82
		lda L_82B0,X	;336C BD B0 82
		adc L_82B0,Y	;336F 79 B0 82
		bcs L_3378		;3372 B0 04
		cmp #$60		;3374 C9 60
		bcc L_337B		;3376 90 03
.L_3378	sbc #$60		;3378 E9 60
		sec				;337A 38
.L_337B	sta L_82B0,Y	;337B 99 B0 82
		lda L_8398,X	;337E BD 98 83
		adc L_8398,Y	;3381 79 98 83
		sta L_8398,Y	;3384 99 98 83
		cld				;3387 D8
		rts				;3388 60
}

.L_3389
{
		ldx #$06		;3389 A2 06
		lda L_31A1		;338B AD A1 31
		beq L_33E8		;338E F0 58
		jsr disable_ints_and_page_in_RAM		;3390 20 F1 33
		ldx #$01		;3393 A2 01
		stx L_31A2		;3395 8E A2 31
.L_3398	stx ZP_15		;3398 86 15
		txa				;339A 8A
		ldy L_C718		;339B AC 18 C7
		beq L_33B5		;339E F0 15
		jsr rndQ		;33A0 20 B9 29
		and #$01		;33A3 29 01
		clc				;33A5 18
		adc #$01		;33A6 69 01
		clc				;33A8 18
		adc L_31A9		;33A9 6D A9 31
		cmp #$03		;33AC C9 03
		bcc L_33B2		;33AE 90 02
		sbc #$03		;33B0 E9 03
.L_33B2	sta L_31A9		;33B2 8D A9 31
.L_33B5	clc				;33B5 18
		adc L_E8E1,Y	;33B6 79 E1 E8
		tay				;33B9 A8
		lda L_DCE0,Y	;33BA B9 E0 DC			; CIA1
		sta L_AEE0,X	;33BD 9D E0 AE
		txa				;33C0 8A
		asl A			;33C1 0A
		asl A			;33C2 0A
		asl A			;33C3 0A
		asl A			;33C4 0A
		tax				;33C5 AA
		tya				;33C6 98
		asl A			;33C7 0A
		asl A			;33C8 0A
		asl A			;33C9 0A
		asl A			;33CA 0A
		tay				;33CB A8
		lda #$10		;33CC A9 10
		sta ZP_14		;33CE 85 14
.L_33D0	lda CIA1_CIAPRA,Y	;33D0 B9 00 DC			; CIA1
		sta L_AE00,X	;33D3 9D 00 AE
		inx				;33D6 E8
		iny				;33D7 C8
		dec ZP_14		;33D8 C6 14
		bne L_33D0		;33DA D0 F4
		ldx ZP_15		;33DC A6 15
		dex				;33DE CA
		bpl L_3398		;33DF 10 B7
		jsr page_in_IO_and_enable_ints		;33E1 20 FC 33
		ldx L_31A1		;33E4 AE A1 31
		inx				;33E7 E8
.L_33E8	stx L_31A3		;33E8 8E A3 31
		lda #$00		;33EB A9 00
		sta L_31A6		;33ED 8D A6 31
		rts				;33F0 60
}

.disable_ints_and_page_in_RAM
{
		lda #$00		;33F1 A9 00
		sta VIC_IRQMASK		;33F3 8D 1A D0
		sei				;33F6 78
		lda #$34		;33F7 A9 34
		sta RAM_SELECT		;33F9 85 01
		rts				;33FB 60
}

.page_in_IO_and_enable_ints
{
		lda #$35		;33FC A9 35
		sta RAM_SELECT		;33FE 85 01
		cli				;3400 58
		lda #$01		;3401 A9 01
		sta VIC_IRQMASK		;3403 8D 1A D0
		rts				;3406 60
}

; FRONTEND STRINGS

.frontend_strings_4
		equb $1F,$0F
.L_3409	equb $09,"DIVISION ",$FF
		equb $1F,$0F
.L_3416	equb $0D,"RACE  ",$FF
		equb $1F,$06,$0B,"Track:  ",$FF
		equb "The ",$FF
		equb " V ",$FF
		equb $1F,$03,$18
		equb "steer to rotate view or fire to continue",$FF
		equb $1F
.L_3460	equb $0F,$15,"The ",$FF
		equb $1F,$11,$12,"RESULT",$FF
		equb "Race Winner: ",$FF
		equb "Fastest Lap: ",$FF
		equb $1F,$0E,$0B
		equb "RESULTS TABLE"
		equb $1F,$06,$0E
		equb "DRIVER     RACED WIN LAP  PTS",$FF
		equb "Promotion for  ",$FF
		equb "Relegation for ",$FF
		equb " CHANGES",$FF
		equb $1F,$12,$0E,"NAME?",$FF
		equb " 2pts",$FF," 1pt",$FF," of ",$FF
		
.L_3500
{
		jsr L_3FBE_with_VIC		;3500 20 BE 3F	; does VIC stuff
		rts				;3503 60
}

.set_up_screen_for_frontend
{
		lda #$00		;3504 A9 00
		jsr L_3FBB_with_VIC		;3506 20 BB 3F
		jsr draw_menu_header		;3509 20 49 1C
		lda #$01		;350C A9 01
		jsr sysctl		;350E 20 25 87
		lda #$41		;3511 A9 41
		sta L_3DF8		;3513 8D F8 3D
		jsr L_39F1		;3516 20 F1 39
		jsr set_up_screen_for_menu		;3519 20 1F 35
		jmp ensure_screen_enabled		;351C 4C 9E 3F
}

.set_up_screen_for_menu
{
		lda L_C718		;351F AD 18 C7
		sta L_C360		;3522 8D 60 C3
		jsr clear_menu_area		;3525 20 23 1C
		jsr menu_colour_map_stuff		;3528 20 C4 38
		ldx #$0C		;352B A2 0C
		ldy #$0B		;352D A0 0B
		jsr get_colour_map_ptr		;352F 20 FA 38
		ldx #$12		;3532 A2 12
		lda #$01		;3534 A9 01
		jsr fill_colourmap_solid		;3536 20 16 39
		ldx #$04		;3539 A2 04
		ldy #$09		;353B A0 09
		jsr get_colour_map_ptr		;353D 20 FA 38
		ldx #$0A		;3540 A2 0A
		lda #$02		;3542 A9 02
		jsr fill_colourmap_solid		;3544 20 16 39
		lda L_31A0		;3547 AD A0 31
		beq L_354D		;354A F0 01
		rts				;354C 60
}

.L_354D	lda L_31A1		;354D AD A1 31
		bne L_3575		;3550 D0 23
		ldy #$09		;3552 A0 09

.print_division_type
		lda L_C71A		;3554 AD 1A C7
		beq L_3564		;3557 F0 0B
		sty L_E0BD		;3559 8C BD E0
		ldx #$BB		;355C A2 BB
		jsr print_msg_2		;355E 20 CB A1
		jmp L_356C		;3561 4C 6C 35
.L_3564	sty L_3409		;3564 8C 09 34
		ldx #$00		;3567 A2 00
		jsr print_msg_4		;3569 20 27 30
.L_356C	lda #$04		;356C A9 04
		sec				;356E 38
		sbc L_C360		;356F ED 60 C3
		jmp print_single_digit		;3572 4C 8A 10
.L_3575	ldx #$A0		;3575 A2 A0
		jmp print_msg_3		;3577 4C DC A1
.L_357A	lda #$80		;357A A9 80
		bne L_3580		;357C D0 02
\\
.L_357E
		lda #$00		;357E A9 00
.L_3580	sta L_C372		;3580 8D 72 C3
		jsr set_up_screen_for_menu		;3583 20 1F 35
		lda L_C360		;3586 AD 60 C3
		asl A			;3589 0A
		sta ZP_14		;358A 85 14
		lda L_C77F		;358C AD 7F C7
		ldx L_31A1		;358F AE A1 31
		beq L_3599		;3592 F0 05
		lda L_31A2		;3594 AD A2 31
		eor #$01		;3597 49 01
.L_3599	and #$01		;3599 29 01
		clc				;359B 18
		adc ZP_14		;359C 65 14
		jsr select_track		;359E 20 2F 30
		ldy #$0B		;35A1 A0 0B
		jsr L_3170		;35A3 20 70 31
		lda L_C305		;35A6 AD 05 C3
		and #$01		;35A9 29 01
		bne L_35E6		;35AB D0 39
		ldx #$0E		;35AD A2 0E
		bit L_C372		;35AF 2C 72 C3
		bpl L_35B5		;35B2 10 01
		dex				;35B4 CA
.L_35B5	stx L_3416		;35B5 8E 16 34
		ldx #$0D		;35B8 A2 0D
		jsr print_msg_4		;35BA 20 27 30
		lda L_31A6		;35BD AD A6 31
		clc				;35C0 18
		adc #$01		;35C1 69 01
		jsr print_number_unpadded		;35C3 20 41 33
		ldx #$F4		;35C6 A2 F4
		jsr print_msg_4		;35C8 20 27 30
		lda L_31A3		;35CB AD A3 31
		ldx L_31A1		;35CE AE A1 31
		beq L_35D4		;35D1 F0 01
		asl A			;35D3 0A
.L_35D4	jsr print_number_unpadded		;35D4 20 41 33
		bit L_C372		;35D7 2C 72 C3
		bmi L_35EC		;35DA 30 10
		lda #$06		;35DC A9 06
		jsr L_3738		;35DE 20 38 37
		lda #$80		;35E1 A9 80
		jsr L_9319		;35E3 20 19 93
.L_35E6	jsr L_9225		;35E6 20 25 92
		jmp L_361C		;35E9 4C 1C 36
.L_35EC	lda #$07		;35EC A9 07
		jsr L_3738		;35EE 20 38 37
		ldx #$60		;35F1 A2 60
		jsr print_msg_4		;35F3 20 27 30
		jsr L_3858		;35F6 20 58 38
		ldx #$6A		;35F9 A2 6A
		jsr print_msg_4		;35FB 20 27 30
		ldx L_C76F		;35FE AE 6F C7
		jsr print_driver_name		;3601 20 8B 38
		ldx #$E9		;3604 A2 E9
		jsr print_msg_4		;3606 20 27 30
		jsr L_3858		;3609 20 58 38
		ldx #$78		;360C A2 78
		jsr print_msg_4		;360E 20 27 30
		ldx L_C770		;3611 AE 70 C7
		jsr print_driver_name		;3614 20 8B 38
		ldx #$EF		;3617 A2 EF
		jsr print_msg_4		;3619 20 27 30
.L_361C	jsr debounce_fire_and_wait_for_fire		;361C 20 96 36
\\
.L_361F
{
		ldx #$00		;361F A2 00
		lda #$20		;3621 A9 20
		jmp sysctl		;3623 4C 25 87
}

.L_3626
{
		jsr L_E8C2		;3626 20 C2 E8
		lda ZP_50		;3629 A5 50
		sta ZP_C7		;362B 85 C7
		lda L_31A1		;362D AD A1 31
		beq L_3638		;3630 F0 06
		jsr L_3092		;3632 20 92 30
		jmp L_361C		;3635 4C 1C 36
.L_3638	jsr set_up_screen_for_menu		;3638 20 1F 35
		ldx #$86		;363B A2 86
		jsr print_msg_4		;363D 20 27 30
		lda #$01		;3640 A9 01
		sta ZP_19		;3642 85 19
.L_3644	jsr L_3858		;3644 20 58 38
		jsr L_364F		;3647 20 4F 36
		bne L_3644		;364A D0 F8
		jmp L_361C		;364C 4C 1C 36
}

.L_364F
{
		ldy ZP_C7		;364F A4 C7
		ldx L_C758,Y	;3651 BE 58 C7
		stx ZP_C6		;3654 86 C6
		jsr print_driver_name		;3656 20 8B 38
		jsr print_space		;3659 20 AF 91
		ldx ZP_C6		;365C A6 C6
		lda L_C39C		;365E AD 9C C3
		bpl L_3674		;3661 10 11
		jsr L_99FF		;3663 20 FF 99
		jsr print_2space		;3666 20 AA 91
		txa				;3669 8A
		clc				;366A 18
		adc #$0C		;366B 69 0C
		tax				;366D AA
		jsr L_99FF		;366E 20 FF 99
		jmp L_368F		;3671 4C 8F 36
.L_3674	lda L_C740,X	;3674 BD 40 C7
		jsr print_number_pad2		;3677 20 45 33
		lda L_C728,X	;367A BD 28 C7
		jsr print_number_pad4		;367D 20 39 33
		lda L_C734,X	;3680 BD 34 C7
		jsr print_number_pad4		;3683 20 39 33
		jsr print_3space		;3686 20 A5 91
		lda L_C74C,X	;3689 BD 4C C7
		jsr print_number_pad2		;368C 20 45 33
.L_368F	inc ZP_C7		;368F E6 C7
		lda ZP_C7		;3691 A5 C7
		cmp ZP_8A		;3693 C5 8A
		rts				;3695 60
}

.debounce_fire_and_wait_for_fire
{
		jsr check_game_keys		;3696 20 9E F7
		and #$10		;3699 29 10
		bne debounce_fire_and_wait_for_fire		;369B D0 F9
		ldy #$05		;369D A0 05
		jsr delay_approx_Y_25ths_sec		;369F 20 EB 3F
.L_36A2	jsr check_game_keys		;36A2 20 9E F7
		and #$10		;36A5 29 10
		beq L_36A2		;36A7 F0 F9
		rts				;36A9 60
}

.L_36AA	jmp L_3626		;36AA 4C 26 36

.L_36AD
{
		lda L_31A1		;36AD AD A1 31
		bne L_36AA		;36B0 D0 F8
		lda #$80		;36B2 A9 80
		sta L_C356		;36B4 8D 56 C3
		jsr clear_menu_area		;36B7 20 23 1C
		jsr menu_colour_map_stuff		;36BA 20 C4 38
		lda #$03		;36BD A9 03
		sta L_C360		;36BF 8D 60 C3
		lda #$0A		;36C2 A9 0A
		sta ZP_19		;36C4 85 19
		lda #$09		;36C6 A9 09
		sta ZP_1A		;36C8 85 1A
		lda #$00		;36CA A9 00
		sta ZP_17		;36CC 85 17
.L_36CE	ldy ZP_1A		;36CE A4 1A
		jsr print_division_type		;36D0 20 54 35
		inc ZP_1A		;36D3 E6 1A
		lda #$00		;36D5 A9 00
		sta ZP_08		;36D7 85 08
.L_36D9	ldy #$06		;36D9 A0 06
		cmp #$02		;36DB C9 02
		bne L_36E1		;36DD D0 02
		ldy #$15		;36DF A0 15
.L_36E1	tya				;36E1 98
		tax				;36E2 AA
		ldy ZP_1A		;36E3 A4 1A
		jsr set_text_cursor		;36E5 20 6B 10
		lda ZP_08		;36E8 A5 08
		cmp #$02		;36EA C9 02
		beq L_3703		;36EC F0 15
		lda L_C360		;36EE AD 60 C3
		asl A			;36F1 0A
		ora ZP_08		;36F2 05 08
		eor #$01		;36F4 49 01
		tay				;36F6 A8
		jsr L_3884		;36F7 20 84 38
		ldx track_order,Y	;36FA BE 28 37
		jsr print_track_name		;36FD 20 92 38
		jsr L_361F		;3700 20 1F 36
.L_3703	ldy ZP_17		;3703 A4 17
		ldx L_C70C,Y	;3705 BE 0C C7
		jsr print_driver_name		;3708 20 8B 38
		inc ZP_1A		;370B E6 1A
		inc ZP_17		;370D E6 17
		inc ZP_08		;370F E6 08
		lda ZP_08		;3711 A5 08
		cmp #$03		;3713 C9 03
		bne L_36D9		;3715 D0 C2
		jsr L_3854		;3717 20 54 38
		jsr L_361F		;371A 20 1F 36
		dec L_C360		;371D CE 60 C3
		bpl L_36CE		;3720 10 AC
		asl L_C356		;3722 0E 56 C3
		jmp L_361C		;3725 4C 1C 36
}

.track_order				equb $00,$02,$01,$03,$06,$07,$04,$05
.track_background_colours	equb $08,$05,$0C,$05,$05,$08,$0C,$08

.L_3738
{
		sta ZP_19		;3738 85 19
		jsr L_E8E5		;373A 20 E5 E8
		jsr L_3858		;373D 20 58 38
		ldx L_C771		;3740 AE 71 C7
		jsr print_driver_name		;3743 20 8B 38
		ldx #$28		;3746 A2 28
		jsr print_msg_4		;3748 20 27 30
		ldx L_C772		;374B AE 72 C7
		jsr print_driver_name		;374E 20 8B 38
		jmp L_361F		;3751 4C 1F 36
}

.L_3754
{
		jsr set_up_screen_for_menu		;3754 20 1F 35
		jsr L_375D		;3757 20 5D 37
		jmp L_361C		;375A 4C 1C 36
.L_375D
		ldx #$0B		;375D A2 0B
.L_375F	lda L_C758,X	;375F BD 58 C7
		sta L_C70C,X	;3762 9D 0C C7
		dex				;3765 CA
		bpl L_375F		;3766 10 F7
		jsr L_E8C2		;3768 20 C2 E8
		ldx #$0F		;376B A2 0F
		ldy #$0C		;376D A0 0C
		jsr set_text_cursor		;376F 20 6B 10
		ldx #$D7		;3772 A2 D7
		jsr print_msg_4		;3774 20 27 30
		lda #$01		;3777 A9 01
		sta ZP_19		;3779 85 19
		ldy ZP_50		;377B A4 50
		bne L_3797		;377D D0 18
		lda L_C758		;377F AD 58 C7
		cmp L_31A4		;3782 CD A4 31
		bne L_37B6		;3785 D0 2F
		lda L_C71A		;3787 AD 1A C7
		beq L_3797		;378A F0 0B
		jsr L_3858		;378C 20 58 38
		ldx #$CE		;378F A2 CE
		jsr print_msg_2		;3791 20 CB A1
		jmp L_37CE		;3794 4C CE 37
.L_3797	jsr L_3858		;3797 20 58 38
		ldx #$B7		;379A A2 B7
		jsr print_msg_4		;379C 20 27 30
		ldy ZP_50		;379F A4 50
		ldx L_C758,Y	;37A1 BE 58 C7
		jsr print_driver_name		;37A4 20 8B 38
		ldy ZP_50		;37A7 A4 50
		bne L_37B6		;37A9 D0 0B
		jsr L_3858		;37AB 20 58 38
		ldx #$A7		;37AE A2 A7
		jsr print_msg_2		;37B0 20 CB A1
		jmp L_37CE		;37B3 4C CE 37
.L_37B6	ldy ZP_8A		;37B6 A4 8A
		dey				;37B8 88
		cpy #$0B		;37B9 C0 0B
		beq L_37CE		;37BB F0 11
		jsr L_3858		;37BD 20 58 38
		ldx #$C7		;37C0 A2 C7
		jsr print_msg_4		;37C2 20 27 30
		ldy ZP_8A		;37C5 A4 8A
		dey				;37C7 88
		ldx L_C758,Y	;37C8 BE 58 C7
		jsr print_driver_name		;37CB 20 8B 38
.L_37CE	lda #$02		;37CE A9 02
		sta L_C360		;37D0 8D 60 C3
.L_37D3	jsr L_E8C2		;37D3 20 C2 E8
		ldy ZP_50		;37D6 A4 50
		ldx L_C70C,Y	;37D8 BE 0C C7
		lda L_C70B,Y	;37DB B9 0B C7
		sta L_C70C,Y	;37DE 99 0C C7
		txa				;37E1 8A
		sta L_C70B,Y	;37E2 99 0B C7
		dec L_C360		;37E5 CE 60 C3
		bpl L_37D3		;37E8 10 E9
		lda L_31A4		;37EA AD A4 31
		cmp L_C758		;37ED CD 58 C7
		bne L_3807		;37F0 D0 15
		ldx L_C71A		;37F2 AE 1A C7
		bne L_3813		;37F5 D0 1C
		sta L_C71A		;37F7 8D 1A C7
		ldx #$0B		;37FA A2 0B
.L_37FC	txa				;37FC 8A
		sta L_C70C,X	;37FD 9D 0C C7
		dex				;3800 CA
		bpl L_37FC		;3801 10 F9
		lda #$00		;3803 A9 00
		beq L_380D		;3805 F0 06
.L_3807	jsr L_3829		;3807 20 29 38
		lda L_381D,X	;380A BD 1D 38
.L_380D	sta L_C718		;380D 8D 18 C7
		beq L_3813		;3810 F0 01
		rts				;3812 60
.L_3813	lda #$06		;3813 A9 06
		asl A			;3815 0A
		sec				;3816 38
		sbc #$02		;3817 E9 02
		sta L_C719		;3819 8D 19 C7
		rts				;381C 60

.L_381D	equb $03,$03,$03,$02,$02,$02,$01,$01,$01,$00,$00,$00
}

.L_3829
{
		ldx #$0B		;3829 A2 0B
.L_382B	cmp L_C70C,X	;382B DD 0C C7
		beq L_3833		;382E F0 03
		dex				;3830 CA
		bpl L_382B		;3831 10 F8
.L_3833	rts				;3833 60
}

.L_3834	equb $06,$04,$00
.L_3837	equb $0D,$10,$13,$16,$10,$13,$10,$0F,$14,$17,$0A,$0E,$12,$16
.L_3845	equb $0E,$0B,$11

.L_3848	ldx #$04		;3848 A2 04
		jsr get_colour_map_ptr		;384A 20 FA 38
		ldx #$0E		;384D A2 0E
		lda #$01		;384F A9 01
		jmp fill_colourmap_solid		;3851 4C 16 39

.L_3854	lda #$03		;3854 A9 03
		bne highlight_current_menu_item		;3856 D0 02

.L_3858	lda #$02		;3858 A9 02

.highlight_current_menu_item
{
		sta ZP_73		;385A 85 73
		ldx ZP_19		;385C A6 19
		ldy L_3837,X	;385E BC 37 38
		sty ZP_74		;3861 84 74
		sty ZP_7A		;3863 84 7A
		jsr L_3A42		;3865 20 42 3A
.L_3868	ldy ZP_74		;3868 A4 74
		jsr L_3848		;386A 20 48 38
		inc ZP_74		;386D E6 74
		dec ZP_73		;386F C6 73
		bne L_3868		;3871 D0 F5
		bit L_C356		;3873 2C 56 C3
		bmi L_387B		;3876 30 03
		jsr L_3A42		;3878 20 42 3A
}
\\ Fall through
.L_387B	ldx #$05		;387B A2 05
		ldy ZP_7A		;387D A4 7A
		jsr set_text_cursor		;387F 20 6B 10
		inc ZP_19		;3882 E6 19
\\ Fall through
.L_3884	ldx #$80		;3884 A2 80
		lda #$20		;3886 A9 20
		jmp sysctl		;3888 4C 25 87

.print_driver_name
{
		lda #$AE		;388B A9 AE
		ldy #$0D		;388D A0 0D
		jmp print_name		;388F 4C 96 38
}

.print_track_name
		lda #$AF		;3892 A9 AF
		ldy #$0F		;3894 A0 0F
.print_name
{
		sta ZP_1F		;3896 85 1F
		sty ZP_14		;3898 84 14
		txa				;389A 8A
		asl A			;389B 0A
		asl A			;389C 0A
		asl A			;389D 0A
		asl A			;389E 0A
		sta ZP_1E		;389F 85 1E
		lda ZP_1F		;38A1 A5 1F
		adc #$00		;38A3 69 00
		sta ZP_1F		;38A5 85 1F
		ldy #$00		;38A7 A0 00
.L_38A9	lda (ZP_1E),Y	;38A9 B1 1E
		jsr write_char		;38AB 20 6F 84
		iny				;38AE C8
		cpy ZP_14		;38AF C4 14
		bne L_38A9		;38B1 D0 F6
		rts				;38B3 60
}

.L_38B4	equb $FE,$FD,$FB,$F7,$EF,$DF,$BF,$7F
.L_38BC	equb $01,$02,$04,$08,$10,$20,$40,$80

.menu_colour_map_stuff
{
		ldx #$00		;38C4 A2 00
		ldy #$08		;38C6 A0 08
		jsr get_colour_map_ptr		;38C8 20 FA 38
		lda #$11		;38CB A9 11
		sta ZP_A0		;38CD 85 A0
.L_38CF	ldx #$00		;38CF A2 00
		lda ZP_A0		;38D1 A5 A0
		cmp #$09		;38D3 C9 09
		bcs L_38D9		;38D5 B0 02
		ldx #$0E		;38D7 A2 0E
.L_38D9	jsr fill_colourmap_varying		;38D9 20 32 39
		ldx #$08		;38DC A2 08
		lda #$01		;38DE A9 01
		jsr fill_colourmap_solid		;38E0 20 16 39
		ldx #$05		;38E3 A2 05
		jsr fill_colourmap_varying		;38E5 20 32 39
		dec ZP_A0		;38E8 C6 A0
		bne L_38CF		;38EA D0 E3
		ldx #$04		;38EC A2 04
		ldy #$08		;38EE A0 08
		jsr get_colour_map_ptr		;38F0 20 FA 38
		ldx #$10		;38F3 A2 10
		lda #$01		;38F5 A9 01
		jmp fill_colourmap_solid		;38F7 4C 16 39
}

.get_colour_map_ptr
{
		stx ZP_C6		;38FA 86 C6
		tya				;38FC 98
		sta ZP_1E		;38FD 85 1E
		asl A			;38FF 0A
		asl A			;3900 0A
		clc				;3901 18
		adc ZP_1E		;3902 65 1E
		asl A			;3904 0A
		asl A			;3905 0A
		sta ZP_1E		;3906 85 1E
		lda #$00		;3908 A9 00
		rol A			;390A 2A
		asl ZP_1E		;390B 06 1E
		rol A			;390D 2A
		clc				;390E 18
		adc #$7C		;390F 69 7C
		sta ZP_1F		;3911 85 1F
		ldy ZP_C6		;3913 A4 C6
		rts				;3915 60
}

.fill_colourmap_solid
{
		sta ZP_15		;3916 85 15
.L_3918	lda L_3944,X	;3918 BD 44 39
		sta ZP_14		;391B 85 14
		inx				;391D E8
		lda L_3944,X	;391E BD 44 39
		inx				;3921 E8
.L_3922	sta (ZP_1E),Y	;3922 91 1E
		iny				;3924 C8
		bne L_3929		;3925 D0 02
		inc ZP_1F		;3927 E6 1F
.L_3929	dec ZP_14		;3929 C6 14
		bne L_3922		;392B D0 F5
		dec ZP_15		;392D C6 15
		bne L_3918		;392F D0 E7
		rts				;3931 60
}

.fill_colourmap_varying
{
		lda L_397A,X	;3932 BD 7A 39
		sta ZP_14		;3935 85 14
		inx				;3937 E8
.L_3938	lda L_397A,X	;3938 BD 7A 39
		sta (ZP_1E),Y	;393B 91 1E
		iny				;393D C8
		inx				;393E E8
		dec ZP_14		;393F C6 14
		bne L_3938		;3941 D0 F5
		rts				;3943 60
}

; Used by colourmap functions above
.L_3944	equb $F0,$1E,$02,$1E,$20,$79,$06,$98,$1C,$18,$0E,$28,$0E,$28,$1C
.L_3953	equb $0F,$1C,$08,$14,$78,$14,$28,$0C,$78,$36,$06,$0B,$07,$45,$06,$0B
		equb $16,$5F,$06,$28,$63,$28,$06,$02,$0D,$01,$06,$0B,$0A,$07,$0F,$01
		equb $06,$0B,$0A,$07,$0F,$50,$06
.L_397A	equb $04,$AE,$AE,$90,$89,$08,$90,$89,$89,$90,$89,$90,$89,$89,$04,$A5
		equb $A5,$90,$89		

.L_398D
{
		lda #$01		;398D A9 01
		sta ZP_17		;398F 85 17
.L_3991	ldy #$F7		;3991 A0 F7
.L_3993	jsr rndQ		;3993 20 B9 29
		lsr A			;3996 4A
		ror ZP_16		;3997 66 16
		and #$07		;3999 29 07
		clc				;399B 18
		adc #$04		;399C 69 04
		sta ZP_14		;399E 85 14
		jmp L_39BE		;39A0 4C BE 39
.L_39A3	bit ZP_16		;39A3 24 16
		bpl L_39AE		;39A5 10 07
		lda (ZP_1E),Y	;39A7 B1 1E
		ora ZP_18		;39A9 05 18
		jmp L_39B6		;39AB 4C B6 39
.L_39AE	lda (ZP_1E),Y	;39AE B1 1E
		ora ZP_17		;39B0 05 17
		ora ZP_18		;39B2 05 18
		and ZP_19		;39B4 25 19
.L_39B6	sta (ZP_1E),Y	;39B6 91 1E
		tya				;39B8 98
		dey				;39B9 88
		and #$07		;39BA 29 07
		bne L_39C1		;39BC D0 03
.L_39BE	jsr L_39D1		;39BE 20 D1 39
.L_39C1	cpy #$70		;39C1 C0 70
		bcc L_39CC		;39C3 90 07
		dec ZP_14		;39C5 C6 14
		bpl L_39A3		;39C7 10 DA
		jmp L_3993		;39C9 4C 93 39
.L_39CC	asl ZP_17		;39CC 06 17
		bne L_3991		;39CE D0 C1
		rts				;39D0 60
}

.L_39D1
{
		txa				;39D1 8A
		sec				;39D2 38
		sbc #$40		;39D3 E9 40
		and #$7C		;39D5 29 7C
		asl A			;39D7 0A
		adc Q_pointers_LO,Y	;39D8 79 00 A5
		sta ZP_1E		;39DB 85 1E
		lda Q_pointers_HI,Y	;39DD B9 00 A6
		adc #$00		;39E0 69 00
		sta ZP_1F		;39E2 85 1F
		cpx #$40		;39E4 E0 40
		bcs L_39EA		;39E6 B0 02
		dec ZP_1F		;39E8 C6 1F
.L_39EA	cpx #$C0		;39EA E0 C0
		bcc L_39F0		;39EC 90 02
		inc ZP_1F		;39EE E6 1F
.L_39F0	rts				;39F0 60
}

.L_39F1
{
		jsr save_rndQ_stateQ		;39F1 20 2C 16
		ldy #$04		;39F4 A0 04
		jsr L_1637		;39F6 20 37 16
		lda #$09		;39F9 A9 09
		sta ZP_1A		;39FB 85 1A
.L_39FD	ldy ZP_1A		;39FD A4 1A
		ldx L_3A1E,Y	;39FF BE 1E 3A
		lda L_3A28,Y	;3A02 B9 28 3A
		sta ZP_19		;3A05 85 19
		lda L_3A32,Y	;3A07 B9 32 3A
		sta ZP_18		;3A0A 85 18
		jsr L_398D		;3A0C 20 8D 39
		dec ZP_1A		;3A0F C6 1A
		bpl L_39FD		;3A11 10 EA
		ldy #$70		;3A13 A0 70
		jsr L_3A4B		;3A15 20 4B 3A
		ldy #$09		;3A18 A0 09
		jsr L_1637		;3A1A 20 37 16
		rts				;3A1D 60
		
.L_3A1E	equb $38,$3C,$B0,$B4,$B8,$BC,$C0,$C4,$C8,$CC
.L_3A28	equb $7F,$FE,$7F,$FF,$80,$DF,$FE,$EF,$F8,$3F
.L_3A32	equb $00,$00,$00,$00,$80,$C0,$02,$E0,$08,$10
}

.L_3A3C
		sta ZP_14		;3A3C 85 14
		lda #$AA		;3A3E A9 AA
		bne L_3A53		;3A40 D0 11
\\
.L_3A42	lda ZP_74		;3A42 A5 74
		asl A			;3A44 0A
		asl A			;3A45 0A
		asl A			;3A46 0A
		clc				;3A47 18
		adc #$2F		;3A48 69 2F
		tay				;3A4A A8
\\
.L_3A4B	ldx #$40		;3A4B A2 40
		lda #$1C		;3A4D A9 1C
\\
.L_3A4F	sta ZP_14		;3A4F 85 14
		lda #$FF		;3A51 A9 FF
.L_3A53	sta ZP_16		;3A53 85 16
.L_3A55	jsr L_39D1		;3A55 20 D1 39
		lda ZP_16		;3A58 A5 16
		sta (ZP_1E),Y	;3A5A 91 1E
		txa				;3A5C 8A
		clc				;3A5D 18
		adc #$04		;3A5E 69 04
		tax				;3A60 AA
		dec ZP_14		;3A61 C6 14
		bne L_3A55		;3A63 D0 F0
		rts				;3A65 60

.L_3A66
{
		sta ZP_14		;3A66 85 14
.L_3A68	jsr L_39D1		;3A68 20 D1 39
		lda (ZP_1E),Y	;3A6B B1 1E
		ora ZP_15		;3A6D 05 15
		sta (ZP_1E),Y	;3A6F 91 1E
		dey				;3A71 88
		dec ZP_14		;3A72 C6 14
		bne L_3A68		;3A74 D0 F2
		rts				;3A76 60
}

.set_up_colour_map_for_track_preview
{
		lda L_C76B		;3A77 AD 6B C7
		sta L_3AEE		;3A7A 8D EE 3A
		sta L_3AF2		;3A7D 8D F2 3A
		ldx #$00		;3A80 A2 00
		ldy #$00		;3A82 A0 00
		jsr get_colour_map_ptr		;3A84 20 FA 38
		ldx #$00		;3A87 A2 00
		ldy #$00		;3A89 A0 00
.L_3A8B	lda L_3AD9,X	;3A8B BD D9 3A
		cmp #$C8		;3A8E C9 C8
		bcs L_3A98		;3A90 B0 06
		jsr L_3AC3		;3A92 20 C3 3A
		jmp L_3A8B		;3A95 4C 8B 3A
.L_3A98	cmp #$FF		;3A98 C9 FF
		bne L_3AA5		;3A9A D0 09
		lda #$0E		;3A9C A9 0E
		sta L_7C53		;3A9E 8D 53 7C
		sta L_7C74		;3AA1 8D 74 7C
		rts				;3AA4 60
.L_3AA5	sec				;3AA5 38
		sbc #$C8		;3AA6 E9 C8
		sta ZP_A0		;3AA8 85 A0
		inx				;3AAA E8
		stx ZP_50		;3AAB 86 50
.L_3AAD	ldx ZP_50		;3AAD A6 50
		lda L_3AD9,X	;3AAF BD D9 3A
		inx				;3AB2 E8
		sta ZP_52		;3AB3 85 52
.L_3AB5	jsr L_3AC3		;3AB5 20 C3 3A
		dec ZP_52		;3AB8 C6 52
		bne L_3AB5		;3ABA D0 F9
		dec ZP_A0		;3ABC C6 A0
		bne L_3AAD		;3ABE D0 ED
		jmp L_3A8B		;3AC0 4C 8B 3A
.L_3AC3	lda L_3AD9,X	;3AC3 BD D9 3A
		inx				;3AC6 E8
		sta ZP_51		;3AC7 85 51
		lda L_3AD9,X	;3AC9 BD D9 3A
		inx				;3ACC E8
.L_3ACD	sta (ZP_1E),Y	;3ACD 91 1E
		iny				;3ACF C8
		bne L_3AD4		;3AD0 D0 02
		inc ZP_1F		;3AD2 E6 1F
.L_3AD4	dec ZP_51		;3AD4 C6 51
		bne L_3ACD		;3AD6 D0 F5
		rts				;3AD8 60

.L_3AD9	equb $01,$BB,$26,$CB,$02,$BB,$01,$CB,$24,$1F,$D8,$08,$01,$CB,$02,$BB
		equb $01,$CB,$01,$1F,$01
.L_3AEE	equb $05,$20,$1E,$01
.L_3AF2	equb $05,$01,$1F,$01,$CB,$02,$BB,$01,$CB,$24,$1F,$01,$CB,$02,$BB,$26
		equb $CB,$0A,$BB,$01,$FB,$14,$1B,$01,$FB,$CA,$04,$12,$BB,$01,$FB,$14
		equb $10,$01,$FB,$12,$BB,$01,$FB,$14,$CB,$01,$FB,$09,$BB,$28,$BB,$FF
}

; *****************************************************************************
; GAME START
; *****************************************************************************

.game_start				; aka L_3B22
{
		ldx #$FF		;3B22 A2 FF
		txs				;3B24 9A
		jsr disable_ints_and_page_in_RAM		;3B25 20 F1 33

		ldx #$00		;3B28 A2 00
.L_3B2A	lda CIA1_CIAPRA,X	;3B2A BD 00 DC		; CIA1
		sta L_AE00,X	;3B2D 9D 00 AE
		inx				;3B30 E8
		bne L_3B2A		;3B31 D0 F7

		jsr page_in_IO_and_enable_ints		;3B33 20 FC 33
		jsr L_E85B		;3B36 20 5B E8
		jsr set_up_screen_for_frontend		;3B39 20 04 35
		jsr do_initial_screen		;3B3C 20 52 30
		jsr L_36AD		;3B3F 20 AD 36
		jsr save_rndQ_stateQ		;3B42 20 2C 16

.L_3B45	lsr L_C304		;3B45 4E 04 C3
		jsr do_main_menu_dwim		;3B48 20 3A EF
		lda L_C76C		;3B4B AD 6C C7
		bmi L_3B69		;3B4E 30 19	     ; taken if	racing

		jsr L_3C36		;3B50 20 36 3C
		jsr L_3500		;3B53 20 00 35
		jsr game_main_loop		;3B56 20 99 3C
		jsr set_up_screen_for_frontend		;3B59 20 04 35
		jmp L_3B45		;3B5C 4C 45 3B

.L_3B5F	lda #$C0		;3B5F A9 C0
		sta L_C304		;3B61 8D 04 C3
		sta L_C362		;3B64 8D 62 C3
		bne L_3B85		;3B67 D0 1C

.L_3B69	jsr L_3389		;3B69 20 89 33

.L_3B6C	ldx #$17		;3B6C A2 17
.L_3B6E	jsr L_1090		;3B6E 20 90 10
		cpx #$10		;3B71 E0 10
		bcs L_3B7A		;3B73 B0 05
		lda #$09		;3B75 A9 09
		sta L_8398,X	;3B77 9D 98 83

.L_3B7A	dex				;3B7A CA
		bpl L_3B6E		;3B7B 10 F1
		lda #$00		;3B7D A9 00
		sta L_C76D		;3B7F 8D 6D C7
		sta L_C76E		;3B82 8D 6E C7

.L_3B85	lda L_C718		;3B85 AD 18 C7
		sta L_C360		;3B88 8D 60 C3
		jsr L_E8E5		;3B8B 20 E5 E8
		bit L_C304		;3B8E 2C 04 C3
		bmi L_3BA7		;3B91 30 14

		ldy L_C772		;3B93 AC 72 C7
		lda L_C771		;3B96 AD 71 C7
		cmp L_31A4		;3B99 CD A4 31
		beq L_3BAD		;3B9C F0 0F
		cpy L_31A4		;3B9E CC A4 31
		bne L_3BA7		;3BA1 D0 04
		tay				;3BA3 A8
		jmp L_3BAD		;3BA4 4C AD 3B

.L_3BA7	jsr L_E87F		;3BA7 20 7F E8
		jmp L_3BF8		;3BAA 4C F8 3B

.L_3BAD	sty L_C773		;3BAD 8C 73 C7
		lda #$C0		;3BB0 A9 C0
		sta L_C305		;3BB2 8D 05 C3
		jsr L_357E		;3BB5 20 7E 35
		ldx #$20		;3BB8 A2 20
		jsr poll_key_with_sysctl		;3BBA 20 C9 C7
		beq L_3B5F		;3BBD F0 A0
		jsr L_3C36		;3BBF 20 36 3C
		jsr L_3500		;3BC2 20 00 35
		lda #$80		;3BC5 A9 80
		jsr store_restore_control_keys		;3BC7 20 46 98
		jsr game_main_loop		;3BCA 20 99 3C
		lda #$00		;3BCD A9 00
		jsr store_restore_control_keys		;3BCF 20 46 98
		lda #$00		;3BD2 A9 00
		jsr L_9319		;3BD4 20 19 93
		jsr L_E87F		;3BD7 20 7F E8
		jsr set_up_screen_for_frontend		;3BDA 20 04 35
		lda L_C305		;3BDD AD 05 C3
		beq L_3BEA		;3BE0 F0 08
		jsr L_357E		;3BE2 20 7E 35
		lda #$00		;3BE5 A9 00
		sta L_C305		;3BE7 8D 05 C3

.L_3BEA	jsr L_357A		;3BEA 20 7A 35
		jsr L_3626		;3BED 20 26 36
		lda L_31A1		;3BF0 AD A1 31
		beq L_3BF8		;3BF3 F0 03
		jsr L_91C3		;3BF5 20 C3 91

.L_3BF8	inc L_31A6		;3BF8 EE A6 31
		inc L_C77F		;3BFB EE 7F C7
		lda L_C77F		;3BFE AD 7F C7
		cmp L_31A3		;3C01 CD A3 31
		bcs L_3C09		;3C04 B0 03
		jmp L_3B85		;3C06 4C 85 3B

.L_3C09	lda #$00		;3C09 A9 00
		sta L_C77F		;3C0B 8D 7F C7
		lda L_31A1		;3C0E AD A1 31
		bne L_3C1F		;3C11 D0 0C
		jsr L_3754		;3C13 20 54 37
		jsr L_36AD		;3C16 20 AD 36

.L_3C19	jsr L_1611		;3C19 20 11 16
.L_3C1C	jmp L_3B45		;3C1C 4C 45 3B

.L_3C1F	jsr L_91B4		;3C1F 20 B4 91
		lsr L_C304		;3C22 4E 04 C3
		dec L_31A2		;3C25 CE A2 31
		bmi L_3C2D		;3C28 30 03
		jmp L_3B6C		;3C2A 4C 6C 3B

.L_3C2D	lda L_C74B		;3C2D AD 4B C7
		cmp #$07		;3C30 C9 07
		bcs L_3C19		;3C32 B0 E5
		bcc L_3C1C		;3C34 90 E6

.L_3C36	lda #$0B		;3C36 A9 0B
		jsr L_3FBB_with_VIC		;3C38 20 BB 3F
		jsr L_3DF9		;3C3B 20 F9 3D
		lda #$40		;3C3E A9 40
		sta L_3DF8		;3C40 8D F8 3D

		ldx #$7C		;3C43 A2 7C
.L_3C45	lda #$08		;3C45 A9 08
		sta L_0201,X	;3C47 9D 01 02
		txa				;3C4A 8A
		sec				;3C4B 38
		sbc #$04		;3C4C E9 04
		tax				;3C4E AA
		bpl L_3C45		;3C4F 10 F4

		jsr update_colour_map_with_sysctl		;3C51 20 30 2C
		ldx L_C76B		;3C54 AE 6B C7
		lda #$03		;3C57 A9 03
		jsr sysctl		;3C59 20 25 87
		jsr set_up_colour_map_for_track_preview		;3C5C 20 77 3A
		jsr draw_track_preview_border		;3C5F 20 03 2F
		jsr draw_track_preview_track_name		;3C62 20 CE 2F
		jsr L_3EA8		;3C65 20 A8 3E
		ldx L_C77D		;3C68 AE 7D C7
		jsr prepare_trackQ		;3C6B 20 34 EA
		jsr update_per_track_stuff		;3C6E 20 18 1D
		jsr L_F386		;3C71 20 86 F3

.L_3C74	ldx #$27		;3C74 A2 27
		lda #$3B		;3C76 A9 3B
.L_3C78	sta L_7FC0,X	;3C78 9D C0 7F
		dex				;3C7B CA
		bpl L_3C78		;3C7C 10 FA
		
		ldx #$2C		;3C7E A2 2C
		jsr print_msg_4		;3C80 20 27 30
		jsr track_preview_check_keys		;3C83 20 DE CF
		bcc L_3C8E		;3C86 90 06
		jsr L_F386		;3C88 20 86 F3
		jmp L_3C74		;3C8B 4C 74 3C

.L_3C8E	lda #$00		;3C8E A9 00
		jsr L_3FBB_with_VIC		;3C90 20 BB 3F
		lda #$00		;3C93 A9 00
		sta L_3DF8		;3C95 8D F8 3D
		rts				;3C98 60
}

; *****************************************************************************
; GAME MAIN LOOP
; *****************************************************************************

.game_main_loop			; aka L_3C99
{
		ldx #$80		;3C99 A2 80
		lda #$34		;3C9B A9 34
		jsr sysctl		;3C9D 20 25 87
		jsr L_3DF9		;3CA0 20 F9 3D
		ldx #$80		;3CA3 A2 80
		lda #$10		;3CA5 A9 10
		jsr sysctl		;3CA7 20 25 87
		lda #$02		;3CAA A9 02
		jsr sysctl		;3CAC 20 25 87
		jsr L_3EB6_from_main_loop		;3CAF 20 B6 3E
		ldx L_C765		;3CB2 AE 65 C7
		stx L_C375		;3CB5 8E 75 C3
		lda #$04		;3CB8 A9 04
		sta ZP_C4		;3CBA 85 C4
		lda #$4C		;3CBC A9 4C
		sta ZP_B0		;3CBE 85 B0
		jsr L_1EE2_from_main_loop		;3CC0 20 E2 1E
		ldx L_C765		;3CC3 AE 65 C7
.L_3CC6
		jsr L_F488		;3CC6 20 88 F4
		jsr L_2C64		;3CC9 20 64 2C
		bit L_3DF8		;3CCC 2C F8 3D
		bmi L_3CDD		;3CCF 30 0C
		jsr reset_sprites		;3CD1 20 84 14
		jsr L_167A_from_main_loop		;3CD4 20 7A 16
		jsr toggle_display_pageQ		;3CD7 20 42 3F
		jsr game_update		;3CDA 20 41 08

.L_3CDD	jsr L_167A_from_main_loop		;3CDD 20 7A 16
		jsr draw_tachometer_in_game		;3CE0 20 06 12
		jsr draw_crane_with_sysctl		;3CE3 20 1E 1C
		jsr L_14D0_from_main_loop		;3CE6 20 D0 14	; update scratches and scrapes?
		jsr toggle_display_pageQ		;3CE9 20 42 3F
		jsr game_update		;3CEC 20 41 08
		lda #$80		;3CEF A9 80
		sta L_C307		;3CF1 8D 07 C3
		sta L_3DF8		;3CF4 8D F8 3D
		ldy #$03		;3CF7 A0 03
		jsr delay_approx_Y_25ths_sec		;3CF9 20 EB 3F
		jsr ensure_screen_enabled		;3CFC 20 9E 3F
		jsr L_3F27_with_SID		;3CFF 20 27 3F
		jsr L_3046		;3D02 20 46 30

.L_3D05
		dec L_C30C		;3D05 CE 0C C3
		jsr L_1C64_with_keys		;3D08 20 64 1C
		jsr game_update		;3D0B 20 41 08
		jsr L_E104		;3D0E 20 04 E1
		jsr L_167A_from_main_loop		;3D11 20 7A 16
		jsr L_2C6F		;3D14 20 6F 2C
		jsr L_14D0_from_main_loop		;3D17 20 D0 14
		jsr draw_crane_with_sysctl		;3D1A 20 1E 1C
		jsr update_per_track_stuff		;3D1D 20 18 1D
		jsr draw_tachometer_in_game		;3D20 20 06 12
		jsr L_10D9		;3D23 20 D9 10
		jsr L_0F2A		;3D26 20 2A 0F
		jsr update_distance_to_ai_car_readout		;3D29 20 64 11
		jsr toggle_display_pageQ		;3D2C 20 42 3F
		jsr update_pause_status		;3D2F 20 E0 3E
		lda L_C351		;3D32 AD 51 C3
		and L_C306		;3D35 2D 06 C3
		bpl L_3D69		;3D38 10 2F
		lda ZP_82		;3D3A A5 82
		bne L_3D69		;3D3C D0 2B
		lda ZP_2F		;3D3E A5 2F
		bne L_3D46		;3D40 D0 04
		lda ZP_6A		;3D42 A5 6A
		beq L_3D69		;3D44 F0 23

.L_3D46	lda L_C364		;3D46 AD 64 C3
		bne L_3D50		;3D49 D0 05
		ldy #$0B		;3D4B A0 0B
		jsr L_114D_with_color_ram		;3D4D 20 4D 11

.L_3D50	ldy #$3C		;3D50 A0 3C
		lda #$04		;3D52 A9 04
		jsr set_up_text_sprite		;3D54 20 A9 12
		lda #$FF		;3D57 A9 FF
		sta ZP_11		;3D59 85 11
		lda #$F8		;3D5B A9 F8
		sta ZP_10		;3D5D 85 10
		lda #$00		;3D5F A9 00
		sta ZP_5D		;3D61 85 5D
		jsr debounce_fire_and_wait_for_fire		;3D63 20 96 36
		jmp L_3DAB		;3D66 4C AB 3D

.L_3D69	lda ZP_2F		;3D69 A5 2F
		bne L_3D95		;3D6B D0 28
		ldy ZP_6B		;3D6D A4 6B
		bpl L_3D95		;3D6F 10 24
		lda ZP_6A		;3D71 A5 6A
		beq L_3D95		;3D73 F0 20
		lda ZP_64		;3D75 A5 64
		bmi L_3D7D		;3D77 30 04
		cmp #$02		;3D79 C9 02
		bcs L_3D80		;3D7B B0 03

.L_3D7D	sty L_C373		;3D7D 8C 73 C3
.L_3D80	dec L_C368		;3D80 CE 68 C3
		bpl L_3D95		;3D83 10 10
		inc L_C368		;3D85 EE 68 C3
		lda ZP_6C		;3D88 A5 6C
		bne L_3D95		;3D8A D0 09
		jsr L_E0F9_with_sysctl		;3D8C 20 F9 E0
		ldx L_C309		;3D8F AE 09 C3
		jmp L_3CC6		;3D92 4C C6 3C
.L_3D95	lda ZP_2F		;3D95 A5 2F
		bne L_3DA1		;3D97 D0 08
		lda ZP_6B		;3D99 A5 6B
		bmi L_3DA8		;3D9B 30 0B
		lda ZP_6A		;3D9D A5 6A
		beq L_3DA8		;3D9F F0 07
.L_3DA1	ldx #$2F		;3DA1 A2 2F
		jsr poll_key_with_sysctl		;3DA3 20 C9 C7
		beq L_3DAB		;3DA6 F0 03
.L_3DA8	jmp L_3D05		;3DA8 4C 05 3D

.L_3DAB	lda L_C364		;3DAB AD 64 C3
		bne L_3DB5		;3DAE D0 05
		lda #$C0		;3DB0 A9 C0
		sta L_C362		;3DB2 8D 62 C3
.L_3DB5	lda #$00		;3DB5 A9 00
		jsr L_3FBB_with_VIC		;3DB7 20 BB 3F
		lda #$00		;3DBA A9 00
		sta L_3DF8		;3DBC 8D F8 3D
		sta VIC_SPENA		;3DBF 8D 15 D0
		jsr L_E0F9_with_sysctl		;3DC2 20 F9 E0
		bit L_C76C		;3DC5 2C 6C C7
		bpl L_3DE7		;3DC8 10 1D
		lda L_31A1		;3DCA AD A1 31
		beq L_3DED		;3DCD F0 1E
		ldx L_31A4		;3DCF AE A4 31
		lda L_C719		;3DD2 AD 19 C7
		sta L_83B0,X	;3DD5 9D B0 83
		lda L_C378		;3DD8 AD 78 C3
		cmp #$04		;3DDB C9 04
		beq L_3DE7		;3DDD F0 08
		txa				;3DDF 8A
		clc				;3DE0 18
		adc #$0C		;3DE1 69 0C
		tax				;3DE3 AA
		jsr L_1090		;3DE4 20 90 10
.L_3DE7	lda L_C37E		;3DE7 AD 7E C3
		sta L_C719		;3DEA 8D 19 C7
.L_3DED	jsr save_rndQ_stateQ		;3DED 20 2C 16
		ldx #$00		;3DF0 A2 00
		lda #$34		;3DF2 A9 34
		jsr sysctl		;3DF4 20 25 87
		rts				;3DF7 60
}

; *****************************************************************************
; *****************************************************************************

.L_3DF8	equb $00		; first frame flag?

.L_3DF9
{
		ldx #$00		;3DF9 A2 00
.L_3DFB	lda #$00		;3DFB A9 00
		sta L_C300,X	;3DFD 9D 00 C3
		cpx #$74		;3E00 E0 74
		bcc L_3E07		;3E02 90 03
		sta L_0700,X	;3E04 9D 00 07
.L_3E07	sta L_4000,X	;3E07 9D 00 40
		cpx #$90		;3E0A E0 90
		bcs L_3E11		;3E0C B0 03
		sta L_0100,X	;3E0E 9D 00 01
.L_3E11	cpx #$02		;3E11 E0 02
		bcc L_3E17		;3E13 90 02
		sta DATA_6510,X		;3E15 95 00
.L_3E17	dex				;3E17 CA
		bne L_3DFB		;3E18 D0 E1
		ldx L_C71A		;3E1A AE 1A C7
		ldy #$00		;3E1D A0 00
.L_3E1F	lda L_BFEA,X	;3E1F BD EA BF
		sta L_C382,Y	;3E22 99 82 C3
		inx				;3E25 E8
		iny				;3E26 C8
		cpy #$0B		;3E27 C0 0B
		bne L_3E1F		;3E29 D0 F4
		ldx #$7C		;3E2B A2 7C
.L_3E2D	lda #$07		;3E2D A9 07
		sta L_0200,X	;3E2F 9D 00 02
		lda #$17		;3E32 A9 17
		sta L_0201,X	;3E34 9D 01 02
		txa				;3E37 8A
		sec				;3E38 38
		sbc #$04		;3E39 E9 04
		tax				;3E3B AA
		bpl L_3E2D		;3E3C 10 EF
		jsr update_colour_map_with_sysctl		;3E3E 20 30 2C
		lda #$3F		;3E41 A9 3F
		sta L_C34F		;3E43 8D 4F C3
		lda #$BA		;3E46 A9 BA
		sta ZP_1C		;3E48 85 1C
		sta L_2806		;3E4A 8D 06 28
		lda #$00		;3E4D A9 00
		sta VIC_SPENA		;3E4F 8D 15 D0
		sta SID_SIGVOL		;3E52 8D 18 D4
		ldx #$02		;3E55 A2 02
.L_3E57	lda #$09		;3E57 A9 09
		sta L_8398,X	;3E59 9D 98 83
		dex				;3E5C CA
		bpl L_3E57		;3E5D 10 F8
		lda L_31A4		;3E5F AD A4 31
		clc				;3E62 18
		adc #$0C		;3E63 69 0C
		tax				;3E65 AA
		jsr L_1090		;3E66 20 90 10
		jsr update_camera_roll_tables		;3E69 20 26 27
		lda #$A0		;3E6C A9 A0
		sta ZP_33		;3E6E 85 33
		lda #$78		;3E70 A9 78
		sta ZP_3C		;3E72 85 3C
		jsr L_E0F9_with_sysctl		;3E74 20 F9 E0
		lda #$04		;3E77 A9 04
		sta L_C354		;3E79 8D 54 C3
		ldy #$09		;3E7C A0 09
		jsr L_1637		;3E7E 20 37 16
		lda #$3B		;3E81 A9 3B
		sta ZP_03		;3E83 85 03
		jsr initialise_hud_sprites		;3E85 20 9A 12
		ldy #$0B		;3E88 A0 0B
		jsr L_115D_with_color_ram		;3E8A 20 5D 11
		jsr L_114D_with_color_ram		;3E8D 20 4D 11
		ldx L_C776		;3E90 AE 76 C7
		lda L_C71A		;3E93 AD 1A C7
		beq L_3E9B		;3E96 F0 03
		ldx L_C777		;3E98 AE 77 C7
.L_3E9B	txa				;3E9B 8A
		jsr convert_X_to_BCD		;3E9C 20 15 92
		sta L_C76A		;3E9F 8D 6A C7
		lda L_C719		;3EA2 AD 19 C7
		sta L_C37E		;3EA5 8D 7E C3
}
\\
.L_3EA8
{
		ldx #$1F		;3EA8 A2 1F
.L_3EAA	lda #$80		;3EAA A9 80
		sta L_A350,X	;3EAC 9D 50 A3
		sta L_8080,X	;3EAF 9D 80 80
		dex				;3EB2 CA
		bpl L_3EAA		;3EB3 10 F5
		rts				;3EB5 60
}

; only called from game_main_loop
.L_3EB6_from_main_loop
{
		ldx #$80		;3EB6 A2 80
.L_3EB8	ldy #$00		;3EB8 A0 00
		txa				;3EBA 8A
		and #$07		;3EBB 29 07
		cmp #$07		;3EBD C9 07
		bne L_3EC3		;3EBF D0 02
		ldy #$80		;3EC1 A0 80
.L_3EC3	tya				;3EC3 98
		sta L_C440,X	;3EC4 9D 40 C4
		dex				;3EC7 CA
		bpl L_3EB8		;3EC8 10 EE
		lda #$C0		;3ECA A9 C0
		sta L_C43F		;3ECC 8D 3F C4
		ldx L_31A1		;3ECF AE A1 31
		beq L_3EDD		;3ED2 F0 09
		ldx L_31A4		;3ED4 AE A4 31
		lda L_83B0,X	;3ED7 BD B0 83
		sta L_C719		;3EDA 8D 19 C7
.L_3EDD	jmp L_F6A6		;3EDD 4C A6 F6
}

.update_pause_status
{
		lda L_C306		;3EE0 AD 06 C3
		bpl L_3EEC		;3EE3 10 07
		ldx #$0D		;3EE5 A2 0D
		jsr poll_key_with_sysctl		;3EE7 20 C9 C7
		beq L_3EED		;3EEA F0 01
.L_3EEC	rts				;3EEC 60

.L_3EED	jsr L_E0F9_with_sysctl		;3EED 20 F9 E0
		lda #$00		;3EF0 A9 00
		sta ZP_10		;3EF2 85 10
		sta ZP_11		;3EF4 85 11
		lda L_C355		;3EF6 AD 55 C3
		pha				;3EF9 48
		lda L_1327		;3EFA AD 27 13
		pha				;3EFD 48
		lda L_1328		;3EFE AD 28 13
		pha				;3F01 48
		ldy #$4C		;3F02 A0 4C
		lda #$02		;3F04 A9 02
		jsr set_up_text_sprite		;3F06 20 A9 12
.L_3F09	jsr maybe_define_keys		;3F09 20 AF 97
		ldx #$34		;3F0C A2 34
		jsr poll_key_with_sysctl		;3F0E 20 C9 C7
		bne L_3F09		;3F11 D0 F6
		pla				;3F13 68
		sta L_1328		;3F14 8D 28 13
		tax				;3F17 AA
		pla				;3F18 68
		sta L_1327		;3F19 8D 27 13
		tay				;3F1C A8
		pla				;3F1D 68
		sta L_C355		;3F1E 8D 55 C3
		bpl L_3F27_with_SID		;3F21 10 04
		txa				;3F23 8A
		jsr set_up_text_sprite		;3F24 20 A9 12
}
\\
.L_3F27_with_SID
{
		lda #$06		;3F27 A9 06
		jsr L_CF68		;3F29 20 68 CF
		lda #$05		;3F2C A9 05
		jsr L_CF68		;3F2E 20 68 CF
		jsr L_E104		;3F31 20 04 E1
		lda #$41		;3F34 A9 41
		sta SID_VCREG1		;3F36 8D 04 D4	; SID
		sta SID_VCREG3		;3F39 8D 12 D4
		lda #$F5		;3F3C A9 F5
		sta SID_SIGVOL		;3F3E 8D 18 D4
		rts				;3F41 60
}

.toggle_display_pageQ
{
		sei				;3F42 78
		lda L_C306		;3F43 AD 06 C3
		eor #$80		;3F46 49 80
		sta L_C306		;3F48 8D 06 C3
		bpl L_3F59		;3F4B 10 0C
		lda #$20		;3F4D A9 20
		sta ZP_12		;3F4F 85 12
		lda #$80		;3F51 A9 80
		sta L_C370		;3F53 8D 70 C3
		jmp L_3F64		;3F56 4C 64 3F
.L_3F59	lda #$18		;3F59 A9 18
		clc				;3F5B 18
		adc L_A1F2		;3F5C 6D F2 A1
		sta ZP_12		;3F5F 85 12
		sta L_C370		;3F61 8D 70 C3
.L_3F64	lda #$80		;3F64 A9 80
		sta L_C37A		;3F66 8D 7A C3
		cli				;3F69 58
		rts				;3F6A 60
}

; called from game update
.update_colour_map_if_dirty
		lda L_C37B		;3F6B AD 7B C3
		beq L_3F83		;3F6E F0 13
\\
.update_colour_map_always
		jsr update_colour_map_with_sysctl		;3F70 20 30 2C
		lda #$0C		;3F73 A9 0C
		sta L_DAAC		;3F75 8D AC DA
		sta L_DACB		;3F78 8D CB DA
		lda #$00		;3F7B A9 00
		sta L_C37A		;3F7D 8D 7A C3
		sta L_C37B		;3F80 8D 7B C3
.L_3F83	rts				;3F83 60

.L_3F84	ldy #$78		;3F84 A0 78
		ldx #$00		;3F86 A2 00
		jmp L_3F8F		;3F88 4C 8F 3F

.set_up_single_page_display
		ldy #$70		;3F8B A0 70
		ldx #$80		;3F8D A2 80
.L_3F8F	sty ZP_14		;3F8F 84 14
		php				;3F91 08
		sei				;3F92 78
		sty VIC_VMCSB		;3F93 8C 18 D0
		stx L_C35F		;3F96 8E 5F C3
		stx L_C370		;3F99 8E 70 C3
		plp				;3F9C 28
		rts				;3F9D 60

.ensure_screen_enabled
{
		lda VIC_SCROLY		;3F9E AD 11 D0
		and #$10		;3FA1 29 10
		bne L_3FB4		;3FA3 D0 0F
}
\\
.enable_screen_and_set_irq50
		lda VIC_SCROLY		;3FA5 AD 11 D0
		ora #$10		;3FA8 09 10
		and #$7F		;3FAA 29 7F
		sta VIC_SCROLY		;3FAC 8D 11 D0
		lda #$32		;3FAF A9 32
		sta VIC_RASTER		;3FB1 8D 12 D0
.L_3FB4	lda #$01		;3FB4 A9 01
		sta VIC_IRQMASK		;3FB6 8D 1A D0
		rts				;3FB9 60
		
.L_3FBA	equb $00

.L_3FBB_with_VIC
{
		sta L_3FBA		;3FBB 8D BA 3F
}
\\
.L_3FBE_with_VIC
{
		nop				;3FBE EA
		ldy #$05		;3FBF A0 05
		sty ZP_14		;3FC1 84 14
.L_3FC3	lda VIC_RASTER		;3FC3 AD 12 D0		; VIC
		cmp #$0A		;3FC6 C9 0A
		bcs L_3FCF		;3FC8 B0 05
		lda VIC_SCROLY		;3FCA AD 11 D0		; VIC
		bpl L_3FD6		;3FCD 10 07
.L_3FCF	dec ZP_14		;3FCF C6 14
		bne L_3FC3		;3FD1 D0 F0
		dey				;3FD3 88
		bne L_3FC3		;3FD4 D0 ED
.L_3FD6	lda L_3FBA		;3FD6 AD BA 3F
		sta VIC_EXTCOL		;3FD9 8D 20 D0		; VIC
		lda VIC_SCROLY		;3FDC AD 11 D0		; VIC
		and #$EF		;3FDF 29 EF
		sta VIC_SCROLY		;3FE1 8D 11 D0		; VIC
		ldy #$01		;3FE4 A0 01
		jmp delay_approx_Y_25ths_sec		;3FE6 4C EB 3F
}

.delay_approx_4_5ths_sec
		ldy #$14		;3FE9 A0 14

.delay_approx_Y_25ths_sec
		lda #$14		;3FEB A9 14
		sta ZP_15		;3FED 85 15
.L_3FEF	dec ZP_14		;3FEF C6 14
.L_3FF1	bne L_3FEF		;3FF1 D0 FC
		dec ZP_15		;3FF3 C6 15
		bne L_3FEF		;3FF5 D0 F8
L_3FF6	= *-1			;!
		dey				;3FF7 88
		bne delay_approx_Y_25ths_sec		;3FF8 D0 F1
.L_3FFA	rts				;3FFA 60

; *****************************************************************************
; SCREEN BUFFERS: $4000 - $8000
; *****************************************************************************

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

ORG &5780
.L_5780	EQUB $BC,$BC,$BC,$BC,$BC,$BC,$BC,$BA,$B9,$B9,$B9,$B9,$B9,$B9,$B7,$B5
		EQUB $B4,$B4,$B4,$B4,$B4,$B2,$B1,$B0,$B0,$B0,$B0,$AE,$AD,$AD,$AD,$AD
		EQUB $AF,$BD,$BF,$C0,$C0,$BF,$BE,$BC,$B8,$B8,$B8,$B7,$B6,$B6,$B5,$B5
		EQUB $B2,$B1,$AF,$AC,$AB,$AB,$AB,$AB,$AB,$AB,$AB,$AC,$B4,$B4,$B4,$B1
		EQUB $B1,$B4,$B4,$B4,$AC,$AB,$AB,$AB,$AB,$AB,$AB,$AB,$AC,$AD,$AF,$B1
		EQUB $B5,$B5,$B5,$B6,$B7,$B8,$B8,$B8,$BC,$BD,$BE,$BF,$C0,$BF,$BD,$AF
		EQUB $AD,$AD,$AD,$AD,$AE,$B0,$B0,$B0,$B0,$B1,$B2,$B4,$B4,$B4,$B4,$B4
		EQUB $B5,$B7,$B9,$B9,$B9,$B9,$B9,$B9,$BA,$BC,$BC,$BC,$BC,$BC,$BC,$BC

L_5798	= screen1_address+$1798
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
;L_72E0	= screen2_address+$12e0 ; OK - originally used for copying the picture engine
;L_7420	= screen2_address+$1420 ; OK - originally used for copying the picture engine
;L_7560	= screen2_address+$1560 ; OK - originally used for copying the picture engine between the blocks
;L_7578	= screen2_address+$1578 ; OK - originally used to copy the image engine between the blocks
;L_75A0	= screen2_address+$15a0 ; OK - originally used to copy the image engine between the blocks
;L_7608	= screen2_address+$1608 ; OK - originally used to copy the image engine between the blocks
;L_7640	= screen2_address+$1640 ; OK - originally used to copy the image engine between the blocks
;L_7648	= screen2_address+$1648 ; OK - originally used to copy the image engine between the blocks
;L_7658	= screen2_address+$1658
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

ORG &72E0
.L_72E0	EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FD,$FD,$FF,$FF,$FF,$FF,$FF,$55,$02,$00
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FD,$FD,$FD,$F4,$FF,$FF,$FF,$55,$00,$55,$00,$00
		EQUB $FF,$FF,$FF,$57,$01,$55,$05,$01,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$D5,$40,$55,$50,$80
		EQUB $FF,$FF,$FF,$55,$00,$55,$00,$00,$FF,$FF,$FF,$FF,$7F,$5F,$5F,$07
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD
		EQUB $FF,$FF,$FF,$FF,$FF,$55,$80,$00,$FF,$FF,$FF,$FF,$FF,$FF,$7F,$7F
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $69,$69,$69,$69,$69,$69,$69,$69,$58,$58,$58,$58,$58,$58,$58,$58
		EQUB $1B,$1B,$1B,$16,$16,$16,$16,$16,$6A,$6A,$5A,$5A,$5A,$56,$D6,$D6
		EQUB $AB,$AF,$AD,$AD,$BD,$BD,$B5,$F5,$68,$68,$68,$68,$68,$68,$68,$68
		EQUB $25,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$69,$69,$69,$69,$69,$69,$69,$69
.L_7420	EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$FC,$F4
		EQUB $FF,$FF,$FF,$FF,$69,$00,$00,$00,$FD,$F4,$D0,$C0,$50,$18,$08,$02
		EQUB $54,$06,$02,$00,$00,$00,$00,$00,$00,$00,$00,$80,$82,$99,$85,$85
		EQUB $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$FF,$FF,$FF,$FF,$FF,$F9,$A5,$94
		EQUB $F5,$D4,$40,$50,$55,$55,$40,$00,$AA,$00,$00,$00,$AA,$55,$00,$00
		EQUB $AA,$29,$02,$0A,$A9,$63,$28,$0B,$FF,$FC,$FC,$FC,$54,$A8,$00,$54
		EQUB $FF,$7F,$7F,$7F,$55,$40,$40,$55,$AA,$68,$40,$60,$EA,$C2,$28,$E0
		EQUB $AA,$00,$00,$00,$AA,$55,$00,$00,$57,$15,$01,$05,$55,$56,$00,$00
		EQUB $FF,$FF,$FF,$FF,$FF,$67,$59,$16,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$7F
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD
		EQUB $00,$00,$00,$82,$82,$66,$52,$92,$15,$90,$80,$00,$00,$00,$00,$80
		EQUB $7F,$1F,$07,$03,$05,$24,$20,$80,$FF,$FF,$FF,$FF,$55,$00,$00,$00
		EQUB $FF,$FF,$FF,$FF,$FF,$7F,$3F,$1F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $69,$69,$69,$69,$69,$69,$69,$69,$58,$5A,$5A,$5A,$5A,$5A,$5A,$5A
		EQUB $29,$29,$29,$29,$29,$29,$29,$29,$EA,$FA,$7A,$7A,$7E,$7E,$5E,$5F
		EQUB $A5,$95,$95,$95,$95,$55,$55,$55,$68,$68,$68,$68,$68,$68,$68,$68
		EQUB $A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$69,$69,$69,$69,$69,$69,$69,$69
.L_7560	EQUB $FF,$FF,$FF,$FF,$00,$00,$00,$00,$FF,$FF,$FE,$FC,$08,$00,$10,$10
		EQUB $FF,$59,$00,$00,$00,$00,$00,$00
.L_7578	EQUB $F0,$50,$08,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00,$40,$80,$80
		EQUB $02,$02,$02,$02,$02,$09,$09,$15,$02,$06,$62,$11,$11,$11,$11,$05
		EQUB $45,$45,$44,$40,$50,$90,$90,$90
.L_75A0	EQUB $7F,$7F,$7F,$7F,$BF,$AF,$2F,$5B,$FF,$FF,$FF,$FF,$FE,$FD,$F5,$E5
		EQUB $F9,$E9,$25,$AA,$92,$99,$59,$A9,$EA,$9A,$98,$50,$58,$6C,$7F,$7F
		EQUB $00,$AA,$5A,$15,$00,$00,$04,$19,$00,$AA,$A5,$54,$00,$00,$01,$40
		EQUB $28,$A4,$07,$0F,$10,$5F,$40,$80,$00,$00,$F1,$A1,$01,$F1,$01,$01
		EQUB $C0,$C0,$C5,$8A,$80,$85,$80,$80,$28,$3A,$5C,$50,$00,$57,$03,$03
		EQUB $00,$AA,$5A,$05,$00,$00,$40,$40,$00,$AA,$A5,$54,$00,$00,$41,$55
		EQUB $AA,$A6,$85,$35,$19,$39,$36,$F8
.L_7608	EQUB $65,$79,$98,$96,$E2,$E7,$E9,$F9,$FF,$FF,$FF,$FF,$7F,$5F,$5B,$12
		EQUB $FD,$FD,$FD,$FD,$FD,$F5,$FA,$EA,$81,$81,$91,$51,$51,$11,$11,$41
		EQUB $80,$90,$99,$94,$94,$94,$84,$44,$80,$80,$80,$80,$A0,$60,$68,$55
		EQUB $00,$00,$00,$00,$00,$01,$02,$02
.L_7640	EQUB $0F,$05,$20,$80,$80,$00,$00,$00
.L_7648	EQUB $FF,$65,$00,$00,$00,$00,$00,$00,$FF,$FF,$BF,$3F,$20,$04,$04,$04
.L_7658	EQUB $FF,$FF,$FF,$FF,$00,$00,$00,$00,$69,$69,$69,$69,$69,$69,$69,$69
		EQUB $5A,$5A,$5A,$5A,$5A,$5A,$5A,$5A,$29,$29,$29,$29,$29,$29,$29,$29
		EQUB $5A,$56,$56,$56,$56,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55,$55
		EQUB $68,$68,$68,$68,$68,$68,$68,$68,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5
		EQUB $69,$69,$69,$69,$69,$69,$69,$69

; *****************************************************************************
; CART RAM: $8000 - $A000
;
; $8300 = More code VIC, color map
; $8400 = oswrch
; $8500 = read keyboard
; $8600 = SID update
; $8700 = sysctl
; ...
; $8A00 = draw horizon
; ...
; $8E00 = draw speedo
; $8F00 = clear screen
; $9000 = update color map
; $9100 = PETSCII fns?
; ...
; $9500 = Save file strings
; ...
; $9800 = Practice menu, Hall of Fame etc.
; ...
; $9A00 = More track & camera code
; ...
; $A100 = Calculate camera sines
; *****************************************************************************

ORG &8000
.L_8000	skip $C8
L_801B	= L_8000 + $1B
L_8020	= L_8000 + $20
L_8025	= L_8000 + $25
L_803E	= L_8000 + $3E
L_8040	= L_8000 + $40
L_8041	= L_8000 + $41
L_8060	= L_8000 + $60
L_807C	= L_8000 + $7C
L_807D	= L_8000 + $7D
L_807E	= L_8000 + $7E
L_807F	= L_8000 + $7F
L_8080	= L_8000 + $80
L_80A0	= L_8000 + $A0

.L_80C8	equb $95,$95,$95,$95,$AA,$EA,$EA,$EA,$15,$15,$15,$15,$15,$6A,$6A,$6A
		equb $75,$C3,$00,$00,$00,$00,$80,$80,$40,$40,$C0,$00,$00,$80,$80,$80
		equb $55,$55,$55,$55,$55,$AA,$AA,$AA,$55,$55,$55,$55,$55,$AA,$AA,$AA
		equb $BD,$FF,$C3,$C0,$C3,$F3,$BF,$BF,$00,$00,$C0,$C0,$C0,$C0,$40,$40
		equb $FF,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$80,$FF
		equb $08,$08,$08,$7F,$08,$08,$08,$00,$01,$01,$01,$01,$01,$01,$01,$FF
		equb $00,$00,$00,$7F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00
		equb $00,$02,$04,$08,$10,$20,$40,$00,$00,$3C,$42,$42,$42,$42,$3C,$00
		equb $00,$10,$30,$10,$10,$10,$38,$00,$00,$3C,$42,$0C,$30,$40,$7E,$00
		equb $00,$7E,$04,$0C,$02,$42,$3C,$00,$00,$04,$0C,$14,$24,$7E,$04,$00
		equb $00,$7E,$40,$7C,$02,$02,$7C,$00,$00,$3C,$40,$7C,$42,$42,$3C,$00
		equb $00,$7E,$04,$08,$10,$20,$20,$00,$00,$3C,$42,$3C,$42,$42,$3C,$00
		equb $00,$3C,$42,$3C,$04,$08,$10,$00,$00,$00,$10,$00,$00,$10,$00,$00
		equb $00,$00,$10,$00,$00,$10,$20,$00,$18,$18,$18,$18,$18,$00,$18,$00
		equb $00,$00,$7E,$00,$7E,$00,$00,$00,$30,$18,$0C,$06,$0C,$18,$30,$00
		equb $00,$38,$44,$04,$08,$10,$00,$10,$3C,$66,$6E,$6A,$6E,$60,$3C,$00
		equb $00,$3C,$42,$42,$7E,$42,$42,$00,$00,$78,$44,$7C,$42,$42,$7C,$00
		equb $00,$3C,$42,$40,$40,$42,$3C,$00,$00,$7C,$42,$42,$42,$42,$7C,$00
		equb $00,$7E,$40,$78,$40,$40,$7E,$00,$00,$7E,$40,$78,$40,$40,$40,$00
		equb $00,$3C,$42,$40,$4E,$42,$3E,$00,$00,$42,$42,$7E,$42,$42,$42,$00
		equb $00,$38,$10,$10,$10,$10,$38,$00,$00,$04,$04,$04,$04,$44,$38,$00
		equb $00,$44,$48,$70,$48,$44,$42,$00,$00,$20,$20,$20,$20,$20,$3E,$00
		equb $00,$42,$66,$5A,$42,$42,$42,$00,$00,$42,$62,$52,$4A,$46,$42,$00
		equb $00,$3C,$42,$42,$42,$42,$3C,$00,$00,$7C,$42,$7C,$40,$40,$40,$00
		equb $00,$3C,$42,$42,$42,$42,$3C,$06,$00,$7C,$42,$7C,$48,$44,$42,$00
		equb $00,$3E,$40,$3C,$02,$02,$7C,$00,$00,$7C,$10,$10,$10,$10,$10,$00
		equb $00,$42,$42,$42,$42,$42,$3E,$00,$00,$42,$42,$42,$42,$24,$18,$00
		equb $00,$42,$42,$42,$5A,$66,$42,$00,$00,$42,$24,$18,$18,$24,$42,$00
		equb $00,$44,$44,$28,$10,$10,$10,$00,$00,$7E,$04,$08,$10,$20,$7E,$00

; Lap time fractions of second?
.L_8298	equb $01,$00,$00,$00,$00,$00,$00,$FF,$80,$00,$00,$00,$00,$00

.L_82A6	equb $00
.L_82A7	equb $FF,$00,$00,$00,$FF,$00,$00,$00,$01

; Lap time fractions of second?
.L_82B0	equb $00,$00,$00,$FF,$00,$00,$00,$80,$01,$00,$00,$00,$00,$00

.L_82BE	equb $00

.L_82BF	equb $01,$00,$00,$00,$FF,$00,$00,$00,$FF,$00,$00,$3C,$02,$3E,$42,$3E
		equb $00,$00,$40,$7C,$42,$42,$42,$7C,$00,$00,$00,$3E,$40,$40,$40,$3E
		equb $00,$00,$02,$3E,$42,$42,$42,$3E,$00,$00,$00,$3C,$42,$7E,$40,$3C
		equb $00,$00,$1C,$22,$20,$78,$20,$20,$00,$00,$00,$3E,$42,$42,$3E,$02
		equb $3C,$00,$40,$40,$7C,$42,$42,$42,$00,$10,$00,$30,$10,$10,$10,$38
		equb $00,$00,$08,$00,$08,$08,$08,$48,$30,$00,$20,$20,$24,$38,$24,$22
		equb $00,$00,$30,$10,$10,$10,$10,$38,$00,$00,$00,$24,$5A,$5A,$42,$42
		equb $00,$00,$00,$7C,$42,$42,$42,$42,$00,$00,$00,$3C,$42,$42,$42,$3C
		equb $00,$00,$00,$7C,$42,$42,$7C,$40,$40,$00,$00,$3E,$42,$42,$3E,$02
		equb $02,$00,$00,$5C,$62,$40,$40,$40,$00,$00,$00,$3E,$60,$3C,$06,$7C
		equb $00,$00,$20,$7C,$20,$20,$24,$18,$00,$00,$00,$42,$42,$42,$42,$3E
		equb $00,$00,$00,$42,$42,$42,$24,$18,$00,$00,$00,$42,$42,$5A,$5A,$24
		equb $00,$00,$00,$42,$24,$18,$24,$42,$00,$00,$00,$42,$42,$42,$3E,$02
		equb $3C,$00,$00,$7E,$04,$18,$20,$7E,$00

; Lap time fractions of second?
.L_8398	equb $00,$00,$00,$FF,$00,$00,$00,$81,$81,$81,$81,$81,$81,$81

.L_83A6	equb $81
.L_83A7	equb $81,$81,$00,$00,$00,$00,$00,$00,$81

.L_83B0	equb $FF,$00,$00,$00,$00,$00,$00,$FF,$30,$18,$0C,$06,$0C,$18,$30,$00

.multicolour_mode
{
		lda VIC_SCROLX		;83C0 AD 16 D0
		ora #$10		;83C3 09 10
		sta VIC_SCROLX		;83C5 8D 16 D0
		lda #$78		;83C8 A9 78
		bne vic_memory_setup		;83CA D0 0A
}
\\
.non_multicolour_mode
{
		lda VIC_SCROLX		;83CC AD 16 D0
		and #$EF		;83CF 29 EF
		sta VIC_SCROLX		;83D1 8D 16 D0
		lda #$F0		;83D4 A9 F0
}
\\
.vic_memory_setup
{
		sta ZP_FA		;83D6 85 FA
		sei				;83D8 78
		lda CIA2_C2DDRA		;83D9 AD 02 DD
		ora #$03		;83DC 09 03
		sta CIA2_C2DDRA		;83DE 8D 02 DD
		lda CIA2_CI2PRA		;83E1 AD 00 DD
		and #$FC		;83E4 29 FC
		ora #$02		;83E6 09 02
		sta CIA2_CI2PRA		;83E8 8D 00 DD
		lda ZP_FA		;83EB A5 FA
		sta VIC_VMCSB		;83ED 8D 18 D0
		cli				;83F0 58
		lda #$00		;83F1 A9 00
		sta VIC_BGCOL0		;83F3 8D 21 D0
		rts				;83F6 60
}

.L_83F7_with_vic
{
		stx L_8415		;83F7 8E 15 84
		lda VIC_SCROLX		;83FA AD 16 D0
		ora #$10		;83FD 09 10
		sta VIC_SCROLX		;83FF 8D 16 D0
		lda #$F0		;8402 A9 F0
		jsr vic_memory_setup		;8404 20 D6 83
		lda L_8415		;8407 AD 15 84
		ora #$0E		;840A 09 0E
		jsr clear_colour_mapQ		;840C 20 16 84
		lda #$01		;840F A9 01
		jsr L_8428		;8411 20 28 84
		rts				;8414 60
		
.L_8415	equb $00
}

.clear_colour_mapQ
{
		ldx #$00		;8416 A2 00
.L_8418	sta L_5C00,X	;8418 9D 00 5C
		sta L_5D00,X	;841B 9D 00 5D
		sta L_5E00,X	;841E 9D 00 5E
		sta L_5F00,X	;8421 9D 00 5F
		dex				;8424 CA
		bne L_8418		;8425 D0 F1
		rts				;8427 60
}

.L_8428
{
		cmp #$02		;8428 C9 02
		bcc L_8453		;842A 90 27
		lda #$40		;842C A9 40
		sta ZP_F4		;842E 85 F4
		sta ZP_F6		;8430 85 F6
		lda #$77		;8432 A9 77
		sta ZP_F5		;8434 85 F5
		lda #$57		;8436 A9 57
		sta ZP_F7		;8438 85 F7
		ldy #$7F		;843A A0 7F
.L_843C	lda (ZP_F4),Y	;843C B1 F4
		sta (ZP_F6),Y	;843E 91 F6
		dey				;8440 88
		bne L_843C		;8441 D0 F9
		lda (ZP_F4),Y	;8443 B1 F4
		sta (ZP_F6),Y	;8445 91 F6
		dey				;8447 88
		dec ZP_F7		;8448 C6 F7
		dec ZP_F5		;844A C6 F5
		lda ZP_F7		;844C A5 F7
		cmp #$41		;844E C9 41
		bcs L_843C		;8450 B0 EA
		rts				;8452 60
.L_8453	lda #$14		;8453 A9 14
		sta ZP_52		;8455 85 52
		ldx #$00		;8457 A2 00
		ldy #$40		;8459 A0 40
		lda #$AA		;845B A9 AA
		jsr fill_64s		;845D 20 21 89
		lda #$05		;8460 A9 05
		sta ZP_52		;8462 85 52
		ldx #$00		;8464 A2 00
		ldy #$59		;8466 A0 59
		lda #$00		;8468 A9 00
		jmp fill_64s		;846A 4C 21 89
}

.L_846D	equb $00
.L_846E	equb $00

; Print char.
; entry: A	= char to print	(also 127=del, 9=space,	VDU31 a	la OSWRCH)
.write_char
{
		sta L_85C7		;846F 8D C7 85
		stx L_85C8		;8472 8E C8 85
		sty L_85C9		;8475 8C C9 85
		jsr write_char_body		;8478 20 85 84
		ldx L_85C8		;847B AE C8 85
		ldy L_85C9		;847E AC C9 85
		lda L_85C7		;8481 AD C7 85
		rts				;8484 60
}

.write_char_body
{
		ldx L_846D		;8485 AE 6D 84
		beq L_84A1		;8488 F0 17
		inc L_846E		;848A EE 6E 84
		ldx L_846E		;848D AE 6E 84
		cpx #$02		;8490 E0 02
		beq L_8498		;8492 F0 04
		sta L_85C5		;8494 8D C5 85
		rts				;8497 60
.L_8498	sta L_85C6		;8498 8D C6 85
		lda #$00		;849B A9 00
		sta L_846D		;849D 8D 6D 84
		rts				;84A0 60

.L_84A1	cmp #$1F		;84A1 C9 1F
		bne L_84AE		;84A3 D0 09
		sta L_846D		;84A5 8D 6D 84
		lda #$00		;84A8 A9 00
		sta L_846E		;84AA 8D 6E 84
		rts				;84AD 60

.L_84AE	cmp #$09		;84AE C9 09
		bne L_84B6		;84B0 D0 04
		inc L_85C5		;84B2 EE C5 85
		rts				;84B5 60

.L_84B6	cmp #$7F		;84B6 C9 7F
		bcc L_84D3		;84B8 90 19
		bne L_84D2		;84BA D0 16
		dec L_85C5		;84BC CE C5 85
		lda #$80		;84BF A9 80
		sta L_85D1		;84C1 8D D1 85
		lda #$20		;84C4 A9 20
		sta L_85C7		;84C6 8D C7 85
		jsr write_char_body		;84C9 20 85 84
		lsr L_85D1		;84CC 4E D1 85
		dec L_85C5		;84CF CE C5 85
.L_84D2	rts				;84D2 60

.L_84D3	asl A			;84D3 0A
		rol ZP_F1		;84D4 26 F1
		asl A			;84D6 0A
		rol ZP_F1		;84D7 26 F1
		asl A			;84D9 0A
		rol ZP_F1		;84DA 26 F1
		clc				;84DC 18
		adc #$C0		;84DD 69 C0
		sta ZP_F0		;84DF 85 F0
		lda ZP_F1		;84E1 A5 F1
		and #$07		;84E3 29 07
		adc #$7F		;84E5 69 7F
		sta ZP_F1		;84E7 85 F1
		lda L_85C5		;84E9 AD C5 85
		asl A			;84EC 0A
		asl A			;84ED 0A
		asl A			;84EE 0A
		ora L_C3D9		;84EF 0D D9 C3
		rol ZP_FB		;84F2 26 FB
		sec				;84F4 38
		sbc L_85C5		;84F5 ED C5 85
		sta ZP_FA		;84F8 85 FA
		bcs L_84FE		;84FA B0 02
		dec ZP_FB		;84FC C6 FB
.L_84FE	lsr ZP_FB		;84FE 46 FB
		ror A			;8500 6A
		lsr A			;8501 4A
		lsr A			;8502 4A
		sta L_85CC		;8503 8D CC 85
		lda ZP_FA		;8506 A5 FA
		and #$07		;8508 29 07
		sta L_85CD		;850A 8D CD 85
		lda L_85C6		;850D AD C6 85
		asl A			;8510 0A
		asl A			;8511 0A
		clc				;8512 18
		adc L_85C6		;8513 6D C6 85
		sta ZP_FA		;8516 85 FA
		lda #$00		;8518 A9 00
		asl ZP_FA		;851A 06 FA
		rol A			;851C 2A
		asl ZP_FA		;851D 06 FA
		rol A			;851F 2A
		asl ZP_FA		;8520 06 FA
		rol A			;8522 2A
		sta ZP_FB		;8523 85 FB
		lda ZP_FA		;8525 A5 FA
		clc				;8527 18
		adc L_85CC		;8528 6D CC 85
		sta ZP_F4		;852B 85 F4
		lda ZP_FB		;852D A5 FB
		adc #$00		;852F 69 00
		asl ZP_F4		;8531 06 F4
		rol A			;8533 2A
		asl ZP_F4		;8534 06 F4
		rol A			;8536 2A
		asl ZP_F4		;8537 06 F4
		rol A			;8539 2A
		clc				;853A 18
		adc #$40		;853B 69 40
		sta ZP_F5		;853D 85 F5
		lda ZP_F4		;853F A5 F4
		bit L_85D0		;8541 2C D0 85
		bpl L_854B		;8544 10 05
		clc				;8546 18
		adc #$04		;8547 69 04
		sta ZP_F4		;8549 85 F4
.L_854B	clc				;854B 18
		adc #$08		;854C 69 08
		sta ZP_F6		;854E 85 F6
		lda ZP_F5		;8550 A5 F5
		adc #$00		;8552 69 00
		sta ZP_F7		;8554 85 F7
		lda #$FF		;8556 A9 FF
		sta L_85CB		;8558 8D CB 85
		lda #$00		;855B A9 00
		ldx L_85CD		;855D AE CD 85
		beq L_856A		;8560 F0 08
.L_8562	sec				;8562 38
		ror A			;8563 6A
		ror L_85CB		;8564 6E CB 85
		dex				;8567 CA
		bne L_8562		;8568 D0 F8
.L_856A	sta L_85CA		;856A 8D CA 85
		ldy #$00		;856D A0 00
.L_856F	lda #$00		;856F A9 00
		sta ZP_FB		;8571 85 FB
		lda (ZP_F0),Y	;8573 B1 F0
		ldx L_85CD		;8575 AE CD 85
		beq L_8580		;8578 F0 06
.L_857A	lsr A			;857A 4A
		ror ZP_FB		;857B 66 FB
		dex				;857D CA
		bne L_857A		;857E D0 FA
.L_8580	sta ZP_FA		;8580 85 FA
		lda (ZP_F4),Y	;8582 B1 F4
		and L_85CA		;8584 2D CA 85
		ora ZP_FA		;8587 05 FA
		sta (ZP_F4),Y	;8589 91 F4
		lda (ZP_F6),Y	;858B B1 F6
		and L_85CB		;858D 2D CB 85
		ora ZP_FB		;8590 05 FB
		sta (ZP_F6),Y	;8592 91 F6
		bit L_85D0		;8594 2C D0 85
		bpl L_85B0		;8597 10 17
		cpy #$03		;8599 C0 03
		bne L_85B0		;859B D0 13
		ldx #$02		;859D A2 02
.L_859F	lda ZP_F4,X		;859F B5 F4
		clc				;85A1 18
		adc #$38		;85A2 69 38
		sta ZP_F4,X		;85A4 95 F4
		lda ZP_F5,X		;85A6 B5 F5
		adc #$01		;85A8 69 01
		sta ZP_F5,X		;85AA 95 F5
		dex				;85AC CA
		dex				;85AD CA
		bpl L_859F		;85AE 10 EF
.L_85B0	iny				;85B0 C8
		cpy #$08		;85B1 C0 08
		bne L_856F		;85B3 D0 BA
		lda #$01		;85B5 A9 01
		clc				;85B7 18
		adc L_85C5		;85B8 6D C5 85
		cmp #$2D		;85BB C9 2D
		bcc L_85C1		;85BD 90 02
		lda #$00		;85BF A9 00
.L_85C1	sta L_85C5		;85C1 8D C5 85
		rts				;85C4 60
}

.L_85C5	equb $00
.L_85C6	equb $00
.L_85C7	equb $00
.L_85C8	equb $00
.L_85C9	equb $00
.L_85CA	equb $00
.L_85CB	equb $00
.L_85CC	equb $00
.L_85CD	equb $00
.L_85CE	equb $00
.L_85CF	equb $00
.L_85D0	equb $00
.L_85D1	equb $00

; poll for	key.
; entry: X=key number (column in bits 0-3,	row in bits 3-6).
; exit: X=0, Z=1, N=0, if key not pressed;	X=$FF, Z=0, N=1	if key pressed.

.poll_key
{
		lda #$FF		;85D2 A9 FF
		sta CIA1_CIDDRA		;85D4 8D 02 DC
		lda #$00		;85D7 A9 00
		jsr check_debug_keys		;85D9 20 17 08
		txa				;85DC 8A
		and #$07		;85DD 29 07
		tay				;85DF A8
		lda L_85FB,Y	;85E0 B9 FB 85
		eor #$FF		;85E3 49 FF
		sta CIA1_CIAPRA		;85E5 8D 00 DC			; CIA1
		txa				;85E8 8A
		lsr A			;85E9 4A
		lsr A			;85EA 4A
		lsr A			;85EB 4A
		tay				;85EC A8
		ldx #$00		;85ED A2 00
		lda CIA1_CIAPRB		;85EF AD 01 DC
		eor #$FF		;85F2 49 FF
		and L_85FB,Y	;85F4 39 FB 85
		beq L_85FA		;85F7 F0 01
		dex				;85F9 CA
.L_85FA	rts				;85FA 60

.L_85FB	equb $01,$02,$04,$08,$10,$20,$40,$80
}

.getch
{
		stx L_85C8		;8603 8E C8 85
		sty L_85C9		;8606 8C C9 85
.L_8609	ldx L_85CF		;8609 AE CF 85
		jsr poll_key		;860C 20 D2 85
		bmi L_8609		;860F 30 F8
.L_8611	lda #$00		;8611 A9 00
		sta L_85CE		;8613 8D CE 85
		ldx #$39		;8616 A2 39
		jsr poll_key		;8618 20 D2 85
		bmi L_8629		;861B 30 0C
		ldx #$26		;861D A2 26
		jsr poll_key		;861F 20 D2 85
		bmi L_8629		;8622 30 05
		lda #$40		;8624 A9 40
		sta L_85CE		;8626 8D CE 85
.L_8629	ldx #$3F		;8629 A2 3F
.L_862B	stx ZP_FA		;862B 86 FA
		cpx #$39		;862D E0 39
		beq L_863A		;862F F0 09
		cpx #$26		;8631 E0 26
		beq L_863A		;8633 F0 05
		jsr poll_key		;8635 20 D2 85
		bmi L_8641		;8638 30 07
.L_863A	ldx ZP_FA		;863A A6 FA
		dex				;863C CA
		bpl L_862B		;863D 10 EC
		bmi L_8611		;863F 30 D0
.L_8641	lda ZP_FA		;8641 A5 FA
		sta L_85CF		;8643 8D CF 85
		ora L_85CE		;8646 0D CE 85
		tax				;8649 AA
		lda L_9125,X	;864A BD 25 91
		ldx L_85C8		;864D AE C8 85
		ldy L_85C9		;8650 AC C9 85
		clc				;8653 18
		rts				;8654 60
}

; *****************************************************************************
; SID
; *****************************************************************************

.L_8655
{
		stx ZP_F8		;8655 86 F8
		sty ZP_F9		;8657 84 F9
		ldy #$00		;8659 A0 00
		lda (ZP_F8),Y	;865B B1 F8
		tax				;865D AA
		sta L_86C6		;865E 8D C6 86
		lda #$80		;8661 A9 80
		sta L_86C8,X	;8663 9D C8 86
		lda L_86DC,X	;8666 BD DC 86
		tax				;8669 AA
		ldy #$01		;866A A0 01
		lda (ZP_F8),Y	;866C B1 F8
		and #$FE		;866E 29 FE
		sta SID_VCREG1,X	;8670 9D 04 D4	; SID
		ldy #$02		;8673 A0 02
		lda (ZP_F8),Y	;8675 B1 F8
		sta SID_ATDCY1,X	;8677 9D 05 D4	; SID
		iny				;867A C8
		lda (ZP_F8),Y	;867B B1 F8
		sta SID_SUREL1,X	;867D 9D 06 D4	; SID
		lda #$00		;8680 A9 00
		sta SID_PWLO1,X	;8682 9D 02 D4	; SID
		sta SID_FRELO1,X	;8685 9D 00 D4	; SID
		ldy #$05		;8688 A0 05
		lda (ZP_F8),Y	;868A B1 F8
		sta L_86C5		;868C 8D C5 86
		and #$0F		;868F 29 0F
		sta SID_PWHI1,X	;8691 9D 03 D4	; SID
		ldy #$04		;8694 A0 04
		lda (ZP_F8),Y	;8696 B1 F8
		sta SID_FREHI1,X	;8698 9D 01 D4	; SID
		ldy #$01		;869B A0 01
		lda (ZP_F8),Y	;869D B1 F8
		sta SID_VCREG1,X	;869F 9D 04 D4	; SID
		ldx L_86C6		;86A2 AE C6 86
		and #$FE		;86A5 29 FE
		sta L_86D8,X	;86A7 9D D8 86
		ldy #$04		;86AA A0 04
		lda (ZP_F8),Y	;86AC B1 F8
		sta L_86CC,X	;86AE 9D CC 86
		dey				;86B1 88
		lda (ZP_F8),Y	;86B2 B1 F8
		and #$0F		;86B4 29 0F
		tay				;86B6 A8
		lda L_86DF,Y	;86B7 B9 DF 86
		sta L_86D0,X	;86BA 9D D0 86
		ldy #$06		;86BD A0 06
		lda (ZP_F8),Y	;86BF B1 F8
		sta L_86C8,X	;86C1 9D C8 86
		rts				;86C4 60
}

.L_86C5	equb $00
.L_86C6	equb $00,$00
.L_86C8	equb $00,$00,$00,$00
.L_86CC	equb $00,$00,$00,$00
.L_86D0	equb $00,$00,$00,$00
.L_86D4	equb $00,$00,$00,$00
.L_86D8	equb $00,$00,$00,$00
.L_86DC	equb $00,$07,$0E
.L_86DF	equb $01,$02,$03,$03,$06,$09,$0B,$0C,$0F,$26,$4B,$78,$96,$FF,$FF,$FF

.sid_update
{
		ldx #$01		;86EF A2 01
		lda L_86C8,X	;86F1 BD C8 86
		beq L_870C		;86F4 F0 16
		bmi L_8724		;86F6 30 2C
		dec L_86C8,X	;86F8 DE C8 86
		bne L_8724		;86FB D0 27
		ldy L_86DC,X	;86FD BC DC 86
		lda L_86D8,X	;8700 BD D8 86
		sta SID_VCREG1,Y	;8703 99 04 D4	; SID
		lda L_86D0,X	;8706 BD D0 86
		sta L_86D4,X	;8709 9D D4 86
.L_870C	lda L_86D4,X	;870C BD D4 86
		beq L_8724		;870F F0 13
		dec L_86D4,X	;8711 DE D4 86
		bne L_8724		;8714 D0 0E
}
\\
.silence_channel
{
		ldy L_86DC,X	;8716 BC DC 86
		lda #$00		;8719 A9 00
		sta L_86C8,X	;871B 9D C8 86
		sta SID_SUREL1,Y	;871E 99 06 D4	; SID
		sta SID_VCREG1,Y	;8721 99 04 D4	; SID
}
\\
.L_8724	rts				;8724 60

; *****************************************************************************
; LIBRARIES ETC.
; *****************************************************************************

; Various OSBYTE-ish functions
; 
; A=1 -> B&W mode,	screenmem +$3C00, bmp +$0000
; A=2 -> multicolour mode,	screenmem +$1C00, bmp +$2000
; A=$15 ->	silence	SID channel X
; A=$20 ->	store X	in byte_85D0
; A=$32 ->	draw menu header graphic
; A=$34 ->	copy stuff (one	way if X&$80, other way	if not)
; A=$3C ->	update draw bridge
; A=$3D ->	draw horizon
; A=$43 ->	draw tachometer
; A=$45 ->	clear screen
; A=$46 ->	update colour map
; A=$55 ->	fill scanlines (A=value, YX=ptr, byte_52=count)
; A=$81 ->	poll for key X (like OSBYTE $81)

.sysctl		; aka sysctl
{
		cmp #$3C		;8725 C9 3C
		beq L_87A0		;8727 F0 77
		cmp #$3D		;8729 C9 3D
		beq L_87A3		;872B F0 76
		cmp #$3E		;872D C9 3E
		beq L_87A6		;872F F0 75
		cmp #$3F		;8731 C9 3F
		beq L_87A9		;8733 F0 74
		cmp #$40		;8735 C9 40
		beq L_87AC		;8737 F0 73
		cmp #$41		;8739 C9 41
		beq L_87AF		;873B F0 72
		cmp #$42		;873D C9 42
		beq L_87B2		;873F F0 71
		cmp #$43		;8741 C9 43
		beq L_87B5		;8743 F0 70
		cmp #$44		;8745 C9 44
		beq L_87B8		;8747 F0 6F
		cmp #$45		;8749 C9 45
		beq L_87BB		;874B F0 6E
		cmp #$46		;874D C9 46
		beq L_87BE		;874F F0 6D
		cmp #$47		;8751 C9 47
		beq L_87C1		;8753 F0 6C
		cmp #$01		;8755 C9 01
		beq L_8781		;8757 F0 28
		cmp #$02		;8759 C9 02
		beq L_8786		;875B F0 29
		cmp #$03		;875D C9 03
		beq L_8793		;875F F0 32
		cmp #$10		;8761 C9 10
		beq L_878B		;8763 F0 26
		cmp #$20		;8765 C9 20
		beq L_878F		;8767 F0 26
		cmp #$81		;8769 C9 81
		beq L_877E		;876B F0 11
		cmp #$15		;876D C9 15
		beq silence_channel		;876F F0 A5
		cmp #$32		;8771 C9 32
		beq sysctl_copy_menu_header_graphic		;8773 F0 4F
		cmp #$55		;8775 C9 55
		beq L_879A		;8777 F0 21
		cmp #$34		;8779 C9 34
		beq L_879D		;877B F0 20
		rts				;877D 60
}

.L_877E	jmp poll_key		;877E 4C D2 85

.L_8781	sta ZP_FE			;8781 85 FE
		jmp non_multicolour_mode			;8783 4C CC 83

.L_8786	sta ZP_FE			;8786 85 FE
		jmp multicolour_mode			;8788 4C C0 83

.L_878B	txa					;878B 8A
		jmp L_8428			;878C 4C 28 84

.L_878F	stx L_85D0			;878F 8E D0 85
		rts				;8792 60

.L_8793	lda #$02			;8793 A9 02
		sta ZP_FE			;8795 85 FE
		jmp L_83F7_with_vic			;8797 4C F7 83

.L_879A	jmp fill_64s		;879A 4C 21 89
.L_879D	jmp copy_stuff		;879D 4C 6A 88		BEEB TODO copy_stuff
.L_87A0	jmp move_draw_bridgeQ		;87A0 4C 4A 89
.L_87A3	jmp draw_horizonQ		;87A3 4C 2F 8A
.L_87A6	jmp L_8AA5		;87A6 4C A5 8A
.L_87A9	jmp draw_crane		;87A9 4C 51 8B
.L_87AC	jmp L_8C0D		;87AC 4C 0D 8C
.L_87AF	jmp L_8CD0		;87AF 4C D0 8C
.L_87B2	jmp L_8D15		;87B2 4C 15 8D
.L_87B5	jmp draw_tachometer		;87B5 4C 77 8E
.L_87B8	jmp L_8F11		;87B8 4C 11 8F
.L_87BB	jmp clear_screen		;87BB 4C 82 8F
.L_87BE	jmp update_colour_map		;87BE 4C 57 90
.L_87C1	jmp sysctl_47		;87C1 4C BB 90

.sysctl_copy_menu_header_graphic
{
		lda #$00		;87C4 A9 00
		sta VIC_IRQMASK		;87C6 8D 1A D0
		sei				;87C9 78
		lda #$34		;87CA A9 34
		sta RAM_SELECT		;87CC 85 01
		lda #$40		;87CE A9 40
		sta ZP_1E		;87D0 85 1E
		lda #$D4		;87D2 A9 D4
		sta ZP_1F		;87D4 85 1F
		ldx #$00		;87D6 A2 00
.L_87D8	ldy #$00		;87D8 A0 00
		lda SID_FRELO1,X	;87DA BD 00 D4	; SID
		sta ZP_08		;87DD 85 08
		bne L_87E2		;87DF D0 01
		iny				;87E1 C8
.L_87E2	sty ZP_16		;87E2 84 16
		lda SID_FREHI1,X	;87E4 BD 01 D4	; SID
		sta ZP_20		;87E7 85 20
		lda SID_PWLO1,X	;87E9 BD 02 D4	; SID
		sta ZP_21		;87EC 85 21
		ldy #$00		;87EE A0 00
.L_87F0	lda (ZP_1E),Y	;87F0 B1 1E
		sta (ZP_20),Y	;87F2 91 20
		iny				;87F4 C8
		cpy ZP_08		;87F5 C4 08
		bne L_87F0		;87F7 D0 F7
		lda ZP_1E		;87F9 A5 1E
		clc				;87FB 18
		adc ZP_08		;87FC 65 08
		sta ZP_1E		;87FE 85 1E
		lda ZP_1F		;8800 A5 1F
		adc ZP_16		;8802 65 16
		sta ZP_1F		;8804 85 1F
		inx				;8806 E8
		inx				;8807 E8
		inx				;8808 E8
		cpx #$27		;8809 E0 27
		bne L_87D8		;880B D0 CB
		lda ZP_1E		;880D A5 1E
		clc				;880F 18
		adc #$40		;8810 69 40
		sta ZP_20		;8812 85 20
		lda ZP_1F		;8814 A5 1F
		adc #$01		;8816 69 01
		sta ZP_21		;8818 85 21
		ldy #$00		;881A A0 00
.L_881C	lda (ZP_1E),Y	;881C B1 1E
		sta L_7C00,Y	;881E 99 00 7C
		lda (ZP_20),Y	;8821 B1 20
		sta L_0400,Y	;8823 99 00 04
		dey				;8826 88
		bne L_881C		;8827 D0 F3
		inc ZP_1F		;8829 E6 1F
		inc ZP_21		;882B E6 21
		ldy #$3F		;882D A0 3F
.L_882F	lda (ZP_1E),Y	;882F B1 1E
		sta L_7D00,Y	;8831 99 00 7D
		lda (ZP_20),Y	;8834 B1 20
		sta L_0500,Y	;8836 99 00 05
		dey				;8839 88
		bpl L_882F		;883A 10 F3
		lda #$11		;883C A9 11
		sta ZP_52		;883E 85 52
		ldy #$4A		;8840 A0 4A
		ldx #$00		;8842 A2 00
		lda #$00		;8844 A9 00
		jsr fill_64s		;8846 20 21 89
		lda #$35		;8849 A9 35
		sta RAM_SELECT		;884B 85 01
		cli				;884D 58
		lda #$01		;884E A9 01
		sta VIC_IRQMASK		;8850 8D 1A D0
		ldx #$00		;8853 A2 00
.L_8855	lda L_0400,X	;8855 BD 00 04
		sta L_D800,X	;8858 9D 00 D8
		dex				;885B CA
		bne L_8855		;885C D0 F7
		ldx #$3F		;885E A2 3F
.L_8860	lda L_0500,X	;8860 BD 00 05
		sta L_D900,X	;8863 9D 00 D9
		dex				;8866 CA
		bpl L_8860		;8867 10 F7
		rts				;8869 60
}

; If X bit	7 set, copy $62A0->$57C0, $6DE0->$D800
; If X bit	7 reset, copy $57C0->$6200, $D800->$6DE0, $D000(RAM)
.copy_stuff
{
		stx ZP_16		;886A 86 16
		lda #$57		;886C A9 57
		sta ZP_1F		;886E 85 1F
		lda #$C0		;8870 A9 C0
		sta ZP_1E		;8872 85 1E
		lda #$62		;8874 A9 62
		sta ZP_21		;8876 85 21
		lda #$A0		;8878 A9 A0
		sta ZP_20		;887A 85 20
		ldx #$08		;887C A2 08
.L_887E	ldy #$FF		;887E A0 FF
.L_8880	bit ZP_16		;8880 24 16
		bmi L_888B		;8882 30 07
		lda (ZP_1E),Y	;8884 B1 1E
		sta (ZP_20),Y	;8886 91 20
		jmp L_888F		;8888 4C 8F 88
.L_888B	lda (ZP_20),Y	;888B B1 20
		sta (ZP_1E),Y	;888D 91 1E
.L_888F	dey				;888F 88
		cpy #$FF		;8890 C0 FF
		bne L_8880		;8892 D0 EC
		lda ZP_20		;8894 A5 20
		clc				;8896 18
		adc #$40		;8897 69 40
		sta ZP_20		;8899 85 20
		lda ZP_21		;889B A5 21
		adc #$01		;889D 69 01
		sta ZP_21		;889F 85 21
		inc ZP_1F		;88A1 E6 1F
		dex				;88A3 CA
		bmi L_88AC		;88A4 30 06
		bne L_887E		;88A6 D0 D6
		ldy #$3F		;88A8 A0 3F
		bne L_8880		;88AA D0 D4
.L_88AC	ldx #$00		;88AC A2 00
		bit ZP_16		;88AE 24 16
		bmi L_88CE		;88B0 30 1C
.L_88B2	lda L_D800,X	;88B2 BD 00 D8
		sta L_6DE0,X	;88B5 9D E0 6D
		lda L_D900,X	;88B8 BD 00 D9
		sta L_6F20,X	;88BB 9D 20 6F
		lda L_DA00,X	;88BE BD 00 DA
		sta L_7060,X	;88C1 9D 60 70
		lda L_DB00,X	;88C4 BD 00 DB		; COLOR RAM
		sta L_71A0,X	;88C7 9D A0 71
		dex				;88CA CA
		bne L_88B2		;88CB D0 E5
		rts				;88CD 60
.L_88CE	lda L_6DE0,X	;88CE BD E0 6D
		sta L_D800,X	;88D1 9D 00 D8
		lda L_6F20,X	;88D4 BD 20 6F
		sta L_D900,X	;88D7 9D 00 D9
		lda L_7060,X	;88DA BD 60 70
		sta L_DA00,X	;88DD 9D 00 DA
		lda L_71A0,X	;88E0 BD A0 71
		sta L_DB00,X	;88E3 9D 00 DB		; COLOR RAM
		dex				;88E6 CA
		bne L_88CE		;88E7 D0 E5
		lda #$00		;88E9 A9 00
		sta VIC_IRQMASK		;88EB 8D 1A D0
		sei				;88EE 78
		lda #$34		;88EF A9 34
		sta RAM_SELECT		;88F1 85 01
		ldx #$00		;88F3 A2 00
.L_88F5	lda VIC_SP0X,X	;88F5 BD 00 D0
		sta L_7C00,X	;88F8 9D 00 7C
		lda L_D100,X	;88FB BD 00 D1
		sta L_7D00,X	;88FE 9D 00 7D
		lda L_D200,X	;8901 BD 00 D2
		sta L_7E00,X	;8904 9D 00 7E
		lda L_D300,X	;8907 BD 00 D3
		sta L_7F00,X	;890A 9D 00 7F
		lda CIA2_CI2PRA,X	;890D BD 00 DD
		sta L_7B00,X	;8910 9D 00 7B
		dex				;8913 CA
		bne L_88F5		;8914 D0 DF
		lda #$35		;8916 A9 35
		sta RAM_SELECT		;8918 85 01
		cli				;891A 58
		lda #$01		;891B A9 01
		sta VIC_IRQMASK		;891D 8D 1A D0
		rts				;8920 60
}

; fill scanlines
; entry: A=byte to	write, X=LSB of	dest, Y=MSB of dest, byte_52=# lines
.fill_64s
{
		stx ZP_1E		;8921 86 1E
		sty ZP_1F		;8923 84 1F
		sta ZP_14		;8925 85 14
		ldx ZP_52		;8927 A6 52
.L_8929	ldy #$00		;8929 A0 00
		lda ZP_14		;892B A5 14
.L_892D	sta (ZP_1E),Y	;892D 91 1E
		dey				;892F 88
		bne L_892D		;8930 D0 FB
		inc ZP_1F		;8932 E6 1F
		ldy #$3F		;8934 A0 3F
.L_8936	sta (ZP_1E),Y	;8936 91 1E
		dey				;8938 88
		bpl L_8936		;8939 10 FB
		lda ZP_1E		;893B A5 1E
		clc				;893D 18
		adc #$40		;893E 69 40
		sta ZP_1E		;8940 85 1E
		bcc L_8946		;8942 90 02
		inc ZP_1F		;8944 E6 1F
.L_8946	dex				;8946 CA
		bne L_8929		;8947 D0 E0
		rts				;8949 60
}

.move_draw_bridgeQ
{
		lda L_C374		;894A AD 74 C3
		cmp #$38		;894D C9 38
		bcs L_8955		;894F B0 04
		cmp #$33		;8951 C9 33
		bcs L_8968		;8953 B0 13
.L_8955	lda L_C375		;8955 AD 75 C3
		cmp #$38		;8958 C9 38
		bcs L_8973		;895A B0 17
		cmp #$33		;895C C9 33
		bcs L_8968		;895E B0 08
		ldy ZP_E7		;8960 A4 E7
		beq L_8973		;8962 F0 0F
		cmp #$30		;8964 C9 30
		bcc L_8973		;8966 90 0B
.L_8968	lda #$0C		;8968 A9 0C
		sta ZP_E7		;896A 85 E7
		clc				;896C 18
		adc L_C300		;896D 6D 00 C3
		jmp L_89FA		;8970 4C FA 89
.L_8973	inc L_C300		;8973 EE 00 C3
		lda #$00		;8976 A9 00
		sta ZP_7D		;8978 85 7D
		sta ZP_7F		;897A 85 7F
		sta ZP_E7		;897C 85 E7
		lda L_C300		;897E AD 00 C3
		and #$1F		;8981 29 1F
		sec				;8983 38
		sbc #$10		;8984 E9 10
		bpl L_898A		;8986 10 02
		eor #$FF		;8988 49 FF
.L_898A	tay				;898A A8
		clc				;898B 18
		adc #$04		;898C 69 04
		sta ZP_14		;898E 85 14
		lda L_8A1F,Y	;8990 B9 1F 8A
		sta L_0743		;8993 8D 43 07
		sta L_0744		;8996 8D 44 07
		lda #$00		;8999 A9 00
		ldy #$05		;899B A0 05
.L_899D	asl ZP_14		;899D 06 14
		rol A			;899F 2A
		dey				;89A0 88
		bne L_899D		;89A1 D0 FA
		sta ZP_77		;89A3 85 77
		lda ZP_14		;89A5 A5 14
		sta ZP_51		;89A7 85 51
		ldy #$02		;89A9 A0 02
		ldx #$BE		;89AB A2 BE
		lda L_B120,X	;89AD BD 20 B1
		sta ZP_1E		;89B0 85 1E
		lda L_B121,X	;89B2 BD 21 B1
		sta ZP_1F		;89B5 85 1F
		ldx #$0F		;89B7 A2 0F
.L_89B9	lda ZP_7D		;89B9 A5 7D
		clc				;89BB 18
		adc ZP_51		;89BC 65 51
		sta ZP_7D		;89BE 85 7D
		lda ZP_7F		;89C0 A5 7F
		adc ZP_77		;89C2 65 77
		sta ZP_7F		;89C4 85 7F
.L_89C6	lda ZP_7F		;89C6 A5 7F
		cpy #$20		;89C8 C0 20
		bne L_89CE		;89CA D0 02
		ora #$80		;89CC 09 80
.L_89CE	pha				;89CE 48
		sta (ZP_1E),Y	;89CF 91 1E
		iny				;89D1 C8
		lda ZP_7D		;89D2 A5 7D
		sta (ZP_1E),Y	;89D4 91 1E
		iny				;89D6 C8
		sty ZP_14		;89D7 84 14
		lda #$48		;89D9 A9 48
		sec				;89DB 38
		sbc ZP_14		;89DC E5 14
		tay				;89DE A8
		pla				;89DF 68
		sta (ZP_1E),Y	;89E0 91 1E
		iny				;89E2 C8
		lda ZP_7D		;89E3 A5 7D
		sta (ZP_1E),Y	;89E5 91 1E
		ldy ZP_14		;89E7 A4 14
		cpy #$12		;89E9 C0 12
		beq L_89C6		;89EB F0 D9
		dex				;89ED CA
		bne L_89B9		;89EE D0 C9
		lda L_C375		;89F0 AD 75 C3
		cmp #$2F		;89F3 C9 2F
		bne L_8A0E		;89F5 D0 17
		lda L_C300		;89F7 AD 00 C3
.L_89FA	and #$1F		;89FA 29 1F
		lsr A			;89FC 4A
		tay				;89FD A8
		ldx #$00		;89FE A2 00
		lda #$C6		;8A00 A9 C6
.L_8A02	clc				;8A02 18
		adc L_8A0F,Y	;8A03 79 0F 8A
		sta L_0740,X	;8A06 9D 40 07
		inx				;8A09 E8
		cpx #$03		;8A0A E0 03
		bne L_8A02		;8A0C D0 F4
.L_8A0E	rts				;8A0E 60

.L_8A0F	equb $F7,$F7,$F6,$F6,$F5,$F5,$F6,$F7,$F8,$F9,$FB,$FD,$FF,$02,$05,$FD
.L_8A1F	equb $D2,$BB,$B7,$B3,$B1,$AD,$AB,$A7,$A6,$A4,$A2,$A1,$9F,$9F,$9F,$9E
}

.draw_horizonQ
{
		ldy #$3F		;8A2F A0 3F
		ldx #$01		;8A31 A2 01
		lda #$00		;8A33 A9 00
		sec				;8A35 38
		sbc ZP_33		;8A36 E5 33
		sta ZP_14		;8A38 85 14
		lda #$00		;8A3A A9 00
		sbc ZP_69		;8A3C E5 69
		bmi L_8A44		;8A3E 30 04
		lda #$FF		;8A40 A9 FF
		bne L_8A4A		;8A42 D0 06
.L_8A44	cmp #$FF		;8A44 C9 FF
		beq L_8A4C		;8A46 F0 04
		lda #$00		;8A48 A9 00
.L_8A4A	sta ZP_14		;8A4A 85 14
.L_8A4C	lda ZP_14		;8A4C A5 14
		bit L_0126		;8A4E 2C 26 01
		bmi L_8A7C		;8A51 30 29
.L_8A53	lda ZP_14		;8A53 A5 14
		sec				;8A55 38
		sbc L_0380,Y	;8A56 F9 80 03
		bcs L_8A5D		;8A59 B0 02
		lda #$00		;8A5B A9 00
.L_8A5D	cmp L_C680,Y	;8A5D D9 80 C6
		bcs L_8A65		;8A60 B0 03
		sta L_C680,Y	;8A62 99 80 C6
.L_8A65	lda ZP_14		;8A65 A5 14
		clc				;8A67 18
		adc L_0380,X	;8A68 7D 80 03
		bcc L_8A6F		;8A6B 90 02
		lda #$FF		;8A6D A9 FF
.L_8A6F	cmp L_C640,Y	;8A6F D9 40 C6
		bcs L_8A77		;8A72 B0 03
		sta L_C640,Y	;8A74 99 40 C6
.L_8A77	inx				;8A77 E8
		dey				;8A78 88
		bpl L_8A53		;8A79 10 D8
		rts				;8A7B 60
.L_8A7C	lda ZP_14		;8A7C A5 14
		clc				;8A7E 18
		adc L_0380,Y	;8A7F 79 80 03
		bcc L_8A86		;8A82 90 02
		lda #$FF		;8A84 A9 FF
.L_8A86	cmp L_C680,Y	;8A86 D9 80 C6
		bcs L_8A8E		;8A89 B0 03
		sta L_C680,Y	;8A8B 99 80 C6
.L_8A8E	lda ZP_14		;8A8E A5 14
		sec				;8A90 38
		sbc L_0380,X	;8A91 FD 80 03
		bcs L_8A98		;8A94 B0 02
		lda #$00		;8A96 A9 00
.L_8A98	cmp L_C640,Y	;8A98 D9 40 C6
		bcs L_8AA0		;8A9B B0 03
		sta L_C640,Y	;8A9D 99 40 C6
.L_8AA0	inx				;8AA0 E8
		dey				;8AA1 88
		bpl L_8A7C		;8AA2 10 D8
		rts				;8AA4 60
}

.L_8AA5
{
		ldx #$40		;8AA5 A2 40
.L_8AA7	lda L_C600,X	;8AA7 BD 00 C6
		sta ZP_13		;8AAA 85 13
		tay				;8AAC A8
		lda L_C601,X	;8AAD BD 01 C6
		sta ZP_14		;8AB0 85 14
		cpy ZP_14		;8AB2 C4 14
		bcs L_8AB7		;8AB4 B0 01
		tay				;8AB6 A8
.L_8AB7	lda L_C602,X	;8AB7 BD 02 C6
		sta ZP_15		;8ABA 85 15
		cpy ZP_15		;8ABC C4 15
		bcs L_8AC1		;8ABE B0 01
		tay				;8AC0 A8
.L_8AC1	lda L_C603,X	;8AC1 BD 03 C6
		sta ZP_16		;8AC4 85 16
		cpy ZP_16		;8AC6 C4 16
		bcs L_8ACB		;8AC8 B0 01
		tay				;8ACA A8
.L_8ACB	cpy #$40		;8ACB C0 40
		bcc L_8B4A		;8ACD 90 7B
		cpy #$C0		;8ACF C0 C0
		bcc L_8AD6		;8AD1 90 03
		ldy #$C0		;8AD3 A0 C0
		dey				;8AD5 88
.L_8AD6	txa				;8AD6 8A
		sec				;8AD7 38
		sbc #$40		;8AD8 E9 40
		and #$7C		;8ADA 29 7C
		asl A			;8ADC 0A
		adc Q_pointers_LO,Y	;8ADD 79 00 A5
		sta ZP_1E		;8AE0 85 1E
		lda Q_pointers_HI,Y	;8AE2 B9 00 A6
		adc ZP_12		;8AE5 65 12
		sta ZP_1F		;8AE7 85 1F
.L_8AE9	lda #$FF		;8AE9 A9 FF
		cpy ZP_13		;8AEB C4 13
		bcs L_8AF1		;8AED B0 02
		and #$BF		;8AEF 29 BF
.L_8AF1	cpy ZP_14		;8AF1 C4 14
		bcs L_8AF7		;8AF3 B0 02
		and #$EF		;8AF5 29 EF
.L_8AF7	cpy ZP_15		;8AF7 C4 15
		bcs L_8AFD		;8AF9 B0 02
		and #$FB		;8AFB 29 FB
.L_8AFD	cpy ZP_16		;8AFD C4 16
		bcs L_8B03		;8AFF B0 02
		and #$FE		;8B01 29 FE
.L_8B03	cmp #$AA		;8B03 C9 AA
		beq L_8B34		;8B05 F0 2D
		and (ZP_1E),Y	;8B07 31 1E
		sta (ZP_1E),Y	;8B09 91 1E
		tya				;8B0B 98
		dey				;8B0C 88
		and #$07		;8B0D 29 07
		bne L_8AE9		;8B0F D0 D8
		cpy #$40		;8B11 C0 40
		bcc L_8B4A		;8B13 90 35
		lda ZP_1E		;8B15 A5 1E
		sec				;8B17 38
		sbc #$38		;8B18 E9 38
		sta ZP_1E		;8B1A 85 1E
		lda ZP_1F		;8B1C A5 1F
		sbc #$01		;8B1E E9 01
		sta ZP_1F		;8B20 85 1F
		jmp L_8AE9		;8B22 4C E9 8A
.L_8B25	txa				;8B25 8A
		clc				;8B26 18
		adc #$04		;8B27 69 04
		tax				;8B29 AA
		cpx #$C0		;8B2A E0 C0
		bcs L_8B31		;8B2C B0 03
		jmp L_8AA7		;8B2E 4C A7 8A
.L_8B31	rts				;8B31 60
.L_8B32	lda #$AA		;8B32 A9 AA
.L_8B34	sta (ZP_1E),Y	;8B34 91 1E
		tya				;8B36 98
		dey				;8B37 88
		and #$07		;8B38 29 07
		bne L_8B32		;8B3A D0 F6
		cpy #$40		;8B3C C0 40
		bcc L_8B4A		;8B3E 90 0A
		tya				;8B40 98
		lsr A			;8B41 4A
		lsr A			;8B42 4A
		lsr A			;8B43 4A
		sta L_01C1,X	;8B44 9D C1 01
		jmp L_8B25		;8B47 4C 25 8B
.L_8B4A	lda #$07		;8B4A A9 07
		sta L_01C1,X	;8B4C 9D C1 01
		bne L_8B25		;8B4F D0 D4
}
\\
.draw_crane
{
		lda ZP_2F		;8B51 A5 2F
		bne L_8B6C		;8B53 D0 17
		lda L_C36B		;8B55 AD 6B C3
		cmp #$5F		;8B58 C9 5F
		beq L_8B76		;8B5A F0 1A
		sec				;8B5C 38
		sbc L_C36C		;8B5D ED 6C C3
		sta L_C36B		;8B60 8D 6B C3
		lda L_C36C		;8B63 AD 6C C3
		clc				;8B66 18
		adc #$08		;8B67 69 08
		sta L_C36C		;8B69 8D 6C C3
.L_8B6C	ldx #$54		;8B6C A2 54
		jsr L_8B77		;8B6E 20 77 8B
		ldx #$A8		;8B71 A2 A8
		jsr L_8B77		;8B73 20 77 8B
.L_8B76	rts				;8B76 60
.L_8B77	stx ZP_4F		;8B77 86 4F
		ldy #$0F		;8B79 A0 0F
		sty ZP_50		;8B7B 84 50
		ldy L_C36B		;8B7D AC 6B C3
.L_8B80	ldx ZP_4F		;8B80 A6 4F
		txa				;8B82 8A
		sec				;8B83 38
		sbc #$40		;8B84 E9 40
		and #$7C		;8B86 29 7C
		asl A			;8B88 0A
		adc Q_pointers_LO,Y	;8B89 79 00 A5
		sta ZP_1E		;8B8C 85 1E
		lda Q_pointers_HI,Y	;8B8E B9 00 A6
		adc ZP_12		;8B91 65 12
		sta ZP_1F		;8B93 85 1F
		lda ZP_1E		;8B95 A5 1E
		clc				;8B97 18
		adc #$08		;8B98 69 08
		sta ZP_20		;8B9A 85 20
		lda ZP_1F		;8B9C A5 1F
		adc #$00		;8B9E 69 00
		sta ZP_21		;8BA0 85 21
		ldx ZP_50		;8BA2 A6 50
		lda #$08		;8BA4 A9 08
		sta ZP_14		;8BA6 85 14
.L_8BA8	lda (ZP_1E),Y	;8BA8 B1 1E
		and L_8BCD,X	;8BAA 3D CD 8B
		ora L_8BED,X	;8BAD 1D ED 8B
		sta (ZP_1E),Y	;8BB0 91 1E
		lda (ZP_20),Y	;8BB2 B1 20
		and L_8BDD,X	;8BB4 3D DD 8B
		ora L_8BFD,X	;8BB7 1D FD 8B
		sta (ZP_20),Y	;8BBA 91 20
		dey				;8BBC 88
		dex				;8BBD CA
		dec ZP_14		;8BBE C6 14
		bne L_8BA8		;8BC0 D0 E6
		lda ZP_50		;8BC2 A5 50
		eor #$08		;8BC4 49 08
		sta ZP_50		;8BC6 85 50
		cpy #$40		;8BC8 C0 40
		bcs L_8B80		;8BCA B0 B4
		rts				;8BCC 60
		
.L_8BCD	equb $F3,$F3,$C0,$00,$00,$33,$3F,$3F,$3F,$3F,$33,$00,$00,$C0,$F3,$F3
.L_8BDD	equb $FF,$FF,$FF,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$FF,$FF,$FF
.L_8BED	equb $00,$00,$01,$40,$00,$00,$00,$00,$00,$00,$04,$15,$04,$04,$04,$04
.L_8BFD	equb $00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
}

.L_8C0D
{
		lda #$D9		;8C0D A9 D9
		sec				;8C0F 38
		sbc ZP_14		;8C10 E5 14
		ldy #$07		;8C12 A0 07
		cpx #$01		;8C14 E0 01
		beq L_8C44		;8C16 F0 2C
		tax				;8C18 AA
.L_8C19	cpy #$04		;8C19 C0 04
		bcc L_8C26		;8C1B 90 09
		lda L_8C70,X	;8C1D BD 70 8C
		sta L_7560,Y	;8C20 99 60 75
		sta L_5560,Y	;8C23 99 60 55
.L_8C26	lda L_8C78,X	;8C26 BD 78 8C
		sta L_76A0,Y	;8C29 99 A0 76
		sta L_56A0,Y	;8C2C 99 A0 56
		lda L_8C80,X	;8C2F BD 80 8C
		cpy #$06		;8C32 C0 06
		bcc L_8C3A		;8C34 90 04
		bne L_8C3D		;8C36 D0 05
		ora #$01		;8C38 09 01
.L_8C3A	sta L_77E0,Y	;8C3A 99 E0 77
.L_8C3D	dex				;8C3D CA
		dey				;8C3E 88
		bpl L_8C19		;8C3F 10 D8
		ldx #$00		;8C41 A2 00
		rts				;8C43 60
.L_8C44	tax				;8C44 AA
.L_8C45	cpy #$04		;8C45 C0 04
		bcc L_8C52		;8C47 90 09
		lda L_8C94,X	;8C49 BD 94 8C
		sta L_7658,Y	;8C4C 99 58 76
		sta L_5658,Y	;8C4F 99 58 56
.L_8C52	lda L_8C9C,X	;8C52 BD 9C 8C
		sta L_7798,Y	;8C55 99 98 77
		sta L_5798,Y	;8C58 99 98 57
		lda L_8CA4,X	;8C5B BD A4 8C
		cpy #$06		;8C5E C0 06
		bcc L_8C66		;8C60 90 04
		bne L_8C69		;8C62 D0 05
		ora #$40		;8C64 09 40
.L_8C66	sta L_78D8,Y	;8C66 99 D8 78
.L_8C69	dex				;8C69 CA
		dey				;8C6A 88
		bpl L_8C45		;8C6B 10 D8
		ldx #$01		;8C6D A2 01
		rts				;8C6F 60
		
.L_8C70	equb $00,$00,$00,$00,$00,$00,$00,$00
.L_8C78	equb $00,$00,$00,$00,$00,$00,$00,$00
.L_8C80	equb $00,$00,$00,$00,$00,$00,$00,$00,$AC,$AC,$B0,$B0,$B0,$B0,$B0,$C0
		equb $C0,$C0,$C0,$00
.L_8C94	equb $00,$00,$00,$00,$00,$00,$00,$00
.L_8C9C	equb $00,$00,$00,$00,$00,$00,$00,$00
.L_8CA4	equb $00,$00,$00,$00,$00,$00,$00,$00,$1A,$1A,$0E,$0E,$0E,$0E,$0E,$03
		equb $03,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
}

.L_8CD0
{
		lda ZP_61		;8CD0 A5 61
		cmp #$C0		;8CD2 C9 C0
		bcc L_8CD8		;8CD4 90 02
		lda #$BF		;8CD6 A9 BF
.L_8CD8	sta ZP_61		;8CD8 85 61
		lda ZP_60		;8CDA A5 60
		cmp #$40		;8CDC C9 40
		bcs L_8CE2		;8CDE B0 02
		lda #$40		;8CE0 A9 40
.L_8CE2	sta ZP_60		;8CE2 85 60
		cmp ZP_61		;8CE4 C5 61
		beq L_8CEA		;8CE6 F0 02
		bcs L_8D0F		;8CE8 B0 25
.L_8CEA	and #$FC		;8CEA 29 FC
		sta ZP_41		;8CEC 85 41
		lda ZP_61		;8CEE A5 61
		clc				;8CF0 18
		adc #$04		;8CF1 69 04
		and #$FC		;8CF3 29 FC
		sta ZP_55		;8CF5 85 55
		ldx ZP_41		;8CF7 A6 41
.L_8CF9	lda L_0240,X	;8CF9 BD 40 02
		bne L_8D03		;8CFC D0 05
		lda #$C0		;8CFE A9 C0
		sta L_C500,X	;8D00 9D 00 C5
.L_8D03	clc				;8D03 18
		adc #$01		;8D04 69 01
		sta L_0240,X	;8D06 9D 40 02
		inx				;8D09 E8
		cpx ZP_55		;8D0A E4 55
		bcc L_8CF9		;8D0C 90 EB
		rts				;8D0E 60
.L_8D0F	lsr ZP_6D		;8D0F 46 6D
		lsr L_C303		;8D11 4E 03 C3
		rts				;8D14 60
}

.L_8D15
{
		lsr ZP_6D		;8D15 46 6D
		ldx ZP_41		;8D17 A6 41
.L_8D19	stx ZP_51		;8D19 86 51
		lda L_C600,X	;8D1B BD 00 C6
		cmp L_C601,X	;8D1E DD 01 C6
		bcs L_8D26		;8D21 B0 03
		lda L_C601,X	;8D23 BD 01 C6
.L_8D26	cmp L_C602,X	;8D26 DD 02 C6
		bcs L_8D2E		;8D29 B0 03
		lda L_C602,X	;8D2B BD 02 C6
.L_8D2E	cmp L_C603,X	;8D2E DD 03 C6
		bcs L_8D36		;8D31 B0 03
		lda L_C603,X	;8D33 BD 03 C6
.L_8D36	sta ZP_50		;8D36 85 50
		cmp #$41		;8D38 C9 41
		bcs L_8D3F		;8D3A B0 03
		jmp L_8DE8		;8D3C 4C E8 8D
.L_8D3F	jsr L_8DF6		;8D3F 20 F6 8D
		ldy ZP_50		;8D42 A4 50
		txa				;8D44 8A
		sec				;8D45 38
		sbc #$40		;8D46 E9 40
		and #$7C		;8D48 29 7C
		asl A			;8D4A 0A
		adc Q_pointers_LO,Y	;8D4B 79 00 A5
		sta ZP_1E		;8D4E 85 1E
		lda Q_pointers_HI,Y	;8D50 B9 00 A6
		adc ZP_12		;8D53 65 12
		sta ZP_1F		;8D55 85 1F
		lda L_C400,Y	;8D57 B9 00 C4
		and #$0F		;8D5A 29 0F
		sta ZP_29		;8D5C 85 29
		bne L_8D82		;8D5E D0 22
		lda L_0240,X	;8D60 BD 40 02
		cmp L_C600,X	;8D63 DD 00 C6
		bcc L_8D80		;8D66 90 18
		lda L_0241,X	;8D68 BD 41 02
		cmp L_C601,X	;8D6B DD 01 C6
		bcc L_8D80		;8D6E 90 10
		lda L_0242,X	;8D70 BD 42 02
		cmp L_C602,X	;8D73 DD 02 C6
		bcc L_8D80		;8D76 90 08
		lda L_0243,X	;8D78 BD 43 02
		cmp L_C603,X	;8D7B DD 03 C6
		bcs L_8DE3		;8D7E B0 63
.L_8D80	lda #$00		;8D80 A9 00
.L_8D82	tax				;8D82 AA
		lda L_8E67,X	;8D83 BD 67 8E
		sta ZP_2A		;8D86 85 2A
		jmp L_8DC5		;8D88 4C C5 8D
.L_8D8B	lda #$AA		;8D8B A9 AA
.L_8D8D	sta (ZP_1E),Y	;8D8D 91 1E
		dey				;8D8F 88
		ldx L_C400,Y	;8D90 BE 00 C4
		beq L_8D8D		;8D93 F0 F8
		bpl L_8DAE		;8D95 10 17
		lda ZP_1E		;8D97 A5 1E
		sec				;8D99 38
		sbc #$38		;8D9A E9 38
		sta ZP_1E		;8D9C 85 1E
		lda ZP_1F		;8D9E A5 1F
		sbc #$01		;8DA0 E9 01
		sta ZP_1F		;8DA2 85 1F
		txa				;8DA4 8A
		and #$7F		;8DA5 29 7F
		beq L_8D8B		;8DA7 F0 E2
		cmp #$10		;8DA9 C9 10
		bcs L_8DE3		;8DAB B0 36
		tax				;8DAD AA
.L_8DAE	txa				;8DAE 8A
.L_8DAF	eor ZP_29		;8DAF 45 29
		sta ZP_29		;8DB1 85 29
		beq L_8DE3		;8DB3 F0 2E
		cmp #$0F		;8DB5 C9 0F
		beq L_8D8B		;8DB7 F0 D2
		tax				;8DB9 AA
		lda L_8E67,X	;8DBA BD 67 8E
		sta ZP_2A		;8DBD 85 2A
.L_8DBF	lda (ZP_1E),Y	;8DBF B1 1E
		and ZP_2A		;8DC1 25 2A
		sta (ZP_1E),Y	;8DC3 91 1E
.L_8DC5	dey				;8DC5 88
		ldx L_C400,Y	;8DC6 BE 00 C4
		beq L_8DBF		;8DC9 F0 F4
		bpl L_8DAE		;8DCB 10 E1
		lda ZP_1E		;8DCD A5 1E
		sec				;8DCF 38
		sbc #$38		;8DD0 E9 38
		sta ZP_1E		;8DD2 85 1E
		lda ZP_1F		;8DD4 A5 1F
		sbc #$01		;8DD6 E9 01
		sta ZP_1F		;8DD8 85 1F
		txa				;8DDA 8A
		and #$7F		;8DDB 29 7F
		beq L_8DBF		;8DDD F0 E0
		cmp #$10		;8DDF C9 10
		bcc L_8DAF		;8DE1 90 CC
.L_8DE3	ldx ZP_51		;8DE3 A6 51
		jsr L_8DF6		;8DE5 20 F6 8D
.L_8DE8	lda ZP_51		;8DE8 A5 51
		clc				;8DEA 18
		adc #$04		;8DEB 69 04
		tax				;8DED AA
		cmp ZP_55		;8DEE C5 55
		bcs L_8DF5		;8DF0 B0 03
		jmp L_8D19		;8DF2 4C 19 8D
.L_8DF5	rts				;8DF5 60
.L_8DF6	ldy L_0240,X	;8DF6 BC 40 02
		tya				;8DF9 98
		cmp L_C600,X	;8DFA DD 00 C6
		bcs L_8E12		;8DFD B0 13
		lda L_C3FF,Y	;8DFF B9 FF C3
		eor #$08		;8E02 49 08
		sta L_C3FF,Y	;8E04 99 FF C3
		ldy L_C600,X	;8E07 BC 00 C6
		lda L_C400,Y	;8E0A B9 00 C4
		eor #$08		;8E0D 49 08
		sta L_C400,Y	;8E0F 99 00 C4
.L_8E12	ldy L_0241,X	;8E12 BC 41 02
		tya				;8E15 98
		cmp L_C601,X	;8E16 DD 01 C6
		bcs L_8E2E		;8E19 B0 13
		lda L_C3FF,Y	;8E1B B9 FF C3
		eor #$04		;8E1E 49 04
		sta L_C3FF,Y	;8E20 99 FF C3
		ldy L_C601,X	;8E23 BC 01 C6
		lda L_C400,Y	;8E26 B9 00 C4
		eor #$04		;8E29 49 04
		sta L_C400,Y	;8E2B 99 00 C4
.L_8E2E	ldy L_0242,X	;8E2E BC 42 02
		tya				;8E31 98
		cmp L_C602,X	;8E32 DD 02 C6
		bcs L_8E4A		;8E35 B0 13
		lda L_C3FF,Y	;8E37 B9 FF C3
		eor #$02		;8E3A 49 02
		sta L_C3FF,Y	;8E3C 99 FF C3
		ldy L_C602,X	;8E3F BC 02 C6
		lda L_C400,Y	;8E42 B9 00 C4
		eor #$02		;8E45 49 02
		sta L_C400,Y	;8E47 99 00 C4
.L_8E4A	ldy L_0243,X	;8E4A BC 43 02
		tya				;8E4D 98
		cmp L_C603,X	;8E4E DD 03 C6
		bcs L_8E66		;8E51 B0 13
		lda L_C3FF,Y	;8E53 B9 FF C3
		eor #$01		;8E56 49 01
		sta L_C3FF,Y	;8E58 99 FF C3
		ldy L_C603,X	;8E5B BC 03 C6
		lda L_C400,Y	;8E5E B9 00 C4
		eor #$01		;8E61 49 01
		sta L_C400,Y	;8E63 99 00 C4
.L_8E66	rts				;8E66 60

.L_8E67	equb $FF,$FE,$FB,$FA,$EF,$EE,$EB,$EA,$BF,$BE,$BB,$BA,$AF,$AE,$AB,$AA
}

.draw_tachometer
{
		txa				;8E77 8A
		lsr A			;8E78 4A
		cmp #$40		;8E79 C9 40
		bcc L_8E7F		;8E7B 90 02
		sbc #$40		;8E7D E9 40
.L_8E7F	sta L_C34E		;8E7F 8D 4E C3
		sec				;8E82 38
		sbc L_C34F		;8E83 ED 4F C3
		bne L_8E8B		;8E86 D0 03
		jmp L_8F02		;8E88 4C 02 8F
.L_8E8B	bmi L_8EC7		;8E8B 30 3A
		sta ZP_51		;8E8D 85 51
		dec ZP_51		;8E8F C6 51
		ldx L_C34F		;8E91 AE 4F C3
		inx				;8E94 E8
		txa				;8E95 8A
		and #$FC		;8E96 29 FC
		asl A			;8E98 0A
		tay				;8E99 A8
		txa				;8E9A 8A
		and #$03		;8E9B 29 03
		clc				;8E9D 18
		adc ZP_51		;8E9E 65 51
.L_8EA0	cmp #$04		;8EA0 C9 04
		bcc L_8EBA		;8EA2 90 16
		tax				;8EA4 AA
		lda L_8F0C		;8EA5 AD 0C 8F
		sta L_7AA6,Y	;8EA8 99 A6 7A
		sta L_7AA7,Y	;8EAB 99 A7 7A
		tya				;8EAE 98
		clc				;8EAF 18
		adc #$08		;8EB0 69 08
		tay				;8EB2 A8
		txa				;8EB3 8A
		sec				;8EB4 38
		sbc #$04		;8EB5 E9 04
		jmp L_8EA0		;8EB7 4C A0 8E
.L_8EBA	tax				;8EBA AA
		lda L_8F09,X	;8EBB BD 09 8F
		sta L_7AA6,Y	;8EBE 99 A6 7A
		sta L_7AA7,Y	;8EC1 99 A7 7A
		jmp L_8F02		;8EC4 4C 02 8F
.L_8EC7	eor #$FF		;8EC7 49 FF
		clc				;8EC9 18
		adc #$01		;8ECA 69 01
		sta ZP_51		;8ECC 85 51
		lda L_C34E		;8ECE AD 4E C3
		and #$03		;8ED1 29 03
		tax				;8ED3 AA
		lda L_C34E		;8ED4 AD 4E C3
		and #$FC		;8ED7 29 FC
		asl A			;8ED9 0A
		tay				;8EDA A8
		lda L_8F09,X	;8EDB BD 09 8F
		sta L_7AA6,Y	;8EDE 99 A6 7A
		sta L_7AA7,Y	;8EE1 99 A7 7A
		txa				;8EE4 8A
		clc				;8EE5 18
		adc ZP_51		;8EE6 65 51
.L_8EE8	cmp #$04		;8EE8 C9 04
		bcc L_8F02		;8EEA 90 16
		tax				;8EEC AA
		tya				;8EED 98
		clc				;8EEE 18
		adc #$08		;8EEF 69 08
		tay				;8EF1 A8
		lda L_8F10		;8EF2 AD 10 8F
		sta L_7AA6,Y	;8EF5 99 A6 7A
		sta L_7AA7,Y	;8EF8 99 A7 7A
		txa				;8EFB 8A
		sec				;8EFC 38
		sbc #$04		;8EFD E9 04
		jmp L_8EE8		;8EFF 4C E8 8E
.L_8F02	lda L_C34E		;8F02 AD 4E C3
		sta L_C34F		;8F05 8D 4F C3
		rts				;8F08 60
		
.L_8F09	equb $C0,$F0,$FC
.L_8F0C	equb $FF,$00,$00,$00
.L_8F10	equb $00
}

.L_8F11
{
		stx L_8F80		;8F11 8E 80 8F
		lda #$00		;8F14 A9 00
		sta ZP_08		;8F16 85 08
		lda #$7C		;8F18 A9 7C
		sta ZP_14		;8F1A 85 14
		lda #$02		;8F1C A9 02
		sta ZP_A0		;8F1E 85 A0
		bne L_8F77		;8F20 D0 55
.L_8F22	ldy L_C778		;8F22 AC 78 C7
		jmp L_8F2E		;8F25 4C 2E 8F
.L_8F28	txa				;8F28 8A
		cmp L_075E,Y	;8F29 D9 5E 07
		beq L_8F33		;8F2C F0 05
.L_8F2E	dey				;8F2E 88
		bpl L_8F28		;8F2F 10 F7
		bmi L_8F45		;8F31 30 12
.L_8F33	lda L_0769,Y	;8F33 B9 69 07
		sta L_0710,X	;8F36 9D 10 07
		bpl L_8F3F		;8F39 10 04
		ldy #$03		;8F3B A0 03
		sty ZP_08		;8F3D 84 08
.L_8F3F	and #$7F		;8F3F 29 7F
		sta ZP_14		;8F41 85 14
		bpl L_8F74		;8F43 10 2F
.L_8F45	lda L_0400,X	;8F45 BD 00 04
		and #$0F		;8F48 29 0F
		tay				;8F4A A8
		lda L_B240,Y	;8F4B B9 40 B2
		bpl L_8F5E		;8F4E 10 0E
		lda L_8F80		;8F50 AD 80 8F
		sec				;8F53 38
		sbc #$0A		;8F54 E9 0A
		sta ZP_14		;8F56 85 14
		lda L_8F80		;8F58 AD 80 8F
		jmp L_8F69		;8F5B 4C 69 8F
.L_8F5E	lda ZP_14		;8F5E A5 14
		clc				;8F60 18
		adc #$0A		;8F61 69 0A
		bmi L_8F67		;8F63 30 02
		sta ZP_14		;8F65 85 14
.L_8F67	lda ZP_14		;8F67 A5 14
.L_8F69	ldy ZP_08		;8F69 A4 08
		beq L_8F71		;8F6B F0 04
		dec ZP_08		;8F6D C6 08
		ora #$80		;8F6F 09 80
.L_8F71	sta L_0710,X	;8F71 9D 10 07
.L_8F74	dex				;8F74 CA
		bpl L_8F22		;8F75 10 AB
.L_8F77	ldx L_C764		;8F77 AE 64 C7
		dex				;8F7A CA
		dec ZP_A0		;8F7B C6 A0
		bne L_8F22		;8F7D D0 A3
		rts				;8F7F 60
		
.L_8F80	equb $00
}

.L_8F81	equb $00

.clear_screen
{
		stx L_8F81		;8F82 8E 81 8F
		lda ZP_12		;8F85 A5 12
		beq L_8FEB		;8F87 F0 62
		ldx #$00		;8F89 A2 00
.L_8F8B	lda #$FF		;8F8B A9 FF
		sta L_62A0,X	;8F8D 9D A0 62
		sta L_63E0,X	;8F90 9D E0 63
		sta L_6520,X	;8F93 9D 20 65
		sta L_6660,X	;8F96 9D 60 66
		sta L_67A0,X	;8F99 9D A0 67
		sta L_68E0,X	;8F9C 9D E0 68
		sta L_6A20,X	;8F9F 9D 20 6A
		sta L_6B60,X	;8FA2 9D 60 6B
		sta L_6CA0,X	;8FA5 9D A0 6C
		sta L_6DE0,X	;8FA8 9D E0 6D
		sta L_6F20,X	;8FAB 9D 20 6F
		sta L_7060,X	;8FAE 9D 60 70
		sta L_71A0,X	;8FB1 9D A0 71
		lda L_C000,X	;8FB4 BD 00 C0
		sta L_72E0,X	;8FB7 9D E0 72
		lda L_C100,X	;8FBA BD 00 C1
		sta L_7420,X	;8FBD 9D 20 74
		dex				;8FC0 CA
		bne L_8F8B		;8FC1 D0 C8
		ldx #$17		;8FC3 A2 17
.L_8FC5	lda L_C200,X	;8FC5 BD 00 C2
		sta L_75A0,X	;8FC8 9D A0 75
		lda L_C218,X	;8FCB BD 18 C2
		sta L_7608,X	;8FCE 9D 08 76
		lda L_C230,X	;8FD1 BD 30 C2
		sta L_7560,X	;8FD4 9D 60 75
		lda L_C248,X	;8FD7 BD 48 C2
		sta L_7648,X	;8FDA 9D 48 76
		dex				;8FDD CA
		bpl L_8FC5		;8FDE 10 E5
		lda #$F0		;8FE0 A9 F0
		sta L_7578		;8FE2 8D 78 75
		lda #$0F		;8FE5 A9 0F
		sta L_7640		;8FE7 8D 40 76
		rts				;8FEA 60
.L_8FEB	ldx #$00		;8FEB A2 00
.L_8FED	lda #$FF		;8FED A9 FF
		sta L_42A0,X	;8FEF 9D A0 42
		sta L_43E0,X	;8FF2 9D E0 43
		sta L_4520,X	;8FF5 9D 20 45
		sta L_4660,X	;8FF8 9D 60 46
		sta L_47A0,X	;8FFB 9D A0 47
		sta L_48E0,X	;8FFE 9D E0 48
		sta L_4A20,X	;9001 9D 20 4A
		sta L_4B60,X	;9004 9D 60 4B
		sta L_4CA0,X	;9007 9D A0 4C
		sta L_4DE0,X	;900A 9D E0 4D
		sta L_4F20,X	;900D 9D 20 4F
		sta L_5060,X	;9010 9D 60 50
		sta L_51A0,X	;9013 9D A0 51
		bit L_8F81		;9016 2C 81 8F
		bpl L_9027		;9019 10 0C
		lda L_C000,X	;901B BD 00 C0
		sta L_52E0,X	;901E 9D E0 52
		lda L_C100,X	;9021 BD 00 C1
		sta L_5420,X	;9024 9D 20 54
.L_9027	dex				;9027 CA
		bne L_8FED		;9028 D0 C3
		bit L_8F81		;902A 2C 81 8F
		bpl L_9056		;902D 10 27
		ldx #$17		;902F A2 17
.L_9031	lda L_C200,X	;9031 BD 00 C2
		sta L_55A0,X	;9034 9D A0 55
		lda L_C218,X	;9037 BD 18 C2
		sta L_5608,X	;903A 9D 08 56
		lda L_C230,X	;903D BD 30 C2
		sta L_5560,X	;9040 9D 60 55
		lda L_C248,X	;9043 BD 48 C2
		sta L_5648,X	;9046 9D 48 56
		dex				;9049 CA
		bpl L_9031		;904A 10 E5
		lda #$F0		;904C A9 F0
		sta L_5578		;904E 8D 78 55
		lda #$0F		;9051 A9 0F
		sta L_5640		;9053 8D 40 56
.L_9056	rts				;9056 60
}

.update_colour_map
{
		lda L_C76B		;9057 AD 6B C7
		sta ZP_16		;905A 85 16
		lda #$00		;905C A9 00
		sta ZP_14		;905E 85 14
.L_9060	tax				;9060 AA
		lda L_0201,X	;9061 BD 01 02
		cmp L_0200,X	;9064 DD 00 02
		beq L_90B1		;9067 F0 48
		bcs L_908E		;9069 B0 23
		sta ZP_15		;906B 85 15
		ldy L_0200,X	;906D BC 00 02
		sta L_0200,X	;9070 9D 00 02
		txa				;9073 8A
		lsr A			;9074 4A
		lsr A			;9075 4A
		sta ZP_20		;9076 85 20
		tya				;9078 98
		tax				;9079 AA
		lda ZP_16		;907A A5 16
.L_907C	ldy L_A418,X	;907C BC 18 A4
		sty ZP_21		;907F 84 21
		ldy L_A400,X	;9081 BC 00 A4
		sta (ZP_20),Y	;9084 91 20
		dex				;9086 CA
		cpx ZP_15		;9087 E4 15
		bne L_907C		;9089 D0 F1
		jmp L_90B1		;908B 4C B1 90
.L_908E	sta ZP_15		;908E 85 15
		ldy L_0200,X	;9090 BC 00 02
		sta L_0200,X	;9093 9D 00 02
		txa				;9096 8A
		lsr A			;9097 4A
		lsr A			;9098 4A
		sta ZP_20		;9099 85 20
		tya				;909B 98
		tax				;909C AA
		lda #$0E		;909D A9 0E
		inx				;909F E8
.L_90A0	ldy L_A418,X	;90A0 BC 18 A4
		sty ZP_21		;90A3 84 21
		ldy L_A400,X	;90A5 BC 00 A4
		sta (ZP_20),Y	;90A8 91 20
		inx				;90AA E8
		cpx ZP_15		;90AB E4 15
		bcc L_90A0		;90AD 90 F1
		beq L_90A0		;90AF F0 EF
.L_90B1	lda ZP_14		;90B1 A5 14
		clc				;90B3 18
		adc #$04		;90B4 69 04
		sta ZP_14		;90B6 85 14
		bpl L_9060		;90B8 10 A6
		rts				;90BA 60
}

.sysctl_47
{
		lda L_0840		;90BB AD 40 08
		beq L_9106		;90BE F0 46
		txa				;90C0 8A
		pha				;90C1 48
		ldx #$08		;90C2 A2 08
		lda #$00		;90C4 A9 00
		tay				;90C6 A8
		jsr KERNEL_SETLFS		;90C7 20 BA FF
		pla				;90CA 68
		beq L_911A		;90CB F0 4D
		lda L_C77B		;90CD AD 7B C7
		beq L_9106		;90D0 F0 34
		ldx #$0B		;90D2 A2 0B
.L_90D4	lda L_AEC1,X	;90D4 BD C1 AE
		sta L_910E,X	;90D7 9D 0E 91
		dex				;90DA CA
		bpl L_90D4		;90DB 10 F7
		lda #$0F		;90DD A9 0F
		ldy #$91		;90DF A0 91
		ldx #$0B		;90E1 A2 0B
.L_90E3	jsr KERNEL_SETNAM		;90E3 20 BD FF
		lda #$0F		;90E6 A9 0F
		ldx #$08		;90E8 A2 08
		ldy #$0F		;90EA A0 0F
		jsr KERNEL_SETLFS		;90EC 20 BA FF
		jsr KERNEL_OPEN		;90EF 20 C0 FF
		bcc L_90FC		;90F2 90 08
		cmp #$04		;90F4 C9 04
		beq L_90FB		;90F6 F0 03
		sec				;90F8 38
		bcs L_90FC		;90F9 B0 01
.L_90FB	clc				;90FB 18
.L_90FC	php				;90FC 08
		lda #$0F		;90FD A9 0F
		jsr KERNEL_CLOSE		;90FF 20 C3 FF
		bcs L_9108		;9102 B0 04
		plp				;9104 28
		rts				;9105 60
.L_9106	clc				;9106 18
		rts				;9107 60
.L_9108	plp				;9108 28
		sec				;9109 38
		rts				;910A 60
		
.L_910B	equb $53,$30,$3A
.L_910E	equb $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20

.L_911A	lda #$02		;911A A9 02
		ldy #$91		;911C A0 91
		ldx #$23		;911E A2 23
		jmp L_90E3		;9120 4C E3 90
		
.L_9123	equb $49,$30
}

.L_9125	equb $7F,$33,$35,$37,$39,$2B,$5C,$31,$0D,$57,$52,$59,$49,$50,$2A,$00
		equb $00,$41,$44,$47,$4A,$4C,$3B,$00,$00,$34,$36,$38,$30,$2D,$1E,$32
		equb $00,$5A,$43,$42,$4D,$2E,$10,$20,$00,$53,$46,$48,$4B,$3A,$3D,$01
		equb $00,$45,$54,$55,$4F,$40,$5E,$51,$00,$10,$58,$56,$4E,$2C,$2F,$00
		equb $7F,$33,$35,$37,$39,$2B,$5C,$31,$0D,$77,$72,$79,$69,$70,$2A,$00
		equb $00,$61,$64,$67,$6A,$6C,$3B,$00,$00,$34,$36,$38,$30,$2D,$1E,$32
		equb $00,$7A,$63,$62,$6D,$2E,$00,$20,$00,$73,$66,$68,$6B,$3A,$3D,$01
		equb $00,$65,$74,$75,$6F,$40,$5E,$71,$00,$00,$78,$76,$6E,$2C,$3F,$00

.print_3space
		lda #$20		;91A5 A9 20
		jsr write_char		;91A7 20 6F 84
.print_2space
		lda #$20		;91AA A9 20
		jsr write_char		;91AC 20 6F 84
.print_space
		lda #$20		;91AF A9 20
		jmp write_char		;91B1 4C 6F 84

.L_91B4
{
		lda #$80		;91B4 A9 80
		sta L_31A5		;91B6 8D A5 31
		jsr L_91C3		;91B9 20 C3 91
		jsr L_3626		;91BC 20 26 36
		asl L_31A5		;91BF 0E A5 31
		rts				;91C2 60
}

.L_91C3
{
		lda #$80		;91C3 A9 80
		sta L_C39C		;91C5 8D 9C C3
		jsr L_3626		;91C8 20 26 36
		asl L_C39C		;91CB 0E 9C C3
		rts				;91CE 60
}

.L_91CF
{
		lda #$0E		;91CF A9 0E
		sta ZP_19		;91D1 85 19
		lda #$0A		;91D3 A9 0A
		sta L_3953		;91D5 8D 53 39
		jsr L_3854		;91D8 20 54 38
		lda #$0F		;91DB A9 0F
		sta L_3953		;91DD 8D 53 39
		ldx #$23		;91E0 A2 23
		jsr print_msg_1		;91E2 20 A5 32
		ldx L_C76E		;91E5 AE 6E C7
		beq L_91F5		;91E8 F0 0B
		inc L_C728,X	;91EA FE 28 C7
		jsr print_driver_name		;91ED 20 8B 38
		ldx #$E9		;91F0 A2 E9
		jsr print_msg_4		;91F2 20 27 30
.L_91F5	ldx #$05		;91F5 A2 05
		ldy ZP_7A		;91F7 A4 7A
		iny				;91F9 C8
		jsr set_text_cursor		;91FA 20 6B 10
		ldx #$2F		;91FD A2 2F
		jsr print_msg_1		;91FF 20 A5 32
		ldx L_C76D		;9202 AE 6D C7
		beq L_9212		;9205 F0 0B
		inc L_C734,X	;9207 FE 34 C7
		jsr print_driver_name		;920A 20 8B 38
		ldx #$EF		;920D A2 EF
		jsr print_msg_4		;920F 20 27 30
.L_9212	jmp L_E9A3		;9212 4C A3 E9
}

.convert_X_to_BCD
{
		stx ZP_CE		;9215 86 CE
		tax				;9217 AA
		sed				;9218 F8
		lda #$00		;9219 A9 00
.L_921B	clc				;921B 18
		adc #$01		;921C 69 01
		dex				;921E CA
		bne L_921B		;921F D0 FA
		cld				;9221 D8
		ldx ZP_CE		;9222 A6 CE
		rts				;9224 60
}

.L_9225
{
		lda L_C305		;9225 AD 05 C3
		beq L_92A1		;9228 F0 77
		ldx #$06		;922A A2 06
		ldy #$14		;922C A0 14
		jsr get_colour_map_ptr		;922E 20 FA 38
		ldx #$14		;9231 A2 14
		lda #$01		;9233 A9 01
		jsr fill_colourmap_solid		;9235 20 16 39
		ldx #$B8		;9238 A2 B8
		ldy #$05		;923A A0 05
		lda #$03		;923C A9 03
		sta ZP_19		;923E 85 19
		lda L_C305		;9240 AD 05 C3
		and #$01		;9243 29 01
		beq L_924F		;9245 F0 08
		ldx #$E3		;9247 A2 E3
		ldy #$07		;9249 A0 07
		lda #$10		;924B A9 10
		sta ZP_19		;924D 85 19
.L_924F	sty L_3953		;924F 8C 53 39
		jsr print_msg_3		;9252 20 DC A1
		lda L_C305		;9255 AD 05 C3
		and #$C0		;9258 29 C0
		cmp #$C0		;925A C9 C0
		bne L_9263		;925C D0 05
		ldx #$6F		;925E A2 6F
		jsr print_msg_3		;9260 20 DC A1
.L_9263	jsr L_3854		;9263 20 54 38
		lda #$0F		;9266 A9 0F
		sta L_3953		;9268 8D 53 39
		bit L_C305		;926B 2C 05 C3
		bpl L_9282		;926E 10 12
		ldx #$23		;9270 A2 23
		jsr print_msg_1		;9272 20 A5 32
		ldx #$D6		;9275 A2 D6
		jsr print_msg_3		;9277 20 DC A1
		jsr print_space		;927A 20 AF 91
		ldx #$0F		;927D A2 0F
		jsr L_99FF		;927F 20 FF 99
.L_9282	bit L_C305		;9282 2C 05 C3
		bvc L_92A1		;9285 50 1A
		ldx #$05		;9287 A2 05
		ldy ZP_7A		;9289 A4 7A
		iny				;928B C8
		jsr set_text_cursor		;928C 20 6B 10
		ldx #$2F		;928F A2 2F
		jsr print_msg_1		;9291 20 A5 32
		ldx #$C9		;9294 A2 C9
		jsr print_msg_3		;9296 20 DC A1
		jsr print_space		;9299 20 AF 91
		ldx #$0E		;929C A2 0E
		jmp L_99FF		;929E 4C FF 99
.L_92A1	rts				;92A1 60
}

.L_92A2
{
		ldy #$0C		;92A2 A0 0C
		jsr L_0F72		;92A4 20 72 0F
		bcs L_92AF		;92A7 B0 06
		lda L_31A4		;92A9 AD A4 31
		sta L_C76D		;92AC 8D 6D C7
.L_92AF	ldy #$0E		;92AF A0 0E
		jsr L_0F72		;92B1 20 72 0F
		bcs L_92C5		;92B4 B0 0F
		ldy #$C9		;92B6 A0 C9
		jsr L_9300		;92B8 20 00 93
		lda L_C305		;92BB AD 05 C3
		ora #$41		;92BE 09 41
		sta L_C305		;92C0 8D 05 C3
		ldx #$00		;92C3 A2 00
.L_92C5	ldy L_31A4		;92C5 AC A4 31
		jsr L_0F72		;92C8 20 72 0F
		tya				;92CB 98
		clc				;92CC 18
		adc #$0C		;92CD 69 0C
		tay				;92CF A8
		jsr L_3361_with_decimal		;92D0 20 61 33
		lda L_C378		;92D3 AD 78 C3
		cmp #$04		;92D6 C9 04
		bne L_92FD		;92D8 D0 23
		tya				;92DA 98
		tax				;92DB AA
		ldy #$0D		;92DC A0 0D
		jsr L_0F72		;92DE 20 72 0F
		bcs L_92E9		;92E1 B0 06
		lda L_31A4		;92E3 AD A4 31
		sta L_C76E		;92E6 8D 6E C7
.L_92E9	ldy #$0F		;92E9 A0 0F
		jsr L_0F72		;92EB 20 72 0F
		bcs L_92FD		;92EE B0 0D
		ldy #$D6		;92F0 A0 D6
		jsr L_9300		;92F2 20 00 93
		lda L_C305		;92F5 AD 05 C3
		ora #$81		;92F8 09 81
		sta L_C305		;92FA 8D 05 C3
.L_92FD	ldx #$00		;92FD A2 00
		rts				;92FF 60
}

.L_9300
{
		lda L_31A4		;9300 AD A4 31
		asl A			;9303 0A
		asl A			;9304 0A
		asl A			;9305 0A
		asl A			;9306 0A
		tax				;9307 AA
		lda #$0C		;9308 A9 0C
		sta ZP_14		;930A 85 14
.L_930C	lda L_AE01,X	;930C BD 01 AE
		sta frontend_strings_3,Y	;930F 99 AA 31
		inx				;9312 E8
		iny				;9313 C8
		dec ZP_14		;9314 C6 14
		bne L_930C		;9316 D0 F4
		rts				;9318 60
}

.L_9319
{
		sta ZP_14		;9319 85 14
		jsr disable_ints_and_page_in_RAM		;931B 20 F1 33
		ldx L_C77D		;931E AE 7D C7
		lda track_order,X	;9321 BD 28 37
		ldy L_C71A		;9324 AC 1A C7
		beq L_932C		;9327 F0 03
		clc				;9329 18
		adc #$08		;932A 69 08
.L_932C	asl A			;932C 0A
		asl A			;932D 0A
		asl A			;932E 0A
		asl A			;932F 0A
		tax				;9330 AA
		ldy #$00		;9331 A0 00
		bit ZP_14		;9333 24 14
		bmi L_936E		;9335 30 37
.L_9337	lda L_3273,Y	;9337 B9 73 32
		sta L_DE00,X	;933A 9D 00 DE		; I/O 1
		lda L_3280,Y	;933D B9 80 32
		sta L_DF00,X	;9340 9D 00 DF		; I/O 2
		inx				;9343 E8
		iny				;9344 C8
		cpy #$0C		;9345 C0 0C
		bne L_9337		;9347 D0 EE
		lda L_83A6		;9349 AD A6 83
		sta L_DE00,X	;934C 9D 00 DE		; I/O 1
		lda L_82BE		;934F AD BE 82
		sta L_DE01,X	;9352 9D 01 DE		; I/O 1
		lda L_82A6		;9355 AD A6 82
		sta L_DE02,X	;9358 9D 02 DE		; I/O 1
		lda L_83A7		;935B AD A7 83
		sta L_DF00,X	;935E 9D 00 DF		; I/O 2
		lda L_82BF		;9361 AD BF 82
		sta L_DF01,X	;9364 9D 01 DF		; I/O 2
		lda L_82A7		;9367 AD A7 82
		sta L_DF02,X	;936A 9D 02 DF		; I/O 2
		rts				;936D 60
}

.L_936E
{
		lda L_DE00,X	;936E BD 00 DE		; I/O 1
		sta L_3273,Y	;9371 99 73 32
		lda L_DF00,X	;9374 BD 00 DF		; I/O 2
		sta L_3280,Y	;9377 99 80 32
		inx				;937A E8
		iny				;937B C8
		cpy #$0C		;937C C0 0C
		bne L_936E		;937E D0 EE
		lda L_DE00,X	;9380 BD 00 DE		; I/O 1
		sta L_83A6		;9383 8D A6 83
		lda L_DE01,X	;9386 BD 01 DE		; I/O 1
		sta L_82BE		;9389 8D BE 82
		lda L_DE02,X	;938C BD 02 DE		; I/O 1
		sta L_82A6		;938F 8D A6 82
		lda L_DF00,X	;9392 BD 00 DF		; I/O 2
		sta L_83A7		;9395 8D A7 83
		lda L_DF01,X	;9398 BD 01 DF		; I/O 2
		sta L_82BF		;939B 8D BF 82
		lda L_DF02,X	;939E BD 02 DF		; I/O 2
		sta L_82A7		;93A1 8D A7 82
		jsr page_in_IO_and_enable_ints		;93A4 20 FC 33
		rts				;93A7 60
}

.L_93A8
{
		eor L_C77B		;93A8 4D 7B C7
		bne L_93DF		;93AB D0 32
		lda L_C39A		;93AD AD 9A C3
		bmi L_93DF		;93B0 30 2D
		lda L_C367		;93B2 AD 67 C3
		bmi L_93DF		;93B5 30 28
		beq L_93DF		;93B7 F0 26
		cmp #$40		;93B9 C9 40
		beq L_93C0		;93BB F0 03
		jmp L_9756		;93BD 4C 56 97
.L_93C0	jsr disable_ints_and_page_in_RAM		;93C0 20 F1 33
		lda L_C77B		;93C3 AD 7B C7
		beq L_93E0		;93C6 F0 18
		ldx #$00		;93C8 A2 00
.L_93CA	lda L_DE00,X	;93CA BD 00 DE		; I/O 1
		sta L_4000,X	;93CD 9D 00 40
		lda L_DF00,X	;93D0 BD 00 DF		; I/O 2
		sta L_4100,X	;93D3 9D 00 41
		dex				;93D6 CA
		bne L_93CA		;93D7 D0 F1
		jsr L_9746		;93D9 20 46 97
}
\\
.L_93DC	jsr page_in_IO_and_enable_ints		;93DC 20 FC 33
\\
.L_93DF	rts				;93DF 60

.L_93E0
{
		jsr L_974E		;93E0 20 4E 97
		bcs L_93DF		;93E3 B0 FA
		ldx #$00		;93E5 A2 00
.L_93E7	sed				;93E7 F8
		sec				;93E8 38
		lda L_400E,X	;93E9 BD 0E 40
		sbc L_DE0E,X	;93EC FD 0E DE
		lda L_400D,X	;93EF BD 0D 40
		sbc L_DE0D,X	;93F2 FD 0D DE
		lda L_400C,X	;93F5 BD 0C 40
		sbc L_DE0C,X	;93F8 FD 0C DE
		cld				;93FB D8
		bcs L_940D		;93FC B0 0F
		ldy #$10		;93FE A0 10
.L_9400	lda L_4000,X	;9400 BD 00 40
		sta L_DE00,X	;9403 9D 00 DE
		inx				;9406 E8
		dey				;9407 88
		bne L_9400		;9408 D0 F6
		jmp L_9412		;940A 4C 12 94
.L_940D	txa				;940D 8A
		clc				;940E 18
		adc #$10		;940F 69 10
		tax				;9411 AA
.L_9412	cpx #$00		;9412 E0 00
		bne L_93E7		;9414 D0 D1
.L_9416	sed				;9416 F8
		sec				;9417 38
		lda L_410E,X	;9418 BD 0E 41
		sbc L_DF0E,X	;941B FD 0E DF
		lda L_410D,X	;941E BD 0D 41
		sbc L_DF0D,X	;9421 FD 0D DF
		lda L_410C,X	;9424 BD 0C 41
		sbc L_DF0C,X	;9427 FD 0C DF
		cld				;942A D8
		bcs L_943C		;942B B0 0F
		ldy #$10		;942D A0 10
.L_942F	lda L_4100,X	;942F BD 00 41
		sta L_DF00,X	;9432 9D 00 DF
		inx				;9435 E8
		dey				;9436 88
		bne L_942F		;9437 D0 F6
		jmp L_9441		;9439 4C 41 94
.L_943C	txa				;943C 8A
		clc				;943D 18
		adc #$10		;943E 69 10
		tax				;9440 AA
.L_9441	cpx #$00		;9441 E0 00
		bne L_9416		;9443 D0 D1
		jmp L_93DC		;9445 4C DC 93
}

.L_9448
{
		ldy #$00		;9448 A0 00
		ldx #$03		;944A A2 03
.L_944C	lda L_AEC1,X	;944C BD C1 AE
		cmp L_94CC,X	;944F DD CC 94
		bne L_945B		;9452 D0 07
		dex				;9454 CA
		bpl L_944C		;9455 10 F5
		ldy #$80		;9457 A0 80
		bne L_947B		;9459 D0 20
.L_945B	ldx #$03		;945B A2 03
.L_945D	lda L_AEC1,X	;945D BD C1 AE
		cmp L_94D0,X	;9460 DD D0 94
		bne L_946C		;9463 D0 07
		dex				;9465 CA
		bpl L_945D		;9466 10 F5
		ldy #$40		;9468 A0 40
		bne L_947B		;946A D0 0F
.L_946C	ldx #$01		;946C A2 01
.L_946E	lda L_AEC1,X	;946E BD C1 AE
		cmp L_94D4,X	;9471 DD D4 94
		bne L_947B		;9474 D0 05
		dex				;9476 CA
		bpl L_946E		;9477 10 F5
		ldy #$01		;9479 A0 01
.L_947B	sty L_C367		;947B 8C 67 C3
		lda L_C77B		;947E AD 7B C7
		beq L_9491		;9481 F0 0E
		tya				;9483 98
		bmi L_9493		;9484 30 0D
		beq L_949A		;9486 F0 12
		cpy #$01		;9488 C0 01
		bne L_9491		;948A D0 05
		lda L_31A1		;948C AD A1 31
		beq L_949F		;948F F0 0E
.L_9491	clc				;9491 18
		rts				;9492 60
.L_9493	lda #$00		;9493 A9 00
		sta L_C77B		;9495 8D 7B C7
		clc				;9498 18
		rts				;9499 60
.L_949A	lda L_31A1		;949A AD A1 31
		beq L_9491		;949D F0 F2
.L_949F	jsr L_3884		;949F 20 84 38
		ldx #$06		;94A2 A2 06
		ldy #$16		;94A4 A0 16
		jsr set_text_cursor		;94A6 20 6B 10
		ldx #$57		;94A9 A2 57
		jsr L_95E2		;94AB 20 E2 95
		jsr getch		;94AE 20 03 86
		ldx #$19		;94B1 A2 19
.L_94B3	lda #$7F		;94B3 A9 7F
		jsr write_char		;94B5 20 6F 84
		dex				;94B8 CA
		bne L_94B3		;94B9 D0 F8
		ldx #$14		;94BB A2 14
		ldy #$13		;94BD A0 13
		jsr set_text_cursor		;94BF 20 6B 10
		ldx #$0C		;94C2 A2 0C
.L_94C4	jsr print_space		;94C4 20 AF 91
		dex				;94C7 CA
		bne L_94C4		;94C8 D0 FA
		sec				;94CA 38
		rts				;94CB 60

.L_94CC	equb "DIR "
.L_94D0	equb "HALL"
.L_94D4	equb "MP$"
}

.L_94D7
{
		lda L_C39A		;94D7 AD 9A C3
		bmi L_94E1		;94DA 30 05
		lda L_C367		;94DC AD 67 C3
		bmi L_9526		;94DF 30 45
.L_94E1	jsr L_3500		;94E1 20 00 35
		jsr set_up_screen_for_frontend		;94E4 20 04 35
		lda #$01		;94E7 A9 01
		sta ZP_19		;94E9 85 19
		jsr L_3858		;94EB 20 58 38
		ldx #$0C		;94EE A2 0C
		jsr print_driver_name		;94F0 20 8B 38
		lda L_C39A		;94F3 AD 9A C3
		bpl L_94FD		;94F6 10 05
		ldx #$00		;94F8 A2 00
		jsr L_95E2		;94FA 20 E2 95
.L_94FD	ldy L_C77B		;94FD AC 7B C7
		ldx L_952A,Y	;9500 BE 2A 95
		jsr L_95E2		;9503 20 E2 95
		lda L_C39A		;9506 AD 9A C3
		bpl L_951D		;9509 10 12
		jsr L_3858		;950B 20 58 38
		lda L_C39A		;950E AD 9A C3
		clc				;9511 18
		adc #$02		;9512 69 02
		and #$07		;9514 29 07
		tay				;9516 A8
		ldx L_952A,Y	;9517 BE 2A 95
		jsr L_95E2		;951A 20 E2 95
.L_951D	jsr ensure_screen_enabled		;951D 20 9E 3F
		jsr debounce_fire_and_wait_for_fire		;9520 20 96 36
		jsr L_361F		;9523 20 1F 36
.L_9526	lda L_C39A		;9526 AD 9A C3
		rts				;9529 60
}

.L_952A	equb $05,$0D,$43,$14,$2A,$43,$43,$43,$71,$8F,$94

.file_strings
		equb " NOT",$FF
		equb " loaded",$FF
		equb " saved",$FF
		equb "Incorrect data found ",$FF
		equb "File name already exists",$FF
		equb "Problem encountered",$FF
		equb "File name is not suitable",$FF
		equb $1F,$05,$13,"Insert game position save ",$FF
		equb "tape",$FF
		equb "disc",$FF
		equb $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$FF

.L_95DE
		jsr write_char		;95DE 20 6F 84
		inx				;95E1 E8
.L_95E2
		lda file_strings,X	;95E2 BD 35 95
		cmp #$FF		;95E5 C9 FF
		bne L_95DE		;95E7 D0 F5
		rts				;95E9 60

.L_95EA
{
		ldx #$00		;95EA A2 00
		lda #$01		;95EC A9 01
.L_95EE	jsr L_FFE2		;95EE 20 E2 FF
		inx				;95F1 E8
		bne L_95EE		;95F2 D0 FA
		ldx #$09		;95F4 A2 09
.L_95F6	lda L_9674,X	;95F6 BD 74 96
		and #$3F		;95F9 29 3F
		sta L_042A,X	;95FB 9D 2A 04
		dex				;95FE CA
		bpl L_95F6		;95FF 10 F5
		lda #$25		;9601 A9 25
		sta ZP_1E		;9603 85 1E
		lda #$40		;9605 A9 40
		sta ZP_1F		;9607 85 1F
		lda #$90		;9609 A9 90
		sta ZP_48		;960B 85 48
.L_960D	ldx #$36		;960D A2 36
		lda #$03		;960F A9 03
		sta ZP_4A		;9611 85 4A
		lda #$A0		;9613 A9 A0
		sta ZP_20		;9615 85 20
		lda #$04		;9617 A9 04
		sta ZP_21		;9619 85 21
.L_961B	ldy #$0D		;961B A0 0D
		lda #$22		;961D A9 22
		cmp (ZP_1E),Y	;961F D1 1E
		bne L_9660		;9621 D0 3D
		ldy #$00		;9623 A0 00
		cmp (ZP_1E),Y	;9625 D1 1E
		bne L_9660		;9627 D0 37
		iny				;9629 C8
		cpx #$00		;962A E0 00
		bne L_9634		;962C D0 06
		jsr debounce_fire_and_wait_for_fire		;962E 20 96 36
		jmp L_960D		;9631 4C 0D 96
.L_9634	lda (ZP_1E),Y	;9634 B1 1E
		and #$3F		;9636 29 3F
		sta (ZP_20),Y	;9638 91 20
		iny				;963A C8
		cpy #$0D		;963B C0 0D
		bcc L_9634		;963D 90 F5
		lda #$20		;963F A9 20
		sta (ZP_20),Y	;9641 91 20
		iny				;9643 C8
		lda #$0D		;9644 A9 0D
		dec ZP_4A		;9646 C6 4A
		bne L_9654		;9648 D0 0A
		lda #$20		;964A A9 20
		sta (ZP_20),Y	;964C 91 20
		lda #$03		;964E A9 03
		sta ZP_4A		;9650 85 4A
		lda #$0E		;9652 A9 0E
.L_9654	clc				;9654 18
		adc ZP_20		;9655 65 20
		sta ZP_20		;9657 85 20
		lda ZP_21		;9659 A5 21
		adc #$00		;965B 69 00
		sta ZP_21		;965D 85 21
		dex				;965F CA
.L_9660	lda ZP_1E		;9660 A5 1E
		clc				;9662 18
		adc #$20		;9663 69 20
		sta ZP_1E		;9665 85 1E
		lda ZP_1F		;9667 A5 1F
		adc #$00		;9669 69 00
		sta ZP_1F		;966B 85 1F
		dec ZP_48		;966D C6 48
		bne L_961B		;966F D0 AA
		jmp debounce_fire_and_wait_for_fire		;9671 4C 96 36
}

.L_9674	equb "DIRECTORY:"

.L_967E
{
		lda L_96A7		;967E AD A7 96
		sta ZP_15		;9681 85 15
		lda L_96A6		;9683 AD A6 96
		asl A			;9686 0A
		rol ZP_15		;9687 26 15
		asl A			;9689 0A
		rol ZP_15		;968A 26 15
		clc				;968C 18
		adc L_96A6		;968D 6D A6 96
		sta L_96A6		;9690 8D A6 96
		sta ZP_14		;9693 85 14
		lda ZP_15		;9695 A5 15
		adc L_96A7		;9697 6D A7 96
		sta L_96A7		;969A 8D A7 96
		lsr A			;969D 4A
		ror ZP_14		;969E 66 14
		lsr A			;96A0 4A
		ror ZP_14		;96A1 66 14
		lda ZP_14		;96A3 A5 14
		rts				;96A5 60
}

.L_96A6	equb $3B
.L_96A7	equb $68

.L_96A8
{
		lda #$00		;96A8 A9 00
		jmp L_96AF		;96AA 4C AF 96
}

.L_96AD
		lda #$80		;96AD A9 80
\\
.L_96AF
{
		sta ZP_19		;96AF 85 19
		lda #$00		;96B1 A9 00
		sta ZP_1E		;96B3 85 1E
		lda #$40		;96B5 A9 40
		sta ZP_1F		;96B7 85 1F
		lda #$3B		;96B9 A9 3B
		sta L_96A6		;96BB 8D A6 96
		lda #$68		;96BE A9 68
		sta L_96A7		;96C0 8D A7 96
		ldx #$00		;96C3 A2 00
.L_96C5	jsr L_967E		;96C5 20 7E 96
		sta L_4300,X	;96C8 9D 00 43
		inx				;96CB E8
		bne L_96C5		;96CC D0 F7
		ldy #$0F		;96CE A0 0F
		bit ZP_19		;96D0 24 19
		bmi L_96DC		;96D2 30 08
		lda L_F810		;96D4 AD 10 F8
		sta (ZP_1E),Y	;96D7 91 1E
		jmp L_96E1		;96D9 4C E1 96
.L_96DC	lda (ZP_1E),Y	;96DC B1 1E
		sta L_F810		;96DE 8D 10 F8
}
\\
.L_96E1	
{
		ldy #$00		;96E1 A0 00
		bit ZP_19		;96E3 24 19
		bmi L_96F5		;96E5 30 0E
		tya				;96E7 98
		ldy #$EF		;96E8 A0 EF
		sta (ZP_1E),Y	;96EA 91 1E
		ldy #$1F		;96EC A0 1F
		sta (ZP_1E),Y	;96EE 91 1E
		ldy #$FF		;96F0 A0 FF
		sta (ZP_1E),Y	;96F2 91 1E
		tay				;96F4 A8
.L_96F5	ldx #$00		;96F5 A2 00
.L_96F7	lda (ZP_1E),Y	;96F7 B1 1E
		sta ZP_17		;96F9 85 17
		stx ZP_18		;96FB 86 18
		ldx L_F810		;96FD AE 10 F8
		lda L_4300,X	;9700 BD 00 43
		inc L_F810		;9703 EE 10 F8
		ldx ZP_18		;9706 A6 18
		inx				;9708 E8
		bit ZP_19		;9709 24 19
		bpl L_9713		;970B 10 06
		cpx ZP_17		;970D E4 17
		beq L_9718		;970F F0 07
		bne L_96F7		;9711 D0 E4
.L_9713	cmp ZP_17		;9713 C5 17
		bne L_96F7		;9715 D0 E0
		txa				;9717 8A
.L_9718	sta (ZP_1E),Y	;9718 91 1E
		lda L_F810		;971A AD 10 F8
		clc				;971D 18
		adc L_4300,X	;971E 7D 00 43
		sta L_F810		;9721 8D 10 F8
		cpy #$0E		;9724 C0 0E
		bne L_9729		;9726 D0 01
		iny				;9728 C8
.L_9729	iny				;9729 C8
		bne L_96F5		;972A D0 C9
		bit ZP_19		;972C 24 19
		bpl L_9745		;972E 10 15
		ldy #$EF		;9730 A0 EF
		lda (ZP_1E),Y	;9732 B1 1E
		ldy #$FF		;9734 A0 FF
		ora (ZP_1E),Y	;9736 11 1E
		ldy #$1F		;9738 A0 1F
		ora (ZP_1E),Y	;973A 11 1E
		clc				;973C 18
		beq L_9745		;973D F0 06
		lda #$81		;973F A9 81
		sta L_C39A		;9741 8D 9A C3
		sec				;9744 38
.L_9745	rts				;9745 60
}

.L_9746
{
		jsr L_96A8		;9746 20 A8 96
		inc ZP_1F		;9749 E6 1F
		jmp L_96E1		;974B 4C E1 96
}

.L_974E
{
		jsr L_96AD		;974E 20 AD 96
		inc ZP_1F		;9751 E6 1F
		jmp L_96E1		;9753 4C E1 96
}

.L_9756
{
		lda L_C77B		;9756 AD 7B C7
		beq L_9784		;9759 F0 29
		ldx #$7F		;975B A2 7F
.L_975D	lda L_AE40,X	;975D BD 40 AE
		sta L_4020,X	;9760 9D 20 40
		cpx #$3C		;9763 E0 3C
		bcs L_976D		;9765 B0 06
		lda L_C728,X	;9767 BD 28 C7
		sta L_40A0,X	;976A 9D A0 40
.L_976D	cpx #$0C		;976D E0 0C
		bcs L_9777		;976F B0 06
		lda L_83B0,X	;9771 BD B0 83
		sta L_40E0,X	;9774 9D E0 40
.L_9777	dex				;9777 CA
		bpl L_975D		;9778 10 E3
		lda L_31A1		;977A AD A1 31
		sta L_40DC		;977D 8D DC 40
		jsr L_96A8		;9780 20 A8 96
		rts				;9783 60
.L_9784	jsr L_96AD		;9784 20 AD 96
		bcs L_97AE		;9787 B0 25
		ldx #$7F		;9789 A2 7F
.L_978B	lda L_4020,X	;978B BD 20 40
		sta L_AE40,X	;978E 9D 40 AE
		cpx #$3C		;9791 E0 3C
		bcs L_979B		;9793 B0 06
		lda L_40A0,X	;9795 BD A0 40
		sta L_C728,X	;9798 9D 28 C7
.L_979B	cpx #$0C		;979B E0 0C
		bcs L_97A5		;979D B0 06
		lda L_40E0,X	;979F BD E0 40
		sta L_83B0,X	;97A2 9D B0 83
.L_97A5	dex				;97A5 CA
		bpl L_978B		;97A6 10 E3
		lda L_40DC		;97A8 AD DC 40
		sta L_31A1		;97AB 8D A1 31
.L_97AE	rts				;97AE 60
}

.maybe_define_keys
{
		ldx #$20		;97AF A2 20
		jsr poll_key_with_sysctl		;97B1 20 C9 C7
		beq L_97B7		;97B4 F0 01
		rts				;97B6 60
.L_97B7	ldy #$64		;97B7 A0 64
		lda #$04		;97B9 A9 04
		jsr set_up_text_sprite		;97BB 20 A9 12
		lda #$01		;97BE A9 01
		sta L_983B		;97C0 8D 3B 98
.L_97C3	ldy #$28		;97C3 A0 28
		jsr delay_approx_Y_25ths_sec		;97C5 20 EB 3F
		ldx #$04		;97C8 A2 04
.L_97CA	stx L_983A		;97CA 8E 3A 98
		ldy L_9841,X	;97CD BC 41 98
		lda #$04		;97D0 A9 04
		jsr set_up_text_sprite		;97D2 20 A9 12
.L_97D5	ldx #$3F		;97D5 A2 3F
.L_97D7	stx ZP_17		;97D7 86 17
		jsr poll_key_with_sysctl		;97D9 20 C9 C7
		bne L_9816		;97DC D0 38
		lda ZP_17		;97DE A5 17
		ldx L_983A		;97E0 AE 3A 98
		ldy L_983C,X	;97E3 BC 3C 98
		ldx L_983B		;97E6 AE 3B 98
		bne L_97FF		;97E9 D0 14
		cmp control_keys,Y	;97EB D9 07 F8
		beq L_9802		;97EE F0 12
		ldy #$D4		;97F0 A0 D4
		lda #$04		;97F2 A9 04
		jsr set_up_text_sprite		;97F4 20 A9 12
		ldy #$28		;97F7 A0 28
		jsr delay_approx_Y_25ths_sec		;97F9 20 EB 3F
		jmp L_97B7		;97FC 4C B7 97
.L_97FF	sta control_keys,Y	;97FF 99 07 F8
.L_9802	lda #$00		;9802 A9 00
		jsr L_CF68		;9804 20 68 CF
.L_9807	ldx ZP_17		;9807 A6 17
		jsr poll_key_with_sysctl		;9809 20 C9 C7
		beq L_9807		;980C F0 F9
		ldy #$03		;980E A0 03
		jsr delay_approx_Y_25ths_sec		;9810 20 EB 3F
		jmp L_981D		;9813 4C 1D 98
.L_9816	ldx ZP_17		;9816 A6 17
		dex				;9818 CA
		bpl L_97D7		;9819 10 BC
		bmi L_97D5		;981B 30 B8
.L_981D	ldx L_983A		;981D AE 3A 98
		dex				;9820 CA
		bpl L_97CA		;9821 10 A7
		dec L_983B		;9823 CE 3B 98
		bmi L_9832		;9826 30 0A
		ldy #$C4		;9828 A0 C4
		lda #$04		;982A A9 04
		jsr set_up_text_sprite		;982C 20 A9 12
		jmp L_97C3		;982F 4C C3 97
.L_9832	ldy #$4C		;9832 A0 4C
		lda #$02		;9834 A9 02
		jsr set_up_text_sprite		;9836 20 A9 12
		rts				;9839 60

.L_983A	equb $00
.L_983B	equb $00
.L_983C	equb $00,$01,$04,$03,$02
.L_9841	equb $B4,$A4,$94,$84,$74
}

.store_restore_control_keys
{
		sta ZP_14		;9846 85 14
		lda L_31A1		;9848 AD A1 31
		beq L_986E		;984B F0 21
		lda L_31A4		;984D AD A4 31
		sec				;9850 38
		sbc #$04		;9851 E9 04
		sta ZP_15		;9853 85 15
		asl A			;9855 0A
		asl A			;9856 0A
		clc				;9857 18
		adc ZP_15		;9858 65 15
		clc				;985A 18
		adc #$04		;985B 69 04
		tay				;985D A8
		ldx #$04		;985E A2 04
		bit ZP_14		;9860 24 14
		bpl L_986F		;9862 10 0B
.L_9864	lda L_987A,Y	;9864 B9 7A 98
		sta control_keys,X	;9867 9D 07 F8
		dey				;986A 88
		dex				;986B CA
		bpl L_9864		;986C 10 F6
.L_986E	rts				;986E 60
}

.L_986F
{
		lda control_keys,X	;986F BD 07 F8
		sta L_987A,Y	;9872 99 7A 98
		dey				;9875 88
		dex				;9876 CA
		bpl L_986F		;9877 10 F6
		rts				;9879 60
}

.L_987A	equb $2E,$27,$29,$12,$08
		equb $2E,$27,$29,$12,$08
		equb $2E,$27,$29,$12,$08
		equb $2E,$27,$29,$12,$08
		equb $2E,$27,$29,$12,$08
		equb $2E,$27,$29,$12,$08
		equb $2E,$27,$29,$12,$08
		equb $2E,$27,$29,$12,$08

.do_practice_menu
{
		lda #$80		;98A2 A9 80
		sta L_31A0		;98A4 8D A0 31
		lsr L_31A8		;98A7 4E A8 31
		bcs L_98BD		;98AA B0 11
		ldy #$03		;98AC A0 03
		lda L_C718		;98AE AD 18 C7
		eor #$03		;98B1 49 03
		ldx #$18		;98B3 A2 18
		jsr do_menu_screen		;98B5 20 36 EE
		eor #$03		;98B8 49 03
		sta L_31A7		;98BA 8D A7 31
.L_98BD	lsr L_31A0		;98BD 4E A0 31
		ldy #$02		;98C0 A0 02
		lda L_C76C		;98C2 AD 6C C7
		and #$01		;98C5 29 01
		ldx #$1C		;98C7 A2 1C
		jsr do_menu_screen		;98C9 20 36 EE
		ldy #$00		;98CC A0 00
		sty L_31A0		;98CE 8C A0 31
		rts				;98D1 60
}

.do_hall_of_fame_screen
{
		lda #$06		;98D2 A9 06
		jsr L_3FBB_with_VIC		;98D4 20 BB 3F
		jsr disable_ints_and_page_in_RAM		;98D7 20 F1 33
		ldx #$7F		;98DA A2 7F
		ldy #$7F		;98DC A0 7F
		lda L_C71A		;98DE AD 1A C7
		beq L_98E5		;98E1 F0 02
		ldy #$FF		;98E3 A0 FF
.L_98E5	lda L_DE00,Y	;98E5 B9 00 DE
		sta L_0400,X	;98E8 9D 00 04
		lda L_DF00,Y	;98EB B9 00 DF
		sta L_0480,X	;98EE 9D 80 04
		dey				;98F1 88
		dex				;98F2 CA
		bpl L_98E5		;98F3 10 F0
		lda #$35		;98F5 A9 35
		sta RAM_SELECT		;98F7 85 01
		cli				;98F9 58
		lda #$01		;98FA A9 01
		jsr sysctl		;98FC 20 25 87
		lda #$06		;98FF A9 06
		sta VIC_EXTCOL		;9901 8D 20 D0
		lda #$5F		;9904 A9 5F
		sta ZP_1F		;9906 85 1F
		ldy #$00		;9908 A0 00
		sty ZP_1E		;990A 84 1E
		tya				;990C 98
.L_990D	sta (ZP_1E),Y	;990D 91 1E
		dey				;990F 88
		bne L_990D		;9910 D0 FB
		dec ZP_1F		;9912 C6 1F
		ldx ZP_1F		;9914 A6 1F
		cpx #$40		;9916 E0 40
		bcs L_990D		;9918 B0 F3
		ldx #$00		;991A A2 00
		ldy #$00		;991C A0 00
		jsr get_colour_map_ptr		;991E 20 FA 38
		ldx #$18		;9921 A2 18
		lda #$06		;9923 A9 06
		jsr fill_colourmap_solid		;9925 20 16 39
		lda #$08		;9928 A9 08
		sta ZP_19		;992A 85 19
.L_992C	ldx #$24		;992C A2 24
		lda #$08		;992E A9 08
		jsr fill_colourmap_solid		;9930 20 16 39
		dec ZP_19		;9933 C6 19
		bne L_992C		;9935 D0 F5
		ldx #$34		;9937 A2 34
		lda #$01		;9939 A9 01
		jsr fill_colourmap_solid		;993B 20 16 39
		lda #$01		;993E A9 01
		sta L_C3D9		;9940 8D D9 C3
		lda #$02		;9943 A9 02
		sta L_C3D9		;9945 8D D9 C3
		ldx #$3B		;9948 A2 3B
		jsr print_msg_1		;994A 20 A5 32
		lda L_C71A		;994D AD 1A C7
		beq L_9957		;9950 F0 05
		ldx #$4B		;9952 A2 4B
		jsr print_msg_1		;9954 20 A5 32
.L_9957	ldx #$5B		;9957 A2 5B
		jsr print_msg_1		;9959 20 A5 32
		lda #$07		;995C A9 07
		sta ZP_19		;995E 85 19
.L_9960	lda #$07		;9960 A9 07
		sec				;9962 38
		sbc ZP_19		;9963 E5 19
		asl A			;9965 0A
		clc				;9966 18
		adc #$08		;9967 69 08
		tay				;9969 A8
		ldx #$00		;996A A2 00
		jsr set_text_cursor		;996C 20 6B 10
		lda ZP_19		;996F A5 19
		asl A			;9971 0A
		tax				;9972 AA
		lda #$01		;9973 A9 01
		sta L_C3D9		;9975 8D D9 C3
		lda L_99EF,X	;9978 BD EF 99
		jsr write_char		;997B 20 6F 84
		lda L_99F0,X	;997E BD F0 99
		jsr write_char		;9981 20 6F 84
		jsr print_space		;9984 20 AF 91
		lda #$04		;9987 A9 04
		sta L_C3D9		;9989 8D D9 C3
		lda #$00		;998C A9 00
		sta ZP_08		;998E 85 08
.L_9990	lda ZP_19		;9990 A5 19
		asl A			;9992 0A
		asl A			;9993 0A
		asl A			;9994 0A
		asl A			;9995 0A
		ora ZP_08		;9996 05 08
		tax				;9998 AA
		ldy #$0C		;9999 A0 0C
.L_999B	lda L_0400,X	;999B BD 00 04
		jsr write_char		;999E 20 6F 84
		inx				;99A1 E8
		dey				;99A2 88
		bne L_999B		;99A3 D0 F6
		jsr print_space		;99A5 20 AF 91
		dec L_C3D9		;99A8 CE D9 C3
		lda L_0400,X	;99AB BD 00 04
		sta L_8398		;99AE 8D 98 83
		lda L_0401,X	;99B1 BD 01 04
		sta L_82B0		;99B4 8D B0 82
		lda L_0402,X	;99B7 BD 02 04
		sta L_8298		;99BA 8D 98 82
		ldx #$00		;99BD A2 00
		jsr L_99FF		;99BF 20 FF 99
		lda ZP_08		;99C2 A5 08
		eor #$80		;99C4 49 80
		sta ZP_08		;99C6 85 08
		bpl L_99D5		;99C8 10 0B
		jsr print_2space		;99CA 20 AA 91
		lda #$02		;99CD A9 02
		sta L_C3D9		;99CF 8D D9 C3
		jmp L_9990		;99D2 4C 90 99
.L_99D5	dec ZP_19		;99D5 C6 19
		bpl L_9960		;99D7 10 87
		lda #$00		;99D9 A9 00
		sta L_C3D9		;99DB 8D D9 C3
		lda VIC_SCROLY		;99DE AD 11 D0
		ora #$10		;99E1 09 10
		sta VIC_SCROLY		;99E3 8D 11 D0
		jsr debounce_fire_and_wait_for_fire		;99E6 20 96 36
		jsr enable_screen_and_set_irq50		;99E9 20 A5 3F
		jmp set_up_screen_for_frontend		;99EC 4C 04 35

.L_99EF	equb $4C,$52,$48
		equb $42,$53,$53,$42,$52,$48,$4A,$52,$43,$53,$4A,$44,$42
L_99F0	= L_99EF + 1
}

.L_99FF
{
		lda L_8398,X	;99FF BD 98 83
		cmp #$09		;9A02 C9 09
		bcs L_9A27		;9A04 B0 21
		ora L_82B0,X	;9A06 1D B0 82
		beq L_9A27		;9A09 F0 1C
		lda L_8398,X	;9A0B BD 98 83
		jsr print_single_digit		;9A0E 20 8A 10
		lda #$3A		;9A11 A9 3A
		jsr write_char		;9A13 20 6F 84
		lda L_82B0,X	;9A16 BD B0 82
		jsr print_BCD_double_digits		;9A19 20 53 33
		lda #$2E		;9A1C A9 2E
		jsr write_char		;9A1E 20 6F 84
		lda L_8298,X	;9A21 BD 98 82
		jmp print_BCD_double_digits		;9A24 4C 53 33
.L_9A27	lda #$2D		;9A27 A9 2D
		ldy #$07		;9A29 A0 07
.L_9A2B	jsr write_char		;9A2B 20 6F 84
		dey				;9A2E 88
		bne L_9A2B		;9A2F D0 FA
		rts				;9A31 60
}

.nmi_handler
{
		pha				;9A32 48
		lda CIA2_C2DDRA		;9A33 AD 0D DD
		pla				;9A36 68
		rti				;9A37 40
}

.L_9A38
{
		ldx ZP_2E		;9A38 A6 2E
		jsr get_track_segment_detailsQ		;9A3A 20 2F F0
		jsr L_F0C5		;9A3D 20 C5 F0
		lda ZP_68		;9A40 A5 68
		sec				;9A42 38
		sbc ZP_1D		;9A43 E5 1D
		sta ZP_3D		;9A45 85 3D
		lda ZP_B2		;9A47 A5 B2
		bpl L_9A4E		;9A49 10 03
		jmp L_9AC9		;9A4B 4C C9 9A
.L_9A4E	asl A			;9A4E 0A
		bmi L_9A77		;9A4F 30 26
		jsr L_9E08		;9A51 20 08 9E
		ldy #$02		;9A54 A0 02
		lda ZP_51		;9A56 A5 51
		sec				;9A58 38
		sbc (ZP_9A),Y	;9A59 F1 9A
		iny				;9A5B C8
		sta ZP_B7		;9A5C 85 B7
		lda ZP_77		;9A5E A5 77
		sbc (ZP_9A),Y	;9A60 F1 9A
		sta ZP_B8		;9A62 85 B8
		lda ZP_52		;9A64 A5 52
		sta ZP_B3		;9A66 85 B3
		lda ZP_78		;9A68 A5 78
		sta ZP_B4		;9A6A 85 B4
		lda ZP_1D		;9A6C A5 1D
		sta L_018A		;9A6E 8D 8A 01
		lda #$00		;9A71 A9 00
		sta L_0189		;9A73 8D 89 01
		rts				;9A76 60
.L_9A77	jsr L_9E08		;9A77 20 08 9E
		lda #$B5		;9A7A A9 B5
		sta ZP_15		;9A7C 85 15
		lda ZP_51		;9A7E A5 51
		sec				;9A80 38
		sbc ZP_52		;9A81 E5 52
		sta ZP_14		;9A83 85 14
		lda ZP_77		;9A85 A5 77
		sbc ZP_78		;9A87 E5 78
		jsr mul_8_16_16bit		;9A89 20 45 C8
		sta ZP_15		;9A8C 85 15
		ldy #$02		;9A8E A0 02
		lda ZP_14		;9A90 A5 14
		sec				;9A92 38
		sbc (ZP_9A),Y	;9A93 F1 9A
		iny				;9A95 C8
		sta ZP_B7		;9A96 85 B7
		lda ZP_15		;9A98 A5 15
		sbc (ZP_9A),Y	;9A9A F1 9A
		sta ZP_B8		;9A9C 85 B8
		ldy #$07		;9A9E A0 07
		lda (ZP_9A),Y	;9AA0 B1 9A
		sta ZP_15		;9AA2 85 15
		lda ZP_51		;9AA4 A5 51
		clc				;9AA6 18
		adc ZP_52		;9AA7 65 52
		sta ZP_14		;9AA9 85 14
		lda ZP_77		;9AAB A5 77
		adc ZP_78		;9AAD 65 78
		jsr mul_8_16_16bit		;9AAF 20 45 C8
		sta ZP_B4		;9AB2 85 B4
		lda ZP_14		;9AB4 A5 14
		sta ZP_B3		;9AB6 85 B3
		ldy #$04		;9AB8 A0 04
		lda (ZP_9A),Y	;9ABA B1 9A
		sta L_0189		;9ABC 8D 89 01
		iny				;9ABF C8
		lda (ZP_9A),Y	;9AC0 B1 9A
		clc				;9AC2 18
		adc ZP_1D		;9AC3 65 1D
		sta L_018A		;9AC5 8D 8A 01
		rts				;9AC8 60
.L_9AC9
		ldy #$02		;9AC9 A0 02
		jsr L_A026		;9ACB 20 26 A0
		ldx #$02		;9ACE A2 02
		jsr L_2458		;9AD0 20 58 24
		lda ZP_68		;9AD3 A5 68
		asl A			;9AD5 0A
		rol A			;9AD6 2A
		rol A			;9AD7 2A
		cmp #$02		;9AD8 C9 02
		bcc L_9ADE		;9ADA 90 02
		ora #$FC		;9ADC 09 FC
.L_9ADE	sta ZP_16		;9ADE 85 16
		lda L_A202		;9AE0 AD 02 A2
		clc				;9AE3 18
		adc ZP_32		;9AE4 65 32
		sta ZP_B9		;9AE6 85 B9
		lda L_A29A		;9AE8 AD 9A A2
		adc ZP_3E		;9AEB 65 3E
		clc				;9AED 18
		adc ZP_16		;9AEE 65 16
		bpl L_9AF5		;9AF0 10 03
		clc				;9AF2 18
		adc #$04		;9AF3 69 04
.L_9AF5	sec				;9AF5 38
		sbc #$02		;9AF6 E9 02
		sta ZP_BA		;9AF8 85 BA
		lda ZP_B9		;9AFA A5 B9
		sta ZP_14		;9AFC 85 14
		lda ZP_BA		;9AFE A5 BA
		ldy #$FA		;9B00 A0 FA
		jsr shift_16bit		;9B02 20 BF C9
		clc				;9B05 18
		adc #$40		;9B06 69 40
		sec				;9B08 38
		sbc ZP_9D		;9B09 E5 9D
		sta L_018A		;9B0B 8D 8A 01
		lda ZP_14		;9B0E A5 14
		sta L_0189		;9B10 8D 89 01
		lda ZP_B2		;9B13 A5 B2
		and #$03		;9B15 29 03
		eor #$FF		;9B17 49 FF
		clc				;9B19 18
		adc #$03		;9B1A 69 03
		sta ZP_16		;9B1C 85 16
		lda ZP_1D		;9B1E A5 1D
		asl A			;9B20 0A
		rol A			;9B21 2A
		rol A			;9B22 2A
		cmp #$02		;9B23 C9 02
		bcc L_9B29		;9B25 90 02
		ora #$FC		;9B27 09 FC
.L_9B29	sta ZP_15		;9B29 85 15
		ldy #$06		;9B2B A0 06
		lda ZP_B9		;9B2D A5 B9
		sec				;9B2F 38
		sbc (ZP_9A),Y	;9B30 F1 9A
		iny				;9B32 C8
		sta ZP_14		;9B33 85 14
		lda ZP_BA		;9B35 A5 BA
		sbc (ZP_9A),Y	;9B37 F1 9A
		sec				;9B39 38
		sbc ZP_15		;9B3A E5 15
		jsr negate_if_N_set		;9B3C 20 BD C8
		cmp #$04		;9B3F C9 04
		bcc L_9B4D		;9B41 90 0A
		sbc #$04		;9B43 E9 04
		jmp L_9B4D		;9B45 4C 4D 9B
.L_9B48	lsr A			;9B48 4A
		ror ZP_14		;9B49 66 14
		dec ZP_16		;9B4B C6 16
.L_9B4D	and #$FF		;9B4D 29 FF
		bne L_9B48		;9B4F D0 F7
		ldy #$08		;9B51 A0 08
		lda (ZP_9A),Y	;9B53 B1 9A
		sta ZP_15		;9B55 85 15
		lda ZP_14		;9B57 A5 14
		jsr mul_8_8_16bit		;9B59 20 82 C7
		lsr A			;9B5C 4A
		ror ZP_14		;9B5D 66 14
		ldy ZP_16		;9B5F A4 16
		jsr shift_16bit		;9B61 20 BF C9
		sta ZP_B4		;9B64 85 B4
		asl A			;9B66 0A
		clc				;9B67 18
		adc #$02		;9B68 69 02
		cmp ZP_9E		;9B6A C5 9E
		bcc L_9B9A		;9B6C 90 2C
		lda L_C3CD		;9B6E AD CD C3
		cmp #$01		;9B71 C9 01
		beq L_9B79		;9B73 F0 04
		cmp #$03		;9B75 C9 03
		bne L_9B9A		;9B77 D0 21
.L_9B79	lda ZP_2E		;9B79 A5 2E
		sta ZP_16		;9B7B 85 16
		lda ZP_A4		;9B7D A5 A4
		beq L_9B87		;9B7F F0 06
		jsr L_CFD2		;9B81 20 D2 CF
		jmp L_9B8A		;9B84 4C 8A 9B
.L_9B87	jsr L_CFC5		;9B87 20 C5 CF
.L_9B8A	lda L_0400,X	;9B8A BD 00 04
		and #$0F		;9B8D 29 0F
		cmp #$04		;9B8F C9 04
		bne L_9B96		;9B91 D0 03
		jmp L_9A38		;9B93 4C 38 9A
.L_9B96	lda ZP_16		;9B96 A5 16
		sta ZP_2E		;9B98 85 2E
.L_9B9A	lda ZP_14		;9B9A A5 14
		sta ZP_B3		;9B9C 85 B3
		jsr L_9BBE		;9B9E 20 BE 9B
		jsr L_9FB8		;9BA1 20 B8 9F
		ldy #$09		;9BA4 A0 09
		lda (ZP_9A),Y	;9BA6 B1 9A
		iny				;9BA8 C8
		sec				;9BA9 38
		sbc ZP_C1		;9BAA E5 C1
		sta ZP_14		;9BAC 85 14
		lda (ZP_9A),Y	;9BAE B1 9A
		sbc ZP_C2		;9BB0 E5 C2
		bit ZP_9D		;9BB2 24 9D
		jsr negate_if_N_set		;9BB4 20 BD C8
		sta ZP_B8		;9BB7 85 B8
		lda ZP_14		;9BB9 A5 14
		sta ZP_B7		;9BBB 85 B7
		rts				;9BBD 60
.L_9BBE	ldy #$03		;9BBE A0 03
		lda ZP_AB		;9BC0 A5 AB
		and #$07		;9BC2 29 07
		sta ZP_15		;9BC4 85 15
		lda ZP_AC		;9BC6 A5 AC
		bpl L_9BD8		;9BC8 10 0E
.L_9BCA	clc				;9BCA 18
		adc #$04		;9BCB 69 04
		iny				;9BCD C8
		cmp #$04		;9BCE C9 04
		bcs L_9BCA		;9BD0 B0 F8
		jmp L_9BDC		;9BD2 4C DC 9B
.L_9BD5	sbc #$04		;9BD5 E9 04
		dey				;9BD7 88
.L_9BD8	cmp #$04		;9BD8 C9 04
		bcs L_9BD5		;9BDA B0 F9
.L_9BDC	sta ZP_14		;9BDC 85 14
		lda ZP_AB		;9BDE A5 AB
		lsr ZP_14		;9BE0 46 14
		ror A			;9BE2 6A
		lsr ZP_14		;9BE3 46 14
		ror A			;9BE5 6A
		lsr A			;9BE6 4A
		tax				;9BE7 AA
		lda L_B001,X	;9BE8 BD 01 B0
		cpx #$7F		;9BEB E0 7F
		bne L_9BF1		;9BED D0 02
		lda #$00		;9BEF A9 00
.L_9BF1	sec				;9BF1 38
		sbc L_B000,X	;9BF2 FD 00 B0
		jsr mul_8_8_16bit		;9BF5 20 82 C7
		lda ZP_14		;9BF8 A5 14
		lsr A			;9BFA 4A
		lsr A			;9BFB 4A
		lsr A			;9BFC 4A
		adc #$00		;9BFD 69 00
		clc				;9BFF 18
		adc L_B000,X	;9C00 7D 00 B0
		sta ZP_14		;9C03 85 14
		lda #$00		;9C05 A9 00
		adc L_A380,X	;9C07 7D 80 A3
		jsr shift_16bit		;9C0A 20 BF C9
		sta ZP_C2		;9C0D 85 C2
		lda ZP_14		;9C0F A5 14
		sta ZP_C1		;9C11 85 C1
		rts				;9C13 60
}

.L_9C14
{
		bit ZP_A2		;9C14 24 A2
		bpl L_9C44		;9C16 10 2C
		txa				;9C18 8A
		lsr A			;9C19 4A
		bcs L_9C30		;9C1A B0 14
		asl A			;9C1C 0A
		tay				;9C1D A8
		iny				;9C1E C8
		lda (ZP_98),Y	;9C1F B1 98
		clc				;9C21 18
		adc ZP_3F		;9C22 65 3F
		sta ZP_14		;9C24 85 14
		dey				;9C26 88
		lda (ZP_98),Y	;9C27 B1 98
		and #$7F		;9C29 29 7F
		adc ZP_35		;9C2B 65 35
		jmp L_9C6D		;9C2D 4C 6D 9C
.L_9C30	asl A			;9C30 0A
		tay				;9C31 A8
		iny				;9C32 C8
		lda (ZP_CA),Y	;9C33 B1 CA
		clc				;9C35 18
		adc ZP_40		;9C36 65 40
		sta ZP_14		;9C38 85 14
		dey				;9C3A 88
		lda (ZP_CA),Y	;9C3B B1 CA
		and #$7F		;9C3D 29 7F
		adc ZP_36		;9C3F 65 36
		jmp L_9C6D		;9C41 4C 6D 9C
.L_9C44	txa				;9C44 8A
		lsr A			;9C45 4A
		bcs L_9C5C		;9C46 B0 14
		tay				;9C48 A8
		lda (ZP_98),Y	;9C49 B1 98
		asl A			;9C4B 0A
		and #$E0		;9C4C 29 E0
		clc				;9C4E 18
		adc ZP_3F		;9C4F 65 3F
		sta ZP_14		;9C51 85 14
		lda (ZP_98),Y	;9C53 B1 98
		and #$0F		;9C55 29 0F
		adc ZP_35		;9C57 65 35
		jmp L_9C6D		;9C59 4C 6D 9C
.L_9C5C	tay				;9C5C A8
		lda (ZP_CA),Y	;9C5D B1 CA
		asl A			;9C5F 0A
		and #$E0		;9C60 29 E0
		clc				;9C62 18
		adc ZP_40		;9C63 65 40
		sta ZP_14		;9C65 85 14
		lda (ZP_CA),Y	;9C67 B1 CA
		and #$0F		;9C69 29 0F
		adc ZP_36		;9C6B 65 36
.L_9C6D	sta ZP_15		;9C6D 85 15
		asl ZP_14		;9C6F 06 14
		rol A			;9C71 2A
		asl ZP_14		;9C72 06 14
		rol A			;9C74 2A
		asl ZP_14		;9C75 06 14
		rol A			;9C77 2A
		rts				;9C78 60
}

.L_9C79
{
		ldx ZP_B3		;9C79 A6 B3
		lda ZP_B4		;9C7B A5 B4
		bit ZP_A4		;9C7D 24 A4
		bpl L_9C8B		;9C7F 10 0A
		lda #$00		;9C81 A9 00
		sec				;9C83 38
		sbc ZP_B3		;9C84 E5 B3
		tax				;9C86 AA
		lda ZP_BE		;9C87 A5 BE
		sbc ZP_B4		;9C89 E5 B4
.L_9C8B	sta ZP_C3		;9C8B 85 C3
		stx ZP_22		;9C8D 86 22
		txa				;9C8F 8A
		clc				;9C90 18
		adc #$40		;9C91 69 40
		sta ZP_8D		;9C93 85 8D
		lda ZP_C3		;9C95 A5 C3
		adc #$00		;9C97 69 00
		tay				;9C99 A8
		cmp ZP_BE		;9C9A C5 BE
		bcc L_9CA2		;9C9C 90 04
		ldy #$00		;9C9E A0 00
		lda #$80		;9CA0 A9 80
.L_9CA2	sta ZP_8E		;9CA2 85 8E
		iny				;9CA4 C8
		tya				;9CA5 98
		asl A			;9CA6 0A
		sta ZP_27		;9CA7 85 27
		lda #$20		;9CA9 A9 20
		sec				;9CAB 38
		sbc ZP_C3		;9CAC E5 C3
		bit ZP_8E		;9CAE 24 8E
		bpl L_9CB5		;9CB0 10 03
		clc				;9CB2 18
		adc ZP_BE		;9CB3 65 BE
.L_9CB5	sta ZP_D2		;9CB5 85 D2
		sta ZP_D3		;9CB7 85 D3
		rts				;9CB9 60
}

; only called from game update
.L_9CBA_from_game_update
{
		ldx L_C374		;9CBA AE 74 C3
		stx ZP_2E		;9CBD 86 2E
		jsr get_track_segment_detailsQ		;9CBF 20 2F F0
		lda #$00		;9CC2 A9 00
		sta L_C359		;9CC4 8D 59 C3
		ldx #$02		;9CC7 A2 02
.L_9CC9	stx ZP_52		;9CC9 86 52
		lda L_C374		;9CCB AD 74 C3
		cmp ZP_2E		;9CCE C5 2E
		beq L_9CDA		;9CD0 F0 08
		tax				;9CD2 AA
		stx ZP_2E		;9CD3 86 2E
		jsr get_track_segment_detailsQ		;9CD5 20 2F F0
		ldx ZP_52		;9CD8 A6 52
.L_9CDA	lda ZP_BC		;9CDA A5 BC
		sta ZP_15		;9CDC 85 15
		lda #$00		;9CDE A9 00
		sta ZP_16		;9CE0 85 16
		lda L_0133,X	;9CE2 BD 33 01
		sta ZP_14		;9CE5 85 14
		bpl L_9CEB		;9CE7 10 02
		dec ZP_16		;9CE9 C6 16
.L_9CEB	lda L_0130,X	;9CEB BD 30 01
		lsr ZP_14		;9CEE 46 14
		ror A			;9CF0 6A
		lsr ZP_14		;9CF1 46 14
		ror A			;9CF3 6A
		lsr ZP_14		;9CF4 46 14
		ror A			;9CF6 6A
		lsr ZP_14		;9CF7 46 14
		ror A			;9CF9 6A
		clc				;9CFA 18
		adc ZP_B7		;9CFB 65 B7
		sta ZP_14		;9CFD 85 14
		lda ZP_16		;9CFF A5 16
		adc ZP_B8		;9D01 65 B8
		sta ZP_16		;9D03 85 16
		cmp #$01		;9D05 C9 01
		bcc L_9D29		;9D07 90 20
		bne L_9D11		;9D09 D0 06
		lda ZP_14		;9D0B A5 14
		cmp #$80		;9D0D C9 80
		bcc L_9D29		;9D0F 90 18
.L_9D11	sec				;9D11 38
		ror L_C3A6		;9D12 6E A6 C3
		lda ZP_14		;9D15 A5 14
		sta L_C3A4		;9D17 8D A4 C3
		lda ZP_16		;9D1A A5 16
		sta L_C3A5		;9D1C 8D A5 C3
		bmi L_9D25		;9D1F 30 04
		lda #$FF		;9D21 A9 FF
		bne L_9D4B		;9D23 D0 26
.L_9D25	lda #$00		;9D25 A9 00
		beq L_9D4B		;9D27 F0 22
.L_9D29	lda ZP_16		;9D29 A5 16
		beq L_9D34		;9D2B F0 07
		lda #$80		;9D2D A9 80
		sec				;9D2F 38
		sbc ZP_14		;9D30 E5 14
		sta ZP_14		;9D32 85 14
.L_9D34	lda ZP_14		;9D34 A5 14
		jsr mul_8_8_16bit		;9D36 20 82 C7
		ldy ZP_16		;9D39 A4 16
		beq L_9D40		;9D3B F0 03
		jsr negate_16bit		;9D3D 20 BF C8
.L_9D40	bit ZP_14		;9D40 24 14
		bpl L_9D4B		;9D42 10 07
		clc				;9D44 18
		adc #$01		;9D45 69 01
		bcc L_9D4B		;9D47 90 02
		lda #$FF		;9D49 A9 FF
.L_9D4B	sta ZP_4C		;9D4B 85 4C
		bit ZP_A4		;9D4D 24 A4
		bpl L_9D53		;9D4F 10 02
		eor #$FF		;9D51 49 FF
.L_9D53	cpx #$02		;9D53 E0 02
		bne L_9D59		;9D55 D0 02
		sta ZP_2B		;9D57 85 2B
.L_9D59	lda ZP_BD		;9D59 A5 BD
		sta ZP_15		;9D5B 85 15
		lda #$00		;9D5D A9 00
		sta ZP_16		;9D5F 85 16
		sta ZP_5A		;9D61 85 5A
		lda L_0139,X	;9D63 BD 39 01
		sta ZP_14		;9D66 85 14
		bpl L_9D6C		;9D68 10 02
		dec ZP_16		;9D6A C6 16
.L_9D6C	lda L_0136,X	;9D6C BD 36 01
		lsr ZP_14		;9D6F 46 14
		ror A			;9D71 6A
		lsr ZP_14		;9D72 46 14
		ror A			;9D74 6A
		lsr ZP_14		;9D75 46 14
		ror A			;9D77 6A
		lsr ZP_14		;9D78 46 14
		ror A			;9D7A 6A
		jsr L_C81E		;9D7B 20 1E C8
		asl ZP_14		;9D7E 06 14
		rol A			;9D80 2A
		clc				;9D81 18
		adc ZP_B3		;9D82 65 B3
		sta ZP_4D		;9D84 85 4D
		lda ZP_16		;9D86 A5 16
		adc ZP_B4		;9D88 65 B4
		sta ZP_BF		;9D8A 85 BF
		asl A			;9D8C 0A
		sta ZP_C0		;9D8D 85 C0
		bmi L_9D95		;9D8F 30 04
		cmp ZP_62		;9D91 C5 62
		bcc L_9D98		;9D93 90 03
.L_9D95	jsr L_9E74		;9D95 20 74 9E
.L_9D98	lda ZP_A4		;9D98 A5 A4
		bne L_9DCA		;9D9A D0 2E
		ldx ZP_C0		;9D9C A6 C0
		jsr L_9C14		;9D9E 20 14 9C
		sta ZP_48		;9DA1 85 48
		lda ZP_15		;9DA3 A5 15
		lsr A			;9DA5 4A
		lsr A			;9DA6 4A
		lsr A			;9DA7 4A
		lsr A			;9DA8 4A
		lsr A			;9DA9 4A
		sta ZP_5B		;9DAA 85 5B
		inx				;9DAC E8
		jsr L_9C14		;9DAD 20 14 9C
		sta ZP_49		;9DB0 85 49
		inx				;9DB2 E8
		jsr L_9C14		;9DB3 20 14 9C
		sta ZP_4A		;9DB6 85 4A
		lda ZP_15		;9DB8 A5 15
		lsr A			;9DBA 4A
		lsr A			;9DBB 4A
		lsr A			;9DBC 4A
		lsr A			;9DBD 4A
		lsr A			;9DBE 4A
		sta ZP_DC		;9DBF 85 DC
		inx				;9DC1 E8
		jsr L_9C14		;9DC2 20 14 9C
		sta ZP_4B		;9DC5 85 4B
		jmp L_9DFC		;9DC7 4C FC 9D
.L_9DCA	lda ZP_9E		;9DCA A5 9E
		sec				;9DCC 38
		sbc ZP_C0		;9DCD E5 C0
		sec				;9DCF 38
		sbc #$04		;9DD0 E9 04
		tax				;9DD2 AA
		jsr L_9C14		;9DD3 20 14 9C
		sta ZP_4B		;9DD6 85 4B
		inx				;9DD8 E8
		jsr L_9C14		;9DD9 20 14 9C
		sta ZP_4A		;9DDC 85 4A
		lda ZP_15		;9DDE A5 15
		lsr A			;9DE0 4A
		lsr A			;9DE1 4A
		lsr A			;9DE2 4A
		lsr A			;9DE3 4A
		lsr A			;9DE4 4A
		sta ZP_DC		;9DE5 85 DC
		inx				;9DE7 E8
		jsr L_9C14		;9DE8 20 14 9C
		sta ZP_49		;9DEB 85 49
		inx				;9DED E8
		jsr L_9C14		;9DEE 20 14 9C
		sta ZP_48		;9DF1 85 48
		lda ZP_15		;9DF3 A5 15
		lsr A			;9DF5 4A
		lsr A			;9DF6 4A
		lsr A			;9DF7 4A
		lsr A			;9DF8 4A
		lsr A			;9DF9 4A
		sta ZP_5B		;9DFA 85 5B
.L_9DFC	ldx ZP_52		;9DFC A6 52
		jsr L_9F6A		;9DFE 20 6A 9F
		dex				;9E01 CA
		bmi L_9E07		;9E02 30 03
		jmp L_9CC9		;9E04 4C C9 9C
.L_9E07	rts				;9E07 60
}

.L_9E08
{
		bit ZP_3D		;9E08 24 3D
		bmi L_9E42		;9E0A 30 36
		bvs L_9E29		;9E0C 70 1B
		lda #$00		;9E0E A9 00
		sec				;9E10 38
		sbc ZP_92		;9E11 E5 92
		sta ZP_51		;9E13 85 51
		lda #$00		;9E15 A9 00
		sbc ZP_93		;9E17 E5 93
		sta ZP_77		;9E19 85 77
		lda #$00		;9E1B A9 00
		sec				;9E1D 38
		sbc ZP_94		;9E1E E5 94
		sta ZP_52		;9E20 85 52
		lda #$00		;9E22 A9 00
		sbc ZP_95		;9E24 E5 95
		sta ZP_78		;9E26 85 78
		rts				;9E28 60
.L_9E29	lda #$00		;9E29 A9 00
		sec				;9E2B 38
		sbc ZP_94		;9E2C E5 94
		sta ZP_51		;9E2E 85 51
		lda #$00		;9E30 A9 00
		sbc ZP_95		;9E32 E5 95
		sta ZP_77		;9E34 85 77
		lda ZP_92		;9E36 A5 92
		sta ZP_52		;9E38 85 52
		lda #$08		;9E3A A9 08
		clc				;9E3C 18
		adc ZP_93		;9E3D 65 93
		sta ZP_78		;9E3F 85 78
		rts				;9E41 60
.L_9E42	bvs L_9E5B		;9E42 70 17
		lda ZP_92		;9E44 A5 92
		sta ZP_51		;9E46 85 51
		lda #$08		;9E48 A9 08
		clc				;9E4A 18
		adc ZP_93		;9E4B 65 93
		sta ZP_77		;9E4D 85 77
		lda ZP_94		;9E4F A5 94
		sta ZP_52		;9E51 85 52
		lda #$08		;9E53 A9 08
		clc				;9E55 18
		adc ZP_95		;9E56 65 95
		sta ZP_78		;9E58 85 78
		rts				;9E5A 60
.L_9E5B	lda ZP_94		;9E5B A5 94
		sta ZP_51		;9E5D 85 51
		lda #$08		;9E5F A9 08
		clc				;9E61 18
		adc ZP_95		;9E62 65 95
		sta ZP_77		;9E64 85 77
		lda #$00		;9E66 A9 00
		sec				;9E68 38
		sbc ZP_92		;9E69 E5 92
		sta ZP_52		;9E6B 85 52
		lda #$00		;9E6D A9 00
		sbc ZP_93		;9E6F E5 93
		sta ZP_78		;9E71 85 78
		rts				;9E73 60
}

.L_9E74
{
		lda ZP_BF		;9E74 A5 BF
		eor ZP_A4		;9E76 45 A4
		bpl L_9E86		;9E78 10 0C
		jsr L_CFD2		;9E7A 20 D2 CF
		jsr get_track_segment_detailsQ		;9E7D 20 2F F0
		lda ZP_A4		;9E80 A5 A4
		bpl L_9E9A		;9E82 10 16
		bmi L_9E90		;9E84 30 0A
.L_9E86	jsr L_CFC5		;9E86 20 C5 CF
		jsr get_track_segment_detailsQ		;9E89 20 2F F0
		lda ZP_A4		;9E8C A5 A4
		bmi L_9E9A		;9E8E 30 0A
.L_9E90	lda #$00		;9E90 A9 00
		sta ZP_C0		;9E92 85 C0
		lda ZP_BF		;9E94 A5 BF
		bpl L_9EBB		;9E96 10 23
		bmi L_9EA5		;9E98 30 0B
.L_9E9A	lda ZP_9E		;9E9A A5 9E
		sec				;9E9C 38
		sbc #$04		;9E9D E9 04
		sta ZP_C0		;9E9F 85 C0
		lda ZP_BF		;9EA1 A5 BF
		bmi L_9EBB		;9EA3 30 16
.L_9EA5	lda #$00		;9EA5 A9 00
		sec				;9EA7 38
		sbc ZP_4D		;9EA8 E5 4D
		bne L_9EAE		;9EAA D0 02
		lda #$FF		;9EAC A9 FF
.L_9EAE	sta ZP_4D		;9EAE 85 4D
		lda #$00		;9EB0 A9 00
		sec				;9EB2 38
		sbc ZP_4C		;9EB3 E5 4C
		bne L_9EB9		;9EB5 D0 02
		lda #$FF		;9EB7 A9 FF
.L_9EB9	sta ZP_4C		;9EB9 85 4C
.L_9EBB	rts				;9EBB 60
}

.L_9EBC
{
		lda #$00		;9EBC A9 00
		sta ZP_5A		;9EBE 85 5A
		lda ZP_4C		;9EC0 A5 4C
		sta ZP_15		;9EC2 85 15
		lda ZP_49		;9EC4 A5 49
		sec				;9EC6 38
		sbc ZP_48		;9EC7 E5 48
		jsr L_C81E		;9EC9 20 1E C8
		sta ZP_44		;9ECC 85 44
		clc				;9ECE 18
		adc ZP_48		;9ECF 65 48
		sta ZP_19		;9ED1 85 19
		lda #$00		;9ED3 A9 00
		bit ZP_44		;9ED5 24 44
		bpl L_9EDB		;9ED7 10 02
		lda #$FF		;9ED9 A9 FF
.L_9EDB	adc ZP_5B		;9EDB 65 5B
		sta ZP_1A		;9EDD 85 1A
		lda ZP_14		;9EDF A5 14
		sta ZP_18		;9EE1 85 18
		lda ZP_4B		;9EE3 A5 4B
		sec				;9EE5 38
		sbc ZP_4A		;9EE6 E5 4A
		jsr L_C81E		;9EE8 20 1E C8
		sta ZP_44		;9EEB 85 44
		clc				;9EED 18
		adc ZP_4A		;9EEE 65 4A
		sta ZP_17		;9EF0 85 17
		lda #$00		;9EF2 A9 00
		bit ZP_44		;9EF4 24 44
		bpl L_9EFA		;9EF6 10 02
		lda #$FF		;9EF8 A9 FF
.L_9EFA	adc ZP_DC		;9EFA 65 DC
		sta ZP_1B		;9EFC 85 1B
		lda ZP_4D		;9EFE A5 4D
		sta ZP_15		;9F00 85 15
		lda ZP_14		;9F02 A5 14
		sec				;9F04 38
		sbc ZP_18		;9F05 E5 18
		sta ZP_14		;9F07 85 14
		lda ZP_17		;9F09 A5 17
		sbc ZP_19		;9F0B E5 19
		sta ZP_16		;9F0D 85 16
		lda ZP_1B		;9F0F A5 1B
		sbc ZP_1A		;9F11 E5 1A
		bpl L_9F3F		;9F13 10 2A
		cmp #$FF		;9F15 C9 FF
		bne L_9F1D		;9F17 D0 04
		bit ZP_16		;9F19 24 16
		bmi L_9F45		;9F1B 30 28
.L_9F1D	lsr A			;9F1D 4A
		ror ZP_16		;9F1E 66 16
		ror ZP_14		;9F20 66 14
		lsr A			;9F22 4A
		ror ZP_16		;9F23 66 16
		ror ZP_14		;9F25 66 14
		lsr A			;9F27 4A
		ror ZP_16		;9F28 66 16
		ror ZP_14		;9F2A 66 14
		lda ZP_16		;9F2C A5 16
		jsr mul_8_16_16bit_2		;9F2E 20 47 C8
		ldy #$FD		;9F31 A0 FD
		jsr shift_16bit		;9F33 20 BF C9
		sta ZP_15		;9F36 85 15
		lda ZP_2D		;9F38 A5 2D
		sta ZP_16		;9F3A 85 16
		jmp L_9F56		;9F3C 4C 56 9F
.L_9F3F	bne L_9F1D		;9F3F D0 DC
		bit ZP_16		;9F41 24 16
		bmi L_9F1D		;9F43 30 D8
.L_9F45	lda ZP_16		;9F45 A5 16
		jsr mul_8_16_16bit_2		;9F47 20 47 C8
		sta ZP_15		;9F4A 85 15
		lda #$00		;9F4C A9 00
		bit ZP_15		;9F4E 24 15
		bpl L_9F54		;9F50 10 02
		lda #$FF		;9F52 A9 FF
.L_9F54	sta ZP_16		;9F54 85 16
.L_9F56	lda ZP_14		;9F56 A5 14
		clc				;9F58 18
		adc ZP_18		;9F59 65 18
		sta ZP_14		;9F5B 85 14
		lda ZP_15		;9F5D A5 15
		adc ZP_19		;9F5F 65 19
		sta ZP_15		;9F61 85 15
		lda ZP_16		;9F63 A5 16
		adc ZP_1A		;9F65 65 1A
		sta ZP_16		;9F67 85 16
		rts				;9F69 60
}

.L_9F6A
{
		jsr L_9EBC		;9F6A 20 BC 9E
		asl L_C3A6		;9F6D 0E A6 C3
		bcc L_9F75		;9F70 90 03
		jsr L_A0B6		;9F72 20 B6 A0
.L_9F75	lda L_0188		;9F75 AD 88 01
		cmp #$0A		;9F78 C9 0A
		bcc L_9F8C		;9F7A 90 10
.L_9F7C	lda ZP_14		;9F7C A5 14
		sta L_C340,X	;9F7E 9D 40 C3
		lda ZP_15		;9F81 A5 15
		sta L_C343,X	;9F83 9D 43 C3
		lda ZP_16		;9F86 A5 16
		sta L_C3CE,X	;9F88 9D CE C3
		rts				;9F8B 60
.L_9F8C	lda L_0124		;9F8C AD 24 01
		bpl L_9F93		;9F8F 10 02
		eor #$FF		;9F91 49 FF
.L_9F93	cmp #$05		;9F93 C9 05
		bcs L_9F7C		;9F95 B0 E5
		lda ZP_14		;9F97 A5 14
		clc				;9F99 18
		adc L_C340,X	;9F9A 7D 40 C3
		sta L_C340,X	;9F9D 9D 40 C3
		lda ZP_15		;9FA0 A5 15
		adc L_C343,X	;9FA2 7D 43 C3
		sta L_C343,X	;9FA5 9D 43 C3
		lda ZP_16		;9FA8 A5 16
		adc L_C3CE,X	;9FAA 7D CE C3
		ror A			;9FAD 6A
		sta L_C3CE,X	;9FAE 9D CE C3
		ror L_C343,X	;9FB1 7E 43 C3
		ror L_C340,X	;9FB4 7E 40 C3
		rts				;9FB7 60
}

.L_9FB8
		lda ZP_77		;9FB8 A5 77
		ldy ZP_51		;9FBA A4 51
		jsr square_ay_32bit		;9FBC 20 76 C9
		lda ZP_16		;9FBF A5 16
		sta ZP_48		;9FC1 85 48
		lda ZP_17		;9FC3 A5 17
		sta ZP_49		;9FC5 85 49
		lda ZP_18		;9FC7 A5 18
		sta ZP_4A		;9FC9 85 4A
		lda ZP_78		;9FCB A5 78
		ldy ZP_52		;9FCD A4 52
		jsr square_ay_32bit		;9FCF 20 76 C9
		lda ZP_16		;9FD2 A5 16
		clc				;9FD4 18
		adc ZP_48		;9FD5 65 48
		sta ZP_48		;9FD7 85 48
		lda ZP_17		;9FD9 A5 17
		adc ZP_49		;9FDB 65 49
		sta ZP_49		;9FDD 85 49
		lda ZP_18		;9FDF A5 18
		adc ZP_4A		;9FE1 65 4A
		sta ZP_4A		;9FE3 85 4A
		lda ZP_C2		;9FE5 A5 C2
		ldy ZP_C1		;9FE7 A4 C1
		jsr square_ay_32bit		;9FE9 20 76 C9
		ldy L_C3CD		;9FEC AC CD C3
		lda L_A01B,Y	;9FEF B9 1B A0
		sta ZP_15		;9FF2 85 15
		lda ZP_48		;9FF4 A5 48
		sec				;9FF6 38
		sbc ZP_16		;9FF7 E5 16
		lda ZP_49		;9FF9 A5 49
		sbc ZP_17		;9FFB E5 17
		sta ZP_14		;9FFD 85 14
		lda ZP_4A		;9FFF A5 4A
L_A000	= *-1			;!
		sbc ZP_18		;A001 E5 18
		jsr mul_8_16_16bit		;A003 20 45 C8
		ldy #$04		;A006 A0 04
		jsr shift_16bit		;A008 20 BF C9
		sta ZP_15		;A00B 85 15
		lda ZP_C1		;A00D A5 C1
		clc				;A00F 18
		adc ZP_14		;A010 65 14
		sta ZP_C1		;A012 85 C1
		lda ZP_C2		;A014 A5 C2
		adc ZP_15		;A016 65 15
		sta ZP_C2		;A018 85 C2
		rts				;A01A 60

.L_A01B	equb $00,$D4,$80,$D4,$00,$00,$AB,$AB,$40,$40,$00

; fetch coordinates (?) from track	data pointed by	(word_9a) with postincrement, munged appropriately for camera
; entry: Y	= index	into (word_9A) data
; exit: Y points after data read

.L_A026
{
		bit ZP_3D		;A026 24 3D
		bmi L_A06D		;A028 30 43
		bvs L_A04B		;A02A 70 1F
		lda ZP_92		;A02C A5 92
		clc				;A02E 18
		adc (ZP_9A),Y	;A02F 71 9A
		iny				;A031 C8
		sta ZP_51		;A032 85 51
		lda ZP_93		;A034 A5 93
		adc (ZP_9A),Y	;A036 71 9A
		iny				;A038 C8
		sta ZP_77		;A039 85 77
		lda ZP_94		;A03B A5 94
		clc				;A03D 18
		adc (ZP_9A),Y	;A03E 71 9A
		iny				;A040 C8
		sta ZP_52		;A041 85 52
		lda (ZP_9A),Y	;A043 B1 9A
		iny				;A045 C8
		adc ZP_95		;A046 65 95
		sta ZP_78		;A048 85 78
		rts				;A04A 60
.L_A04B	lda ZP_94		;A04B A5 94
		clc				;A04D 18
		adc (ZP_9A),Y	;A04E 71 9A
		iny				;A050 C8
		sta ZP_52		;A051 85 52
		lda ZP_95		;A053 A5 95
		adc (ZP_9A),Y	;A055 71 9A
		iny				;A057 C8
		sta ZP_78		;A058 85 78
		lda ZP_92		;A05A A5 92
		sec				;A05C 38
		sbc (ZP_9A),Y	;A05D F1 9A
		iny				;A05F C8
		sta ZP_51		;A060 85 51
		lda ZP_93		;A062 A5 93
		sbc (ZP_9A),Y	;A064 F1 9A
		iny				;A066 C8
		clc				;A067 18
		adc #$08		;A068 69 08
		sta ZP_77		;A06A 85 77
		rts				;A06C 60
.L_A06D	bvs L_A094		;A06D 70 25
		lda ZP_92		;A06F A5 92
		sec				;A071 38
		sbc (ZP_9A),Y	;A072 F1 9A
		iny				;A074 C8
		sta ZP_51		;A075 85 51
		lda ZP_93		;A077 A5 93
		sbc (ZP_9A),Y	;A079 F1 9A
		iny				;A07B C8
		clc				;A07C 18
		adc #$08		;A07D 69 08
		sta ZP_77		;A07F 85 77
		lda ZP_94		;A081 A5 94
		sec				;A083 38
		sbc (ZP_9A),Y	;A084 F1 9A
		iny				;A086 C8
		sta ZP_52		;A087 85 52
		lda ZP_95		;A089 A5 95
		sbc (ZP_9A),Y	;A08B F1 9A
		iny				;A08D C8
		clc				;A08E 18
		adc #$08		;A08F 69 08
		sta ZP_78		;A091 85 78
		rts				;A093 60
.L_A094	lda ZP_94		;A094 A5 94
		sec				;A096 38
		sbc (ZP_9A),Y	;A097 F1 9A
		iny				;A099 C8
		sta ZP_52		;A09A 85 52
		lda ZP_95		;A09C A5 95
		sbc (ZP_9A),Y	;A09E F1 9A
		iny				;A0A0 C8
		clc				;A0A1 18
		adc #$08		;A0A2 69 08
		sta ZP_78		;A0A4 85 78
		lda ZP_92		;A0A6 A5 92
		clc				;A0A8 18
		adc (ZP_9A),Y	;A0A9 71 9A
		iny				;A0AB C8
		sta ZP_51		;A0AC 85 51
		lda ZP_93		;A0AE A5 93
		adc (ZP_9A),Y	;A0B0 71 9A
		iny				;A0B2 C8
		sta ZP_77		;A0B3 85 77
		rts				;A0B5 60
}

.L_A0B6
{
		lda ZP_16		;A0B6 A5 16
		sta ZP_1A		;A0B8 85 1A
		lda ZP_15		;A0BA A5 15
		sta ZP_19		;A0BC 85 19
		lda ZP_14		;A0BE A5 14
		sta ZP_18		;A0C0 85 18
		lda L_C3A5		;A0C2 AD A5 C3
		bpl L_A0CF		;A0C5 10 08
		ldy L_C3A4		;A0C7 AC A4 C3
		sty ZP_14		;A0CA 84 14
		jmp L_A0DC		;A0CC 4C DC A0
.L_A0CF	lda #$80		;A0CF A9 80
		sec				;A0D1 38
		sbc L_C3A4		;A0D2 ED A4 C3
		sta ZP_14		;A0D5 85 14
		lda #$01		;A0D7 A9 01
		sbc L_C3A5		;A0D9 ED A5 C3
.L_A0DC	jsr negate_if_N_set		;A0DC 20 BD C8
		cmp #$00		;A0DF C9 00
		bne L_A123		;A0E1 D0 40
		ldy #$FC		;A0E3 A0 FC
		jsr shift_16bit		;A0E5 20 BF C9
		sta ZP_15		;A0E8 85 15
		lda #$00		;A0EA A9 00
		sta ZP_16		;A0EC 85 16
		lda ZP_15		;A0EE A5 15
		cmp #$03		;A0F0 C9 03
		bcs L_A123		;A0F2 B0 2F
		lda ZP_18		;A0F4 A5 18
		sec				;A0F6 38
		sbc ZP_14		;A0F7 E5 14
		sta ZP_14		;A0F9 85 14
		lda ZP_19		;A0FB A5 19
		sbc ZP_15		;A0FD E5 15
		sta ZP_15		;A0FF 85 15
		lda ZP_1A		;A101 A5 1A
		sbc ZP_16		;A103 E5 16
		sta ZP_16		;A105 85 16
		bne L_A114		;A107 D0 0B
		lda ZP_15		;A109 A5 15
		sec				;A10B 38
		sbc #$01		;A10C E9 01
		cmp #$10		;A10E C9 10
		bcc L_A123		;A110 90 11
		sta ZP_15		;A112 85 15
.L_A114	lda L_C3A5		;A114 AD A5 C3
		eor ZP_A4		;A117 45 A4
		and #$80		;A119 29 80
		bmi L_A11F		;A11B 30 02
		lda #$40		;A11D A9 40
.L_A11F	sta L_C30A		;A11F 8D 0A C3
		rts				;A122 60
.L_A123	sec				;A123 38
		ror L_C359		;A124 6E 59 C3
		lda #$10		;A127 A9 10
		sta ZP_15		;A129 85 15
		lda #$00		;A12B A9 00
		sta ZP_14		;A12D 85 14
		sta ZP_16		;A12F 85 16
		rts				;A131 60
}

.calculate_camera_sines
{
		lda #$00		;A132 A9 00
		sta ZP_79		;A134 85 79
		sta ZP_7A		;A136 85 7A
		lda L_0121		;A138 AD 21 01
		sta ZP_14		;A13B 85 14
		lda L_0124		;A13D AD 24 01
		jsr accurate_sin		;A140 20 CD C8
		sta ZP_77		;A143 85 77
		and #$FF		;A145 29 FF
		bpl L_A14B		;A147 10 02
		dec ZP_79		;A149 C6 79
.L_A14B	lda ZP_14		;A14B A5 14
		sta ZP_51		;A14D 85 51
		lda L_0123		;A14F AD 23 01
		sta ZP_14		;A152 85 14
		lda L_0126		;A154 AD 26 01
		jsr accurate_sin		;A157 20 CD C8
		sta ZP_43		;A15A 85 43
		and #$FF		;A15C 29 FF
		bpl L_A162		;A15E 10 02
		dec ZP_7A		;A160 C6 7A
.L_A162	asl A			;A162 0A
		ror ZP_43		;A163 66 43
		ror ZP_14		;A165 66 14
		lda ZP_14		;A167 A5 14
		sta ZP_56		;A169 85 56
		lda L_0101		;A16B AD 01 01
		sec				;A16E 38
		sbc ZP_51		;A16F E5 51
		sta L_C348		;A171 8D 48 C3
		lda L_0104		;A174 AD 04 01
		sbc ZP_77		;A177 E5 77
		sta L_C34B		;A179 8D 4B C3
		lda L_0107		;A17C AD 07 01
		sbc ZP_79		;A17F E5 79
		sta L_C3D3		;A181 8D D3 C3
		lda L_0101		;A184 AD 01 01
		clc				;A187 18
		adc ZP_51		;A188 65 51
		sta ZP_14		;A18A 85 14
		lda L_0104		;A18C AD 04 01
		adc ZP_77		;A18F 65 77
		sta ZP_15		;A191 85 15
		lda L_0107		;A193 AD 07 01
		adc ZP_79		;A196 65 79
		sta ZP_16		;A198 85 16
		lda ZP_14		;A19A A5 14
		sec				;A19C 38
		sbc ZP_56		;A19D E5 56
		sta L_C347		;A19F 8D 47 C3
		lda ZP_15		;A1A2 A5 15
		sbc ZP_43		;A1A4 E5 43
		sta L_C34A		;A1A6 8D 4A C3
		lda ZP_16		;A1A9 A5 16
		sbc ZP_7A		;A1AB E5 7A
		sta L_C3D2		;A1AD 8D D2 C3
		lda ZP_14		;A1B0 A5 14
		clc				;A1B2 18
		adc ZP_56		;A1B3 65 56
		sta L_C346		;A1B5 8D 46 C3
		lda ZP_15		;A1B8 A5 15
		adc ZP_43		;A1BA 65 43
		sta L_C349		;A1BC 8D 49 C3
		lda ZP_16		;A1BF A5 16
		adc ZP_7A		;A1C1 65 7A
		sta L_C3D1		;A1C3 8D D1 C3
		rts				;A1C6 60
}

.L_A1C7	jsr write_char		;A1C7 20 6F 84
		inx				;A1CA E8
.print_msg_2
{
		bit L_31A0		;A1CB 2C A0 31
		bmi print_msg_3		;A1CE 30 0C
		lda frontend_strings_2,X	;A1D0 BD 00 E0
		cmp #$FF		;A1D3 C9 FF
		bne L_A1C7		;A1D5 D0 F0
		rts				;A1D7 60
}

.L_A1D8	jsr write_char		;A1D8 20 6F 84
		inx				;A1DB E8
.print_msg_3
{
		lda frontend_strings_3,X	;A1DC BD AA 31
		cmp #$FF		;A1DF C9 FF
		bne L_A1D8		;A1E1 D0 F5
		rts				;A1E3 60
		tya				;A1E4 98
		sta ZP_14		;A1E5 85 14
		asl A			;A1E7 0A
		adc ZP_14		;A1E8 65 14
		asl A			;A1EA 0A
		asl A			;A1EB 0A
		asl A			;A1EC 0A
		clc				;A1ED 18
		adc #$08		;A1EE 69 08
		tay				;A1F0 A8
		rts				;A1F1 60
}

.L_A1F2	equb $E8,$46,$4B,$53,$52,$46,$55,$48,$42,$45,$52,$44
.L_A1FE	equb $42
.L_A1FF	equb $49

.L_A200	skip &180
L_A202	= L_A200 + $02
L_A203	= L_A200 + $03
L_A21E	= L_A200 + $1E
L_A21F	= L_A200 + $1F
L_A220	= L_A200 + $20
L_A221	= L_A200 + $21
L_A240	= L_A200 + $40
L_A241	= L_A200 + $41
L_A242	= L_A200 + $42
L_A243	= L_A200 + $43
L_A244	= L_A200 + $44
L_A245	= L_A200 + $45
L_A246	= L_A200 + $46
L_A247	= L_A200 + $47
L_A248	= L_A200 + $48
L_A249	= L_A200 + $49
L_A24A	= L_A200 + $4A
L_A24B	= L_A200 + $4B
L_A24C	= L_A200 + $4C
L_A24E	= L_A200 + $4E
L_A26C	= L_A200 + $6C
L_A26D	= L_A200 + $6D
L_A288	= L_A200 + $88
L_A289	= L_A200 + $89
L_A28C	= L_A200 + $8C
L_A28D	= L_A200 + $8D
L_A28E	= L_A200 + $8E
L_A28F	= L_A200 + $8F
L_A290	= L_A200 + $90
L_A291	= L_A200 + $91
L_A292	= L_A200 + $92
L_A293	= L_A200 + $93
L_A294	= L_A200 + $94
L_A295	= L_A200 + $95
L_A296	= L_A200 + $96
L_A297	= L_A200 + $97
L_A298	= L_A200 + $98
L_A29A	= L_A200 + $9A
L_A29B	= L_A200 + $9B
L_A2B6	= L_A200 + $B6
L_A2B7	= L_A200 + $B7
L_A2B8	= L_A200 + $B8
L_A2E4	= L_A200 + $E4
L_A2E6	= L_A200 + $E6

L_A320	= L_A200 + $120
L_A321	= L_A200 + $121
L_A32E	= L_A200 + $12E
L_A32F	= L_A200 + $12F
L_A330	= L_A200 + $130
L_A331	= L_A200 + $131
L_A350	= L_A200 + $150
L_A36C	= L_A200 + $16C
L_A36D	= L_A200 + $16D
L_A36E	= L_A200 + $16E
L_A36F	= L_A200 + $16F

.L_A380	equb $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08
		equb $08,$08,$08,$08,$08,$08,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09
		equb $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$0A,$0A,$0A,$0A,$0A,$0A
		equb $0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0B,$0B,$0B,$0B,$0B
		equb $0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0B,$0C,$0C,$0C,$0C,$0C
		equb $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0D,$0D,$0D,$0D,$0D,$0D
		equb $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
		equb $0E,$0E,$0E,$0E,$0E,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F

; LO pointers to C64 COLOR RAM?

.L_A400	equb $00,$00,$00,$00,$00,$00,$04,$2C,$54,$7C,$A4,$CC,$F4,$1C,$44,$6C
		equb $94,$BC,$E4,$0C,$34,$5C,$84,$AC

; HI pointers to C64 COLOR RAM?

.L_A418	equb $D8,$D8,$D8,$D8,$D8,$D8,$D8,$D8,$D8,$D8,$D8,$D8,$D8,$D9,$D9,$D9
		equb $D9,$D9,$D9,$DA,$DA,$DA,$DA,$DA

		equb $85,$33,$A5,$31,$85,$32,$A9,$00
		equb $85,$31,$F0,$D0,$46,$31,$66,$32

		equb $3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC
		equb $3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC
		equb $3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC
		equb $3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC
		equb $3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC
		equb $3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC
		equb $3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC
		equb $3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC
		equb $3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC

.L_A4C0	equb $7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD
		equb $7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD
		equb $7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD
		equb $7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD

ORG &A500

; LO pointers?

.Q_pointers_LO
		equb $7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD
		equb $7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD
		equb $7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD
		equb $7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD,$7F,$DF,$F7,$FD
		equb $60,$60,$60,$60,$60,$60,$60,$60,$98,$98,$98,$98,$98,$98,$98,$98
		equb $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0,$08,$08,$08,$08,$08,$08,$08,$08
		equb $40,$40,$40,$40,$40,$40,$40,$40,$78,$78,$78,$78,$78,$78,$78,$78
		equb $B0,$B0,$B0,$B0,$B0,$B0,$B0,$B0,$E8,$E8,$E8,$E8,$E8,$E8,$E8,$E8
		equb $20,$20,$20,$20,$20,$20,$20,$20,$58,$58,$58,$58,$58,$58,$58,$58
		equb $90,$90,$90,$90,$90,$90,$90,$90,$C8,$C8,$C8,$C8,$C8,$C8,$C8,$C8
		equb $00,$00,$00,$00,$00,$00,$00,$00,$38,$38,$38,$38,$38,$38,$38,$38
		equb $70,$70,$70,$70,$70,$70,$70,$70,$A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8
		equb $E0,$E0,$E0,$E0,$E0,$E0,$E0,$E0,$18,$18,$18,$18,$18,$18,$18,$18
		equb $50,$50,$50,$50,$50,$50,$50,$50,$88,$88,$88,$88,$88,$88,$88,$88
		equb $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$F8,$F8,$F8,$F8,$F8,$F8,$F8,$F8
		equb $30,$30,$30,$30,$30,$30,$30,$30,$68,$68,$68,$68,$68,$68,$68,$68

; HI pointers?

.Q_pointers_HI
		equb $07,$06,$05,$04,$03,$02,$01,$00,$07,$06,$05,$04,$03,$02,$01,$00
.L_A610	equb $E0,$E4,$E8,$EC,$F0,$F4,$F8,$FC,$E0,$E4,$E8,$EC,$F0,$F4,$F8,$FC
.L_A620	equb $1B,$1B,$1B,$1B,$1B,$1A,$1A,$1A,$19,$19,$19,$18,$17,$17,$16,$15
		equb $14,$13,$12,$11,$0F,$0E,$0B,$09,$07,$07,$07,$07,$07,$07,$07,$07
		equb $42,$42,$42,$42,$42,$42,$42,$42,$43,$43,$43,$43,$43,$43,$43,$43
		equb $44,$44,$44,$44,$44,$44,$44,$44,$46,$46,$46,$46,$46,$46,$46,$46
		equb $47,$47,$47,$47,$47,$47,$47,$47,$48,$48,$48,$48,$48,$48,$48,$48
		equb $49,$49,$49,$49,$49,$49,$49,$49,$4A,$4A,$4A,$4A,$4A,$4A,$4A,$4A
		equb $4C,$4C,$4C,$4C,$4C,$4C,$4C,$4C,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D
		equb $4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4F,$4F,$4F,$4F,$4F,$4F,$4F,$4F
		equb $51,$51,$51,$51,$51,$51,$51,$51,$52,$52,$52,$52,$52,$52,$52,$52
		equb $53,$53,$53,$53,$53,$53,$53,$53,$54,$54,$54,$54,$54,$54,$54,$54
		equb $55,$55,$55,$55,$55,$55,$55,$55,$57,$57,$57,$57,$57,$57,$57,$57
		equb $58,$58,$58,$58,$58,$58,$58,$58,$59,$59,$59,$59,$59,$59,$59,$59
		equb $5A,$5A,$5A,$5A,$5A,$5A,$5A,$5A,$5B,$5B,$5B,$5B,$5B,$5B,$5B,$5B
		equb $5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5E,$5E,$5E,$5E,$5E,$5E,$5E,$5E

ORG &A700
.cosine_table
		equb $FF
.cosine_table_plus_1
		equb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FE
		equb $FE,$FE,$FE,$FE,$FD,$FD,$FD,$FD,$FC,$FC,$FC,$FC,$FB,$FB,$FB,$FB
		equb $FA,$FA,$FA,$F9,$F9,$F9,$F8,$F8,$F7,$F7,$F7,$F6,$F6,$F5,$F5,$F4
		equb $F4,$F4,$F3,$F3,$F2,$F2,$F1,$F1,$F0,$EF,$EF,$EE,$EE,$ED,$ED,$EC
		equb $EB,$EB,$EA,$EA,$E9,$E8,$E8,$E7,$E6,$E6,$E5,$E4,$E3,$E3,$E2,$E1
		equb $E1,$E0,$DF,$DE,$DD,$DD,$DC,$DB,$DA,$D9,$D9,$D8,$D7,$D6,$D5,$D4
		equb $D3,$D3,$D2,$D1,$D0,$CF,$CE,$CD,$CC,$CB,$CA,$C9,$C8,$C7,$C6,$C5
		equb $C4,$C3,$C2,$C1,$C0,$BF,$BE,$BD,$BC,$BB,$BA,$B9,$B8,$B7,$B6,$B5
		equb $B3,$B2,$B1,$B0,$AF,$AE,$AD,$AB,$AA,$A9,$A8,$A7,$A6,$A4,$A3,$A2
		equb $A1,$9F,$9E,$9D,$9C,$9B,$99,$98,$97,$95,$94,$93,$92,$90,$8F,$8E
		equb $8C,$8B,$8A,$88,$87,$86,$84,$83,$82,$80,$7F,$7E,$7C,$7B,$7A,$78
		equb $77,$75,$74,$73,$71,$70,$6E,$6D,$6C,$6A,$69,$67,$66,$64,$63,$61
		equb $60,$5F,$5D,$5C,$5A,$59,$57,$56,$54,$53,$51,$50,$4E,$4D,$4B,$4A
		equb $48,$47,$45,$44,$42,$41,$3F,$3E,$3C,$3B,$39,$38,$36,$35,$33,$31
		equb $30,$2E,$2D,$2B,$2A,$28,$27,$25,$24,$22,$20,$1F,$1D,$1C,$1A,$19
		equb $17,$15,$14,$12,$11,$0F,$0E,$0C,$0A,$09,$07,$06,$04,$03,$01
.L_A800	equb $01,$01,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02,$02,$02,$02,$02
		equb $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
		equb $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$04
		equb $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$05,$05,$05,$05,$05
		equb $05,$05,$05,$05,$06,$06,$06,$06,$06,$06,$06,$06,$07,$07,$07,$07
		equb $07,$07,$08,$08,$08,$08,$08,$08,$09,$09,$09,$09,$09,$0A,$0A,$0A
		equb $0A,$0A,$0B,$0B,$0B,$0B,$0C,$0C,$0C,$0C,$0D,$0D,$0D,$0D,$0E,$0E
		equb $0E,$0F,$0F,$0F,$10,$10,$10,$11,$11,$11,$12,$12,$13,$13,$13,$14
.L_A880	equb $14,$15,$15,$15,$15,$15,$16,$16,$16,$16,$17,$17,$17,$17,$18,$18
		equb $18,$18,$19,$19,$19,$1A,$1A,$1A,$1A,$1B,$1B,$1B,$1C,$1C,$1C,$1C
		equb $1D,$1D,$1D,$1E,$1E,$1E,$1F,$1F,$1F,$20,$20,$20,$21,$21,$21,$22
		equb $22,$23,$23,$23,$24,$24,$24,$25,$25,$26,$26,$26,$27,$27,$28,$28
		equb $29,$29,$29,$2A,$2A,$2B,$2B,$2C,$2C,$2D,$2D,$2E,$2E,$2F,$2F,$30
		equb $30,$31,$31,$32,$32,$33,$33,$34,$34,$35,$36,$36,$37,$37,$38,$38
		equb $39,$3A,$3A,$3B,$3C,$3C,$3D,$3D,$3E,$3F,$3F,$40,$41,$41,$42,$43
		equb $44,$44,$45,$46,$46,$47,$48,$49,$49,$4A,$4B,$4C,$4D,$4D,$4E,$4F
.L_A900	equb $50,$50,$51,$51,$52,$52,$52,$53,$53,$54,$54,$55,$55,$55,$56,$56
		equb $57,$57,$58,$58,$59,$59,$59,$5A,$5A,$5B,$5B,$5C,$5C,$5D,$5D,$5E
		equb $5E,$5F,$5F,$60,$60,$61,$61,$62,$62,$63,$63,$64,$64,$65,$65,$66
		equb $66,$67,$67,$68,$68,$69,$69,$6A,$6A,$6B,$6B,$6C,$6D,$6D,$6E,$6E
		equb $6F,$6F,$70,$70,$71,$72,$72,$73,$73,$74,$74,$75,$76,$76,$77,$77
		equb $78,$79,$79,$7A,$7A,$7B,$7C,$7C,$7D,$7D,$7E,$7F,$7F,$80,$80,$81
		equb $82,$82,$83,$84,$84,$85,$86,$86,$87,$88,$88,$89,$89,$8A,$8B,$8B
		equb $8C,$8D,$8D,$8E,$8F,$8F,$90,$91,$92,$92,$93,$94,$94,$95,$96,$96
		equb $97,$98,$99,$99,$9A,$9B,$9B,$9C,$9D,$9E,$9E,$9F,$A0,$A0,$A1,$A2
		equb $A3,$A3,$A4,$A5,$A6,$A6,$A7,$A8,$A9,$A9,$AA,$AB,$AC,$AD,$AD,$AE
		equb $AF,$B0,$B0,$B1,$B2,$B3,$B4,$B4,$B5,$B6,$B7,$B8,$B8,$B9,$BA,$BB
		equb $BC,$BC,$BD,$BE,$BF,$C0,$C0,$C1,$C2,$C3,$C4,$C4,$C5,$C6,$C7,$C8
		equb $C9,$C9,$CA,$CB,$CC,$CD,$CE,$CE,$CF,$D0,$D1,$D2,$D3,$D4,$D4,$D5
		equb $D6,$D7,$D8,$D9,$DA,$DA,$DB,$DC,$DD,$DE,$DF,$E0,$E0,$E1,$E2,$E3
		equb $E4,$E5,$E6,$E7,$E7,$E8,$E9,$EA,$EB,$EC,$ED,$EE,$EE,$EF,$F0,$F1
		equb $F2,$F3,$F4,$F5,$F5,$F6,$F7,$F8,$F9,$FA,$FB,$FC,$FC,$FD,$FE,$FF
.log_lsb
		equb $00,$00,$00,$57,$00,$4A,$57,$3B,$00,$AE,$4A,$D6,$57,$CD,$3B,$A1
		equb $00,$5A,$AE,$FE,$4A,$92,$D6,$18,$57,$93,$CD,$05,$3B,$6F,$A1,$D1
		equb $00,$2D,$5A,$84,$AE,$D6,$FE,$24,$4A,$6E,$92,$B4,$D6,$F8,$18,$38
		equb $57,$75,$93,$B1,$CD,$E9,$05,$20,$3B,$55,$6F,$88,$A1,$B9,$D1,$E9
		equb $00,$17,$2D,$44,$5A,$6F,$84,$99,$AE,$C2,$D6,$EA,$FE,$11,$24,$37
		equb $4A,$5C,$6E,$80,$92,$A3,$B4,$C6,$D6,$E7,$F8,$08,$18,$28,$38,$48
		equb $57,$66,$75,$84,$93,$A2,$B1,$BF,$CD,$DB,$E9,$F7,$05,$13,$20,$2D
		equb $3B,$48,$55,$62,$6F,$7B,$88,$94,$A1,$AD,$B9,$C5,$D1,$DD,$E9,$F4
		equb $00,$0B,$17,$22,$2D,$39,$44,$4F,$5A,$64,$6F,$7A,$84,$8F,$99,$A4
		equb $AE,$B8,$C2,$CC,$D6,$E0,$EA,$F4,$FE,$08,$11,$1B,$24,$2E,$37,$40
		equb $4A,$53,$5C,$65,$6E,$77,$80,$89,$92,$9B,$A3,$AC,$B4,$BD,$C6,$CE
		equb $D6,$DF,$E7,$EF,$F8,$00,$08,$10,$18,$20,$28,$30,$38,$40,$48,$4F
		equb $57,$5F,$66,$6E,$75,$7D,$84,$8C,$93,$9B,$A2,$A9,$B1,$B8,$BF,$C6
		equb $CD,$D4,$DB,$E2,$E9,$F0,$F7,$FE,$05,$0C,$13,$19,$20,$27,$2D,$34
		equb $3B,$41,$48,$4E,$55,$5B,$62,$68,$6F,$75,$7B,$82,$88,$8E,$94,$9A
		equb $A1,$A7,$AD,$B3,$B9,$BF,$C5,$CB,$D1,$D7,$DD,$E3,$E9,$EF,$F4,$FA
.log_msb
		equb $F1,$00,$04,$06,$08,$09,$0A,$0B,$0C,$0C,$0D,$0D,$0E,$0E,$0F,$0F
		equb $10,$10,$10,$10,$11,$11,$11,$12,$12,$12,$12,$13,$13,$13,$13,$13
		equb $14,$14,$14,$14,$14,$14,$14,$15,$15,$15,$15,$15,$15,$15,$16,$16
		equb $16,$16,$16,$16,$16,$16,$17,$17,$17,$17,$17,$17,$17,$17,$17,$17
		equb $18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$18,$19,$19,$19
		equb $19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$19,$1A,$1A,$1A,$1A,$1A
		equb $1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1A,$1B,$1B,$1B,$1B
		equb $1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B
		equb $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C
		equb $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1D,$1D,$1D,$1D,$1D,$1D,$1D
		equb $1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D,$1D
		equb $1D,$1D,$1D,$1D,$1D,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E
		equb $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E
		equb $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
		equb $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
		equb $1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
.L_AC00	equb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$91,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		equb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$26
		equb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$AF,$FF
		equb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$49,$FF,$FF,$FF,$FF,$FF
		equb $FF,$FF,$FF,$8D,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$44,$FF,$FF,$FF,$FF
		equb $FF,$E0,$FF,$FF,$FF,$FF,$FF,$A8,$FF,$FF,$FF,$FF,$CB,$FF,$FF,$FF
		equb $FF,$6B,$FF,$FF,$FF,$9E,$FF,$FF,$FF,$79,$FF,$FF,$FF,$07,$FF,$FF
		equb $55,$FF,$FF,$6A,$FF,$FF,$4E,$FF,$FF,$07,$FF,$99,$FF,$FF,$09,$FF
.L_AC80	equb $B3,$FF,$FF,$FF,$FF,$1C,$FF,$FF,$FF,$52,$FF,$FF,$FF,$59,$FF,$FF
		equb $FF,$36,$FF,$FF,$EB,$FF,$FF,$FF,$7C,$FF,$FF,$EC,$FF,$FF,$FF,$3C
		equb $FF,$FF,$6F,$FF,$FF,$88,$FF,$FF,$87,$FF,$FF,$6F,$FF,$FF,$40,$FF
		equb $FC,$FF,$FF,$A5,$FF,$FF,$3B,$FF,$BF,$FF,$FF,$33,$FF,$97,$FF,$EC
		equb $FF,$FF,$32,$FF,$6C,$FF,$98,$FF,$B8,$FF,$CC,$FF,$D4,$FF,$D2,$FF
		equb $C6,$FF,$B0,$FF,$90,$FF,$67,$FF,$35,$FB,$FF,$B9,$FF,$6F,$FF,$1E
		equb $C5,$FF,$65,$FF,$FF,$92,$FF,$1F,$A5,$FF,$26,$A1,$FF,$16,$87,$F1
		equb $FF,$57,$B8,$FF,$15,$6C,$C0,$FF,$0F,$59,$A0,$E2,$FF,$21,$5C,$93
.L_AD00	equb $FF
.L_AD01	equb $8F,$FF,$EF,$FF
		equb $FF,$4E,$FE,$9D,$FC,$EC,$FB,$FA,$29,$F8,$6F,$FE,$AC,$FB,$DA,$F8
		equb $FF,$0D,$FB,$31,$FF,$56,$FB,$71,$FF,$8D,$FB,$A0,$FE,$B3,$F8,$BE
		equb $FB,$C0,$FD,$C2,$FF,$BC,$F9,$B5,$FA,$AE,$FB,$9F,$FC,$80,$FC,$68
		equb $FC,$48,$FC,$28,$FC,$07,$DB,$FE,$B2,$FD,$80,$FC,$57,$FA,$1D,$D8
		equb $FB,$A5,$F8,$63,$FD,$18,$D2,$FD,$8F,$F9,$3C,$EE,$F8,$9A,$FC,$45
		equb $EF,$F9,$93,$FC,$36,$D7,$F8,$72,$FB,$0C,$A5,$FE,$37,$C8,$F9,$5A
		equb $EB,$FB,$74,$FC,$FD,$85,$FE,$0E,$8E,$FE,$0F,$8F,$FF,$0F,$86,$FE
		equb $06,$76,$ED,$FD,$65,$D4,$FB,$43,$B2,$F9,$19,$80,$F7,$FE,$5D,$BC
		equb $FB,$21,$80,$E7,$FE,$44,$A3,$F9,$00,$5E,$B4,$FB,$09,$67,$BD,$FC
		equb $12,$60,$B6,$FC,$09,$5F,$A5,$F3,$F8,$46,$8C,$D1,$FF,$1C,$62,$AF
		equb $F5,$FA,$37,$7C,$BA,$FF,$FC,$41,$86,$BB,$F8,$FD,$3A,$77,$B4,$E8
		equb $FD,$22,$66,$9B,$D0,$FC,$09,$3D,$72,$AE,$DB,$FF,$0C,$40,$74,$A1
		equb $D5,$F9,$05,$31,$66,$92,$C6,$F2,$FE,$1A,$4E,$72,$A6,$CA,$F6,$FA
		equb $26,$49,$75,$99,$C5,$E9,$FC,$10,$3C,$60,$8B,$B7,$D3,$FE,$FA,$26
		equb $41,$6D,$90,$B4,$D8,$FB,$FF,$22,$46,$69,$8D,$A8,$D4,$F7,$FB,$1E
		equb $3A,$5D,$79,$A4,$C7,$E3,$FE,$0A,$2D,$49,$6C

.L_AE00	equb $20
.L_AE01	equb "Hot Rod      ",$B1,$8B
		equb " Whizz Kid    ",$F0,$36
		equb " Bad Guy      ",$14,$60
		equb " The Dodger   ",$41,$04
.L_AE40	equb " Big Ed       ",$61,$72
		equb " Max Boost    ",$02,$A8
		equb " Dare Devil   ",$00,$86
		equb " High Flyer   ",$23,$C9
		equb " Bully Boy    ",$0A,$0A
		equb " Jumping Jack ",$F4,$C8
		equb " Road Hog     ",$64,$20
		equb $20
.L_AEB1	equb $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$40,$60,$A9
.L_AEC1	equb $00,$A4,$18,$4C,$EA,$AE,$4C,$43,$AE,$A9,$00,$F0,$0A,$4C,$0E,$8C
		equb $20,$EC,$AD,$D0,$F8,$A5,$36,$A0,$00,$F0,$0E,$A4,$1B,$B1,$19
.L_AEE0	equb $22,$20,$62,$20,$3E,$04,$30,$14,$4A,$10,$08,$00,$84,$2B,$A9,$00
		equb $85,$2C,$85,$2D,$A9,$40,$60,$A5,$1E,$4C,$D8,$AE,$A5,$00,$A4,$01

		equb "LITTLE RAMP     "
		equb "STEPPING STONES "
		equb "HUMP BACK       "
		equb "BIG RAMP        "
		equb "SKI JUMP        "
		equb "DRAW BRIDGE     "
		equb "HIGH JUMP       "
		equb "ROLLER COASTER  "
		equb $01,$41,$05,$00,$50,$98,$04,$80,$01,$81,$0F,$E0
.L_AF8C	equb $64,$08,$1E,$80,$01,$81,$0F,$E0,$14,$08,$1E,$80,$01,$81,$00,$F0
		equb $03,$08,$03,$80,$01,$41,$02,$00,$64,$98,$01,$80,$02,$00,$00,$FF
		equb $50,$07,$FF,$80,$00,$00,$00,$CF,$50,$07,$FF,$80,$FF,$20,$E0,$FF
		equb $4C,$D8,$AE,$20
.L_AFC0	equb $16,$14,$02
.L_AFC3	equb $18,$0F,$04
.L_AFC6	equb $17,$15,$03
.L_AFC9	equb $16,$18,$17
.L_AFCC	equb $14,$0F,$15
.L_AFCF	equb $02,$04,$03
.L_AFD2	equb $11,$10
.L_AFD4	equb $12,$11,$1B,$20,$B2,$BD,$20,$56,$AE,$20,$F0,$92,$E9,$E5,$FA,$F3
		equb $F8,$E3,$ED,$E2,$FE,$8A,$ED,$EF,$E5,$EC,$EC,$8A,$E9,$F8,$EB,$E7
		equb $E7,$E5,$E4,$EE,$8A,$9B,$93,$92,$92,$56,$AE,$20

.L_B000	equb $00
.L_B001	equb $0B,$16,$22,$2D,$38,$44,$4F,$5B,$66,$72,$7E,$8A,$95,$A1,$AD,$B9
		equb $C5,$D2,$DE,$EA,$F7,$03,$10,$1C,$29,$36,$42,$4F,$5C,$69,$76,$83
		equb $91,$9E,$AB,$B9,$C6,$D4,$E2,$EF,$FD,$0B,$19,$27,$35,$43,$52,$60
		equb $6E,$7D,$8B,$9A,$A9,$B8,$C7,$D6,$E5,$F4,$03,$12,$22,$31,$41,$50
		equb $60,$70,$80,$90,$A0,$B0,$C0,$D1,$E1,$F1,$02,$13,$24,$34,$45,$56
		equb $68,$79,$8A,$9C,$AD,$BF,$D0,$E2,$F4,$06,$18,$2B,$3D,$4F,$62,$74
		equb $87,$9A,$AD,$C0,$D3,$E6,$F9,$0D,$20,$34,$48,$5C,$70,$84,$98,$AC
		equb $C0,$D5,$EA,$FE,$13,$28,$3D,$52,$68,$7D,$93,$A8,$BE,$D4,$EA
.L_B080	equb $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FE
		equb $FE,$FE,$FD,$FD,$FD,$FD,$FC,$FC,$FB,$FB,$FB,$FA,$FA,$F9,$F9,$F8
		equb $F8,$F7,$F7,$F6,$F6,$F5,$F4,$F4,$F3,$F3,$F2,$F1,$F0,$F0,$EF,$EE
		equb $ED,$EC,$EC,$EB,$EA,$E9,$E8,$E7,$E6,$E5,$E4,$E3,$E2,$E1,$E0,$DF
		equb $DE,$DD,$DB,$DA,$D9,$D8,$D6,$D5,$D4,$D2,$D1,$CF,$CE,$CC,$CB,$C9
		equb $C8,$C6,$C5,$C3,$C1,$BF,$BE,$BC,$BA,$B8,$B6,$B4,$B2,$B0,$AE,$AC
		equb $A9,$A7,$A5,$A2,$A0,$9D,$9B,$98,$95,$92,$8F,$8C,$89,$86,$83,$7F
		equb $7C,$78,$74,$70,$6C,$68,$63,$5E,$59,$53,$4D,$47,$3F,$37,$2D,$20

.L_B100	equb $50
.L_B101	equb $B2,$A3,$B2,$A9,$FF,$FE,$B2,$59,$B3,$20,$DA,$D8,$B3,$3B,$B4,$0A
		equb $46,$2E,$20,$9E,$B4,$A9,$80,$85,$2E,$60,$A5,$30,$C9,$81,$90
.L_B120	equb $0D
.L_B121	equb $B5,$1B,$B5,$24,$B5,$36,$B5,$44,$B5,$52,$B5,$5C,$B5,$66,$B5,$6F
		equb $B5,$78,$B5,$86,$B5,$94,$B5,$9D,$B5,$A6,$B5,$B2,$B5,$CA,$B5,$D3
		equb $B5,$EB,$B5,$F7,$B5,$01,$B6,$0A,$B6,$14,$B6,$1D,$B6,$27,$B6,$31
		equb $B6,$3A,$B6,$43,$B6,$4D,$B6,$57,$B6,$60,$B6,$69,$B6,$72,$B6,$7B
		equb $B6,$84,$B6,$90,$B6,$99,$B6,$A2,$B6,$AB,$B6,$B7,$B6,$C0,$B6,$C9
		equb $B6,$D5,$B6,$E1,$B6,$ED,$B6,$F9,$B6,$02,$B7,$0B,$B7,$14,$B7,$1D
		equb $B7,$26,$B7,$32,$B7,$3E,$B7,$4C,$B7,$56,$B7,$5F,$B7,$68,$B7,$7A
		equb $B7,$83,$B7,$8C,$B7,$95,$B7,$9E,$B7,$A7,$B7,$B0,$B7,$B9,$B7,$C3
		equb $B7,$CC,$B7,$D6,$B7,$E8,$B7,$F1,$B7,$FA,$B7,$03,$B8,$0C,$B8,$16
		equb $B8,$1F,$B8,$28,$B8,$31,$B8,$3A,$B8,$46,$B8,$4F,$B8,$58,$B8,$70
		equb $B8,$A7,$20,$7E,$B8,$87,$B8,$90,$B8,$9E,$B8,$AC,$B8,$B5,$B8,$BF
		equb $B8,$C9,$B8,$D5,$B8,$DE,$B8,$E7,$B8,$F0,$B8,$FA,$B8,$03,$B9,$15
		equb $B9,$27,$B9,$39,$B9,$4B,$B9,$54,$B9,$60,$B9,$6A,$B9,$74,$B9,$7E
		equb $B9,$88,$B9,$91,$B9,$9A,$B9,$A3,$B9,$AC,$B9,$B5,$B9,$BE,$B9,$CA
		equb $B9,$D4,$B9,$E0,$B9,$F8,$B9,$04,$BA,$0D,$BA,$1F,$BA,$28,$BA,$A3
		equb $20,$7D,$A3,$31,$BA,$AA,$20,$3A,$BA,$44,$BA,$4E,$BA,$58,$BA
.L_B220	equb $62
.L_B221	equb $BA,$DE,$BA,$6F,$BB,$00,$BC,$8E,$BC,$1F,$BD,$F4,$BD,$82,$BE,$F5
		equb $A7,$4C,$00,$A5,$4C,$B2,$A3,$00,$17,$41,$63,$63,$75,$72,$61
.L_B240	equb $00,$80,$20,$C0,$00,$73,$80,$C0,$A9,$59,$00,$02,$A9,$5E,$85,$4B
; L_B240 only indexed up to $F
		equb $04,$00,$40,$03,$12,$00,$AB,$80,$80,$01,$20,$40,$03,$00,$00,$C0
		equb $04,$00,$00,$40,$03,$00,$01,$C0,$04,$00,$01,$40,$03,$00,$02,$C0
		equb $04,$00,$02,$40,$03,$00,$03,$C0,$04,$00,$03,$40,$03,$00,$04,$C0
		equb $04,$00,$04,$40,$03,$00,$05,$C0,$04,$00,$05,$40,$03,$00,$06,$C0
		equb $04,$00,$06,$40,$03,$00,$07,$C0,$04,$00,$07,$40,$03,$00,$08,$C0
		equb $04,$00,$08,$0C,$80,$A8,$0D,$00,$00,$00,$FF,$80,$68,$0A,$87,$12
		equb $00,$AB,$87,$80,$01,$3E,$40,$03,$00,$00,$C0,$04,$00,$00,$4C,$03
		equb $05,$01,$CA,$04,$DF,$00,$73,$03,$07,$02,$EB,$04,$BC,$01,$B2,$03
		equb $05,$03,$22,$05,$95,$02,$0A,$04,$FB,$03,$6D,$05,$68,$03,$7A,$04
		equb $E7,$04,$CD,$05,$32,$04,$00,$05,$C8,$05,$40,$06,$F2,$04,$9C,$05
		equb $9A,$06,$C5,$06,$A6,$05,$4C,$06,$5B,$07,$5B,$07,$4C,$06,$0C,$C0

		equb $57,$FA,$00,$00,$00,$01,$80,$E8,$08,$87,$12,$03,$AB,$87,$80,$01
		equb $3E,$3F,$03,$00,$00,$BF,$04,$00,$00,$35,$03,$DF,$00,$B3,$04,$05
		equb $01,$14,$03,$BC,$01,$8C,$04,$07,$02,$DD,$02,$95,$02,$4D,$04,$05
		equb $03,$92,$02,$68,$03,$F5,$03,$FB,$03,$32,$02,$32,$04,$85,$03,$E7
		equb $04,$BF,$01,$F2,$04,$FF,$02,$C8,$05,$3A,$01,$A6,$05,$63,$02,$9A
		equb $06,$A4,$00,$4C,$06,$B3,$01,$5B,$07,$08,$40,$40,$FF,$00,$20,$80
		equb $B5,$1C,$00,$AB,$80,$80,$01,$20,$78,$FF,$87,$00,$87,$00,$78,$FF
		equb $2C,$00,$3C,$01,$3C,$01,$2C,$00,$E1,$00,$F0,$01,$F0,$01,$E1,$00
		equb $96,$01,$A5,$02,$A5,$02,$96,$01,$4A,$02,$5A,$03,$5A,$03,$4A,$02
		equb $FF,$02,$0E,$04,$0E,$04,$FF,$02,$B3,$03,$C3,$04,$C3,$04,$B3,$03
		equb $68,$04,$77,$05,$77,$05,$68,$04,$1D,$05,$2C,$06,$2C,$06,$1D,$05
		equb $D1,$05,$E1,$06,$E1,$06,$D1,$05,$86,$06,$95,$07,$95,$07,$86,$06
		equb $3A,$07,$4A,$08,$4A,$08,$3A,$07,$EF,$07,$FF,$08,$FF,$08,$EF,$07
		equb $A4,$08,$B3,$09,$B3,$09,$A4,$08,$0C,$80,$00,$10,$00,$00,$00,$FF
		equb $90,$C0,$0C,$7A,$14,$00,$AB,$7A,$80,$01,$32,$40,$03,$00,$00,$C0
		equb $04,$00,$00,$4C,$03,$1C,$01,$CA,$04,$FB,$00,$71,$03,$36,$02,$EB
		equb $04,$F4,$01,$AF,$03,$4C,$03,$22,$05,$E9,$02,$04,$04,$5C,$04,$6D
		equb $05,$D9,$03,$71,$04,$63,$05,$CD,$05,$C1,$04,$F5,$04,$60,$06,$41
		equb $06,$A0,$05,$8E,$05,$50,$07,$C8,$06,$73,$06,$3B,$06,$32,$08,$61
		equb $07,$3B,$07,$FC,$06,$03,$09,$0B,$08,$F4,$07,$0C,$C0,$00,$F8,$00
		equb $00,$00,$01,$90,$40,$0B,$7A,$14,$03,$AB,$7A,$80,$01,$32,$40,$03
		equb $00,$00,$C0,$04,$00,$00,$35,$03,$FB,$00,$B3,$04,$1C,$01,$14,$03
		equb $F4,$01,$8E,$04,$36,$02,$DD,$02,$E9,$02,$50,$04,$4C,$03,$92,$02
		equb $D9,$03,$FB,$03,$5C,$04,$32,$02,$C1,$04,$8E,$03,$63,$05,$BE,$01
		equb $A0,$05,$0A,$03,$60,$06,$37,$01,$73,$06,$71,$02,$50,$07,$9E,$00
		equb $3B,$07,$C4,$01,$32,$08,$F4,$FF,$F4,$07,$03,$01,$03,$09,$08,$40
		equb $40,$FF,$00,$20,$7C,$B0,$18,$00,$AB,$7C,$80,$01,$20,$78,$FF,$87
		equb $00,$87,$00,$78,$FF,$32,$00,$41,$01,$41,$01,$32,$00,$EC,$00,$FC
		equb $01,$FC,$01,$EC,$00,$A6,$01,$B6,$02,$B6,$02,$A6,$01,$60,$02,$70
		equb $03,$70,$03,$60,$02,$1B,$03,$2A,$04,$2A,$04,$1B,$03,$D5,$03,$E4
		equb $04,$E4,$04,$D5,$03,$8F,$04,$9F,$05,$9F,$05,$8F,$04,$49,$05,$59
		equb $06,$59,$06,$49,$05,$03,$06,$13,$07,$13

.L_B4FA	equb $07,$03,$06,$BE,$06,$CD,$07,$CD,$07,$BE,$06,$78,$07,$87,$08,$87
		equb $08,$78,$07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		equb $00,$00,$60,$61,$03,$44,$26,$28,$2A,$2C,$00,$00,$02,$00,$04,$00
		equb $06,$00,$08,$00,$0A,$00,$0C,$00,$0E,$00,$10,$00,$00,$20,$40,$60
		equb $01,$21,$41,$61,$02,$02,$02,$02,$02,$02,$02,$61,$41,$21,$01,$60
		equb $40,$20,$00,$00,$00,$00,$00,$00,$00,$60,$21,$51,$02,$22,$42,$62
		equb $03,$13,$00,$20,$40,$70,$21,$41,$61,$02,$22,$32,$00,$02,$04,$06
		equb $E7,$29,$CA,$4B,$2C,$46,$96,$55,$85,$24,$33,$B2,$21,$00,$00,$00
		equb $00,$00,$00,$10,$20,$40,$60,$01,$21,$41,$61,$02,$02,$02,$02,$02
		equb $02,$71,$61,$41,$21,$01,$60,$40,$20,$00,$00,$10,$10,$10,$10,$10
		equb $10,$90,$80,$10,$00,$00,$00,$00,$00,$00,$80,$90,$00,$01,$02,$03
		equb $04,$05,$06,$07,$08,$09,$0A,$0B,$1B,$80,$1C,$80,$1D,$80,$1E,$80
		equb $1F,$80,$20,$80,$A1,$80,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00
		equb $4E,$1D,$DB,$0A,$A8,$36,$34,$22,$00,$00,$00,$9B,$20,$19,$E0,$18
		equb $A0,$17,$60,$16,$20,$14,$E0,$13,$A0,$12,$60,$11,$20,$0F,$E0,$0E
		equb $A0,$48,$27,$26,$35,$44,$63,$13,$42,$71,$21,$50,$00,$13,$03,$62
		equb $42,$22,$02,$51,$21,$E0,$80,$05,$05,$85,$00,$00,$85,$05,$05,$05
		equb $32,$22,$02,$61,$41,$21,$70,$40,$A0,$80,$00,$40,$01,$41,$02,$42
		equb $03,$33,$63,$00,$20,$30,$30,$30,$30,$30,$30,$30,$30,$30,$10,$00
		equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$90,$B0
		equb $30,$30,$30,$30,$30,$30,$30,$A0,$80,$00,$00,$00,$00,$00,$00,$00
		equb $00,$90,$B0,$30,$30,$30,$30,$30,$30,$30,$30,$A0,$80,$00,$21,$42
		equb $53,$E4,$65,$E6,$57,$48,$00,$60,$41,$92,$62,$A3,$63,$14,$44,$00
		equb $20,$40,$D0,$60,$60,$D0,$40,$20,$04,$63,$B3,$03,$42,$82,$31,$60
		equb $00,$A6,$80,$00,$00,$00,$00,$00,$80,$35,$47,$87,$46,$75,$25,$44
		equb $63,$03,$22,$41,$60,$00,$08,$27,$36,$C5,$44,$43,$32,$21,$00,$50
		equb $50,$50,$50,$C0,$30,$20,$10,$00,$00,$00,$10,$30,$60,$11,$51,$22
		equb $72,$00,$60,$41,$A2,$D2,$62,$F2,$72,$72,$72,$72,$72,$22,$B2,$32
		equb $A2,$12,$F1,$31,$60,$00,$0A,$68,$47,$26,$05,$63,$42,$21,$00,$00
		equb $10,$30,$60,$21,$71,$42,$13,$63,$34,$05,$55,$55,$26,$76,$47,$18
		equb $68,$39,$8A,$00,$00,$00,$00,$00,$C7,$76,$26,$55,$05,$34,$63,$13
		equb $42,$71,$21,$21,$60,$30,$10,$00,$00,$00,$00,$00,$00,$00,$00,$8A
		equb $80,$00,$00,$00,$00,$00,$80,$4C,$00,$41,$03,$44,$06,$47,$09,$4A
		equb $0C,$70,$50,$30,$10,$00,$10,$30,$50,$70,$AA,$00,$00,$00,$00,$00
		equb $00,$80,$2A,$59,$49,$39,$A9,$63,$63,$63,$63,$47,$00,$00,$00,$10
		equb $30,$50,$01,$31,$71,$42,$23,$14,$62,$62,$62,$D2,$42,$A2,$02,$61
		equb $B1,$01,$40,$00,$00,$40,$01,$41,$02,$42,$03,$43,$04,$64,$45,$26
		equb $07,$67,$00,$10,$20,$30,$40,$40,$40,$40,$40,$40,$00,$00,$00,$00
		equb $00,$10,$30,$60,$21,$8D,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00
		equb $00,$00,$80,$00,$9C,$80,$1C,$80,$9C,$80,$80,$00,$00,$00,$00,$00
		equb $00,$00,$10,$20,$40,$60,$01,$31,$71,$00,$10,$30,$70,$31,$71,$B2
		equb $52,$62,$00,$00,$00,$10,$30,$60,$21,$02,$03,$00,$10,$30,$60,$21
		equb $71,$62,$53,$44,$00,$70,$61,$52,$43,$34,$25,$16,$07,$00,$00,$00
		equb $00,$00,$00,$00,$80,$2E,$00,$01,$F1,$52,$A3,$63,$94,$34,$54,$00
		equb $30,$D0,$70,$11,$A1,$31,$41,$41,$41,$40,$10,$00,$00,$00,$10,$40
		equb $11,$61,$40,$40,$40,$40,$40,$40,$30,$20,$10,$00,$9A,$C0,$80,$00
		equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$0C,$80,$24,$03
		equb $02,$21,$60,$30,$10,$00,$00,$47,$46,$65,$25,$05,$05,$15,$35,$75
		equb $80,$E6,$16,$45,$74,$24,$53,$23,$13,$46,$25,$14,$13,$22,$41,$70
		equb $30,$00,$00,$01,$12,$33,$54,$75,$17,$38,$59,$7A,$02,$71,$D1,$21
		equb $60,$30,$10,$00,$00,$00,$00,$10,$30,$60,$21,$D1,$71,$02,$00,$40
		equb $81,$31,$D1,$61,$F1,$71,$71,$22,$61,$21,$60,$30,$10,$00,$00,$00
		equb $00,$60,$41,$22,$03,$63,$44,$25,$06,$66,$47,$28,$00,$00,$10,$30
		equb $60,$21,$71,$52,$43,$24,$45,$E6,$80,$21,$42,$63,$05,$26,$28,$60
		equb $27,$C0,$27,$40,$26,$E0,$26,$A0,$26,$80,$26,$80,$26,$A0,$26,$E0
		equb $27,$20,$A7,$60,$00,$00,$00,$01,$02,$03,$04,$05,$06,$07,$08,$68
		equb $49,$2A,$0B,$6B,$00,$70,$51,$32,$13,$73,$54,$35,$06,$00,$50,$31
		equb $12,$72,$53,$34,$15,$06,$00,$60,$41,$22,$03,$73,$64,$65,$66,$67
		equb $68,$69,$6A,$6B,$00,$60,$41,$22,$03,$53,$24,$64,$25,$65,$26,$66
		equb $27,$67,$00,$81,$61,$A2,$42,$52,$52,$52,$52,$00,$41,$72,$14,$35
		equb $56,$77,$19,$3A,$5B,$00,$21,$42,$63,$05,$26,$47,$68,$1A,$5B,$64
		equb $14,$43,$72,$22,$51,$01,$40,$20,$10,$00,$00,$05,$05,$05,$15,$25
		equb $45,$E5,$00,$00,$22,$12,$F1,$51,$31,$11,$60,$30,$00,$00,$50,$31
		equb $22,$23,$34,$55,$76,$18,$00,$21,$42,$63,$05,$26,$47,$68,$79,$7A
		equb $52,$71,$21,$60,$30,$10,$00,$00,$00,$00,$00,$00,$20,$00,$40,$00
		equb $60,$32,$00,$00,$60,$00,$40,$00,$20,$00,$00,$00,$00,$00,$20,$00
		equb $40,$00,$60,$32,$00,$00,$60,$00,$40,$00,$20,$00,$00,$00,$00,$00
		equb $20,$00,$40,$00,$60,$32,$00,$00,$60,$00,$40,$00,$20,$00,$00,$00
		equb $00,$00,$20,$00,$40,$00,$60,$32,$00,$00,$60,$00,$40,$00,$20,$00
		equb $00,$63,$43,$A3,$F2,$42,$02,$41,$01,$40,$28,$47,$66,$06,$25,$44
		equb $63,$03,$22,$41,$60,$00,$14,$73,$43,$03,$42,$02,$41,$01,$40,$00
		equb $74,$14,$43,$03,$42,$02,$41,$01,$40,$00,$14,$53,$13,$52,$12,$51
		equb $11,$50,$A0,$80,$74,$34,$73,$33,$72,$32,$71,$31,$E0,$80,$23,$62
		equb $22,$61,$21,$70,$40,$20,$00,$42,$42,$52,$72,$13,$43,$F3,$00,$00
		equb $00,$00,$00,$00,$85,$05,$05,$05,$05,$0C,$59,$47,$55,$04,$52,$41
		equb $50,$00,$00,$10,$30,$50,$E0,$50,$30,$10,$00,$00,$00,$00,$00,$80
		equb $00,$00,$00,$00,$04,$04,$04,$04,$04,$04,$73,$E3,$33,$52,$41,$00
		equb $44,$04,$43,$03,$42,$02,$41,$01,$40,$00,$41,$41,$41,$41,$41,$41
		equb $31,$A1,$01,$E0,$30,$00,$18,$C0,$16,$80,$14,$40,$12,$00,$0F,$C0
		equb $0D,$80,$0B,$40,$09,$00,$06,$C0,$04,$80,$02,$40,$00,$00,$7E,$4C
		equb $1A,$08,$16,$44,$13,$02,$11,$40,$10,$00,$60,$30,$10,$00,$00,$10
		equb $30,$60,$21,$13,$00,$10,$A0,$0E,$40,$0B,$E0,$09,$80,$07,$20,$04
		equb $C0,$02,$60,$00,$00,$00,$E8,$18,$47,$76,$26,$55,$05,$34,$00,$00
		equb $00,$10,$30,$60,$21,$71,$42,$00,$21,$42,$63,$05,$26,$47,$68,$0A
		equb $00,$60,$31,$71,$32,$72,$33,$73,$34,$74,$00,$20,$50,$11,$51,$12
		equb $52,$13,$53,$14,$00,$40,$01,$41,$02,$42,$03,$43,$94,$F4,$00,$40
		equb $01,$41,$02,$42,$03,$43,$F3,$94

.little_ramp_data
		equb $2C,$0F,$0F,$25,$00,$05,$A0,$CF
		equb $6A,$9F,$6B,$24,$50,$50,$25,$00,$00,$19,$63,$80,$2F,$04,$64,$86
		equb $1F,$65,$66,$57,$0E,$68,$67,$C0,$0D,$64,$04,$E0,$0C,$69,$9F,$17
		equb $00,$00,$00,$00,$00,$00,$00,$00,$CC,$02,$C6,$01,$16,$17,$B7,$10
		equb $00,$01,$20,$19,$18,$94,$31,$04,$03,$2A,$42,$00,$2A,$53,$00,$2A
		equb $64,$00,$2A,$75,$28,$2A,$86,$29,$2A,$97,$00,$2A,$A8,$2A,$2A,$B9
		equb $2B,$2A,$CA,$00,$2A,$DB,$00,$04,$EC,$09,$0A,$D3,$FD,$16,$17,$66
		equb $FE,$00,$17,$EF,$1B,$1A,$8D,$DF,$06,$05,$22,$2F,$02,$02,$21,$46
		equb $03,$58,$01,$22

.stepping_stones_data
		equb $38,$2A,$2A,$0E,$00,$0F,$A0,$CF,$00,$9F,$3B,$3C
		equb $3C,$25,$13,$48,$49,$00,$32,$80,$2F,$04,$64,$86,$1F,$65,$66,$57
		equb $0E,$68,$67,$C0,$0D,$64,$04,$E0,$0C,$69,$9F,$2E,$2F,$2E,$2F,$2E
		equb $2F,$2E,$2F,$38,$C0,$02,$4C,$03,$C6,$01,$7C,$7D,$97,$10,$7F,$7E
		equb $00,$20,$03,$4C,$20,$30,$33,$9F,$33,$15,$1E,$1F,$64,$64,$64,$64
		equb $5E,$0C,$D0,$06,$E0,$16,$17,$D7,$F1,$1B,$1A,$4D,$F2,$60,$F3,$00
		equb $9F,$00,$49,$00,$5A,$6B,$00,$00,$48,$00,$4C,$FD,$46,$FE,$16,$17
		equb $17,$EF,$1B,$1A,$8D,$DF,$07,$09,$30,$34,$08,$09,$03,$D4,$08,$3F
		equb $0F,$BE,$11,$BD,$13,$BB,$15,$BA,$2C,$F3,$1E,$42,$10,$11,$12,$13
		equb $14,$15,$16,$2F,$05

.hump_back_data
		equb $35,$2E,$2E,$13,$40,$05,$60,$04,$3A,$8F,$7A
		equb $1C,$1D,$1E,$1F,$22,$27,$43,$4D,$0D,$47,$0E,$17,$16,$96,$1F,$1A
		equb $1B,$0C,$2F,$20,$3F,$00,$9F,$48,$00,$39,$00,$48,$49,$48,$00,$38
		equb $00,$DF,$03,$4C,$07,$EF,$7D,$7C,$56,$FE,$7E,$7F,$C0,$FD,$4C,$03
		equb $E0,$FC,$33,$6F,$4A,$71,$1F,$64,$64,$5E,$CD,$F5,$C7,$F4,$17,$16
		equb $16,$E3,$1A,$1B,$8C,$D3,$A0,$C3,$30,$1F,$4B,$8C,$A3,$81,$93,$0B
		equb $0C,$14,$82,$04,$03,$84,$71,$0A,$09,$11,$60,$0C,$0B,$8C,$50,$A0
		equb $40,$00,$1F,$00,$8D,$20,$87,$10,$17,$16,$D6,$01,$1A,$1B,$4C,$02
		equb $60,$03,$00,$06,$05,$29,$31,$06,$01,$00,$52,$01,$4D,$1B,$4C,$25
		equb $4F,$28,$4D,$34,$5C,$26

.big_ramp_data
		equb $2C,$01,$01,$18,$80,$07,$A0,$C0,$00,$3F
		equb $00,$00,$00,$80,$80,$6D,$6E,$4F,$6E,$6D,$6D,$6E,$6E,$6D,$6D,$6E
		equb $A0,$30,$00,$8D,$20,$87,$10,$17,$16,$D6,$01,$1A,$1B,$4C,$02,$60
		equb $03,$77,$9F,$29,$00,$00,$76,$40,$29,$00,$00,$45,$4D,$0D,$47,$0E
		equb $17,$16,$B6,$1F,$00,$03,$2F,$18,$19,$54,$3E,$03,$04,$EA,$4D,$31
		equb $EA,$5C,$0D,$EA,$6B,$0D,$EA,$7A,$8E,$EA,$89,$00,$EA,$98,$00,$EA
		equb $A7,$00,$EA,$B6,$90,$EA,$C5,$11,$EA,$D4,$59,$C4,$E3,$0A,$09,$51
		equb $F2,$17,$16,$E7,$F1,$00,$16,$E0,$1A,$1B,$8C,$D0,$0A,$09,$2B,$29
		equb $05,$08,$20,$D6,$0E,$4E,$0F,$4B,$13,$4B,$14,$46,$10,$11,$15,$16
		equb $20,$21,$22,$23

.ski_jump_data
		equb $28,$0F,$0F,$23,$40,$6A,$AA,$BD,$71,$AA,$AC,$21
		equb $AA,$9B,$64,$AA,$8A,$CF,$AA,$79,$00,$AA,$68,$00,$AA,$57,$00,$AA
		equb $46,$6F,$AA,$35,$F2,$AA,$24,$73,$84,$13,$09,$0A,$53,$02,$16,$17
		equb $E6,$01,$00,$97,$10,$1B,$1A,$0D,$20,$20,$30,$24,$00,$40,$50,$33
		equb $01,$50,$52,$53,$94,$61,$33,$50,$2A,$72,$4C,$04,$83,$55,$54,$91
		equb $94,$53,$52,$00,$A4,$50,$33,$20,$B4,$4C,$1F,$25,$0C,$D4,$06,$E4
		equb $16,$17,$D7,$F5,$1B,$1A,$4D,$F6,$60,$F7,$4D,$5F,$47,$7A,$4E,$7A
		equb $56,$4C,$FD,$46,$FE,$16,$17,$37,$EF,$00,$81,$DF,$19,$18,$14,$CE
		equb $04,$03,$07,$08,$2B,$28,$06,$01,$03,$D8,$15,$54,$18,$36,$20,$C2
		equb $00,$42,$27,$C9,$20

.draw_bridge_data
		equb $4E,$2A,$2A,$04,$A0,$11,$A0,$CC,$00,$7F,$38
		equb $33,$33,$2C,$00,$00,$32,$80,$4C,$04,$64,$86,$3C,$65,$66,$57,$2B
		equb $68,$67,$C0,$2A,$64,$04,$E0,$29,$2B,$3F,$20,$35,$5C,$C0,$25,$2D
		equb $0D,$C6,$24,$57,$47,$97,$33,$5D,$58,$00,$43,$0D,$2D,$20,$53,$1C
		equb $3F,$1D,$3F,$00,$00,$93,$6D,$6E,$2F,$6D,$6E,$6E,$6D,$20,$C3,$32
		equb $00,$D3,$64,$04,$07,$E3,$66,$65,$76,$F2,$70,$E7,$F1,$70,$16,$E0
		equb $67,$68,$80,$D0,$04,$64,$A0,$C0,$70,$9F,$70,$70,$70,$C2,$00,$64
		equb $64,$2B,$00,$8D,$20,$87,$10,$17,$16,$D6,$01,$1A,$1B,$4C,$02,$60
		equb $03,$00,$9F,$00,$35,$DF,$E0,$00,$E1,$E2,$2B,$38,$40,$0D,$03,$4C
		equb $47,$0E,$7D,$7C,$96,$1F,$7E,$7F,$00,$2F,$4C,$03,$20,$3F,$33,$9F
		equb $33,$33,$15,$1E,$1F,$22,$44,$64,$5E,$0D,$DF,$07,$EF,$17,$16,$76
		equb $FE,$00,$E7,$FD,$00,$16,$EC,$1A,$1B,$8C,$DC,$04,$04,$48,$48,$09
		equb $07,$03,$62,$06,$55,$07,$50,$14,$43,$3D,$E4,$41,$D8,$2D,$5A,$2E
		equb $50,$2F,$C6,$04,$0D,$26,$33,$34,$35,$36

.high_jump_data
		equb $34,$1D,$1D,$04,$40,$06
		equb $20,$3F,$00,$9F,$00,$3B,$25,$4D,$3E,$26,$64,$64,$2B,$0D,$DF,$07
		equb $EF,$17,$16,$56,$FE,$1A,$1B,$CC,$FD,$E0,$FC,$00,$5F,$00,$00,$00
		equb $00,$00,$CD,$F6,$C3,$F5,$17,$16,$34,$E4,$00,$AA,$D3,$00,$AA,$C2
		equb $00,$A4,$B1,$00,$11,$A0,$18,$19,$8C,$90,$A0,$80,$00,$5F,$00,$00
		equb $00,$00,$00,$8D,$20,$87,$10,$17,$16,$D6,$01,$1A,$1B,$4C,$02,$60
		equb $03,$00,$9F,$3A,$7A,$36,$00,$B7,$00,$3D,$27,$43,$4D,$0D,$47,$0E
		equb $17,$16,$96,$1F,$1A,$1B,$0C,$2F,$06,$06,$2C,$2A,$06,$0E,$27,$D3
		equb $28,$CE,$02,$D3,$17,$55,$16,$52,$15,$52,$1E,$1F,$20,$21,$22,$25
		equb $26,$27,$28,$29,$2A,$2B,$2C,$2D

.roller_coaster_data
		equb $4E,$00,$00,$25,$00,$05,$A0,$CF
		equb $38,$9F,$01,$82,$82,$82,$82,$82,$07,$4A,$00,$8C,$2F,$86,$1F,$16
		equb $17,$57,$0E,$1B,$1A,$CD,$0D,$E0,$0C,$19,$9F,$08,$0F,$F5,$F5,$F5
		equb $F5,$6C,$74,$5C,$C0,$02,$2D,$0D,$C6,$01,$57,$47,$97,$10,$5D,$58
		equb $00,$20,$0D,$2D,$20,$30,$1C,$9F,$1D,$1E,$1F,$22,$27,$27,$27,$43
		equb $38,$00,$D0,$4C,$03,$06,$E0,$05,$06,$F7,$F1,$34,$66,$F2,$41,$17
		equb $E3,$12,$14,$80,$D3,$64,$04,$A0,$C3,$70,$7F,$4B,$35,$33,$33,$33
		equb $33,$33,$80,$43,$03,$4C,$87,$33,$06,$05,$F6,$24,$34,$67,$25,$00
		equb $96,$36,$1A,$1B,$0C,$46,$20,$56,$00,$7F,$23,$5B,$70,$70,$70,$70
		equb $70,$00,$D6,$04,$64,$06,$E6,$65,$66,$D7,$F7,$68,$67,$40,$F8,$64
		equb $04,$60,$F9,$2B,$3F,$00,$00,$00,$4C,$FD,$46,$FE,$16,$17,$17,$EF
		equb $1B,$1A,$8D,$DF,$03,$03,$50,$59,$07,$00,$06,$2A,$07,$29,$0E,$36
		equb $1A,$54,$1B,$4A,$4D,$52,$4C,$5A,$00,$00,$00,$00,$00,$00,$00,$00
		equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

.L_BFAA	equb $07,$07,$07,$07,$07,$07,$07,$07
.L_BFB2	equb $41,$3A,$3E,$41,$48,$51,$48,$4F
.L_BFBA	equb $00,$00,$00,$00,$00,$00,$00,$00
.L_BFC2	equb $48,$41,$45,$48,$4F,$58,$4F,$56,$07,$03,$03,$03,$03,$03,$07,$03
		equb $66,$57,$57,$59,$59,$69,$62,$64,$07,$03,$03,$03,$03,$01,$03,$03
		equb $61,$55,$53,$56,$58,$5B,$5A,$62
.L_BFEA	equb $48,$00,$F0,$00,$EC,$00,$10,$60,$5B,$00,$00,$54,$0C,$40,$01,$3A
		equb $01,$0C,$6E,$69,$01,$00

; *****************************************************************************
; HIGH RAM: $C000 - $D000
; $C700 = Maths routines
; ...
; $CD00 = IRQ handler
; $CE00 = Sprite code
; $CF00 = Raster interrupts
; *****************************************************************************

; Engine screen data (copied at boot time from elsewhere)

ORG &C000

.L_C000	skip &100
.L_C100	skip &100
.L_C200 skip &18
.L_C218 skip &18
.L_C230 skip &18
.L_C248 skip &18
.L_C260 skip &20
.L_C280 skip &40
.L_C2C0 skip &40

.L_C300	skip 1
.L_C301	skip 1
.L_C302	skip 1
.L_C303	skip 1
.L_C304	skip 1
.L_C305	skip 1
.L_C306	skip 1
.L_C307	skip 1
.L_C308	skip 1
.L_C309	skip 1
.L_C30A	skip 1
.L_C30B	skip 1
.L_C30C	skip 1
.L_C30D	skip 1
.L_C30E	skip 1
.L_C30F	skip 1
.L_C310	skip &C
.L_C31C	skip &C
.L_C328	skip &C
.L_C334	skip &C
.L_C340	skip 3
.L_C343	skip 2
.L_C345	skip 1
.L_C346	skip 1
.L_C347	skip 1
.L_C348	skip 1
.L_C349	skip 1
.L_C34A	skip 1
.L_C34B	skip 1
.L_C34C	skip 1
.L_C34D	skip 1
.L_C34E	skip 1
.L_C34F	skip 1
.L_C350	skip 1
.L_C351	skip 1
.L_C352	skip 1
.L_C353	skip 1
.L_C354	skip 1
.L_C355	skip 1
.L_C356	skip 1
.L_C357	skip 1
.L_C358	skip 1
.L_C359	skip 3
.L_C35C	skip 1
.L_C35D	skip 1
.L_C35E	skip 1
.L_C35F	skip 1
.L_C360	skip 1
.L_C361	skip 1
.L_C362	skip 2
.L_C364	skip 1
.L_C365	skip 1
.L_C366	skip 1
.L_C367	skip 1
.L_C368	skip 1
.L_C369	skip 1
.L_C36A	skip 1
.L_C36B	skip 1
.L_C36C	skip 1
.L_C36D	skip 1
.L_C36E	skip 1
.L_C36F	skip 1
.L_C370	skip 1
.L_C371	skip 1
.L_C372	skip 1
.L_C373	skip 1
.L_C374	skip 1
.L_C375	skip 1
.L_C376	skip 2
.L_C378	skip 1
.L_C379	skip 1
.L_C37A	skip 1
.L_C37B	skip 1
.L_C37C	skip 2
.L_C37E	skip 1
.L_C37F	skip 1
.L_C380	skip 1
.L_C381	skip 1
.L_C382	skip 2
.L_C384	skip 1
.L_C385	skip 1
.L_C386	skip 1
.L_C387	skip 1
.L_C388	skip 3
.L_C38B	skip &A
.L_C395	skip 1
.L_C396	skip 1
.L_C397	skip 1
.L_C398	skip 1
.L_C399	skip 1
.L_C39A	skip 1
.L_C39B	skip 1
.L_C39C	skip 8
.L_C3A4	skip 1
.L_C3A5	skip 1
.L_C3A6	skip 2
.L_C3A8	skip 1
.L_C3A9	skip 2
.L_C3AB	skip 2
.L_C3AD	skip 9
.L_C3B6	skip 1
.L_C3B7	skip 5
.L_C3BC	skip 7
.L_C3C3	skip 1
.L_C3C4	skip 1
.L_C3C5	skip 1
.L_C3C6	skip 1
.L_C3C7	skip 4
.L_C3CB	skip 1
.L_C3CC	skip 1
.L_C3CD	skip 1
.L_C3CE	skip 2
.L_C3D0	skip 1
.L_C3D1	skip 1
.L_C3D2	skip 1
.L_C3D3	skip 1
.L_C3D4	skip 3
.L_C3D7	skip 1
.L_C3D8	skip 1
.L_C3D9	skip 1
.L_C3DA	skip 2
.L_C3DC	skip 3
.L_C3DF	skip &20
.L_C3FF	skip 1

.L_C400	skip &3F
.L_C43F	skip 1
.L_C440	skip &C0
.L_C500	skip 2
.L_C502	skip 3
.L_C505	skip 2
.L_C507	skip 1
.L_C508	skip 8
.L_C510	skip 2
.L_C512	skip 3
.L_C515	skip 2
.L_C517	skip 1
.L_C518	skip 8
.L_C520	skip 5
.L_C525	skip 3
.L_C528	skip 8
.L_C530	skip 5
.L_C535	skip 3
.L_C538	skip 8
.L_C540	skip &40
.L_C580	skip &40
.L_C5C0	skip &40
.L_C600	skip 1
.L_C601	skip 1
.L_C602	skip 1
.L_C603	skip &3C
.L_C63F	skip 1
.L_C640	skip &40
.L_C680	skip &40
.L_C6C0	skip &40	; stash $B bytes from $DAB6

.L_C700	equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.L_C70B	equb $00
.L_C70C	equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.L_C718	equb $00
.L_C719	equb $00
.L_C71A	equb $00,$00
.L_C71C	equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; Player times?

.L_C728	equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.L_C734	equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.L_C740	equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.L_C74B	equb $00
.L_C74C	equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.L_C758	equb $00
.L_C759	equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.L_C763	equb $00
.L_C764	equb $00
.L_C765	equb $00
.L_C766	equb $00
.L_C767	equb $00
.L_C768	equb $00
.L_C769	equb $00
.L_C76A	equb $00
.L_C76B	equb $00
.L_C76C	equb $00
.L_C76D	equb $00
.L_C76E	equb $00
.L_C76F	equb $00
.L_C770	equb $00
.L_C771	equb $00
.L_C772	equb $00
.L_C773	equb $00
.L_C774	equb $00
.L_C775	equb $00
.L_C776	equb $00
.L_C777	equb $00
.L_C778	equb $00
.L_C779	equb $00,$00
.L_C77B	equb $00
.L_C77C	equb $00
.L_C77D	equb $00
.L_C77E	equb $00
.L_C77F	equb $00
.L_C780	equb $00,$40

; multiply	two 8 bit values giving	16-bit result.
; 
; entry: A	= first	value, byte_15 = second	value
; result: A = result MSB, byte_14 = result	LSB

.mul_8_8_16bit
{
		sta ZP_14		;C782 85 14
		lda #$00		;C784 A9 00
		lsr ZP_14		;C786 46 14
		bcc L_C78D		;C788 90 03
		clc				;C78A 18
		adc ZP_15		;C78B 65 15
.L_C78D	ror A			;C78D 6A
		ror ZP_14		;C78E 66 14
		bcc L_C795		;C790 90 03
		clc				;C792 18
		adc ZP_15		;C793 65 15
.L_C795	ror A			;C795 6A
		ror ZP_14		;C796 66 14
		bcc L_C79D		;C798 90 03
		clc				;C79A 18
		adc ZP_15		;C79B 65 15
.L_C79D	ror A			;C79D 6A
		ror ZP_14		;C79E 66 14
		bcc L_C7A5		;C7A0 90 03
		clc				;C7A2 18
		adc ZP_15		;C7A3 65 15
.L_C7A5	ror A			;C7A5 6A
		ror ZP_14		;C7A6 66 14
		bcc L_C7AD		;C7A8 90 03
		clc				;C7AA 18
		adc ZP_15		;C7AB 65 15
.L_C7AD	ror A			;C7AD 6A
		ror ZP_14		;C7AE 66 14
		bcc L_C7B5		;C7B0 90 03
		clc				;C7B2 18
		adc ZP_15		;C7B3 65 15
.L_C7B5	ror A			;C7B5 6A
		ror ZP_14		;C7B6 66 14
		bcc L_C7BD		;C7B8 90 03
		clc				;C7BA 18
		adc ZP_15		;C7BB 65 15
.L_C7BD	ror A			;C7BD 6A
		ror ZP_14		;C7BE 66 14
		bcc L_C7C5		;C7C0 90 03
		clc				;C7C2 18
		adc ZP_15		;C7C3 65 15
.L_C7C5	ror A			;C7C5 6A
		ror ZP_14		;C7C6 66 14
		rts				;C7C8 60
}

; entry: X	holds key to test.
; 
; exit: Z set if key pressed.

.poll_key_with_sysctl
{
		tya				;C7C9 98
		pha				;C7CA 48
		lda #$81		;C7CB A9 81
		ldy #$FF		;C7CD A0 FF
		jsr sysctl		;C7CF 20 25 87
		pla				;C7D2 68
		tay				;C7D3 A8
		cpx #$FF		;C7D4 E0 FF
		rts				;C7D6 60
}

; get sin and cos.
; 
; entry: byte_14=angle LSB, A=angle MSB
; exit: sincos_sin, sincos_cos, sincos_sign_flag, sincos_angle

.sincos
{
		pha				;C7D7 48
		lda ZP_14		;C7D8 A5 14
		clc				;C7DA 18
		adc #$20		;C7DB 69 20
		sta ZP_14		;C7DD 85 14
		pla				;C7DF 68
		adc #$00		;C7E0 69 00
		sta ZP_58		;C7E2 85 58
		stx L_C780		;C7E4 8E 80 C7
		asl ZP_14		;C7E7 06 14
		rol A			;C7E9 2A
		eor ZP_58		;C7EA 45 58
		sta ZP_59		;C7EC 85 59
		eor ZP_58		;C7EE 45 58
		bpl L_C803		;C7F0 10 11
		asl ZP_14		;C7F2 06 14
		rol A			;C7F4 2A
		eor #$FF		;C7F5 49 FF
		clc				;C7F7 18
		adc #$01		;C7F8 69 01
		bne L_C806		;C7FA D0 0A
		sta ZP_57		;C7FC 85 57
		lda cosine_table		;C7FE AD 00 A7
		bne L_C818		;C801 D0 15
.L_C803	asl ZP_14		;C803 06 14
		rol A			;C805 2A
.L_C806	tax				;C806 AA
		lda cosine_table,X	;C807 BD 00 A7
		sta ZP_57		;C80A 85 57
		txa				;C80C 8A
		eor #$FF		;C80D 49 FF
		clc				;C80F 18
		adc #$01		;C810 69 01
		beq L_C818		;C812 F0 04
		tax				;C814 AA
		lda cosine_table,X	;C815 BD 00 A7
.L_C818	sta ZP_56		;C818 85 56
		ldx L_C780		;C81A AE 80 C7
		rts				;C81D 60
}

.L_C81E
{
		and #$FF		;C81E 29 FF
		bmi L_C829		;C820 30 07
		bit ZP_5A		;C822 24 5A
		bmi L_C832		;C824 30 0C
.L_C826	jmp mul_8_8_16bit		;C826 4C 82 C7
.L_C829	eor #$FF		;C829 49 FF
		clc				;C82B 18
		adc #$01		;C82C 69 01
		bit ZP_5A		;C82E 24 5A
		bmi L_C826		;C830 30 F4
.L_C832	jsr mul_8_8_16bit		;C832 20 82 C7
		sta L_C37F		;C835 8D 7F C3
		lda #$00		;C838 A9 00
		sec				;C83A 38
		sbc ZP_14		;C83B E5 14
		sta ZP_14		;C83D 85 14
		lda #$00		;C83F A9 00
		sbc L_C37F		;C841 ED 7F C3
		rts				;C844 60
}

; Multiply	8-bit value by 16-bit value, producing top 16 bits of result
; 
; entry: (A,byte_14) = first value; byte_15 = 2nd value
; exit: (A,byte_15) = result

.mul_8_16_16bit
		lsr ZP_5A		;C845 46 5A
.mul_8_16_16bit_2
{
		sta ZP_17		;C847 85 17
		and #$FF		;C849 29 FF
		bpl L_C858		;C84B 10 0B
		lda #$00		;C84D A9 00
		sec				;C84F 38
		sbc ZP_14		;C850 E5 14
		sta ZP_14		;C852 85 14
		lda #$00		;C854 A9 00
		sbc ZP_17		;C856 E5 17
.L_C858	sta ZP_16		;C858 85 16
		lda ZP_17		;C85A A5 17
		jmp L_C894		;C85C 4C 94 C8
}

.mul_8_16_16bit_from_state
		sta ZP_5A		;C85F 85 5A
		and #$FF		;C861 29 FF
		bpl L_C870		;C863 10 0B
		lda #$00		;C865 A9 00
		sec				;C867 38
		sbc ZP_14		;C868 E5 14
		sta ZP_14		;C86A 85 14
		lda #$00		;C86C A9 00
		sbc ZP_5A		;C86E E5 5A
.L_C870	sta ZP_16		;C870 85 16
		lda L_0774,X	;C872 BD 74 07
		sta ZP_15		;C875 85 15
		lda L_079C,X	;C877 BD 9C 07
		sta L_C380		;C87A 8D 80 C3
		bpl L_C88B		;C87D 10 0C
		lda #$00		;C87F A9 00
		sec				;C881 38
		sbc ZP_15		;C882 E5 15
		sta ZP_15		;C884 85 15
		lda #$00		;C886 A9 00
		sbc L_C380		;C888 ED 80 C3
.L_C88B	lsr A			;C88B 4A
		ror ZP_15		;C88C 66 15
		lsr A			;C88E 4A
		ror ZP_15		;C88F 66 15
		lda L_C380		;C891 AD 80 C3
.L_C894	eor ZP_5A		;C894 45 5A
		sta ZP_5A		;C896 85 5A
		lda ZP_14		;C898 A5 14
		jsr mul_8_8_16bit		;C89A 20 82 C7
		sta ZP_17		;C89D 85 17
		lda ZP_16		;C89F A5 16
		bne L_C8AB		;C8A1 D0 08
		lda ZP_17		;C8A3 A5 17
		sta ZP_14		;C8A5 85 14
		lda #$00		;C8A7 A9 00
		beq L_C8BB		;C8A9 F0 10
.L_C8AB	jsr mul_8_8_16bit		;C8AB 20 82 C7
		sta ZP_15		;C8AE 85 15
		lda ZP_17		;C8B0 A5 17
		clc				;C8B2 18
		adc ZP_14		;C8B3 65 14
		sta ZP_14		;C8B5 85 14
		lda ZP_15		;C8B7 A5 15
		adc #$00		;C8B9 69 00
.L_C8BB	bit ZP_5A		;C8BB 24 5A
; Fall through (so	that result is negative	if the arguments differed in sign)

; Negates 16-bit value if N is set.
; 
; on entry: byte_14=LSB, A=MSB, N=1 to negate or N=0 to do	nothing
; on exit:	byte_14=LSB, A=MSB

.negate_if_N_set
		bpl L_C8CC		;C8BD 10 0D
.negate_16bit
		sta ZP_15		;C8BF 85 15
		lda #$00		;C8C1 A9 00
		sec				;C8C3 38
		sbc ZP_14		;C8C4 E5 14
		sta ZP_14		;C8C6 85 14
		lda #$00		;C8C8 A9 00
		sbc ZP_15		;C8CA E5 15
.L_C8CC	rts				;C8CC 60

; more accurate sin than sincos
; 
; entry: angle in (A,byte_14)
; exit: sine in (A,byte_14)

.accurate_sin
{
		sta ZP_58		;C8CD 85 58
		bit ZP_58		;C8CF 24 58
		bvs L_C8DE		;C8D1 70 0B
		lda #$FF		;C8D3 A9 FF
		sec				;C8D5 38
		sbc ZP_14		;C8D6 E5 14
		sta ZP_14		;C8D8 85 14
		lda #$FF		;C8DA A9 FF
		sbc ZP_58		;C8DC E5 58
.L_C8DE	asl ZP_14		;C8DE 06 14
		rol A			;C8E0 2A
		asl ZP_14		;C8E1 06 14
		rol A			;C8E3 2A
		tax				;C8E4 AA
		cpx #$FF		;C8E5 E0 FF
		bne L_C8EE		;C8E7 D0 05
		lda #$00		;C8E9 A9 00
		sta ZP_14		;C8EB 85 14
		rts				;C8ED 60
.L_C8EE	lda L_AD01,X	;C8EE BD 01 AD
		asl A			;C8F1 0A
		asl A			;C8F2 0A
		asl A			;C8F3 0A
		asl A			;C8F4 0A
		asl A			;C8F5 0A
		sta ZP_15		;C8F6 85 15
		lda L_AD00,X	;C8F8 BD 00 AD
		asl A			;C8FB 0A
		asl A			;C8FC 0A
		asl A			;C8FD 0A
		asl A			;C8FE 0A
		asl A			;C8FF 0A
		sta ZP_16		;C900 85 16
		sec				;C902 38
		sbc ZP_15		;C903 E5 15
		sta ZP_15		;C905 85 15
		lda cosine_table,X	;C907 BD 00 A7
		sta ZP_17		;C90A 85 17
		sbc cosine_table_plus_1,X	;C90C FD 01 A7
		lsr A			;C90F 4A
		ror ZP_15		;C910 66 15
		lda ZP_14		;C912 A5 14
		jsr mul_8_8_16bit		;C914 20 82 C7
		sta ZP_15		;C917 85 15
		lsr ZP_17		;C919 46 17
		ror ZP_16		;C91B 66 16
		lda ZP_16		;C91D A5 16
		sec				;C91F 38
		sbc ZP_15		;C920 E5 15
		sta ZP_14		;C922 85 14
		lda ZP_17		;C924 A5 17
		sbc #$00		;C926 E9 00
		lsr A			;C928 4A
		ror ZP_14		;C929 66 14
		lsr A			;C92B 4A
		ror ZP_14		;C92C 66 14
		lsr A			;C92E 4A
		ror ZP_14		;C92F 66 14
		lsr A			;C931 4A
		ror ZP_14		;C932 66 14
		bit ZP_58		;C934 24 58
		jsr negate_if_N_set		;C936 20 BD C8
		rts				;C939 60
}

; computes	~1/3 of	a state	value
; 
; entry: X	= state	value index; byte_5A = sign control
; exit: (A,byte_14) = value; value	negated	if top bit of byte_5A was set.
.get_one_third_of_state_value
{
		lda L_0774,X	;C93A BD 74 07
		sta ZP_14		;C93D 85 14
		lda L_079C,X	;C93F BD 9C 07
		sta ZP_15		;C942 85 15
		lda #$00		;C944 A9 00
		sta ZP_18		;C946 85 18
		lda ZP_15		;C948 A5 15
		bpl L_C94E		;C94A 10 02
		dec ZP_18		;C94C C6 18
.L_C94E	lsr ZP_18		;C94E 46 18
		ror A			;C950 6A
		ror ZP_14		;C951 66 14
		sta ZP_15		;C953 85 15
		sta ZP_17		;C955 85 17
		lda ZP_14		;C957 A5 14
		lsr ZP_18		;C959 46 18
		ror ZP_17		;C95B 66 17
		ror A			;C95D 6A
		lsr ZP_18		;C95E 46 18
		ror ZP_17		;C960 66 17
		ror A			;C962 6A
		clc				;C963 18
		adc ZP_14		;C964 65 14
		sta ZP_14		;C966 85 14
		lda ZP_15		;C968 A5 15
		adc ZP_17		;C96A 65 17
		lsr ZP_18		;C96C 46 18
		ror A			;C96E 6A
		ror ZP_14		;C96F 66 14
		bit ZP_5A		;C971 24 5A
		jmp negate_if_N_set		;C973 4C BD C8
}

; Squares 16-bit value.
; 
; entry: A	= MSB, Y = LSB
; exit: byte_16,byte_17,byte_18,byte_19 = 32-bit result

.square_ay_32bit
{
		and #$FF		;C976 29 FF
		bpl L_C988		;C978 10 0E
		sta ZP_15		;C97A 85 15
		sty ZP_14		;C97C 84 14
		lda #$00		;C97E A9 00
		sec				;C980 38
		sbc ZP_14		;C981 E5 14
		tay				;C983 A8
		lda #$00		;C984 A9 00
		sbc ZP_15		;C986 E5 15
.L_C988	sta ZP_15		;C988 85 15
		pha				;C98A 48
		jsr mul_8_8_16bit		;C98B 20 82 C7
		sta ZP_19		;C98E 85 19
		lda ZP_14		;C990 A5 14
		sta ZP_18		;C992 85 18
		tya				;C994 98
		sta ZP_15		;C995 85 15
		jsr mul_8_8_16bit		;C997 20 82 C7
		sta ZP_17		;C99A 85 17
		lda ZP_14		;C99C A5 14
		sta ZP_16		;C99E 85 16
		pla				;C9A0 68
		jsr mul_8_8_16bit		;C9A1 20 82 C7
		asl ZP_14		;C9A4 06 14
		rol A			;C9A6 2A
		bcc L_C9AB		;C9A7 90 02
		inc ZP_19		;C9A9 E6 19
.L_C9AB	sta ZP_15		;C9AB 85 15
		lda ZP_17		;C9AD A5 17
		clc				;C9AF 18
		adc ZP_14		;C9B0 65 14
		sta ZP_17		;C9B2 85 17
		lda ZP_18		;C9B4 A5 18
		adc ZP_15		;C9B6 65 15
		sta ZP_18		;C9B8 85 18
		bcc L_C9BE		;C9BA 90 02
		inc ZP_19		;C9BC E6 19
.L_C9BE	rts				;C9BE 60
}

; 16-bit arithmetic shift of A (MSB) and byte_14 (LSB).
; 
; If Y is +ve, shift Y places right.
; If Y is -ve, shift abs(Y) places	left.

.shift_16bit
{
		pha				;C9BF 48
		lda #$00		;C9C0 A9 00
		sta ZP_2D		;C9C2 85 2D
		sta L_C381		;C9C4 8D 81 C3
		pla				;C9C7 68
		bpl L_C9CF		;C9C8 10 05
		dec ZP_2D		;C9CA C6 2D
		dec L_C381		;C9CC CE 81 C3
.L_C9CF	cpy #$80		;C9CF C0 80
		bcs L_C9E1		;C9D1 B0 0E
		cpy #$00		;C9D3 C0 00
		beq L_C9E0		;C9D5 F0 09
.L_C9D7	lsr L_C381		;C9D7 4E 81 C3
		ror A			;C9DA 6A
		ror ZP_14		;C9DB 66 14
		dey				;C9DD 88
		bne L_C9D7		;C9DE D0 F7
.L_C9E0	rts				;C9E0 60
.L_C9E1	asl ZP_14		;C9E1 06 14
		rol A			;C9E3 2A
		rol ZP_2D		;C9E4 26 2D
		iny				;C9E6 C8
		bne L_C9E1		;C9E7 D0 F8
		rts				;C9E9 60
}

.update_state
{
		lda L_0122		;C9EA AD 22 01
		sta ZP_14		;C9ED 85 14
		lda L_0125		;C9EF AD 25 01
		jsr sincos		;C9F2 20 D7 C7
		lda ZP_57		;C9F5 A5 57
		sta ZP_44		;C9F7 85 44
		lda ZP_56		;C9F9 A5 56
		sta ZP_43		;C9FB 85 43
		lda ZP_59		;C9FD A5 59
		sta ZP_79		;C9FF 85 79
		lda ZP_58		;CA01 A5 58
		sta ZP_7A		;CA03 85 7A
		lda L_0122		;CA05 AD 22 01
		sec				;CA08 38
		sbc L_0189		;CA09 ED 89 01
		sta ZP_14		;CA0C 85 14
		lda L_0125		;CA0E AD 25 01
		sbc L_018A		;CA11 ED 8A 01
		jsr sincos		;CA14 20 D7 C7
		lda ZP_57		;CA17 A5 57
		sta ZP_51		;CA19 85 51
		lda ZP_56		;CA1B A5 56
		sta ZP_52		;CA1D 85 52
		lda ZP_59		;CA1F A5 59
		sta ZP_77		;CA21 85 77
		lda ZP_58		;CA23 A5 58
		sta ZP_78		;CA25 85 78
		lda L_0121		;CA27 AD 21 01
		sta ZP_14		;CA2A 85 14
		lda L_0124		;CA2C AD 24 01
		jsr sincos		;CA2F 20 D7 C7
		ldx #$06		;CA32 A2 06
		lda ZP_56		;CA34 A5 56
		sta ZP_15		;CA36 85 15
		ldy ZP_43		;CA38 A4 43
		lda ZP_58		;CA3A A5 58
		eor ZP_7A		;CA3C 45 7A
		jsr multiply_and_store_in_state		;CA3E 20 D8 CB
		ldx #$08		;CA41 A2 08
		ldy ZP_44		;CA43 A4 44
		lda ZP_58		;CA45 A5 58
		eor ZP_79		;CA47 45 79
		jsr multiply_and_store_in_state		;CA49 20 D8 CB
		ldx #$1A		;CA4C A2 1A
		ldy ZP_52		;CA4E A4 52
		lda ZP_58		;CA50 A5 58
		eor ZP_78		;CA52 45 78
		jsr multiply_and_store_in_state		;CA54 20 D8 CB
		ldx #$1C		;CA57 A2 1C
		ldy ZP_51		;CA59 A4 51
		lda ZP_58		;CA5B A5 58
		eor ZP_77		;CA5D 45 77
		jsr multiply_and_store_in_state		;CA5F 20 D8 CB
		ldx #$02		;CA62 A2 02
		lda ZP_57		;CA64 A5 57
		sta ZP_15		;CA66 85 15
		ldy ZP_43		;CA68 A4 43
		lda ZP_59		;CA6A A5 59
		eor ZP_7A		;CA6C 45 7A
		jsr multiply_and_store_abs_in_state		;CA6E 20 17 CC
		ldx #$03		;CA71 A2 03
		ldy ZP_44		;CA73 A4 44
		lda ZP_59		;CA75 A5 59
		eor ZP_79		;CA77 45 79
		jsr multiply_and_store_abs_in_state		;CA79 20 17 CC
		ldx #$22		;CA7C A2 22
		ldy ZP_52		;CA7E A4 52
		lda ZP_59		;CA80 A5 59
		eor ZP_78		;CA82 45 78
		jsr multiply_and_store_abs_in_state		;CA84 20 17 CC
		ldx #$23		;CA87 A2 23
		ldy ZP_51		;CA89 A4 51
		lda ZP_59		;CA8B A5 59
		eor ZP_77		;CA8D 45 77
		jsr multiply_and_store_abs_in_state		;CA8F 20 17 CC
		ldx #$04		;CA92 A2 04
		lda ZP_56		;CA94 A5 56
		ldy ZP_58		;CA96 A4 58
		jsr store_fixed_up_sincos_in_state		;CA98 20 01 CC
		jsr abs_state		;CA9B 20 1A CC
		ldx #$1E		;CA9E A2 1E
		lda ZP_51		;CAA0 A5 51
		ldy ZP_77		;CAA2 A4 77
		jsr store_fixed_up_sincos_in_state		;CAA4 20 01 CC
		ldx #$20		;CAA7 A2 20
		lda ZP_52		;CAA9 A5 52
		ldy ZP_78		;CAAB A4 78
		jsr store_fixed_up_sincos_in_state		;CAAD 20 01 CC
		lda #$04		;CAB0 A9 04
		sta L_07AC		;CAB2 8D AC 07
		lda #$00		;CAB5 A9 00
		sta L_0784		;CAB7 8D 84 07
		ldx #$0A		;CABA A2 0A
		lda ZP_43		;CABC A5 43
		ldy ZP_7A		;CABE A4 7A
		jsr store_fixed_up_sincos_in_state		;CAC0 20 01 CC
		ldx #$0C		;CAC3 A2 0C
		lda ZP_44		;CAC5 A5 44
		ldy ZP_79		;CAC7 A4 79
		jsr store_fixed_up_sincos_in_state		;CAC9 20 01 CC
		ldx #$0E		;CACC A2 0E
		lda ZP_57		;CACE A5 57
		ldy ZP_59		;CAD0 A4 59
		jsr store_fixed_up_sincos_in_state		;CAD2 20 01 CC
		ldy #$06		;CAD5 A0 06
.L_CAD7	sty ZP_0D		;CAD7 84 0D
		lda L_0774,Y	;CAD9 B9 74 07
		sta ZP_14		;CADC 85 14
		lda L_079C,Y	;CADE B9 9C 07
		sta ZP_5A		;CAE1 85 5A
		asl ZP_14		;CAE3 06 14
		rol A			;CAE5 2A
		tax				;CAE6 AA
		lda ZP_14		;CAE7 A5 14
		lsr A			;CAE9 4A
		tay				;CAEA A8
		lda L_0380,Y	;CAEB B9 80 03
		clc				;CAEE 18
		adc L_C310,X	;CAEF 7D 10 C3
		sta ZP_14		;CAF2 85 14
		lda #$00		;CAF4 A9 00
		adc L_C31C,X	;CAF6 7D 1C C3
		lsr A			;CAF9 4A
		ror ZP_14		;CAFA 66 14
		sta ZP_15		;CAFC 85 15
		lda L_0300,Y	;CAFE B9 00 03
		clc				;CB01 18
		adc L_C328,X	;CB02 7D 28 C3
		ldy #$00		;CB05 A0 00
		eor #$80		;CB07 49 80
		sta ZP_16		;CB09 85 16
		bpl L_CB0E		;CB0B 10 01
		dey				;CB0D 88
.L_CB0E	tya				;CB0E 98
		adc L_C334,X	;CB0F 7D 34 C3
		bit ZP_5A		;CB12 24 5A
		bpl L_CB23		;CB14 10 0D
		sta ZP_17		;CB16 85 17
		lda #$00		;CB18 A9 00
		sec				;CB1A 38
		sbc ZP_16		;CB1B E5 16
		sta ZP_16		;CB1D 85 16
		lda #$00		;CB1F A9 00
		sbc ZP_17		;CB21 E5 17
.L_CB23	ldy ZP_0D		;CB23 A4 0D
		sta L_079D,Y	;CB25 99 9D 07
		lda ZP_16		;CB28 A5 16
		sta L_0775,Y	;CB2A 99 75 07
		lda ZP_5A		;CB2D A5 5A
		eor L_0126		;CB2F 4D 26 01
		bpl L_CB41		;CB32 10 0D
		lda #$00		;CB34 A9 00
		sec				;CB36 38
		sbc ZP_14		;CB37 E5 14
		sta ZP_14		;CB39 85 14
		lda #$00		;CB3B A9 00
		sbc ZP_15		;CB3D E5 15
		sta ZP_15		;CB3F 85 15
.L_CB41	lda ZP_14		;CB41 A5 14
		sta L_0774,Y	;CB43 99 74 07
		lda ZP_15		;CB46 A5 15
		sta L_079C,Y	;CB48 99 9C 07
		iny				;CB4B C8
		iny				;CB4C C8
		cpy #$12		;CB4D C0 12
		bcc L_CAD7		;CB4F 90 86
		bne L_CB55		;CB51 D0 02
		ldy #$1A		;CB53 A0 1A
.L_CB55	cpy #$22		;CB55 C0 22
		bcs L_CB5C		;CB57 B0 03
		jmp L_CAD7		;CB59 4C D7 CA
.L_CB5C	lda L_0780		;CB5C AD 80 07
		sec				;CB5F 38
		sbc L_077B		;CB60 ED 7B 07
		sta L_0788		;CB63 8D 88 07
		lda L_07A8		;CB66 AD A8 07
		sbc L_07A3		;CB69 ED A3 07
		sta L_07B0		;CB6C 8D B0 07
		lda #$00		;CB6F A9 00
		sec				;CB71 38
		sbc L_077D		;CB72 ED 7D 07
		sta ZP_14		;CB75 85 14
		lda #$00		;CB77 A9 00
		sbc L_07A5		;CB79 ED A5 07
		sta ZP_15		;CB7C 85 15
		lda ZP_14		;CB7E A5 14
		sec				;CB80 38
		sbc L_077E		;CB81 ED 7E 07
		sta L_0789		;CB84 8D 89 07
		lda ZP_15		;CB87 A5 15
		sbc L_07A6		;CB89 ED A6 07
		sta L_07B1		;CB8C 8D B1 07
		lda L_0781		;CB8F AD 81 07
		clc				;CB92 18
		adc L_077A		;CB93 6D 7A 07
		sta L_078A		;CB96 8D 8A 07
		lda L_07A9		;CB99 AD A9 07
		adc L_07A2		;CB9C 6D A2 07
		sta L_07B2		;CB9F 8D B2 07
		lda L_077C		;CBA2 AD 7C 07
		sec				;CBA5 38
		sbc L_077F		;CBA6 ED 7F 07
		sta L_078B		;CBA9 8D 8B 07
		lda L_07A4		;CBAC AD A4 07
		sbc L_07A7		;CBAF ED A7 07
		sta L_07B3		;CBB2 8D B3 07
		lda #$00		;CBB5 A9 00
		sec				;CBB7 38
		sbc L_0782		;CBB8 ED 82 07
		sta L_078C		;CBBB 8D 8C 07
		lda #$00		;CBBE A9 00
		sbc L_07AA		;CBC0 ED AA 07
		sta L_07B4		;CBC3 8D B4 07
		lda #$00		;CBC6 A9 00
		sec				;CBC8 38
		sbc L_0784		;CBC9 ED 84 07
		sta L_0786		;CBCC 8D 86 07
		lda #$00		;CBCF A9 00
		sbc L_07AC		;CBD1 ED AC 07
		sta L_07AE		;CBD4 8D AE 07
		rts				;CBD7 60
}

; multiply	two values, and	store in the state.
;
; entry: Y	= first	value; byte_15 = second	value; X = state index;	if N set, result will be negative.
.multiply_and_store_in_state
{
		php				;CBD8 08
		lda #$00		;CBD9 A9 00
		sta ZP_16		;CBDB 85 16
		tya				;CBDD 98
		jsr mul_8_8_16bit		;CBDE 20 82 C7
		asl ZP_14		;CBE1 06 14
		rol A			;CBE3 2A
		rol ZP_16		;CBE4 26 16
		asl ZP_14		;CBE6 06 14
		rol A			;CBE8 2A
		rol ZP_16		;CBE9 26 16
		asl ZP_14		;CBEB 06 14
		adc #$00		;CBED 69 00
		bcc L_CBF3		;CBEF 90 02
		inc ZP_16		;CBF1 E6 16
.L_CBF3	sta L_0774,X	;CBF3 9D 74 07
		lda ZP_16		;CBF6 A5 16
		plp				;CBF8 28
		bpl L_CBFD		;CBF9 10 02
		ora #$80		;CBFB 09 80
.L_CBFD	sta L_079C,X	;CBFD 9D 9C 07
		rts				;CC00 60
}

; fix up sign of sin/cos result and store in state.
; 
; entry: A	= sign flag; Y = value;	X = state index.
.store_fixed_up_sincos_in_state
{
		sta ZP_14		;CC01 85 14
		tya				;CC03 98
		and #$80		;CC04 29 80
		lsr A			;CC06 4A
		lsr A			;CC07 4A
		asl ZP_14		;CC08 06 14
		rol A			;CC0A 2A
		asl ZP_14		;CC0B 06 14
		rol A			;CC0D 2A
		sta L_079C,X	;CC0E 9D 9C 07
		lda ZP_14		;CC11 A5 14
		sta L_0774,X	;CC13 9D 74 07
		rts				;CC16 60
}

.multiply_and_store_abs_in_state
		jsr multiply_and_store_in_state		;CC17 20 D8 CB

; set state value to its absolute.
; 
; entry: X	= index	of state value.

.abs_state
{
		lda L_079C,X	;CC1A BD 9C 07
		bpl L_CC30		;CC1D 10 11
		lda #$00		;CC1F A9 00
		sec				;CC21 38
		sbc L_0774,X	;CC22 FD 74 07
		sta L_0774,X	;CC25 9D 74 07
		lda #$80		;CC28 A9 80
		sbc L_079C,X	;CC2A FD 9C 07
		sta L_079C,X	;CC2D 9D 9C 07
.L_CC30	rts				;CC30 60
}

; only called from game update
.L_CC31_from_game_update
{
		ldy #$02		;CC31 A0 02
.L_CC33	lda L_0109		;CC33 AD 09 01
		sta ZP_14		;CC36 85 14
		lda L_010F		;CC38 AD 0F 01
		ldx L_AFC0,Y	;CC3B BE C0 AF
		jsr mul_8_16_16bit_from_state		;CC3E 20 5F C8
		sta ZP_77		;CC41 85 77
		lda ZP_14		;CC43 A5 14
		sta ZP_51		;CC45 85 51
		lda L_010A		;CC47 AD 0A 01
		sta ZP_14		;CC4A 85 14
		lda L_0110		;CC4C AD 10 01
		ldx L_AFC3,Y	;CC4F BE C3 AF
		jsr mul_8_16_16bit_from_state		;CC52 20 5F C8
		tax				;CC55 AA
		lda ZP_14		;CC56 A5 14
		clc				;CC58 18
		adc ZP_51		;CC59 65 51
		sta ZP_51		;CC5B 85 51
		txa				;CC5D 8A
		adc ZP_77		;CC5E 65 77
		sta ZP_77		;CC60 85 77
		lda L_010B		;CC62 AD 0B 01
		sta ZP_14		;CC65 85 14
		lda L_0111		;CC67 AD 11 01
		ldx L_AFC6,Y	;CC6A BE C6 AF
		jsr mul_8_16_16bit_from_state		;CC6D 20 5F C8
		tax				;CC70 AA
		lda ZP_14		;CC71 A5 14
		clc				;CC73 18
		adc ZP_51		;CC74 65 51
		sta L_0154,Y	;CC76 99 54 01
		txa				;CC79 8A
		adc ZP_77		;CC7A 65 77
		sta L_0157,Y	;CC7C 99 57 01
		dey				;CC7F 88
		dey				;CC80 88
		bpl L_CC33		;CC81 10 B0
		rts				;CC83 60
}

.calculate_friction_and_gravity
{
		lda #$80		;CC84 A9 80
		sta ZP_5A		;CC86 85 5A
		ldx #$0F		;CC88 A2 0F
		jsr get_one_third_of_state_value		;CC8A 20 3A C9
		sta L_0140		;CC8D 8D 40 01
		lda ZP_14		;CC90 A5 14
		sta L_013D		;CC92 8D 3D 01
		ldx #$04		;CC95 A2 04
		jsr get_one_third_of_state_value		;CC97 20 3A C9
		sta L_0141		;CC9A 8D 41 01
		lda ZP_14		;CC9D A5 14
		sta L_013E		;CC9F 8D 3E 01
		ldx #$0E		;CCA2 A2 0E
		jsr get_one_third_of_state_value		;CCA4 20 3A C9
		jsr negate_16bit		;CCA7 20 BF C8
		sta L_013F		;CCAA 8D 3F 01
		lda ZP_14		;CCAD A5 14
		sta L_013C		;CCAF 8D 3C 01
		rts				;CCB2 60
}

; only called from game update
.L_CCB3_from_game_update
{
		ldy #$02		;CCB3 A0 02
.L_CCB5	lda L_015A		;CCB5 AD 5A 01
		sta ZP_14		;CCB8 85 14
		lda L_015D		;CCBA AD 5D 01
		ldx L_AFC9,Y	;CCBD BE C9 AF
		jsr mul_8_16_16bit_from_state		;CCC0 20 5F C8
		sta ZP_77		;CCC3 85 77
		lda ZP_14		;CCC5 A5 14
		sta ZP_51		;CCC7 85 51
		lda L_015B		;CCC9 AD 5B 01
		sta ZP_14		;CCCC 85 14
		lda L_015E		;CCCE AD 5E 01
		ldx L_AFCC,Y	;CCD1 BE CC AF
		jsr mul_8_16_16bit_from_state		;CCD4 20 5F C8
		tax				;CCD7 AA
		lda ZP_14		;CCD8 A5 14
		clc				;CCDA 18
		adc ZP_51		;CCDB 65 51
		sta ZP_51		;CCDD 85 51
		txa				;CCDF 8A
		adc ZP_77		;CCE0 65 77
		sta ZP_77		;CCE2 85 77
		lda L_015C		;CCE4 AD 5C 01
		sta ZP_14		;CCE7 85 14
		lda L_015F		;CCE9 AD 5F 01
		ldx L_AFCF,Y	;CCEC BE CF AF
		jsr mul_8_16_16bit_from_state		;CCEF 20 5F C8
		tax				;CCF2 AA
		lda ZP_14		;CCF3 A5 14
		clc				;CCF5 18
		adc ZP_51		;CCF6 65 51
		sta L_0115,Y	;CCF8 99 15 01
		txa				;CCFB 8A
		adc ZP_77		;CCFC 65 77
		sta L_011B,Y	;CCFE 99 1B 01
		dey				;CD01 88
		bpl L_CCB5		;CD02 10 B1
		rts				;CD04 60
}

; only called from game update
.L_CD05_from_game_update
{
		ldy #$01		;CD05 A0 01
.L_CD07	lda L_010C		;CD07 AD 0C 01
		sta ZP_14		;CD0A 85 14
		lda L_0112		;CD0C AD 12 01
		ldx L_AFD2,Y	;CD0F BE D2 AF
		jsr mul_8_16_16bit_from_state		;CD12 20 5F C8
		sta ZP_77		;CD15 85 77
		lda ZP_14		;CD17 A5 14
		sta ZP_51		;CD19 85 51
		lda L_010D		;CD1B AD 0D 01
		sta ZP_14		;CD1E 85 14
		lda L_0113		;CD20 AD 13 01
		ldx L_AFD4,Y	;CD23 BE D4 AF
		jsr mul_8_16_16bit_from_state		;CD26 20 5F C8
		tax				;CD29 AA
		lda ZP_14		;CD2A A5 14
		clc				;CD2C 18
		adc ZP_51		;CD2D 65 51
		sta L_016A,Y	;CD2F 99 6A 01
		txa				;CD32 8A
		adc ZP_77		;CD33 65 77
		sta L_016D,Y	;CD35 99 6D 01
		dey				;CD38 88
		bpl L_CD07		;CD39 10 CC
		lda L_016B		;CD3B AD 6B 01
		sta ZP_14		;CD3E 85 14
		lda L_016E		;CD40 AD 6E 01
		ldx #$04		;CD43 A2 04
		jsr mul_8_16_16bit_from_state		;CD45 20 5F C8
		sta ZP_15		;CD48 85 15
		lda L_010E		;CD4A AD 0E 01
		clc				;CD4D 18
		adc ZP_14		;CD4E 65 14
		sta L_016C		;CD50 8D 6C 01
		lda L_0114		;CD53 AD 14 01
		adc ZP_15		;CD56 65 15
		sta L_016F		;CD58 8D 6F 01
		rts				;CD5B 60
}

.L_CD5C
{
		lsr A			;CD5C 4A
		bcc L_CD72		;CD5D 90 13
		lda VIC_RASTER		;CD5F AD 12 D0
		cmp #$72		;CD62 C9 72
		bcs L_CD84		;CD64 B0 1E
		lda VIC_SCROLX		;CD66 AD 16 D0
		ora #$10		;CD69 09 10
		sta VIC_SCROLX		;CD6B 8D 16 D0
		lda #$72		;CD6E A9 72
		bne L_CD9F		;CD70 D0 2D
.L_CD72	lda VIC_RASTER		;CD72 AD 12 D0
		bpl L_CD90		;CD75 10 19
		cmp #$D5		;CD77 C9 D5
		bcs L_CD84		;CD79 B0 09
		lda #$0B		;CD7B A9 0B
		sta VIC_BGCOL0		;CD7D 8D 21 D0
		lda #$D5		;CD80 A9 D5
		bne L_CD9F		;CD82 D0 1B
.L_CD84	lda VIC_SCROLX		;CD84 AD 16 D0
		and #$EF		;CD87 29 EF
		sta VIC_SCROLX		;CD89 8D 16 D0
		lda #$28		;CD8C A9 28
		bne L_CD9F		;CD8E D0 0F
.L_CD90	lda VIC_SCROLX		;CD90 AD 16 D0
		ora #$10		;CD93 09 10
		sta VIC_SCROLX		;CD95 8D 16 D0
		lda #$00		;CD98 A9 00
		sta VIC_BGCOL0		;CD9A 8D 21 D0
		lda #$CE		;CD9D A9 CE
.L_CD9F	jmp L_CF49		;CD9F 4C 49 CF
.L_CDA2	lda CIA1_CIAICR		;CDA2 AD 0D DC
		lda CIA2_C2DDRA		;CDA5 AD 0D DD
.L_CDA8	pla				;CDA8 68
		rti				;CDA9 40

.L_CDAA		; C64 game init sets IRQ/BRK vector to $CDAA

		sei				;CDAA 78
		pha				;CDAB 48
		lda VIC_VICIRQ		;CDAC AD 19 D0
		bpl L_CDA2		;CDAF 10 F1
		lda #$01		;CDB1 A9 01
		sta VIC_VICIRQ		;CDB3 8D 19 D0
		lda L_3DF8		;CDB6 AD F8 3D
		beq L_CDA8		;CDB9 F0 ED
		bpl L_CD5C		;CDBB 10 9F
		lda VIC_RASTER		;CDBD AD 12 D0
		bpl L_CDC5		;CDC0 10 03
		jmp L_CEA1		;CDC2 4C A1 CE
.L_CDC5	lda L_C37A		;CDC5 AD 7A C3
		beq L_CDD0		;CDC8 F0 06
		lda L_C35F		;CDCA AD 5F C3
		jmp L_CDD6		;CDCD 4C D6 CD
.L_CDD0	lda L_C370		;CDD0 AD 70 C3
		sta L_C35F		;CDD3 8D 5F C3
.L_CDD6	bpl L_CDE0		;CDD6 10 08
		lda #$70		;CDD8 A9 70
		sta VIC_VMCSB		;CDDA 8D 18 D0
		jmp L_CE1B		;CDDD 4C 1B CE
.L_CDE0	lda #$78		;CDE0 A9 78
		sta VIC_VMCSB		;CDE2 8D 18 D0
		lda L_C355		;CDE5 AD 55 C3
		beq L_CE1B		;CDE8 F0 31
		lda VIC_RASTER		;CDEA AD 12 D0
		cmp #$64		;CDED C9 64
		bcs L_CE1B		;CDEF B0 2A
		lda #$50		;CDF1 A9 50
		sta VIC_SP0Y		;CDF3 8D 01 D0
		sta VIC_SP1Y		;CDF6 8D 03 D0
		lda #$A0		;CDF9 A9 A0
		sta VIC_SP0X		;CDFB 8D 00 D0
		lda #$B8		;CDFE A9 B8
		sta VIC_SP1X		;CE00 8D 02 D0
		lda L_C399		;CE03 AD 99 C3
		sta VIC_SP0COL		;CE06 8D 27 D0
		sta VIC_SP1COL		;CE09 8D 28 D0
		lda #$FE		;CE0C A9 FE
		sta L_5FF8		;CE0E 8D F8 5F
		lda #$FF		;CE11 A9 FF
		sta L_5FF9		;CE13 8D F9 5F
		lda #$64		;CE16 A9 64
		jmp L_CF49		;CE18 4C 49 CF
.L_CE1B	lda #$BB		;CE1B A9 BB
		sta VIC_SP2Y		;CE1D 8D 05 D0
		sta VIC_SP3Y		;CE20 8D 07 D0
		lda #$38		;CE23 A9 38
		sta VIC_SP2X		;CE25 8D 04 D0
		lda #$20		;CE28 A9 20
		sta VIC_SP3X		;CE2A 8D 06 D0
		lda #$C8		;CE2D A9 C8
		sta VIC_MSIGX		;CE2F 8D 10 D0
		lda #$FF		;CE32 A9 FF
		sta VIC_SPMC		;CE34 8D 1C D0
		lda #$64		;CE37 A9 64
		sta L_5FFA		;CE39 8D FA 5F
		lda #$63		;CE3C A9 63
		sta L_5FFB		;CE3E 8D FB 5F
		lda #$03		;CE41 A9 03
		sta VIC_SP2COL		;CE43 8D 29 D0
		sta VIC_SP3COL		;CE46 8D 2A D0
		bit ZP_72		;CE49 24 72
		bpl L_CE97		;CE4B 10 4A
		txa				;CE4D 8A
		pha				;CE4E 48
		ldx L_C36D		;CE4F AE 6D C3
		dex				;CE52 CA
		bpl L_CE57		;CE53 10 02
		ldx #$01		;CE55 A2 01
.L_CE57	stx L_C36D		;CE57 8E 6D C3
		lda L_CF56,X	;CE5A BD 56 CF
		sta VIC_SP0X		;CE5D 8D 00 D0
		lda L_CF58,X	;CE60 BD 58 CF
		sta VIC_SP1X		;CE63 8D 02 D0
		lda L_CF66,X	;CE66 BD 66 CF
		sta VIC_MSIGX		;CE69 8D 10 D0
		lda L_CF5A,X	;CE6C BD 5A CF
		sta VIC_SP0Y		;CE6F 8D 01 D0
		lda L_CF5C,X	;CE72 BD 5C CF
		sta VIC_SP1Y		;CE75 8D 03 D0
		bit L_C35F		;CE78 2C 5F C3
		bpl L_CE81		;CE7B 10 04
		inx				;CE7D E8
		inx				;CE7E E8
		inx				;CE7F E8
		inx				;CE80 E8
.L_CE81	lda L_CF5E,X	;CE81 BD 5E CF
		sta L_5FF8		;CE84 8D F8 5F
		lda L_CF60,X	;CE87 BD 60 CF
		sta L_5FF9		;CE8A 8D F9 5F
		lda #$07		;CE8D A9 07
		sta VIC_SP0COL		;CE8F 8D 27 D0
		sta VIC_SP1COL		;CE92 8D 28 D0
		pla				;CE95 68
		tax				;CE96 AA
.L_CE97	lda ZP_6E		;CE97 A5 6E
		sta VIC_SPENA		;CE99 8D 15 D0
		lda #$C5		;CE9C A9 C5
		jmp L_CF49		;CE9E 4C 49 CF
.L_CEA1	cmp #$D7		;CEA1 C9 D7
		bcs L_CEB5		;CEA3 B0 10
		lda #$78		;CEA5 A9 78
		sta VIC_VMCSB		;CEA7 8D 18 D0
		lda L_C37A		;CEAA AD 7A C3
		sta L_C37B		;CEAD 8D 7B C3
		lda #$D7		;CEB0 A9 D7
		jmp L_CF49		;CEB2 4C 49 CF
.L_CEB5	lda #$E4		;CEB5 A9 E4
		sta VIC_SP2Y		;CEB7 8D 05 D0
		sta VIC_SP3Y		;CEBA 8D 07 D0
		sta VIC_SP0Y		;CEBD 8D 01 D0
		sta VIC_SP1Y		;CEC0 8D 03 D0
		lda L_140D		;CEC3 AD 0D 14
		sta VIC_SP0X		;CEC6 8D 00 D0
		lda L_140E		;CEC9 AD 0E 14
		sta VIC_SP1X		;CECC 8D 02 D0
		lda L_140F		;CECF AD 0F 14
		sta VIC_SP2X		;CED2 8D 04 D0
		lda L_1410		;CED5 AD 10 14
		sta VIC_SP3X		;CED8 8D 06 D0
		lda #$0C		;CEDB A9 0C
		sta VIC_MSIGX		;CEDD 8D 10 D0
		lda #$00		;CEE0 A9 00
		sta L_5FF8		;CEE2 8D F8 5F
		lda #$01		;CEE5 A9 01
		sta L_5FF9		;CEE7 8D F9 5F
		lda #$02		;CEEA A9 02
		sta L_5FFA		;CEEC 8D FA 5F
		lda #$03		;CEEF A9 03
		sta L_5FFB		;CEF1 8D FB 5F
		lda #$00		;CEF4 A9 00
		sta VIC_SP2COL		;CEF6 8D 29 D0
		sta VIC_SP3COL		;CEF9 8D 2A D0
		sta VIC_SP0COL		;CEFC 8D 27 D0
		sta VIC_SP1COL		;CEFF 8D 28 D0
		sta VIC_SPMC		;CF02 8D 1C D0
		lda ZP_6F		;CF05 A5 6F
		sta VIC_SPENA		;CF07 8D 15 D0
		txa				;CF0A 8A
		pha				;CF0B 48
		tya				;CF0C 98
		pha				;CF0D 48
		cld				;CF0E D8
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
		sta SID_FREHI1		;CF20 8D 01 D4	; SID
		stx ZP_09		;CF23 86 09
		lsr A			;CF25 4A
		sta SID_FREHI3		;CF26 8D 0F D4	; SID
		lda ZP_09		;CF29 A5 09
		and #$FE		;CF2B 29 FE
		sta SID_FRELO1		;CF2D 8D 00 D4	; SID
		ror A			;CF30 6A
		sta SID_FRELO3		;CF31 8D 0E D4	; SID
		jsr sid_update		;CF34 20 EF 86
		lda ZP_5F		;CF37 A5 5F
		clc				;CF39 18
		adc ZP_5D		;CF3A 65 5D
		sta ZP_5F		;CF3C 85 5F
		bcc L_CF43		;CF3E 90 03
		jsr update_tyre_spritesQ		;CF40 20 B1 FF
.L_CF43	pla				;CF43 68
		tay				;CF44 A8
		pla				;CF45 68
		tax				;CF46 AA
		lda #$3D		;CF47 A9 3D
.L_CF49	sta VIC_RASTER		;CF49 8D 12 D0
		lda VIC_SCROLY		;CF4C AD 11 D0
		and #$7F		;CF4F 29 7F
		sta VIC_SCROLY		;CF51 8D 11 D0
		pla				;CF54 68
		rti				;CF55 40
		
.L_CF56	equb $46,$12
.L_CF58	equb $5E,$FA
.L_CF5A	equb $B4,$B4		
.L_CF5C	equb $AD,$AD
.L_CF5E	equb $6A,$6D
.L_CF60	equb $6B,$6C,$6E,$5F,$6F,$FD
.L_CF66	equb $C8,$C9
}

.L_CF68
{
		asl A			;CF68 0A
		asl A			;CF69 0A
		asl A			;CF6A 0A
		adc #$80		;CF6B 69 80
		tax				;CF6D AA
		ldy #$AF		;CF6E A0 AF
		jmp L_8655		;CF70 4C 55 86
}

.L_CF73
{
		ldx ZP_C6		;CF73 A6 C6
		ldy #$02		;CF75 A0 02
.L_CF77	txa				;CF77 8A
		eor #$01		;CF78 49 01
		tax				;CF7A AA
		lda L_A200,X	;CF7B BD 00 A2
		sec				;CF7E 38
		sbc #$80		;CF7F E9 80
		sta ZP_14		;CF81 85 14
		lda L_A298,X	;CF83 BD 98 A2
		sbc #$00		;CF86 E9 00
		jsr negate_if_N_set		;CF88 20 BD C8
		sta ZP_15		;CF8B 85 15
		lda ZP_14		;CF8D A5 14
		sec				;CF8F 38
		sbc #$50		;CF90 E9 50
		sta ZP_14		;CF92 85 14
		lda ZP_15		;CF94 A5 15
		sbc #$00		;CF96 E9 00
		bcc L_CFB3		;CF98 90 19
		lsr A			;CF9A 4A
		ror ZP_14		;CF9B 66 14
		lsr A			;CF9D 4A
		ror ZP_14		;CF9E 66 14
		sta ZP_15		;CFA0 85 15
		lda L_A24C,X	;CFA2 BD 4C A2
		clc				;CFA5 18
		adc ZP_14		;CFA6 65 14
		sta L_A24C,X	;CFA8 9D 4C A2
		lda L_A2E4,X	;CFAB BD E4 A2
		adc ZP_15		;CFAE 65 15
		sta L_A2E4,X	;CFB0 9D E4 A2
.L_CFB3	dey				;CFB3 88
		bne L_CF77		;CFB4 D0 C1
		rts				;CFB6 60
}

.L_CFB7
{
		sta ZP_15		;CFB7 85 15
		lda ZP_18		;CFB9 A5 18
		clc				;CFBB 18
		adc ZP_14		;CFBC 65 14
		sta ZP_14		;CFBE 85 14
		lda ZP_19		;CFC0 A5 19
		adc ZP_15		;CFC2 65 15
		rts				;CFC4 60
}

.L_CFC5
{
		ldx ZP_2E		;CFC5 A6 2E
		inx				;CFC7 E8
		cpx L_C764		;CFC8 EC 64 C7
		bcc L_CFCF		;CFCB 90 02
		ldx #$00		;CFCD A2 00
.L_CFCF	stx ZP_2E		;CFCF 86 2E
		rts				;CFD1 60
}

.L_CFD2
{
		ldx ZP_2E		;CFD2 A6 2E
		dex				;CFD4 CA
		bpl L_CFDB		;CFD5 10 04
		ldx L_C764		;CFD7 AE 64 C7
		dex				;CFDA CA
.L_CFDB	stx ZP_2E		;CFDB 86 2E
		rts				;CFDD 60
}

.track_preview_check_keys
{
		jsr check_game_keys		;CFDE 20 9E F7
		ldx ZP_66		;CFE1 A6 66
		txa				;CFE3 8A
		and #$04		;CFE4 29 04
		bne L_CFF9		;CFE6 D0 11
		txa				;CFE8 8A
		and #$08		;CFE9 29 08
		bne L_CFF4		;CFEB D0 07
		txa				;CFED 8A
		and #$10		;CFEE 29 10
		beq track_preview_check_keys		;CFF0 F0 EC
		clc				;CFF2 18
		rts				;CFF3 60
.L_CFF4	dec L_C34C		;CFF4 CE 4C C3
		sec				;CFF7 38
		rts				;CFF8 60
.L_CFF9	inc L_C34C		;CFF9 EE 4C C3
		sec				;CFFC 38
		rts				;CFFD 60
}

; *****************************************************************************
; COLOR RAM - TO REMOVE
; *****************************************************************************

L_CFFF = $CFFF
L_D100 = $D100		; CHARACTER ROM?
L_D200 = $D200		; CHARACTER ROM?
L_D300 = $D300		; CHARACTER ROM?
L_D800 = $D800		; COLOR RAM
L_D805 = $D805		; COLOR RAM
L_D900 = $D900		; COLOR RAM
L_DA00 = $DA00		; COLOR RAM
L_DB00 = $DB00		; COLOR RAM
L_DAB6 = $DAB6		; COLOR RAM
L_DAAC = $DAAC		; COLOR RAM
L_DACB = $DACB		; COLOR RAM
L_DBDA = $DBDA		; COLOR RAM
L_DBDB = $DBDB		; COLOR RAM
L_DBCC = $DBCC		; COLOR RAM
L_DBCD = $DBCD		; COLOR RAM

L_DCE0 = $DCE0		; SPARE RAM? CAN'T STAY HERE ON BEEB!

L_DE00 = $DE00		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DE01 = $DE01		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DE02 = $DE02		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DE0C = $DE0C		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DE0D = $DE0D		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DE0E = $DE0E		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DF00 = $DF00		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DF01 = $DF01		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DF02 = $DF02		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DF0C = $DF0C		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DF0D = $DF0D		; SPARE RAM? CAN'T STAY HERE ON BEEB!
L_DF0E = $DF0E		; SPARE RAM? CAN'T STAY HERE ON BEEB!

; *****************************************************************************
; KERNEL RAM: $E000 - $FFFF
;
; $E000 = Menu strings
; $E100 = Additional game code
; $E200 = Draw AI car
; ...
; $E800 = More subroutines
; ...
; $EE00 = Do menus
; ...
; $F000 = Menu data
; ...
; $F200 = Draw track preview
; ...
; $F600 = Update boosting
; ...
; $F800 = Drawing code?
; ...
; $FC00 = Line drawing code
; ...
; $FF00 = Vectors
; *****************************************************************************

ORG &E000
.frontend_strings_2
		equb $1F,$11,$0B,"SELECT",$FF
		equb "Practise ",$FF
		equb "Start the Racing Season",$FF
		equb "Load/Save/Replay       ",$FF
		equb "Load",$FF
		equb "Save",$FF
		equb "Replay",$FF
		equb "Cancel",$FF
		equb "LOAD from Tape",$FF
		equb "LOAD from Disc",$FF
		equb "SAVE to Tape",$FF
		equb "SAVE to Disc",$FF
		equb $1F,$05,$13,"   Filename?  >",$FF
		equb "to the SUPER LEAGUE",$FF
		equb $1F,$0C
.L_E0BD	equb $09,"SUPER DIVISION "
		equb $FF
		equb "EXCELLENT DRIVING - WELL DONE",$FF
		equb "Hall of Fame",$FF

.L_E0F9_with_sysctl
{
		ldx #$02		;E0F9 A2 02
.L_E0FB	lda #$15		;E0FB A9 15
		jsr sysctl		;E0FD 20 25 87
		dex				;E100 CA
		bpl L_E0FB		;E101 10 F8
		rts				;E103 60
}

.L_E104
{
		lda ZP_6A		;E104 A5 6A
		bne L_E116		;E106 D0 0E
		lda #$00		;E108 A9 00
		sta ZP_14		;E10A 85 14
		lda ZP_66		;E10C A5 66
		and #$03		;E10E 29 03
		beq L_E123		;E110 F0 11
		lda #$C8		;E112 A9 C8
		bne L_E123		;E114 D0 0D
.L_E116	lda L_0156		;E116 AD 56 01
		and #$F0		;E119 29 F0
		sta ZP_14		;E11B 85 14
		lda L_0159		;E11D AD 59 01
		jsr negate_if_N_set		;E120 20 BD C8
.L_E123	clc				;E123 18
		adc #$05		;E124 69 05
		sta ZP_16		;E126 85 16
		lsr A			;E128 4A
		ror ZP_14		;E129 66 14
		lsr A			;E12B 4A
		ror ZP_14		;E12C 66 14
		lsr A			;E12E 4A
		ror ZP_14		;E12F 66 14
		sta ZP_15		;E131 85 15
		lda ZP_14		;E133 A5 14
		sec				;E135 38
		sbc ZP_09		;E136 E5 09
		sta ZP_14		;E138 85 14
		lda ZP_15		;E13A A5 15
		sbc ZP_0A		;E13C E5 0A
		ldy #$03		;E13E A0 03
		jsr shift_16bit		;E140 20 BF C9
		sta ZP_11		;E143 85 11
		ldx ZP_14		;E145 A6 14
		stx ZP_10		;E147 86 10
		tay				;E149 A8
		bmi L_E154		;E14A 30 08
		beq L_E174		;E14C F0 26
		ldx #$00		;E14E A2 00
		lda #$01		;E150 A9 01
		bne L_E170		;E152 D0 1C
.L_E154	ldy ZP_6A		;E154 A4 6A
		beq L_E162		;E156 F0 0A
		cmp #$FF		;E158 C9 FF
		beq L_E174		;E15A F0 18
		ldx #$00		;E15C A2 00
		lda #$FF		;E15E A9 FF
		bne L_E170		;E160 D0 0E
.L_E162	cmp #$FF		;E162 C9 FF
		bne L_E16C		;E164 D0 06
		lda ZP_10		;E166 A5 10
		cmp #$E0		;E168 C9 E0
		bcs L_E174		;E16A B0 08
.L_E16C	ldx #$E0		;E16C A2 E0
		lda #$FF		;E16E A9 FF
.L_E170	sta ZP_11		;E170 85 11
		stx ZP_10		;E172 86 10
.L_E174	jsr rndQ		;E174 20 B9 29
		and #$3F		;E177 29 3F
		sta SID_PWLO1		;E179 8D 02 D4	; SID
		sta SID_PWLO3		;E17C 8D 10 D4
		lda ZP_16		;E17F A5 16
		cmp #$64		;E181 C9 64
		bcc L_E187		;E183 90 02
		lda #$63		;E185 A9 63
.L_E187	asl A			;E187 0A
		clc				;E188 18
		adc #$20		;E189 69 20
		cmp #$6E		;E18B C9 6E
		bcs L_E191		;E18D B0 02
		lda #$6E		;E18F A9 6E
.L_E191	sta SID_CUTHI		;E191 8D 16 D4
		rts				;E194 60
}

.L_E195
{
		lda L_C36A		;E195 AD 6A C3
		bmi L_E1A4		;E198 30 0A
		lda ZP_3A		;E19A A5 3A
		bne L_E1A5		;E19C D0 07
		lda ZP_39		;E19E A5 39
		cmp #$0A		;E1A0 C9 0A
		bcs L_E1A5		;E1A2 B0 01
.L_E1A4	rts				;E1A4 60
.L_E1A5	lda ZP_2F		;E1A5 A5 2F
		bne L_E1B1		;E1A7 D0 08
		lda ZP_6B		;E1A9 A5 6B
		bpl L_E1B1		;E1AB 10 04
		sta L_C366		;E1AD 8D 66 C3
		rts				;E1B0 60
}

.L_E1B1
{
		lsr L_C366		;E1B1 4E 66 C3
		lda #$00		;E1B4 A9 00
		sta ZP_61		;E1B6 85 61
		lda #$FF		;E1B8 A9 FF
		sta ZP_60		;E1BA 85 60
		ldy #$05		;E1BC A0 05
		ldx #$3C		;E1BE A2 3C
		jsr L_E641		;E1C0 20 41 E6
		ldy #$07		;E1C3 A0 07
		ldx #$3E		;E1C5 A2 3E
		jsr L_E641		;E1C7 20 41 E6
		ldy #$08		;E1CA A0 08
		ldx #$3D		;E1CC A2 3D
		jsr L_E641		;E1CE 20 41 E6
		ldy #$0A		;E1D1 A0 0A
		ldx #$3F		;E1D3 A2 3F
		jsr L_E641		;E1D5 20 41 E6
		ldx #$02		;E1D8 A2 02
.L_E1DA	lda L_A288,X	;E1DA BD 88 A2
		sec				;E1DD 38
		sbc L_A289,X	;E1DE FD 89 A2
		lda L_A320,X	;E1E1 BD 20 A3
		sbc L_A321,X	;E1E4 FD 21 A3
		bpl L_E1EE		;E1E7 10 05
		lda #$80		;E1E9 A9 80
		sta L_C3DA		;E1EB 8D DA C3
.L_E1EE	dex				;E1EE CA
		dex				;E1EF CA
		bpl L_E1DA		;E1F0 10 E8
		lda L_C3AB		;E1F2 AD AB C3
		pha				;E1F5 48
		ldx #$3C		;E1F6 A2 3C
		jsr L_E409		;E1F8 20 09 E4
		bcs L_E258		;E1FB B0 5B
		ldx #$02		;E1FD A2 02
.L_E1FF	lda ZP_37		;E1FF A5 37
		sec				;E201 38
		sbc L_07CC,X	;E202 FD CC 07
		lda ZP_38		;E205 A5 38
		sbc L_07D0,X	;E207 FD D0 07
		bmi L_E228		;E20A 30 1C
		dex				;E20C CA
		bpl L_E1FF		;E20D 10 F0
		bit L_C3DA		;E20F 2C DA C3
		bmi L_E22C		;E212 30 18
		lda ZP_C9		;E214 A5 C9
		beq L_E22C		;E216 F0 14
		jsr L_E294		;E218 20 94 E2
		ldx #$3D		;E21B A2 3D
		jsr L_E409		;E21D 20 09 E4
		bcs L_E258		;E220 B0 36
		jsr draw_aicar		;E222 20 E8 E6
		jmp L_E258		;E225 4C 58 E2
.L_E228	lda #$80		;E228 A9 80
		sta ZP_6D		;E22A 85 6D
.L_E22C	lda #$80		;E22C A9 80
		sta L_C303		;E22E 8D 03 C3
		jsr L_FC31		;E231 20 31 FC
		jsr L_E294		;E234 20 94 E2
		ldx #$3D		;E237 A2 3D
		jsr L_E409		;E239 20 09 E4
		bcs L_E252		;E23C B0 14
		bit L_C3DA		;E23E 2C DA C3
		bpl L_E24C		;E241 10 09
		jsr L_FC99		;E243 20 99 FC
		jsr L_FCB3		;E246 20 B3 FC
		jmp L_E24F		;E249 4C 4F E2
.L_E24C	jsr L_FCA2		;E24C 20 A2 FC
.L_E24F	jsr draw_aicar		;E24F 20 E8 E6
.L_E252	jsr do_ai_depth_stuff		;E252 20 35 2C
		jsr L_FC23		;E255 20 23 FC
.L_E258	pla				;E258 68
		tax				;E259 AA
		jmp set_linedraw_colour		;E25A 4C 01 FC
}

.L_E25D
{
		ldx #$03		;E25D A2 03
.L_E25F	lda ZP_E8,X		;E25F B5 E8
		bpl L_E268		;E261 10 05
		eor #$FF		;E263 49 FF
		clc				;E265 18
		adc #$01		;E266 69 01
.L_E268	lsr A			;E268 4A
		sta ZP_EC,X		;E269 95 EC
		lsr A			;E26B 4A
		sta ZP_F0,X		;E26C 95 F0
		lsr A			;E26E 4A
		sta ZP_F4,X		;E26F 95 F4
		ldy ZP_E8,X		;E271 B4 E8
		bpl L_E290		;E273 10 1B
		lda ZP_EC,X		;E275 B5 EC
		eor #$FF		;E277 49 FF
		clc				;E279 18
		adc #$01		;E27A 69 01
		sta ZP_EC,X		;E27C 95 EC
		lda ZP_F0,X		;E27E B5 F0
		eor #$FF		;E280 49 FF
		clc				;E282 18
		adc #$01		;E283 69 01
		sta ZP_F0,X		;E285 95 F0
		lda ZP_F4,X		;E287 B5 F4
		eor #$FF		;E289 49 FF
		clc				;E28B 18
		adc #$01		;E28C 69 01
		sta ZP_F4,X		;E28E 95 F4
.L_E290	dex				;E290 CA
		bpl L_E25F		;E291 10 CC
		rts				;E293 60
}

.L_E294
{
		bit ZP_EA		;E294 24 EA
		bmi L_E2A1		;E296 30 09
		jsr L_E388		;E298 20 88 E3
		jsr L_E2AA		;E29B 20 AA E2
		jmp L_E372		;E29E 4C 72 E3
.L_E2A1	jsr L_E372		;E2A1 20 72 E3
		jsr L_E2AA		;E2A4 20 AA E2
		jmp L_E388		;E2A7 4C 88 E3
.L_E2AA	ldx #$01		;E2AA A2 01
		jsr set_linedraw_colour		;E2AC 20 01 FC
		lda ZP_EC		;E2AF A5 EC
		sec				;E2B1 38
		sbc ZP_ED		;E2B2 E5 ED
		sta L_A247		;E2B4 8D 47 A2
		lda ZP_EE		;E2B7 A5 EE
		sec				;E2B9 38
		sbc ZP_EF		;E2BA E5 EF
		sta L_A293		;E2BC 8D 93 A2
		lda #$00		;E2BF A9 00
		sec				;E2C1 38
		sbc ZP_EC		;E2C2 E5 EC
		sec				;E2C4 38
		sbc ZP_ED		;E2C5 E5 ED
		sta L_A244		;E2C7 8D 44 A2
		lda #$00		;E2CA A9 00
		sec				;E2CC 38
		sbc ZP_EE		;E2CD E5 EE
		sec				;E2CF 38
		sbc ZP_EF		;E2D0 E5 EF
		sta L_A290		;E2D2 8D 90 A2
		lda ZP_E9		;E2D5 A5 E9
		clc				;E2D7 18
		adc ZP_F0		;E2D8 65 F0
		clc				;E2DA 18
		adc ZP_F4		;E2DB 65 F4
		sta L_A246		;E2DD 8D 46 A2
		lda ZP_EB		;E2E0 A5 EB
		clc				;E2E2 18
		adc ZP_F2		;E2E3 65 F2
		clc				;E2E5 18
		adc ZP_F6		;E2E6 65 F6
		sta L_A292		;E2E8 8D 92 A2
		lda ZP_E9		;E2EB A5 E9
		sec				;E2ED 38
		sbc ZP_F0		;E2EE E5 F0
		sec				;E2F0 38
		sbc ZP_F4		;E2F1 E5 F4
		sta L_A245		;E2F3 8D 45 A2
		lda ZP_EB		;E2F6 A5 EB
		sec				;E2F8 38
		sbc ZP_F2		;E2F9 E5 F2
		sec				;E2FB 38
		sbc ZP_F6		;E2FC E5 F6
		sta L_A291		;E2FE 8D 91 A2
		ldx #$04		;E301 A2 04
		jsr L_E31A		;E303 20 1A E3
		ldx #$03		;E306 A2 03
.L_E308	lda L_A244,X	;E308 BD 44 A2
		sta L_A240,X	;E30B 9D 40 A2
		lda L_A290,X	;E30E BD 90 A2
		sta L_A28C,X	;E311 9D 8C A2
		dex				;E314 CA
		bpl L_E308		;E315 10 F1
		jmp L_E3D8_with_draw_line		;E317 4C D8 E3
}

.L_E31A
{
		lda #$04		;E31A A9 04
		sta ZP_08		;E31C 85 08
.L_E31E	ldy #$00		;E31E A0 00
		lda L_A240,X	;E320 BD 40 A2
		bpl L_E326		;E323 10 01
		dey				;E325 88
.L_E326	sty ZP_15		;E326 84 15
		ldy ZP_FC		;E328 A4 FC
		bpl L_E32F		;E32A 10 03
		asl A			;E32C 0A
		rol ZP_15		;E32D 26 15
.L_E32F	clc				;E32F 18
		adc ZP_F8		;E330 65 F8
		tay				;E332 A8
		lda ZP_15		;E333 A5 15
		adc ZP_F9		;E335 65 F9
		beq L_E341		;E337 F0 08
		bpl L_E33F		;E339 10 04
		ldy #$00		;E33B A0 00
		beq L_E341		;E33D F0 02
.L_E33F	ldy #$FF		;E33F A0 FF
.L_E341	tya				;E341 98
		sta L_A240,X	;E342 9D 40 A2
		ldy #$00		;E345 A0 00
		lda L_A28C,X	;E347 BD 8C A2
		bpl L_E34D		;E34A 10 01
		dey				;E34C 88
.L_E34D	sty ZP_15		;E34D 84 15
		ldy ZP_FC		;E34F A4 FC
		bpl L_E356		;E351 10 03
		asl A			;E353 0A
		rol ZP_15		;E354 26 15
.L_E356	clc				;E356 18
		adc ZP_FA		;E357 65 FA
		tay				;E359 A8
		lda ZP_15		;E35A A5 15
		adc ZP_FB		;E35C 65 FB
		beq L_E368		;E35E F0 08
		bpl L_E366		;E360 10 04
		ldy #$00		;E362 A0 00
		beq L_E368		;E364 F0 02
.L_E366	ldy #$FF		;E366 A0 FF
.L_E368	tya				;E368 98
		sta L_A28C,X	;E369 9D 8C A2
		inx				;E36C E8
		dec ZP_08		;E36D C6 08
		bne L_E31E		;E36F D0 AD
		rts				;E371 60
}

.L_E372
{
		lda ZP_F8		;E372 A5 F8
		cmp #$40		;E374 C9 40
		bcc L_E387		;E376 90 0F
		lda #$00		;E378 A9 00
		sec				;E37A 38
		sbc ZP_E8		;E37B E5 E8
		sta ZP_D9		;E37D 85 D9
		lda #$00		;E37F A9 00
		sec				;E381 38
		sbc ZP_EA		;E382 E5 EA
		jmp L_E39A		;E384 4C 9A E3
}
.L_E387	rts				;E387 60

.L_E388
		lda ZP_F8		;E388 A5 F8
		cmp #$C0		;E38A C9 C0
		bcs L_E387		;E38C B0 F9
		lda ZP_E8		;E38E A5 E8
		sec				;E390 38
		sbc ZP_EC		;E391 E5 EC
		sta ZP_D9		;E393 85 D9
		lda ZP_EA		;E395 A5 EA
		sec				;E397 38
		sbc ZP_EE		;E398 E5 EE
\\
.L_E39A
		sta ZP_DA		;E39A 85 DA
		ldx #$00		;E39C A2 00
		jsr set_linedraw_colour		;E39E 20 01 FC
		lda ZP_D9		;E3A1 A5 D9
		sta L_A241		;E3A3 8D 41 A2
		clc				;E3A6 18
		adc ZP_EC		;E3A7 65 EC
		sta L_A242		;E3A9 8D 42 A2
		lda ZP_DA		;E3AC A5 DA
		sta L_A28D		;E3AE 8D 8D A2
		clc				;E3B1 18
		adc ZP_EE		;E3B2 65 EE
		sta L_A28E		;E3B4 8D 8E A2
		lda ZP_D9		;E3B7 A5 D9
		sec				;E3B9 38
		sbc ZP_E9		;E3BA E5 E9
		sta L_A240		;E3BC 8D 40 A2
;L_E3BF
		clc				;E3BF 18
		adc ZP_EC		;E3C0 65 EC
		sta L_A243		;E3C2 8D 43 A2
		lda ZP_DA		;E3C5 A5 DA
		sec				;E3C7 38
		sbc ZP_EB		;E3C8 E5 EB
		sta L_A28C		;E3CA 8D 8C A2
		clc				;E3CD 18
		adc ZP_EE		;E3CE 65 EE
		sta L_A28F		;E3D0 8D 8F A2
		ldx #$00		;E3D3 A2 00
		jsr L_E31A		;E3D5 20 1A E3
\\
.L_E3D8_with_draw_line
{
		ldx #$40		;E3D8 A2 40
		ldy #$43		;E3DA A0 43
		jsr L_FEAB_with_draw_line		;E3DC 20 AB FE
		bit ZP_EA		;E3DF 24 EA
		bmi L_E3F4		;E3E1 30 11
		ldx #$43		;E3E3 A2 43
		ldy #$42		;E3E5 A0 42
		jsr draw_line		;E3E7 20 C9 FE
		ldx #$40		;E3EA A2 40
		ldy #$41		;E3EC A0 41
		jsr draw_line		;E3EE 20 C9 FE
		jmp L_E402		;E3F1 4C 02 E4
.L_E3F4	ldx #$40		;E3F4 A2 40
		ldy #$41		;E3F6 A0 41
		jsr draw_line		;E3F8 20 C9 FE
		ldx #$43		;E3FB A2 43
		ldy #$42		;E3FD A0 42
		jsr draw_line		;E3FF 20 C9 FE
.L_E402	ldx #$41		;E402 A2 41
		ldy #$42		;E404 A0 42
		jmp L_FEAB_with_draw_line		;E406 4C AB FE
}

.L_E409
{
		lda L_A202,X	;E409 BD 02 A2
		sec				;E40C 38
		sbc L_A200,X	;E40D FD 00 A2
		sta ZP_51		;E410 85 51
		lda L_A29A,X	;E412 BD 9A A2
		sbc L_A298,X	;E415 FD 98 A2
		clc				;E418 18
		bpl L_E41C		;E419 10 01
		sec				;E41B 38
.L_E41C	ror A			;E41C 6A
		ror ZP_51		;E41D 66 51
		sta ZP_77		;E41F 85 77
		lda L_A24E,X	;E421 BD 4E A2
		sec				;E424 38
		sbc L_A24C,X	;E425 FD 4C A2
		sta ZP_52		;E428 85 52
		lda L_A2E6,X	;E42A BD E6 A2
		sbc L_A2E4,X	;E42D FD E4 A2
		clc				;E430 18
		bpl L_E434		;E431 10 01
		sec				;E433 38
.L_E434	ror A			;E434 6A
		ror ZP_52		;E435 66 52
		sta ZP_78		;E437 85 78
		ldy #$00		;E439 A0 00
		lda ZP_51		;E43B A5 51
		sta ZP_14		;E43D 85 14
		lda ZP_77		;E43F A5 77
		jsr negate_if_N_set		;E441 20 BD C8
		cmp #$00		;E444 C9 00
		bne L_E44E		;E446 D0 06
		lda ZP_14		;E448 A5 14
		cmp #$5B		;E44A C9 5B
		bcc L_E450		;E44C 90 02
.L_E44E	lda #$5A		;E44E A9 5A
.L_E450	sta ZP_EB		;E450 85 EB
		lda ZP_52		;E452 A5 52
		sta ZP_14		;E454 85 14
		lda ZP_78		;E456 A5 78
		jsr negate_if_N_set		;E458 20 BD C8
		cmp #$00		;E45B C9 00
		bne L_E465		;E45D D0 06
		lda ZP_14		;E45F A5 14
		cmp #$5B		;E461 C9 5B
		bcc L_E467		;E463 90 02
.L_E465	lda #$5A		;E465 A9 5A
.L_E467	sta ZP_EA		;E467 85 EA
		cmp ZP_EB		;E469 C5 EB
		bcs L_E46F		;E46B B0 02
		lda ZP_EB		;E46D A5 EB
.L_E46F	cmp #$40		;E46F C9 40
		bcc L_E47E		;E471 90 0B
		lda ZP_EB		;E473 A5 EB
		asl A			;E475 0A
		ror ZP_EB		;E476 66 EB
		lda ZP_EA		;E478 A5 EA
		asl A			;E47A 0A
		ror ZP_EA		;E47B 66 EA
		dey				;E47D 88
.L_E47E	sty ZP_FC		;E47E 84 FC
		lda ZP_EB		;E480 A5 EB
		sta ZP_E8		;E482 85 E8
		bit ZP_77		;E484 24 77
		bpl L_E492		;E486 10 0A
		lda #$00		;E488 A9 00
		sec				;E48A 38
		sbc ZP_E8		;E48B E5 E8
		sta ZP_E8		;E48D 85 E8
		jmp L_E499		;E48F 4C 99 E4
.L_E492	lda #$00		;E492 A9 00
		sec				;E494 38
		sbc ZP_EB		;E495 E5 EB
		sta ZP_EB		;E497 85 EB
.L_E499	lda ZP_EA		;E499 A5 EA
		lsr A			;E49B 4A
		lsr A			;E49C 4A
		sta ZP_E9		;E49D 85 E9
		bit ZP_78		;E49F 24 78
		bpl L_E4B1		;E4A1 10 0E
		lda #$00		;E4A3 A9 00
		sec				;E4A5 38
		sbc ZP_E9		;E4A6 E5 E9
		sta ZP_E9		;E4A8 85 E9
		lda #$00		;E4AA A9 00
		sec				;E4AC 38
		sbc ZP_EA		;E4AD E5 EA
		sta ZP_EA		;E4AF 85 EA
.L_E4B1	lda L_A200,X	;E4B1 BD 00 A2
		clc				;E4B4 18
		adc ZP_51		;E4B5 65 51
		sta ZP_F8		;E4B7 85 F8
		lda L_A298,X	;E4B9 BD 98 A2
		adc ZP_77		;E4BC 65 77
		sta ZP_F9		;E4BE 85 F9
		bne L_E4D8		;E4C0 D0 16
		lda L_A24C,X	;E4C2 BD 4C A2
		clc				;E4C5 18
		adc ZP_52		;E4C6 65 52
		sta ZP_FA		;E4C8 85 FA
		lda L_A2E4,X	;E4CA BD E4 A2
		adc ZP_78		;E4CD 65 78
		sta ZP_FB		;E4CF 85 FB
		bne L_E4D8		;E4D1 D0 05
		jsr L_E25D		;E4D3 20 5D E2
		clc				;E4D6 18
		rts				;E4D7 60
.L_E4D8	sec				;E4D8 38
		rts				;E4D9 60
}

.L_E4DA
{
		lda #$40		;E4DA A9 40
		jsr L_E5A1		;E4DC 20 A1 E5
		stx ZP_D4		;E4DF 86 D4
		sta ZP_D5		;E4E1 85 D5
		sty ZP_9C		;E4E3 84 9C
		jsr get_track_segment_detailsQ		;E4E5 20 2F F0
		jsr L_F0C5		;E4E8 20 C5 F0
		lda ZP_68		;E4EB A5 68
		sec				;E4ED 38
		sbc ZP_1D		;E4EE E5 1D
		sta ZP_3D		;E4F0 85 3D
		lda ZP_D5		;E4F2 A5 D5
		asl A			;E4F4 0A
		tax				;E4F5 AA
		jsr L_9C14		;E4F6 20 14 9C
		sta ZP_48		;E4F9 85 48
		lda ZP_15		;E4FB A5 15
		lsr A			;E4FD 4A
		lsr A			;E4FE 4A
		lsr A			;E4FF 4A
		lsr A			;E500 4A
		lsr A			;E501 4A
		sta ZP_5B		;E502 85 5B
		inx				;E504 E8
		jsr L_9C14		;E505 20 14 9C
		sta ZP_49		;E508 85 49
		inx				;E50A E8
		jsr L_9C14		;E50B 20 14 9C
		sta ZP_4A		;E50E 85 4A
		lda ZP_15		;E510 A5 15
		lsr A			;E512 4A
		lsr A			;E513 4A
		lsr A			;E514 4A
		lsr A			;E515 4A
		lsr A			;E516 4A
		sta ZP_DC		;E517 85 DC
		inx				;E519 E8
		jsr L_9C14		;E51A 20 14 9C
		sta ZP_4B		;E51D 85 4B
		inx				;E51F E8
		cpx ZP_9E		;E520 E4 9E
		bcc L_E538		;E522 90 14
		jsr L_CFC5		;E524 20 C5 CF
		jsr get_track_segment_detailsQ		;E527 20 2F F0
		ldx #$02		;E52A A2 02
		jsr L_E5C7		;E52C 20 C7 E5
		jsr L_CFD2		;E52F 20 D2 CF
		jsr get_track_segment_detailsQ		;E532 20 2F F0
		jmp L_E53B		;E535 4C 3B E5
}

.L_E538	jsr L_E5C7		;E538 20 C7 E5
\\
.L_E53B	lda ZP_D5		;E53B A5 D5
		jsr L_E808		;E53D 20 08 E8
		ldy #$04		;E540 A0 04
		ldx #$00		;E542 A2 00
\\
.L_E544
{
		jsr L_E628		;E544 20 28 E6
		ldy #$06		;E547 A0 06
		ldx #$01		;E549 A2 01
		jsr L_E628		;E54B 20 28 E6
		lsr L_C30B		;E54E 4E 0B C3
		ldx #$00		;E551 A2 00
		ldy #$01		;E553 A0 01
		jsr L_238E		;E555 20 8E 23
		lsr A			;E558 4A
		lda ZP_14		;E559 A5 14
		ror A			;E55B 6A
		lsr A			;E55C 4A
		lsr A			;E55D 4A
		lsr A			;E55E 4A
		tay				;E55F A8
		lda L_A620,Y	;E560 B9 20 A6
		sta L_C34D		;E563 8D 4D C3
		lda ZP_9C		;E566 A5 9C
		sta ZP_4D		;E568 85 4D
		lda ZP_B0		;E56A A5 B0
		sec				;E56C 38
		sbc L_C34D		;E56D ED 4D C3
		sta ZP_4C		;E570 85 4C
		ldx #$00		;E572 A2 00
		jsr L_FF94		;E574 20 94 FF
		ldy #$05		;E577 A0 05
		ldx #$04		;E579 A2 04
		lda ZP_4C		;E57B A5 4C
		jsr L_E631		;E57D 20 31 E6
		lda ZP_B0		;E580 A5 B0
		clc				;E582 18
		adc L_C34D		;E583 6D 4D C3
		sta ZP_4C		;E586 85 4C
		ldx #$01		;E588 A2 01
		jsr L_FF94		;E58A 20 94 FF
		ldy #$07		;E58D A0 07
		ldx #$04		;E58F A2 04
		lda ZP_4C		;E591 A5 4C
		jsr L_E631		;E593 20 31 E6
		jsr L_E65E		;E596 20 5E E6
		lda #$FF		;E599 A9 FF
		bit ZP_6B		;E59B 24 6B
		bpl L_E5A1		;E59D 10 02
		lda #$00		;E59F A9 00
}
\\
.L_E5A1
{
		sta ZP_14		;E5A1 85 14
		ldx L_C375		;E5A3 AE 75 C3
		stx ZP_2E		;E5A6 86 2E
		lda ZP_23		;E5A8 A5 23
		sec				;E5AA 38
		sbc ZP_14		;E5AB E5 14
		sta ZP_18		;E5AD 85 18
		lda ZP_C4		;E5AF A5 C4
		sbc #$00		;E5B1 E9 00
		bpl L_E5C0		;E5B3 10 0B
		jsr L_CFD2		;E5B5 20 D2 CF
		jsr get_track_segment_detailsQ		;E5B8 20 2F F0
		lda ZP_BE		;E5BB A5 BE
		sec				;E5BD 38
		sbc #$01		;E5BE E9 01
.L_E5C0	sta ZP_A3		;E5C0 85 A3
		stx ZP_A6		;E5C2 86 A6
		ldy ZP_18		;E5C4 A4 18
		rts				;E5C6 60
}

.L_E5C7
{
		jsr L_9C14		;E5C7 20 14 9C
		sta ZP_DD		;E5CA 85 DD
		lda ZP_15		;E5CC A5 15
		lsr A			;E5CE 4A
		lsr A			;E5CF 4A
		lsr A			;E5D0 4A
		lsr A			;E5D1 4A
		lsr A			;E5D2 4A
		sta ZP_DF		;E5D3 85 DF
		inx				;E5D5 E8
		jsr L_9C14		;E5D6 20 14 9C
		sta ZP_DE		;E5D9 85 DE
		rts				;E5DB 60
}

.L_E5DC
{
		lda L_C502,X	;E5DC BD 02 C5
		sec				;E5DF 38
		sbc L_C500,X	;E5E0 FD 00 C5
		sta ZP_14		;E5E3 85 14
		lda L_C512,X	;E5E5 BD 12 C5
		sbc L_C510,X	;E5E8 FD 10 C5
		php				;E5EB 08
		jsr negate_if_N_set		;E5EC 20 BD C8
		lsr A			;E5EF 4A
		ror ZP_14		;E5F0 66 14
		lda ZP_17		;E5F2 A5 17
		sta ZP_15		;E5F4 85 15
		lda ZP_14		;E5F6 A5 14
		jsr mul_8_8_16bit		;E5F8 20 82 C7
		asl ZP_14		;E5FB 06 14
		rol A			;E5FD 2A
		sta ZP_14		;E5FE 85 14
		lda #$00		;E600 A9 00
		rol A			;E602 2A
		plp				;E603 28
		jsr negate_if_N_set		;E604 20 BD C8
		sta ZP_15		;E607 85 15
		bit L_C30B		;E609 2C 0B C3
		bpl L_E616		;E60C 10 08
		inx				;E60E E8
		inx				;E60F E8
		jsr L_E616		;E610 20 16 E6
		dex				;E613 CA
		dex				;E614 CA
		rts				;E615 60
.L_E616	lda L_C500,X	;E616 BD 00 C5
		clc				;E619 18
		adc ZP_14		;E61A 65 14
		sta L_C500,Y	;E61C 99 00 C5
		lda L_C510,X	;E61F BD 10 C5
		adc ZP_15		;E622 65 15
		sta L_C510,Y	;E624 99 10 C5
		rts				;E627 60
}

.L_E628
		lda ZP_9C		;E628 A5 9C
		clc				;E62A 18
		adc L_C30D,X	;E62B 7D 0D C3
		ror L_C30B		;E62E 6E 0B C3
\\
.L_E631
{
		sta ZP_17		;E631 85 17
		jsr L_E5DC		;E633 20 DC E5
		tya				;E636 98
		ora #$20		;E637 09 20
		tay				;E639 A8
		txa				;E63A 8A
		ora #$20		;E63B 09 20
		tax				;E63D AA
		jmp L_E5DC		;E63E 4C DC E5
}

.L_E641
{
		lda L_C500,Y	;E641 B9 00 C5
		sta ZP_51		;E644 85 51
		lda L_C510,Y	;E646 B9 10 C5
		sta ZP_77		;E649 85 77
		lda L_C520,Y	;E64B B9 20 C5
		sta ZP_52		;E64E 85 52
		lda L_C530,Y	;E650 B9 30 C5
		sta ZP_78		;E653 85 78
		jsr L_2458		;E655 20 58 24
		jsr L_25EA		;E658 20 EA 25
		jmp L_2809		;E65B 4C 09 28
}

.L_E65E
{
		ldx #$01		;E65E A2 01
		ldy #$00		;E660 A0 00
.L_E662	lda L_C507,Y	;E662 B9 07 C5
		sec				;E665 38
		sbc L_C505,Y	;E666 F9 05 C5
		sta ZP_56,X		;E669 95 56
		sta ZP_14		;E66B 85 14
		lda L_C517,Y	;E66D B9 17 C5
		sbc L_C515,Y	;E670 F9 15 C5
		sta ZP_43,X		;E673 95 43
		clc				;E675 18
		bpl L_E679		;E676 10 01
		sec				;E678 38
.L_E679	ror A			;E679 6A
		ror ZP_14		;E67A 66 14
		sta ZP_15		;E67C 85 15
		lda ZP_56,X		;E67E B5 56
		clc				;E680 18
		adc ZP_14		;E681 65 14
		sta ZP_56,X		;E683 95 56
		lda ZP_43,X		;E685 B5 43
		adc ZP_15		;E687 65 15
		sta ZP_43,X		;E689 95 43
		ldy #$20		;E68B A0 20
		dex				;E68D CA
		bpl L_E662		;E68E 10 D2
		ldx #$02		;E690 A2 02
.L_E692	ldy L_E6E5,X	;E692 BC E5 E6
		lda L_C505,X	;E695 BD 05 C5
		sec				;E698 38
		sbc ZP_56		;E699 E5 56
		sta L_C508,X	;E69B 9D 08 C5
		lda L_C515,X	;E69E BD 15 C5
		sbc ZP_43		;E6A1 E5 43
		sta L_C518,X	;E6A3 9D 18 C5
		lda L_C525,X	;E6A6 BD 25 C5
		clc				;E6A9 18
		adc ZP_57		;E6AA 65 57
		sta L_C528,X	;E6AC 9D 28 C5
		lda L_C535,X	;E6AF BD 35 C5
		adc ZP_44		;E6B2 65 44
		sta L_C538,X	;E6B4 9D 38 C5
		dex				;E6B7 CA
		dex				;E6B8 CA
		bpl L_E692		;E6B9 10 D7
		lda ZP_9C		;E6BB A5 9C
		clc				;E6BD 18
		adc #$80		;E6BE 69 80
		sta ZP_4D		;E6C0 85 4D
		bcc L_E6DC		;E6C2 90 18
		lda ZP_4A		;E6C4 A5 4A
		sta ZP_48		;E6C6 85 48
		lda ZP_DC		;E6C8 A5 DC
		sta ZP_5B		;E6CA 85 5B
		lda ZP_4B		;E6CC A5 4B
		sta ZP_49		;E6CE 85 49
		lda ZP_DD		;E6D0 A5 DD
		sta ZP_4A		;E6D2 85 4A
		lda ZP_DF		;E6D4 A5 DF
		sta ZP_DC		;E6D6 85 DC
		lda ZP_DE		;E6D8 A5 DE
		sta ZP_4B		;E6DA 85 4B
.L_E6DC	lda ZP_B0		;E6DC A5 B0
		sta ZP_4C		;E6DE 85 4C
		ldx #$02		;E6E0 A2 02
		jmp L_FF94		;E6E2 4C 94 FF
		
.L_E6E5	equb $00,$00,$01
}

; draw front of aicar

.draw_aicar
{
		ldx #$01		;E6E8 A2 01
		jsr set_linedraw_colour		;E6EA 20 01 FC
		lda ZP_EC		;E6ED A5 EC
		sta L_A24A		;E6EF 8D 4A A2
		sec				;E6F2 38
		sbc ZP_ED		;E6F3 E5 ED
		sta L_A24B		;E6F5 8D 4B A2
		lda ZP_EE		;E6F8 A5 EE
		sta L_A296		;E6FA 8D 96 A2
		sec				;E6FD 38
		sbc ZP_EF		;E6FE E5 EF
		sta L_A297		;E700 8D 97 A2
		lda #$00		;E703 A9 00
		sec				;E705 38
		sbc ZP_EC		;E706 E5 EC
		sta L_A249		;E708 8D 49 A2
		sec				;E70B 38
		sbc ZP_ED		;E70C E5 ED
		sta L_A248		;E70E 8D 48 A2
		lda #$00		;E711 A9 00
		sec				;E713 38
		sbc ZP_EE		;E714 E5 EE
		sta L_A295		;E716 8D 95 A2
		sec				;E719 38
		sbc ZP_EF		;E71A E5 EF
		sta L_A294		;E71C 8D 94 A2
		ldx #$08		;E71F A2 08
		jsr L_E31A		;E721 20 1A E3
		lda L_A246		;E724 AD 46 A2
		cmp L_A24A		;E727 CD 4A A2
		bcc L_E78E		;E72A 90 62
		lda L_A245		;E72C AD 45 A2
		cmp L_A249		;E72F CD 49 A2
		bcs L_E75A		;E732 B0 26
		bit L_C3DA		;E734 2C DA C3
		bmi L_E748		;E737 30 0F
		jsr L_E7D0_with_draw_line		;E739 20 D0 E7
		jsr L_E7C2_with_draw_line		;E73C 20 C2 E7
		jsr L_E7DE_with_draw_line		;E73F 20 DE E7
		jsr L_E372		;E742 20 72 E3
		jmp L_E388		;E745 4C 88 E3
.L_E748	jsr L_E7F3_with_draw_line		;E748 20 F3 E7
		jsr L_E7E5_with_draw_line		;E74B 20 E5 E7
		jsr L_E7EC_with_draw_line		;E74E 20 EC E7
		jsr L_FCB3		;E751 20 B3 FC
		jsr L_E372		;E754 20 72 E3
		jmp L_E388		;E757 4C 88 E3
.L_E75A	bit L_C3DA		;E75A 2C DA C3
		bmi L_E779		;E75D 30 1A
		jsr L_E7C2_with_draw_line		;E75F 20 C2 E7
		lda L_A296		;E762 AD 96 A2
		cmp L_A292		;E765 CD 92 A2
		bcs L_E773		;E768 B0 09
		jsr L_E801_with_draw_line		;E76A 20 01 E8
		jsr L_E7DE_with_draw_line		;E76D 20 DE E7
		jsr L_E7EC_with_draw_line		;E770 20 EC E7
.L_E773	jsr L_E372		;E773 20 72 E3
		jmp L_E388		;E776 4C 88 E3
.L_E779	jsr L_E7F3_with_draw_line		;E779 20 F3 E7
		jsr L_E7EC_with_draw_line		;E77C 20 EC E7
		jsr L_E7E5_with_draw_line		;E77F 20 E5 E7
		jsr L_FCB3		;E782 20 B3 FC
		jsr L_E388		;E785 20 88 E3
		jsr L_E372		;E788 20 72 E3
		jmp L_E7FA_with_draw_line		;E78B 4C FA E7
.L_E78E	bit L_C3DA		;E78E 2C DA C3
		bmi L_E7AD		;E791 30 1A
		jsr L_E7D0_with_draw_line		;E793 20 D0 E7
		lda L_A295		;E796 AD 95 A2
		cmp L_A291		;E799 CD 91 A2
		bcs L_E7A7		;E79C B0 09
		jsr L_E7FA_with_draw_line		;E79E 20 FA E7
		jsr L_E7DE_with_draw_line		;E7A1 20 DE E7
		jsr L_E7E5_with_draw_line		;E7A4 20 E5 E7
.L_E7A7	jsr L_E388		;E7A7 20 88 E3
		jmp L_E372		;E7AA 4C 72 E3
.L_E7AD	jsr L_E7F3_with_draw_line		;E7AD 20 F3 E7
		jsr L_E7E5_with_draw_line		;E7B0 20 E5 E7
		jsr L_E7EC_with_draw_line		;E7B3 20 EC E7
		jsr L_FCB3		;E7B6 20 B3 FC
		jsr L_E372		;E7B9 20 72 E3
		jsr L_E388		;E7BC 20 88 E3
		jmp L_E801_with_draw_line		;E7BF 4C 01 E8

.L_E7C2_with_draw_line	ldx #$44		;E7C2 A2 44
		ldy #$48		;E7C4 A0 48
		jsr draw_line		;E7C6 20 C9 FE
		ldx #$45		;E7C9 A2 45
		ldy #$49		;E7CB A0 49
		jmp draw_line		;E7CD 4C C9 FE

.L_E7D0_with_draw_line	ldx #$47		;E7D0 A2 47
		ldy #$4B		;E7D2 A0 4B
		jsr draw_line		;E7D4 20 C9 FE
		ldx #$46		;E7D7 A2 46
		ldy #$4A		;E7D9 A0 4A
		jmp draw_line		;E7DB 4C C9 FE

.L_E7DE_with_draw_line	ldx #$49		;E7DE A2 49
		ldy #$4A		;E7E0 A0 4A
		jmp draw_line		;E7E2 4C C9 FE

.L_E7E5_with_draw_line	ldx #$44		;E7E5 A2 44
		ldy #$48		;E7E7 A0 48
		jmp draw_line		;E7E9 4C C9 FE

.L_E7EC_with_draw_line	ldx #$47		;E7EC A2 47
		ldy #$4B		;E7EE A0 4B
		jmp draw_line		;E7F0 4C C9 FE

.L_E7F3_with_draw_line	ldx #$48		;E7F3 A2 48
		ldy #$4B		;E7F5 A0 4B
		jmp draw_line		;E7F7 4C C9 FE

.L_E7FA_with_draw_line	ldx #$45		;E7FA A2 45
		ldy #$49		;E7FC A0 49
		jmp draw_line		;E7FE 4C C9 FE

.L_E801_with_draw_line	ldx #$46		;E801 A2 46
		ldy #$4A		;E803 A0 4A
		jmp draw_line		;E805 4C C9 FE
}

.L_E808
{
		sta ZP_16		;E808 85 16
		ldy #$00		;E80A A0 00
		lda (ZP_9A),Y	;E80C B1 9A
		clc				;E80E 18
		adc #$07		;E80F 69 07
		sta ZP_9F		;E811 85 9F
		lda ZP_A4		;E813 A5 A4
		bne L_E82B		;E815 D0 14
		lda ZP_16		;E817 A5 16
		asl A			;E819 0A
		asl A			;E81A 0A
		asl A			;E81B 0A
		clc				;E81C 18
		adc ZP_9F		;E81D 65 9F
		tay				;E81F A8
		ldx #$00		;E820 A2 00
.L_E822	jsr L_E843		;E822 20 43 E8
		inx				;E825 E8
		cpx #$04		;E826 E0 04
		bne L_E822		;E828 D0 F8
		rts				;E82A 60
.L_E82B	lda ZP_BE		;E82B A5 BE
		sec				;E82D 38
		sbc ZP_16		;E82E E5 16
		sec				;E830 38
		sbc #$01		;E831 E9 01
		asl A			;E833 0A
		asl A			;E834 0A
		asl A			;E835 0A
		clc				;E836 18
		adc ZP_9F		;E837 65 9F
		tay				;E839 A8
		ldx #$03		;E83A A2 03
.L_E83C	jsr L_E843		;E83C 20 43 E8
		dex				;E83F CA
		bpl L_E83C		;E840 10 FA
		rts				;E842 60
.L_E843	jsr L_A026		;E843 20 26 A0
		lda ZP_51		;E846 A5 51
		sta L_C500,X	;E848 9D 00 C5
		lda ZP_77		;E84B A5 77
		sta L_C510,X	;E84D 9D 10 C5
		lda ZP_52		;E850 A5 52
		sta L_C520,X	;E852 9D 20 C5
		lda ZP_78		;E855 A5 78
		sta L_C530,X	;E857 9D 30 C5
		rts				;E85A 60
}

.L_E85B
{
		jsr L_3DF9		;E85B 20 F9 3D
		ldx #$7F		;E85E A2 7F
.L_E860	lda #$00		;E860 A9 00
		sta L_C700,X	;E862 9D 00 C7
		sta L_3DF8		;E865 8D F8 3D
		jsr rndQ		;E868 20 B9 29
		cpx #$0C		;E86B E0 0C
		bcs L_E873		;E86D B0 04
		txa				;E86F 8A
		sta L_C70C,X	;E870 9D 0C C7
.L_E873	dex				;E873 CA
		bpl L_E860		;E874 10 EA
		jsr L_1611		;E876 20 11 16
		lda #$0A		;E879 A9 0A
		sta L_C719		;E87B 8D 19 C7
		rts				;E87E 60
}

.L_E87F
{
		ldx #$0B		;E87F A2 0B
.L_E881	jsr rndQ		;E881 20 B9 29
		and #$3F		;E884 29 3F
		clc				;E886 18
		adc L_E8B6,X	;E887 7D B6 E8
		sta L_C71C,X	;E88A 9D 1C C7
		dex				;E88D CA
		bpl L_E881		;E88E 10 F1
		ldx L_C77F		;E890 AE 7F C7
		lda #$00		;E893 A9 00
.L_E895	sta L_C360		;E895 8D 60 C3
		ldx L_31A1		;E898 AE A1 31
		beq L_E8A2		;E89B F0 05
		cmp L_C718		;E89D CD 18 C7
		bne L_E8AB		;E8A0 D0 09
.L_E8A2	jsr L_E8E5		;E8A2 20 E5 E8
		jsr L_E92C		;E8A5 20 2C E9
		jsr L_E9A3		;E8A8 20 A3 E9
.L_E8AB	lda L_C360		;E8AB AD 60 C3
		clc				;E8AE 18
		adc #$01		;E8AF 69 01
		cmp #$04		;E8B1 C9 04
		bcc L_E895		;E8B3 90 E0
		rts				;E8B5 60
}

.L_E8B6	equb $78,$6E,$64,$5A,$50,$46,$3C,$32,$28,$1E,$14,$0A

.L_E8C2
{
		lda L_31A1		;E8C2 AD A1 31
		beq L_E8D3		;E8C5 F0 0C
		eor #$FF		;E8C7 49 FF
		clc				;E8C9 18
		adc #$0C		;E8CA 69 0C
		sta ZP_50		;E8CC 85 50
		lda #$0C		;E8CE A9 0C
		sta ZP_8A		;E8D0 85 8A
		rts				;E8D2 60
.L_E8D3	ldx L_C360		;E8D3 AE 60 C3
		lda L_E8E1,X	;E8D6 BD E1 E8
		sta ZP_50		;E8D9 85 50
		clc				;E8DB 18
		adc #$03		;E8DC 69 03
		sta ZP_8A		;E8DE 85 8A
		rts				;E8E0 60
}

.L_E8E1	equb $09,$06,$03,$00

.L_E8E5
{
		jsr L_E8C2		;E8E5 20 C2 E8
		lda L_31A1		;E8E8 AD A1 31
		beq L_E8FD		;E8EB F0 10
		lda #$0B		;E8ED A9 0B
		sec				;E8EF 38
		sbc L_C77F		;E8F0 ED 7F C7
		sta L_C771		;E8F3 8D 71 C7
		tay				;E8F6 A8
		lda L_31A2		;E8F7 AD A2 31
		jmp L_E919		;E8FA 4C 19 E9
.L_E8FD	ldx L_C77F		;E8FD AE 7F C7
		lda L_E920,X	;E900 BD 20 E9
;L_E902	= *-1			;!
		clc				;E903 18
		adc ZP_50		;E904 65 50
		tay				;E906 A8
		lda L_C70C,Y	;E907 B9 0C C7
		sta L_C771		;E90A 8D 71 C7
		lda L_E926,X	;E90D BD 26 E9
		clc				;E910 18
		adc ZP_50		;E911 65 50
		tay				;E913 A8
		lda L_C70C,Y	;E914 B9 0C C7
		ldy #$0B		;E917 A0 0B
.L_E919	sta L_C772		;E919 8D 72 C7
		sty L_31A4		;E91C 8C A4 31
		rts				;E91F 60

.L_E920	equb $00,$00,$00,$00,$01,$01
.L_E926	equb $01,$01,$02,$02,$02,$02
}

.L_E92C
{
		ldx #$00		;E92C A2 00
		jsr rndQ		;E92E 20 B9 29
		cmp #$A0		;E931 C9 A0
		bcc L_E937		;E933 90 02
		ldx #$40		;E935 A2 40
.L_E937	stx ZP_51		;E937 86 51
		ldy L_C771		;E939 AC 71 C7
		ldx L_C772		;E93C AE 72 C7
		inc L_C740,X	;E93F FE 40 C7
		lda L_C740,Y	;E942 B9 40 C7
		clc				;E945 18
		adc #$01		;E946 69 01
		sta L_C740,Y	;E948 99 40 C7
		lda L_C362		;E94B AD 62 C3
		cpx L_31A4		;E94E EC A4 31
		beq L_E95A		;E951 F0 07
		cpy L_31A4		;E953 CC A4 31
		bne L_E95F		;E956 D0 07
		eor #$C0		;E958 49 C0
.L_E95A	sta ZP_51		;E95A 85 51
		jmp L_E975		;E95C 4C 75 E9
.L_E95F	lda L_C71C,Y	;E95F B9 1C C7
		cmp L_C71C,X	;E962 DD 1C C7
		bcc L_E975		;E965 90 0E
		bne L_E96F		;E967 D0 06
		jsr rndQ		;E969 20 B9 29
		lsr A			;E96C 4A
		bcs L_E975		;E96D B0 06
.L_E96F	lda ZP_51		;E96F A5 51
		eor #$C0		;E971 49 C0
		sta ZP_51		;E973 85 51
.L_E975	bit ZP_51		;E975 24 51
		bmi L_E982		;E977 30 09
		stx ZP_16		;E979 86 16
		bvs L_E986		;E97B 70 09
.L_E97D	stx ZP_17		;E97D 86 17
		jmp L_E988		;E97F 4C 88 E9
.L_E982	sty ZP_16		;E982 84 16
		bvc L_E97D		;E984 50 F7
.L_E986	sty ZP_17		;E986 84 17
.L_E988	ldx ZP_16		;E988 A6 16
		inc L_C728,X	;E98A FE 28 C7
		ldx ZP_17		;E98D A6 17
		inc L_C734,X	;E98F FE 34 C7
		lda L_C360		;E992 AD 60 C3
		cmp L_C718		;E995 CD 18 C7
		bne L_E9A2		;E998 D0 08
		stx L_C770		;E99A 8E 70 C7
		lda ZP_16		;E99D A5 16
		sta L_C76F		;E99F 8D 6F C7
.L_E9A2	rts				;E9A2 60
}

.L_E9A3
{
		jsr L_E8C2		;E9A3 20 C2 E8
		ldy ZP_50		;E9A6 A4 50
.L_E9A8	ldx L_C70C,Y	;E9A8 BE 0C C7
		txa				;E9AB 8A
		sta L_C758,Y	;E9AC 99 58 C7
		lda L_C728,X	;E9AF BD 28 C7
		asl A			;E9B2 0A
		clc				;E9B3 18
		adc L_C734,X	;E9B4 7D 34 C7
		sta L_C74C,X	;E9B7 9D 4C C7
		iny				;E9BA C8
		cpy ZP_8A		;E9BB C4 8A
		bcc L_E9A8		;E9BD 90 E9
.L_E9BF	lda #$00		;E9BF A9 00
		sta ZP_16		;E9C1 85 16
		ldy ZP_50		;E9C3 A4 50
.L_E9C5	sty ZP_17		;E9C5 84 17
		ldx L_C758,Y	;E9C7 BE 58 C7
		lda L_C759,Y	;E9CA B9 59 C7
		tay				;E9CD A8
		lda L_C74C,X	;E9CE BD 4C C7
		cmp L_C74C,Y	;E9D1 D9 4C C7
		bcc L_E9F5		;E9D4 90 1F
		bne L_EA04		;E9D6 D0 2C
		lda L_C728,X	;E9D8 BD 28 C7
		cmp L_C728,Y	;E9DB D9 28 C7
		bcc L_E9F5		;E9DE 90 15
		bne L_EA04		;E9E0 D0 22
		lda L_31A1		;E9E2 AD A1 31
		beq L_E9EF		;E9E5 F0 08
		sty ZP_14		;E9E7 84 14
		cpx ZP_14		;E9E9 E4 14
		bcc L_E9F5		;E9EB 90 08
		bcs L_EA04		;E9ED B0 15
.L_E9EF	jsr rndQ		;E9EF 20 B9 29
		lsr A			;E9F2 4A
		bcc L_EA04		;E9F3 90 0F
.L_E9F5	sty ZP_15		;E9F5 84 15
		ldy ZP_17		;E9F7 A4 17
		txa				;E9F9 8A
		sta L_C759,Y	;E9FA 99 59 C7
		lda ZP_15		;E9FD A5 15
		sta L_C758,Y	;E9FF 99 58 C7
		inc ZP_16		;EA02 E6 16
.L_EA04	ldy ZP_17		;EA04 A4 17
		iny				;EA06 C8
		iny				;EA07 C8
		cpy ZP_8A		;EA08 C4 8A
		dey				;EA0A 88
		bcc L_E9C5		;EA0B 90 B8
		lda ZP_16		;EA0D A5 16
		bne L_E9BF		;EA0F D0 AE
		rts				;EA11 60
}

.get_next_ptr_byte
{
		lda (ZP_1E),Y	;EA12 B1 1E
		iny				;EA14 C8
		bne L_EA19		;EA15 D0 02
		inc ZP_1F		;EA17 E6 1F
.L_EA19	and #$FF		;EA19 29 FF
		rts				;EA1B 60
}

.adjust_accumulator
{
		bit ZP_15		;EA1C 24 15
		bmi L_EA2A		;EA1E 30 0A
		bvs L_EA26		;EA20 70 04
		clc				;EA22 18
		adc #$10		;EA23 69 10
		rts				;EA25 60
.L_EA26	clc				;EA26 18
		adc #$01		;EA27 69 01
		rts				;EA29 60
.L_EA2A	bvs L_EA30		;EA2A 70 04
		sec				;EA2C 38
		sbc #$10		;EA2D E9 10
		rts				;EA2F 60
.L_EA30	sec				;EA30 38
		sbc #$01		;EA31 E9 01
		rts				;EA33 60
}

.prepare_trackQ
{
		txa				;EA34 8A
		asl A			;EA35 0A
		tay				;EA36 A8
		lda L_B220,Y	;EA37 B9 20 B2
		sta ZP_1E		;EA3A 85 1E
		lda L_B221,Y	;EA3C B9 21 B2
		sta ZP_1F		;EA3F 85 1F
		ldy #$00		;EA41 A0 00
.L_EA43	jsr get_next_ptr_byte		;EA43 20 12 EA
		sta L_C763,Y	;EA46 99 63 C7
		cpy #$04		;EA49 C0 04
		bne L_EA43		;EA4B D0 F6
		jsr get_next_ptr_byte		;EA4D 20 12 EA
		sta ZP_51		;EA50 85 51
		sta ZP_52		;EA52 85 52
		jsr get_next_ptr_byte		;EA54 20 12 EA
		sta ZP_77		;EA57 85 77
		sta ZP_78		;EA59 85 78
		ldx #$00		;EA5B A2 00
		stx ZP_D8		;EA5D 86 D8
		stx ZP_7D		;EA5F 86 7D
		stx ZP_7F		;EA61 86 7F
		stx ZP_08		;EA63 86 08
.L_EA65	lda ZP_08		;EA65 A5 08
		beq L_EA84		;EA67 F0 1B
		dec ZP_08		;EA69 C6 08
		lda ZP_4F		;EA6B A5 4F
		sta ZP_15		;EA6D 85 15
		sta L_0400,X	;EA6F 9D 00 04
		and #$10		;EA72 29 10
		beq L_EA7C		;EA74 F0 06
		lda ZP_15		;EA76 A5 15
		eor #$C0		;EA78 49 C0
		sta ZP_15		;EA7A 85 15
.L_EA7C	lda ZP_30		;EA7C A5 30
		jsr adjust_accumulator		;EA7E 20 1C EA
		jmp L_EAA4		;EA81 4C A4 EA
.L_EA84	jsr get_next_ptr_byte		;EA84 20 12 EA
		sta ZP_15		;EA87 85 15
		sta L_0400,X	;EA89 9D 00 04
		and #$0F		;EA8C 29 0F
		cmp #$0F		;EA8E C9 0F
		bne L_EA9C		;EA90 D0 0A
		lda ZP_15		;EA92 A5 15
		lsr A			;EA94 4A
		lsr A			;EA95 4A
		lsr A			;EA96 4A
		lsr A			;EA97 4A
		sta ZP_08		;EA98 85 08
		bpl L_EA65		;EA9A 10 C9
.L_EA9C	lda L_0400,X	;EA9C BD 00 04
		sta ZP_4F		;EA9F 85 4F
		jsr get_next_ptr_byte		;EAA1 20 12 EA
.L_EAA4	sta L_044E,X	;EAA4 9D 4E 04
		sta ZP_30		;EAA7 85 30
		lda ZP_D8		;EAA9 A5 D8
		lsr A			;EAAB 4A
		lsr A			;EAAC 4A
		ror A			;EAAD 6A
		sta ZP_14		;EAAE 85 14
		lda ZP_15		;EAB0 A5 15
		and #$0F		;EAB2 29 0F
		cmp #$0C		;EAB4 C9 0C
		bcc L_EAD1		;EAB6 90 19
		sty ZP_16		;EAB8 84 16
		tay				;EABA A8
		lda L_0400,X	;EABB BD 00 04
		and #$F0		;EABE 29 F0
		sta L_0400,X	;EAC0 9D 00 04
		lda L_EBDB,Y	;EAC3 B9 DB EB
		sta L_049C,X	;EAC6 9D 9C 04
		lda L_EBDD,Y	;EAC9 B9 DD EB
		ldy ZP_16		;EACC A4 16
		jmp L_EAE6		;EACE 4C E6 EA
.L_EAD1	jsr get_next_ptr_byte		;EAD1 20 12 EA
		sta L_049C,X	;EAD4 9D 9C 04
		lda ZP_15		;EAD7 A5 15
		and #$20		;EAD9 29 20
		beq L_EAE3		;EADB F0 06
		lda L_049C,X	;EADD BD 9C 04
		jmp L_EAE6		;EAE0 4C E6 EA
.L_EAE3	jsr get_next_ptr_byte		;EAE3 20 12 EA
.L_EAE6	and #$7F		;EAE6 29 7F
		ora ZP_14		;EAE8 05 14
		sta L_04EA,X	;EAEA 9D EA 04
		tya				;EAED 98
		pha				;EAEE 48
		lda ZP_7D		;EAEF A5 7D
		sta ZP_14		;EAF1 85 14
		lda ZP_7F		;EAF3 A5 7F
		ldy #$FB		;EAF5 A0 FB
		jsr shift_16bit		;EAF7 20 BF C9
		sta L_06BE,X	;EAFA 9D BE 06
		lda ZP_14		;EAFD A5 14
		sta L_0670,X	;EAFF 9D 70 06
		jsr get_track_segment_detailsQ		;EB02 20 2F F0
		lda ZP_D8		;EB05 A5 D8
		clc				;EB07 18
		adc ZP_62		;EB08 65 62
		and #$02		;EB0A 29 02
		sta ZP_D8		;EB0C 85 D8
		lda ZP_7D		;EB0E A5 7D
		clc				;EB10 18
		adc ZP_BE		;EB11 65 BE
		sta ZP_7D		;EB13 85 7D
		lda ZP_7F		;EB15 A5 7F
		adc #$00		;EB17 69 00
		sta ZP_7F		;EB19 85 7F
		ldy #$00		;EB1B A0 00
		jsr L_EBF3		;EB1D 20 F3 EB
		sta ZP_15		;EB20 85 15
		lda ZP_51		;EB22 A5 51
		sec				;EB24 38
		sbc ZP_14		;EB25 E5 14
		sta L_0538,X	;EB27 9D 38 05
		lda ZP_77		;EB2A A5 77
		sbc ZP_15		;EB2C E5 15
		sta L_0586,X	;EB2E 9D 86 05
		ldy ZP_BE		;EB31 A4 BE
		jsr L_EBF3		;EB33 20 F3 EB
		sta ZP_15		;EB36 85 15
		lda L_0538,X	;EB38 BD 38 05
		clc				;EB3B 18
		adc ZP_14		;EB3C 65 14
		sta ZP_51		;EB3E 85 51
		lda L_0586,X	;EB40 BD 86 05
		adc ZP_15		;EB43 65 15
		sta ZP_77		;EB45 85 77
		ldy #$00		;EB47 A0 00
		jsr L_EBEB		;EB49 20 EB EB
		sta ZP_15		;EB4C 85 15
		lda ZP_52		;EB4E A5 52
		sec				;EB50 38
		sbc ZP_14		;EB51 E5 14
		sta L_05D4,X	;EB53 9D D4 05
		lda ZP_78		;EB56 A5 78
		sbc ZP_15		;EB58 E5 15
		sta L_0622,X	;EB5A 9D 22 06
		ldy ZP_BE		;EB5D A4 BE
		jsr L_EBEB		;EB5F 20 EB EB
		sta ZP_15		;EB62 85 15
		lda L_05D4,X	;EB64 BD D4 05
		clc				;EB67 18
		adc ZP_14		;EB68 65 14
		sta ZP_52		;EB6A 85 52
		lda L_0622,X	;EB6C BD 22 06
		adc ZP_15		;EB6F 65 15
		sta ZP_78		;EB71 85 78
		pla				;EB73 68
		tay				;EB74 A8
		inx				;EB75 E8
		cpx L_C764		;EB76 EC 64 C7
		beq L_EB7E		;EB79 F0 03
		jmp L_EA65		;EB7B 4C 65 EA
.L_EB7E	ldx L_C766		;EB7E AE 66 C7
		inx				;EB81 E8
		cpx L_C764		;EB82 EC 64 C7
		bcc L_EB89		;EB85 90 02
		ldx #$00		;EB87 A2 00
.L_EB89	stx L_C77C		;EB89 8E 7C C7
		sty ZP_17		;EB8C 84 17
		lda ZP_7D		;EB8E A5 7D
		sta ZP_14		;EB90 85 14
		lda ZP_7F		;EB92 A5 7F
		ldy #$FB		;EB94 A0 FB
		jsr shift_16bit		;EB96 20 BF C9
		sta L_C769		;EB99 8D 69 C7
		lda ZP_14		;EB9C A5 14
		sta L_C768		;EB9E 8D 68 C7
		ldy ZP_17		;EBA1 A4 17
		ldx #$00		;EBA3 A2 00
.L_EBA5	jsr get_next_ptr_byte		;EBA5 20 12 EA
		sta L_C774,X	;EBA8 9D 74 C7
		inx				;EBAB E8
		cpx #$06		;EBAC E0 06
		bne L_EBA5		;EBAE D0 F5
		lda L_C778		;EBB0 AD 78 C7
		beq L_EBC9		;EBB3 F0 14
		ldx #$00		;EBB5 A2 00
.L_EBB7	jsr get_next_ptr_byte		;EBB7 20 12 EA
		sta L_075E,X	;EBBA 9D 5E 07
		jsr get_next_ptr_byte		;EBBD 20 12 EA
		sta L_0769,X	;EBC0 9D 69 07
		inx				;EBC3 E8
		cpx L_C778		;EBC4 EC 78 C7
		bne L_EBB7		;EBC7 D0 EE
.L_EBC9	lda L_C779		;EBC9 AD 79 C7
		beq L_EBDC		;EBCC F0 0E
		ldx #$00		;EBCE A2 00
.L_EBD0	jsr get_next_ptr_byte		;EBD0 20 12 EA
		sta L_0190,X	;EBD3 9D 90 01
		inx				;EBD6 E8
		cpx L_C779		;EBD7 EC 79 C7
		bne L_EBD0		;EBDA D0 F4
.L_EBDC	jsr L_1F06		;EBDC 20 06 1F
		ldx L_209A		;EBDF AE 9A 20
		lda #$44		;EBE2 A9 44
		jmp sysctl		;EBE4 4C 25 87

.L_EBE7	equb $03,$04,$04,$03
L_EBDB	= L_EBE7 - $C			;!
L_EBDD	= L_EBE7 - $A			;!
}

.L_EBEB
{
		lda ZP_CA		;EBEB A5 CA
		sta ZP_98		;EBED 85 98
		lda ZP_CB		;EBEF A5 CB
		sta ZP_99		;EBF1 85 99
}
\\
.L_EBF3
{
		lda ZP_A2		;EBF3 A5 A2
		bpl L_EC05		;EBF5 10 0E
		tya				;EBF7 98
		asl A			;EBF8 0A
		tay				;EBF9 A8
		iny				;EBFA C8
		lda (ZP_98),Y	;EBFB B1 98
		sta ZP_14		;EBFD 85 14
		dey				;EBFF 88
		lda (ZP_98),Y	;EC00 B1 98
		and #$7F		;EC02 29 7F
		rts				;EC04 60
.L_EC05	lda (ZP_98),Y	;EC05 B1 98
		asl A			;EC07 0A
		and #$E0		;EC08 29 E0
		sta ZP_14		;EC0A 85 14
		lda (ZP_98),Y	;EC0C B1 98
		and #$0F		;EC0E 29 0F
		rts				;EC10 60
}

.L_EC11
{
		ldx ZP_2F		;EC11 A6 2F
		beq L_EC3C		;EC13 F0 27
		cpx #$E6		;EC15 E0 E6
		bcc L_EC2C		;EC17 90 13
		lda #$2C		;EC19 A9 2C
		bit L_C36F		;EC1B 2C 6F C3
		bpl L_EC22		;EC1E 10 02
		lda #$D4		;EC20 A9 D4
.L_EC22	sta L_C3DF		;EC22 8D DF C3
		lda #$00		;EC25 A9 00
		sta ZP_34		;EC27 85 34
.L_EC29	dec ZP_2F		;EC29 C6 2F
		rts				;EC2B 60
.L_EC2C	cpx #$E5		;EC2C E0 E5
		bne L_EC3D		;EC2E D0 0D
		lda #$00		;EC30 A9 00
		jsr L_ECDB		;EC32 20 DB EC
		lda #$03		;EC35 A9 03
		jsr L_EC9A		;EC37 20 9A EC
		bpl L_EC29		;EC3A 10 ED
.L_EC3C	rts				;EC3C 60
.L_EC3D	cpx #$E4		;EC3D E0 E4
		bne L_EC6C		;EC3F D0 2B
		lda #$04		;EC41 A9 04
		jsr L_EC9A		;EC43 20 9A EC
		lda #$FF		;EC46 A9 FF
		jsr L_ECDB		;EC48 20 DB EC
		bne L_EC3C		;EC4B D0 EF
		jsr rndQ		;EC4D 20 B9 29
		and #$1F		;EC50 29 1F
		clc				;EC52 18
		adc #$A0		;EC53 69 A0
		ldy #$2C		;EC55 A0 2C
		bit L_C37C		;EC57 2C 7C C3
		bpl L_EC5E		;EC5A 10 02
		ldy #$3C		;EC5C A0 3C
.L_EC5E	bit L_C76C		;EC5E 2C 6C C7
		bmi L_EC65		;EC61 30 02
		lda #$8C		;EC63 A9 8C
.L_EC65	sta ZP_2F		;EC65 85 2F
		lda #$04		;EC67 A9 04
		jmp set_up_text_sprite		;EC69 4C A9 12
.L_EC6C	lda #$00		;EC6C A9 00
		jsr L_ECDB		;EC6E 20 DB EC
		lda #$02		;EC71 A9 02
		jsr L_EC9A		;EC73 20 9A EC
		dec ZP_2F		;EC76 C6 2F
		bne L_EC7C		;EC78 D0 02
		inc ZP_2F		;EC7A E6 2F
.L_EC7C	lda L_C37C		;EC7C AD 7C C3
		bne L_EC86		;EC7F D0 05
		bit ZP_2F		;EC81 24 2F
		bpl L_EC8B		;EC83 10 06
		rts				;EC85 60
.L_EC86	lda L_C398		;EC86 AD 98 C3
		bne L_EC99		;EC89 D0 0E
.L_EC8B	lda #$00		;EC8B A9 00
		sta ZP_2F		;EC8D 85 2F
		sta ZP_6B		;EC8F 85 6B
		sta L_C355		;EC91 8D 55 C3
		lda #$80		;EC94 A9 80
		sta L_C37C		;EC96 8D 7C C3
.L_EC99	rts				;EC99 60
}

.L_EC9A
{
		sta ZP_16		;EC9A 85 16
		lda ZP_46		;EC9C A5 46
		sec				;EC9E 38
		sbc L_C35D		;EC9F ED 5D C3
		sta ZP_14		;ECA2 85 14
		lda ZP_64		;ECA4 A5 64
		sbc L_C35E		;ECA6 ED 5E C3
		sec				;ECA9 38
		sbc ZP_16		;ECAA E5 16
		sta ZP_16		;ECAC 85 16
		ldy #$03		;ECAE A0 03
		jsr shift_16bit		;ECB0 20 BF C9
		sec				;ECB3 38
		sbc #$01		;ECB4 E9 01
		bpl L_ECC2		;ECB6 10 0A
		cmp #$FE		;ECB8 C9 FE
		bcs L_ECC2		;ECBA B0 06
		lda #$00		;ECBC A9 00
		sta ZP_14		;ECBE 85 14
		lda #$FE		;ECC0 A9 FE
.L_ECC2	sta ZP_15		;ECC2 85 15
		lda L_0171		;ECC4 AD 71 01
		sec				;ECC7 38
		sbc ZP_14		;ECC8 E5 14
		sta L_0171		;ECCA 8D 71 01
		lda L_0174		;ECCD AD 74 01
		sbc ZP_15		;ECD0 E5 15
		sta L_0174		;ECD2 8D 74 01
		lda ZP_16		;ECD5 A5 16
		clc				;ECD7 18
		adc #$02		;ECD8 69 02
		rts				;ECDA 60
}

.L_ECDB
{
		ldy #$10		;ECDB A0 10
		bit L_C36F		;ECDD 2C 6F C3
		bpl L_ECE9		;ECE0 10 07
		eor #$FF		;ECE2 49 FF
		clc				;ECE4 18
		adc #$01		;ECE5 69 01
		ldy #$F0		;ECE7 A0 F0
.L_ECE9	sty ZP_4E		;ECE9 84 4E
		ldy #$00		;ECEB A0 00
		sty ZP_14		;ECED 84 14
		jsr L_FF8E		;ECEF 20 8E FF
		sta ZP_1A		;ECF2 85 1A
		lda ZP_15		;ECF4 A5 15
		sta ZP_18		;ECF6 85 18
		lda ZP_B5		;ECF8 A5 B5
		sta ZP_14		;ECFA 85 14
		lda ZP_B6		;ECFC A5 B6
		ldy #$FB		;ECFE A0 FB
		jsr shift_16bit		;ED00 20 BF C9
		sta ZP_15		;ED03 85 15
		lda L_C3DF		;ED05 AD DF C3
		cmp ZP_4E		;ED08 C5 4E
		beq L_ED1B		;ED0A F0 0F
		lda ZP_34		;ED0C A5 34
		clc				;ED0E 18
		adc ZP_1A		;ED0F 65 1A
		sta ZP_34		;ED11 85 34
		lda L_C3DF		;ED13 AD DF C3
		adc ZP_18		;ED16 65 18
		sta L_C3DF		;ED18 8D DF C3
.L_ED1B	lda ZP_34		;ED1B A5 34
		sec				;ED1D 38
		sbc ZP_14		;ED1E E5 14
		sta L_0123		;ED20 8D 23 01
		lda L_C3DF		;ED23 AD DF C3
		sbc ZP_15		;ED26 E5 15
		sta L_0126		;ED28 8D 26 01
		lda #$00		;ED2B A9 00
		sta L_014E		;ED2D 8D 4E 01
		sta L_014F		;ED30 8D 4F 01
		lda L_C3DF		;ED33 AD DF C3
		cmp ZP_4E		;ED36 C5 4E
		rts				;ED38 60
}

.L_ED39
{
		ldx #$02		;ED39 A2 02
		ldy #$02		;ED3B A0 02
.L_ED3D	lda L_0774,Y	;ED3D B9 74 07
		sta ZP_14		;ED40 85 14
		lda L_079C,Y	;ED42 B9 9C 07
		cpx #$02		;ED45 E0 02
		bne L_ED4C		;ED47 D0 03
		jsr negate_16bit		;ED49 20 BF C8
.L_ED4C	ldy L_C36F		;ED4C AC 6F C3
		sty ZP_5A		;ED4F 84 5A
		ldy #$A0		;ED51 A0 A0
		sty ZP_15		;ED53 84 15
		jsr mul_8_16_16bit_2		;ED55 20 47 C8
		ldy #$FD		;ED58 A0 FD
		jsr shift_16bit		;ED5A 20 BF C9
		sta ZP_15		;ED5D 85 15
		lda L_0100,X	;ED5F BD 00 01
		clc				;ED62 18
		adc ZP_14		;ED63 65 14
		sta L_0100,X	;ED65 9D 00 01
		lda L_0103,X	;ED68 BD 03 01
		adc ZP_15		;ED6B 65 15
		sta L_0103,X	;ED6D 9D 03 01
		lda L_0106,X	;ED70 BD 06 01
		adc ZP_2D		;ED73 65 2D
		sta L_0106,X	;ED75 9D 06 01
		ldy #$03		;ED78 A0 03
		dex				;ED7A CA
		dex				;ED7B CA
		bpl L_ED3D		;ED7C 10 BF
		rts				;ED7E 60
}

.get_entered_name
{
		jsr clear_menu_area		;ED7F 20 23 1C
		jsr menu_colour_map_stuff		;ED82 20 C4 38
		ldx #$E0		;ED85 A2 E0
		jsr print_msg_4		;ED87 20 27 30
		lda #$01		;ED8A A9 01
		sta ZP_19		;ED8C 85 19
		jsr L_3858		;ED8E 20 58 38
		ldx #$0E		;ED91 A2 0E
		ldy #$10		;ED93 A0 10
		jsr set_text_cursor		;ED95 20 6B 10
		lda #$3E		;ED98 A9 3E
		jsr write_char		;ED9A 20 6F 84
		ldx #$64		;ED9D A2 64
		ldy #$BD		;ED9F A0 BD
		lda #$0B		;EDA1 A9 0B
		sec				;EDA3 38
		sbc L_31A1		;EDA4 ED A1 31
		asl A			;EDA7 0A
		asl A			;EDA8 0A
		asl A			;EDA9 0A
		asl A			;EDAA 0A
}
\\
.L_EDAB
{
		sta ZP_0B		;EDAB 85 0B
		lda #$0B		;EDAD A9 0B
		jsr L_3A4F		;EDAF 20 4F 3A
		lsr L_EE35		;EDB2 4E 35 EE
.L_EDB5	ldx #$00		;EDB5 A2 00
.L_EDB7	ldy #$02		;EDB7 A0 02
		jsr delay_approx_Y_25ths_sec		;EDB9 20 EB 3F
		txa				;EDBC 8A
		clc				;EDBD 18
		adc ZP_0B		;EDBE 65 0B
		tay				;EDC0 A8
		jsr getch		;EDC1 20 03 86
		cmp #$01		;EDC4 C9 01
		bne L_EDD6		;EDC6 D0 0E
		lda ZP_0B		;EDC8 A5 0B
		cmp #$C0		;EDCA C9 C0
		bne L_EDB7		;EDCC D0 E9
		lda #$80		;EDCE A9 80
		sta L_EE35		;EDD0 8D 35 EE
		jmp L_EE32		;EDD3 4C 32 EE
.L_EDD6	cmp #$0D		;EDD6 C9 0D
		beq L_EE2E		;EDD8 F0 54
		cmp #$20		;EDDA C9 20
		bne L_EDE4		;EDDC D0 06
		cpx #$00		;EDDE E0 00
		beq L_EDB7		;EDE0 F0 D5
		bne L_EE09		;EDE2 D0 25
.L_EDE4	cmp #$2E		;EDE4 C9 2E
		bcc L_EDB7		;EDE6 90 CF
		cmp #$3B		;EDE8 C9 3B
		bcc L_EE09		;EDEA 90 1D
		cmp #$41		;EDEC C9 41
		bcc L_EDB7		;EDEE 90 C7
		cmp #$5B		;EDF0 C9 5B
		bcc L_EE09		;EDF2 90 15
		cmp #$61		;EDF4 C9 61
		bcc L_EDB7		;EDF6 90 BF
		cmp #$7B		;EDF8 C9 7B
		bcc L_EE09		;EDFA 90 0D
		cmp #$7F		;EDFC C9 7F
		bne L_EDB7		;EDFE D0 B7
		dex				;EE00 CA
		bmi L_EDB5		;EE01 30 B2
		jsr write_char		;EE03 20 6F 84
		jmp L_EDB7		;EE06 4C B7 ED
.L_EE09	cmp #$60		;EE09 C9 60
		bcc L_EE15		;EE0B 90 08
		bit ZP_0B		;EE0D 24 0B
		bpl L_EE15		;EE0F 10 04
		bvc L_EE15		;EE11 50 02
		sbc #$20		;EE13 E9 20
.L_EE15	cpx #$0C		;EE15 E0 0C
		bcs L_EDB7		;EE17 B0 9E
		jsr write_char		;EE19 20 6F 84
		sta L_AE01,Y	;EE1C 99 01 AE
		inx				;EE1F E8
		jmp L_EDB7		;EE20 4C B7 ED
.L_EE23	txa				;EE23 8A
		clc				;EE24 18
		adc ZP_0B		;EE25 65 0B
		tay				;EE27 A8
		lda #$20		;EE28 A9 20
		sta L_AE01,Y	;EE2A 99 01 AE
		inx				;EE2D E8
.L_EE2E	cpx #$0C		;EE2E E0 0C
		bne L_EE23		;EE30 D0 F1
.L_EE32	jmp L_361F		;EE32 4C 1F 36
}

.L_EE35	equb $00

.do_menu_screen
{
		dey				;EE36 88
		sty ZP_31		;EE37 84 31
		stx ZP_30		;EE39 86 30
		sta ZP_0C		;EE3B 85 0C
		jsr set_up_screen_for_menu		;EE3D 20 1F 35
		ldx #$00		;EE40 A2 00
		stx ZP_0F		;EE42 86 0F
		jsr print_msg_2		;EE44 20 CB A1
.L_EE47	lda #$00		;EE47 A9 00
		sta ZP_19		;EE49 85 19
.L_EE4B	ldy ZP_19		;EE4B A4 19
		sty ZP_17		;EE4D 84 17
		cpy ZP_0C		;EE4F C4 0C
		bne L_EE5E		;EE51 D0 0B
		lda #$0A		;EE53 A9 0A
		ldy ZP_0F		;EE55 A4 0F
		bne L_EE5B		;EE57 D0 02
		lda #$07		;EE59 A9 07
.L_EE5B	sta L_3953		;EE5B 8D 53 39
.L_EE5E	jsr L_3858		;EE5E 20 58 38
		lda #$0F		;EE61 A9 0F
		sta L_3953		;EE63 8D 53 39
		lda ZP_17		;EE66 A5 17
		clc				;EE68 18
		adc #$01		;EE69 69 01
		jsr print_single_digit		;EE6B 20 8A 10
		lda #$2E		;EE6E A9 2E
		jsr write_char		;EE70 20 6F 84
		jsr print_space		;EE73 20 AF 91
		lda ZP_17		;EE76 A5 17
		clc				;EE78 18
		adc ZP_30		;EE79 65 30
		tay				;EE7B A8
		ldx L_F001,Y	;EE7C BE 01 F0
		jsr print_msg_2		;EE7F 20 CB A1
		lda ZP_30		;EE82 A5 30
		cmp #$18		;EE84 C9 18
		bne L_EE90		;EE86 D0 08
		lda ZP_17		;EE88 A5 17
		clc				;EE8A 18
		adc #$01		;EE8B 69 01
		jsr print_single_digit		;EE8D 20 8A 10
.L_EE90	lda ZP_31		;EE90 A5 31
		cmp ZP_17		;EE92 C5 17
		bcc L_EEB2		;EE94 90 1C
		lda ZP_30		;EE96 A5 30
		cmp #$1C		;EE98 C9 1C
		bne L_EE4B		;EE9A D0 AF
		ldx #$23		;EE9C A2 23
		jsr print_msg_4		;EE9E 20 27 30
		lda L_31A7		;EEA1 AD A7 31
		asl A			;EEA4 0A
		clc				;EEA5 18
		adc ZP_17		;EEA6 65 17
		tay				;EEA8 A8
		ldx track_order,Y	;EEA9 BE 28 37
		jsr print_track_name		;EEAC 20 92 38
		jmp L_EE4B		;EEAF 4C 4B EE
.L_EEB2	lda ZP_0F		;EEB2 A5 0F
		beq L_EEC1		;EEB4 F0 0B
		jsr L_361F		;EEB6 20 1F 36
		ldy #$07		;EEB9 A0 07
		jsr delay_approx_Y_25ths_sec		;EEBB 20 EB 3F
		lda ZP_0C		;EEBE A5 0C
		rts				;EEC0 60
.L_EEC1	jsr check_game_keys		;EEC1 20 9E F7
		bne L_EEC1		;EEC4 D0 FB
		ldy #$02		;EEC6 A0 02
		jsr delay_approx_Y_25ths_sec		;EEC8 20 EB 3F
.L_EECB	jsr check_game_keys		;EECB 20 9E F7
		and #$10		;EECE 29 10
		sta ZP_0F		;EED0 85 0F
		bne L_EF03		;EED2 D0 2F
		ldy ZP_31		;EED4 A4 31
		iny				;EED6 C8
.L_EED7	ldx L_F80C,Y	;EED7 BE 0C F8
		jsr poll_key_with_sysctl		;EEDA 20 C9 C7
		bne L_EEE4		;EEDD D0 05
		sty ZP_0C		;EEDF 84 0C
		jmp L_EE47		;EEE1 4C 47 EE
.L_EEE4	dey				;EEE4 88
		bpl L_EED7		;EEE5 10 F0
		ldx ZP_0C		;EEE7 A6 0C
		lda ZP_66		;EEE9 A5 66
		and #$03		;EEEB 29 03
		beq L_EECB		;EEED F0 DC
		and #$01		;EEEF 29 01
		beq L_EEFA		;EEF1 F0 07
		dex				;EEF3 CA
		bpl L_EF01		;EEF4 10 0B
		ldx #$00		;EEF6 A2 00
		beq L_EF01		;EEF8 F0 07
.L_EEFA	cpx ZP_31		;EEFA E4 31
		beq L_EF00		;EEFC F0 02
		bcs L_EF01		;EEFE B0 01
.L_EF00	inx				;EF00 E8
.L_EF01	stx ZP_0C		;EF01 86 0C
.L_EF03	jmp L_EE47		;EF03 4C 47 EE
}

.L_EF06	tay				;EF06 A8
		bne L_EF0F		;EF07 D0 06
		jsr do_hall_of_fame_screen		;EF09 20 D2 98
		jmp do_main_menu_dwim		;EF0C 4C 3A EF
.L_EF0F	jsr do_practice_menu		;EF0F 20 A2 98
		cmp #$02		;EF12 C9 02
		bcs do_main_menu_dwim		;EF14 B0 24
		sta L_C76C		;EF16 8D 6C C7
		lda #$01		;EF19 A9 01
		sta L_31A8		;EF1B 8D A8 31
		lda L_31A7		;EF1E AD A7 31
		asl A			;EF21 0A
		clc				;EF22 18
		adc L_C76C		;EF23 6D 6C C7
		jsr select_track		;EF26 20 2F 30
		jmp delay_approx_4_5ths_sec		;EF29 4C E9 3F
.L_EF2C	lda #$00		;EF2C A9 00
		jsr L_F6D7		;EF2E 20 D7 F6
		lda #$80		;EF31 A9 80
		sta L_C76C		;EF33 8D 6C C7
		rts				;EF36 60
.L_EF37	jsr delay_approx_4_5ths_sec		;EF37 20 E9 3F

.do_main_menu_dwim
{
		lda L_31A8		;EF3A AD A8 31
		bne L_EF0F		;EF3D D0 D0
		lda #$01		;EF3F A9 01
		ldx L_C76C		;EF41 AE 6C C7
		bpl L_EF48		;EF44 10 02
		lda #$02		;EF46 A9 02
.L_EF48	ldy #$03		;EF48 A0 03
		ldx #$00		;EF4A A2 00
		jsr do_menu_screen		;EF4C 20 36 EE
		cmp #$02		;EF4F C9 02
		beq L_EF2C		;EF51 F0 D9
		bcc L_EF06		;EF53 90 B1
		jsr delay_approx_4_5ths_sec		;EF55 20 E9 3F
		ldy #$03		;EF58 A0 03
		lda #$03		;EF5A A9 03
		ldx #$04		;EF5C A2 04
		jsr do_menu_screen		;EF5E 20 36 EE
		cmp #$02		;EF61 C9 02
		bcc L_EF8C		;EF63 90 27
		bne L_EF37		;EF65 D0 D0
		jsr L_1611		;EF67 20 11 16
		ldx #$20		;EF6A A2 20
		jsr poll_key_with_sysctl		;EF6C 20 C9 C7
		bne L_EF77		;EF6F D0 06
		jsr L_3500		;EF71 20 00 35
		jmp game_start		;EF74 4C 22 3B
.L_EF77	lda L_31A1		;EF77 AD A1 31
		bne L_EF86		;EF7A D0 0A
		jsr L_3FBE_with_VIC		;EF7C 20 BE 3F
		lda #$80		;EF7F A9 80
		jsr L_F6D7		;EF81 20 D7 F6
		bcc L_EFF4		;EF84 90 6E
.L_EF86	jsr L_E85B		;EF86 20 5B E8
		jmp L_EFF4		;EF89 4C F4 EF
.L_EF8C	sta L_C77B		;EF8C 8D 7B C7
		asl A			;EF8F 0A
		asl A			;EF90 0A
		clc				;EF91 18
		adc #$08		;EF92 69 08
		tax				;EF94 AA
		ldy #$00		;EF95 A0 00
.L_EF97	lda L_8000,Y	;EF97 B9 00 80
		sta L_7B00,Y	;EF9A 99 00 7B
		dey				;EF9D 88
		bne L_EF97		;EF9E D0 F7
		lda L_C77E		;EFA0 AD 7E C7
		sta L_F000		;EFA3 8D 00 F0
		jsr delay_approx_4_5ths_sec		;EFA6 20 E9 3F
		ldy #$02		;EFA9 A0 02
		lda L_0840		;EFAB AD 40 08
		jsr do_menu_screen		;EFAE 20 36 EE
		cmp #$02		;EFB1 C9 02
		bcs L_EF37		;EFB3 B0 82
		sta L_0840		;EFB5 8D 40 08
		lda #$00		;EFB8 A9 00
		jsr L_F6D7		;EFBA 20 D7 F6
		jsr L_2AAE_with_load_save		;EFBD 20 AE 2A
		bit L_EE35		;EFC0 2C 35 EE
		bmi L_EFFD		;EFC3 30 38
		lda L_C367		;EFC5 AD 67 C3
		bne L_EFF1		;EFC8 D0 27
		lda L_C39A		;EFCA AD 9A C3
		bmi L_EFE0		;EFCD 30 11
		lda L_C77B		;EFCF AD 7B C7
		bne L_EFE0		;EFD2 D0 0C
		lda #$80		;EFD4 A9 80
		jsr L_F6D7		;EFD6 20 D7 F6
		bcc L_EFF1		;EFD9 90 16
		lda #$81		;EFDB A9 81
		sta L_C39A		;EFDD 8D 9A C3
.L_EFE0	ldy #$00		;EFE0 A0 00
		lda L_F000		;EFE2 AD 00 F0
		sta L_C77E		;EFE5 8D 7E C7
.L_EFE8	lda L_7B00,Y	;EFE8 B9 00 7B
		sta L_8000,Y	;EFEB 99 00 80
		dey				;EFEE 88
		bne L_EFE8		;EFEF D0 F7
.L_EFF1	jsr L_94D7		;EFF1 20 D7 94
.L_EFF4	jsr L_3500		;EFF4 20 00 35
		jsr set_up_screen_for_frontend		;EFF7 20 04 35
		jsr L_36AD		;EFFA 20 AD 36
.L_EFFD	jmp do_main_menu_dwim		;EFFD 4C 3A EF
}

; X=0 (main menu)
; X=4 (Load/Save/Replay)
; X=8 (Load)
; X=$C (Save)
; X=$10 (Start)
; X=$14 (Multiplayer setup)
; X=$18 (Practise)
; X=$1C (Practise specific	division)
.L_F000	equb $00
.L_F001	equb $EC,$0A,$14,$2C,$44,$49,$4E,$55,$5C,$6B,$55,$00,$7A,$87,$55,$00
		equb $0A,$1F,$00,$00,$2B,$40,$00,$00,$49,$49,$49,$49,$0A,$0A,$55,$00
		
.L_F021
{
		tya				;F021 98
		sta ZP_14		;F022 85 14
		asl A			;F024 0A
		adc ZP_14		;F025 65 14
		asl A			;F027 0A
		asl A			;F028 0A
		asl A			;F029 0A
		clc				;F02A 18
		adc #$08		;F02B 69 08
		tay				;F02D A8
		rts				;F02E 60
}

.get_track_segment_detailsQ
{
		lda L_049C,X	;F02F BD 9C 04
		sta ZP_A2		;F032 85 A2
		asl A			;F034 0A
		tay				;F035 A8
		lda L_B120,Y	;F036 B9 20 B1
		sta ZP_98		;F039 85 98
		lda L_B121,Y	;F03B B9 21 B1
		sta ZP_99		;F03E 85 99
		lda L_04EA,X	;F040 BD EA 04
		asl A			;F043 0A
		tay				;F044 A8
		lda #$00		;F045 A9 00
		rol A			;F047 2A
		asl A			;F048 0A
		sta ZP_D8		;F049 85 D8
		lda L_B120,Y	;F04B B9 20 B1
		sta ZP_CA		;F04E 85 CA
		lda L_B121,Y	;F050 B9 21 B1
		sta ZP_CB		;F053 85 CB
		lda L_0538,X	;F055 BD 38 05
		sta ZP_3F		;F058 85 3F
		lda L_0586,X	;F05A BD 86 05
		sta ZP_35		;F05D 85 35
		lda L_05D4,X	;F05F BD D4 05
		sta ZP_40		;F062 85 40
		lda L_0622,X	;F064 BD 22 06
		sta ZP_36		;F067 85 36
		lda L_0400,X	;F069 BD 00 04
		and #$C0		;F06C 29 C0
		sta ZP_1D		;F06E 85 1D
		lda L_0400,X	;F070 BD 00 04
		and #$10		;F073 29 10
		asl A			;F075 0A
		asl A			;F076 0A
		asl A			;F077 0A
		sta ZP_A4		;F078 85 A4
		lda L_0400,X	;F07A BD 00 04
		and #$0F		;F07D 29 0F
		sta L_C3CD		;F07F 8D CD C3
		asl A			;F082 0A
		tay				;F083 A8
		lda L_B100,Y	;F084 B9 00 B1
		sta ZP_9A		;F087 85 9A
		lda L_B101,Y	;F089 B9 01 B1
		sta ZP_9B		;F08C 85 9B
		ldy #$01		;F08E A0 01
		lda (ZP_9A),Y	;F090 B1 9A
		sta ZP_B2		;F092 85 B2
		dey				;F094 88
		lda (ZP_9A),Y	;F095 B1 9A
		tay				;F097 A8
		lda (ZP_9A),Y	;F098 B1 9A
		iny				;F09A C8
		sta ZP_9E		;F09B 85 9E
		sec				;F09D 38
		sbc #$02		;F09E E9 02
		sta ZP_62		;F0A0 85 62
		lda ZP_9E		;F0A2 A5 9E
		lsr A			;F0A4 4A
		sec				;F0A5 38
		sbc #$01		;F0A6 E9 01
		sta ZP_BE		;F0A8 85 BE
		lda (ZP_9A),Y	;F0AA B1 9A
		iny				;F0AC C8
		lsr A			;F0AD 4A
		ror A			;F0AE 6A
		and #$80		;F0AF 29 80
		sta ZP_9D		;F0B1 85 9D
		lda (ZP_9A),Y	;F0B3 B1 9A
		iny				;F0B5 C8
		sta ZP_BC		;F0B6 85 BC
		lda (ZP_9A),Y	;F0B8 B1 9A
		iny				;F0BA C8
		sta ZP_BD		;F0BB 85 BD
		iny				;F0BD C8
		iny				;F0BE C8
		lda (ZP_9A),Y	;F0BF B1 9A
		iny				;F0C1 C8
		sta ZP_C8		;F0C2 85 C8
		rts				;F0C4 60
}

.L_F0C5
{
		lda L_044E,X	;F0C5 BD 4E 04
		tay				;F0C8 A8
		and #$0F		;F0C9 29 0F
		sec				;F0CB 38
		sbc ZP_5C		;F0CC E5 5C
		tax				;F0CE AA
		tya				;F0CF 98
		lsr A			;F0D0 4A
		lsr A			;F0D1 4A
		lsr A			;F0D2 4A
		lsr A			;F0D3 4A
		sec				;F0D4 38
		sbc ZP_5E		;F0D5 E5 5E
		tay				;F0D7 A8
		bit ZP_68		;F0D8 24 68
		bmi L_F0EC		;F0DA 30 10
		bvc L_F104		;F0DC 50 26
		stx ZP_14		;F0DE 86 14
		tya				;F0E0 98
		eor #$FF		;F0E1 49 FF
		clc				;F0E3 18
		adc #$01		;F0E4 69 01
		tax				;F0E6 AA
		ldy ZP_14		;F0E7 A4 14
		jmp L_F104		;F0E9 4C 04 F1
.L_F0EC	bvs L_F0F9		;F0EC 70 0B
		txa				;F0EE 8A
		eor #$FF		;F0EF 49 FF
		clc				;F0F1 18
		adc #$01		;F0F2 69 01
		tax				;F0F4 AA
		tya				;F0F5 98
		jmp L_F0FE		;F0F6 4C FE F0
.L_F0F9	sty ZP_14		;F0F9 84 14
		txa				;F0FB 8A
		ldx ZP_14		;F0FC A6 14
.L_F0FE	eor #$FF		;F0FE 49 FF
		clc				;F100 18
		adc #$01		;F101 69 01
		tay				;F103 A8
.L_F104	txa				;F104 8A
		asl A			;F105 0A
		asl A			;F106 0A
		asl A			;F107 0A
		clc				;F108 18
		adc ZP_CF		;F109 65 CF
		sta ZP_93		;F10B 85 93
		tya				;F10D 98
		asl A			;F10E 0A
		asl A			;F10F 0A
		asl A			;F110 0A
		clc				;F111 18
		adc ZP_D1		;F112 65 D1
		sta ZP_95		;F114 85 95
		rts				;F116 60
}

.L_F117
{
		sta ZP_14		;F117 85 14
		sty ZP_15		;F119 84 15
		cpy ZP_14		;F11B C4 14
		bcs L_F13C		;F11D B0 1D
		clc				;F11F 18
		adc ZP_15		;F120 65 15
		bcc L_F12F		;F122 90 0B
		txa				;F124 8A
		and #$0F		;F125 29 0F
		cmp #$0F		;F127 C9 0F
		beq L_F15A		;F129 F0 2F
		inx				;F12B E8
		jmp L_F156		;F12C 4C 56 F1
.L_F12F	txa				;F12F 8A
		and #$F0		;F130 29 F0
		beq L_F15A		;F132 F0 26
		txa				;F134 8A
		sec				;F135 38
		sbc #$10		;F136 E9 10
		tax				;F138 AA
		jmp L_F156		;F139 4C 56 F1
.L_F13C	clc				;F13C 18
		adc ZP_15		;F13D 65 15
		bcc L_F150		;F13F 90 0F
		txa				;F141 8A
		and #$F0		;F142 29 F0
		cmp #$F0		;F144 C9 F0
		beq L_F15A		;F146 F0 12
		txa				;F148 8A
		clc				;F149 18
		adc #$10		;F14A 69 10
		tax				;F14C AA
		jmp L_F156		;F14D 4C 56 F1
.L_F150	txa				;F150 8A
		and #$0F		;F151 29 0F
		beq L_F15A		;F153 F0 05
		dex				;F155 CA
.L_F156	jsr find_track_segment_index		;F156 20 5F 1E
		rts				;F159 60
.L_F15A	lda #$FF		;F15A A9 FF
		rts				;F15C 60
}

.L_F15D
{
		sta ZP_16		;F15D 85 16
		ldx #$02		;F15F A2 02
.L_F161	lda L_0100,X	;F161 BD 00 01
		bne L_F169		;F164 D0 03
		inc L_0100,X	;F166 FE 00 01
.L_F169	lda L_0100,X	;F169 BD 00 01
		asl A			;F16C 0A
		lda L_0103,X	;F16D BD 03 01
		rol A			;F170 2A
		sta ZP_AF,X		;F171 95 AF
		lda L_0106,X	;F173 BD 06 01
		rol A			;F176 2A
		sta ZP_5C,X		;F177 95 5C
		dex				;F179 CA
		dex				;F17A CA
		bpl L_F161		;F17B 10 E4
		ldx #$00		;F17D A2 00
		ldy #$00		;F17F A0 00
		bit ZP_16		;F181 24 16
		bmi L_F19D		;F183 30 18
		bvs L_F191		;F185 70 0A
		jsr L_F1C9		;F187 20 C9 F1
		ldx #$02		;F18A A2 02
		ldy #$02		;F18C A0 02
		jmp L_F1C9		;F18E 4C C9 F1
.L_F191	ldy #$02		;F191 A0 02
		jsr L_F1C9		;F193 20 C9 F1
		ldx #$02		;F196 A2 02
		ldy #$00		;F198 A0 00
		jmp L_F1A6		;F19A 4C A6 F1
.L_F19D	bvs L_F1C0		;F19D 70 21
		jsr L_F1A6		;F19F 20 A6 F1
		ldx #$02		;F1A2 A2 02
		ldy #$02		;F1A4 A0 02
.L_F1A6	lda #$00		;F1A6 A9 00
		sec				;F1A8 38
		sbc L_0100,X	;F1A9 FD 00 01
		sta ZP_45,Y		;F1AC 99 45 00
		lda #$00		;F1AF A9 00
		sbc L_0103,X	;F1B1 FD 03 01
		sta ZP_63,Y		;F1B4 99 63 00
		lda #$08		;F1B7 A9 08
		sbc L_0106,X	;F1B9 FD 06 01
		sta ZP_24,Y		;F1BC 99 24 00
		rts				;F1BF 60
.L_F1C0	ldy #$02		;F1C0 A0 02
		jsr L_F1A6		;F1C2 20 A6 F1
		ldx #$02		;F1C5 A2 02
		ldy #$00		;F1C7 A0 00
.L_F1C9	lda L_0100,X	;F1C9 BD 00 01
		sta ZP_45,Y		;F1CC 99 45 00
		lda L_0103,X	;F1CF BD 03 01
		sta ZP_63,Y		;F1D2 99 63 00
		lda L_0106,X	;F1D5 BD 06 01
		sta ZP_24,Y		;F1D8 99 24 00
		rts				;F1DB 60
}

.L_F1DC
{
		lda L_0125		;F1DC AD 25 01
		clc				;F1DF 18
		adc #$20		;F1E0 69 20
		and #$C0		;F1E2 29 C0
		sta ZP_68		;F1E4 85 68
		jsr L_F15D		;F1E6 20 5D F1
		lda L_0101		;F1E9 AD 01 01
		sta ZP_46		;F1EC 85 46
		lda L_0104		;F1EE AD 04 01
		sta ZP_64		;F1F1 85 64
		lda L_0107		;F1F3 AD 07 01
		lsr A			;F1F6 4A
		ror ZP_64		;F1F7 66 64
		ror ZP_46		;F1F9 66 46
		lsr A			;F1FB 4A
		ror ZP_64		;F1FC 66 64
		ror ZP_46		;F1FE 66 46
		lsr A			;F200 4A
		ror ZP_64		;F201 66 64
		ror ZP_46		;F203 66 46
		ldy #$07		;F205 A0 07
		lda L_0160		;F207 AD 60 01
		sta ZP_16		;F20A 85 16
		lda L_0161		;F20C AD 61 01
		cmp #$05		;F20F C9 05
		bcc L_F218		;F211 90 05
		asl ZP_16		;F213 06 16
		rol A			;F215 2A
		ldy #$02		;F216 A0 02
.L_F218	sta ZP_17		;F218 85 17
		lda #$80		;F21A A9 80
		clc				;F21C 18
		adc ZP_16		;F21D 65 16
		sta ZP_16		;F21F 85 16
		tya				;F221 98
		adc ZP_17		;F222 65 17
		sta ZP_17		;F224 85 17
		lda #$00		;F226 A9 00
		sta ZP_14		;F228 85 14
		sta ZP_15		;F22A 85 15
		bit L_0124		;F22C 2C 24 01
		bpl L_F240		;F22F 10 0F
		lda L_0121		;F231 AD 21 01
		sta ZP_14		;F234 85 14
		lda L_0124		;F236 AD 24 01
		ldy #$01		;F239 A0 01
		jsr shift_16bit		;F23B 20 BF C9
		sta ZP_15		;F23E 85 15
.L_F240	lda ZP_16		;F240 A5 16
		sec				;F242 38
		sbc ZP_14		;F243 E5 14
		sta ZP_14		;F245 85 14
		lda ZP_17		;F247 A5 17
		sbc ZP_15		;F249 E5 15
		ldy #$04		;F24B A0 04
		jsr shift_16bit		;F24D 20 BF C9
		sta ZP_15		;F250 85 15
		lda ZP_46		;F252 A5 46
		clc				;F254 18
		adc ZP_14		;F255 65 14
		sta ZP_37		;F257 85 37
		lda ZP_64		;F259 A5 64
		adc ZP_15		;F25B 65 15
		sta ZP_38		;F25D 85 38
		ldx #$02		;F25F A2 02
.L_F261	lda ZP_45,X		;F261 B5 45
		sta ZP_14		;F263 85 14
		lda ZP_63,X		;F265 B5 63
		and #$7F		;F267 29 7F
		lsr A			;F269 4A
		ror ZP_14		;F26A 66 14
		lsr A			;F26C 4A
		ror ZP_14		;F26D 66 14
		lsr A			;F26F 4A
		ror ZP_14		;F270 66 14
		lsr A			;F272 4A
		ror ZP_14		;F273 66 14
		jsr negate_16bit		;F275 20 BF C8
		sta ZP_CF,X		;F278 95 CF
		lda ZP_14		;F27A A5 14
		sta ZP_92,X		;F27C 95 92
		dex				;F27E CA
		dex				;F27F CA
		bpl L_F261		;F280 10 DF
		lda #$00		;F282 A9 00
		sta ZP_16		;F284 85 16
		lda L_0122		;F286 AD 22 01
		sta ZP_14		;F289 85 14
		lda L_0125		;F28B AD 25 01
		sec				;F28E 38
		sbc #$20		;F28F E9 20
		bpl L_F295		;F291 10 02
		dec ZP_16		;F293 C6 16
.L_F295	asl ZP_14		;F295 06 14
		rol A			;F297 2A
		rol ZP_16		;F298 26 16
		asl ZP_14		;F29A 06 14
		rol A			;F29C 2A
		rol ZP_16		;F29D 26 16
		sta ZP_32		;F29F 85 32
		lda ZP_16		;F2A1 A5 16
		sta ZP_3E		;F2A3 85 3E
		lda #$FF		;F2A5 A9 FF
		sta ZP_3E		;F2A7 85 3E
		lda #$00		;F2A9 A9 00
		sec				;F2AB 38
		sbc ZP_32		;F2AC E5 32
		sta ZP_A7		;F2AE 85 A7
		lda #$00		;F2B0 A9 00
		sbc ZP_3E		;F2B2 E5 3E
		sta ZP_A8		;F2B4 85 A8
		rts				;F2B6 60
}

.L_F2B7
{
		lda ZP_B7		;F2B7 A5 B7
		sec				;F2B9 38
		sbc #$C0		;F2BA E9 C0
		sta ZP_14		;F2BC 85 14
		lda ZP_B8		;F2BE A5 B8
		sbc #$00		;F2C0 E9 00
		bit ZP_A4		;F2C2 24 A4
		jsr negate_if_N_set		;F2C4 20 BD C8
		sta ZP_B6		;F2C7 85 B6
		ldx ZP_14		;F2C9 A6 14
		stx ZP_B5		;F2CB 86 B5
		and #$FF		;F2CD 29 FF
		jsr negate_if_N_set		;F2CF 20 BD C8
		cmp #$01		;F2D2 C9 01
		bcc L_F2EC		;F2D4 90 16
		bit ZP_6B		;F2D6 24 6B
		bmi L_F2EB		;F2D8 30 11
		lda #$80		;F2DA A9 80
		sta ZP_6B		;F2DC 85 6B
		lda ZP_B6		;F2DE A5 B6
		sta L_C36F		;F2E0 8D 6F C3
		lda #$0F		;F2E3 A9 0F
;L_F2E4	= *-1			;!
		sta L_C368		;F2E5 8D 68 C3
		jsr L_2C64		;F2E8 20 64 2C
.L_F2EB	rts				;F2EB 60
.L_F2EC	bit ZP_6B		;F2EC 24 6B
		bvs L_F2EB		;F2EE 70 FB
		sta ZP_6B		;F2F0 85 6B
		sta L_C373		;F2F2 8D 73 C3
		rts				;F2F5 60
}

.draw_track_preview
{
		ldx #$00		;F2F6 A2 00
		ldy #$00		;F2F8 A0 00
.L_F2FA	lda #$08		;F2FA A9 08
		sta L_C3D7		;F2FC 8D D7 C3
		lda #$00		;F2FF A9 00
		sec				;F301 38
		sbc L_C3D7		;F302 ED D7 C3
		sta L_C3D8		;F305 8D D8 C3
		ldx #$00		;F308 A2 00
		stx L_C361		;F30A 8E 61 C3
.L_F30D	jsr L_F32E		;F30D 20 2E F3
		dex				;F310 CA
		cpx L_C3D8		;F311 EC D8 C3
		bcs L_F30D		;F314 B0 F7
		ldx #$01		;F316 A2 01
		lda #$80		;F318 A9 80
		sta L_C361		;F31A 8D 61 C3
.L_F31D	jsr L_F32E		;F31D 20 2E F3
		inx				;F320 E8
		cpx L_C3D7		;F321 EC D7 C3
		bcc L_F31D		;F324 90 F7
		beq L_F31D		;F326 F0 F5
		iny				;F328 C8
		cpy #$11		;F329 C0 11
		bne L_F2FA		;F32B D0 CD
		rts				;F32D 60
.L_F32E	stx ZP_30		;F32E 86 30
		sty ZP_31		;F330 84 31
		bit ZP_68		;F332 24 68
		bmi L_F343		;F334 30 0D
		bvc L_F35C		;F336 50 24
		ldx ZP_31		;F338 A6 31
		lda #$00		;F33A A9 00
		sec				;F33C 38
		sbc ZP_30		;F33D E5 30
		tay				;F33F A8
		jmp L_F35C		;F340 4C 5C F3
.L_F343	bvs L_F354		;F343 70 0F
		lda #$00		;F345 A9 00
		sec				;F347 38
		sbc ZP_30		;F348 E5 30
		tax				;F34A AA
		lda #$00		;F34B A9 00
		sec				;F34D 38
		sbc ZP_31		;F34E E5 31
		tay				;F350 A8
		jmp L_F35C		;F351 4C 5C F3
.L_F354	lda #$00		;F354 A9 00
		sec				;F356 38
		sbc ZP_31		;F357 E5 31
		tax				;F359 AA
		ldy ZP_30		;F35A A4 30
.L_F35C	stx ZP_0B		;F35C 86 0B
		sty ZP_0C		;F35E 84 0C
		lda #$00		;F360 A9 00
		sta ZP_D3		;F362 85 D3
		sta ZP_D2		;F364 85 D2
		jsr L_FF6A		;F366 20 6A FF
		bcs L_F381		;F369 B0 16
		cmp #$FF		;F36B C9 FF
		beq L_F381		;F36D F0 12
		sta ZP_2E		;F36F 85 2E
		lda #$00		;F371 A9 00
		sta ZP_D0		;F373 85 D0
		lda #$80		;F375 A9 80
		sta ZP_CC		;F377 85 CC
		sta ZP_CD		;F379 85 CD
		jsr L_177D		;F37B 20 7D 17
		jsr L_1A3B		;F37E 20 3B 1A
.L_F381	ldx ZP_30		;F381 A6 30
		ldy ZP_31		;F383 A4 31
		rts				;F385 60
}

.L_F386
{
		lda L_C34C		;F386 AD 4C C3
		and #$03		;F389 29 03
		tax				;F38B AA
		lda L_F3FC,X	;F38C BD FC F3
		sta L_0106		;F38F 8D 06 01
		lda L_F400,X	;F392 BD 00 F4
		sta L_0108		;F395 8D 08 01
		lda L_F404,X	;F398 BD 04 F4
		sta L_0125		;F39B 8D 25 01
		lda #$03		;F39E A9 03
		sta L_0107		;F3A0 8D 07 01
		lda #$F0		;F3A3 A9 F0
		sta L_0104		;F3A5 8D 04 01
		lda #$18		;F3A8 A9 18
		clc				;F3AA 18
		adc L_A1F2		;F3AB 6D F2 A1
		sta ZP_12		;F3AE 85 12
		lda #$B8		;F3B0 A9 B8
		sta ZP_33		;F3B2 85 33
		jsr start_of_frame		;F3B4 20 4D 16
		ldx #$7F		;F3B7 A2 7F
		lda #$C0		;F3B9 A9 C0
.L_F3BB	sta L_C640,X	;F3BB 9D 40 C6
		dex				;F3BE CA
		bpl L_F3BB		;F3BF 10 FA
		ldx #$00		;F3C1 A2 00
		lda #$FF		;F3C3 A9 FF
.L_F3C5	sta L_52E0,X	;F3C5 9D E0 52
		sta L_5420,X	;F3C8 9D 20 54
		sta L_5560,X	;F3CB 9D 60 55
		dex				;F3CE CA
		bne L_F3C5		;F3CF D0 F4
		jsr ensure_screen_enabled		;F3D1 20 9E 3F
		lda #$0B		;F3D4 A9 0B
		sta L_262B		;F3D6 8D 2B 26
		ldx #$02		;F3D9 A2 02
.L_F3DB	lda L_2458,X	;F3DB BD 58 24
		pha				;F3DE 48
		lda L_F408,X	;F3DF BD 08 F4
		sta L_2458,X	;F3E2 9D 58 24
		dex				;F3E5 CA
		bpl L_F3DB		;F3E6 10 F3
		jsr draw_track_preview		;F3E8 20 F6 F2
		lda #$08		;F3EB A9 08
		sta L_262B		;F3ED 8D 2B 26
		ldx #$00		;F3F0 A2 00
.L_F3F2	pla				;F3F2 68
		sta L_2458,X	;F3F3 9D 58 24
		inx				;F3F6 E8
		cpx #$03		;F3F7 E0 03
		bne L_F3F2		;F3F9 D0 F7
		rts				;F3FB 60
}

.L_F3FC	equb $04,$00,$04,$08
.L_F400	equb $00,$04,$08,$04
.L_F404	equb $00,$40,$80,$C0
.L_F408	equb $4C,$0B,$F4,$86,$16,$A5,$77,$18,$10,$01,$38,$6A,$66,$51,$85,$77

.L_F418
{
		jsr L_F42D		;F418 20 2D F4
		lda ZP_70		;F41B A5 70
		pha				;F41D 48
		lda ZP_71		;F41E A5 71
		pha				;F420 48
		jsr L_F42D		;F421 20 2D F4
		pla				;F424 68
		sta ZP_AC		;F425 85 AC
		pla				;F427 68
		sta ZP_AB		;F428 85 AB
		ldx ZP_16		;F42A A6 16
		rts				;F42C 60
.L_F42D	lda ZP_78		;F42D A5 78
		clc				;F42F 18
		bpl L_F433		;F430 10 01
		sec				;F432 38
.L_F433	ror A			;F433 6A
		ror ZP_52		;F434 66 52
		clc				;F436 18
		adc #$30		;F437 69 30
		sta ZP_78		;F439 85 78
		lda ZP_52		;F43B A5 52
		jmp L_245C		;F43D 4C 5C 24
}

.L_F440
{
		ldx #$00		;F440 A2 00
		ldy ZP_9E		;F442 A4 9E
		dey				;F444 88
		lda ZP_9E		;F445 A5 9E
		lsr A			;F447 4A
		sta ZP_18		;F448 85 18
.L_F44A	lda L_A330,X	;F44A BD 30 A3
		sta ZP_14		;F44D 85 14
		lda L_8040,X	;F44F BD 40 80
		sta ZP_15		;F452 85 15
		lda L_A330,Y	;F454 B9 30 A3
		sta L_A330,X	;F457 9D 30 A3
		lda L_8040,Y	;F45A B9 40 80
		sta L_8040,X	;F45D 9D 40 80
		lda ZP_14		;F460 A5 14
		sta L_A330,Y	;F462 99 30 A3
		lda ZP_15		;F465 A5 15
		sta L_8040,Y	;F467 99 40 80
		dey				;F46A 88
		txa				;F46B 8A
		and #$01		;F46C 29 01
		bne L_F47F		;F46E D0 0F
		txa				;F470 8A
		lda L_8080,X	;F471 BD 80 80
		pha				;F474 48
		lda L_8080,Y	;F475 B9 80 80
		sta L_8080,X	;F478 9D 80 80
		pla				;F47B 68
		sta L_8080,Y	;F47C 99 80 80
.L_F47F	inx				;F47F E8
		dec ZP_18		;F480 C6 18
		bne L_F44A		;F482 D0 C6
		rts				;F484 60
}

.L_F485
		jsr L_CFD2		;F485 20 D2 CF
\\
.L_F488
{
		stx ZP_2E		;F488 86 2E
		stx L_C374		;F48A 8E 74 C3
		lda L_0400,X	;F48D BD 00 04
		and #$0F		;F490 29 0F
		tay				;F492 A8
		lda L_B240,Y	;F493 B9 40 B2
		bmi L_F485		;F496 30 ED
		ldy L_C779		;F498 AC 79 C7
		beq L_F4A7		;F49B F0 0A
		dey				;F49D 88
.L_F49E	txa				;F49E 8A
		cmp L_0190,Y	;F49F D9 90 01
		beq L_F485		;F4A2 F0 E1
		dey				;F4A4 88
		bpl L_F49E		;F4A5 10 F7
.L_F4A7	ldy #$00		;F4A7 A0 00
		tya				;F4A9 98
.L_F4AA	sta L_0100,Y	;F4AA 99 00 01
		iny				;F4AD C8
		cpy #$90		;F4AE C0 90
		bcc L_F4AA		;F4B0 90 F8
		lda #$F0		;F4B2 A9 F0
		sta ZP_2F		;F4B4 85 2F
		jsr get_track_segment_detailsQ		;F4B6 20 2F F0
		lda L_044E,X	;F4B9 BD 4E 04
		and #$0F		;F4BC 29 0F
		sta ZP_0B		;F4BE 85 0B
		lda L_044E,X	;F4C0 BD 4E 04
		lsr A			;F4C3 4A
		lsr A			;F4C4 4A
		lsr A			;F4C5 4A
		lsr A			;F4C6 4A
		sta ZP_0C		;F4C7 85 0C
		lda ZP_0B		;F4C9 A5 0B
		lsr A			;F4CB 4A
		sta L_0106		;F4CC 8D 06 01
		lda #$00		;F4CF A9 00
		sta L_0100		;F4D1 8D 00 01
		sta L_0102		;F4D4 8D 02 01
		ror A			;F4D7 6A
		clc				;F4D8 18
		adc #$40		;F4D9 69 40
		sta L_0103		;F4DB 8D 03 01
		lda ZP_0C		;F4DE A5 0C
		lsr A			;F4E0 4A
		sta L_0108		;F4E1 8D 08 01
		lda #$00		;F4E4 A9 00
		ror A			;F4E6 6A
		clc				;F4E7 18
		adc #$40		;F4E8 69 40
		sta L_0105		;F4EA 8D 05 01
		lda #$04		;F4ED A9 04
		sta L_0107		;F4EF 8D 07 01
		ldx #$00		;F4F2 A2 00
		lda L_C3CD		;F4F4 AD CD C3
		cmp #$04		;F4F7 C9 04
		beq L_F4FF		;F4F9 F0 04
		cmp #$0A		;F4FB C9 0A
		bne L_F501		;F4FD D0 02
.L_F4FF	ldx #$20		;F4FF A2 20
.L_F501	stx ZP_14		;F501 86 14
		lda ZP_1D		;F503 A5 1D
		eor ZP_A4		;F505 45 A4
		clc				;F507 18
		adc ZP_14		;F508 65 14
		sta L_0125		;F50A 8D 25 01
		jsr L_F1DC		;F50D 20 DC F1
		jsr L_9A38		;F510 20 38 9A
		jsr L_F2B7		;F513 20 B7 F2
		jsr game_update		;F516 20 41 08
		lda #$00		;F519 A9 00
		sta L_0107		;F51B 8D 07 01
		sta L_0101		;F51E 8D 01 01
		lda #$10		;F521 A9 10
		sta L_0104		;F523 8D 04 01
		lda L_C345		;F526 AD 45 C3
		sta ZP_14		;F529 85 14
		lda L_C3D0		;F52B AD D0 C3
		ldy L_C37C		;F52E AC 7C C3
		beq L_F552		;F531 F0 1F
		sta ZP_15		;F533 85 15
		sta L_0107		;F535 8D 07 01
		lda ZP_14		;F538 A5 14
		asl A			;F53A 0A
		rol L_0107		;F53B 2E 07 01
		clc				;F53E 18
		adc #$18		;F53F 69 18
		sta L_0104		;F541 8D 04 01
		lda L_0107		;F544 AD 07 01
		adc #$00		;F547 69 00
		sta L_0107		;F549 8D 07 01
		lda #$E6		;F54C A9 E6
		sta ZP_2F		;F54E 85 2F
		lda ZP_15		;F550 A5 15
.L_F552	ldy #$FA		;F552 A0 FA
		jsr shift_16bit		;F554 20 BF C9
		sta L_C35E		;F557 8D 5E C3
		lda ZP_14		;F55A A5 14
		sta L_C35D		;F55C 8D 5D C3
		jsr L_ED39		;F55F 20 39 ED
		ldx #$02		;F562 A2 02
.L_F564	lda #$10		;F564 A9 10
		sta L_C343,X	;F566 9D 43 C3
		lda #$00		;F569 A9 00
		sta L_C3CE,X	;F56B 9D CE C3
		sta L_C340,X	;F56E 9D 40 C3
		sta L_0145,X	;F571 9D 45 01
		dex				;F574 CA
		bpl L_F564		;F575 10 ED
		jsr L_F1DC		;F577 20 DC F1
		lda #$AF		;F57A A9 AF
		sta L_C36B		;F57C 8D 6B C3
		lda #$08		;F57F A9 08
		sta L_C36C		;F581 8D 6C C3
		rts				;F584 60
}

.L_F585
{
		lda ZP_23		;F585 A5 23
		sec				;F587 38
		sbc ZP_22		;F588 E5 22
		sta ZP_14		;F58A 85 14
		lda ZP_C4		;F58C A5 C4
		sbc ZP_C3		;F58E E5 C3
		ldy #$03		;F590 A0 03
		jsr shift_16bit		;F592 20 BF C9
		sta ZP_15		;F595 85 15
		ldx L_C375		;F597 AE 75 C3
		ldy L_C374		;F59A AC 74 C3
		lda L_0670,X	;F59D BD 70 06
		sec				;F5A0 38
		sbc L_0670,Y	;F5A1 F9 70 06
		sta ZP_16		;F5A4 85 16
		lda L_06BE,X	;F5A6 BD BE 06
		sbc L_06BE,Y	;F5A9 F9 BE 06
		sta ZP_17		;F5AC 85 17
		lda ZP_16		;F5AE A5 16
		clc				;F5B0 18
		adc ZP_14		;F5B1 65 14
		sta ZP_14		;F5B3 85 14
		lda ZP_17		;F5B5 A5 17
		adc ZP_15		;F5B7 65 15
		sta ZP_3B		;F5B9 85 3B
		jsr negate_if_N_set		;F5BB 20 BD C8
		sta ZP_15		;F5BE 85 15
		lda L_C768		;F5C0 AD 68 C7
		sec				;F5C3 38
		sbc ZP_14		;F5C4 E5 14
		tax				;F5C6 AA
		lda L_C769		;F5C7 AD 69 C7
		sbc ZP_15		;F5CA E5 15
		tay				;F5CC A8
		lda ZP_3B		;F5CD A5 3B
		cpy ZP_15		;F5CF C4 15
		bcc L_F5DF		;F5D1 90 0C
		bne L_F5D9		;F5D3 D0 04
		cpx ZP_14		;F5D5 E4 14
		bcc L_F5DF		;F5D7 90 06
.L_F5D9	ldx ZP_14		;F5D9 A6 14
		ldy ZP_15		;F5DB A4 15
		eor #$80		;F5DD 49 80
.L_F5DF	stx ZP_39		;F5DF 86 39
		sty ZP_3A		;F5E1 84 3A
		eor #$80		;F5E3 49 80
		sta L_C36A		;F5E5 8D 6A C3
		rts				;F5E8 60
}

.L_F5E9
{
		lda L_C379		;F5E9 AD 79 C3
		sec				;F5EC 38
		sbc L_C378		;F5ED ED 78 C3
		bne L_F60E		;F5F0 D0 1C
		ldx #$01		;F5F2 A2 01
.L_F5F4	lda L_C374,X	;F5F4 BD 74 C3
		sec				;F5F7 38
		sbc L_C77C		;F5F8 ED 7C C7
		bcs L_F600		;F5FB B0 03
		adc L_C764		;F5FD 6D 64 C7
.L_F600	sta ZP_14,X		;F600 95 14
		dex				;F602 CA
		bpl L_F5F4		;F603 10 EF
		lda ZP_15		;F605 A5 15
		sec				;F607 38
		sbc ZP_14		;F608 E5 14
		bne L_F60E		;F60A D0 02
		lda ZP_3B		;F60C A5 3B
.L_F60E	rts				;F60E 60
}

.update_boosting
{
		lda L_C398		;F60F AD 98 C3
		ora ZP_0E		;F612 05 0E
		bne L_F65D		;F614 D0 47
		lda L_C39B		;F616 AD 9B C3
		bmi L_F621		;F619 30 06
		lda ZP_66		;F61B A5 66
		and #$03		;F61D 29 03
		beq L_F65D		;F61F F0 3C
.L_F621	lda L_C76A		;F621 AD 6A C7
		beq L_F65D		;F624 F0 37
		dec L_C36E		;F626 CE 6E C3
		bpl L_F64C		;F629 10 21
		ldy L_C388		;F62B AC 88 C3
		sty L_C36E		;F62E 8C 6E C3
		sed				;F631 F8
		sec				;F632 38
		sbc #$01		;F633 E9 01
;L_F634	= *-1			;!
		cld				;F635 D8
		sta L_C76A		;F636 8D 6A C7
		lsr A			;F639 4A
		lsr A			;F63A 4A
		lsr A			;F63B 4A
		lsr A			;F63C 4A
		ldx #$44		;F63D A2 44
		jsr L_142E		;F63F 20 2E 14
		lda L_C76A		;F642 AD 6A C7
		and #$0F		;F645 29 0F
		ldx #$45		;F647 A2 45
		jsr L_142E		;F649 20 2E 14
.L_F64C	lda #$80		;F64C A9 80
		sta ZP_72		;F64E 85 72
		lda ZP_6E		;F650 A5 6E
		ora #$03		;F652 09 03
		sta ZP_6E		;F654 85 6E
		asl L_0150		;F656 0E 50 01
		rol L_0151		;F659 2E 51 01
		rts				;F65C 60
.L_F65D	lda ZP_6E		;F65D A5 6E
		and #$FC		;F65F 29 FC
		sta ZP_6E		;F661 85 6E
		lda #$00		;F663 A9 00
		sta ZP_72		;F665 85 72
		rts				;F667 60
}

.L_F668
		ldx #$10		;F668 A2 10
		jsr L_F67E		;F66A 20 7E F6
		ldx #$18		;F66D A2 18
.L_F66F	lda #$3F		;F66F A9 3F
		bne L_F680		;F671 D0 0D
\\
.L_F673
		ldx #$30		;F673 A2 30
		jsr L_F67E		;F675 20 7E F6
		ldx #$38		;F678 A2 38
		bne L_F66F		;F67A D0 F3
.L_F67C	ldx #$20		;F67C A2 20
.L_F67E	lda #$00		;F67E A9 00
.L_F680	sta ZP_16		;F680 85 16
		lda #$08		;F682 A9 08
		bne L_F68A		;F684 D0 04
.L_F686	ldx #$00		;F686 A2 00
		lda #$10		;F688 A9 10
.L_F68A	sta ZP_14		;F68A 85 14
		sty ZP_15		;F68C 84 15
.L_F68E	lda L_6028,Y	;F68E B9 28 60
		and ZP_16		;F691 25 16
		ora L_80C8,X	;F693 1D C8 80
		sta L_6028,Y	;F696 99 28 60
		iny				;F699 C8
		inx				;F69A E8
		dec ZP_14		;F69B C6 14
		bne L_F68E		;F69D D0 EF
		lda ZP_15		;F69F A5 15
		lsr A			;F6A1 4A
		lsr A			;F6A2 4A
		lsr A			;F6A3 4A
		tax				;F6A4 AA
		rts				;F6A5 60

.L_F6A6
{
		ldx #$1D		;F6A6 A2 1D
.L_F6A8	lda #$0A		;F6A8 A9 0A
		sta L_D805,X	;F6AA 9D 05 D8
		dex				;F6AD CA
		bpl L_F6A8		;F6AE 10 F8
		ldy #$00		;F6B0 A0 00
		lda L_C719		;F6B2 AD 19 C7
		sta ZP_08		;F6B5 85 08
.L_F6B7	jsr L_F67C		;F6B7 20 7C F6
		dec ZP_08		;F6BA C6 08
		bmi L_F6C6		;F6BC 30 08
		jsr L_F686		;F6BE 20 86 F6
.L_F6C1	cpy #$F0		;F6C1 C0 F0
		bcc L_F6B7		;F6C3 90 F2
		rts				;F6C5 60
.L_F6C6	jsr L_F67C		;F6C6 20 7C F6
		jsr L_F67C		;F6C9 20 7C F6
		tya				;F6CC 98
		sec				;F6CD 38
		sbc #$10		;F6CE E9 10
		tay				;F6D0 A8
		jsr L_F668		;F6D1 20 68 F6
		jmp L_F6C1		;F6D4 4C C1 F6
}

.L_F6D7
{
		sta ZP_19		;F6D7 85 19
		ldx #$04		;F6D9 A2 04
.L_F6DB	bit ZP_19		;F6DB 24 19
		bmi L_F6E9		;F6DD 30 0A
		lda ZP_02,X		;F6DF B5 02
		sta L_801B,X	;F6E1 9D 1B 80
		jmp L_F6F3		;F6E4 4C F3 F6
.L_F6E7	clc				;F6E7 18
		rts				;F6E8 60
.L_F6E9	lda L_C77E		;F6E9 AD 7E C7
		bpl L_F6E7		;F6EC 10 F9
		lda L_801B,X	;F6EE BD 1B 80
		sta ZP_02,X		;F6F1 95 02
.L_F6F3	dex				;F6F3 CA
		bpl L_F6DB		;F6F4 10 E5
		bit ZP_19		;F6F6 24 19
		bmi L_F707		;F6F8 30 0D
		ldx #$0B		;F6FA A2 0B
.L_F6FC	lda L_AEB1,X	;F6FC BD B1 AE
		eor #$3B		;F6FF 49 3B
		sta L_C700,X	;F701 9D 00 C7
		dex				;F704 CA
		bpl L_F6FC		;F705 10 F5
.L_F707	ldx #$1A		;F707 A2 1A
.L_F709	bit ZP_19		;F709 24 19
		bpl L_F717		;F70B 10 0A
		lda L_8000,X	;F70D BD 00 80
		sta ZP_17		;F710 85 17
		lda L_8025,X	;F712 BD 25 80
		sta ZP_16		;F715 85 16
.L_F717	ldy #$00		;F717 A0 00
		sty ZP_15		;F719 84 15
.L_F71B	inc ZP_15		;F71B E6 15
		bne L_F722		;F71D D0 03
		iny				;F71F C8
		bmi L_F791		;F720 30 6F
.L_F722	jsr rndQ		;F722 20 B9 29
		sta ZP_18		;F725 85 18
		bit ZP_19		;F727 24 19
		bmi L_F73C		;F729 30 11
		cmp L_C700,X	;F72B DD 00 C7
		bne L_F71B		;F72E D0 EB
		tya				;F730 98
		sta L_8000,X	;F731 9D 00 80
		lda ZP_15		;F734 A5 15
		sta L_8025,X	;F736 9D 25 80
		jmp L_F74B		;F739 4C 4B F7
.L_F73C	cpy ZP_17		;F73C C4 17
		bne L_F71B		;F73E D0 DB
		lda ZP_15		;F740 A5 15
		cmp ZP_16		;F742 C5 16
		bne L_F71B		;F744 D0 D5
		lda ZP_18		;F746 A5 18
		sta L_4000,X	;F748 9D 00 40
.L_F74B	dex				;F74B CA
		bpl L_F709		;F74C 10 BB
		ldx #$04		;F74E A2 04
		ldy #$09		;F750 A0 09
.L_F752	lda ZP_02,X		;F752 B5 02
		bit ZP_19		;F754 24 19
		bmi L_F75D		;F756 30 05
		sta L_8020,X	;F758 9D 20 80
		bpl L_F762		;F75B 10 05
.L_F75D	cmp L_8020,X	;F75D DD 20 80
		bne L_F791		;F760 D0 2F
.L_F762	dex				;F762 CA
		bpl L_F752		;F763 10 ED
		bit ZP_19		;F765 24 19
		bpl L_F78A		;F767 10 21
		ldx #$1A		;F769 A2 1A
.L_F76B	lda L_31A1		;F76B AD A1 31
		beq L_F774		;F76E F0 04
		cpx #$18		;F770 E0 18
		bcc L_F77A		;F772 90 06
.L_F774	lda L_4000,X	;F774 BD 00 40
		sta L_C700,X	;F777 9D 00 C7
.L_F77A	dex				;F77A CA
		bpl L_F76B		;F77B 10 EE
		ldx #$0B		;F77D A2 0B
.L_F77F	lda L_C700,X	;F77F BD 00 C7
		eor #$3B		;F782 49 3B
		sta L_AEB1,X	;F784 9D B1 AE
		dex				;F787 CA
		bpl L_F77F		;F788 10 F5
.L_F78A	lda #$80		;F78A A9 80
		sta L_C77E		;F78C 8D 7E C7
		clc				;F78F 18
		rts				;F790 60
.L_F791	lda #$3B		;F791 A9 3B
		sta ZP_03		;F793 85 03
		lda ZP_19		;F795 A5 19
		bmi L_F79C		;F797 30 03
		jmp L_F6D7		;F799 4C D7 F6
.L_F79C	sec				;F79C 38
		rts				;F79D 60
}

.check_game_keys
{
		lda #$10		;F79E A9 10
		sta ZP_15		;F7A0 85 15
		lda #$00		;F7A2 A9 00
		sta ZP_14		;F7A4 85 14
		jsr rndQ		;F7A6 20 B9 29
		ldy #$04		;F7A9 A0 04
.L_F7AB	ldx control_keys,Y	;F7AB BE 07 F8
		jsr poll_key_with_sysctl		;F7AE 20 C9 C7
		bne L_F7B9		;F7B1 D0 06
		lda ZP_14		;F7B3 A5 14
		ora ZP_15		;F7B5 05 15
		sta ZP_14		;F7B7 85 14
.L_F7B9	lsr ZP_15		;F7B9 46 15
		dey				;F7BB 88
		bpl L_F7AB		;F7BC 10 ED
		lda ZP_14		;F7BE A5 14
		tax				;F7C0 AA
		tay				;F7C1 A8
		and #$10		;F7C2 29 10
		beq L_F7CA		;F7C4 F0 04
		tya				;F7C6 98
		ora #$01		;F7C7 09 01
		tay				;F7C9 A8
.L_F7CA	txa				;F7CA 8A
		and #$02		;F7CB 29 02
		beq L_F7D3		;F7CD F0 04
		tya				;F7CF 98
		ora #$10		;F7D0 09 10
		tay				;F7D2 A8
.L_F7D3	txa				;F7D3 8A
		and #$01		;F7D4 29 01
		beq L_F7DE		;F7D6 F0 06
		tya				;F7D8 98
		ora #$02		;F7D9 09 02
		and #$FE		;F7DB 29 FE
		tay				;F7DD A8
.L_F7DE	tya				;F7DE 98
		bne L_F802		;F7DF D0 21
		inc L_F810		;F7E1 EE 10 F8
		lda #$00		;F7E4 A9 00
		sta CIA1_CIDDRA		;F7E6 8D 02 DC
		lda CIA1_CIAPRA		;F7E9 AD 00 DC			; CIA1
		eor #$FF		;F7EC 49 FF
		bne L_F802		;F7EE D0 12
		ldy L_3DF8		;F7F0 AC F8 3D
		bmi L_F802		;F7F3 30 0D
		ldx #$08		;F7F5 A2 08
		jsr poll_key_with_sysctl		;F7F7 20 C9 C7
		bne L_F800		;F7FA D0 04
		lda #$10		;F7FC A9 10
		bne L_F802		;F7FE D0 02
.L_F800	lda #$00		;F800 A9 00
.L_F802	and #$1F		;F802 29 1F
		sta ZP_66		;F804 85 66
		rts				;F806 60
}

; KEY DEFINITIONS

.control_keys	equb $2E,$27,$29,$12,$08
.L_F80C	equb $07,$1F,$01,$19
.L_F810	equb $11

.L_F811
{
		lda ZP_C3,X		;F811 B5 C3
		bne L_F829		;F813 D0 14
		lda ZP_22,X		;F815 B5 22
		eor #$FF		;F817 49 FF
		sta ZP_15		;F819 85 15
		lda #$0E		;F81B A9 0E
		jsr mul_8_8_16bit		;F81D 20 82 C7
		cmp #$0A		;F820 C9 0A
		bcc L_F826		;F822 90 02
		adc #$05		;F824 69 05
.L_F826	jsr L_109E		;F826 20 9E 10
.L_F829	rts				;F829 60
}

.L_F82A	rts				;F82A 60

; Line draw functions? (steep/shallow/x/y?)

.L_F82B
		cmp #$C0		;F82B C9 C0
		bcs L_F82A		;F82D B0 FB
		cmp #$40		;F82F C9 40
		bcs L_F835		;F831 B0 02
		lda #$40		;F833 A9 40
.L_F835	sta ZP_89		;F835 85 89
		lda ZP_52		;F837 A5 52
		lsr A			;F839 4A
		eor #$FF		;F83A 49 FF
		cpy ZP_89		;F83C C4 89
		bcs L_F843		;F83E B0 03
		jmp L_F907		;F840 4C 07 F9
.L_F843	cpy #$C0		;F843 C0 C0
		bcc L_F854		;F845 90 0D
.L_F847	dey				;F847 88
		clc				;F848 18
		adc ZP_51		;F849 65 51
		bcc L_F843		;F84B 90 F6
		sbc ZP_52		;F84D E5 52
		dex				;F84F CA
		cpy #$C0		;F850 C0 C0
		bcs L_F847		;F852 B0 F3
.L_F854	cpx #$40		;F854 E0 40
		bcc L_F82A		;F856 90 D2
		cpx #$C0		;F858 E0 C0
		bcc L_F874		;F85A 90 18
		jmp L_F86B		;F85C 4C 6B F8
.L_F85F	clc				;F85F 18
		adc ZP_51		;F860 65 51
		bcc L_F86B		;F862 90 07
		sbc ZP_52		;F864 E5 52
		dex				;F866 CA
		cpx #$C0		;F867 E0 C0
		bcc L_F874		;F869 90 09
.L_F86B	dey				;F86B 88
		cpy ZP_89		;F86C C4 89
		bcs L_F85F		;F86E B0 EF
		jmp L_F907		;F870 4C 07 F9
.L_F873	rts				;F873 60
.L_F874	sta ZP_0F		;F874 85 0F
		tya				;F876 98
		and #$F8		;F877 29 F8
		cmp ZP_89		;F879 C5 89
		bcs L_F87F		;F87B B0 02
		lda ZP_89		;F87D A5 89
.L_F87F	sta ZP_07		;F87F 85 07
		txa				;F881 8A
		sec				;F882 38
		sbc #$40		;F883 E9 40
		and #$7C		;F885 29 7C
		asl A			;F887 0A
		adc Q_pointers_LO,Y	;F888 79 00 A5
		sta ZP_1E		;F88B 85 1E
		lda Q_pointers_HI,Y	;F88D B9 00 A6
		adc ZP_12		;F890 65 12
		sta ZP_1F		;F892 85 1F
		jmp L_F8C9		;F894 4C C9 F8
.L_F897	lda ZP_0F		;F897 A5 0F
		clc				;F899 18
		adc ZP_51		;F89A 65 51
		bcc L_F8C7		;F89C 90 29
		sbc ZP_52		;F89E E5 52
		sta ZP_0F		;F8A0 85 0F
		txa				;F8A2 8A
		dex				;F8A3 CA
		and #$03		;F8A4 29 03
		bne L_F8C9		;F8A6 D0 21
		cpx #$40		;F8A8 E0 40
		bcc L_F873		;F8AA 90 C7
		lda ZP_1E		;F8AC A5 1E
		sbc #$08		;F8AE E9 08
		sta ZP_1E		;F8B0 85 1E
		bcs L_F8C9		;F8B2 B0 15
		dec ZP_1F		;F8B4 C6 1F
		jmp L_F8C9		;F8B6 4C C9 F8
.L_F8B9	cmp L_C580,X	;F8B9 DD 80 C5
		bcc L_F8E3		;F8BC 90 25
		beq L_F8E3		;F8BE F0 23
		cmp L_C600,X	;F8C0 DD 00 C6
		bcc L_F8DC		;F8C3 90 17
		bcs L_F8E3		;F8C5 B0 1C
.L_F8C7	sta ZP_0F		;F8C7 85 0F
.L_F8C9	tya				;F8C9 98
		cmp L_C600,X	;F8CA DD 00 C6
L_F8CB	= *-2			;! self-mod!
		bcs L_F8E3		;F8CD B0 14
		sta L_C600,X	;F8CF 9D 00 C6
		cmp L_0240,X	;F8D2 DD 40 02
		bcs L_F8DC		;F8D5 B0 05
		cmp L_C500,X	;F8D7 DD 00 C5
		bcs L_F8E3		;F8DA B0 07
.L_F8DC	lda (ZP_1E),Y	;F8DC B1 1E
.L_F8DE	and L_A400,X	;F8DE 3D 00 A4
L_F8DF	= *-2			;!
		sta (ZP_1E),Y	;F8E1 91 1E
.L_F8E3	dey				;F8E3 88
		cpy ZP_07		;F8E4 C4 07
		bcs L_F897		;F8E6 B0 AF
		tya				;F8E8 98
		sbc #$06		;F8E9 E9 06
		cmp ZP_89		;F8EB C5 89
		bcs L_F8F5		;F8ED B0 06
		cpy ZP_89		;F8EF C4 89
		bcc L_F907		;F8F1 90 14
		lda ZP_89		;F8F3 A5 89
.L_F8F5	sta ZP_07		;F8F5 85 07
		lda ZP_1E		;F8F7 A5 1E
		sec				;F8F9 38
		sbc #$38		;F8FA E9 38
		sta ZP_1E		;F8FC 85 1E
		lda ZP_1F		;F8FE A5 1F
		sbc #$01		;F900 E9 01
		sta ZP_1F		;F902 85 1F
		jmp L_F897		;F904 4C 97 F8
.L_F907	cpy #$40		;F907 C0 40
		bcs L_F931		;F909 B0 26
		lda ZP_4F		;F90B A5 4F
		cmp ZP_4E		;F90D C5 4E
		bcc L_F913		;F90F 90 02
		lda ZP_4E		;F911 A5 4E
.L_F913	cmp #$40		;F913 C9 40
		bcs L_F919		;F915 B0 02
		lda #$40		;F917 A9 40
.L_F919	sta ZP_89		;F919 85 89
		cpx #$C0		;F91B E0 C0
		bcc L_F921		;F91D 90 02
		ldx #$BF		;F91F A2 BF
.L_F921	cpx ZP_89		;F921 E4 89
		bcc L_F931		;F923 90 0C
\\
.L_F925
		dec ZP_89		;F925 C6 89
		lda #$40		;F927 A9 40
.L_F929	sta L_C600,X	;F929 9D 00 C6
L_F92B	= *-1			;! self-mod!
		dex				;F92C CA
		cpx ZP_89		;F92D E4 89
		bne L_F929		;F92F D0 F8
.L_F931	rts				;F931 60

.L_F932
		cmp #$C0		;F932 C9 C0
		bcs L_F931		;F934 B0 FB
		cmp #$40		;F936 C9 40
		bcs L_F93C		;F938 B0 02
		lda #$40		;F93A A9 40
.L_F93C	sta ZP_89		;F93C 85 89
		lda ZP_52		;F93E A5 52
		lsr A			;F940 4A
		eor #$FF		;F941 49 FF
		cpy ZP_89		;F943 C4 89
		bcs L_F94A		;F945 B0 03
		jmp L_FA0E		;F947 4C 0E FA
.L_F94A	cpy #$C0		;F94A C0 C0
		bcc L_F95B		;F94C 90 0D
.L_F94E	dey				;F94E 88
		clc				;F94F 18
		adc ZP_51		;F950 65 51
		bcc L_F94A		;F952 90 F6
		sbc ZP_52		;F954 E5 52
		inx				;F956 E8
		cpy #$C0		;F957 C0 C0
		bcs L_F94E		;F959 B0 F3
.L_F95B	cpx #$C0		;F95B E0 C0
		bcs L_F931		;F95D B0 D2
		cpx #$40		;F95F E0 40
		bcs L_F97B		;F961 B0 18
		jmp L_F972		;F963 4C 72 F9
.L_F966	clc				;F966 18
		adc ZP_51		;F967 65 51
		bcc L_F972		;F969 90 07
		sbc ZP_52		;F96B E5 52
		inx				;F96D E8
		cpx #$40		;F96E E0 40
		bcs L_F97B		;F970 B0 09
.L_F972	dey				;F972 88
		cpy ZP_89		;F973 C4 89
		bcs L_F966		;F975 B0 EF
		jmp L_FA0E		;F977 4C 0E FA
.L_F97A	rts				;F97A 60
.L_F97B	sta ZP_0F		;F97B 85 0F
		tya				;F97D 98
		and #$F8		;F97E 29 F8
		cmp ZP_89		;F980 C5 89
		bcs L_F986		;F982 B0 02
		lda ZP_89		;F984 A5 89
.L_F986	sta ZP_07		;F986 85 07
		txa				;F988 8A
		sec				;F989 38
		sbc #$40		;F98A E9 40
		and #$7C		;F98C 29 7C
		asl A			;F98E 0A
		adc Q_pointers_LO,Y	;F98F 79 00 A5
		sta ZP_1E		;F992 85 1E
		lda Q_pointers_HI,Y	;F994 B9 00 A6
		adc ZP_12		;F997 65 12
		sta ZP_1F		;F999 85 1F
		jmp L_F9D0		;F99B 4C D0 F9
.L_F99E	lda ZP_0F		;F99E A5 0F
		clc				;F9A0 18
		adc ZP_51		;F9A1 65 51
		bcc L_F9CE		;F9A3 90 29
		sbc ZP_52		;F9A5 E5 52
		sta ZP_0F		;F9A7 85 0F
		inx				;F9A9 E8
		txa				;F9AA 8A
		and #$03		;F9AB 29 03
		bne L_F9D0		;F9AD D0 21
		cpx #$C0		;F9AF E0 C0
		bcs L_F97A		;F9B1 B0 C7
		lda ZP_1E		;F9B3 A5 1E
		adc #$08		;F9B5 69 08
		sta ZP_1E		;F9B7 85 1E
		bcc L_F9D0		;F9B9 90 15
		inc ZP_1F		;F9BB E6 1F
		jmp L_F9D0		;F9BD 4C D0 F9
;L_F9C0
		cmp L_C580,X	;F9C0 DD 80 C5
		bcc L_F9EA		;F9C3 90 25
		beq L_F9EA		;F9C5 F0 23
		cmp L_C600,X	;F9C7 DD 00 C6
		bcc L_F9E3		;F9CA 90 17
		bcs L_F9EA		;F9CC B0 1C
.L_F9CE	sta ZP_0F		;F9CE 85 0F
.L_F9D0	tya				;F9D0 98
		cmp L_C600,X	;F9D1 DD 00 C6
L_F9D2	= *-2			;! self-mod!
		bcs L_F9EA		;F9D4 B0 14
		sta L_C600,X	;F9D6 9D 00 C6
		cmp L_0240,X	;F9D9 DD 40 02
		bcs L_F9E3		;F9DC B0 05
		cmp L_C500,X	;F9DE DD 00 C5
		bcs L_F9EA		;F9E1 B0 07
.L_F9E3	lda (ZP_1E),Y	;F9E3 B1 1E
.L_F9E5	and L_A400,X	;F9E5 3D 00 A4
L_F9E6	= *-2			;! self-mod!
		sta (ZP_1E),Y	;F9E8 91 1E
.L_F9EA	dey				;F9EA 88
		cpy ZP_07		;F9EB C4 07
		bcs L_F99E		;F9ED B0 AF
		tya				;F9EF 98
		sbc #$06		;F9F0 E9 06
		cmp ZP_89		;F9F2 C5 89
		bcs L_F9FC		;F9F4 B0 06
		cpy ZP_89		;F9F6 C4 89
		bcc L_FA0E		;F9F8 90 14
		lda ZP_89		;F9FA A5 89
.L_F9FC	sta ZP_07		;F9FC 85 07
		lda ZP_1E		;F9FE A5 1E
		sec				;FA00 38
		sbc #$38		;FA01 E9 38
		sta ZP_1E		;FA03 85 1E
		lda ZP_1F		;FA05 A5 1F
		sbc #$01		;FA07 E9 01
		sta ZP_1F		;FA09 85 1F
		jmp L_F99E		;FA0B 4C 9E F9
.L_FA0E	cpy #$40		;FA0E C0 40
		bcs L_FA38		;FA10 B0 26
		lda ZP_4F		;FA12 A5 4F
		cmp ZP_4E		;FA14 C5 4E
		bcs L_FA1A		;FA16 B0 02
		lda ZP_4E		;FA18 A5 4E
.L_FA1A	cmp #$C0		;FA1A C9 C0
		bcc L_FA20		;FA1C 90 02
		lda #$BF		;FA1E A9 BF
.L_FA20	sta ZP_89		;FA20 85 89
		cpx #$40		;FA22 E0 40
		bcs L_FA28		;FA24 B0 02
		ldx #$40		;FA26 A2 40
.L_FA28	inc ZP_89		;FA28 E6 89
		cpx ZP_89		;FA2A E4 89
		bcs L_FA38		;FA2C B0 0A
.L_FA2E	lda #$40		;FA2E A9 40
.L_FA30	sta L_C600,X	;FA30 9D 00 C6
L_FA32	= *-1			;! self-mod!
		inx				;FA33 E8
		cpx ZP_89		;FA34 E4 89
		bne L_FA30		;FA36 D0 F8
.L_FA38	rts				;FA38 60

.L_FA39
		cmp #$C0		;FA39 C9 C0
		bcs L_FA38		;FA3B B0 FB
		cmp #$40		;FA3D C9 40
		bcs L_FA43		;FA3F B0 02
		lda #$40		;FA41 A9 40
.L_FA43	sta ZP_89		;FA43 85 89
		lda ZP_51		;FA45 A5 51
		lsr A			;FA47 4A
		eor #$FF		;FA48 49 FF
		cpx ZP_89		;FA4A E4 89
		bcc L_FA38		;FA4C 90 EA
.L_FA4E	cpx #$C0		;FA4E E0 C0
		bcc L_FA5F		;FA50 90 0D
.L_FA52	dex				;FA52 CA
		clc				;FA53 18
		adc ZP_52		;FA54 65 52
		bcc L_FA4E		;FA56 90 F6
		sbc ZP_51		;FA58 E5 51
		dey				;FA5A 88
		cpx #$C0		;FA5B E0 C0
		bcs L_FA52		;FA5D B0 F3
.L_FA5F	cpy #$40		;FA5F C0 40
		bcs L_FA66		;FA61 B0 03
		jmp L_FB15		;FA63 4C 15 FB
.L_FA66	cpy #$C0		;FA66 C0 C0
		bcc L_FA81		;FA68 90 17
		jmp L_FA79		;FA6A 4C 79 FA
.L_FA6D	clc				;FA6D 18
		adc ZP_52		;FA6E 65 52
		bcc L_FA79		;FA70 90 07
		sbc ZP_51		;FA72 E5 51
		dey				;FA74 88
		cpy #$C0		;FA75 C0 C0
		bcc L_FA81		;FA77 90 08
.L_FA79	dex				;FA79 CA
		cpx ZP_89		;FA7A E4 89
		bcs L_FA6D		;FA7C B0 EF
		jmp L_FA38		;FA7E 4C 38 FA
.L_FA81	sta ZP_0F		;FA81 85 0F
		txa				;FA83 8A
		and #$FC		;FA84 29 FC
		cmp ZP_89		;FA86 C5 89
		bcs L_FA8C		;FA88 B0 02
		lda ZP_89		;FA8A A5 89
.L_FA8C	sta ZP_07		;FA8C 85 07
		txa				;FA8E 8A
		sec				;FA8F 38
		sbc #$40		;FA90 E9 40
		and #$7C		;FA92 29 7C
		asl A			;FA94 0A
		adc Q_pointers_LO,Y	;FA95 79 00 A5
		sta ZP_1E		;FA98 85 1E
		lda Q_pointers_HI,Y	;FA9A B9 00 A6
		adc ZP_12		;FA9D 65 12
		sta ZP_1F		;FA9F 85 1F
		jmp L_FAD8		;FAA1 4C D8 FA
.L_FAA4	lda ZP_0F		;FAA4 A5 0F
		clc				;FAA6 18
		adc ZP_52		;FAA7 65 52
		bcc L_FAD6		;FAA9 90 2B
		sbc ZP_51		;FAAB E5 51
		sta ZP_0F		;FAAD 85 0F
		tya				;FAAF 98
		dey				;FAB0 88
		and #$07		;FAB1 29 07
		bne L_FAD8		;FAB3 D0 23
		cpy #$40		;FAB5 C0 40
		bcc L_FB15		;FAB7 90 5C
		lda ZP_1E		;FAB9 A5 1E
		sbc #$38		;FABB E9 38
		sta ZP_1E		;FABD 85 1E
		lda ZP_1F		;FABF A5 1F
		sbc #$01		;FAC1 E9 01
		sta ZP_1F		;FAC3 85 1F
		jmp L_FAD8		;FAC5 4C D8 FA
;L_FAC8
		cmp L_C580,X	;FAC8 DD 80 C5
		bcc L_FAF2		;FACB 90 25
		beq L_FAF2		;FACD F0 23
		cmp L_C600,X	;FACF DD 00 C6
		bcc L_FAEB		;FAD2 90 17
		bcs L_FAF2		;FAD4 B0 1C
.L_FAD6	sta ZP_0F		;FAD6 85 0F
.L_FAD8	tya				;FAD8 98
		cmp L_C600,X	;FAD9 DD 00 C6
L_FADA	= *-2			;! self-mod!
		bcs L_FAF2		;FADC B0 14
		sta L_C600,X	;FADE 9D 00 C6
		cmp L_0240,X	;FAE1 DD 40 02
		bcs L_FAEB		;FAE4 B0 05
		cmp L_C500,X	;FAE6 DD 00 C5
		bcs L_FAF2		;FAE9 B0 07
.L_FAEB	lda (ZP_1E),Y	;FAEB B1 1E
.L_FAED	and L_A400,X	;FAED 3D 00 A4
L_FAEE	= *-2			;! self-mod!
		sta (ZP_1E),Y	;FAF0 91 1E
.L_FAF2	dex				;FAF2 CA
		cpx ZP_07		;FAF3 E4 07
		bcs L_FAA4		;FAF5 B0 AD
		txa				;FAF7 8A
		sbc #$02		;FAF8 E9 02
		cmp ZP_89		;FAFA C5 89
		bcs L_FB04		;FAFC B0 06
		cpx ZP_89		;FAFE E4 89
		bcc L_FB18		;FB00 90 16
		lda ZP_89		;FB02 A5 89
.L_FB04	sta ZP_07		;FB04 85 07
		lda ZP_1E		;FB06 A5 1E
		sec				;FB08 38
		sbc #$08		;FB09 E9 08
		sta ZP_1E		;FB0B 85 1E
		bcs L_FAA4		;FB0D B0 95
		dec ZP_1F		;FB0F C6 1F
		sec				;FB11 38
		jmp L_FAA4		;FB12 4C A4 FA
.L_FB15	jmp L_F925		;FB15 4C 25 F9
.L_FB18	rts				;FB18 60

.L_FB19	cmp #$40		;FB19 C9 40
		bcc L_FB18		;FB1B 90 FB
		cmp #$C0		;FB1D C9 C0
		bcc L_FB25		;FB1F 90 04
		lda #$C0		;FB21 A9 C0
		sbc #$01		;FB23 E9 01
.L_FB25	sta ZP_89		;FB25 85 89
		lda ZP_51		;FB27 A5 51
		lsr A			;FB29 4A
		eor #$FF		;FB2A 49 FF
		cpx ZP_89		;FB2C E4 89
		beq L_FB32		;FB2E F0 02
		bcs L_FB18		;FB30 B0 E6
.L_FB32	cpx #$40		;FB32 E0 40
		bcs L_FB42		;FB34 B0 0C
.L_FB36	inx				;FB36 E8
		adc ZP_52		;FB37 65 52
		bcc L_FB32		;FB39 90 F7
		sbc ZP_51		;FB3B E5 51
		dey				;FB3D 88
		cpx #$40		;FB3E E0 40
		bcc L_FB36		;FB40 90 F4
.L_FB42	cpy #$40		;FB42 C0 40
		bcs L_FB49		;FB44 B0 03
		jmp L_FBFB		;FB46 4C FB FB
.L_FB49	cpy #$C0		;FB49 C0 C0
		bcc L_FB66		;FB4B 90 19
		jmp L_FB5C		;FB4D 4C 5C FB
.L_FB50	clc				;FB50 18
		adc ZP_52		;FB51 65 52
		bcc L_FB5C		;FB53 90 07
		sbc ZP_51		;FB55 E5 51
		dey				;FB57 88
		cpy #$C0		;FB58 C0 C0
		bcc L_FB66		;FB5A 90 0A
.L_FB5C	inx				;FB5C E8
		cpx ZP_89		;FB5D E4 89
		bcc L_FB50		;FB5F 90 EF
		beq L_FB50		;FB61 F0 ED
		jmp L_FB18		;FB63 4C 18 FB
.L_FB66	sta ZP_0F		;FB66 85 0F
		txa				;FB68 8A
		and #$FC		;FB69 29 FC
		ora #$03		;FB6B 09 03
		cmp ZP_89		;FB6D C5 89
		bcc L_FB73		;FB6F 90 02
		lda ZP_89		;FB71 A5 89
.L_FB73	sta ZP_07		;FB73 85 07
		txa				;FB75 8A
		sec				;FB76 38
		sbc #$40		;FB77 E9 40
		and #$7C		;FB79 29 7C
		asl A			;FB7B 0A
		adc Q_pointers_LO,Y	;FB7C 79 00 A5
		sta ZP_1E		;FB7F 85 1E
		lda Q_pointers_HI,Y	;FB81 B9 00 A6
		adc ZP_12		;FB84 65 12
		sta ZP_1F		;FB86 85 1F
		jmp L_FBBF		;FB88 4C BF FB
.L_FB8B	inx				;FB8B E8
		lda ZP_0F		;FB8C A5 0F
		adc ZP_52		;FB8E 65 52
		bcc L_FBBD		;FB90 90 2B
		sbc ZP_51		;FB92 E5 51
		sta ZP_0F		;FB94 85 0F
		tya				;FB96 98
		dey				;FB97 88
		and #$07		;FB98 29 07
		bne L_FBBF		;FB9A D0 23
		cpy #$40		;FB9C C0 40
		bcc L_FBFB		;FB9E 90 5B
		lda ZP_1E		;FBA0 A5 1E
		sbc #$38		;FBA2 E9 38
		sta ZP_1E		;FBA4 85 1E
		lda ZP_1F		;FBA6 A5 1F
		sbc #$01		;FBA8 E9 01
		sta ZP_1F		;FBAA 85 1F
		jmp L_FBBF		;FBAC 4C BF FB
;L_FBAF
		cmp L_C580,X	;FBAF DD 80 C5
		bcc L_FBD9		;FBB2 90 25
		beq L_FBD9		;FBB4 F0 23
		cmp L_C600,X	;FBB6 DD 00 C6
		bcc L_FBD2		;FBB9 90 17
		bcs L_FBD9		;FBBB B0 1C
.L_FBBD	sta ZP_0F		;FBBD 85 0F
.L_FBBF	tya				;FBBF 98
		cmp L_C600,X	;FBC0 DD 00 C6
L_FBC1	= *-2			;! self-mod!
		bcs L_FBD9		;FBC3 B0 14
		sta L_C600,X	;FBC5 9D 00 C6
		cmp L_0240,X	;FBC8 DD 40 02
		bcs L_FBD2		;FBCB B0 05
		cmp L_C500,X	;FBCD DD 00 C5
		bcs L_FBD9		;FBD0 B0 07
.L_FBD2	lda (ZP_1E),Y	;FBD2 B1 1E
.L_FBD4	and L_A400,X	;FBD4 3D 00 A4
L_FBD5	= *-2			;! self-mod!
		sta (ZP_1E),Y	;FBD7 91 1E
.L_FBD9	cpx ZP_07		;FBD9 E4 07
		bcc L_FB8B		;FBDB 90 AE
		txa				;FBDD 8A
		adc #$03		;FBDE 69 03
		cmp ZP_89		;FBE0 C5 89
		bcc L_FBEA		;FBE2 90 06
		cpx ZP_89		;FBE4 E4 89
		bcs L_FC00		;FBE6 B0 18
		lda ZP_89		;FBE8 A5 89
.L_FBEA	sta ZP_07		;FBEA 85 07
		lda ZP_1E		;FBEC A5 1E
		clc				;FBEE 18
		adc #$08		;FBEF 69 08
		sta ZP_1E		;FBF1 85 1E
		bcc L_FB8B		;FBF3 90 96
		inc ZP_1F		;FBF5 E6 1F
		clc				;FBF7 18
		jmp L_FB8B		;FBF8 4C 8B FB
.L_FBFB	inc ZP_89		;FBFB E6 89
;L_FBFD
		jmp L_FA2E		;FBFD 4C 2E FA
.L_FC00	rts				;FC00 60

.set_linedraw_colour
{
		stx L_C3AB		;FC01 8E AB C3
		lda L_FC14,X	;FC04 BD 14 FC
		sta L_F8DF		;FC07 8D DF F8
		sta L_F9E6		;FC0A 8D E6 F9
		sta L_FAEE		;FC0D 8D EE FA
		sta L_FBD5		;FC10 8D D5 FB
		rts				;FC13 60
}

.L_FC14	equb $00
		equb $80

.set_linedraw_op
{
		sta L_F8DE		;FC16 8D DE F8
		sta L_F9E5		;FC19 8D E5 F9
		sta L_FAED		;FC1C 8D ED FA
		sta L_FBD4		;FC1F 8D D4 FB
		rts				;FC22 60
}

.L_FC23
{
		lda #$C6		;FC23 A9 C6
		sta L_F92B		;FC25 8D 2B F9
		sta L_FA32		;FC28 8D 32 FA
		lda #$00		;FC2B A9 00
		ldy #$11		;FC2D A0 11
		bne L_FC4E		;FC2F D0 1D
}
\\
.L_FC31
		lda #$C5		;FC31 A9 C5
		sta L_F92B		;FC33 8D 2B F9
		sta L_FA32		;FC36 8D 32 FA
		ldx #$3F		;FC39 A2 3F
.L_FC3B	lda L_C640,X	;FC3B BD 40 C6
		sta L_C540,X	;FC3E 9D 40 C5
		lda L_C680,X	;FC41 BD 80 C6
		sta L_C580,X	;FC44 9D 80 C5
		dex				;FC47 CA
		bpl L_FC3B		;FC48 10 F1
		lda #$80		;FC4A A9 80
		ldy #$2A		;FC4C A0 2A
\\
.L_FC4E
		ldx #$10		;FC4E A2 10
		sta L_C3AD		;FC50 8D AD C3
.L_FC53	lda L_FC67,Y	;FC53 B9 67 FC
		sta L_F8CB,X	;FC56 9D CB F8
		sta L_F9D2,X	;FC59 9D D2 F9
		sta L_FADA,X	;FC5C 9D DA FA
		sta L_FBC1,X	;FC5F 9D C1 FB
		dey				;FC62 88
		dex				;FC63 CA
		bpl L_FC53		;FC64 10 ED
		rts				;FC66 60
.L_FC67	cmp L_C600,X	;FC67 DD 00 C6
		bcs L_FC80		;FC6A B0 14
		sta L_C600,X	;FC6C 9D 00 C6
		cmp L_0240,X	;FC6F DD 40 02
		bcs L_FC79		;FC72 B0 05
		cmp L_C500,X	;FC74 DD 00 C5
		bcs L_FC80		;FC77 B0 07
.L_FC79	nop				;FC79 EA
		nop				;FC7A EA
		nop				;FC7B EA
		nop				;FC7C EA
		nop				;FC7D EA
		nop				;FC7E EA
		nop				;FC7F EA
.L_FC80	cmp L_0240,X	;FC80 DD 40 02
		bcc L_FC88		;FC83 90 03
		sta L_0240,X	;FC85 9D 40 02
.L_FC88	cmp L_C600,X	;FC88 DD 00 C6
		bcs L_FC99		;FC8B B0 0C
		sta L_C500,X	;FC8D 9D 00 C5
		bcs L_FC99		;FC90 B0 07
		nop				;FC92 EA
		nop				;FC93 EA
		nop				;FC94 EA
		nop				;FC95 EA
		nop				;FC96 EA
		nop				;FC97 EA
		nop				;FC98 EA
\\
.L_FC99
		jsr L_FCA2		;FC99 20 A2 FC
		lda #$E2		;FC9C A9 E2
		ldx #$0B		;FC9E A2 0B
		bne L_FCA6		;FCA0 D0 04
.L_FCA2	lda #$C5		;FCA2 A9 C5
		ldx #$09		;FCA4 A2 09
.L_FCA6	sta L_F8CB,X	;FCA6 9D CB F8
		sta L_F9D2,X	;FCA9 9D D2 F9
		sta L_FADA,X	;FCAC 9D DA FA
		sta L_FBC1,X	;FCAF 9D C1 FB
		rts				;FCB2 60

.L_FCB3
{
		ldx #$3F		;FCB3 A2 3F
.L_FCB5	lda L_0280,X	;FCB5 BD 80 02
		sta L_C5C0,X	;FCB8 9D C0 C5
		lda L_02C0,X	;FCBB BD C0 02
		sta L_C600,X	;FCBE 9D 00 C6
		dex				;FCC1 CA
		bpl L_FCB5		;FCC2 10 F1
		rts				;FCC4 60
}

.L_FCC5
		lda #$00		;FCC5 A9 00
		sta ZP_8B		;FCC7 85 8B
		sta ZP_8C		;FCC9 85 8C
		lda L_A200,Y	;FCCB B9 00 A2
		sta ZP_4F		;FCCE 85 4F
		lda L_A24C,Y	;FCD0 B9 4C A2
		sta ZP_50		;FCD3 85 50
		lda L_A298,Y	;FCD5 B9 98 A2
		sta ZP_73		;FCD8 85 73
		lda L_A2E4,Y	;FCDA B9 E4 A2
		sta ZP_74		;FCDD 85 74
		bmi L_FCE9		;FCDF 30 08
		bne L_FD01		;FCE1 D0 1E
		lda ZP_50		;FCE3 A5 50
		cmp #$40		;FCE5 C9 40
		bcs L_FD01		;FCE7 B0 18
.L_FCE9	lda ZP_73		;FCE9 A5 73
		bmi L_FCFD		;FCEB 30 10
		bne L_FCF9		;FCED D0 0A
		lda ZP_4F		;FCEF A5 4F
		cmp #$40		;FCF1 C9 40
		bcc L_FCFD		;FCF3 90 08
		cmp #$C0		;FCF5 C9 C0
		bcc L_FCFF		;FCF7 90 06
.L_FCF9	lda #$C0		;FCF9 A9 C0
		bne L_FCFF		;FCFB D0 02
.L_FCFD	lda #$3F		;FCFD A9 3F
.L_FCFF	sta ZP_8B		;FCFF 85 8B
.L_FD01	lda L_A200,X	;FD01 BD 00 A2
		sta ZP_4E		;FD04 85 4E
		lda L_A24C,X	;FD06 BD 4C A2
		sta ZP_8A		;FD09 85 8A
		lda L_A298,X	;FD0B BD 98 A2
		sta ZP_75		;FD0E 85 75
		lda L_A2E4,X	;FD10 BD E4 A2
		sta ZP_76		;FD13 85 76
		bmi L_FD1F		;FD15 30 08
		bne L_FD46		;FD17 D0 2D
		lda ZP_8A		;FD19 A5 8A
		cmp #$40		;FD1B C9 40
		bcs L_FD46		;FD1D B0 27
.L_FD1F	lda ZP_75		;FD1F A5 75
		bmi L_FD33		;FD21 30 10
		bne L_FD2F		;FD23 D0 0A
		lda ZP_4E		;FD25 A5 4E
		cmp #$40		;FD27 C9 40
		bcc L_FD33		;FD29 90 08
		cmp #$C0		;FD2B C9 C0
		bcc L_FD35		;FD2D 90 06
.L_FD2F	lda #$C0		;FD2F A9 C0
L_FD30	= *-1			;!
		bne L_FD35		;FD31 D0 02
.L_FD33	lda #$3F		;FD33 A9 3F
.L_FD35	sta ZP_8C		;FD35 85 8C
		ldx ZP_8B		;FD37 A6 8B
		beq L_FD46		;FD39 F0 0B
		cmp ZP_8B		;FD3B C5 8B
		bcc L_FD43		;FD3D 90 04
		lda ZP_8B		;FD3F A5 8B
		ldx ZP_8C		;FD41 A6 8C
.L_FD43	jmp L_F913		;FD43 4C 13 F9
.L_FD46	lda #$00		;FD46 A9 00
		sta ZP_79		;FD48 85 79
		sta ZP_7A		;FD4A 85 7A
		lda ZP_4E		;FD4C A5 4E
		sec				;FD4E 38
		sbc ZP_4F		;FD4F E5 4F
		sta ZP_51		;FD51 85 51
		sta ZP_7D		;FD53 85 7D
		lda ZP_75		;FD55 A5 75
		sbc ZP_73		;FD57 E5 73
		sta ZP_77		;FD59 85 77
		bpl L_FD6A		;FD5B 10 0D
		dec ZP_79		;FD5D C6 79
		lda #$00		;FD5F A9 00
		sec				;FD61 38
		sbc ZP_51		;FD62 E5 51
		sta ZP_7D		;FD64 85 7D
		lda #$00		;FD66 A9 00
		sbc ZP_77		;FD68 E5 77
.L_FD6A	sta ZP_7F		;FD6A 85 7F
		lda ZP_8A		;FD6C A5 8A
		sec				;FD6E 38
		sbc ZP_50		;FD6F E5 50
		sta ZP_52		;FD71 85 52
		sta ZP_7E		;FD73 85 7E
		lda ZP_76		;FD75 A5 76
		sbc ZP_74		;FD77 E5 74
		sta ZP_78		;FD79 85 78
		bpl L_FD8A		;FD7B 10 0D
		dec ZP_7A		;FD7D C6 7A
		lda #$00		;FD7F A9 00
		sec				;FD81 38
		sbc ZP_52		;FD82 E5 52
		sta ZP_7E		;FD84 85 7E
		lda #$00		;FD86 A9 00
		sbc ZP_78		;FD88 E5 78
.L_FD8A	cmp ZP_7F		;FD8A C5 7F
		bcc L_FD9A		;FD8C 90 0C
		bne L_FD96		;FD8E D0 06
		ldx ZP_7E		;FD90 A6 7E
		cpx ZP_7D		;FD92 E4 7D
		bcc L_FD9A		;FD94 90 04
.L_FD96	sta ZP_7F		;FD96 85 7F
		stx ZP_7D		;FD98 86 7D
.L_FD9A	lda #$00		;FD9A A9 00
		sta ZP_7B		;FD9C 85 7B
		sta ZP_7C		;FD9E 85 7C
		lda #$01		;FDA0 A9 01
		sta ZP_81		;FDA2 85 81
		lda ZP_7D		;FDA4 A5 7D
		ldx ZP_7F		;FDA6 A6 7F
		bne L_FDB0		;FDA8 D0 06
		cmp #$40		;FDAA C9 40
		bcs L_FDB0		;FDAC B0 02
.L_FDAE	rts				;FDAE 60
.L_FDAF	ror A			;FDAF 6A
.L_FDB0	lsr ZP_77		;FDB0 46 77
		ror ZP_51		;FDB2 66 51
		ror ZP_7B		;FDB4 66 7B
		lsr ZP_78		;FDB6 46 78
		ror ZP_52		;FDB8 66 52
		ror ZP_7C		;FDBA 66 7C
		asl ZP_81		;FDBC 06 81
		lsr ZP_7F		;FDBE 46 7F
		bne L_FDAF		;FDC0 D0 ED
		ror A			;FDC2 6A
		cmp #$40		;FDC3 C9 40
		bcs L_FDB0		;FDC5 B0 E9
		ldx ZP_81		;FDC7 A6 81
		lda #$00		;FDC9 A9 00
		sta ZP_7D		;FDCB 85 7D
		sta ZP_7E		;FDCD 85 7E
		lda ZP_74		;FDCF A5 74
		jmp L_FE18		;FDD1 4C 18 FE
.L_FDD4	lda L_C365		;FDD4 AD 65 C3
		bpl L_FDAE		;FDD7 10 D5
		lda #$3F		;FDD9 A9 3F
		ldx #$C0		;FDDB A2 C0
		bit ZP_79		;FDDD 24 79
		bpl L_FDE8		;FDDF 10 07
		stx ZP_4E		;FDE1 86 4E
		sta ZP_4F		;FDE3 85 4F
		jmp L_FE6E		;FDE5 4C 6E FE
.L_FDE8	stx ZP_4F		;FDE8 86 4F
		sta ZP_4E		;FDEA 85 4E
		jmp L_FE6E		;FDEC 4C 6E FE
.L_FDEF	lda ZP_7D		;FDEF A5 7D
		clc				;FDF1 18
		adc ZP_7B		;FDF2 65 7B
		sta ZP_7D		;FDF4 85 7D
		lda ZP_4F		;FDF6 A5 4F
		adc ZP_51		;FDF8 65 51
		sta ZP_4F		;FDFA 85 4F
		lda ZP_73		;FDFC A5 73
		adc ZP_79		;FDFE 65 79
		sta ZP_73		;FE00 85 73
		lda ZP_7E		;FE02 A5 7E
		clc				;FE04 18
		adc ZP_7C		;FE05 65 7C
		sta ZP_7E		;FE07 85 7E
		lda ZP_50		;FE09 A5 50
		adc ZP_52		;FE0B 65 52
		sta ZP_50		;FE0D 85 50
		lda ZP_74		;FE0F A5 74
		adc ZP_7A		;FE11 65 7A
		sta ZP_74		;FE13 85 74
		dex				;FE15 CA
		beq L_FDD4		;FE16 F0 BC
\\
.L_FE18	ora ZP_73		;FE18 05 73
		bne L_FDEF		;FE1A D0 D3
		lda #$00		;FE1C A9 00
		sta ZP_7D		;FE1E 85 7D
		sta ZP_7E		;FE20 85 7E
		lda ZP_76		;FE22 A5 76
		jmp L_FE50		;FE24 4C 50 FE
.L_FE27	lda ZP_7D		;FE27 A5 7D
		sec				;FE29 38
		sbc ZP_7B		;FE2A E5 7B
		sta ZP_7D		;FE2C 85 7D
		lda ZP_4E		;FE2E A5 4E
		sbc ZP_51		;FE30 E5 51
		sta ZP_4E		;FE32 85 4E
		lda ZP_75		;FE34 A5 75
		sbc ZP_79		;FE36 E5 79
		sta ZP_75		;FE38 85 75
		lda ZP_7E		;FE3A A5 7E
		sec				;FE3C 38
		sbc ZP_7C		;FE3D E5 7C
		sta ZP_7E		;FE3F 85 7E
		lda ZP_8A		;FE41 A5 8A
		sbc ZP_52		;FE43 E5 52
		sta ZP_8A		;FE45 85 8A
		lda ZP_76		;FE47 A5 76
		sbc ZP_7A		;FE49 E5 7A
		sta ZP_76		;FE4B 85 76
		dex				;FE4D CA
		beq L_FDD4		;FE4E F0 84
.L_FE50	ora ZP_75		;FE50 05 75
		bne L_FE27		;FE52 D0 D3
		jsr L_FE6E		;FE54 20 6E FE
		lda ZP_50		;FE57 A5 50
		cmp ZP_8A		;FE59 C5 8A
		bcs L_FE6B		;FE5B B0 0E
		ldx ZP_8A		;FE5D A6 8A
		sta ZP_8A		;FE5F 85 8A
		stx ZP_50		;FE61 86 50
		lda ZP_4F		;FE63 A5 4F
		ldx ZP_4E		;FE65 A6 4E
		sta ZP_4E		;FE67 85 4E
		stx ZP_4F		;FE69 86 4F
.L_FE6B	jmp L_FEF6		;FE6B 4C F6 FE
.L_FE6E	lda ZP_8B		;FE6E A5 8B
		beq L_FE7F		;FE70 F0 0D
		ldx ZP_4F		;FE72 A6 4F
		cmp ZP_4F		;FE74 C5 4F
		bcc L_FE7C		;FE76 90 04
		ldx ZP_8B		;FE78 A6 8B
		lda ZP_4F		;FE7A A5 4F
.L_FE7C	jsr L_F913		;FE7C 20 13 F9
.L_FE7F	lda ZP_8C		;FE7F A5 8C
		beq L_FE90		;FE81 F0 0D
		ldx ZP_4E		;FE83 A6 4E
		cmp ZP_4E		;FE85 C5 4E
		bcc L_FE8D		;FE87 90 04
		ldx ZP_8C		;FE89 A6 8C
		lda ZP_4E		;FE8B A5 4E
.L_FE8D	jsr L_F913		;FE8D 20 13 F9
.L_FE90	rts				;FE90 60

.L_FE91_with_draw_line
{
		lda L_A330,X	;FE91 BD 30 A3
		ora L_A330,Y	;FE94 19 30 A3
		bpl L_FE9A		;FE97 10 01
		rts				;FE99 60
.L_FE9A	lda L_A298,X	;FE9A BD 98 A2
		ora L_A298,Y	;FE9D 19 98 A2
		ora L_A2E4,X	;FEA0 1D E4 A2
		ora L_A2E4,Y	;FEA3 19 E4 A2
		beq draw_line		;FEA6 F0 21
		jmp L_FCC5		;FEA8 4C C5 FC
}

.L_FEAB_with_draw_line
{
		lda L_A200,X	;FEAB BD 00 A2
		cmp ZP_60		;FEAE C5 60
		bcs L_FEB4		;FEB0 B0 02
		sta ZP_60		;FEB2 85 60
.L_FEB4	cmp ZP_61		;FEB4 C5 61
		bcc L_FEBA		;FEB6 90 02
		sta ZP_61		;FEB8 85 61
.L_FEBA	lda L_A200,Y	;FEBA B9 00 A2
		cmp ZP_60		;FEBD C5 60
		bcs L_FEC3		;FEBF B0 02
		sta ZP_60		;FEC1 85 60
.L_FEC3	cmp ZP_61		;FEC3 C5 61
		bcc draw_line		;FEC5 90 02
		sta ZP_61		;FEC7 85 61
}
\\
.draw_line
		lda L_A24C,X	;FEC9 BD 4C A2
		cmp L_A24C,Y	;FECC D9 4C A2
		bcc L_FEE5		;FECF 90 14
		sta ZP_50		;FED1 85 50
		lda L_A24C,Y	;FED3 B9 4C A2
		sta ZP_8A		;FED6 85 8A
		lda L_A200,X	;FED8 BD 00 A2
		sta ZP_4F		;FEDB 85 4F
		lda L_A200,Y	;FEDD B9 00 A2
		sta ZP_4E		;FEE0 85 4E
		jmp L_FEF6		;FEE2 4C F6 FE
.L_FEE5	sta ZP_8A		;FEE5 85 8A
		lda L_A24C,Y	;FEE7 B9 4C A2
		sta ZP_50		;FEEA 85 50
		lda L_A200,X	;FEEC BD 00 A2
		sta ZP_4E		;FEEF 85 4E
		lda L_A200,Y	;FEF1 B9 00 A2
		sta ZP_4F		;FEF4 85 4F
\\
.L_FEF6
{
		bit L_C3AD		;FEF6 2C AD C3
		bpl L_FF32		;FEF9 10 37
		lda ZP_50		;FEFB A5 50
		cmp #$C0		;FEFD C9 C0
		bcs L_FF07		;FEFF B0 06
		lda ZP_8A		;FF01 A5 8A
		cmp #$C0		;FF03 C9 C0
		bcc L_FF32		;FF05 90 2B
.L_FF07	ldx ZP_4F		;FF07 A6 4F
		cpx ZP_4E		;FF09 E4 4E
		bcc L_FF13		;FF0B 90 06
		txa				;FF0D 8A
		ldx ZP_4E		;FF0E A6 4E
		jmp L_FF15		;FF10 4C 15 FF
.L_FF13	lda ZP_4E		;FF13 A5 4E
.L_FF15	cmp #$C0		;FF15 C9 C0
		bcc L_FF1B		;FF17 90 02
		lda #$BF		;FF19 A9 BF
.L_FF1B	clc				;FF1B 18
		adc #$01		;FF1C 69 01
		cpx #$40		;FF1E E0 40
		bcs L_FF24		;FF20 B0 02
		ldx #$40		;FF22 A2 40
.L_FF24	sta ZP_89		;FF24 85 89
		lda #$C0		;FF26 A9 C0
		bne L_FF2E		;FF28 D0 04
.L_FF2A	sta L_0240,X	;FF2A 9D 40 02
		inx				;FF2D E8
.L_FF2E	cpx ZP_89		;FF2E E4 89
		bcc L_FF2A		;FF30 90 F8
.L_FF32	lda ZP_50		;FF32 A5 50
		sec				;FF34 38
		sbc ZP_8A		;FF35 E5 8A
		sta ZP_52		;FF37 85 52
		ldx ZP_4F		;FF39 A6 4F
		ldy ZP_50		;FF3B A4 50
		lda ZP_4E		;FF3D A5 4E
		sec				;FF3F 38
		sbc ZP_4F		;FF40 E5 4F
		bcc L_FF54		;FF42 90 10
		sta ZP_51		;FF44 85 51
		cmp ZP_52		;FF46 C5 52
		bcc L_FF4F		;FF48 90 05
		lda ZP_4E		;FF4A A5 4E
		jmp L_FB19		;FF4C 4C 19 FB
.L_FF4F	lda ZP_8A		;FF4F A5 8A
		jmp L_F932		;FF51 4C 32 F9
.L_FF54	eor #$FF		;FF54 49 FF
		clc				;FF56 18
		adc #$01		;FF57 69 01
		sta ZP_51		;FF59 85 51
		cmp ZP_52		;FF5B C5 52
		bcc L_FF64		;FF5D 90 05
		lda ZP_4E		;FF5F A5 4E
		jmp L_FA39		;FF61 4C 39 FA
.L_FF64	lda ZP_8A		;FF64 A5 8A
		jmp L_F82B		;FF66 4C 2B F8
;L_FF69
		rts				;FF69 60
}

.L_FF6A
{
		lda ZP_5E		;FF6A A5 5E
		clc				;FF6C 18
		adc ZP_0C		;FF6D 65 0C
		cmp #$10		;FF6F C9 10
		bcs L_FF8C		;FF71 B0 19
		asl A			;FF73 0A
		asl A			;FF74 0A
		asl A			;FF75 0A
		asl A			;FF76 0A
		sta ZP_14		;FF77 85 14
		lda ZP_5C		;FF79 A5 5C
		clc				;FF7B 18
		adc ZP_0B		;FF7C 65 0B
		cmp #$10		;FF7E C9 10
		bcs L_FF8C		;FF80 B0 0A
		and #$0F		;FF82 29 0F
}
\\
.L_FF84
		ora ZP_14		;FF84 05 14
		tax				;FF86 AA
\\
.L_FF87	jsr find_track_segment_index		;FF87 20 5F 1E
		clc				;FF8A 18
		rts				;FF8B 60
.L_FF8C	sec				;FF8C 38
		rts				;FF8D 60

.L_FF8E
{
		sta ZP_15		;FF8E 85 15
		lda ZP_14		;FF90 A5 14
		clc				;FF92 18
		rts				;FF93 60
}

.L_FF94
{
		jsr L_9EBC		;FF94 20 BC 9E
		lda ZP_15		;FF97 A5 15
		lsr ZP_16		;FF99 46 16
		ror A			;FF9B 6A
		ror ZP_14		;FF9C 66 14
		lsr ZP_16		;FF9E 46 16
		ror A			;FFA0 6A
		ror ZP_14		;FFA1 66 14
		lsr ZP_16		;FFA3 46 16
		ror A			;FFA5 6A
		ror ZP_14		;FFA6 66 14
		sta L_07F0,X	;FFA8 9D F0 07
		lda ZP_14		;FFAB A5 14
		sta L_07EC,X	;FFAD 9D EC 07
		rts				;FFB0 60
}

.update_tyre_spritesQ
{
		ldx L_5FFF		;FFB1 AE FF 5F
		ldy L_5FFD		;FFB4 AC FD 5F
;L_FFB7				; KERNEL_READST
		bit L_0159		;FFB7 2C 59 01
;L_FFBA				; KERNEL_SETLFS
		bpl L_FFCD		;FFBA 10 11
		dex				;FFBC CA
;L_FFBD				; KERNEL_SETNAM
		cpx #$60		;FFBD E0 60
		bcs L_FFC3		;FFBF B0 02
;L_FFC0	= *-1		; KERNEL_OPEN
		ldx #$62		;FFC1 A2 62
.L_FFC3	iny				;FFC3 C8
		cpy #$68		;FFC4 C0 68
		bcc L_FFDB		;FFC6 90 13
		ldy #$65		;FFC8 A0 65
		jmp L_FFDB		;FFCA 4C DB FF
.L_FFCD	inx				;FFCD E8
		cpx #$63		;FFCE E0 63
		bcc L_FFD4		;FFD0 90 02
		ldx #$60		;FFD2 A2 60
.L_FFD4	dey				;FFD4 88
;L_FFD5				; KERNEL_LOAD
		cpy #$65		;FFD5 C0 65
		bcs L_FFDB		;FFD7 B0 02
;L_FFD8	= *-1		; KERNEL_SAVE
		ldy #$67		;FFD9 A0 67
.L_FFDB	stx L_5FFF		;FFDB 8E FF 5F
		sty L_5FFD		;FFDE 8C FD 5F
		rts				;FFE1 60
}

.L_FFE2
{
		sta L_D800,X	;FFE2 9D 00 D8
;L_FFE4	= *-1		; KERNEL_GETIN
		sta L_D900,X	;FFE5 9D 00 D9
		sta L_DA00,X	;FFE8 9D 00 DA
		sta L_DB00,X	;FFEB 9D 00 DB		; COLOR RAM
		ldy #$20		;FFEE A0 20
		sty L_0400		;FFF0 8C 00 04
		rts				;FFF3 60
}