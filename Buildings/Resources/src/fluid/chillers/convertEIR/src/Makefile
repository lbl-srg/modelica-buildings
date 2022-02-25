SHELL = /bin/sh
# Makefile for convertIDF
# Thierry Nouidui (TSNouidui@lbl.gov), Wangda Zuo (WZuo@lbl.gov), Michael Wetter (MWetter@lbl.gov) October 03, 2010

# compilation flags
#
# Program name
PROG = ConvertEIRData.jar
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

SRCS =  convertEIR/BiCubicCurve.java convertEIR/BiQuadraticCurve.java convertEIR/ElectricEIR.java \
        convertEIR/ICurve.java convertEIR/ConvertEIRData.java convertEIR/Parser.java convertEIR/ParserResultObject.java \
        convertEIR/QuadraticCurve.java convertEIR/ReformElectricEIR.java

OBJS =  convertEIR/BiCubicCurve.class convertEIR/BiQuadraticCurve.class convertEIR/ElectricEIR.class \
        convertEIR/ICurve.class convertEIR/ConvertEIRData.class convertEIR/Parser.class \
        convertEIR/ParserResultObject.class convertEIR/QuadraticCurve.class convertEIR/ReformElectricEIR.class

JARS =  ConvertEIRData.jar

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
