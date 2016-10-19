# Python module with test functions.
# These functions are used to test the Modelica Python interface.
# They are not meaningful, but rather kept simple to test whether
# the interface is correct.
#
# Make sure that the python path is set, such as by running
# export PYTHONPATH=`pwd`

def r1_r1(iS, uR, uS, yS):
    return uR
    
def r2_r1(iS, uR, uS, yS):
    return uR[0] + uR[1]
    
def par3_r1(iS, yS, parR, parS):
    f = open("par2.txt", 'w')
    f.write(" The parameter names are: " + parS[0] + ", " + parS[1])
    f.close()
    return parR[0] + parR[1] + parR[2]   
    
def r1_r2(iS, uR, uS, yS):
    return [uR,  uR*2]       
    
def r2p2_r2(iS, uR, uS, yS, parR, parS):
    f = open("r2_r2.txt", 'w')
    f.write("The input file name is: " + iS + "." +
            " The input names are: " + uS[0] + ", " + uS[1] + "." +
            " The output names are: " + yS[0] + ", " + yS[1] + "." + 
            " The parameter names are: " + parS[0] + ", " + parS[1])
    f.close()
    return [uR[0] *parR[0],  uR[1]*parR[1]]
    
 



