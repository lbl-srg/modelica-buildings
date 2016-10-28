# Python module with test functions.
# These functions are used to test the Modelica Python interface.
# They are not meaningful, but rather kept simple to test whether
# the interface is correct.
#
# Make sure that the python path is set, such as by running
# export PYTHONPATH=`pwd`

import function

def main():
    inputNames = {'VMAG_A', 'VMAG_B', 'VMAG_C', 'P_A', 'P_B', 'P_C', 'Q_A', 'Q_B', 'Q_C'}
    inputValues = {7287, 7299, 7318, 7272, 2118, 6719, -284, -7184, 3564}
    exchange_cymdist("HL0004.sxst", inputNames, inputValues, "", "", 0)

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
    
def exchange_cymdist(inputFileName, inputValues, inputNames, 
               outputNames, outputDeviceNames, writeResults):
    
    """
     Args:
        inputFileName (str): Name of the CYMDIST input file.
        inputValues(str): Double input values.
        inputNames(str): Double input names.
        outputNames(str):  Double output names.
        outputDeviceNames(str): Output device names.
        writeResults(int): Flag for writing results.
    
    
    """
    # Call the CYMDIST wrapper
    # eed for testing the names of outputs and devices
    outputs = function.fmu_wrapper(inputFileName, inputValues, inputNames, 
               outputNames, outputDeviceNames, writeResults)
    return outputs

if __name__ == '__main__':
    # Try running this module!
    main()