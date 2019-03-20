#!/usr/bin/python
import argparse,os,os.path,sys,struct,glob

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

def get_data(xs):
    data=""
    for x in xs:
        if type(x) is int or type(x) is long:
            assert x>=0 and x<=255
            data+=chr(x)
        elif type(x) is str:
            assert len(x)==1
            data+=x
        else:
            assert False,(x,type(x))

    return data

##########################################################################
##########################################################################

def get_unique_paths(paths):
    abs_paths=[os.path.normcase(os.path.abspath(path)) for path in paths]
    abs_paths_seen=set()
    result=[]
    for i,abs_path in enumerate(abs_paths):
        if abs_path not in abs_paths_seen:
            result.append(paths[i])
            abs_paths_seen.add(abs_path)
    return result

##########################################################################
##########################################################################

# def get_size_sectors(size_bytes): return (size_bytes+255)//256

class BeebFile: pass

def main(options):
    global g_verbose
    g_verbose=options.verbose

    # Use glob.glob to expand the input files, since Windows-style
    # shells don't do that for you.
    fnames=[]
    for pattern in options.fnames: fnames+=glob.glob(pattern)
    options.fnames=fnames

    # Remove input files with an extension - this just makes it easier
    # to use from a POSIX-style shell.
    options.fnames=[x for x in options.fnames if os.path.isfile(x+'.inf')]

    options.fnames=get_unique_paths(options.fnames)

    # *TITLE setting.
    title=''
    if options.title is None:
        title_name=os.path.join(options.dir,'.title')
        if os.path.isfile(title_name):
            with open(title_name,'rt') as f: title=f.readlines()[0][:12]
    else:
        if len(options.title)>12: fatal("title is too long - max 12 chars")
        # if len(options.fnames)>31: fatal("too many files - max 31")
        title=options.title

    renames={}
    for rename in options.renames:
        if rename[0].lower() in renames:
            fatal('duplicated rename: %s'%rename[0])
            
        renames[rename[0].lower()]=rename[1]
    renamed=set()

    # *OPT4 setting.
    opt4=0
    if options.opt4 is None:
        if options.dir is not None:
            opt4_name=os.path.join(options.dir,'.opt4')
            if os.path.isfile(opt4_name):
                with open(opt4_name,'rb') as f: opt4=int(f.read()[0])&3
    else:
        if options.opt4<0 or options.opt4>3:
            fatal("bad *OPT4 value: %s"%options.opt4)
        opt4=options.opt4

    if len(options.build)>0:
        opt4=3

    # How many usable sectors on this disc?
    num_disc_sectors=(40 if options._40 else 80)*10
    v("%d sector(s) on disc\n"%num_disc_sectors)

    # Load all files in.
    files=[]
    v("%d file(s):\n"%len(options.fnames))
    for fname in options.fnames:
        file=BeebFile()

        with open(fname+'.inf','rt') as f:
            inf_lines=f.readlines()
            if len(inf_lines)==0:
                # Bodge.
                inf_data=[os.path.basename(fname),
                          'ffffffff',
                          'ffffffff']
            else:
                inf_data=inf_lines[0].split()

        if len(inf_data)<3: continue

        file.bbc_name=inf_data[0]

        # Handle the rename before checking for validity.
        new_bbc_name=renames.get(file.bbc_name.lower())
        if new_bbc_name is not None:
            renamed.add(file.bbc_name.lower())
            v('Rename: %s -> %s\n'%(file.bbc_name,new_bbc_name))
            file.bbc_name=new_bbc_name
        
        if len(file.bbc_name)<3:
            print>>sys.stderr,'NOTE: Ignoring %s: BBC name too short: %s'%(fname,file.bbc_name)
            continue
        
        if file.bbc_name[1]!='.':
            print>>sys.stderr,'NOTE: Ignoring %s: BBC name not a DFS-style name: %s'%(fname,file.bbc_name)
            continue
        
        if len(file.bbc_name)>9:
            print>>sys.stderr,'NOTE: Ignoring %s: BBC name too long: %s'%(fname,file.bbc_name)
            continue
        
        if len(options.build)>0:
            if file.bbc_name.lower()=='$.!boot':
                print>>sys.stderr,'NOTE: Ignoring specified $.!BOOT file due to --build'
                continue

        file.bbc_name=file.bbc_name[0]+file.bbc_name[2:] # remove '.'

        with open(fname,"rb") as f: file.data=f.read()

        file.load=int(inf_data[1],16)
        file.exec_=int(inf_data[2],16)
        
        file.locked=False
        if len(inf_data)>=4:
            if inf_data[3].lower()=='l': file.locked=True
            else:
                try:
                    attr=int(inf_data[3],16)
                    file.locked=(attr&8)!=0
                except ValueError: pass

        files.append(file)

    # Add a manually-specified !BOOT, if necessary.
    if len(options.build)>0:
        file=BeebFile()

        file.bbc_name='$!BOOT'
        file.load=0xffffffff
        file.exec_=0xffffffff
        file.locked=False

        file.data=''
        for line in options.build: file.data+=line+'\r'

        files.append(file)

    next_sector=2
    for file in files:
        file.sector=next_sector
        file.size_sectors=(len(file.data)+255)//256
        next_sector+=file.size_sectors

        v("    %-10s %08X %08X %08X %s "%(file.bbc_name[0]+"."+file.bbc_name[1:],
                                         file.load,
                                         file.exec_,
                                         len(file.data),
                                         "L" if file.locked else ""))

        v(" @%d"%file.sector)

        v("\n")

    if len(files)>31:
        fatal('Too many files - disk has %d files, but max is 31'%len(files))

    if next_sector>num_disc_sectors-2:
        fatal("Too much data - disk has %d sectors, but files use %d sectors"%(num_disc_sectors,next_sector))

    # Create catalogue.
    sectors=[[0]*8+[" "]*248,
             [0]*256]

    # Store title.
    for i in range(len(title)):
        if i<8: sectors[0][i]=title[i]
        else: sectors[1][i-8]=title[i]

    # Store metadata.
    sectors[1][4]=0                 # Disk write count
    sectors[1][5]=len(files)*8
    sectors[1][6]=((opt4<<4)|
                   ((num_disc_sectors>>8)&3))
    sectors[1][7]=num_disc_sectors&255

    # Store catalogue data.
    next_sector=2
    for i,file in enumerate(files):
        # Files are stored in reverse sector order.
        offset=8+8*(len(files)-1-i)

        for j in range(1,len(file.bbc_name)): sectors[0][offset+j-1]=file.bbc_name[j]
        sectors[0][offset+7]=file.bbc_name[0]

        sectors[1][offset+0]=(file.load>>0)&255
        sectors[1][offset+1]=(file.load>>8)&255
        sectors[1][offset+2]=(file.exec_>>0)&255
        sectors[1][offset+3]=(file.exec_>>8)&255
        sectors[1][offset+4]=(len(file.data)>>0)&255
        sectors[1][offset+5]=(len(file.data)>>8)&255
        sectors[1][offset+6]=(((3 if (file.exec_&0xffff0000) else 0)<<6)|
                              (((len(file.data)>>16)&3)<<4)|
                              ((3 if (file.load&0xffff0000) else 0)<<2)|
                              (((file.sector>>8)&3)<<0))
        sectors[1][offset+7]=file.sector&255

    # Store file data
    for file in files:
        assert len(sectors)==file.sector
        for i in range(file.size_sectors):
            sectors.append(list(file.data[i*256:i*256+256]))

        # The last sector might need padding.
        while len(sectors[-1])!=256: sectors[-1].append(0)

    v("%d sectors on disc\n"%len(sectors))

    image="".join([get_data(x) for x in sectors])

    v("%d bytes in disc image\n"%len(image))

    if options.output_fname is not None:
        with open(options.output_fname,"wb") as f: f.write(image)
        
    if len(renamed)!=len(renames):
        print>>sys.stderr,'WARNING: Some renames were redundant:'
        for key,val in renames.iteritems():
            if key not in renamed:
                print>>sys.stderr,'    %s -> %s'%(key,val)

