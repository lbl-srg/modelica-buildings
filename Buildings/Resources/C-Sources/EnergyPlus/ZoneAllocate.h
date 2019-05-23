/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_ZoneAllocate_h
#define Buildings_ZoneAllocate_h

#include "EnergyPlusStructure.h"

int zoneIsUnique(const struct FMUBuilding* fmuBld, const char* zoneName);

/* Create the structure and return a pointer to its address. */
void* ZoneAllocate(
  const char* idfName,
  const char* weaName,
  const char* iddName,
  const char* zoneName,
  const char* modelicaInstanceName,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot,
  const int verbosity);

#endif
