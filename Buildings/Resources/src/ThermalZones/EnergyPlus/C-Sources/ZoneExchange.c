/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 * Thierry S. Nouidui, LBNL              4/16/2018
 */

#include "ZoneExchange.h"
#include "EnergyPlusFMU.h"

#include <stdlib.h>
#include <math.h>
#include <string.h>

bool allZonesAreInitialized(FMUBuilding* bui){
  void** zones = bui->zones;
  size_t i;
  FMUZone* zon;
  for(i = 0; i < bui->nZon; i++){
    zon = (FMUZone*)zones[i];
    if (! zon->isInitialized)
      return false;
  }
  return true;
}


/* Exchange data between Modelica zone and EnergyPlus zone
*/
void EnergyPlusZoneExchange(
  void* object,
  int initialCall,
  double T,
  double X,
  double mInlets_flow,
  double TAveInlet,
  double QGaiRad_flow,
  double AFlo,
  double time,
  double* TRad,
  double* QConSen_flow,
  double* dQConSen_flow,
  double* QLat_flow,
  double* QPeo_flow,
  double* tNext){

  FMUZone* zone = (FMUZone*) object;
  FMUBuilding* bui = zone->bui;

  fmi2Status status;

  const double dT = 0.01; /* Increment for derivative approximation */
  double QConSenPer_flow;

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  /* Time need to be guarded against rounding error */
  /* *tNext = round((floor(time/3600.0)+1) * 3600.0); */

  if (bui->logLevel >= TIMESTEP)
    SpawnFormatMessage("Exchanging data with EnergyPlus: t = %.2f, initialCall = %d, mode = %s, zone = %s.\n",
      time, initialCall, fmuModeToString(bui->mode), zone->modelicaNameThermalZone);

  if (! zone->isInstantiated){
    /* This zone has not been initialized because the simulator removed the call to initialize().
    */
    SpawnFormatError(
      "Error, zone %s should have been initialized. Contact support.",
      zone->modelicaNameThermalZone);
  }

  if (initialCall){
    zone->isInitialized = true; /* Set to true as it will be initialized right below */
    if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage("Initial call for zone %s with time = %.f\n", zone->modelicaNameThermalZone, time);
  }
  else
  {
    if (bui->logLevel >= TIMESTEP)
      SpawnFormatMessage("Did not enter initialization mode for zone %s., isInitialized = %d\n",
        zone->modelicaNameThermalZone, zone->isInitialized);
  }

  /* Get out of the initialization mode if this zone is no longer in the initial call
     but the FMU is still in initializationMode */
  if ((!initialCall) && bui->mode == initializationMode){
    if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage(
        "fmi2_import_exit_initialization_mode: Enter exit initialization mode of FMU in exchange() for zone = %s.\n",
        zone->modelicaNameThermalZone);
    status = fmi2_import_exit_initialization_mode(bui->fmu);
    if( status != fmi2_status_ok ){
      SpawnFormatError("Failed to exit initialization mode for FMU for building %s and zone %s",
        bui->modelicaNameBuilding, zone->modelicaNameThermalZone);
    }
    /* After exit_initialization_mode, the FMU is implicitly in event mode per the FMI standard */
    setFMUMode(bui, eventMode);
  }


  if ( (time - bui->time) > 0.001 ) {
    /* Real time advanced */
    advanceTime_completeIntegratorStep_enterEventMode(bui, zone->modelicaNameThermalZone, time);
  }

  /* Set input values, which are of the order below
     const char* inpNames[] = {"T", "X", "mInlets_flow", "TAveInlet", "QGaiRad_flow"};
  */
  zone->inputs->valsSI[1] = X/(1.-X); /* Conversion from kg/kg_total_air to kg/kg_dry_air */
  zone->inputs->valsSI[2] = mInlets_flow;
  zone->inputs->valsSI[3] = TAveInlet;
  zone->inputs->valsSI[4] = QGaiRad_flow;


  /* Forward difference for QConSen_flow */
  zone->inputs->valsSI[0] = T + dT;

  if (bui->logLevel >= TIMESTEP)
    SpawnFormatMessage(
      "Input to fmu for zone %s: TAir = %.2f; \t QGaiRad_flow = %.2f\n",
      zone->modelicaNameThermalZone,
      zone->inputs->valsSI[0],
      zone->inputs->valsSI[4]);

  setVariables(bui, zone->modelicaNameThermalZone, zone->inputs);
  getVariables(bui, zone->modelicaNameThermalZone, zone->outputs);
  QConSenPer_flow = zone->outputs->valsSI[1];
  zone->inputs->valsSI[0] = T;
  setVariables(bui, zone->modelicaNameThermalZone, zone->inputs);
  getVariables(bui, zone->modelicaNameThermalZone, zone->outputs);

  *dQConSen_flow = (QConSenPer_flow-zone->outputs->valsSI[1])/dT;

  /* Get next event time, unless FMU is in initialization mode */
  if (bui->mode == initializationMode){
    if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage(
        "Returning current time %.0f as tNext due to initializationMode for zone = %s\n",
        bui->time,
        zone->modelicaNameThermalZone);
    *tNext = bui->time; /* Return start time for next event time */
  }
  else{
    if (bui->logLevel >= TIMESTEP)
      SpawnFormatMessage("Calling do_event_iteration after setting inputs for zone = %s\n", zone->modelicaNameThermalZone);
    *tNext = do_event_iteration(bui, zone->modelicaNameThermalZone);
    /* After the event iteration, we must get the output. Otherwise, we get the
       discrete output before the time event, and not after.
       To test, run SingleZone.mo in EnergyPlus/src
    */
    getVariables(bui, zone->modelicaNameThermalZone, zone->outputs);
  }

  /* Assign output values, which are of the order below
     const char* outNames[] = {"TRad", "QConSen_flow", "QLat_flow", "QPeo_flow"};
  */
  /* Check for what seems to be an error, possibly due to unstable simulation */
  if (zone->outputs->valsSI[0] > 373.15 || zone->outputs->valsSI[0] < 173.15)
    SpawnFormatError(
      "Radiative temperature is %.2f K in zone %s",
      zone->outputs->valsSI[0],
      zone->modelicaNameThermalZone);

  *TRad         = zone->outputs->valsSI[0];
  *QConSen_flow = zone->outputs->valsSI[1];
  *QLat_flow    = zone->outputs->valsSI[2];
  *QPeo_flow    = zone->outputs->valsSI[3];

  if (bui->logLevel >= TIMESTEP)
    SpawnFormatMessage("Returning from EnergyPlusZoneExchange with nextEventTime = %.2f, TRad_degC = %.2f, zone = %s, mode = %s, ptr=%p, nZon=%d \n",
    *tNext, zone->outputs->valsEP[0], zone->modelicaNameThermalZone, fmuModeToString(bui->mode), zone, bui->nZon);

  return;
}
