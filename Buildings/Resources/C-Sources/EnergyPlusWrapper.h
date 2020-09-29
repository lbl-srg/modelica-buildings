#ifndef EnergyPlusWrapper_h
#define EnergyPlusWrapper_h

#include <ModelicaUtilities.h>

#ifdef _WIN32
#error "*** Spawn is not yet supported on Windows."
#endif

/* ********************************************************* */
/* Thermal zone */
extern void* EnergyPlusZoneAllocate(
  const char* modelicaNameBuilding,
  const char* modelicaNameThermalZone,
  const char* idfName,
  const char* weaName,
  const char* zoneName,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot,
  const int verbosity,
  void (*SpawnMessage)(const char *string),
  void (*SpawnError)(const char *string),
  void (*SpawnFormatMessage)(const char *string, ...),
  void (*SpawnFormatError)(const char *string, ...));

extern void EnergyPlusZoneInstantiate(void* object, double t0, double* AFlo, double* V, double* mSenFac);

extern void EnergyPlusZoneExchange(
  void* object,
  int initialCall,
  double T,
  double X,
  double mInlets_flow,
  double TAveInlet,
  double QGaiRad_flow,
  double AFlo,
  double time,
  double* TRad,
  double* QConSen_flow,
  double* dQConSen_flow,
  double* QLat_flow,
  double* QPeo_flow,
  double* tNext);

extern void EnergyPlusZoneFree(void* object);

/* ********************************************************* */
/* Input variables */
extern void* EnergyPlusInputVariableAllocate(
  const int objectType,
  const char* modelicaNameBuilding,
  const char* modelicaNameInputVariable,
  const char* idfName,
  const char* weaName,
  const char* name,
  const char* componentType,
  const char* controlType,
  const char* unit,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot,
  const int verbosity,
  void (*SpawnMessage)(const char *string),
  void (*SpawnError)(const char *string),
  void (*SpawnFormatMessage)(const char *string, ...),
  void (*SpawnFormatError)(const char *string, ...));

extern void EnergyPlusInputVariableInstantiate(void* object, double t0);

extern void EnergyPlusInputVariableExchange(
  void* object,
  int initialCall,
  double u,
  double time,
  double* y);

extern void EnergyPlusInputVariableFree(void* object);

/* ********************************************************* */
/* Output variables */
extern void* EnergyPlusOutputVariableAllocate(
  const char* modelicaNameBuilding,
  const char* modelicaNameOutputVariable,
  const char* idfName,
  const char* weaName,
  const char* variableName,
  const char* componentKey,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot,
  const int verbosity,
  int printUnit,
  void (*SpawnMessage)(const char *string),
  void (*SpawnError)(const char *string),
  void (*SpawnFormatMessage)(const char *string, ...),
  void (*SpawnFormatError)(const char *string, ...));

extern void EnergyPlusOutputVariableInstantiate(void* object, double t0);

extern void EnergyPlusOutputVariableExchange(
  void* object,
  int initialCall,
  double directDependency,
  double time,
  double* y,
  double* tNext);

extern void EnergyPlusOutputVariableFree(void* object);

#endif