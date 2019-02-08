; *****************************************************************************
; Jump tables
; *****************************************************************************

_STORE_STATUS = FALSE

MACRO DLL_CALL_KERNEL fn, id
IF BEEB_KERNEL_SLOT = 0
{
	JMP fn
}
ELSE
{
IF _STORE_STATUS
	PHP
ENDIF

    \\ Preserve X
	STX jump_to_kernel_reload_x+1

    \\ Load fn index
    LDX #id

    \\ Call jump fn

    JMP jump_to_kernel
}
ENDIF
ENDMACRO

.beeb_dll_start

.jump_to_kernel
{
    sta reload_a+1

IF _STORE_STATUS
	PLA
	STA .reload_status+1
ENDIF

    \\ Remember current bank
    LDA &F4: PHA

    \\ Set new bank
    LDA #BEEB_KERNEL_SLOT
    STA &F4: STA &FE30

    LDA kernel_table_LO, X
    STA kernel_addr + 1

    LDA kernel_table_HI, X

IF _DEBUG
    BMI fn_ok1   ; can only jump into upper half of RAM!
    BRK         ; X=fn index that isn't implemented
    .fn_ok1
	CMP #&C0
	BCC fn_ok2
	BRK
	.fn_ok2
ENDIF

    STA kernel_addr + 2

IF _STORE_STATUS
.reload_status:lda #$ff
	PHA
ENDIF

    \\ Restore A before fn call
.*jump_to_kernel_reload_x:ldx #$ff
.reload_a:lda #$ff

IF _STORE_STATUS
	PLP
ENDIF
}
\\ Call function
.kernel_addr
    JSR &FFFF
{
IF _STORE_STATUS
	PHP
ENDIF

    \\ Preserve A
	sta reload_a+1

IF _STORE_STATUS
	PLA
	STA .reload_status+1
ENDIF

    \\ Restore original bank
    PLA
    STA &F4:STA &FE30

IF _STORE_STATUS
.reload_status:lda #$ff
	PHA
ENDIF

    \\ Restore A before return
.reload_a:lda #$ff

IF _STORE_STATUS
	PLP
ENDIF

    RTS
}

; *****************************************************************************
\\ Functions residing in Kernel module originally from Kernel RAM
; *****************************************************************************

.kernel_silence_all_voices_with_sysctl	DLL_CALL_KERNEL silence_all_voices_with_sysctl, 0
.kernel_L_E104_with_sid DLL_CALL_KERNEL L_E104_with_sid, 1
.kernel_L_E195 DLL_CALL_KERNEL L_E195, 2
.kernel_L_E1B1 DLL_CALL_KERNEL L_E1B1, 3
.kernel_L_E4DA DLL_CALL_KERNEL L_E4DA, 4
.kernel_L_E544 DLL_CALL_KERNEL L_E544, 5		; not required in DLL
.kernel_L_E631 DLL_CALL_KERNEL L_E631, 6
.kernel_L_E641 DLL_CALL_KERNEL L_E641, 7
.kernel_L_E808 DLL_CALL_KERNEL L_E808, 8
.kernel_L_E85B DLL_CALL_KERNEL L_E85B, 9
.kernel_L_E87F DLL_CALL_KERNEL L_E87F, 10
.kernel_L_E8C2 DLL_CALL_KERNEL L_E8C2, 11
.kernel_L_E8E5 DLL_CALL_KERNEL L_E8E5, 12
.kernel_L_E9A3 DLL_CALL_KERNEL L_E9A3, 13
.kernel_set_road_data1 DLL_CALL_KERNEL set_road_data1, 14
.kernel_L_EC11 DLL_CALL_KERNEL L_EC11, 15		; not required in DLL
.kernel_get_entered_name DLL_CALL_KERNEL get_entered_name, 16
.kernel_L_EDAB DLL_CALL_KERNEL L_EDAB, 17
.kernel_do_menu_screen DLL_CALL_KERNEL do_menu_screen, 18
.kernel_do_main_menu_dwim DLL_CALL_KERNEL do_main_menu_dwim, 19
.kernel_L_F021 DLL_CALL_KERNEL L_F021, 20		; not required in DLL
.kernel_fetch_near_section_stuff DLL_CALL_KERNEL fetch_near_section_stuff, 21
.kernel_fetch_xz_position DLL_CALL_KERNEL fetch_xz_position, 22
.kernel_L_F117 DLL_CALL_KERNEL L_F117, 23		; only in Cart
.kernel_L_F1DC DLL_CALL_KERNEL L_F1DC, 24
.kernel_L_F2B7 DLL_CALL_KERNEL L_F2B7, 25
.kernel_update_track_preview DLL_CALL_KERNEL update_track_preview, 26
.kernel_L_F440 DLL_CALL_KERNEL L_F440, 27
.kernel_setup_car_on_trackQ DLL_CALL_KERNEL setup_car_on_trackQ, 28
.kernel_L_F585 DLL_CALL_KERNEL L_F585, 29
.kernel_L_F5E9 DLL_CALL_KERNEL L_F5E9, 30		; not required in DLL
.kernel_update_boosting DLL_CALL_KERNEL update_boosting, 31	; only in Cart
.kernel_L_F668 DLL_CALL_KERNEL L_F668, 32		; not required in DLL
.kernel_L_F673 DLL_CALL_KERNEL L_F673, 33		; not required in DLL
.kernel_L_F6A6 DLL_CALL_KERNEL L_F6A6, 34
.kernel_check_game_keys DLL_CALL_KERNEL check_game_keys, 35
.kernel_L_F811 DLL_CALL_KERNEL L_F811, 36		; not required in DLL
.kernel_set_linedraw_colour DLL_CALL_KERNEL set_linedraw_colour, 37
.kernel_set_linedraw_op DLL_CALL_KERNEL set_linedraw_op, 38
.kernel_L_FE91_with_draw_line DLL_CALL_KERNEL L_FE91_with_draw_line, 39
.kernel_draw_line DLL_CALL_KERNEL draw_line, 40
.kernel_L_FF6A DLL_CALL_KERNEL L_FF6A, 41
.kernel_L_FF84 DLL_CALL_KERNEL L_FF84, 42		; not required in DLL
.kernel_L_FF87 DLL_CALL_KERNEL L_FF87, 43		; not required in DLL
.kernel_L_FF8E DLL_CALL_KERNEL L_FF8E, 44
.kernel_update_tyre_spritesQ DLL_CALL_KERNEL update_tyre_spritesQ, 45		; not required in DLL
.kernel_L_FFE2 DLL_CALL_KERNEL L_FFE2, 46		; only in Cart

