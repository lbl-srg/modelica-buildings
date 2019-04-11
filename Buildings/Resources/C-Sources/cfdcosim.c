/*
 *
 * \file   cfdStartCosimulation.c
 *
 * \brief  Function to start the coupled simulation
 *
 * \author Wangda Zuo
 *         University of Miami
 *         W.Zuo@miami.edu
 *
 *         Tian Wei
 *         University of Miami
 *         W.tian@miami.edu
 *
 *         Xu Han
 *         University of Colorado Boulder
 *         xuha3556@colorado.edu
 *
 * \date   7/27/2017
 *
 */
#include "cfdCosimulation.h"
#include <ModelicaUtilities.h>
/*
 * Start the cosimulation
 *
 * Allocate memory for cosimulation variables
 *
 */
void *cfdcosim() {

  /****************************************************************************
  | return modelica error if more than one ffd instances are created
  ****************************************************************************/
	if ( cosim != NULL )
		ModelicaError("ModelicaError: Only one room with FFD can be used, but more than one is used.");

  /****************************************************************************
  | Allocate memory for cosimulation variables
  ****************************************************************************/
  cosim = NULL;
  cosim = (CosimulationData *) malloc(sizeof(CosimulationData));
  if (cosim == NULL){
    ModelicaError("Failed to allocate memory for cosim in cfdcosim.c");
  }
  cosim->para = NULL;
  cosim->para = (ParameterSharedData *) malloc(sizeof(ParameterSharedData));
  if (cosim->para == NULL){
    ModelicaError("Failed to allocate memory for cosim->para in cfdcosim.c");
  }

  cosim->modelica = NULL;
  cosim->modelica = (ModelicaSharedData *) malloc(sizeof(ModelicaSharedData));
  if (cosim->para == NULL){
    ModelicaError("Failed to allocate memory for cosim->modelica in cfdcosim.c");
  }

  cosim->ffd = NULL;
  cosim->ffd = (ffdSharedData *) malloc(sizeof(ffdSharedData));
    if (cosim->para == NULL){
    ModelicaError("Failed to allocate memory for cosim->ffd in cfdcosim.c");
  }

	return (void*) cosim;
} /* End of cfdcosim()*/
