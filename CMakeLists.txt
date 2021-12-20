##################################################################
# CMake file for Modelica Buildings Library
# To build all targets, run
# rm -rf build && mkdir build && cd build && cmake ../ && cmake --build . --target install && cd ..
#
##################################################################
cmake_policy(SET CMP0048 NEW)

project( Modelica-Buildings
  DESCRIPTION "Modelica Buildings Library"
  LANGUAGES C
)

cmake_minimum_required(VERSION 3.8)

# Create position independent code
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release")
  message(STATUS "Build type not specified: Use Release by default")
endif(NOT CMAKE_BUILD_TYPE)

# find_package(Java REQUIRED)
# include(UseJava)

set(BUILDINGS_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/Buildings")

# Output build system directories.
message("CMake source directory is: ${CMAKE_SOURCE_DIR}")

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

# Set compiler options
if ( CMAKE_COMPILER_IS_GNUCC )
    set(CMAKE_C_FLAGS  "${CMAKE_CXX_FLAGS} -O3 -Wall -Wextra -pedantic -Wmisleading-indentation -Wconversion -Wno-unused-function -Wno-unused-parameter")
endif()

if ( MSVC )
  add_compile_options("/wd4100")
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
  add_compile_definitions(EXTERNAL_FUNCTION_EXPORT)
endif()

# Set target directories.
# NOTE: always add quotes to protect spaces in path when setting new variables.
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

set(CMAKE_INSTALL_PREFIX "${BUILDINGS_INSTALL_PREFIX}/Resources/Library/${PLATFORM_INSTALL_PREFIX}/" )

# Set name of fmilib_shared
if (WIN32)
  set(FMILIB_SHARED "${CMAKE_INSTALL_PREFIX}fmilib_shared.lib")
elseif(APPLE)
  message(FATAL_ERROR "OS X is not yet supported.")
else()
  set(FMILIB_SHARED "${CMAKE_INSTALL_PREFIX}libfmilib_shared.so")
endif()


if (LINUX)
add_definitions(-D_GNU_SOURCE)
message("Added GNU_SOURCE")
endif()

add_library( ModelicaBuildingsEnergyPlus SHARED
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/SpawnUtil.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/SpawnObjectFree.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/SpawnObjectExchange.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/SpawnObjectInstantiate.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/BuildingInstantiate.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/SpawnFMU.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/cryptographicsHash.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/SpawnObjectAllocate.c
)

target_include_directories( ModelicaBuildingsEnergyPlus
  PRIVATE Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources
  PRIVATE Buildings/Resources/src/fmi-library/include
)

#link_directories(${CMAKE_SOURCE_DIR}/Buildings/Resources/Library/darwin64)

if (WIN32)
target_link_libraries( ModelicaBuildingsEnergyPlus
  PRIVATE ${FMILIB_SHARED}
  PRIVATE ${CMAKE_DL_LIBS}
)
else()
target_link_libraries( ModelicaBuildingsEnergyPlus
  PRIVATE ${CMAKE_DL_LIBS}
)
endif()

set(BUILDINGS_INSTALL_DIR "${BUILDINGS_INSTALL_PREFIX}/Resources/Library/${PLATFORM_INSTALL_PREFIX}/")
message("Installing to: ${BUILDINGS_INSTALL_DIR}")

install( TARGETS ModelicaBuildingsEnergyPlus DESTINATION ${BUILDINGS_INSTALL_DIR} )

# Other stuff not compiled yet

# add_jar( ConvertEIRData
#   Buildings/Resources/src/fluid/chillers/convertEIR/src/convertEIR/BiCubicCurve.java
#   Buildings/Resources/src/fluid/chillers/convertEIR/src/convertEIR/BiQuadraticCurve.java
#   Buildings/Resources/src/fluid/chillers/convertEIR/src/convertEIR/ElectricEIR.java
#   Buildings/Resources/src/fluid/chillers/convertEIR/src/convertEIR/ICurve.java
#   Buildings/Resources/src/fluid/chillers/convertEIR/src/convertEIR/ConvertEIRData.java
#   Buildings/Resources/src/fluid/chillers/convertEIR/src/convertEIR/Parser.java
#   Buildings/Resources/src/fluid/chillers/convertEIR/src/convertEIR/ParserResultObject.java
#   Buildings/Resources/src/fluid/chillers/convertEIR/src/convertEIR/QuadraticCurve.java
#   Buildings/Resources/src/fluid/chillers/convertEIR/src/convertEIR/ReformElectricEIR.java
# )
# get_target_property(ConvertEIRData_JAR ConvertEIRData JAR_FILE)
# install( PROGRAMS ${ConvertEIRData_JAR} DESTINATION ${BUILDINGS_INSTALL_PREFIX}/Resources/bin )
#
# add_jar( ConvertDXData
#   Buildings/Resources/src/fluid/dxcoils/convertDXSingleDoubleSpeed/src/convertDXSingleDoubleSpeed/BiQuadraticCurve.java
#   Buildings/Resources/src/fluid/dxcoils/convertDXSingleDoubleSpeed/src/convertDXSingleDoubleSpeed/DXSingleSpeed.java
#   Buildings/Resources/src/fluid/dxcoils/convertDXSingleDoubleSpeed/src/convertDXSingleDoubleSpeed/ICurve.java
#   Buildings/Resources/src/fluid/dxcoils/convertDXSingleDoubleSpeed/src/convertDXSingleDoubleSpeed/ConvertDXData.java
#   Buildings/Resources/src/fluid/dxcoils/convertDXSingleDoubleSpeed/src/convertDXSingleDoubleSpeed/Parser.java
#   Buildings/Resources/src/fluid/dxcoils/convertDXSingleDoubleSpeed/src/convertDXSingleDoubleSpeed/ParserResultObject.java
#   Buildings/Resources/src/fluid/dxcoils/convertDXSingleDoubleSpeed/src/convertDXSingleDoubleSpeed/QuadraticCurve.java
#   Buildings/Resources/src/fluid/dxcoils/convertDXSingleDoubleSpeed/src/convertDXSingleDoubleSpeed/DXCoilPerformance.java
#   Buildings/Resources/src/fluid/dxcoils/convertDXSingleDoubleSpeed/src/convertDXSingleDoubleSpeed/DXDoubleSpeed.java
# )
# get_target_property(ConvertDXData_JAR ConvertDXData JAR_FILE)
# install( PROGRAMS ${ConvertDXData_JAR} DESTINATION ${BUILDINGS_INSTALL_PREFIX}/Resources/bin )
#
# add_jar( ConvertWeatherData
#   Buildings/Resources/src/convertEPW/src/ConvertWeatherData.java
# )
#get_target_property(ConvertWeatherData_JAR ConvertWeatherData JAR_FILE)
#install( PROGRAMS ${ConvertWeatherData_JAR} DESTINATION ${BUILDINGS_INSTALL_PREFIX}/Resources/bin )
#
#
#
#./Buildings/Resources/Documentation/userGuide/Makefile
#./Buildings/Resources/Scripts/travis/Makefile
#./Buildings/Resources/src/Makefile

# python / documentation related
#./Buildings/Resources/src/fluid/heatpumps/calibration/doc/Makefile
#./Buildings/Resources/src/fluid/heatpumps/calibration/Makefile
#./Buildings/Resources/src/fluid/Makefile

# python interpreter
#./Buildings/Resources/src/python/Makefile.darwin
#./Buildings/Resources/src/python/Makefile.linux
#./Buildings/Resources/src/python/Makefile.windows.bat
