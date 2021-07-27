#ifndef Spawn_declared
#define Spawn_declared

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
   ********************************************************* */

/* Custom implementation of ModelicaFormatMessage that prints to stdout
#define my_printf(...) MyModelicaFormatMessage(__VA_ARGS__)
void my_printf(const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    vprintf(fmt, args);
    va_end(args);
    fflush(stdout);
}
*/

void* ModelicaSpawnAllocate(
  const int objectType,
  double startTime,
  const char* modelicaNameBuilding,
  const char* modelicaNameThermalZone,
  const char* idfName,
  const char* weaName,
  double relativeSurfaceTolerance,
  const char* epName,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot,
  const int logLevel,
  const int printUnit,
  const char* jsonName,
  const char* jsonKeysValues,
  char** parOutNames,
  const size_t nParOut,
  char** parOutUnits,
  const size_t nParOutUni,
  char** inpNames,
  const size_t nInp,
  char** inpUnits,
  const size_t nInpUni,
  char** outNames,
  const size_t nOut,
  char** outUnits,
  const size_t nOutUni,
  const int* derivatives_structure,
  size_t k,
  size_t n,
  const double* derivatives_delta,
  const size_t nDer){

    return EnergyPlusSpawnAllocate(
      objectType,
      startTime,
      modelicaNameBuilding,
      modelicaNameThermalZone,
      idfName,
      weaName,
      relativeSurfaceTolerance,
      epName,
      usePrecompiledFMU,
      fmuName,
      buildingsLibraryRoot,
      logLevel,
      printUnit,
      jsonName,
      jsonKeysValues,
      (const char**)parOutNames,
      nParOut,
      (const char**)parOutUnits,
      nParOutUni,
      (const char**)inpNames,
      nInp,
      (const char**)inpUnits,
      nInpUni,
      (const char**)outNames,
      nOut,
      (const char**)outUnits,
      nOutUni,
      derivatives_structure,
      k, /* k = 2 in Modelica */
      n,
      derivatives_delta,
      nDer,
      ModelicaMessage,
      ModelicaError,
      ModelicaFormatMessage,
      ModelicaFormatError);
  }

void ModelicaSpawnInitialize(
    void* object,
    double isSynchronized,
    int *nObj){
      EnergyPlusSpawnInitialize(object, nObj);
}

void ModelicaSpawnGetParameters(
    void* object,
    double isSynchronized,
    double *parOut){
      EnergyPlusSpawnGetParameters(object, parOut);
}

void ModelicaSpawnExchange(
  void* object,
  int initialCall,
  const double* u,
  double dummy,
  double* y){

    EnergyPlusSpawnExchange(
      object,
      initialCall,
      u,
      y);
  }

void ModelicaSpawnFree(void* object){
    EnergyPlusSpawnObjectFree(object);
}

#endif
