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

.kernel_start

; *****************************************************************************
\\ Code moved from Core RAM so data can reside there
; *****************************************************************************

.L_0800_with_VIC
{
	 	jsr L_FF90
;L_0803
		lda #$15		;0803 A9 15
		sta VIC_VMCSB		;0805 8D 18 D0			; VIC - not bitmap mode?
		lda #$80		;0808 A9 80
		sta L_0291		;080A 8D 91 02
		lda #$00		;080D A9 00
		sta ZP_9D		;080F 85 9D
		lda #$1B		;0811 A9 1B
		sta VIC_SCROLY		;0813 8D 11 D0			; VIC
		rts				;0816 60
}

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
		jsr cart_update_camera_roll_tables		;088B 20 26 27
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

.integrate_plcar		\\ only called from game_update
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

.L_0A55	equb $2C,$0A
.L_0A57	equb $D3,$F5
}

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

; only called from game update
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
		lda current_track		;0C26 AD 7D C7
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

.L_0D60		; in kernel
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

.L_0DCD			; in kernel
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

.L_0E73			; in kernel
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

.L_0F12			; in kernel
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
		lda cosine_conversion_table,X	;0F24 BD 80 B0
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

.L_0F72			; called mostly from cart
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

.L_0F9C			; in kernel
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

.L_0FAD			; in kernel
{
		cpx #$00		;0FAD E0 00
		bne L_0FB5		;0FAF D0 04
		bit ZP_6B		;0FB1 24 6B
		bvs L_0FC7		;0FB3 70 12
.L_0FB5	lda L_C374,X	;0FB5 BD 74 C3
		ldy L_C376,X	;0FB8 BC 76 C3
		bpl L_0FC8		;0FBB 10 0B
		cmp half_a_lap_section		;0FBD CD 67 C7
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
;.L_1010
		ror A			;1010 6A
		sta L_C395		;1011 8D 95 C3
		beq L_101D		;1014 F0 07
		lda #$00		;1016 A9 00
		sta ZP_82		;1018 85 82
		jsr L_0F9C		;101A 20 9C 0F
.L_101D	jmp L_1090		;101D 4C 90 10
}

.L_1020			; in kernel
{
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
}

.L_1078			; in kernel
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

.L_1090
{
		lda #$00		;1090 A9 00
		sta L_82B0,X	;1092 9D B0 82
		sta L_8298,X	;1095 9D 98 82
		sta L_8398,X	;1098 9D 98 83
		rts				;109B 60
}

.L_109C			; in kernel
		lda #$14		;109C A9 14
.L_109E			; in kernel
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
		jsr cart_update_damage_display		;10EF 20 88 1B
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

.L_1144_with_color_ram		; in kernel
		ldy #$0B		;1144 A0 0B
		lda L_C395		;1146 AD 95 C3
		bne L_114D_with_color_ram		;1149 D0 02
		ldy #$07		;114B A0 07
.L_114D_with_color_ram
		sty L_DBDA		;114D 8C DA DB		; COLOR RAM
		sty L_DBDB		;1150 8C DB DB		; COLOR RAM
		rts				;1153 60

.L_1154_with_color_ram		; in kernel
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
		jmp cart_sysctl		;121C 4C 25 87
}

; Something to do with plotting the dashboard sprite?

.L_121F			; in kernel
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

}

.L_1411				; only called from Kernel?
{
		lda L_3FFA,X	;1411 BD FA 3F
		ora #$80		;1414 09 80
		sta L_3FFA,X	;1416 9D FA 3F
		lda L_3FF1,X	;1419 BD F1 3F
		ora #$80		;141C 09 80
		sta L_3FF1,X	;141E 9D F1 3F
		rts				;1421 60
}

.L_1422				; only called from Kernel?
		ldy #$00		;1422 A0 00
		beq L_1430		;1424 F0 0A

.L_1426				; only called from Kernel?
		ldy #$80		;1426 A0 80
		bne L_1430		;1428 D0 06

.L_142A				; only called from Kernel?
		ldy #$C0		;142A A0 C0
		bne L_1430		;142C D0 02

.L_142E				; only called from Kernel?
		ldy #$40		;142E A0 40

.L_1430				; not an entry point
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

.L_1469				; only called from Kernel?
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
		adc #LO(L_7FC0)		;1478 69 C0
		sta ZP_1E		;147A 85 1E
		lda ZP_14		;147C A5 14
		adc #HI(L_7FC0)		;147E 69 7F
		sta ZP_1F		;1480 85 1F
		iny				;1482 C8
		rts				;1483 60
}

