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

.cart_start

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
.L_9212	jmp jmp_L_E9A3		;9212 4C A3 E9
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
.L_95EE	jsr jmp_L_FFE2		;95EE 20 E2 FF
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
		jsr jmp_do_menu_screen		;98B5 20 36 EE
		eor #$03		;98B8 49 03
		sta L_31A7		;98BA 8D A7 31
.L_98BD	lsr L_31A0		;98BD 4E A0 31
		ldy #$02		;98C0 A0 02
		lda L_C76C		;98C2 AD 6C C7
		and #$01		;98C5 29 01
		ldx #$1C		;98C7 A2 1C
		jsr jmp_do_menu_screen		;98C9 20 36 EE
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
		jsr jmp_get_track_segment_detailsQ		;9A3A 20 2F F0
		jsr jmp_L_F0C5		;9A3D 20 C5 F0
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
		jsr jmp_get_track_segment_detailsQ		;9CBF 20 2F F0
		lda #$00		;9CC2 A9 00
		sta L_C359		;9CC4 8D 59 C3
		ldx #$02		;9CC7 A2 02
.L_9CC9	stx ZP_52		;9CC9 86 52
		lda L_C374		;9CCB AD 74 C3
		cmp ZP_2E		;9CCE C5 2E
		beq L_9CDA		;9CD0 F0 08
		tax				;9CD2 AA
		stx ZP_2E		;9CD3 86 2E
		jsr jmp_get_track_segment_detailsQ		;9CD5 20 2F F0
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
		jsr jmp_get_track_segment_detailsQ		;9E7D 20 2F F0
		lda ZP_A4		;9E80 A5 A4
		bpl L_9E9A		;9E82 10 16
		bmi L_9E90		;9E84 30 0A
.L_9E86	jsr L_CFC5		;9E86 20 C5 CF
		jsr jmp_get_track_segment_detailsQ		;9E89 20 2F F0
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
{
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
}

; Not sure what this is used for - depends on which C64 bank is paged in?

L_A000 = $A000		; Cold Start Vector?

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

\\ Lots of data moved to Hazel RAM

ORG $A700
.cosine_table		; $A700
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
.L_B220	equb LO(little_ramp_data)
.L_B221	equb HI(little_ramp_data)
		equw stepping_stones_data
		equw hump_back_data
		equw big_ramp_data
		equw ski_jump_data
		equw draw_bridge_data
		equw high_jump_data
		equw roller_coaster_data
		equb $F5
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

.cart_end
