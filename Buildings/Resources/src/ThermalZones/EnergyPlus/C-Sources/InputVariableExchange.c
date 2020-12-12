/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  5/22/2020
 */

#include "InputVariableExchange.h"
#include "EnergyPlusFMU.h"

#include <stdlib.h>
#include <math.h>
#include <string.h>


/* Exchange data between Modelica zone and EnergyPlus zone
*/
void EnergyPlusInputVariableExchange(
  void* object,
  int initialCall,
  double u,
  double time,
  double* y){

  FMUInputVariable* inpVar = (FMUInputVariable*) object;
  FMUBuilding* bui = inpVar->bui;

  fmi2Status status;

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  if (bui->logLevel >= TIMESTEP)
    SpawnFormatMessage("Exchanging data with EnergyPlus: t = %.2f, initialCall = %d, zone = %s,  building ptr at %p.\n",
      time, initialCall, inpVar->modelicaNameInputVariable, bui);

  if (! inpVar->isInstantiated){
    /* This input variable has not been initialized because the simulator removed the call to initialize().
    */
    EnergyPlusInputVariableInstantiate(object, time);
 /*   SpawnFormatError(
      "Error, input variable %s should have been initialized. Contact support.",
      inpVar->modelicaNameInputVariable);
      */
  }

  if (initialCall){
    inpVar->isInitialized = true; /* Set to true as it will be initialized right below */
    if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage("Initial call for input variable %s with time = %.f\n", inpVar->modelicaNameInputVariable, time);
  }
  else
  {
    if (bui->logLevel >= TIMESTEP)
      SpawnFormatMessage("Did not enter initialization mode for input variable %s., isInitialized = %d\n",
        inpVar->modelicaNameInputVariable, inpVar->isInitialized);
  }

  /* Get out of the initialization mode if this input variable is no longer in the initial call
     but the FMU is still in initializationMode */
  if ((!initialCall) && bui->mode == initializationMode){
    if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage(
        "fmi2_import_exit_initialization_mode: Enter exit initialization mode of FMU in EnergyPlusInputVariableExchange() for input variable = %s.\n",
        inpVar->modelicaNameInputVariable);
    status = fmi2_import_exit_initialization_mode(bui->fmu);
    if( status != fmi2_status_ok ){
      SpawnFormatError("Failed to exit initialization mode for FMU for building %s and input variable %s",
        bui->modelicaNameBuilding, inpVar->modelicaNameInputVariable);
    }
    /* After exit_initialization_mode, the FMU is implicitly in event mode per the FMI standard */
    setFMUMode(bui, eventMode);
  }

  if ( (time - bui->time) > 0.001 ) {
    /* Real time advanced */
    advanceTime_completeIntegratorStep_enterEventMode(bui, inpVar->modelicaNameInputVariable, time);
  }

  /* Set input values, which are of the order below
     const char* inpNames[] = {"T", "X", "mInlets_flow", "TAveInlet", "QGaiRad_flow"};
  */
  inpVar->inputs->valsSI[0] = u;


  if (bui->logLevel >= TIMESTEP)
    SpawnFormatMessage(
      "Input to fmu for input variable %s: u = %.2f\n",
      inpVar->modelicaNameInputVariable,
      inpVar->inputs->valsSI[0]);

  setVariables(bui, inpVar->modelicaNameInputVariable, inpVar->inputs);

  /* Dummy output, used to enable forcing a direct dependency of outputs to inputs */
  *y = u;

  if (bui->logLevel >= TIMESTEP)
    SpawnFormatMessage("Returning from EnergyPlusInputVariableExchange() for %s.\n", inpVar->modelicaNameInputVariable);

  return;
}
