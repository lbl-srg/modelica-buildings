cmake_policy(SET CMP0048 NEW)

project( Modelica-Buildings VERSION 5.1.0 )
cmake_minimum_required(VERSION 3.8)

# find_package(Java REQUIRED)
# include(UseJava)

set( BUILDINGS_INSTALL_PREFIX "Buildings")
if( APPLE )
  set( PLATFORM_INSTALL_PREFIX darwin64 )
elseif( WIN32 )
  if(CMAKE_SYSTEM_PROCESSOR STREQUAL "i386")
    set( PLATFORM_INSTALL_PREFIX win32 )
  else()
    set( PLATFORM_INSTALL_PREFIX win64 )
  endif()
elseif( LINUX )
  if(CMAKE_SYSTEM_PROCESSOR STREQUAL "i386")
    set( PLATFORM_INSTALL_PREFIX linux32 )
  else()
    set( PLATFORM_INSTALL_PREFIX linux64 )
  endif()
endif()

install( DIRECTORY Buildings/
  DESTINATION ${BUILDINGS_INSTALL_PREFIX}
  PATTERN CMakeLists.txt EXCLUDE
)

add_library( ModelicaBuildingsEnergyPlus SHARED
  Buildings/Resources/src/EnergyPlus/ModelicaUtilities.h
  Buildings/Resources/src/EnergyPlus/fmi2FunctionTypes.h
  Buildings/Resources/src/EnergyPlus/fmi2Functions.h
  Buildings/Resources/src/EnergyPlus/fmi2TypesPlatform.h
  Buildings/Resources/src/EnergyPlus/FMUEnergyPlusStructure.c
  Buildings/Resources/src/EnergyPlus/FMUZoneExchange.c
  Buildings/Resources/src/EnergyPlus/FMUZoneFree.c
  Buildings/Resources/src/EnergyPlus/FMUZoneInit.c
  Buildings/Resources/src/EnergyPlus/FMUZoneInstantiate.c
)
target_link_libraries( ModelicaBuildingsEnergyPlus
  ${MODELICA_LIBS}
)
install( TARGETS ModelicaBuildingsEnergyPlus DESTINATION ${BUILDINGS_INSTALL_PREFIX}/Resources/Library/${PLATFORM_INSTALL_PREFIX}/ )

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
