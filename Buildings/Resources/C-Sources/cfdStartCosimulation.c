///////////////////////////////////////////////////////////////////////////////
///
/// \file   cfdStartCosimulation.c
///
/// \brief  Function to start the cosimulation
///
/// \author Wangda Zuo
///         University of Miami
///         W.Zuo@miami.edu
///
/// \date   8/3/2013
///
///////////////////////////////////////////////////////////////////////////////
#include "cfdCosimulation.h"

///////////////////////////////////////////////////////////////////////////////
/// Start the cosimulation
///
/// Allocate memory for the data exchange and launch CFD simulation
///
///\param cfdFilNam Name of the input file for the CFD simulation
///\param name Pointer to the names of surfaces and fluid ports
///\param A Pointer to the area of surfaces in the same order of name
///\param til Pointer to the tilt of surface in the same order of name
///\param bouCon Pointer to the type of thermal bundary condition in the 
///       same order of name
///\param nPorts Number of fluid ports
///\param portName Pointer to the name of fluid ports
///\param haveSensor Flag: 1->have sensor; 0->No sensor
///\param sensorName Pointer to the names of the sensors used in CFD
///\param haveShade Flag: 1->have shade; 0->no shade
///\param nSur Number of surfaces
///\param nSen Number of sensors
///\param nConExtWin Number of exterior construction with windows
///\param nC Number of trace substances
///\param nXi Number of species
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int cfdStartCosimulation(char *cfdFilNam, char **name, double *A, double *til, 
                int *bouCon, int nPorts, char** portName, int haveSensor,
                char **sensorName, int haveShade, int nSur, int nSen,
                int nConExtWin, int nC, int nXi) {
  int i, nBou;
  /****************************************************************************
  | For call FFD-DLL.dll
  ****************************************************************************/
  typedef int (*MYPROC)(CosimulationData *);
  HINSTANCE hinstLib; 
  MYPROC ProcAdd;

  printf("Start to allcoate memory for data exchange.\n");

  cosim = (CosimulationData *) malloc(sizeof(CosimulationData));
  cosim->para = (ParameterSharedData *) malloc(sizeof(ParameterSharedData));  
  cosim->modelica = (ModelicaSharedData *) malloc(sizeof(ModelicaSharedData)); 
  cosim->ffd = (ffdSharedData *) malloc(sizeof(ffdSharedData)); 

  /****************************************************************************
  | allocate the memory and assign the data
  ****************************************************************************/
  cosim->para->fileName = (char *) malloc(sizeof(char)*strlen(cfdFilNam));
  strcpy(cosim->para->fileName, cfdFilNam); 

  cosim->para->nSur = nSur;
  cosim->para->nSen = nSen;
  cosim->para->nConExtWin= nConExtWin;
  cosim->para->nPorts = nPorts;
  cosim->para->sha = haveShade;
  cosim->para->nC = nC;
  cosim->para->nXi = nXi;

  nBou = nSur + nPorts;

  cosim->para->name = (char**) malloc(nSur*sizeof(char *));
  cosim->para->are = (float *) malloc(nSur*sizeof(float));
  cosim->para->til = (float *) malloc(nSur*sizeof(float));
  cosim->para->bouCon = (int *) malloc(nSur*sizeof(int));

  for(i=0; i<nSur; i++) { 
    cosim->para->name[i] = (char *)malloc(sizeof(char) *strlen(name[i]));
    strcpy(cosim->para->name[i], name[i]);
    printf("Boundary name:%s\n", cosim->para->name[i]);

    cosim->para->are[i] = (float) A[i];
    printf("\tA->Area:%f->%f [m2]\n", A[i], cosim->para->are[i]);

    cosim->para->til[i] = (float) til[i];
    printf("\tTilt->Tilt:%f->%f [deg]\n", til[i], cosim->para->til[i]);

    cosim->para->bouCon[i] = bouCon[i];
    printf("\tbouCon->bouCon:%d->%d \n\n", bouCon[i], cosim->para->bouCon[i]);
  }

  cosim->para->portName = (char**) malloc(nPorts*sizeof(char *));

  for(i=0; i<nPorts; i++) {
    cosim->para->portName[i] = (char *)malloc(sizeof(char)*strlen(portName[i]));
    strcpy(cosim->para->portName[i], portName[i]);
    printf("Boundary name:%s\n", cosim->para->portName[i]);
  }

  if(haveSensor) {
    cosim->para->sensorName = (char **) malloc(nSen*sizeof(char *));
    for(i=0; i<nSen; i++) {
      cosim->para->sensorName[i] = (char *)malloc(sizeof(char)*strlen(sensorName[i]));
      strcpy(cosim->para->sensorName[i], sensorName[i]);
      printf("Sensor Name:%s\n", cosim->para->sensorName[i]);
    }
  }

  // Set the flag to initial value
  cosim->modelica->flag = 0;
  cosim->ffd->flag = 0;
  cosim->para->flag = 1;

  cosim->modelica->temHea = (float *) malloc(nSur*sizeof(float));
  // Having a shade for window
  if(haveShade==1) {
    cosim->modelica->shaConSig = (float *) malloc(nConExtWin*sizeof(float));
    cosim->modelica->shaAbsRad = (float *) malloc(nConExtWin*sizeof(float));
  }
  cosim->modelica->mFloRatPor = (float *) malloc(nPorts*sizeof(float));
  cosim->modelica->TPor = (float *) malloc(nPorts*sizeof(float));

  cosim->modelica->XiPor = (float **) malloc(nPorts*sizeof(float *));
  cosim->ffd->XiPor = (float **) malloc(nPorts*sizeof(float *));
  for(i=0; i<cosim->para->nXi; i++) {
    cosim->modelica->XiPor[i] = (float *) malloc(cosim->para->nXi*sizeof(float));
    cosim->ffd->XiPor[i] = (float *) malloc(cosim->para->nXi*sizeof(float));
  }

  cosim->modelica->CPor = (float **) malloc(nPorts*sizeof(float *));
  cosim->ffd->CPor = (float **) malloc(nPorts*sizeof(float *));
  for(i=0; i<cosim->para->nC; i++) {
    cosim->modelica->CPor[i] = (float *) malloc(cosim->para->nC*sizeof(float));
    cosim->ffd->CPor[i] = (float *) malloc(cosim->para->nC*sizeof(float));
  }

  cosim->ffd->temHea = (float *) malloc(nSur*sizeof(float));
  if(haveShade==1) cosim->ffd->TSha = (float *) malloc(nConExtWin*sizeof(float));
  cosim->ffd->TPor = (float *) malloc(nPorts*sizeof(float));
  
  printf("Allocated memory for cosimulation data.\n");

  /****************************************************************************
  | Get a handle to the DLL module.
  ****************************************************************************/
  hinstLib = LoadLibrary(TEXT("Resources/bin/FFD-DLL.dll")); 

  // If the handle is valid, try to get the function address.
  if(hinstLib != NULL) {
    ProcAdd = (MYPROC) GetProcAddress(hinstLib, "ffd_dll");
  }
  else {
    printf("instantiate(): Could not find dll handle.\n");
    return 1;
  }

  // If the function address is valid, call the function.
    if (NULL!=ProcAdd) {
      ProcAdd(cosim);   //call function: passing pointer of NAME struct
    }
    else{
      printf("instantiate(): Could not find dll function address.\n");
      return 1;
    }

  return 0;
} // End of cfdStartCosimulation()