/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_OutputVariableExchange_h
#define Buildings_OutputVariableExchange_h

#include "EnergyPlusFMU.h"
#include "OutputVariableInstantiate.h"
#include "FMI2/fmi2_import_capi.h"


void OutputVariableExchange(
  void* object,
  int initialCall,
  double time,
  double* y,
  double* tNext);

#endif
