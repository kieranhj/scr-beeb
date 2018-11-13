; *****************************************************************************
; Jump tables
; *****************************************************************************

MACRO DLL_CALL_KERNEL fn, id
IF BEEB_KERNEL_SLOT = 0
{
	JMP fn
}
ELSE
{
    \\ Preserve X
	STX DLL_REG_X

    \\ Load fn index
    LDX #id

    \\ Call jump fn

    JMP jump_to_kernel
}
ENDIF
ENDMACRO

.beeb_dll_start

.DLL_REG_A skip 1           \\ Move these to ZP when possible
.DLL_REG_X skip 1

.jump_to_kernel
{
    STA DLL_REG_A

    \\ Remember current bank
    LDA &F4: PHA

    \\ Set new bank
    LDA #BEEB_KERNEL_SLOT
    STA &F4: STA &FE30

    LDA kernel_table_LO, X
    STA kernel_addr + 1

    LDA kernel_table_HI, X

IF _DEBUG
    BMI fn_ok   ; can only jump into upper half of RAM!
    BRK         ; X=fn index that isn't implemented
    .fn_ok
ENDIF

    STA kernel_addr + 2

    \\ Restore A before fn call
    LDX DLL_REG_X
    LDA DLL_REG_A
}
\\ Call function
.kernel_addr
    JSR &FFFF
{
    \\ Preserve A
    STA DLL_REG_A

    \\ Restore original bank
    PLA
    STA &F4:STA &FE30

    \\ Restore A before return
    LDA DLL_REG_A

    RTS
}

; *****************************************************************************
\\ Functions residing in Kernel module originally from Kernel RAM
; *****************************************************************************

.jmp_L_E0F9_with_sysctl	DLL_CALL_KERNEL L_E0F9_with_sysctl, 0
.jmp_L_E104 DLL_CALL_KERNEL L_E104, 1
.jmp_L_E195 DLL_CALL_KERNEL L_E195, 2
.jmp_L_E1B1 DLL_CALL_KERNEL L_E1B1, 3
.jmp_L_E4DA DLL_CALL_KERNEL L_E4DA, 4
.jmp_L_E544 DLL_CALL_KERNEL L_E544, 5
.jmp_L_E631 DLL_CALL_KERNEL L_E631, 6
.jmp_L_E641 DLL_CALL_KERNEL L_E641, 7
.jmp_L_E808 DLL_CALL_KERNEL L_E808, 8
.jmp_L_E85B DLL_CALL_KERNEL L_E85B, 9
.jmp_L_E87F DLL_CALL_KERNEL L_E87F, 10
.jmp_L_E8C2 DLL_CALL_KERNEL L_E8C2, 11
.jmp_L_E8E5 DLL_CALL_KERNEL L_E8E5, 12
.jmp_L_E9A3 DLL_CALL_KERNEL L_E9A3, 13
.jmp_prepare_trackQ DLL_CALL_KERNEL prepare_trackQ, 14
.jmp_L_EC11 DLL_CALL_KERNEL L_EC11, 15
.jmp_get_entered_name DLL_CALL_KERNEL get_entered_name, 16
.jmp_L_EDAB DLL_CALL_KERNEL L_EDAB, 17
.jmp_do_menu_screen DLL_CALL_KERNEL do_menu_screen, 18
.jmp_do_main_menu_dwim DLL_CALL_KERNEL do_main_menu_dwim, 19
.jmp_L_F021 DLL_CALL_KERNEL L_F021, 20
.jmp_get_track_segment_detailsQ DLL_CALL_KERNEL get_track_segment_detailsQ, 21
.jmp_L_F0C5 DLL_CALL_KERNEL L_F0C5, 22
.jmp_L_F117 DLL_CALL_KERNEL L_F117, 23
.jmp_L_F1DC DLL_CALL_KERNEL L_F1DC, 24
.jmp_L_F2B7 DLL_CALL_KERNEL L_F2B7, 25
.jmp_L_F386 DLL_CALL_KERNEL L_F386, 26
.jmp_L_F440 DLL_CALL_KERNEL L_F440, 27
.jmp_L_F488 DLL_CALL_KERNEL L_F488, 28
.jmp_L_F585 DLL_CALL_KERNEL L_F585, 29
.jmp_L_F5E9 DLL_CALL_KERNEL L_F5E9, 30
.jmp_update_boosting DLL_CALL_KERNEL update_boosting, 31
.jmp_L_F668 DLL_CALL_KERNEL L_F668, 32
.jmp_L_F673 DLL_CALL_KERNEL L_F673, 33
.jmp_L_F6A6 DLL_CALL_KERNEL L_F6A6, 34
.jmp_check_game_keys DLL_CALL_KERNEL check_game_keys, 35
.jmp_L_F811 DLL_CALL_KERNEL L_F811, 36
.jmp_set_linedraw_colour DLL_CALL_KERNEL set_linedraw_colour, 37
.jmp_set_linedraw_op DLL_CALL_KERNEL set_linedraw_op, 38
.jmp_L_FE91_with_draw_line DLL_CALL_KERNEL L_FE91_with_draw_line, 39
.jmp_draw_line DLL_CALL_KERNEL draw_line, 40
.jmp_L_FF6A DLL_CALL_KERNEL L_FF6A, 41
.jmp_L_FF84 DLL_CALL_KERNEL L_FF84, 42
.jmp_L_FF87 DLL_CALL_KERNEL L_FF87, 43
.jmp_L_FF8E DLL_CALL_KERNEL L_FF8E, 44
.jmp_update_tyre_spritesQ DLL_CALL_KERNEL update_tyre_spritesQ, 45
.jmp_L_FFE2 DLL_CALL_KERNEL L_FFE2, 46

