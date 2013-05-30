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

# Number of .mos files
N_mos_files = len(mos_files)

# number of modified models
N_modify_models = 0

# number of .mos scripts with problems
N_mos_problems = 0

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
	
	try:
		pModel    = re.compile('simulateModel\("([^\(|^"]+)[\S]*"')
		mModel    = pModel.match(line)
		modelName = mModel.group(1)
		if "startTime=startTime" in line:
			startTime = "startTime"
		elif "startTime=" in line:
			# Old version, does not work with 86400*900
			# pTime    = re.compile(r"[\d\S\s.,]*(stopTime=)([\d]*[.]*[\d]*[e]*[+|-]*[\d]*)")
			pTime    = re.compile(r"[\d\S\s.,]*(startTime=)([\d]*[.]*[\d]*[e]*[+|-]*[\d]*[*]*[\d]*[.]*[\d]*[e]*[+|-]*[\d]*)")
			mTime    = pTime.match(line)
			startTime = mTime.group(2)
		else:
			# Maybe the stopTime command is in the next line...
			print "\tThe startTime is not in the simulation command row... go ahead"
			found = False
			while found == False and i<len(content):
				line = content[i]
				i += 1
				# Remove white spaces
				line.replace(" ", "")
				
				if "startTime=" in line:
					found = True
					pTime    = re.compile(r"[\d\S\s.,]*(startTime=)([\d]*[.]*[\d]*[e]*[+|-]*[\d]*[*]*[\d]*[.]*[\d]*[e]*[+|-]*[\d]*)[\S\s.,]*")
					mTime    = pTime.match(line)
					startTime = mTime.group(2)
				if "startTime=startTime" in line:
					startTime = "startTime"
					
			
			if found == False:
				print "\tStartTime not found, defined the default stopTime=0.0"
				startTime = "0.0"
		
		print "\tStartTime: "+str(startTime)
		print "\tModelName: "+str(modelName)
		
	except AttributeError:
		print "\tThe script does not contain the simulation command! Maybe it is a plot script..."
		startTime = "NA"
		N_mos_problems += 1
		
	
	if startTime != "NA" and startTime != "startTime":		
		
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
			
			# if the lines contains experiment stop time, replace it
			# experiment(StopTime=2)
			if "StartTime=" in line and not found:
				# found the stopTime assignmant, replace with the value in the mos file
				print "\t==================="
				print "\t REPLACE"
				print "\t"+line
				
				pStopTime    = re.compile(r"[\d\S\s.,]*(StartTime=[\d]*[.]*[\d]*[e]*[+|-]*[\d]*[*]*[\d]*[.]*[\d]*[e]*[+|-]*[\d])")
				mStopTime    = pStopTime.match(line)
				stopTimeStr  = mStopTime.group(1)
				
				newLine = line.replace(stopTimeStr,"StartTime="+str(startTime))
				print "\t WITH"
				print "\t"+newLine
				
				# replace
				modelContent[i] = newLine
				found = True
				
			if ("annotation (" in line or "annotation(" in line) and not found:	
				# we reach the beginning of the annotation and we don't found the stop time
				# let's add it
				print "\t=============================================="
				print "\t NOT FOUND, ADD STOPTIME STATEMENT. REPLACE "
			
				# if true, reached the end of the annotations
				# Go back and look for the __DymolaCommand and replace it adding the experiment
				# stopTime command
				for k in range(Nlines-1, i-1, -1):
					
					line = modelContent[k]
					
					if "StopTime=" in line:
						print "\t"+line
						newLine = line.replace("StopTime" , "StartTime="+str(startTime)+", StopTime")
						print "\t WITH"
						print "\t"+newLine
						
						# replace
						modelContent[k] = newLine
						
						# replacement done
						found = True	
		
		# rewrite in an other file with the same name
		fm.close()
		
		print "\t================================="
		rewrite = raw_input("\n\tARE YOU SURE TO DO THAT (N/y)?")
		
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
			N_modify_models += 1
			
		else:
			print "\tThe file is safe..."
		
	elif startTime == "startTime":
		print "\n\t*******************************"
		print "\tDO THAT MODIFICATION AT HAND!!!"
		
	f.close()
	
	raw_input("\n\tContinue?")

print "\nNumber of modified models = "+str(N_modify_models) + " / " + str(N_mos_files)
print "Number of mos scripts with problems = "+str(N_mos_problems)


