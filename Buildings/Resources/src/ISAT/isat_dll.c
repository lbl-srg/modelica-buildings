/****************************************************************************
|
|  \file   isat_dll.c
|
|  \brief  functions to call ISAT code as a dll
|
|  \author Wangda Zuo
|          University of Miami, University of Colorado Boulder
|          W.Zuo@miami.edu, wangda.zuo@colorado.edu
|          Xu Han
|          Univeristy of Colorado Boulder, xuha3556@colorado.edu
|
|  \date   4/5/2020
|  \This file provides functions as entry for the coupled simulation
|
****************************************************************************/

#include "isat_dll.h"
/******************************************************************************
| DLL interface to launch a separated thread for ISAT.
| Called by the other program
******************************************************************************/
void *isat_dll(CosimulationData *cosim) {
/* Windows*/
#ifdef _MSC_VER
  DWORD dummy;
  HANDLE workerThreadHandle;
/*  Linux*/
#else
    pthread_t thread1;
#endif

/* Windows*/
#ifdef _MSC_VER
  workerThreadHandle = CreateThread(NULL, 0, isat_thread, (void *)cosim, 0, &dummy);
/* Linux*/
#else
  void * (*foo) (void *);
  foo=&isat_thread;
  pthread_create(&thread1, NULL, foo, (void *)cosim);
#endif

  return 0;
} /* End of isat_dll()*/

/*
	* Launch the ISAT simulation through a thread
	*
	* @param p Pointer to the coupled simulation data
	*
	* @return 0 if no error occurred
	*/

#ifdef _MSC_VER /* Windows*/
DWORD WINAPI isat_thread(void *p){
  ULONG workerID = (ULONG)(ULONG_PTR)p;
#else /*Linux*/
void *isat_thread(void* p){
#endif

  CosimulationData *cosim = (CosimulationData *) p;

#ifdef _MSC_VER /* Windows*/
  sprintf(msg, "Start ISAT Simulation with Thread ID %lu", workerID);
#else /*Linux*/
  sprintf(msg, "Start ISAT Simulation with Thread");
#endif

  printf("%s\n", msg);
  ffd_log(msg, FFD_NEW);

  sprintf(msg, "fileName=\"%s\"", cosim->para->fileName);
  ffd_log(msg, FFD_NORMAL);

  if(isat_cosimulation(cosim)!=0) {
    ffd_log("isat_thread(): Cosimulation failed", FFD_ERROR);
/* Windows*/
#ifdef _MSC_VER 
    return 1;
#endif
  }
  else {
    ffd_log("Successfully exit ISAT.", FFD_NORMAL);
/* Windows*/
#ifdef _MSC_VER
    return 0;
#endif
  }
} /* End of isat_thread()*/



