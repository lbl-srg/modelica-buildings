#######################################################
# LINUX OPERATING SYSTEMS
#######################################################
SHELL = /bin/sh
ARCH = $(shell getconf LONG_BIT)

# Makefile to compile ISAT source code
# This script is implemented based on the makefile for
# the FFD source code in src/FastFluidDynamics
# Cary Faulkner (cary.faulkner@colorado.edu) April 12, 2020


# Directory where executable will be copied to
BINDIR = ../../../Library/linux$(ARCH)

#######################################################
## Compilation flags
CC = gcc

#Note that Dymola use 32bit compiler, so generated executable only support 32bit loaded library
CC_FLAGS_32 = -Wall -lm -m32 -std=c89 -pedantic -msse2 -mfpmath=sse -fcommon
CC_FLAGS_64 = -Wall -lm -m64 -std=c89 -pedantic -msse2 -mfpmath=sse -fcommon

# Directory for FFD source code
FFD = ../../FastFluidDynamics/

# Directory for ISAT source code
ISAT = ../

SRCS = $(FFD)advection.c $(FFD)boundary.c $(FFD)chen_zero_equ_model.c $(ISAT)cosimulation.c \
       $(FFD)data_writer.c $(FFD)diffusion.c $(FFD)ffd.c $(FFD)ffd_data_reader.c $(FFD)ffd_dll.c \
       $(FFD)geometry.c $(FFD)initialization.c $(FFD)interpolation.c $(FFD)parameter_reader.c \
       $(FFD)projection.c $(FFD)sci_reader.c $(FFD)solver.c $(FFD)solver_gs.c \
       $(FFD)solver_tdma.c $(FFD)timing.c $(FFD)utility.c $(ISAT)ffd_isat.c $(ISAT)ffd_wrap.c \
       $(ISAT)isat_dll.c $(ISAT)usrfgh.c $(ISAT)utility_isat.c\

OBJS = advection.o boundary.o chen_zero_equ_model.o cosimulation.o \
       data_writer.o diffusion.o ffd.o ffd_data_reader.o ffd_dll.o geometry.o initialization.o \
       interpolation.o parameter_reader.o projection.o sci_reader.o solver.o solver_gs.o \
       solver_tdma.o timing.o utility.o ffd_isat.o ffd_wrap.o isat_dll.o\
       usrfgh.o utility_isat.o\

LIB = libisat.so
# LIBS = -lpthread -lc -lgfortran -llapack -lblas
LIBS = -lpthread -lc -lgfortran

# Note that -fPIC is recommended on Linux according to the Modelica specification

# $(CC) -shared -fPIC -Wl,-soname,$(LIB) -o $(LIB) $(OBJS) libisatab_ser.a $(LIBS)

all: clean
	mv $(FFD)modelica_ffd_common.h $(FFD)m1.h
	cp $(ISAT)modelica_ffd_common.h $(FFD)
	$(CC) $(CC_FLAGS_$(ARCH)) -fPIC -c $(SRCS)
	$(CC) -shared -fPIC -Wl,-soname,$(LIB) -o $(LIB) $(OBJS) libisatab_ser.a liblapack.a libblas.a $(LIBS)
	rm -f $(OBJS)
	mv $(LIB) $(BINDIR)
	@echo "==== library generated in $(BINDIR)"
	rm -f $(FFD)modelica_ffd_common.h
	mv $(FFD)m1.h $(FFD)modelica_ffd_common.h

clean:
	rm -f $(OBJS) $(BINDIR)$(LIB)

# To enable RootMakefile, add follow empty targets
doc:
cleandoc:
