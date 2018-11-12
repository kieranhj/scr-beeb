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
GUARD &4000

.core_start

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
		jsr jmp_L_FF8E		;097E 20 8E FF
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
		jsr jmp_L_FF8E		;09C9 20 8E FF
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
		jsr jmp_L_FF8E		;0A63 20 8E FF
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
		jsr jmp_L_FF8E		;0A82 20 8E FF
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
.L_0C5B	jsr jmp_L_EC11		;0C5B 20 11 EC
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
		jsr jmp_L_F811		;0FDC 20 11 F8
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
		jsr jmp_L_F021		;1107 20 21 F0
		jsr jmp_L_F668		;110A 20 68 F6
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
		jsr jmp_L_F021		;1125 20 21 F0
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
		jsr jmp_L_F5E9		;1156 20 E9 F5
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
		jsr jmp_L_F1DC		;1669 20 DC F1
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
		jsr jmp_L_FF6A		;168E 20 6A FF
		bcs L_16A2		;1691 B0 0F
		cmp #$FF		;1693 C9 FF
		bne L_16B4		;1695 D0 1D
		lda ZP_AF		;1697 A5 AF
		ldy ZP_B1		;1699 A4 B1
		jsr jmp_L_F117		;169B 20 17 F1
		cmp #$FF		;169E C9 FF
		bne L_16B4		;16A0 D0 12
.L_16A2	lda #$C0		;16A2 A9 C0
		sta ZP_6B		;16A4 85 6B
		lda L_C76C		;16A6 AD 6C C7
		bpl L_16B1		;16A9 10 06
		jsr update_aicar		;16AB 20 85 1E
		jsr jmp_L_E4DA		;16AE 20 DA E4
.L_16B1	jmp L_1757		;16B1 4C 57 17
.L_16B4	sta ZP_2E		;16B4 85 2E
		jsr L_9A38		;16B6 20 38 9A
		jsr jmp_L_F2B7		;16B9 20 B7 F2
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
		jsr jmp_L_F585		;16D9 20 85 F5
		jsr L_1D25		;16DC 20 25 1D
		jsr jmp_L_E4DA		;16DF 20 DA E4
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
		jsr jmp_L_E195		;1701 20 95 E1
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
		jsr jmp_get_track_segment_detailsQ		;177F 20 2F F0
		ldx ZP_2E		;1782 A6 2E
		jsr jmp_L_F0C5		;1784 20 C5 F0
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
		jsr jmp_L_F440		;17C5 20 40 F4
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
.L_1A65	jsr jmp_set_linedraw_colour		;1A65 20 01 FC
		lda ZP_C6		;1A68 A5 C6
		lsr A			;1A6A 4A
		sec				;1A6B 38
		sbc #$01		;1A6C E9 01
		cmp ZP_A3		;1A6E C5 A3
		bne L_1A7B		;1A70 D0 09
		lda ZP_A6		;1A72 A5 A6
		cmp ZP_2E		;1A74 C5 2E
		bne L_1A7B		;1A76 D0 03
		jsr jmp_L_E195		;1A78 20 95 E1
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
		jsr jmp_L_E1B1		;1AB7 20 B1 E1
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
		jsr jmp_set_linedraw_colour		;1AD7 20 01 FC
		jsr L_CF73		;1ADA 20 73 CF
		ldx ZP_C6		;1ADD A6 C6
		txa				;1ADF 8A
		eor #$01		;1AE0 49 01
		tay				;1AE2 A8
		jsr jmp_L_FE91_with_draw_line		;1AE3 20 91 FE
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
		jmp jmp_L_FE91_with_draw_line		;1AFF 4C 91 FE
}

