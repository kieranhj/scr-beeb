import math,png,sys

##########################################################################
##########################################################################

gamma=2.2

##########################################################################
##########################################################################

rgbs=[(255 if (i&1)!=0 else 0,
       255 if (i&2)!=0 else 0,
       255 if (i&4)!=0 else 0) for i in range(8)]

##########################################################################
##########################################################################

def find_closest_rgb(p):
    assert p[0]>=0 and p[0]<=255
    assert p[1]>=0 and p[1]<=255
    assert p[2]>=0 and p[2]<=255
    
    p=[int(math.pow(p[0]/255.0,gamma)*255),
       int(math.pow(p[1]/255.0,gamma)*255),
       int(math.pow(p[2]/255.0,gamma)*255)]

    best=None
    best_dist_sq=None
    
    for rgb in rgbs:
        dr=p[0]-rgb[0]
        dg=p[1]-rgb[1]
        db=p[2]-rgb[2]
        dist_sq=dr*dr+dg*dg+db*db

        if best_dist_sq is None or dist_sq<best_dist_sq:
            best_dist_sq=dist_sq
            best=rgb

    return best

##########################################################################
##########################################################################

def unpack_2bpp(byte):
    return [((byte>>7&1)<<1|byte>>3&1),
            ((byte>>6&1)<<1|byte>>2&1),
            ((byte>>5&1)<<1|byte>>1&1),
            ((byte>>4&1)<<1|byte>>0&1)]

##########################################################################
##########################################################################

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
            (pixels[1]>>0&1)<<0)

##########################################################################
##########################################################################

def pack_2bpp(pixels):
    assert len(pixels)==4,pixels
    for i in range(4): assert pixels[i]>=0 and pixels[i]<=3,(pixels,i)

    return ((pixels[0]>>1&1)<<7|
            (pixels[1]>>1&1)<<6|
            (pixels[2]>>1&1)<<5|
            (pixels[3]>>1&1)<<4|
            (pixels[0]>>0&1)<<3|
            (pixels[1]>>0&1)<<2|
            (pixels[2]>>0&1)<<1|
            (pixels[3]>>0&1)<<0)

##########################################################################
##########################################################################

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

def load_png(path,
             mode,
             halve_width=False,
             transparent_physical_index=None,
             transparent_rgb=None,
             print_warnings=True):
    '''loads PATH, a PNG representing a BBC screen in mode MODE, returning
    a 2d array of BBC physical colour indexes for the caller to disentangle.

TRANSPARENT_PHYSICAL_INDEX, if not None, is the value to produce for
transparent pixels.

TRANSPARENT_RGB is the opaque RGB value, if any, to treat as
transparent.

    '''
    png_result=png.Reader(filename=path).asRGBA()

    width=png_result[0]
    height=png_result[1]

    pixels=[]
    for row in png_result[2]:
        pixels.append([])
        for x in range(0,len(row),4):
            pixels[-1].append((row[x+0],row[x+1],row[x+2],row[x+3]))

    if halve_width:
        good=True
        for y in range(len(pixels)):
            row=[]
            for x in range(0,len(pixels[y]),2):
                if pixels[y][x+0]!=pixels[y][x+1]:
                    print>>sys.stderr,'pixel at (%d,%d) is different from pixel at (%d,%d)'%(x+0,y,x+1,y)
                    good=False

                row.append(pixels[y][x+0])

            pixels[y]=row

        if not good: raise ValueError('image not suitable for width halving')

    pidxs=[]
    for y in range(len(pixels)):
        pidxs.append([])
        for x in range(len(pixels[y])):
            p=pixels[y][x]

            if p[3]<128 or (transparent_rgb is not None and
                            p[0]==transparent_rgb[0] and
                            p[1]==transparent_rgb[1] and
                            p[2]==transparent_rgb[2]):
                if transparent_physical_index is None:
                    raise ValueError('invalid transparency')

                pidx=transparent_physical_index
            else:
                for i in range(3):
                    if p[i]!=0 and p[i]!=255:
                        p=find_closest_rgb(p)
                        if print_warnings:
                            print>>sys.stderr,'Non-BBC Micro colour %s at (%d,%d) - using %s'%(pixels[y][x],x,y,p)
                        break

                pidx=rgbs.index((p[0],p[1],p[2]))

            pidxs[-1].append(pidx)

    for y in range(1,len(pixels)):
        assert len(pixels[y])==len(pixels[y-1])

    return pidxs
                            
