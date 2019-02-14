; *****************************************************************************
\\ Data moved from Cart RAM to Core
; *****************************************************************************

_JUST_ONE_TRACK_FOR_SAVING_RAM = FALSE

.core_data_start

\\ Save game
PAGE_ALIGN
.L_8000	skip $C0
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
L_80C0	= L_8000 + $C0

\\ FONT START at $80C0
.font_data
	equb $00,$00,$00,$00,$00,$00,$00,$00 ; 32
.L_80C8

	equb $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff ; 33 - backspace char
	equb $15,$15,$15,$15,$15,$6A,$6A,$6A ; 34 +$08
	
; Hole.

	equb %01001111 ; %01110101 ; $75
	equb %10011001 ; %11000011 ; $c3
	equb %00000000 ; %00000000 ; $00
	equb %00000000 ; %00000000 ; $00
	equb %00000000 ; %00000000 ; $00
	equb %00000000 ; %00000000 ; $00
	equb %10000000 ; %10000000 ; $80
	equb %00001000 ; %10000000 ; $80

	equb %00001000 ; %01000000 ; $40
	equb %00001000 ; %01000000 ; $40
	equb %10001000 ; %11000000 ; $c0
	equb %00000000 ; %00000000 ; $00
	equb %00000000 ; %00000000 ; $00
	equb %10000000 ; %10000000 ; $80
	equb %00001000 ; %10000000 ; $80
	equb %00001000 ; %10000000 ; $80

; Original pattern? (no longer used)
; 
; ?? - $55 = 1/1/1/1, $aa=2/2/2/2
	equb $55,$55,$55,$55,$55,$AA,$AA,$AA ; 37 +$20
	equb $55,$55,$55,$55,$55,$AA,$AA,$AA ; 38 +$28

; Hole with highlight (displayed briefly).
    equb %01101111 ; %10111101 ; $bd
	equb %11111111 ; %11111111 ; $ff
	equb %10011001 ; %11000011 ; $c3
	equb %10001000 ; %11000000 ; $c0
	equb %10011001 ; %11000011 ; $c3
	equb %11011101 ; %11110011 ; $f3
	equb %01111111 ; %10111111 ; $bf
	equb %01111111 ; %10111111 ; $bf

	equb %00000000 ; %00000000 ; $00
	equb %00000000 ; %00000000 ; $00
	equb %10001000 ; %11000000 ; $c0
	equb %10001000 ; %11000000 ; $c0
	equb %10001000 ; %11000000 ; $c0
	equb %10001000 ; %11000000 ; $c0
	equb %10001000 ; %01000000 ; $40
	equb %00001000 ; %01000000 ; $40
	
	equb $FF,$80,$80,$80,$80,$80,$80,$80 ; 41
	equb $80,$80,$80,$80,$80,$80,$80,$FF ; 42
	equb $08,$08,$08,$7F,$08,$08,$08,$00 ; 43
	equb $01,$01,$01,$01,$01,$01,$01,$FF ; 44
	equb $00,$00,$00,$7F,$00,$00,$00,$00 ; 45
	equb $00,$00,$00,$00,$00,$00,$10,$00 ; 46
	equb $00,$02,$04,$08,$10,$20,$40,$00 ; 47
	equb $00,$3C,$42,$42,$42,$42,$3C,$00 ; 48
	equb $00,$10,$30,$10,$10,$10,$38,$00 ; 49
	equb $00,$3C,$42,$0C,$30,$40,$7E,$00 ; 50
	equb $00,$7E,$04,$0C,$02,$42,$3C,$00 ; 51
	equb $00,$04,$0C,$14,$24,$7E,$04,$00 ; 52
	equb $00,$7E,$40,$7C,$02,$02,$7C,$00 ; 53
	equb $00,$3C,$40,$7C,$42,$42,$3C,$00 ; 54
	equb $00,$7E,$04,$08,$10,$20,$20,$00 ; 55
	equb $00,$3C,$42,$3C,$42,$42,$3C,$00 ; 56
	equb $00,$3C,$42,$3C,$04,$08,$10,$00 ; 57
	equb $00,$00,$10,$00,$00,$10,$00,$00 ; 58
	equb $00,$00,$10,$00,$00,$10,$20,$00 ; 59
	equb $18,$18,$18,$18,$18,$00,$18,$00 ; 60
	equb $00,$00,$7E,$00,$7E,$00,$00,$00 ; 61
	equb $30,$18,$0C,$06,$0C,$18,$30,$00 ; 62
	equb $00,$38,$44,$04,$08,$10,$00,$10 ; 63
	equb $3C,$66,$6E,$6A,$6E,$60,$3C,$00 ; 64
	equb $00,$3C,$42,$42,$7E,$42,$42,$00 ; 65
	equb $00,$78,$44,$7C,$42,$42,$7C,$00 ; 66
	equb $00,$3C,$42,$40,$40,$42,$3C,$00 ; 67
	equb $00,$7C,$42,$42,$42,$42,$7C,$00 ; 68
	equb $00,$7E,$40,$78,$40,$40,$7E,$00 ; 69
	equb $00,$7E,$40,$78,$40,$40,$40,$00 ; 70
	equb $00,$3C,$42,$40,$4E,$42,$3E,$00 ; 71
	equb $00,$42,$42,$7E,$42,$42,$42,$00 ; 72
	equb $00,$38,$10,$10,$10,$10,$38,$00 ; 73
	equb $00,$04,$04,$04,$04,$44,$38,$00 ; 74
	equb $00,$44,$48,$70,$48,$44,$42,$00 ; 75
	equb $00,$20,$20,$20,$20,$20,$3E,$00 ; 76
	equb $00,$42,$66,$5A,$42,$42,$42,$00 ; 77
	equb $00,$42,$62,$52,$4A,$46,$42,$00 ; 78
	equb $00,$3C,$42,$42,$42,$42,$3C,$00 ; 79
	equb $00,$7C,$42,$7C,$40,$40,$40,$00 ; 80
	equb $00,$3C,$42,$42,$42,$42,$3C,$06 ; 81
	equb $00,$7C,$42,$7C,$48,$44,$42,$00 ; 82
	equb $00,$3E,$40,$3C,$02,$02,$7C,$00 ; 83
	equb $00,$7C,$10,$10,$10,$10,$10,$00 ; 84
	equb $00,$42,$42,$42,$42,$42,$3E,$00 ; 85
	equb $00,$42,$42,$42,$42,$24,$18,$00 ; 86
	equb $00,$42,$42,$42,$5A,$66,$42,$00 ; 87
	equb $00,$42,$24,$18,$18,$24,$42,$00 ; 88
	equb $00,$44,$44,$28,$10,$10,$10,$00 ; 89
	equb $00,$7E,$04,$08,$10,$20,$7E,$00 ; 90

