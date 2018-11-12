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

CLEAR &8000,&C000
ORG &8000
GUARD &C000

.kernel_start

\\ Data removed

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
		jsr jmp_L_E641		;E1C0 20 41 E6
		ldy #$07		;E1C3 A0 07
		ldx #$3E		;E1C5 A2 3E
		jsr jmp_L_E641		;E1C7 20 41 E6
		ldy #$08		;E1CA A0 08
		ldx #$3D		;E1CC A2 3D
		jsr jmp_L_E641		;E1CE 20 41 E6
		ldy #$0A		;E1D1 A0 0A
		ldx #$3F		;E1D3 A2 3F
		jsr jmp_L_E641		;E1D5 20 41 E6
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
		jsr L_E5C7_in_kernel		;E52C 20 C7 E5
		jsr L_CFD2		;E52F 20 D2 CF
		jsr get_track_segment_detailsQ		;E532 20 2F F0
		jmp L_E53B		;E535 4C 3B E5
}

.L_E538	jsr L_E5C7_in_kernel		;E538 20 C7 E5
\\
.L_E53B	lda ZP_D5		;E53B A5 D5
		jsr jmp_L_E808		;E53D 20 08 E8
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
		jsr L_FF94_in_kernel		;E574 20 94 FF
		ldy #$05		;E577 A0 05
		ldx #$04		;E579 A2 04
		lda ZP_4C		;E57B A5 4C
		jsr jmp_L_E631		;E57D 20 31 E6
		lda ZP_B0		;E580 A5 B0
		clc				;E582 18
		adc L_C34D		;E583 6D 4D C3
		sta ZP_4C		;E586 85 4C
		ldx #$01		;E588 A2 01
		jsr L_FF94_in_kernel		;E58A 20 94 FF
		ldy #$07		;E58D A0 07
		ldx #$04		;E58F A2 04
		lda ZP_4C		;E591 A5 4C
		jsr jmp_L_E631		;E593 20 31 E6
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
		jsr get_track_segment_detailsQ		;E5B8 20 2F F0
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
		jmp L_2809		;E65B 4C 09 28
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
.L_E8A2	jsr jmp_L_E8E5		;E8A2 20 E5 E8
		jsr L_E92C_in_kernel		;E8A5 20 2C E9
		jsr jmp_L_E9A3		;E8A8 20 A3 E9
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
		jsr jmp_L_E8C2		;E8E5 20 C2 E8
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
		jsr jmp_L_E8C2		;E9A3 20 C2 E8
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

.get_next_ptr_byte		\\ only called from Kernel fns
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
		jsr L_EBF3_in_kernel		;EB1D 20 F3 EB
		sta ZP_15		;EB20 85 15
		lda ZP_51		;EB22 A5 51
		sec				;EB24 38
		sbc ZP_14		;EB25 E5 14
		sta L_0538,X	;EB27 9D 38 05
		lda ZP_77		;EB2A A5 77
		sbc ZP_15		;EB2C E5 15
		sta L_0586,X	;EB2E 9D 86 05
		ldy ZP_BE		;EB31 A4 BE
		jsr L_EBF3_in_kernel		;EB33 20 F3 EB
		sta ZP_15		;EB36 85 15
		lda L_0538,X	;EB38 BD 38 05
		clc				;EB3B 18
		adc ZP_14		;EB3C 65 14
		sta ZP_51		;EB3E 85 51
		lda L_0586,X	;EB40 BD 86 05
		adc ZP_15		;EB43 65 15
		sta ZP_77		;EB45 85 77
		ldy #$00		;EB47 A0 00
		jsr L_EBEB_in_kernel		;EB49 20 EB EB
		sta ZP_15		;EB4C 85 15
		lda ZP_52		;EB4E A5 52
		sec				;EB50 38
		sbc ZP_14		;EB51 E5 14
		sta L_05D4,X	;EB53 9D D4 05
		lda ZP_78		;EB56 A5 78
		sbc ZP_15		;EB58 E5 15
		sta L_0622,X	;EB5A 9D 22 06
		ldy ZP_BE		;EB5D A4 BE
		jsr L_EBEB_in_kernel		;EB5F 20 EB EB
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
		jsr jmp_do_menu_screen		;EF4C 20 36 EE
		cmp #$02		;EF4F C9 02
		beq L_EF2C		;EF51 F0 D9
		bcc L_EF06		;EF53 90 B1
		jsr delay_approx_4_5ths_sec		;EF55 20 E9 3F
		ldy #$03		;EF58 A0 03
		lda #$03		;EF5A A9 03
		ldx #$04		;EF5C A2 04
		jsr jmp_do_menu_screen		;EF5E 20 36 EE
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
		jsr L_F6D7_in_kernel		;EF81 20 D7 F6
		bcc L_EFF4		;EF84 90 6E
.L_EF86	jsr jmp_L_E85B		;EF86 20 5B E8
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
		jsr jmp_do_menu_screen		;EFAE 20 36 EE
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
.L_EFF4	jsr L_3500		;EFF4 20 00 35
		jsr set_up_screen_for_frontend		;EFF7 20 04 35
		jsr L_36AD		;EFFA 20 AD 36
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

.L_F3FC	equb $04,$00,$04,$08
.L_F400	equb $00,$04,$08,$04
.L_F404	equb $00,$40,$80,$C0
.L_F408	equb $4C,$0B,$F4,$86,$16,$A5,$77,$18,$10,$01,$38,$6A,$66,$51,$85,$77
}

.L_F418			\\ Unused?
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
		jsr jmp_L_F668		;F6D1 20 68 F6
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

.L_FC14	equb $00
		equb $80
}

.set_linedraw_op
{
		sta L_F8DE		;FC16 8D DE F8
		sta L_F9E5		;FC19 8D E5 F9
		sta L_FAED		;FC1C 8D ED FA
		sta L_FBD4		;FC1F 8D D4 FB
		rts				;FC22 60
}

.L_FC23_in_kernel
{
		lda #$C6		;FC23 A9 C6
		sta L_F92B		;FC25 8D 2B F9
		sta L_FA32		;FC28 8D 32 FA
		lda #$00		;FC2B A9 00
		ldy #$11		;FC2D A0 11
		bne L_FC4E		;FC2F D0 1D
}
\\
.L_FC31_in_kernel
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
.L_FF8C	sec				;FF8C 38
		rts				;FF8D 60

.L_FF8E
{
		sta ZP_15		;FF8E 85 15
		lda ZP_14		;FF90 A5 14
		clc				;FF92 18
		rts				;FF93 60
}

.L_FF94_in_kernel
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

.kernel_end

; *****************************************************************************
; KERNEL RAM Area
; *****************************************************************************

PRINT "-----------"
PRINT "KERNEL RAM"
PRINT "-----------"
PRINT "Start =", ~kernel_start
PRINT "End =", ~kernel_end
PRINT "Size =", ~(kernel_end - kernel_start)

SAVE "Kernel", kernel_start, kernel_end, 0
PRINT "-------"
