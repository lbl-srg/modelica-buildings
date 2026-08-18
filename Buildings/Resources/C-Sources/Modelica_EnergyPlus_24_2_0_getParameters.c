#ifndef Modelica_EnergyPlus_24_2_0_getParameters_declared
#define Modelica_EnergyPlus_24_2_0_getParameters_declared

#include "Modelica_EnergyPlus_24_2_0_getParameters.h"
#include "../src/ThermalZones/EnergyPlus_24_2_0/C-Sources/SpawnTypes.h"
#include <string.h>

/* *********************************************************
   Wrapper function that connects to the library which
   generates and loads the EnergyPlus fmu.
   *********************************************************
*/

void Modelica_EnergyPlus_24_2_0_getParameters(
    void* object,
    double isSynchronized,
    double *parOut){
      SpawnObject* ptrSpaObj = (SpawnObject*) object;
      getParameters_Spawn_EnergyPlus_24_2_0(object, parOut);
      for (size_t i = 0; i < ptrSpaObj->parameters->n; i++) {
         ptrSpaObj->bui->SpawnFormatMessage("Testing string: %s.\n", ptrSpaObj->parameters->fmiNames[i]);
         if (ptrSpaObj->parameters->fmiNames[i] && strstr(ptrSpaObj->parameters->fmiNames[i], "QHea_flow")) {
            ptrSpaObj->bui->SpawnFormatMessage("Found matching string: %s.  Will add %0.3f to gotten value of %0.3f\n", ptrSpaObj->parameters->fmiNames[i], ptrSpaObj->m_inf_flow, parOut[i]);
            parOut[i] += ptrSpaObj->m_inf_flow;
         }
      }
}

#endif
