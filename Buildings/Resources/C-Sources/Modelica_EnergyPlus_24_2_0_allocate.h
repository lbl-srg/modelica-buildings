#ifndef Modelica_EnergyPlus_24_2_0_allocate_h
#define Modelica_EnergyPlus_24_2_0_allocate_h

#include "EnergyPlus_24_2_0_definitions.h"

extern void* allocate_Spawn_EnergyPlus_24_2_0(
  const int objectType,
  double startTime,
  const char* modelicaNameBuilding,
  const char* modelicaNameThermalZone,
  const char* spawnExe,
  const char* idfVersion,
  const char* idfName,
  const char* epwName,
  const runPeriod* runPer,
  double relativeSurfaceTolerance,
  const char* epName,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsRootFileLocation,
  const int logLevel,
  const int printUnit,
  const char* jsonName,
  const char* jsonKeysValues,
  const char** parOutNames,
  const size_t nParOut,
  const char** parOutUnits,
  const size_t nParOutUni,
  const char** inpNames,
  const size_t nInp,
  const char** inpUnits,
  const size_t nInpUni,
  const char** outNames,
  const size_t nOut,
  const char** outUnits,
  const size_t nOutUni,
  const int* derivatives_structure,
  const size_t k,
  const size_t n,
  const double* derivatives_delta,
  const size_t nDer,
  void (*SpawnMessage)(const char *string),
  void (*SpawnError)(const char *string),
  void (*SpawnFormatMessage)(const char *string, ...),
  void (*SpawnFormatError)(const char *string, ...));

#endif
