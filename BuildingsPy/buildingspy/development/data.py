class Data:
    ''' Class that stores the results from the unit tests.
    
    This class stores the data that are needed to compare
    the results of the unit tests with previous results.

    '''
    def __init__(self):

        self.__resultFile = ""
        ''' Name of result file (without path)'''
        self.__resultDirectory = ""
        ''' Name of result directory'''
        self.__scriptFile = ""
        ''' Name of script file (without path)'''
        self.__scriptDirectory = ""
        ''' Name of script directory (without path)'''
        self.__resultVariables = []
        ''' The values of ``y`` are a list of the 
            form `[[a.x, a.y], [b.x, b.y1, b.y2]]` if the
            mos file plots `a.x` versus `a.y` and `b.x` versus `(b.y1, b.y2)`.
            '''
        self.__simulateFile = False
        ''' Flag, ``True`` if the ``*.mos`` file contains a ``simulate`` command.
        '''

    def setResultFile(self, fileName):
        ''' Set the result file.
    
        :param fileName: The name of the result file without the path.

        '''
        self.__resultFile = fileName

    def setResultDirectory(self, directoryName):
        ''' Set the result directory.
    
        :param directoryName: The name of the result directory.

        '''
        self.__resultDirectory = directoryName

    def setResultVariables(self, resultVariables):
        ''' Set the result variables.
    
        :param directoryName: A list of result variable names.

        Each element of the list of result variable names will be plotted together if
        they do not match previously obtained results.

        '''
        self.__resultVariables = resultVariables


    def setScriptFile(self, fileName):
        ''' Set the script file.
    
        :param fileName: The name of the script file without the path.

        '''
        self.__scriptFile = fileName

    def setScriptDirectory(self, directoryName):
        ''' Set the script directory.
    
        :param directoryName: The name of the script directory.

        '''
        self.__scriptDirectory = directoryName


    def getResultFile(self):
        ''' Get the result file.
    
        :return: The name of the result file without the path.

        '''
        return self.__resultFile

    def getResultDirectory(self):
        ''' Get the result directory.
    
        :return: The name of the result directory.

        '''
        return self.__resultDirectory

    def getResultVariables(self):
        ''' Get the result variables.
    
        :return: A list of result variable names.

        Each element of the list of result variable names will be plotted together if
        they do not match previously obtained results.

        '''
        return self.__resultVariables

    def getScriptFile(self):
        ''' Get the script file.
    
        :return: The name of the script file without the path.

        '''
        return self.__scriptFile

    def getScriptDirectory(self):
        ''' Get the script directory.
    
        :return: The name of the script directory.

        '''
        return self.__scriptDirectory

    def mustSimulate(self, flag):
        ''' Set a flag if the ``*.mos`` file of this instance needs to be simulated.
    
        :param flag: ``True`` if the ``*.mos`` file of this instance needs to be simulated.
    
        '''
        self.__simulateFile = flag

    def simulateFile(self):
        ''' Return ``True`` if the ``*.mos`` file of this object should be simulated.
    
        :return: ``True`` if the ``*.mos`` file of this object should be simulated.
        '''
        return self.__simulateFile

