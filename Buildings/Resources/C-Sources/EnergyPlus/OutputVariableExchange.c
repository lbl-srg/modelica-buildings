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

  fmi2Status status;

  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("Exchanging data with EnergyPlus: t = %.2f, initialCall = %d, mode = %s, output variable = %s, valueReference = %lu.\n",
      time, initialCall, fmuModeToString(bui->mode), outVar->modelicaNameOutputVariable, outVar->outputs->valRefs[0]);

  if (! outVar->isInstantiated){
    /* In the first call, the output variable is not yet initialized.
       The call below will initialize it.
       Note that if such a call were to be done only from the 'initial equation' section,
       then OpenModelica would not call it.
    */
    OutputVariableInstantiate(object, time);
  }

  if (initialCall){
    outVar->isInitialized = true; /* Set to true as it will be initialized right below */
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage("Initial call for output variable %s at %p with time = %.f\n", outVar->modelicaNameOutputVariable, outVar, time);

    if (outVar->printUnit){
      if (outVar->outputs->units[0]) /* modelDescription.xml defines unit */
        ModelicaFormatMessage("Output %s.y has in Modelica the unit %s.\n",
          outVar->modelicaNameOutputVariable,
          fmi2_import_get_unit_name(outVar->outputs->units[0]));      
      else
        ModelicaFormatMessage("Output %s.y has same unit as EnergyPlus, but EnergyPlus does not define the unit of this output.\n",
          outVar->modelicaNameOutputVariable);
      }
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

  /* Get next event time, unless FMU is in initialization mode */
  if (bui->mode == initializationMode){
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage(
        "Returning current time %.0f as tNext due to initializationMode for zone = %s\n",
        bui->time,
        outVar->modelicaNameOutputVariable);
    *tNext = bui->time; /* Return start time for next event time */
  }
  else{
    if (FMU_EP_VERBOSITY >= TIMESTEP)
      ModelicaFormatMessage("Calling do_event_iteration for output = %s\n", outVar->modelicaNameOutputVariable);
    *tNext = do_event_iteration(bui, outVar->modelicaNameOutputVariable);
  }
  /* Get output */
  getVariables(bui, outVar->modelicaNameOutputVariable, outVar->outputs);

  *y = outVar->outputs->valsEP[0];

  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("Returning from OutputVariablesExchange with nextEventTime = %.2f, y = %.2f, output variable = %s, mode = %s\n",
    *tNext, *y, outVar->modelicaNameOutputVariable, fmuModeToString(bui->mode));

  return;
}