; Lap type indexes:
;
; +0 = player current lap
; +1 = opponent current lap??
; +2 = best lap
;
; These appear to be arrays, so there are probably more...

; Lap time fractions of second
.L_8298	equb $01,$00,$00,$00,$00,$00,$00,$FF,$80,$00,$00,$00,$00,$00

.L_82A6	equb $00
.L_82A7	equb $FF,$00,$00,$00,$FF,$00,$00,$00,$01

; Lap time seconds
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

; Lap time minutes
.L_8398	equb $00,$00,$00,$FF,$00,$00,$00,$81,$81,$81,$81,$81,$81,$81

.L_83A6	equb $81
.L_83A7	equb $81,$81,$00,$00,$00,$00,$00,$00,$81

; Fandal says "table of car damage for multiplayer (12 byte)"
.L_83B0	equb $FF,$00,$00,$00,$00,$00,$00,$FF,$30,$18,$0C,$06,$0C,$18,$30,$00

\\comments are index/offset
.file_strings_offset
equb file_strings_loaded-file_strings ; $00 / $05
equb file_strings_saved-file_strings ; $01 / $0d
equb file_strings_problem_encountered-file_strings ; $02 / $43
equb file_strings_incorrect_data_found-file_strings ; $03 / $14
equb file_strings_file_name_already_exists-file_strings ; $04 / $2a
equb file_strings_problem_encountered-file_strings ; $05 / $43
equb file_strings_problem_encountered-file_strings ; $06 / $43
equb file_strings_problem_encountered-file_strings ; $07 / $43
equb file_strings_insert_game_position_save-file_strings ; $08 / $71
equb file_strings_tape-file_strings ; $09 / $8f
equb file_strings_disc-file_strings ; $0a / $94

\\
.L_A1F2	equb $E8,$46,$4B,$53,$52,$46,$55,$48,$42,$45,$52,$44

.L_E8E1	equb $09,$06,$03,$00

.L_EE35	equb $00

; KEY DEFINITIONS

.control_keys
; equals, space, s, d, return
; equb $2E,$27,$29,$12,$08
equb KEY_DEF_BRAKE, KEY_DEF_BACK, KEY_DEF_LEFT, KEY_DEF_RIGHT, KEY_DEF_FIRE

.menu_keys
equb KEY_MENU_OPTION_1,KEY_MENU_OPTION_2,KEY_MENU_OPTION_3,KEY_MENU_OPTION_4

.L_F810	equb $11

.L_2099	equb $78
.L_209A	equb $6E
.L_209B	equb $05

;.L_083A	equb $00,$00,$00,$00,$00,$00 ; unused?
.L_0840	equb $01				; save device - 0=tape, 1=disk

.L_1327	equb $00
.L_1328	equb $02

; $80=main game,$00=exiting,$40=track preview,$41=frontend
.irq_mode	equb $00


; *****************************************************************************
\\ Data moved from Kernel RAM to Core
; *****************************************************************************

; FRONTEND STRINGS

.frontend_strings_2
.frontend_strings_2_select
		equb $1F,$11,$0B,"SELECT",$FF
.frontend_strings_2_practise
		equb "Practise ",$FF
.frontend_strings_2_start_the_racing_season
		equb "Start the Racing Season",$FF
.frontend_strings_2_load_save_replay
		equb "Load/Save/Replay       ",$FF
.frontend_strings_2_load
		equb "Load",$FF
.frontend_strings_2_save
		equb "Save",$FF
.frontend_strings_2_replay
		equb "Replay",$FF
.frontend_strings_2_cancel
		equb "Cancel",$FF
.frontend_strings_2_load_from_tape
		equb "Load Hall of Fame",$FF
.frontend_strings_2_load_from_disc
		equb "Load Game",$FF
.frontend_strings_2_save_to_tape
		equb "Save Hall of Fame",$FF
.frontend_strings_2_save_to_disc
		equb "Save Game",$FF
.frontend_strings_2_filename
		equb $1F,$05,$13,"   Filename?  >",$FF
.frontend_strings_2_to_the_super_league
		equb "to the SUPER LEAGUE",$FF
.frontend_strings_2_super_division
		equb $1F,$0C
.L_E0BD	equb $09,"SUPER DIVISION "
		equb $FF
.frontend_strings_2_excellent_driving_well_done
		equb "EXCELLENT DRIVING - WELL DONE",$FF
.frontend_strings_2_hall_of_fame
		equb "Hall of Fame",$FF
.frontend_strings_2_catalog
		equb "@CAT",$FF
if P%-frontend_strings_2>255:error "frontend_strings_2 too big":endif

.frontend_strings_3
.frontend_strings_3_select
		equb $1F,$11,$0B,"SELECT",$FF
.frontend_strings_3_single_player_league
		equb "Single Player League",$FF
.frontend_strings_3_multiplayer
		equb "Multiplayer",$FF
.frontend_strings_3_enter_another_driver
		equb "Enter another driver",$FF
.frontend_strings_3_continue
		equb "Continue",$FF
.frontend_strings_3_tracks_in_division
		equb "Tracks in DIVISION ",$FF
		equb $00,$00,$00
		equb $00,$00,$00
