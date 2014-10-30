SHELL = /bin/sh
# Makefile for convertEPW
# Wangda Zuo (WZuo@lbl.gov), Michael Wetter (MWetter@lbl.gov) July 14, 2010

# compilation flags
#
# Program name
PROG = ConvertWeatherData.jar
# Directory where executable will be copied to
BINDIR = ../../../bin
# Directory where html docs will be stored
HTMLDIR = ../doc/

#######################################################
## Compiler settings
JC = javac
JJ = jar
JFLAGS = cfm

SRCS = ConvertWeatherData.java
OBJS = ConvertWeatherData.class
JARS = ConvertWeatherData.jar
#######################################################
all: clean doc
	$(JC) $(SRCS)
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

