/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_SpawnObjectExchange_h
#define Buildings_SpawnObjectExchange_h

#include "SpawnTypes.h"
#include "SpawnFMU.h"
#include "SpawnObjectInstantiate.h"
#include "FMI2/fmi2_import_capi.h"


LBNL_Spawn_EXPORT void exchange_Spawn_EnergyPlus_24_2_0(
  void* object,
  int initialCall,
  const double* u,
  double* y);

#endif
