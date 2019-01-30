; *****************************************************************************
; SCREEN 2 RAM: $6000 - $8000
; Ensure this is all set up as per C64 before boot
; *****************************************************************************

.boot_data_start

\\ Page $5C00 believed to be screen RAM

.vic_screen_mem_page0
		EQUB $E1,$E1,$B1,$B1,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2
		EQUB $B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2
		EQUB $B2,$B2,$B2,$B2,$B2,$B1
.L_5C26	EQUB $E1,$E1,$E1,$E1,$B1,$2B,$21,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A
		EQUB $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A
		EQUB $2A,$2A,$2A,$2A,$2A,$21,$2A,$B2
.L_5C4E	EQUB $E1,$E1,$E1,$E1,$B2,$A1,$E2,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E2,$A1,$B2
.L_5C76	EQUB $E1,$E1,$E1,$E1,$2B,$2A,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$2A,$2B
.L_5C9E	EQUB $E1,$E1,$E1,$E1,$2B,$2A,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$2A,$2B
.L_5CC6	EQUB $E1,$E1,$E1,$E1,$2B,$2A,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$2A,$2B
.L_5CEE	EQUB $E1,$E1,$E1,$E1,$2B,$2A,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1

\\ Page $5D00

.vic_screen_mem_page1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$2A,$2B
.L_5D16	EQUB $E1,$E1,$E1,$E1,$2B,$2A,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$2A,$2B
.L_5D3E	EQUB $E1,$E1,$E1,$E1,$2B,$2A,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$2A,$2B,$E1,$E1,$E1,$E1,$2B,$2A,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$2A,$2B
		EQUB $E1,$E1,$E1,$B1,$2B,$A2,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$A2,$2B,$B1,$E1,$B1,$B2,$A2,$21,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$21,$A2
		EQUB $B2,$B1,$B2,$2A,$A2,$A2,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1

\\ Page $5E00

.vic_screen_mem_page2
		EQUB $E1,$E1,$E1,$E1,$A2,$A2,$2A,$B2,$2A,$A2,$B2,$2A,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$2A,$B2,$A2,$2A
		EQUB $A2,$2B,$2B,$2A,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$E1,$E1,$2A,$2B,$2B,$A2,$2A,$6B,$2B,$2A,$E1,$E1,$E1,$E1
		EQUB $E1,$E1,$31,$31,$31,$E1,$E1,$E1,$31,$31,$31,$E1,$E1,$31,$31,$31
		EQUB $E1,$E1,$E1,$31,$31,$31,$E1,$E1,$E1,$E1,$E1,$E1,$2A,$2B,$6B,$2A
		EQUB $E2,$E6,$2B,$2A,$E1,$E1,$E1,$31,$31,$31,$31,$31,$31,$E1,$D1,$3D
		EQUB $31,$31,$31,$C1,$31,$31,$31,$31,$3D,$D1,$E1,$31,$31,$31,$31,$31
		EQUB $31,$E1,$E1,$E1,$2A,$2B,$E6,$E2,$EB,$E6,$2B,$2A
.L_5EAC	EQUB $E1,$31,$31,$31,$31,$31,$31,$31,$31,$D1,$D1,$D1,$31,$31,$31,$31
		EQUB $C1,$C1,$31,$31,$D1,$C1,$D1,$31,$31,$31,$31,$31,$31,$31,$31
.L_5ECB	EQUB $E1,$2A,$2B,$E6,$EB,$E1,$E6,$2B,$2A
.L_5ED4	EQUB $E1,$31,$E1,$31,$31,$31,$31,$31,$31,$D1,$D1,$C1,$31,$31,$C1,$31
		EQUB $C1,$C1,$31,$31,$C1,$D1,$D1,$31,$31,$31,$31,$31,$31,$E1,$31
.L_5EF3	EQUB $E1,$2A,$2B,$E6,$E1,$E1,$E6,$2B,$2A
.L_5EFC	EQUB $21,$23,$21,$32

\\ Page $5F00

.vic_screen_mem_page3
		EQUB $A1,$A2,$A1,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A
		EQUB $2A,$2A,$2A,$2A,$2A,$A1,$A1,$A2,$A2,$21,$32
