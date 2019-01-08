cmake_policy(SET CMP0048 NEW)

project( Modelica-Buildings VERSION 5.1.0 )
cmake_minimum_required(VERSION 3.8)

find_package(Java REQUIRED)
include(UseJava)

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

set( MODELICA_HOME CACHE PATH "Modelica Home" )
find_library( ModelicaExternalC_LIB ModelicaExternalC HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
find_library( ModelicaIO_LIB ModelicaIO HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
find_library( ModelicaMatIO_LIB ModelicaMatIO HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
find_library( ModelicaStandardTables_LIB ModelicaStandardTables HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
find_library( Blas_LIB blas HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
find_library( Fmi1_cs_LIB fmi1_cs HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
find_library( Fmi1_me_LIB fmi1_me HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
find_library( Fmi2_LIB fmi2 HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
find_library( Jmi_LIB jmi HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
find_library( Jmi_block_solver_LIB jmi_block_solver HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
find_library( Jmi_get_set_default_LIB jmi_get_set_default HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
find_library( Lapack_LIB lapack HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
find_library( Zlib_LIB zlib HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )

list( APPEND MODELICA_LIBS
  ${ModelicaExternalC_LIB}
  ${ModelicaIO_LIB}
  ${ModelicaMatIO_LIB}
  ${ModelicaStandardTables_LIB}
  ${Blas_LIB}
  ${Fmi1_cs_LIB}
  ${Fmi1_me_LIB}
  ${Fmi2_LIB}
  ${Jmi_LIB}
  ${Jmi_block_solver_LIB}
  ${Jmi_get_set_default_LIB}
  ${Lapack_LIB}
  ${Zlib_LIB}
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
install( TARGETS ModelicaBuildingsEnergyPlus DESTINATION ${BUILDINGS_INSTALL_PREFIX}/Resources/Library/${PLATFORM_INSTALL_PREFIX} )

add_jar( ConvertEIRData 
  Buildings/Resources/src/fluid/chillers/convertEIR/src/convertEIR/BiCubicCurve.java 
  Buildings/Resources/src/fluid/chillers/convertEIR/src/convertEIR/BiQuadraticCurve.java 
  Buildings/Resources/src/fluid/chillers/convertEIR/src/convertEIR/ElectricEIR.java
  Buildings/Resources/src/fluid/chillers/convertEIR/src/convertEIR/ICurve.java 
  Buildings/Resources/src/fluid/chillers/convertEIR/src/convertEIR/ConvertEIRData.java 
  Buildings/Resources/src/fluid/chillers/convertEIR/src/convertEIR/Parser.java 
  Buildings/Resources/src/fluid/chillers/convertEIR/src/convertEIR/ParserResultObject.java
  Buildings/Resources/src/fluid/chillers/convertEIR/src/convertEIR/QuadraticCurve.java 
  Buildings/Resources/src/fluid/chillers/convertEIR/src/convertEIR/ReformElectricEIR.java
)
get_target_property(ConvertEIRData_JAR ConvertEIRData JAR_FILE)
install( PROGRAMS ${ConvertEIRData_JAR} DESTINATION ${BUILDINGS_INSTALL_PREFIX}/Resources/bin )

add_jar( ConvertDXData
  Buildings/Resources/src/fluid/dxcoils/convertDXSingleDoubleSpeed/src/convertDXSingleDoubleSpeed/BiQuadraticCurve.java 
  Buildings/Resources/src/fluid/dxcoils/convertDXSingleDoubleSpeed/src/convertDXSingleDoubleSpeed/DXSingleSpeed.java
  Buildings/Resources/src/fluid/dxcoils/convertDXSingleDoubleSpeed/src/convertDXSingleDoubleSpeed/ICurve.java 
  Buildings/Resources/src/fluid/dxcoils/convertDXSingleDoubleSpeed/src/convertDXSingleDoubleSpeed/ConvertDXData.java
  Buildings/Resources/src/fluid/dxcoils/convertDXSingleDoubleSpeed/src/convertDXSingleDoubleSpeed/Parser.java 
  Buildings/Resources/src/fluid/dxcoils/convertDXSingleDoubleSpeed/src/convertDXSingleDoubleSpeed/ParserResultObject.java
  Buildings/Resources/src/fluid/dxcoils/convertDXSingleDoubleSpeed/src/convertDXSingleDoubleSpeed/QuadraticCurve.java 
  Buildings/Resources/src/fluid/dxcoils/convertDXSingleDoubleSpeed/src/convertDXSingleDoubleSpeed/DXCoilPerformance.java
  Buildings/Resources/src/fluid/dxcoils/convertDXSingleDoubleSpeed/src/convertDXSingleDoubleSpeed/DXDoubleSpeed.java
)
get_target_property(ConvertDXData_JAR ConvertDXData JAR_FILE)
install( PROGRAMS ${ConvertDXData_JAR} DESTINATION ${BUILDINGS_INSTALL_PREFIX}/Resources/bin )

add_jar( ConvertWeatherData
  Buildings/Resources/src/convertEPW/src/ConvertWeatherData.java
)
get_target_property(ConvertWeatherData_JAR ConvertWeatherData JAR_FILE)
install( PROGRAMS ${ConvertWeatherData_JAR} DESTINATION ${BUILDINGS_INSTALL_PREFIX}/Resources/bin )

install( DIRECTORY Buildings/
  DESTINATION ${BUILDINGS_INSTALL_PREFIX}
  PATTERN CMakeLists.txt EXCLUDE
)

# Other stuff not compiled yet

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

