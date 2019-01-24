.beeb_graphics_start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "build/flames-tables.asm"

.menu_header_graphic_begin
incbin "build/scr-beeb-header.dat"
skip 2560						; book space for the Mode 1 version...
.menu_header_graphic_end

include "build/wheels-tables.asm"

include "build/hud-font-tables.asm"

if FANCY_TRACK_PREVIEW
include "build/track-preview.asm"
endif

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

; Redraw part of the engine on top of the wheel sprite.
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

dex
bpl loop

ENDMACRO

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; C64 version: the wheels are sprites - two sprites for the left
; wheel, and two sprites for the right. C64 sprites appear on top of
; the bitmap, so this makes the wheels appear on top of the engine. To
; fix this, there are two additional higher-priority sprites, that
; look like the nearest pair of exhaust pipes, positioned exactly on
; top of the corresponding areas of the bitmap.
; 
; The wheel sprites aren't tall enough to reach the bottom of the
; screen when the wheel is at its minimum Y coordinate, so the HUD
; graphic contains 10 or so rows of black in the bottom left and right
; corners. When the wheels is at its minimum Y coordinate, these areas
; are revealed, and it just looks like you're looking at the inside of
; the wheel.
;
;
; The BBC version is sort of similar.
;
; For the part of the wheel that overlaps the double-buffered area, it
; draws the wheel on top of the engine (writing unmasked $00 bytes if
; it runs out of wheel data before reaching the bottom of the screen
; area), then redraws the bit of the engine that could have been
; overwritten.
;
; For the single-buffered area, it does a similar sort of thing, but
; only writes each byte once to avoid flicker. There is also a
; load-bearing pixel in the last byte of the single-buffered area that
; needs to be retained.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Copy blank wheel to double-buffered area.
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Blank the bottom left corner.
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
sta $77e6
rts
}

; Blank the bottom right corner.
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Copy wheel data into the bottom right corner, followed by blank if
; the data runs out before the bottom of the display.
.wheel_copy_right_corner
{
lda #$d8:sta wheel_copy_corner_wr0+1:sta wheel_copy_corner_wr1+1
lda #$78:sta wheel_copy_corner_wr0+2:sta wheel_copy_corner_wr1+2
lda #hud_right_corner_byte
inx:inx							; copy from right column
jmp wheel_copy_corner
}

; Copy wheel data into the bottom left corner, followed by blank if
; the data runs out before the bottom of the display.
.wheel_copy_left_corner
{
lda #$e0:sta wheel_copy_corner_wr0+1:sta wheel_copy_corner_wr1+1
lda #$77:sta wheel_copy_corner_wr0+2:sta wheel_copy_corner_wr1+2
lda #hud_left_corner_byte
; run through into wheel_copy_corner
}

; Copy wheel data to left or right corner.
;
; Fix up wheel_copy_corner_wr0 and wheel_copy_corner_wr1 before
; calling. A is the byte to store in the bottom row.
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Generate a wheel copy routine - copy data from DATA to left
; (IS_LEFT==TRUE) or right (IS_LEFT==FALSE) side of the screen in the
; double-buffered area.
MACRO WHEEL_ROUTINE is_left,data

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

ldy #y+0
lda (ZP_1E),y:and data,x:ora data+wheel_data_size,x:sta (ZP_1E),y
inx

ldy #y+8
lda (ZP_1E),y:and data,x:ora data+wheel_data_size,x:sta (ZP_1E),y
inx

ldy #y+16
lda (ZP_1E),y:and data,x:ora data+wheel_data_size,x:sta (ZP_1E),y
inx

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

lda #LO(data+wheel_data_size):sta wheel_copy_corner_ld+1
lda #HI(data+wheel_data_size):sta wheel_copy_corner_ld+2

if is_left
jsr wheel_copy_left_corner
else
jsr wheel_copy_right_corner
endif

