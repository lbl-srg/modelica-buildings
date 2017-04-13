###################################################
# Run the JModelica verification branches as a  
# cronjob. This script will be invoked by 
# cronjob-modelica.sh to run every midnight.
# This script 
# - pulles the branches
# - matches the .mos and .mo parameters
# - runs the unit tests
# - pushes the updated results on the repo
# - logs the results in a log file
###################################################

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
import schedule
import time

import subprocess as sp
import os, sys, re
from datetime import datetime


def recursive_glob(rootdir='.', suffix=''):
    return [os.path.join(rootdir, filename) for rootdir, dirnames, 
            filenames in os.walk(rootdir) for filename in filenames 
            if ( filename.endswith(suffix) 
                 and ("ConvertBuildings_from" not in filename)) ]


def write_file(filnam, content):
    """ 
    Write new mos file.

    :param filnam: mos file name.

     """
    
    # Delete the old file
    # print( "\tDeleting the old mos script...")
    os.system("rm "+filnam)

    # Create a new one with the same name
    fm = open(filnam,"w")

    for line in content:
        fm.write(line)

    # close and exit
    fm.close()

def removeInverseAnnotation (mo_files):
    """ 
    Fix parameter settings.

    :param name: mo file.

     """

    j = 1
    nInvAnn = 0
    for mo_file in mo_files:
        if (os.path.basename(mo_file) in ['basicFlowFunction_dp.mo', 'basicFlowFunction_m_flow.mo']):
            j += 1
            
            f = open(mo_file, "r")
            content = f.readlines()
            found = False
            i = 0

            regex = r"inverse\("
            while found == False and i < len(content):
                l = content[i]
                l.replace(" ", "")
                matches = re.findall(regex, l)
                if (len(matches) != 0):
                    nInvAnn += 1
                    print ("Found inverse annotation in " + mo_file)
                    sub1 = re.sub(regex, "__LBNL(inverse(", l, 1)
                    content[i] = sub1
                    regex = r"\),"

                    matches = re.findall(regex, sub1)
                    if(len(matches) != 0):
                        sub2 = re.sub(regex, ")),", sub1, 1)
                        content[i] = sub2
                        found = True
                    else:
                        while found == False and i < len(content):
                            matches = re.findall(regex, content[i])
                            if (len(matches) != 0):
                                sub2 = re.sub(regex, ")),", content[i], 1)
                                content[i] = sub2
                                found = True
                            i += 1                
                    f.close()
                    write_file(mo_file, content)
                i += 1
    if(nInvAnn != 2):
        print("ERROR: Number of inverse annotation found is " \
		+ str (nInvAnn) + ". The expected number of inverse annotation was 2.")
        exit(1)
		#print("\n\tContains: {!s}".format(line))

