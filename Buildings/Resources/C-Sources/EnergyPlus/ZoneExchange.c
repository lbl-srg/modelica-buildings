/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 * Thierry S. Nouidui, LBNL              4/16/2018
 */

#include "ZoneExchange.h"
#include "EnergyPlusStructure.h"

#include <stdlib.h>
#include <math.h>
#include <string.h>

void setVariables(FMUBuilding* bui, const char* zoneName, fmi2ValueReference vr[],  fmi2Real values[], size_t n){
    fmi2_status_t status;
    writeFormatLog(3, "fmi2_import_set_real: Setting real variables in EnergyPlus for zone %s, mode = %s.",
      zoneName, fmuModeToString(bui->mode));
    status = fmi2_import_set_real(bui->fmu, vr, n, values);
    if (status != fmi2OK) {
      ModelicaFormatError("Failed to set variables for building FMU with name %s\n", bui->name);
    }
  }

void getVariables(FMUBuilding* bui, const char* zoneName, fmi2ValueReference vr[], fmi2Real values[], size_t n){
    fmi2_status_t status;
    writeFormatLog(3, "fmi2_import_get_real: Getting real variables from EnergyPlus for zone %s, mode = %s.",
      zoneName, fmuModeToString(bui->mode));
    status = fmi2_import_get_real(bui->fmu, vr, n, values);
    if (status != fmi2OK) {
      ModelicaFormatError("Failed to get variables for building FMU with name %s\n", bui->name);
    }
  }

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