.frontend_strings_3_space_s_dot
		equb " S.",$FF
		equb "        "
.frontend_strings_3_s
		equb "s",$FF
.frontend_strings_3_driver_best_lap_race_time
		equb $1F,$06
.L_321D	equb $0E,"DRIVER      BEST-LAP RACE-TIME",$FF
.frontend_strings_3_track_the
		equb "Track:  The ",$FF
.frontend_strings_3_drivers_championship
		equb $1F,$0A,$09
		equb "DRIVERS CHAMPIONSHIP",$FF
.frontend_strings_3_track_record
		equb $1F,$0E,$14,"Track record",$FF
		equb $00
.frontend_strings_3_driver_2
		equb "------------",$FF
.frontend_strings_3_driver_1
		equb "------------",$FF
.frontend_strings_3_new_track_record
		equb $1F,$0C,$0F
		equb "New track record",$FF
.frontend_strings_3_credits
        equb "Credits",$FF
if P%-frontend_strings_3>255:error "frontend_strings_3 too big":endif

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
if P%-frontend_strings_4>255:error "frontend_strings_4 too big":endif

.beeb_mode5_crtc_regs
{
	EQUB 63				; R0  horizontal total
	EQUB 40					; R1  horizontal displayed
	EQUB 49					; R2  horizontal position
	EQUB &24				; R3  sync width 40 = &28
	EQUB 38					; R4  vertical total
	EQUB 0					; R5  vertical total adjust
	EQUB 25					; R6  vertical displayed
	EQUB 35					; R7  vertical position; 35=top of screen
	EQUB &0					; R8  interlace; &30 = HIDE SCREEN
	EQUB 7					; R9  scanlines per row
	EQUB 32					; R10 cursor start
	EQUB 8					; R11 cursor end
	EQUB HI(screen1_address/8)	; R12 screen start address, high
	EQUB LO(screen1_address/8)	; R13 screen start address, low
}

PAGE_ALIGN
.L_AD00	equb $FF,$8F,$FF,$EF,$FF
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

\\ Page $AE00 is copied to $DC00 at boot

.driver_name_data
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
		equb " "
.L_AEB1	equb "             ",$40,$60

\\ This looks like workspace data for C64 FS commands and think contents is just garbage
;			equb $A9
;.L_AEC1	equb $00,$A4,$18,$4C,$EA,$AE,$4C,$43,$AE,$A9,$00,$F0,$0A,$4C,$0E,$8C
;			equb $20,$EC,$AD,$D0,$F8,$A5,$36,$A0,$00,$F0,$0E,$A4,$1B,$B1,$19
.L_AEC0
{
		LDA #0
		LDY ZP_18
		JMP $AEEA		; not a real fn address
		JMP $AE43		; not a real fn address
		LDA #0
		BEQ L_AED8
.L_AECE	JMP $8C0E		; not a real fn address
		JSR $ADEC		; not a real fn address
		BNE L_AECE
		LDA ZP_36
.L_AED8	LDY #0
		BEQ P%+$10
		LDY ZP_1B
		LDA (ZP_19),Y
}

; buffer for save game name, I think? - see, e.g., sysctl_47
L_AEC1 = L_AEC0 + 1

;opponent.attributes
; OBSTRUCTS_PLAYER	equ	2
; WHEELIE			equ	4
; DRIVES_NEAR_EDGE	equ	8
; PUSH_PLAYER		equ	32
;	dc.b	PUSH_PLAYER|OBSTRUCTS_PLAYER
;	dc.b	PUSH_PLAYER
;	dc.b	%1000000|PUSH_PLAYER|OBSTRUCTS_PLAYER
;	dc.b	PUSH_PLAYER
;	dc.b	%0010000|PUSH_PLAYER|DRIVES_NEAR_EDGE|WHEELIE|OBSTRUCTS_PLAYER
;	dc.b	WHEELIE
;	dc.b	%0010000|PUSH_PLAYER
;	dc.b	%0010000|WHEELIE
;	dc.b	%1000000|DRIVES_NEAR_EDGE|OBSTRUCTS_PLAYER
;	dc.b	%0010000
;	dc.b	DRIVES_NEAR_EDGE
;	dc.b	%0000000			(unused)
.opponent_attributes
		equb $22,$20,$62,$20,$3E,$04,$30,$14,$4A,$10,$08,$00,$84,$2B,$A9,$00
		equb $85,$2C,$85,$2D,$A9,$40,$60,$A5,$1E,$4C,$D8,$AE,$A5,$00,$A4,$01

\\ Think this has to be page aligned

.track_name_data
		equb "LITTLE RAMP     "
		equb "STEPPING STONES "
		equb "HUMP BACK       "
		equb "BIG RAMP        "
		equb "SKI JUMP        "
		equb "DRAW BRIDGE     "
		equb "HIGH JUMP       "
		equb "ROLLER COASTER  "

;L_AF80
.sid_sound_data
	\\ Byte 0 = voice# for this data
	\\ Byte 1 = SID voice control register 
	\\ Byte 2 = Attack/Decay Register
	\\ Byte 3 = Sustain/Release Control Register
	\\ Byte 4 = Frequency Control (high byte)
	\\ Byte 5 = Pulse Waveform Width (high nybble)
	\\ Byte 6 = voice flags

		equb $01,$41,$05,$00,$50,$98,$04,$80		; sfx #0 - confirm keys
		; voice 2, pulse wave, decay 5/attack 0, sustain 0/release 0, freq $5000 = 1248Hz, pulse width $0400 = 25% wave
		; SN76489 reg = 100
 
		equb $01,$81,$0F,$E0
