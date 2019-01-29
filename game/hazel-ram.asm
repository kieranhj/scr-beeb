; *****************************************************************************
; HAZEL RAM: $C000 - $D000
; $C700 = Maths routines
; ...
; $CD00 = IRQ handler
; $CE00 = Sprite code
; $CF00 = Raster interrupts
; *****************************************************************************

; Engine screen data (copied at boot time from elsewhere)

.L_C000
;.L_72E0
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FD,$FD,$FF,$FF,$FF,$FF,$FF,$55,$02,$00
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FD,$FD,$FD,$F4,$FF,$FF,$FF,$55,$00,$55,$00,$00
		EQUB $FF,$FF,$FF,$57,$01,$55,$05,$01,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$D5,$40,$55,$50,$80
		EQUB $FF,$FF,$FF,$55,$00,$55,$00,$00,$FF,$FF,$FF,$FF,$7F,$5F,$5F,$07
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD
		EQUB $FF,$FF,$FF,$FF,$FF,$55,$80,$00,$FF,$FF,$FF,$FF,$FF,$FF,$7F,$7F
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

.L_C100
;.L_7420
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$FC,$F4
		EQUB $FF,$FF,$FF,$FF,$69,$00,$00,$00,$FD,$F4,$D0,$C0,$50,$18,$08,$02
		EQUB $54,$06,$02,$00,$00,$00,$00,$00,$00,$00,$00,$80,$82,$99,$85,$85
		EQUB $7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$FF,$FF,$FF,$FF,$FF,$F9,$A5,$94
		EQUB $F5,$D4,$40,$50,$55,$55,$40,$00,$AA,$00,$00,$00,$AA,$55,$00,$00
		EQUB $AA,$29,$02,$0A,$A9,$63,$28,$0B,$FF,$FC,$FC,$FC,$54,$A8,$00,$54
		EQUB $FF,$7F,$7F,$7F,$55,$40,$40,$55,$AA,$68,$40,$60,$EA,$C2,$28,$E0
		EQUB $AA,$00,$00,$00,$AA,$55,$00,$00,$57,$15,$01,$05,$55,$56,$00,$00
		EQUB $FF,$FF,$FF,$FF,$FF,$67,$59,$16,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$7F
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD
		EQUB $00,$00,$00,$82,$82,$66,$52,$92,$15,$90,$80,$00,$00,$00,$00,$80
		EQUB $7F,$1F,$07,$03,$05,$24,$20,$80,$FF,$FF,$FF,$FF,$55,$00,$00,$00
		EQUB $FF,$FF,$FF,$FF,$FF,$7F,$3F,$1F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
		EQUB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

.L_C200
;.L_75A0
		EQUB $7F,$7F,$7F,$7F,$BF,$AF,$2F,$5B,$FF,$FF,$FF,$FF,$FE,$FD,$F5,$E5
		EQUB $F9,$E9,$25,$AA,$92,$99,$59,$A9

.L_C218
;.L_7608
		EQUB $65,$79,$98,$96,$E2,$E7,$E9,$F9,$FF,$FF,$FF,$FF,$7F,$5F,$5B,$12
		EQUB $FD,$FD,$FD,$FD,$FD,$F5,$FA,$EA

.L_C230
;.L_7560
		EQUB $FF,$FF,$FF,$FF,$00,$00,$00,$00,$FF,$FF,$FE,$FC,$08,$00,$10,$10
		EQUB $FF,$59,$00,$00,$00,$00,$00,$00

.L_C248
;.L_7648
		EQUB $FF,$65,$00,$00,$00,$00,$00,$00,$FF,$FF,$BF,$3F,$20,$04,$04,$04
		EQUB $FF,$FF,$FF,$FF,$00,$00,$00,$00

.L_C260 skip &20

\\ Manually moved from boot loader
.L_C280
;.L_5780
		EQUB $BC,$BC,$BC,$BC,$BC,$BC,$BC,$BA,$B9,$B9,$B9,$B9,$B9,$B9,$B7,$B5
		EQUB $B4,$B4,$B4,$B4,$B4,$B2,$B1,$B0,$B0,$B0,$B0,$AE,$AD,$AD,$AD,$AD
		EQUB $AF,$BD,$BF,$C0,$C0,$BF,$BE,$BC,$B8,$B8,$B8,$B7,$B6,$B6,$B5,$B5
		EQUB $B2,$B1,$AF,$AC,$AB,$AB,$AB,$AB,$AB,$AB,$AB,$AC,$B4,$B4,$B4,$B1
