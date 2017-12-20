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
INVALID_IN_ALL=["fixme", "import \"",
                "import Buildings;",
                "<h1", "<h2", "<h3", "todo", "xxx", "tt>", "<--",
                "realString", "integerString", "structurallyIncomplete",
                "preferedView", "Algorithm=", "Diagram,", "DocumentationClass",
                "Modelica.Icons.Info;",
                "modelica:Buildings",
                "Modelica:Buildings",
                "modelica:Modelica",
                "Modelica:Modelica",
                "__Dymola_absoluteValue",
                "__Dymola_checkBox",
                "__Dymola_choicesAllMatching",
                "__Dymola_classOrder",
                "__Dymola_connectorSizing",
                "__Dymola_loadSelector",
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
# List of invalid regular expressions in .mo files
INVALID_REGEXP_IN_MO=["StopTime\s*=\s*\d\s*[*]\s*\d+"]
# List of strings that are required in .mo files, except in Examples
REQUIRED_IN_MO=["documentation"]

#########################################################
def reportError(message):
    print "*** Error: ", message
    global IERR
    IERR=IERR+1

#########################################################
def report_empty_statements(fileName, start_line, next_line):
    filObj=open(fileName, 'r')
    filTex=filObj.readlines()
    found_loop = False
    iLin = 1;
    for lin in filTex:
        if lin.rstrip().endswith(start_line):
            found_loop = True
        else:
            if found_loop and lin.lstrip().startswith(next_line):
                reportError("File '"
                            + fileName.replace(LIBHOME, "", 1)
                            + "' contains an empty '" + start_line + " ... " + next_line +
                            "' on line '" + str(iLin) + "'.")
                found_loop = False
            else:
                found_loop = False
        iLin += 1

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
def reportErrorIfContainsRegExp(fileName, listOfStrings):
    import re
    filObj=open(fileName, 'r')
    filTex=filObj.read()
    for string in listOfStrings:
        match = re.search(string, filTex, re.I)
        if match is not None:
            reportError("File '"
                        + fileName.replace(LIBHOME, "", 1)
                        + "' contains invalid string regular expression '"
                        + string + "' in '"
                        + match.group() + "'.")

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

# Number of errors found
IERR=0

# Walk the directory tree, but skip the userGuide folder as it contains .mo models
# that have the uses(...) annotation
for (path, dirs, files) in os.walk(LIBHOME):
    pos=path.find(os.path.join('Resources', 'Documentation', 'userGuide'))
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
                reportErrorIfContainsRegExp(filFulNam, INVALID_REGEXP_IN_MO)
                if (filFulNam.find('Examples') == -1):
                    reportErrorIfMissing(filFulNam, REQUIRED_IN_MO)
                if not filFulNam.endswith(maiPac):
                    reportErrorIfContains(filFulNam, ["uses("])
                # Check for empty statements, which can happen if connections are deleted
                report_empty_statements(filFulNam, "loop", "end for")
                report_empty_statements(filFulNam, "then", "end if")
                report_empty_statements(filFulNam, "then", "else")
                report_empty_statements(filFulNam, "else", "end if")

# Terminate if there was an error.
# This allows other scripts to check the return value
if IERR != 0:
    print "*** Terminating due to found errors in examined files."
    sys.exit(2)
