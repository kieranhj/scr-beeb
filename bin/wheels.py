#!/usr/bin/python
import os,sys,bbc,argparse

##########################################################################
##########################################################################

def load_file(path):
    with open(path,'rb') as f: return [ord(x) for x in f.read()]

##########################################################################
##########################################################################

def get_offset(x,y): return (y//8)*320+(y%8)+(x//4)*8

def get_byte(data,x,y):
    assert x%4==0
    offset=get_offset(x,y)
    return bbc.pack_2bpp(data[offset:offset+4])

def equb(values):
    return 'equb %s ; n=%d'%(','.join(['$%02x'%x for x in values]),
                             len(values))

def create_engine_redraw_tables(hud,
                                hud_mask,
                                side,
                                start_column):
    values=[]
    masks=[]

    # Only copy the first 2 rows of the engine. The 3rd row is in the
    # single-buffered part, and is handled separately to reduce
    # flicker.
    for row in range(2):
        addr=(17+row)*320+start_column*8
        masks+=hud_mask[addr:addr+24]
        values+=hud[addr:addr+24]

    for i in range(len(values)): values[i]&=~masks[i]

    print '.engine_%s_masks'%side
    print equb(masks)

    print '.engine_%s_values'%side
    print equb(values)

##########################################################################
##########################################################################

def create_wheel_side_tables(side,images):
    for frame,image in enumerate(images):
        values=[]
        masks=[]

        for y in range(len(image)):
            for x in range(0,len(image[y]),4):
                pixels=image[y][x:x+4]

                values.append(bbc.pack_2bpp([0 if pixel==-1 else pixel
                                             for pixel in pixels]))
                masks.append(bbc.pack_2bpp([3 if pixel==-1 else 0
                                            for pixel in pixels]))

        for i in range(len(masks)): values[i]&=~masks[i]

        print '.wheel_%s_%d_data'%(side,frame)
        print '; masks'
        print equb(masks)
        print 'IF P%%<>wheel_%s_%d_data+wheel_data_size:ERROR "oops":ENDIF'%(side,frame)
        print '; values'
        print equb(values)
        print 'IF P%%<>wheel_%s_%d_data+wheel_data_size*2:ERROR "oops":ENDIF'%(side,frame)

def create_wheel_tables():
    # Load wheel sprites.
    images=[]
    paths=[]
    
    for side in ['left','right']:
        for frame in range(3):
            image_path='./graphics/wheel_%s_%d.png'%(side,frame)
            image=bbc.load_png(image_path,5,True,-1,(255,0,255))

            if len(image)!=42 or len(image[0])!=12:
                raise Exception('%s: not 24x42'%image_path)

            # convert to Stunt Car Racer palette.
            for y in range(len(image)):
                for x in range(len(image[y])):
                    if image[y][x]==4: image[y][x]=2

            # The wheels are drawn row by row, so if there are any
            # completely transparent rows at the bottom, strip them
            # off.
            while image[-1].count(-1)==len(image[-1]): del image[-1]

            images.append(image)
            paths.append(image_path)

    for i in range(1,len(images)):
        # All images must be the same size.
        if (len(images[i])!=len(images[0]) or
            len(images[i][0])!=len(images[0][0])):
            raise Exception('%s: opaque area is %dx%d, not %dx%d'%
                            (paths[i],
                             len(images[i][0]),len(images[i]),
                             len(images[0][0]),len(images[0])))

    # 3 bytes/row.
    wheel_min_sprite_y=151      # in VIC sprite coordinates
    wheel_end_sprite_y=19*8+50  # in VIC sprite coordinates
    hud_bottom_sprite_y=20*8+50  # in VIC sprite coordinates

    print 'wheel_data_size=%d'%(len(images[0])*3)
    print 'wheel_min_sprite_y=%d'%wheel_min_sprite_y
    print 'wheel_end_sprite_y=%d'%wheel_end_sprite_y
    print 'hud_bottom_sprite_y=%d'%hud_bottom_sprite_y

    create_wheel_side_tables('left',images[0:3])
    create_wheel_side_tables('right',images[3:6])

    # # Additional blank data.
    # max_num_blank_lines=wheel_end_sprite_y-(wheel_min_sprite_y+len(images[0]))
    # print '.wheel_blank_masks_and_values'
    # print equb(max_num_blank_lines*[0,0,0])
    # print 'wheel_blank_data_size=%d'%(max_num_blank_lines*3)

    # Row address tables.
    addrs=[]
    for y in range(wheel_min_sprite_y,wheel_end_sprite_y):
        screen_y=y-50
        if screen_y>=19*8:
            addrs.append(0x77e0+get_offset(0,screen_y-19*8))
        else:
            addrs.append(0x4020+get_offset(0,screen_y))

    print '.wheel_row_ptrs_LO'
    print equb([addr&0xff for addr in addrs])

    print '.wheel_row_ptrs_HI'
    print equb([addr>>8 for addr in addrs])
        
##########################################################################
##########################################################################

def main(options):
    hud=load_file('./build/scr-beeb-hud.dat')
    hud_mask=load_file('./build/scr-beeb-hud-mask.dat')

    # Create tables for redrawing the bits of the engine that the
    # wheels may overlap.
    create_engine_redraw_tables(hud,hud_mask,'left',4)
    create_engine_redraw_tables(hud,hud_mask,'right',33)

    # Create wheel sprite tables.
    create_wheel_tables()

    print 'hud_left_corner_byte=$%02x'%hud[19*320+6+32]
    print 'hud_right_corner_byte=$%02x'%hud[19*320+6+32+248]



##########################################################################
##########################################################################

if __name__=='__main__':
    parser=argparse.ArgumentParser()

    main(parser.parse_args())