; *****************************************************************************
\\ Functions in Kernel module moved from Core RAM
; *****************************************************************************

.jmp_game_update DLL_CALL_KERNEL game_update, 47
.jmp_L_0F2A DLL_CALL_KERNEL L_0F2A, 48
.jmp_L_0F72 DLL_CALL_KERNEL L_0F72, 49
.jmp_set_text_cursor DLL_CALL_KERNEL set_text_cursor, 50
.jmp_print_single_digit DLL_CALL_KERNEL print_single_digit, 51
.jmp_L_1090 DLL_CALL_KERNEL L_1090, 52
.jmp_L_10D9 DLL_CALL_KERNEL L_10D9, 53
.jmp_L_114D_with_color_ram DLL_CALL_KERNEL L_114D_with_color_ram, 54
.jmp_L_115D_with_color_ram DLL_CALL_KERNEL L_115D_with_color_ram, 55
.jmp_update_distance_to_ai_car_readout DLL_CALL_KERNEL update_distance_to_ai_car_readout, 56
.jmp_draw_tachometer_in_game DLL_CALL_KERNEL draw_tachometer_in_game, 57
.jmp_initialise_hud_sprites DLL_CALL_KERNEL initialise_hud_sprites, 58
.jmp_set_up_text_sprite DLL_CALL_KERNEL set_up_text_sprite, 59

; *****************************************************************************
\\ Functions in Kernel module moved from Hazel RAM
; *****************************************************************************

.jmp_mul_8_8_16bit DLL_CALL_KERNEL mul_8_8_16bit, 60
.jmp_poll_key_with_sysctl DLL_CALL_KERNEL poll_key_with_sysctl, 61
.jmp_L_C81E DLL_CALL_KERNEL L_C81E, 62
.jmp_mul_8_16_16bit DLL_CALL_KERNEL mul_8_16_16bit, 63
.jmp_mul_8_16_16bit_2 DLL_CALL_KERNEL mul_8_16_16bit_2, 64
.jmp_negate_if_N_set DLL_CALL_KERNEL negate_if_N_set, 65
.jmp_negate_16bit DLL_CALL_KERNEL negate_16bit, 66
.jmp_accurate_sin DLL_CALL_KERNEL accurate_sin, 67      ; only called from Cart?
.jmp_square_ay_32bit DLL_CALL_KERNEL square_ay_32bit, 68    ; only called from Cart?
.jmp_shift_16bit DLL_CALL_KERNEL shift_16bit, 69
.jmp_L_CF68 DLL_CALL_KERNEL L_CF68, 70
.jmp_L_CF73 DLL_CALL_KERNEL L_CF73, 71      ; only called from Cart?
.jmp_L_CFB7 DLL_CALL_KERNEL L_CFB7, 72
.jmp_L_CFC5 DLL_CALL_KERNEL L_CFC5, 73
.jmp_L_CFD2 DLL_CALL_KERNEL L_CFD2, 74
.jmp_track_preview_check_keys DLL_CALL_KERNEL track_preview_check_keys, 75

; *****************************************************************************
\\ Function addresses
; *****************************************************************************