void ZoneExchange(
  void* object,
  int initialCall,
  double T,
  double X,
  double mInlets_flow,
  double TAveInlet,
  double QGaiRad_flow,
  double time,
  double* TRad,
  double* QConSen_flow,
  double* dQConSen_flow,
  double* QLat_flow,
  double* QPeo_flow,
  double* tNext){

  FMUZone* zone = (FMUZone*) object;
  fmi2Real inputValues[ZONE_N_INP];
  fmi2Real outputValues[ZONE_N_OUT];
  fmi2_event_info_t eventInfo;
  fmi2Boolean callEventUpdate;
  fmi2Boolean terminateSimulation;
  fmi2Status status;

  const double dT = 0.01; /* Increment for derivative approximation */
  double QConSenPer_flow;

  double AFlo;
  double V;
  double mSenFac;

  /* Time need to be guarded against rounding error */
  /* *tNext = round((floor(time/3600.0)+1) * 3600.0); */

  writeFormatLog(3, "Exchanging data with EnergyPlus: t = %.2f, initialCall = %d, mode = %s, zone = %s.",
    time, initialCall, fmuModeToString(zone->ptrBui->mode), zone->name);

  if (! zone->isInstantiated){
    /* This zone has not been initialized because the simulator optimized away the call to initialize().
       Hence, we intialize it now.
    */
    ModelicaError("fixme: Error, we should not be here.");
    ZoneInstantiate(object, time, &AFlo, &V, &mSenFac);
  }

  if (initialCall){
    if ( ! zone->ptrBui->mode == initializationMode){
      /* Enter initialization mode for initial call */
      writeFormatLog(3, "fmi2_import_enter_initialization_mode: Enter initialization mode of FMU with T = %.f for zone = %s.", T, zone->name);
      status = fmi2_import_enter_initialization_mode(zone->ptrBui->fmu);
      if( status != fmi2_status_ok ){
        ModelicaFormatError("Failed to enter initialization mode for FMU with name %s for zone %s.",
          zone->ptrBui->fmuAbsPat, zone->name);
      }
      setFMUMode(zone->ptrBui, initializationMode);
    }
    zone->isInitialized = true; /* Set to true as it will be initialized right below */
  }
  else
  {
    writeFormatLog(3, "Did not enter initialization mode for zone %s., isInitialized = %d",
      zone->name, zone->isInitialized);
  }


  if ( !initialCall && (time - zone->ptrBui->time) > 0.001 ) {
    /* This is not in the initial clause of the Modelica when, and
       it is the first zone that advances time for this building.
       Complete the integrator step in the FMU, and set the new time
    */
   writeFormatLog(3, "fmi2_import_completed_integrator_step: Calling completed integrator step with time = %.f in zone = %s",
     zone->ptrBui->time, zone->name);
    status = fmi2_import_completed_integrator_step(zone->ptrBui->fmu, fmi2_true,
      &callEventUpdate,
      &terminateSimulation);

    if ( status != fmi2OK ) {
      ModelicaFormatError("Failed to complete integrator step in building FMU with name %s.",
      zone->ptrBui->name);
    }
    if (callEventUpdate){
      ModelicaFormatError(
        "Unexpected value for callEventUpdate in ZoneExchange at t = %.2f for FMU with name %s",
        time, zone->ptrBui->name);
    }
    if (terminateSimulation){
      ModelicaFormatError(
        "Unexpected value for terminateSimulation in ZoneExchange at t = %.2f for FMU with name %s",
        time, zone->ptrBui->name);
    }

    writeFormatLog(3, "fmi2_import_set_time: Setting time in EnergyPlus to %.2f.", time);
    zone->ptrBui->time = time;
    status = fmi2_import_set_time(zone->ptrBui->fmu, time);
    if ( status != fmi2OK ) {
      ModelicaFormatError("Failed to set time in building FMU with name %s.",
      zone->ptrBui->name);
    }
  } /* end of else if */


  /* Set input values, which are of the order below
     const char* inpNames[] = {"T", "X", "mInlets_flow", "TAveInlet", "QGaiRad_flow"};
  */
  inputValues[1] = X/(1.-X); /* Conversion from kg/kg_total_air to kg/kg_dry_air */
  inputValues[2] = mInlets_flow;
  inputValues[3] = TAveInlet;
  inputValues[4] = QGaiRad_flow;
  if ( strcmp(zone->name, "Core_ZN") ){
    inputValues[5] = time+0.1; /* this is xTest */
  }
  else
  {
    inputValues[5] = time+0.2; /* this is xTest */
  }


  /* Forward difference for QConSen_flow */
  inputValues[0] = T - 273.15 + dT;

  writeFormatLog(3, "Input to fmu: TAir = %.2f; \t QGaiRad_flow = %.2f",
    inputValues[0], inputValues[4]);

  setVariables(zone->ptrBui, zone->name, zone->inpValReferences, inputValues, ZONE_N_INP);
  getVariables(zone->ptrBui, zone->name, zone->outValReferences, outputValues, ZONE_N_OUT);
  QConSenPer_flow=outputValues[1];
  inputValues[0] = T - 273.15;
  setVariables(zone->ptrBui, zone->name, zone->inpValReferences, inputValues, ZONE_N_INP);
  getVariables(zone->ptrBui, zone->name, zone->outValReferences, outputValues, ZONE_N_OUT);

/*  writeFormatLog(3, "After time step: TRad = %.2f; \t QCon = %.2f;\t QLat = %.2f", *TRad, *QConSen_flow,
    *QLat_flow);
*/
  /* Get next event time */
  writeFormatLog(3, "Calling do_event_iteration for zone = %s", zone->name);
  status = do_event_iteration(zone, &eventInfo);

 /* status = fmi2_import_new_discrete_states(zone->ptrBui->fmu, &eventInfo); */
  if (status != fmi2OK) {
    ModelicaFormatError("Failed during call to fmi2NewDiscreteStates for building FMU with name %s with status %s.",
    zone->ptrBui->name, fmi2_status_to_string(status));
  }
  if(eventInfo.terminateSimulation == fmi2True){
    ModelicaFormatError("EnergyPlus requested to terminate the simulation for building = %s, zone = %s, time = %f.",
    zone->ptrBui->name, zone->name, time);
  }
  if(eventInfo.nextEventTimeDefined == fmi2False){
    if (initialCall){
      *tNext = time;
    }
    else{
      ModelicaFormatError("Expected EnergyPlus to set nextEventTimeDefined = true in FMU =%s, zone = %s, time = %f.",
        zone->ptrBui->name, zone->name, time);
    }
  }
  else{
    *tNext = eventInfo.nextEventTime;
    writeFormatLog(3, "Requested next event time at %.2f: %.2f;\t zone = %s\n", time, *tNext, zone->name);
    if (*tNext <= time + 1E-6){
      ModelicaFormatError("EnergyPlus requested at time = %f a next event time of %f for building = %s, zone = %s. Zero time steps are not supported. Check with support.",
      time, *tNext, zone->ptrBui->name, zone->name);
    }
  }

 /* After the event iteration, we must get the output. Otherwise, we get the
     discrete output before the time event, and not after.
     To test, run SingleZone.mo in EnergyPlus/src
  */
  getVariables(zone->ptrBui, zone->name, zone->outValReferences, outputValues, ZONE_N_OUT);

  writeFormatLog(3, "*** In Exchange, time = %.2f;\t xTest = %.2f;\t yTest = %.2f;\t initialCall = %d;\t mode = %s;\t zone = %s",
    time, inputValues[5], outputValues[4], initialCall, fmuModeToString(zone->ptrBui->mode), zone->name);

  /* Get out of the initialization mode if this zone is in the initial call, and if it was the last zone */
  if (initialCall && allZonesAreInitialized(zone->ptrBui)){
    writeFormatLog(3, "fmi2_import_exit_initialization_mode: Enter exit initialization mode of FMU in exchange() for zone = %s.", zone->name);
    status = fmi2_import_exit_initialization_mode(zone->ptrBui->fmu);
    if( status != fmi2_status_ok ){
      ModelicaFormatError("Failed to exit initialization mode for FMU with name %s in zone %s",
        zone->ptrBui->fmuAbsPat, zone->name);
    }
    /* After exit_initialization_mode, the FMU is implicitely in event mode per the FMI standard */
    setFMUMode(zone->ptrBui, eventMode);
  }

  /* Assign output values, which are of the order below
     const char* outNames[] = {"TRad", "QConSen_flow", "QLat_flow", "QPeo_flow"};
  */

  *TRad = outputValues[0] + 273.15;
  *QConSen_flow = outputValues[1];
  *QLat_flow = outputValues[2];
  *QPeo_flow = outputValues[3];
  *dQConSen_flow = 0*(QConSenPer_flow-*QConSen_flow)/dT;

  writeFormatLog(3, "Returning from ZoneExchange with nextEventTime = %.2f. in mode %d", *tNext, zone->ptrBui->mode);
  return;
}

/* fixme, newDiscreteStateNeeded is a wrong criteria
   because we operate here on a room by room basis
   */
fmi2Status do_event_iteration(FMUZone* zone, fmi2_event_info_t *eventInfo){
  size_t i = 0;
  const size_t nMax = 50;
  fmi2Status status;

  eventInfo->newDiscreteStatesNeeded = fmi2_true;
  eventInfo->terminateSimulation     = fmi2_false;
  while (eventInfo->newDiscreteStatesNeeded && !eventInfo->terminateSimulation && i < nMax) {
    i++;
    writeFormatLog(3, "fmi2_import_new_discrete_states: Doing event iteration with i = %d, zone = %s", i, zone->name);
    status = fmi2_import_new_discrete_states(zone->ptrBui->fmu, eventInfo);
  }
  if (eventInfo->terminateSimulation){
    ModelicaFormatError("FMU requested to terminate the simulation.");
  }
  if (i == nMax){
    ModelicaFormatError("Did not converge during event iteration.");
  }
  return status;
}
