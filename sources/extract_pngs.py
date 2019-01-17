import os,png

##########################################################################
##########################################################################

def unpack_c64(x): return [x>>6&3,x>>4&3,x>>2&3,x>>0&3]

def pack_beeb(p):
    return ((p[0]>>1&1)<<7|
            (p[1]>>1&1)<<6|
            (p[2]>>1&1)<<5|
            (p[3]>>1&1)<<4|
            (p[0]&1)<<3|
            (p[1]&1)<<2|
            (p[2]&1)<<1|
            (p[3]&1)<<0)

def get_beeb_pixels(buffer):
    return [pack_beeb(unpack_c64(x)) for x in buffer]

##########################################################################
##########################################################################

TRANSPARENT=4

def save_png(name,image):
    assert isinstance(name,str)
    
    for i in range(len(image)): assert len(image[i])==len(image[0])
    
    palette=[(0,0,0,255),
             (255,0,0,255),
             (0,255,0,255),
             (255,255,255,255),
             (0,0,0,0)]

    # correct the aspect ratio.
    image2=[]
    for y in range(len(image)):
        image2.append([])
        for x in range(len(image[y])):
            for i in range(2): image2[-1].append(image[y][x])

    with open('tmp/%s.png'%name,'wb') as f:
        png.Writer(len(image2[0]),
                   len(image2),
                   palette=palette).write(f,image2)

def ensure_space_in_image(image,new_width,new_height):
    for i in range(len(image)): assert len(image[i])==len(image[0])
    
    if new_height>len(image):
        width=0 if len(image)==0 else len(image[0])
        for y in range(new_height-len(image)):
            image.append(width*[TRANSPARENT])

    if new_width>len(image[0]):
        for y in range(len(image)):
            for x in range(new_width-len(image[y])):
                image[y].append(TRANSPARENT)

    for i in range(len(image)): assert len(image[i])==len(image[0])

def get_image_from_c64_bitmap(bitmap,stride):
    image=[]

    assert stride%8==0
    assert len(bitmap)%stride==0

    bitmap_width=stride//8*4
    bitmap_height=len(bitmap)//stride*8
    
    ensure_space_in_image(image,bitmap_width,bitmap_height)
    
    for y in range(bitmap_height):
        for x in range(bitmap_width):
            pixels=unpack_c64(bitmap[(y>>3)*stride+(y&7)+(x//4)*8])
            image[y][x]=pixels[x%4]

    return image
    
##########################################################################
##########################################################################

def extract_menu_header_graphic(data):
    buffer=[]
    for i in range(0xa00): buffer.append(None)

    src_idx=0x40
    for i in range(13):
        nbytes=data[i*3+0]
        if nbytes==0: nbytes=256

        dest=data[i*3+1]|data[i*3+2]<<8
        assert dest>=0x4000 and dest+nbytes<=0x4a00

        for j in range(nbytes):
            dest_idx=dest+j-0x4000
            assert buffer[dest_idx] is None
            buffer[dest_idx]=data[src_idx]
            src_idx+=1

    for i in range(len(buffer)):
        if buffer[i] is None: buffer[i]=0x55

    image=get_image_from_c64_bitmap(buffer,320)

    save_png('header_menu_graphic',image)

##########################################################################
##########################################################################

def extract_hud(data):
    image=get_image_from_c64_bitmap(data[0x1100:0x1100+8000],320)

    # remove junk.
    for y in range(96):
        for x in range(128):
            image[16+y][16+x]=TRANSPARENT

    # by some miracle, this happens to work.
    for x in range(16,16+128):
        y=16+96
        while image[y][x]==3:
            image[y][x]=TRANSPARENT
            y+=1
    
    save_png('in_game_hud',image)

##########################################################################
##########################################################################

def extract_sprite(sprite_data,image,dest_x,dest_y):
    ensure_space_in_image(image,dest_x+12,dest_y+21)

    for y in range(21):
        for x in range(12):
            index=unpack_c64(sprite_data[y*3+x//4])[x%4]
            if index!=0:
                assert dest_y+y<len(image)
                assert dest_x+x<len(image[dest_y+y])
                image[dest_y+y][dest_x+x]=index

def get_sprite_data(data,index):
    offset=index*64
    hud_addr=0x62a0+(offset>>8)*320+(offset&0xff)-0x4f00
    assert hud_addr>=0 and hud_addr+63<=len(data)
    return data[hud_addr:hud_addr+63]
                
def extract_wheel(data,name,top_index,bottom_index):
    image=[]

    extract_sprite(get_sprite_data(data,top_index),image,0,0)
    extract_sprite(get_sprite_data(data,bottom_index),image,0,21)

    save_png(name,image)
                
def extract_sprites(data):
    for frame in range(3):
        extract_wheel(data,'wheel_left_%d'%frame,9+frame,19+frame)
        extract_wheel(data,'wheel_right_%d'%frame,4+frame,14+frame)

    for frame in range(3):
        image=[]
        extract_sprite(get_sprite_data(data,24+frame*2+0),image,0,0)
        extract_sprite(get_sprite_data(data,24+frame*2+1),image,12,7)
        save_png('flame_right_%d'%frame,image)

        image=[]
        extract_sprite(get_sprite_data(data,34+frame*2+0),image,0,7)
        extract_sprite(get_sprite_data(data,34+frame*2+1),image,12,0)
        save_png('flame_left_%d'%frame,image)

##########################################################################
##########################################################################
    
def main():
    with open('tmp/scr-beeb/0/$.Data','rb') as f:
        data=[ord(x) for x in f.read()]

    extract_menu_header_graphic(data)
    extract_hud(data)
    extract_sprites(data)

if __name__=='__main__': main()


