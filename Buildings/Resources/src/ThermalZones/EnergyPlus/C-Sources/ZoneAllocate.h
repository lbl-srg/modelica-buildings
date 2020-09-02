/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_ZoneAllocate_h
#define Buildings_ZoneAllocate_h

#include "EnergyPlusFMU.h"
#include "EnergyPlusUtil.h"

#ifdef __cplusplus
extern "C" {
#endif
#ifdef _MSC_VER
#ifdef EXTERNAL_FUNCTION_EXPORT
# define LBNL_EnergyPlus_EXPORT __declspec( dllexport )
#else
# define LBNL_EnergyPlus_EXPORT __declspec( dllimport )
#endif
#elif __GNUC__ >= 4
/* In gnuc, all symbols are by default exported. It is still often useful,
to not export all symbols but only the needed ones */
# define LBNL_EnergyPlus_EXPORT __attribute__ ((visibility("default")))
#else
# define LBNL_EnergyPlus_EXPORT
#endif

/* Create the structure and return a pointer to its address. */
void* ZoneAllocate(
  const char* modelicaNameBuilding,
  const char* modelicaNameThermalZone,
  const char* idfName,
  const char* weaName,
  const char* zoneName,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot,
  const int verbosity);

#endif
