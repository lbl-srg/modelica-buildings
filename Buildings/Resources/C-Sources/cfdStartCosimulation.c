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
 * \date   2/14/2017
 *
 */
#include "ModelicaUtilities.h"

#include "cfdCosimulation.h"

/*
 * Start the cosimulation
 *
 * Allocate memory for the data exchange and launch CFD simulation
 *
 * @param cfdFilNam Name of the input file for the CFD simulation
 * @param name Pointer to the names of surfaces and fluid ports
 * @param A Pointer to the area of surfaces in the same order of name
 * @param til Pointer to the tilt of surface in the same order of name
 * @param bouCon Pointer to the type of thermal boundary condition in the
 *       same order of name
 * @param nPorts Number of fluid ports
 * @param portName Pointer to the name of fluid ports
 * @param haveSensor Flag: 1->have sensor; 0->No sensor
 * @param sensorName Pointer to the names of the sensors used in CFD
 * @param haveShade Flag: 1->have shade; 0->no shade
 * @param nSur Number of surfaces
 * @param nSen Number of sensors
 * @param nConExtWin Number of exterior construction with windows
 * @param nXi Number of species
 * @param nC Number of trace substances
 * @param rho_start Density at initial state
 *
 * @return 0 if no error occurred
 */
int cfdStartCosimulation(char *cfdFilNam, char **name, double *A, double *til,
                int *bouCon, int nPorts, char** portName, int haveSensor,
                char **sensorName, int haveShade, size_t nSur, size_t nSen,
                size_t nConExtWin, size_t nXi, size_t nC, int haveSource, size_t nSou, char **sourceName, double rho_start) {
  size_t i;
  size_t nBou;

  /****************************************************************************
  | allocate the memory and assign the data
  ****************************************************************************/
  cosim->para->fileName = (char *) malloc(sizeof(char)*(strlen(cfdFilNam)+1));
  if (cosim->para->fileName == NULL){
    ModelicaError("Failed to allocate memory for cosim->para->fileName in cfdStartCosimulation.c");
	return -1;
  }
  strcpy(cosim->para->fileName, cfdFilNam);

  cosim->para->nSur = nSur;
  cosim->para->nSen = nSen;
  cosim->para->nConExtWin= nConExtWin;
  cosim->para->nPorts = nPorts;
  cosim->para->sha = haveShade;
  cosim->para->nC = nC;
  cosim->para->nXi = nXi;
  cosim->para->rho_start = rho_start;

  cosim->para->Sou = haveSource;	
  cosim->para->nSou = nSou;

  if(cosim->para->nSou>0){
    cosim->para->souName = (char**) malloc(nSou*sizeof(char *));
	if (cosim->para->souName == NULL){
      ModelicaError("Failed to allocate memory for cosim->para->souName in cfdStartCosimulation.c");
	  return -1;
    }
    cosim->modelica->sourceHeat = (REAL *) malloc(nSou*sizeof(REAL));
	if (cosim->modelica->sourceHeat == NULL){
      ModelicaError("Failed to allocate memory for cosim->modelica->sourceHeat in cfdStartCosimulation.c");
	  return -1;
    }
    for(i=0; i<nSou; i++) {
      cosim->para->souName[i] = (char *)malloc(sizeof(char)*(strlen(sourceName[i])+1));
	  if (cosim->para->souName[i] == NULL){
        ModelicaError("Failed to allocate memory for cosim->para->souName[%d] in cfdStartCosimulation.c");
		return -1;
	  }
      strcpy(cosim->para->souName[i], sourceName[i]);
    }
  }
	
  nBou = nSur + nPorts;

  cosim->para->name = (char**) malloc(nSur*sizeof(char *));
  if (cosim->para->name == NULL){
    ModelicaError("Failed to allocate memory for cosim->para->name in cfdStartCosimulation.c");
	return -1;
  }
  cosim->para->are = (double *) malloc(nSur*sizeof(double));
  if (cosim->para->are == NULL){
    ModelicaError("Failed to allocate memory for cosim->para->are in cfdStartCosimulation.c");
	return -1;
  }
  cosim->para->til = (double *) malloc(nSur*sizeof(double));
  if (cosim->para->til == NULL){
    ModelicaError("Failed to allocate memory for cosim->para->til in cfdStartCosimulation.c");
	return -1;
  }
  cosim->para->bouCon = (int *) malloc(nSur*sizeof(int));
  if (cosim->para->bouCon == NULL){
    ModelicaError("Failed to allocate memory for cosim->para->bouCon in cfdStartCosimulation.c");
	return -1;
  }

  for(i=0; i<nSur; i++) {
    cosim->para->name[i] = NULL;
    cosim->para->name[i] = (char *)malloc(sizeof(char) *(strlen(name[i])+1));
    if (  cosim->para->name[i] == NULL){
      ModelicaError("Failed to allocate memory for cosim->para->name[i] in cfdStartCosimulation.c");
	  return -1;
    }
    strcpy(cosim->para->name[i], name[i]);
    cosim->para->are[i] = (double) A[i];
    cosim->para->til[i] = (double) til[i];
    cosim->para->bouCon[i] = bouCon[i];
  }

  cosim->para->portName = (char**) malloc(nPorts*sizeof(char *));
  if (cosim->para->portName == NULL){
    ModelicaError("Failed to allocate memory for cosim->para->portName in cfdStartCosimulation.c");
	return -1;
  }

  for(i=0; i<nPorts; i++) {
    cosim->para->portName[i] = NULL;
    cosim->para->portName[i] = (char *)malloc(sizeof(char)*(strlen(portName[i])+1));
    if (  cosim->para->portName[i] == NULL){
      ModelicaError("Failed to allocate memory for cosim->para->portName[i] in cfdStartCosimulation.c");
	  return -1;
    }
    strcpy(cosim->para->portName[i], portName[i]);
  }

  if(haveSensor) {
    cosim->para->sensorName = (char **) malloc(nSen*sizeof(char *));
    if (  cosim->para->sensorName == NULL){
      ModelicaError("Failed to allocate memory for cosim->para->sensorName in cfdStartCosimulation.c");
	  return -1;
    }
    cosim->ffd->senVal = (double *) malloc(nSen*sizeof(double));
    if (  cosim->ffd->senVal == NULL){
      ModelicaError("Failed to allocate memory for cosim->ffd->senVal in cfdStartCosimulation.c");
	  return -1;
    }
    for(i=0; i<nSen; i++) {
      cosim->para->sensorName[i] = NULL;
      cosim->para->sensorName[i] = (char *)malloc(sizeof(char)*(strlen(sensorName[i])+1));
      if (    cosim->para->sensorName[i] == NULL){
        ModelicaError("Failed to allocate memory for cosim->para->sensorName[i] in cfdStartCosimulation.c");
		return -1;
      }
      strcpy(cosim->para->sensorName[i], sensorName[i]);
    }
  }

  /* Set the flag to initial value*/
  cosim->modelica->flag = 0;
  cosim->ffd->flag = 0;
  cosim->para->flag = 1;
  cosim->para->ffdError = 0;
  cosim->modelica->t = 0;
  cosim->modelica->lt = -1;/*initialize lt to -1 to avoid skipping all exchange() at time = 0*/

  cosim->modelica->temHea = (double *) malloc(nSur*sizeof(double));
  if (cosim->modelica->temHea == NULL){
    ModelicaError("Failed to allocate memory for cosim->modelica->temHea in cfdStartCosimulation.c");
	return -1;
  }
  /* Having a shade for window*/
  if(haveShade==1) {
    cosim->modelica->shaConSig = (double *) malloc(nConExtWin*sizeof(double));
    if (  cosim->modelica->shaConSig == NULL){
      ModelicaError("Failed to allocate memory for cosim->modelica->shaConSig in cfdStartCosimulation.c");
	  return -1;
    }
    cosim->modelica->shaAbsRad = (double *) malloc(nConExtWin*sizeof(double));
    if (  cosim->modelica->shaAbsRad == NULL){
      ModelicaError("Failed to allocate memory for cosim->modelica->shaAbsRad in cfdStartCosimulation.c");
	  return -1;
    }
  }
  cosim->modelica->mFloRatPor = (double *) malloc(nPorts*sizeof(double));
  if (cosim->modelica->mFloRatPor == NULL){
    ModelicaError("Failed to allocate memory for cosim->modelica->mFloRatPor in cfdStartCosimulation.c");
	return -1;
  }
  cosim->modelica->TPor = (double *) malloc(nPorts*sizeof(double));
  if (cosim->modelica->TPor == NULL){
    ModelicaError("Failed to allocate memory for cosim->modelica->TPor in cfdStartCosimulation.c");
	return -1;
  }

  cosim->modelica->XiPor = (double **) malloc(nPorts*sizeof(double *));
  if (cosim->modelica->XiPor == NULL){
    ModelicaError("Failed to allocate memory for cosim->modelica->XiPor in cfdStartCosimulation.c");
	return -1;
  }
  cosim->ffd->XiPor = (double **) malloc(nPorts*sizeof(double *));
  if (cosim->ffd->XiPor == NULL){
    ModelicaError("Failed to allocate memory for cosim->ffd->XiPor in cfdStartCosimulation.c");
	return -1;
  }
  for(i=0; i<nPorts; i++) {
    cosim->modelica->XiPor[i] = NULL;
    cosim->modelica->XiPor[i] = (double *) malloc(cosim->para->nXi*sizeof(double));
    if (  cosim->modelica->XiPor[i] == NULL){
      ModelicaError("Failed to allocate memory for cosim->modelica->XiPor[i] in cfdStartCosimulation.c");
	  return -1;
    }
    cosim->ffd->XiPor[i] = NULL;
    cosim->ffd->XiPor[i] = (double *) malloc(cosim->para->nXi*sizeof(double));
    if (  cosim->ffd->XiPor[i] == NULL){
      ModelicaError("Failed to allocate memory for cosim->ffd->XiPor[i] in cfdStartCosimulation.c");
	  return -1;
    }
  }

  cosim->modelica->CPor = (double **) malloc(nPorts*sizeof(double *));
  if (cosim->modelica->CPor == NULL){
    ModelicaError("Failed to allocate memory for cosim->modelica->CPor in cfdStartCosimulation.c");
	return -1;
  }
  cosim->ffd->CPor = (double **) malloc(nPorts*sizeof(double *));
  if (cosim->ffd->CPor == NULL){
    ModelicaError("Failed to allocate memory for cosim->ffd->CPor in cfdStartCosimulation.c");
	return -1;
  }
  for(i=0; i<nPorts; i++) {
    cosim->modelica->CPor[i] = NULL;
    cosim->modelica->CPor[i] = (double *) malloc(cosim->para->nC*sizeof(double));
    if (  cosim->modelica->CPor[i] == NULL){
      ModelicaError("Failed to allocate memory for cosim->modelica->CPor[i] in cfdStartCosimulation.c");
	  return -1;
    }
    cosim->ffd->CPor[i] = NULL;
    cosim->ffd->CPor[i] = (double *) malloc(cosim->para->nC*sizeof(double));
    if (  cosim->ffd->CPor[i] == NULL){
      ModelicaError("Failed to allocate memory for cosim->ffd->CPor[i] in cfdStartCosimulation.c");
	  return -1;
    }
  }

  cosim->ffd->temHea = (double *) malloc(nSur*sizeof(double));
  if (cosim->ffd->temHea == NULL){
    ModelicaError("Failed to allocate memory for cosim->ffd->temHea in cfdStartCosimulation.c");
	return -1;
  }
  if(haveShade==1){
     cosim->ffd->TSha = (double *) malloc(nConExtWin*sizeof(double));
     if (   cosim->ffd->TSha == NULL){
       ModelicaError("Failed to allocate memory for    cosim->ffd->TSha in cfdStartCosimulation.c");
	   return -1;
     }
  }
  cosim->ffd->TPor = (double *) malloc(nPorts*sizeof(double));
  if (cosim->ffd->TPor == NULL){
    ModelicaError("Failed to allocate memory for cosim->ffd->TPor in cfdStartCosimulation.c");
	return -1;
  }

  /****************************************************************************
  | Implicitly launch DLL module.
  ****************************************************************************/
  ffd_dll(cosim);

  return 0;
} /* End of cfdStartCosimulation()*/