.sid_sfx1_freq_high	\\ Used in crash effect
		equb $64,$08,$1E,$80						; sfx #1 - crash?
		; voice 2, random wave, decay 15/attack 0, sustain 14/release 0, freq $6400, pulse width $0800

	; one will be hole and the other edge grind / wrecked

		equb $01,$81,$0F,$E0,$14,$08,$1E,$80		; sfx #2 - game update?
		; voice 2, random wave, decay 15/attack 0, sustain 14/release 0, freq $1400 = 312Hz, pulse width $0800
		; SN76489 reg = 400 ($190)

		equb $01,$81,$00,$F0,$03,$08,$03,$80		; sfx #3 - game update?
		; voice 2, random wave, decay 0/attack 0, sustain 15/release 0, freq $0300 = 47Hz, pulse width $0800
		; SN76489 reg = 2660 (beyond max $3FF of course)

		equb $01,$41,$02,$00,$64,$98,$01,$80		; sfx #4 - damage creak
		; voice 2, pulse wave, decay 2/attack 0, sustain 0/release 0, freq $6400 = 1560Hz, pulse width $0800 = 50% (square wave)
		; SN76489 reg = 80 ($50)

		equb $02,$00,$00,$FF,$50,$07,$FF,$80		; configure engine tone voice 3
		equb $00,$00,$00,$CF,$50,$07,$FF,$80		; configure engine tone voice 1
		equb $FF,$20,$E0,$FF,$4C,$D8,$AE,$20		; not valid sound data

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

\* These first 16 words are used to give offsets to the data definitions of
\* the different road pieces.  They are stored in low byte, high byte order
\* so they are rotated by 8 bit positions to give a high byte, low byte word.
\* This word then has #$b100 subtracted from it to give an offset to the data
\* of the required piece.
\*
\* The resulting words are as follows :-
\*
\*	336,419,000,510,601,000,728,827
\*	000,000,926,000,000,000,000,000
\*
\* Some values have been replaced by zeros because the actual values are
\* bollocks and are not used by the program (for any of the roads).  The only
\* values used by the program are words 0, 1, 3, 4, 6, 7 and 10.

;L_B100
.piece_data_offsets
		equw L_B250, L_B2A3, $FFA9, L_B2FE, L_B359, $DA20, L_B3D8, L_B43B
		equw $460A, $202E, L_B49E, $80A9, $2E85, $A560, $C930, $9081

;L_B120
.y_coordinate_offsets
	equw L_B50D, L_B51B, L_B524, L_B536, L_B544, L_B552, L_B55C, L_B566
	equw L_B56F, L_B578, L_B586, L_B594, L_B59D, L_B5A6, L_B5B2, L_B5CA
	equw L_B5D3, L_B5EB, L_B5F7, L_B601, L_B60A, L_B614, L_B61D, L_B627
	equw L_B631, L_B63A, L_B643, L_B64D, L_B657, L_B660, L_B669, L_B672
	equw L_B67B, L_B684, L_B690, L_B699, L_B6A2, L_B6AB, L_B6B7, L_B6C0
	equw L_B6C9, L_B6D5, L_B6E1, L_B6ED, L_B6F9, L_B702, L_B70B, L_B714
	equw L_B71D, L_B726, L_B732, L_B73E, L_B74C, L_B756, L_B75F, L_B768
	equw L_B77A, L_B783, L_B78C, L_B795, L_B79E, L_B7A7, L_B7B0, L_B7B9
	equw L_B7C3, L_B7CC, L_B7D6, L_B7E8, L_B7F1, L_B7FA, L_B803, L_B80C
	equw L_B816, L_B81F, L_B828, L_B831, L_B83A, L_B846, L_B84F, L_B858
	equw L_B870, $20A7, L_B87E, L_B887, L_B890, L_B89E, L_B8AC, L_B8B5
	equw L_B8BF, L_B8C9, L_B8D5, L_B8DE, L_B8E7, L_B8F0, L_B8FA, L_B903
	equw L_B915, L_B927, L_B939, L_B94B, L_B954, L_B960, L_B96A, L_B974
	equw L_B97E, L_B988, L_B991, L_B99A, L_B9A3, L_B9AC, L_B9B5, L_B9BE
	equw L_B9CA, L_B9D4, L_B9E0, L_B9F8, L_BA04, L_BA0D, L_BA1F, L_BA28
	equw $20A3, $A37D, L_BA31, $20AA, L_BA3A, L_BA44, L_BA4E, L_BA58

.tracks_table		; L_B220
		equw little_ramp_data
		equw stepping_stones_data
		equw hump_back_data
		equw big_ramp_data
		equw ski_jump_data
		equw draw_bridge_data
		equw high_jump_data
		equw roller_coaster_data
		equb $F5,$A7,$4C,$00,$A5,$4C,$B2,$A3
		equb $00,$17,$41,$63,$63,$75,$72,$61

\* These 16 bytes are flags for each of the near sections.  The actual values
\* used are as follows :-
\*
\*	dc.b	$00,$80,$00,$c0,$00,$00,$80,$c0
\*	dc.b	$00,$00,$00,$00,$00,$00,$00,$00
\*
\* If bit 7 is set then the car cannot be lowered onto this section.

;L_B240
.sections_car_can_be_put_on
	equb $00,$80,$20,$C0,$00,$73,$80,$C0,$A9,$59,$00,$02,$A9,$5E,$85,$4B

\* Groups of X and Z co-ordinates follow.  There are two bytes for each
\* co-ordinate - stored in low byte, high byte order.
\*
\* First line is :-	X = $340, Z = $000, X = $4c0, Z = $000

.L_B250; 		straight 8
		equb $04	;offset for number.of.coords
		equb $00	;near.section.byte1
		equb $40,$03
		equb $12	;number.of.coords
		equb $00	;gives curve.to.left
		equb $AB	;road.width.reduction
		equb $80	;road.length.reduction
		equb $80,$01
		equb $20	;section.steering.amount
		equb $40,$03,$00,$00,$C0
		equb $04,$00,$00,$40,$03,$00,$01,$C0,$04,$00,$01,$40,$03,$00,$02,$C0
		equb $04,$00,$02,$40,$03,$00,$03,$C0,$04,$00,$03,$40,$03,$00,$04,$C0
		equb $04,$00,$04,$40,$03,$00,$05,$C0,$04,$00,$05,$40,$03,$00,$06,$C0
		equb $04,$00,$06,$40,$03,$00,$07,$C0,$04,$00,$07,$40,$03,$00,$08,$C0
		equb $04,$00,$08