##########################################################################
##########################################################################

if __name__=="__main__":
    parser=argparse.ArgumentParser(description="make SSD disc image from .inf folder")

    parser.add_argument("-v",
                        "--verbose",
                        action="store_true",
                        help="be more verbose")
    
    parser.add_argument("--40",
                        dest="_40",
                        default=False,
                        action="store_true",
                        help="create a 40- rather than 80-track disk")

    parser.add_argument("-t",
                        "--title",
                        metavar="TITLE",
                        default="",
                        help="use %(metavar)s as disc title (overrides --dir)")

    parser.add_argument("-4",
                        "--opt4",
                        metavar="VALUE",
                        default=None,
                        type=int,
                        help="set *OPT4 option to %(metavar)s (overrides --dir)")

    parser.add_argument('-d',
                        '--dir',
                        metavar='PATH',
                        default=None,
                        help='if specified, read *OPT4 and title settings from BeebLink folder %(metavar)s (title will be silently truncated if too long)')

    parser.add_argument("-o",
                        dest="output_fname",
                        metavar="FILE",
                        default=None,
                        help="write result to FILE")

    parser.add_argument('-r',
                        dest='renames',
                        metavar=('OLD-BBC-NAME','NEW-BBC-NAME'),
                        nargs=2,
                        action='append',
                        default=[],
                        help='while adding, rename OLD-BBC-NAME to NEW-BBC-NAME')

    parser.add_argument('-b',
                        '--build',
                        action='append',
                        default=[],
                        help='add line to $.!BOOT. Implies --opt4=3 and overries any $.!BOOT file specified')

    parser.add_argument("fnames",
                        nargs="*",
                        metavar="FILE",
                        #action="append",
                        default=[],
                        help="file(s) to put in disc image (non-BBC files will be ignored)")
    
    args=sys.argv[1:]

    options=parser.parse_args(args)
    main(options)
    
