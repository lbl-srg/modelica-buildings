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
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage("fmi2_import_set_real: Setting real variables in EnergyPlus for zone %s, mode = %s.\n",
        zoneName, fmuModeToString(bui->mode));
    status = fmi2_import_set_real(bui->fmu, vr, n, values);
    if (status != fmi2OK) {
      ModelicaFormatError("Failed to set variables for building FMU with name %s\n", bui->name);
    }
  }

void getVariables(FMUBuilding* bui, const char* zoneName, fmi2ValueReference vr[], fmi2Real values[], size_t n){
    fmi2_status_t status;
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage("fmi2_import_get_real: Getting real variables from EnergyPlus for zone %s, mode = %s.\n",
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


/* Set the new time in the FMU, complete the integrator step and set the FMU into event mode.
*/
void advanceTime_completeIntegratorStep_enterEventMode(FMUZone* zone, double time){
  fmi2Status status;
  fmi2Boolean enterEventMode;
  fmi2Boolean terminateSimulation;

  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("fmi2_import_enter_continuous_time_mode: ************ Setting EnergyPlus to continuous time mode at t = %.2f\n", time);
  status = fmi2_import_enter_continuous_time_mode(zone->ptrBui->fmu);
  if ( status != fmi2OK ) {
    ModelicaFormatError("Failed to set time in building FMU with name %s, returned status is %s.",
      zone->ptrBui->name, fmi2_status_to_string(status));
  }
  setFMUMode(zone->ptrBui, continuousTimeMode);

  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("fmi2_import_set_time: Setting time in EnergyPlus to %.2f.\n", time);
  zone->ptrBui->time = time;
  status = fmi2_import_set_time(zone->ptrBui->fmu, time);
  if ( status != fmi2OK ) {
    ModelicaFormatError("Failed to set time in building FMU with name %s, returned status is %s.",
      zone->ptrBui->name, fmi2_status_to_string(status));
  }

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("fmi2_import_completed_integrator_step: Calling completed integrator step at t = %.2f\n", time);
  status = fmi2_import_completed_integrator_step(zone->ptrBui->fmu, fmi2_true, &enterEventMode, &terminateSimulation);
  if ( status != fmi2OK ) {
    ModelicaFormatError("Failed to complete integrator step in building FMU with name %s, returned status is %s.",
    zone->ptrBui->name, fmi2_status_to_string(status));
  }
  if (enterEventMode){
    ModelicaFormatError(
      "Unexpected value for enterEventMode in ZoneExchange at t = %.2f for FMU with name %s and zone %s",
      time, zone->ptrBui->name, zone->name);
  }
  if (terminateSimulation){
    ModelicaFormatError(
      "FMU requested to terminate simulation at t = %.2f for FMU with name %s and zone %s",
      time, zone->ptrBui->name, zone->name);
  }
  /* Enter the FMU into event mode */
  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("fmi2_import_enter_event_mode: Enter event mode in ZoneExchange for FMU %s\n", zone->ptrBui->name);
  status = fmi2_import_enter_event_mode(zone->ptrBui->fmu);
  if (status != fmi2_status_ok){
    ModelicaFormatError("Failed to enter event mode in ZoneExchange for FMU %s and zone %s, returned status is %s.",
    zone->ptrBui->name, zone->name, fmi2_status_to_string(status));
  }
  setFMUMode(zone->ptrBui, eventMode);

  return;
}

/* Exchange data between Modelica zone and EnergyPlus zone
*/
void ZoneExchange(
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
  fmi2Real inputValues[ZONE_N_INP];
  fmi2Real outputValues[ZONE_N_OUT];

  fmi2Status status;

  const double dT = 0.01; /* Increment for derivative approximation */
  double QConSenPer_flow;

  /* Time need to be guarded against rounding error */
  /* *tNext = round((floor(time/3600.0)+1) * 3600.0); */

  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("Exchanging data with EnergyPlus: t = %.2f, initialCall = %d, mode = %s, zone = %s.\n",
      time, initialCall, fmuModeToString(zone->ptrBui->mode), zone->name);

  if (! zone->isInstantiated){
    /* This zone has not been initialized because the simulator removed the call to initialize().
    */
    ModelicaFormatError("Error, zone %s should have been initialized. Contact support.", zone->name);
  }

  if (initialCall){
    zone->isInitialized = true; /* Set to true as it will be initialized right below */
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage("Initial call for zone %s with time = %.f\n", zone->name, time);
  }
  else
  {
    if (FMU_EP_VERBOSITY >= TIMESTEP)
      ModelicaFormatMessage("Did not enter initialization mode for zone %s., isInitialized = %d\n",
        zone->name, zone->isInitialized);
  }

  /* Get out of the initialization mode if this zone is no longer in the initial call
     but the FMU is still in initializationMode */
  if ((!initialCall) && zone->ptrBui->mode == initializationMode){
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage("fmi2_import_exit_initialization_mode: Enter exit initialization mode of FMU in exchange() for zone = %s.\n", zone->name);
    status = fmi2_import_exit_initialization_mode(zone->ptrBui->fmu);
    if( status != fmi2_status_ok ){
      ModelicaFormatError("Failed to exit initialization mode for FMU with name %s in zone %s",
        zone->ptrBui->fmuAbsPat, zone->name);
    }
    /* After exit_initialization_mode, the FMU is implicitly in event mode per the FMI standard */
    setFMUMode(zone->ptrBui, eventMode);
  }


  if ( (time - zone->ptrBui->time) > 0.001 ) {
    /* Real time advanced */
    advanceTime_completeIntegratorStep_enterEventMode(zone, time);
  }

  /* Set input values, which are of the order below
     const char* inpNames[] = {"T", "X", "mInlets_flow", "TAveInlet", "QGaiRad_flow"};
  */
  inputValues[1] = X/(1.-X); /* Conversion from kg/kg_total_air to kg/kg_dry_air */
  inputValues[2] = mInlets_flow;
  inputValues[3] = TAveInlet;
  inputValues[4] = QGaiRad_flow;


  /* Forward difference for QConSen_flow */
  inputValues[0] = T - 273.15 + dT;

  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("Input to fmu: TAir = %.2f; \t QGaiRad_flow = %.2f\n", inputValues[0], inputValues[4]);
/*
  if (zone->ptrBui->mode == eventMode){
  status = fmi2_import_enter_continuous_time_mode(zone->ptrBui->fmu);
  if ( status != fmi2OK ) {
    ModelicaFormatError("Failed to set continuous time mode in building FMU with name %s, returned status is %s.",
      zone->ptrBui->name, fmi2_status_to_string(status));
  }
  setFMUMode(zone->ptrBui, continuousTimeMode);
  }
*/
  setVariables(zone->ptrBui, zone->name, zone->inpValReferences, inputValues, ZONE_N_INP);
  getVariables(zone->ptrBui, zone->name, zone->outValReferences, outputValues, ZONE_N_OUT);
  QConSenPer_flow=outputValues[1];
  inputValues[0] = T - 273.15;
  setVariables(zone->ptrBui, zone->name, zone->inpValReferences, inputValues, ZONE_N_INP);
  getVariables(zone->ptrBui, zone->name, zone->outValReferences, outputValues, ZONE_N_OUT);
/*
  if (zone->ptrBui->mode == continuousTimeMode){
  status = fmi2_import_enter_event_mode(zone->ptrBui->fmu);
  if ( status != fmi2OK ) {
    ModelicaFormatError("Failed to set event mode in building FMU with name %s, returned status is %s.",
      zone->ptrBui->name, fmi2_status_to_string(status));
  }
  setFMUMode(zone->ptrBui, eventMode);
  }
*/
  *dQConSen_flow = (QConSenPer_flow-outputValues[1])/dT;

    /*
  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("After time step: TRad = %.2f; \t QCon = %.2f;\t QLat = %.2f\n", *TRad, *QConSen_flow,
    *QLat_flow);
*/
  /* Get next event time, unless FMU is in initialization mode */
  if (zone->ptrBui->mode == initializationMode){
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage("Returning current time %.0f as tNext due to initializationMode for zone = %s\n",
    zone->ptrBui->time, zone->name);
    *tNext = zone->ptrBui->time; /* Return start time for next event time */
  }
  else{
    if (FMU_EP_VERBOSITY >= TIMESTEP)
      ModelicaFormatMessage("Calling do_event_iteration after setting inputs for zone = %s\n", zone->name);
    *tNext = do_event_iteration(zone);
    /* After the event iteration, we must get the output. Otherwise, we get the
       discrete output before the time event, and not after.
       To test, run SingleZone.mo in EnergyPlus/src
    */
    getVariables(zone->ptrBui, zone->name, zone->outValReferences, outputValues, ZONE_N_OUT);
  }

  /* Assign output values, which are of the order below
     const char* outNames[] = {"TRad", "QConSen_flow", "QLat_flow", "QPeo_flow"};
  */
  /* Check for what seems to be an error, possibly due to unstable simulation */
  if (outputValues[0] > 100. || outputValues[0] < -50.)
    ModelicaFormatError("Radiative temperature is %.2f degC in zone %s", outputValues[0], zone->modelicaInstanceName);

  *TRad = outputValues[0] + 273.15;
  *QConSen_flow = outputValues[1];
  *QLat_flow = outputValues[2];
  *QPeo_flow = outputValues[3];

  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("Returning from ZoneExchange with nextEventTime = %.2f, TRad_degC = %.2f, zone = %s, mode = %s, ptr=%p, nZon=%d \n",
    *tNext, outputValues[0], zone->name, fmuModeToString(zone->ptrBui->mode), zone, zone->ptrBui->nZon);

  return;
}

/* Do the event iteration
   */
double do_event_iteration(FMUZone* zone){
  fmi2_event_info_t eventInfo;
  size_t i = 0;
  const size_t nMax = 50;
  fmi2Status status;
  double tNext;

  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("Entered do_event_iteration for zone %s, mode = %s\n",
      zone->name, fmuModeToString(zone->ptrBui->mode));
  /* Enter event mode if the FMU is in Continuous time mode
     because fmi2NewDiscreteStates can only be called in event mode */
  if (zone->ptrBui->mode == continuousTimeMode){
    ModelicaFormatError("********* FMU is in unexpected mode in do_event_iteration at t=%.2f, zone = %s, mode = %s. Contact support.",
      zone->ptrBui->time, zone->name, fmuModeToString(zone->ptrBui->mode));
    /*
      if (FMU_EP_VERBOSITY >= TIMESTEP)
      ModelicaFormatMessage("fmi2_import_enter_event_mode: Enter event mode in do_event_iteration for FMU %s\n", zone->ptrBui->name);
    status = fmi2_import_enter_event_mode(zone->ptrBui->fmu);
    if (status != fmi2_status_ok){
      ModelicaFormatError("Failed to enter event mode in do_event_iteration for FMU %s and zone %s, returned status is %s.",
      zone->ptrBui->name, zone->name, fmi2_status_to_string(status));
    }
    setFMUMode(zone->ptrBui, eventMode);
    */
  }
/* *****************************************************************************
  if (zone->ptrBui->mode != initializationMode){
    if (FMU_EP_VERBOSITY >= TIMESTEP)
      ModelicaFormatMessage("fmi2_import_enter_event_mode: Enter event mode in do_event_iteration for FMU %s\n", zone->ptrBui->name);
    status = fmi2_import_enter_event_mode(zone->ptrBui->fmu);
    if (status != fmi2_status_ok){
      ModelicaFormatError("Failed to enter event mode in do_event_iteration for FMU %s and zone %s, returned status is %s.",
      zone->ptrBui->name, zone->name, fmi2_status_to_string(status));
    }
    setFMUMode(zone->ptrBui, eventMode);
  }
  ***************************************************************************** */


  /* Make sure we are in event mode (this is for debugging) */
  if (zone->ptrBui->mode != eventMode){
    ModelicaFormatError("Expected to be in event mode, but was in %s, for FMU %s and zone %s.",
      fmuModeToString(zone->ptrBui->mode), zone->ptrBui->name, zone->name);
  }
  eventInfo.newDiscreteStatesNeeded = fmi2_true;
  eventInfo.terminateSimulation     = fmi2_false;
  while (eventInfo.newDiscreteStatesNeeded && !eventInfo.terminateSimulation && i < nMax) {
    i++;
    if (FMU_EP_VERBOSITY >= TIMESTEP)
      ModelicaFormatMessage("fmi2_import_new_discrete_states: Doing event iteration with i = %d, zone = %s\n", i, zone->name);
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
    ModelicaFormatError("Expected EnergyPlus to set nextEventTimeDefined = true in FMU =%s, zone = %s, time = %f.",
    zone->ptrBui->name, zone->name, zone->ptrBui->time);
  }
  else{
    tNext = eventInfo.nextEventTime;
    if (FMU_EP_VERBOSITY >= TIMESTEP)
      ModelicaFormatMessage("Requested next event time at %.2f: %.2f;\t zone = %s\n",
        zone->ptrBui->time, tNext, zone->name);
    if (tNext <= zone->ptrBui->time + 1E-6){
      ModelicaFormatError("EnergyPlus requested at time = %f a next event time of %f for building = %s, zone = %s. Zero time steps are not supported. Check with support.",
      zone->ptrBui->time, tNext, zone->ptrBui->name, zone->name);
    }
  }

  /* THIS WAS WRONG: if newDiscreteStatesNeeded is false, the FMU is in continuous time mode
  setFMUMode(zone->ptrBui, continuousTimeMode); */
  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("Exiting do_event_iteration for zone %s, mode = %s with tNext = %.2f\n",
      zone->name, fmuModeToString(zone->ptrBui->mode), tNext);
  return tNext;
}
