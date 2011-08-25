#!/usr/bin/env python
#######################################################
# Script that runs all unit tests.
#
#
# MWetter@lbl.gov                            2011-02-23
#######################################################

def runSimulation(worDir):
    ''' Runs the simulation.

    :param worDir: The working directory.

    .. note:: This method is outside the class definition to
              allow parallel computing.
    '''
    import os
    import sys
    import subprocess
    import buildingspy.development.unittest as u
    try:
        logFilNam=os.path.join(worDir, 'stdout.log')
        logFil = open(logFilNam, 'w')
        print "Starting simulation in ", worDir
        t = u.Tester()
        retcode = subprocess.Popen(args=[t.getModelicaCommand(), "runAll.mos", "/nowindow"], 
                                   stdout=logFil,
                                   stderr=logFil,
                                   shell=False, 
                                   cwd=os.path.join(worDir, "Buildings") ).wait()

        logFil.close()
        if retcode != 0:
            print "Child was terminated by signal", retcode
            return retcode
        else:
            return 0
    except OSError as e:
        print "Execution of ", command, " failed:", e


class Tester:
    ''' Class that runs all unit tests using Dymola.
    
    This class can be used to run all unit tests.
    It searches the directory ``Buildings\Resources\Scripts\Dymola`` for 
    all ``*.mos`` files that contain the string ``simulate``. 
    All these files will be executed as part of the unit tests.
    Any variables or parameters that are plotted by these ``*.mos`` files
    will be compared to previous results that are stored in 
    ``Buildings\Resources\ReferenceResults\Dymola``.
    If no reference results exist, then they will be created.
    Otherwise, the accuracy of the new results is compared to the
    reference results. If they differ by more than a prescibed
    tolerance, a plot is shown that shows the old data, the new data
    and a vertical line where the biggest error occurs.
    The user is then asked to accept or reject the new results.

    To run the unit tests, type

    >>> import buildingspy.development.unittest as u
    >>> ut = u.Tester()
    >>> ut.run()

    '''
    def __init__(self):
        import os
        import multiprocessing
        # --------------------------
        # Class variables
        self.__libHome=os.path.abspath(".")
        self.__modelicaCmd='dymola'
        self.__nPro = multiprocessing.cpu_count()
        self.__batch = False

        # List of scripts that should be excluded from the unit tests
        #self.__excludeMos=['Resources/Scripts/Dymola/Airflow/Multizone/Examples/OneOpenDoor.mos']
        self.__excludeMos=[]

        # Number of data points that are used
        self.__nPoi = 100

        # List of temporary directories that are used to run the simulations.
        self.__temDir = []

        # Flag to delete temporary directories.
        self.__deleteTemporaryDirectories = True

        # Flag to use existing results instead of running a simulation
        self.__useExistingResults = False

        # Dictionary with keys being the matlab file name (without path), and value being the directory 
        # in which the matlab file will be generated
        self.__matToDir = dict()


    def useExistingResults(self, dirs):
        ''' This function allows to use existing results, as opposed to running a simulation.
        
        :param dirs: A non-empty list of directories that contain existing results.

        This method can be used for testing and debugging. If called, then no simulation is
        run. Use as

        >>> import buildingspy.development.unittest as u
        >>> ut = u.Tester()
        >>> ut.useExistingResults(['/tmp/tmp-Buildings-0-zABC44', '/tmp/tmp-Buildings-0-zQNS41'])
        >>> ut.run()

        This method assumes that the directories ``['/tmp/tmp-Buildings-0-zABC44', '/tmp/tmp-Buildings-0-zQNS41']``
        contain previous results.
        '''
        if len(dirs) == 0:
            raise ValueError("Argument 'dirs' of function 'useExistingResults(dirs)' must have at least one element.")
            
        self.setNumberOfThreads(len(dirs))
        self.__temDir = dirs
        self.deleteTemporaryDirectories(False)
        self.__useExistingResults = True

    def setNumberOfThreads(self, number):
        ''' Set the number of parallel threads that are used to run the unit tests.
        
        :param number: The number of parallel threads that are used to run the unit tests.

        By default, the number of parallel threads are set to be equal to the number of
        processors of the computer.
        '''
        self.__nPro = number


    def batchMode(self, batchMode):
        ''' Set the batch mode flag.
        
        :param batchMode: Set to ``True`` to run without interactive prompts 
                          and without plot windows.

        By default, the unit tests require the user to respond if results differ from previous simulations.
        This method can be used to run the script in batch mode, suppressing all prompts that require
        the user to enter a response. If run in batch mode, no new results will be stored.
        To run the unit tests in batch mode, enter
        
        >>> import buildingspy.development.unittest as u
        >>> ut = u.Tester()
        >>> ut.batchMode(True)
        >>> ut.run()

        '''
        self.__batch = batchMode

    def getModelicaCommand(self):
        ''' Return the name of the modelica executable.
        
        :return: The name of the modelica executable.

        '''
        return self.__modelicaCmd
    
    # --------------------------
    # Check if argument is an executable
    def isExecutable(self, program):
        import os
        import platform

        def is_exe(fpath):
            return os.path.exists(fpath) and os.access(fpath, os.X_OK)

        # Add .exe, which is needed on Windows 7 to test existence
        # of the program
        if platform.system() == "Windows":
            program=program + ".exe"

        if is_exe(program):
            return True
        else:
            for path in os.environ["PATH"].split(os.pathsep):
                exe_file = os.path.join(path, program)
                if is_exe(exe_file):
                    return True
        return False

    def checkPythonModuleAvailability(self):
        ''' Check whether all required python modules are installed.

            If some modules are missing, then an `ImportError` is raised.
        '''
        requiredModules = ['buildingspy', 'matplotlib.pyplot', 'numpy', 'scipy.io']
        missingModules = []
        for module in requiredModules:
            try:
                __import__(module)
            except ImportError:
                missingModules.append( module )

        if len(missingModules) > 0:
            msg = "The following python module(s) are required but failed to load:\n"
            for mod in missingModules:
                msg += "  " + mod + "\n"
            msg += "You need to install these python modules to use this script.\n"
            raise ImportError(msg)

    # --------------------------
    # Check wether the file 'fileName' contains the string 'key'
    # as the first string on the first or second line
    # If 'key' is found, increase the counter
    def __checkKey(self, key, fileName, counter):
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
    def __includeFile(self, fileName):
        ''' Returns true if the file need to be included in the list of scripts to run

        :param: fileName The name of the file.

        The parameter *fileName* need to be of the form
        *Resources/Scripts/Dymola/Fluid/Actuators/Examples/Damper.mos*
        or *Resources/Scripts/someOtherFile.ext*.
        This function checks if *fileName* exists in the global list
        self.__excludeMos. During this check, all backward slashes will
        be replaced by a forward slash.
    '''
        pos=fileName.find('.mos')
        if pos > -1: # This is an mos file
            # Check whether the file is in the exclude list
            fileName = fileName.replace('\\', '/')

            # Remove all files, except a few for testing
    #        test=os.path.join('Resources','Scripts','Dymola','Controls','Continuous','Examples')
    ##        test=os.path.join('Resources', 'Scripts', 'Dymola', 'Fluid', 'Movers', 'Examples')
    ##        if fileName.find(test) != 0:
    ##            return False

            if (self.__excludeMos.count(fileName) == 0):
                return True
            else:
                print "*** Warning: Excluded file ", fileName, " from the unit tests."
                return False
        else:
            False


    # --------------------------
    def __getUnitTests(self, libDir, datDic):
        ''' Return a dictionary with the full name of the ``*.mos`` file as a key,
            and the ``*.mat`` file name as a value.

            :return: A dictionary with the full name of the ``*.mos`` file as a key,
            and the ``*.mat`` file name as a value.
        '''
        import os
        listOfTests = dict()
        for root, dirs, files in os.walk(libDir):
            pos=root.find('svn')
            # skip svn folders
            if pos == -1:
                for filNam in files:
                    # find files that contain simulate command
                    mosDir = root[len(libDir)+1:]
                    filRelNam=os.path.join(mosDir, filNam)
                    if self.__includeFile(filRelNam):
                        filObj=open(filRelNam, 'r')
                        filTex=filObj.read()
                        strpos=filTex.find("simulate")
                        filObj.close()
                        if strpos > -1:
                            res = datDic[filNam] # res is a dictionary of matlab file name and results
                            listOfTests[filNam]={'mosDir': mosDir, 'matFil': res['matFil']}
        return listOfTests

    # --------------------------
    # --------------------------
    # Check md5 sum of .mat files versus the ones from the library home folder.
    # If they differ, ask the user whether to accept the differences.
    # If there is no md5 sum in the library home folder, ask the user whether it
    # should be generated.
    def __checkMD5Sum(self, worDir, ans):
        import os
        import hashlib
        for filNam in os.listdir(os.path.join(worDir, "Buildings")):
            # find .mat files
            pos=filNam.find('.mat')
            if pos > -1:
                # Compute md5 sum of new unit test result
                fulFilNam=os.path.join(worDir, "Buildings", filNam)
                fMat = open(fulFilNam,'rb')
                md5 = hashlib.md5()
                md5.update(fMat.read())
                md5New = md5.hexdigest()
                fMat.close()

                # Reset answer, unless it is set to Y or N
                if not (ans == "Y" or ans == "N"):
                    ans = "-"

                # check if .mat already exists in library
                md5FilOld = os.path.join(self.__libHome, "..", "md5sum", filNam) + ".md5"
                if os.path.exists(md5FilOld):  # md5 file exists. Check if the md5 sum changed
                    fMD5 = open(md5FilOld, 'r')
                    md5Old = fMD5.readline()
                    md5Old = md5Old[:-1] # remove carriage return
                    fMD5.close()
                    if md5New != md5Old:
                        print "*** Warning: md5sum changed in ", filNam
                        print "    Old md5sum: ", md5Old
                        print "    New md5sum: ", md5New
                        while not (ans == "n" or ans == "y" or ans == "Y" or ans == "N"):
                            print "    Accept new file and update md5 sum in library?"
                            ans = raw_input("    Enter: y(yes), n(no), Y(yes for all), N(no for all): ")
                        if ans == "y" or ans == "Y":
                            # Write md5 sum to new file
                            fMD5 = open(md5FilOld, 'w')
                            fMD5.write(md5New + "\n")
                            fMD5.close()
                            print "Updated md5 sum in ", md5FilOld
                else: # md5 does not exist.
                    print "*** Warning: md5 sum does not yet exist for ", filNam
                    while not (ans == "n" or ans == "y" or ans == "Y" or ans == "N"):
                        print "    Create new file in library?"
                        ans = raw_input("    Enter: y(yes), n(no), Y(yes for all), N(no for all): ")
                    if ans == "y" or ans == "Y":
                        # Write md5 sum to new file
                        fMD5 = open(md5FilOld, 'w')
                        fMD5.write(md5New + "\n")
                        fMD5.close()
                        print "Wrote ", md5FilOld
        return ans

    # --------------------------
    # finds the MOS file corresponding to the "fileName" and returns a list 
    # of "plotVariables" mentioned in it
    def getDataDictionary(self):
        ''' Return a list of variables that are in the plot command and the associate ``*.mat`` file name.

        :return: A dictionary with keys equal to the ``*.mos`` file name, and values
                 containing a dictionary with keys ``matFil`` and ``y``.

                 The values of ``y`` is a list of the 
                 form `[[a.x, a.y], [b.x, b.y1, b.y2]]` if the
                 mos file plots `a.x` versus `a.y` and `b.x` versus `(b.y1, b.y2)`.
        '''
        import os
        import re

        retVal = dict()
        for root, dirs, files in os.walk(os.path.join(self.__libHome, 'Resources', 'Scripts', 'Dymola')):
            pos=root.find('svn')
            # skip svn folders
            if pos == -1:
                for mosFil in files:
                    # find the desired mos file
                    pos=mosFil.endswith('.mos')
                    if pos > -1 and not mosFil.startswith("ConvertBuildings"):
                        plotVars = []
                        matFil = ""
                        # open the mos file and read its content.
                        fMOS=open(os.path.join(root, mosFil), 'r')
                        Lines=fMOS.readlines()
                        fMOS.close()
                        # Remove white spaces
                        for i in range(len(Lines)):
                            Lines[i] = Lines[i].replace(' ', '')

                        for lin in Lines:
                            if 'y={' in lin:
                                var=re.search('{.*?}', lin).group()
                                var=var.strip('{}"')
                                y = var.split('","')
                                plotVars.append(y)

                        # search for the result file
                        for lin in Lines:
                            if 'resultFile=\"' in lin:
                                matFil = re.search('(?<=resultFile=\")\w+', lin).group()
                                matFil =  matFil + '.mat'
                                break
                        # Some *.mos file only contain plot commands, but no simulation.
                        # Hence, if 'resultFile=' could not be found, try to get the file that
                        # is used for plotting.
                        if len(matFil) == 0:
                            for lin in Lines:
                                if 'filename=\"' in lin:
                                    matFil = re.search('(?<=filename=\")\w+', lin).group()
                                    matFil = matFil + '.mat'
                                    break
                        if len(matFil) == 0:
                            raise  ValueError('Did not find *.mat file in ' + mosFil)
                        value = {'matFil': matFil, 'y': plotVars}
                        retVal[mosFil] = value
        return retVal

    def __getSimulationResults(self, mosFil, results):
        '''
        Get the simulation results.

        :param worDir: The current working directory.
        :param fileNam: The result `*.mat` file.
        :param ploVarNam: The list of variables that are plotted together.
        :param mosFilNam: The `*.mos` file name (used for reporting only).

        Extracts and returns the simulation results from the `*.mat` file as
        a list of dictionaries. Each element of the list contains a dictionary
        of results that need to be printed together.
        '''    
        import os
        from buildingspy.io.outputfile import Reader


        # Get the working directory that contains the ".mat" file
        matFil = results['matFil']
        worDir = self.__matToDir[matFil]
        fulFilNam=os.path.join(worDir, "Buildings", matFil)
        ret=[]
        try:
            r=Reader(fulFilNam, "dymola") 
        except IOError as e:
            print "*** Warning: Failed to read ", fulFilNam, ", generated by ", mosFil, "."
        else:
            for pai in results['y']: # pairs of variables that are plotted together
                foundData = False # This ensures that time is in all data series
                dat=dict()
                for var in pai:
                    try:
                        (time, val) = r.values(var)
                    except KeyError:
                        print "*** Warning: ", mosFil, " uses ", var, " which does not exist in result file."
                    except IndexError:
                        print "*** Warning: IndexError in DyMat.py when reading ", var, " from ", fulFilNam, "."
                        print "             Variable will not be used in comparison."
                    else:
                        # Number of data point that are compared
                        nPoi = min(self.__nPoi, len(val))
                        step = max(1, round(len(time)/nPoi))
                        if (not foundData) and len(time) > 2:
                            dat['time']=time[::step]
                            foundData = True
                        dat[var]=val[::step]
                if foundData:
                    ret.append(dat)
        return ret

    def __areResultsEqual(self, tOld, yOld, tNew, yNew, varNam, filNam):
        ''' Return `True` if the data series are equal within a tolerance.

        :param tOld: List of old time values.
        :param yOld: Old simulation results.
        :param tNew: Time stamps of new results.
        :param yNew: New simulation results.
        :param varNam: Variable name, used for reporting.
        :param filNam: File name, used for reporting.
        :return: A list with ``False`` if the results are not equal, and he time 
                 of the maximum error.
        '''
        import numpy as np

        timMaxErr = 0

        tol=1E-3  #Tolerance

        # Interpolate the new variables to the old time stamps
        if self.__isParameter(yNew):
            yInt = yNew
        else:
            yInt=np.interp(tOld, tNew, yNew)

        errAbs=np.zeros(len(yInt))
        errRel=np.zeros(len(yInt))
        errFun=np.zeros(len(yInt))

        # Compute error for the variable with name varNam
        for i in range(len(yInt)):
            errAbs[i] = abs( yOld[i] - yInt[i] )
            if ( errAbs[i] == float('NaN') ):
                raise ValueError('NaN in errAbs ' + varNam + " "  + str(yOld[i]) + "  " + str(yInt[i]))
            if (abs(yOld[i]) > 1E-3):
                errRel[i] = errAbs[i] / abs( yOld[i] )
            else:
                errRel[i] = 0
            errFun[i] = errAbs[i] + errRel[i]
        if max(errFun) > tol:
            iMax = 0
            eMax = 0
            for i in range(len(errFun)):
                if errFun[i] > eMax:
                    iMax = i
            timMaxErr = tOld[iMax]
            print "*** Warning: ", filNam, ":", varNam, " has absolute and relative error = ", \
                                   str(max(errAbs)), " ", str(max(errRel))
            print "             Maximum error is at t = ", timMaxErr
            return (False, timMaxErr)
        else:
            return (True, timMaxErr)


    def __isParameter(self, dataSeries):
        ''' Return `True` if `dataSeries` is from a parameter.
        '''
        return (len(dataSeries) == 2)

    def __writeReferenceResults(self, refFilNam, dic):
        ''' Write the reference results.

        :param refFilNam: The name of the reference file.
        :param dic: The data dictionary for the reference files
        :return: A dictionary with the reference results.

        This method writes the results in the form ``key=value``, with one line per entry.
        '''
        def format(value):
            return "%.20f" % value

        f=open(refFilNam,'w')
        f.write('svn-id=$Id$\n')
        f.write('last-generated=' + dic['last-generated'] + '\n')
        res = dic['results']
        for pai in res:
            for k, v in pai.items():
                f.write(k + '=')
                # Use many digits, otherwise truncation errors occur that can be higher
                # than the required accuracy.
                formatted = [format(e) for e in v]
                f.write(str(formatted).replace("'", ""))
                f.write('\n')
        f.close()

    def __readReferenceResults(self, refFilNam):
        ''' Read the reference results.

        :param refFilNam: The name of the reference file.
        :return: A dictionary with the reference results.

        '''
        import string
        import numpy

        d = dict()
        f=open(refFilNam,'r')
        lines = f.readlines()
        f.close()

        d['svn-id'] = lines[0].split("svn-id=")
        d['last-generated']      = lines[1].split("last-generated=")

        r = dict()
        for i in range(2, len(lines)):
            lin = lines[i].strip('\n')
            (key, value) = lin.split("=")
            s = (value[value.find('[')+1: value.rfind(']')]).strip()
            numAsStr=s.split(',')
            val = []
            for num in numAsStr:
                # We need to use numpy.float32 here for the comparison to work
                val.append(numpy.float32(num)) 
            r[key] = val
        d['results'] = r
        return d

    # --------------------------
    # compares the old reference data with the new reference data
    # If the simulation time of the new data is different from the simulation time of
    # the old data raises a warning and theuser can choose wether to accept th enew data or not.
    # Otherwise, compares the old and new reference data, if the error is more than the tolerance,
    # switches the flag "foundError" to Ture and asks th euser wethe rto accept the new data or not.
    # If the user chooses yes, it switches the flag "updateReferenceData" to Ture.
    def __compareResults(self, filNam, oldRefFulFilNam, simRes, refFilNam, ans):
        import matplotlib.pyplot as plt
        import numpy

        # Reset answer, unless it is set to Y or N
        if not (ans == "Y" or ans == "N"):
            ans = "-"
        updateReferenceData = False
        foundError = False
        verifiedTime = False

        #Load the old data (in dictionary format)
        d = self.__readReferenceResults(oldRefFulFilNam)
        oldDatSam=d['results']

        if len(oldDatSam) == 0:
            # The existing reference data has no results.
            if len(simRes) == 0:
                # The simulation has also no results
                return (updateReferenceData, foundError, ans)
            else:
                print "*** Warning: The old reference data had no results, but the new simulation produced results"
                print "             for ", refFilNam
                print "             Accept new results?"
            while not (ans == "n" or ans == "y" or ans == "Y" or ans == "N"):
                ans = raw_input("   Enter: y(yes), n(no), Y(yes for all), N(no for all): ")
            if ans == "y" or ans == "Y":
                # update the flag 
                updateReferenceData = True
            return (updateReferenceData, foundError, ans)

        # The old data contains results
        oldTimSam=oldDatSam.get('time')


        # Iterate over the pairs of data that are to be plotted together
        timOfMaxErr = []
        for pai in simRes:
            timSam=pai['time']
            if not verifiedTime:
                verifiedTime = True

                # Check if the first and last time stamp are equal
                tolTim = 1E-3 # Tolerance for time
                if (abs(oldTimSam[0] - timSam[0]) > tolTim) or abs(oldTimSam[-1] - timSam[-1]) > tolTim: 
                    print "***Warning: The simulation time interval in"
                    print "   file: ", refFilNam
                    print "   is not consistent with the old one"
                    print "   Old reference points are for " , oldTimSam[0], ' <= t <= ', oldTimSam[-1]
                    print "   New reference points are for " , timSam[0], ' <= t <= ', timSam[-1]
                    foundError = True
                    while not (ans == "n" or ans == "y" or ans == "Y" or ans == "N"):
                        print "    Accept new results and update reference file in library?"
                        ans = raw_input("    Enter: y(yes), n(no), Y(yes for all), N(no for all): ")
                    if ans == "y" or ans == "Y":
                        # Write results to reference file
                        updateReferenceData = True
                        return (updateReferenceData, foundError, ans)

            # The time interval is the same for the stored and the current data.
            # Check the accuracy of the simulation.
            noOldResults = [] # List of variables for which no old results have been found
            for varNam in pai.keys(): # Iterate over the variable names that are to be plotted together
                if varNam != 'time':
                    if oldDatSam.has_key(varNam):
                        # Check results
                        (res, timMaxErr) = self.__areResultsEqual(oldTimSam, oldDatSam[varNam], 
                                                     timSam, pai[varNam], varNam, filNam)
                        if not res:
                            foundError = True
                            timOfMaxErr.append(timMaxErr)
                    else:
                        # There is no old data series for this variable name
                        print "*** Warning: Did not find variable ", varNam , " in old results."
                        foundError = True
                        noOldResults.append(varNam)

        # If we found an error, plot the results, and ask the user to accept or reject the new values
        if foundError and not self.__batch:
            print "   Acccept new file and update reference files? (Close plot window to continue.)"
            for pai in simRes:
                for varNam in pai.keys(): # Iterate over the variable names that are to be plotted together
                    if varNam != 'time':
                        if self.__isParameter(pai[varNam]):
                            t = [min(timSam), max(timSam)]
                        else:
                            t = timSam
                        plt.plot(t, pai[varNam], label='New ' + varNam)

                        # Test to make sure that this variable has been found in the old results
                        if noOldResults.count(varNam) == 0:
                            oldVarValSam=oldDatSam[varNam]
                            if self.__isParameter(oldVarValSam):
                                t = [min(oldTimSam), max(oldTimSam)]
                            else:
                                t = oldTimSam
                            plt.plot(t, oldVarValSam, label='Old ' + varNam)

                # Plot the location of the maximum error
                for timMaxErr in timOfMaxErr:
                    plt.axvline(x=timMaxErr)
                leg = plt.legend(loc='best', fancybox=True)
                leg.get_frame().set_alpha(0.5) # transparent legend
                plt.xlabel('time')
                plt.title(filNam)
                plt.grid(True)
                plt.show()
            while not (ans == "n" or ans == "y" or ans == "Y" or ans == "N"):
                ans = raw_input("   Enter: y(yes), n(no), Y(yes for all), N(no for all): ")
            if ans == "y" or ans == "Y":
                # update the flag 
                updateReferenceData = True
        return (updateReferenceData, foundError, ans)

    # --------------------------
    # Check reference points from each unit test and compare it with the previously
    # saved reference points of the same test stored in the library home folder.
    # If all the reference points are not within a certain tolerance with the previous results,
    # show a warning message containing the "file name" and "path".
    # If there is no .mat file of the reference points in the library home folder,
    # ask the user whether it should be generated.
    def __checkReferencePoints(self, datDic, ans):
        import os
        import scipy.io
        import shutil
        from datetime import date

        for k, v in datDic.iteritems():
            # k is the name of the matlab file
            # v are the variables that need to be extracted from this matlab file

            # Name of the reference file, which is the same as that matlab file name but with another extension
            refFilNam=k[:len(k)-4] + ".txt" 

            # extract reference points from the ".mat" file corresponding to "filNam"
            simRes=self.__getSimulationResults(k, v)
            # Reset answer, unless it is set to Y or N
            if not (ans == "Y" or ans == "N"):
                ans = "-"
            #Check if the directory "self.__libHome\\Resources\\ReferenceResults\\Dymola" exists, if not create it.
            refDir=os.path.join(self.__libHome, 'Resources', 'ReferenceResults', 'Dymola')   
            if not os.path.exists(refDir):
                os.makedirs(refDir)               

            updateReferenceData = False
            # check if reference results already exists in library
            oldRefFulFilNam=os.path.join(refDir, refFilNam)  
            # If the reference file exists, and if the reference file contains results, compare the results.
            if os.path.exists(oldRefFulFilNam):
                # compare the new reference data with the old one
                [updateReferenceData, foundError, ans]=self.__compareResults(
                    v['matFil'], oldRefFulFilNam, simRes, refFilNam, ans)
            else:
                # Reference file does not exist
                print "*** Warning: Reference file ", refFilNam, " does not yet exist."
                while not (ans == "n" or ans == "y" or ans == "Y" or ans == "N"):
                    print "    Create new file?"
                    ans = raw_input("    Enter: y(yes), n(no), Y(yes for all), N(no for all): ")
                if ans == "y" or ans == "Y":
                    updateReferenceData = True
            if updateReferenceData:    # If the reference data of any variable was updated
                # Make dictionary to save the results and the svn information
                dic = {'last-generated': str(date.today()), 'results': simRes}
                self.__writeReferenceResults(oldRefFulFilNam, dic)

        return ans

    # --------------------------
    def __checkSimulationError(self, errorFile):
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
    def printNumberOfClasses(self, dir):
        import os

        iMod=0
        iBlo=0
        iFun=0
        for root, dirs, files in os.walk(self.__libHome):
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
                        iMod = self.__checkKey("model", filFulNam, iMod)
                        iBlo = self.__checkKey("block", filFulNam, iBlo)
                        iFun = self.__checkKey("function", filFulNam, iFun)
        print "Number of models   : ", str(iMod)
        print "          blocks   : ", str(iBlo)
        print "          functions: ", str(iFun)

    # --------------------------
    # Write the script that runs all example problems, and
    # that searches for errors
    def __writeRunscripts(self, listOfTests):
        import os

        nUniTes = 0
        self.__matToDir.clear()

        mosFiles = listOfTests.keys()
        mosFiles.sort()
        for iPro in range(self.__nPro):
            runFil=open(os.path.join(self.__temDir[iPro], "Buildings", "runAll.mos"), 'w')
            runFil.write("// File autogenerated for process " 
                         + str(iPro+1) + " of " + str(self.__nPro) + "\n")
            runFil.write("// Do not edit.\n")
            runFil.write("openModel(\"package.mo\");\n")
            runFil.write("Modelica.Utilities.Files.remove(\"unitTests.log\");\n")
            # Write unit tests for this process
            pSta=int(round(iPro*len(mosFiles)/self.__nPro))
            pEnd=int(round((iPro+1)*len(mosFiles)/self.__nPro))

            for i in range(pSta-1,pEnd-1):
                mosFil=mosFiles[i]
                # Write line for run script
                ent = listOfTests[mosFil]
                runFil.write("RunScript(\"" + ent['mosDir'] + "/" + mosFil + "\");\n")
                # Build a dictionary so that we can now in which directory the mat files will be generated
                # Dictionary with keys being the matlab file name (without path), and value being the directory 
                # in which the matlab file will be generated
                self.__matToDir[ ent['matFil'] ] = self.__temDir[iPro]
                nUniTes = nUniTes + 1
            runFil.write("// Save log file\n")
            runFil.write("savelog(\"unitTests.log\");\n")
            runFil.write("exit\n")
            runFil.close()

        print "Generated ", nUniTes, " unit tests.\n"

    def deleteTemporaryDirectories(self, delete):
        ''' Flag, if set to ``False``, then the temporary directories will not be deleted
        after the unit tests are run.
        
        :param delete: Flag, set to ``False`` to avoid the temporary directories to be deleted.
        
        Unless this method is called prior to running the unit tests with ``delete=False``,
        all temporary directories will be deleted after the unit tests.
        '''
        self.__deleteTemporaryDirectories = delete

    # Create the list of temporary directories that will be used to run the unit tests
    def __setTemporaryDirectories(self, nPro):
        import tempfile
        import shutil
        import os

        self.__temDir = []

        # Make temporary directory, copy library into the directory and 
        # write run scripts to directory
        for iPro in range(self.__nPro):
            #print "Calling parallel loop for iPro=", iPro, " self.__nPro=", self.__nPro
            dirNam = tempfile.mkdtemp(prefix='tmp-Buildings-'+ str(iPro) +  "-")
            self.__temDir.append( dirNam )
            shutil.copytree(".." + os.sep + "Buildings", 
                            os.path.join(dirNam, "Buildings"), 
                            symlinks=False, 
                            ignore=shutil.ignore_patterns('.svn', '.mat'))
        return

    #####################################################################################    
    #####################################################################################

    def run(self):
        ''' Runs all unit tests and checks the results.

        :return: 0 if no errros occurred during the unit tests, 
                 otherwise a non-zero value.

        This method

        - creates temporary directories for each processors, 
        - copies the directory 'Buildings' into these
          temporary directories,
        - creates run scripts that run all unit tests,
        - runs these unit tests,
        - collects the dymola log files from each process,
        - writes the combined log file ``unitTests.log``
          to the current directory, 
        - compares the results of the new simulations with
          reference results that are stored in ``Resources/ReferenceResults``,
        - writes the message `Unit tests completed successfully.` 
          if no error occured,
        - returns 0 if no errors occurred, or non-zero otherwise.

        '''
        import multiprocessing
        import sys
        import time
        import os
        import shutil

        self.checkPythonModuleAvailability()

