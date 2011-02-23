#!/usr/bin/python
#######################################################
# Script that runs all unit tests.
#
# This script 
# - creates temporary directories for each processors, 
# - copies the directory 'Buildings' into these
#   temporary directories,
# - creates run scripts that run all unit tests,
# - runs these unit tests,
# - collects the dymola log files from each process,
# - writes the combined log file 'unitTests.log'
#   in the current directory, and
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
import os, string, fnmatch, os.path, sys
import tempfile, shutil
import multiprocessing
# --------------------------
# Global settings
LIBHOME=os.path.abspath(".")
MODELICA_EXE='dymola'
NPRO=multiprocessing.cpu_count()
# Number of processors used to run the unit tests
##if multiprocessing.cpu_count() >= 16:
##    NPRO=multiprocessing.cpu_count()-4
##elif multiprocessing.cpu_count() >= 8:
##    NPRO=multiprocessing.cpu_count()-2
##else:
##    NPRO=multiprocessing.cpu_count()
print "Using ", NPRO, " of ", multiprocessing.cpu_count(), " processors to run unit tests."

# --------------------------
# Check if argument is an executable
def isExecutable(program):
    import os
    def is_exe(fpath):
        return os.path.exists(fpath) and os.access(fpath, os.X_OK)

    if is_exe(program):
        return True
    else:
        for path in os.environ["PATH"].split(os.pathsep):
            exe_file = os.path.join(path, program)
            if is_exe(exe_file):
                return True
    return False

# --------------------------
# Check wether the file 'fileName' contains the string 'key'
# as the first string on the first or second line
# If 'key' is found, increase the counter
def checkKey(key, fileName, counter):
    filObj=open(fileName, 'r')
    filTex=filObj.readline()
    # Strip white spaces so we can test strpos for zero.
    # This test returns non-zero for partial classes.
    filTex.strip()
    strpos=filTex.find("within")
    if strpos == 0:
        # first line is "within ...
        # get second line
        filTex=filObj.readline()
        filTex.strip()
    strpos=filTex.find(key)
    if strpos == 0:
        counter += 1;
    filObj.close()
    return counter

# --------------------------
def getUnitTests(listOfTests, libDir):
    for root, dirs, files in os.walk(libDir):
        pos=root.find('svn')
        # skip svn folders
        if pos == -1:
            for filNam in files:
                # find .mos files
                pos=filNam.find('.mos')
                if pos > -1:
                    # find files that contain simulate command
                    filFulNam=os.path.join(root, filNam)
                    filObj=open(filFulNam, 'r')
                    filTex=filObj.read()
                    strpos=filTex.find("simulate")
                    if strpos > -1:
                        listOfTests.append("RunScript(\""
                                           + os.path.join(root, filNam) 
                                           + "\");\n")
                    filObj.close()

# --------------------------
def runSimulation(worDir):
    import sys
    import subprocess
    try:
        print "Starting ", MODELICA_EXE, " in ", worDir
        logFil = open(os.path.join(worDir, "stdout.log"), 'w')
        retcode = subprocess.Popen(args=[MODELICA_EXE, "runAll.mos", "/nowindow"], 
                                   stdout=logFil,
                                   stderr=logFil,
                                   shell=False, 
                                   cwd=os.path.join(worDir, "Buildings") ).wait()

        print worDir , " had exit code ", retcode
        logFil.close()
        if retcode != 0:
            print "Child was terminated by signal", retcode
            return retcode
        else:
            return 0
    except OSError as e:
        print "Execution of ", command, " failed:", e
        
# --------------------------
def checkSimulationError(errorFile):
    import os.path
    import sys
    fil = open(errorFile, "r")
    i=0
    for lin in fil.readlines():
	    if (lin.count("false") > 0):
		    i=i+1
    fil.close() #Closes the file (read session)
    if (i>0):
	    print "*** Error: Unit tests had", i, "error(s)."
	    print "    Search 'unitTests.log' for 'false' to see details."
	    return 1
    else:
	    print "Unit tests completed successfully."
	    return 0

		
# --------------------------
def countClasses(dir):
    iMod=0
    iBlo=0
    iFun=0
    for root, dirs, files in os.walk(LIBHOME):
        pos=root.find('svn')
        # skip svn folders
        if pos == -1:
            for filNam in files:
                # find .mo files
                pos=filNam.find('.mo')
                posExa=root.find('Examples')
                if pos > -1 and posExa == -1:
                     # find classes that are not partial
                    filFulNam=os.path.join(root, filNam)
                    iMod = checkKey("model", filFulNam, iMod)
                    iBlo = checkKey("block", filFulNam, iBlo)
                    iFun = checkKey("function", filFulNam, iFun)
    print "Number of models   : ", str(iMod)
    print "          blocks   : ", str(iBlo)
    print "          functions: ", str(iFun)
      
# --------------------------
# Write the script that runs all example problems, and
# that searches for errors
def writeRunscript(temDirNam, iPro, NPRO):
    listOfTests = []
    getUnitTests(listOfTests, os.path.join(temDirNam, "Buildings"))

    runFil=open(os.path.join(temDirNam, "Buildings", "runAll.mos"), 'w')
    runFil.write("// File autogenerated for process " 
                 + str(iPro+1) + " of " + str(NPRO) + "\n")
    runFil.write("// Do not edit.\n")
    runFil.write("openModel(\"package.mo\");\n")
    runFil.write("Modelica.Utilities.Files.remove(\"unitTests.log\");\n")
    # Write unit tests for this process
    pSta=int(round(iPro*len(listOfTests)/NPRO))
    pEnd=int(round((iPro+1)*len(listOfTests)/NPRO))
    print "Making unit tests ", pSta, " to ", pEnd
    for i in range(pSta-1,pEnd-1):
        runFil.write(listOfTests[i])
    runFil.write("// Save log file\n")
    runFil.write("savelog(\"unitTests.log\");\n")
    runFil.write("exit\n")
    runFil.close()
    if iPro == 0:
        print "Generated ", len(listOfTests), " unit tests.\n"

#####################################################################################
# Check if executable is on the path
if not isExecutable(MODELICA_EXE):
	print "Error: Did not find executable '", MODELICA_EXE, "'."
	exit(3)

# Check current working directory
curDir=os.path.split(os.path.abspath("."))[1]
if curDir != "Buildings":
    print "*** This script must be run from the Buildings directory."
    print "*** Exit with error. Did not do anything."
    exit(2)

# Count number of classes
countClasses(".")    
# List of temporary directories for running the tests
temDirNam = []

# Make temporary directory, copy library into the directory and 
# write run scripts to directory
for iPro in range(NPRO):
    temDirNam.append( tempfile.mkdtemp(prefix='tmp-Buildings-') )
    shutil.copytree(".." + os.sep + "Buildings", 
                    os.path.join(temDirNam[iPro], "Buildings"), 
                    symlinks=False, 
                    ignore=shutil.ignore_patterns('.svn', '.mat'))
    writeRunscript(temDirNam[iPro], iPro, NPRO)    
    
# Start all unit tests in parallel
if __name__ == '__main__':
    from multiprocessing import Pool
    po = Pool(NPRO)
    po.map(runSimulation, temDirNam)

# Concatenate output files into one file
logFil=open('unitTests.log', 'w')
for d in temDirNam:
    file=open(os.path.join(d, 'Buildings', 'unitTests.log'),'r')
    data=file.read()
    file.close()
    logFil.write(data)
logFil.close()

# Delete temporary directories
for d in temDirNam:
    shutil.rmtree(d)

# Check for errors
retVal=checkSimulationError("unitTests.log")

exit(retVal)
