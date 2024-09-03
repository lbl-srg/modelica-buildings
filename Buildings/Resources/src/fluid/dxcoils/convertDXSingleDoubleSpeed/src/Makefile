SHELL = /bin/sh
# Makefile for convertDXSingleDoubleSpeed
# Thierry Nouidui (TSNouidui@lbl.gov), Michael Wetter (MWetter@lbl.gov) November 20, 2012

# compilation flags
#
# Program name
PROG = ConvertDXData.jar
# Directory where executable will be copied to
BINDIR = ../../../../../bin
# Directory where html docs will be stored
HTMLDIR = ../doc/

#######################################################
## Compiler settings
JC = javac
#JCFLAGS = -Xlint
JCFLAGS =
JJ = jar
JFLAGS = cfm

SRCS =  convertDXSingleDoubleSpeed/BiQuadraticCurve.java convertDXSingleDoubleSpeed/DXSingleSpeed.java \
        convertDXSingleDoubleSpeed/ICurve.java convertDXSingleDoubleSpeed/ConvertDXData.java \
	convertDXSingleDoubleSpeed/Parser.java convertDXSingleDoubleSpeed/ParserResultObject.java \
	convertDXSingleDoubleSpeed/QuadraticCurve.java convertDXSingleDoubleSpeed/DXCoilPerformance.java \
        convertDXSingleDoubleSpeed/DXDoubleSpeed.java \


OBJS =  convertDXSingleDoubleSpeed/BiQuadraticCurve.class convertDXSingleDoubleSpeed/DXSingleSpeed.class\
        convertDXSingleDoubleSpeed/ICurve.class convertDXSingleDoubleSpeed/ConvertDXData.class \
	convertDXSingleDoubleSpeed/Parser.class convertDXSingleDoubleSpeed/ParserResultObject.class \
	convertDXSingleDoubleSpeed/QuadraticCurve.class convertDXSingleDoubleSpeed/DXCoilPerformance.class \
        convertDXSingleDoubleSpeed/DXDoubleSpeed.class \

JARS =  ConvertDXData.jar

#######################################################
all: clean doc
	$(JC) $(JCFLAGS) $(SRCS)
	$(JJ) $(JFLAGS) $(JARS) Manifest.txt $(OBJS) $(SRCS)
	$(JJ) -i $(JARS)
	rm $(OBJS)
	mv $(JARS) $(BINDIR)
	@echo "==== jar code generated"

doc:	cleandoc
	javadoc -d $(HTMLDIR) $(SRCS)
	@echo "==== Documents created"

cleandoc:
	rm -rf $(HTMLDIR)/*.html $(HTMLDIR)/package-list
	@echo "==== Clean of document directory finished"

clean: cleandoc
	rm -f $(PROG)
	rm -f $(BINDIR)/$(PROG)
	@echo "==== Clean of directory finished"
