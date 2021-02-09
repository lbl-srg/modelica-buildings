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
LBNL_EnergyPlus_EXPORT void* EnergyPlusExchangeAllocate(
  const char* modelicaNameBuilding,
  const char* modelicaName,
  const char* idfName,
  const char* weaName,
  const char* epName,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot,
  const int logLevel,
  const char* parOutNames[],
  const char* inpNames[],
  const char* outNames[],
  void (*SpawnMessage)(const char *string),
  void (*SpawnError)(const char *string),
  void (*SpawnFormatMessage)(const char *string, ...),
  void (*SpawnFormatError)(const char *string, ...));

#endif
