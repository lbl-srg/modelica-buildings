/*
 * A structure to store the data needed to communicate with EnergyPlus.
 */

#ifndef Buildings_EnergyPlusFMU_h /* Not needed since it is only a typedef; added for safety */
#define Buildings_EnergyPlusFMU_h

#include "EnergyPlusTypes.h"
#include "EnergyPlusUtil.h"

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
  const char* modelicaNameBuilding,
  const char* idfName,
  const char* weaName,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot,
  const double initialTime,
  size_t logLevel,
  void (*SpawnMessage)(const char *string),
  void (*SpawnError)(const char *string),
  void (*SpawnFormatMessage)(const char *string, ...),
  void (*SpawnFormatError)(const char *string, ...));

void AddZoneToBuilding(FMUZone* zone, size_t logLevel);

void AddOutputVariableToBuilding(FMUOutputVariable* ptrOutVar, size_t logLevel);

void AddInputVariableToBuilding(FMUInputVariable* ptrOutVar, size_t logLevel);

FMUBuilding* getBuildingsFMU(size_t iFMU);

void FMUBuildingFree(FMUBuilding* bui);

#endif
