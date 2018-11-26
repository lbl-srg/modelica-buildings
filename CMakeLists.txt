
project( modelica-buildings C )

add_library( modelica-buildings
  #Buildings/Resources/C-Sources/cfdCosimulation.h
  #Buildings/Resources/C-Sources/cfdExchangeData.c
  #Buildings/Resources/C-Sources/cfdReceiveFeedback.c
  #Buildings/Resources/C-Sources/cfdSendStopCommand.c
  #Buildings/Resources/C-Sources/cfdStartCosimulation.c
  #Buildings/Resources/C-Sources/cryptographicsHash.c
  #Buildings/Resources/C-Sources/cryptographicsHash.h
  #Buildings/Resources/C-Sources/exchangeValues.c
  #Buildings/Resources/C-Sources/externalObjectStructure.h
  #Buildings/Resources/C-Sources/fileWriterFree.c
  #Buildings/Resources/C-Sources/fileWriterInit.c
  #Buildings/Resources/C-Sources/fileWriterStructure.h
  #Buildings/Resources/C-Sources/freeArray.c
  #Buildings/Resources/C-Sources/initArray.c
  #Buildings/Resources/C-Sources/plotFree.c
  #Buildings/Resources/C-Sources/plotInit.c
  #Buildings/Resources/C-Sources/plotObjectStructure.h
  #Buildings/Resources/C-Sources/plotSendReal.c
  #Buildings/Resources/C-Sources/plotSendString.c
  #Buildings/Resources/C-Sources/plotSendTerminalString.c
  #Buildings/Resources/src/EnergyPlus/fmi2Functions.h
  #Buildings/Resources/src/EnergyPlus/fmi2FunctionTypes.h
  #Buildings/Resources/src/EnergyPlus/fmi2TypesPlatform.h
  Buildings/Resources/src/EnergyPlus/FMUEnergyPlusStructure.c
  Buildings/Resources/src/EnergyPlus/FMUEnergyPlusStructure.h
  Buildings/Resources/src/EnergyPlus/FMUZoneExchange.c
  Buildings/Resources/src/EnergyPlus/FMUZoneFree.c
  Buildings/Resources/src/EnergyPlus/FMUZoneInit.c
  Buildings/Resources/src/EnergyPlus/FMUZoneInstantiate.c
  #Buildings/Resources/src/EnergyPlus/ModelicaUtilities.h
  #Buildings/Resources/src/FastFluidDynamics/advection.c
  #Buildings/Resources/src/FastFluidDynamics/advection.h
  #Buildings/Resources/src/FastFluidDynamics/boundary.c
  #Buildings/Resources/src/FastFluidDynamics/boundary.h
  #Buildings/Resources/src/FastFluidDynamics/chen_zero_equ_model.c
  #Buildings/Resources/src/FastFluidDynamics/chen_zero_equ_model.h
  #Buildings/Resources/src/FastFluidDynamics/cosimulation.c
  #Buildings/Resources/src/FastFluidDynamics/cosimulation.h
  #Buildings/Resources/src/FastFluidDynamics/data_structure.h
  #Buildings/Resources/src/FastFluidDynamics/data_writer.c
  #Buildings/Resources/src/FastFluidDynamics/data_writer.h
  #Buildings/Resources/src/FastFluidDynamics/diffusion.c
  #Buildings/Resources/src/FastFluidDynamics/diffusion.h
  #Buildings/Resources/src/FastFluidDynamics/ffd.c
  #Buildings/Resources/src/FastFluidDynamics/ffd.h
  #Buildings/Resources/src/FastFluidDynamics/ffd_data_reader.c
  #Buildings/Resources/src/FastFluidDynamics/ffd_data_reader.h
  #Buildings/Resources/src/FastFluidDynamics/ffd_dll.c
  #Buildings/Resources/src/FastFluidDynamics/ffd_dll.h
  #Buildings/Resources/src/FastFluidDynamics/geometry.c
  #Buildings/Resources/src/FastFluidDynamics/geometry.h
  #Buildings/Resources/src/FastFluidDynamics/initialization.c
  #Buildings/Resources/src/FastFluidDynamics/initialization.h
  #Buildings/Resources/src/FastFluidDynamics/interpolation.c
  #Buildings/Resources/src/FastFluidDynamics/interpolation.h
  #Buildings/Resources/src/FastFluidDynamics/modelica_ffd_common.h
  #Buildings/Resources/src/FastFluidDynamics/parameter_reader.c
  #Buildings/Resources/src/FastFluidDynamics/parameter_reader.h
  #Buildings/Resources/src/FastFluidDynamics/projection.c
  #Buildings/Resources/src/FastFluidDynamics/projection.h
  #Buildings/Resources/src/FastFluidDynamics/sci_reader.c
  #Buildings/Resources/src/FastFluidDynamics/sci_reader.h
  #Buildings/Resources/src/FastFluidDynamics/solver.c
  #Buildings/Resources/src/FastFluidDynamics/solver.h
  #Buildings/Resources/src/FastFluidDynamics/solver_gs.c
  #Buildings/Resources/src/FastFluidDynamics/solver_gs.h
  #Buildings/Resources/src/FastFluidDynamics/solver_tdma.c
  #Buildings/Resources/src/FastFluidDynamics/solver_tdma.h
  #Buildings/Resources/src/FastFluidDynamics/timing.c
  #Buildings/Resources/src/FastFluidDynamics/timing.h
  #Buildings/Resources/src/FastFluidDynamics/utility.c
  #Buildings/Resources/src/FastFluidDynamics/utility.h
)

target_link_libraries(modelica-buildings
  ModelicaExternalC
  ModelicaIO
  ModelicaMatIO
  ModelicaStandardTables
  zlib
  dl
)

target_include_directories(modelica-buildings 
  PUBLIC 
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Buildings/Resources/C-Sources/>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Buildings/Resources/src/EnergyPlus/>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Buildings/Resources/src/FastFluidDynamics/>
  $<INSTALL_INTERFACE:include/modelica-buildings>
)

install(TARGETS modelica-buildings EXPORT modelica-buildings 
  RUNTIME DESTINATION bin
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
)

install(EXPORT modelica-buildings DESTINATION lib/modelica-buildings)

