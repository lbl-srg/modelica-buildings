#!/usr/bin/python
#####################################################################
# This script checks mo and mos files for invalid syntax.
# Run this file before checking changes into the trunk.
#
# MWetter@lbl.gov                                          2011-03-06
#####################################################################
import os, string, fnmatch, os.path, sys
# --------------------------
# Global settings
LIBHOME=os.path.abspath(".")

# List of invalid strings
INVALID_IN_ALL=["fixme", "import \"", "<h1", "<h2", "<h3", "todo", "xxx", "tt>"]
# List of invalid strings in .mos files
INVALID_IN_MOS=["=false", "= false"]
# List of strings that are required in .mo files, except in Examples
REQUIRED_IN_MO=["documentation"]

#########################################################
def reportError(message):
    print "*** Error: ", message

#########################################################
def reportErrorIfContains(fileName, listOfStrings):
    filObj=open(fileName, 'r')
    filTex=filObj.read()
    filTex=filTex.lower()
    for string in listOfStrings:
        if (filTex.find(string.lower()) > -1):
            reportError("File '" 
                        + fileName.replace(LIBHOME, "", 1)
                        + "' contains invalid string '" 
                        + string + "'.")

#########################################################
def reportErrorIfMissing(fileName, listOfStrings):
    filObj=open(fileName, 'r')
    filTex=filObj.read()
    filTex=filTex.lower()
    for string in listOfStrings:
        if (filTex.find(string.lower()) == -1):
            reportError("File '" 
                        + fileName.replace(LIBHOME, "", 1)
                        + "' does not contain required string '" 
                        + string + "'.")

#########################################################
# Main method
# Walk the directory tree, but skip svn folders
for (path, dirs, files) in os.walk(LIBHOME):
    pos=path.find('svn')
    # skip svn folders
    if pos == -1:
        # Loop over all files
        for filNam in files:
            pos1=filNam.find('.mo')
            pos2=filNam.find('.mos')
            filFulNam=os.path.join(path, filNam)
            # Test .mo and .mos
            if (pos1 > -1) or (pos2 > -1):
                reportErrorIfContains(filFulNam, INVALID_IN_ALL)
            # Test .mos files only
            if (pos1 == -1) and (pos2 > -1):
                reportErrorIfContains(filFulNam, INVALID_IN_MOS)
            # Test .mo files only
            if (pos1 > -1) and (pos2 == -1):
                if (filFulNam.find('Examples') == -1):
                    reportErrorIfMissing(filFulNam, REQUIRED_IN_MO)
        



