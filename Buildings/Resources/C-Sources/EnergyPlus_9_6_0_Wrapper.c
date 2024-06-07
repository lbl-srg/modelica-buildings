#ifndef Spawn_declared
#define Spawn_declared

#include "EnergyPlus_9_6_0_Wrapper.h"

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

void* allocate_Modelica_EnergyPlus_9_6_0(
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
  const char* hvacZone,
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
  size_t k,
  size_t n,
  const double* derivatives_delta,
  const size_t nDer){

    return allocate_Spawn_EnergyPlus_9_6_0(
      objectType,
      startTime,
      modelicaNameBuilding,
      modelicaNameThermalZone,
      spawnExe,
      idfVersion,
      idfName,
      epwName,
      relativeSurfaceTolerance,
      epName,
      hvacZone,
      usePrecompiledFMU,
      fmuName,
      buildingsRootFileLocation,
      logLevel,
      printUnit,
      jsonName,
      jsonKeysValues,
      parOutNames,
      nParOut,
      parOutUnits,
      nParOutUni,
      inpNames,
      nInp,
      inpUnits,
      nInpUni,
      outNames,
      nOut,
      outUnits,
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

void initialize_Modelica_EnergyPlus_9_6_0(
    void* object,
    double isSynchronized,
    int *nObj){
      initialize_Spawn_EnergyPlus_9_6_0(object, nObj);
}

void getParameters_Modelica_EnergyPlus_9_6_0(
    void* object,
    double isSynchronized,
    double *parOut){
      getParameters_Spawn_EnergyPlus_9_6_0(object, parOut);
}

void exchange_Modelica_EnergyPlus_9_6_0(
  void* object,
  const double* u,
  double dummy,
  double* y){

    exchange_Spawn_EnergyPlus_9_6_0(
      object,
      0, /* Argument initialCall is hard-coded to false, and can be removed when binaries need to be recompiled. */
      u,
      y);
  }

void free_Modelica_EnergyPlus_9_6_0(void* object){
    free_Spawn_EnergyPlus_9_6_0(object);
}

#endif