.find_track_segment_index		; only called from Kernel?
{
		stx L_1E84		;1E5F 8E 84 1E
		txa				;1E62 8A
		ldx L_C374		;1E63 AE 74 C3
		cpx number_of_road_sections		;1E66 EC 64 C7
		bcs L_1E7D		;1E69 B0 12
.L_1E6B	cmp road_section_xz_positions,X	;1E6B DD 4E 04
		beq L_1E7F		;1E6E F0 0F
		inx				;1E70 E8
		cpx number_of_road_sections		;1E71 EC 64 C7
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

.L_1F06				; only called from Kernel?
{
		lda L_31A1		;1F06 AD A1 31
		beq L_1F10		;1F09 F0 05
		lda L_C77F		;1F0B AD 7F C7
		bne L_1F47		;1F0E D0 37
.L_1F10	ldx #$00		;1F10 A2 00
.L_1F12	jsr rndQ		;1F12 20 B9 29
		dex				;1F15 CA
		bne L_1F12		;1F16 D0 FA
		lda current_track		;1F18 AD 7D C7
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

.L_2176				; only called from Kernel?
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
		jsr cart_write_file_string		;2AD1 20 E2 95
		lda L_0840		;2AD4 AD 40 08
		clc				;2AD7 18
		adc #$09		;2AD8 69 09
		tay				;2ADA A8
		ldx file_strings_offset,Y	;2ADB BE 2A 95
		jsr cart_write_file_string		;2ADE 20 E2 95
		jsr debounce_fire_and_wait_for_fire		;2AE1 20 96 36
		ldx #$99		;2AE4 A2 99
		jsr cart_write_file_string		;2AE6 20 E2 95
.L_2AE9	ldx #$94		;2AE9 A2 94
		jsr cart_print_msg_2		;2AEB 20 CB A1
		ldx #$78		;2AEE A2 78
		ldy #$D5		;2AF0 A0 D5
		lda #$C0		;2AF2 A9 C0
		jsr L_EDAB		;2AF4 20 AB ED
		bit L_EE35		;2AF7 2C 35 EE
		bpl L_2AFD		;2AFA 10 01
		rts				;2AFC 60
.L_2AFD	jsr cart_L_9448		;2AFD 20 48 94
		bcs L_2AE9		;2B00 B0 E7
		jsr L_361F		;2B02 20 1F 36
		jsr cart_save_rndQ_stateQ		;2B05 20 2C 16
		lda #$00		;2B08 A9 00
		jsr L_3FBB_with_VIC		;2B0A 20 BB 3F
		lda #$01		;2B0D A9 01
		jsr cart_L_93A8		;2B0F 20 A8 93
		ldx #$00		;2B12 A2 00
		lda #$20		;2B14 A9 20
.L_2B16	sta road_section_angle_and_piece,X	;2B16 9D 00 04
		sta L_04FA,X	;2B19 9D FA 04
		sta L_05F4,X	;2B1C 9D F4 05
		sta L_06EE,X	;2B1F 9D EE 06
		inx				;2B22 E8
		cpx #$FA		;2B23 E0 FA
		bne L_2B16		;2B25 D0 EF

		lda #C64_VIC_IRQ_DISABLE		;2B27 A9 00
		sta VIC_IRQMASK		;2B29 8D 1A D0		; VIC

		sei				;2B2C 78
		lda L_A000		;2B2D AD 00 A0
		pha				;2B30 48
		lda #C64_IO_AND_KERNAL		;2B31 A9 36
		sta RAM_SELECT		;2B33 85 01
		jsr L_FF84		;2B35 20 84 FF
		jsr L_FF87		;2B38 20 87 FF
		ldx #$1F		;2B3B A2 1F
.L_2B3D	lda KERNEL_RAM_VECTORS,X	;2B3D BD 30 FD
		sta L_0314,X	;2B40 9D 14 03
		dex				;2B43 CA
		bpl L_2B3D		;2B44 10 F7
		jsr L_E544		;2B46 20 44 E5

		lda #$C0		;2B49 A9 C0
		sta VIC_EXTCOL		;2B4B 8D 20 D0		; VIC
		sta VIC_BGCOL0		;2B4E 8D 21 D0		; VIC

		jsr L_0800_with_VIC		;2B51 20 00 08
		lda #C64_IO_AND_KERNAL		;2B54 A9 36
		sta RAM_SELECT		;2B56 85 01
		cli				;2B58 58
;L_2B59
		lda #$47		;2B59 A9 47
;L_2B5A	= *-1			;! _SELF_MOD
;L_2B5B
		ldx #$00		;2B5B A2 00
		jsr cart_sysctl		;2B5D 20 25 87
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
		jsr cart_sysctl		;2B7F 20 25 87
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
		jsr cart_sysctl		;2BE0 20 25 87
.L_2BE3	pla				;2BE3 68
		sta L_A000		;2BE4 8D 00 A0
		ldy #$4B		;2BE7 A0 4B
		jsr delay_approx_Y_25ths_sec		;2BE9 20 EB 3F
		lda #C64_IO_NO_KERNAL		;2BEC A9 35
		sta RAM_SELECT		;2BEE 85 01
		bit L_C301		;2BF0 2C 01 C3
		bpl L_2BFC		;2BF3 10 07
		lda #$80		;2BF5 A9 80
		sta L_C39A		;2BF7 8D 9A C3
		bne L_2C04		;2BFA D0 08
.L_2BFC	lda L_C367		;2BFC AD 67 C3
		bpl L_2C04		;2BFF 10 03
		jsr cart_L_95EA		;2C01 20 EA 95
.L_2C04	jsr L_3FBE_with_VIC		;2C04 20 BE 3F
		sei				;2C07 78
		lda #$2B		;2C08 A9 2B
		sta VIC_SCROLY		;2C0A 8D 11 D0		; VIC
		jsr set_up_single_page_display		;2C0D 20 8B 3F
		cli				;2C10 58
		lda #C64_VIC_IRQ_RASTERCMP		;2C11 A9 01
		sta VIC_IRQMASK		;2C13 8D 1A D0		; VIC
		lda #$00		;2C16 A9 00
		jsr cart_L_93A8		;2C18 20 A8 93
		ldy #$09		;2C1B A0 09
		jsr cart_L_1637		;2C1D 20 37 16
		rts				;2C20 60

.L_2C21	equb $01,$08	;2C21 01 08
}

; only called from game update (move to kernel?)
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

; only called from game update (move to kernel?)
.L_2DC2_from_game_update
{
		ldx L_C374		;2DC2 AE 74 C3
		stx ZP_2E		;2DC5 86 2E
		jsr fetch_near_section_stuff		;2DC7 20 2F F0
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
		jsr fetch_near_section_stuff		;2E1E 20 2F F0
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

.L_2EFD	equb $00,$D9,$27
.L_2F00	equb $00,$00,$FF
}

.select_track
{
		tax				;302F AA
		lda track_order,X	;3030 BD 28 37
		sta current_track		;3033 8D 7D C7
		lda L_C71A		;3036 AD 1A C7
		beq L_303F		;3039 F0 04
		txa				;303B 8A
		eor #$01		;303C 49 01
		tax				;303E AA
.L_303F	lda track_background_colours,X	;303F BD 30 37
		sta L_C76B		;3042 8D 6B C7
		rts				;3045 60
}

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

.L_36AA	jmp cart_L_3626_from_game_start		;36AA 4C 26 36

.L_36AD_from_game_start
{
		lda L_31A1		;36AD AD A1 31
		bne L_36AA		;36B0 D0 F8
		lda #$80		;36B2 A9 80
		sta L_C356		;36B4 8D 56 C3
		jsr cart_clear_menu_area		;36B7 20 23 1C
		jsr cart_menu_colour_map_stuff		;36BA 20 C4 38
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
		jsr cart_set_text_cursor		;36E5 20 6B 10
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

\\ Unreachable code?	; set up double page display?
.L_3F84	ldy #C64_VIC_BITMAP_SCREEN2		;3F84 A0 78
		ldx #$00		;3F86 A2 00
		jmp L_3F8F		;3F88 4C 8F 3F

.set_up_single_page_display
		ldy #C64_VIC_BITMAP_SCREEN1		;3F8B A0 70
		ldx #$80		;3F8D A2 80
.L_3F8F	sty ZP_14		;3F8F 84 14
		php				;3F91 08
		sei				;3F92 78
		sty VIC_VMCSB		;3F93 8C 18 D0
		stx screen_buffer_current		;3F96 8E 5F C3
		stx screen_buffer_next_vsync		;3F99 8E 70 C3
		plp				;3F9C 28
		rts				;3F9D 60


; *****************************************************************************
\\ Code moved from Cart RAM because it is only used by Kernel fns
; *****************************************************************************

.L_92A2				; only called from Kernel?
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

.L_9300			; only called from fn above L_92A2
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

.L_94D7				; only called from Kernel?
{
		lda L_C39A		;94D7 AD 9A C3
		bmi L_94E1		;94DA 30 05
		lda L_C367		;94DC AD 67 C3
		bmi L_9526		;94DF 30 45
.L_94E1	jsr L_3500_with_VIC		;94E1 20 00 35
		jsr set_up_screen_for_frontend		;94E4 20 04 35
		lda #$01		;94E7 A9 01
		sta ZP_19		;94E9 85 19
		jsr L_3858		;94EB 20 58 38
		ldx #$0C		;94EE A2 0C
		jsr print_driver_name		;94F0 20 8B 38
		lda L_C39A		;94F3 AD 9A C3
		bpl L_94FD		;94F6 10 05
		ldx #$00		;94F8 A2 00
		jsr cart_write_file_string		;94FA 20 E2 95
.L_94FD	ldy L_C77B		;94FD AC 7B C7
		ldx file_strings_offset,Y	;9500 BE 2A 95
		jsr cart_write_file_string		;9503 20 E2 95
		lda L_C39A		;9506 AD 9A C3
		bpl L_951D		;9509 10 12
		jsr L_3858		;950B 20 58 38
		lda L_C39A		;950E AD 9A C3
		clc				;9511 18
		adc #$02		;9512 69 02
		and #$07		;9514 29 07
		tay				;9516 A8
		ldx file_strings_offset,Y	;9517 BE 2A 95
		jsr cart_write_file_string		;951A 20 E2 95
.L_951D	jsr ensure_screen_enabled		;951D 20 9E 3F
		jsr debounce_fire_and_wait_for_fire		;9520 20 96 36
		jsr L_361F		;9523 20 1F 36
.L_9526	lda L_C39A		;9526 AD 9A C3
		rts				;9529 60
}

.do_practice_menu			; only called from Kernel?
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

.do_hall_of_fame_screen		; only called from Kernel?
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
		lda #C64_IO_NO_KERNAL		;98F5 A9 35
		sta RAM_SELECT		;98F7 85 01
		cli				;98F9 58
		lda #$01		;98FA A9 01
		jsr cart_sysctl		;98FC 20 25 87
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
		jsr cart_print_msg_1		;994A 20 A5 32
		lda L_C71A		;994D AD 1A C7
		beq L_9957		;9950 F0 05
		ldx #$4B		;9952 A2 4B
		jsr cart_print_msg_1		;9954 20 A5 32
.L_9957	ldx #$5B		;9957 A2 5B
		jsr cart_print_msg_1		;9959 20 A5 32
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
		jsr cart_set_text_cursor		;996C 20 6B 10
		lda ZP_19		;996F A5 19
		asl A			;9971 0A
		tax				;9972 AA
		lda #$01		;9973 A9 01
		sta L_C3D9		;9975 8D D9 C3
		lda track_initials,X	;9978 BD EF 99
		jsr cart_write_char		;997B 20 6F 84
		lda track_initials+1,X	;997E BD F0 99
		jsr cart_write_char		;9981 20 6F 84
		jsr cart_print_space		;9984 20 AF 91
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
		jsr cart_write_char		;999E 20 6F 84
		inx				;99A1 E8
		dey				;99A2 88
		bne L_999B		;99A3 D0 F6
		jsr cart_print_space		;99A5 20 AF 91
		dec L_C3D9		;99A8 CE D9 C3
		lda L_0400,X	;99AB BD 00 04
		sta L_8398		;99AE 8D 98 83
		lda L_0401,X	;99B1 BD 01 04
		sta L_82B0		;99B4 8D B0 82
		lda L_0402,X	;99B7 BD 02 04
		sta L_8298		;99BA 8D 98 82
		ldx #$00		;99BD A2 00
		jsr cart_print_lap_time_Q		;99BF 20 FF 99
		lda ZP_08		;99C2 A5 08
		eor #$80		;99C4 49 80
		sta ZP_08		;99C6 85 08
		bpl L_99D5		;99C8 10 0B
		jsr cart_print_2space		;99CA 20 AA 91
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

.track_initials
		equs "LRHBSSBRHJRCSJDB"
		;equb $4C
		;equb $52,$48
		;equb $42,$53,$53,$42,$52,$48,$4A,$52,$43,$53,$4A,$44,$42
}

; only called from game update
.L_9CBA_from_game_update		; in Kernel
{
		ldx L_C374		;9CBA AE 74 C3
		stx ZP_2E		;9CBD 86 2E
		jsr fetch_near_section_stuff		;9CBF 20 2F F0
		lda #$00		;9CC2 A9 00
		sta L_C359		;9CC4 8D 59 C3
		ldx #$02		;9CC7 A2 02
.L_9CC9	stx ZP_52		;9CC9 86 52
		lda L_C374		;9CCB AD 74 C3
		cmp ZP_2E		;9CCE C5 2E
		beq L_9CDA		;9CD0 F0 08
		tax				;9CD2 AA
		stx ZP_2E		;9CD3 86 2E
		jsr fetch_near_section_stuff		;9CD5 20 2F F0
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
		jsr cart_L_9C14		;9D9E 20 14 9C
		sta ZP_48		;9DA1 85 48
		lda ZP_15		;9DA3 A5 15
		lsr A			;9DA5 4A
		lsr A			;9DA6 4A
		lsr A			;9DA7 4A
		lsr A			;9DA8 4A
		lsr A			;9DA9 4A
		sta ZP_5B		;9DAA 85 5B
		inx				;9DAC E8
		jsr cart_L_9C14		;9DAD 20 14 9C
		sta ZP_49		;9DB0 85 49
		inx				;9DB2 E8
		jsr cart_L_9C14		;9DB3 20 14 9C
		sta ZP_4A		;9DB6 85 4A
		lda ZP_15		;9DB8 A5 15
		lsr A			;9DBA 4A
		lsr A			;9DBB 4A
		lsr A			;9DBC 4A
		lsr A			;9DBD 4A
		lsr A			;9DBE 4A
		sta ZP_DC		;9DBF 85 DC
		inx				;9DC1 E8
		jsr cart_L_9C14		;9DC2 20 14 9C
		sta ZP_4B		;9DC5 85 4B
		jmp L_9DFC		;9DC7 4C FC 9D
.L_9DCA	lda ZP_9E		;9DCA A5 9E
		sec				;9DCC 38
		sbc ZP_C0		;9DCD E5 C0
		sec				;9DCF 38
		sbc #$04		;9DD0 E9 04
		tax				;9DD2 AA
		jsr cart_L_9C14		;9DD3 20 14 9C
		sta ZP_4B		;9DD6 85 4B
		inx				;9DD8 E8
		jsr cart_L_9C14		;9DD9 20 14 9C
		sta ZP_4A		;9DDC 85 4A
		lda ZP_15		;9DDE A5 15
		lsr A			;9DE0 4A
		lsr A			;9DE1 4A
		lsr A			;9DE2 4A
		lsr A			;9DE3 4A
		lsr A			;9DE4 4A
		sta ZP_DC		;9DE5 85 DC
		inx				;9DE7 E8
		jsr cart_L_9C14		;9DE8 20 14 9C
		sta ZP_49		;9DEB 85 49
		inx				;9DED E8
		jsr cart_L_9C14		;9DEE 20 14 9C
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

.L_9E74				; in Kernel
{
		lda ZP_BF		;9E74 A5 BF
		eor ZP_A4		;9E76 45 A4
		bpl L_9E86		;9E78 10 0C
		jsr L_CFD2		;9E7A 20 D2 CF
		jsr fetch_near_section_stuff		;9E7D 20 2F F0
		lda ZP_A4		;9E80 A5 A4
		bpl L_9E9A		;9E82 10 16
		bmi L_9E90		;9E84 30 0A
.L_9E86	jsr L_CFC5		;9E86 20 C5 CF
		jsr fetch_near_section_stuff		;9E89 20 2F F0
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

.L_9F6A				; in Kernel
{
		jsr cart_L_9EBC		;9F6A 20 BC 9E
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

.L_A0B6				; in Cart
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

.calculate_camera_sines		; only called from Kernel?
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

; *****************************************************************************
\\ Code moved from Hazel RAM so data can reside there
; *****************************************************************************

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

; get sin and cos.
; 
; entry: byte_14=angle LSB, A=angle MSB
; exit: sincos_sin, sincos_cos, sincos_sign_flag, sincos_angle

.sincos			; in kernel
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

.mul_8_16_16bit_from_state	; in kernel
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

.accurate_sin		; only called from Cart?
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
.L_C8EE	lda L_AD00+1,X	;C8EE BD 01 AD
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
		sbc cosine_table+1,X	;C90C FD 01 A7
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
.get_one_third_of_state_value		; in kernel
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

.update_state		; in kernel
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
.multiply_and_store_in_state		; in kernel
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
.store_fixed_up_sincos_in_state			; in kernel
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

.multiply_and_store_abs_in_state		; in kernel
		jsr multiply_and_store_in_state		;CC17 20 D8 CB

; set state value to its absolute.
; 
; entry: X	= index	of state value.

.abs_state			; in kernel
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

.calculate_friction_and_gravity			; in kernel
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

.L_CD5C			; in kernel
{
		lsr A			;CD5C 4A
		bcc L_CD72		;CD5D 90 13
		lda VIC_RASTER		;CD5F AD 12 D0
		cmp #$72		;CD62 C9 72
		bcs L_CD84		;CD64 B0 1E
		lda VIC_SCROLX		;CD66 AD 16 D0
		ora #$10		;CD69 09 10			; VIC multicolour_mode
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
		and #$EF		;CD87 29 EF			; VIC non_multicolour_mode
		sta VIC_SCROLX		;CD89 8D 16 D0
		lda #$28		;CD8C A9 28
		bne L_CD9F		;CD8E D0 0F
.L_CD90	lda VIC_SCROLX		;CD90 AD 16 D0
		ora #$10		;CD93 09 10
		sta VIC_SCROLX		;CD95 8D 16 D0
		lda #$00		;CD98 A9 00
		sta VIC_BGCOL0		;CD9A 8D 21 D0
		lda #$CE		;CD9D A9 CE
.L_CD9F	jmp set_raster_interrupt_line		;CD9F 4C 49 CF
}

; *****************************************************************************
; C64 Interrupt Handler
; *****************************************************************************

.irq_handler_done
		lda CIA1_CIAICR		;CDA2 AD 0D DC
		lda CIA2_C2DDRA		;CDA5 AD 0D DD
.irq_handler_return
		pla				;CDA8 68
		rti				;CDA9 40

.irq_handler		; C64 game init sets IRQ/BRK vector to $CDAA
		sei				;CDAA 78
		pha				;CDAB 48
		lda VIC_VICIRQ		;CDAC AD 19 D0
		bpl irq_handler_done		;CDAF 10 F1

		lda #$01		;CDB1 A9 01
		sta VIC_VICIRQ		;CDB3 8D 19 D0

		lda L_3DF8		;CDB6 AD F8 3D
		beq irq_handler_return		;CDB9 F0 ED
		bpl L_CD5C		;CDBB 10 9F

		lda VIC_RASTER		;CDBD AD 12 D0
		bpl L_CDC5		;CDC0 10 03
		jmp L_CEA1		;CDC2 4C A1 CE

.L_CDC5	lda L_C37A		;CDC5 AD 7A C3
		beq L_CDD0		;CDC8 F0 06
		lda screen_buffer_current		;CDCA AD 5F C3
		jmp L_CDD6		;CDCD 4C D6 CD

.L_CDD0	lda screen_buffer_next_vsync		;CDD0 AD 70 C3
		sta screen_buffer_current		;CDD3 8D 5F C3

.L_CDD6	bpl L_CDE0		;CDD6 10 08
		lda #C64_VIC_BITMAP_SCREEN1		;CDD8 A9 70		; BEEB SELECT SCREEN BUFFER
		sta VIC_VMCSB		;CDDA 8D 18 D0
		jmp L_CE1B		;CDDD 4C 1B CE

.L_CDE0	lda #C64_VIC_BITMAP_SCREEN2		;CDE0 A9 78		; BEEB SELECT SCREEN BUFFER
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
		sta vic_sprite_ptr0		;CE0E 8D F8 5F
		lda #$FF		;CE11 A9 FF
		sta vic_sprite_ptr1		;CE13 8D F9 5F
		lda #$64		;CE16 A9 64
		jmp set_raster_interrupt_line		;CE18 4C 49 CF

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
		sta vic_sprite_ptr2		;CE39 8D FA 5F
		lda #$63		;CE3C A9 63
		sta vic_sprite_ptr3		;CE3E 8D FB 5F
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
		bit screen_buffer_current		;CE78 2C 5F C3
		bpl L_CE81		;CE7B 10 04
		inx				;CE7D E8
		inx				;CE7E E8
		inx				;CE7F E8
		inx				;CE80 E8
.L_CE81	lda L_CF5E,X	;CE81 BD 5E CF
		sta vic_sprite_ptr0		;CE84 8D F8 5F
		lda L_CF60,X	;CE87 BD 60 CF
		sta vic_sprite_ptr1		;CE8A 8D F9 5F
		lda #$07		;CE8D A9 07
		sta VIC_SP0COL		;CE8F 8D 27 D0
		sta VIC_SP1COL		;CE92 8D 28 D0
		pla				;CE95 68
		tax				;CE96 AA
.L_CE97	lda ZP_6E		;CE97 A5 6E
		sta VIC_SPENA		;CE99 8D 15 D0
		lda #$C5		;CE9C A9 C5
		jmp set_raster_interrupt_line		;CE9E 4C 49 CF

.L_CEA1	cmp #$D7		;CEA1 C9 D7
		bcs place_dashboard_sprites		;CEA3 B0 10
		lda #C64_VIC_BITMAP_SCREEN2		;CEA5 A9 78		; BEEB SELECT SCREEN BUFFER
		sta VIC_VMCSB		;CEA7 8D 18 D0

 ; TomS - point display at single copy of dashboard.
 ; (there is only one copy;	the corresponding region in the	first buffer holds sprites.)

		lda L_C37A		;CEAA AD 7A C3
		sta L_C37B		;CEAD 8D 7B C3
		lda #$D7		;CEB0 A9 D7
		jmp set_raster_interrupt_line		;CEB2 4C 49 CF

.place_dashboard_sprites
{
		lda #$E4		;CEB5 A9 E4
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
		sta vic_sprite_ptr0		;CEE2 8D F8 5F
		lda #$01		;CEE5 A9 01
		sta vic_sprite_ptr1		;CEE7 8D F9 5F
		lda #$02		;CEEA A9 02
		sta vic_sprite_ptr2		;CEEC 8D FA 5F
		lda #$03		;CEEF A9 03
		sta vic_sprite_ptr3		;CEF1 8D FB 5F
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
		jsr cart_sid_update		;CF34 20 EF 86
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
}
\\
.set_raster_interrupt_line
{
		sta VIC_RASTER		;CF49 8D 12 D0
		lda VIC_SCROLY		;CF4C AD 11 D0
		and #$7F		;CF4F 29 7F
		sta VIC_SCROLY		;CF51 8D 11 D0
		pla				;CF54 68
		rti				;CF55 40
}

\\ Dashboard sprite positions
.L_140D	equb $3C
.L_140E	equb $54
.L_140F	equb $06
.L_1410	equb $1A

.L_CF56	equb $46,$12
.L_CF58	equb $5E,$FA
.L_CF5A	equb $B4,$B4		
.L_CF5C	equb $AD,$AD
.L_CF5E	equb $6A,$6D
.L_CF60	equb $6B,$6C,$6E,$5F,$6F,$FD
.L_CF66	equb $C8,$C9

.L_CF68
{
		asl A			;CF68 0A
		asl A			;CF69 0A
		asl A			;CF6A 0A
		adc #LO(L_AF80)		;CF6B 69 80
		tax				;CF6D AA
		ldy #HI(L_AF80)		;CF6E A0 AF
		jmp cart_sid_process		;CF70 4C 55 86
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
		cpx number_of_road_sections		;CFC8 EC 64 C7
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
		ldx number_of_road_sections		;CFD7 AE 64 C7
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
.L_CFF4	dec track_preview_rotation		;CFF4 CE 4C C3
		sec				;CFF7 38
		rts				;CFF8 60
.L_CFF9	inc track_preview_rotation		;CFF9 EE 4C C3
		sec				;CFFC 38
		rts				;CFFD 60
}

; *****************************************************************************
; Functions originally located in Kernel RAM
; *****************************************************************************

\\ Data removed

.L_E0F9_with_sysctl
{
		ldx #$02		;E0F9 A2 02
.L_E0FB	lda #$15		;E0FB A9 15
		jsr cart_sysctl		;E0FD 20 25 87
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
		jsr L_E409_in_kernel		;E1F8 20 09 E4
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
		jsr L_E294_in_kernel		;E218 20 94 E2
		ldx #$3D		;E21B A2 3D
		jsr L_E409_in_kernel		;E21D 20 09 E4
		bcs L_E258		;E220 B0 36
		jsr draw_aicar		;E222 20 E8 E6
		jmp L_E258		;E225 4C 58 E2
.L_E228	lda #$80		;E228 A9 80
		sta ZP_6D		;E22A 85 6D
.L_E22C	lda #$80		;E22C A9 80
		sta L_C303		;E22E 8D 03 C3
		jsr L_FC31_in_kernel		;E231 20 31 FC
		jsr L_E294_in_kernel		;E234 20 94 E2
		ldx #$3D		;E237 A2 3D
		jsr L_E409_in_kernel		;E239 20 09 E4
		bcs L_E252		;E23C B0 14
		bit L_C3DA		;E23E 2C DA C3
		bpl L_E24C		;E241 10 09
		jsr L_FC99_in_kernel		;E243 20 99 FC
		jsr L_FCB3_in_kernel		;E246 20 B3 FC
		jmp L_E24F		;E249 4C 4F E2
.L_E24C	jsr L_FCA2_in_kernel		;E24C 20 A2 FC
.L_E24F	jsr draw_aicar		;E24F 20 E8 E6
.L_E252	jsr do_ai_depth_stuff		;E252 20 35 2C
		jsr L_FC23_in_kernel		;E255 20 23 FC
.L_E258	pla				;E258 68
		tax				;E259 AA
		jmp set_linedraw_colour		;E25A 4C 01 FC
}

.L_E25D_in_kernel	\\ only called from Kernel fns
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

.L_E294_in_kernel	\\ only called from Kernel fns
{
		bit ZP_EA		;E294 24 EA
		bmi L_E2A1		;E296 30 09
		jsr L_E388_in_kernel		;E298 20 88 E3
		jsr L_E2AA		;E29B 20 AA E2
		jmp L_E372_in_kernel		;E29E 4C 72 E3
.L_E2A1	jsr L_E372_in_kernel		;E2A1 20 72 E3
		jsr L_E2AA		;E2A4 20 AA E2
		jmp L_E388_in_kernel		;E2A7 4C 88 E3
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
		jsr L_E31A_in_kernel		;E303 20 1A E3
		ldx #$03		;E306 A2 03
.L_E308	lda L_A244,X	;E308 BD 44 A2
		sta L_A240,X	;E30B 9D 40 A2
		lda L_A290,X	;E30E BD 90 A2
		sta L_A28C,X	;E311 9D 8C A2
		dex				;E314 CA
		bpl L_E308		;E315 10 F1
		jmp L_E3D8_with_draw_line		;E317 4C D8 E3
}

.L_E31A_in_kernel	\\ only called from Kernel fns
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

.L_E372_in_kernel	\\ only called from Kernel fns
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

.L_E388_in_kernel	\\ only called from Kernel fns
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
.L_E39A	\\ only called from Kernel fns
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
		jsr L_E31A_in_kernel		;E3D5 20 1A E3
\\
.L_E3D8_with_draw_line		\\ only called from Kernel fns
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

.L_E409_in_kernel		\\ only called from Kernel fns
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
		jsr L_E25D_in_kernel		;E4D3 20 5D E2
		clc				;E4D6 18
		rts				;E4D7 60
.L_E4D8	sec				;E4D8 38
		rts				;E4D9 60
}

.L_E4DA
{
		lda #$40		;E4DA A9 40
		jsr L_E5A1_in_kernel		;E4DC 20 A1 E5
		stx ZP_D4		;E4DF 86 D4
		sta ZP_D5		;E4E1 85 D5
		sty ZP_9C		;E4E3 84 9C
		jsr fetch_near_section_stuff		;E4E5 20 2F F0
		jsr fetch_xz_position		;E4E8 20 C5 F0
		lda ZP_68		;E4EB A5 68
		sec				;E4ED 38
		sbc ZP_1D		;E4EE E5 1D
		sta ZP_3D		;E4F0 85 3D
		lda ZP_D5		;E4F2 A5 D5
		asl A			;E4F4 0A
		tax				;E4F5 AA
		jsr cart_L_9C14		;E4F6 20 14 9C
		sta ZP_48		;E4F9 85 48
		lda ZP_15		;E4FB A5 15
		lsr A			;E4FD 4A
		lsr A			;E4FE 4A
		lsr A			;E4FF 4A
		lsr A			;E500 4A
		lsr A			;E501 4A
		sta ZP_5B		;E502 85 5B
		inx				;E504 E8
		jsr cart_L_9C14		;E505 20 14 9C
		sta ZP_49		;E508 85 49
		inx				;E50A E8
		jsr cart_L_9C14		;E50B 20 14 9C
		sta ZP_4A		;E50E 85 4A
		lda ZP_15		;E510 A5 15
		lsr A			;E512 4A
		lsr A			;E513 4A
		lsr A			;E514 4A
		lsr A			;E515 4A
		lsr A			;E516 4A
		sta ZP_DC		;E517 85 DC
		inx				;E519 E8
		jsr cart_L_9C14		;E51A 20 14 9C
		sta ZP_4B		;E51D 85 4B
		inx				;E51F E8
		cpx ZP_9E		;E520 E4 9E
		bcc L_E538		;E522 90 14
		jsr L_CFC5		;E524 20 C5 CF
		jsr fetch_near_section_stuff		;E527 20 2F F0
		ldx #$02		;E52A A2 02
		jsr L_E5C7_in_kernel		;E52C 20 C7 E5
		jsr L_CFD2		;E52F 20 D2 CF
		jsr fetch_near_section_stuff		;E532 20 2F F0
		jmp L_E53B		;E535 4C 3B E5
}

.L_E538	jsr L_E5C7_in_kernel		;E538 20 C7 E5
\\
.L_E53B	lda ZP_D5		;E53B A5 D5
		jsr L_E808		;E53D 20 08 E8
		ldy #$04		;E540 A0 04
		ldx #$00		;E542 A2 00
\\
.L_E544
{
		jsr L_E628_in_kernel		;E544 20 28 E6
		ldy #$06		;E547 A0 06
		ldx #$01		;E549 A2 01
		jsr L_E628_in_kernel		;E54B 20 28 E6
		lsr L_C30B		;E54E 4E 0B C3
		ldx #$00		;E551 A2 00
		ldy #$01		;E553 A0 01
		jsr cart_L_238E		;E555 20 8E 23
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
		jsr L_FF94_in_kernel		;E574 20 94 FF
		ldy #$05		;E577 A0 05
		ldx #$04		;E579 A2 04
		lda ZP_4C		;E57B A5 4C
		jsr L_E631		;E57D 20 31 E6
		lda ZP_B0		;E580 A5 B0
		clc				;E582 18
		adc L_C34D		;E583 6D 4D C3
		sta ZP_4C		;E586 85 4C
		ldx #$01		;E588 A2 01
		jsr L_FF94_in_kernel		;E58A 20 94 FF
		ldy #$07		;E58D A0 07
		ldx #$04		;E58F A2 04
		lda ZP_4C		;E591 A5 4C
		jsr L_E631		;E593 20 31 E6
		jsr L_E65E_in_kernel		;E596 20 5E E6
		lda #$FF		;E599 A9 FF
		bit ZP_6B		;E59B 24 6B
		bpl L_E5A1_in_kernel		;E59D 10 02
		lda #$00		;E59F A9 00
}
\\
.L_E5A1_in_kernel		\\ only called from Kernel fns
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
		jsr fetch_near_section_stuff		;E5B8 20 2F F0
		lda ZP_BE		;E5BB A5 BE
		sec				;E5BD 38
		sbc #$01		;E5BE E9 01
.L_E5C0	sta ZP_A3		;E5C0 85 A3
		stx ZP_A6		;E5C2 86 A6
		ldy ZP_18		;E5C4 A4 18
		rts				;E5C6 60
}

.L_E5C7_in_kernel		\\ only called from Kernel fns
{
		jsr cart_L_9C14		;E5C7 20 14 9C
		sta ZP_DD		;E5CA 85 DD
		lda ZP_15		;E5CC A5 15
		lsr A			;E5CE 4A
		lsr A			;E5CF 4A
		lsr A			;E5D0 4A
		lsr A			;E5D1 4A
		lsr A			;E5D2 4A
		sta ZP_DF		;E5D3 85 DF
		inx				;E5D5 E8
		jsr cart_L_9C14		;E5D6 20 14 9C
		sta ZP_DE		;E5D9 85 DE
		rts				;E5DB 60
}

.L_E5DC_in_kernel		\\ only called from Kernel fns
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

.L_E628_in_kernel		\\ only called from Kernel fns
		lda ZP_9C		;E628 A5 9C
		clc				;E62A 18
		adc L_C30D,X	;E62B 7D 0D C3
		ror L_C30B		;E62E 6E 0B C3
\\
.L_E631
{
		sta ZP_17		;E631 85 17
		jsr L_E5DC_in_kernel		;E633 20 DC E5
		tya				;E636 98
		ora #$20		;E637 09 20
		tay				;E639 A8
		txa				;E63A 8A
		ora #$20		;E63B 09 20
		tax				;E63D AA
		jmp L_E5DC_in_kernel		;E63E 4C DC E5
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
		jmp cart_L_2809		;E65B 4C 09 28
}

.L_E65E_in_kernel		\\ only called from Kernel fns
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
		jmp L_FF94_in_kernel		;E6E2 4C 94 FF
		
.L_E6E5	equb $00,$00,$01
}

; draw front of aicar

.draw_aicar		\\ only called from Kernel fns
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
		jsr L_E31A_in_kernel		;E721 20 1A E3
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
		jsr L_E372_in_kernel		;E742 20 72 E3
		jmp L_E388_in_kernel		;E745 4C 88 E3
.L_E748	jsr L_E7F3_with_draw_line		;E748 20 F3 E7
		jsr L_E7E5_with_draw_line		;E74B 20 E5 E7
		jsr L_E7EC_with_draw_line		;E74E 20 EC E7
		jsr L_FCB3_in_kernel		;E751 20 B3 FC
		jsr L_E372_in_kernel		;E754 20 72 E3
		jmp L_E388_in_kernel		;E757 4C 88 E3
.L_E75A	bit L_C3DA		;E75A 2C DA C3
		bmi L_E779		;E75D 30 1A
		jsr L_E7C2_with_draw_line		;E75F 20 C2 E7
		lda L_A296		;E762 AD 96 A2
		cmp L_A292		;E765 CD 92 A2
		bcs L_E773		;E768 B0 09
		jsr L_E801_with_draw_line		;E76A 20 01 E8
		jsr L_E7DE_with_draw_line		;E76D 20 DE E7
		jsr L_E7EC_with_draw_line		;E770 20 EC E7
.L_E773	jsr L_E372_in_kernel		;E773 20 72 E3
		jmp L_E388_in_kernel		;E776 4C 88 E3
.L_E779	jsr L_E7F3_with_draw_line		;E779 20 F3 E7
		jsr L_E7EC_with_draw_line		;E77C 20 EC E7
		jsr L_E7E5_with_draw_line		;E77F 20 E5 E7
		jsr L_FCB3_in_kernel		;E782 20 B3 FC
		jsr L_E388_in_kernel		;E785 20 88 E3
		jsr L_E372_in_kernel		;E788 20 72 E3
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
.L_E7A7	jsr L_E388_in_kernel		;E7A7 20 88 E3
		jmp L_E372_in_kernel		;E7AA 4C 72 E3
.L_E7AD	jsr L_E7F3_with_draw_line		;E7AD 20 F3 E7
		jsr L_E7E5_with_draw_line		;E7B0 20 E5 E7
		jsr L_E7EC_with_draw_line		;E7B3 20 EC E7
		jsr L_FCB3_in_kernel		;E7B6 20 B3 FC
		jsr L_E372_in_kernel		;E7B9 20 72 E3
		jsr L_E388_in_kernel		;E7BC 20 88 E3
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
.L_E843	jsr cart_L_A026		;E843 20 26 A0
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
		jsr cart_L_1611		;E876 20 11 16
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
		jsr L_E92C_in_kernel		;E8A5 20 2C E9
		jsr L_E9A3		;E8A8 20 A3 E9
.L_E8AB	lda L_C360		;E8AB AD 60 C3
		clc				;E8AE 18
		adc #$01		;E8AF 69 01
		cmp #$04		;E8B1 C9 04
		bcc L_E895		;E8B3 90 E0
		rts				;E8B5 60

.L_E8B6	equb $78,$6E,$64,$5A,$50,$46,$3C,$32,$28,$1E,$14,$0A
}

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

