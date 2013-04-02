# Makefile to compile Python interface
# Michael Wetter (MWetter@lbl.gov) October 24, 2012
# Modified: Thierry S. Nouidui (TSNouidui@lbl.gov) to support Windows OS
# Date: March 27, 2013

SRCS = pythonInterpreter.c 
OBJS = pythonInterpreter.o

#######################################################
# WINDOWS OPERATING SYSTEMS
#######################################################

# Directory with python source files
PYTHONSrc=C:/Python27/include
# Directory with python libraries
PYTHONLibs=C:/Python27/libs

ifeq ($(OS),Windows_NT)
CC = gcc
IM = lib
CC_FLAGS += -D WIN32
  ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
    # Not implemented yet
  endif
  ifeq ($(PROCESSOR_ARCHITECTURE),x86)
    # Directory where executable will be copied
    BINDIR = ../../Library/win32
    CC_FLAGS += -D IA32 -Wall -I$(PYTHONSrc)
  endif
DLL  = ModelicaBuildingsPython2.7.dll 
LIB  = ModelicaBuildingsPython2.7.lib
DEF  = ModelicaBuildingsPython2.7.def
EXP  = ModelicaBuildingsPython2.7.exp

all: clean
	$(CC) $(CC_FLAGS) -c $(SRCS)
	$(CC)  -shared -o $(DLL) $(OBJS) -L$(PYTHONLibs) -lpython27
	# Note that import library is required on Windows
	# This set-up requires lib.exe to generate the
	# import library. lib.exe is available in Microsoft Visual Studio
	$(IM) /def:$(DEF) /OUT:$(LIB)
	mv $(LIB) $(DLL) $(BINDIR)
	@echo "==== libraries generated in $(BINDIR)"   

clean:
	rm -f $(OBJS) $(LIB) $(DLL) $(EXP)
	
else

#######################################################
# LINUX OPERATING SYSTEMS
######################################################

SHELL = /bin/sh
ARCH = $(shell getconf LONG_BIT)

# Directory where executable will be copied to
BINDIR = ../../Library/linux$(ARCH)

#######################################################
## Compilation flags
CC = cc

CC_FLAGS_32 = -Wall -I/usr/include/python2.7 -I/opt/dymola/source -lpython2.7 -lm -m32
CC_FLAGS_64 = -Wall -I/usr/include/python2.7 -I/opt/dymola/source -lpython2.7 -lm -m64
LIB  = libModelicaBuildingsPython2.7.so

# Note that -fPIC is recommended on Linux according to the Modelica specification

all: clean
	$(CC) $(CC_FLAGS_$(ARCH)) -fPIC -c $(SRCS)
	$(CC) -shared -fPIC -Wl,-soname,$(LIB) -o $(LIB) $(OBJS) -lc
#	ar -cvq $(LIB) $(OBJS)
	mv $(LIB) $(BINDIR)
	@echo "==== library generated in $(BINDIR)"

prg: clean
	$(CC) -g testProgram.c $(SRCS) -o testProgram  $(CC_FLAGS_$(ARCH))

clean:
	rm -f $(OBJS) $(LIB) main.o main

endif
