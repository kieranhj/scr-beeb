#!/usr/bin/python
import bbc,argparse

dest=0x42a0

##########################################################################
##########################################################################

def get_addr(x,y): return (y>>3)*320+(y&7)+(x//4)*8

def pack(image,x,y,w,h):
    assert x%4==0
    assert y%8==0
    assert w%4==0
    assert h%8==0

    data=[]

    for dy in range(0,h,8):
        for dx in range(0,w,4):
            for scanline in range(0,8):
                data.append(bbc.pack_2bpp(image[y+dy+scanline][x+dx:x+dx+4]))

    return data

def equb(data,stride):
    n=0
    for i in range(0,len(data),stride):
        print 'equb %s ; %d, +%d '%(','.join(['$%02x'%byte for byte in data[i:i+stride]]),
                                    n,
                                    i)
        n+=1

def main(options):
    image=bbc.load_png('./graphics/scr-beeb-preview.png',5,True)

    if len(image)!=160 or len(image[0])!=160:
        raise Exception('image not 160x160')

    # convert to Stunt Car Racer palette
    for y in range(len(image)):
        for x in range(len(image[0])):
            if image[y][x]==4: image[y][x]=2

    # (0,0) + 160 x 16 top border
    # (0,144) + 160 x 16 bottom border
    # (0,16) + 16 x 128 left border
    # (144,16) + 16 x 128 right border

    borders={
        'top':pack(image,0,0,160,16),
        'bottom':pack(image,0,144,160,16),
        'left':pack(image,0,16,16,128),
        'right':pack(image,144,16,16,128),
    }

    for name,data in borders.iteritems():
        print
        print '.%s_border_data ; %d bytes'%(name,len(data))
        equb(data,8)

    # Pick out the middle 128x128.
    area=image[16:144]
    for y in range(len(area)): area[y]=area[y][16:144]

    # Generate code to mask off the top corners after the screen has
    # been cleared.
    # 
    # (The top and bottom lines are known to be all blank.)
    area_height=128
    print
    print '.preview_initialise_corners'
    for x in [0,124]:
        side='left' if x<64 else 'right'
        # Top corners - mask out the black pixels, purely to keep the
        # shape.
        print '; top %s'%side
        y=1
        while True:
            mask_pixels=[0 if pixel==0 else 3 for pixel in area[y][x:x+4]]
            if 0 not in mask_pixels: break

            mask=bbc.pack_2bpp(mask_pixels)
            addr=0x42a0+get_addr(x,y)

            print 'lda $%04x:and #$%02x:sta $%04x'%(addr,mask,addr)
            y+=1

        # Bottom corners - add in the non-yellow pixels, because
        # there's some extra detail.
        print '; bottom %s'%side
        y=126
        while True:
            pixels=area[y][x:x+4]
            if pixels.count(3)==4:
                area_height=min(area_height,y)
                break

            value=bbc.pack_2bpp(pixels)
            addr=0x42a0+get_addr(x,y)
            print 'lda #$%02x:sta $%04x'%(value,addr)

            y-=1

    print 'rts'

    # Arrange the backdrop in columns.
    while area[area_height].count(3)==len(area[area_height]): area_height-=1

    # Adjust background so it's an even number of character rows.
    area_height=(area_height+7)//8*8

    print 'preview_area_background_height=%d'%area_height

    print 
    print '.preview_area_background_data'
    equb(pack(area,0,0,128,area_height),8)
            

##########################################################################
##########################################################################

if __name__=='__main__':
    parser=argparse.ArgumentParser()

    main(parser.parse_args())
