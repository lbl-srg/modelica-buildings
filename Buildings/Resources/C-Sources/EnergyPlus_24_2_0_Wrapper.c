#ifndef Spawn_declared
#define Spawn_declared

#include "EnergyPlus_24_2_0_Wrapper.h"
#include <stdlib.h>

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

void* allocate_Modelica_EnergyPlus_24_2_0(
  const int objectType,
  double startTime,
  const char* modelicaNameBuilding,
  const char* modelicaNameThermalZone,
  const char* spawnExe,
  const char* idfVersion,
  const char* idfName,
  const char* epwName,
  int runPeriod_dayOfWeekForStartDay,
  int runPeriod_applyWeekEndHolidayRule,
  int runPeriod_use_weatherFileDaylightSavingPeriod,
  int runPeriod_use_weatherFileHolidaysAndSpecialDays,
  int runPeriod_use_weatherFileRainIndicators,
  int runPeriod_use_weatherFileSnowIndicators,
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
  size_t k,
  size_t n,
  const double* derivatives_delta,
  const size_t nDer){

    runPeriod runPer;
    runPer.dayOfWeekForStartDay = runPeriod_dayOfWeekForStartDay;
    runPer.applyWeekEndHolidayRule = runPeriod_applyWeekEndHolidayRule;
    runPer.use_weatherFileDaylightSavingPeriod = runPeriod_use_weatherFileDaylightSavingPeriod;
    runPer.use_weatherFileHolidaysAndSpecialDays = runPeriod_use_weatherFileHolidaysAndSpecialDays;
    runPer.use_weatherFileRainIndicators = runPeriod_use_weatherFileRainIndicators;
    runPer.use_weatherFileSnowIndicators = runPeriod_use_weatherFileSnowIndicators;

    return allocate_Spawn_EnergyPlus_24_2_0(
      objectType,
      startTime,
      modelicaNameBuilding,
      modelicaNameThermalZone,
      spawnExe,
      idfVersion,
      idfName,
      epwName,
      &runPer,
      relativeSurfaceTolerance,
      epName,
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

void initialize_Modelica_EnergyPlus_24_2_0(
    void* object,
    double isSynchronized,
    int *nObj){
      initialize_Spawn_EnergyPlus_24_2_0(object, nObj);
}

void getParameters_Modelica_EnergyPlus_24_2_0(
    void* object,
    double isSynchronized,
    double *parOut){
      getParameters_Spawn_EnergyPlus_24_2_0(object, parOut);
}

void exchange_Modelica_EnergyPlus_24_2_0(
  void* object,
  const double* u,
  double dummy,
  double* y){

    exchange_Spawn_EnergyPlus_24_2_0(
      object,
      0, /* Argument initialCall is hard-coded to false, and can be removed when binaries need to be recompiled. */
      u,
      y);
  }

/* Track freed objects to prevent double-free when OpenModelica calls the
   destructor multiple times for the same external object instance.
   OpenModelica (like Dymola 2019FD01) may call the constructor multiple times
   for the same Modelica object and return the same pointer each time.
   In that case, the destructor is also called multiple times for that pointer.
   We use a simple list to remember which pointers have already been freed. */
static void** EnergyPlus_24_2_0_freed_ptrs = NULL;
static size_t EnergyPlus_24_2_0_freed_count = 0;
static size_t EnergyPlus_24_2_0_freed_capacity = 0;

void free_Modelica_EnergyPlus_24_2_0(void* object){
    size_t i;

    if (object == NULL) return;

    /* Check if this pointer was already freed */
    for (i = 0; i < EnergyPlus_24_2_0_freed_count; i++){
      if (EnergyPlus_24_2_0_freed_ptrs[i] == object){
        /* Already freed - skip to prevent double-free crash */
        return;
      }
    }

    /* Record this pointer as freed */
    if (EnergyPlus_24_2_0_freed_count >= EnergyPlus_24_2_0_freed_capacity){
      void** tmp;
      EnergyPlus_24_2_0_freed_capacity = (EnergyPlus_24_2_0_freed_capacity == 0)
        ? 16 : EnergyPlus_24_2_0_freed_capacity * 2;
      tmp = (void**)realloc(EnergyPlus_24_2_0_freed_ptrs,
        EnergyPlus_24_2_0_freed_capacity * sizeof(void*));
      if (tmp != NULL){
        EnergyPlus_24_2_0_freed_ptrs = tmp;
      }
      else{
        /* realloc failed: proceed without tracking (minor risk of double-free) */
        EnergyPlus_24_2_0_freed_capacity = EnergyPlus_24_2_0_freed_count;
        free_Spawn_EnergyPlus_24_2_0(object);
        return;
      }
    }
    EnergyPlus_24_2_0_freed_ptrs[EnergyPlus_24_2_0_freed_count++] = object;

    free_Spawn_EnergyPlus_24_2_0(object);
}

#endif