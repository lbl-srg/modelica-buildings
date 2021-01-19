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

/* Exchange data between Modelica output variable block and EnergyPlus output variable.

   The argument directDependency is a dummy variable needed
   to force Modelica tools to call outputs after an input has been set.
*/
void EnergyPlusOutputVariableExchange(
  void* object,
  int initialCall,
  double directDependency,
  double time,
  double* y,
  double* tNext){

  FMUOutputVariable* outVar = (FMUOutputVariable*) object;
  FMUBuilding* bui = outVar->bui;

  fmi2Status status;

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  if (bui->logLevel >= TIMESTEP)
    SpawnFormatMessage("%.3f %s: Exchanging data with EnergyPlus: initialCall = %d, mode = %s, directDependency = %2.f, valueReference = %lu.\n",
      bui->time, outVar->modelicaNameOutputVariable,
      initialCall, fmuModeToString(bui->mode), directDependency, outVar->outputs->valRefs[0]);

  if (! outVar->isInstantiated){
    /* In the first call, the output variable is not yet initialized.
       The call below will initialize it.
       Note that if such a call were to be done only from the 'initial equation' section,
       then OpenModelica would not call it.
    */
    EnergyPlusOutputVariableInstantiate(object, time);
  }

  if (initialCall){
    outVar->isInitialized = true; /* Set to true as it will be initialized right below */
    if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage("%.3f %s: Initial call for output variable at %p.f\n", bui->time, outVar->modelicaNameOutputVariable, outVar);

    if (outVar->printUnit){
      if (outVar->outputs->units[0]) /* modelDescription.xml defines unit */
        SpawnFormatMessage("Output %s.y has in Modelica the unit %s.\n",
          outVar->modelicaNameOutputVariable,
          fmi2_import_get_unit_name(outVar->outputs->units[0]));
      else
        SpawnFormatMessage("Output %s.y has same unit as EnergyPlus, but EnergyPlus does not define the unit of this output.\n",
          outVar->modelicaNameOutputVariable);
      }
  }
  else
  {
    if (bui->logLevel >= TIMESTEP)
      SpawnFormatMessage("%.3f %s: Did not enter initialization mode for output variable, isInitialized = %d\n",
        bui->time, outVar->modelicaNameOutputVariable,
        outVar->isInitialized);
  }

  /* Get out of the initialization mode if this output variable is no longer in the initial call
     but the FMU is still in initializationMode */
  if ((!initialCall) && bui->mode == initializationMode){
    if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage("%.3f %s: fmi2_import_exit_initialization_mode: Enter exit initialization mode of FMU in exchange() for output variable.\n",
        bui->time, outVar->modelicaNameOutputVariable);
    status = fmi2_import_exit_initialization_mode(bui->fmu);
    if( status != fmi2OK ){
      SpawnFormatError("Failed to exit initialization mode for FMU for building %s and output variable %s",
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
    if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage("%.3f %s: Returning current time %.0f as tNext due to initializationMode for zone = %s\n",
        bui->time, outVar->modelicaNameOutputVariable,
        bui->time,
        outVar->modelicaNameOutputVariable);
    *tNext = bui->time; /* Return start time for next event time */
  }
  else{
    if (bui->logLevel >= TIMESTEP)
      SpawnFormatMessage("%.3f %s: Calling do_event_iteration\n",
        bui->time, outVar->modelicaNameOutputVariable);
    *tNext = do_event_iteration(bui, outVar->modelicaNameOutputVariable);
  }
  /* Get output */
  getVariables(bui, outVar->modelicaNameOutputVariable, outVar->outputs);

  *y = outVar->outputs->valsSI[0];

  if (bui->logLevel >= TIMESTEP)
    SpawnFormatMessage("%.3f %s: Returning from OutputVariablesExchange with nextEventTime = %.2f, y = %.2f, mode = %s\n",
    bui->time, outVar->modelicaNameOutputVariable,
    *tNext, *y, fmuModeToString(bui->mode));

  return;
}
