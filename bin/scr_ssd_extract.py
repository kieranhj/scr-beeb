#!/usr/bin/python
import sys,argparse,struct,textwrap,os,os.path

##########################################################################
##########################################################################

can_convert_basic=False
try:
    import BBCBasicToText
    can_convert_basic=True
except ImportError: pass

##########################################################################
##########################################################################

def fatal(str):
    sys.stderr.write("FATAL: %s"%str)
    if str[-1]!='\n': sys.stderr.write("\n")
    
    sys.exit(1)

##########################################################################
##########################################################################

g_verbose=False

def v(str):
    global g_verbose
    
    if g_verbose:
        sys.stdout.write(str)
        sys.stdout.flush()

##########################################################################
##########################################################################

# \ / : * ? " < > |
quote_chars='/<>:"\\|?* .#'

def get_pc_name(bbc_name):
    pc_name=''
    for c in bbc_name:
        if ord(c)<32 or ord(c)>126 or c in quote_chars:
            pc_name+='#%02x'%ord(c)
        else: pc_name+=c
    return pc_name

##########################################################################
##########################################################################

class Disc:
    def __init__(self,
                 num_sides,
                 num_tracks,
                 num_sectors,
                 data):
        self.num_sides=num_sides
        self.num_tracks=num_tracks
        self.num_sectors=num_sectors
        self.data=[ord(x) for x in data]

    def read(self,
             side,
             track,
             sector,
             offset):
        return self.data[self.get_index(side,track,sector,offset)]

    def read_string(self,
                    side,
                    track,
                    sector,
                    offset,
                    count):
        return "".join([chr(x) for x in [self.read(side,track,sector,offset+i) for i in range(count)]])

    def get_index(self,
                  side,
                  track,
                  sector,
                  offset):
        assert side>=0 and side<self.num_sides
        assert track>=0 and track<self.num_tracks,(track,self.num_tracks)
        assert sector>=0 and sector<self.num_sectors
        assert offset>=0 and offset<256

        index=(track*self.num_sides+side)*(self.num_sectors*256)
        index+=sector*256
        index+=offset

        return index

##########################################################################
##########################################################################
    
def mkdir(dir_name):
    "try to create folder, ignoring error"
    try: os.makedirs(dir_name)
    except: pass

##########################################################################
##########################################################################

def mkdir_and_open(path,mode):
    mkdir(os.path.split(path)[0])
    return open(path,mode)

##########################################################################
##########################################################################
    
