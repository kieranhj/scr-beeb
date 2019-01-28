import bbc

def binstr(x): return ('0000000'+bin(x)[2:])[-8:]

def main():
    ___=0
    __x=1
    _x_=2
    _xx=3
    x__=4
    x_x=5
    xx_=6
    xxx=7


    char_names=['0','1','2','3','4',
                '5','6','7','8','9',
                'B','L','colon','dot','minus','space']
    chars=[[_x_,
            x_x,
            x_x,
            x_x,
            x_x,
            _x_],
           [_x_,
            xx_,
            _x_,
            _x_,
            _x_,
            xxx],
           [_xx,
            x_x,
            __x,
            _x_,
            x__,
            xxx],
           [xxx,
            __x,
            _xx,
            __x,
            x_x,
            _xx],
           [__x,
            _xx,
            x_x,
            xxx,
            __x,
            __x],
           [xxx,
            x__,
            xxx,
            __x,
            __x,
            xx_,],
           [_xx,
            x__,
            xx_,
            x_x,
            x_x,
            _x_,],
           [xxx,
            __x,
            _x_,
            x__,
            x__,
            x__],
           [_x_,
            x_x,
            _x_,
            x_x,
            x_x,
            _x_],
           [_xx,
            x_x,
            _xx,
            __x,
            _x_,
            x__],
           [xx_,
            x_x,
            xx_,
            x_x,
            x_x,
            xx_],
           [x__,
            x__,
            x__,
            x__,
            x__,
            xxx],
           [___,
            x__,
            ___,
            ___,
            x__,
            ___],
           [___,
            ___,
            ___,
            ___,
            ___,
            __x],
           
           [___,
            ___,
            xxx,
            ___,
            ___,
            ___,],
           [___,
            ___,
            ___,
            ___,
            ___,
            ___,]
           ]

    print '.hud_font'
    for i in range(len(chars)):
        values=[]
        print 'hud_font_char_%s=P%%-hud_font'%char_names[i]
        for row in range(5,-1,-1):
            assert len(chars[i])==6
            assert chars[i][row]>=0 and chars[i][row]<=7
            values.append(chars[i][row])
            
        print 'equb %s'%(','.join(['%%%s'%(binstr(x)[-3:]) for x in values]),)

    def table(suffix,masks):
        print '.hud_font_%s'%suffix
        values=[]
        for i in range(8):
            pixels=[0 if (i&masks[j])!=0 else 3 for j in range(4)]
            values.append(bbc.pack_2bpp(pixels))
        print 'equb %s'%(','.join(['$%02x'%x for x in values]))

    table('shift0',[4,2,1,0])

    table('shift1',[0,4,2,1])

    table('shift2_a',[0,0,4,2])
    table('shift2_b',[1,0,0,0])

    table('shift3_a',[0,0,0,4])
    table('shift3_b',[2,1,0,0])

    print 'hud_font_stride=%d'%(len(chars),)
    
if __name__=='__main__': main()