; Moved to Hazel
;.L_E8E1	equb $09,$06,$03,$00

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
;L_E902	= *-1			;! _SELF_MOD
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

.L_E92C_in_kernel		\\ only called from Kernel fns
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

.get_road_data_byte		\\ only called from Kernel fns
{
		lda (ZP_1E),Y	;EA12 B1 1E
		iny				;EA14 C8
		bne L_EA19		;EA15 D0 02
		inc ZP_1F		;EA17 E6 1F
.L_EA19	and #$FF		;EA19 29 FF
		rts				;EA1B 60
}

.adjust_accumulator		\\ only called from Kernel fns
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

.set_road_data1
{
		txa				;EA34 8A
		asl A			;EA35 0A
		tay				;EA36 A8
		lda tracks_table,Y	;EA37 B9 20 B2
		sta ZP_1E		;EA3A 85 1E
		lda tracks_table+1,Y	;EA3C B9 21 B2
		sta ZP_1F		;EA3F 85 1F
		ldy #$00		;EA41 A0 00
.L_EA43	jsr get_road_data_byte		;EA43 20 12 EA
		sta L_C763,Y	;EA46 99 63 C7
		cpy #$04		;EA49 C0 04
		bne L_EA43		;EA4B D0 F6
		jsr get_road_data_byte		;EA4D 20 12 EA
		sta ZP_51		;EA50 85 51
		sta ZP_52		;EA52 85 52
		jsr get_road_data_byte		;EA54 20 12 EA
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
		sta road_section_angle_and_piece,X	;EA6F 9D 00 04
		and #$10		;EA72 29 10
		beq L_EA7C		;EA74 F0 06
		lda ZP_15		;EA76 A5 15
		eor #$C0		;EA78 49 C0
		sta ZP_15		;EA7A 85 15
.L_EA7C	lda ZP_30		;EA7C A5 30
		jsr adjust_accumulator		;EA7E 20 1C EA
		jmp L_EAA4		;EA81 4C A4 EA
.L_EA84	jsr get_road_data_byte		;EA84 20 12 EA
		sta ZP_15		;EA87 85 15
		sta road_section_angle_and_piece,X	;EA89 9D 00 04
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
.L_EA9C	lda road_section_angle_and_piece,X	;EA9C BD 00 04
		sta ZP_4F		;EA9F 85 4F
		jsr get_road_data_byte		;EAA1 20 12 EA
.L_EAA4	sta road_section_xz_positions,X	;EAA4 9D 4E 04
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
		lda road_section_angle_and_piece,X	;EABB BD 00 04
		and #$F0		;EABE 29 F0
		sta road_section_angle_and_piece,X	;EAC0 9D 00 04
		lda L_EBDB,Y	;EAC3 B9 DB EB
		sta left_y_coordinate_IDs,X	;EAC6 9D 9C 04
		lda L_EBDD,Y	;EAC9 B9 DD EB
		ldy ZP_16		;EACC A4 16
		jmp L_EAE6		;EACE 4C E6 EA
.L_EAD1	jsr get_road_data_byte		;EAD1 20 12 EA
		sta left_y_coordinate_IDs,X	;EAD4 9D 9C 04
		lda ZP_15		;EAD7 A5 15
		and #$20		;EAD9 29 20
		beq L_EAE3		;EADB F0 06
		lda left_y_coordinate_IDs,X	;EADD BD 9C 04
		jmp L_EAE6		;EAE0 4C E6 EA
.L_EAE3	jsr get_road_data_byte		;EAE3 20 12 EA
.L_EAE6	and #$7F		;EAE6 29 7F
		ora ZP_14		;EAE8 05 14
		sta right_y_coordinate_IDs,X	;EAEA 9D EA 04
		tya				;EAED 98
		pha				;EAEE 48
		lda ZP_7D		;EAEF A5 7D
		sta ZP_14		;EAF1 85 14
		lda ZP_7F		;EAF3 A5 7F
		ldy #$FB		;EAF5 A0 FB
		jsr shift_16bit		;EAF7 20 BF C9
		sta distances_around_road_MSBs,X	;EAFA 9D BE 06
		lda ZP_14		;EAFD A5 14
		sta distances_around_road_LSBs,X	;EAFF 9D 70 06
		jsr fetch_near_section_stuff		;EB02 20 2F F0
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
		jsr L_EBF3_in_kernel		;EB1D 20 F3 EB
		sta ZP_15		;EB20 85 15
		lda ZP_51		;EB22 A5 51
		sec				;EB24 38
		sbc ZP_14		;EB25 E5 14
		sta overall_left_y_shifts_LSBs,X	;EB27 9D 38 05
		lda ZP_77		;EB2A A5 77
		sbc ZP_15		;EB2C E5 15
		sta overall_left_y_shifts_MSBs,X	;EB2E 9D 86 05
		ldy ZP_BE		;EB31 A4 BE
		jsr L_EBF3_in_kernel		;EB33 20 F3 EB
		sta ZP_15		;EB36 85 15
		lda overall_left_y_shifts_LSBs,X	;EB38 BD 38 05
		clc				;EB3B 18
		adc ZP_14		;EB3C 65 14
		sta ZP_51		;EB3E 85 51
		lda overall_left_y_shifts_MSBs,X	;EB40 BD 86 05
		adc ZP_15		;EB43 65 15
		sta ZP_77		;EB45 85 77
		ldy #$00		;EB47 A0 00
		jsr L_EBEB_in_kernel		;EB49 20 EB EB
		sta ZP_15		;EB4C 85 15
		lda ZP_52		;EB4E A5 52
		sec				;EB50 38
		sbc ZP_14		;EB51 E5 14
		sta overall_right_y_shifts_LSBs,X	;EB53 9D D4 05
		lda ZP_78		;EB56 A5 78
		sbc ZP_15		;EB58 E5 15
		sta overall_right_y_shifts_MSBs,X	;EB5A 9D 22 06
		ldy ZP_BE		;EB5D A4 BE
		jsr L_EBEB_in_kernel		;EB5F 20 EB EB
		sta ZP_15		;EB62 85 15
		lda overall_right_y_shifts_LSBs,X	;EB64 BD D4 05
		clc				;EB67 18
		adc ZP_14		;EB68 65 14
		sta ZP_52		;EB6A 85 52
		lda overall_right_y_shifts_MSBs,X	;EB6C BD 22 06
		adc ZP_15		;EB6F 65 15
		sta ZP_78		;EB71 85 78
		pla				;EB73 68
		tay				;EB74 A8
		inx				;EB75 E8
		cpx number_of_road_sections		;EB76 EC 64 C7
		beq L_EB7E		;EB79 F0 03
		jmp L_EA65		;EB7B 4C 65 EA
.L_EB7E	ldx near_start_line_section		;EB7E AE 66 C7
		inx				;EB81 E8
		cpx number_of_road_sections		;EB82 EC 64 C7
		bcc L_EB89		;EB85 90 02
		ldx #$00		;EB87 A2 00
.L_EB89	stx L_C77C		;EB89 8E 7C C7
		sty ZP_17		;EB8C 84 17
		lda ZP_7D		;EB8E A5 7D
		sta ZP_14		;EB90 85 14
		lda ZP_7F		;EB92 A5 7F
		ldy #$FB		;EB94 A0 FB
		jsr shift_16bit		;EB96 20 BF C9
		sta total_road_distance+1		;EB99 8D 69 C7
		lda ZP_14		;EB9C A5 14
		sta total_road_distance		;EB9E 8D 68 C7
		ldy ZP_17		;EBA1 A4 17
		ldx #$00		;EBA3 A2 00
.L_EBA5	jsr get_road_data_byte		;EBA5 20 12 EA
		sta L_C774,X	;EBA8 9D 74 C7
		inx				;EBAB E8
		cpx #$06		;EBAC E0 06
		bne L_EBA5		;EBAE D0 F5
		lda L_C778		;EBB0 AD 78 C7
		beq L_EBC9		;EBB3 F0 14
		ldx #$00		;EBB5 A2 00
.L_EBB7	jsr get_road_data_byte		;EBB7 20 12 EA
		sta L_075E,X	;EBBA 9D 5E 07
		jsr get_road_data_byte		;EBBD 20 12 EA
		sta L_0769,X	;EBC0 9D 69 07
		inx				;EBC3 E8
		cpx L_C778		;EBC4 EC 78 C7
		bne L_EBB7		;EBC7 D0 EE
.L_EBC9	lda L_C779		;EBC9 AD 79 C7
		beq L_EBDC		;EBCC F0 0E
		ldx #$00		;EBCE A2 00
.L_EBD0	jsr get_road_data_byte		;EBD0 20 12 EA
		sta L_0190,X	;EBD3 9D 90 01
		inx				;EBD6 E8
		cpx L_C779		;EBD7 EC 79 C7
		bne L_EBD0		;EBDA D0 F4
.L_EBDC	jsr L_1F06		;EBDC 20 06 1F
		ldx L_209A		;EBDF AE 9A 20
		lda #$44		;EBE2 A9 44
		jmp cart_sysctl		;EBE4 4C 25 87

.L_EBE7	equb $03,$04,$04,$03
L_EBDB	= L_EBE7 - $C			;!
L_EBDD	= L_EBE7 - $A			;!
}

