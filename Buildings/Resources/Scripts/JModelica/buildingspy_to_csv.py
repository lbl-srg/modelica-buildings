#!/usr/bin/env python
##########################################################
# This script converts a reference result file
# from the format used by BuildingsPy to the
# csv format used by the Modelica Association.
#
# This script is provided for tools that compare the
# reference results with the csv compare tool
# from the Modelica Association.
#
# Usage: ./buildingspy_to_csv.py reference_result_file.txt
#
#        will create reference_result_file.csv
#
# MWetter@lbl.gov                               2016-08-31
# Revision: Modified by Thierry Nouidui         2016-12-01
# for non equidistant time grids
############################################################

def _read_reference_result(file_name):
    ''' Read the reference results and write them as a csv file
        with the same base file name.

    :param file_name: The name of the reference file.
    :return: A dictionary with the reference results.

    This function is based on buildingspy.development.regressiontest:_readReferenceResults()
    but provided as a stand-alone function to avoid dependency on
    BuildingsPy.

    '''
    f=open(file_name,'r')
    lines = f.readlines()
    f.close()

    # Compute the number of the first line that contains the results
    iSta=0
    for iLin in range(min(2, len(lines))):
        if "svn-id" in lines[iLin]:
            iSta=iSta+1
        if "last-generated" in lines[iLin]:
            iSta=iSta+1

    # Dictionary that stores the reference results
    r = dict()
    iLin = iSta
    while iLin < len(lines):
        lin = lines[iLin].strip('\n')
        try:
            (key, value) = lin.split("=")
            # Check if this is a statistics-* entry.
            if key.startswith("statistics-"):
                while (iLin < len(lines)-1 and lines[iLin+1].find('=') == -1):
                    iLin += 1
            else:
                s = (value[value.find('[')+1: value.rfind(']')]).strip()
                numAsStr=s.split(',')
                val = []
                for num in numAsStr:
                    # We need to use numpy.float64 here for the comparison to work
#                    val.append(numpy.float64(num))
                    val.append(num)
                r[key] = val
        except ValueError as detail:
            s =  "%s could not be parsed.\n" % file_name
            sys.stderr.write(s)
            raise TypeError(detail)
        iLin += 1
    return r

def _write_csv(file_name, d):
    """ Writes the dictionary with the reference results to a csv file.

        :param file_name: The name of the csv reference file.
        :param: A dictionary with the reference results.
    """
    import numpy as np
    # Get the length of the data series

    # Check if time is a key, as FMU export has no time series
    found_time = False
    for key in d.keys():
        if key == 'time':
            found_time = True
            break
    if not found_time:
        return

    n = 2
    for key in d.keys():
        # Parameters and time have two entries. Hence, we search
        # to see if there are data with more entries.
        if len(d[key]) > 2:
            n = len(d[key])
            break
    # Set all series to have the same length
    for key in d.keys():
        if len(d[key]) != n:
            #d[key] = [d[key][0] for x in range(n)]
            if ((key == 'time') and (len(d[key])<3)):
                d[key] = np.linspace( \
                   np.float64(d[key][0]), \
                   np.float64(d[key][-1]), n).tolist()
            else:
                d[key] = [d[key][0] for x in range(n)]

    # Write data as csv file
    with open(file_name, 'w') as f:
        # Write header
        f.write("time")
        for key in d.keys():
            if key != 'time':
                f.write("; %s" % key)
        f.write("\n")
        # Write data
        for i in range(n):
            vals = d['time']
            f.write(str(vals[i]))
            for key in d.keys():
                if key != 'time':
                    vals = d[key]
                    f.write("; %s" % vals[i])
            f.write("\n")


if __name__ == "__main__":
    import sys
    import os

    if len(sys.argv) == 2 and os.path.isfile(sys.argv[1]):
        file_name = sys.argv[1]
        d = _read_reference_result(file_name)
        _write_csv(file_name[:-3] + "csv", d)
    else:
        s =  "Usage: %s reference_result_file.txt\n" % sys.argv[0]
        sys.stderr.write(s)
        raise ValueError(s)
