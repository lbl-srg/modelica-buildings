/*
 *
 * \file   cfdCloseThread.c
 *
 * \brief  Function to stop the cosimualtion and close the thread
 *
 * \author Tian Wei
 *         University of Miami
 *         W.tian@miami.edu
 * \date   2/13/2018
 *
 */
#include "cfdCosimulation.h"
int cfdCloseThread(void *thread) {
	size_t i = 0;
	int imax = 10000;
	
	cosim->para->flag = 0;
	
	while(cosim->para->flag==0 && i<imax) {
    if(cosim->para->ffdError==1) {
      ModelicaError(cosim->ffd->msg);
    }
    else {
      sleep(10);
      i++;
    }
  }

  if(i<imax) {
    if(cosim->para->ffdError==1) {
      ModelicaError(cosim->ffd->msg);
    }
    else {
      ModelicaMessage("Successfully stopped the FFD simulation.\n");
    }
  }
  else {
    ModelicaError("Error: Cannot stop the FFD simulation in required time.");
  }
	
/* Windows*/
#ifdef _MSC_VER
	CloseHandle(thread);
/*  Linux*/
#else
  pthread_cancel(thread);
#endif
	
	return 0;
}