.L_EBEB_in_kernel		\\ only called from Kernel fns
{
		lda ZP_CA		;EBEB A5 CA
		sta ZP_98		;EBED 85 98
		lda ZP_CB		;EBEF A5 CB
		sta ZP_99		;EBF1 85 99
}
\\
.L_EBF3_in_kernel		\\ only called from Kernel fns
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
		jsr L_ECDB_in_kernel		;EC32 20 DB EC
		lda #$03		;EC35 A9 03
		jsr L_EC9A_in_kernel		;EC37 20 9A EC
		bpl L_EC29		;EC3A 10 ED
.L_EC3C	rts				;EC3C 60
.L_EC3D	cpx #$E4		;EC3D E0 E4
		bne L_EC6C		;EC3F D0 2B
		lda #$04		;EC41 A9 04
		jsr L_EC9A_in_kernel		;EC43 20 9A EC
		lda #$FF		;EC46 A9 FF
		jsr L_ECDB_in_kernel		;EC48 20 DB EC
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
		jsr L_ECDB_in_kernel		;EC6E 20 DB EC
		lda #$02		;EC71 A9 02
		jsr L_EC9A_in_kernel		;EC73 20 9A EC
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

.L_EC9A_in_kernel		\\ only called from Kernel fns
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

.L_ECDB_in_kernel		\\ only called from Kernel fns
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

