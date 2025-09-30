/*
 *
 * \file   cfdSendStopCommand.c
 *
 * \brief  Function to send a stop command to terminate the CFD simulation
 *
 * \author Wangda Zuo
 *         University of Miami
 *         W.Zuo@miami.edu
 *
 * \date   8/3/2013
 *
 */
#include "ModelicaUtilities.h"

#include "cfdCosimulation.h"

/*
 * Send a stop command to terminate the CFD simulation
 *
 * @return No return needed
 */
void cfdSendStopCommand(void *thread) {

  size_t i = 0;
  size_t imax = 1000000;

  /*send stop command to FFD*/
  cosim->para->flag = 0;

  /* Wait for the feedback from FFD*/
 while(cosim->para->flag==0 && i<imax) {
    if(cosim->para->ffdError==1) {
      ModelicaError(cosim->ffd->msg);
    }
    else {
      Sleep(10);
      i++;
    }
  }

  if (i<imax) {
    if (cosim->para->ffdError==1) {
      ModelicaError(cosim->ffd->msg);
    }
    else {
      ModelicaMessage("Successfully stopped the FFD simulation.\n");
    }
  }
  else {
    ModelicaMessage("Error: Cannot stop the FFD simulation in required time.");
  }

  /*free memory for variables*/
  if (cosim->para->fileName != NULL) {
    free(cosim->para->fileName);
  }
  if (cosim->para->are != NULL) {
    free(cosim->para->are);
  }
  if (cosim->para->til != NULL) {
    free(cosim->para->til);
  }
  if (cosim->para->bouCon != NULL) {
    free(cosim->para->bouCon);
  }
  if (cosim->para->nSur>0) {
    for(i=0; i<cosim->para->nSur; i++) {
      free(cosim->para->name[i]);
    }
    if (cosim->para->name != NULL) {
      free(cosim->para->name);
    }
  }
  if (cosim->para->nSen>0) {
    if (cosim->ffd->senVal != NULL) {
      free(cosim->ffd->senVal);
    }
    for(i=0; i<cosim->para->nSen; i++) {
      free(cosim->para->sensorName[i]);
    }
    if (cosim->para->sensorName != NULL) {
      free(cosim->para->sensorName);
    }
  }
  if (cosim->modelica->temHea != NULL) {
    free(cosim->modelica->temHea);
  }
  if (cosim->para->sha==1) {
    if (cosim->modelica->shaConSig != NULL) {
      free(cosim->modelica->shaConSig);
    }
    if (cosim->modelica->shaAbsRad != NULL) {
      free(cosim->modelica->shaAbsRad);
    }
    if (cosim->ffd->TSha != NULL) {
      free(cosim->ffd->TSha);
    }
  }
  if (cosim->para->nPorts>0) {
    for(i=0; i<cosim->para->nPorts; i++) {
      free(cosim->modelica->XiPor[i]);
      free(cosim->ffd->XiPor[i]);
      free(cosim->modelica->CPor[i]);
      free(cosim->ffd->CPor[i]);
    }
    if (cosim->modelica->CPor != NULL) {
      free(cosim->modelica->CPor);
    }
    if (cosim->ffd->CPor != NULL) {
      free(cosim->ffd->CPor);
    }
    if (cosim->modelica->XiPor != NULL) {
      free(cosim->modelica->XiPor);
    }
    if (cosim->ffd->XiPor != NULL) {
      free(cosim->ffd->XiPor);
    }
    if (cosim->modelica->TPor != NULL) {
      free(cosim->modelica->TPor);
    }
    if (cosim->ffd->TPor != NULL) {
      free(cosim->ffd->TPor);
    }
    for(i=0; i<cosim->para->nPorts; i++) {
      free(cosim->para->portName[i]);
    }
    if (cosim->para->portName != NULL) {
      free(cosim->para->portName);
    }
    if (cosim->modelica->mFloRatPor != NULL) {
      free(cosim->modelica->mFloRatPor);
    }
  }
  if (cosim->ffd->temHea != NULL) {
    free(cosim->ffd->temHea);
  }

  if (cosim->para->nSou>0) {
    if (cosim->para->souName != NULL) {
      free(cosim->para->souName);
    }
    if (cosim->modelica->sourceHeat != NULL) {
      free(cosim->modelica->sourceHeat);
    }
  }

  if (cosim->para != NULL) {
    free(cosim->para);
  }
  if (cosim->modelica != NULL) {
    free(cosim->modelica);
  }
  if (cosim->ffd != NULL) {
    free(cosim->ffd);
  }
  if (cosim != NULL) {
    free(cosim);
  }

} /* End of cfdSendStopCommand*/
