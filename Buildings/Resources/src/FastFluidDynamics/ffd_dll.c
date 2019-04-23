/*
*
* \file   ffd_dll.c
*
* \brief  functions to call ffd code as a dll
*
* \author Wangda Zuo, Dan Li
*         University of Miami
*         W.Zuo@miami.edu
					Wei Tian
					W.Tian@umiami.edu
*
* \date   8/3/2013
*
* This file provides functions as entry for the coupled simulation
*
*/

#include "ffd_dll.h"
/******************************************************************************
| DLL interface to launch a separated thread for FFD.
| Called by the other program
******************************************************************************/
void *ffd_dll(CosimulationData *cosim) {
/* Windows*/
#ifdef _MSC_VER
  DWORD dummy;
  HANDLE workerThreadHandle[1];
/*  Linux*/
#else
    pthread_t thread1[1];
#endif

  /*printf("ffd_dll():Start to launch FFD\n");*/

/* Windows*/
#ifdef _MSC_VER
  workerThreadHandle[0] = CreateThread(NULL, 0, ffd_thread, (void *)cosim, 0, &dummy);
/* Linux*/
#else
  void * (*foo) (void *);
  foo=&ffd_thread;
  pthread_create(&thread1[0], NULL, foo, (void *)cosim);
#endif

  /*printf("ffd_dll(): Launched FFD simulation.\n");*/
	/* return the handle or thread*/
#ifdef _MSC_VER	
  return workerThreadHandle;
#else
	return thread1;
#endif
} /* End of ffd_dll()*/

/*
* Launch the FFD simulation through a thread
*
* @param p Pointer to the coupled simulation data
*
* @return 0 if no error occurred
*/
#ifdef _MSC_VER /*Windows*/
DWORD WINAPI ffd_thread(void *p){
  ULONG workerID = (ULONG)(ULONG_PTR)p;
#else /*Linux*/
void *ffd_thread(void* p){
#endif
int pthread_ret = 0;
  CosimulationData *cosim = (CosimulationData *) p;

#ifdef _MSC_VER /*Windows*/
  sprintf(msg, "Start Fast Fluid Dynamics Simulation with Thread ID %lu", workerID);
#else /*Linux*/
  sprintf(msg, "Start Fast Fluid Dynamics Simulation with Thread");
#endif

  printf("%s\n", msg);
  ffd_log(msg, FFD_NEW);

  sprintf(msg, "fileName=\"%s\"", cosim->para->fileName);
  ffd_log(msg, FFD_NORMAL);

  if(ffd_cosimulation(cosim)!=0) {
    ffd_log("ffd_thread(): Cosimulation failed", FFD_ERROR);
		#ifdef _MSC_VER
			return 1;
		#endif
  }
  else {
    ffd_log("Successfully exit FFD.", FFD_NORMAL);
		return 0;
  }
} /* End of ffd_thread()*/
