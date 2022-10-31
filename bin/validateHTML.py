#!/usr/bin/env python3
#####################################################################
# This script validates the html code in the info section
# of all .mo files in the current directory and in all its
# subdirectories.
#
# The script and the Validator package are still experimental
# and its API may change.
#
# MWetter@lbl.gov                                          2011-06-01
#####################################################################

def validate():
    import buildingspy.io.reporter as rep
    import buildingspy.development.validator as v
    val = v.Validator()
    errMsg = val.validateHTMLInPackage(".")
    for i in range(len(errMsg)):
        if i == 0:
            print(f"The following malformed html syntax has been found:\n{errMsg[i]}")
        else:
            print(errMsg[i])

if __name__ == '__main__':
    import sys
    import os
    # The path to buildingspy must be added to sys.path to work on Linux.
    # If only added to os.environ, the Python interpreter won't find buildingspy
    sys.path.append(os.path.join(os.path.abspath('.'), "..", "..", "BuildingsPy"))
    validate()
