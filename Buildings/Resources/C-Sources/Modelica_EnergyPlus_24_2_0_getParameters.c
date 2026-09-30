#ifndef Modelica_EnergyPlus_24_2_0_getParameters_declared
#define Modelica_EnergyPlus_24_2_0_getParameters_declared

#include "Modelica_EnergyPlus_24_2_0_getParameters.h"

/* *********************************************************
   Wrapper function that connects to the library which
   generates and loads the EnergyPlus fmu.
   *********************************************************
*/

void Modelica_EnergyPlus_24_2_0_getParameters(
    void* object,
    double isSynchronized,
    double *parOut){
      /* Get all parameter values for current spawn object,
         including the infiltration loads */
      getParametersWithInfiltration_Spawn_EnergyPlus_24_2_0(object, parOut);
}

#endif
