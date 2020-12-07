/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_ZoneAllocate_h
#define Buildings_ZoneAllocate_h

#include "EnergyPlusTypes.h"
#include "EnergyPlusFMU.h"
#include "EnergyPlusUtil.h"

/* Create the structure and return a pointer to its address. */
LBNL_EnergyPlus_EXPORT void* EnergyPlusZoneAllocate(
  const char* modelicaNameBuilding,
  const char* modelicaNameThermalZone,
  const char* idfName,
  const char* weaName,
  const char* zoneName,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot,
  const int logLevel,
  void (*SpawnMessage)(const char *string),
  void (*SpawnError)(const char *string),
  void (*SpawnFormatMessage)(const char *string, ...),
  void (*SpawnFormatError)(const char *string, ...));

#endif
