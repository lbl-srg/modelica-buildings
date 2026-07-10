#ifndef Spawn_declared
#define Spawn_declared

#include "EnergyPlus_24_2_0_Wrapper.h"

/* *********************************************************
   Wrapper function that connects to the library which
   generates and loads the EnergyPlus fmu.
   *********************************************************
*/

void Modelica_EnergyPlus_24_2_0_exchange(
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

#endif
