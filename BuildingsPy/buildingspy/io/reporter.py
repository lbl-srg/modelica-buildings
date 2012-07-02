#!/usr/bin/env python

class Reporter:
    ''' Class that is used to report errors.
    '''
    
    def __init__(self, directory="."):
        ''' Construct a reporter.

        :param directory: The directory where the log files will be written to.

        This class writes the standard output stream and the
        standard error stream to the files ``stdout.log``
        and  ``stderr.log``. These files will be created in the
        directory ``directory``.
        '''
        self.__logToFile = True
        self.__directory = directory
        self.__verbose = True
        self.logToFile()

    def logToFile(self, log=True):
        ''' Function to log the standard output and standard error stream to a file.
        
        :param log: If ``True``, then the standard output stream and the standard error stream will be logged to a file.

        This function can be used to enable and disable writing of the standard output 
        stream to the file ''stdout.log'', and the standard error stream to the file ``stderr.log``.
        The default setting is ``True``
        '''
        self.__logToFile = log

    def writeError(self, message):
        ''' Writes an error message.
        
        :param message: The message to be written.
        
        Note that this method adds a new line character at the end of the message.
        '''
        self.__writeErrorOrWarning(True, message)
        return

    def writeWarning(self, message):
        ''' Writes a warning message.
        
        :param message: The message to be written.
        
        Note that this method adds a new line character at the end of the message.
        '''
        self.__writeErrorOrWarning(False, message)
        return


    def __writeErrorOrWarning(self, isError, message):
        ''' Writes an error message or a warning message.
        
        :param isError: Set to 'True' if an error should be written, or 'False' for a warning.
        :param message: The message to be written.
        
        Note that this method adds a new line character at the end of the message.
        '''
        import sys
        import os

        msg = ""
        if self.__verbose:
            if isError:
                msg += "*** Error : "
            else:
                msg += "*** Warning : "                
        msg += message + "\n"
        sys.stderr.write(msg)
        if self.__logToFile:
            fil = open(os.path.join(self.__directory, 'stderr.log'), 'a')
            fil.write(msg)
            fil.close()
        return


    def writeOutput(self, message):
        ''' Writes a message to the standard output.
        
        :param message: The message to be written.
        
        Note that this method adds a new line character at the end of the message.
        '''
        import sys
        import os

        msg = message + "\n"
        if self.__logToFile:
            fil = open(os.path.join(self.__directory, 'stdout.log'), 'a')
            fil.write(msg)
            fil.close()
        sys.stdout.write(msg)
        return