.L_ED39_in_kernel		\\ only called from Kernel fns
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
		jsr cart_clear_menu_area		;ED7F 20 23 1C
		jsr cart_menu_colour_map_stuff		;ED82 20 C4 38
		ldx #$E0		;ED85 A2 E0
		jsr cart_print_msg_4		;ED87 20 27 30
		lda #$01		;ED8A A9 01
		sta ZP_19		;ED8C 85 19
		jsr L_3858		;ED8E 20 58 38
		ldx #$0E		;ED91 A2 0E
		ldy #$10		;ED93 A0 10
		jsr cart_set_text_cursor		;ED95 20 6B 10
		lda #$3E		;ED98 A9 3E
		jsr cart_write_char		;ED9A 20 6F 84
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
		jsr cart_getch		;EDC1 20 03 86
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
		jsr cart_write_char		;EE03 20 6F 84
		jmp L_EDB7		;EE06 4C B7 ED
.L_EE09	cmp #$60		;EE09 C9 60
		bcc L_EE15		;EE0B 90 08
		bit ZP_0B		;EE0D 24 0B
		bpl L_EE15		;EE0F 10 04
		bvc L_EE15		;EE11 50 02
		sbc #$20		;EE13 E9 20
.L_EE15	cpx #$0C		;EE15 E0 0C
		bcs L_EDB7		;EE17 B0 9E
		jsr cart_write_char		;EE19 20 6F 84
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