def job():
	# Path to the script
	script_path = os.path.dirname(os.path.realpath(__file__))

	print('Changing to the BuildingsPy folder in ../BuildingsPy.')
	#f.write('Changing to the BuildingsPy folder in ../BuildingsPy' + 
	#        '\n')
	lib_path=os.path.abspath(os.path.join(script_path, '..', 'BuildingsPy')) 
	os.chdir(lib_path)

	retVal=sp.call(['git', 'checkout', 'issue142_cronjob'])
	if retVal != 0:
		print('Failed to checkout respository' +
		' when running ' + 'issue142_cronjob')
	#    f.write('Failed to checkout respository' +
	#    ' when running ' + 'issue142_cronjob' 
	#    + '\n')
		sys.exit(1)

	# Switch back to bin directory
	os.chdir(script_path)
	for i in ['IBPSA', 'Buildings']:
		if i=='IBPSA':
		    f= open('cronjobLogIBPSA.txt', 'a')
		else:
		    f= open('cronjobLogBuildings.txt', 'a') 
		f.write('###########################' + '\n')
		f.write(str(datetime.now()) + '\n')
		f.write('Ready to simulate branch ' + i + '\n')

		# Change to the folder with Modelica models
		if i=='IBPSA':
		    print('Changing to the IBPSA  folder in ../modelica/IBPSA.')
		    f.write('Changing to the IBPSA  folder in ../modelica/IBPSA' + 
		            '\n')
		    lib_path=os.path.abspath(os.path.join(script_path, '..', 'modelica', 'IBPSA'))
		else:
		    print('Changing to the IBPSA  folder in ../modelica-buildings/Buildings.')
		    f.write('Changing to the IBPSA  folder in ../modelica-buildings/Buildings' + 
		            '\n')
		    lib_path=os.path.abspath(os.path.join(script_path, '..', 
		                                          'modelica-buildings', 'Buildings'))
		
		# Change to the library folder
		os.chdir(lib_path)

		# Get the path to the library
		libHome = os.path.abspath(".")

		# Get the path to the mos files
		rootPackage = os.path.join(libHome, 'Fluid')

		#mos_files = recursive_glob(rootPackage, '.mos')
		mo_files = recursive_glob(rootPackage, '.mo')
		
		# Checkout the master branch
	    print('Checking out master.')
	    f.write('Checking out master' 
	            + '\n')
	    retVal=sp.call(['git', 'checkout', 'master'])
	    if retVal != 0:
	        print('Failed to checkout respository' +
	        ' when running ' + i + ' master branch.')
	        f.write('Failed to checkout respository' +
	        ' when running ' + i + ' master branch.' 
	        + '\n')
	        sys.exit(1)

	    print('Pulling master to update local files.')
	    f.write('Pulling master to update local files' 
	            + '\n')
		retVal=sp.call(['git', 'pull'])

		# Remove the inverse annotation
		removeInverseAnnotation (mo_files)    

		# Delete current reference results which are not dense
		print('Deleting old reference results which are not dense.')
		f.write('Deleting old reference results which are not dense' + 
		        '\n')
		retVal=os.system('rm -rf Resources/ReferenceResults/Dymola/*.*')
		
		if retVal != 0:
		    print('Failed to delete old reference result'+
		    ' when running ' + i + ' verification branch.')
		    f.write('Failed to delete old reference result'+
		    ' when running ' + i + ' verification branch.' + 
		    '\n')
		    sys.exit(1)
		
		# Check consistency of mo/mos parameters
		print('Matching .mos and .mo files.')
		f.write('Matching mos and mo files' + '\n')
		retVal=sp.call(['python', '../bin/runUnitTests.py', '--validate-mo-mos-only'])
		if retVal != 0:
		    print('Failed to match .mos to .mo parameters' +
		    ' when running ' + i + ' verification branch.')
		    f.write('Failed to match .mos to .mo parameters' +
		    ' when running ' + i + ' verification branch.' + 
		    '\n')
		    sys.exit(1)  

		# Run the unittests 
		print('Running the unittests')
		f.write('Running the unittests' + '\n')
		# How to autmatically accept new results?
		retVal=sp.call(['python', '../bin/runUnitTests.py'])
		#if retVal != 0:
		#    print('Failed to run the unittests' +
		#    ' when running ' + i + ' verification branch.')
		#    f.write('Failed to run the unittests' +
		#    ' when running ' + i + ' verification branch.' + 
		#    '\n')
		#    sys.exit(1)
		
		# Post the reference results to 
		# the repository
		#echo Posting the results on the repository
		os.chdir(script_path)
		retVal=sp.call(['make', '-f', 'Makefile.'+ "Annex60", 'dist'])

		
		# Checkout the old reference results
		print('Restoring the repository ' + i)
		f.write('Restoring the repository ' + i + '\n')
		os.chdir(lib_path)
		#if i=='IBPSA':
		#    retVal=sp.call(['git', 'checkout', '../IBPSA'])
		#else:
		#    retVal=sp.call(['git', 'checkout', '../Buildings'])
		
		#if retVal != 0:
		#    print('Failed to restore repository '  + i)
		#    f.write('Failed to restore repository' + 
		#        i + '\n')
		#    sys.exit(1)
		
		# Change to the working folder
		print('Changing to the working folder.')
		f.write('Changing to the working folder' + 
		        '\n')
		f.write('###########################' + 
		        '\n')
		os.chdir(script_path)
		
		# Closing the file
		f.close()

#schedule.every(10).minutes.do(job)
#schedule.every().hour.do(job)
schedule.every().day.at("11:08").do(job)
#schedule.every().monday.do(job)
#schedule.every().wednesday.at("13:15").do(job)

while True:
    schedule.run_pending()
    time.sleep(1)

