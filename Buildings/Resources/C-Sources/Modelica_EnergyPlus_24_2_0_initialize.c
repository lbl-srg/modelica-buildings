#ifndef Spawn_declared
#define Spawn_declared

#include "EnergyPlus_24_2_0_Wrapper.h"

/* *********************************************************
   Wrapper function that connects to the library which
   generates and loads the EnergyPlus fmu.
   *********************************************************
*/

void Modelica_EnergyPlus_24_2_0_initialize(
    void* object,
    double isSynchronized,
    int *nObj){
      initialize_Spawn_EnergyPlus_24_2_0(object, nObj);
}

#endif
