import scipy.io
import numpy
import os

filenames = list()
filenames.append("load_PV.mat")
filenames.append("SLP_33buildings.mat")

# Get current directory
currentDir = os.getcwd()

for name in filenames:
	# open the .mat file
	filePath = os.path.join(currentDir, name)
	mat = scipy.io.loadmat(name)
	
	# read the name of the tables that contains
	table_names = mat.keys()
	
	# create a new file that will contain all the tables
	newFilePath = filePath.replace(".mat",".txt")
	f = open(newFilePath, "w")
	f.write("#1\n")

	# read every table and write on a separate file
	for tab in table_names:
		data = mat[tab]
		row, col = numpy.shape(data)
		s = "double "+tab+"("+str(row)+", "+str(col)+")\n"
		f.write(s)
		
		for i in range(row):
			l = [ str(a) for a in data[i,:]]
			s = " ".join(l)+"\n"
			f.write(s)

	f.close()

		
