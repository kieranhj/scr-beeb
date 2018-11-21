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

.multicolour_mode			; in Cart
{
		lda VIC_SCROLX		;83C0 AD 16 D0
		ora #$10		;83C3 09 10
		sta VIC_SCROLX		;83C5 8D 16 D0
		lda #$78		;83C8 A9 78
		bne vic_memory_setup		;83CA D0 0A
}
\\
.non_multicolour_mode		; in Cart
{
		lda VIC_SCROLX		;83CC AD 16 D0
		and #$EF		;83CF 29 EF
		sta VIC_SCROLX		;83D1 8D 16 D0
		lda #$F0		;83D4 A9 F0
}
\\
.vic_memory_setup			; in Cart
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

.L_83F7_with_vic			; in Cart
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
		jsr L_8428_in_cart		;8411 20 28 84
		rts				;8414 60
		
.L_8415	equb $00
}

.clear_colour_mapQ			; in Cart
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

.L_8428_in_cart
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

; Print char.
; entry: A	= char to print	(also 127=del, 9=space,	VDU31 a	la OSWRCH)
.write_char			; HAS DLL
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

.write_char_body	; in Cart
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
		adc #LO(font_data - $100)		;84DD 69 C0
		sta ZP_F0		;84DF 85 F0
		lda ZP_F1		;84E1 A5 F1
		and #$07		;84E3 29 07
		adc #HI(font_data - $100)		;84E5 69 7F
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

.L_846D	equb $00
.L_846E	equb $00

.L_85C5	equb $00
.L_85C6	equb $00

.L_85CA	equb $00
.L_85CB	equb $00
.L_85CC	equb $00
.L_85CD	equb $00
}

\\ Temporary storage for registers A,X,Y
.L_85C7	equb $00
.L_85C8	equb $00
.L_85C9	equb $00

.L_85D0	equb $00
.L_85D1	equb $00

; poll for	key.
; entry: X=key number (column in bits 0-3,	row in bits 3-6).
; entry: X=key number (bits 0-2 = row, bits 3-5 = column read off)
; exit: X=0, Z=1, N=0, if key not pressed;	X=$FF, Z=0, N=1	if key pressed.

.poll_key			; in Cart
{
IF _NOT_BEEB
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
ELSE
	TXA
	EOR #&80
	TAX
	LDA #&79
	JSR osbyte
	TXA
	BMI key_pressed
	LDX #0
	RTS
	.key_pressed
	LDX #&FF
	RTS
ENDIF
}

.getch				; HAS DLL
{
		stx L_85C8		;8603 8E C8 85
		sty L_85C9		;8606 8C C9 85

.L_8609	ldx L_85CF		;8609 AE CF 85
		jsr poll_key		;860C 20 D2 85
		bmi L_8609		;860F 30 F8
.L_8611	lda #$00		;8611 A9 00
		sta L_85CE		;8613 8D CE 85
		ldx #KEY_LEFT_SHIFT		;8616 A2 39
		jsr poll_key		;8618 20 D2 85
		bmi L_8629		;861B 30 0C
		ldx #KEY_RIGHT_SHIFT		;861D A2 26
		jsr poll_key		;861F 20 D2 85
		bmi L_8629		;8622 30 05
		lda #$40		;8624 A9 40
		sta L_85CE		;8626 8D CE 85
.L_8629	ldx #$7F		;8629 A2 3F
.L_862B	stx ZP_FA		;862B 86 FA
		cpx #KEY_LEFT_SHIFT		;862D E0 39
		beq L_863A		;862F F0 09
		cpx #KEY_RIGHT_SHIFT		;8631 E0 26
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
		lda ikn_to_ascii,X	;864A BD 25 91

		ldx L_85C8		;864D AE C8 85
		ldy L_85C9		;8650 AC C9 85
		clc				;8653 18
		rts				;8654 60

.L_85CE	equb $00
.L_85CF	equb $00

\\ Converts C64 key matrix codes to ASCII
\\ Upper case
.L_9125	equb $7F,$33,$35,$37,$39,$2B,$5C,$31, $0D,$57,$52,$59,$49,$50,$2A,$00
		equb $00,$41,$44,$47,$4A,$4C,$3B,$00, $00,$34,$36,$38,$30,$2D,$1E,$32
		equb $00,$5A,$43,$42,$4D,$2E,$10,$20, $00,$53,$46,$48,$4B,$3A,$3D,$01
		equb $00,$45,$54,$55,$4F,$40,$5E,$51, $00,$10,$58,$56,$4E,$2C,$2F,$00
\\ Lower case
		equb $7F,$33,$35,$37,$39,$2B,$5C,$31, $0D,$77,$72,$79,$69,$70,$2A,$00
		equb $00,$61,$64,$67,$6A,$6C,$3B,$00, $00,$34,$36,$38,$30,$2D,$1E,$32
		equb $00,$7A,$63,$62,$6D,$2E,$00,$20, $00,$73,$66,$68,$6B,$3A,$3D,$01
		equb $00,$65,$74,$75,$6F,$40,$5E,$71, $00,$00,$78,$76,$6E,$2C,$3F,$00

.ikn_to_ascii
\\ Starting at &10
		equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00, $00,$00,$00,$00,$00,$00
		equb 'Q','3','4','5',$00,'8',$00,'-','^',$00, $00,$00,$00,$00,$00,$00
		equb $00,'W','E','T','7','9','I','0','_',$00, $00,$00,$00,$00,$00,$00
		equb '1','2','D',$00,'6','U','O','P','[',$00, $00,$00,$00,$00,$00,$00
		equb $00,'A','X','F','Y','J','K','@',':',$0D, $00,$00,$00,$00,$00,$00
		equb $00,'S','C','G','H','N','L',';',']',$7F, $00,$00,$00,$00,$00,$00
		equb $00,'Z',$00,'V','B','M',$00,'.','/',$00, $00,$00,$00,$00,$00,$00
		equb $1F,$00,$00,$00,$00,$00,$00,$00,'\',$00, $00,$00,$00,$00,$00,$00
}

