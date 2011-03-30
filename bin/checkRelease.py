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
REQUIRED_IN_COMPONENTS=['defaultComponentName']
# Global flags
#isBaseclass=False
#isExample=False


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
def addExamplesDescription(fileName):
    filObj=open(fileName, 'r')
    filTex=filObj.readlines()
    filObj.close()
    for l in filTex:
        print l
    ans="n"
    while ans != "n" and ans != "y":
        print "-----------------------------------------------------------------------------"
        ans = raw_input("------- Replace " + fileName + " with standard Examples file? [y,n]")
    if ans == "y":
        firInd=fileName.find("Buildings")
        tem=fileName[firInd:].split('/')
        pat=tem[:len(tem)-2]
        lin=list()
        wi=""
        i=0
        for t in pat:
            if (i == 0):
                wi=t
                i=1
            else:
                wi=wi + "." + t
        lin.append("within " + wi + ";")
        lin.append("package Examples \"Collection of models that illustrate model use and test models\"")
        lin.append("  extends Buildings.BaseClasses.BaseIconExamples;")
        lin.append("annotation (preferedView=\"info\", Documentation(info=\"<html>")
        lin.append("<p>")
        lin.append("This package contains examples for the use of models that can be found in")
        lin.append("<a href=\\\"modelica://"+ wi + "\\\">")
        lin.append(wi + "</a>.")
        lin.append("</p>")
        lin.append("</html>\"));")
        lin.append("end Examples;")
 
##--        filObj=open(fileName, 'w')
##--        for t in lin:
##--            filObj.write(t + "\n")
##--        filObj.close()

#        for t in lin:
#            print "----                      ", t
#            subprocess.Popen(args=["open", "-a", "emacs", fileName], 
#                                   shell=False)


#########################################################
# Main method
# Walk the directory tree, but skip svn folders
for (path, dirs, files) in os.walk(LIBHOME):
    posSVN=path.find('svn')
    posHel=path.find('help')
    # skip svn folders
    if posSVN == -1 and posHel == -1:
        # Set global flags
        isExample=(path.find('Examples') != -1)
        isBaseclass=(path.find('BaseClasses') != -1) or (path.find('Interfaces') != -1)
        # Loop over all files
        for filNam in files:
            pos1=filNam.find('.mo')
            pos2=filNam.find('.mos')
            # Test only for .mo or .mos, but not for package.order
            if ( pos1 > -1 or pos2 > -1):
                filFulNam=os.path.join(path, filNam)
                filNamTok=filFulNam.split("/")
                if ( pos2 == -1 ):
                    filObj=open(filFulNam, 'r')
                    filLin=filObj.readlines();
                    filObj.close();
                    isFunction=(max(filLin[1].find('function'), filLin[2].find('function')) > -1)
                    isPackage=(max(filLin[1].find('package'), filLin[2].find('package')) > -1)
                    isRecord=(max(filLin[1].find('record'), filLin[2].find('record')) > -1)
                else:
                    isFunction=False
                    isPackage=False
                    isRecord=False
                # Test .mo and .mos
                if (pos1 > -1) or (pos2 > -1):
                    reportErrorIfContains(filFulNam, INVALID_IN_ALL)
                # Test .mos files only
                if (pos1 == -1) and (pos2 > -1):
                    reportErrorIfContains(filFulNam, INVALID_IN_MOS)
                # Test .mo files only
                if (pos1 > -1) and (pos2 == -1):
                    if (not isExample):
                        reportErrorIfMissing(filFulNam, REQUIRED_IN_MO)
##                    if ( filNamTok[len(filNamTok)-1] == "package.mo") and (filNamTok[len(filNamTok)-2] == "Examples"):
##                        addExamplesDescription(filFulNam)
                if (not isBaseclass) and (not isExample) and (not isFunction) and (not isPackage) and (not isRecord) and (pos2 == -1) and ( filNam.find('package.mo') == -1 ) and ( filNam.find('UsersGuide.mo') == -1 ) and ( filNam.find('Types.mo') == -1 ):
                    reportErrorIfMissing(filFulNam, REQUIRED_IN_COMPONENTS)

        



