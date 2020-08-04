# CMake file to build fmi library
# Invoke as
# rm -rf build && mkdir build && cd build && cmake .. && cmake --build . && cd ..

cmake_policy(SET CMP0048 NEW)

cmake_minimum_required(VERSION 3.8)

project( fmi-library
  VERSION 2.2
  DESCRIPTION "FMI Library for Modelica Buildings Library"
  LANGUAGES C
)

find_package(Git REQUIRED)


##################################################################################
# Detect OS.
if(CMAKE_SYSTEM_NAME MATCHES Windows)
    set(WINDOWS 1)
    message("Windows system detected.")
elseif(CMAKE_SYSTEM_NAME MATCHES Linux)
    set(LINUX 1)
    message("Linux system detected.")
elseif(CMAKE_SYSTEM_NAME MATCHES Darwin)
    set(MACOSX 1)
    message("Mac OS X system detected.")
else()
    message(WARNING "OS unknown!")
endif()

##################################################################################
# Set target directories.
if (WIN32) # True also on 64 bit Windows
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(PLATFORM_INSTALL_PREFIX win64)
    else()
        set(PLATFORM_INSTALL_PREFIX win32)
    endif()
elseif(APPLE)
    set(PLATFORM_INSTALL_PREFIX darwin64)
elseif(UNIX)
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(PLATFORM_INSTALL_PREFIX linux64)
    else()
        set(PLATFORM_INSTALL_PREFIX linux32)
    endif()
else()
    message(FATAL_ERROR "OS unknown!")
endif()
##################################################################################

include (ExternalProject)
#include(${CMAKE_ROOT}/Modules/ExternalProject.cmake)

set (FMI_LIBRARY "fmi-library-modelon")

ExternalProject_Add(
  ${FMI_LIBRARY}

  PREFIX         ${FMI_LIBRARY}
  GIT_REPOSITORY https://github.com/modelon-community/fmi-library
  GIT_TAG        2.2
  GIT_SHALLOW    ON

  BUILD_ALWAYS   OFF

#--Configure step-------------
#  CONFIGURE_COMMAND ""
  CMAKE_ARGS        DFMILIB_BUILD_SHARED_LIB=OFF DFMILIB_GENERATE_DOXYGEN_DOC=OFF

#--Build step-----------------
#  BUILD_COMMAND     "" #cmake --build ..
#--Install step---------------
#  [INSTALL_DIR dir]           # Installation prefix
#  INSTALL_COMMAND   ""
#--Test step------------------
   TEST_AFTER_INSTALL 0        # Add test step executed after install step
  )

##################################################################################
# Copy the library which is used by the Modelica compiler.
add_custom_command(TARGET ${FMI_LIBRARY}
  POST_BUILD
  COMMAND "${CMAKE_COMMAND}" -E copy
     "fmi-library-modelon/src/install/lib/libfmilib_shared.so"
     "${CMAKE_CURRENT_SOURCE_DIR}/../../../Library/${PLATFORM_INSTALL_PREFIX}/libfmilib_shared.so"
  COMMENT "Copying to Modelica library directory '${CMAKE_CURRENT_SOURCE_DIR}/../../../Library/${PLATFORM_INSTALL_PREFIX}/libfmilib_shared.so'")

# Copy header files which are used to build the Modelica-EnergyPlus interface.
foreach(dir_name include doc)

  file(REMOVE_RECURSE ${CMAKE_CURRENT_SOURCE_DIR}/${dir_name})
  file(MAKE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${dir_name})
  file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/build/fmi-library-modelon/src/install/${dir_name} DESTINATION ${CMAKE_CURRENT_SOURCE_DIR})
  message(Copied header files to ${CMAKE_CURRENT_SOURCE_DIR}/${dir_name})
endforeach(dir_name)



