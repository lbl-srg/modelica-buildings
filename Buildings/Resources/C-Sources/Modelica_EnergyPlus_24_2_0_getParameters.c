#ifndef Spawn_declared
#define Spawn_declared

#include "EnergyPlus_24_2_0_Wrapper.h"

/* *********************************************************
   Wrapper function that connects to the library which
   generates and loads the EnergyPlus fmu.
   *********************************************************
*/

void Modelica_EnergyPlus_24_2_0_getParameters(
    void* object,
    double isSynchronized,
    double *parOut){
      getParameters_Spawn_EnergyPlus_24_2_0(object, parOut);
}

#endif
