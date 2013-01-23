#!/usr/bin/env python
#######################################################
# Script that runs all unit tests.
#
#
# MWetter@lbl.gov                            2011-02-23
#######################################################

def runSimulation(worDir):
    ''' Run the simulation.

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
        sys.stderr.write("Execution of " + [t.getModelicaCommand(), "runAll.mos", "/nowindow"] + " failed.")
        raise(e)


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
    tolerance, a plot such as the one below is shown.

    .. figure:: img/unitTestPlot.png
       :scale: 75%

       Plot that compares the new results (solid line) of the unit test with the old results (dotted line).
       The blue line indicates the time where the largest error occurs.

    In this plot, the vertical line indicates the time where the biggest error 
    occurs.
    The user is then asked to accept or reject the new results.

    To run the unit tests, type

    >>> import buildingspy.development.unittest as u
    >>> ut = u.Tester()
    >>> ut.run()

    '''
    def __init__(self):
        import os
        import multiprocessing
        import buildingspy.io.reporter as rep

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
        self.__nPoi = 101

        # List of temporary directories that are used to run the simulations.
        self.__temDir = []

        # Flag to delete temporary directories.
        self.__deleteTemporaryDirectories = True

        # Flag to use existing results instead of running a simulation
        self.__useExistingResults = False

        ''' Dictionary with keys equal to the ``*.mos`` file name, and values
                 containing a dictionary with keys ``matFil`` and ``y``.

                 The values of ``y`` are a list of the 
                 form `[[a.x, a.y], [b.x, b.y1, b.y2]]` if the
                 mos file plots `a.x` versus `a.y` and `b.x` versus `(b.y1, b.y2)`.
        '''
        self.__data = []
        self.__reporter = rep.Reporter("unitTests.log")

    def useExistingResults(self, dirs):
        ''' This function allows to use existing results, as opposed to running a simulation.
        
        :param dirs: A non-empty list of directories that contain existing results.

        This method can be used for testing and debugging. If called, then no simulation is
        run.
        If the directories 
        ``['/tmp/tmp-Buildings-0-zABC44', '/tmp/tmp-Buildings-0-zQNS41']``
        contain previous results, then this method can be used as

        >>> import buildingspy.development.unittest as u
        >>> l=['/tmp/tmp-Buildings-0-zABC44', '/tmp/tmp-Buildings-0-zQNS41']
        >>> ut = u.Tester()
        >>> ut.useExistingResults(l)
        >>> ut.run()

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

        :param: fileName The name of the ``*.mos`` file.

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

    def setDataDictionary(self):
        ''' Build the data structures that are needed to parse the output files.

        '''
        import os
        import re
        import sys
        import buildingspy.development.data as data

        scrPat = os.path.join(self.__libHome, 'Resources', 'Scripts', 'Dymola')
        for root, dirs, files in os.walk(scrPat):
            pos=root.find('.svn')
            # skip .svn folders
            if pos == -1:
                for mosFil in files:
                    # find the desired mos file
                    pos=mosFil.endswith('.mos')
                    if pos > -1 and not mosFil.startswith("ConvertBuildings"):
                        matFil = ""
                        dat = data.Data()
                        dat.setScriptDirectory(root[len(scrPat)+1:])
                        dat.setScriptFile(mosFil)
                        dat.mustSimulate(False)

                        # open the mos file and read its content.
                        # Path and name of mos file without 'Resources/Scripts/Dymola'
                        fMOS=open(os.path.join(root, mosFil), 'r')
                        Lines=fMOS.readlines()
                        fMOS.close()

                        # Remove white spaces
                        for i in range(len(Lines)):
                            Lines[i] = Lines[i].replace(' ', '')

                        # Check if the file contains the simulate command
                        if self.__includeFile(os.path.join(root, mosFil)):
                            for lin in Lines:
                                if (lin.find("simulate")) > -1:
                                    dat.mustSimulate(True)
                                    break

                        plotVars = []
                        print "---- Test ", os.path.join(root, mosFil)
                        iLin=0
                        for lin in Lines:
                            iLin=iLin+1
                            if 'y={' in lin:
                                try:
                                    var=re.search('{.*?}', lin).group()
                                except AttributeError as e:
                                    s =  "%s, line %s, could not be parsed.\n" % (mosFil, iLin)
                                    s +=  "The problem occurred at the line below:\n"
                                    s +=  "%s\n" % lin
                                    s += "Make sure that each assignment of the plot command is on one line.\n"
                                    s += "Unit tests failed with error.\n"
                                    self.__reporter.writeError(s)
                                    raise
                                var=var.strip('{}"')
                                y = var.split('","')
                                # Replace a[1,1] by a[1, 1], which is required for the
                                # Reader to be able to read the result.
                                for i in range(len(y)):
                                    y[i] = y[i].replace(",", ", ")
                                plotVars.append(y)
                        if len(plotVars) == 0:
                            s =  "%s does not contain any plot command.\n" % mosFil
                            s += "You need to add a plot command to include its\n"
                            s += "results in the unit tests.\n"
                            self.__reporter.writeError(s)
                            
                        dat.setResultVariables(plotVars)

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
                        dat.setResultFile(matFil)
                        self.__data.append(dat)
        self.__checkDataDictionary()
        return


    def __checkDataDictionary(self):
        ''' Check if the data used to run the unit tests do not have duplicate ``*.mat`` files.

            Since Dymola writes all ``*.mat`` files to the current working directory,
            dublicate ``*.mat`` file names would cause a simulation to overwrite the results
            of a previous simulation. This would make it impossible to compare the results
            to previously obtained results.
            
            If there are dublicate ``*.mat`` file names used, then this method throws
            a ``ValueError`` exception.

        '''
        s = set()
        errMes = ""
        for data in self.__data:
            resFil = data.getResultFile()
            if data.simulateFile():
                if resFil in s:
                    errMes += "*** Error: Result file %s is generated by more than one script.\n" \
                        "           You need to make sure that all scripts use unique result file names.\n" % resFil
                else:
                    s.add(resFil)
        if len(errMes) > 0:
            raise ValueError(errMes)


    def __getSimulationResults(self, data, warnings):
        '''
        Get the simulation results.

        :param data: The class that contains the data structure for the simulation results.
        :param warning: An empty list in which all warnings will be written.

        Extracts and returns the simulation results from the `*.mat` file as
        a list of dictionaries. Each element of the list contains a dictionary
        of results that need to be printed together.
        '''    
        import os
        import sys
        from buildingspy.io.outputfile import Reader
        from buildingspy.io.postprocess import Plotter

        def extractData(y, step):
            # Replace the last element with the last element in time,
            # [::step] may not extract the last time stamp, in which case
            # the final time changes when the number of event change.
            r=y[::step]
            r[len(r)-1] = y[len(y)-1]
            return r
            
        # Get the working directory that contains the ".mat" file
        fulFilNam=os.path.join(data.getResultDirectory(), "Buildings", data.getResultFile())
        ret=[]
        try:
            r=Reader(fulFilNam, "dymola") 
        except IOError as e:
            warnings.append("Failed to read %s generated by %s.\n" % 
                             (fulFilNam, data.getScriptFile()))
            return ret

        for pai in data.getResultVariables(): # pairs of variables that are plotted together
            foundData = False # This ensures that time is in all data series
            dat=dict()
            for var in pai:
                time = []
                val = []
                try:
                    (time, val) = r.values(var)
                    # Make time grid to which simulation results
                    # will be interpolated.
                    # This reduces the data that need to be stored.
                    # It also makes it easier to compare accuracy
                    # in case that a slight change in the location of 
                    # state events triggered a different output interval grid.
                    tMin=float(min(time))
                    tMax=float(max(time))
                    dTim=tMax-tMin
                    nPoi = min(self.__nPoi, len(val))
                    ti = [ tMin+float(i)/(nPoi-1)*dTim for i in range(nPoi) ]
                except ZeroDivisionError as e:
                    s = "When processing " + fulFilNam + " generated by " + data.getScriptFile() + ", caught division by zero.\n"
                    s += "   len(val) = " + str(len(val)) + "\n"
                    s += "   dTim     = " + str(dTim) + "\n"
                    warnings.append(s)
                    break

                except KeyError:
                    warnings.append("%s uses %s which does not exist in %s.\n" %
                                     (data.getScriptFile(), var, data.getResultFile()))
                else:
                    if (not foundData) and len(time) > 2:
                        dat['time']=ti
                        foundData = True

                    if self.__isParameter(val):
                        dat[var] = val
                    else:
                        dat[var]=Plotter.interpolate(ti, time, val)

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
        :return: A list with ``False`` if the results are not equal, and the time 
                 of the maximum error, and a warning message or `None`
        '''
        import numpy as np
        from buildingspy.io.postprocess import Plotter

        timMaxErr = 0

        tol=1E-3  #Tolerance

        # Interpolate the new variables to the old time stamps
        if len(yNew) > 2:
            yInt = Plotter.interpolate(tOld, tNew, yNew)
        else:
            yInt = [yNew[0], yNew[0]]

        errAbs=np.zeros(len(yInt))
        errRel=np.zeros(len(yInt))
        errFun=np.zeros(len(yInt))

        # Compute error for the variable with name varNam
        for i in range(len(yInt)):
            errAbs[i] = abs( yOld[i] - yInt[i] )
            if np.isnan(errAbs[i]):
                raise ValueError('NaN in errAbs ' + varNam + " "  + str(yOld[i]) + 
                                 "  " + str(yInt[i]) + " i, N " + str(i) + " --:" + str(yInt[i-1]) + 
                                 " ++:", str(yInt[i+1]))
            if (abs(yOld[i]) > 10*tol):
                errRel[i] = errAbs[i] / abs( yOld[i] )
            else:
                errRel[i] = 0
            errFun[i] = errAbs[i] + errRel[i]
        if max(errFun) > tol:
            iMax = 0
            eMax = 0
            for i in range(len(errFun)):
                if errFun[i] > eMax:
                    eMax = errFun[i]
                    iMax = i
            timMaxErr = tOld[iMax]
            warning = filNam + ": " + varNam + " has absolute and relative error = " + \
                ("%0.3e" % max(errAbs)) + ", " + ("%0.3e" % max(errRel)) + ".\n"
            if self.__isParameter(yInt):
                warning += "             %s is a parameter.\n" % varNam
            else:
                warning += "             Maximum error is at t = %s\n" % str(timMaxErr)

            return (False, timMaxErr, warning)
        else:
            return (True, timMaxErr, None)


    def __isParameter(self, dataSeries):
        ''' Return `True` if `dataSeries` is from a parameter.
        '''
        import numpy as np
        if not (isinstance(dataSeries, np.ndarray) or isinstance(dataSeries, list)):
            raise TypeError("Program error: dataSeries must be a numpy.ndarr or a list. Received type " \
                                + str(type(dataSeries)) + ".\n")
        return (len(dataSeries) == 2)

    def __writeReferenceResults(self, refFilNam, yS):
        ''' Write the reference results.

        :param refFilNam: The name of the reference file.
        :param yS: The data points to be written to the file.

        This method writes the results in the form ``key=value``, with one line per entry.
        '''
        from datetime import date

        def format(value):
            return "%.20f" % value

        f=open(refFilNam, 'w')
        f.write('svn-id=$Id$\n')
        f.write('last-generated=' + str(date.today()) + '\n')
        # Set, used to avoid that data series that are plotted in two plots are
        # written twice to the reference data file.
        s = set()
        for pai in yS:
            for k, v in pai.items():
                if k not in s:
                    s.add(k)
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

            try:
                (key, value) = lin.split("=")
                s = (value[value.find('[')+1: value.rfind(']')]).strip()
                numAsStr=s.split(',')
            except ValueError as detail:
                s =  "%s could not be parsed.\n" % refFilNam
                self.__reporter.writeError(s)
                raise TypeError(detail)

            val = []
            for num in numAsStr:
                # We need to use numpy.float64 here for the comparison to work
                val.append(numpy.float64(num)) 
            r[key] = val
        d['results'] = r
        return d


    def __askNoReferenceResultsFound(self, yS, refFilNam, ans):
        ''' Ask user what to do if no reference data were found
           :param yS: A list where each element is a dictionary of variable names and simulation
                      results that are to be plotted together.
           :param refFilNam: Name of reference file (used for reporting only).
           :param ans: A previously entered answer, either ``y``, ``Y``, ``n`` or ``N``.
           :return: A triple ``(updateReferenceData, foundError, ans)`` where ``updateReferenceData``
                    and ``foundError`` are booleans, and ``ans`` is ``y``, ``Y``, ``n`` or ``N``.
   
        '''
        import sys
        updateReferenceData = False
        foundError = False

        if len(yS) > 0:
            sys.stdout.write("*** Warning: The old reference data had no results, but the new simulation produced results\n")
            sys.stdout.write("             for %s\n" % refFilNam)
            sys.stdout.write("             Accept new results?\n")
            while not (ans == "n" or ans == "y" or ans == "Y" or ans == "N"):
                ans = raw_input("   Enter: y(yes), n(no), Y(yes for all), N(no for all): ")
            if ans == "y" or ans == "Y":
                # update the flag 
                updateReferenceData = True
        return (updateReferenceData, foundError, ans)


    def __compareResults(self, matFilNam, oldRefFulFilNam, yS, refFilNam, ans):
        ''' Compares the new and the old results.
        
            :param matFilNam: Matlab file name.
            :param oldRefFilFilNam: File name including path of old reference files.
            :param yS: A list where each element is a dictionary of variable names and simulation
                           results that are to be plotted together.
            :param refFilNam: Name of the file with reference results (used for reporting only.
            :param ans: A previously entered answer, either ``y``, ``Y``, ``n`` or ``N``.
            :return: A triple ``(updateReferenceData, foundError, ans)`` where ``updateReferenceData``
                     and ``foundError`` are booleans, and ``ans`` is ``y``, ``Y``, ``n`` or ``N``.

        '''
        import matplotlib.pyplot as plt

        # Reset answer, unless it is set to Y or N
        if not (ans == "Y" or ans == "N"):
            ans = "-"
        updateReferenceData = False
        foundError = False
        verifiedTime = False

        #Load the old data (in dictionary format)
        d = self.__readReferenceResults(oldRefFulFilNam)
        yR=d['results']

        if len(yR) == 0:
            return self.__askNoReferenceResultsFound(yS, refFilNam, ans)

        # The old data contains results
        tR=yR.get('time')


        # Iterate over the pairs of data that are to be plotted together
        timOfMaxErr = dict()
        noOldResults = [] # List of variables for which no old results have been found
        for pai in yS:
            tS=pai['time']
            if not verifiedTime:
                verifiedTime = True

                # Check if the first and last time stamp are equal
                tolTim = 1E-3 # Tolerance for time
                if (abs(tR[0] - tS[0]) > tolTim) or abs(tR[-1] - tS[-1]) > tolTim: 
                    print "***Warning: Different simulation time interval in ", refFilNam, " and ", matFilNam
                    print "   Old reference points are for " , tR[0], ' <= t <= ', tR[len(tR)-1]
                    print "   New reference points are for " , tS[0], ' <= t <= ', tS[len(tS)-1]
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
            for varNam in pai.keys(): # Iterate over the variable names that are to be plotted together
                if varNam != 'time':
                    if yR.has_key(varNam):
                        # Check results
                        if self.__isParameter(pai[varNam]):
                            t=[min(tS), max(tS)]
                        else:
                            t=tS

                        (res, timMaxErr, warning) = self.__areResultsEqual(tR, yR[varNam], t, pai[varNam], varNam, matFilNam)
                        if warning:
                            self.__reporter.writeWarning(warning)
                        if not res:
                            foundError = True
                            timOfMaxErr[varNam] = timMaxErr
                    else:
                        # There is no old data series for this variable name
                        self.__reporter.writeWarning("Did not find variable " + varNam + " in old results.")
                        foundError = True
                        noOldResults.append(varNam)

        # If the users selected "N" (to not accept any new results) in previous tests,
        # or if the script is run in batch mode, then don't plot the results.
        # If we found an error, plot the results, and ask the user to accept or reject the new values.
        if foundError and (not self.__batch) and (not ans == "N"):
            print "   Acccept new file and update reference files? (Close plot window to continue.)"
            nPlo = len(yS)
            iPlo = 0
            plt.clf()
            for pai in yS:
                iPlo += 1
                plt.subplot(nPlo, 1, iPlo)
                # Iterate over the variable names that are to be plotted together
                color=['k', 'r', 'b', 'g', 'c', 'm']
                iPai = -1
                for varNam in pai.keys(): 
                    iPai += 1
                    if iPai > len(color)-1:
                        iPai = 0
                    if varNam != 'time':
                        if self.__isParameter(pai[varNam]):
                            plt.plot([min(tS), max(tS)], pai[varNam], 
                                     color[iPai] + '-', label='New ' + varNam)
                        else:
                            plt.plot(tS, pai[varNam], 
                                     color[iPai] + '-', label='New ' + varNam)
                        

                        # Test to make sure that this variable has been found in the old results
                        if noOldResults.count(varNam) == 0:
                            if self.__isParameter(yR[varNam]):
                                plt.plot([min(tR), max(tR)], yR[varNam], 
                                         color[iPai] + '.', label='Old ' + varNam)
                            else:
                                plt.plot(tR, yR[varNam], 
                                         color[iPai] + '.', label='Old ' + varNam)
                        # Plot the location of the maximum error
                        if varNam in timOfMaxErr:
                            plt.axvline(x=timOfMaxErr[varNam])
                    
                leg = plt.legend(loc='best', fancybox=True)
                leg.get_frame().set_alpha(0.5) # transparent legend
                plt.xlabel('time')
                plt.grid(True)
                if iPlo == 1:
                    plt.title(matFilNam)
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
    def __checkReferencePoints(self, ans):
        import os
        import sys

        #Check if the directory "self.__libHome\\Resources\\ReferenceResults\\Dymola" exists, if not create it.
        refDir=os.path.join(self.__libHome, 'Resources', 'ReferenceResults', 'Dymola')   
        if not os.path.exists(refDir):
            os.makedirs(refDir)               

        for data in self.__data:
            # k is the name of the mos file
            # v are the variables that need to be extracted from this matlab file

            # Name of the reference file, which is the same as that matlab file name but with another extension
            if self.__includeFile(data.getScriptFile()):
                # Convert 'aa/bb.mos' to 'aa_bb.txt'
                mosFulFilNam = os.path.join('Buildings', data.getScriptDirectory(), data.getScriptFile())
                mosFulFilNam = mosFulFilNam.replace(os.sep, '_')
                refFilNam=os.path.splitext( mosFulFilNam )[0] + ".txt" 

                try:
                    # extract reference points from the ".mat" file corresponding to "filNam"
                    warnings = []
                    yS=self.__getSimulationResults(data, warnings)
                    for entry in warnings:
                        self.__reporter.writeWarning(entry)
                except UnicodeDecodeError, e:
                    em = str(e) + "\n"
                    em += "Output file of " + data.getScriptFile() + " is excluded from unit tests.\n"
                    em += "The model appears to contain a non-asci character\n"
                    em += "in the comment of a variable, parameter or constant.\n"
                    em += "Check " + data.getScriptFile() + " and the classes it instanciates.\n"
                    self.__reporter.writeError(em)
                else:
                    # Reset answer, unless it is set to Y or N
                    if not (ans == "Y" or ans == "N"):
                        ans = "-"

                    updateReferenceData = False
                    # check if reference results already exists in library
                    oldRefFulFilNam=os.path.join(refDir, refFilNam)  
                    # If the reference file exists, and if the reference file contains results, compare the results.
                    if os.path.exists(oldRefFulFilNam):
                        # compare the new reference data with the old one
                        [updateReferenceData, foundError, ans]=self.__compareResults(
                            data.getResultFile(), oldRefFulFilNam, yS, refFilNam, ans)
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
                        self.__writeReferenceResults(oldRefFulFilNam, yS)
            else:
                self.__reporter.writeWarning("Output file of " + data.getScriptFile() + " is excluded from result test.")

        return ans

    # --------------------------
    def __checkSimulationError(self, errorFile):
        import sys

        fil = open(errorFile, "r")
        i=0
        for lin in fil.readlines():
                if (lin.count("false") > 0):
                        i=i+1
        fil.close() #Closes the file (read session)
        if (i>0):
                self.__reporter.writeError("Unit tests had " + str(i) + " error(s).\n" + \
                                               "Search 'dymola.log' for 'false' to see details.\n")

        self.__reporter.writeOutput("Script that runs unit tests had " + \
                                        str(self.__reporter.getNumberOfWarnings()) + \
                                        " warnings and " + \
                                        str(self.__reporter.getNumberOfErrors()) + \
                                        " errors.\n")
        sys.stdout.write("See 'unitTests.log' for details.\n")
        if self.__reporter.getNumberOfErrors() > 0:
            return 1
        if self.__reporter.getNumberOfWarnings() > 0:
            return 2
        else:
            self.__reporter.writeOutput("Unit tests completed successfully.\n")
            return 0


    # --------------------------
    def printNumberOfClasses(self, dir):
        import os

        iMod=0
        iBlo=0
        iFun=0
        for root, dirs, files in os.walk(self.__libHome):
            pos=root.find('.svn')
            # skip .svn folders
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

    def __removePlotCommands(self, mosFilNam):
        ''' Remove all plot commands from the mos file.
        
        :param mosFilNam: The name of the ``*.mos`` file

        This function removes all plot commands from the file ``mosFilNam``.
        This allows to work around a bug in Dymola 2012 which can cause an exception
        from the Windows operating system, or which can cause Dymola to hang on Linux
        '''
        fil = open(mosFilNam, "r+")
        lines = fil.readlines()
        fil.close()
        linWri = []
        goToPlotEnd = False
        for i in range(len(lines)):
            if not goToPlotEnd:
                if (lines[i].count("removePlots(") == 0) and (lines[i].count("createPlot(") == 0):
                    linWri.append(i)
                elif (lines[i].count("createPlot(")) > 0:
                    goToPlotEnd = True
            else:
                if (lines[i].count(";") > 0):
                    goToPlotEnd = False
        # Write file
        filWri = open(mosFilNam, "w")
        for i in range(len(linWri)):
            filWri.write(lines[linWri[i]])
        filWri.close()

    # --------------------------
    # Write the script that runs all example problems, and
    # that searches for errors
    def __writeRunscripts(self):
        import os

        nUniTes = 0

        nTes = len(self.__data)
        for iPro in range(min(self.__nPro, nTes)):

            runFil=open(os.path.join(self.__temDir[iPro], "Buildings", "runAll.mos"), 'w')
            runFil.write("// File autogenerated for process " 
                         + str(iPro+1) + " of " + str(self.__nPro) + "\n")
            runFil.write("// Do not edit.\n")
            runFil.write("openModel(\"package.mo\");\n")
            runFil.write("Modelica.Utilities.Files.remove(\"dymola.log\");\n")
            # Write unit tests for this process
            for i in range(iPro, nTes, self.__nPro):
                # Check if this mos file should be simulated
                if self.__data[i].simulateFile():
                    # Write line for run script
                    runFil.write("RunScript(\"Resources/Scripts/Dymola/" 
                                 + self.__data[i].getScriptDirectory() + "/" 
                                 + self.__data[i].getScriptFile() + "\");\n")
                    self.__data[i].setResultDirectory(self.__temDir[iPro])
                    mosFilNam = os.path.join(self.__temDir[iPro], "Buildings", 
                                             "Resources", "Scripts", "Dymola",
                                             self.__data[i].getScriptDirectory(),
                                             self.__data[i].getScriptFile())
                    self.__removePlotCommands(mosFilNam)
                    nUniTes = nUniTes + 1
            runFil.write("// Save log file\n")
            runFil.write("savelog(\"dymola.log\");\n")
            runFil.write("Modelica.Utilities.System.exit();\n")
            runFil.close()
        
        # For files that do not require a simulation, we need to set the path of the result files.
        for dat in self.__data:
            if not dat.simulateFile():
                matFil = dat.getResultFile()
                for allDat in self.__data:
                    if allDat.simulateFile():
                        resFil = allDat.getResultFile()
                        if resFil == matFil:
                            dat.setResultDirectory( allDat.getResultDirectory() )
                            break

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
        ''' Run all unit tests and checks the results.

        :return: 0 if no errros occurred during the unit tests, 
                 otherwise a non-zero value.

        This method

        - creates temporary directories for each processors, 
        - copies the directory 'Buildings' into these
          temporary directories,
        - creates run scripts that run all unit tests,
        - runs these unit tests,
        - collects the dymola log files from each process,
        - writes the combined log file ``dymola.log``
          to the current directory, 
        - compares the results of the new simulations with
          reference results that are stored in ``Resources/ReferenceResults``,
        - writes the message `Unit tests completed successfully.` 
          if no error occured,
        - returns 0 if no errors occurred, or non-zero otherwise.

        '''
        import multiprocessing
        import sys
        import os
        import shutil
        import time

        self.checkPythonModuleAvailability()

        self.setDataDictionary()

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

        # Run simulations
        if not self.__useExistingResults:
            self.__setTemporaryDirectories(self.__nPro)
        self.__writeRunscripts()
        if not self.__useExistingResults:
            if self.__nPro > 1:
                po = multiprocessing.Pool(self.__nPro)
                po.map(runSimulation, self.__temDir)
            else:
                runSimulation(self.__temDir[0])


        # Concatenate output files into one file
        logFil=open('dymola.log', 'w')
        for d in self.__temDir:
            temLogFilNam = os.path.join(d, 'Buildings', 'dymola.log')
            if os.path.exists(temLogFilNam):
                file=open(temLogFilNam,'r')
                data=file.read()
                file.close()
                logFil.write(data)
            else:
                self.__reporter.writeError("Log file '" + temLogFilNam + "' does not exist.\n")
                retVal = 1
        logFil.close()

        # Check reference results
        if self.__batch:
            ans = "N"
        else:
            ans = "-"

        ans = self.__checkReferencePoints(ans)


        # Delete temporary directories
        if self.__deleteTemporaryDirectories:
            for d in self.__temDir:
                shutil.rmtree(d)

        # Check for errors
        if retVal == 0:
            retVal = self.__checkSimulationError("dymola.log")
        else:
            self.__checkSimulationError("dymola.log")

        # Print list of files that may be excluded from unit tests
        if len(self.__excludeMos) > 0:
            print "*** Warning: The following files may be excluded from the unit tests:\n"
            for fil in self.__excludeMos:
                print "            ", fil

        # Print time
        elapsedTime=time.time()-startTime;
        print "Execution time = %.3f s" % elapsedTime

        return retVal
