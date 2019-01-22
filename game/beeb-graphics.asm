.beeb_graphics_start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "build/flames-tables.asm"

.menu_header_graphic_begin
incbin "build/scr-beeb-header.dat"
skip 2560						; book space for the Mode 1 version...
.menu_header_graphic_end

include "build/wheels-tables.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._graphics_erase_flames
{
clc
lda ZP_12
adc #HI(flames_initial_erase_addr)
sta erase_write+2

ldy #LO(flames_initial_erase_addr)
ldx #0

.erase_loop

.erase_read:lda flames_erase_values,x
.erase_write:sta $ff00,y

tya
adc flames_erase_deltas,x
tay
bcc erase_noc
inc erase_write+2
clc
.erase_noc

inx

cpx #flames_erase_writes_size
bne erase_loop

rts
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._graphics_draw_flames
{
asl A:tax

lda unmasked_tables+0,x:sta unmasked_read+1
lda unmasked_tables+1,x:sta unmasked_read+2

lda masked_masks_tables+0,x:sta masked_mask+1
lda masked_masks_tables+1,x:sta masked_mask+2

lda masked_values_tables+0,x:sta masked_value+1
lda masked_values_tables+1,x:sta masked_value+2

; unmasked

clc
lda ZP_12
adc #HI(flames_initial_unmasked_write_addr)
sta unmasked_write+2

ldy #LO(flames_initial_unmasked_write_addr)
ldx #0

.unmasked_loop

.unmasked_read:lda $ffff,x
.unmasked_write:sta $ff00,y

tya
adc flames_unmasked_deltas,x
tay
bcc unmasked_noc
inc unmasked_write+2
clc
.unmasked_noc

inx

cpx #flames_unmasked_writes_size
bne unmasked_loop

; masked

clc
lda ZP_12
adc #HI(flames_initial_masked_write_addr)
sta masked_read+2
sta masked_write+2

ldy #LO(flames_initial_masked_write_addr)
ldx #0

.masked_loop

.masked_read:lda $ff00,y
.masked_mask:and $ffff,x
.masked_value:ora $ffff,x
.masked_write:sta $ff00,y

tya
adc flames_masked_deltas,x
tay
bcc masked_noc
inc masked_read+2
inc masked_write+2
clc
.masked_noc

inx

cpx #flames_masked_writes_size
bne masked_loop

rts

.unmasked_tables
equw flames_unmasked_values_0
equw flames_unmasked_values_1
equw flames_unmasked_values_2

.masked_values_tables
equw flames_masked_values_0
equw flames_masked_values_1
equw flames_masked_values_2

.masked_masks_tables
equw flames_masked_masks_0
equw flames_masked_masks_1
equw flames_masked_masks_2
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._graphics_copy_menu_header_graphic
{

if (menu_header_graphic_end-menu_header_graphic_begin) mod 256<>0
error "oops"
endif

ldx #0
.loop
for i,0,(menu_header_graphic_end-menu_header_graphic_begin) div 256-1
lda menu_header_graphic_begin+i*256,x:sta $4000+i*256,x
next

inx
bne loop

rts
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MACRO REDRAW_ENGINE row0_addr,row1_addr,offset,masks,values

clc

lda #HI(row0_addr+offset):adc ZP_12:sta rd0+2:sta wr0+2

lda #HI(row1_addr+offset):adc ZP_12:sta rd1+2:sta wr1+2

ldx #23

.loop

.rd0:lda $ff00+LO(row0_addr+offset),x
and masks+0,x
ora values+0,x
.wr0:sta $ff00+LO(row0_addr+offset),x

.rd1:lda $ff00+LO(row1_addr+offset),x
and masks+24,x
ora values+24,x
.wr1:sta $ff00+LO(row1_addr+offset),x

; lda $77c0+offset,x
; and masks+48,x
; ora values+48,x
; sta $77c0+offset,x

dex
bpl loop

ENDMACRO

MACRO WHEEL_BYTE y,masks,values
ldy #y
lda (ZP_1E),y
and masks,x
ora values,x
sta (ZP_1E),y
inx
ENDMACRO

.wheel_blank_part
{
clc
sta ld0+1
adc #8:sta ld8+1
adc #8:sta ld16+1

ldx ZP_14

.loop
cpx #wheel_end_sprite_y:bcs done

lda wheel_row_ptrs_LO-wheel_min_sprite_y,x:sta ZP_1E
lda wheel_row_ptrs_HI-wheel_min_sprite_y,x:adc ZP_12:sta ZP_1F

inx

lda #0

.ld0:ldy #0:sta (ZP_1E),y
.ld8:ldy #8:sta (ZP_1E),y
.ld16:ldy #16:sta (ZP_1E),y

bne loop

.done
stx ZP_14
rts
}

.wheel_blank_left_corner
{
lda #0
sta $77e0
sta $77e1
sta $77e2
sta $77e3
sta $77e4
sta $77e5
lda #hud_left_corner_byte
sta $77e6,x
rts
}

.wheel_blank_right_corner
{
lda #0
sta $78d8
sta $78d9
sta $78da
sta $78db
sta $78dc
sta $78dd
lda #hud_right_corner_byte
sta $78de
rts
}

.wheel_copy_right_corner
{
lda #$d8:sta wheel_copy_corner_wr0+1:sta wheel_copy_corner_wr1+1
lda #$78:sta wheel_copy_corner_wr0+2:sta wheel_copy_corner_wr1+2
lda #hud_right_corner_byte
inx:inx							; copy from right column
jmp wheel_copy_corner
}

.wheel_copy_left_corner
{
lda #$e0:sta wheel_copy_corner_wr0+1:sta wheel_copy_corner_wr1+1
lda #$77:sta wheel_copy_corner_wr0+2:sta wheel_copy_corner_wr1+2
lda #hud_left_corner_byte
}

.wheel_copy_corner
{
sta corner_values+6
ldy #0
.loop
.*wheel_copy_corner_ld:lda $ffff,x
ora corner_values,y
.*wheel_copy_corner_wr0:sta $ffff,y
inx:inx:inx
cpx #wheel_data_size:bcs out_of_data
iny
cpy #7:bne loop

rts

.out_of_data_loop
lda corner_values,y
.*wheel_copy_corner_wr1:sta $ffff,y
.out_of_data
iny
cpy #7:bne out_of_data_loop
rts

.corner_values
equb 0,0,0,0,0,0
equb 0
}

MACRO WHEEL_ROUTINE is_left,masks,values

if is_left
y=0
else
y=232
endif

ldx #0

.loop
ldy ZP_14

cpy #wheel_end_sprite_y:bcs reached_bottom

lda wheel_row_ptrs_LO-wheel_min_sprite_y,y:sta ZP_1E
lda wheel_row_ptrs_HI-wheel_min_sprite_y,y:adc ZP_12:sta ZP_1F

iny:sty ZP_14

WHEEL_BYTE y+0,masks,values
WHEEL_BYTE y+8,masks,values
WHEEL_BYTE y+16,masks,values

cpx #wheel_data_size
bne loop

; Out of data.

lda #y:jsr wheel_blank_part

; And blank out the bottom corner bit too.
if is_left
jsr wheel_blank_left_corner
else
jsr wheel_blank_right_corner
endif

rts

.reached_bottom

lda #LO(values):sta wheel_copy_corner_ld+1
lda #HI(values):sta wheel_copy_corner_ld+2

if is_left
jsr wheel_copy_left_corner
else
jsr wheel_copy_right_corner
endif

rts
ENDMACRO

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._graphics_draw_left_wheel_0:WHEEL_ROUTINE TRUE,wheel_left_0_masks,wheel_left_0_values
._graphics_draw_left_wheel_1:WHEEL_ROUTINE TRUE,wheel_left_1_masks,wheel_left_1_values
._graphics_draw_left_wheel_2:WHEEL_ROUTINE TRUE,wheel_left_2_masks,wheel_left_2_values

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._graphics_draw_right_wheel_0:WHEEL_ROUTINE FALSE,wheel_right_0_masks,wheel_right_0_values
._graphics_draw_right_wheel_1:WHEEL_ROUTINE FALSE,wheel_right_1_masks,wheel_right_1_values
._graphics_draw_right_wheel_2:WHEEL_ROUTINE FALSE,wheel_right_2_masks,wheel_right_2_values

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._graphics_draw_left_wheel
{
lda ZP_14:pha
lda ZP_1E:pha
lda ZP_1F:pha

sty ZP_14

cpx #0:bne not_0:jsr _graphics_draw_left_wheel_0:jmp drawn:.not_0
cpx #1:bne not_1:jsr _graphics_draw_left_wheel_1:jmp drawn:.not_1
jsr _graphics_draw_left_wheel_2

.drawn

REDRAW_ENGINE $5540,$5680,4*8,engine_left_masks,engine_left_values

pla:sta ZP_1F
pla:sta ZP_1E
pla:sta ZP_14

rts
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._graphics_draw_right_wheel
{
lda ZP_14:pha
lda ZP_1E:pha
lda ZP_1F:pha

sty ZP_14

cpx #0:bne not_0:jsr _graphics_draw_right_wheel_0:jmp drawn:.not_0
cpx #1:bne not_1:jsr _graphics_draw_right_wheel_1:jmp drawn:.not_1
jsr _graphics_draw_right_wheel_2

.drawn

REDRAW_ENGINE $5540,$5680,33*8,engine_right_masks,engine_right_values

pla:sta ZP_1F
pla:sta ZP_1E
pla:sta ZP_14

rts
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.beeb_graphics_end
