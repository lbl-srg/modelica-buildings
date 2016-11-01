# Python module with test functions.
# These functions are used to test the Modelica Python interface.
# They are not meaningful, but rather kept simple to test whether
# the interface is correct.
#
# Make sure that the python path is set, such as by running
# export PYTHONPATH=`pwd`

import function

def main():
    inputNames = ['VMAG_A', 'VMAG_B', 'VMAG_C', 'P_A', 'P_B', 'P_C', 'Q_A', 'Q_B', 'Q_C']
    inputValues = [7287, 7299, 7318, 7272, 2118, 6719, -284, -7184, 3564]
    outputNames = ['voltage_A', 'voltage_B', 'voltage_C']
    outputDeviceNames = ['HOLLISTER_2104', 'HOLLISTER_2104', 'HOLLISTER_2104']
    exchange("HL0004.sxst", inputNames, inputValues, outputNames, outputDeviceNames, 0)
    
def exchange(inputFileName, inputValues, inputNames, 
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
    # Need for testing the names of outputs and devices
    # To use the wrapper, the user will need to set the 
    # Pythonpath to a folder which contains the testFunctionsCymdist,
    # function.py and the cympy folder.
    outputs = function.fmu_wrapper(inputFileName, inputValues, inputNames, 
               outputNames, outputDeviceNames, writeResults)
    print ("This is the outputs returned from CYMDIST " + str(outputs))
    return outputs

if __name__ == '__main__':
    # Try running this module!
    main()