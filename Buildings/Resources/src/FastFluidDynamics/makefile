#######################################################
# LINUX OPERATING SYSTEMS
#######################################################
SHELL = /bin/sh
ARCH = $(shell getconf LONG_BIT)
# Makefile to compile Python interface
# Michael Wetter (MWetter@lbl.gov) October 24, 2012


# Directory where executable will be copied to
BINDIR = ../../Library/linux$(ARCH)

#######################################################
## Compilation flags
CC = gcc

#Note that Dymola use 32bit compiler, so generated executable only support 32bit loaded library
CC_FLAGS_32 = -Wall -lm -m32 -std=c89 -pedantic -msse2 -mfpmath=sse
CC_FLAGS_64 = -Wall -lm -m64 -std=c89 -pedantic -msse2 -mfpmath=sse

SRCS = advection.c boundary.c chen_zero_equ_model.c cosimulation.c \
       data_writer.c diffusion.c ffd.c ffd_data_reader.c ffd_dll.c geometry.c initialization.c \
       interpolation.c parameter_reader.c projection.c sci_reader.c solver.c solver_gs.c \
       solver_tdma.c timing.c utility.c

OBJS = advection.o boundary.o chen_zero_equ_model.o cosimulation.o \
       data_writer.o diffusion.o ffd.o ffd_data_reader.o ffd_dll.o geometry.o initialization.o \
       interpolation.o parameter_reader.o projection.o sci_reader.o solver.o solver_gs.o \
       solver_tdma.o timing.o utility.o

LIB = libffd.so
LIBS = -lpthread

# Note that -fPIC is recommended on Linux according to the Modelica specification

all: clean
	$(CC) $(CC_FLAGS_$(ARCH)) -fPIC -c $(SRCS)
	$(CC) -shared -fPIC -Wl,-soname,$(LIB) -o $(LIB) $(OBJS) $(LIBS) -lc
	rm -f $(OBJS)
	mv $(LIB) $(BINDIR)
	@echo "==== library generated in $(BINDIR)"

clean:
	rm -f $(OBJS) $(BINDIR)$(LIB)

# To enable RootMakefile, add fellow empty targets
doc:
cleandoc:
