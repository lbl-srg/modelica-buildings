/*
 * Modelica external function to intialize EnergyPlus.
 *
 * Michael Wetter, LBNL                  10/9/19
 */

#include "OutputVariableInstantiate.h"
#include "BuildingInstantiate.c" /* Include c file, otherwise Modelica won't compile it */
#include "EnergyPlusFMU.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

/* This function is called for each output variable in the 'initial equation section'
*/
void OutputVariableInstantiate(
    void* object,
    double startTime){
  fmi2_status_t status;
  FMUOutputVariable* outVar = (FMUOutputVariable*) object;
  FMUBuilding* bui = outVar->ptrBui;

  if (FMU_EP_VERBOSITY >= MEDIUM){
    ModelicaFormatMessage("Entered OutputVariableInstantiate for %s at %p with value reference %lu.\n", outVar->modelicaNameOutputVariable, outVar, outVar->outputs->valRefs[0]);
  }
  if (! outVar->valueReferenceIsSet){
    ModelicaFormatError("Value reference is not set for %s. For Dymola 2020x, make sure you set 'Hidden.AvoidDoubleComputation=true'. See Buildings.Experimental.EnergyPlus.UsersGuide.", outVar->modelicaNameOutputVariable);
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
    if (FMU_EP_VERBOSITY >= MEDIUM)
      ModelicaFormatMessage("FMU for %s is now allocated at %p.\n", outVar->modelicaNameOutputVariable, bui->fmu);
  }

  /* Set flag to indicate that this output variable has been properly initialized */
  outVar->isInstantiated = fmi2True;
}
