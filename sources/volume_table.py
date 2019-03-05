#!/usr/bin/python

##########################################################################
##########################################################################

def float_values(i):
    values=[]
    value=0
    step=(i+1)/16.0
    for j in range(16):
        values.append(int(value))
        #values.append(value+0.5)
        value+=step
    return values

def fix_values(i):
    values=[]
    value=0
    step=int((i+1)/16.0*4096.0)
    for j in range(16):
        values.append(value>>12)
        value+=step
    return values
        
def main():
    for i in range(16):
        print "%-3d: %s"%(i,float_values(i))
        print"     %s"%fix_values(i)
        assert float_values(i)==fix_values(i)
        
##########################################################################
##########################################################################
    
if __name__=='__main__': main()

