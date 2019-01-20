#!/usr/bin/python
import png,argparse,sys,math,bbc,collections,os

if (os.getenv('INSIDE_EMACS') is not None and
    os.getenv('USER')=='tom'):
    # me, on my laptop...
    os.chdir(os.path.expanduser('~/github/scr-beeb'))

##########################################################################
##########################################################################

def load_file(path):
    with open(path,'rb') as f: return [ord(x) for x in f.read()]

##########################################################################
##########################################################################

def get_addr(x,y): return (y>>3)*320+(y&7)+(x//4)*8

def get(bbc_image,x,y):
    assert x>=0 and x<160
    assert y>=0 and y<200
    index=get_addr(x,y)
    value=bbc_image[index]
    pixels=bbc.unpack_2bpp(value)
    return pixels[x%4]

##########################################################################
##########################################################################

Write=collections.namedtuple('Write','pos addr mask value')

def stats(name,
          path,
          dest_x,
          dest_y,
          hud,
          hud_mask):
    writes=[]
    
    image=bbc.load_png(path,5,True,-1,(255,0,255))
    # print '%s: %d x %d'%(name,len(image[0]),len(image))

    for y in range(len(image)):
        for x in range(len(image[0])):
            if image[y][x]==1: image[y][x]=1
            elif image[y][x]==3: image[y][x]=3
            elif image[y][x]==-1: pass         # transparent
            else:
                raise ValueError('unrecognised colour %d at (%d,%d)'%(image[y][x],x,y))

    # Add transparency to vertical edges of image, so it is
    # byte-aligned for its destination.
    if dest_x%4!=0:
        l=dest_x%4
        # print '    Dest X is %d - padding with %d on left'%(dest_x,l)
        for y in range(len(image)):
            image[y]=l*[-1]+image[y]+(4-l)*[-1]
        dest_x-=dest_x%4
        # print '    Dest X now %d, width now %d'%(dest_x,len(image[0]))

    num_mask_bytes=0
    num_total_sprite_bytes=0

    for y in range(len(image)):
        for x in range(0,len(image),4):
            # pixels in this byte.
            byte_pixels=image[y][x+0:x+4]

            if byte_pixels.count(-1)==4:
                # fully transparent - just skip
                continue

            byte_screen_mask=[0,0,0,0]

            for i in range(4):
                screen_x=dest_x+x+i
                screen_y=dest_y+y
                if byte_pixels[i]==-1:
                    if get(hud_mask,screen_x,screen_y)==0:
                        # this pixel is transparent, but all that's
                        # behind it is the engine.
                        byte_pixels[i]=get(hud,screen_x,screen_y)
                    else:
                        # :(
                        byte_screen_mask[i]=3
                        byte_pixels[i]=0
                        #print '        mask at: (%d,%d)'%(dest_x+x+i,dest_y+y)

                assert byte_pixels[i]>=0 and byte_pixels[i]<=3
                
            writes.append(Write((dest_x+x,dest_y+y),
                                get_addr(dest_x+x,dest_y+y),
                                bbc.pack_2bpp(byte_screen_mask),
                                bbc.pack_2bpp(byte_pixels)))

    # print '    %d sprite bytes'%len(writes)
    # print '    %d mask bytes'%len([x for x in writes if x.mask!=0])

    return writes

SimpleWrite=collections.namedtuple('SimpleWrite','addr values')
MaskedWrite=collections.namedtuple('MaskedWrite','addr masks values')

# everything before this is erased every frame anyway, so no need to
# erase it manually.
#
# TODO - this probably means that anything past this address should
# always be written unmasked? - but there are 8 masked entries past
# this point. Does this mean lines could be drawn there in game, and
# then not erased? Or does the default horizon table differ from the
# HUD graphic? Not a huge problem, just a bit of inefficiency, but
# should probably figure this out at some point...
first_erase_addr=0x1560

def main(options):
    hud=load_file('./build/scr-beeb-hud.dat')
    hud_mask=load_file('./build/scr-beeb-hud-mask.dat')

    masks_by_addr={}
    writes_by_addr={}
    
    for frame in range(3):
        writes=[]
        
        writes+=stats('left%d'%frame,
                      './graphics/flame_left_%d.png'%frame,
                      (70-24)//2,173-50,
                      hud,hud_mask)

        writes+=stats('right%d'%frame,
                      './graphics/flame_right_%d.png'%frame,
                      (250-24)//2,173-50,
                      hud,hud_mask)

        for write in writes:
            masks_by_addr[write.addr]=masks_by_addr.get(write.addr,0)|write.mask

            if write.addr not in writes_by_addr:
                writes_by_addr[write.addr]=[None,None,None]
            
            assert writes_by_addr[write.addr][frame] is None
            writes_by_addr[write.addr][frame]=write

    print>>sys.stderr,len(masks_by_addr)

    msbs={}
    for addr in masks_by_addr.keys(): msbs[addr>>8]=msbs.get(addr>>8,0)+1
    print>>sys.stderr,msbs

    masked_addrs=set()
    for addr,mask in masks_by_addr.iteritems():
        if mask!=0: masked_addrs.add(addr)

    unmasked_addrs=[x for x in masks_by_addr.keys() if x not in masked_addrs]

    unmasked_addrs=sorted(list(unmasked_addrs))
    masked_addrs=sorted(list(masked_addrs))

    print>>sys.stderr,'%d %d'%(len(masked_addrs),len(unmasked_addrs))

    print 'flames_initial_masked_write_addr=$%04x'%(0x4000+masked_addrs[0])
    print 'flames_initial_unmasked_write_addr=$%04x'%(0x4000+unmasked_addrs[0])

    print 'flames_unmasked_writes_size=%d'%len(unmasked_addrs)
    print 'flames_masked_writes_size=%d'%len(masked_addrs)

    for frame in range(3):
        print '.flames_unmasked_values_%d'%frame

        for addr in unmasked_addrs:
            write=writes_by_addr[addr][frame]
            if write is None:
                print '    equb $%02x ; +$%04x (from HUD)'%(hud[addr],addr)
            else:
                assert write.mask==0
                print '    equb $%02x ; +$%04x'%(write.value,addr)

        print '.flames_masked_masks_%d'%frame

        for addr in masked_addrs:
            write=writes_by_addr[addr][frame]
            if write is None: mask=255
            else: mask=write.mask
            print '    equb $%02x ; +$%04x'%(mask,addr)

        print '.flames_masked_values_%d'%frame

        for addr in masked_addrs:
            write=writes_by_addr[addr][frame]
            if write is None: value=0
            else: value=write.value
            print '    equb $%02x ; +$%04x'%(value,addr)
            
    print '.flames_unmasked_deltas'
    for i in range(1,len(unmasked_addrs)):
        print '    equb $%02x'%(unmasked_addrs[i]-unmasked_addrs[i-1])
    print '    equb 0'

    print '.flames_masked_deltas'
    for i in range(1,len(masked_addrs)):
        print '    equb $%02x'%(masked_addrs[i]-masked_addrs[i-1])
    print '    equb 0'

    erase_addrs=sorted(masked_addrs+unmasked_addrs)
    for i in range(len(erase_addrs)):
        if erase_addrs[i]>=first_erase_addr:
            del erase_addrs[0:i]
            break

    print 'flames_erase_writes_size=%d'%len(erase_addrs)
    print 'flames_initial_erase_addr=$%04x'%(0x4000+erase_addrs[0])

    print '.flames_erase_values'
    for addr in erase_addrs:
        print '    equb $%02x ; +$%04x'%(hud[addr],addr)

    print '.flames_erase_deltas'
    for i in range(1,len(erase_addrs)):
        print '    equb $%02x'%(erase_addrs[i]-erase_addrs[i-1])
    print '    equb 0'
    

##########################################################################
##########################################################################

if __name__=='__main__':
    parser=argparse.ArgumentParser()

    main(parser.parse_args())
    
