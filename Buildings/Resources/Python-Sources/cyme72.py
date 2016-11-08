# Python module with test functions.
# These functions are used to test the Modelica Python interface.
# They are not meaningful, but rather kept simple to test whether
# the interface is correct.
#
# Make sure that the python path is set, such as by running
# export PYTHONPATH=`pwd`

from datetime import datetime
import function

def main():
    input_names = ['VMAG_A', 'VMAG_B', 'VMAG_C', 'P_A', 'P_B', 'P_C', 'Q_A', 'Q_B', 'Q_C']
    input_values = [7287, 7299, 7318, 7272, 2118, 6719, -284, -7184, 3564]
    output_names = ['voltage_A', 'voltage_B', 'voltage_C']
    output_device_names = ['HOLLISTER_2104', 'HOLLISTER_2104', 'HOLLISTER_2104']
    exchange("HL0004.sxst", input_values, input_names, output_names, output_device_names, 0)
    
def exchange(input_file_name, input_values, input_names, 
               output_names, output_device_names, write_results):
    
    """
     Args:
        input_file_name (str): Name of the CYMDIST grid model.
        input_values(dbl): Input values.
        input_names(str): Input names.
        output_names(str):  Output names.
        output_device_names(str): Outputs devices names.
        write_results(int): Flag for writing results.
    
    
    """
    # Call the CYMDIST wrapper
    results = []
    n_outputs = len(output_names)
    start = datetime.now()
    outputs = function.fmu_wrapper(input_file_name, input_values, input_names, 
               output_names, output_device_names, write_results)
    end = datetime.now()
    print('Run a CYMDIST simulation in ' + str((end - start).total_seconds()) + ' seconds' )
    # Save the first n outputs. n is the length of the output_names.
    for i in range(n_outputs):
        try:
            results.append(float(outputs[i]))
        except ValueError:
            print('Cannot convert output ' + outputs[i] + ' to a float.')  
    print('These are the results returned by CYMDIST ' + str(outputs))
    print('These are the results returned by CYMDIST ' + str(results))
    return results

if __name__ == '__main__':
    # Try running this module!
    main()