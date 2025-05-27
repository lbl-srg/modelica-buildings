/*
 * A structure to store the data needed to communicate with EnergyPlus.
 */

#ifndef Buildings_SpawnFMU_h /* Not needed since it is only a typedef; added for safety */
#define Buildings_SpawnFMU_h

#include "SpawnTypes.h"
#include "SpawnUtil.h"

#include <stdlib.h>
#include <stddef.h>  /* stddef defines size_t */
#include <string.h>
#include <stdio.h>
#include <stdbool.h>

/* #include <ModelicaUtilities.h> */

void incrementBuildings_nFMU();
void decrementBuildings_nFMU();
size_t getBuildings_nFMU();

size_t AllocateBuildingDataStructure(
  double startTime,
  const char* modelicaNameBuilding,
  const char* spawnExe,
  const char* idfVersion,
  const char* idfName,
  const char* epwName,
  const int autosizeHVAC,
  const int use_sizingPeriods,
  const runPeriod* runPer,
  double relativeSurfaceTolerance,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsRootFileLocation,
  const int logLevel,
  void (*SpawnMessage)(const char *string),
  void (*SpawnError)(const char *string),
  void (*SpawnFormatMessage)(const char *string, ...),
  void (*SpawnFormatError)(const char *string, ...));

void AddSpawnObjectToBuilding(SpawnObject* exchangeObject, const int logLevel);

FMUBuilding* getBuildingsFMU(size_t iFMU);

void FMUBuildingFree(FMUBuilding* bui);

#endif
