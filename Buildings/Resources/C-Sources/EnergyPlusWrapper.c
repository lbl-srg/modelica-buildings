#ifndef _Spawn_declared
#define _Spawn_declared

#include <ModelicaUtilities.h>
#include "EnergyPlusWrapper.h"

/* *********************************************************
   Wrapper functions that connect to the library which
   generates and loads the EnergyPlus fmu.

   Note that ModelicaMessage, ModelicaError,
   ModelicaFormatMessage and ModelicaFormatError are passed
   as function pointers. These functions are provided by,
   and may differ among, the Modelica environments.
   Using function pointers allows the library to load the
   correct version provided by the Modelica simulation
   environment that compiles the Modelica model.
/* ********************************************************* */
/* Thermal zone */
void* SpawnZoneAllocate(
  const char* modelicaNameBuilding,
  const char* modelicaNameThermalZone,
  const char* idfName,
  const char* weaName,
  const char* zoneName,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot,
  const int logLevel){

    return EnergyPlusZoneAllocate(
      modelicaNameBuilding,
      modelicaNameThermalZone,
      idfName,
      weaName,
      zoneName,
      usePrecompiledFMU,
      fmuName,
      buildingsLibraryRoot,
      logLevel,
      ModelicaMessage,
      ModelicaError,
      ModelicaFormatMessage,
      ModelicaFormatError);
  }

void SpawnZoneInstantiate(
    void* object,
    double startTime,
    double* AFlo,
    double* V,
    double* mSenFac){

      EnergyPlusZoneInstantiate(object, startTime, AFlo, V, mSenFac);
}

void SpawnZoneExchange(
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

void SpawnZoneFree(void* object){

    EnergyPlusZoneFree(object);
}

/* ********************************************************* */
/* Input variables */
void* SpawnInputVariableAllocate(
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
  const int logLevel){

    return EnergyPlusInputVariableAllocate(
      objectType,
      modelicaNameBuilding,
      modelicaNameInputVariable,
      idfName,
      weaName,
      name,
      componentType,
      controlType,
      unit,
      usePrecompiledFMU,
      fmuName,
      buildingsLibraryRoot,
      logLevel,
      ModelicaMessage,
      ModelicaError,
      ModelicaFormatMessage,
      ModelicaFormatError);
  }

void SpawnInputVariableInstantiate(void* object, double t0){

    EnergyPlusInputVariableInstantiate(object, t0);
  }

void SpawnInputVariableExchange(
  void* object,
  int initialCall,
  double u,
  double time,
  double* y){

    EnergyPlusInputVariableExchange(object, initialCall, u, time, y);
  }

void SpawnInputVariableFree(void* object){

    EnergyPlusInputVariableFree(object);
  }

/* ********************************************************* */
/* Output variables */
void* SpawnOutputVariableAllocate(
  const char* modelicaNameBuilding,
  const char* modelicaNameOutputVariable,
  const char* idfName,
  const char* weaName,
  const char* variableName,
  const char* componentKey,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot,
  const int logLevel,
  int printUnit){

    return EnergyPlusOutputVariableAllocate(
      modelicaNameBuilding,
      modelicaNameOutputVariable,
      idfName,
      weaName,
      variableName,
      componentKey,
      usePrecompiledFMU,
      fmuName,
      buildingsLibraryRoot,
      logLevel,
      printUnit,
      ModelicaMessage,
      ModelicaError,
      ModelicaFormatMessage,
      ModelicaFormatError);
  }

void SpawnOutputVariableInstantiate(void* object, double t0){
    EnergyPlusOutputVariableInstantiate(object, t0);
  }

void SpawnOutputVariableExchange(
  void* object,
  int initialCall,
  double directDependency,
  double time,
  double* y,
  double* tNext){

    EnergyPlusOutputVariableExchange(object, initialCall, directDependency, time, y, tNext);
  }

void SpawnOutputVariableFree(void* object){

    EnergyPlusOutputVariableFree(object);
  }

#endif
