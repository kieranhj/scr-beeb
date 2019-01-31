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

    with open('./build/scr-beeb-hud.dat','rb') as f: hud=f.read()

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

    path='./build/scr-beeb-preview.dat'
    with open(path,'wb') as f:
        f.write(pack(image,0,0,len(image[0]),len(image)))

    print 'track_preview_bg_height=%d'%bg_height

    # Merge track preview background and HUD, so there's just one block to
    # unpack, that can overwrite the HUD.
    # 
    # (This is about 300 bytes packed, and basically no code to
    # decompress, compared to 352 bytes, plus a little loop, and a
    # table, to carefully unpack each row of the background into the
    # right place without touching anything.)
    bg2=''
    for row in range((bg_height+7)//8):
        i=0x280+row*320
        bg2+=hud[i:i+32]
        bg2+=pack(area,0,row*8,len(area[0]),8)
        bg2+=hud[i+288:i+320]

    with open('./build/scr-beeb-preview-bg.dat','wb') as f: f.write(bg2)

##########################################################################
##########################################################################

if __name__=='__main__':
    parser=argparse.ArgumentParser()

    parser.add_argument('--pucrunch',
                        metavar='FILE',
                        default='pucrunch',
                        help='path to pucrunch. Default: %(default)s')

    main(parser.parse_args())