rts
ENDMACRO

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._graphics_draw_left_wheel_0:WHEEL_ROUTINE TRUE,wheel_left_0_data
._graphics_draw_left_wheel_1:WHEEL_ROUTINE TRUE,wheel_left_1_data
._graphics_draw_left_wheel_2:WHEEL_ROUTINE TRUE,wheel_left_2_data

._graphics_draw_left_wheel_LO
equb LO(_graphics_draw_left_wheel_0)
equb LO(_graphics_draw_left_wheel_1)
equb LO(_graphics_draw_left_wheel_2)

._graphics_draw_left_wheel_HI
equb HI(_graphics_draw_left_wheel_0)
equb HI(_graphics_draw_left_wheel_1)
equb HI(_graphics_draw_left_wheel_2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._graphics_draw_right_wheel_0:WHEEL_ROUTINE FALSE,wheel_right_0_data
._graphics_draw_right_wheel_1:WHEEL_ROUTINE FALSE,wheel_right_1_data
._graphics_draw_right_wheel_2:WHEEL_ROUTINE FALSE,wheel_right_2_data

._graphics_draw_right_wheel_LO
equb LO(_graphics_draw_right_wheel_0)
equb LO(_graphics_draw_right_wheel_1)
equb LO(_graphics_draw_right_wheel_2)

._graphics_draw_right_wheel_HI
equb HI(_graphics_draw_right_wheel_0)
equb HI(_graphics_draw_right_wheel_1)
equb HI(_graphics_draw_right_wheel_2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MACRO WHEEL_PUSH 
lda ZP_14:pha
lda ZP_1E:pha
lda ZP_1F:pha
ENDMACRO

MACRO WHEEL_POP
pla:sta ZP_1F
pla:sta ZP_1E
pla:sta ZP_14
ENDMACRO

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


._graphics_draw_left_wheel
{
WHEEL_PUSH

sty ZP_14

lda _graphics_draw_left_wheel_LO,x:sta call+1
lda _graphics_draw_left_wheel_HI,x:sta call+2
.call jsr $ffff

REDRAW_ENGINE $5540,$5680,4*8,engine_left_masks,engine_left_values

WHEEL_POP

rts
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._graphics_draw_right_wheel
{
WHEEL_PUSH

sty ZP_14

lda _graphics_draw_right_wheel_LO,x:sta call+1
lda _graphics_draw_right_wheel_HI,x:sta call+2
.call jsr $ffff

REDRAW_ENGINE $5540,$5680,33*8,engine_right_masks,engine_right_values

WHEEL_POP

rts
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; The text areas are not really very conveniently aligned :(
;
; 6 scanlines to write.
;
; Scanlines 0/1/2 are always on the same character row, and scanline 5
; is always on a different character row from 0/1/2.
;
;     NW    SW    NE    SE
; 0  7bab  7ced  7c6b  7dad
; 1  7bac  7cee  7c6c  7dae
; 2  7bad  7cef  7c6d  7daf
; 3  7bae  7e28  7c6e  7ee8
; 4  7baf  7e29  7c6f  7ee9
; 5  7ce8  7e2a  7da8  7eea

dash_ZP_ptr0=ZP_1E
dash_ZP_ptr1=ZP_20
dash_ZP_ptr2=ZP_22
dash_ZP_offset=ZP_24
dash_ZP_last_char=ZP_25

MACRO PREPARE_ROUTINE addr_012,addr_34,addr_5
lda #LO(addr_012):sta dash_ZP_ptr0+0
lda #HI(addr_012):sta dash_ZP_ptr0+1

lda #LO(addr_34):sta dash_ZP_ptr1+0
lda #HI(addr_34):sta dash_ZP_ptr1+1

lda #LO(addr_5):sta dash_ZP_ptr2+0
lda #HI(addr_5):sta dash_ZP_ptr2+1

lda #0:sta dash_ZP_offset

rts
ENDMACRO

.dash_buffer:skip 6

.dash_prepare_for_nw:PREPARE_ROUTINE $7bab,$7bae,$7ce8
.dash_prepare_for_sw:PREPARE_ROUTINE $7ced,$7e28,$7e2a
.dash_prepare_for_ne:PREPARE_ROUTINE $7c6b,$7c6e,$7da8
.dash_prepare_for_se:PREPARE_ROUTINE $7dad,$7ee8,$7eea

.dash_clearbuf
{
lda #$ff
sta dash_buffer+0
sta dash_buffer+1
sta dash_buffer+2
sta dash_buffer+3
sta dash_buffer+4
sta dash_buffer+5
rts
}

.dash_loadbuf
{
ldy dash_ZP_offset

; +0
lda (dash_ZP_ptr0),y:sta dash_buffer+0
lda (dash_ZP_ptr1),y:sta dash_buffer+3
lda (dash_ZP_ptr2),y:sta dash_buffer+5

; +1
iny
lda (dash_ZP_ptr0),y:sta dash_buffer+1
lda (dash_ZP_ptr1),y:sta dash_buffer+4

; +2
iny
lda (dash_ZP_ptr0),y:sta dash_buffer+2

rts
}

.dash_storebuf
{
ldy dash_ZP_offset

; +0
lda dash_buffer+0:sta (dash_ZP_ptr0),y
lda dash_buffer+3:sta (dash_ZP_ptr1),y
lda dash_buffer+5:sta (dash_ZP_ptr2),y

; +1
iny
lda dash_buffer+1:sta (dash_ZP_ptr0),y
lda dash_buffer+4:sta (dash_ZP_ptr1),y

; +2
iny
lda dash_buffer+2:sta (dash_ZP_ptr0),y

clc:tya:adc #6:sta dash_ZP_offset
rts
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; storech - overwrite dash_buffer with char (or part thereof).

; unshifted.
.dash_storech_0_and_storebuf
{
lda #LO(hud_font_shift0):sta dash_storech_read_table+1
lda #HI(hud_font_shift0):sta dash_storech_read_table+2
jsr dash_storech
jmp dash_storebuf
}

; shifted 2 pixels right.
.dash_storech_2l_and_storebuf
{
lda #LO(hud_font_shift2_a):sta dash_storech_read_table+1
lda #HI(hud_font_shift2_a):sta dash_storech_read_table+2
jsr dash_storech
jmp dash_storebuf
}

; shifted 2 pixels right.
.dash_storech_2r
{
lda #LO(hud_font_shift2_b):sta dash_storech_read_table+1
lda #HI(hud_font_shift2_b):sta dash_storech_read_table+2
}
.dash_storech
{
ldy #5
.loop
sty reload_y+1
ldy hud_font,x
.*dash_storech_read_table:lda $ffff,y
.reload_y:ldy #$ff
sta dash_buffer,y
inx
dey						
bpl loop				
rts
}

; shifted 3 pixels right.
.dash_storech_3l_and_storebuf
{
lda #LO(hud_font_shift3_a):sta dash_storech_read_table+1
lda #HI(hud_font_shift3_a):sta dash_storech_read_table+2
jsr dash_storech
jmp dash_storebuf
}

.dash_storech_3r
{
lda #LO(hud_font_shift3_b):sta dash_storech_read_table+1
lda #HI(hud_font_shift3_b):sta dash_storech_read_table+2
jmp dash_storech
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; addch - add char (or part thereof), masked, into existing contents
; of dash_buffer.

.dash_addch_2l_and_storebuf
{
lda #$33:sta dash_addch_mask+1	; clear right 2 pixels
lda #LO(hud_font_shift2_a):sta dash_addch_read_table+1
lda #HI(hud_font_shift2_a):sta dash_addch_read_table+2
jsr dash_addch
jmp dash_storebuf
}

.dash_addch_2r
{
lda #$cc:sta dash_addch_mask+1	; clear left 2 pixels
lda #LO(hud_font_shift2_b):sta dash_addch_read_table+1
lda #HI(hud_font_shift2_b):sta dash_addch_read_table+2
}
.dash_addch
{
ldy #5
.loop
lda dash_buffer,y
.*dash_addch_mask:ora #$ff
sty reload_y+1
ldy hud_font,x
.*dash_addch_read_table:and $ffff,y
.reload_y:ldy #$ff
sta dash_buffer,y
inx
dey
bpl loop
rts
}

.dash_addch_3l_and_storebuf
{
lda #$11:sta dash_addch_mask+1	; clear right 1 pixels
lda #LO(hud_font_shift3_a):sta dash_addch_read_table+1
lda #HI(hud_font_shift3_a):sta dash_addch_read_table+2
jsr dash_addch
jmp dash_storebuf
}

.dash_addch_3r
{
lda #$ee:sta dash_addch_mask+1	; clear left 3 pixels
lda #LO(hud_font_shift3_b):sta dash_addch_read_table+1
lda #HI(hud_font_shift3_b):sta dash_addch_read_table+2
jmp dash_addch
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; stores right part of whatever's in dash_ZP_last_char, right part of
; X, and puts X in dash_ZP_last_char ready for the next call.
.dash_storech_2_and_storebuf
{
stx reload_x+1
ldx dash_ZP_last_char:jsr dash_storech_2r
.reload_x:ldx #$ff
stx dash_ZP_last_char
jmp dash_addch_2l_and_storebuf
}

.dash_storech_3_and_storebuf
{
stx reload_x+1
ldx dash_ZP_last_char:jsr dash_storech_3r
.reload_x:ldx #$ff
stx dash_ZP_last_char
jmp dash_addch_3l_and_storebuf
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.high_nybble_digit
{
and #$f0						; x*16
lsr a							; x*8
lsr a							; x*4
sta add+1
lsr a							; x*2
.add:adc #$ff					; x*2+x*4
tax
rts
}

.low_nybble_digit
and #$0f
.digit
{
and #%00111111
asl a
sta add+1
asl a
.add:adc #$ff
tax
rts
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 5 unmasked columns + 2 pixels.
.dash_clear_west
{
jsr dash_clear_5_columns_unmasked
lda #$cc
}
.dash_clear_1_column_masked
{
sta mask+1
jsr dash_loadbuf
ldx #5
.loop
lda dash_buffer,x
.mask:ora #$ff
sta dash_buffer,x
dex
bpl loop
jmp dash_storebuf
}

; 2 pixels + 5 unmasked columns.
.dash_clear_east
{
lda #$33:jsr dash_clear_1_column_masked
}
.dash_clear_5_columns_unmasked
{
jsr dash_clearbuf
ldx #5
.loop
jsr dash_storebuf
dex
bne loop
rts
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._dash_reset
{
jsr dash_save_zp

; NW - lap/boost
jsr dash_prepare_for_nw:jsr dash_clear_west

lda #0:sta dash_ZP_offset

ldx #hud_font_char_L:jsr dash_storech_0_and_storebuf

lda #16:sta dash_ZP_offset

ldx #hud_font_char_B:jsr dash_storech_3l_and_storebuf
ldx #hud_font_char_B:jsr dash_storech_3r:jsr dash_storebuf

; SW - aicar distance
jsr dash_prepare_for_sw:jsr dash_clear_west

; NE - lap time
jsr dash_prepare_for_ne:jsr dash_clear_east

; SE - best lap
jsr dash_prepare_for_se:jsr dash_clear_east

ldy #7:jsr dash_update_flag_icon
ldy #7:jsr dash_update_stopwatch_icon

jmp dash_restore_zp
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._dash_update_boost
{
jsr dash_save_zp

jsr dash_prepare_for_nw

lda #3*8:sta dash_ZP_offset

lda #hud_font_char_B:sta dash_ZP_last_char

; 'B' (right half) + Boost reserve high nybble (left half)
lda boost_reserve:jsr high_nybble_digit:jsr dash_storech_3_and_storebuf

;Boost reserve high nybble (right half) + boost reserve low nybble
;(left half)
lda boost_reserve:jsr low_nybble_digit:jsr dash_storech_3_and_storebuf

; Boost reserve low nybble (right half)
jsr dash_loadbuf
ldx dash_ZP_last_char:jsr dash_addch_3r
jsr dash_storebuf

jmp dash_restore_zp
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._dash_update_lap
{
jsr dash_save_zp
jsr dash_prepare_for_nw

lda #1*8:sta dash_ZP_offset

ldx #hud_font_char_space
lda L_C378:beq storech
jsr digit
.storech
jsr dash_storech_0_and_storebuf

jmp dash_restore_zp
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._dash_update_distance_to_ai_car
{
jsr dash_save_zp
jsr dash_prepare_for_sw

ldx #hud_font_char_space
lda L_C36A
and #$f0
bpl prefix
ldx #hud_font_char_minus
.prefix
stx dash_ZP_last_char

jsr dash_storech_3l_and_storebuf

lda ZP_18:jsr digit:jsr dash_storech_3_and_storebuf
lda ZP_16:jsr digit:jsr dash_storech_3_and_storebuf
lda ZP_15:jsr digit:jsr dash_storech_3_and_storebuf
lda ZP_17:jsr digit:jsr dash_storech_3_and_storebuf

jsr dash_loadbuf
ldx dash_ZP_last_char:jsr dash_addch_3r
jsr dash_storebuf

jmp dash_restore_zp
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._dash_update_current_lap_time
{
jsr dash_save_zp
jsr dash_prepare_for_ne

ldy #0

; think ZP_82 is just briefly set after finishing a lap, so you see
; the hundredths...
{lda ZP_82:beq k:lda #$80:.k}

jsr dash_update_time

jmp dash_restore_zp
}

._dash_update_best_lap_time
{
jsr dash_save_zp
jsr dash_prepare_for_se

ldy #2
lda #$80						; show hundredths

jsr dash_update_time

jmp dash_restore_zp
}

.dash_update_time
{
sta show_hundredths
sty offset

; Minutes

lda L_8398,Y:jsr low_nybble_digit:stx dash_ZP_last_char
jsr dash_loadbuf:jsr dash_addch_2l_and_storebuf

ldx #hud_font_char_colon:jsr dash_storech_2_and_storebuf

; The right half of the colon is discarded.

ldy offset:lda L_82B0,y:pha

jsr high_nybble_digit:jsr dash_storech_0_and_storebuf
pla:jsr low_nybble_digit:jsr dash_storech_0_and_storebuf

bit show_hundredths:bpl no_hundredths

; Only the right half of the dot is drawn.
lda #hud_font_char_dot:sta dash_ZP_last_char

ldy offset:lda L_8298,Y:pha

jsr high_nybble_digit:jsr dash_storech_2_and_storebuf
pla:jsr low_nybble_digit:jsr dash_storech_2_and_storebuf

jsr dash_loadbuf
ldx dash_ZP_last_char:jsr dash_addch_2r
jsr dash_storebuf

rts

.no_hundredths
jsr dash_clearbuf

jsr dash_storebuf

jsr dash_storebuf

jsr dash_loadbuf
ldx #hud_font_char_space:jsr dash_addch_2r
jsr dash_storebuf

rts

.show_hundredths:equb $ff
.offset:equb $ff
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Icon 0 = checquered flag; icon 1 = stopwatch.

icon_0_addr=$7e60

.dash_icon_offsets
equb 0							; $7e60
equb $d0-$60					; $7ed0

.dash_icon_colours
equb $ff
equb $ff

; the C64 dash icon colours are either 7 (yellow) or 11 (dark grey).
.dash_set_icon_state
{
lda #$f0						; "grey"
cpy #7							; yellow?
bne got_colour					; taken if grey
lda #$ff						; yellow
.got_colour

cmp dash_icon_colours,x:beq done

sta dash_icon_colours,x:sta _and+1

; Each icon is 7 scanlines high.
ldy dash_icon_offsets,x
jsr do
iny								; skip 7th row
.do
ldx #7
.loop
lda icon_0_addr,y				; abcdefgh
lsr a:lsr a:lsr a:lsr a			; 0000abcd
ora icon_0_addr,y				; abcdxyzw
and #$0f						; 0000xyzw
sta or+1
asl a:asl a:asl a:asl a			; xyzw0000
.or:ora #$ff					; xyzwxyzw
._and:and #$ff
sta icon_0_addr,y
.next
iny
dex
bne loop
.done
rts
}

._dash_update_flag_icon
{
ldx #0:jmp dash_set_icon_state
}

._dash_update_stopwatch_icon
{
ldx #1:jmp dash_set_icon_state
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.dash_save_zp
{
lda dash_ZP_offset:sta dash_restore_zp_reload_offset+1
lda dash_ZP_last_char:sta dash_restore_zp_reload_tmp+1
lda dash_ZP_ptr0+0:sta dash_restore_zp_reload_ptr0_0+1
lda dash_ZP_ptr0+1:sta dash_restore_zp_reload_ptr0_1+1
lda dash_ZP_ptr1+0:sta dash_restore_zp_reload_ptr1_0+1
lda dash_ZP_ptr1+1:sta dash_restore_zp_reload_ptr1_1+1
lda dash_ZP_ptr2+0:sta dash_restore_zp_reload_ptr2_0+1
lda dash_ZP_ptr2+1:sta dash_restore_zp_reload_ptr2_1+1
rts
}

.dash_restore_zp
{
.*dash_restore_zp_reload_offset:lda #$ff:sta dash_ZP_offset
.*dash_restore_zp_reload_tmp:lda #$ff:sta dash_ZP_last_char
.*dash_restore_zp_reload_ptr0_0:lda #$ff:sta dash_ZP_ptr0+0
.*dash_restore_zp_reload_ptr0_1:lda #$ff:sta dash_ZP_ptr0+1
.*dash_restore_zp_reload_ptr1_0:lda #$ff:sta dash_ZP_ptr1+0
.*dash_restore_zp_reload_ptr1_1:lda #$ff:sta dash_ZP_ptr1+1
.*dash_restore_zp_reload_ptr2_0:lda #$ff:sta dash_ZP_ptr2+0
.*dash_restore_zp_reload_ptr2_1:lda #$ff:sta dash_ZP_ptr2+1
rts
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if NOT(FANCY_TRACK_PREVIEW)

; Bogus entries for the DLL table.
._preview_draw_border
._preview_fix_up_cleared_screen
._preview_add_background
brk

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

else

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

preview_ZP_src=ZP_1E
preview_ZP_dest=ZP_20

.preview_save_zp
{
lda preview_ZP_src+0:sta preview_restore_zp_reload_src_0+1
lda preview_ZP_src+1:sta preview_restore_zp_reload_src_1+1
lda preview_ZP_dest+0:sta preview_restore_zp_reload_dest_0+1
lda preview_ZP_dest+1:sta preview_restore_zp_reload_dest_1+1
rts
}

.preview_restore_zp
{
.*preview_restore_zp_reload_src_0:lda #$ff:sta preview_ZP_src+0
.*preview_restore_zp_reload_src_1:lda #$ff:sta preview_ZP_src+1
.*preview_restore_zp_reload_dest_0:lda #$ff:sta preview_ZP_dest+0
.*preview_restore_zp_reload_dest_1:lda #$ff:sta preview_ZP_dest+1
rts
}

.preview_copy_horizontal
{
ldy #255

jsr copy
inc preview_ZP_src+1:inc preview_ZP_dest+1

jsr copy
inc preview_ZP_src+1:inc preview_ZP_dest+1

ldy #127
.copy
.copy128_loop
lda (preview_ZP_src),y:sta (preview_ZP_dest),y
dey:cpy #$ff:bne copy128_loop
rts
}

.preview_copy_vertical
{
ldx #16
.rows_loop
ldy #31
.row_loop
lda (preview_ZP_src),y:sta (preview_ZP_dest),y
dey:bpl row_loop

clc
lda preview_ZP_src+0:adc #32:sta preview_ZP_src+0:bcc src_done:inc preview_ZP_src+1:.src_done

clc
lda preview_ZP_dest+0:adc #$40:sta preview_ZP_dest+0
lda preview_ZP_dest+1:adc #$01:sta preview_ZP_dest+1

dex:bne rows_loop
rts
}

._preview_draw_border
{
jsr preview_save_zp

lda #LO(top_border_data):sta preview_ZP_src+0
lda #HI(top_border_data):sta preview_ZP_src+1
lda #$00:sta preview_ZP_dest+0
lda #$40:sta preview_ZP_dest+1
jsr preview_copy_horizontal

lda #LO(bottom_border_data):sta preview_ZP_src+0
lda #HI(bottom_border_data):sta preview_ZP_src+1
lda #$80:sta preview_ZP_dest+0
lda #$56:sta preview_ZP_dest+1
jsr preview_copy_horizontal

lda #LO(left_border_data):sta preview_ZP_src+0
lda #HI(left_border_data):sta preview_ZP_src+1
lda #$80:sta preview_ZP_dest+0
lda #$42:sta preview_ZP_dest+1
jsr preview_copy_vertical

lda #LO(right_border_data):sta preview_ZP_src+0
lda #HI(right_border_data):sta preview_ZP_src+1
lda #$a0:sta preview_ZP_dest+0
lda #$43:sta preview_ZP_dest+1
jsr preview_copy_vertical

jmp preview_restore_zp
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._preview_fix_up_cleared_screen
{
ldx #0
.clear_lines_loop
lda #0
sta $42a0,x
sta $5567,x
clc:txa:adc #8:tax:bne clear_lines_loop

jmp preview_initialise_corners
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._preview_add_background
{
jsr preview_save_zp

lda #LO(preview_area_background_data):sta preview_ZP_src+0
lda #HI(preview_area_background_data):sta preview_ZP_src+1

lda #0

.columns_loop
sta x

; 64 = top of screen - same units as the horizon table.
lda #64
sta y

lda #0
sta src_index
sta mask

.copy_column_loop

lda #0:sta mask_tmp

ldx x
lda y
cmp L_C640+0,X:rol mask_tmp
cmp L_C640+1,X:rol mask_tmp
cmp L_C640+2,X:rol mask_tmp
cmp L_C640+3,X:rol mask_tmp

; convert into proper pixel mask.
lda mask_tmp:asl a:asl a:asl a:asl a:ora mask_tmp

; accumulate.
ora mask

; check if all 4 pixels' columns done...
cmp #$ff:beq next_column

sta mask

; form masked source byte.
eor #$ff
ldy src_index
and (preview_ZP_src),y:sta mask_tmp

; form screen address.
ldy y
lda x
asl A							; turn into column byte offset (and C=0)
adc Q_pointers_LO,y
sta preview_ZP_dest+0

lda Q_pointers_HI,y
adc #0
sta preview_ZP_dest+1

; form masked screen byte.
ldy y:lda (preview_ZP_dest),y:and mask

; merge and write.
ora mask_tmp
sta (preview_ZP_dest),y

; next row.
inc y
inc src_index
lda src_index
cmp #preview_area_background_height
bne copy_column_loop

.next_column
clc
lda preview_ZP_src+0
adc #preview_area_background_height
sta preview_ZP_src+0
{bcc noc:inc preview_ZP_src+1:.noc}

clc:lda x:adc #4
bmi done
jmp columns_loop
.done

jmp preview_restore_zp

; mask: 1=draw screen, 0=draw background.
.mask_tmp:equb 0
.mask:equb 0
.y:equb 0
.src_index:equb 0
.x:equb 0
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.beeb_graphics_end
