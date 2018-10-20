/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "FMUEnergyPlusStructure.h"
#include "ModelicaUtilities.h"

static unsigned int Buildings_nFMU = 0;     /* Number of FMUs */

void incrementBuildings_nFMU(){
  Buildings_nFMU++;
  ModelicaFormatMessage("*** Increased Buildings_nFMU to %zu\n", Buildings_nFMU);
  return;
}

void decrementBuildings_nFMU(){
  Buildings_nFMU--;
  ModelicaFormatMessage("*** Decreased Buildings_nFMU to %zu\n", Buildings_nFMU);
  return;
}

unsigned int getBuildings_nFMU(){
  return Buildings_nFMU;
}

