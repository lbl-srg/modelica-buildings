/*
 * Modelica external function to intialize EnergyPlus.
 *
 * Michael Wetter, LBNL                  3/1/2018
 * Thierry S. Nouidui, LBNL              3/23/2018
 */

#include "SpawnFMU.h"
#include "SpawnObjectInstantiate.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>


/* This function is called for each Spawn object in the 'initial equation' section
*/
void initialize_Spawn_EnergyPlus_24_2_0(
    void* object,
    int *nObj){
  SpawnObject* ptrSpaObj = (SpawnObject*) object;
  FMUBuilding* bui = ptrSpaObj->bui;
  const char* modelicaName = ptrSpaObj->modelicaName;

  if (bui->logLevel >= MEDIUM){
    bui->SpawnFormatMessage("%.3f %s: Entered initialize_Spawn_EnergyPlus_24_2_0.\n", bui->time, modelicaName);
  }
  if (bui == NULL){
    bui->SpawnFormatError("Pointer bui is NULL in initialize_Spawn_EnergyPlus_24_2_0 for %s. For Dymola 2020x, make sure you set 'Hidden.AvoidDoubleComputation=true'. See Buildings.ThermalZones.EnergyPlus.UsersGuide.", modelicaName);
  }
  if (bui->fmu == NULL){
    /* EnergyPlus is not yet loaded.
       This section is only executed once if the 'initial equation' section is called multiple times.
       Moreover, it is called from the 'initial equation' section rather than than constructor
       because we only know how many exc and output variables there are after all constructors have been called.
       Hence we cannot construct the FMU in the constructor because we don't know which
       is the last constructor to be called.
    */

    /* Delete old files that were extracted from the FMU, if present */
    delete_extracted_fmu_files(bui);

    loadFMU_setupExperiment_enterInitializationMode(bui, bui->time);
  }

  if (! ptrSpaObj->valueReferenceIsSet){
    bui->SpawnFormatError("Value reference is not set for %s. For Dymola 2020x, make sure you set 'Hidden.AvoidDoubleComputation=true'. See Buildings.ThermalZones.EnergyPlus.UsersGuide.",
      modelicaName);
  }

  /* Get parameter values from EnergyPlus */
  if (bui->logLevel >= MEDIUM)
    bui->SpawnFormatMessage("%.3f %s: Getting parameters from EnergyPlus, bui at %p, Spawn object at %p, parameter at %p.\n", bui->time, ptrSpaObj->modelicaName,
      bui, ptrSpaObj, ptrSpaObj->parameters);
  getVariables(bui, modelicaName, ptrSpaObj->parameters);

  /* Assign nObj to synchronize all Spawn objects of this building */
  *nObj = (int)bui->nExcObj;

  /* Set flag to indicate that this Spawn object has been properly initialized */
  ptrSpaObj->isInstantiated = fmi2True;

  if (bui->logLevel >= MEDIUM)
    bui->SpawnFormatMessage("%.3f %s: Spawn object is instantiated.\n", bui->time, ptrSpaObj->modelicaName);
}


/* Returns the parameter values for this Spawn object
*/
void getParameters_Spawn_EnergyPlus_24_2_0(
    void* object,
    double *parOut){
  SpawnObject* ptrSpaObj = (SpawnObject*) object;
  FMUBuilding* bui = ptrSpaObj->bui;
  const char* modelicaName = ptrSpaObj->modelicaName;
  size_t i;

  if (bui->logLevel >= MEDIUM){
    bui->SpawnFormatMessage("%.3f %s: Entered getParameters_Spawn_EnergyPlus_24_2_0.\n", bui->time, modelicaName);
  }

  /* Assign the parameters for this object */
  for(i = 0; i < ptrSpaObj->parameters->n; i++){
    *parOut = ptrSpaObj->parameters->valsSI[i];
    parOut++; /* Increment to next element */
  }
  if (bui->logLevel >= MEDIUM)
    bui->SpawnFormatMessage("%.3f %s: Leaving getParameters_Spawn_EnergyPlus_24_2_0.\n", bui->time, ptrSpaObj->modelicaName);
}


/* Returns the parameter values for this Spawn object, and adds the
   infiltration loads to the zone and system level sizing parameters
*/
void getParametersWithInfiltration_Spawn_EnergyPlus_24_2_0(
    void* object,
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
              if (strstr(ptrSpaObj->parameters->fmiNames[j], "TSetHea")) TSetHea = parOut[j];
              if (strstr(ptrSpaObj->parameters->fmiNames[j], "TOutHea")) TOutHea = parOut[j];
              if (strstr(ptrSpaObj->parameters->fmiNames[j], "_V") && strstr(ptrSpaObj->parameters->fmiNames[j], ptrSpaObj->epName)) V = parOut[j];
           }
        }
        /* Calculate infiltration load and add to zone parameter */
        m_inf_flow = ptrSpaObj->airChaRatInf * (V*35.3147) * 60 / 2118.88 * ptrSpaObj->rhoAir;
        parOut[i] +=  m_inf_flow * ptrSpaObj->cpAir * (TSetHea - TOutHea);
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
        m_inf_flow = ptrSpaObj->airChaRatInf * (V*35.3147) * 60 / 2118.88 * ptrSpaObj->rhoAir;
        parOut[i] += m_inf_flow * ptrSpaObj->cpAir * (TOutCoo - TSetCoo);
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
        m_inf_flow = ptrSpaObj->airChaRatInf * (V*35.3147) * 60 / 2118.88 * ptrSpaObj->rhoAir;
        parOut[i] += m_inf_flow * ptrSpaObj->hfgWater * (XOutCoo - XSetCoo);
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
              m_inf_flow = zone->airChaRatInf * (V*35.3147) * 60 / 2118.88 * zone->rhoAir;
              sumInfiltration += m_inf_flow * zone->cpAir * (TSetHea - TOutHea);
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
              m_inf_flow = zone->airChaRatInf * (V*35.3147) * 60 / 2118.88 * zone->rhoAir;
              sumInfiltration += m_inf_flow * zone->cpAir * (TOutCoo - TSetCoo);
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
              m_inf_flow = zone->airChaRatInf * (V*35.3147) * 60 / 2118.88 * zone->rhoAir;
              sumInfiltration += m_inf_flow * zone->hfgWater * (XOutCoo - XSetCoo);
           }
        }
        /* Add the system sum to the system parameter */
        parOut[i] += sumInfiltration;
     }
  }
}
