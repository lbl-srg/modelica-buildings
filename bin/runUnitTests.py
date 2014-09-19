#!/usr/bin/env python
#######################################################
# Script that runs all unit tests.
#
# This script 
# - creates temporary directories for each processors, 
# - copies the library directory into these
#   temporary directories,
# - creates run scripts that run all unit tests,
# - runs these unit tests,
# - collects the dymola log files from each process,
# - writes the combined log file 'unitTests.log'
#   in the current directory, 
# - checks whether all unit tests run successfully,
#   and produced the same results as the reference
#   results, and
# - exits with the message 
#    'Unit tests completed successfully.' or with
#   an error message.
#
# If no errors occurred during the unit tests, then
# this script returns 0. Otherwise, it returns a
# non-zero exit value.
#
# MWetter@lbl.gov                            2011-02-23
#######################################################
import getopt
import sys
import os

def usage():
    ''' Print the usage statement
    '''
    print "runUnitTests.py [-b|-h|--help]"
    print ""
    print "  Runs the unit tests."
    print ""
    print "  -b         Batch mode, without user interaction"
    print "  -h, --help Print this help"
    print ""


def _setEnvironmentVariables(var, value):
    ''' Add to the environment variable `var` the value `value`
    '''
    import os
    import platform
    if os.environ.has_key(var):
        if platform.system() == "Windows":
            os.environ[var] = value + ";" + os.environ[var]
        else:
            os.environ[var] = value + ":" + os.environ[var]
    else:
        os.environ[var] = value

def _runUnitTests():
    import buildingspy.development.regressiontest as u
    ut = u.Tester()
    ut.batchMode(batch)
#    ut.setNumberOfThreads(1)
#    ut.deleteTemporaryDirectories(False)
#    ut.useExistingResults(['/tmp/tmp-Buildings-0-fagmeZ'])
#    #print ut.getDataDictionary()
#    ut.setSinglePackage("Buildings.Examples")
    retVal = ut.run()
    exit(retVal)


if __name__ == '__main__':
    import platform
    batch = False

    try:
        opts, args=getopt.getopt(sys.argv[1:], "hb", ["help", "batch"])
    except getopt.GetoptError, err:
        print str(err)
        usage()
        sys.exit(2)

    for o, a in opts:
        if (o == "-b" or o == "--batch"):
            batch=True
            print "Running in batch mode."
        elif (o == "-h" or o == "--help"):
            usage()
            sys.exit()
        else:
            assert False, "Unhandled option."

    # Set environment variables
    if platform.system() == "Windows":
        _setEnvironmentVariables("PATH", 
                                 os.path.join(os.path.abspath('.'), "Resources", "Library", "win32"))
    else:
        _setEnvironmentVariables("LD_LIBRARY_PATH", 
                                 os.path.join(os.path.abspath('.'), "Resources", "Library", "linux32"))

    # The path to buildingspy must be added to sys.path to work on Linux.
    # If only added to os.environ, the Python interpreter won't find buildingspy
    sys.path.append(os.path.join(os.path.abspath('.'), "..", "..", "BuildingsPy"))


    _runUnitTests()

