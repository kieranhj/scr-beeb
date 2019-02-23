.beeb_graphics_start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "build/flames-tables.asm"

; Entire menu screen nnow compressed with pucrunch
;.menu_header_graphic_begin
;incbin "build/scr-beeb-header.dat"
;skip 2560						; book space for the Mode 1 version...
;.menu_header_graphic_end

include "build/wheels-tables.asm"

; Don't remember why I called this "HUD" and not "dash"...
include "build/hud-font-tables.asm"

include "build/track-preview.asm"

include "build/dash-icons.asm"

.track_preview_screen
incbin "build/scr-beeb-preview.pu"

.track_preview_bg
incbin "build/scr-beeb-preview-bg.pu"

.credits_screen
incbin "build/scr-beeb-credits.pu"

.keys_screen_pu
incbin "build/keys.mode7.pu"

.trainer_screen_pu
incbin "build/trainer.mode7.pu"

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
._graphics_unpack_menu_screen
{
    LDA #HI(screen1_address)
    LDX #LO(beeb_menu_screen_compressed)
    LDY #HI(beeb_menu_screen_compressed)
    JMP PUCRUNCH_UNPACK
}

.beeb_menu_screen_compressed
INCBIN "build/scr-beeb-menu.pu"

IF 0
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
ENDIF

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
equb LO(_graphics_draw_left_wheel_1)
equb LO(_graphics_draw_left_wheel_0)
equb LO(_graphics_draw_left_wheel_2)

._graphics_draw_left_wheel_HI
equb HI(_graphics_draw_left_wheel_1)
equb HI(_graphics_draw_left_wheel_0)
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

; Icon 0 = checquered flag ($7d27); icon 1 = stopwatch ($7d97)
;
; Each icon is 2 columns * 7 pixels = 14 bytes.
;
; There are 4 icons stored in the buffer:
;
; 0 = icon 0 off
; 1 = icon 0 on
; 2 = icon 1 off
; 3 = icon 1 on

.dash_icon_c64_colours
equb 7							; on
equb 7							; on

.dash_icon_offsets
equb dash_icon_0-dash_icons
equb dash_icon_1-dash_icons

.dash_icon_dest_addrs_LO:equb LO(dash_icon_0_addr),LO(dash_icon_1_addr)
.dash_icon_dest_addrs_HI:equb HI(dash_icon_0_addr),HI(dash_icon_1_addr)

