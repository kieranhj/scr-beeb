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

; *****************************************************************************
\\ Data moved from Cart RAM to Hazel
; *****************************************************************************

PAGE_ALIGN

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

; *****************************************************************************
\\ Data moved from Kernel RAM to Hazel
; *****************************************************************************

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

.hazel_end
