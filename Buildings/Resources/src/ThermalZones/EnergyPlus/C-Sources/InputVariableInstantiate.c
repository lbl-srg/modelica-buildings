/*
 * Modelica external function to intialize EnergyPlus.
 *
 * Michael Wetter, LBNL                  5/22/2020
 */

#include "InputVariableInstantiate.h"
#include "EnergyPlusFMU.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

/* This function is called for each output variable in the 'initial equation section'
*/
void EnergyPlusInputVariableInstantiate(
    void* object,
    double startTime){
  fmi2_status_t status;
  FMUInputVariable* var = (FMUInputVariable*) object;
  FMUBuilding* bui = var->bui;

  if (bui->logLevel >= MEDIUM){
    bui->SpawnFormatMessage("Entered EnergyPlusInputVariableInstantiate for %s.\n",
      var->modelicaNameInputVariable);
  }
  if (bui->fmu == NULL){
    /* EnergyPlus is not yet loaded.
       This section is only executed once if the 'initial equation' section is called multiple times.
       Moreover, it is called from the 'initial equation' section rather than than constructor
       because we only know how many zones and output variables there are after all constructors have been called.
       Hence we cannot construct the FMU in the constructor because we don't know which
       is the last constructor to be called.
    */
    loadFMU_setupExperiment_enterInitializationMode(bui, startTime);
  }
  if (! var->valueReferenceIsSet){
    bui->SpawnFormatError("Value reference is not set for %s. For Dymola 2020x, make sure you set 'Hidden.AvoidDoubleComputation=true'. See Buildings.ThermalZones.EnergyPlus.UsersGuide.",
      var->modelicaNameInputVariable);
  }
  /* Set flag to indicate that this output variable has been properly initialized */
  var->isInstantiated = fmi2True;
}
