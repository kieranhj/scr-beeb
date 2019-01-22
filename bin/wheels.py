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
    for row in range(3):
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

def create_wheel_tables(side):
    for frame in range(3):
        image_path='./graphics/wheel_%s_%d.png'%(side,frame)
        image=bbc.load_png(image_path,5,True,-1,(255,0,255))

        if len(image)!=42 or len(image[0])!=12:
            raise Exception('%s: not 24x42'%image_path)

        # convert to Stunt Car Racer palette.
        for y in range(len(image)):
            for x in range(len(image[y])):
                if image[y][x]==4: image[y][x]=2

        values=[]
        masks=[]
        
        for y in range(len(image)):
            for x in range(0,len(image[y]),4):
                pixels=image[y][x:x+4]

                values.append(bbc.pack_2bpp([0 if pixel==-1 else pixel
                                             for pixel in pixels]))
                masks.append(bbc.pack_2bpp([3 if pixel==-1 else pixel
                                            for pixel in pixels]))

        print '.wheel_%s_%d_masks'%(side,frame)
        print equb(masks)
                
        print '.wheel_%s_%d_values'%(side,frame)
        print equb(values)
        
def create_wheel_rows_tables():
    wheel_min_sprite_y=151      # in VIC sprite coordinates
    wheel_end_sprite_y=20*8+50  # in VIC sprite coordinates

    print 'wheel_min_sprite_y=%d'%wheel_min_sprite_y
    print 'wheel_end_sprite_y=%d'%wheel_end_sprite_y
    
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
    create_wheel_tables('left')
    create_wheel_tables('right')
    create_wheel_rows_tables()


##########################################################################
##########################################################################

if __name__=='__main__':
    parser=argparse.ArgumentParser()

    main(parser.parse_args())
