#!/usr/bin/env python

class Simulator:
    """Class to simulate a Modelica model.

    :param modelName: The name of the Modelica model.
    :param simulator: The simulation engine. Currently, the only supported value is ``dymola``.
    :param outputDirectory: An optional output directory.

    If the parameter ``outputDirectory`` is specified, then the
    output files and log files will be moved to this directory
    when the simulation is completed.
    """

    def __init__(self, modelName, simulator, outputDirectory='.'):
        import buildingspy.io.reporter as reporter
        import os

        ## Check arguments and make output directory if needed
        if simulator != "dymola":
            raise ValueError("Argument 'simulator' needs to be set to 'dymola'.")


        self.modelName = modelName
        self.__outputDir__ = outputDirectory
        ## This call is needed so that the reporter can write to the working directory
        self.__createDirectory(outputDirectory)
        self.__preProcessing__ = list()
        self.__parameters__ = {}
        self.__modelModifiers__ = list()
        self.__simulator__ = {}
        self.setStartTime(0)
        self.setStopTime(1)
        self.setTolerance(1E-6)
        self.setSolver("radau")
        self.setResultFile(modelName)
        self.setTimeOut(-1)
        self.__MODELICA_EXE='dymola'
        self.__reporter = reporter.Reporter(directory=outputDirectory)
        self.__showProgressBar = True
        self.__showGUI = False;


    def __createDirectory(self, directoryName):
        ''' Creates the directory *directoryName*

        :param directoryName: The name of the directory

        This method validates the directory *directoryName* and if the
        argument is valid and write permissions exists, it creates the 
        directory. Otherwise, a *ValueError* is raised.
        '''
        import os

        if directoryName != '.':
            if len(directoryName) == 0:
                raise ValueError("Specified directory is not valid. Set to '.' for current directory.")
            # Try to create directory
            if not os.path.exists(directoryName):
                os.makedirs(directoryName)
            # Check write permission
            if not os.access(directoryName, os.W_OK):
                raise ValueError("Write permission to '" + directory + "' denied.")





    def addPreProcessingStatement(self, command):
        '''Adds a pre-processing statement to the simulation script.

        :param statement: A script statement.

        Usage: Type
           >>> from buildingspy.simulate.Simulator import Simulator
           >>> s=Simulator("myPackage.myModel", "dymola")
           >>> s.addPreProcessingStatement("Advanced.StoreProtectedVariables:= true;")
           >>> s.addPreProcessingStatement("Advanced.GenerateTimers = true;")

        This will execute the two statements after the ``openModel`` and
        before the ``simulateModel`` statement.
        '''
        d = self.__preProcessing__.append(command)
        return


    def addParameters(self, dictionary):
        '''Adds parameter declarations to the simulator.

        :param dictionary: A dictionary with the parameter values

        Usage: Type
           >>> from buildingspy.simulate.Simulator import Simulator
           >>> s=Simulator("myPackage.myModel", "dymola")
           >>> s.addParameters({'PID.k': 1.0, 'valve.m_flow_nominal' : 0.1})
           >>> s.addParameters({'PID.t': 10.0})

        This will add the three parameters ``PID.k``, ``valve.m_flow_nominal``
        and ``PID.t`` to the list of model parameters.
        '''
        d = self.__parameters__.update(dictionary)
        return

    def getParameters(self):
        '''Returns a list of parameters as (key, value)-tuples.

        :return: A list of parameters as (key, value)-tuples.

        Usage: Type
           >>> from buildingspy.simulate.Simulator import Simulator
           >>> s=Simulator("myPackage.myModel", "dymola")
           >>> s.addParameters({'PID.k': 1.0, 'valve.m_flow_nominal' : 0.1})
           >>> s.getParameters()

        This will return the list
        ``[('valve.m_flow_nominal', 0.1), ('PID.k', 1.0)]``
        '''
        return self.__parameters__.items()

    def getOutputDirectory(self):
        '''Returns a the name of the output directory.

        :return: The name of the output directory.

        '''
        return self.__outputDir__

    def addModelModifier(self, modelModifier):
        '''Adds a model modifier.

        :param dictionary: A model modifier.

        Usage: Type
           >>> from buildingspy.simulate.Simulator import Simulator
           >>> s=Simulator("myPackage.myModel", "dymola")
           >>> s.addModelModifier('redeclare package MediumA = Buildings.Media.IdealGases.SimpleAir')

        This method adds a model modifier. The modifier is added to the list
        of model parameters. For example, the above statement would yield the 
        command
        ``simulateModel(myPackage.myModel(redeclare package MediumA = Buildings.Media.IdealGases.SimpleAir), startTime=...``

        '''
        d = self.__modelModifiers__.append(modelModifier)
        return


    def getSimulatorSettings(self):
        '''Returns a list of settings for the parameter as (key, value)-tuples.

        :return: A list of parameters (key, value) pairs, as 2-tuples.

        Usage: Type
           >>> from buildingspy.simulate.Simulator import Simulator
           >>> s=Simulator("myPackage.myModel", "dymola")
           >>> s.add({'PID.k': 1.0, 'valve.m_flow_nominal' : 0.1})
           >>> s.getSimulatorSettings()

        This will return the list
        ``[('valve.m_flow_nominal', 0.1), ('PID.k', 1.0)]``
        '''
        return self.__parameters__.items()


    def setStartTime(self, t0):
        '''Sets the start time.

        :param t0: The start time of the simulation in seconds.

        The default stop time is 1.
        '''
        self.__simulator__.update(t0=t0)
        return

    def setStopTime(self, t1):
        '''Sets the start time.

        :param t0: The start time of the simulation in seconds.

        The default start time is 0.
        '''
        self.__simulator__.update(t1=t1)
        return

    def setTimeOut(self, sec):
        '''Sets the time out after which the simulation will be killed.

        :param sec: The time out after which the simulation will be killed.

        The default value is -1, which means that the simulation will
        never be killed.
        '''
        self.__simulator__.update(timeout=sec)
        return

    def setTolerance(self, eps):
        '''Sets the solver tolerance.

        :param eps: The solver tolerance.

        The default solver tolerance is 1E-6.
        '''
        self.__simulator__.update(eps=eps)
        return

    def setSolver(self, solver):
        '''Sets the solver.

        :param solver: The name of the solver.

        The default solver is *radau*.
        '''
        self.__simulator__.update(solver=solver)
        return

    def setNumberOfIntervals(self, n):
        '''Sets the number of output intervals.

        :param n: The number of output intervals.

        The default is unspecified, which defaults by Dymola to 500.
        '''
        self.__simulator__.update(numberOfIntervals=n)
        return

    def setResultFile(self, resultFile):
        '''Sets the name of the result file (without extension).

        :param resultFile: The name of the result file (without extension).

        '''
        # If resultFile=aa.bb.cc, then split returns [aa, bb, cc]
        # This is needed to get the short model name
        rs=resultFile.split(".")
        self.__simulator__.update(resultFile=rs[len(rs)-1])
        return


    def simulate(self):
        '''Simulates the model.

        This method
          1. Deletes dymola output files
          2. Copies the current directory to a temporary directory.
          3. Writes a Modelica script to the temporary directory.
          4. Starts the Modelica simulation environment from the temporary directory.
          5. Translates and simulates the model.
          6. Closes the Modelica simulation environment.
          7. Copies output files and deletes the temporary directory.
        '''
        import sys
        import os
        import tempfile
        import getpass
        import shutil

        # Delete dymola output files
        self.deleteOutputFiles()

        # Get directory name. This ensures for example that if the directory is called xx/Buildings
        # then the simulations will be done in tmp??/Buildings
        curDir = os.path.abspath(".")
        ds=curDir.split(os.sep)
        dirNam=ds[len(ds)-1]
        worDir = os.path.join(tempfile.mkdtemp(prefix='tmp-simulator-' + getpass.getuser() + '-'), dirNam)
        # Copy directory
        shutil.copytree(os.path.abspath("."), worDir)


        # Construct the model instance with all parameter values
        # and the package redeclarations
        dec = list()
        k=self.__parameters__.keys()
        v=self.__parameters__.values()
        nK=len(k)
        for i in range(nK):
            dec.append('"' + k[i] + '=" + String(' + str(v[i]) + ')')

        nK=len(self.__modelModifiers__)
        for i in range(nK):
            dec.append('"' + self.__modelModifiers__[i] + '"')

        mi='"' + self.modelName + '("'
        for i in range(len(dec)):
            mi += " + " + dec[i]
            if i < len(dec)-1:
                mi += ' + ","'
        mi += ' + ")";\n'

        try:
            # Write the Modelica script
            runScriptName = os.path.join(worDir, "run.mos")
            fil=open(runScriptName, "w")
            fil.write("// File autogenerated\n")
            fil.write("// Do not edit.\n")
            fil.write('cd("' + worDir + '");\n')
            fil.write("Modelica.Utilities.Files.remove(\"simulator.log\");\n")
            fil.write("openModel(\"package.mo\");\n")
            fil.write('OutputCPUtime:=true;\n')
            # Pre-processing commands
            for prePro in self.__preProcessing__:
                fil.write(prePro + '\n')

            fil.write('modelInstance=' + mi + '\n')
            fil.write('simulateModel(modelInstance, ')
            fil.write('startTime=' + str(self.__simulator__.get('t0')) + \
                          ', stopTime='  + str(self.__simulator__.get('t1')) + \
                          ', method="' + self.__simulator__.get('solver') + '"' + \
                          ', tolerance=' + str(self.__simulator__.get('eps')) + \
                          ', resultFile="' + str(self.__simulator__.get('resultFile')  
                                                 + '"'))
            if self.__simulator__.has_key('numberOfIntervals'):
                fil.write(', numberOfIntervals=' + 
                          str(self.__simulator__.get('numberOfIntervals')))
            fil.write(');\n')
            fil.write("savelog(\"simulator.log\");\n")
            fil.write("Modelica.Utilities.System.exit();\n")
            fil.close()
            # Copy files to working directory

            # Run simulation
            self.__runSimulation(runScriptName, 
                                 self.__simulator__.get('timeout'), 
                                 worDir)
            self.__copyResultFiles(worDir)
            self.__deleteTemporaryDirectory(worDir)
        except: # Catch all possible exceptions
            e = sys.exc_info()[1]
            self.__reporter.writeError("Simulation failed in '" + worDir + "'\n" 
                                       + "   You need to delete the directory manually.")
            raise 

    def deleteOutputFiles(self):
        ''' Deletes the output files of the simulator.
        '''
        import os
        filLis=['buildlog.txt', 'dsfinal.txt', 'dsin.txt', 'dslog.txt', 
                'dsmodel*', 'dymosim', 'dymosim.exe', 
                str(self.__simulator__.get('resultFile')) + '.mat', 
                'request.', 'status', 'failure', 'stop']
        for fil in filLis:
            try:
                if os.path.exists(fil):
                    os.remove(fil)
            except OSError as e:
                self.__reporter.writeError("Failed to delete '" + fil + "' : " + e.strerror)

    def showGUI(self, show=True):
        ''' Call this function to show the GUI of the simulator.
        
        By default, the simulator runs without GUI
        '''
        self.__showGUI = show;
        return

    def printModelAndTime(self):
        ''' Prints the current time and the model name to the standard output.
        
        This method may be used to print logging information.
        '''
        import time
        self.__reporter.writeOutput("Model name       = " + self.modelName + '\n' +
                                    "Output directory = " + self.__outputDir__ + '\n' +
                                    "Time             = " + time.asctime() + '\n')
        return

    def __copyResultFiles(self, srcDir):
        ''' Copies the output files of the simulator.
        
        :param srcDir: The source directory of the files
        
        '''
        import shutil
        import os

        if self.__outputDir__ != '.':
            self.__createDirectory(self.__outputDir__)
            filLis=['run.mos', 'simulator.log', 'dslog.txt', 
                    self.__simulator__.get('resultFile') + '.mat']
            for fil in filLis:
                srcFil = os.path.join(srcDir, fil)
                newFil = os.path.join(self.__outputDir__, fil)
                try:
                    if os.path.exists(srcFil):
                        shutil.copy(srcFil, newFil)
                except IOError as e:
                    self.__reporter.writeError("Failed to copy '" + 
                                               srcFil + "' to '" + newFil + 
                                               "; : " + e.strerror)


    def __deleteTemporaryDirectory(self, worDir):
        ''' Deletes the working directory.
        
        :param srcDir: The name of the working directory.
        
        '''
        import shutil
        import os
        
        # Walk one level up, since we appended the name of the current directory to the name of the working directory
        dirNam=os.path.split(worDir)[0]
        # Make sure we don't delete a root directory
        if dirNam.find('tmp-simulator-') == -1:
            self.__reporter.writeError("Failed to delete '" + 
                                       dirNam + "' as it does not seem to be a valid directory name.")
        else:
            try:
                if os.path.exists(worDir):
                    shutil.rmtree(dirNam)
            except IOError as e:
                self.__reporter.writeError("Failed to delete '" + 
                                           worDir + ": " + e.strerror)


                
    def __isExecutable(self, program):
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

    def __runSimulation(self, mosFile, timeout, directory):
        '''Runs the simulation.
        
        :param mosFile: The Modelica *mos* file name, including extension
        :param timeout: Time out in seconds
        :param directory: The working directory
        
        '''
        
        import sys
        import subprocess
        import time
        import datetime
        import signal
        import os

        # List of command and arguments
        if self.__showGUI:
            cmd=[self.__MODELICA_EXE, mosFile]
        else:
            cmd=[self.__MODELICA_EXE, mosFile, "/nowindow"]
