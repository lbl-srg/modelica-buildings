/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 * Thierry S. Nouidui, LBNL              4/16/2018
 */

#include "SpawnObjectExchange.h"
#include "SpawnFMU.h"

#include <stdlib.h>
#include <math.h>
#include <string.h>

bool areAllSpawnObjectsInitialized(FMUBuilding* bui){
  void** exc = bui->exchange;
  size_t i;
  SpawnObject* ptrSpaObj;
  for(i = 0; i < bui->nExcObj; i++){
    ptrSpaObj = (SpawnObject*)exc[i];
    if (! ptrSpaObj->isInitialized)
      return false;
  }
  return true;
}


/* Exchange data between Modelica and EnergyPlus during time stepping
*/
void EnergyPlusSpawnExchange(
  void* object,
  int initialCall,
  const double* u,
  double* y){

  SpawnObject* ptrSpaObj = (SpawnObject*) object;
  FMUBuilding* bui = ptrSpaObj->bui;

  fmi2Status status;

  size_t iU;
  size_t iY;
  size_t iDer;
  const size_t nInp = ptrSpaObj->inputs->n;
  const size_t nOut = ptrSpaObj->outputs->n;
  const size_t nDer = ptrSpaObj->derivatives->n;
  const double time = u[nInp];

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  if (bui->logLevel >= TIMESTEP)
    SpawnFormatMessage("%.3f %s: Exchanging data with EnergyPlus: initialCall = %d, mode = %s, ptrSpaObj = %s.\n", bui->time, ptrSpaObj->modelicaName,
      initialCall, fmuModeToString(bui->mode), ptrSpaObj->modelicaName);

  if (! ptrSpaObj->isInstantiated){
    /* This ptrSpaObj has not been initialized because the simulator removed the call to initialize().
    */
    SpawnFormatError(
      "Error, ptrSpaObj %s should have been initialized. Contact support.",
      ptrSpaObj->modelicaName);
  }

  if (ptrSpaObj->printUnit && (! ptrSpaObj->unitPrinted)){
    /* The above statement is only true for outputs, hence we know the outputs->units[0] exists */
    if (ptrSpaObj->outputs->units[0]){ /* modelDescription.xml defines unit */
      SpawnFormatMessage("Output %s.y has in Modelica the unit %s.\n",
        ptrSpaObj->modelicaName,
        fmi2_import_get_unit_name(ptrSpaObj->outputs->units[0]));
    }
    else{
      SpawnFormatMessage("Output %s.y has same unit as received from EnergyPlus, but EnergyPlus does not define the unit of this output.\n",
        ptrSpaObj->modelicaName);
    }
    ptrSpaObj->unitPrinted = fmi2True;
  }

  if (initialCall){
    ptrSpaObj->isInitialized = true; /* Set to true as it will be initialized right below */
    if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage("%.3f %s: Initial call for exchange.\n", bui->time, ptrSpaObj->modelicaName);
  }
  else
  {
    if (bui->logLevel >= TIMESTEP)
      SpawnFormatMessage("%.3f %s: Did not enter initialization mode for exchange. isInitialized = %d\n", bui->time, ptrSpaObj->modelicaName, ptrSpaObj->isInitialized);
  }

  /* Get out of the initialization mode if this ptrSpaObj is no longer in the initial call
     but the FMU is still in initializationMode */
  if ((!initialCall) && bui->mode == initializationMode){
    if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage("%.3f %s: Enter exit initialization mode of FMU in exchange().\n", bui->time, ptrSpaObj->modelicaName);
    status = fmi2_import_exit_initialization_mode(bui->fmu);
    if( status != (fmi2Status)fmi2_status_ok ){
      SpawnFormatError("Failed to exit initialization mode for FMU for building %s and exchange %s",
        bui->modelicaNameBuilding, ptrSpaObj->modelicaName);
    }
    /* After exit_initialization_mode, the FMU is implicitly in event mode per the FMI standard */
    setFMUMode(bui, eventMode);
  }

  /* Check whether time in Modelica advanced compared to the last call to the building */
  if ( (time - bui->time) > 0.001 ) {
    /* Real time advanced */
    advanceTime_completeIntegratorStep_enterEventMode(bui, ptrSpaObj->modelicaName, time);
  }

 /* Set inputs */
  for(iU = 0; iU < nInp; iU++){
    ptrSpaObj->inputs->valsSI[iU] = u[iU];
  }

  /* Compute derivatives dy_i/du_j */
  for(iDer = 0; iDer < nDer; iDer++){
    iY = ptrSpaObj->derivatives->structure[iDer][0];
    iU = ptrSpaObj->derivatives->structure[iDer][1];
    /* Change value of iU-th input to the FMU, using forward difference */
    ptrSpaObj->inputs->valsSI[iU] = u[iU] + ptrSpaObj->derivatives->delta[iDer];
    /* Evaluate y(u + du_j) */
    setVariables(bui, ptrSpaObj->modelicaName, ptrSpaObj->inputs);
    getVariables(bui, ptrSpaObj->modelicaName, ptrSpaObj->outputs);
    /* Store value of y_i(u + du_j). This is not yet the derivative! */
    ptrSpaObj->derivatives->vals[iDer] = ptrSpaObj->outputs->valsSI[iY];
    /* Reset the input to the non-perturbed value */
    ptrSpaObj->inputs->valsSI[iU] = u[iU];
  }

  // Evaluate the FMU for the non-perturbed output */
  setVariables(bui, ptrSpaObj->modelicaName, ptrSpaObj->inputs);
  getVariables(bui, ptrSpaObj->modelicaName, ptrSpaObj->outputs);

  /* Get next event time, unless FMU is in initialization mode */
  if (bui->mode == initializationMode){
    if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage("%.3f %s: Returning current time as tNext due to initializationMode for exchange.\n",
         bui->time, ptrSpaObj->modelicaName);
    y[nOut+nDer] = bui->time; /* Return start time for next event time */
  }
  else{
    if (bui->logLevel >= TIMESTEP)
      SpawnFormatMessage("%.3f %s: Calling do_event_iteration after setting inputs for exchange.\n", bui->time, ptrSpaObj->modelicaName);
    /* Assign next synchronization time */
    y[nOut+nDer] = do_event_iteration(bui, ptrSpaObj->modelicaName);
    /* After the event iteration, we must get the output. Otherwise, we get the
       discrete output before the time event, and not after.
       To test, run SingleZone.mo in EnergyPlus/src
    */
    getVariables(bui, ptrSpaObj->modelicaName, ptrSpaObj->outputs);
  }

  /* Assign output values */
  for(iY = 0; iY < nOut; iY++){
    y[iY] = ptrSpaObj->outputs->valsSI[iY];
  }
  /* Compute the derivative values */
  for(iDer = 0; iDer < nDer; iDer++){
    iY = ptrSpaObj->derivatives->structure[iDer][0];
    ptrSpaObj->derivatives->vals[iDer] -= ptrSpaObj->outputs->valsSI[iY];
    ptrSpaObj->derivatives->vals[iDer] /= ptrSpaObj->derivatives->delta[iDer];
    /* Assign value to output array */
    y[nOut + iDer] = ptrSpaObj->derivatives->vals[iDer];
  }

  return;
}
