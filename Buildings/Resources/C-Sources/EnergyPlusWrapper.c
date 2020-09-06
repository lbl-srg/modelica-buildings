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

      ZoneInstantiate(object, startTime, AFlo, V, mSenFac);
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

    ZoneExchange(
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

/* ********************************************************* */
/* Input variables */
void* EnergyPlusInputVariableAllocate(
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
  const int verbosity){

    return InputVariableAllocate(
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
      verbosity,
      ModelicaMessage,
      ModelicaError,
      ModelicaFormatMessage,
      ModelicaFormatError);
  }

void EnergyPlusInputVariableInstantiate(void* object, double t0){

    InputVariableInstantiate(object, t0);
  }

void EnergyPlusInputVariableExchange(
  void* object,
  int initialCall,
  double u,
  double time,
  double* y){

    InputVariableExchange(object, initialCall, u, time, y);
  }

void EnergyPlusInputVariableFree(void* object){

    InputVariableFree(object);
  }

/* ********************************************************* */
/* Output variables */
void* EnergyPlusOutputVariableAllocate(
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
  int printUnit){

    return OutputVariableAllocate(
      modelicaNameBuilding,
      modelicaNameOutputVariable,
      idfName,
      weaName,
      variableName,
      componentKey,
      usePrecompiledFMU,
      fmuName,
      buildingsLibraryRoot,
      verbosity,
      printUnit,
      ModelicaMessage,
      ModelicaError,
      ModelicaFormatMessage,
      ModelicaFormatError);
  }

void EnergyPlusOutputVariableInstantiate(void* object, double t0){
    OutputVariableInstantiate(object, t0);
  }

void EnergyPlusOutputVariableExchange(
  void* object,
  int initialCall,
  double directDependency,
  double time,
  double* y,
  double* tNext){

    OutputVariableExchange(object, initialCall, directDependency, time, y, tNext);
  }

void EnergyPlusOutputVariableFree(void* object){

    OutputVariableFree(object);
  }

#endif
