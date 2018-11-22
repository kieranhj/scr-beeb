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

.L_C000	;skip &100
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

.L_C100	;skip &100
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

.L_C200 ;skip &18
;.L_75A0
		EQUB $7F,$7F,$7F,$7F,$BF,$AF,$2F,$5B,$FF,$FF,$FF,$FF,$FE,$FD,$F5,$E5
		EQUB $F9,$E9,$25,$AA,$92,$99,$59,$A9

.L_C218 ;skip &18
;.L_7608
		EQUB $65,$79,$98,$96,$E2,$E7,$E9,$F9,$FF,$FF,$FF,$FF,$7F,$5F,$5B,$12
		EQUB $FD,$FD,$FD,$FD,$FD,$F5,$FA,$EA

.L_C230 ;skip &18
;.L_7560
		EQUB $FF,$FF,$FF,$FF,$00,$00,$00,$00,$FF,$FF,$FE,$FC,$08,$00,$10,$10
		EQUB $FF,$59,$00,$00,$00,$00,$00,$00

.L_C248 ;skip &18
;.L_7648
		EQUB $FF,$65,$00,$00,$00,$00,$00,$00,$FF,$FF,$BF,$3F,$20,$04,$04,$04
		EQUB $FF,$FF,$FF,$FF,$00,$00,$00,$00

.L_C260 skip &20

\\ Manually moved from boot loader
.L_C280 ;skip &40
;.L_5780
		EQUB $BC,$BC,$BC,$BC,$BC,$BC,$BC,$BA,$B9,$B9,$B9,$B9,$B9,$B9,$B7,$B5
		EQUB $B4,$B4,$B4,$B4,$B4,$B2,$B1,$B0,$B0,$B0,$B0,$AE,$AD,$AD,$AD,$AD
		EQUB $AF,$BD,$BF,$C0,$C0,$BF,$BE,$BC,$B8,$B8,$B8,$B7,$B6,$B6,$B5,$B5
		EQUB $B2,$B1,$AF,$AC,$AB,$AB,$AB,$AB,$AB,$AB,$AB,$AC,$B4,$B4,$B4,$B1
.L_C2C0 ;skip &40
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

; *****************************************************************************
\\ Data moved from Cart RAM to Hazel
; *****************************************************************************

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

\\ FONT START at $80C0
.font_data equb $00,$00,$00,$00,$00,$00,$00,$00

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

\\
.file_strings_offset	equb $05,$0D,$43,$14,$2A,$43,$43,$43,$71,$8F,$94

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

.L_9674	equb "DIRECTORY:"

\\
.L_A1F2	equb $E8,$46,$4B,$53,$52,$46,$55,$48,$42,$45,$52,$44
.L_A1FE	equb $42
.L_A1FF	equb $49

PAGE_ALIGN

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

.hazel_end