; *****************************************************************************
\\ Functions in Kernel module moved from Core RAM
; *****************************************************************************

.kernel_game_update DLL_CALL_KERNEL game_update, 47
.kernel_L_0F2A DLL_CALL_KERNEL L_0F2A, 48
.kernel_L_0F72 DLL_CALL_KERNEL L_0F72, 49		; not required in DLL
\\ was set_text_cursor, 50
\\ was kernel_print_single_digit, 51
.kernel_L_1090 DLL_CALL_KERNEL L_1090, 52
.kernel_L_10D9 DLL_CALL_KERNEL L_10D9, 53
.kernel_L_114D_with_color_ram DLL_CALL_KERNEL L_114D_with_color_ram, 54
.kernel_L_115D_with_color_ram DLL_CALL_KERNEL L_115D_with_color_ram, 55
.kernel_update_distance_to_ai_car_readout DLL_CALL_KERNEL update_distance_to_ai_car_readout, 56
.kernel_draw_tachometer_in_game DLL_CALL_KERNEL draw_tachometer_in_game, 57
.kernel_initialise_hud_sprites DLL_CALL_KERNEL initialise_hud_sprites, 58
; .kernel_set_up_text_sprite DLL_CALL_KERNEL set_up_text_sprite, 59

; *****************************************************************************
\\ Functions in Kernel module moved from Hazel RAM
; *****************************************************************************

.kernel_mul_8_8_16bit DLL_CALL_KERNEL mul_8_8_16bit, 60
.kernel_poll_key_with_sysctl BRK	; sets flags on exit
.kernel_L_C81E DLL_CALL_KERNEL L_C81E, 62
.kernel_mul_8_16_16bit DLL_CALL_KERNEL mul_8_16_16bit, 63
.kernel_mul_8_16_16bit_2 DLL_CALL_KERNEL mul_8_16_16bit_2, 64
.kernel_negate_if_N_set DLL_CALL_KERNEL negate_if_N_set, 65
.kernel_negate_16bit DLL_CALL_KERNEL negate_16bit, 66		; not required in DLL
.kernel_accurate_sin BRK      ; only called from Kernel?
.kernel_square_ay_32bit BRK    ; only called from Cart?
.kernel_shift_16bit DLL_CALL_KERNEL shift_16bit, 69
.kernel_play_sound_effect DLL_CALL_KERNEL play_sound_effect, 70
.kernel_L_CF73 BRK      ; only called from Cart?
.kernel_L_CFB7 DLL_CALL_KERNEL L_CFB7, 72
.kernel_to_next_road_section DLL_CALL_KERNEL to_next_road_section, 73
.kernel_to_previous_road_section DLL_CALL_KERNEL to_previous_road_section, 74
.kernel_track_preview_check_keys DLL_CALL_KERNEL track_preview_check_keys, 75

