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

.L_2458				; SELF-MOD CODE from update_track_preview
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
.L_24F8	bcc L_2572		;24F8 90 78		;! _SELF_MOD local
		lda ZP_A9		;24FA A5 A9
		sec				;24FC 38
		sbc ZP_70		;24FD E5 70
		sta ZP_14		;24FF 85 14
		lda ZP_AA		;2501 A5 AA
		sbc ZP_71		;2503 E5 71
		bpl L_2537		;2505 10 30
		jsr cart_pow36Q		;2507 20 D2 26
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
		jsr cart_pow36Q		;2544 20 D2 26
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
		jsr cart_pow36Q		;257F 20 D2 26
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
		jsr cart_pow36Q		;25BA 20 D2 26
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

.L_25EA				; WAS DLL
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
L_262B	= *-1			;! _SELF_MOD by update_track_preview
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
		jsr cart_pow36Q		;2640 20 D2 26
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
		jsr cart_pow36Q		;266F 20 D2 26
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
		jsr cart_pow36Q		;2690 20 D2 26
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
		jsr cart_pow36Q		;26B0 20 D2 26
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

\\ Moved from Kernel RAM as self-mod code above gets redirected here!

.L_F40B
{
		stx ZP_16		; equb $86,$16
		lda ZP_77		; equb $A5,$77
		clc				; equb $18
		bpl L_F413		; equb $10,$01
		sec				; equb $38
.L_F413	ror A			; equb $6A
		ror ZP_51		; equb $66,$51
		sta ZP_77		; equb $85,$77

\\ Previously thought to be ununsed...

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

.update_colour_map_with_sysctl	;'G'
{
		lda #$46		;2C30 A9 46
		jmp cart_sysctl		;2C32 4C 25 87
}

.L_3046_from_main_loop
{
		ldx #$0B		;3046 A2 0B
.L_3048	lda L_C6C0,X	;3048 BD C0 C6
		sta L_DAB6,X	;304B 9D B6 DA		; COLOR RAM
		dex				;304E CA
		bpl L_3048		;304F 10 F7
		rts				;3051 60
}

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

.disable_ints_and_page_in_RAM	RTS
IF _NOT_BEEB
{
		lda #C64_VIC_IRQ_DISABLE		;33F1 A9 00
		sta VIC_IRQMASK		;33F3 8D 1A D0
		sei				;33F6 78
		lda #C64_NO_IO_NO_KERNAL		;33F7 A9 34
		sta RAM_SELECT		;33F9 85 01
		rts				;33FB 60
}
ENDIF

.page_in_IO_and_enable_ints		RTS
IF _NOT_BEEB
{
		lda #C64_IO_NO_KERNAL		;33FC A9 35
		sta RAM_SELECT		;33FE 85 01
		cli				;3400 58
		lda #C64_VIC_IRQ_RASTERCMP		;3401 A9 01
		sta VIC_IRQMASK		;3403 8D 1A D0
		rts				;3406 60
}
ENDIF

.reset_border_colour
{
		jsr vic_reset_border_colour		;3500 20 BE 3F	; does VIC stuff
		rts				;3503 60
}

.set_up_screen_for_frontend
{
		lda #$00		;3504 A9 00
		jsr vic_set_border_colour		;3506 20 BB 3F
		jsr cart_draw_menu_header		;3509 20 49 1C
		lda #$01		;350C A9 01		; 'MODE 1'
		jsr cart_sysctl		;350E 20 25 87
		lda #$41		;3511 A9 41
		sta irq_mode		;3513 8D F8 3D
		jsr cart_L_39F1		;3516 20 F1 39
		jsr set_up_screen_for_menu		;3519 20 1F 35
		jmp ensure_screen_enabled		;351C 4C 9E 3F
}

.set_up_screen_for_menu
{
		lda L_C718		;351F AD 18 C7
		sta L_C360		;3522 8D 60 C3
		jsr cart_clear_menu_area		;3525 20 23 1C
		jsr cart_menu_colour_map_stuff		;3528 20 C4 38
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
\\
.print_division_type
		lda L_C71A		;3554 AD 1A C7
		beq L_3564		;3557 F0 0B
		sty L_E0BD		;3559 8C BD E0
		ldx #$BB		;355C A2 BB
		jsr cart_print_msg_2		;355E 20 CB A1
		jmp L_356C		;3561 4C 6C 35
.L_3564	sty L_3409		;3564 8C 09 34
		ldx #$00		;3567 A2 00
		jsr cart_print_msg_4		;3569 20 27 30
.L_356C	lda #$04		;356C A9 04
		sec				;356E 38
		sbc L_C360		;356F ED 60 C3
		jmp cart_print_single_digit		;3572 4C 8A 10
\\
.L_3575	ldx #$A0		;3575 A2 A0
		jmp cart_print_msg_3		;3577 4C DC A1	; "DRIVERS CHAMPIONSHIP"
.L_357A	lda #$80		;357A A9 80
		bne L_3580		;357C D0 02
\\
.L_357E				; another entry point
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
		jsr kernel_select_track		;359E 20 2F 30
		ldy #$0B		;35A1 A0 0B
		jsr cart_print_track_title		;35A3 20 70 31
		lda L_C305		;35A6 AD 05 C3
		and #$01		;35A9 29 01
		bne L_35E6		;35AB D0 39
		ldx #$0E		;35AD A2 0E
		bit L_C372		;35AF 2C 72 C3
		bpl L_35B5		;35B2 10 01
		dex				;35B4 CA
.L_35B5	stx L_3416		;35B5 8E 16 34
		ldx #$0D		;35B8 A2 0D
		jsr cart_print_msg_4		;35BA 20 27 30
		lda L_31A6		;35BD AD A6 31
		clc				;35C0 18
		adc #$01		;35C1 69 01
		jsr cart_print_number_unpadded		;35C3 20 41 33
		ldx #$F4		;35C6 A2 F4
		jsr cart_print_msg_4		;35C8 20 27 30
		lda L_31A3		;35CB AD A3 31
		ldx L_31A1		;35CE AE A1 31
		beq L_35D4		;35D1 F0 01
		asl A			;35D3 0A
.L_35D4	jsr cart_print_number_unpadded		;35D4 20 41 33
		bit L_C372		;35D7 2C 72 C3
		bmi L_35EC		;35DA 30 10
		lda #$06		;35DC A9 06
		jsr cart_L_3738		;35DE 20 38 37
		lda #$80		;35E1 A9 80
		jsr cart_L_9319		;35E3 20 19 93
.L_35E6	jsr cart_L_9225		;35E6 20 25 92
		jmp L_361C		;35E9 4C 1C 36
.L_35EC	lda #$07		;35EC A9 07
		jsr cart_L_3738		;35EE 20 38 37
		ldx #$60		;35F1 A2 60
		jsr cart_print_msg_4		;35F3 20 27 30
		jsr L_3858		;35F6 20 58 38
		ldx #$6A		;35F9 A2 6A
		jsr cart_print_msg_4		;35FB 20 27 30
		ldx L_C76F		;35FE AE 6F C7
		jsr print_driver_name		;3601 20 8B 38
		ldx #$E9		;3604 A2 E9
		jsr cart_print_msg_4		;3606 20 27 30
		jsr L_3858		;3609 20 58 38
		ldx #$78		;360C A2 78
		jsr cart_print_msg_4		;360E 20 27 30
		ldx L_C770		;3611 AE 70 C7
		jsr print_driver_name		;3614 20 8B 38
		ldx #$EF		;3617 A2 EF
		jsr cart_print_msg_4		;3619 20 27 30
.L_361C	jsr debounce_fire_and_wait_for_fire		;361C 20 96 36
\\
.L_361F
{
		ldx #$00		;361F A2 00
		lda #$20		;3621 A9 20
		jmp cart_sysctl		;3623 4C 25 87
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

.track_order				equb $00,$02,$01,$03,$06,$07,$04,$05
.track_background_colours	equb $08,$05,$0C,$05,$05,$08,$0C,$08

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
		jsr cart_set_text_cursor		;387F 20 6B 10
		inc ZP_19		;3882 E6 19
\\ Fall through
.L_3884	ldx #$80		;3884 A2 80
		lda #$20		;3886 A9 20
		jmp cart_sysctl		;3888 4C 25 87

.print_driver_name
{
		lda #HI(driver_name_data)		;388B A9 AE
		ldy #$0D		;388D A0 0D
		jmp print_name		;388F 4C 96 38
}

.print_track_name
		lda #HI(track_name_data)		;3892 A9 AF
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

; Used by colourmap functions above
.L_3944	equb $F0,$1E,$02,$1E,$20,$79,$06,$98,$1C,$18,$0E,$28,$0E,$28,$1C
.L_3953	equb $0F,$1C,$08,$14,$78,$14,$28,$0C,$78,$36,$06,$0B,$07,$45,$06,$0B
		equb $16,$5F,$06,$28,$63,$28,$06,$02,$0D,$01,$06,$0B,$0A,$07,$0F,$01
		equb $06,$0B,$0A,$07,$0F,$50,$06
.L_397A	equb $04,$AE,$AE,$90,$89,$08,$90,$89,$89,$90,$89,$90,$89,$89,$04,$A5
		equb $A5,$90,$89		

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
.L_3A55	jsr cart_L_39D1		;3A55 20 D1 39
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
.L_3A68	jsr cart_L_39D1		;3A68 20 D1 39
		lda (ZP_1E),Y	;3A6B B1 1E
		ora ZP_15		;3A6D 05 15
		sta (ZP_1E),Y	;3A6F 91 1E
		dey				;3A71 88
		dec ZP_14		;3A72 C6 14
		bne L_3A68		;3A74 D0 F2
		rts				;3A76 60
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
.L_3B2A	lda L_DC00,X	;3B2A BD 00 DC
		sta L_AE00,X	;3B2D 9D 00 AE
		inx				;3B30 E8
		bne L_3B2A		;3B31 D0 F7

		jsr page_in_IO_and_enable_ints		;3B33 20 FC 33
		jsr kernel_L_E85B		;3B36 20 5B E8
		jsr set_up_screen_for_frontend		;3B39 20 04 35
		jsr cart_do_initial_screen		;3B3C 20 52 30
		jsr kernel_L_36AD_from_game_start		;3B3F 20 AD 36
		jsr cart_save_rndQ_stateQ		;3B42 20 2C 16

.L_3B45	lsr L_C304		;3B45 4E 04 C3
		jsr kernel_do_main_menu_dwim		;3B48 20 3A EF
		lda L_C76C		;3B4B AD 6C C7
		bmi L_3B69		;3B4E 30 19	     ; taken if	racing

		jsr do_track_preview		;3B50 20 36 3C
		jsr reset_border_colour		;3B53 20 00 35
		jsr game_main_loop		;3B56 20 99 3C
		jsr set_up_screen_for_frontend		;3B59 20 04 35
		jmp L_3B45		;3B5C 4C 45 3B

.L_3B5F	lda #$C0		;3B5F A9 C0
		sta L_C304		;3B61 8D 04 C3
		sta L_C362		;3B64 8D 62 C3
		bne L_3B85		;3B67 D0 1C

.L_3B69	jsr cart_L_3389_from_game_start		;3B69 20 89 33

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
		ldx #KEY_DEF_REDEFINE		;3BB8 A2 20
		jsr poll_key_with_sysctl		;3BBA 20 C9 C7
		beq L_3B5F		;3BBD F0 A0
		jsr do_track_preview		;3BBF 20 36 3C
		jsr reset_border_colour		;3BC2 20 00 35
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
		jsr cart_L_3626_from_game_start		;3BED 20 26 36
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
		jsr cart_L_3754_from_game_start		;3C13 20 54 37
		jsr kernel_L_36AD_from_game_start		;3C16 20 AD 36

.L_3C19	jsr cart_L_1611		;3C19 20 11 16
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
}

.do_track_preview			; could be moved to Cart
{
		lda #$0B		;3C36 A9 0B
		jsr vic_set_border_colour		;3C38 20 BB 3F
		jsr L_3DF9		;3C3B 20 F9 3D
		lda #$40		;3C3E A9 40
		sta irq_mode		;3C40 8D F8 3D

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
		lda #$03		;3C57 A9 03			; 'MODE 3'
		jsr cart_sysctl		;3C59 20 25 87
		jsr cart_set_up_colour_map_for_track_preview		;3C5C 20 77 3A
		jsr cart_draw_track_preview_border		;3C5F 20 03 2F
		jsr cart_draw_track_preview_track_name		;3C62 20 CE 2F
		jsr L_3EA8		;3C65 20 A8 3E
		ldx current_track		;3C68 AE 7D C7
		jsr kernel_set_road_data1		;3C6B 20 34 EA
		jsr cart_update_per_track_stuff		;3C6E 20 18 1D
		jsr kernel_update_track_preview		;3C71 20 86 F3

.L_3C74	ldx #$27		;3C74 A2 27
		lda #$3B		;3C76 A9 3B
.L_3C78	sta L_7FC0,X	;3C78 9D C0 7F
		dex				;3C7B CA
		bpl L_3C78		;3C7C 10 FA
		
		ldx #$2C		;3C7E A2 2C
		jsr cart_print_msg_4		;3C80 20 27 30
		jsr kernel_track_preview_check_keys		;3C83 20 DE CF
		bcc L_3C8E		;3C86 90 06
		jsr kernel_update_track_preview		;3C88 20 86 F3
		jmp L_3C74		;3C8B 4C 74 3C

.L_3C8E	lda #$00		;3C8E A9 00
		jsr vic_set_border_colour		;3C90 20 BB 3F
		lda #$00		;3C93 A9 00
		sta irq_mode		;3C95 8D F8 3D
		rts				;3C98 60
}

; *****************************************************************************
; GAME MAIN LOOP
; *****************************************************************************

.game_main_loop			; aka L_3C99
{
		ldx #$80		;3C99 A2 80
		lda #$34		;3C9B A9 34		; 'copy stuff'
		jsr cart_sysctl		;3C9D 20 25 87
		jsr L_3DF9		;3CA0 20 F9 3D
		ldx #$80		;3CA3 A2 80
		lda #$10		;3CA5 A9 10		; 
		jsr cart_sysctl		;3CA7 20 25 87
		lda #$02		;3CAA A9 02		; 'MODE 2'
		jsr cart_sysctl		;3CAC 20 25 87
		jsr L_3EB6_from_main_loop		;3CAF 20 B6 3E
		ldx players_start_section		;3CB2 AE 65 C7
		stx L_C375		;3CB5 8E 75 C3
		lda #$04		;3CB8 A9 04
		sta ZP_C4		;3CBA 85 C4
		lda #$4C		;3CBC A9 4C
		sta ZP_B0		;3CBE 85 B0
		jsr cart_L_1EE2_from_main_loop		;3CC0 20 E2 1E
		ldx players_start_section		;3CC3 AE 65 C7
.L_3CC6
		jsr kernel_L_F488		;3CC6 20 88 F4
		jsr cart_L_2C64		;3CC9 20 64 2C
		bit irq_mode		;3CCC 2C F8 3D
		bmi L_3CDD		;3CCF 30 0C
		jsr cart_reset_sprites		;3CD1 20 84 14
		jsr cart_draw_trackQ		;3CD4 20 7A 16
		jsr toggle_display_pageQ		;3CD7 20 42 3F
		jsr kernel_game_update		;3CDA 20 41 08

.L_3CDD	jsr cart_draw_trackQ		;3CDD 20 7A 16
		jsr kernel_draw_tachometer_in_game		;3CE0 20 06 12
		jsr cart_draw_crane_with_sysctl		;3CE3 20 1E 1C
		jsr cart_L_14D0_from_main_loop		;3CE6 20 D0 14	; update scratches and scrapes?
		jsr toggle_display_pageQ		;3CE9 20 42 3F
		jsr kernel_game_update		;3CEC 20 41 08
		lda #$80		;3CEF A9 80
		sta L_C307		;3CF1 8D 07 C3
		sta irq_mode		;3CF4 8D F8 3D
		ldy #$03		;3CF7 A0 03
		jsr delay_approx_Y_25ths_sec		;3CF9 20 EB 3F
		jsr ensure_screen_enabled		;3CFC 20 9E 3F
		jsr L_3F27_with_SID		;3CFF 20 27 3F
		jsr L_3046_from_main_loop		;3D02 20 46 30

.L_3D05
		dec L_C30C		;3D05 CE 0C C3
		jsr cart_L_1C64_with_keys		;3D08 20 64 1C
		jsr kernel_game_update		;3D0B 20 41 08
		jsr kernel_L_E104		;3D0E 20 04 E1
		jsr cart_draw_trackQ		;3D11 20 7A 16
		jsr cart_L_2C6F		;3D14 20 6F 2C
		jsr cart_L_14D0_from_main_loop		;3D17 20 D0 14
		jsr cart_draw_crane_with_sysctl		;3D1A 20 1E 1C
		jsr cart_update_per_track_stuff		;3D1D 20 18 1D
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
.L_3DA1	ldx #KEY_DEF_QUIT		;3DA1 A2 2F
		jsr poll_key_with_sysctl		;3DA3 20 C9 C7
		beq L_3DAB		;3DA6 F0 03
.L_3DA8	jmp L_3D05		;3DA8 4C 05 3D

.L_3DAB	lda L_C364		;3DAB AD 64 C3
		bne L_3DB5		;3DAE D0 05
		lda #$C0		;3DB0 A9 C0
		sta L_C362		;3DB2 8D 62 C3
.L_3DB5	lda #$00		;3DB5 A9 00
		jsr vic_set_border_colour		;3DB7 20 BB 3F
		lda #$00		;3DBA A9 00
		sta irq_mode		;3DBC 8D F8 3D
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
.L_3DED	jsr cart_save_rndQ_stateQ		;3DED 20 2C 16
		ldx #$00		;3DF0 A2 00
		lda #$34		;3DF2 A9 34
		jsr cart_sysctl		;3DF4 20 25 87
		rts				;3DF7 60
}

; *****************************************************************************
; *****************************************************************************

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

		CPX #$E4
		BCS L_3E17		; BEEB - skip MOS ZP vars

		sta $00,X		;3E15 95 00
.L_3E17	dex				;3E17 CA
		bne L_3DFB		;3E18 D0 E1
		ldx L_C71A		;3E1A AE 1A C7
		ldy #$00		;3E1D A0 00
.L_3E1F	lda league_values,X	;3E1F BD EA BF
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
		jsr cart_update_camera_roll_tables		;3E69 20 26 27
		lda #$A0		;3E6C A9 A0
		sta ZP_33		;3E6E 85 33
		lda #$78		;3E70 A9 78
		sta ZP_3C		;3E72 85 3C
		jsr kernel_L_E0F9_with_sysctl		;3E74 20 F9 E0
		lda #$04		;3E77 A9 04
		sta L_C354		;3E79 8D 54 C3
		ldy #$09		;3E7C A0 09
		jsr cart_L_1637		;3E7E 20 37 16
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
		sta boost_reserve		;3E9F 8D 6A C7
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
.L_3EB6_from_main_loop		; can be moved to Cart
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

.update_pause_status		; can be moved to Kernel
{
		lda L_C306		;3EE0 AD 06 C3
		bpl L_3EEC		;3EE3 10 07
		ldx #KEY_DEF_PAUSE		;3EE5 A2 0D
		jsr poll_key_with_sysctl		;3EE7 20 C9 C7
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
		ldx #KEY_DEF_CONTINUE		;3F0C A2 34
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
		sta screen_buffer_next_vsync		;3F53 8D 70 C3

;		LDA #HI(screen1_address / 8)

		jmp L_3F64		;3F56 4C 64 3F
.L_3F59	lda #$18		;3F59 A9 18
		clc				;3F5B 18
		adc L_A1F2		;3F5C 6D F2 A1
		sta ZP_12		;3F5F 85 12
		sta screen_buffer_next_vsync		;3F61 8D 70 C3

;		LDA #HI(screen2_address / 8)

.L_3F64	
;		PHA
;		LDA #12:STA &FE00
;		PLA:STA &FE01

		lda #$80		;3F64 A9 80
		sta L_C37A		;3F66 8D 7A C3
		cli				;3F69 58
		rts				;3F6A 60
}

.ensure_screen_enabled		RTS
IF _NOT_BEEB
{
		lda VIC_SCROLY		;3F9E AD 11 D0
		and #$10		;3FA1 29 10			; 1=enable screen
		bne L_3FB4		;3FA3 D0 0F
}
ENDIF
\\
.enable_screen_and_set_irq50
IF _NOT_BEEB
		lda VIC_SCROLY		;3FA5 AD 11 D0
		ora #$10		;3FA8 09 10			; 1=enable screen
		and #$7F		;3FAA 29 7F			; 0=raster compare HI
		sta VIC_SCROLY		;3FAC 8D 11 D0
		lda #$32		;3FAF A9 32
		sta VIC_RASTER		;3FB1 8D 12 D0
.L_3FB4	lda #C64_VIC_IRQ_RASTERCMP		;3FB4 A9 01
		sta VIC_IRQMASK		;3FB6 8D 1A D0
ENDIF
		rts				;3FB9 60
		
.vic_border_colour	equb $00

.vic_set_border_colour
{
		sta vic_border_colour		;3FBB 8D BA 3F
}
\\
.vic_reset_border_colour
{
		nop				;3FBE EA
		ldy #$05		;3FBF A0 05
		sty ZP_14		;3FC1 84 14
.L_3FC3	lda VIC_RASTER		;3FC3 AD 12 D0
		cmp #$0A		;3FC6 C9 0A
		bcs L_3FCF		;3FC8 B0 05
		lda VIC_SCROLY		;3FCA AD 11 D0		; VIC raster compare HI
		bpl L_3FD6		;3FCD 10 07
.L_3FCF	dec ZP_14		;3FCF C6 14
		bne L_3FC3		;3FD1 D0 F0
		dey				;3FD3 88
		bne L_3FC3		;3FD4 D0 ED
.L_3FD6	lda vic_border_colour		;3FD6 AD BA 3F
		sta VIC_EXTCOL		;3FD9 8D 20 D0
		lda VIC_SCROLY		;3FDC AD 11 D0
		and #$EF		;3FDF 29 EF				; 0=blank screen
		sta VIC_SCROLY		;3FE1 8D 11 D0
		ldy #$01		;3FE4 A0 01
		jmp delay_approx_Y_25ths_sec		;3FE6 4C EB 3F
}

.delay_approx_4_5ths_sec
		ldy #$14		;3FE9 A0 14
\\
.delay_approx_Y_25ths_sec
{
		lda #$14		;3FEB A9 14
		sta ZP_15		;3FED 85 15
.L_3FEF	dec ZP_14		;3FEF C6 14
		bne L_3FEF		;3FF1 D0 FC
		dec ZP_15		;3FF3 C6 15
		bne L_3FEF		;3FF5 D0 F8
		dey				;3FF7 88
		bne delay_approx_Y_25ths_sec		;3FF8 D0 F1
		rts				;3FFA 60
}

\\ Moved from Cart RAM

.nmi_handler		; C64 only
{
		pha				;9A32 48
		lda CIA2_C2DDRA		;9A33 AD 0D DD
		pla				;9A36 68
		rti				;9A37 40
}

\\ Moved from Hazel RAM

; entry: X	holds key to test.
; 
; exit: Z set if key pressed.

.poll_key_with_sysctl
{
		tya				;C7C9 98
		pha				;C7CA 48
		lda #$81		;C7CB A9 81
		ldy #$FF		;C7CD A0 FF
		jsr cart_sysctl		;C7CF 20 25 87
		pla				;C7D2 68
		tay				;C7D3 A8
		cpx #$FF		;C7D4 E0 FF
		rts				;C7D6 60
}
\\ NB. can't be put in DLL as sets flag on exit

.core_end
