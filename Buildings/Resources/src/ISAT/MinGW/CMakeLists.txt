# CMake input file to compile ISAT source code
# Please see https://www.colorado.edu/lab/sbs/data-center-package
# for guidance on compiling the ISAT libraries
# Cary Faulkner (cary.faulkner@colorado.edu) October 6, 2020

cmake_minimum_required(VERSION 2.8.12)

project(isat)
enable_language(Fortran)

SET(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS TRUE)
option(BUILD_SHARED_LIBS "Build shared libraries" ON)
file(GLOB_RECURSE c_sources ISAT/*.c FastFluidDynamics/*.c)
set(LIB_DIR ${CMAKE_SOURCE_DIR}/ISAT/MinGW/)
set(LIBS ${LIB_DIR}/libisatab_ser.a ${LIB_DIR}/liblapack.a ${LIB_DIR}/libblas.a)
set(MinGW_LIBS -lgfortran -lquadmath)

add_library(isat SHARED ${c_sources})
target_link_libraries(isat ${LIBS} -static ${MinGW_LIBS})
set_target_properties(isat PROPERTIES PREFIX "")
set_target_properties(isat PROPERTIES IMPORT_PREFIX "")
