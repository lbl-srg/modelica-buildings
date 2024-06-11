/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_SpawnObjectAllocate_h
#define Buildings_SpawnObjectAllocate_h

#include "SpawnTypes.h"
#include "SpawnFMU.h"
#include "SpawnUtil.h"

/* Create the structure and return a pointer to its address. */
LBNL_Spawn_EXPORT void* allocate_Spawn_EnergyPlus_9_6_0(
  const int objectType,
  double startTime,
  const char* modelicaNameBuilding,
  const char* modelicaName,
  const char* spawnExe,
  const char* idfVersion,
  const char* idfName,
  const char* epwName,
  const int autosizeHVAC,
  const int use_sizingPeriods,
  double relativeSurfaceTolerance,
  const char* epName,
  const char* hvacZone,
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
