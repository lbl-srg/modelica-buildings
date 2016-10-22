# Python module with test functions.
# These functions are used to test the Modelica Python interface.
# They are not meaningful, but rather kept simple to test whether
# the interface is correct.
#
# Make sure that the python path is set, such as by running
# export PYTHONPATH=`pwd`

import cympy
import function

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
    
    # Open input file name
    cympy.study.Open(inputFileName)
    
    # # Retrieve microPMU data at t
    # udata = {'VMAG_A': 7287.4208984375,
    #          'VMAG_B': 7299.921875,
    #          'VMAG_C': 7318.2822265625,
    #          'P_A': 7272.5364248477308,
    #          'P_B': 2118.3817519608633,
    #          'P_C': 6719.1867010705246,
    #          'Q_A': -284.19075651498088,
    #          'Q_B': -7184.1189935099919,
    #          'Q_C': 3564.4269660296022,
    #          'units': ('kW', 'kVAR', 'V')}
    
    # Create dicionary of input which is similar to udata
    # Make sure that the units are OK here. We might have to 
    # Check units here or do it in Python where the xml is provided.
    # This might be better to avoid passing units to the functions.
    input_data = {}
    output_data = {}
    outputs = []
    for i in inputNames:
        input_data{i}=inputValues[i]
        
    # Call functions to set inputs. 
    # Is this one similar to load_allocation??
    # Set input data in CYMDIST
    function.set_inputs(input_data)

    # Run a power flow
    lf = cympy.sim.LoadFlow()
    lf.Run()
    
    # Get output data from CYMDIST. 
    # Make sure that outputs have the same order as the output names.
    # The key name is the output name
    # The key value is the device name.
    # These two will be used to get the output value.
    for i in outputNames:
        output_data{i}=outputDeviceNames[i]
    
    # Get the outputs from CYMDIST
    output_dict = function.get_outputs(output_data)
    
    for i in outputNames:
        # This should be the values in listed output names
        outputs.append(output_dict[i])
    
    # Write results
    if(writeResults==1):
        f = open(inputFileName+"_"+"Output"+".json", 'w')
        f.write(output_dict)
        f.close()
    
    return outputs

