This directory contains the source files
that are used to build the Python API
for the Buildings library.
To compile the files on Linux Ubuntu,
the package python-dev needs to be installed.

The makefile generates libraries for the respective
operating system, and copies the library to
Buildings/Resources/Library/"operatingSystem".

Note that Dymola 2013 FD01 on Linux Ubuntu 64 bit compiles
the executable as a 32 bit application. Hence,
to 32 bit version of the library will be used.
