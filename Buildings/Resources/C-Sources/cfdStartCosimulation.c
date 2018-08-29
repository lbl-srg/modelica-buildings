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
                size_t nConExtWin, size_t nXi, size_t nC, double rho_start) {
  size_t i, nBou;
  /****************************************************************************
  | For call FFD-DLL
  ****************************************************************************/
  cosim = (CosimulationData *) malloc(sizeof(CosimulationData));
  cosim->para = (ParameterSharedData *) malloc(sizeof(ParameterSharedData));
  cosim->modelica = (ModelicaSharedData *) malloc(sizeof(ModelicaSharedData));
  cosim->ffd = (ffdSharedData *) malloc(sizeof(ffdSharedData));

  /****************************************************************************
  | allocate the memory and assign the data
  ****************************************************************************/
  cosim->para->fileName = (char *) malloc(sizeof(char)*(strlen(cfdFilNam)+1));
  strcpy(cosim->para->fileName, cfdFilNam);

  cosim->para->nSur = nSur;
  cosim->para->nSen = nSen;
  cosim->para->nConExtWin= nConExtWin;
  cosim->para->nPorts = nPorts;
  cosim->para->sha = haveShade;
  cosim->para->nC = nC;
  cosim->para->nXi = nXi;
  cosim->para->rho_start = rho_start;

  nBou = nSur + nPorts;

  cosim->para->name = (char**) malloc(nSur*sizeof(char *));
  cosim->para->are = (REAL *) malloc(nSur*sizeof(REAL));
  cosim->para->til = (REAL *) malloc(nSur*sizeof(REAL));
  cosim->para->bouCon = (size_t *) malloc(nSur*sizeof(size_t));

  for(i=0; i<nSur; i++) {
    cosim->para->name[i] = (char *)malloc(sizeof(char) *(strlen(name[i])+1));
    strcpy(cosim->para->name[i], name[i]);
    cosim->para->are[i] = (REAL) A[i];
    cosim->para->til[i] = (REAL) til[i];
    cosim->para->bouCon[i] = bouCon[i];
  }

  cosim->para->portName = (char**) malloc(nPorts*sizeof(char *));

  for(i=0; i<nPorts; i++) {
    cosim->para->portName[i] = (char *)malloc(sizeof(char)*(strlen(portName[i])+1));
    strcpy(cosim->para->portName[i], portName[i]);
  }

  if(haveSensor) {
    cosim->para->sensorName = (char **) malloc(nSen*sizeof(char *));
    cosim->ffd->senVal = (REAL *) malloc(nSen*sizeof(REAL));
    for(i=0; i<nSen; i++) {
      cosim->para->sensorName[i] = (char *)malloc(sizeof(char)*(strlen(sensorName[i])+1));
      strcpy(cosim->para->sensorName[i], sensorName[i]);
    }
  }

  /* Set the flag to initial value*/
  cosim->modelica->flag = 0;
  cosim->ffd->flag = 0;
  cosim->para->flag = 1;
  cosim->para->ffdError = 0;

  cosim->modelica->temHea = (REAL *) malloc(nSur*sizeof(REAL));
  /* Having a shade for window*/
  if(haveShade==1) {
    cosim->modelica->shaConSig = (REAL *) malloc(nConExtWin*sizeof(REAL));
    cosim->modelica->shaAbsRad = (REAL *) malloc(nConExtWin*sizeof(REAL));
  }
  cosim->modelica->mFloRatPor = (REAL *) malloc(nPorts*sizeof(REAL));
  cosim->modelica->TPor = (REAL *) malloc(nPorts*sizeof(REAL));

  cosim->modelica->XiPor = (REAL **) malloc(nPorts*sizeof(REAL *));
  cosim->ffd->XiPor = (REAL **) malloc(nPorts*sizeof(REAL *));
  for(i=0; i<nPorts; i++) {
    cosim->modelica->XiPor[i] = (REAL *) malloc(cosim->para->nXi*sizeof(REAL));
    cosim->ffd->XiPor[i] = (REAL *) malloc(cosim->para->nXi*sizeof(REAL));
  }

  cosim->modelica->CPor = (REAL **) malloc(nPorts*sizeof(REAL *));
  cosim->ffd->CPor = (REAL **) malloc(nPorts*sizeof(REAL *));
  for(i=0; i<nPorts; i++) {
    cosim->modelica->CPor[i] = (REAL *) malloc(cosim->para->nC*sizeof(REAL));
    cosim->ffd->CPor[i] = (REAL *) malloc(cosim->para->nC*sizeof(REAL));
  }

  cosim->ffd->temHea = (REAL *) malloc(nSur*sizeof(REAL));
  if(haveShade==1) cosim->ffd->TSha = (REAL *) malloc(nConExtWin*sizeof(REAL));
  cosim->ffd->TPor = (REAL *) malloc(nPorts*sizeof(REAL));
  cosim->ffd->msg = (REAL *) malloc(400*sizeof(char));

  /****************************************************************************
  | Implicitly launch DLL module.
  ****************************************************************************/
  ffd_dll(cosim);

  return 0;
} /* End of cfdStartCosimulation()*/
