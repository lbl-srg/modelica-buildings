/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 * Thierry S. Nouidui, LBNL              4/16/2018
 */

#include "InputOutputExchange.h"
#include "EnergyPlusFMU.h"

#include <stdlib.h>
#include <math.h>
#include <string.h>

bool allZonesAreInitialized(FMUBuilding* bui){
  void** exc = bui->exchange;
  size_t i;
  FMUInOut* zon;
  for(i = 0; i < bui->nZon; i++){
    zon = (FMUInOut*)exc[i];
    if (! zon->isInitialized)
      return false;
  }
  return true;
}


/* Exchange data between Modelica and EnergyPlus during time stepping
*/
void EnergyPlusInputOutputExchange(
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

  FMUInOut* ptrInOut = (FMUInOut*) object;
  FMUBuilding* bui = ptrInOut->bui;

  fmi2Status status;

  const double dT = 0.01; /* Increment for derivative approximation */
  double QConSenPer_flow;

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  /* Time need to be guarded against rounding error */
  /* *tNext = round((floor(time/3600.0)+1) * 3600.0); */

  if (bui->logLevel >= TIMESTEP)
    SpawnFormatMessage("%.3f %s: Exchanging data with EnergyPlus: initialCall = %d, mode = %s, ptrInOut = %s.\n", bui->time, ptrInOut->modelicaName,
      initialCall, fmuModeToString(bui->mode), ptrInOut->modelicaName);

  if (! ptrInOut->isInstantiated){
    /* This ptrInOut has not been initialized because the simulator removed the call to initialize().
    */
    SpawnFormatError(
      "Error, ptrInOut %s should have been initialized. Contact support.",
      ptrInOut->modelicaName);
  }

  if (initialCall){
    ptrInOut->isInitialized = true; /* Set to true as it will be initialized right below */
    if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage("%.3f %s: Initial call for exchange.\n", bui->time, ptrInOut->modelicaName);
  }
  else
  {
    if (bui->logLevel >= TIMESTEP)
      SpawnFormatMessage("%.3f %s: Did not enter initialization mode for exchange. isInitialized = %d\n", bui->time, ptrInOut->modelicaName, ptrInOut->isInitialized);
  }

  /* Get out of the initialization mode if this ptrInOut is no longer in the initial call
     but the FMU is still in initializationMode */
  if ((!initialCall) && bui->mode == initializationMode){
    if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage("%.3f %s: Enter exit initialization mode of FMU in exchange().\n", bui->time, ptrInOut->modelicaName);
    status = fmi2_import_exit_initialization_mode(bui->fmu);
    if( status != (fmi2Status)fmi2_status_ok ){
      SpawnFormatError("Failed to exit initialization mode for FMU for building %s and exchange %s",
        bui->modelicaNameBuilding, ptrInOut->modelicaName);
    }
    /* After exit_initialization_mode, the FMU is implicitly in event mode per the FMI standard */
    setFMUMode(bui, eventMode);
  }


  if ( (time - bui->time) > 0.001 ) {
    /* Real time advanced */
    advanceTime_completeIntegratorStep_enterEventMode(bui, ptrInOut->modelicaName, time);
  }

  /* Set input values, which are of the order below
     const char* inpNames[] = {"T", "X", "mInlets_flow", "TAveInlet", "QGaiRad_flow"};
  */
  ptrInOut->inputs->valsSI[1] = X;
  ptrInOut->inputs->valsSI[2] = mInlets_flow;
  ptrInOut->inputs->valsSI[3] = TAveInlet;
  ptrInOut->inputs->valsSI[4] = QGaiRad_flow;


  /* Forward difference for QConSen_flow */
  ptrInOut->inputs->valsSI[0] = T + dT;

/*
  SpawnFormatMessage("*** This is a test output %s", "\n");
  SpawnFormatMessage("*** This is a test output, bui %p\n", bui);
  SpawnFormatMessage("*** This is a test output, bui time =  %.2f\n", bui->time);
  SpawnFormatMessage("*** This is a test output, ptrInOut %p\n", ptrInOut);
  SpawnFormatMessage("*** This is a test output, modelicaName %s\n", ptrInOut->modelicaName);
  SpawnFormatMessage("*** This is a test output, ptrInOut->inputs %p\n", ptrInOut->inputs);
  SpawnFormatMessage("*** This is a test output,  TAir =  %.2f\n", ptrInOut->inputs->valsSI[0]);
  SpawnFormatMessage("*** This is a test output,  QGaiRad_flow =  %.2f\n", ptrInOut->inputs->valsSI[4]);
  SpawnFormatMessage("*** This is a test output,  bui->logLevel =  %d\n", bui->logLevel);
*/

  if (bui->logLevel >= TIMESTEP)
    SpawnFormatMessage("%.3f %s: Input to fmu for ptrInOut: TAir = %.2f; \t QGaiRad_flow = %.2f\n",
      bui->time,
      ptrInOut->modelicaName,
      ptrInOut->inputs->valsSI[0],
      ptrInOut->inputs->valsSI[4]);

  setVariables(bui, ptrInOut->modelicaName, ptrInOut->inputs);
  getVariables(bui, ptrInOut->modelicaName, ptrInOut->outputs);
  QConSenPer_flow = ptrInOut->outputs->valsSI[1];
  ptrInOut->inputs->valsSI[0] = T;
  setVariables(bui, ptrInOut->modelicaName, ptrInOut->inputs);
  getVariables(bui, ptrInOut->modelicaName, ptrInOut->outputs);

  *dQConSen_flow = (QConSenPer_flow - ptrInOut->outputs->valsSI[1])/dT;
  /* Get next event time, unless FMU is in initialization mode */
  if (bui->mode == initializationMode){
    if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage("%.3f %s: Returning current time as tNext due to initializationMode for exchange.\n",
         bui->time, ptrInOut->modelicaName);
    *tNext = bui->time; /* Return start time for next event time */
  }
  else{
    if (bui->logLevel >= TIMESTEP)
      SpawnFormatMessage("%.3f %s: Calling do_event_iteration after setting inputs for exchange.\n", bui->time, ptrInOut->modelicaName);
    *tNext = do_event_iteration(bui, ptrInOut->modelicaName);
    /* After the event iteration, we must get the output. Otherwise, we get the
       discrete output before the time event, and not after.
       To test, run SingleZone.mo in EnergyPlus/src
    */
    getVariables(bui, ptrInOut->modelicaName, ptrInOut->outputs);
  }

  /* Assign output values, which are of the order below
     const char* outNames[] = {"TRad", "QConSen_flow", "QLat_flow", "QPeo_flow"};
  */
  /* Check for what seems to be an error, possibly due to unstable simulation */
  if (ptrInOut->outputs->valsSI[0] > 373.15 || ptrInOut->outputs->valsSI[0] < 173.15)
    SpawnFormatError("%.3f %s: Radiative temperature is %.2f K in exchange",
      bui->time,
      ptrInOut->modelicaName,
      ptrInOut->outputs->valsSI[0]);

  *TRad         = ptrInOut->outputs->valsSI[0];
  *QConSen_flow = ptrInOut->outputs->valsSI[1];
  *QLat_flow    = ptrInOut->outputs->valsSI[2];
  *QPeo_flow    = ptrInOut->outputs->valsSI[3];

  if (bui->logLevel >= TIMESTEP)
    SpawnFormatMessage("%.3f %s: Returning from EnergyPlusInputOutputExchange with nextEventTime = %.2f, TRad_degC = %.2f, mode = %s, nZon=%d \n",
      bui->time, ptrInOut->modelicaName, *tNext, ptrInOut->outputs->valsEP[0], fmuModeToString(bui->mode), bui->nZon);

  return;
}