; 		curve right 8
.L_B2A3	equb $0C,$80,$A8,$0D,$00,$00,$00,$FF,$80,$68,$0A,$87,$12
		equb $00,$AB,$87,$80,$01,$3E,$40,$03,$00,$00,$C0,$04,$00,$00,$4C,$03
		equb $05,$01,$CA,$04,$DF,$00,$73,$03,$07,$02,$EB,$04,$BC,$01,$B2,$03
		equb $05,$03,$22,$05,$95,$02,$0A,$04,$FB,$03,$6D,$05,$68,$03,$7A,$04
		equb $E7,$04,$CD,$05,$32,$04,$00,$05,$C8,$05,$40,$06,$F2,$04,$9C,$05
		equb $9A,$06,$C5,$06,$A6,$05,$4C,$06,$5B,$07,$5B,$07,$4C,$06
		
; 		curve left 8
.L_B2FE	equb $0C,$C0
		equb $57,$FA,$00,$00,$00,$01,$80,$E8,$08,$87,$12,$03,$AB,$87,$80,$01
		equb $3E,$3F,$03,$00,$00,$BF,$04,$00,$00,$35,$03,$DF,$00,$B3,$04,$05
		equb $01,$14,$03,$BC,$01,$8C,$04,$07,$02,$DD,$02,$95,$02,$4D,$04,$05
		equb $03,$92,$02,$68,$03,$F5,$03,$FB,$03,$32,$02,$32,$04,$85,$03,$E7
		equb $04,$BF,$01,$F2,$04,$FF,$02,$C8,$05,$3A,$01,$A6,$05,$63,$02,$9A
		equb $06,$A4,$00,$4C,$06,$B3,$01,$5B,$07

; 		straight 13
.L_B359	equb $08,$40,$40,$FF,$00,$20,$80
		equb $B5,$1C,$00,$AB,$80,$80,$01,$20,$78,$FF,$87,$00,$87,$00,$78,$FF
		equb $2C,$00,$3C,$01,$3C,$01,$2C,$00,$E1,$00,$F0,$01,$F0,$01,$E1,$00
		equb $96,$01,$A5,$02,$A5,$02,$96,$01,$4A,$02,$5A,$03,$5A,$03,$4A,$02
		equb $FF,$02,$0E,$04,$0E,$04,$FF,$02,$B3,$03,$C3,$04,$C3,$04,$B3,$03
		equb $68,$04,$77,$05,$77,$05,$68,$04,$1D,$05,$2C,$06,$2C,$06,$1D,$05
		equb $D1,$05,$E1,$06,$E1,$06,$D1,$05,$86,$06,$95,$07,$95,$07,$86,$06
		equb $3A,$07,$4A,$08,$4A,$08,$3A,$07,$EF,$07,$FF,$08,$FF,$08,$EF,$07
		equb $A4,$08,$B3,$09,$B3,$09,$A4,$08

;		curve right 9
.L_B3D8	equb $0C,$80,$00,$10,$00,$00,$00,$FF
		equb $90,$C0,$0C,$7A,$14,$00,$AB,$7A,$80,$01,$32,$40,$03,$00,$00,$C0
		equb $04,$00,$00,$4C,$03,$1C,$01,$CA,$04,$FB,$00,$71,$03,$36,$02,$EB
		equb $04,$F4,$01,$AF,$03,$4C,$03,$22,$05,$E9,$02,$04,$04,$5C,$04,$6D
		equb $05,$D9,$03,$71,$04,$63,$05,$CD,$05,$C1,$04,$F5,$04,$60,$06,$41
		equb $06,$A0,$05,$8E,$05,$50,$07,$C8,$06,$73,$06,$3B,$06,$32,$08,$61
		equb $07,$3B,$07,$FC,$06,$03,$09,$0B,$08,$F4,$07

; 		curve left 9
.L_B43B	equb $0C,$C0,$00,$F8,$00
		equb $00,$00,$01,$90,$40,$0B,$7A,$14,$03,$AB,$7A,$80,$01,$32,$40,$03
		equb $00,$00,$C0,$04,$00,$00,$35,$03,$FB,$00,$B3,$04,$1C,$01,$14,$03
		equb $F4,$01,$8E,$04,$36,$02,$DD,$02,$E9,$02,$50,$04,$4C,$03,$92,$02
		equb $D9,$03,$FB,$03,$5C,$04,$32,$02,$C1,$04,$8E,$03,$63,$05,$BE,$01
		equb $A0,$05,$0A,$03,$60,$06,$37,$01,$73,$06,$71,$02,$50,$07,$9E,$00
		equb $3B,$07,$C4,$01,$32,$08,$F4,$FF,$F4,$07,$03,$01,$03,$09

; 		straight 11 aka O926
.L_B49E
		equb $08
		equb $40
		equb $40,$FF,$00,$20,$7C,$B0
		equb $18	; 12*2
		equb $00
		equb $AB	; WIDTH.REDUCTION
		equb $7C
		equb $80,$01
		equb $20

		equb $78,$FF,$87,$00,$87,$00,$78,$FF
		equb $32,$00,$41,$01,$41,$01,$32,$00
		equb $EC,$00,$FC,$01,$FC,$01,$EC,$00
		equb $A6,$01,$B6,$02,$B6,$02,$A6,$01
		equb $60,$02,$70,$03,$70,$03,$60,$02
		equb $1B,$03,$2A,$04,$2A,$04,$1B,$03
		equb $D5,$03,$E4,$04,$E4,$04,$D5,$03
		equb $8F,$04,$9F,$05,$9F,$05,$8F,$04
		equb $49,$05,$59,$06,$59,$06,$49,$05
		equb $03,$06,$13,$07,$13