.L_C2C0
		EQUB $B1,$B4,$B4,$B4,$AC,$AB,$AB,$AB,$AB,$AB,$AB,$AB,$AC,$AD,$AF,$B1
		EQUB $B5,$B5,$B5,$B6,$B7,$B8,$B8,$B8,$BC,$BD,$BE,$BF,$C0,$BF,$BD,$AF
		EQUB $AD,$AD,$AD,$AD,$AE,$B0,$B0,$B0,$B0,$B1,$B2,$B4,$B4,$B4,$B4,$B4
		EQUB $B5,$B7,$B9,$B9,$B9,$B9,$B9,$B9,$BA,$BC,$BC,$BC,$BC,$BC,$BC,$BC

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
.track_preview_rotation	skip 1			; rotation angle of track preview
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
.screen_buffer_current	skip 1
.L_C360	skip 1
.L_C361	skip 1
.L_C362	skip 2
.L_C364	skip 1
.L_C365	skip 1
.L_C366	skip 1
.L_C367	skip 1
.L_C368	skip 1		; Crash Timer
.L_C369	skip 1
.L_C36A	skip 1					; distance_to_aicar_in_segments
.L_C36B	skip 1
.L_C36C	skip 1
.L_C36D	skip 1
.L_C36E	skip 1
.L_C36F	skip 1
.screen_buffer_next_vsync	skip 1
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
.line_colour	skip 2
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
.write_char_pixel_offset	skip 1
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
.L_C600	skip &40
.L_C640	skip &40
.L_C680	skip &40
.L_C6C0	skip &40	; stash $B bytes from $DAB6

.hazel_start

.L_C700	equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.L_C70B	equb $00
.L_C70C	equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.L_C718	equb $00

; L_C719 tracks number of damage holes somehow.
.L_C719	equb $00
.L_C71A	equb $00,$00
.L_C71C	equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; Player times?

; Fandal says "number of races won for multiplayer (12 byte)"
.L_C728	equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; Fandal says "number of laps won for multiplayer (12 byte)"
.L_C734	equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; Fandal says "number of races for multiplayer (12 byte)"
.L_C740	equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.L_C74B	equb $00

; Fandal says "automatically updated by speed and laps"?
.L_C74C	equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

.L_C758	equb $00
.L_C759	equb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00

.L_C763	equb $00
.number_of_road_sections	equb $00
.players_start_section	equb $00
.near_start_line_section	equb $00
.half_a_lap_section	equb $00
.total_road_distance	equw $00
.boost_reserve	equb $00
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
.current_track	equb $00
.L_C77E	equb $00
.L_C77F	equb $00
.L_C780	equb $00,$40

skip &7C
.L_A1FE	equb $42
.L_A1FF	equb $49

; *****************************************************************************
\\ Data moved from Cart RAM to Hazel
; *****************************************************************************

\\ Suspect these are transformed vertices somehow?
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

\\ Suspect these are transformed vertices somehow, perhaps in screen space?

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

;L_A400
.color_ram_ptrs_LO
		equb $00,$00,$00,$00,$00,$00,$04,$2C,$54,$7C,$A4,$CC,$F4,$1C,$44,$6C
		equb $94,$BC,$E4,$0C,$34,$5C,$84,$AC

; HI pointers to C64 COLOR RAM?

;L_A418
.color_ram_ptrs_HI
		equb $D8,$D8,$D8,$D8,$D8,$D8,$D8,$D8,$D8,$D8,$D8,$D8,$D8,$D9,$D9,$D9
		equb $D9,$D9,$D9,$DA,$DA,$DA,$DA,$DA

		equb $85,$33,$A5,$31,$85,$32,$A9,$00
		equb $85,$31,$F0,$D0,$46,$31,$66,$32

;L_A440 = color_ram_ptrs_LO + $40

.pixel_masks_1
	\\ Pixel masks %00 11 11 11, %11 00 11 11, %11 11 00 11, %11 11 11 00
IF 1
		equb &77,&BB,&DD,&EE,&77,&BB,&DD,&EE,&77,&BB,&DD,&EE,&77,&BB,&DD,&EE
		equb &77,&BB,&DD,&EE,&77,&BB,&DD,&EE,&77,&BB,&DD,&EE,&77,&BB,&DD,&EE
		equb &77,&BB,&DD,&EE,&77,&BB,&DD,&EE,&77,&BB,&DD,&EE,&77,&BB,&DD,&EE
		equb &77,&BB,&DD,&EE,&77,&BB,&DD,&EE,&77,&BB,&DD,&EE,&77,&BB,&DD,&EE
		equb &77,&BB,&DD,&EE,&77,&BB,&DD,&EE,&77,&BB,&DD,&EE,&77,&BB,&DD,&EE
		equb &77,&BB,&DD,&EE,&77,&BB,&DD,&EE,&77,&BB,&DD,&EE,&77,&BB,&DD,&EE
		equb &77,&BB,&DD,&EE,&77,&BB,&DD,&EE,&77,&BB,&DD,&EE,&77,&BB,&DD,&EE
		equb &77,&BB,&DD,&EE,&77,&BB,&DD,&EE,&77,&BB,&DD,&EE,&77,&BB,&DD,&EE