.kernel_select_track DLL_CALL_KERNEL select_track, 76
.kernel_print_division_table DLL_CALL_KERNEL print_division_table, 77
.kernel_set_up_screen_for_frontend DLL_CALL_KERNEL set_up_screen_for_frontend, 78
.kernel_L_3EB6_from_main_loop DLL_CALL_KERNEL L_3EB6_from_main_loop, 79

; *****************************************************************************
\\ Function addresses
; *****************************************************************************

.kernel_table_LO
{
	EQUB LO(silence_all_voices_with_sysctl)
	EQUB LO(L_E104_with_sid)
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
	EQUB LO(set_road_data1)
	EQUB LO(L_EC11)
	EQUB LO(get_entered_name)
	EQUB LO(L_EDAB)
	EQUB LO(do_menu_screen)
	EQUB LO(do_main_menu_dwim)
	EQUB LO(L_F021)
	EQUB LO(fetch_near_section_stuff)
	EQUB LO(fetch_xz_position)
	EQUB LO(L_F117)
	EQUB LO(L_F1DC)
	EQUB LO(L_F2B7)
	EQUB LO(update_track_preview)
	EQUB LO(L_F440)
	EQUB LO(setup_car_on_trackQ)
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
	EQUB 0;LO(set_text_cursor)
	EQUB 0;LO(print_single_digit)
	EQUB LO(L_1090)
	EQUB LO(L_10D9)
	EQUB LO(L_114D_with_color_ram)
	EQUB LO(L_115D_with_color_ram)
	EQUB LO(update_distance_to_ai_car_readout)
	EQUB LO(draw_tachometer_in_game)
	EQUB LO(initialise_hud_sprites)
	EQUB 0 ; LO(set_up_text_sprite)

	EQUB LO(mul_8_8_16bit)
	EQUB 0	; poll_key_with_sysctl
	EQUB LO(L_C81E)
	EQUB LO(mul_8_16_16bit)
	EQUB LO(mul_8_16_16bit_2)
	EQUB LO(negate_if_N_set)
	EQUB LO(negate_16bit)
	EQUB 0	; only called from Cart?
	EQUB 0  ; only called from Cart?
	EQUB LO(shift_16bit)
	EQUB LO(play_sound_effect)
	EQUB 0  ; only called from Cart?
	EQUB LO(L_CFB7)
	EQUB LO(to_next_road_section)
	EQUB LO(to_previous_road_section)
	EQUB LO(track_preview_check_keys)

	EQUB LO(select_track)
	EQUB LO(print_division_table)
	EQUB LO(set_up_screen_for_frontend)
	EQUB LO(L_3EB6_from_main_loop)
}

.kernel_table_HI
{
	EQUB HI(silence_all_voices_with_sysctl)
	EQUB HI(L_E104_with_sid)
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
	EQUB HI(set_road_data1)
	EQUB HI(L_EC11)
	EQUB HI(get_entered_name)
	EQUB HI(L_EDAB)
	EQUB HI(do_menu_screen)
	EQUB HI(do_main_menu_dwim)
	EQUB HI(L_F021)
	EQUB HI(fetch_near_section_stuff)
	EQUB HI(fetch_xz_position)
	EQUB HI(L_F117)
	EQUB HI(L_F1DC)
	EQUB HI(L_F2B7)
	EQUB HI(update_track_preview)
	EQUB HI(L_F440)
	EQUB HI(setup_car_on_trackQ)
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
	EQUB 0	;HI(set_text_cursor)
	EQUB 0	;HI(print_single_digit)
	EQUB HI(L_1090)
	EQUB HI(L_10D9)
	EQUB HI(L_114D_with_color_ram)
	EQUB HI(L_115D_with_color_ram)
	EQUB HI(update_distance_to_ai_car_readout)
	EQUB HI(draw_tachometer_in_game)
	EQUB HI(initialise_hud_sprites)
	EQUB 0 ; HI(set_up_text_sprite)

	EQUB HI(mul_8_8_16bit)
	EQUB 0	; poll_key_with_sysctl
	EQUB HI(L_C81E)
	EQUB HI(mul_8_16_16bit)
	EQUB HI(mul_8_16_16bit_2)
	EQUB HI(negate_if_N_set)
	EQUB HI(negate_16bit)
	EQUB 0	; only called from Cart?
	EQUB 0	; only called from Cart?
	EQUB HI(shift_16bit)
	EQUB HI(play_sound_effect)
	EQUB 0  ; only called from Cart?
	EQUB HI(L_CFB7)
	EQUB HI(to_next_road_section)
	EQUB HI(to_previous_road_section)
	EQUB HI(track_preview_check_keys)

	EQUB HI(select_track)
	EQUB HI(print_division_table)
	EQUB HI(set_up_screen_for_frontend)
	EQUB HI(L_3EB6_from_main_loop)
}