##        (mosFilNam, matFil, plotVariables) = self.getDataDictionary()
        datDic = self.getDataDictionary()

        retVal = 0
        # Start timer
        startTime=time.time()
        # Process command line arguments

        # Check if executable is on the path
        if not self.isExecutable(self.__modelicaCmd):
            print "Error: Did not find executable '", self.__modelicaCmd, "'."
            return 3

        # Check current working directory
        curDir=os.path.split(os.path.abspath("."))[1]
        if curDir != "Buildings":
            print "*** This script must be run from the Buildings directory."
            print "*** Exit with error. Did not do anything."
            return 2

        print "Using ", self.__nPro, " of ", multiprocessing.cpu_count(), " processors to run unit tests."
        # Count number of classes
        self.printNumberOfClasses(".")    

        # Get list of unit tests
        listOfTests = self.__getUnitTests(os.path.abspath(os.path.join("..", "Buildings")), datDic)

        # Run simulations
        if not self.__useExistingResults:
            self.__setTemporaryDirectories(self.__nPro)
        self.__writeRunscripts(listOfTests)
        if not self.__useExistingResults:
            if self.__nPro > 1:
                po = multiprocessing.Pool(self.__nPro)
                po.map(runSimulation, self.__temDir)
            else:
                runSimulation(self.__temDir[0])


        # Concatenate output files into one file
        logFil=open('unitTests.log', 'w')
        for d in self.__temDir:
            temLogFilNam = os.path.join(d, 'Buildings', 'unitTests.log')
            if os.path.exists(temLogFilNam):
                file=open(temLogFilNam,'r')
                data=file.read()
                file.close()
                logFil.write(data)
            else:
                sys.stderr.write("*** Error: Log file '" + temLogFilNam + "' does not exist.\n")
                retVal = 1
        logFil.close()

        # Check reference results
        if self.__batch:
            ans = "N"
        else:
            ans = "-"

        ans = self.__checkReferencePoints(datDic, ans)


        # Delete temporary directories
        if self.__deleteTemporaryDirectories:
            for d in self.__temDir:
                shutil.rmtree(d)

        # Check for errors
        if retVal == 0:
            retVal = self.__checkSimulationError("unitTests.log")
        else:
            self.__checkSimulationError("unitTests.log")

        # Print list of files that may be excluded from unit tests
        if len(self.__excludeMos) > 0:
            print "*** Warning: The following files may be excluded from the unit tests:\n"
            for fil in self.__excludeMos:
                print "            ", fil

        # Print time
        elapsedTime=time.time()-startTime;
        print "Execution time = %.3f s" % elapsedTime

        exit(retVal)
