import sys,os,os.path,glob,zlib

def main():
    name=sys.argv[1] if len(sys.argv)>=2 else "."

    print ' CRC 32     File Size   Filename'
    print '-------------------------------------------------'
    
    if name == ".":
        folder=name
        names=os.listdir(folder)

        for name in names:
            full_name=os.path.join(folder,name)
            if not os.path.isfile(full_name): continue
            with open(full_name,'rb') as f: data=f.read()
            print '%08x  %9d  %s'%(zlib.crc32(data)&0xffffffff,
                                len(data),
                                full_name)

    else:

        with open(name,'rb') as f: data=f.read() 
        print '%08x  %9d  %s'%(zlib.crc32(data)&0xffffffff,
                                len(data),
                                name)
    

if __name__=='__main__': main()
