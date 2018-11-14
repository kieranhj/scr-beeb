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
ELSE
skip 19
ENDIF

.L_083A	equb $00,$00,$00,$00,$00,$00
.L_0840	equb $01

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

.L_2458				; SELF-MOD CODE by fn L_F386?
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

.L_2806	equb $FF
.L_2807	equb $00

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
		jsr print_msg_2		;2AEB 20 CB A1
		ldx #$78		;2AEE A2 78
		ldy #$D5		;2AF0 A0 D5
		lda #$C0		;2AF2 A9 C0
		jsr kernel_L_EDAB		;2AF4 20 AB ED
		bit L_EE35		;2AF7 2C 35 EE
		bpl L_2AFD		;2AFA 10 01
		rts				;2AFC 60
.L_2AFD	jsr cart_L_9448		;2AFD 20 48 94
		bcs L_2AE9		;2B00 B0 E7
		jsr L_361F		;2B02 20 1F 36
		jsr save_rndQ_stateQ		;2B05 20 2C 16
		lda #$00		;2B08 A9 00
		jsr L_3FBB_with_VIC		;2B0A 20 BB 3F
		lda #$01		;2B0D A9 01
		jsr cart_L_93A8		;2B0F 20 A8 93
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
		jsr kernel_L_FF84		;2B35 20 84 FF
		jsr kernel_L_FF87		;2B38 20 87 FF
		ldx #$1F		;2B3B A2 1F
.L_2B3D	lda KERNEL_RAM_VECTORS,X	;2B3D BD 30 FD
		sta L_0314,X	;2B40 9D 14 03
		dex				;2B43 CA
		bpl L_2B3D		;2B44 10 F7
		jsr kernel_L_E544		;2B46 20 44 E5

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
		lda #$35		;2BEC A9 35
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
		lda #$01		;2C11 A9 01
		sta VIC_IRQMASK		;2C13 8D 1A D0		; VIC
		lda #$00		;2C16 A9 00
		jsr cart_L_93A8		;2C18 20 A8 93
		ldy #$09		;2C1B A0 09
		jsr L_1637		;2C1D 20 37 16
		rts				;2C20 60
}

.L_2C21	equb $01,$08	;2C21 01 08

.clear_screen_with_sysctl	;'F'
{
		ldx L_3DF8		;2C23 AE F8 3D
		lda #$45		;2C26 A9 45
		jmp cart_sysctl		;2C28 4C 25 87
}

.L_2C2B_with_sysctl		;'>'
{
		lda #$3E		;2C2B A9 3E
		jmp cart_sysctl		;2C2D 4C 25 87
}

.update_colour_map_with_sysctl	;'G'
{
		lda #$46		;2C30 A9 46
		jmp cart_sysctl		;2C32 4C 25 87
}

.do_ai_depth_stuff		;'A'
{
		lda #$41		;2C35 A9 41
		jmp cart_sysctl		;2C37 4C 25 87
}

.L_2C3A_with_sysctl		; 'B'
{
		bit ZP_6D		;2C3A 24 6D
		bmi L_2C3F		;2C3C 30 01
		rts				;2C3E 60
.L_2C3F
		lda #$42		;2C3F A9 42
		jmp cart_sysctl		;2C41 4C 25 87
}

