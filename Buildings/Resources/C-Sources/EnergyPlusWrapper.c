#ifndef _Spawn_declared
#define _Spawn_declared

#include <ModelicaUtilities.h>
#include "EnergyPlusWrapper.h"

/* Zone interface */
void* EnergyPlusZoneAllocate(
  const char* modelicaNameBuilding,
  const char* modelicaNameThermalZone,
  const char* idfName,
  const char* weaName,
  const char* zoneName,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot,
  const int verbosity){
    return ZoneAllocate(
      modelicaNameBuilding,
      modelicaNameThermalZone,
      idfName,
      weaName,
      zoneName,
      usePrecompiledFMU,
      fmuName,
      buildingsLibraryRoot,
      verbosity,
      ModelicaMessage,
      ModelicaError,
      ModelicaFormatMessage,
      ModelicaFormatError);
  }

void EnergyPlusZoneInstantiate(
    void* object,
    double startTime,
    double* AFlo,
    double* V,
    double* mSenFac){

      ZoneInstantiate(
        object,
        startTime,
        AFlo,
        V,
        mSenFac);
}

void EnergyPlusZoneExchange(
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
  double* tNext){

    EnergyPlusZoneExchange(
      object,
      initialCall,
      T,
      X,
      mInlets_flow,
      TAveInlet,
      QGaiRad_flow,
      AFlo,
      time,
      TRad,
      QConSen_flow,
      dQConSen_flow,
      QLat_flow,
      QPeo_flow,
      tNext);
  }

void EnergyPlusZoneFree(void* object){
    ZoneFree(object);
}

#endif