def main(options):
    global g_verbose
    g_verbose=options.verbose

    global emacs
    if options.not_emacs: emacs=False

    #
    if options.drive0 and options.drive2:
        fatal("-0 and -2 are mutually exclusive")
        
    if (options.drive0 or options.drive2) and options.dest_dir is None:
        fatal("must specify destination folder explicitly with -0 or -2")

    # Figure out disc sidedness.
    ext=os.path.splitext(options.fname)[1]
    if ext.lower()=='.ssd':
        num_sides=1
        if options.drive2: fatal("disc image is single-sided")
    elif ext.lower()=='.dsd': num_sides=2
    else: fatal("unrecognised extension: %s"%ext)

    # Figure out where to put files.
    dest_dir=options.dest_dir
    if options.drive0 or options.drive2: pass
    else:
        if dest_dir is None:
            dest_dir=os.path.join(os.path.dirname(options.fname))

        dest_dir=os.path.join(dest_dir,
                              os.path.splitext(os.path.basename(options.fname))[0])

    # Load the image
    with open(options.fname,"rb") as f: image=Disc(num_sides,80,10,f.read())

    if options.drive0: sides=[0]
    elif options.drive2: sides=[1]
    else: sides=range(num_sides)
    
    for side in sides:
        drive=side*2

        title=(image.read_string(side,0,0,0,8)+image.read_string(side,0,1,0,4)).replace(chr(0),"").strip()

        num_files=image.read(side,0,1,5)>>3
        option=(image.read(side,0,1,6)>>4)&3

        v("Side %d: \"%s\": Option %d, %d files\n"%(side,title,option,num_files))

        # Write PC file.
        if options.drive0 or options.drive2: pc_folder=dest_dir
        else: pc_folder=os.path.join(dest_dir,"%d"%drive)

        if title!='':
            with mkdir_and_open(os.path.join(pc_folder,'.title'),'wt') as f: print>>f,title

        if option!=0:
            with mkdir_and_open(os.path.join(pc_folder,'.opt4'),'wt') as f: print>>f,option

        for file_idx in range(num_files):
            offset=8+file_idx*8
            
            name=image.read_string(side,0,0,offset,7).rstrip()
            dir=image.read(side,0,0,offset+7)

            locked=(dir&0x80)!=0
            dir=chr(dir&0x7F)

            load=(image.read(side,0,1,offset+0)<<0)|(image.read(side,0,1,offset+1)<<8)
            exec_=(image.read(side,0,1,offset+2)<<0)|(image.read(side,0,1,offset+3)<<8)
            length=(image.read(side,0,1,offset+4)<<0)|(image.read(side,0,1,offset+5)<<8)
            start=image.read(side,0,1,offset+7)

            topbits=image.read(side,0,1,offset+6)

            if (topbits>>6)&3:
                # but there are two bits, so what are you supposed to do?
                exec_|=0xFFFF0000

            length|=((topbits>>4)&3)<<16

            if (topbits>>2)&3:
                # but there are two bits, so what are you supposed to do?
                load|=0xFFFF0000

            start|=((topbits>>0)&3)<<8

            # Grab contents of this file
            contents=[]
            for i in range(length):
                byte_sector=start+i/256
                byte_offset=i%256
                
                contents.append(image.read(side,byte_sector/10,byte_sector%10,byte_offset))

            # Does it look like it could be a BASIC program?
            basic=False
            if options.basic and len(contents)>0:
                i=0
                while True:
                    if i>=len(contents):
                        break

                    if contents[i]!=0x0D:
                        break

                    if i+1>=len(contents):
                        break

                    if contents[i+1]==0xFF:
                        basic=True
                        break

                    if i+3>=len(contents):
                        break

                    if contents[i+3]==0:
                        break
                    
                    i+=contents[i+3]#skip rest of line
                    

            # *INFO
            locked_str="L" if locked else " "
            v("%s.%-7s %c %08X %08X %08X (T%d S%d)%s\n"%(dir,
                                                         name,
                                                         locked_str,
                                                         load,
                                                         exec_,
                                                         length,
                                                         start/10,
                                                         start%10,
                                                         " (BASIC)" if basic else ""))

            #
            contents_str="".join([chr(x) for x in contents])

            pc_name='%s.%s'%(get_pc_name(dir),get_pc_name(name))
            pc_path=os.path.join(pc_folder,pc_name)
            
            with mkdir_and_open(pc_path+'.inf','wt') as f:
                print>>f,'%s.%s %08x %08x %s'%(dir,
                                               name,
                                               load,
                                               exec_,
                                               locked_str)
                
            with mkdir_and_open(pc_path,"wb") as f: f.write(contents_str)

            # Write PC copy.
            if basic:
                raw_path=os.path.join(dest_dir,
                                      'raw/%d'%drive,
                                      pc_name)
                
                decoded=BBCBasicToText.DecodeLines(contents_str)
                for wrap in [False]:
                    ext=".wrap.txt" if wrap else ".txt"
                    with mkdir_and_open(raw_path+ext,'wb') as f:
                        # Produce output like the BASIC Editor (readability
                        # not guaranteed)
                        for num,text in decoded:
                            wrap_width=64 if wrap else 65536
                            wrapped=textwrap.wrap(wrap_width)
                            num_text="%5d "%num
                            for i in range(len(wrapped)):
                                if i==0: prefix=num_text
                                else: prefix=" "*len(num_text)
                                print>>f,"%s%s"%(prefix,wrapped[i])

##########################################################################
##########################################################################

if __name__=="__main__":
    parser=argparse.ArgumentParser(description="make BeebLink folder from BBC disk image")
    
    parser.add_argument("-v",
                        "--verbose",
                        action="store_true",
                        help="be more verbose")

    parser.add_argument("--not-emacs",
                        action="store_true",
                        help="does nothing")

    if can_convert_basic:
        parser.add_argument("-b",
                            "--basic",
                            action="store_true",
                            help="find tokenized BASIC source files and save text copies")
                        
    parser.add_argument("-o",
                        "--output-dir",
                        dest='dest_dir',
                        default='.',
                        metavar="DIR",
                        help="where to put files. Default: %(default)s")

    parser.add_argument("-0",
                        default=None,
                        action="store_true",
                        dest="drive0",
                        help="convert only side 0, putting files directly in dest dir (which must be given explicitly)")

    parser.add_argument("-2",
                        default=None,
                        action="store_true",
                        dest="drive2",
                        help="convert only side 2, putting files directly in dest dir (which must be given explicitly)")
    
    parser.add_argument("fname",
                        metavar="FILE",
                        help="name of disc to convert")

    args=sys.argv[1:]

    options=parser.parse_args(args)

    if not can_convert_basic: options.basic=False
    
    main(options)
    
#auto_convert("Z:\\beeb\\beebcode\\A5022201.DSD",True)
