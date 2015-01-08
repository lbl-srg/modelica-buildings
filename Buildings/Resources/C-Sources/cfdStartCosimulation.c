///////////////////////////////////////////////////////////////////////////////
///
/// \file   cfdStartCosimulation.c
///
/// \brief  Function to start the coupled simulation
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
///\param bouCon Pointer to the type of thermal boundary condition in the
///       same order of name
///\param nPorts Number of fluid ports
///\param portName Pointer to the name of fluid ports
///\param haveSensor Flag: 1->have sensor; 0->No sensor
///\param sensorName Pointer to the names of the sensors used in CFD
///\param haveShade Flag: 1->have shade; 0->no shade
///\param nSur Number of surfaces
///\param nSen Number of sensors
///\param nConExtWin Number of exterior construction with windows
///\param nXi Number of species
///\param nC Number of trace substances
///\param rho_start Density at initial state
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int cfdStartCosimulation(char *cfdFilNam, char **name, double *A, double *til,
                int *bouCon, int nPorts, char** portName, int haveSensor,
                char **sensorName, int haveShade, int nSur, int nSen,
                int nConExtWin, int nXi, int nC, double rho_start) {
  int i, nBou;
  /****************************************************************************
  | For call FFD-DLL
  ****************************************************************************/
  //Define loaded library handle
#ifdef _MSC_VER //Windows
  HINSTANCE hinstLib;
#else //Linux
  void *hinstLib;
#endif
  //Define function type
  typedef int (*MYPROC)(CosimulationData *);
  MYPROC ProcAdd;

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
  cosim->para->bouCon = (int *) malloc(nSur*sizeof(int));

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

  // Set the flag to initial value
  cosim->modelica->flag = 0;
  cosim->ffd->flag = 0;
  cosim->para->flag = 1;
  cosim->para->ffdError = 0;

  cosim->modelica->temHea = (REAL *) malloc(nSur*sizeof(REAL));
  // Having a shade for window
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
  | Get a handle to the DLL module.
  ****************************************************************************/
#ifdef _MSC_VER //Windows

#if _WIN64
  hinstLib = LoadLibrary(TEXT("Resources/Library/win64/ffd.dll"));
#elif _WIN32
  hinstLib = LoadLibrary(TEXT("Resources/Library/win32/ffd.dll"));
#else
  ModelicaError("Error: Failed to detect 32 or 64 bit Windows system in cfdStartCosimulation.c.\n");
#endif

#elif __linux__ //Linux
#if UINTPTR_MAX == 0xffffffff
/* 32-bit */
  hinstLib = dlopen("Resources/Library/linux32/libffd.so", RTLD_LAZY);
#elif UINTPTR_MAX == 0xffffffffffffffff
/* 64-bit */
  hinstLib = dlopen("Resources/Library/linux64/libffd.so", RTLD_LAZY);
#else
  ModelicaError("Error: Failed to detect 32 or 64 bit Linux system in cfdStartCosimulation.c.\n");
#endif

#else /* Neither MSC nor Linux */
  ModelicaError("Error: Unsupported operating system in cfdStartCosimulation.c.\n");
#endif

  // If the handle is valid, try to get the function address.
  if(hinstLib!=NULL) {
#ifdef _MSC_VER
    ProcAdd = (MYPROC) GetProcAddress(hinstLib, "ffd_dll");
#else
    ProcAdd = (MYPROC) dlsym(hinstLib, "ffd_dll");
#endif
  }
  else {
    ModelicaError("Error: Could not find dll handle.\n");
  }

  // If the function address is valid, call the function.
  if (ProcAdd!=NULL) {
  //call function: passing pointer of NAME struct
    ProcAdd(cosim);
  }
  else{
    ModelicaError("Error: Could not find dll function address.\n");
  }

  return 0;
} // End of cfdStartCosimulation()
