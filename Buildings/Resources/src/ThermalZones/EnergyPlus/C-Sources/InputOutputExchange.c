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

bool areAllInputOutputObjectsInitialized(FMUBuilding* bui){
  void** exc = bui->exchange;
  size_t i;
  FMUInOut* ptrInOut;
  for(i = 0; i < bui->nExcObj; i++){
    ptrInOut = (FMUInOut*)exc[i];
    if (! ptrInOut->isInitialized)
      return false;
  }
  return true;
}


/* Exchange data between Modelica and EnergyPlus during time stepping
*/
void EnergyPlusInputOutputExchange(
  void* object,
  int initialCall,
  const double* u,
  double* y){

  FMUInOut* ptrInOut = (FMUInOut*) object;
  FMUBuilding* bui = ptrInOut->bui;

  fmi2Status status;

  size_t iU;
  size_t iY;
  size_t iDer;
  const size_t nInp = ptrInOut->inputs->n;
  const size_t nOut = ptrInOut->outputs->n;
  const size_t nDer = ptrInOut->derivatives->n;
  const double time = u[nInp];

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

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

    if (ptrInOut->printUnit){
      /* The above statement is only true for outputs, hence we know the outputs->units[0] exists */
      if (ptrInOut->outputs->units[0]) /* modelDescription.xml defines unit */
        SpawnFormatMessage("Output %s.y has in Modelica the unit %s.\n",
          ptrInOut->modelicaName,
          fmi2_import_get_unit_name(ptrInOut->outputs->units[0]));
      else
        SpawnFormatMessage("Output %s.y has same unit as received from EnergyPlus, but EnergyPlus does not define the unit of this output.\n",
          ptrInOut->modelicaName);
      }
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

  /* Check whether time in Modelica advanced compared to the last call to the building */
  if ( (time - bui->time) > 0.001 ) {
    /* Real time advanced */
    advanceTime_completeIntegratorStep_enterEventMode(bui, ptrInOut->modelicaName, time);
  }

 /* Set inputs */
  for(iU = 0; iU < nInp; iU++){
    ptrInOut->inputs->valsSI[iU] = u[iU];
  }

  /* Compute derivatives dy_i/du_j */
  for(iDer = 0; iDer < nDer; iDer++){
    iY = ptrInOut->derivatives->structure[iDer][0];
    iU = ptrInOut->derivatives->structure[iDer][1];
    /* Change value of iU-th input to the FMU, using forward difference */
    ptrInOut->inputs->valsSI[iU] = u[iU] + ptrInOut->derivatives->delta[iDer];
    /* Evaluate y(u + du_j) */
    setVariables(bui, ptrInOut->modelicaName, ptrInOut->inputs);
    getVariables(bui, ptrInOut->modelicaName, ptrInOut->outputs);
    /* Store value of y_i(u + du_j). This is not yet the derivative! */
    ptrInOut->derivatives->vals[iDer] = ptrInOut->outputs->valsSI[iY];
    /* Reset the input to the non-perturbed value */
    ptrInOut->inputs->valsSI[iU] = u[iU];
  }

  // Evaluate the FMU for the non-perturbed output */
  setVariables(bui, ptrInOut->modelicaName, ptrInOut->inputs);
  getVariables(bui, ptrInOut->modelicaName, ptrInOut->outputs);

  /* Get next event time, unless FMU is in initialization mode */
  if (bui->mode == initializationMode){
    if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage("%.3f %s: Returning current time as tNext due to initializationMode for exchange.\n",
         bui->time, ptrInOut->modelicaName);
    y[nOut+nDer] = bui->time; /* Return start time for next event time */
  }
  else{
    if (bui->logLevel >= TIMESTEP)
      SpawnFormatMessage("%.3f %s: Calling do_event_iteration after setting inputs for exchange.\n", bui->time, ptrInOut->modelicaName);
    /* Assign next synchronization time */
    y[nOut+nDer] = do_event_iteration(bui, ptrInOut->modelicaName);
    /* After the event iteration, we must get the output. Otherwise, we get the
       discrete output before the time event, and not after.
       To test, run SingleZone.mo in EnergyPlus/src
    */
    getVariables(bui, ptrInOut->modelicaName, ptrInOut->outputs);
  }

  /* Assign output values */
  for(iY = 0; iY < nOut; iY++){
    y[iY] = ptrInOut->outputs->valsSI[iY];
  }
  /* Compute the derivative values */
  for(iDer = 0; iDer < nDer; iDer++){
    iY = ptrInOut->derivatives->structure[iDer][0];
    ptrInOut->derivatives->vals[iDer] -= ptrInOut->outputs->valsSI[iY];
    ptrInOut->derivatives->vals[iDer] /= ptrInOut->derivatives->delta[iDer];
    /* Assign value to output array */
    y[nOut + iDer] = ptrInOut->derivatives->vals[iDer];
  }

  return;
}