.L_1B02
{
		ldx ZP_C6		;1B02 A6 C6
		txa				;1B04 8A
		ora #$20		;1B05 09 20
		tay				;1B07 A8
		jmp jmp_L_FE91_with_draw_line		;1B08 4C 91 FE
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
		jsr jmp_L_E808		;1B45 20 08 E8
		ldx ZP_C7		;1B48 A6 C7
		ldy #$04		;1B4A A0 04
		lda ZP_8D		;1B4C A5 8D
		jsr jmp_L_E631		;1B4E 20 31 E6
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
		jsr jmp_L_E641		;1B80 20 41 E6
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
		jsr jmp_check_game_keys		;1C64 20 9E F7
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
		jsr jmp_update_boosting		;1CC7 20 0F F6
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
		jsr jmp_set_linedraw_op		;1D05 20 16 FC
		ldx #$02		;1D08 A2 02
		ldy #$03		;1D0A A0 03
		jsr jmp_L_FE91_with_draw_line		;1D0C 20 91 FE
		lda #$3D		;1D0F A9 3D
		jsr jmp_set_linedraw_op		;1D11 20 16 FC
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
		jsr jmp_get_track_segment_detailsQ		;1E8D 20 2F F0
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
		jsr jmp_L_FF8E		;1EAC 20 8E FF
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
		jsr jmp_L_E4DA		;1EE2 20 DA E4
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
.L_2009	jsr jmp_L_FF8E		;2009 20 8E FF
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
		jsr jmp_L_FF8E		;22E4 20 8E FF
		adc L_07DC,X	;22E7 7D DC 07
		sta L_07DC,X	;22EA 9D DC 07
		sta ZP_14		;22ED 85 14
		lda L_07E0,X	;22EF BD E0 07
		adc ZP_15		;22F2 65 15
		sta L_07E0,X	;22F4 9D E0 07
		jsr jmp_L_FF8E		;22F7 20 8E FF
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
		jsr jmp_set_linedraw_colour		;29FA 20 01 FC
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
		jsr jmp_draw_line		;2A26 20 C9 FE
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
		jsr jmp_L_EDAB		;2AF4 20 AB ED
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
		jsr jmp_L_FF84		;2B35 20 84 FF
		jsr jmp_L_FF87		;2B38 20 87 FF
		ldx #$1F		;2B3B A2 1F
.L_2B3D	lda KERNEL_RAM_VECTORS,X	;2B3D BD 30 FD
		sta L_0314,X	;2B40 9D 14 03
		dex				;2B43 CA
		bpl L_2B3D		;2B44 10 F7
		jsr jmp_L_E544		;2B46 20 44 E5

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
		jsr jmp_get_track_segment_detailsQ		;2DC7 20 2F F0
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
		jsr jmp_get_track_segment_detailsQ		;2E1E 20 2F F0
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
		jsr jmp_do_menu_screen		;3060 20 36 EE
		cmp #$00		;3063 C9 00
		bne L_307D		;3065 D0 16
		jsr jmp_get_entered_name		;3067 20 7F ED
		jmp L_308C		;306A 4C 8C 30
.L_306D	lda #$00		;306D A9 00
		ldy #$01		;306F A0 01
		ldx #$14		;3071 A2 14
		jsr jmp_do_menu_screen		;3073 20 36 EE
		cmp #$00		;3076 C9 00
		bne L_3087		;3078 D0 0D
		inc L_31A1		;307A EE A1 31
.L_307D	jsr jmp_get_entered_name		;307D 20 7F ED
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
		jsr jmp_L_E9A3		;3092 20 A3 E9
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
		jsr jmp_L_E8C2		;3626 20 C2 E8
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
		jsr jmp_check_game_keys		;3696 20 9E F7
		and #$10		;3699 29 10
		bne debounce_fire_and_wait_for_fire		;369B D0 F9
		ldy #$05		;369D A0 05
		jsr delay_approx_Y_25ths_sec		;369F 20 EB 3F
.L_36A2	jsr jmp_check_game_keys		;36A2 20 9E F7
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
		jsr jmp_L_E8E5		;373A 20 E5 E8
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
		jsr jmp_L_E8C2		;3768 20 C2 E8
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
.L_37D3	jsr jmp_L_E8C2		;37D3 20 C2 E8
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
		jsr jmp_L_E85B		;3B36 20 5B E8
		jsr set_up_screen_for_frontend		;3B39 20 04 35
		jsr do_initial_screen		;3B3C 20 52 30
		jsr L_36AD		;3B3F 20 AD 36
		jsr save_rndQ_stateQ		;3B42 20 2C 16

.L_3B45	lsr L_C304		;3B45 4E 04 C3
		jsr jmp_do_main_menu_dwim		;3B48 20 3A EF
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
		jsr jmp_L_E8E5		;3B8B 20 E5 E8
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

.L_3BA7	jsr jmp_L_E87F		;3BA7 20 7F E8
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
		jsr jmp_L_E87F		;3BD7 20 7F E8
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
		jsr jmp_prepare_trackQ		;3C6B 20 34 EA
		jsr update_per_track_stuff		;3C6E 20 18 1D
		jsr jmp_L_F386		;3C71 20 86 F3

.L_3C74	ldx #$27		;3C74 A2 27
		lda #$3B		;3C76 A9 3B
.L_3C78	sta L_7FC0,X	;3C78 9D C0 7F
		dex				;3C7B CA
		bpl L_3C78		;3C7C 10 FA
		
		ldx #$2C		;3C7E A2 2C
		jsr print_msg_4		;3C80 20 27 30
		jsr track_preview_check_keys		;3C83 20 DE CF
		bcc L_3C8E		;3C86 90 06
		jsr jmp_L_F386		;3C88 20 86 F3
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
		jsr jmp_L_F488		;3CC6 20 88 F4
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
		jsr jmp_L_E104		;3D0E 20 04 E1
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
		jsr jmp_L_E0F9_with_sysctl		;3D8C 20 F9 E0
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
		jsr jmp_L_E0F9_with_sysctl		;3DC2 20 F9 E0
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
		jsr jmp_L_E0F9_with_sysctl		;3E74 20 F9 E0
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
.L_3EDD	jmp jmp_L_F6A6		;3EDD 4C A6 F6
}

.update_pause_status
{
		lda L_C306		;3EE0 AD 06 C3
		bpl L_3EEC		;3EE3 10 07
		ldx #$0D		;3EE5 A2 0D
		jsr poll_key_with_sysctl		;3EE7 20 C9 C7
		beq L_3EED		;3EEA F0 01
.L_3EEC	rts				;3EEC 60

.L_3EED	jsr jmp_L_E0F9_with_sysctl		;3EED 20 F9 E0
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
		jsr jmp_L_E104		;3F31 20 04 E1
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

.core_end

; *****************************************************************************
\\ Core RAM area
; *****************************************************************************

PRINT "--------"
PRINT "CORE RAM"
PRINT "--------"
PRINT "Start =", ~core_start
PRINT "End =", ~core_end
PRINT "Size =", ~(core_end - core_start)
PRINT "Entry =", ~scr_entry

SAVE "Core", core_start, core_end, scr_entry
PRINT "--------"
