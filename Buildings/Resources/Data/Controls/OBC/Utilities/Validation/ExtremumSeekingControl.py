#!/usr/bin/env python
#######################################################
# Script that converts the output data ExtremumSeekingControl.csv
# to a format that can be read by the Modelica
# data reader.
#
# karthikeya.devaprasad@pnnl.gov                            2026-07-09
#######################################################

def convertData():
    import csv
    import datetime
    with open('ExtremumSeekingControl.csv', 'r') as csvfile:
        rea = csv.reader(csvfile, delimiter=',')
        next(rea, None) # Skip header
        i = 0
        lines= list()
        for row in rea:
            try:
                # "%.0f" formats the row index i as an integer (no decimal places)
                # "%.6f" formats the input signal (row[1]) with 6 decimal places
                # "%.6f" formats the output signal (row[3]) with 6 decimal places
                lines.append("%.0f, %.6f, %.6f\n" % (i, float(row[1]), float(row[3])))
                previousRow = row
            except ValueError:
                # Reached the last line, which contains non-numeric text
                # Prepend a t=0 entry using the last valid row's values
                # Same format specifiers as above; the row index is hardcoded to 0
                l = "%.0f, %.6f, %.6f\n" % (0, float(previousRow[1]), float(previousRow[3]))
                lines.insert(0, l)
            i = i + 1

    with open('ExtremumSeekingControl.mos', 'w') as filOut:
        filOut.write("""#1
# The rows in this file are as follows:
#  - time in seconds
#  - Input signal (Dimensionless)
#  - Output signal (Dimensionless)
double refData(%s, 3)
""" % len(lines))  # "%s" is replaced with the row count so the Modelica reader knows the matrix dimensions (rows x 3 columns)
        filOut.writelines(lines)

if __name__ == "__main__":
    convertData()
