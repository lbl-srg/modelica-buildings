#ifndef EnergyPlus_9_6_0_Wrapper_h
#define EnergyPlus_9_6_0_Wrapper_h

#include <stdint.h>


/* Check for 64 bit */
/* Windows */
#if _WIN32 || _WIN64
#if _WIN64
#define ENVIRONMENT64
#else
#define ENVIRONMENT32
#endif
#endif

/* gcc */
#if __GNUC__
#if __x86_64__ || __ppc64__
#define ENVIRONMENT64
#else
#define ENVIRONMENT32
#endif
#endif

#ifndef ENVIRONMENT64
#error Modelica Spawn coupling is only supported for Windows and Linux 64 bit. Your operating system is not 64 bit.
#endif

#include "ModelicaUtilities.h"

/* ********************************************************* */
/* Thermal zone */
extern void* allocate_Spawn_EnergyPlus_9_6_0(
  const int objectType,
  double startTime,
  const char* modelicaNameBuilding,
  const char* modelicaNameThermalZone,
  const char* spawnExe,
  const char* idfVersion,
  const char* idfName,
  const char* epwName,
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

extern void initialize_Spawn_EnergyPlus_9_6_0(void* object, int *nObj);

extern void getParameters_Spawn_EnergyPlus_9_6_0(void* object, double *parOut);

extern void exchange_Spawn_EnergyPlus_9_6_0(
  void* object,
  int initialCall,
  const double* u,
  double* y);

extern void free_Spawn_EnergyPlus_9_6_0(void* object);

#endif
