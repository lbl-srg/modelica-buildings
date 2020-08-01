##################################################################
# CMake file for Modelica Buildings Library
# To build all targets, run
# rm -rf build && mkdir build && cd build && cmake ../ && cmake --build . --target install && cd ..
#
##################################################################
cmake_policy(SET CMP0048 NEW)

project( Modelica-Buildings VERSION 5.1.0 )
cmake_minimum_required(VERSION 3.8)

# find_package(Java REQUIRED)
# include(UseJava)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -ldl")

set( BUILDINGS_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/Buildings")

set( CMAKE_INSTALL_PREFIX "${BUILDINGS_INSTALL_PREFIX}/Resources/Library/${PLATFORM_INSTALL_PREFIX}/" )

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

# Set target directories.
# NOTE: always add quotes to protect spaces in path when setting new variables.
if (WINDOWS)
    if(CMAKE_SYSTEM_PROCESSOR MATCHES ".*64$")
        set(PLATFORM_INSTALL_PREFIX win64)
    else()
        set(PLATFORM_INSTALL_PREFIX win32)
    endif()
elseif(LINUX)
    if(CMAKE_SYSTEM_PROCESSOR MATCHES ".*64$")
        set(PLATFORM_INSTALL_PREFIX linux64)
    else()
        set(PLATFORM_INSTALL_PREFIX linux32)
    endif()
elseif(MACOSX)
    set(PLATFORM_INSTALL_PREFIX darwin64)
endif()

if (LINUX)
add_definitions(-D_GNU_SOURCE)
message("Added GNU_SOURCE")
endif()

#install( DIRECTORY Buildings/
#  DESTINATION ${BUILDINGS_INSTALL_PREFIX}
#  PATTERN CMakeLists.txt EXCLUDE
#)

  add_library( ModelicaBuildingsEnergyPlus SHARED
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/InputVariableExchange.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/EnergyPlusUtil.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/OutputVariableFree.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/ZoneFree.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/ZoneExchange.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/OutputVariableExchange.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/InputVariableAllocate.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/InputVariableFree.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/ZoneInstantiate.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/BuildingInstantiate.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/InputVariableInstantiate.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/OutputVariableAllocate.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/EnergyPlusFMU.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/cryptographicsHash.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/ZoneAllocate.c
  Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources/OutputVariableInstantiate.c
)


target_include_directories( ModelicaBuildingsEnergyPlus
  PRIVATE Buildings/Resources/src/ThermalZones/EnergyPlus/C-Sources
)

target_link_libraries( ModelicaBuildingsEnergyPlus
  ${MODELICA_LIBS}
)
target_link_libraries(ModelicaBuildingsEnergyPlus dl)

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