; *****************************************************************************
; SID
; *****************************************************************************

.sid_process				; only called from Kernel?
{
		stx ZP_F8		;8655 86 F8
		sty ZP_F9		;8657 84 F9
		ldy #$00		;8659 A0 00
		lda (ZP_F8),Y	;865B B1 F8
		tax				;865D AA
		sta L_86C6		;865E 8D C6 86
		lda #$80		;8661 A9 80
		sta L_86C8_sid,X	;8663 9D C8 86
		lda L_86DC_sid,X	;8666 BD DC 86
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
		sta L_86D8_sid,X	;86A7 9D D8 86
		ldy #$04		;86AA A0 04
		lda (ZP_F8),Y	;86AC B1 F8
		sta L_86CC_sid,X	;86AE 9D CC 86
		dey				;86B1 88
		lda (ZP_F8),Y	;86B2 B1 F8
		and #$0F		;86B4 29 0F
		tay				;86B6 A8
		lda L_86DF,Y	;86B7 B9 DF 86
		sta L_86DO_sid,X	;86BA 9D D0 86
		ldy #$06		;86BD A0 06
		lda (ZP_F8),Y	;86BF B1 F8
		sta L_86C8_sid,X	;86C1 9D C8 86
		rts				;86C4 60

.L_86C5	equb $00
.L_86C6	equb $00,$00

.L_86DF	equb $01,$02,$03,$03,$06,$09,$0B,$0C,$0F,$26,$4B,$78,$96,$FF,$FF,$FF
}

.L_86C8_sid	equb $00,$00,$00,$00
.L_86CC_sid	equb $00,$00,$00,$00
.L_86DO_sid	equb $00,$00,$00,$00
.L_86D4_sid	equb $00,$00,$00,$00
.L_86D8_sid	equb $00,$00,$00,$00
.L_86DC_sid	equb $00,$07,$0E

.sid_update			; only called from Kernel?
{
		ldx #$01		;86EF A2 01
		lda L_86C8_sid,X	;86F1 BD C8 86
		beq L_870C		;86F4 F0 16
		bmi L_8724		;86F6 30 2C
		dec L_86C8_sid,X	;86F8 DE C8 86
		bne L_8724		;86FB D0 27
		ldy L_86DC_sid,X	;86FD BC DC 86
		lda L_86D8_sid,X	;8700 BD D8 86
		sta SID_VCREG1,Y	;8703 99 04 D4	; SID
		lda L_86DO_sid,X	;8706 BD D0 86
		sta L_86D4_sid,X	;8709 9D D4 86
.L_870C	lda L_86D4_sid,X	;870C BD D4 86
		beq L_8724		;870F F0 13
		dec L_86D4_sid,X	;8711 DE D4 86
		bne L_8724		;8714 D0 0E
}
\\
.silence_channel		; in Cart - only called from sysctl
{
		ldy L_86DC_sid,X	;8716 BC DC 86
		lda #$00		;8719 A9 00
		sta L_86C8_sid,X	;871B 9D C8 86
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

.sysctl		; HAS DLL
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

.L_877E	jmp poll_key		;877E 4C D2 85

.L_8781	sta ZP_FE			;8781 85 FE
		jmp non_multicolour_mode			;8783 4C CC 83

.L_8786	sta ZP_FE			;8786 85 FE
		jmp multicolour_mode			;8788 4C C0 83

.L_878B	txa					;878B 8A
		jmp L_8428_in_cart			;878C 4C 28 84

.L_878F	stx L_85D0			;878F 8E D0 85
		rts				;8792 60

.L_8793	lda #$02			;8793 A9 02
		sta ZP_FE			;8795 85 FE
		jmp L_83F7_with_vic			;8797 4C F7 83

.L_879A	jmp fill_64s		;879A 4C 21 89
.L_879D	jmp copy_stuff		;879D 4C 6A 88		BEEB TODO copy_stuff
.L_87A0	jmp move_draw_bridgeQ		;87A0 4C 4A 89
.L_87A3	jmp draw_horizonQ		;87A3 4C 2F 8A
.L_87A6	jmp L_8AA5_from_sysctl		;87A6 4C A5 8A
.L_87A9	jmp draw_crane		;87A9 4C 51 8B
.L_87AC	jmp L_8C0D_from_sysctl		;87AC 4C 0D 8C
.L_87AF	jmp L_8CD0_from_sysctl		;87AF 4C D0 8C
.L_87B2	jmp L_8D15_from_sysctl		;87B2 4C 15 8D
.L_87B5	jmp draw_tachometer		;87B5 4C 77 8E
.L_87B8	jmp L_8F11_from_sysctl		;87B8 4C 11 8F
.L_87BB	jmp clear_screen		;87BB 4C 82 8F
.L_87BE	jmp update_colour_map		;87BE 4C 57 90
.L_87C1	jmp sysctl_47		;87C1 4C BB 90
}