PRINT "KERNEL Jump Table Entries =", kernel_table_HI-kernel_table_LO, "(", P%-kernel_table_HI, ")"

; *****************************************************************************
; Same again but for functions in Cart module
; *****************************************************************************

MACRO DLL_CALL_CART fn, id
IF BEEB_CART_SLOT = 0
{
	JMP fn
}
ELSE
{
IF _STORE_STATUS
	PHP
ENDIF

    \\ Preserve X
	STX jump_to_cart_reload_x+1

    \\ Load fn index
    LDX #id

    \\ Call jump fn
    JMP jump_to_cart
}
ENDIF
ENDMACRO

.jump_to_cart
{
    STA reload_a+1

IF _STORE_STATUS
	PLA
	STA reload_status+1
ENDIF

    \\ Remember current bank
    LDA &F4: PHA

    \\ Set new bank
    LDA #BEEB_CART_SLOT
    STA &F4: STA &FE30

    LDA cart_table_LO, X
    STA cart_addr + 1

    LDA cart_table_HI, X

IF _DEBUG
    BMI fn_ok1   ; can only jump into upper half of RAM!
    BRK         ; X=fn index that isn't implemented
    .fn_ok1
	CMP #&C0
	BCC fn_ok2
	BRK
	.fn_ok2
ENDIF

    STA cart_addr + 2

IF _STORE_STATUS
.reload_status:lda #$ff
	PHA
ENDIF

    \\ Restore A before fn call
.*jump_to_cart_reload_x:ldx #$ff
.reload_a:lda #$ff

IF _STORE_STATUS
	PLP
ENDIF
}
\\ Call function
.cart_addr
    JSR &FFFF
{
IF _STORE_STATUS
	PHP
ENDIF

    \\ Preserve A
    STA reload_a+1

IF _STORE_STATUS
	PLA
	STA reload_status+1
ENDIF

    \\ Restore original bank
    PLA
    STA &F4:STA &FE30

IF _STORE_STATUS
.reload_status:lda #$ff
	PHA
ENDIF

    \\ Restore A before return
.reload_a:lda #$ff

IF _STORE_STATUS
	PLP
ENDIF

    RTS
}

; *****************************************************************************
\\ Functions in Cart module called from outside of Cart RAM
; *****************************************************************************

.cart_write_char DLL_CALL_CART write_char, 0
.cart_getch DLL_CALL_CART getch, 1
.cart_sid_play_sound DLL_CALL_CART sid_play_sound, 2	; only called from Kernel
.cart_sid_update_voice_2 BRK
.cart_sysctl DLL_CALL_CART sysctl, 4
.cart_print_3space DLL_CALL_CART print_3space, 5	; not required in DLL
.cart_print_2space DLL_CALL_CART print_2space, 6
.cart_print_space DLL_CALL_CART print_space, 7
.cart_L_91B4 DLL_CALL_CART L_91B4, 8			; small fn - move to Core?
.cart_L_91C3 DLL_CALL_CART L_91C3, 9			; small fn - move to Core?
.cart_print_race_times DLL_CALL_CART print_race_times, 10				; not required in DLL
.cart_convert_X_to_BCD DLL_CALL_CART convert_X_to_BCD, 11
.cart_print_track_records DLL_CALL_CART print_track_records, 12
.cart_copy_track_records_Q DLL_CALL_CART copy_track_records_Q, 13
.cart_L_93A8 DLL_CALL_CART L_93A8, 14
.cart_L_9448 DLL_CALL_CART L_9448, 15
.cart_write_file_string DLL_CALL_CART write_file_string, 16
.cart_L_95EA DLL_CALL_CART L_95EA, 17
.cart_maybe_define_keys DLL_CALL_CART maybe_define_keys, 18
.cart_store_restore_control_keys DLL_CALL_CART store_restore_control_keys, 19
.cart_print_lap_time_Q DLL_CALL_CART print_lap_time_Q, 20
.cart_L_9A38 DLL_CALL_CART L_9A38, 21
.cart_L_9C14 DLL_CALL_CART L_9C14, 22			; all in Kernel
.cart_L_9EBC DLL_CALL_CART L_9EBC, 23			; all in Kernel
.cart_L_A026 DLL_CALL_CART L_A026, 24
.cart_print_msg_2 DLL_CALL_CART print_msg_2, 25
.cart_print_msg_3 DLL_CALL_CART print_msg_3, 26