#        cmd=[self.__MODELICA_EXE, mosFile]
#        cmd=["sleep", "1"]

        # Check if executable is on the path
        if not self.__isExecutable(cmd[0]):
            print "Error: Did not find executable '", cmd[0], "'."
            exit(3)
        # Run command
        try:
            staTim = datetime.datetime.now()
            self.__reporter.writeOutput("Starting simulation in '" + 
                                        directory + "' at " +
                                        str(staTim))
            pro = subprocess.Popen(args=cmd, 
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE,
                                   shell=False, 
                                   cwd=directory)
            killedProcess=False
            countOld = -1
            if timeout > 0:
                while pro.poll() is None:
                    time.sleep(0.01)
                    elapsedTime = (datetime.datetime.now() - staTim).seconds

                    if elapsedTime > timeout:
                        # First, terminate the process. Then, if it is still
                        # running, kill the process

                        if killedProcess == False:
                            killedProcess=True
                            # This output needed because of the progress bar
                            sys.stdout.write("\n") 
                            self.__reporter.writeError("Terminating simulation in "
                                             + directory + ".")
                            pro.terminate()
                        else:
                            self.__reporter.writeError("Killing simulation in "
                                             + directory + ".")
                            pro.kill()
                    else:
                        if self.__showProgressBar:
                            fractionComplete = float(elapsedTime)/float(timeout)
                            self.__printProgressBar(fractionComplete)

            else:
                pro.wait()
            # This output is needed because of the progress bar
            if not killedProcess: 
                sys.stdout.write("\n") 

            if not killedProcess:
                self.__reporter.writeOutput("*** Standard output stream from simulation:\n" + pro.stdout.read())
                self.__reporter.writeError("*** Standard error stream from simulation:\n" + pro.stderr.read())
            else:
                self.__reporter.writeOutput("*** Killed process as it computed longer than " +
                             str(timeout) + " seconds.")

        except OSError as e:
            print "Execution of ", command, " failed:", e


    def showProgressBar(self, show=True):
        ''' Enables or disables the progress bar.
        
        :param show: Set to *false* to disable the progress bar.
        
        If this function is not called, then a progress bar will be shown as the simulation runs.
        '''
        self.__showProgressBar = show
        return

    def __printProgressBar(self, fractionComplete):
        '''Prints a progress bar to the console.
        
        :param fractionComplete: The fraction of the time that is completed.
        
        '''
        import sys
        nInc = 50
        count=int(nInc*fractionComplete)
        proBar = "|"
        for i in range(nInc):
            if i < count:
                proBar += "-"
            else:
                proBar += " "
        proBar += "|"
        print proBar, int(fractionComplete*100), "%\r", 
        sys.stdout.flush()
