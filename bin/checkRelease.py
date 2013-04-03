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
# Regarding the strings __Dymola_*, see https://trac.modelica.org/Modelica/ticket/786
# for possible replacements.
INVALID_IN_ALL=["fixme", "import \"", "<h1", "<h2", "<h3", "todo", "xxx", "tt>", 
                "realString", "integerString", "structurallyIncomplete",
                "preferedView", "Algorithm=", "Diagram,", "DocumentationClass",
                "__Dymola_absoluteValue",
                "__Dymola_checkBox",
                "__Dymola_choicesAllMatching",
                "__Dymola_classOrder",
                "__Dymola_colorSelector",
                "__Dymola_editButton",
                "__Dymola_experimentSetupOutput",
                "__Dymola_InlineAfterIndexReduction",
                "__Dymola_keepConstant",
                "__Dymola_normallyConstant",
                "__Dymola_NumberOfIntervals",
                "__Dymola_saveSelector",
                "__Dymola_Text"]
# List of invalid strings in .mos files
INVALID_IN_MOS=[]
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

# Name of top-level package file
maiPac=LIBHOME.split(os.path.sep)[-1] + os.path.sep + 'package.mo'

# Walk the directory tree, but skip svn folders
for (path, dirs, files) in os.walk(LIBHOME):
    pos=path.find('svn')
    # skip svn folders
    if pos == -1:
        # Loop over all files
        for filNam in files:
            pos1=filNam.find('.mo')
            pos2=filNam.find('.mos')
            foundMo =  (pos1 == (len(filNam)-3))
            foundMos = (pos2 == (len(filNam)-4))
            filFulNam=os.path.join(path, filNam)
            # Test .mo and .mos
            if foundMo or foundMos:
                reportErrorIfContains(filFulNam, INVALID_IN_ALL)
            # Test .mos files only
            if foundMos:
                reportErrorIfContains(filFulNam, INVALID_IN_MOS)
            # Test .mo files only
            if foundMo:
                if (filFulNam.find('Examples') == -1):
                    reportErrorIfMissing(filFulNam, REQUIRED_IN_MO)
                if not filFulNam.endswith(maiPac):
                    reportErrorIfContains(filFulNam, ["uses("])
        