.L_2C44_with_sysctl
{
		lda L_C359		;2C44 AD 59 C3
		beq L_2C4C		;2C47 F0 03
		jmp L_1CCB		;2C49 4C CB 1C

.L_2C4C
		lda #$3D		;2C4C A9 3D
		jmp cart_sysctl		;2C4E 4C 25 87
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

; only called from game update (move to kernel?)
.L_2D89_from_game_update
{
		lda L_0156		;2D89 AD 56 01
		sta ZP_14		;2D8C 85 14
		lda L_0159		;2D8E AD 59 01
		jsr kernel_negate_if_N_set		;2D91 20 BD C8
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
		jsr kernel_shift_16bit		;2DAF 20 BF C9
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
		jsr kernel_get_track_segment_detailsQ		;2DC7 20 2F F0
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
		jsr kernel_negate_if_N_set		;2DFA 20 BD C8
		sta ZP_7F		;2DFD 85 7F
		ldy ZP_14		;2DFF A4 14
		sty ZP_7D		;2E01 84 7D
		cmp #$08		;2E03 C9 08
		bcc L_2E0B		;2E05 90 04
		lda #$7F		;2E07 A9 7F
		bne L_2E10		;2E09 D0 05
.L_2E0B	ldy #$FC		;2E0B A0 FC
		jsr kernel_shift_16bit		;2E0D 20 BF C9
.L_2E10	sta ZP_A5		;2E10 85 A5
		lda ZP_BE		;2E12 A5 BE
		sec				;2E14 38
		sbc ZP_C3		;2E15 E5 C3
		cmp #$02		;2E17 C9 02
		bcs L_2E21		;2E19 B0 06
		jsr kernel_L_CFC5		;2E1B 20 C5 CF
		jsr kernel_get_track_segment_detailsQ		;2E1E 20 2F F0
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
		jsr kernel_mul_8_8_16bit		;2E8A 20 82 C7
		ldy #$07		;2E8D A0 07
		jsr kernel_shift_16bit		;2E8F 20 BF C9
		ldy ZP_14		;2E92 A4 14
		bne L_2E98		;2E94 D0 02
		inc ZP_14		;2E96 E6 14
.L_2E98	bit ZP_77		;2E98 24 77
		jsr kernel_negate_if_N_set		;2E9A 20 BD C8
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
		jsr kernel_shift_16bit		;2EBA 20 BF C9
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
		jsr kernel_mul_8_16_16bit		;2EE1 20 45 C8
		bit ZP_C5		;2EE4 24 C5
		jsr kernel_negate_if_N_set		;2EE6 20 BD C8
		ldy #$03		;2EE9 A0 03
		jsr kernel_shift_16bit		;2EEB 20 BF C9
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

.L_3023	jsr cart_write_char		;3023 20 6F 84
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

.L_3092
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
		jsr cart_L_91CF		;30E3 20 CF 91
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
		jsr kernel_set_text_cursor		;3172 20 6B 10
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

.L_32A1	jsr cart_write_char		;32A1 20 6F 84
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
		jsr cart_print_2space		;333A 20 AA 91
		pla				;333D 68
		jmp print_number_pad2		;333E 4C 45 33

.print_number_unpadded
		cmp #$0A		;3341 C9 0A
		bcc L_335E		;3343 90 19

.print_number_pad2
		cmp #$0A		;3345 C9 0A
		bcs L_3350		;3347 B0 07
		pha				;3349 48
		jsr cart_print_space		;334A 20 AF 91
		jmp L_335B		;334D 4C 5B 33

.L_3350	jsr cart_convert_X_to_BCD		;3350 20 15 92

.print_BCD_double_digits
		pha				;3353 48
		lsr A			;3354 4A
		lsr A			;3355 4A
		lsr A			;3356 4A
		lsr A			;3357 4A
		jsr kernel_print_single_digit		;3358 20 8A 10
.L_335B
		pla				;335B 68
		and #$0F		;335C 29 0F
.L_335E	jmp kernel_print_single_digit		;335E 4C 8A 10

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
		jsr cart_sysctl		;350E 20 25 87
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
		jmp kernel_print_single_digit		;3572 4C 8A 10
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
		jsr cart_L_9319		;35E3 20 19 93
.L_35E6	jsr cart_L_9225		;35E6 20 25 92
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
		jmp cart_sysctl		;3623 4C 25 87
}

.L_3626
{
		jsr kernel_L_E8C2		;3626 20 C2 E8
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
		jsr cart_print_space		;3659 20 AF 91
		ldx ZP_C6		;365C A6 C6
		lda L_C39C		;365E AD 9C C3
		bpl L_3674		;3661 10 11
		jsr L_99FF		;3663 20 FF 99
		jsr cart_print_2space		;3666 20 AA 91
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
		jsr cart_print_3space		;3686 20 A5 91
		lda L_C74C,X	;3689 BD 4C C7
		jsr print_number_pad2		;368C 20 45 33
.L_368F	inc ZP_C7		;368F E6 C7
		lda ZP_C7		;3691 A5 C7
		cmp ZP_8A		;3693 C5 8A
		rts				;3695 60
}

.debounce_fire_and_wait_for_fire
{
		jsr kernel_check_game_keys		;3696 20 9E F7
		and #$10		;3699 29 10
		bne debounce_fire_and_wait_for_fire		;369B D0 F9
		ldy #$05		;369D A0 05
		jsr delay_approx_Y_25ths_sec		;369F 20 EB 3F
.L_36A2	jsr kernel_check_game_keys		;36A2 20 9E F7
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
		jsr kernel_set_text_cursor		;36E5 20 6B 10
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
		jsr kernel_set_text_cursor		;387F 20 6B 10
		inc ZP_19		;3882 E6 19
\\ Fall through
.L_3884	ldx #$80		;3884 A2 80
		lda #$20		;3886 A9 20
		jmp cart_sysctl		;3888 4C 25 87

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
		jsr cart_write_char		;38AB 20 6F 84
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
		jsr kernel_L_E85B		;3B36 20 5B E8
		jsr set_up_screen_for_frontend		;3B39 20 04 35
		jsr do_initial_screen		;3B3C 20 52 30
		jsr L_36AD		;3B3F 20 AD 36
		jsr save_rndQ_stateQ		;3B42 20 2C 16

.L_3B45	lsr L_C304		;3B45 4E 04 C3
		jsr kernel_do_main_menu_dwim		;3B48 20 3A EF
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
.L_3B6E	jsr kernel_L_1090		;3B6E 20 90 10
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
		jsr kernel_L_E8E5		;3B8B 20 E5 E8
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

.L_3BA7	jsr kernel_L_E87F		;3BA7 20 7F E8
		jmp L_3BF8		;3BAA 4C F8 3B

.L_3BAD	sty L_C773		;3BAD 8C 73 C7
		lda #$C0		;3BB0 A9 C0
		sta L_C305		;3BB2 8D 05 C3
		jsr L_357E		;3BB5 20 7E 35
		ldx #$20		;3BB8 A2 20
		jsr kernel_poll_key_with_sysctl		;3BBA 20 C9 C7
		beq L_3B5F		;3BBD F0 A0
		jsr L_3C36		;3BBF 20 36 3C
		jsr L_3500		;3BC2 20 00 35
		lda #$80		;3BC5 A9 80
		jsr cart_store_restore_control_keys		;3BC7 20 46 98
		jsr game_main_loop		;3BCA 20 99 3C
		lda #$00		;3BCD A9 00
		jsr cart_store_restore_control_keys		;3BCF 20 46 98
		lda #$00		;3BD2 A9 00
		jsr cart_L_9319		;3BD4 20 19 93
		jsr kernel_L_E87F		;3BD7 20 7F E8
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
		jsr cart_L_91C3		;3BF5 20 C3 91

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

.L_3C1F	jsr cart_L_91B4		;3C1F 20 B4 91
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
		jsr cart_sysctl		;3C59 20 25 87
		jsr set_up_colour_map_for_track_preview		;3C5C 20 77 3A
		jsr draw_track_preview_border		;3C5F 20 03 2F
		jsr draw_track_preview_track_name		;3C62 20 CE 2F
		jsr L_3EA8		;3C65 20 A8 3E
		ldx L_C77D		;3C68 AE 7D C7
		jsr kernel_prepare_trackQ		;3C6B 20 34 EA
		jsr update_per_track_stuff		;3C6E 20 18 1D
		jsr kernel_L_F386		;3C71 20 86 F3

.L_3C74	ldx #$27		;3C74 A2 27
		lda #$3B		;3C76 A9 3B
.L_3C78	sta L_7FC0,X	;3C78 9D C0 7F
		dex				;3C7B CA
		bpl L_3C78		;3C7C 10 FA
		
		ldx #$2C		;3C7E A2 2C
		jsr print_msg_4		;3C80 20 27 30
		jsr kernel_track_preview_check_keys		;3C83 20 DE CF
		bcc L_3C8E		;3C86 90 06
		jsr kernel_L_F386		;3C88 20 86 F3
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
		jsr cart_sysctl		;3C9D 20 25 87
		jsr L_3DF9		;3CA0 20 F9 3D
		ldx #$80		;3CA3 A2 80
		lda #$10		;3CA5 A9 10
		jsr cart_sysctl		;3CA7 20 25 87
		lda #$02		;3CAA A9 02
		jsr cart_sysctl		;3CAC 20 25 87
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
		jsr kernel_L_F488		;3CC6 20 88 F4
		jsr L_2C64		;3CC9 20 64 2C
		bit L_3DF8		;3CCC 2C F8 3D
		bmi L_3CDD		;3CCF 30 0C
		jsr reset_sprites		;3CD1 20 84 14
		jsr L_167A_from_main_loop		;3CD4 20 7A 16
		jsr toggle_display_pageQ		;3CD7 20 42 3F
		jsr kernel_game_update		;3CDA 20 41 08

.L_3CDD	jsr L_167A_from_main_loop		;3CDD 20 7A 16
		jsr kernel_draw_tachometer_in_game		;3CE0 20 06 12
		jsr draw_crane_with_sysctl		;3CE3 20 1E 1C
		jsr L_14D0_from_main_loop		;3CE6 20 D0 14	; update scratches and scrapes?
		jsr toggle_display_pageQ		;3CE9 20 42 3F
		jsr kernel_game_update		;3CEC 20 41 08
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
		jsr kernel_game_update		;3D0B 20 41 08
		jsr kernel_L_E104		;3D0E 20 04 E1
		jsr L_167A_from_main_loop		;3D11 20 7A 16
		jsr L_2C6F		;3D14 20 6F 2C
		jsr L_14D0_from_main_loop		;3D17 20 D0 14
		jsr draw_crane_with_sysctl		;3D1A 20 1E 1C
		jsr update_per_track_stuff		;3D1D 20 18 1D
		jsr kernel_draw_tachometer_in_game		;3D20 20 06 12
		jsr L_10D9		;3D23 20 D9 10
		jsr kernel_L_0F2A		;3D26 20 2A 0F
		jsr kernel_update_distance_to_ai_car_readout		;3D29 20 64 11
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
		jsr kernel_L_114D_with_color_ram		;3D4D 20 4D 11

.L_3D50	ldy #$3C		;3D50 A0 3C
		lda #$04		;3D52 A9 04
		jsr kernel_set_up_text_sprite		;3D54 20 A9 12
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
		jsr kernel_L_E0F9_with_sysctl		;3D8C 20 F9 E0
		ldx L_C309		;3D8F AE 09 C3
		jmp L_3CC6		;3D92 4C C6 3C
.L_3D95	lda ZP_2F		;3D95 A5 2F
		bne L_3DA1		;3D97 D0 08
		lda ZP_6B		;3D99 A5 6B
		bmi L_3DA8		;3D9B 30 0B
		lda ZP_6A		;3D9D A5 6A
		beq L_3DA8		;3D9F F0 07
.L_3DA1	ldx #$2F		;3DA1 A2 2F
		jsr kernel_poll_key_with_sysctl		;3DA3 20 C9 C7
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
		jsr kernel_L_E0F9_with_sysctl		;3DC2 20 F9 E0
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
		jsr kernel_L_1090		;3DE4 20 90 10
.L_3DE7	lda L_C37E		;3DE7 AD 7E C3
		sta L_C719		;3DEA 8D 19 C7
.L_3DED	jsr save_rndQ_stateQ		;3DED 20 2C 16
		ldx #$00		;3DF0 A2 00
		lda #$34		;3DF2 A9 34
		jsr cart_sysctl		;3DF4 20 25 87
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
		jsr kernel_L_1090		;3E66 20 90 10
		jsr update_camera_roll_tables		;3E69 20 26 27
		lda #$A0		;3E6C A9 A0
		sta ZP_33		;3E6E 85 33
		lda #$78		;3E70 A9 78
		sta ZP_3C		;3E72 85 3C
		jsr kernel_L_E0F9_with_sysctl		;3E74 20 F9 E0
		lda #$04		;3E77 A9 04
		sta L_C354		;3E79 8D 54 C3
		ldy #$09		;3E7C A0 09
		jsr L_1637		;3E7E 20 37 16
		lda #$3B		;3E81 A9 3B
		sta ZP_03		;3E83 85 03
		jsr kernel_initialise_hud_sprites		;3E85 20 9A 12
		ldy #$0B		;3E88 A0 0B
		jsr kernel_L_115D_with_color_ram		;3E8A 20 5D 11
		jsr kernel_L_114D_with_color_ram		;3E8D 20 4D 11
		ldx L_C776		;3E90 AE 76 C7
		lda L_C71A		;3E93 AD 1A C7
		beq L_3E9B		;3E96 F0 03
		ldx L_C777		;3E98 AE 77 C7
.L_3E9B	txa				;3E9B 8A
		jsr cart_convert_X_to_BCD		;3E9C 20 15 92
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
.L_3EDD	jmp kernel_L_F6A6		;3EDD 4C A6 F6
}

.update_pause_status
{
		lda L_C306		;3EE0 AD 06 C3
		bpl L_3EEC		;3EE3 10 07
		ldx #$0D		;3EE5 A2 0D
		jsr kernel_poll_key_with_sysctl		;3EE7 20 C9 C7
		beq L_3EED		;3EEA F0 01
.L_3EEC	rts				;3EEC 60

.L_3EED	jsr kernel_L_E0F9_with_sysctl		;3EED 20 F9 E0
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
		jsr kernel_set_up_text_sprite		;3F06 20 A9 12
.L_3F09	jsr cart_maybe_define_keys		;3F09 20 AF 97
		ldx #$34		;3F0C A2 34
		jsr kernel_poll_key_with_sysctl		;3F0E 20 C9 C7
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
		jsr kernel_set_up_text_sprite		;3F24 20 A9 12
}
\\
.L_3F27_with_SID
{
		lda #$06		;3F27 A9 06
		jsr kernel_L_CF68		;3F29 20 68 CF
		lda #$05		;3F2C A9 05
		jsr kernel_L_CF68		;3F2E 20 68 CF
		jsr kernel_L_E104		;3F31 20 04 E1
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

\\ Moved from Cart RAM

.nmi_handler		; C64 only
{
		pha				;9A32 48
		lda CIA2_C2DDRA		;9A33 AD 0D DD
		pla				;9A36 68
		rti				;9A37 40
}

.core_end
