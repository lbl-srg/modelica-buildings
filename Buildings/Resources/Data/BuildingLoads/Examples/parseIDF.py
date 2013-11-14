# Load the jinja library's namespace into the current module.
import jinja2
import io

# In this case, we will load templates off the filesystem.
# This means we must construct a FileSystemLoader object.
# 
# The search path can be used to make finding templates by
#   relative paths much easier.  In this case, we are using
#   absolute paths and thus set it to the filesystem root.
templateLoader = jinja2.FileSystemLoader( searchpath="./Templates/" )

# An environment provides the data necessary to read and
#   parse our templates.  We pass in the loader object here.
templateEnv = jinja2.Environment( loader=templateLoader )

# Names of the zones that may be present in each idf file
Zone_names = ["PER-1T", "PER-2T", "PER-3T", "PER-4T", "COR-T",\
              "PER-1F", "PER-2F", "PER-3F", "PER-4F", "COR-F"]
names_extra = ["PER-1I", "PER-2I", "PER-3I", "PER-4I", "COR-I"]
Zone_names_extra = Zone_names + names_extra
	
# dictionary containing the name of the idf files as keys, and the corresponding zone names
dictionary = {"A": Zone_names, "B": Zone_names, "C": Zone_names, "D": Zone_names_extra, "E": Zone_names_extra}

for key, value in dictionary.iteritems():
	
	# This constant string specifies the template file we will use.
	outFile = "./Updated_idf/"+key+".idf"
	TEMPLATE_FILE = key+"_template.jinja"
	print "Creating IDF file ",outFile," Using template",TEMPLATE_FILE,"..."

	# Read the template file using the environment object.
	# This also constructs our Template object.
	template = templateEnv.get_template( TEMPLATE_FILE )

	# Specify any input variables to the template as a dictionary.
	templateVars = { "zones" : value}

	# Finally, process the template to produce our final text.
	outputText = template.render( templateVars )

	# Write the idf file
	f = io.open(outFile,"w", newline='\r\n')
	f.write(outputText)
	f.close()
	print "Created"

	
