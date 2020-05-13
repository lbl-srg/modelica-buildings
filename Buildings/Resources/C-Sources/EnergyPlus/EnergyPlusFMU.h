/*
 * A structure to store the data needed to communicate with EnergyPlus.
 */

#ifndef Buildings_EnergyPlusFMU_h /* Not needed since it is only a typedef; added for safety */
#define Buildings_EnergyPlusFMU_h

#include "EnergyPlusTypes.h"

#include <stdlib.h>
#include <stddef.h>  /* stddef defines size_t */
#include <string.h>
#include <stdio.h>
#include <stdbool.h>

#include <ModelicaUtilities.h>

void incrementBuildings_nFMU();
void decrementBuildings_nFMU();
unsigned int getBuildings_nFMU();

size_t AllocateBuildingDataStructure(
  const char* modelicaNameBuilding,
  const char* idfName,
  const char* weaName,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot);

void AddZoneToBuilding(FMUZone* ptrZone);

void AddOutputVariableToBuilding(FMUOutputVariable* ptrOutVar);

FMUBuilding* getBuildingsFMU(size_t iFMU);

void FMUBuildingFree(FMUBuilding* ptrBui);

#endif
