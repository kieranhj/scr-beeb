; *****************************************************************************
; HAZEL RAM: $C000 - $D000
; $C700 = Maths routines
; ...
; $CD00 = IRQ handler
; $CE00 = Sprite code
; $CF00 = Raster interrupts
; *****************************************************************************

.hazel_start

; Engine screen data (copied at boot time from elsewhere)

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
		jsr jmp_update_tyre_spritesQ		;CF40 20 B1 FF
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
		jsr jmp_check_game_keys		;CFDE 20 9E F7
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

ORG &D000

\\ Data moved from Cart RAM to Hazel

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

.L_A1F2	equb $E8,$46,$4B,$53,$52,$46,$55,$48,$42,$45,$52,$44
.L_A1FE	equb $42
.L_A1FF	equb $49

ALIGN &100

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

; $A500 LO pointers?

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

\\ Data moved from Kernel RAM to Hazel

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

.L_E8E1	equb $09,$06,$03,$00

.L_EE35	equb $00

; KEY DEFINITIONS

.control_keys	equb $2E,$27,$29,$12,$08
.L_F80C			equb $07,$1F,$01,$19
.L_F810			equb $11

.beeb_dll_start

.jmp_L_E0F9_with_sysctl	BEEB_DLL_JMP L_E0F9_with_sysctl
.jmp_L_E104 BEEB_DLL_JMP L_E104
.jmp_L_E195 BEEB_DLL_JMP L_E195
.jmp_L_E1B1 BEEB_DLL_JMP L_E1B1
.jmp_L_E4DA BEEB_DLL_JMP L_E4DA
.jmp_L_E544 BEEB_DLL_JMP L_E544
.jmp_L_E631 BEEB_DLL_JMP L_E631
.jmp_L_E641 BEEB_DLL_JMP L_E641
.jmp_L_E808 BEEB_DLL_JMP L_E808
.jmp_L_E85B BEEB_DLL_JMP L_E85B
.jmp_L_E87F BEEB_DLL_JMP L_E87F
.jmp_L_E8C2 BEEB_DLL_JMP L_E8C2
.jmp_L_E8E5 BEEB_DLL_JMP L_E8E5
.jmp_L_E9A3 BEEB_DLL_JMP L_E9A3
.jmp_prepare_trackQ BEEB_DLL_JMP prepare_trackQ
.jmp_L_EC11 BEEB_DLL_JMP L_EC11
.jmp_get_entered_name BEEB_DLL_JMP get_entered_name
.jmp_L_EDAB BEEB_DLL_JMP L_EDAB
.jmp_do_menu_screen BEEB_DLL_JMP do_menu_screen
.jmp_do_main_menu_dwim BEEB_DLL_JMP do_main_menu_dwim
.jmp_L_F021 BEEB_DLL_JMP L_F021
.jmp_get_track_segment_detailsQ BEEB_DLL_JMP get_track_segment_detailsQ
.jmp_L_F0C5 BEEB_DLL_JMP L_F0C5
.jmp_L_F117 BEEB_DLL_JMP L_F117
.jmp_L_F1DC BEEB_DLL_JMP L_F1DC
.jmp_L_F2B7 BEEB_DLL_JMP L_F2B7
.jmp_L_F386 BEEB_DLL_JMP L_F386
.jmp_L_F440 BEEB_DLL_JMP L_F440
.jmp_L_F488 BEEB_DLL_JMP L_F488
.jmp_L_F585 BEEB_DLL_JMP L_F585
.jmp_L_F5E9 BEEB_DLL_JMP L_F5E9
.jmp_update_boosting BEEB_DLL_JMP update_boosting
.jmp_L_F668 BEEB_DLL_JMP L_F668
.jmp_L_F673 BEEB_DLL_JMP L_F673
.jmp_L_F6A6 BEEB_DLL_JMP L_F6A6
.jmp_check_game_keys BEEB_DLL_JMP check_game_keys
.jmp_L_F811 BEEB_DLL_JMP L_F811
.jmp_set_linedraw_colour BEEB_DLL_JMP set_linedraw_colour
.jmp_set_linedraw_op BEEB_DLL_JMP set_linedraw_op
.jmp_L_FE91_with_draw_line BEEB_DLL_JMP L_FE91_with_draw_line
.jmp_draw_line BEEB_DLL_JMP draw_line
.jmp_L_FF6A BEEB_DLL_JMP L_FF6A
.jmp_L_FF84 BEEB_DLL_JMP L_FF84
.jmp_L_FF87 BEEB_DLL_JMP L_FF87
.jmp_L_FF8E BEEB_DLL_JMP L_FF8E
.jmp_update_tyre_spritesQ BEEB_DLL_JMP update_tyre_spritesQ
.jmp_L_FFE2 BEEB_DLL_JMP L_FFE2

.beeb_dll_end

.hazel_end
