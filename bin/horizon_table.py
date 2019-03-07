#!/usr/bin/python
import png,argparse,sys,math,bbc,collections,os

##########################################################################
##########################################################################

def main():
    image=bbc.load_png('graphics/scr-beeb-hud.png',
                       mode=5,
                       halve_width=True,
                       print_warnings=False)

    ys=''
    for dx in range(128):
        x=16+dx
        y=50
        assert image[y][x]==5
        while image[y][x]==5: y+=1

        y=y-16+64
        if y>0xc0: y=0xc0

        ys+=chr(y)

    # easier to test on BBC...
    with open('./build/default_horizon_table.bin','wb') as f: f.write(ys)

##########################################################################
##########################################################################

if __name__=='__main__': main()
