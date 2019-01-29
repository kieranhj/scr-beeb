#!/usr/bin/python
import bbc,argparse,os,sys

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

    return ''.join([chr(x) for x in data])

def equb(data,stride):
    n=0
    for i in range(0,len(data),stride):
        print 'equb %s ; %d, +%d '%(','.join(['$%02x'%byte for byte in data[i:i+stride]]),
                                    n,
                                    i)
        n+=1

def pucrunch(path,options):
    cmd='"%s" -5 -d -c0 -l0x1000 "%s" "%s.pu"'%(options.pucrunch,
                                                path,
                                                path)
    print>>sys.stderr,'%s'%cmd
    if os.system(cmd)!=0:
        print>>sys.stderr,'FAILED: %s'%cmd
        sys.exit(1)
        
def main(options):
    image=bbc.load_png('./graphics/scr-beeb-preview.png',5,True)

    if len(image)!=160 or len(image[0])!=160:
        raise Exception('image not 160x160')

    # convert to Stunt Car Racer palette
    for y in range(len(image)):
        for x in range(len(image[0])):
            if image[y][x]==4: image[y][x]=2

    # Copy the preview area, which is the middle 128x128.
    area=image[16:144]
    for y in range(len(area)): area[y]=area[y][16:144]

    # Figure out height of the background.
    bg_height=len(area)

    # Find first solid yellow line.
    while area[bg_height-1].count(3)!=len(area[bg_height-1]): bg_height-=1

    # Find last solid yellow line.
    while area[bg_height-1].count(3)==len(area[bg_height-1]): bg_height-=1

    print 'bg_height=%d'%bg_height

    # Round up to an even number of rows.
    # bg_height=(bg_height+7)//8*8

    # Fill the original image's background area with yellow.
    # Skip row 0, as it's known to be all black.
    for y in range(1,bg_height):
        line=image[16+y]

        num_black=0
        for x in range(0,128):
            if line[16+x]==0: num_black+=1

        x0=16+0
        x1=16+128
        
        if num_black>0 and num_black!=128:
            while line[x0]==0: x0+=1
            while line[x1-1]==0: x1-=1

        assert x1>=x0

        # print 'y=%d x0=%d x1=%d'%(y,x0,x1)
        for x in range(x0,x1): line[x]=3

    # print '; bg height=%d'%area_height

    path='./build/beeb-preview.dat'
    with open(path,'wb') as f:
        f.write(pack(image,0,0,len(image[0]),len(image)))

    pucrunch(path,options)
    
    print '.track_preview_screen'
    print 'incbin "%s.pu"'%path

    for row in range((bg_height+7)//8):
        path='./build/beeb-preview-bg-%d.dat'%row
        
        with open(path,'wb') as f:
            f.write(pack(area,0,row*8,len(area[0]),8))

        pucrunch(path,options)

        print '.track_preview_bg_row_%d'%row
        print 'incbin "%s.pu"'%path

##########################################################################
##########################################################################

if __name__=='__main__':
    parser=argparse.ArgumentParser()

    parser.add_argument('--pucrunch',
                        metavar='FILE',
                        default='pucrunch',
                        help='path to pucrunch. Default: %(default)s')

    main(parser.parse_args())