.L_B4FA	equb                     $07,$03,$06
		equb $BE,$06,$CD,$07,$CD,$07,$BE,$06
		equb $78,$07,$87,$08,$87,$08,$78,$07

;******** Start of y co-ordinates for near sections ********

.L_B50D	equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.L_B51B	equb $00,$60,$61,$03,$44,$26,$28,$2A,$2C
.L_B524	equb $00,$00,$02,$00,$04,$00
		equb $06,$00,$08,$00,$0A,$00,$0C,$00,$0E,$00,$10,$00
.L_B536	equb $00,$20,$40,$60
		equb $01,$21,$41,$61,$02,$02,$02,$02,$02,$02
.L_B544	equb $02,$61,$41,$21,$01,$60
		equb $40,$20,$00,$00,$00,$00,$00,$00
.L_B552	equb $00,$60,$21,$51,$02,$22,$42,$62
		equb $03,$13
.L_B55C	equb $00,$20,$40,$70,$21,$41,$61,$02,$22,$32
.L_B566	equb $00,$02,$04,$06
		equb $E7,$29,$CA,$4B,$2C
.L_B56F	equb $46,$96,$55,$85,$24,$33,$B2,$21,$00
.L_B578	equb $00,$00
		equb $00,$00,$00,$10,$20,$40,$60,$01,$21,$41,$61,$02
.L_B586	equb $02,$02,$02,$02
		equb $02,$71,$61,$41,$21,$01,$60,$40,$20,$00
.L_B594	equb $00,$10,$10,$10,$10,$10
		equb $10,$90,$80
.L_B59D	equb $10,$00,$00,$00,$00,$00,$00,$80,$90
.L_B5A6 equb $00,$01,$02,$03
		equb $04,$05,$06,$07,$08,$09,$0A,$0B
.L_B5B2	equb $1B,$80,$1C,$80,$1D,$80,$1E,$80
		equb $1F,$80,$20,$80,$A1,$80,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00
.L_B5CA	equb $4E,$1D,$DB,$0A,$A8,$36,$34,$22,$00
.L_B5D3 equb $00,$00,$9B,$20,$19,$E0,$18
		equb $A0,$17,$60,$16,$20,$14,$E0,$13,$A0,$12,$60,$11,$20,$0F,$E0,$0E
		equb $A0
.L_B5EB	equb $48,$27,$26,$35,$44,$63,$13,$42,$71,$21,$50,$00
.L_B5F7 equb $13,$03,$62
		equb $42,$22,$02,$51,$21,$E0,$80
.L_B601	equb $05,$05,$85,$00,$00,$85,$05,$05,$05
.L_B60A	equb $32,$22,$02,$61,$41,$21,$70,$40,$A0,$80
.L_B614 equb $00,$40,$01,$41,$02,$42
		equb $03,$33,$63
.L_B61D	equb $00,$20,$30,$30,$30,$30,$30,$30,$30,$30
.L_B627 equb $30,$10,$00
		equb $00,$00,$00,$00,$00,$00,$00
.L_B631	equb $00,$00,$00,$00,$00,$00,$00,$90,$B0
.L_B63A	equb $30,$30,$30,$30,$30,$30,$30,$A0,$80
.L_B643 equb $00,$00,$00,$00,$00,$00,$00
		equb $00,$90,$B0
.L_B64D	equb $30,$30,$30,$30,$30,$30,$30,$30,$A0,$80
.L_B657 equb $00,$21,$42
		equb $53,$E4,$65,$E6,$57,$48
.L_B660	equb $00,$60,$41,$92,$62,$A3,$63,$14,$44
.L_B669 equb $00
		equb $20,$40,$D0,$60,$60,$D0,$40,$20
.L_B672	equb $04,$63,$B3,$03,$42,$82,$31,$60
		equb $00
.L_B67B	equb $A6,$80,$00,$00,$00,$00,$00,$80,$35
.L_B684 equb $47,$87,$46,$75,$25,$44
		equb $63,$03,$22,$41,$60,$00
.L_B690	equb $08,$27,$36,$C5,$44,$43,$32,$21,$00
.L_B699	equb $50
		equb $50,$50,$50,$C0,$30,$20,$10,$00
.L_B6A2	equb $00,$00,$10,$30,$60,$11,$51,$22
		equb $72
.L_B6AB	equb $00,$60,$41,$A2,$D2,$62,$F2,$72,$72,$72,$72,$72
.L_B6B7 equb $22,$B2,$32
		equb $A2,$12,$F1,$31,$60,$00
.L_B6C0	equb $0A,$68,$47,$26,$05,$63,$42,$21,$00
.L_B6C9 equb $00
		equb $10,$30,$60,$21,$71,$42,$13,$63,$34,$05,$55
.L_B6D5	equb $55,$26,$76,$47,$18
		equb $68,$39,$8A,$00,$00,$00,$00
.L_B6E1	equb $00,$C7,$76,$26,$55,$05,$34,$63,$13
		equb $42,$71,$21
.L_B6ED	equb $21,$60,$30,$10,$00,$00,$00,$00,$00,$00,$00,$00
.L_B6F9 equb $8A
		equb $80,$00,$00,$00,$00,$00,$80,$4C
.L_B702	equb $00,$41,$03,$44,$06,$47,$09,$4A
		equb $0C
.L_B70B	equb $70,$50,$30,$10,$00,$10,$30,$50,$70
.L_B714 equb $AA,$00,$00,$00,$00,$00 ; Amiga = $aa,$80...
		equb $00,$80,$2A
.L_B71D	equb $59,$49,$39,$A9,$63,$63,$63,$63,$47
.L_B726 equb $00,$00,$00,$10
		equb $30,$50,$01,$31,$71,$42,$23,$14
.L_B732	equb $62,$62,$62,$D2,$42,$A2,$02,$61
		equb $B1,$01,$40,$00