.cart_reset_sprites DLL_CALL_CART reset_sprites, 27
.cart_L_14D0_from_main_loop DLL_CALL_CART L_14D0_from_main_loop, 28
.cart_L_1611 DLL_CALL_CART L_1611, 29
.cart_save_rndQ_stateQ DLL_CALL_CART save_rndQ_stateQ, 30
.cart_load_rndQ_stateQ DLL_CALL_CART load_rndQ_stateQ, 31
.cart_draw_trackQ DLL_CALL_CART draw_trackQ, 32
.cart_make_near_road_coords DLL_CALL_CART make_near_road_coords, 33
.cart_L_1A3B DLL_CALL_CART L_1A3B, 34
.cart_update_damage_display DLL_CALL_CART update_damage_display, 35
.cart_draw_crane_with_sysctl DLL_CALL_CART draw_crane_with_sysctl, 36
.cart_clear_menu_area DLL_CALL_CART clear_menu_area, 37
.cart_draw_menu_header DLL_CALL_CART draw_menu_header, 38
.cart_L_1C64_with_keys DLL_CALL_CART L_1C64_with_keys, 39
.cart_L_1CCB DLL_CALL_CART L_1CCB, 40				; not required in DLL
.cart_update_per_track_stuff DLL_CALL_CART update_per_track_stuff, 41
.cart_L_1EE2_from_main_loop DLL_CALL_CART L_1EE2_from_main_loop, 42
.cart_L_238E DLL_CALL_CART L_238E, 43
.cart_L_25EA BRK
.cart_pow36Q DLL_CALL_CART pow36Q, 45
.cart_update_camera_roll_tables DLL_CALL_CART update_camera_roll_tables, 46
.cart_L_2809 DLL_CALL_CART L_2809, 47
.cart_draw_crash_smoke DLL_CALL_CART draw_crash_smoke, 48	; not required in DLL
.cart_L_2A5C DLL_CALL_CART L_2A5C, 49			; not required in DLL

.cart_L_2C64 DLL_CALL_CART L_2C64, 50
.cart_L_2C6F_from_main_loop DLL_CALL_CART L_2C6F_from_main_loop, 51
; 52
.cart_draw_track_preview_track_name DLL_CALL_CART draw_track_preview_track_name, 53
.cart_do_initial_screen DLL_CALL_CART do_initial_screen, 54
.cart_do_end_of_race_screen DLL_CALL_CART do_end_of_race_screen, 55	; not required in DLL
.cart_L_3389_from_game_start DLL_CALL_CART L_3389_from_game_start, 56
.cart_L_3626_from_game_start DLL_CALL_CART L_3626_from_game_start, 57
.cart_print_driver_v_driver DLL_CALL_CART print_driver_v_driver, 58
.cart_do_driver_league_changes DLL_CALL_CART do_driver_league_changes, 59
.cart_menu_colour_map_stuff DLL_CALL_CART menu_colour_map_stuff, 60
.cart_get_menu_screen_ptr DLL_CALL_CART get_menu_screen_ptr, 61
.cart_prep_menu_graphics DLL_CALL_CART prep_menu_graphics, 62
.cart_set_up_colour_map_for_track_preview DLL_CALL_CART set_up_colour_map_for_track_preview, 63

.start_of_frame_track_preview DLL_CALL_CART _start_of_frame_track_preview, 64
.cart_print_single_digit DLL_CALL_CART print_single_digit, 65
.cart_print_msg_1 DLL_CALL_CART print_msg_1, 66
.cart_print_msg_4 DLL_CALL_CART print_msg_4, 67
.cart_set_text_cursor DLL_CALL_CART set_text_cursor, 68
.cart_print_number_unpadded DLL_CALL_CART print_number_unpadded, 69
.cart_print_track_title DLL_CALL_CART print_track_title, 70

; *****************************************************************************
\\ Function addresses
; *****************************************************************************

