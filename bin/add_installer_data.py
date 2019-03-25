#!/usr/bin/python
import sys

def main():
    with open('data/install.txt','rt') as f: print f.read()
    print '1000DATA %s,""'%(','.join(sys.argv[1:]))

if __name__=='__main__': main()
