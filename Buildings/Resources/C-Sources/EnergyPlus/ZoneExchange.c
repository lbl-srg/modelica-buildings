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

void setVariables(FMUBuilding* bui, const char* modelicaNameThermalZone, fmi2ValueReference vr[],  fmi2Real values[], size_t n){
    fmi2_status_t status;
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage("fmi2_import_set_real: Setting real variables in EnergyPlus for zone %s, mode = %s.\n",
        modelicaNameThermalZone, fmuModeToString(bui->mode));
    status = fmi2_import_set_real(bui->fmu, vr, n, values);
    if (status != fmi2OK) {
      ModelicaFormatError("Failed to set variables for building in FMU for %s, zone %s\n",
      bui->modelicaNameBuilding,
      modelicaNameThermalZone);
    }
  }

void stopIfResultsAreNaN(
  FMUBuilding* bui,
  const char* modelicaNameThermalZone, fmi2ValueReference vr[], fmi2Real values[], size_t n){
    size_t i;
    fmi2_import_variable_t* fmiVar;
    char* varNam;
    size_t i_nan = -1;
    for(i=0; i < n; i++){
      if (isnan(values[i])){
        i_nan = i;
        break;
      }
    }
    if (i_nan != -1){
      for(i=0; i < n; i++){
        fmiVar = fmi2_import_get_variable_by_vr(bui->fmu, fmi2_base_type_real, vr[i]);
        varNam = fmi2_import_get_variable_name(fmiVar);
        if (isnan(values[i])){
          ModelicaFormatMessage("Received nan from EnergyPlus at time = %.2f:\n", bui->time);
        }
        ModelicaFormatMessage("  %s = %.2f\n", varNam, values[i]);
      }
      ModelicaFormatError("Terminating simulation because EnergyPlus returned nan for %s. See Modelica log file for details.",
        fmi2_import_get_variable_name(fmi2_import_get_variable_by_vr(bui->fmu, fmi2_base_type_real, vr[i_nan])));
    }
}