.cart_table_LO
{
	EQUB LO(write_char)
	EQUB LO(getch)
	EQUB LO(sid_play_sound)
	EQUB 0;LO(sid_update_voice_2)
	EQUB LO(sysctl)
	EQUB LO(print_3space)
	EQUB LO(print_2space)
	EQUB LO(print_space)
	EQUB LO(L_91B4)
	EQUB LO(L_91C3)
	EQUB LO(print_race_times)
	EQUB LO(convert_X_to_BCD)
	EQUB LO(print_track_records)
	EQUB LO(copy_track_records_Q)
	EQUB LO(L_93A8)
	EQUB LO(L_9448)
	EQUB LO(write_file_string)
	EQUB LO(L_95EA)
	EQUB LO(maybe_define_keys)
	EQUB LO(store_restore_control_keys)
	EQUB LO(print_lap_time_Q)
	EQUB LO(L_9A38)
	EQUB LO(L_9C14)
	EQUB LO(L_9EBC)
	EQUB LO(L_A026)
	EQUB LO(print_msg_2)
	EQUB LO(print_msg_3)

	EQUB LO(reset_sprites)
	EQUB LO(L_14D0_from_main_loop)
	EQUB LO(L_1611)
	EQUB LO(save_rndQ_stateQ)
	EQUB LO(load_rndQ_stateQ)
	EQUB LO(draw_trackQ)
	EQUB LO(make_near_road_coords)
	EQUB LO(L_1A3B)
	EQUB LO(update_damage_display)
	EQUB LO(draw_crane_with_sysctl)
	EQUB LO(clear_menu_area)
	EQUB LO(draw_menu_header)
	EQUB LO(L_1C64_with_keys)
	EQUB LO(L_1CCB)
	EQUB LO(update_per_track_stuff)
	EQUB LO(L_1EE2_from_main_loop)
	EQUB LO(L_238E)
	EQUB 0
	EQUB LO(pow36Q)
	EQUB LO(update_camera_roll_tables)
	EQUB LO(L_2809)
	EQUB LO(draw_crash_smoke)
	EQUB LO(L_2A5C)

	EQUB LO(L_2C64)
	EQUB LO(L_2C6F_from_main_loop)
	EQUB 0 ; 52
	EQUB LO(draw_track_preview_track_name)
	EQUB LO(do_initial_screen)
	EQUB LO(do_end_of_race_screen)
	EQUB LO(L_3389_from_game_start)
	EQUB LO(L_3626_from_game_start)
	EQUB LO(print_driver_v_driver)
	EQUB LO(do_driver_league_changes)
	EQUB LO(menu_colour_map_stuff)
	EQUB LO(get_menu_screen_ptr)
	EQUB LO(prep_menu_graphics)
	EQUB LO(set_up_colour_map_for_track_preview)

	EQUB LO(_start_of_frame_track_preview)
	EQUB LO(print_single_digit)
	EQUB LO(print_msg_1)
	EQUB LO(print_msg_4)
	EQUB LO(set_text_cursor)
	EQUB LO(print_number_unpadded)
	EQUB LO(print_track_title)
}

.cart_table_HI
{
	EQUB HI(write_char)
	EQUB HI(getch)
	EQUB HI(sid_play_sound)
	EQUB 0;HI(sid_update_voice_2)
	EQUB HI(sysctl)
	EQUB HI(print_3space)
	EQUB HI(print_2space)
	EQUB HI(print_space)
	EQUB HI(L_91B4)
	EQUB HI(L_91C3)
	EQUB HI(print_race_times)
	EQUB HI(convert_X_to_BCD)
	EQUB HI(print_track_records)
	EQUB HI(copy_track_records_Q)
	EQUB HI(L_93A8)
	EQUB HI(L_9448)
	EQUB HI(write_file_string)
	EQUB HI(L_95EA)
	EQUB HI(maybe_define_keys)
	EQUB HI(store_restore_control_keys)
	EQUB HI(print_lap_time_Q)
	EQUB HI(L_9A38)
	EQUB HI(L_9C14)
	EQUB HI(L_9EBC)
	EQUB HI(L_A026)
	EQUB HI(print_msg_2)
	EQUB HI(print_msg_3)

	EQUB HI(reset_sprites)
	EQUB HI(L_14D0_from_main_loop)
	EQUB HI(L_1611)
	EQUB HI(save_rndQ_stateQ)
	EQUB HI(load_rndQ_stateQ)
	EQUB HI(draw_trackQ)
	EQUB HI(make_near_road_coords)
	EQUB HI(L_1A3B)
	EQUB HI(update_damage_display)
	EQUB HI(draw_crane_with_sysctl)
	EQUB HI(clear_menu_area)
	EQUB HI(draw_menu_header)
	EQUB HI(L_1C64_with_keys)
	EQUB HI(L_1CCB)
	EQUB HI(update_per_track_stuff)
	EQUB HI(L_1EE2_from_main_loop)
	EQUB HI(L_238E)
	EQUB 0
	EQUB HI(pow36Q)
	EQUB HI(update_camera_roll_tables)
	EQUB HI(L_2809)
	EQUB HI(draw_crash_smoke)
	EQUB HI(L_2A5C)

	EQUB HI(L_2C64)
	EQUB HI(L_2C6F_from_main_loop)
	EQUB 0 ; 52
	EQUB HI(draw_track_preview_track_name)
	EQUB HI(do_initial_screen)
	EQUB HI(do_end_of_race_screen)
	EQUB HI(L_3389_from_game_start)
	EQUB HI(L_3626_from_game_start)
	EQUB HI(print_driver_v_driver)
	EQUB HI(do_driver_league_changes)
	EQUB HI(menu_colour_map_stuff)
	EQUB HI(get_menu_screen_ptr)
	EQUB HI(prep_menu_graphics)
	EQUB HI(set_up_colour_map_for_track_preview)

	EQUB HI(_start_of_frame_track_preview)
	EQUB HI(print_single_digit)
	EQUB HI(print_msg_1)
	EQUB HI(print_msg_4)
	EQUB HI(set_text_cursor)
	EQUB HI(print_number_unpadded)
	EQUB HI(print_track_title)
}

