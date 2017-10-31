#!/usr/bin/env python
##########################################################
# This script retrieves the reference results from
# a remote repository which is at
# https://simulationresearch.lbl.gov/jmodelica/modelica-buildings/Dymola/.
#
# This script creates a folder called 'Dymola'
# in the working directory and writes the
# reference results retrieved from the repository.
#
# Usage: ./getReferenceResults.py
#
#
# TSNouidui@lbl.gov                             2016-12-13
############################################################
from urllib2 import urlopen
import re
import os

# Name of the directory containing the reference results
directory ='Dymola_Ext'
if __name__ == "__main__":
    # Path to the directory with reference results
    urlResPath = 'https://simulationresearch.lbl.gov/jmodelica/modelica-buildings/Dymola/'
    urlpath =urlopen(urlResPath)
    string = urlpath.read().decode('utf-8')

    # Regular expression to extract reference results
    pattern = re.compile('(?<=\>)[a-zA-Z0-9_a-zA-Z0-9]+[.]+[txt]*')
    filelist = pattern.findall(string)

    # Create a reference results' directory in working folder
    if not os.path.exists(directory):
        os.makedirs(directory)

    for filename in filelist:
        # Check files with length longer than 7
        if len(filename) > 7:
            remotefile = urlopen(urlResPath + filename)
	    localfile = open(os.path.join(directory, filename),'w')
            localfile.write(remotefile.read())
            localfile.close()
            remotefile.close()
