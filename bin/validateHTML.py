#!/usr/bin/python
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
    import buildingspy.development.validator as v
    val = v.Validator()
    val.validateHTMLInPackage(".")

if __name__ == '__main__':
    import sys
    import os
    # The path to buildingspy must be added to sys.path to work on Linux.
    # If only added to os.environ, the Python interpreter won't find buildingspy
    sys.path.append(os.path.join(os.path.abspath('.'), "..", "..", "BuildingsPy"))
    validate()