PRINT "CART Jump Table Entries =", cart_table_HI-cart_table_LO, "(", P%-cart_table_HI, ")"

; *****************************************************************************
; Same again but for functions in Graphics module
; *****************************************************************************

MACRO DLL_CALL_GRAPHICS fn, id
IF BEEB_GRAPHICS_SLOT = 0
{
	JMP fn
}
ELSE
{
IF _STORE_STATUS
	PHP
ENDIF

    \\ Preserve X
	STX jump_to_graphics_reload_x+1

    \\ Load fn index
    LDX #id

    \\ Call jump fn
    JMP jump_to_graphics
}
ENDIF
ENDMACRO

.jump_to_graphics
{
    STA reload_a+1

IF _STORE_STATUS
	PLA
	STA reload_status+1
ENDIF

    \\ Remember current bank
    LDA &F4: PHA

    \\ Set new bank
    LDA #BEEB_GRAPHICS_SLOT
    STA &F4: STA &FE30

    LDA graphics_table_LO, X
    STA graphics_addr + 1

    LDA graphics_table_HI, X

IF _DEBUG
    BMI fn_ok1   ; can only jump into upper half of RAM!
    BRK         ; X=fn index that isn't implemented
    .fn_ok1
	CMP #&C0
	BCC fn_ok2
	BRK
	.fn_ok2
ENDIF

    STA graphics_addr + 2

IF _STORE_STATUS
.reload_status:lda #$ff
	PHA
ENDIF

    \\ Restore A before fn call
.*jump_to_graphics_reload_x:ldx #$ff
.reload_a:lda #$ff

IF _STORE_STATUS
	PLP
ENDIF
}
\\ Call function
.graphics_addr
    JSR &FFFF
{
IF _STORE_STATUS
	PHP
ENDIF

    \\ Preserve A
	STA reload_a+1

IF _STORE_STATUS
	PLA
	STA reload_status+1
ENDIF


    \\ Restore original bank
    PLA
    STA &F4:STA &FE30

IF _STORE_STATUS
.reload_status:lda #$ff
	PHA
ENDIF

    \\ Restore A before return
.reload_a:lda #$ff

IF _STORE_STATUS
	PLP
ENDIF

    RTS
}

; *****************************************************************************
\\ Functions in Graphics module called from outside of Graphics RAM
; *****************************************************************************

.graphics_draw_flames DLL_CALL_GRAPHICS _graphics_draw_flames, 0
.graphics_erase_flames DLL_CALL_GRAPHICS _graphics_erase_flames, 1
.graphics_draw_in_game_text_sprites DLL_CALL_GRAPHICS _graphics_draw_in_game_text_sprites, 2
.graphics_draw_left_wheel DLL_CALL_GRAPHICS _graphics_draw_left_wheel, 3
.graphics_draw_right_wheel DLL_CALL_GRAPHICS _graphics_draw_right_wheel, 4
.dash_reset DLL_CALL_GRAPHICS _dash_reset, 5
.dash_update_lap DLL_CALL_GRAPHICS _dash_update_lap, 6
.dash_update_boost DLL_CALL_GRAPHICS _dash_update_boost, 7
.dash_update_distance_to_ai_car DLL_CALL_GRAPHICS _dash_update_distance_to_ai_car, 8
.dash_update_current_lap_time DLL_CALL_GRAPHICS _dash_update_current_lap_time, 9
.dash_update_best_lap_time DLL_CALL_GRAPHICS _dash_update_best_lap_time, 10
.dash_update_flag_icon DLL_CALL_GRAPHICS _dash_update_flag_icon, 11
.dash_update_stopwatch_icon DLL_CALL_GRAPHICS _dash_update_stopwatch_icon, 12
.preview_draw_screen DLL_CALL_GRAPHICS _preview_draw_screen, 13
.preview_unpack_background DLL_CALL_GRAPHICS _preview_unpack_background, 14
.preview_add_background DLL_CALL_GRAPHICS _preview_add_background, 15
.graphics_draw_debug_framerate DLL_CALL_GRAPHICS _graphics_draw_debug_framerate, 16
.graphics_unpack_menu_screen DLL_CALL_GRAPHICS _graphics_unpack_menu_screen, 17
.set_up_text_sprite DLL_CALL_GRAPHICS _set_up_text_sprite, 18
.graphics_pause_save_screen DLL_CALL_GRAPHICS graphics_pause_save_screen,19
.graphics_pause_show_text_sprite DLL_CALL_GRAPHICS graphics_pause_show_text_sprite,20

