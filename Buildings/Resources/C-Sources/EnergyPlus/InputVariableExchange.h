/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  5/22/2020
 */
#ifndef Buildings_InputVariableExchange_h
#define Buildings_InputVariableExchange_h

#include "EnergyPlusFMU.h"
#include "InputVariableInstantiate.h"
#include "FMI2/fmi2_import_capi.h"


void InputVariableExchange(
  void* object,
  int initialCall,
  double u,
  double time,
  double* y);

#endif