void getVariables(FMUBuilding* bui, const char* modelicaNameThermalZone, fmi2ValueReference vr[], fmi2Real values[], size_t n){
    fmi2_status_t status;
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage("fmi2_import_get_real: Getting real variables from EnergyPlus for zone %s, mode = %s.\n",
        modelicaNameThermalZone, fmuModeToString(bui->mode));
    status = fmi2_import_get_real(bui->fmu, vr, n, values);
    if (status != fmi2OK) {
      ModelicaFormatError("Failed to get variables for building in FMU for %s, zone %s\n",
      bui->modelicaNameBuilding,
      modelicaNameThermalZone);
    }
    stopIfResultsAreNaN(bui, modelicaNameThermalZone, vr, values, n);
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
  FMUBuilding* bui = zone->ptrBui;
  fmi2Real inputValues[ZONE_N_INP];
  fmi2Real outputValues[ZONE_N_OUT];

  fmi2Status status;

  const double dT = 0.01; /* Increment for derivative approximation */
  double QConSenPer_flow;

  /* Time need to be guarded against rounding error */
  /* *tNext = round((floor(time/3600.0)+1) * 3600.0); */

  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("Exchanging data with EnergyPlus: t = %.2f, initialCall = %d, mode = %s, zone = %s.\n",
      time, initialCall, fmuModeToString(bui->mode), zone->modelicaNameThermalZone);

  if (! zone->isInstantiated){
    /* This zone has not been initialized because the simulator removed the call to initialize().
    */
    ModelicaFormatError(
      "Error, zone %s should have been initialized. Contact support.",
      zone->modelicaNameThermalZone);
  }

  if (initialCall){
    zone->isInitialized = true; /* Set to true as it will be initialized right below */
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage("Initial call for zone %s with time = %.f\n", zone->modelicaNameThermalZone, time);
  }
  else
  {
    if (FMU_EP_VERBOSITY >= TIMESTEP)
      ModelicaFormatMessage("Did not enter initialization mode for zone %s., isInitialized = %d\n",
        zone->modelicaNameThermalZone, zone->isInitialized);
  }

  /* Get out of the initialization mode if this zone is no longer in the initial call
     but the FMU is still in initializationMode */
  if ((!initialCall) && bui->mode == initializationMode){
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage(
        "fmi2_import_exit_initialization_mode: Enter exit initialization mode of FMU in exchange() for zone = %s.\n",
        zone->modelicaNameThermalZone);
    status = fmi2_import_exit_initialization_mode(bui->fmu);
    if( status != fmi2_status_ok ){
      ModelicaFormatError("Failed to exit initialization mode for FMU for building %s and zone %s",
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
  inputValues[1] = X/(1.-X); /* Conversion from kg/kg_total_air to kg/kg_dry_air */
  inputValues[2] = mInlets_flow;
  inputValues[3] = TAveInlet;
  inputValues[4] = QGaiRad_flow;


  /* Forward difference for QConSen_flow */
  inputValues[0] = T - 273.15 + dT;

  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage(
      "Input to fmu for zone %s: TAir = %.2f; \t QGaiRad_flow = %.2f\n",
      zone->modelicaNameThermalZone,
      inputValues[0],
      inputValues[4]);

  setVariables(bui, zone->modelicaNameThermalZone, zone->inpValReferences, inputValues, ZONE_N_INP);
  getVariables(bui, zone->modelicaNameThermalZone, zone->outValReferences, outputValues, ZONE_N_OUT);
  QConSenPer_flow=outputValues[1];
  inputValues[0] = T - 273.15;
  setVariables(bui, zone->modelicaNameThermalZone, zone->inpValReferences, inputValues, ZONE_N_INP);
  getVariables(bui, zone->modelicaNameThermalZone, zone->outValReferences, outputValues, ZONE_N_OUT);

  *dQConSen_flow = (QConSenPer_flow-outputValues[1])/dT;

  /* Get next event time, unless FMU is in initialization mode */
  if (bui->mode == initializationMode){
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage(
        "Returning current time %.0f as tNext due to initializationMode for zone = %s\n",
        bui->time,
        zone->modelicaNameThermalZone);
    *tNext = bui->time; /* Return start time for next event time */
  }
  else{
    if (FMU_EP_VERBOSITY >= TIMESTEP)
      ModelicaFormatMessage("Calling do_event_iteration after setting inputs for zone = %s\n", zone->modelicaNameThermalZone);
    *tNext = do_event_iteration(bui, zone->modelicaNameThermalZone);
    /* After the event iteration, we must get the output. Otherwise, we get the
       discrete output before the time event, and not after.
       To test, run SingleZone.mo in EnergyPlus/src
    */
    getVariables(bui, zone->modelicaNameThermalZone, zone->outValReferences, outputValues, ZONE_N_OUT);
  }

  /* Assign output values, which are of the order below
     const char* outNames[] = {"TRad", "QConSen_flow", "QLat_flow", "QPeo_flow"};
  */
  /* Check for what seems to be an error, possibly due to unstable simulation */
  if (outputValues[0] > 100. || outputValues[0] < -50.)
    ModelicaFormatError(
      "Radiative temperature is %.2f degC in zone %s",
      outputValues[0],
      zone->modelicaNameThermalZone);

  *TRad = outputValues[0] + 273.15;
  *QConSen_flow = outputValues[1];
  *QLat_flow = outputValues[2];
  *QPeo_flow = outputValues[3];

  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("Returning from ZoneExchange with nextEventTime = %.2f, TRad_degC = %.2f, zone = %s, mode = %s, ptr=%p, nZon=%d \n",
    *tNext, outputValues[0], zone->modelicaNameThermalZone, fmuModeToString(bui->mode), zone, bui->nZon);

  return;
}
