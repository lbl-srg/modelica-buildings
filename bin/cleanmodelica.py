#!/usr/bin/env python3
"""Deletes all temporary files created by Dymola, starting
   at the current working directory and recursively searching the 
   subdirectories for files.
   In the current directory, the subdirectory 'binaries' will also be
   deleted as Dymola 2013 creates this directory when exporting an FMU.
"""
if __name__ == "__main__":
    import os, sys
    import shutil
    import fnmatch

    # List of files that should be deleted
    DELETEFILES=['buildlog.txt', 'dsfinal.txt', 'dsin.txt', 'dslog.txt', 
                 'dsmodel*', 'dymosim', 'dymosim.lib', 'dymosim.exp', 
                 'dymosim.dll', 'dymola.log', 'dymosim.exe', '*.mat', '*.mof', 
                 '*.bak-mo', 'request.', 'status.', 'status', 'failure', 
                 'success.', '*.log',
                 'stop', 'stop.',
                 'fmiModelIdentifier.h', 'modelDescription.xml',
                 'fmiFunctions.o',
                 'CSVWriter.csvWriter.csv', 'test.csv']
    # Directories to be deleted. This will be non-recursive
    DELETEDIRS=['binaries']

    # Array in which the names of the files that will be deleted are stored
    matches = []
    for root, dirnames, filenames in os.walk('.'):
        for fil in DELETEFILES:
            for filename in fnmatch.filter(filenames, fil):
                matches.append(os.path.join(root, filename))
        # Exclude .svn directories
        if '.svn' in dirnames:
            dirnames.remove('.svn')

    # Removed duplicate entries which may be due to wildcards
    matches = list(set(matches))
    # Delete the files
    for f in matches:
        sys.stdout.write("Deleting file '" + f + "'.\n")
        os.remove(f)
    # Delete directories
    for d in DELETEDIRS:
        if os.path.exists(d):
            sys.stdout.write("Deleting directory '" + d + "'.\n")
            shutil.rmtree(d)
        
