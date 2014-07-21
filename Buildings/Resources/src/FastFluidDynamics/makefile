#######################################################
# LINUX OPERATING SYSTEMS
#######################################################
SHELL = /bin/sh

# Makefile to compile FFD DLL
# Michael Wetter (MWetter@lbl.gov) August 2, 2013


# Directory where executable will be copied to

BINDIR = ../../bin/

#######################################################
## Compilation flags
CC = cc

#Note that Dymola use 32bit compiler, so generated executable only support 32bit loaded library
CC_FLAGS_32 = -Wall -I/usr/include/python2.7 -lpython2.7 -lm -m32  



SRCS = advection.c boundary.c chen_zero_equ_model.c cosimulation.c \
       data_writer.c diffusion.c ffd.c ffd_data_reader.c ffd_dll.c geometry.c initialization.c \
       interpolation.c parameter_reader.c projection.c sci_reader.c solver.c solver_gs.c \
       solver_tdma.c timing.c utility.c visualization.c

OBJS = advection.o boundary.o chen_zero_equ_model.o cosimulation.o \
       data_writer.o diffusion.o ffd.o ffd_data_reader.o ffd_dll.o geometry.o initialization.o \
       interpolation.o parameter_reader.o projection.o sci_reader.o solver.o solver_gs.o \
       solver_tdma.o timing.o utility.o visualization.o

LIB = FFD-DLL.so
LIBS = -lpthread -lglut -lGLU

# Note that -fPIC is recommended on Linux according to the Modelica specification

all: clean
	$(CC) $(CC_FLAGS_32) -fPIC -c $(SRCS)
	$(CC) -m32 -shared -fPIC -Wl,-soname,$(LIB) -o $(LIB) $(OBJS) $(LIBS) -lc 
	mv $(LIB) $(BINDIR)
	@echo "==== library generated in $(BINDIR)"

clean:
	rm -f $(OBJS) $(BINDIR)$(LIB)

# To enable RootMakefile, add fellow empty targets
doc:
cleandoc:
