#!/usr/bin/python
import png,argparse,sys,math

##########################################################################
##########################################################################

gamma=2.2

bbc_colours=[(255 if (i&1)!=0 else 0,
              255 if (i&2)!=0 else 0,
              255 if (i&4)!=0 else 0) for i in range(8)]

def find_closest_bbc_colour(p):
    assert p[0]>=0 and p[0]<=255
    assert p[1]>=0 and p[1]<=255
    assert p[2]>=0 and p[2]<=255
    
    p=[int(math.pow(p[0]/255.0,gamma)*255),
       int(math.pow(p[1]/255.0,gamma)*255),
       int(math.pow(p[2]/255.0,gamma)*255)]

    best=None
    best_dist_sq=None
    
    for bbc_colour in bbc_colours:
        dr=p[0]-bbc_colour[0]
        dg=p[1]-bbc_colour[1]
        db=p[2]-bbc_colour[2]
        dist_sq=dr*dr+dg*dg+db*db

        if best_dist_sq is None or dist_sq<best_dist_sq:
            best_dist_sq=dist_sq
            best=bbc_colour

    return best

def pack_4bpp(pixels):
    assert len(pixels)==2,pixels
    for i in range(2): assert pixels[i]>=0 and pixels[i]<=15

    return ((pixels[0]>>3&1)<<7|
            (pixels[1]>>3&1)<<6|
            (pixels[0]>>2&1)<<5|
            (pixels[1]>>2&1)<<4|
            (pixels[0]>>1&1)<<3|
            (pixels[1]>>1&1)<<2|
            (pixels[0]>>0&1)<<1|
            (pixels[1]>>0&1)<<1)

def pack_2bpp(pixels):
    assert len(pixels)==4,pixels
    for i in range(4): assert pixels[i]>=0 and pixels[i]<=3

    return ((pixels[0]>>1&1)<<7|
            (pixels[1]>>1&1)<<6|
            (pixels[2]>>1&1)<<5|
            (pixels[3]>>1&1)<<4|
            (pixels[0]>>0&1)<<3|
            (pixels[1]>>0&1)<<2|
            (pixels[2]>>0&1)<<1|
            (pixels[3]>>0&1)<<0)

def pack_1bpp(pixels):
    assert len(pixels)==8,pixels
    for i in range(8): assert pixels[i]==0 or pixels[i]==1

    return (pixels[0]<<7|
            pixels[1]<<6|
            pixels[2]<<5|
            pixels[3]<<4|
            pixels[4]<<3|
            pixels[5]<<2|
            pixels[6]<<1|
            pixels[7]<<0)

##########################################################################
##########################################################################

def main(options):
    if options.mode<0 or options.mode>6:
        print>>sys.stderr,'FATAL: invalid mode: %d'%options.mode
        sys.exit(1)

    if options.mode!=5:
        print>>sys.stderr,'FATAL: only mode 5 for now...'
        sys.exit(1)

    if options.palette is None:
        palette=[0,1,3,7]
    else:
        if options.mode in [0,3,4,6]: n=2
        elif options.mode in [1,5]: n=4
        elif options.mode==2: n=8
        if len(options.palette)!=n:
            print>>sys.stderr,'FATAL: invalid mode %d palette - must have %d entries'%(options.mode,n)
            sys.exit(1)

        palette=[]
        for i in range(len(options.palette)):
            if options.palette[i] not in "01234567":
                print>>sys.stderr,'FATAL: invalid BBC colour: %s'%options.palette[i]
                sys.exit(1)

            for j in range(len(options.palette)):
                if i!=j and options.palette[i]==options.palette[j]:
                    print>>sys.stderr,'FATAL: duplicate BBC colour: %s'%options.palette[i]
                    sys.exit(1)

            palette.append(int(options.palette[i]))

    png_result=png.Reader(filename=options.input_path).asRGBA()
    
    png_width=png_result[0]
    png_height=png_result[1]

    if png_height%4!=0:
        print>>sys.stderr,'FATAL: image height must be a multiple of 4'
        sys.exit(1)
        
    if png_height%8!=0:
        print>>sys.stderr,'FATAL: image height must be a multiple of 8'
        sys.exit(1)

    # Replace the png library business with tuples.
    png_pixels=[]
    for src_row in png_result[2]:
        png_pixels.append([])
        for i in range(0,len(src_row),4):
            png_pixels[-1].append((src_row[i+0],
                                   src_row[i+1],
                                   src_row[i+2],
                                   src_row[i+3]))

    # Halve width, if necessary.
    if options._160:
        good=True
        for y in range(len(png_pixels)):
            row=[]
            for x in range(0,len(png_pixels[y]),2):
                if png_pixels[y][x+0]!=png_pixels[y][x+1]:
                    print>>sys.stderr,'FATAL: pixel at (%d,%d) is different from pixel at (%d,%d)'%(x+0,y,x+1,y)
                    good=False

                row.append(png_pixels[y][x+0])

            png_pixels[y]=row

        if not good: sys.exit(1)

    # Convert into BBC physical indexes: 0-7, and -1 for transparent
    # (going by the alpha channel value).
    bbc_lidxs=[]
    for y in range(len(png_pixels)):
        bbc_lidxs.append([])
        for x in range(len(png_pixels[y])):
            p=png_pixels[y][x]
            lidx=None

            if p[3]<128 or (options.transparent_rgb is not None and
                            p[0]==options.transparent_rgb[0] and
                            p[1]==options.transparent_rgb[1] and
                            p[2]==options.transparent_rgb[2]):
                # transparent pixel
                if options.transparent_output is None:
                    print>>sys.stderr,'FATAL: transparent pixel at (%d,%d): %s'%(x,y,p)
                    sys.exit(1)

                lidx=options.transparent_output
            else:
                # opaque pixel
                for i in range(3):
                    if p[i]!=0 and p[i]!=255:
                        p=find_closest_bbc_colour(p)
                        print>>sys.stderr,'WARNING: non-BBC Micro colour %s at (%d,%d) - using %s'%(png_pixels[y][x],x,y,p)
                        break

                pidx=bbc_colours.index((p[0],p[1],p[2]))
                try:
                    lidx=palette.index(pidx)
                except ValueError:
                    print>>sys.stderr,'FATAL: (%d,%d): colour %d not in BBC palette'%(x,y,pidx)
                    sys.exit(1)
                        
            bbc_lidxs[-1].append(lidx)
            
    data=[]
    for y in range(0,len(bbc_lidxs),8):
        for x in range(0,len(bbc_lidxs[y]),4):
            for line in range(8):
                data.append(pack_2bpp(bbc_lidxs[y+line][x+0:x+4]))

    print '%d bytes BBC data'%len(data)

    if options.output_path is not None:
        with open(options.output_path,'wb') as f:
            f.write(''.join([chr(x) for x in data]))

        if options.inf:
            with open('%s.inf'%options.output_path,'wt') as f: pass

##########################################################################
##########################################################################

if __name__=='__main__':
    parser=argparse.ArgumentParser()

    parser.add_argument('-o',dest='output_path',metavar='FILE',help='output BBC data to %(metavar)s')
    parser.add_argument('--inf',action='store_true',help='if -o specified, also produce a 0-byte .inf file')
    parser.add_argument('--160',action='store_true',dest='_160',help='double width (Mode 5/2) aspect ratio')
    parser.add_argument('-p','--palette',help='specify BBC palette')
    parser.add_argument('--transparent-output',
                        default=None,
                        type=int,
                        help='specify output index to use for transparent PNG pixels')
    parser.add_argument('--transparent-rgb',
                        default=None,
                        type=int,
                        nargs=3,
                        help='specify opaque RGB to be interpreted as transparent')
    parser.add_argument('input_path',metavar='FILE',help='load PNG data fro %(metavar)s')
    parser.add_argument('mode',type=int,help='screen mode')
    main(parser.parse_args())
