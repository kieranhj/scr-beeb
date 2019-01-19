.beeb_graphics_start

include "build/flames-tables.asm"

.draw_flames
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
adc #HI(initial_unmasked_write_offset)
sta unmasked_write+2

ldy #LO(initial_unmasked_write_offset)

.unmasked_loop

.unmasked_read:lda $ffff,x
.unmasked_write:sta $ff00,y

tya
adc unmasked_deltas,x
bcc unmasked_noc
inc unmasked_write+2
clc
.unmasked_noc

inx

cpx #unmasked_writes_size
bne unmasked_loop

; masked

clc
lda ZP_12
adc #HI(initial_masked_write_offset)
sta masked_read+2
sta masked_write+2

ldy #LO(initial_masked_write_offset)

.masked_loop

.masked_read:lda $ff00,y
.masked_mask:and $ffff,x
.masked_value:ora $ffff,x
.masked_write:sta $ff00,y

tya
adc masked_deltas,x
bcc masked_noc
inc masked_read+2
inc masked_write+2
clc
.masked_noc

inx

cpx #masked_writes_size
bne masked_loop

rts

.unmasked_tables
equw unmasked_flame_table_0
equw unmasked_flame_table_1
equw unmasked_flame_table_2

.masked_values_tables
equw masked_flame_value_table_0
equw masked_flame_value_table_1
equw masked_flame_value_table_2

.masked_masks_tables
equw masked_flame_mask_table_0
equw masked_flame_mask_table_1
equw masked_flame_mask_table_2
}

.beeb_graphics_end