; Moved to Hazel
;.L_EE35	equb $00

.do_menu_screen
{
		dey				;EE36 88
		sty ZP_31		;EE37 84 31
		stx ZP_30		;EE39 86 30
		sta ZP_0C		;EE3B 85 0C
		jsr set_up_screen_for_menu		;EE3D 20 1F 35
		ldx #$00		;EE40 A2 00
		stx ZP_0F		;EE42 86 0F
		jsr cart_print_msg_2		;EE44 20 CB A1
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
		jsr cart_print_single_digit		;EE6B 20 8A 10
		lda #$2E		;EE6E A9 2E
		jsr cart_write_char		;EE70 20 6F 84
		jsr cart_print_space		;EE73 20 AF 91
		lda ZP_17		;EE76 A5 17
		clc				;EE78 18
		adc ZP_30		;EE79 65 30
		tay				;EE7B A8
		ldx L_F001,Y	;EE7C BE 01 F0
		jsr cart_print_msg_2		;EE7F 20 CB A1
		lda ZP_30		;EE82 A5 30
		cmp #$18		;EE84 C9 18
		bne L_EE90		;EE86 D0 08
		lda ZP_17		;EE88 A5 17
		clc				;EE8A 18
		adc #$01		;EE8B 69 01
		jsr cart_print_single_digit		;EE8D 20 8A 10
.L_EE90	lda ZP_31		;EE90 A5 31
		cmp ZP_17		;EE92 C5 17
		bcc L_EEB2		;EE94 90 1C
		lda ZP_30		;EE96 A5 30
		cmp #$1C		;EE98 C9 1C
		bne L_EE4B		;EE9A D0 AF
		ldx #$23		;EE9C A2 23
		jsr cart_print_msg_4		;EE9E 20 27 30
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
.L_EED7	ldx menu_keys,Y	;EED7 BE 0C F8
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

\\ Moved from further up RAM as only used in this function

.L_F001	equb $EC,$0A,$14,$2C,$44,$49,$4E,$55,$5C,$6B,$55,$00,$7A,$87,$55,$00
		equb $0A,$1F,$00,$00,$2B,$40,$00,$00,$49,$49,$49,$49,$0A,$0A,$55,$00
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
		jsr L_F6D7_in_kernel		;EF2E 20 D7 F6
		lda #$80		;EF31 A9 80
		sta L_C76C		;EF33 8D 6C C7
		rts				;EF36 60
.L_EF37	jsr delay_approx_4_5ths_sec		;EF37 20 E9 3F
\\
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
		jsr cart_L_1611		;EF67 20 11 16
		ldx #KEY_DEF_REDEFINE		;EF6A A2 20
		jsr poll_key_with_sysctl		;EF6C 20 C9 C7
		bne L_EF77		;EF6F D0 06
		jsr L_3500_with_VIC		;EF71 20 00 35
		jmp game_start		;EF74 4C 22 3B
.L_EF77	lda L_31A1		;EF77 AD A1 31
		bne L_EF86		;EF7A D0 0A
		jsr L_3FBE_with_VIC		;EF7C 20 BE 3F
		lda #$80		;EF7F A9 80
		jsr L_F6D7_in_kernel		;EF81 20 D7 F6
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
		jsr L_F6D7_in_kernel		;EFBA 20 D7 F6
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
		jsr L_F6D7_in_kernel		;EFD6 20 D7 F6
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
.L_EFF4	jsr L_3500_with_VIC		;EFF4 20 00 35
		jsr set_up_screen_for_frontend		;EFF7 20 04 35
		jsr L_36AD_from_game_start		;EFFA 20 AD 36
.L_EFFD	jmp do_main_menu_dwim		;EFFD 4C 3A EF

.L_F000	equb $00
}

