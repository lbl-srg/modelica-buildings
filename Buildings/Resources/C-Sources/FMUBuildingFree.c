/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "FMUEnergyPlusStructure.h"
#include <stdlib.h>

void FMUBuildingFree(void* object){
  if ( object != NULL ){
    FMUBuilding* zone = (FMUBuilding*) object;
    free(zone);
  }
}
