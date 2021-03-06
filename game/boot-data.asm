; *****************************************************************************
; SCREEN 2 RAM: $6000 - $8000
; Ensure this is all set up as per C64 before boot
; *****************************************************************************

.boot_data_start

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
;L_7B00=L_6000+$1B00
;L_7C00=L_6000+$1C00
;L_7C53=L_6000+$1C53
;L_7C74=L_6000+$1C74
;L_7D00=L_6000+$1D00
;L_7E00=L_6000+$1E00
;L_7F00=L_6000+$1F00

; end of in-game screen data.

.boot_data_end
