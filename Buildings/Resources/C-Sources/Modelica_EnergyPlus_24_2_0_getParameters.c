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
      /* Add infiltration to zone level sensible heating load*/
      for (size_t i = 0; i < ptrSpaObj->parameters->n; i++) {
         if (ptrSpaObj->parameters->fmiNames[i] && strstr(ptrSpaObj->parameters->fmiNames[i], "QHea_flow")) {
            double TSetHea = 0;
            double TOutHea = 0;
            for (size_t j = 0; j < ptrSpaObj->parameters->n; j++) {
               if (ptrSpaObj->parameters->fmiNames[j]) {
                  if (strstr(ptrSpaObj->parameters->fmiNames[j], "TSetHea")) TSetHea = parOut[j];
                  if (strstr(ptrSpaObj->parameters->fmiNames[j], "TOutHea")) TOutHea = parOut[j];
               }
            }
            parOut[i] += ptrSpaObj->m_inf_flow * 1006.0 * (TSetHea - TOutHea);
         }
      }
      /* Add infiltration to zone level sensible cooling load*/
      for (size_t i = 0; i < ptrSpaObj->parameters->n; i++) {
         if (ptrSpaObj->parameters->fmiNames[i] && strstr(ptrSpaObj->parameters->fmiNames[i], "QCooSen_flow")) {
            double TSetCoo = 0;
            double TOutCoo = 0;
            for (size_t j = 0; j < ptrSpaObj->parameters->n; j++) {
               if (ptrSpaObj->parameters->fmiNames[j]) {
                  if (strstr(ptrSpaObj->parameters->fmiNames[j], "TSetCoo")) TSetCoo = parOut[j];
                  if (strstr(ptrSpaObj->parameters->fmiNames[j], "TOutCoo")) TOutCoo = parOut[j];
               }
            }
            parOut[i] += ptrSpaObj->m_inf_flow * 1006.0 * (TOutCoo - TSetCoo);
         }
      }
      /* Add infiltration to zone level latent cooling load*/
      for (size_t i = 0; i < ptrSpaObj->parameters->n; i++) {
         if (ptrSpaObj->parameters->fmiNames[i] && strstr(ptrSpaObj->parameters->fmiNames[i], "QCooLat_flow")) {
            double XSetCoo = 0;
            double XOutCoo = 0;
            for (size_t j = 0; j < ptrSpaObj->parameters->n; j++) {
               if (ptrSpaObj->parameters->fmiNames[j]) {
                  if (strstr(ptrSpaObj->parameters->fmiNames[j], "XSetCoo")) XSetCoo = parOut[j];
                  if (strstr(ptrSpaObj->parameters->fmiNames[j], "XOutCoo")) XOutCoo = parOut[j];
               }
            }
            parOut[i] += ptrSpaObj->m_inf_flow * 2441000 * (XOutCoo - XSetCoo);
         }
      }
}

#endif
