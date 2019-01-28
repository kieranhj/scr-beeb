#!/usr/bin/python
import bbc

##########################################################################
##########################################################################

def byte(hud,index,mask):
    pixels=bbc.unpack_2bpp(hud[index])
    if mask: pixels=[0 if x==0 else 2 for x in pixels]
    print 'equb $%02x'%bbc.pack_2bpp(pixels)

def icon2(id,hud,index,mask):
    byte(hud,index+7,mask)
    byte(hud,index+15,mask)
    for i in range(2):
        for j in range(6): byte(hud,index+320+i*8+j,mask)

def icon(id,hud,index):
    print 'dash_icon_%d_addr=$%04x'%(id,0x6000+index)
    print '.dash_icon_%d'%id
    print '; masked'
    icon2(id,hud,index,True)
    print '; original'
    icon2(id,hud,index,False)

def main():
    with open('./build/scr-beeb-hud.dat','rb') as f:
        hud=[ord(x) for x in f.read()]

    print '.dash_icons'
    icon(0,hud,0+23*320+(15-3)*8)
    icon(1,hud,0+23*320+(29-3)*8)

##########################################################################
##########################################################################
    
if __name__=='__main__': main()
