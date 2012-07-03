#!/usr/bin/env python

class Reporter:
    ''' Class that is used to report errors.
    '''
    
    def __init__(self, fileName):
        ''' Construct a reporter.

        :param fileName: Name of the output file.

        This class writes the standard output stream and the
        standard error stream to the file ``fileName``. 
        '''
        import os

        self.__logToFile = True
        self.__verbose = True
        self.__iWar = 0
        self.__iErr = 0
        self.logToFile()
        # Delete existing files
        self.__logFil = os.path.join(fileName)
        if os.path.isfile(self.__logFil):
            os.remove(self.__logFil)
            

    def logToFile(self, log=True):
        ''' Function to log the standard output and standard error stream to a file.
        
        :param log: If ``True``, then the standard output stream and the standard error stream will be logged to a file.

        This function can be used to enable and disable writing outputs to
        the file ''fileName''.
        The default setting is ``True``
        '''
        self.__logToFile = log

    def getNumberOfErrors(self):
        ''' Returns the number of error messages that were written.
        
        :return : The number of error messages that were written.
        '''
        return self.__iErr

    def getNumberOfWarnings(self):
        ''' Returns the number of warning messages that were written.
        
        :return : The number of warning messages that were written.
        '''
        return self.__iWar

    def writeError(self, message):
        ''' Writes an error message.
        
        :param message: The message to be written.
        
        Note that this method adds a new line character at the end of the message.
        '''
        self.__iErr += 1
        self.__writeErrorOrWarning(True, message)
        return

    def writeWarning(self, message):
        ''' Writes a warning message.
        
        :param message: The message to be written.
        
        Note that this method adds a new line character at the end of the message.
        '''
        self.__iWar += 1
        self.__writeErrorOrWarning(False, message)
        return


    def __writeErrorOrWarning(self, isError, message):
        ''' Writes an error message or a warning message.
        
        :param isError: Set to 'True' if an error should be written, or 'False' for a warning.
        :param message: The message to be written.
        
        Note that this method adds a new line character at the end of the message.
        '''
        import sys

        msg = ""
        if self.__verbose:
            if isError:
                msg += "*** Error: "
            else:
                msg += "*** Warning: "                
        msg += message + "\n"
        sys.stderr.write(msg)
        if self.__logToFile:
            fil = open(self.__logFil, 'a')
            fil.write(msg)
            fil.close()
        return


    def writeOutput(self, message):
        ''' Writes a message to the standard output.
        
        :param message: The message to be written.
        
        Note that this method adds a new line character at the end of the message.
        '''
        import sys

        msg = message + "\n"
        if self.__logToFile:
            fil = open(self.__logFil, 'a')
            fil.write(msg)
            fil.close()
        sys.stdout.write(msg)
        return

