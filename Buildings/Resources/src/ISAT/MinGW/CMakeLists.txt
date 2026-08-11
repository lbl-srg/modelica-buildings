# CMake input file to compile ISAT source code
# Please see https://sites.psu.edu/sbslab/publications/tools/end-to-end-modeling-and-optimization-package-for-data-center-cooling/
# for guidance on compiling the ISAT libraries
# Cary Faulkner (cary.faulkner@colorado.edu) October 6, 2020

cmake_minimum_required(VERSION 3.10)

project(isat)
enable_language(Fortran)

# The ISAT/FastFluidDynamics C sources were originally only ever built with
# gcc's `-std=c89 -pedantic -fcommon` (see Resources/src/ISAT/Linux/makefile).
# In C89/gnu89 mode, calling a function that has not been declared yet is
# only a warning, and multiple tentative definitions of the same global
# (e.g. `FILE *file_log;`, declared in several headers) are merged instead
# of causing a link error. Modern gcc (>=14) defaults to gnu17 for C, in
# which both of the above become hard errors, so the flags below are
# required to keep the legacy code compiling unmodified.
set(CMAKE_C_STANDARD 90)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)
add_compile_options($<$<COMPILE_LANGUAGE:C>:-fcommon>)

SET(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS TRUE)
option(BUILD_SHARED_LIBS "Build shared libraries" ON)
file(GLOB_RECURSE c_sources ISAT/*.c FastFluidDynamics/*.c)

# Exclude stray Windows "* - Copy*.c" backup files that are sometimes left
# behind in the working tree (e.g. FastFluidDynamics/cosimulation - Copy.c).
# These are untracked duplicates of files that already exist elsewhere in
# the source tree (e.g. ISAT/cosimulation.c) and, if picked up by the glob
# above, cause "multiple definition of ..." link errors.
list(FILTER c_sources EXCLUDE REGEX " - Copy")
set(LIB_DIR ${CMAKE_SOURCE_DIR}/ISAT/MinGW/)
set(LIBS ${LIB_DIR}/libisatab_ser.a ${LIB_DIR}/liblapack.a ${LIB_DIR}/libblas.a)
set(MinGW_LIBS -lgfortran -lquadmath)

set(isat_sources ${c_sources})
if(MINGW)
  # ModelicaError()/ModelicaUtilities.h are supplied by the Modelica tool
  # (e.g. Dymola/OpenModelica) that loads this library at simulation time,
  # not by any source file compiled here, so the symbol is left undefined
  # on purpose in the ISAT/FastFluidDynamics sources. On Linux this is a
  # non-issue because gcc links shared objects (.so) by default without
  # requiring every referenced symbol to be resolved (see
  # Resources/src/ISAT/Linux/makefile, which links with plain `-shared`).
  # On Windows, a DLL's import table must be fully resolved at link time,
  # so building isat.dll with MinGW fails with
  # "undefined reference to `ModelicaError'" unless a definition is
  # provided. Add a small stub (stderr-only) so the standalone MinGW
  # build link succeeds; this file is not part of the official ISAT
  # build and has no effect when this library is loaded by a real
  # Modelica tool, which provides its own ModelicaError() first.
  list(APPEND isat_sources modelica_error_stub.c)
endif()

add_library(isat SHARED ${isat_sources})
target_link_libraries(isat ${LIBS} -static ${MinGW_LIBS})
set_target_properties(isat PROPERTIES PREFIX "")
set_target_properties(isat PROPERTIES IMPORT_PREFIX "")