.sysctl_copy_menu_header_graphic		; in Cart
{
		lda #$00		;87C4 A9 00
		sta VIC_IRQMASK		;87C6 8D 1A D0
		sei				;87C9 78
		lda #$34		;87CA A9 34
		sta RAM_SELECT		;87CC 85 01
		lda #LO(L_D440)		;87CE A9 40
		sta ZP_1E		;87D0 85 1E
		lda #HI(L_D440)		;87D2 A9 D4
		sta ZP_1F		;87D4 85 1F
		ldx #$00		;87D6 A2 00
.L_87D8	ldy #$00		;87D8 A0 00
		lda L_D400,X	;87DA BD 00 D4	; SID
		sta ZP_08		;87DD 85 08
		bne L_87E2		;87DF D0 01
		iny				;87E1 C8
.L_87E2	sty ZP_16		;87E2 84 16
		lda L_D401,X	;87E4 BD 01 D4	; SID
		sta ZP_20		;87E7 85 20
		lda L_D402,X	;87E9 BD 02 D4	; SID
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
; If X bit	7 reset, copy $57C0->$62A0, $D800->$6DE0, $D000(RAM)
.copy_stuff			; in Cart
{
		stx ZP_16		;886A 86 16
		lda #HI(L_57C0)		;886C A9 57
		sta ZP_1F		;886E 85 1F
		lda #LO(L_57C0)		;8870 A9 C0
		sta ZP_1E		;8872 85 1E
		lda #HI(L_62A0)		;8874 A9 62
		sta ZP_21		;8876 85 21
		lda #LO(L_62A0)		;8878 A9 A0
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
.L_88B2	lda L_D800,X	;88B2 BD 00 D8		; COLOR RAM
		sta L_6DE0,X	;88B5 9D E0 6D
		lda L_D900,X	;88B8 BD 00 D9		; COLOR RAM
		sta L_6F20,X	;88BB 9D 20 6F
		lda L_DA00,X	;88BE BD 00 DA		; COLOR RAM
		sta L_7060,X	;88C1 9D 60 70
		lda L_DB00,X	;88C4 BD 00 DB		; COLOR RAM
		sta L_71A0,X	;88C7 9D A0 71
		dex				;88CA CA
		bne L_88B2		;88CB D0 E5
		rts				;88CD 60
.L_88CE	lda L_6DE0,X	;88CE BD E0 6D
		sta L_D800,X	;88D1 9D 00 D8		; COLOR RAM
		lda L_6F20,X	;88D4 BD 20 6F
		sta L_D900,X	;88D7 9D 00 D9		; COLOR RAM
		lda L_7060,X	;88DA BD 60 70
		sta L_DA00,X	;88DD 9D 00 DA		; COLOR RAM
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
.fill_64s			; in Cart
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

.move_draw_bridgeQ			; in Cart
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

.draw_horizonQ				; in Cart
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

.L_8AA5_from_sysctl			; in Cart
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
.draw_crane			; in Cart
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

.L_8C0D_from_sysctl			; in Cart
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

.L_8CD0_from_sysctl			; in Cart
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

.L_8D15_from_sysctl			; in Cart
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

.draw_tachometer			; in Cart
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

.L_8F11_from_sysctl			; in Cart
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

.clear_screen				; in Cart
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

.L_8F81	equb $00
}

.update_colour_map			; in Cart
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

.sysctl_47			; in Cart
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

.print_3space		; HAS DLL
		lda #$20		;91A5 A9 20
		jsr write_char		;91A7 20 6F 84
.print_2space		; HAS DLL
		lda #$20		;91AA A9 20
		jsr write_char		;91AC 20 6F 84
.print_space		; HAS DLL
		lda #$20		;91AF A9 20
		jmp write_char		;91B1 4C 6F 84

.L_91B4				; HAS DLL
{
		lda #$80		;91B4 A9 80
		sta L_31A5		;91B6 8D A5 31
		jsr L_91C3		;91B9 20 C3 91
		jsr L_3626_from_game_start		;91BC 20 26 36
		asl L_31A5		;91BF 0E A5 31
		rts				;91C2 60
}

.L_91C3				; HAS DLL
{
		lda #$80		;91C3 A9 80
		sta L_C39C		;91C5 8D 9C C3
		jsr L_3626_from_game_start		;91C8 20 26 36
		asl L_C39C		;91CB 0E 9C C3
		rts				;91CE 60
}

.L_91CF				; HAS DLL
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
		jsr kernel_set_text_cursor		;91FA 20 6B 10
		ldx #$2F		;91FD A2 2F
		jsr print_msg_1		;91FF 20 A5 32
		ldx L_C76D		;9202 AE 6D C7
		beq L_9212		;9205 F0 0B
		inc L_C734,X	;9207 FE 34 C7
		jsr print_driver_name		;920A 20 8B 38
		ldx #$EF		;920D A2 EF
		jsr print_msg_4		;920F 20 27 30
.L_9212	jmp kernel_L_E9A3		;9212 4C A3 E9
}

.convert_X_to_BCD		; HAS DLL
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

.L_9225				; HAS DLL
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
		jsr kernel_set_text_cursor		;928C 20 6B 10
		ldx #$2F		;928F A2 2F
		jsr print_msg_1		;9291 20 A5 32
		ldx #$C9		;9294 A2 C9
		jsr print_msg_3		;9296 20 DC A1
		jsr print_space		;9299 20 AF 91
		ldx #$0E		;929C A2 0E
		jmp L_99FF		;929E 4C FF 99
.L_92A1	rts				;92A1 60
}

.L_9319				; HAS DLL
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

.L_936E
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

.L_93A8				; HAS DLL
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

.L_93E0			; continuation of fn L_93A8
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

.L_9448				; HAS DLL
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
		jsr kernel_set_text_cursor		;94A6 20 6B 10
		ldx #$57		;94A9 A2 57
		jsr write_file_string		;94AB 20 E2 95
		jsr getch		;94AE 20 03 86
		ldx #$19		;94B1 A2 19
.L_94B3	lda #$7F		;94B3 A9 7F
		jsr write_char		;94B5 20 6F 84
		dex				;94B8 CA
		bne L_94B3		;94B9 D0 F8
		ldx #$14		;94BB A2 14
		ldy #$13		;94BD A0 13
		jsr kernel_set_text_cursor		;94BF 20 6B 10
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

\\ Data moved from file_strings_offset to Hazel RAM

.L_95DE			; not an entry point
		jsr write_char		;95DE 20 6F 84
		inx				;95E1 E8
.write_file_string			; HAS DLL
		lda file_strings,X	;95E2 BD 35 95
		cmp #$FF		;95E5 C9 FF
		bne L_95DE		;95E7 D0 F5
		rts				;95E9 60

.L_95EA			; HAS DLL
{
		ldx #$00		;95EA A2 00
		lda #$01		;95EC A9 01
.L_95EE	jsr kernel_L_FFE2		;95EE 20 E2 FF
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

.L_967E				; in Cart
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

.L_96A8				; in Cart
{
		lda #$00		;96A8 A9 00
		jmp L_96AF		;96AA 4C AF 96
}

.L_96AD				; in Cart
		lda #$80		;96AD A9 80
\\
.L_96AF				; in Cart
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
.L_96E1				; in Cart
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

.L_9746				; in Cart
{
		jsr L_96A8		;9746 20 A8 96
		inc ZP_1F		;9749 E6 1F
		jmp L_96E1		;974B 4C E1 96
}

.L_974E				; in Cart
{
		jsr L_96AD		;974E 20 AD 96
		inc ZP_1F		;9751 E6 1F
		jmp L_96E1		;9753 4C E1 96
}

.L_9756				; in Cart
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

.maybe_define_keys			; HAS DLL
{
		ldx #KEY_DEF_REDEFINE		;97AF A2 20
		jsr kernel_poll_key_with_sysctl		;97B1 20 C9 C7
		beq L_97B7		;97B4 F0 01
		rts				;97B6 60
.L_97B7	ldy #$64		;97B7 A0 64
		lda #$04		;97B9 A9 04
		jsr kernel_set_up_text_sprite		;97BB 20 A9 12
		lda #$01		;97BE A9 01
		sta L_983B		;97C0 8D 3B 98
.L_97C3	ldy #$28		;97C3 A0 28
		jsr delay_approx_Y_25ths_sec		;97C5 20 EB 3F
		ldx #$04		;97C8 A2 04
.L_97CA	stx L_983A		;97CA 8E 3A 98
		ldy L_9841,X	;97CD BC 41 98
		lda #$04		;97D0 A9 04
		jsr kernel_set_up_text_sprite		;97D2 20 A9 12
.L_97D5	ldx #KEY_DEF_CANCEL		;97D5 A2 3F
.L_97D7	stx ZP_17		;97D7 86 17
		jsr kernel_poll_key_with_sysctl		;97D9 20 C9 C7
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
		jsr kernel_set_up_text_sprite		;97F4 20 A9 12
		ldy #$28		;97F7 A0 28
		jsr delay_approx_Y_25ths_sec		;97F9 20 EB 3F
		jmp L_97B7		;97FC 4C B7 97
.L_97FF	sta control_keys,Y	;97FF 99 07 F8
.L_9802	lda #$00		;9802 A9 00
		jsr kernel_L_CF68		;9804 20 68 CF
.L_9807	ldx ZP_17		;9807 A6 17
		jsr kernel_poll_key_with_sysctl		;9809 20 C9 C7
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
		jsr kernel_set_up_text_sprite		;982C 20 A9 12
		jmp L_97C3		;982F 4C C3 97
.L_9832	ldy #$4C		;9832 A0 4C
		lda #$02		;9834 A9 02
		jsr kernel_set_up_text_sprite		;9836 20 A9 12
		rts				;9839 60

.L_983A	equb $00
.L_983B	equb $00
.L_983C	equb $00,$01,$04,$03,$02
.L_9841	equb $B4,$A4,$94,$84,$74
}

.store_restore_control_keys			; HAS DLL
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

.L_986F
		lda control_keys,X	;986F BD 07 F8
		sta L_987A,Y	;9872 99 7A 98
		dey				;9875 88
		dex				;9876 CA
		bpl L_986F		;9877 10 F6
		rts				;9879 60

.L_987A	equb $2E,$27,$29,$12,$08
		equb $2E,$27,$29,$12,$08
		equb $2E,$27,$29,$12,$08
		equb $2E,$27,$29,$12,$08
		equb $2E,$27,$29,$12,$08
		equb $2E,$27,$29,$12,$08
		equb $2E,$27,$29,$12,$08
		equb $2E,$27,$29,$12,$08
}