.L_B73E	equb $00,$40,$01,$41,$02,$42,$03,$43,$04,$64,$45,$26
		equb $07,$67
.L_B74C	equb $00,$10,$20,$30,$40,$40,$40,$40,$40,$40
.L_B756 equb $00,$00,$00,$00
		equb $00,$10,$30,$60,$21
.L_B75F	equb $8D,$80,$00,$00,$00,$00,$00,$00,$00
.L_B768 equb $00,$00
		equb $00,$00,$80,$00,$9C,$80,$1C,$80,$9C,$80,$80,$00,$00,$00,$00,$00
.L_B77A	equb $00,$00,$10,$20,$40,$60,$01,$31,$71
.L_B783 equb $00,$10,$30,$70,$31,$71,$B2
		equb $52,$62
.L_B78C	equb $00,$00,$00,$10,$30,$60,$21,$02,$03
.L_B795 equb $00,$10,$30,$60,$21
		equb $71,$62,$53,$44
.L_B79E	equb $00,$70,$61,$52,$43,$34,$25,$16,$07
.L_B7A7 equb $00,$00,$00
		equb $00,$00,$00,$00,$80,$2E
.L_B7B0	equb $00,$01,$F1,$52,$A3,$63,$94,$34,$54
.L_B7B9 equb $00
		equb $30,$D0,$70,$11,$A1,$31,$41,$41,$41
.L_B7C3	equb $40,$10,$00,$00,$00,$10,$40
		equb $11,$61
.L_B7CC	equb $40,$40,$40,$40,$40,$40,$30,$20,$10,$00
.L_B7D6	equb $9A,$C0,$80,$00
		equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$0C,$80
.L_B7E8	equb $24,$03
		equb $02,$21,$60,$30,$10,$00,$00
.L_B7F1	equb $47,$46,$65,$25,$05,$05,$15,$35,$75
.L_B7FA	equb $80,$E6,$16,$45,$74,$24,$53,$23,$13
.L_B803 equb $46,$25,$14,$13,$22,$41,$70
		equb $30,$00
.L_B80C	equb $00,$01,$12,$33,$54,$75,$17,$38,$59,$7A
.L_B816 equb $02,$71,$D1,$21
		equb $60,$30,$10,$00,$00
.L_B81F	equb $00,$00,$10,$30,$60,$21,$D1,$71,$02
.L_B828 equb $00,$40
		equb $81,$31,$D1,$61,$F1,$71,$71
.L_B831	equb $22,$61,$21,$60,$30,$10,$00,$00,$00
.L_B83A	equb $00,$60,$41,$22,$03,$63,$44,$25,$06,$66,$47,$28
.L_B846 equb $00,$00,$10,$30
		equb $60,$21,$71,$52,$43
.L_B84F	equb $24,$45,$E6,$80,$21,$42,$63,$05,$26
.L_B858 equb $28,$60
		equb $27,$C0,$27,$40,$26,$E0,$26,$A0,$26,$80,$26,$80,$26,$A0,$26,$E0
		equb $27,$20,$A7,$60,$00,$00
.L_B870	equb $00,$01,$02,$03,$04,$05,$06,$07,$08,$68
		equb $49,$2A,$0B,$6B
.L_B87E	equb $00,$70,$51,$32,$13,$73,$54,$35,$06
.L_B887 equb $00,$50,$31
		equb $12,$72,$53,$34,$15,$06
.L_B890	equb $00,$60,$41,$22,$03,$73,$64,$65,$66,$67
		equb $68,$69,$6A,$6B
.L_B89E	equb $00,$60,$41,$22,$03,$53,$24,$64,$25,$65,$26,$66
		equb $27,$67
.L_B8AC	equb $00,$81,$61,$A2,$42,$52,$52,$52,$52
.L_B8B5 equb $00,$41,$72,$14,$35
		equb $56,$77,$19,$3A,$5B
.L_B8BF	equb $00,$21,$42,$63,$05,$26,$47,$68,$1A,$5B
.L_B8C9 equb $64
		equb $14,$43,$72,$22,$51,$01,$40,$20,$10,$00,$00
.L_B8D5	equb $05,$05,$05,$15,$25
		equb $45,$E5,$00,$00
.L_B8DE	equb $22,$12,$F1,$51,$31,$11,$60,$30,$00
.L_B8E7 equb $00,$50,$31
		equb $22,$23,$34,$55,$76,$18
.L_B8F0	equb $00,$21,$42,$63,$05,$26,$47,$68,$79,$7A
.L_B8FA	equb $52,$71,$21,$60,$30,$10,$00,$00,$00
.L_B903 equb $00,$00,$00,$20,$00,$40,$00
		equb $60,$32,$00,$00,$60,$00,$40,$00,$20,$00,$00
.L_B915	equb $00,$00,$00,$20,$00
		equb $40,$00,$60,$32,$00,$00,$60,$00,$40,$00,$20,$00,$00
.L_B927	equb $00,$00,$00
		equb $20,$00,$40,$00,$60,$32,$00,$00,$60,$00,$40,$00,$20,$00,$00
.L_B939	equb $00
		equb $00,$00,$20,$00,$40,$00,$60,$32,$00,$00,$60,$00,$40,$00,$20,$00
		equb $00
.L_B94B	equb $63,$43,$A3,$F2,$42,$02,$41,$01,$40
.L_B954 equb $28,$47,$66,$06,$25,$44
		equb $63,$03,$22,$41,$60,$00
.L_B960	equb $14,$73,$43,$03,$42,$02,$41,$01,$40,$00
.L_B96A	equb $74,$14,$43,$03,$42,$02,$41,$01,$40,$00
.L_B974 equb $14,$53,$13,$52,$12,$51
		equb $11,$50,$A0,$80
.L_B97E	equb $74,$34,$73,$33,$72,$32,$71,$31,$E0,$80
.L_B988	equb $23,$62
		equb $22,$61,$21,$70,$40,$20,$00