.kernel_table_LO
{
	EQUB LO(L_E0F9_with_sysctl)
	EQUB LO(L_E104)
	EQUB LO(L_E195)
	EQUB LO(L_E1B1)
	EQUB LO(L_E4DA)
	EQUB LO(L_E544)
	EQUB LO(L_E631)
	EQUB LO(L_E641)
	EQUB LO(L_E808)
	EQUB LO(L_E85B)
	EQUB LO(L_E87F)
	EQUB LO(L_E8C2)
	EQUB LO(L_E8E5)
	EQUB LO(L_E9A3)
	EQUB LO(prepare_trackQ)
	EQUB LO(L_EC11)
	EQUB LO(get_entered_name)
	EQUB LO(L_EDAB)
	EQUB LO(do_menu_screen)
	EQUB LO(do_main_menu_dwim)
	EQUB LO(L_F021)
	EQUB LO(get_track_segment_detailsQ)
	EQUB LO(L_F0C5)
	EQUB LO(L_F117)
	EQUB LO(L_F1DC)
	EQUB LO(L_F2B7)
	EQUB LO(L_F386)
	EQUB LO(L_F440)
	EQUB LO(L_F488)
	EQUB LO(L_F585)
	EQUB LO(L_F5E9)
	EQUB LO(update_boosting)
	EQUB LO(L_F668)
	EQUB LO(L_F673)
	EQUB LO(L_F6A6)
	EQUB LO(check_game_keys)
	EQUB LO(L_F811)
	EQUB LO(set_linedraw_colour)
	EQUB LO(set_linedraw_op)
	EQUB LO(L_FE91_with_draw_line)
	EQUB LO(draw_line)
	EQUB LO(L_FF6A)
	EQUB LO(L_FF84)
	EQUB LO(L_FF87)
	EQUB LO(L_FF8E)
	EQUB LO(update_tyre_spritesQ)
	EQUB LO(L_FFE2)

	EQUB LO(game_update)
	EQUB LO(L_0F2A)
	EQUB LO(L_0F72)
	EQUB LO(set_text_cursor)
	EQUB LO(print_single_digit)
	EQUB LO(L_1090)
	EQUB LO(L_10D9)
	EQUB LO(L_114D_with_color_ram)
	EQUB LO(L_115D_with_color_ram)
	EQUB LO(update_distance_to_ai_car_readout)
	EQUB LO(draw_tachometer_in_game)
	EQUB LO(initialise_hud_sprites)
	EQUB LO(set_up_text_sprite)

	EQUB LO(mul_8_8_16bit)
	EQUB LO(poll_key_with_sysctl)
	EQUB LO(L_C81E)
	EQUB LO(mul_8_16_16bit)
	EQUB LO(mul_8_16_16bit_2)
	EQUB LO(negate_if_N_set)
	EQUB LO(negate_16bit)
	EQUB LO(accurate_sin)       ; only called from Cart?
	EQUB LO(square_ay_32bit)    ; only called from Cart?
	EQUB LO(shift_16bit)
	EQUB LO(L_CF68)
	EQUB LO(L_CF73)             ; only called from Cart?
	EQUB LO(L_CFB7)
	EQUB LO(L_CFC5)
	EQUB LO(L_CFD2)
	EQUB LO(track_preview_check_keys)
}

.kernel_table_HI
{
	EQUB HI(L_E0F9_with_sysctl)
	EQUB HI(L_E104)
	EQUB HI(L_E195)
	EQUB HI(L_E1B1)
	EQUB HI(L_E4DA)
	EQUB HI(L_E544)
	EQUB HI(L_E631)
	EQUB HI(L_E641)
	EQUB HI(L_E808)
	EQUB HI(L_E85B)
	EQUB HI(L_E87F)
	EQUB HI(L_E8C2)
	EQUB HI(L_E8E5)
	EQUB HI(L_E9A3)
	EQUB HI(prepare_trackQ)
	EQUB HI(L_EC11)
	EQUB HI(get_entered_name)
	EQUB HI(L_EDAB)
	EQUB HI(do_menu_screen)
	EQUB HI(do_main_menu_dwim)
	EQUB HI(L_F021)
	EQUB HI(get_track_segment_detailsQ)
	EQUB HI(L_F0C5)
	EQUB HI(L_F117)
	EQUB HI(L_F1DC)
	EQUB HI(L_F2B7)
	EQUB HI(L_F386)
	EQUB HI(L_F440)
	EQUB HI(L_F488)
	EQUB HI(L_F585)
	EQUB HI(L_F5E9)
	EQUB HI(update_boosting)
	EQUB HI(L_F668)
	EQUB HI(L_F673)
	EQUB HI(L_F6A6)
	EQUB HI(check_game_keys)
	EQUB HI(L_F811)
	EQUB HI(set_linedraw_colour)
	EQUB HI(set_linedraw_op)
	EQUB HI(L_FE91_with_draw_line)
	EQUB HI(draw_line)
	EQUB HI(L_FF6A)
	EQUB HI(L_FF84)
	EQUB HI(L_FF87)
	EQUB HI(L_FF8E)
	EQUB HI(update_tyre_spritesQ)
	EQUB HI(L_FFE2)

	EQUB HI(game_update)
	EQUB HI(L_0F2A)
	EQUB HI(L_0F72)
	EQUB HI(set_text_cursor)
	EQUB HI(print_single_digit)
	EQUB HI(L_1090)
	EQUB HI(L_10D9)
	EQUB HI(L_114D_with_color_ram)
	EQUB HI(L_115D_with_color_ram)
	EQUB HI(update_distance_to_ai_car_readout)
	EQUB HI(draw_tachometer_in_game)
	EQUB HI(initialise_hud_sprites)
	EQUB HI(set_up_text_sprite)

	EQUB HI(mul_8_8_16bit)
	EQUB HI(poll_key_with_sysctl)
	EQUB HI(L_C81E)
	EQUB HI(mul_8_16_16bit)
	EQUB HI(mul_8_16_16bit_2)
	EQUB HI(negate_if_N_set)
	EQUB HI(negate_16bit)
	EQUB HI(accurate_sin)       ; only called from Cart?
	EQUB HI(square_ay_32bit)    ; only called from Cart?
	EQUB HI(shift_16bit)
	EQUB HI(L_CF68)
	EQUB HI(L_CF73)             ; only called from Cart?
	EQUB HI(L_CFB7)
	EQUB HI(L_CFC5)
	EQUB HI(L_CFD2)
	EQUB HI(track_preview_check_keys)
}

.beeb_dll_end
