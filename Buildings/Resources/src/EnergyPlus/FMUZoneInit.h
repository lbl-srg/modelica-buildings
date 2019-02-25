/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_FMUZoneInit_h
#define Buildings_FMUZoneInit_h

#include "FMUEnergyPlusStructure.h"

int zoneIsUnique(const struct FMUBuilding* fmuBld, const char* zoneName);

/* Create the structure and return a pointer to its address. */
void* FMUZoneInit(const char* idfName, const char* weaName, const char* iddName, const char* zoneName);

#endif
