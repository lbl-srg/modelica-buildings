///////////////////////////////////////////////////////////////////////////////
///
/// \file   cfdExchangeData.c
///
/// \brief  Function to exchange data between Modelica and CFD
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
/// Exchange the data between Modelica and CFD
///
///\param t0 Current time of integration for Modelica
///\param dt Time step size for next synchronization define dby Modelica
///\param u Pointer to the input data from Modleica to CFD
///\param nU Number of inputs from Modelica to CFD
///\param nY Number of outputs from CFD to Modelica
///\param y Pointer to the output data from CFD to Modelica
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int cfdExchangeData(double t0, double dt, double *u, int nU, int nY,
                 double *t1, double *y) {
  int i, j, k, imax = 10000;
  
  printf("---------------------------------------------------\n");
  printf("exchangeData(): start to exchagne data at t=%f\n", t0);
  /*--------------------------------------------------------------------------
  | Write data to FFD
  | Command: 
  | -1: feak data
  |  0: data has been read by the other program
  |  1: data waiting for the other program to read
  --------------------------------------------------------------------------*/
  // If previous data hasn't been read, wait
  while(cosim->modelica->flag==1) {
    if(cosim->para->ffdError==1) {
      printf("FFD exited with error");
      return -1;
    }
    else {
      printf("exchangeData(): Waiting for the FFD to read my data.\n");
      Sleep(1000);
    }
  }

  printf("exchangeData(): Start to write data");
  cosim->modelica->t = (float) t0;
  cosim->modelica->dt = (float) dt;

  printf("exchangeData():: wrtie data at %f with dt=%f\n", 
         cosim->modelica->t, cosim->modelica->dt);

  // Copy the modelica data to shared memory
  for(i=0; i<cosim->para->nSur; i++) {
    cosim->modelica->temHea[i] = (float) u[i];
    printf("temHea[%d] = %f\n", i, cosim->modelica->temHea[i]); 
  }

  if(cosim->para->sha==1)
    for(j=0; j<cosim->para->nConExtWin; j++) {
      cosim->modelica->shaConSig[j] = (float) u[i+j];
      cosim->modelica->shaAbsRad[j] = (float) u[i+j+cosim->para->nConExtWin];
      printf("shaConSig[%d] = %f, shaAbsRad[%d] = %f\n", 
             cosim->modelica->shaConSig[j],
             cosim->modelica->shaAbsRad[j]);
    }
  i = i + 2*cosim->para->nConExtWin;
  
  cosim->modelica->heaConvec = (float) u[i]; 
  printf("heaConvec = %f\n", cosim->modelica->heaConvec);
  i++;
  
  cosim->modelica->latentHeat = (float) u[i];
  i++;

  cosim->modelica->p = (float) u[i];
  i++;
 
  for(j=0; j<cosim->para->nPorts; j++) {
    cosim->modelica->mFloRatPor[j] = (float) u[i+j];    
    cosim->modelica->TPor[j] = (float) u[i+j+cosim->para->nPorts];
  }

  i = i + 2*cosim->para->nPorts;
  for(j=0; j<cosim->para->nPorts; j++)
    for(k=0; k<cosim->para->nXi; k++)
      cosim->modelica->XiPor[j][k] = (float) u[i+j*cosim->para->nXi+k];

  i = i + cosim->para->nPorts*cosim->para->nXi;
  for(j=0; j<cosim->para->nPorts; j++)
    for(k=0; k<cosim->para->nC; k++)
    cosim->modelica->CPor[j][k] = (float) u[i+j*cosim->para->nC+k];

  // Set the flag to new data
  cosim->modelica->flag = 1;

  /*-----------------------------------------------------------------------
  | Copy data from CFD
  ------------------------------------------------------------------------*/
  // If the data is not ready or not updated, check again
  while(cosim->ffd->flag!=1) {
    if(cosim->para->ffdError==1) {
      printf("FFD exited with error");
      return -1;
    }
    else
      Sleep(1000);
  }


  for(i=0; i<cosim->para->nSur; i++) 
    y[i] = cosim->ffd->temHea[i];

  y[i] = cosim->ffd->TRoo;
  
  if(cosim->para->sha==1)
    for(j=0; j<cosim->para->nConExtWin; j++) {
      y[i+j] = cosim->ffd->TSha[j];
    }

  i = i + cosim->para->nConExtWin;

  for(j=0; j<cosim->para->nPorts; j++)
    y[j+i] = cosim->ffd->TPor[j];

  i = i + cosim->para->nPorts;

  for(j=0; j<cosim->para->nPorts; j++)
    for(k=0; k<cosim->para->nXi; k++)
       y[i+j*cosim->para->nXi+k] = cosim->ffd->XiPor[j][k];
  
  i = i + cosim->para->nPorts*cosim->para->nC;
  for(j=0; j<cosim->para->nPorts; j++)
    for(k=0; k<cosim->para->nC; k++)
       y[i+j*cosim->para->nC+k] = cosim->ffd->CPor[j][k];

  printf("\n FFD: \t\ttime=%f, status=%d\n", cosim->ffd->t, cosim->ffd->flag);
  printf("Modelica: \ttime=%f, status=%d\n", cosim->modelica->t, cosim->modelica->flag);

  // Update the data status
  cosim->ffd->flag = 0;

  *t1 = cosim->ffd->t;
  for(i=0; i<nY; i++)
    y[i] = 273.15;

  return 0;
} // End of cfdExchangeData()