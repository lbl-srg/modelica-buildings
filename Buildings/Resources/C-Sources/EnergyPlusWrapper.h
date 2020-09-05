#ifndef EnergyPlusWrapper_h
#define EnergyPlusWrapper_h

#include <ModelicaUtilities.h>

extern void* ZoneAllocate(
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

extern void ZoneInstantiate(void* object, double t0, double* AFlo, double* V, double* mSenFac);

extern void ZoneExchange(
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

extern void ZoneFree(void* object);
#endif