; Note that this routine has 2 names. I don't think the distinction is
; relevant for the BBC.
.disable_screen_and_change_border_colour
.disable_screen DLL_CALL_GRAPHICS _disable_screen,21


; Note that this routine has 2 names. I don't think the distinction is
; relevant for the BBC.
.enable_screen_and_set_irq50
.ensure_screen_enabled DLL_CALL_GRAPHICS _ensure_screen_enabled,22


; *****************************************************************************
\\ Function addresses
; *****************************************************************************

.graphics_table_LO
{
	EQUB LO(_graphics_draw_flames)				 ; 0
	EQUB LO(_graphics_erase_flames)				 ; 1
	EQUB LO(_graphics_draw_in_game_text_sprites) ; 2
	EQUB LO(_graphics_draw_left_wheel)			 ; 3
	EQUB LO(_graphics_draw_right_wheel)			 ; 4
	EQUB LO(_dash_reset)						 ; 5
	EQUB LO(_dash_update_lap)					 ; 6
	EQUB LO(_dash_update_boost)					 ; 7
	EQUB LO(_dash_update_distance_to_ai_car)	 ; 8
	EQUB LO(_dash_update_current_lap_time)		 ; 9
	EQUB LO(_dash_update_best_lap_time)			 ; 10
	EQUB LO(_dash_update_flag_icon)				 ; 11
	EQUB LO(_dash_update_stopwatch_icon)		 ; 12
	EQUB LO(_preview_draw_screen)				 ; 13
	EQUB LO(_preview_unpack_background)			 ; 14
	EQUB LO(_preview_add_background)			 ; 15
	EQUB LO(_graphics_draw_debug_framerate)		 ; 16
	EQUB LO(_graphics_unpack_menu_screen)		 ; 17
	EQUB LO(_set_up_text_sprite)				 ; 18
	EQUB LO(_graphics_pause_save_screen)		 ; 19
	EQUB LO(_graphics_pause_show_text_sprite)	 ; 20
	EQUB LO(_disable_screen)					 ; 21
	EQUB LO(_ensure_screen_enabled)				 ; 22
}

.graphics_table_HI
{
	EQUB HI(_graphics_draw_flames)				 ; 0
	EQUB HI(_graphics_erase_flames)				 ; 1
	EQUB HI(_graphics_draw_in_game_text_sprites) ; 2
	EQUB HI(_graphics_draw_left_wheel)			 ; 3
	EQUB HI(_graphics_draw_right_wheel)			 ; 4
	EQUB HI(_dash_reset)						 ; 5
	EQUB HI(_dash_update_lap)					 ; 6
	EQUB HI(_dash_update_boost)					 ; 7
	EQUB HI(_dash_update_distance_to_ai_car)	 ; 8
	EQUB HI(_dash_update_current_lap_time)		 ; 9
	EQUB HI(_dash_update_best_lap_time)			 ; 10
	EQUB HI(_dash_update_flag_icon)				 ; 11
	EQUB HI(_dash_update_stopwatch_icon)		 ; 12
	EQUB HI(_preview_draw_screen)				 ; 13
	EQUB HI(_preview_unpack_background)			 ; 14
	EQUB HI(_preview_add_background)			 ; 15
	EQUB HI(_graphics_draw_debug_framerate)		 ; 16
	EQUB HI(_graphics_unpack_menu_screen)		 ; 17
	EQUB HI(_set_up_text_sprite)				 ; 18
	EQUB HI(_graphics_pause_save_screen)		 ; 19
	EQUB HI(_graphics_pause_show_text_sprite)	 ; 20
	EQUB HI(_disable_screen)					 ; 21
	EQUB HI(_ensure_screen_enabled)				 ; 22
}

PRINT "GRAPHICS Jump Table Entries =", graphics_table_HI-graphics_table_LO, "(", P%-graphics_table_HI, ")"



.beeb_dll_end
