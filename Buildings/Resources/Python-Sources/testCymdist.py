# Python module with test functions.
# These functions are used to test the Modelica Python interface.
# They are not meaningful, but rather kept simple to test whether
# the interface is correct.
#
# Make sure that the python path is set, such as by running
# export PYTHONPATH=`pwd`

def r1_r1(iS, uR, uS, yS, dyS, iwR):
    f = open("r1_r1.txt", 'w')
    f.write(str(iS) + " " + str(uR) + " " + str(uS) + 
    " " + str(yS) + " " + str(dyS) + " " + str(iwR))
    f.close()
    return uR
    
def r2_r1(iS, uR, uS, yS, dyS, iwR):
    f = open("r2_r1.txt", 'w')
    f.write(str(iS) + " " + str(uR) + " " + str(uS) + 
    " " + str(yS) + " " + str(dyS) + " " + str(iwR))
    f.close()
    return uR[0] + uR[1]
    
def par3_r1(iS, yS, dyS, parR, parS, iwR):
    f = open("par3_r1.txt", 'w')
    f.write(str(iS) + " " + str(yS) + " " + str(dyS) + 
    " " + str(parR) + " " + str(parS) + " " + str(iwR))
    f.close()
    return parR[0] + parR[1] + parR[2]   
    
def r1_r2(iS, uR, uS, yS, dyS, iwR):
    f = open("r1_r2.txt", 'w')
    f.write(str(iS) + " " + str(uR) + " " + str(uS) + 
    " " + str(yS) + " " + str(dyS) + " " + str(iwR))
    f.close()
    return [uR,  uR*2]       
    
def r2p2_r2(iS, uR, uS, yS, dyS, parR, parS, iwR):
    f = open("r2_r2.txt", 'w')
    f.write("The input file name is: " + iS + "." +
            " The input names are: " + uS[0] + ", " + uS[1] + "." +
            " The output names are: " + yS[0] + ", " + yS[1] + "." + 
            " The device output names are: " + dyS[0] + ", " + dyS[1] + "." + 
            " The parameter names are: " + parS[0] + ", " + parS[1])
    f.close()
    return [uR[0] *parR[0],  uR[1]*parR[1]]