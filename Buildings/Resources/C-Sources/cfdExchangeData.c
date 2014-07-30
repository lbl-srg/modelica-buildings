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
///\param dt Time step size for next synchronization defined by Modelica
///\param u Pointer to the input data from Modelica to CFD
///\param nU Number of inputs from Modelica to CFD
///\param nY Number of outputs from CFD to Modelica
///\param y Pointer to the output data from CFD to Modelica
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int cfdExchangeData(double t0, double dt, double *u, int nU, int nY,
                 double *t1, double *y) {
  int i, j, k, imax = 10000;
  int verbose = 0;
  sprintf(msg,"---------------------------------------------------\n");
  ModelicaMessage(msg);

  /*--------------------------------------------------------------------------
  | Write data to CFD
  | Command: 
  | -1: feak data
  |  0: data has been read by the other program
  |  1: data waiting for the other program to read
  --------------------------------------------------------------------------*/
  // If previous data hasn't been read, wait
  while(cosim->modelica->flag==1) {
    if(cosim->para->ffdError==1) {
	  sprintf(msg,"CFD exited with error");
      ModelicaMessage(msg);
      return -1;
    }
    else {
      if(verbose==1) {
	    sprintf(msg, "cfdExchangeData(): Waiting for the CFD to read my data.\n");
        ModelicaMessage(msg);
		}
		
      Sleep(1000);
    }
  }

  if(verbose==1) {
    sprintf(msg, "cfdExchangeData(): Start to write data");
    ModelicaMessage(msg);
	}
	
  cosim->modelica->t = (REAL) t0;
  cosim->modelica->dt = (REAL) dt;


  sprintf(msg, "cfdExchangeData(): write data at %f with dt=%f\n", 
         cosim->modelica->t, cosim->modelica->dt);
  ModelicaMessage(msg);

  if(verbose==1) {
    sprintf(msg,"cfdExchangeData(): number of input variables nU=%d\n", nU);
	ModelicaMessage(msg);
    sprintf(msg,"cfdExchangeData(): number of output variables nY=%d\n", nY);
	ModelicaMessage(msg);
  }

  // Copy the Modelica data to shared memory
  for(i=0; i<cosim->para->nSur; i++) {
    cosim->modelica->temHea[i] = (REAL) u[i];
    if(verbose==1) {
      sprintf(msg, "temHea[%d] = %f\n", i, cosim->modelica->temHea[i]);
      ModelicaMessage(msg);	
    }   	  
  }

  if(cosim->para->sha==1) {
    if(verbose==1) {
      sprintf(msg, "Set shade conditions for %d windows\n", cosim->para->nConExtWin);
	  ModelicaMessage(msg);
    }
    for(j=0; j<cosim->para->nConExtWin; j++) {
      cosim->modelica->shaConSig[j] = (REAL) u[i+j];
      cosim->modelica->shaAbsRad[j] = (REAL) u[i+j+cosim->para->nConExtWin];
      if(verbose==1) {
        sprintf(msg, "shaConSig[%d] = %f, shaAbsRad[%d] = %f\n", 
               j, cosim->modelica->shaConSig[j],
               j, cosim->modelica->shaAbsRad[j]);
		ModelicaMessage(msg);}
    }
    i = i + 2*cosim->para->nConExtWin;
  }

  cosim->modelica->sensibleHeat = (REAL) u[i]; 
  if(verbose==1) {
    sprintf(msg, "sensibleHeat = %f\n", cosim->modelica->sensibleHeat);
	ModelicaMessage(msg);
	}
  i++;
  
  cosim->modelica->latentHeat = (REAL) u[i];
  if(verbose==1) {
    sprintf(msg, "latentHeat = %f\n", cosim->modelica->latentHeat);
	ModelicaMessage(msg);
	}
  i++;

  cosim->modelica->p = (REAL) u[i];
  if(verbose==1) {
    sprintf(msg, "p = %f\n", cosim->modelica->p);
	ModelicaMessage(msg);
	}
  i++;
 
  for(j=0; j<cosim->para->nPorts; j++) {
    cosim->modelica->mFloRatPor[j] = (REAL) u[i+j];
    if(verbose==1) {
      sprintf(msg,"mFloRatPor[%d] = %f\n", j, cosim->modelica->mFloRatPor[j]);
	  ModelicaMessage(msg);
    }
    cosim->modelica->TPor[j] = (REAL) u[i+j+cosim->para->nPorts];
    if(verbose==1) {
	  sprintf(msg, "TPor[%d] = %f\n", j, cosim->modelica->TPor[j]);
	  ModelicaMessage(msg);
	  }
  }

  i = i + 2*cosim->para->nPorts;
  for(j=0; j<cosim->para->nPorts; j++)
    for(k=0; k<cosim->para->nXi; k++) {
      cosim->modelica->XiPor[j][k] = (REAL) u[i+j*cosim->para->nXi+k];
      if(verbose==1) {
        sprintf(msg, "XiPor[%d][%d] = %f\n", j, k, cosim->modelica->XiPor[j][k]);
		ModelicaMessage(msg);
		}
    }

  i = i + cosim->para->nPorts*cosim->para->nXi;
  for(j=0; j<cosim->para->nPorts; j++)
    for(k=0; k<cosim->para->nC; k++) {
      cosim->modelica->CPor[j][k] = (REAL) u[i+j*cosim->para->nC+k];
      if(verbose==1) {
        sprintf(msg, "CPor[%d][%d] = %f\n", j, k, cosim->modelica->CPor[j][k]);
		ModelicaMessage(msg);
		}
    }
  
  // Set the flag to new data
  cosim->modelica->flag = 1;
  if(verbose==1) {
    sprintf(msg, "cosim->modelica->flag = %d\n", cosim->modelica->flag);
	ModelicaMessage(msg);
  }
  /****************************************************************************
  | Copy data from CFD
  ****************************************************************************/
  if(verbose==1) {
    sprintf(msg, "Start to get cosim-ffd->flag.\n");
    ModelicaMessage(msg);
  }

  // If the data is not ready or not updated, check again
  while(cosim->ffd->flag!=1) {
    if(cosim->para->ffdError==1) {
	  sprintf(msg, "CFD exited with error");
      ModelicaMessage(msg);
      return -1;
    }
    else
      Sleep(1000);
  }

  if(verbose==1) {
    sprintf(msg, "Start to get CFD Data: cosim->ffd->flag = %f\n", cosim->ffd->flag);
	ModelicaMessage(msg);
  }
  // Get the temperature/heat flux for solid surface
  for(i=0; i<cosim->para->nSur; i++) {
    y[i] = cosim->ffd->temHea[i];
    sprintf(msg, "y[%d]=%f\n", i, y[i]);
	ModelicaMessage(msg);
  }

  // Get the averaged room temperature
  y[i] = cosim->ffd->TRoo;
  sprintf(msg, "y[%d]=%f\n", i, y[i]);
  ModelicaMessage(msg);
  i++;

  // Get the temperature of shading device if there is a shading device
  if(cosim->para->sha==1) {
    for(j=0; j<cosim->para->nConExtWin; i++, j++) {
      y[i] = cosim->ffd->TSha[j];
      sprintf(msg, "y[%d]=%f\n", i, y[i]);
	  ModelicaMessage(msg);
    }
  }

  // Get the temperature fluid at the fluid ports
  for(j=0; j<cosim->para->nPorts; i++, j++) {
    y[i] = cosim->ffd->TPor[j];
    sprintf(msg, "y[%d]=%f\n", i, y[i]);
	ModelicaMessage(msg);
  }

  // Get the mass fraction at fluid ports
  for(j=0; j<cosim->para->nPorts; j++)
    for(k=0; k<cosim->para->nXi; k++, i++) {
       y[i] = cosim->ffd->XiPor[j][k];
       sprintf(msg, "y[%d]=%f\n", i, y[i]);
	   ModelicaMessage(msg);
    }
  // Get the trace substance at fluid ports
  for(j=0; j<cosim->para->nPorts; j++)
    for(k=0; k<cosim->para->nC; k++, i++) {
       y[i] = cosim->ffd->CPor[j][k];
       sprintf(msg, "y[%d]=%f\n", i, y[i]);
	   ModelicaMessage(msg);
    }

  // Get the sensor data
  for(j=0; j<cosim->para->nSen; j++, i++) {
    y[i] = cosim->ffd->senVal[j];
    sprintf(msg, "y[%d]=%f\n", i, y[i]);
	ModelicaMessage(msg);
  }

  if(verbose==1) {
    sprintf(msg, "\n CFD: \t\ttime=%f, status=%d\n", cosim->ffd->t, cosim->ffd->flag);
	ModelicaMessage(msg);
    sprintf(msg, "Modelica: \ttime=%f, status=%d\n", cosim->modelica->t, cosim->modelica->flag);
	ModelicaMessage(msg);
  }

  // Update the data status
  cosim->ffd->flag = 0;

  *t1 = cosim->ffd->t;

  return 0;
} // End of cfdExchangeData()
