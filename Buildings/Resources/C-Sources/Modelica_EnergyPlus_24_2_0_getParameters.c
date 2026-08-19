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
      /* Get all parameter values for current spawn object*/
      getParameters_Spawn_EnergyPlus_24_2_0(object, parOut);
      /* Add infiltration to zone level sensible heating load*/
      for (size_t i = 0; i < ptrSpaObj->parameters->n; i++) {
         if (ptrSpaObj->parameters->fmiNames[i] && 
             strstr(ptrSpaObj->parameters->fmiNames[i], "QHea_flow") &&
             !strstr(ptrSpaObj->parameters->fmiNames[i], "hvac_sizing_group")) {
            double TSetHea = 0;
            double TOutHea = 0;
            double V = 0;
            double m_inf_flow = 0;
            /* Get relevant parameter values for zone spawn object*/
            for (size_t j = 0; j < ptrSpaObj->parameters->n; j++) {
               if (ptrSpaObj->parameters->fmiNames[j]) {
                  ptrSpaObj->bui->SpawnFormatMessage("Object %s with parameter %s = %0.3f\n", ptrSpaObj->epName, ptrSpaObj->parameters->fmiNames[j], parOut[j]);
                  if (strstr(ptrSpaObj->parameters->fmiNames[j], "TSetHea")) TSetHea = parOut[j];
                  if (strstr(ptrSpaObj->parameters->fmiNames[j], "TOutHea")) TOutHea = parOut[j];
                  if (strstr(ptrSpaObj->parameters->fmiNames[j], "_V") && strstr(ptrSpaObj->parameters->fmiNames[j], ptrSpaObj->epName)) V = parOut[j];
               }
            }
            /* Calculate infiltration load and add to zone parameter */
            m_inf_flow = ptrSpaObj->ach_inf * (V*35.3147) / 60 / 2118.88 * 1.2;
            parOut[i] +=  m_inf_flow * 1006.0 * (TSetHea - TOutHea);
         }
      }
      /* Add infiltration to zone level sensible cooling load*/
      for (size_t i = 0; i < ptrSpaObj->parameters->n; i++) {
         if (ptrSpaObj->parameters->fmiNames[i] && 
             strstr(ptrSpaObj->parameters->fmiNames[i], "QCooSen_flow") &&
             !strstr(ptrSpaObj->parameters->fmiNames[i], "hvac_sizing_group")) {
            double TSetCoo = 0;
            double TOutCoo = 0;
            double V = 0;
            double m_inf_flow = 0;
            /* Get relevant parameter values for zone spawn object*/
            for (size_t j = 0; j < ptrSpaObj->parameters->n; j++) {
               if (ptrSpaObj->parameters->fmiNames[j]) {
                  if (strstr(ptrSpaObj->parameters->fmiNames[j], "TSetCoo")) TSetCoo = parOut[j];
                  if (strstr(ptrSpaObj->parameters->fmiNames[j], "TOutCoo")) TOutCoo = parOut[j];
                  if (strstr(ptrSpaObj->parameters->fmiNames[j], "_V") && strstr(ptrSpaObj->parameters->fmiNames[j], ptrSpaObj->epName)) V = parOut[j];
               }
            }
            /* Calculate infiltration load and add to zone parameter */
            m_inf_flow = ptrSpaObj->ach_inf * (V*35.3147) / 60 / 2118.88 * 1.2;
            parOut[i] += m_inf_flow * 1006.0 * (TOutCoo - TSetCoo);
         }
      }
      /* Add infiltration to zone level latent cooling load*/
      for (size_t i = 0; i < ptrSpaObj->parameters->n; i++) {
         if (ptrSpaObj->parameters->fmiNames[i] && 
             strstr(ptrSpaObj->parameters->fmiNames[i], "QCooLat_flow") &&
             !strstr(ptrSpaObj->parameters->fmiNames[i], "hvac_sizing_group")) {
            double XSetCoo = 0;
            double XOutCoo = 0;
            double V = 0;
            double m_inf_flow = 0;
            /* Get relevant parameter values for zone spawn object*/
            for (size_t j = 0; j < ptrSpaObj->parameters->n; j++) {
               if (ptrSpaObj->parameters->fmiNames[j]) {
                  if (strstr(ptrSpaObj->parameters->fmiNames[j], "XSetCoo")) XSetCoo = parOut[j];
                  if (strstr(ptrSpaObj->parameters->fmiNames[j], "XOutCoo")) XOutCoo = parOut[j];
                  if (strstr(ptrSpaObj->parameters->fmiNames[j], "_V") && strstr(ptrSpaObj->parameters->fmiNames[j], ptrSpaObj->epName)) V = parOut[j];
               }
            }
            /* Calculate infiltration load and add to zone parameter */
            m_inf_flow = ptrSpaObj->ach_inf * (V*35.3147) / 60 / 2118.88 * 1.2;
            parOut[i] += m_inf_flow * 2441000 * (XOutCoo - XSetCoo);
         }
      }
      /* Add infiltration to system level sensible heating load*/
      for (size_t i = 0; i < ptrSpaObj->parameters->n; i++) {
         if (ptrSpaObj->parameters->fmiNames[i] && 
             strstr(ptrSpaObj->parameters->fmiNames[i], "QHea_flow") &&
             strstr(ptrSpaObj->parameters->fmiNames[i], "hvac_sizing_group")) {
            double TSetHea = 0;
            double TOutHea = 0;
            double V = 0;
            double m_inf_flow = 0;
            /* Get relevant parameter values for system spawn object*/
            for (size_t j = 0; j < ptrSpaObj->parameters->n; j++) {
               if (ptrSpaObj->parameters->fmiNames[j]) {
                  ptrSpaObj->bui->SpawnFormatMessage("Object %s with parameter %s = %0.3f\n", ptrSpaObj->epName, ptrSpaObj->parameters->fmiNames[j], parOut[j]);
                  if (strstr(ptrSpaObj->parameters->fmiNames[j], "TOutHea")) TOutHea = parOut[j];
               }
            }
            double sumInfiltration = 0;
            FMUBuilding* bui = ptrSpaObj->bui;
            /* Get relevant parameter values for each zone spawn object associated with the system, 
            which are different from the current system object and need to be retrieved explicitly*/
            for (size_t k = 0; k < bui->nExcObj; k++) {
               SpawnObject* zone = (SpawnObject*)bui->exchange[k];
               int n = 0;
               for (size_t j = 0; j < zone->parameters->n; j++) {
                  n += 1;
               }
               double zoneParOut[n];
               getParameters_Spawn_EnergyPlus_24_2_0(zone, zoneParOut);
               if (zone->hvacZone && strstr(ptrSpaObj->epName, zone->hvacZone)) {
                  for (size_t j = 0; j < zone->parameters->n; j++) {
                     if (zone->parameters->fmiNames[j]) {
                        if (strstr(zone->parameters->fmiNames[j], "TSetHea")) TSetHea = zoneParOut[j];
                        if (strstr(zone->parameters->fmiNames[j], "_V")) V = zoneParOut[j];
                     }
                  }
                  /* Calculate infiltration load contributed from the zone and add it to the system sum */
                  m_inf_flow = zone->ach_inf * (V*35.3147) / 60 / 2118.88 * 1.2;
                  sumInfiltration += m_inf_flow * 1006.0 * (TSetHea - TOutHea);
                  bui->SpawnFormatMessage("Zone %s with V %0.3f part of hvacZone %s with epName %s, adding infiltration using TSetHea %0.3f and TOutHea %0.3f and ach_inf %0.3f\n", 
                  zone->epName, V, zone->hvacZone, ptrSpaObj->epName, TSetHea, TOutHea, zone->ach_inf );
               }
            }
            /* Add the system sum to the system parameter */
            parOut[i] += sumInfiltration;
         }
      }
      /* Add infiltration to system level sensible cooling load*/
      for (size_t i = 0; i < ptrSpaObj->parameters->n; i++) {
         if (ptrSpaObj->parameters->fmiNames[i] && 
             strstr(ptrSpaObj->parameters->fmiNames[i], "QCooSen_flow") &&
             strstr(ptrSpaObj->parameters->fmiNames[i], "hvac_sizing_group")) {
            double TSetCoo = 0;
            double TOutCoo = 0;
            double V = 0;
            double m_inf_flow = 0;
            /* Get relevant parameter values for system spawn object*/
            for (size_t j = 0; j < ptrSpaObj->parameters->n; j++) {
               if (ptrSpaObj->parameters->fmiNames[j]) {
                  ptrSpaObj->bui->SpawnFormatMessage("Object %s with parameter %s = %0.3f\n", ptrSpaObj->epName, ptrSpaObj->parameters->fmiNames[j], parOut[j]);
                  if (strstr(ptrSpaObj->parameters->fmiNames[j], "TOutCoo")) TOutCoo = parOut[j];
               }
            }
            double sumInfiltration = 0;
            FMUBuilding* bui = ptrSpaObj->bui;
            /* Get relevant parameter values for each zone spawn object associated with the system, 
            which are different from the current system object and need to be retrieved explicitly*/
            for (size_t k = 0; k < bui->nExcObj; k++) {
               SpawnObject* zone = (SpawnObject*)bui->exchange[k];
               int n = 0;
               for (size_t j = 0; j < zone->parameters->n; j++) {
                  n += 1;
               }
               double zoneParOut[n];
               getParameters_Spawn_EnergyPlus_24_2_0(zone, zoneParOut);
               if (zone->hvacZone && strstr(ptrSpaObj->epName, zone->hvacZone)) {
                  for (size_t j = 0; j < zone->parameters->n; j++) {
                     if (zone->parameters->fmiNames[j]) {
                        if (strstr(zone->parameters->fmiNames[j], "TSetCoo")) TSetCoo = zoneParOut[j];
                        if (strstr(zone->parameters->fmiNames[j], "_V")) V = zoneParOut[j];
                     }
                  }
                  /* Calculate infiltration load contributed from the zone and add it to the system sum */
                  m_inf_flow = zone->ach_inf * (V*35.3147) / 60 / 2118.88 * 1.2;
                  sumInfiltration += m_inf_flow * 1006.0 * (TOutCoo - TSetCoo);
                  bui->SpawnFormatMessage("Zone %s with V %0.3f part of hvacZone %s with epName %s, adding infiltration using TSetCoo %0.3f and TOutCoo %0.3f and ach_inf %0.3f\n", 
                  zone->epName, V, zone->hvacZone, ptrSpaObj->epName, TSetCoo, TOutCoo, zone->ach_inf );
               }
            }
            /* Add the system sum to the system parameter */
            parOut[i] += sumInfiltration;
         }
      }
      /* Add infiltration to system level latent cooling load*/
      for (size_t i = 0; i < ptrSpaObj->parameters->n; i++) {
         if (ptrSpaObj->parameters->fmiNames[i] && 
             strstr(ptrSpaObj->parameters->fmiNames[i], "QCooLat_flow") &&
             strstr(ptrSpaObj->parameters->fmiNames[i], "hvac_sizing_group")) {
            double XSetCoo = 0;
            double XOutCoo = 0;
            double V = 0;
            double m_inf_flow = 0;
            /* Get relevant parameter values for system spawn object*/
            for (size_t j = 0; j < ptrSpaObj->parameters->n; j++) {
               if (ptrSpaObj->parameters->fmiNames[j]) {
                  ptrSpaObj->bui->SpawnFormatMessage("Object %s with parameter %s = %0.3f\n", ptrSpaObj->epName, ptrSpaObj->parameters->fmiNames[j], parOut[j]);
                  if (strstr(ptrSpaObj->parameters->fmiNames[j], "XOutCoo")) XOutCoo = parOut[j];
               }
            }
            double sumInfiltration = 0;
            FMUBuilding* bui = ptrSpaObj->bui;
            /* Get relevant parameter values for each zone spawn object associated with the system, 
            which are different from the current system object and need to be retrieved explicitly*/
            for (size_t k = 0; k < bui->nExcObj; k++) {
               SpawnObject* zone = (SpawnObject*)bui->exchange[k];
               int n = 0;
               for (size_t j = 0; j < zone->parameters->n; j++) {
                  n += 1;
               }
               double zoneParOut[n];
               getParameters_Spawn_EnergyPlus_24_2_0(zone, zoneParOut);
               if (zone->hvacZone && strstr(ptrSpaObj->epName, zone->hvacZone)) {
                  for (size_t j = 0; j < zone->parameters->n; j++) {
                     if (zone->parameters->fmiNames[j]) {
                        if (strstr(zone->parameters->fmiNames[j], "XSetCoo")) XSetCoo = zoneParOut[j];
                        if (strstr(zone->parameters->fmiNames[j], "_V")) V = zoneParOut[j];
                     }
                  }
                  /* Calculate infiltration load contributed from the zone and add it to the system sum */
                  m_inf_flow = zone->ach_inf * (V*35.3147) / 60 / 2118.88 * 1.2;
                  sumInfiltration += m_inf_flow * 2441000 * (XOutCoo - XSetCoo);
                  bui->SpawnFormatMessage("Zone %s with V %0.3f part of hvacZone %s with epName %s, adding infiltration using XSetCoo %0.3f and XOutCoo %0.3f and ach_inf %0.3f\n", 
                  zone->epName, V, zone->hvacZone, ptrSpaObj->epName, XSetCoo, XOutCoo, zone->ach_inf );
               }
            }
            /* Add the system sum to the system parameter */
            parOut[i] += sumInfiltration;
         }
      }
}

#endif
