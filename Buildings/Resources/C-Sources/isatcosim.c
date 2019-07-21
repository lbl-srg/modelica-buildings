/*
 *
 * \file   isatStartCosimulation.c
 *
 * \brief  Function to start the coupled simulation based on cfdcosim.c
 *
 * \author 
 *         Xu Han
 *         University of Colorado Boulder
 *         xuha3556@colorado.edu
 *
 *         Wangda Zuo
 *         University of Miami
 *         W.Zuo@miami.edu 
 *
 * \date   9/21/2019
 *
 */
#include "isatCosimulation.h"
#include <ModelicaUtilities.h>
/*
 * Start the cosimulation
 *
 * Allocate memory for cosimulation variables
 *
 */
void *isatcosim() {

  /****************************************************************************
  | return modelica error if more than one isat instances are created
  ****************************************************************************/
  if ( cosim != NULL )
    ModelicaError("ModelicaError: Only one room with ISAT can be used, but more than one is used.");

  /****************************************************************************
  | Allocate memory for cosimulation variables
  ****************************************************************************/
  cosim = NULL;
  cosim = (CosimulationData *) malloc(sizeof(CosimulationData));
  if (cosim == NULL){
    ModelicaError("Failed to allocate memory for cosim in isatcosim.c");
  }
  cosim->para = NULL;
  cosim->para = (ParameterSharedData *) malloc(sizeof(ParameterSharedData));
  if (cosim->para == NULL){
    ModelicaError("Failed to allocate memory for cosim->para in isatcosim.c");
  }

  cosim->modelica = NULL;
  cosim->modelica = (ModelicaSharedData *) malloc(sizeof(ModelicaSharedData));
  if (cosim->para == NULL){
    ModelicaError("Failed to allocate memory for cosim->modelica in isatcosim.c");
  }

  cosim->ffd = NULL;
  cosim->ffd = (ffdSharedData *) malloc(sizeof(ffdSharedData));
    if (cosim->para == NULL){
    ModelicaError("Failed to allocate memory for cosim->ffd in isatcosim.c");
  }

  /****************************************************************************
  | Initialize cosimulation variables
  ****************************************************************************/
  cosim->modelica->flag = 0;
  cosim->ffd->flag = 0;
  cosim->para->flag = 1;
  cosim->para->ffdError = 0;
  cosim->para->nSur = 0;
  cosim->para->nSen = 0;
  cosim->para->nConExtWin = 0;
  cosim->para->nPorts = 0;
  cosim->para->sha = 0;
  cosim->para->nC = 0;
  cosim->para->nXi = 0;
  cosim->ffd->msg = NULL;
  cosim->para->fileName = NULL;
  cosim->para->are = NULL;
  cosim->para->til = NULL;
  cosim->para->bouCon = NULL;
  cosim->para->name = NULL;
  cosim->para->sensorName = NULL;
  cosim->ffd->senVal = NULL;
  cosim->modelica->CPor = NULL;
  cosim->ffd->CPor = NULL;
  cosim->modelica->XiPor = NULL;
  cosim->ffd->XiPor = NULL;
  cosim->modelica->TPor = NULL;
  cosim->ffd->TPor = NULL;
  cosim->para->portName = NULL;
  cosim->modelica->mFloRatPor = NULL;
  cosim->ffd->temHea = NULL;
  cosim->modelica->temHea = NULL;
  cosim->modelica->shaConSig = NULL;
  cosim->modelica->shaAbsRad = NULL;
  cosim->ffd->TSha = NULL;
  cosim->para->Sou = 0;	
  cosim->para->nSou = 0;
  cosim->para->souName = NULL;
	cosim->modelica->sourceHeat = NULL;	

  return (void*) cosim;
} /* End of isatcosim()*/