; X=0 (main menu)
; X=4 (Load/Save/Replay)
; X=8 (Load)
; X=$C (Save)
; X=$10 (Start)
; X=$14 (Multiplayer setup)
; X=$18 (Practise)
; X=$1C (Practise specific	division)

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

.fetch_near_section_stuff
{
		lda left_y_coordinate_IDs,X	;F02F BD 9C 04
		sta ZP_A2		;F032 85 A2
		asl A			;F034 0A
		tay				;F035 A8
		lda y_coordinate_offsets,Y	;F036 B9 20 B1
		sta ZP_98		;F039 85 98
		lda y_coordinate_offsets+1,Y	;F03B B9 21 B1
		sta ZP_99		;F03E 85 99
		lda right_y_coordinate_IDs,X	;F040 BD EA 04
		asl A			;F043 0A
		tay				;F044 A8
		lda #$00		;F045 A9 00
		rol A			;F047 2A
		asl A			;F048 0A
		sta ZP_D8		;F049 85 D8
		lda y_coordinate_offsets,Y	;F04B B9 20 B1
		sta ZP_CA		;F04E 85 CA
		lda y_coordinate_offsets+1,Y	;F050 B9 21 B1
		sta ZP_CB		;F053 85 CB
		lda overall_left_y_shifts_LSBs,X	;F055 BD 38 05
		sta ZP_3F		;F058 85 3F
		lda overall_left_y_shifts_MSBs,X	;F05A BD 86 05
		sta ZP_35		;F05D 85 35
		lda overall_right_y_shifts_LSBs,X	;F05F BD D4 05
		sta ZP_40		;F062 85 40
		lda overall_right_y_shifts_MSBs,X	;F064 BD 22 06
		sta ZP_36		;F067 85 36
		lda road_section_angle_and_piece,X	;F069 BD 00 04
		and #$C0		;F06C 29 C0
		sta ZP_1D		;F06E 85 1D
		lda road_section_angle_and_piece,X	;F070 BD 00 04
		and #$10		;F073 29 10
		asl A			;F075 0A
		asl A			;F076 0A
		asl A			;F077 0A
		sta ZP_A4		;F078 85 A4
		lda road_section_angle_and_piece,X	;F07A BD 00 04
		and #$0F		;F07D 29 0F
		sta L_C3CD		;F07F 8D CD C3
		asl A			;F082 0A
		tay				;F083 A8
		lda piece_data_offsets,Y	;F084 B9 00 B1
		sta ZP_9A		;F087 85 9A
		lda piece_data_offsets+1,Y	;F089 B9 01 B1
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

; TomS - looks up entry in 44E table, disentangles it (getting X and Y).
.fetch_xz_position
{
		lda road_section_xz_positions,X	;F0C5 BD 4E 04
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

.L_F15D_in_kernel		\\ only called from Kernel fns
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
		jsr L_F15D_in_kernel		;F1E6 20 5D F1
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
;L_F2E4	= *-1			;! _SELF_MOD
		sta L_C368		;F2E5 8D 68 C3
		jsr cart_L_2C64		;F2E8 20 64 2C
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
.L_F30D	jsr draw_track_preview_section		;F30D 20 2E F3
		dex				;F310 CA
		cpx L_C3D8		;F311 EC D8 C3
		bcs L_F30D		;F314 B0 F7
		ldx #$01		;F316 A2 01
		lda #$80		;F318 A9 80
		sta L_C361		;F31A 8D 61 C3
.L_F31D	jsr draw_track_preview_section		;F31D 20 2E F3
		inx				;F320 E8
		cpx L_C3D7		;F321 EC D7 C3
		bcc L_F31D		;F324 90 F7
		beq L_F31D		;F326 F0 F5
		iny				;F328 C8
		cpy #$11		;F329 C0 11
		bne L_F2FA		;F32B D0 CD
		rts				;F32D 60
}

.draw_track_preview_section			; in Kernel
{
		stx ZP_30		;F32E 86 30
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

		jsr cart_make_near_road_coords		;F37B 20 7D 17
		jsr cart_L_1A3B		;F37E 20 3B 1A

.L_F381	ldx ZP_30		;F381 A6 30
		ldy ZP_31		;F383 A4 31
		rts				;F385 60
}

\\ Believe this is effecively do "draw_track_preview"
.update_track_preview
{
		lda track_preview_rotation		;F386 AD 4C C3
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
		jsr cart_start_of_frame		;F3B4 20 4D 16
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
		sta L_262B		;F3D6 8D 2B 26	_SELF_MOD to L_25EA in Core
		ldx #$02		;F3D9 A2 02
.L_F3DB	lda L_2458,X	;F3DB BD 58 24  _SELF_MOD
		pha				;F3DE 48
		lda L_F408,X	;F3DF BD 08 F4
		sta L_2458,X	;F3E2 9D 58 24  _SELF_MOD
		dex				;F3E5 CA
		bpl L_F3DB		;F3E6 10 F3
		jsr draw_track_preview		;F3E8 20 F6 F2

		lda #$08		;F3EB A9 08
		sta L_262B		;F3ED 8D 2B 26	_SELF_MOD to L_25EA in Core
		ldx #$00		;F3F0 A2 00
.L_F3F2	pla				;F3F2 68
		sta L_2458,X	;F3F3 9D 58 24   _SELF_MOD
		inx				;F3F6 E8
		cpx #$03		;F3F7 E0 03
		bne L_F3F2		;F3F9 D0 F7
		rts				;F3FB 60

.L_F3FC	equb $04,$00,$04,$08
.L_F400	equb $00,$04,$08,$04
.L_F404	equb $00,$40,$80,$C0

.L_F408	jmp L_F40B		; equb $4C,$0B,$F4
}

\\ Code moved to Core

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
		lda road_section_angle_and_piece,X	;F48D BD 00 04
		and #$0F		;F490 29 0F
		tay				;F492 A8
		lda sections_car_can_be_put_on,Y	;F493 B9 40 B2
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
		jsr fetch_near_section_stuff		;F4B6 20 2F F0
		lda road_section_xz_positions,X	;F4B9 BD 4E 04
		and #$0F		;F4BC 29 0F
		sta ZP_0B		;F4BE 85 0B
		lda road_section_xz_positions,X	;F4C0 BD 4E 04
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
		jsr cart_L_9A38		;F510 20 38 9A
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
		jsr L_ED39_in_kernel		;F55F 20 39 ED
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
		lda distances_around_road_LSBs,X	;F59D BD 70 06
		sec				;F5A0 38
		sbc distances_around_road_LSBs,Y	;F5A1 F9 70 06
		sta ZP_16		;F5A4 85 16
		lda distances_around_road_MSBs,X	;F5A6 BD BE 06
		sbc distances_around_road_MSBs,Y	;F5A9 F9 BE 06
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
		lda total_road_distance		;F5C0 AD 68 C7
		sec				;F5C3 38
		sbc ZP_14		;F5C4 E5 14
		tax				;F5C6 AA
		lda total_road_distance+1		;F5C7 AD 69 C7
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
		adc number_of_road_sections		;F5FD 6D 64 C7
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
.L_F621	lda boost_reserve		;F621 AD 6A C7
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
		sta boost_reserve		;F636 8D 6A C7
		lsr A			;F639 4A
		lsr A			;F63A 4A
		lsr A			;F63B 4A
		lsr A			;F63C 4A
		ldx #$44		;F63D A2 44
		jsr L_142E		;F63F 20 2E 14
		lda boost_reserve		;F642 AD 6A C7
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

.L_F6D7_in_kernel
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
		jmp L_F6D7_in_kernel		;F799 4C D7 F6
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

IF _NOT_BEEB
		lda #$00		;F7E4 A9 00
		sta CIA1_CIDDRA		;F7E6 8D 02 DC
		lda CIA1_CIAPRA		;F7E9 AD 00 DC			; CIA1
		eor #$FF		;F7EC 49 FF
		bne L_F802		;F7EE D0 12
		ldy L_3DF8		;F7F0 AC F8 3D
		bmi L_F802		;F7F3 30 0D
ENDIF

		ldx #KEY_RETURN		;F7F5 A2 08
		jsr poll_key_with_sysctl		;F7F7 20 C9 C7
		bne L_F800		;F7FA D0 04
		lda #$10		;F7FC A9 10
		bne L_F802		;F7FE D0 02

.L_F800	lda #$00		;F800 A9 00
.L_F802	and #$1F		;F802 29 1F
		sta ZP_66		;F804 85 66
		rts				;F806 60
}

