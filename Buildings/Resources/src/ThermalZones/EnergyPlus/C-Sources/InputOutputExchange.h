/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_InputOutputExchange_h
#define Buildings_InputOutputExchange_h

#include "EnergyPlusTypes.h"
#include "EnergyPlusFMU.h"
#include "InputOutputInstantiate.h"
#include "FMI2/fmi2_import_capi.h"


LBNL_EnergyPlus_EXPORT void EnergyPlusInputOutputExchange(
  void* object,
  int initialCall,
  const double* u,
  double* y);

#endif