; the C64 dash icon colours are either 7 (yellow, on) or 11 (dark
; grey, off).
.dash_set_icon_state
{
tya
cmp dash_icon_c64_colours,x
bne set_icon_state
rts

.set_icon_state
sta dash_icon_c64_colours,x

jsr dash_save_zp

lda dash_icon_offsets,x
cpy #7							; yellow?
bne got_colour					; taken if grey
adc #14-1						; offset to on version, -1 as C=1
.got_colour

ldy dash_icon_dest_addrs_LO,x:sty dash_ZP_ptr0+0
ldy dash_icon_dest_addrs_HI,x:sty dash_ZP_ptr0+1

tax

ldy #7:lda dash_icons,x:inx:sta (dash_ZP_ptr0),y
ldy #15:lda dash_icons,x:inx:sta (dash_ZP_ptr0),y

clc
lda dash_ZP_ptr0+0:adc #$40:sta dash_ZP_ptr0+0
lda dash_ZP_ptr0+1:adc #$01:sta dash_ZP_ptr0+1

ldy #0:jsr copy6
ldy #8:jsr copy6

jmp dash_restore_zp

.copy6
lda #6:sta dash_ZP_offset
.copy6_loop
lda dash_icons,x:sta (dash_ZP_ptr0),y
inx:iny
dec dash_ZP_offset:bne copy6_loop
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

._preview_draw_screen
{
lda #$40
ldx #LO(track_preview_screen)
ldy #HI(track_preview_screen)

jmp PUCRUNCH_UNPACK
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._preview_unpack_background
{
ldx #$80:ldy #$62
jsr PUCRUNCH_SET_OUTPOS

ldx #LO(track_preview_bg):ldy #HI(track_preview_bg)
jmp PUCRUNCH_UNPACK_TO_OUTPOS
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._preview_add_background
{
jsr preview_save_zp

jsr clear_C600

ldy #64

.one_row

sty y

; address of source row.
clc
tya:adc Q_pointers_LO,y:sta preview_ZP_src+0
lda Q_pointers_HI,y:adc #$20:sta preview_ZP_src+1

; address of left edge of preview area.
clc
tya:adc Q_pointers_LO,y:sta preview_ZP_dest+0
lda Q_pointers_HI,y:adc #0:sta preview_ZP_dest+1

; Position in columns - 0-31.
ldx #0

.one_byte

stx x

; skip this byte if it's entirely hidden.
lda L_C600,x:cmp #$ff:beq next_column

lda #0:sta mask_tmp

; X = X position in pixels.
txa:asl a:asl a:tax

; Y = X position as byte offset.
asl a:tay

; Form mask - 0 = background, 1 = screen
lda y
cmp L_C640+0,X:rol mask_tmp
cmp L_C640+1,X:rol mask_tmp
cmp L_C640+2,X:rol mask_tmp
cmp L_C640+3,X:rol mask_tmp

; Form pixel mask from that - 0 = background, 3 = screen
lda mask_tmp:asl a:asl a:asl a:asl a:ora mask_tmp

; Accumlate.
ldx x:ora L_C600,x:sta L_C600,x

; Form masked background byte.
eor #$ff:and (preview_ZP_src),y:sta mask_tmp

; Form masked screen byte.
lda (preview_ZP_dest),y:and L_C600,x

; Merge and write.
ora mask_tmp:sta (preview_ZP_dest),y

.next_column
inx
cpx #32
bne one_byte

ldy y
iny
cpy #64+track_preview_bg_height
beq done
jmp one_row
.done

jsr clear_C600

jmp preview_restore_zp

.clear_C600
; This table doesn't appear to be used for anything during the track
; preview process, so I'm sure this is perfectly safe...
ldx #31
lda #0
.init_loop
sta L_C600,x
dex:bpl init_loop
rts

; mask: 1=draw screen, 0=draw background.
.mask_tmp:equb 0
.mask:equb 0
.y:equb 0
.src_index:equb 0
.x:equb 0
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF _DEBUG
._graphics_draw_debug_framerate
{
sec
lda vsync_counter
tax
sbc prev_vsync
cmp #10
bcc ok
lda #9
.ok
stx prev_vsync

asl a							; n*2
sta beeb_writeptr
asl a							; n*4, C=0
adc beeb_writeptr
tax								; n*6

ldy #5
.loop
sty reload_y+1
ldy hud_font,x
lda hud_font_shift0,y
eor #$ff
.reload_y:ldy #$ff
sta $6000,y
inx
dey
bpl loop

rts

.prev_vsync:equb 0
}
ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Might as well keep this out of main RAM...
text_sprite_buffer_size=2*12*8+16
.text_sprite_buffer:skip text_sprite_buffer_size

._graphics_draw_in_game_text_sprites
{
address=$4570

bit L_C355:bpl done

clc
lda #LO(address):sta ZP_1E
lda #HI(address):adc ZP_12:sta ZP_1F
ldx #0
jsr copy

ldx #4
jsr copy

ldx #96
jsr copy

ldx #100
.copy
ldy #0
.copy_loop
jsr copy_byte
jsr copy_byte
jsr copy_byte
jsr copy_byte
inx:inx:inx:inx
cpy #96
bne copy_loop
clc
lda ZP_1E:adc #$40:sta ZP_1E
lda ZP_1F:adc #$01:sta ZP_1F
.done
rts

.copy_byte
lda text_sprite_buffer+8,x
eor #$ff
and #$0f						; red
sta value0+1
sta value1+1

lda (ZP_1E),y
and text_sprite_buffer+8,x
.value0:ora #$ff
sta (ZP_1E),y
iny

lda (ZP_1E),y
and text_sprite_buffer+8,x
.value1:ora #$ff
sta (ZP_1E),y
iny

inx

rts
}

; Moved here from kernel-ram.asm. Keep all the text sprite stuff in
; the same place...
; 
; Y = offset into text_sprite_data
; A = # 4-byte blocks at the given offset
._set_up_text_sprite
{
; dest offset values used on the C64:
;
; LTOP = $03 - left sprite, row 3
; RTOP = $43 - right sprite, row 3
; LBOT = $21 - left sprite, row 11
; RBOT = $61 - right sprite, row 11

; total BBC buffer size is 2*12*8. < can be handled just by changing
; the offsets, as on the BBC there's a convenient 4 pixels per byte.

; No shift.
LTOPN=$08
RTOPN=$38
LBOTN=$68
RBOTN=$98

; Shift left 4 pixels.
LTOPS=$00
RTOPS=$30
LBOTS=$60
RBOTS=$90

		sty L_1327		;12A9 8C 27 13 data offset
		sta L_1328		;12AC 8D 28 13
		sta ZP_A0		;12AF 85 A0
		txa				;12B1 8A
		pha				;12B2 48
		;ldx #$7f		;12B3 A2 7F

; reset the < flag.

		; lda #$00		;12B5 A9 00
		; sta ZP_18		;12B7 85 18

; clear sprite contents.

  		ldx #text_sprite_buffer_size
		lda #$ff
.L_12B9	sta text_sprite_buffer-1,X ;12B9 9D 80 7F
		dex						 ;12BC CA
		bne L_12B9				 ;12BD 10 FA

.L_12BF

; fetch first byte of block - dest offset in sprite data.

		ldx text_sprite_data,Y	;12BF BE 29 13
		iny				;12C2 C8

; ZP_08 = column counter - each sprite is 24 px/3 chars wide.

		lda #$03		;12C3 A9 03
		sta ZP_08		;12C5 85 08

.L_12C7
		lda text_sprite_data,Y	;12C7 B9 29 13

		cmp #$3C		;12CA C9 3C
		bne L_12D2		;12CC D0 04 taken if not '<'

; ; If a < was seen, shift this row left 4 pixels.

;   		sec
; 		txa:sbc #8:tax

		lda #$20		;12D0 A9 20 pretend it was a space
		
.L_12D2

; convert ASCII->char index

        sec				;12D2 38
		sbc #$20		;12D3 E9 30

; save X+Y.

		sty ZP_C7		;12D5 84 C7
		stx ZP_C6		;12D7 86 C6

; L_1469 = get address of B&W data for font char in ZP_1E

		; jsr L_1469		;12D9 20 69 14

		asl A					; *2
		asl A:rol ZP_14			; *4
		asl A:rol ZP_14			; *8
		clc
		adc #LO(font_data):sta ZP_1E
		lda ZP_14:and #3:adc #HI(font_data):sta ZP_1F
		ldy #0
		
.L_12DC

; copy font char byte into sprite data.

; Do left half.

        lda (ZP_1E),y			 ; abcdefgh
		lsr a:lsr a:lsr a:lsr a	 ; 0000abcd
		sta left_or+1
		lda (ZP_1E),y			 ; abcdefgh
		and #$f0				 ; abcd0000
.left_or:ora #$ff				 ; abcdabcd
        eor #$ff
		sta text_sprite_buffer,x
		
; Do right half.

  	    lda (ZP_1E),y			   ; abcdefgh
		asl a:asl a:asl a:asl a	   ; efgh0000
		sta right_or+1
		lda (ZP_1E),y			   ; abcdefgh
		and #$0f				   ; 0000efgh
.right_or:ora #$ff				   ; efghefgh
        eor #$ff
		sta text_sprite_buffer+8,x

; advance to next row of sprite

  		inx

; next byte of font data - and so on.

		iny				;12E4 C8
		cpy #$08		;12E5 C0 07
		bne L_12DC		;12E7 D0 F3

; restore X+Y.

		ldy ZP_C7		;12E9 A4 C7
		ldx ZP_C6		;12EB A6 C6

; next text sprite data byte

		iny				;12ED C8

; next sprite column

  	   	clc
		txa:adc #16:tax

; 3 columns.

		dec ZP_08		;12EF C6 08
		bne L_12C7		;12F1 D0 D4

; repeat for all blocks of 4 bytes

		dec ZP_A0		;12F3 C6 A0
		bne L_12BF		;12F5 D0 C8

; Check for a row shift offset.

; 		lda ZP_18		;12F7 A5 18
; 		beq L_131F		;12F9 F0 24

; ; < flag was set.

; 		lda #$06		;12FB A9 06
; 		sta ZP_08		;12FD 85 08 shift 6 rows
		
; 		ldx ZP_18		;12FF A6 18

; ; shift row left, 4 times.

; .L_1301	ldy #$04				;1301 A0 04
; .L_1303	asl L_7F80+64+2,X		;1303 1E C2 7F
; 		rol L_7F80+64+1,X		;1306 3E C1 7F
; 		rol L_7F80+64,X			;1309 3E C0 7F
; 		rol L_7F80+2,X			;130C 3E 82 7F
; 		rol L_7F80+1,X			;130F 3E 81 7F
; 		rol L_7F80+0,X			;1312 3E 80 7F
; 		dey				;1315 88
; 		bne L_1303		;1316 D0 EB
; 		inx				;1318 E8
; 		inx				;1319 E8
; 		inx				;131A E8
; 		dec ZP_08		;131B C6 08
; 		bne L_1301		;131D D0 E2
		
; .L_131F

; indicate there's a text sprite set up.

		lda #$80		;131F A9 80
		sta L_C355		;1321 8D 55 C3
		pla				;1324 68
		tax				;1325 AA
		rts				;1326 60

; There doesn't appear to be any way to make defines for the offsets
; in BeebAsm :(
.text_sprite_data
		equb LTOPS,"<WR",RTOPS,"ECK" ; +0   +$00

; the "T" part looks like a bug - when used, A is set to 4 - see
; L_1057.
		equb LTOPN," RA",RTOPN,"CE ",LBOTS,"< W",RBOTS,"ON ",RBOTS,"T  " ; +8 +$08
		equb LTOPN," RA",RTOPN,"CE ",LBOTN," LO",RBOTN,"ST " ; +28  +$1C
		equb LTOPN," DR",RTOPN,"OP ",LBOTS,"<ST",RBOTS,"ART" ; +44  +$2C
		equb LTOPS,"<PR",RTOPS,"ESS",LBOTN," FI",RBOTN,"RE " ; +60  +$3C
		equb LTOPN,"PAU",RTOPN,"SED",""	; +76  +$4C
		equb LTOPN," LA",RTOPN,"PS ",LBOTN," OV",RBOTN,"ER " ; +84  +$54
		equb LTOPN,"DEF",RTOPN,"INE",LBOTN," KE",RBOTN,"YS " ; +100 +$64
		equb LTOPS,"<ST",RTOPS,"EER",LBOTN," LE",RBOTN,"FT " ; +116 +$74
		equb LTOPS," ST",RTOPS,"EER",LBOTS," RI",RBOTS,"GHT" ; +132 +84
		equb LTOPS,"<AH",RTOPS,"EAD",LBOTN,"+BO",RBOTN,"OST" ; +148 +$94
		equb LTOPN," BA",RTOPN,"CK ",LBOTN,"+BO",RBOTN,"OST" ; +164 +$A4
		equb LTOPN," BA",RTOPN,"CK ",LBOTN,"   ",RBOTN,"   " ; +180 +$B4
		equb LTOPN,"VER",RTOPN,"IFY",LBOTN," KE",RBOTN,"YS " ; +196 +$C4
		equb LTOPN," FA",RTOPN,"ULT",LBOTN," FO",RBOTN,"UND" ; +212 +$D4
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Pause mode isn't like in-game mode, but the differences aren't too
; hard to work around...

; Copies contents of front buffer to back buffer, or vice versa, so the 
._graphics_pause_save_screen
{
sec								; front->back
}
.graphics_pause_copy_screen
{
php

clc
lda #$42:adc ZP_12				; read from back buffer
plp:bcc src_msb_ok
eor #$20						; read from front buffer
.src_msb_ok
sta read+2
eor #$20
sta write+2

lda #$a0
sta read+1
sta write+1

ldy #12
.copy_1_row
ldx #0
.copy_1_byte
.read:lda $ffff,x
.write:sta $ffff,x
inx
bne copy_1_byte
inc read+2
inc write+2
dey
bne copy_1_row
rts
}

; Sets up text sprite, restores old screen, draws text sprite (but
; after fiddling with ZP_12, so the drawing temporarily goes to the
; front buffer...).
._graphics_pause_show_text_sprite
{
jsr _set_up_text_sprite
clc:jsr graphics_pause_copy_screen ; back->front

lda ZP_12:eor #$20:sta ZP_12
jsr _graphics_draw_in_game_text_sprites
lda ZP_12:eor #$20:sta ZP_12
rts
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._ensure_screen_enabled
{
lda #CRTC_R8_DisplayEnableValue
bne set_r8_value				; will always be non-zero due to the
								; cursor bits
}

._disable_screen
{
lda #CRTC_R8_DisplayDisableValue
}

.set_r8_value
{
sta irq_handler_load_r8_value+1
lda vsync_counter:.loop:cmp vsync_counter:beq loop
rts
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._beeb_set_mode_1
{
    lda #13:sta beeb_max_crtc_reg
    LDX #LO(beeb_mode1_crtc_regs)
    LDY #HI(beeb_mode1_crtc_regs)
    JSR beeb_set_crtc_regs

    \\ BEEB ULA SET MODE 1
    LDA #ULA_MODE_1			; 80 chars per line @ 2bpp
    STA &FE20

    \\ BEEB SHADOW
    LDA &FE34
    ORA #5          ; page in SHADOW and display SHADOW
    STA &FE34

    \\ BEEB ULA SET PALETTE
    LDX #LO(beeb_mode5_palette)
    LDY #HI(beeb_mode5_palette)
    JMP beeb_set_palette
	
.beeb_mode1_crtc_regs
{
	EQUB 127				; R0  horizontal total
	EQUB 80					; R1  horizontal displayed
	EQUB 98					; R2  horizontal position
	EQUB &28				; R3  sync width 40 = &28
	EQUB 38					; R4  vertical total
	EQUB 0					; R5  vertical total adjust
	EQUB 25					; R6  vertical displayed
	EQUB 32					; R7  vertical position; 35=top of screen
	EQUB &0					; R8  interlace; &30 = HIDE SCREEN
	EQUB 7					; R9  scanlines per row
	EQUB 32					; R10 cursor start
	EQUB 8					; R11 cursor end
	EQUB HI(screen1_address/8)	; R12 screen start address, high
	EQUB LO(screen1_address/8)	; R13 screen start address, low
}

}

.beeb_set_mode_2
{
lda #13:sta beeb_max_crtc_reg
ldx #lo(beeb_mode2_crtc_regs)
ldy #hi(beeb_mode2_crtc_regs)
jsr beeb_set_crtc_regs

lda #ULA_MODE_2:sta $fe20

; Page in shadow RAM, display shadow RAM
lda $fe34:ora #5:sta $fe34

; Palette.
lda #0
clc
.loop
tax
eor #7:sta $fe21
txa
adc #$11
bcc loop

rts

.beeb_mode2_crtc_regs
{
	EQUB 127				; R0  horizontal total
	EQUB 80					; R1  horizontal displayed
	EQUB 98					; R2  horizontal position
	EQUB &28				; R3  sync width 40 = &28
	EQUB 38					; R4  vertical total
	EQUB 0					; R5  vertical total adjust
	EQUB 32					; R6  vertical displayed
	EQUB 35					; R7  vertical position; 35=top of screen
	EQUB &0					; R8  interlace; &30 = HIDE SCREEN
	EQUB 7					; R9  scanlines per row
	EQUB 32					; R10 cursor start
	EQUB 8					; R11 cursor end
	EQUB HI($3000/8)		; R12 screen start address, high
	EQUB LO($3000/8)		; R13 screen start address, low
}
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

._graphics_show_credits_screen
{
jsr disable_screen
jsr beeb_set_mode_2

ldx #lo(credits_screen):ldy #hi(credits_screen)
lda #$30
jsr PUCRUNCH_UNPACK
jsr ensure_screen_enabled

jsr debounce_fire_and_wait_for_fire
; .keys_loop
; lda #$7a:jsr osbyte
; cpx #$ff:beq keys_loop

jsr disable_screen

; copy $3000-$3fff back from main RAM to shadow RAM.
lda #$30:sta load_main+2:sta store_shadow+2

ldx #0
.copy_main_ram_to_shadow_ram_loop
lda $fe34:and #%11111011:sta $fe34 ; page in main RAM
.load_main:lda $ff00,x
pha

lda $fe34:ora #%00000100:sta $fe34 ; page in shadow RAM
pla
.store_shadow:sta $ff00,x
inx
bne copy_main_ram_to_shadow_ram_loop
inc load_main+2
inc store_shadow+2
lda store_shadow+2
cmp #$40
bne copy_main_ram_to_shadow_ram_loop

jsr beeb_set_mode_1
rts
}

.page_in_shadow_RAM
{
pha
lda $fe34:ora #%00000100:sta $fe34 ; page in shadow RAM
pla
rts
}

.page_in_main_RAM
{
pha
lda $fe34:and #%11111011:sta $fe34 ; page in main RAM
pla
rts
}

.unpack_mode7
{
stx reload_x+1:sty reload_y+1

lda #19:jsr osbyte

; disabled output + interlace sync/video
lda #8:sta $fe00:lda #%11110011:sta $fe01

jsr page_in_shadow_RAM

; Unpack keys screen
.reload_x:ldx #$ff
.reload_y:ldy #$ff
lda #$7c
jsr PUCRUNCH_UNPACK

jsr page_in_main_RAM

; Seems to take my TV nearly half a second to fully settle down after
; the mode change, presumably due to the change in interlace
; sync/video mode. 3 vsyncs is enough to avoid the worst of it.
;
; (The picture still adjusts itself slightly, but when the other
; option is a half second pause, it's fine.)

lda #3:sta nvsyncs
.loop
lda #19:jsr osbyte
dec nvsyncs:bne loop

; enable output + interlace sync/video
lda #8:sta $fe00:lda #%11010011:sta $fe01

rts

.nvsyncs:equb 0

}

; assumes main RAM is paged in and shadow RAM is displayed.
._graphics_show_keys_screen
{
; disable key repeat
lda #11:ldx #0:jsr osbyte

; flush all buffers
lda #15:ldx #0:jsr osbyte

lda #$e1:jsr setup_fkeys		  ; f keys
lda #$e2:jsr setup_fkeys		  ; f keys+shift
lda #$e3:jsr setup_fkeys		  ; f keys+ctrl
lda #$e4:jsr setup_fkeys		  ; f keys+shift+ctrl
lda #229:ldx #1:ldy #0:jsr osbyte ; disable Escape

; disable screen
lda #19:jsr osbyte
lda #8:sta $fe00:lda #$30:sta $fe01

lda #13:sta beeb_max_crtc_reg
ldx #lo(beeb_mode7_crtc_regs)
ldy #hi(beeb_mode7_crtc_regs)
jsr beeb_set_crtc_regs

lda #ULA_MODE_7:sta $fe20

; Keys screen loop.

.keys_screen
ldx #lo(keys_screen_pu):ldy #hi(keys_screen_pu):jsr unpack_mode7

jsr osrdch

and #$df
cmp #'T':beq trainer_screen

.screens_done
lda #19:jsr osbyte

; disable screen
lda #8:sta $fe00:lda #$30:sta $fe01

rts

; Trainer screen loop.

.trainer_screen
{
ldx #lo(trainer_screen_pu):ldy #hi(trainer_screen_pu):jsr unpack_mode7

.trainer_screen_loop

; draw flags on screen, and apply cheats.

lda #19:jsr osbyte

disabled_message_y=7
disabled_addr=$7c00+(disabled_message_y-1)*40

trainer_x=34
trainer_y=10
last_addr=$7c00+trainer_x+(trainer_y+(num_trainers-1)*2)*40
lda #<last_addr:sta ZP_20
lda #>last_addr:sta ZP_21

; sneakily hide the 'load/save disabled' message with a misplaced
; double height code.
jsr page_in_shadow_RAM
lda #141:sta disabled_addr
jsr page_in_main_RAM

ldy #num_trainers-1
{
.trainers_loop
tya:pha

lda trainer_flags,y:asl a:lda #0:rol a:tax:beq show_state

; at least one cheat is on, so unhide the load/save disabled message.
jsr page_in_shadow_RAM
lda #0:sta disabled_addr
jsr page_in_main_RAM

.show_state
ldy #0
jsr page_in_shadow_RAM
lda trainer_onoff+0,x:sta (ZP_20),y:iny
lda trainer_onoff+2,x:sta (ZP_20),y:iny
lda trainer_onoff+4,x:sta (ZP_20),y:iny
jsr page_in_main_RAM

sec
lda ZP_20:sbc #80:sta ZP_20
lda ZP_21:sbc #0:sta ZP_21

pla:tay:dey
bpl trainers_loop
}

jsr osrdch:tax

and #$df:cmp #'I':bne not_keys_screen:jmp keys_screen:.not_keys_screen

txa:and #$f0:cmp #$10:beq handle_f_key

jmp screens_done

.handle_f_key
txa:and #$0f:cmp #num_trainers:bcs trainer_screen_loop
tay
lda trainer_flags,y:eor #$80:sta trainer_flags,y
jmp trainer_screen_loop
}

.trainer_onoff:equb "OOfnf "

.setup_fkeys
ldx #16							; produce 16+n for f key n
ldy #0							; replace old value
jmp osbyte
}

.beeb_mode7_crtc_regs
{
	EQUB 63					; R0  horizontal total
	EQUB 40					; R1  horizontal displayed
	EQUB 51					; R2  horizontal position
	EQUB &24				; R3  sync width 40 = &28
	EQUB 30					; R4  vertical total
	EQUB 2					; R5  vertical total adjust
	EQUB 25					; R6  vertical displayed
	EQUB 27					; R7  vertical position; 35=top of screen
	EQUB $30				; R8  interlace; &30 = HIDE SCREEN
	EQUB 18					; R9  scanlines per row
	EQUB 32					; R10 cursor start
	EQUB 8					; R11 cursor end
	EQUB $28				; R12 screen start address, high
	EQUB $00				; R13 screen start address, low
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.beeb_graphics_end