\\ Control keys moved from here to Hazel RAM

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

.L_F82B_in_kernel
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
L_F8CB	= *-2			;! _SELF_MOD
		bcs L_F8E3		;F8CD B0 14
		sta L_C600,X	;F8CF 9D 00 C6
		cmp L_0240,X	;F8D2 DD 40 02
		bcs L_F8DC		;F8D5 B0 05
		cmp L_C500,X	;F8D7 DD 00 C5
		bcs L_F8E3		;F8DA B0 07
.L_F8DC	lda (ZP_1E),Y	;F8DC B1 1E
.L_F8DE	and color_ram_ptrs_LO,X	;F8DE 3D 00 A4 ;! _SELF_MOD from set_linedraw_op
L_F8DF	= *-2			;! _SELF_MOD from set_linedraw_colour
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
L_F92B	= *-1			;! _SELF_MOD
		dex				;F92C CA
		cpx ZP_89		;F92D E4 89
		bne L_F929		;F92F D0 F8
.L_F931	rts				;F931 60

.L_F932_in_kernel
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
L_F9D2	= *-2			;! _SELF_MOD
		bcs L_F9EA		;F9D4 B0 14
		sta L_C600,X	;F9D6 9D 00 C6
		cmp L_0240,X	;F9D9 DD 40 02
		bcs L_F9E3		;F9DC B0 05
		cmp L_C500,X	;F9DE DD 00 C5
		bcs L_F9EA		;F9E1 B0 07
.L_F9E3	lda (ZP_1E),Y	;F9E3 B1 1E
.L_F9E5	and color_ram_ptrs_LO,X	;F9E5 3D 00 A4 ;! _SELF_MOD from set_linedraw_op
L_F9E6	= *-2			;! _SELF_MOD from set_linedraw_colour
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
L_FA32	= *-1			;! _SELF_MOD
		inx				;FA33 E8
		cpx ZP_89		;FA34 E4 89
		bne L_FA30		;FA36 D0 F8
.L_FA38	rts				;FA38 60

.L_FA39_in_kernel
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
L_FADA	= *-2			;! _SELF_MOD
		bcs L_FAF2		;FADC B0 14
		sta L_C600,X	;FADE 9D 00 C6
		cmp L_0240,X	;FAE1 DD 40 02
		bcs L_FAEB		;FAE4 B0 05
		cmp L_C500,X	;FAE6 DD 00 C5
		bcs L_FAF2		;FAE9 B0 07
.L_FAEB	lda (ZP_1E),Y	;FAEB B1 1E
.L_FAED	and color_ram_ptrs_LO,X	;FAED 3D 00 A4 ;! _SELF_MOD from set_linedraw_op
L_FAEE	= *-2			;! _SELF_MOD from set_linedraw_colour
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

.L_FB19_in_kernel	cmp #$40		;FB19 C9 40
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
L_FBC1	= *-2			;! _SELF_MOD
		bcs L_FBD9		;FBC3 B0 14
		sta L_C600,X	;FBC5 9D 00 C6
		cmp L_0240,X	;FBC8 DD 40 02
		bcs L_FBD2		;FBCB B0 05
		cmp L_C500,X	;FBCD DD 00 C5
		bcs L_FBD9		;FBD0 B0 07
.L_FBD2	lda (ZP_1E),Y	;FBD2 B1 1E
.L_FBD4	and color_ram_ptrs_LO,X	;FBD4 3D 00 A4 ;! _SELF_MOD from set_linedraw_op
L_FBD5	= *-2			;! _SELF_MOD from set_linedraw_colour
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
		sta L_F8DF		;FC07 8D DF F8	_SELF_MOD
		sta L_F9E6		;FC0A 8D E6 F9	_SELF_MOD
		sta L_FAEE		;FC0D 8D EE FA	_SELF_MOD
		sta L_FBD5		;FC10 8D D5 FB
		rts				;FC13 60

.L_FC14	equb $00
		equb $80
}

.set_linedraw_op
{
		sta L_F8DE		;FC16 8D DE F8  _SELF_MOD
		sta L_F9E5		;FC19 8D E5 F9  _SELF_MOD
		sta L_FAED		;FC1C 8D ED FA  _SELF_MOD
		sta L_FBD4		;FC1F 8D D4 FB  _SELF_MOD
		rts				;FC22 60
}

.L_FC23_in_kernel
{
		lda #HI(L_C600)		;FC23 A9 C6
		sta L_F92B		;FC25 8D 2B F9  _SELF_MOD
		sta L_FA32		;FC28 8D 32 FA  _SELF_MOD
		lda #$00		;FC2B A9 00
		ldy #$11		;FC2D A0 11
		bne L_FC4E		;FC2F D0 1D
}
\\
.L_FC31_in_kernel
		lda #HI(L_C500)		;FC31 A9 C5
		sta L_F92B		;FC33 8D 2B F9  _SELF_MOD
		sta L_FA32		;FC36 8D 32 FA  _SELF_MOD
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
		sta L_F8CB,X	;FC56 9D CB F8	_SELF_MOD
		sta L_F9D2,X	;FC59 9D D2 F9	_SELF_MOD
		sta L_FADA,X	;FC5C 9D DA FA	_SELF_MOD
		sta L_FBC1,X	;FC5F 9D C1 FB	_SELF_MOD
		dey				;FC62 88
		dex				;FC63 CA
		bpl L_FC53		;FC64 10 ED
		rts				;FC66 60

\\ Code ($11 bytes) pasted into L_F8CB, L_F9D2, L_FADA, L_FBC1
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
		bcs L_FC99_in_kernel		;FC8B B0 0C
		sta L_C500,X	;FC8D 9D 00 C5
		bcs L_FC99_in_kernel		;FC90 B0 07
		nop				;FC92 EA
		nop				;FC93 EA
		nop				;FC94 EA
		nop				;FC95 EA
		nop				;FC96 EA
		nop				;FC97 EA
		nop				;FC98 EA
\\
.L_FC99_in_kernel
		jsr L_FCA2_in_kernel		;FC99 20 A2 FC
		lda #$E2		;FC9C A9 E2
		ldx #$0B		;FC9E A2 0B
		bne L_FCA6		;FCA0 D0 04
.L_FCA2_in_kernel	lda #$C5		;FCA2 A9 C5
		ldx #$09		;FCA4 A2 09
.L_FCA6	sta L_F8CB,X	;FCA6 9D CB F8
		sta L_F9D2,X	;FCA9 9D D2 F9
		sta L_FADA,X	;FCAC 9D DA FA
		sta L_FBC1,X	;FCAF 9D C1 FB
		rts				;FCB2 60

.L_FCB3_in_kernel
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

.L_FCC5_in_kernel
{
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
}

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
		jmp L_FCC5_in_kernel		;FEA8 4C C5 FC
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
		jmp L_FB19_in_kernel		;FF4C 4C 19 FB
.L_FF4F	lda ZP_8A		;FF4F A5 8A
		jmp L_F932_in_kernel		;FF51 4C 32 F9
.L_FF54	eor #$FF		;FF54 49 FF
		clc				;FF56 18
		adc #$01		;FF57 69 01
		sta ZP_51		;FF59 85 51
		cmp ZP_52		;FF5B C5 52
		bcc L_FF64		;FF5D 90 05
		lda ZP_4E		;FF5F A5 4E
		jmp L_FA39_in_kernel		;FF61 4C 39 FA
.L_FF64	lda ZP_8A		;FF64 A5 8A
		jmp L_F82B_in_kernel		;FF66 4C 2B F8
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
\\
.L_FF8C	sec				;FF8C 38
		rts				;FF8D 60

.L_FF8E
		sta ZP_15		;FF8E 85 15
\\
.L_FF90
{
		lda ZP_14		;FF90 A5 14
		clc				;FF92 18
		rts				;FF93 60
}

.L_FF94_in_kernel
{
		jsr cart_L_9EBC		;FF94 20 BC 9E
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
		ldx vic_sprite_ptr7		;FFB1 AE FF 5F
		ldy vic_sprite_ptr5		;FFB4 AC FD 5F
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
.L_FFDB	stx vic_sprite_ptr7		;FFDB 8E FF 5F
		sty vic_sprite_ptr5		;FFDE 8C FD 5F
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

.kernel_end
