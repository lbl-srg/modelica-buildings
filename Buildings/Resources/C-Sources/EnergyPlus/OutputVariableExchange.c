/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  10/7/2019
 */

#include "OutputVariableExchange.h"
#include "EnergyPlusFMU.h"

#include <stdlib.h>
#include <math.h>
#include <string.h>

/*
bool allOutputVariablesAreInitialized(FMUBuilding* bui){
  void** outVars = bui->outputVariables;
  size_t i;
  FMUOutputVariable* outVar;
  for(i = 0; i < bui->nOutputVariables; i++){
    outVar = (FMUOutputVariable*)outVars[i];
    if (! outVar->isInitialized)
      return false;
  }
  return true;
}
*/

/* Exchange data between Modelica output variable block and EnergyPlus output variable
*/
void OutputVariableExchange(
  void* object,
  int initialCall,
  double time,
  double* y,
  double* tNext){

  FMUOutputVariable* outVar = (FMUOutputVariable*) object;
  FMUBuilding* bui = outVar->ptrBui;
  fmi2Real outputValues[1];

  fmi2Status status;

  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("Exchanging data with EnergyPlus: t = %.2f, initialCall = %d, mode = %s, output variable = %s.\n",
      time, initialCall, fmuModeToString(bui->mode), outVar->modelicaNameOutputVariable);

  if (! outVar->isInstantiated){
    /* This zone has not been initialized because the simulator removed the call to initialize().
    */
    ModelicaFormatError(
      "Error, output variable %s should have been initialized. Contact support.",
      outVar->modelicaNameOutputVariable);
  }

  if (initialCall){
    outVar->isInitialized = true; /* Set to true as it will be initialized right below */
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage("Initial call for output variable %s with time = %.f\n", outVar->modelicaNameOutputVariable, time);
  }
  else
  {
    if (FMU_EP_VERBOSITY >= TIMESTEP)
      ModelicaFormatMessage("Did not enter initialization mode for output variable %s., isInitialized = %d\n",
        outVar->modelicaNameOutputVariable, outVar->isInitialized);
  }

  /* Get out of the initialization mode if this output variable is no longer in the initial call
     but the FMU is still in initializationMode */
  if ((!initialCall) && bui->mode == initializationMode){
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage(
        "fmi2_import_exit_initialization_mode: Enter exit initialization mode of FMU in exchange() for output variable = %s.\n",
        outVar->modelicaNameOutputVariable);
    status = fmi2_import_exit_initialization_mode(bui->fmu);
    if( status != fmi2_status_ok ){
      ModelicaFormatError("Failed to exit initialization mode for FMU for building %s and output variable %s",
        bui->modelicaNameBuilding, outVar->modelicaNameOutputVariable);
    }
    /* After exit_initialization_mode, the FMU is implicitly in event mode per the FMI standard */
    setFMUMode(bui, eventMode);
  }


  if ( (time - bui->time) > 0.001 ) {
    /* Real time advanced */
    advanceTime_completeIntegratorStep_enterEventMode(bui, outVar->modelicaNameOutputVariable, time);
  }

  /* Get output */
  getVariables(bui, outVar->modelicaNameOutputVariable, outVar->outValReferences, outputValues, 1);

  /* Get next event time */
  *tNext = bui->time; /* Return start time for next event time */

  *y = outputValues[0];

  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("Returning from OutputVariablesExchange with nextEventTime = %.2f, y = %.2f, output variable = %s, mode = %s\n",
    *tNext, *y, outVar->modelicaNameOutputVariable, fmuModeToString(bui->mode));

  return;
}
