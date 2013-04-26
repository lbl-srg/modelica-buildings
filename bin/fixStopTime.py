# Python script for managing the stopTime value between the .mos scripts and the annotation
#
# The .mos scripts are in the folder ../Buildings/Resources/Scripts/Dymola/...
# look at every .mos script and identify the name of the model that is simulated in the
# .mos file (typically these are examples)
#
# Once you know the model name,

import os
import re

def recursive_glob(rootdir='.', suffix=''):
    return [os.path.join(rootdir, filename) for rootdir, dirnames, filenames in os.walk(rootdir) for filename in filenames if ( filename.endswith(suffix) and ("ConvertBuildings_from" not in filename)) ]

mos_files = recursive_glob('../Buildings/Resources/Scripts/Dymola/', '.mos')

j = 1
for mos_file in mos_files:
	os.system("clear")
	print str(j)+": "+str(mos_file)
	j += 1
	
	f = open(mos_file,"r")
	
	content = f.readlines()
	found = False
	i = 0
	while found == False and i<len(content):
		l = content[i]
		if "simulateModel(" in l:
			line = l
			found = True
		i += 1
	
	print "\n\tContains: "+str(line)
	
	# The format is simulateModel("MODEL.PATH.NAME", xxx***, stopTime=#####.###, ***);
	
	# Remove white spaces
	line.replace(" ", "")
	
	pModel    = re.compile('simulateModel\("(\S+)"')
	mModel    = pModel.match(line)
	modelName = mModel.group(1)
	
	print "\tModelName: "+str(modelName)
	
	if "stopTime=stopTime" in line:
		stopTime = "1.0"
		
	elif "stopTime=" in line:
		pTime    = re.compile(r"[\d\S\s.,]*(stopTime=)([\d]*[.]*[\d]*[e]*[+|-]*[\d]*)")
		mTime    = pTime.match(line)
		stopTime = mTime.group(2)
	else:
		stopTime = "NA"
		
	print "\tStopTime: "+str(stopTime)
	
	if stopTime != "NA":
	
		modelPath = ""
		modelPath = modelName.replace(".", "/")
		modelPath = "../"+modelPath+".mo"
	
		print "\n\tThe model is here: "+str(modelPath)
		fm = open(modelPath,"r")
		
		modelContent = fm.readlines()
		Nlines = len(modelContent)

		found = False
		
		for i in range(Nlines-1, 0, -1):
			
			line = modelContent[i]
			
			# the line to be written in the new .mo file
			newLine = line
			
			# if the lines contains experiment stop time, replace it
			# experiment(StopTime=2)
			if "StopTime=" in line:
				found = True
				# found the stopTime assignmant, replace with the value in the mos file
				print "\t==================="
				print "\t REPLACE"
				print "\t"+line
				
				pStopTime    = re.compile(r"[\d\S\s.,]*(StopTime=[\d]*[.]*[\d]*[e]*[+|-]*[\d]*)")
				mStopTime    = pStopTime.match(line)
				stopTimeStr  = mStopTime.group(1)
				
				newLine = line.replace(stopTimeStr,"StopTime="+str(stopTime))
				print "\t WITH"
				print "\t"+newLine
				
			if "annotation (" in line and not found:	
				# we reach the beginning of the annotation and we don't found the stop time
				# let's add it
				print "\t=============================================="
				print "\t NOT FOUND, ADD STOPTIME STATEMENT. REPLACE "
				found = True
				print "\t"+line
				newLine = line.replace("annotation (" , "annotation ( experiment(StopTime="+str(stopTime)+"), ")
				print "\t WITH"
				print "\t"+newLine
				
			modelContent[i] = newLine
		
		# rewrite in an other file with the same name
		fm.close()
		
		print "\t================================="
		rewrite = raw_input("\n\tARE YOU SURE TO DO THAT (y/N)?")
		
		if rewrite == 'y':
			# Delete the old file
			print "\tDeleting the old version..."
			os.system("rm "+modelPath)
		
			# Create a new one with the same name
			fm = open(modelPath,"w")
		
			for line in modelContent:
				fm.write(line)
		
			# close and exit
			fm.close()
			
			print "\tNew model is available!"
		else:
			print "\tThe file is safe..."
		
	f.close()
	
	raw_input("\n\tContinue?")

    


