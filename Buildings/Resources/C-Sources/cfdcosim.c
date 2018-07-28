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

/*
 * Start the cosimulation
 *
 * Allocate memory for cosimulation variables
 *
 */
void *cfdcosim() {

  /****************************************************************************
  | Allocate memory for cosimulation variables
  ****************************************************************************/
  cosim = (CosimulationData *) malloc(sizeof(CosimulationData));
  cosim->para = (ParameterSharedData *) malloc(sizeof(ParameterSharedData));
  cosim->modelica = (ModelicaSharedData *) malloc(sizeof(ModelicaSharedData));
  cosim->ffd = (ffdSharedData *) malloc(sizeof(ffdSharedData));
  
  ModelicaMessage("finish allocate memory to cosim from constructor\n");

  return 0;
} /* End of cfdcosim()*/
