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

    print 'initial_masked_write_offset=$%04x'%masked_addrs[0]
    print 'initial_unmasked_write_offset=$%04x'%unmasked_addrs[0]

    print 'unmasked_writes_size=%d'%len(unmasked_addrs)
    print 'masked_writes_size=%d'%len(masked_addrs)

    for frame in range(3):
        print '.unmasked_flame_table_%d'%frame

        for addr in unmasked_addrs:
            write=writes_by_addr[addr][frame]
            if write is None:
                print '    equb $%02x ; +$%04x (from HUD)'%(hud[addr],addr)
            else:
                assert write.mask==0
                print '    equb $%02x ; +$%04x'%(write.value,addr)

        print '.masked_flame_mask_table_%d'%frame

        for addr in masked_addrs:
            write=writes_by_addr[addr][frame]
            if write is None: mask=255
            else: mask=write.mask
            print '    equb $%02x ; +$%04x'%(mask,addr)

        print '.masked_flame_value_table_%d'%frame

        for addr in masked_addrs:
            write=writes_by_addr[addr][frame]
            if write is None: value=0
            else: value=write.value
            print '    equb $%02x ; +$%04x'%(value,addr)
            
    print '.unmasked_deltas'
    for i in range(1,len(unmasked_addrs)):
        print '    equb $%02x'%(unmasked_addrs[i]-unmasked_addrs[i-1])
    print '    equb 0'

    print '.masked_deltas'
    for i in range(1,len(masked_addrs)):
        print '    equb $%02x'%(masked_addrs[i]-masked_addrs[i-1])
    print '    equb 0'

    # masked_positions=set()
    # for writes in all_writes:
    #     for write in writes:
            

    #     for write in writes:
    #         if write.pos not in all_writes: all_writes[write.pos]={}
    #         assert frame not in all_writes[write.pos]
    #         all_writes[write.pos][frame]=(write.mask,write.value)

    

    # set up empty item for any frames that don't write anything to a
    # given address.
    # for pos in all_writes.keys():
    #     for frame in range(3):
    #         if frame not in all_writes[pos]: all_writes[pos][frame]=None

    # simple_writes={}
    # masked_writes={}

    # # get addresses.
    # for pos in all_writes.keys():
    #     mask=0
    #     for frame in range(3):
    #         write=all_writes[pos].get(frame,None)
    #         if write is not None: mask|=write[0]

    #     if mask==0:
    #         # always unmasked
            
                
    # for frame in range(3):
    #     for pos in all_writes.keys():

    # for 

    # print len(all_writes)

    # num_always_simple=0
    # for pos in all_writes.keys():
    #     mask=0
    #     for write in all_writes[pos].values(): mask|=write[0]
    #     if mask==0: num_always_simple+=1

    # simple_writes={}
    # masked_writes={}

    # for frame in range(3):
    #     for pos in all

    # for frame in range(3):
    #     print '.simple_flame_table_%d'%frame

    #     for pos in all_writes.keys():
    #         assert pos[0]%4==0

    #         mask=0
    #         for write in all_writes[pos].values(): mask|=write[0]
            
    #         if mask==0:
    #             addr=get_addr(pos[0],pos[1])
                
    #             # simple write.
    #             if frame in all_writes[pos]:
    #                 assert all_writes[pos][frame][0]==0
    #                 value=all_writes[pos][frame][1]
    #             else:
    #                 value=bbc.pack_2bpp([get(hud,pos[0]+i,pos[1]) for i in range(4)])

    #             print '    equb $%02x ; %s ($%04x)'%(value,
    #                                                  pos,
    #                                                  get_addr(pos[0],pos[1]))

    # for frame in range(3):
    #     print '.masked_frame_table_%d'%frame

    #     for pos in all_writes.keys():
    #         assert pos[0]%4==0

    #         mask=0
    #         for write in all_writes[pos].values(): mask|=write[0]
    #         if mask!=0:
    #             # masked write

    #             if frame in all_writes[pos]:
    #                 mask,value=all_writes[pos][frame]
    #             else:
    #                 mask=255
    #                 value=0

    #             print '    equb $%02x,$%02x ; %s ($%04x)'%(mask,
    #                                                        value,
    #                                                        pos,
    #                                                        get_addr(pos[0],pos[1]))

    # num_masked=len(all_writes)-num_always_simple
    
    # print 'flames_simple_data_size=%d'%num_always_simple
    # print 'flames_masked_data_size=%d'%num_masked
    # print '; total size: %d'%(3*(num_always_simple+2*num_masked),)
    


##########################################################################
##########################################################################

if __name__=='__main__':
    parser=argparse.ArgumentParser()

    main(parser.parse_args())
    
