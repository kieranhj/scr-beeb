.beeb_graphics_start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "build/flames-tables.asm"

.menu_header_graphic_begin
incbin "build/scr-beeb-header.dat"
skip 2560						; book space for the Mode 1 version...
.menu_header_graphic_end

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

.beeb_graphics_end
