#ifndef Modelica_EnergyPlus_24_2_0_allocate_declared
#define Modelica_EnergyPlus_24_2_0_allocate_declared

#include "Modelica_EnergyPlus_24_2_0_allocate.h"
#include <stdlib.h>

/* *********************************************************
   Wrapper function that connects to the library which
   generates and loads the EnergyPlus fmu.
   *********************************************************
*/

void* Modelica_EnergyPlus_24_2_0_allocate(
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

#endif
