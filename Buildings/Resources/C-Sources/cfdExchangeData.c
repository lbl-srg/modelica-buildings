/*
 *
 * \file   cfdExchangeData.c
 *
 * \brief  Function to exchange data between Modelica and CFD
 *
 * \author Wangda Zuo
 *         University of Miami
 *         W.Zuo@miami.edu
 *
 * \date   8/3/2013
 *
 */
#include "cfdCosimulation.h"

#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#include "ModelicaUtilities.h"

/*
 * Exchange the data between Modelica and CFD
 *
 * @param t0 Current time of integration for Modelica
 * @param dt Time step size for next synchronization defined by Modelica
 * @param u Pointer to the input data from Modelica to CFD
 * @param nU Number of inputs from Modelica to CFD
 * @param nY Number of outputs from CFD to Modelica
 * @param y Pointer to the output data from CFD to Modelica
 *
 * @return 0 if no error occurred
 */
int cfdExchangeData(double t0, double dt, const double *u, size_t nU, size_t nY,
                 double *t1, double *y) {
  size_t i, j, k;

  /*check if current modelica time equals to last time*/
  /*if yes, it means cfdExchangeData() was called multiple times at one synchronization point, then directly return*/
  if(fabs(cosim->modelica->lt - t0) < 1E-6){
    return 0;
  }

  /*--------------------------------------------------------------------------
  | Write data to CFD
  | Command:
  | -1: fake data
  |  0: data has been read by the other program
  |  1: data waiting for the other program to read
  --------------------------------------------------------------------------*/
  /* If previous data hasn't been read, wait*/
  while(cosim->modelica->flag==1) {
    if(cosim->para->ffdError==1)
      ModelicaError(cosim->ffd->msg);
    else
      Sleep(10);
  }

  cosim->modelica->t = t0;
  cosim->modelica->dt = dt;
  cosim->modelica->lt = t0;

  /* Copy the Modelica data to shared memory*/
  for(i=0; i<cosim->para->nSur; i++) {
    cosim->modelica->temHea[i] = u[i];
  }

  if(cosim->para->sha==1) {
    for(j=0; j<cosim->para->nConExtWin; j++) {
      cosim->modelica->shaConSig[j] = u[i+j];
      cosim->modelica->shaAbsRad[j] = u[i+j+cosim->para->nConExtWin];
    }
    i = i + 2*cosim->para->nConExtWin;
  }

  cosim->modelica->sensibleHeat = u[i];
  i++;

  cosim->modelica->latentHeat = u[i];
  i++;

  cosim->modelica->p = u[i];
  i++;

  for(j=0; j<cosim->para->nPorts; j++) {
    cosim->modelica->mFloRatPor[j] = u[i+j];
    cosim->modelica->TPor[j] = u[i+j+cosim->para->nPorts];
  }

  i = i + 2*cosim->para->nPorts;
  for(j=0; j<cosim->para->nPorts; j++)
    for(k=0; k<cosim->para->nXi; k++) {
      cosim->modelica->XiPor[j][k] = u[i+j*cosim->para->nXi+k];
    }

  i = i + cosim->para->nPorts*cosim->para->nXi;
  for(j=0; j<cosim->para->nPorts; j++)
    for(k=0; k<cosim->para->nC; k++) {
      cosim->modelica->CPor[j][k] = u[i+j*cosim->para->nC+k];
    }

  /* Set the flag to new data*/
  cosim->modelica->flag = 1;

  /****************************************************************************
  | Copy data from CFD
  ****************************************************************************/
  /* If the data is not ready or not updated, check again*/
  while(cosim->ffd->flag!=1) {
    if(cosim->para->ffdError==1)
      ModelicaError(cosim->ffd->msg);
    else
      Sleep(10);
  }

  /* Get the temperature/heat flux for solid surface*/
  for(i=0; i<cosim->para->nSur; i++) {
    y[i] = cosim->ffd->temHea[i];
  }

  /* Get the averaged room temperature*/
  y[i] = cosim->ffd->TRoo;
  i++;

  /* Get the temperature of shading device if there is a shading device*/
  if(cosim->para->sha==1) {
    for(j=0; j<cosim->para->nConExtWin; i++, j++) {
      y[i] = cosim->ffd->TSha[j];
    }
  }

  /* Get the temperature fluid at the fluid ports*/
  for(j=0; j<cosim->para->nPorts; i++, j++) {
    y[i] = cosim->ffd->TPor[j];
  }

  /* Get the mass fraction at fluid ports*/
  for(j=0; j<cosim->para->nPorts; j++)
    for(k=0; k<cosim->para->nXi; k++, i++) {
       y[i] = cosim->ffd->XiPor[j][k];
    }

  /* Get the trace substance at fluid ports*/
  for(j=0; j<cosim->para->nPorts; j++)
    for(k=0; k<cosim->para->nC; k++, i++) {
       y[i] = cosim->ffd->CPor[j][k];
    }

  /* Get the sensor data*/
  for(j=0; j<cosim->para->nSen; j++, i++) {
    y[i] = cosim->ffd->senVal[j];
  }

  /* Update the data status*/
  cosim->ffd->flag = 0;

  *t1 = cosim->ffd->t;

  return 0;
} /* End of cfdExchangeData()*/
