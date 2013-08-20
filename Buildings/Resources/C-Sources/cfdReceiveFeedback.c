///////////////////////////////////////////////////////////////////////////////
///
/// \file   cfdReceiveFeedback.c
///
/// \brief  Functions to receive the feedback from CFD about teh stop command
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
/// Receive the feedback from CFD about teh stop command
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int cfdReceiveFeedback( ) {
  int i = 0, imax = 10000, flag;
  
  // Wait for the feedback from FFD
  while(cosim->para->flag==0 && i<imax) {
    Sleep(10000);
    i++;
  }
  
  if(i<imax) {
    printf("Successfully stopped the FFD simulation.\n");
    flag = 0;
  }
  else {
    printf("stopFFD(): Could not stop the FFD simulation in reqruied time.\n");
    flag = 1;
  }

  free(cosim->para);
  free(cosim->modelica);
  free(cosim->ffd);
  free(cosim);

  return flag;
} // End of cfdReceiveFeedback()