ELSE
		equb $3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC
		equb $3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC
		equb $3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC
		equb $3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC
		equb $3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC
		equb $3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC
		equb $3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC
		equb $3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC
ENDIF
	\\ Pixel masks %01 11 11 11, %11 01 11 11, %11 11 01 11, %11 11 11 01

; L_A4C0
.pixel_masks_2
		EQUB &7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF
		EQUB &7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF
		EQUB &7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF
		EQUB &7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF

; $A500 LO pointers?

.Q_pointers_LO
		EQUB &7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF
		EQUB &7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF
		EQUB &7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF
		EQUB &7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF,&7F,&BF,&DF,&EF

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

\ Doesn't look like this data is looked up beyond 8 bytes?
.L_A610	equb $E0,$E4,$E8,$EC,$F0,$F4,$F8,$FC,$E0,$E4,$E8,$EC,$F0,$F4,$F8,$FC

\ Doesn't look like this data is looked up beyond 32 bytes?
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

; L_A700
.cosine_table
		equb $FF
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

; L_A800
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

; L_A900
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

.hazel_end

ORG &D000
._L_D000:skip 256
._L_D100:skip 256
._L_D200:skip 256
._L_D300:skip 256
._L_D400:skip 256
._L_D500:skip 256
._L_D600:skip 256
._L_D700:skip 256
._L_D800:skip 256
._L_D900:skip 256
.L_DA00
;L_5500
		EQUB $CF,$EF,$EF,$EF,$EF,$EF,$AF,$9F,$9F,$F9,$6F,$9F,$EF,$EF,$EF,$EF
		EQUB $EF,$EF,$EF,$F1,$F1,$F1,$F1,$F1,$E1,$E1,$91,$91,$91,$91,$91,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$91,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$E1,$91,$91,$97,$87,$98,$9F,$F9,$F9,$F9
		EQUB $E1,$E1,$E9,$98,$91,$91,$91,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$91
;L_5560
		EQUB $91,$97,$87,$98,$97,$89,$97,$97,$05,$05,$05,$05,$05,$05,$05,$05
		EQUB $05,$05,$05,$05,$05,$05,$05,$05
;L_5578
		EQUB $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
		EQUB $05,$05,$05,$05,$05,$05,$0C,$05,$05,$05,$05,$05,$05,$05,$05,$05
		EQUB $05,$05,$05,$05,$05,$05,$05,$05
;L_55A0
		EQUB $05,$05,$05,$05,$05,$05,$05,$0F,$0F,$05,$05,$05,$05,$05,$05,$05
		EQUB $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
		EQUB $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$09,$05,$0C
		EQUB $02,$05,$0F,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$0C,$05,$05
		EQUB $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$06
		EQUB $0F,$02,$0A,$0A,$02,$06,$0F,$06,$0C,$09,$09,$05,$05,$05,$05,$05

.L_DB00
;L_5600
		EQUB $05,$05,$05,$05,$0C,$05,$05,$05
;L_5608
		EQUB $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$0C
		EQUB $02,$05,$05,$05,$02,$05,$0F,$09,$06,$09,$0F,$09,$05,$05,$05,$05
		EQUB $05,$05,$05,$0C,$0C,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
		EQUB $05,$05,$05,$05,$05,$05,$05,$06
;L_5640
		EQUB $06,$02,$05,$05,$05,$06,$06,$05
;L_5648
		EQUB $05,$05,$05,$0A,$06,$05,$05,$05,$05,$05,$0C,$05,$05,$05,$05,$05
;L_5658
		EQUB $05,$05,$05,$05,$05,$05,$05,$09,$09,$09,$09,$09,$09,$09,$09,$09
		EQUB $09,$09,$09,$09,$09,$05,$09,$09,$09,$09,$09,$09,$09,$09,$09,$05
		EQUB $05,$05,$09,$0F,$07,$08,$07,$05,$05,$05,$08,$0F,$05,$05,$05,$09
		EQUB $09,$09,$09,$09,$09,$09,$09,$09
;L_5690
		EQUB $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$05
;L_56A0
		EQUB $05,$05,$05,$05,$05,$05,$05,$05,$00,$00,$00,$00,$00,$00,$00,$00
		EQUB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		EQUB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		EQUB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		EQUB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		EQUB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