.L_99FF				; HAS DLL
{
		lda L_8398,X	;99FF BD 98 83
		cmp #$09		;9A02 C9 09
		bcs L_9A27		;9A04 B0 21
		ora L_82B0,X	;9A06 1D B0 82
		beq L_9A27		;9A09 F0 1C
		lda L_8398,X	;9A0B BD 98 83
		jsr kernel_print_single_digit		;9A0E 20 8A 10
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

.L_9A38				; HAS DLL
{
		ldx ZP_2E		;9A38 A6 2E
		jsr kernel_get_track_segment_detailsQ		;9A3A 20 2F F0
		jsr kernel_L_F0C5		;9A3D 20 C5 F0
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
		jsr kernel_mul_8_16_16bit		;9A89 20 45 C8
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
		jsr kernel_mul_8_16_16bit		;9AAF 20 45 C8
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
		jsr kernel_shift_16bit		;9B02 20 BF C9
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
		jsr kernel_negate_if_N_set		;9B3C 20 BD C8
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
		jsr kernel_mul_8_8_16bit		;9B59 20 82 C7
		lsr A			;9B5C 4A
		ror ZP_14		;9B5D 66 14
		ldy ZP_16		;9B5F A4 16
		jsr kernel_shift_16bit		;9B61 20 BF C9
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
		jsr kernel_L_CFD2		;9B81 20 D2 CF
		jmp L_9B8A		;9B84 4C 8A 9B
.L_9B87	jsr kernel_L_CFC5		;9B87 20 C5 CF
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
		jsr kernel_negate_if_N_set		;9BB4 20 BD C8
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
		jsr kernel_mul_8_8_16bit		;9BF5 20 82 C7
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
		jsr kernel_shift_16bit		;9C0A 20 BF C9
		sta ZP_C2		;9C0D 85 C2
		lda ZP_14		;9C0F A5 14
		sta ZP_C1		;9C11 85 C1
		rts				;9C13 60
}

.L_9C14				; HAS DLL
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

.L_9C79				; in Cart
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
.L_9CBA_from_game_update		; in Cart
{
		ldx L_C374		;9CBA AE 74 C3
		stx ZP_2E		;9CBD 86 2E
		jsr kernel_get_track_segment_detailsQ		;9CBF 20 2F F0
		lda #$00		;9CC2 A9 00
		sta L_C359		;9CC4 8D 59 C3
		ldx #$02		;9CC7 A2 02
.L_9CC9	stx ZP_52		;9CC9 86 52
		lda L_C374		;9CCB AD 74 C3
		cmp ZP_2E		;9CCE C5 2E
		beq L_9CDA		;9CD0 F0 08
		tax				;9CD2 AA
		stx ZP_2E		;9CD3 86 2E
		jsr kernel_get_track_segment_detailsQ		;9CD5 20 2F F0
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
		jsr kernel_mul_8_8_16bit		;9D36 20 82 C7
		ldy ZP_16		;9D39 A4 16
		beq L_9D40		;9D3B F0 03
		jsr kernel_negate_16bit		;9D3D 20 BF C8
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
		jsr kernel_L_C81E		;9D7B 20 1E C8
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

.L_9E08				; in Cart
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

.L_9E74				; in Cart
{
		lda ZP_BF		;9E74 A5 BF
		eor ZP_A4		;9E76 45 A4
		bpl L_9E86		;9E78 10 0C
		jsr kernel_L_CFD2		;9E7A 20 D2 CF
		jsr kernel_get_track_segment_detailsQ		;9E7D 20 2F F0
		lda ZP_A4		;9E80 A5 A4
		bpl L_9E9A		;9E82 10 16
		bmi L_9E90		;9E84 30 0A
.L_9E86	jsr kernel_L_CFC5		;9E86 20 C5 CF
		jsr kernel_get_track_segment_detailsQ		;9E89 20 2F F0
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

.L_9EBC				; HAS DLL
{
		lda #$00		;9EBC A9 00
		sta ZP_5A		;9EBE 85 5A
		lda ZP_4C		;9EC0 A5 4C
		sta ZP_15		;9EC2 85 15
		lda ZP_49		;9EC4 A5 49
		sec				;9EC6 38
		sbc ZP_48		;9EC7 E5 48
		jsr kernel_L_C81E		;9EC9 20 1E C8
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
		jsr kernel_L_C81E		;9EE8 20 1E C8
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
		jsr kernel_mul_8_16_16bit_2		;9F2E 20 47 C8
		ldy #$FD		;9F31 A0 FD
		jsr kernel_shift_16bit		;9F33 20 BF C9
		sta ZP_15		;9F36 85 15
		lda ZP_2D		;9F38 A5 2D
		sta ZP_16		;9F3A 85 16
		jmp L_9F56		;9F3C 4C 56 9F
.L_9F3F	bne L_9F1D		;9F3F D0 DC
		bit ZP_16		;9F41 24 16
		bmi L_9F1D		;9F43 30 D8
.L_9F45	lda ZP_16		;9F45 A5 16
		jsr kernel_mul_8_16_16bit_2		;9F47 20 47 C8
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

.L_9F6A				; in Cart
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

.L_9FB8				; in Cart
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
		jsr kernel_mul_8_16_16bit		;A003 20 45 C8
		ldy #$04		;A006 A0 04
		jsr kernel_shift_16bit		;A008 20 BF C9
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

; fetch coordinates (?) from track	data pointed by	(word_9a) with postincrement, munged appropriately for camera
; entry: Y	= index	into (word_9A) data
; exit: Y points after data read

.L_A026				; HAS DLL
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
.L_A0DC	jsr kernel_negate_if_N_set		;A0DC 20 BD C8
		cmp #$00		;A0DF C9 00
		bne L_A123		;A0E1 D0 40
		ldy #$FC		;A0E3 A0 FC
		jsr kernel_shift_16bit		;A0E5 20 BF C9
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

.L_A1C7	jsr write_char		;A1C7 20 6F 84
		inx				;A1CA E8
.print_msg_2		; HAS DLL
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
.print_msg_3		; HAS DLL
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

; *****************************************************************************
; Fns moved from Core RAM so data can reside there
; *****************************************************************************

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
ELSE
skip 19
ENDIF

.reset_sprites		; HAS DLL
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
.L_14D0_from_main_loop		; HAS DLL
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

.L_1572			; in Cart - only called from update_damage_display
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
		jsr kernel_set_up_text_sprite		;158A 20 A9 12
.L_158D	rts				;158D 60
}

.L_158E			; in Cart - only called from update_aicar
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

.L_1611				; HAS DLL
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

.save_rndQ_stateQ	; HAS DLL
{
		ldx #$04		;162C A2 04
.L_162E	lda ZP_02,X		;162E B5 02
		sta L_1648,X	;1630 9D 48 16
		dex				;1633 CA
		bpl L_162E		;1634 10 F8
		rts				;1636 60

.L_1648	equb $B1,$65,$3B,$17,$3B
}

.L_1637				; HAS DLL
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

.start_of_frame		; in Cart
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
		jsr kernel_L_F1DC		;1669 20 DC F1
		lda #$00		;166C A9 00
		sta L_C3A9		;166E 8D A9 C3
		sta L_C3DA		;1671 8D DA C3
		sta ZP_6D		;1674 85 6D
;L_1676
		sta L_C303		;1676 8D 03 C3
		rts				;1679 60
}

; only called from main loop - pretty sure this is main draw function for track etc.

.draw_trackQ		; HAS DLL
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
		jsr kernel_L_FF6A		;168E 20 6A FF
		bcs L_16A2		;1691 B0 0F
		cmp #$FF		;1693 C9 FF
		bne L_16B4		;1695 D0 1D
		lda ZP_AF		;1697 A5 AF
		ldy ZP_B1		;1699 A4 B1
		jsr kernel_L_F117		;169B 20 17 F1
		cmp #$FF		;169E C9 FF
		bne L_16B4		;16A0 D0 12
.L_16A2	lda #$C0		;16A2 A9 C0
		sta ZP_6B		;16A4 85 6B
		lda L_C76C		;16A6 AD 6C C7
		bpl L_16B1		;16A9 10 06
		jsr update_aicar		;16AB 20 85 1E
		jsr kernel_L_E4DA		;16AE 20 DA E4
.L_16B1	jmp L_1757		;16B1 4C 57 17
.L_16B4	sta ZP_2E		;16B4 85 2E
		jsr L_9A38		;16B6 20 38 9A
		jsr kernel_L_F2B7		;16B9 20 B7 F2
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
		jsr kernel_L_F585		;16D9 20 85 F5
		jsr L_1D25		;16DC 20 25 1D
		jsr kernel_L_E4DA		;16DF 20 DA E4
.L_16E2	lda L_C374		;16E2 AD 74 C3
		sta ZP_2E		;16E5 85 2E
		lda #$00		;16E7 A9 00
		sta ZP_D0		;16E9 85 D0
		lda ZP_8E		;16EB A5 8E
		bpl L_16F6		;16ED 10 07
		jsr kernel_L_CFC5		;16EF 20 C5 CF
		lda #$00		;16F2 A9 00
		sta ZP_8E		;16F4 85 8E
.L_16F6	lda ZP_8E		;16F6 A5 8E
		bne L_1707		;16F8 D0 0D
		jsr kernel_L_CFD2		;16FA 20 D2 CF
		cpx ZP_A6		;16FD E4 A6
		bne L_1704		;16FF D0 03
		jsr kernel_L_E195		;1701 20 95 E1
.L_1704	jsr kernel_L_CFC5		;1704 20 C5 CF
.L_1707	jsr L_177D		;1707 20 7D 17
		jsr L_1B0B		;170A 20 0B 1B
		jsr L_1A3B		;170D 20 3B 1A
		lda #$00		;1710 A9 00
		sta ZP_27		;1712 85 27
		lda #$02		;1714 A9 02
		sta ZP_D0		;1716 85 D0
		jsr L_1909		;1718 20 09 19
		jsr kernel_L_CFC5		;171B 20 C5 CF
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
.L_1747	jsr kernel_L_CFC5		;1747 20 C5 CF
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

.L_177D				; HAS DLL
{
		ldx ZP_2E		;177D A6 2E
		jsr kernel_get_track_segment_detailsQ		;177F 20 2F F0
		ldx ZP_2E		;1782 A6 2E
		jsr kernel_L_F0C5		;1784 20 C5 F0
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
		jsr kernel_L_F440		;17C5 20 40 F4
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

.L_1909				; in Cart
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

.L_1948			; in Cart
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

.L_1A3B				; HAS DLL
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
.L_1A65	jsr kernel_set_linedraw_colour		;1A65 20 01 FC
		lda ZP_C6		;1A68 A5 C6
		lsr A			;1A6A 4A
		sec				;1A6B 38
		sbc #$01		;1A6C E9 01
		cmp ZP_A3		;1A6E C5 A3
		bne L_1A7B		;1A70 D0 09
		lda ZP_A6		;1A72 A5 A6
		cmp ZP_2E		;1A74 C5 2E
		bne L_1A7B		;1A76 D0 03
		jsr kernel_L_E195		;1A78 20 95 E1
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
		jsr kernel_L_E1B1		;1AB7 20 B1 E1
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
		jsr kernel_set_linedraw_colour		;1AD7 20 01 FC
		jsr L_CF73		;1ADA 20 73 CF
		ldx ZP_C6		;1ADD A6 C6
		txa				;1ADF 8A
		eor #$01		;1AE0 49 01
		tay				;1AE2 A8
		jsr kernel_L_FE91_with_draw_line		;1AE3 20 91 FE
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

.L_1AF7				; in Cart
{
		ldx ZP_C6		;1AF7 A6 C6
		ldy ZP_A0		;1AF9 A4 A0
		lda ZP_CC,Y		;1AFB B9 CC 00
		tay				;1AFE A8
		jmp kernel_L_FE91_with_draw_line		;1AFF 4C 91 FE
}

.L_1B02				; in Cart
{
		ldx ZP_C6		;1B02 A6 C6
		txa				;1B04 8A
		ora #$20		;1B05 09 20
		tay				;1B07 A8
		jmp kernel_L_FE91_with_draw_line		;1B08 4C 91 FE
}

.L_1B0B				; in Cart
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
		jsr kernel_L_E808		;1B45 20 08 E8
		ldx ZP_C7		;1B48 A6 C7
		ldy #$04		;1B4A A0 04
		lda ZP_8D		;1B4C A5 8D
		jsr kernel_L_E631		;1B4E 20 31 E6
		ldx ZP_C6		;1B51 A6 C6
		lda ZP_8D		;1B53 A5 8D
		sta ZP_15		;1B55 85 15
		lda L_8040,X	;1B57 BD 40 80
		sec				;1B5A 38
		sbc L_803E,X	;1B5B FD 3E 80
		sta ZP_14		;1B5E 85 14
		lda L_A330,X	;1B60 BD 30 A3
		sbc L_A32E,X	;1B63 FD 2E A3
		jsr kernel_mul_8_16_16bit		;1B66 20 45 C8
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
		jsr kernel_L_E641		;1B80 20 41 E6
		ldx ZP_C6		;1B83 A6 C6
		jmp L_1B2F		;1B85 4C 2F 1B
}

.update_damage_display		; HAS DLL
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

.draw_crane_with_sysctl		; HAS DLL
{
		lda #$3F		;1C1E A9 3F
		jmp sysctl		;1C20 4C 25 87
}

.clear_menu_area			; HAS DLL
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

.draw_menu_header			; HAS DLL
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

.L_1C64_with_keys			; HAS DLL
{
		jsr kernel_check_game_keys		;1C64 20 9E F7
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
		jsr kernel_update_boosting		;1CC7 20 0F F6
		rts				;1CCA 60
}

.L_1CCB				; HAS DLL
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
		jsr kernel_set_linedraw_op		;1D05 20 16 FC
		ldx #$02		;1D08 A2 02
		ldy #$03		;1D0A A0 03
		jsr kernel_L_FE91_with_draw_line		;1D0C 20 91 FE
		lda #$3D		;1D0F A9 3D
		jsr kernel_set_linedraw_op		;1D11 20 16 FC
		asl L_C365		;1D14 0E 65 C3
		rts				;1D17 60
}

.update_per_track_stuff		; HAS DLL
{
		lda L_C77D		;1D18 AD 7D C7
		cmp #$05		;1D1B C9 05
		beq L_1D20		;1D1D F0 01
		rts				;1D1F 60
.L_1D20	lda #$3C		;1D20 A9 3C
		jmp sysctl		;1D22 4C 25 87
}

.L_1D25				; in Cart
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
.L_1DF9	jsr kernel_L_CFC5		;1DF9 20 C5 CF
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

.update_aicar		; in Cart
{
		lda L_C37C		;1E85 AD 7C C3
		beq L_1EE1		;1E88 F0 57
		ldx L_C375		;1E8A AE 75 C3
		jsr kernel_get_track_segment_detailsQ		;1E8D 20 2F F0
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
		jsr kernel_mul_8_16_16bit		;1EA9 20 45 C8
		jsr kernel_L_FF8E		;1EAC 20 8E FF
		lda ZP_15		;1EAF A5 15
		ldy #$FD		;1EB1 A0 FD
		jsr kernel_shift_16bit		;1EB3 20 BF C9
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
.L_1EE2_from_main_loop		; HAS DLL
{
		jsr kernel_L_E4DA		;1EE2 20 DA E4
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

.L_1F48			; in Cart - only called from update_aicar
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
		jsr kernel_mul_8_8_16bit		;1F6B 20 82 C7
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
		jsr kernel_negate_if_N_set		;1FDB 20 BD C8
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
		jsr kernel_negate_if_N_set		;1FF9 20 BD C8
		sta ZP_15		;1FFC 85 15
		lda ZP_16		;1FFE A5 16
		clc				;2000 18
		adc ZP_14		;2001 65 14
		sta ZP_14		;2003 85 14
		lda ZP_17		;2005 A5 17
		adc ZP_15		;2007 65 15
.L_2009	jsr kernel_L_FF8E		;2009 20 8E FF
		adc ZP_D6		;200C 65 D6
		sta ZP_D6		;200E 85 D6
		lda ZP_D7		;2010 A5 D7
		adc ZP_15		;2012 65 15
		bpl L_2018		;2014 10 02
		lda #$00		;2016 A9 00
.L_2018	sta ZP_D7		;2018 85 D7
		rts				;201A 60
}

.L_201B		; in Cart - only called from update_aicar
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

.L_2037		; in Cart - only called from update_aicar
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

.L_209C				; in Cart
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
		jsr kernel_negate_if_N_set		;20CC 20 BD C8
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
		jsr kernel_negate_if_N_set		;20EE 20 BD C8
		ldy #$FC		;20F1 A0 FC
		jsr kernel_shift_16bit		;20F3 20 BF C9
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
		jsr kernel_negate_if_N_set		;2153 20 BD C8
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

.L_21DE			; in Cart - only called from update_aicar
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
		jsr kernel_L_CFB7		;2229 20 B7 CF
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
		jsr kernel_shift_16bit		;22A6 20 BF C9
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
		jsr kernel_L_FF8E		;22E4 20 8E FF
		adc L_07DC,X	;22E7 7D DC 07
		sta L_07DC,X	;22EA 9D DC 07
		sta ZP_14		;22ED 85 14
		lda L_07E0,X	;22EF BD E0 07
		adc ZP_15		;22F2 65 15
		sta L_07E0,X	;22F4 9D E0 07
		jsr kernel_L_FF8E		;22F7 20 8E FF
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

.L_238E			; HAS DLL
{
		lda L_07CC,X	;238E BD CC 07
		sec				;2391 38
		sbc L_07CC,Y	;2392 F9 CC 07
		sta ZP_14		;2395 85 14
		lda L_07D0,X	;2397 BD D0 07
		sbc L_07D0,Y	;239A F9 D0 07
		sta ZP_17		;239D 85 17
		jmp kernel_negate_if_N_set		;239F 4C BD C8
}

.L_23A2			; in Cart
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

.L_2433				; in Cart
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

; raises number to	the power of 36	(? - experimentally determined)
; entry: A	= MSB; byte_14 = LSB

.pow36Q				; HAS DLL
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

.update_camera_roll_tables		; HAS DLL
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

.L_2808	rts				;2808 60

.L_2809				; HAS DLL
		lda L_A330,X	;2809 BD 30 A3
		bmi L_2808		;280C 30 FA
.L_280E				; in Cart
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

.draw_crash_smokeQ		; HAS DLL
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
		jsr kernel_set_linedraw_colour		;29FA 20 01 FC
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
		jsr kernel_draw_line		;2A26 20 C9 FE
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

.L_2A5C				; HAS DLL
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

.L_2C51				; Cart only?
{
		lda L_0188		;2C51 AD 88 01
		cmp #$10		;2C54 C9 10
		bcc L_2C5A		;2C56 90 02
		lda #$10		;2C58 A9 10
.L_2C5A	sta L_C350		;2C5A 8D 50 C3
		ldx #$0F		;2C5D A2 0F
		lda #$08		;2C5F A9 08
		bne L_2CAB		;2C61 D0 48
}
.L_2C63	rts				;2C63 60

.L_2C64				; HAS DLL called from main_loop
{
		ldx #$1F		;2C64 A2 1F
		lda #$D4		;2C66 A9 D4
.L_2C68	sta L_C260,X	;2C68 9D 60 C2
		dex				;2C6B CA
		bpl L_2C68		;2C6C 10 FA
		rts				;2C6E 60
}

.L_2C6F				; HAS DLL called from main_loop
{
		lda L_C30A		;2C6F AD 0A C3
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
}

.L_2CAB
{
		clc				;2CAB 18
		adc #$02		;2CAC 69 02
		sta L_AF8C		;2CAE 8D 8C AF
		stx ZP_2C		;2CB1 86 2C
		lda ZP_6A		;2CB3 A5 6A
		beq L_2C64		;2CB5 F0 AD
		lda #$01		;2CB7 A9 01
		jsr kernel_L_CF68		;2CB9 20 68 CF
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
}

.draw_track_preview_border			; called from game_start
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

.draw_track_preview_track_name			; called from game_start
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

.do_initial_screen			; called from game_start
{
		lda #$80		;3052 A9 80
		sta L_31A0		;3054 8D A0 31
		lda #$00		;3057 A9 00
		sta L_31A1		;3059 8D A1 31
		ldy #$01		;305C A0 01
		ldx #$10		;305E A2 10
		jsr kernel_do_menu_screen		;3060 20 36 EE
		cmp #$00		;3063 C9 00
		bne L_307D		;3065 D0 16
		jsr kernel_get_entered_name		;3067 20 7F ED
		jmp L_308C		;306A 4C 8C 30
.L_306D	lda #$00		;306D A9 00
		ldy #$01		;306F A0 01
		ldx #$14		;3071 A2 14
		jsr kernel_do_menu_screen		;3073 20 36 EE
		cmp #$00		;3076 C9 00
		bne L_3087		;3078 D0 0D
		inc L_31A1		;307A EE A1 31
.L_307D	jsr kernel_get_entered_name		;307D 20 7F ED
		lda L_31A1		;3080 AD A1 31
		cmp #$07		;3083 C9 07
		bcc L_306D		;3085 90 E6
.L_3087	lda L_31A1		;3087 AD A1 31
		beq L_306D		;308A F0 E1
.L_308C	lda #$00		;308C A9 00
		sta L_31A0		;308E 8D A0 31
		rts				;3091 60
}

.L_3092_from_game_start
{
		jsr kernel_L_E9A3		;3092 20 A3 E9
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
		jsr kernel_set_text_cursor		;30C1 20 6B 10
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

.L_3389_from_game_start			; called from game_start
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

.L_3626_from_game_start
{
		jsr kernel_L_E8C2		;3626 20 C2 E8
		lda ZP_50		;3629 A5 50
		sta ZP_C7		;362B 85 C7
		lda L_31A1		;362D AD A1 31
		beq L_3638		;3630 F0 06
		jsr L_3092_from_game_start		;3632 20 92 30
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

.L_364F			; in Cart
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

.L_3738
{
		sta ZP_19		;3738 85 19
		jsr kernel_L_E8E5		;373A 20 E5 E8
		jsr L_3858		;373D 20 58 38
		ldx L_C771		;3740 AE 71 C7
		jsr print_driver_name		;3743 20 8B 38
		ldx #$28		;3746 A2 28
		jsr print_msg_4		;3748 20 27 30
		ldx L_C772		;374B AE 72 C7
		jsr print_driver_name		;374E 20 8B 38
		jmp L_361F		;3751 4C 1F 36
}

.L_3754_from_game_start
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
		jsr kernel_L_E8C2		;3768 20 C2 E8
		ldx #$0F		;376B A2 0F
		ldy #$0C		;376D A0 0C
		jsr kernel_set_text_cursor		;376F 20 6B 10
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
.L_37D3	jsr kernel_L_E8C2		;37D3 20 C2 E8
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

.L_3829			; in Cart
{
		ldx #$0B		;3829 A2 0B
.L_382B	cmp L_C70C,X	;382B DD 0C C7
		beq L_3833		;382E F0 03
		dex				;3830 CA
		bpl L_382B		;3831 10 F8
.L_3833	rts				;3833 60
}

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

.fill_colourmap_varying		; in Cart
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

.L_398D				; in Cart
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
; Fns moved from Kernel RAM as only called from Cart fns
; *****************************************************************************

; Squares 16-bit value.
; 
; entry: A	= MSB, Y = LSB
; exit: byte_16,byte_17,byte_18,byte_19 = 32-bit result

.square_ay_32bit			; only called from Cart?
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

.L_CF73				; only called from Cart?
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

.cart_end