.L_B991	equb $42,$42,$52,$72,$13,$43,$F3,$00,$00 ; Amiga = ...$f3,$80,$00
.L_B99A equb $00,$00,$00,$00,$85,$05,$05,$05,$05 ; Amiga = $00,$00,$00,$80...
.L_B9A3 equb $0C,$59,$47,$55,$04,$52,$41
		equb $50,$00
.L_B9AC	equb $00,$10,$30,$50,$E0,$50,$30,$10,$00
.L_B9B5 equb $00,$00,$00,$00,$80
		equb $00,$00,$00,$00
.L_B9BE	equb $04,$04,$04,$04,$04,$04,$73,$E3,$33,$52,$41,$00
.L_B9CA	equb $44,$04,$43,$03,$42,$02,$41,$01,$40,$00
.L_B9D4 equb $41,$41,$41,$41,$41,$41
		equb $31,$A1,$01,$E0,$30,$00
.L_B9E0	equb $18,$C0,$16,$80,$14,$40,$12,$00,$0F,$C0
		equb $0D,$80,$0B,$40,$09,$00,$06,$C0,$04,$80,$02,$40,$00,$00
.L_B9F8	equb $7E,$4C
		equb $1A,$08,$16,$44,$13,$02,$11,$40,$10,$00
.L_BA04	equb $60,$30,$10,$00,$00,$10
		equb $30,$60,$21
.L_BA0D	equb $13,$00,$10,$A0,$0E,$40,$0B,$E0,$09,$80,$07,$20,$04
		equb $C0,$02,$60,$00,$00
.L_BA1F	equb $00,$E8,$18,$47,$76,$26,$55,$05,$34
.L_BA28 equb $00,$00
		equb $00,$10,$30,$60,$21,$71,$42
.L_BA31	equb $00,$21,$42,$63,$05,$26,$47,$68,$0A
.L_BA3A	equb $00,$60,$31,$71,$32,$72,$33,$73,$34,$74
.L_BA44 equb $00,$20,$50,$11,$51,$12
		equb $52,$13,$53,$14
.L_BA4E	equb $00,$40,$01,$41,$02,$42,$03,$43,$94,$F4
.L_BA58 equb $00,$40
		equb $01,$41,$02,$42,$03,$43,$F3,$94

IF _JUST_ONE_TRACK_FOR_SAVING_RAM
.stepping_stones_data
.hump_back_data
.big_ramp_data
.ski_jump_data
.draw_bridge_data
.high_jump_data
.roller_coaster_data
ENDIF

.little_ramp_data		; L_BA62
		equb $2C		; number.of.road.sections
		equb $0F		; players.start.section
		equb $0F		; near.start.line.section
		equb $25		; half.a.lap.section
		equb $00,$05,$A0,$CF
		equb $6A,$9F,$6B,$24,$50,$50,$25,$00,$00,$19,$63,$80,$2F,$04,$64,$86
		equb $1F,$65,$66,$57,$0E,$68,$67,$C0,$0D,$64,$04,$E0,$0C,$69,$9F,$17
		equb $00,$00,$00,$00,$00,$00,$00,$00,$CC,$02,$C6,$01,$16,$17,$B7,$10
		equb $00,$01,$20,$19,$18,$94,$31,$04,$03,$2A,$42,$00,$2A,$53,$00,$2A
		equb $64,$00,$2A,$75,$28,$2A,$86,$29,$2A,$97,$00,$2A,$A8,$2A,$2A,$B9
		equb $2B,$2A,$CA,$00,$2A,$DB,$00,$04,$EC,$09,$0A,$D3,$FD,$16,$17,$66
		equb $FE,$00,$17,$EF,$1B,$1A,$8D,$DF,$06,$05,$22,$2F,$02,$02,$21,$46
		equb $03,$58,$01,$22

IF _JUST_ONE_TRACK_FOR_SAVING_RAM = FALSE
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
		equb $1A,$54,$1B,$4A,$4D,$52,$4C,$5A
ENDIF

; data after this point exists in Amiga source...
		equb $00,$00,$00,$00,$00,$00,$00,$00
		equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

;DAT.1fe2c
.L_BFAA	equb $07,$07,$07,$07,$07,$07,$07,$07
.L_BFB2	equb $41,$3A,$3E,$41,$48,$51,$48,$4F
.L_BFBA	equb $00,$00,$00,$00,$00,$00,$00,$00
.L_BFC2	equb $48,$41,$45,$48,$4F,$58,$4F,$56
		equb $07,$03,$03,$03,$03,$03,$07,$03
		equb $66,$57,$57,$59,$59,$69,$62,$64
		equb $07,$03,$03,$03,$03,$01,$03,$03
		equb $61,$55,$53,$56,$58,$5B,$5A,$62

;L_BFEA
.league_values
\* Standard league
		equb $48,$00
		equb $F0,$00	;			engine.power
		equb $EC,$00	;			opponents.engine.power
		equb $10		;			boost.unit.value
		equb $60,$5B
		equb $00		;			road.cushion.value
		equb $00
\* Super league
		equb $54,$0C
		equb $40,$01
		equb $3A,$01
		equb $0C
		equb $6E,$69
		equb $01
		equb $00

.file_strings
.file_strings_not
		equb " NOT",$FF
.file_strings_loaded
		equb " loaded",$FF
.file_strings_saved
		equb " saved",$FF
.file_strings_incorrect_data_found
		equb "Incorrect data found ",$FF
.file_strings_file_name_already_exists
		equb "File name already exists",$FF
.file_strings_problem_encountered
		equb "Problem encountered",$FF
.file_strings_file_name_is_not_suitable
		equb "File name is not suitable",$FF
.file_strings_insert_game_position_save
		equb $1F,$05,$13,"Insert game position save ",$FF
.file_strings_tape
		equb "tape",$FF
.file_strings_disc
		equb "disc",$FF
.file_string_file_name_maybe
		equb $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$FF

.L_9674	equb "DIRECTORY:"

.core_data_end