.L_5F1B	EQUB $21,$2A,$2B,$E6,$E1,$E1,$E6,$2B,$A2,$A2,$A2,$2A,$2A,$2B,$2B,$B2
		EQUB $B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2,$B2
		EQUB $B2,$B2,$B2,$2B,$2B,$2A,$2A,$A2,$A2,$A2,$2B,$E6,$E1,$E1,$E6,$2B
		EQUB $2B,$B2,$B2,$B6,$B6,$6B,$6B,$6B,$E6,$E3,$E3,$E3,$E3,$E3,$E3,$E3
		EQUB $E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$E3,$61,$6B,$6B,$6B,$B6,$B6,$B2
		EQUB $B2,$2B,$2B,$E6,$E1,$E6,$61,$2B,$2B,$F1,$F1,$F1,$F1,$F1,$F1,$F1
		EQUB $63,$31,$31,$E1,$31,$E1,$31,$31,$31,$31,$31,$31,$31,$31,$31,$31
		EQUB $31,$E6,$F1,$F1,$F1,$F1,$F1,$F1,$F1,$2B,$2B,$61,$E6,$E6,$61,$2B
		EQUB $2B,$EF,$F1,$F1,$F1,$F1,$F1,$F1,$E6,$E6,$E6,$E6,$E6,$E6,$E1,$E1
		EQUB $F1,$F1,$EF,$E3,$E6,$E6,$E6,$E6,$E6,$E6,$F1,$F1,$F1,$F1,$F1,$F1
		EQUB $EF,$2B,$2B,$61,$E6,$6B,$6B,$2B,$AB,$E3,$EF,$EF,$EF,$EF,$EF,$EF
		EQUB $E6,$E3,$E3,$E6,$6F,$F1,$61,$61,$61,$6F,$61,$F6,$F1,$61,$E6,$E3
		EQUB $E3,$E6,$EF,$EF,$EF,$EF,$EF,$EF,$E3,$AB,$2B,$6B,$6B,$00,$00,$00
		EQUB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

; sprite pointers
.vic_sprite_ptr0	EQUB $00
.vic_sprite_ptr1	EQUB $00
.vic_sprite_ptr2	EQUB $00
.vic_sprite_ptr3	EQUB $00,$00
.vic_sprite_ptr5	EQUB $00,$00
.vic_sprite_ptr7	EQUB $00

\\ Gameplay HUD surround graphic

.L_6000
incbin "build/scr-beeb-hud.dat"

L_6026=L_6000+$026
L_6027=L_6000+$027
L_6028=L_6000+$028
L_62A0=L_6000+$2A0
;L_63E0=L_6000+$3E0
;L_6520=L_6000+$520
L_6660=L_6000+$660
;L_66E0=L_6000+$6E0
L_67A0=L_6000+$7A0
L_68E0=L_6000+$8E0
;L_6920=L_6000+$920
;L_6A20=L_6000+$A20
;L_6B60=L_6000+$B60
;L_6BA0=L_6000+$BA0
L_6CA0=L_6000+$CA0
;L_6D20=L_6000+$D20
;L_6D6A=L_6000+$D6A
;L_6DE0=L_6000+$DE0
L_6F20=L_6000+$F20
L_7060=L_6000+$1060
L_71A0=L_6000+$11A0
L_72E0=L_6000+$12E0
L_7420=L_6000+$1420
L_7560=L_6000+$1560
L_7578=L_6000+$1578
L_75A0=L_6000+$15A0
L_7608=L_6000+$1608
L_7640=L_6000+$1640
L_7648=L_6000+$1648
L_7658=L_6000+$1658
L_76A0=L_6000+$16A0
L_7798=L_6000+$1798
L_77E0=L_6000+$17E0
L_78D8=L_6000+$18D8
L_7AA6=L_6000+$1AA6
L_7AA7=L_6000+$1AA7
L_7B00=L_6000+$1B00
L_7C00=L_6000+$1C00
; L_7C53=L_6000+$1C53
; L_7C74=L_6000+$1C74
L_7D00=L_6000+$1D00
L_7E00=L_6000+$1E00
L_7F00=L_6000+$1F00

; end of in-game screen data.

  		skip 64					; previously some sprite data

; buffer for in-game text sprites.

.L_7F80

.boot_data_end