.L_DC00
;L_AE00
		EQUB $20
;L_AE01
		EQUB $48,$6F,$74,$20,$52,$6F,$64,$20,$20,$20,$20,$20,$20,$B1,$8B,$20
		EQUB $57,$68,$69,$7A,$7A,$20,$4B,$69,$64,$20,$20,$20,$20,$F0,$36,$20
		EQUB $42,$61,$64,$20,$47,$75,$79,$20,$20,$20,$20,$20,$20,$14,$60,$20
		EQUB $54,$68,$65,$20,$44,$6F,$64,$67,$65,$72,$20,$20,$20,$41,$04
;L_AE40
		EQUB $20,$42,$69,$67,$20,$45,$64,$20,$20,$20,$20,$20,$20,$20,$61,$72
		EQUB $20,$4D,$61,$78,$20,$42,$6F,$6F,$73,$74,$20,$20,$20,$20,$02,$A8
		EQUB $20,$44,$61,$72,$65,$20,$44,$65,$76,$69,$6C,$20,$20,$20,$00,$86
		EQUB $20,$48,$69,$67,$68,$20,$46,$6C,$79,$65,$72,$20,$20,$20,$23,$C9
		EQUB $20,$42,$75,$6C,$6C,$79,$20,$42,$6F,$79,$20,$20,$20,$20,$0A,$0A
		EQUB $20,$4A,$75,$6D,$70,$69,$6E,$67,$20,$4A,$61,$63,$6B,$20,$F4,$C8
		EQUB $20,$52,$6F,$61,$64,$20,$48,$6F,$67,$20,$20,$20,$20,$20,$64,$20
		EQUB $20
;L_AEB1
		EQUB $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$40,$60,$A9
;L_AEC1	
		EQUB $00,$A4,$18,$4C,$EA,$AE,$4C,$43,$AE,$A9,$00,$F0,$0A,$4C,$0E,$8C
		EQUB $20,$EC,$AD,$D0,$F8,$A5,$36,$A0,$00,$F0,$0E,$A4,$1B,$B1,$19
;opponent_attributes
.L_DCE0	
		EQUB $22,$20,$62,$20,$3E,$04,$30,$14,$4A,$10,$08,$00,$84,$2B,$A9,$00
		EQUB $85,$2C,$85,$2D,$A9,$40,$60,$A5,$1E,$4C,$D8,$AE,$A5,$00,$A4,$01

.L_DD00
;L_7B00
		EQUB $00,$00,$10,$20,$20,$20,$55,$55,$00,$00,$00,$00,$82,$82,$55,$55
		EQUB $00,$00,$04,$08,$08,$08,$55,$55,$00,$00,$00,$00,$20,$20,$54,$54
		EQUB $00,$00,$55,$55,$15,$15,$15,$15,$2A,$00,$40,$55,$55,$55,$55,$55
		EQUB $AA,$2A,$00,$40,$55,$55,$55,$55,$AA,$AA,$2A,$00,$40,$55,$55,$55
		EQUB $55,$55,$55,$15,$00,$80,$AA,$AA,$55,$55,$55,$55,$55,$00,$80,$AA
		EQUB $AA,$55,$55,$55,$55,$55,$00,$C0,$AA,$AA,$55,$55,$55,$55,$55,$00
		EQUB $55,$55,$55,$A9,$A9,$A9,$A9,$A1,$5A,$5A,$5A,$5A,$5A,$5A,$5A,$5A
		EQUB $29,$29,$29,$29,$29,$29,$29,$29,$55,$55,$55,$55,$55,$55,$55,$55
		EQUB $55,$55,$55,$55,$56,$56,$56,$56,$54,$54,$54,$54,$54,$54,$54,$54
		EQUB $A5,$A5,$A5,$A5,$A5,$A5,$A5,$A5,$40,$50,$50,$50,$50,$58,$58,$58
		EQUB $00,$00,$01,$05,$05,$05,$05,$05,$00,$00,$55,$55,$55,$55,$55,$55
		EQUB $00,$00,$55,$55,$55,$55,$55,$55,$00,$00,$55,$55,$55,$55,$55,$55
		EQUB $00,$00,$55,$55,$55,$55,$55,$55,$00,$00,$55,$55,$55,$55,$55,$55
		EQUB $00,$00,$50,$54,$54,$54,$54,$54,$56,$16,$16,$16,$16,$16,$16,$16
		EQUB $00,$00,$00,$01,$01,$01,$00,$01,$40,$40,$00,$50,$00,$50,$10,$50
		EQUB $00,$00,$00,$00,$00,$00,$00,$00,$10,$10,$00,$54,$44,$54,$44,$54
