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
    zone->isInitialized = true; /* Set to true as it will be initialized right below */
    writeFormatLog(2, "Initial call for zone %s with time = %.f", zone->name, time);
  }
  else
  {
    writeFormatLog(3, "Did not enter initialization mode for zone %s., isInitialized = %d",
      zone->name, zone->isInitialized);
  }

  /* Get out of the initialization mode if this zone is no longer in the initial call
     but the FMU is still in initializationMode */
  if (! initialCall && zone->ptrBui->mode == initializationMode){
    writeFormatLog(3, "fmi2_import_exit_initialization_mode: Enter exit initialization mode of FMU in exchange() for zone = %s.", zone->name);
    status = fmi2_import_exit_initialization_mode(zone->ptrBui->fmu);
    if( status != fmi2_status_ok ){
      ModelicaFormatError("Failed to exit initialization mode for FMU with name %s in zone %s",
        zone->ptrBui->fmuAbsPat, zone->name);
    }
    /* After exit_initialization_mode, the FMU is implicitely in event mode per the FMI standard */
    setFMUMode(zone->ptrBui, eventMode);
    /* Do an event iteration to get tNext */
    writeFormatLog(3, "Calling do_event_iteration after exiting initialization mode for zone = %s", zone->name);
    *tNext = do_event_iteration(zone);
  }


  if ( !initialCall && (time - zone->ptrBui->time) > 0.001 ) {
    /* This is not in the initial clause of the Modelica when, and
       it is the first zone that advances time for this building.
       Complete the integrator step in the FMU, and set the new time
    */
/*   writeFormatLog(3, "fmi2_import_completed_integrator_step: Calling completed integrator step with time = %.f, mode = %s, zone = %s",
     zone->ptrBui->time, fmuModeToString(zone->ptrBui->mode), zone->name);
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
*/
    writeFormatLog(2, "fmi2_import_set_time: Setting time in EnergyPlus to %.2f.", time);
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
  /* Get next event time, unless FMU is in initialization mode */
  if (zone->ptrBui->mode == initializationMode){
    writeFormatLog(3, "Returning current time %.0f as tNext due to initializationMode for zone = %s",
    zone->ptrBui->time, zone->name);
    *tNext = zone->ptrBui->time; /* Return start time for next event time */
  }
  else{
    writeFormatLog(3, "Calling do_event_iteration after setting inputs for zone = %s", zone->name);
    *tNext = do_event_iteration(zone);
  }


 /* After the event iteration, we must get the output. Otherwise, we get the
     discrete output before the time event, and not after.
     To test, run SingleZone.mo in EnergyPlus/src
  */
  getVariables(zone->ptrBui, zone->name, zone->outValReferences, outputValues, ZONE_N_OUT);

  /* Assign output values, which are of the order below
     const char* outNames[] = {"TRad", "QConSen_flow", "QLat_flow", "QPeo_flow"};
  */

  *TRad = outputValues[0] + 273.15;
  *QConSen_flow = outputValues[1];
  *QLat_flow = outputValues[2];
  *QPeo_flow = outputValues[3];
  *dQConSen_flow = 0*(QConSenPer_flow-*QConSen_flow)/dT;

  writeFormatLog(3, "Returning from ZoneExchange with nextEventTime = %.2f, QCon = %.2f, zone = %s, mode = %s",
    *tNext, *QConSen_flow, zone->name, fmuModeToString(zone->ptrBui->mode));
  return;
}

/* fixme, newDiscreteStateNeeded is a wrong criteria
   because we operate here on a room by room basis
   */
double do_event_iteration(FMUZone* zone){
  fmi2_event_info_t eventInfo;
  size_t i = 0;
  const size_t nMax = 50;
  fmi2Status status;
  double tNext;

  writeFormatLog(3, "Entered do_event_iteration for zone %s, mode = %s",
    zone->name, fmuModeToString(zone->ptrBui->mode));
  /* Enter event mode if the FMU is in Continuous time mode
     because fmi2NewDiscreteStates can only be called in event mode */
  if (zone->ptrBui->mode == continuousTimeMode){
    status = fmi2_import_enter_event_mode(zone->ptrBui->fmu);
    /* fixme if (status != fmi2_status_ok){
      ModelicaFormatError("Failed to enter event mode for FMU %s and zone %s.",
      zone->ptrBui->name, zone->name);
    }*/
    setFMUMode(zone->ptrBui, eventMode);
  }
  /* Make sure we are in event model (this is for debugging) */
  if (zone->ptrBui->mode != eventMode){
    ModelicaFormatError("Expected to be in event mode, but was in %s, for FMU %s and zone %s.",
      fmuModeToString(zone->ptrBui->mode), zone->ptrBui->name, zone->name);
  }
  eventInfo.newDiscreteStatesNeeded = fmi2_true;
  eventInfo.terminateSimulation     = fmi2_false;
  while (eventInfo.newDiscreteStatesNeeded && !eventInfo.terminateSimulation && i < nMax) {
    i++;
    writeFormatLog(3, "fmi2_import_new_discrete_states: Doing event iteration with i = %d, zone = %s", i, zone->name);
    status = fmi2_import_new_discrete_states(zone->ptrBui->fmu, &eventInfo);
  }
  if (eventInfo.terminateSimulation){
    ModelicaFormatError("FMU requested to terminate the simulation.");
  }
  if (i == nMax){
    ModelicaFormatError("Did not converge during event iteration.");
  }

  if (status != fmi2OK) {
    ModelicaFormatError("Failed during call to fmi2NewDiscreteStates for building FMU with name %s with status %s.",
    zone->ptrBui->name, fmi2_status_to_string(status));
  }
  if(eventInfo.terminateSimulation == fmi2True){
    ModelicaFormatError("EnergyPlus requested to terminate the simulation for building = %s, zone = %s, time = %f.",
    zone->ptrBui->name, zone->name, zone->ptrBui->time);
  }
  if(eventInfo.nextEventTimeDefined == fmi2False){
/*    if (initialCall){
      tNext = time;
    }
    else{
*/
    ModelicaFormatError("Expected EnergyPlus to set nextEventTimeDefined = true in FMU =%s, zone = %s, time = %f.",
    zone->ptrBui->name, zone->name, zone->ptrBui->time);
/*    }*/
  }
  else{
    tNext = eventInfo.nextEventTime;
    writeFormatLog(3, "Requested next event time at %.2f: %.2f;\t zone = %s\n",
      zone->ptrBui->time, tNext, zone->name);
    if (tNext <= zone->ptrBui->time + 1E-6){
      ModelicaFormatError("EnergyPlus requested at time = %f a next event time of %f for building = %s, zone = %s. Zero time steps are not supported. Check with support.",
      zone->ptrBui->time, tNext, zone->ptrBui->name, zone->name);
    }
  }

  /* if newDiscreteStatesNeeded is false, the FMU is in continuous time mode */
  setFMUMode(zone->ptrBui, continuousTimeMode);
  writeFormatLog(3, "Exiting do_event_iteration for zone %s, mode = %s with tNext = %.2f",
    zone->name, fmuModeToString(zone->ptrBui->mode), tNext);
  return tNext;
}
