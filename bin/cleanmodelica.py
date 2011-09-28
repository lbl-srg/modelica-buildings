#!/usr/bin/env python
"""Deletes all temporary files created by Dymola, starting
   at the current working directory and recursively searching the 
   subdirectories.
"""
if __name__ == "__main__":
    import os, sys
    import fnmatch

    # List of files that should be deleted
    DELETEFILES=['buildlog.txt', 'dsfinal.txt', 'dsin.txt', 'dslog.txt', 
                 'dsmodel*', 'dymosim', 'dymosim.lib', 'dymosim.exp', 
                 'dymosim.exe', '*.mat', '*.mof', 
                 '*.bak-mo', 'request.', 'status.', 'status', 'failure' , 'stop']

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
        sys.stdout.write("Deleting '" + f + "'\n")
        os.remove(f)
