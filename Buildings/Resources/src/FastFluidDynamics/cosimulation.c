/*
	*
	* \file   cosimulation.c
	*
	* \brief  Functions for cosimulation
	*
	* \author Wangda Zuo
	*         University of Miami
	*         W.Zuo@miami.edu
	*         Xu Han
	*         University of Colorado Boulder
	*         xuha3556@colorado.edu	
	*         Tian Wei
	*         University of Miami
	*         W.tian@miami.edu	
	*	      Cary Faulkner
	*         University of Colorado Boulder
	*	      cary.faulkner@colorado.edu
	*
	* \date   4/13/2020
	*
	* This file provides functions that are used for conducting the coupled simulation
	* with Modelica
	*
	*/

#include "cosimulation.h"

/*
	* Read the coupled simulation parameters defined by Modelica
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param BINDEX pointer to boundary index
	*
	* @return 0 if no error occurred
	*/
int read_cosim_parameter(PARA_DATA *para, REAL **var, int **BINDEX) {
  int i;

  ffd_log("-------------------------------------------------------------------",
          FFD_NORMAL);
  if(para->outp->version==DEBUG) {
    ffd_log("read_cosim_parameter(): "
            "Received the following coupled simulation parameters:",
             FFD_NORMAL);
  }

  /****************************************************************************
  | Compare number of solid surface boundaries
  | (Wall, Window Glass with and without shading, and Window Frame)
  ****************************************************************************/
  if(para->cosim->para->nSur==para->bc->nb_wall) {
    sprintf(msg, "\tnSur=%d", para->cosim->para->nSur);
    ffd_log(msg, FFD_NORMAL);
  }
  else {
    sprintf(msg,
            "read_cosim_parameter(): Modelica(%d) and FFD(%d) "
            "have different numbers of solid surfaces.",
            para->cosim->para->nSur, para->bc->nb_wall);
    ffd_log(msg, FFD_ERROR);
    ffd_log("\tModelica Surfaces are:", FFD_NORMAL);
    for(i=0; i<para->cosim->para->nSur; i++) {
      sprintf(msg, "\t\t%s", para->cosim->para->name[i]);
      ffd_log(msg, FFD_NORMAL);
    }
    ffd_log("\tFFD Surfaces are:", FFD_NORMAL);
    for(i=0; i<para->bc->nb_wall; i++) {
      sprintf(msg, "\t\t%s", para->bc->wallName[i]);
      ffd_log(msg, FFD_NORMAL);
    }
    return 1;
  }

  /****************************************************************************
  | Compare the number of fluid ports
  ****************************************************************************/
  if(para->cosim->para->nPorts==para->bc->nb_port) {
    sprintf(msg, "\tnPorts=%d", para->cosim->para->nPorts);
    ffd_log(msg, FFD_NORMAL);
  }
  else {
    sprintf(msg,
            "read_cosim_parameter(): Modelica(%d) and FFD(%d) "
            "have different number of fluid ports.",
            para->cosim->para->nPorts, para->bc->nb_port);
    ffd_log(msg, FFD_ERROR);
    return 1;
  }

  /****************************************************************************
  | Compare the number of sensors
  ****************************************************************************/
  if(para->cosim->para->nSen==para->sens->nb_sensor) {
    sprintf(msg, "\tnSen=%d", para->cosim->para->nSen);
    ffd_log(msg, FFD_NORMAL);
  }
  else {
    sprintf(msg,
            "read_cosim_parameter(): Modelica(%d) and FFD(%d) "
            "have different number of sensors.",
            para->cosim->para->nSen, para->sens->nb_sensor);
    ffd_log(msg, FFD_ERROR);
    return 1;
  }

  /****************************************************************************
  | Compare the number of species
  ****************************************************************************/
  if(para->cosim->para->nXi==para->bc->nb_Xi) {
    sprintf(msg, "\tnXi=%d", para->cosim->para->nXi);
    ffd_log(msg, FFD_NORMAL);
  }
  else {
    sprintf(msg,
            "read_cosim_parameter(): Modelica(%d) and FFD(%d) "
            "have different number of species.",
            para->cosim->para->nXi, para->bc->nb_Xi);
    ffd_log(msg, FFD_ERROR);
    return 1;
  }

  /****************************************************************************
  | Compare the number of trace substances
  ****************************************************************************/
  if(para->cosim->para->nC==para->bc->nb_C) {
    sprintf(msg, "\tnC=%d", para->cosim->para->nC);
    ffd_log(msg, FFD_NORMAL);
  }
  else {
    sprintf(msg,
            "read_cosim_parameter(): Modelica(%d) and FFD(%d) "
            "have different number of substances.",
            para->cosim->para->nC, para->bc->nb_C);
    ffd_log(msg, FFD_ERROR);
    return 1;
  }

  sprintf(msg, "\tnConExtWin=%d", para->cosim->para->nConExtWin);
  ffd_log(msg, FFD_NORMAL);

  sprintf(msg, "\tsha=%d", para->cosim->para->sha);
  ffd_log(msg, FFD_NORMAL);

  /****************************************************************************
  | Print the information for surface boundaries
  ****************************************************************************/
  for(i=0; i<para->cosim->para->nSur; i++) {
    sprintf(msg, "\tSurface %d: %s", i, para->cosim->para->name[i]);
    ffd_log(msg, FFD_NORMAL);
    sprintf(msg, "\t\tArea:%f[m2],\t Tilt:%f[deg]",
            para->cosim->para->are[i], para->cosim->para->til[i]);
    ffd_log(msg, FFD_NORMAL);
    switch (para->cosim->para->bouCon[i]) {
      case 1:
        ffd_log("\t\tThermal boundary: Fixed temperature", FFD_NORMAL);
        break;
      case 2:
        ffd_log("\t\tThermal boundary: Fixed heat flux", FFD_NORMAL);
        break;
      default:
        sprintf(msg,
        "Invalid value (%d) for thermal boundary condition. "
        "1: Fixed T; 2: Fixed heat flux",
        para->cosim->para->bouCon[i]);
        ffd_log(msg, FFD_ERROR);
        return 1;
    }
  }

  for(i=0; i<para->cosim->para->nPorts; i++) {
    sprintf(msg, "\tFluid Ports %d: %s", i, para->cosim->para->portName[i]);
    ffd_log(msg, FFD_NORMAL);
  }

  for(i=0; i<para->cosim->para->nSen; i++) {
    sprintf(msg, "\tSensor %d: %s", i, para->cosim->para->sensorName[i]);
    ffd_log(msg, FFD_NORMAL);
  }

  /****************************************************************************
  | Compare name and surface area of boundaries
  ****************************************************************************/
  if(compare_boundary_names(para)!=0) {
    ffd_log("read_cosim_parameter(): The boundary names were not consistent.",
    FFD_ERROR);
    return 1;
  }
  else if(compare_boundary_area(para, var, BINDEX)!=0) {
    ffd_log("read_cosim_parameter(): The boundary areas were not consistent.",
    FFD_ERROR);
    return 1;
  }

  /****************************************************************************
  | Get the start time of co-simulation
  ****************************************************************************/
  para->mytime->t = para->cosim->modelica->t;
  sprintf(msg, "read_cosim_parameter(): Simulation starts at %fs",
          para->mytime->t);
  ffd_log(msg, FFD_NORMAL);

  /****************************************************************************
  | Get the air density if there is a fluid port
  ****************************************************************************/
  if(para->bc->nb_port>0 && para->prob->rho!=para->cosim->para->rho_start) {
    sprintf(msg, "read_cosim_parameter(): Overwrite the density of air "
           "%f kg/m3 with %f kg/m3", para->prob->rho,
           para->cosim->para->rho_start);
    para->prob->rho = para->cosim->para->rho_start;
    ffd_log(msg, FFD_NORMAL);
  }

  return 0;
} /* End of read_cosim_parameter()*/

	/*
		* Read the data from Modelica
		*
		* @param para Pointer to FFD parameters
		* @param var Pointer to FFD simulation variables
		* @param BINDEX pointer to boundary index
		*
		* @return 0 if no error occurred
		*/
int read_cosim_data(PARA_DATA *para, REAL **var, int **BINDEX) {
  int i;

  ffd_log("-------------------------------------------------------------------",
          FFD_NORMAL);
  if(para->outp->version==DEBUG) {
    ffd_log("read_cosim_data(): Start to read data from Modelica.",
            FFD_NORMAL);
  }
  /****************************************************************************
  | Wait for data to be updated by the other program
  ****************************************************************************/
  while(para->cosim->modelica->flag==0) {
    if(para->outp->version==DEBUG) {
      sprintf(msg,
              "read_cosim_data(): Data is not ready with "
              "para->cosim->modelica->flag=%d",
              para->cosim->modelica->flag);
      ffd_log(msg, FFD_NORMAL);
    }
	/*return when detecting stop command*/
	if (para->cosim->para->flag==0){
			return 0;
	}		
		
    Sleep(10);
    if(para->outp->version==DEBUG)
      ffd_log("read_cosim_data(): Sleep for 0.01s.", FFD_NORMAL);
  }

  if(para->outp->version==DEBUG) {
    ffd_log("read_cosim_data(): Modelica data is ready.", FFD_NORMAL);
    sprintf(msg,
            "read_cosim_data(): Received the following data at t=%f[s]",
            para->cosim->modelica->t);
    ffd_log(msg, FFD_NORMAL);
  }

  /****************************************************************************
  | Read and assign the thermal boundary conditions
  ****************************************************************************/
  if(assign_thermal_bc(para,var,BINDEX)!=0) {
     ffd_log("read_cosim_data(): Could not assign the Modelica thermal data to FFD",
            FFD_ERROR);
    return 1;
  }

  /****************************************************************************
  | Read and assign the shading boundary conditions
  | Warning: This is not used in current version
  ****************************************************************************/
  if(para->cosim->para->sha==1) {
    ffd_log("Shading control signal and adsorbed radiation by the shade:",
            FFD_NORMAL);
    for(i=0; i<para->cosim->para->nConExtWin; i++) {
      sprintf(msg, "Surface[%d]: %f,\t%f\n",
              i, para->cosim->modelica->shaConSig[i],
              para->cosim->modelica->shaAbsRad[i]);
      ffd_log(msg, FFD_NORMAL);
    }
  }
  else
    if(para->outp->version==DEBUG) {
      ffd_log("\tNo shading devices.", FFD_NORMAL);
    }

  /****************************************************************************
  | Read and assign the inlet conditions
  ****************************************************************************/
  if(para->cosim->para->nPorts>0) {
    if(assign_port_bc(para,var,BINDEX)!=0) {
      ffd_log(" read_cosim_data(): Could not assign the Modelica inlet BC to FFD",
      FFD_ERROR);
      return 1;
    }
  }
  else
    if(para->outp->version==DEBUG) {
       ffd_log("\tNo fluid ports.", FFD_NORMAL);
    }

  /****************************************************************************
  | Post-Process after reading the data
  ****************************************************************************/
  /* Change the flag to indicate that the data has been read*/
  para->cosim->modelica->flag = 0;
  if(para->outp->version==DEBUG) {
    ffd_log("read_cosim_data(): Ended reading data from Modelica.",
            FFD_NORMAL);
  }

  return 0;
} /* End of read_cosim_data()*/

/*
	* Write the FFD data for Modelica
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	*
	* @return 0 if no error occurred
	*/
int write_cosim_data(PARA_DATA *para, REAL **var) {
  int i, j, id;

  ffd_log("-------------------------------------------------------------------",
          FFD_NORMAL);
  if(para->outp->version==DEBUG) {
    ffd_log("write_cosim_parameter(): "
            "Start to write the following coupled simulation data to Modelica:",
             FFD_NORMAL);
  }

  /****************************************************************************
  | Wait if the previous data has not been read by Modelica
  ****************************************************************************/
  while(para->cosim->ffd->flag==1) {
    ffd_log("write_cosim_data(): Wait since previous data is not taken "
            "by Modelica", FFD_NORMAL);
    Sleep(10);
  }

  /****************************************************************************
  | Start to write new data
  ****************************************************************************/
  para->cosim->ffd->t = para->mytime->t;

  sprintf(msg, "write_cosim_data(): Start to write FFD data to Modelica "
               "at t=%f[s]",
          para->cosim->ffd->t);
  ffd_log(msg, FFD_NORMAL);

  /****************************************************************************
  | Set the time and space averaged temperature of space
  | Convert T from degC to K
  ****************************************************************************/
  para->cosim->ffd->TRoo = average_volume(para, var, var[TEMPM]);
  sprintf(msg, "\tAveraged room temperature %f[degC]", para->cosim->ffd->TRoo);
  para->cosim->ffd->TRoo += 273.15;
  ffd_log(msg, FFD_NORMAL);

  /****************************************************************************
  | Set temperature of shading devices
  ****************************************************************************/
  if(para->cosim->para->sha==1) {
    ffd_log("\tTemperature of the shade:", FFD_NORMAL);
    for(i=0; i<para->cosim->para->nConExtWin; i++) {
      /*Note: The shade feature is to be implemented*/
      para->cosim->ffd->TSha[i] = 20 + 273.15;
      sprintf(msg, "\t\tSurface %d: %f[K]\n",
              i, para->cosim->ffd->TSha[i]);
      ffd_log(msg, FFD_NORMAL);
    }
  }

  /****************************************************************************
  | Set data for fluid ports
  ****************************************************************************/
  ffd_log("\tFlow information at the ports:", FFD_NORMAL);
  for(i=0; i<para->bc->nb_port; i++) {
    /* Get the corresponding ID in Modelica*/
    id = para->bc->portId[i];
    /*-------------------------------------------------------------------------
    | Assign the temperature
    -------------------------------------------------------------------------*/
    para->cosim->ffd->TPor[id] = para->bc->TPortMean[i]/para->bc->APort[i]
                                 + 273.15;
    sprintf(msg, "\t\t%s: TPor[%d]=%f",
            para->cosim->para->portName[id], i,
            para->cosim->ffd->TPor[id]);
    ffd_log(msg, FFD_NORMAL);
    /*-------------------------------------------------------------------------
    | Assign the Xi
    -------------------------------------------------------------------------*/
    if(para->outp->version==DEBUG) {
      sprintf(msg, "\t\t\tn_Xi=%f, id=%d", para->bc->nb_Xi, id);
      ffd_log(msg, FFD_NORMAL);
    }

    for(j=0; j<para->bc->nb_Xi; j++) {
      para->bc->velPortMean[i] = fabs(para->bc->velPortMean[i]) + SMALL;
      para->cosim->ffd->XiPor[id][j] = para->bc->XiPortMean[i][j]
                                      / para->bc->velPortMean[i];

      sprintf(msg, "\t\t%s: Xi[%d]=%f",
              para->cosim->para->portName[id], j,
              para->cosim->ffd->XiPor[id][j]);
      ffd_log(msg, FFD_NORMAL);
    }
    /*-------------------------------------------------------------------------
    | Assign the C
    -------------------------------------------------------------------------*/
    for(j=0; j<para->bc->nb_C; j++) {
      para->bc->velPortMean[i] = fabs(para->bc->velPortMean[i]) + SMALL;
      para->cosim->ffd->CPor[id][j] = para->bc->CPortMean[i][j]
                                    / para->bc->velPortMean[i];
      sprintf(msg, "\t\t%s: C[%d]=%f",
              para->cosim->para->portName[id], j,
              para->cosim->ffd->CPor[id][j]);
      ffd_log(msg, FFD_NORMAL);
    }
  }

  /****************************************************************************
  | Set data for solid surfaces
  ****************************************************************************/
  ffd_log("\tInformation at solid surfaces:", FFD_NORMAL);
  for(i=0; i<para->bc->nb_wall; i++) {
    id = para->bc->wallId[i];

    /* Set the B.C. Temperature*/
    if(para->cosim->para->bouCon[id]==2) {
      para->cosim->ffd->temHea[id] = para->bc->temHeaMean[i]
                                  / para->bc->AWall[i] + 273.15;
      sprintf(msg, "\t\t%s: %f[K]",
              para->cosim->para->name[id], para->cosim->ffd->temHea[id]);
    }
    /* Set the heat flux*/
    else {
      para->cosim->ffd->temHea[id] = para->bc->temHeaMean[i];
      sprintf(msg, "\t\t%s: %f[W]",
              para->cosim->para->name[id], para->cosim->ffd->temHea[id]);
    }
    ffd_log(msg, FFD_NORMAL);
  }

  /****************************************************************************
  | Set data for sensors
  ****************************************************************************/
  if (set_sensor_data(para, var)!=0) {
    ffd_log("\tCould not get sensor data", FFD_ERROR);
    return 1;
  }
  else
    ffd_log("\tSensor Information:", FFD_NORMAL);

  for(i=0; i<para->cosim->para->nSen; i++) {
    para->cosim->ffd->senVal[i] = para->sens->senVal[i];
    sprintf(msg, "\t\t%s: %f",
            para->cosim->para->sensorName[i], para->cosim->ffd->senVal[i]);
    ffd_log(msg, FFD_NORMAL);
  }

  /****************************************************************************
  | Inform Modelica that the FFD data is updated
  ****************************************************************************/
  para->cosim->ffd->flag = 1;

  return 0;
} /* End of write_cosim_data()*/



/*
	* Compare the names of boundaries and store the relationship
	*
	* @param para Pointer to FFD parameters
	*
	* @return 0 if no error occurred
	*/
int compare_boundary_names(PARA_DATA *para) {
  int i, j, flag;

  char **name1 = para->cosim->para->name;
  char **name2 = para->bc->wallName;
  char **name3 = para->cosim->para->portName;
  char **name4 = para->bc->portName;

  /****************************************************************************
  | Compare the names of solid surfaces
  ****************************************************************************/
  for(i=0; i<para->cosim->para->nSur; i++) {
    /*-------------------------------------------------------------------------
    | Assume we do not find the name
    -------------------------------------------------------------------------*/
    flag = 1;

    /*-------------------------------------------------------------------------
    | Check the wall names in FFD
    -------------------------------------------------------------------------*/
    for(j=0; j<para->bc->nb_wall&&flag!=0; j++) {
      flag = strcmp(name1[i], name2[j]);
      /* If found the name*/
      if(flag==0) {
        /* If the same name has been found before*/
        if(para->bc->wallId[j]>0) {
          sprintf(msg, "compare_boundary_names(): Modelica has "
            "the same name \"%s\" for two BCs.", name1[i]);
          ffd_log(msg, FFD_ERROR);
          return 1;
        }
        /* If no same name has been found before, use it*/
        else {
          sprintf(msg,
          "compare_boundary_names(): Matched boundary name \"%s\".",
          name1[i]);
          ffd_log(msg, FFD_NORMAL);
          para->bc->wallId[j] = i;
        }
      } /* End of if(flag==0)*/
    } /* End of for(j=0; j<para->bc->nb_wall&&flag!=0; j++)*/

    /*-------------------------------------------------------------------------
    | Stop if name is not found
    -------------------------------------------------------------------------*/
    if(flag!=0) {
      sprintf(msg, "compare_boundary_names(): Could not find the Modelica "
        " wall boundary \"%s\" in FFD.", name1[i]);
      ffd_log(msg, FFD_ERROR);
      return 1;
    }
  } /* Next Modelica Wall name*/

  /****************************************************************************
  | Compare the names of fluid ports
  ****************************************************************************/
  ffd_log("Start to compare port names", FFD_NORMAL);
  for(i=0; i<para->cosim->para->nPorts; i++) {
    /*-------------------------------------------------------------------------
    | Assume we do not find the name
    -------------------------------------------------------------------------*/
    flag = 1;
    sprintf(msg, "\tModelica: port[%d]=%s", i, name3[i]);
    ffd_log(msg, FFD_NORMAL);
    /*-------------------------------------------------------------------------
    | Check the FFD inlet and outlet names
    -------------------------------------------------------------------------*/
    for(j=0; j<para->bc->nb_port&&flag!=0; j++) {
      flag = strcmp(name3[i], name4[j]);
      sprintf(msg, "\tFFD: port[%d]=%s", j, name4[j]);
      ffd_log(msg, FFD_NORMAL);
      /* If found the name*/
      if(flag==0) {
        /* If the same name has been found before*/
        if(para->bc->portId[j]>0) {
          sprintf(msg,
          "compare_boundary_names(): Modelica has the same name \"%s\" for two BCs.",
          name3[i]);
          ffd_log(msg, FFD_ERROR);
          return 1;
        }
        /* If no same name has been found before, use it*/
        else {
          sprintf(msg,
          "compare_boundary_names(): Matched boundary name \"%s\".",
          name3[i]);
          ffd_log(msg, FFD_NORMAL);
          para->bc->portId[j] = i;
        }
      } /* End of if(flag==0)*/
    }

    /*-------------------------------------------------------------------------
    | Stop if name is not found
    -------------------------------------------------------------------------*/
    if(flag!=0) {
      sprintf(msg, "compare_boundary_names(): Could not find "
        "the Modelica fluid port boundary \"%s\" in FFD.", name3[i]);
      ffd_log(msg, FFD_ERROR);
      return 1;
    }
  } /* Next Modelica port name*/

  return 0;
} /* End of compare_boundary_names()*/

/*
	* Compare the area of boundaries
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to the FFD simulation variables
	* @param BINDEX Pointer to boundary index
	*
	* @return 0 if no error occurred
	*/
int compare_boundary_area(PARA_DATA *para, REAL **var, int **BINDEX) {
  int i, j;
  REAL *A0 = para->bc->AWall, *A1 = para->cosim->para->are;

  ffd_log("compare_boundary_area(): "
          "Start to compare the area of solid surfaces.",
          FFD_NORMAL);
  for(i=0; i<para->bc->nb_wall; i++) {
    j = para->bc->wallId[i];
    if(fabs(A0[i]-A1[j])<SMALL) {
      sprintf(msg, "\t%s has the same area of %f[m2]",
        para->bc->wallName[i], A0[i]);
      ffd_log(msg, FFD_NORMAL);
    }
    else {
      sprintf(msg,
              "compare_boundary_area(): Area of surface %s are different: "
              "Modelica (%f[m2]) and FFD (%f[m2])",
              para->bc->wallName[i], A1[j], A0[i]);
      ffd_log(msg, FFD_ERROR);
      return 1;
    }
  }

  return 0;
} /* End of compare_boundary_area()*/

/*
	* Assign the Modelica solid surface thermal boundary condition data to FFD
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to the FFD simulation variables
	* @param BINDEX Pointer to boundary index
	*
	* @return 0 if no error occurred
	*/
int assign_thermal_bc(PARA_DATA *para, REAL **var, int **BINDEX) {
  int i, j, k, it, id, modelicaId;
  int imax = para->geom->imax, jmax = para->geom->jmax,
      kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL sensibleHeat=para->cosim->modelica->sensibleHeat;
  REAL latentHeat=para->cosim->modelica->latentHeat;
  REAL *temHea, celVol;

  /****************************************************************************
  | Assign the boundary condition if there is a solid surface
  ****************************************************************************/
  if(para->bc->nb_wall>0) {
    ffd_log("assign_thermal_bc(): Thermal conditions for solid surfaces:",
          FFD_NORMAL);
    temHea = (REAL *) malloc(para->bc->nb_wall*sizeof(REAL));
    if(temHea==NULL) {
      ffd_log("assign_thermal_bc(): Could not allocate memory for temHea.",
              FFD_ERROR);
      return 1;
    }
    /*-------------------------------------------------------------------------*/
    /* Convert the wall data from Modelica order to FFD order*/
    /*-------------------------------------------------------------------------*/
    for(j=0; j<para->bc->nb_wall; j++) {
      i = para->bc->wallId[j];
      switch(para->cosim->para->bouCon[i]) {
        case 1: /* Temperature*/
          temHea[j] = para->cosim->modelica->temHea[i] - 273.15;
          sprintf(msg, "\t%s: T=%f[degC]",
            para->bc->wallName[j], temHea[j]);
          ffd_log(msg, FFD_NORMAL);
          break;
        case 2: /* Heat flow rate*/
          temHea[j] = para->cosim->modelica->temHea[i] / para->bc->AWall[j];
          sprintf(msg, "\t%s: Q_dot=%f[W/m2]",
            para->bc->wallName[j], temHea[j]);
          ffd_log(msg, FFD_NORMAL);
          break;
        default:
          sprintf(msg,
          "Invalid value (%d) for thermal boundary condition. "
          "Expected value are 1->Fixed T; 2->Fixed heat flux",
          para->cosim->para->bouCon[i]);
          ffd_log(msg, FFD_ERROR);
          return 1;
      }
    }
    /*-------------------------------------------------------------------------*/
    /* Assign the wall BC*/
    /*-------------------------------------------------------------------------*/
    for(it=0; it<para->geom->index; it++) {
      i = BINDEX[0][it];
      j = BINDEX[1][it];
      k = BINDEX[2][it];
      id = BINDEX[4][it]- para->bc->nb_block;
      modelicaId = para->bc->wallId[id];

      if(var[FLAGP][IX(i,j,k)]==SOLID && id >= 0)
        switch(para->cosim->para->bouCon[modelicaId]) {
          case 1:
            var[TEMPBC][IX(i,j,k)] = temHea[id];
            BINDEX[3][it] = 1; /* Specified temperature*/
            break;
          case 2:
            var[QFLUXBC][IX(i,j,k)] = temHea[id];
            BINDEX[3][it] = 0; /* Specified heat flux*/
            break;
          default:
            sprintf(msg,
              "assign_thermal_bc(): Thermal bc value BINDEX[3][%d]=%d "
              "at [%d,%d,%d] was not valid.",
              it, BINDEX[3][it], i, j, k);
            ffd_log(msg, FFD_ERROR);
            return 1;
      } /* End of switch(BINDEX[3][it])*/
    }

	/*-------------------------------------------------------------------------*/
	/* Convert the block data from Modelica order to FFD order*/
	/*-------------------------------------------------------------------------*/
	if(para->cosim->para->nSou>0){
		for(j=0; j<para->bc->nb_block; j++) {
			i = j;
			int bouCon = 1;
			REAL ABlock = 1.0; /*defined by users*/
			switch(bouCon) {
				case 1: /* Temperature*/
					temHea[j] = para->cosim->modelica->sourceHeat[i] - 273.15;
					sprintf(msg, "\t%s: T=%f[degC]",
						para->bc->blockName[j], temHea[j]);
					ffd_log(msg, FFD_NORMAL);
					break;
				case 2: /* Heat flow rate*/
					temHea[j] = para->cosim->modelica->sourceHeat[i] / ABlock;
					sprintf(msg, "\t%s: Q_dot=%f[W]",
						para->bc->blockName[j], temHea[j]);
					ffd_log(msg, FFD_NORMAL);
					break;
				default:
					sprintf(msg,
					"Invalid value (%d) for thermal boundary condition. "
					"Expected value are 1->Fixed T; 2->Fixed heat flux",
					bouCon);
					ffd_log(msg, FFD_ERROR);
					return 1;
			}
		}
	}
    /*-------------------------------------------------------------------------*/
    /* Assign the block BC*/
    /*-------------------------------------------------------------------------*/
    if(para->cosim->para->nSou>0){
		int bouCon = 1;
		for(it=0; it<para->geom->index; it++) {
			i = BINDEX[0][it];
			j = BINDEX[1][it];
			k = BINDEX[2][it];
			id = BINDEX[4][it];
			/*modelicaId = id;*/

			if(var[FLAGP][IX(i,j,k)]==SOLID && id < para->bc->nb_block)
				switch(bouCon) {
					case 1:
						var[TEMPBC][IX(i,j,k)] = temHea[id];
						BINDEX[3][it] = 1; /* Specified temperature*/
						break;
					case 2:
						var[QFLUXBC][IX(i,j,k)] = temHea[id];
						BINDEX[3][it] = 0; /* Specified heat flux*/
						break;
					default:
						sprintf(msg,
							"assign_thermal_bc(): Thermal bc value BINDEX[3][%d]=%d "
							"at [%d,%d,%d] was not valid.",
							it, BINDEX[3][it], i, j, k);
						ffd_log(msg, FFD_ERROR);
						return 1;
				} /* End of switch(BINDEX[3][it])*/
		}
	}
		
		
    free(temHea);
  } /* End of if(para->bc->nb_wall>0)*/
  /****************************************************************************
  | No action since there is not a solid surface
  ****************************************************************************/
  else
    ffd_log("assign_thermal_bc(): No solid surfaces:", FFD_NORMAL);

  /****************************************************************************
  | Calculate heat injected into the space
  ****************************************************************************/
  sprintf(msg, "Convective sensible heat received by FFD is %f",
                sensibleHeat);
  ffd_log(msg, FFD_NORMAL);

  FOR_EACH_CELL
    if (var[FLAGP][IX(i,j,k)]==FLUID){
       celVol = vol(para, var, i, j, k);
       var[TEMPS][IX(i,j,k)] = sensibleHeat * celVol / para->geom->volFlu;
    }
  END_FOR

  /****************************************************************************
  | Data received, but not used in current version
  ****************************************************************************/
  sprintf(msg, "Latent heat received by FFD is %f",
                 latentHeat);
  ffd_log(msg, FFD_NORMAL);

  return 0;
} /* End of assign_thermal_bc()*/

/*
	* Assign the Modelica inlet and outlet boundary condition data to FFD
	*
	* The inlet and outlet boundaries are not fixed and they can change during
	* the simulation. The reason is that the Modelica uses acausal modeling
	* and the flow direction can change during the simulation depending on the
	* pressure difference. As a result, the FFD has to change its inlet and outlet
	* boundary condition accordingly. The inlet or outlet boundary is decided
	* according to the flow rate para->cosim->modelica->mFloRarPor. The port is
	* inlet if mFloRarPor>0 and outlet if mFloRarPor<0. We will need to reset the
	* var[FLAGP][IX(i,j,k)] to apply the change of boundary conditions.
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to the FFD simulation variables
	* @param BINDEX Pointer to boundary index
	*
	* @return 0 if no error occurred
	*/
int assign_port_bc(PARA_DATA *para, REAL **var, int **BINDEX) {
  int i, j, k, id, it, Xid, Cid;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);

  ffd_log("assign_port_bc():", FFD_NORMAL);

  /****************************************************************************
  | Convert the data from Modelica to FFD for the Inlet
  ****************************************************************************/
  for(j=0; j<para->bc->nb_port; j++) {
    i = para->bc->portId[j];

    /*-------------------------------------------------------------------------
    | Convert for mass flow rate and temperature
    -------------------------------------------------------------------------*/
    para->bc->velPort[j] = para->cosim->modelica->mFloRatPor[i]
                              / (para->prob->rho*para->bc->APort[j]);
    para->bc->TPort[j] = para->cosim->modelica->TPor[i] - 273.15;
    sprintf(msg, "\t%s: vel=%f[m/s], T=%f[degC]",
          para->bc->portName[j], para->bc->velPort[j],
          para->bc->TPort[j]);
    ffd_log(msg, FFD_NORMAL);
    /*-------------------------------------------------------------------------
    | Convert nXi types of species
    -------------------------------------------------------------------------*/
    for(Xid=0; Xid<para->cosim->para->nXi; Xid++) {
      para->bc->XiPort[j][Xid] = para->cosim->modelica->XiPor[i][Xid];
      sprintf(msg, "\tXi[%d]=%f", Xid, para->bc->XiPort[j][Xid]);
      ffd_log(msg, FFD_NORMAL);
    }
    /*-------------------------------------------------------------------------
    | Convert nC types of trace substances
    -------------------------------------------------------------------------*/
    for(Cid=0; Cid<para->cosim->para->nC; Cid++) {
      para->bc->CPort[j][Cid] = para->cosim->modelica->CPor[i][Cid];
      sprintf(msg, "\tC[%d]=%f", Cid, para->bc->CPort[j][Cid]);
      ffd_log(msg, FFD_NORMAL);
    }
  }

  /****************************************************************************
  | Assign the BC
  ****************************************************************************/
  for(it=0; it<para->geom->index; it++) {
    i = BINDEX[0][it];
    j = BINDEX[1][it];
    k = BINDEX[2][it];
    id = BINDEX[4][it];

    /*-------------------------------------------------------------------------
    | Only treat those inlet and outlet boundaries
    -------------------------------------------------------------------------*/
    if(var[FLAGP][IX(i,j,k)]==INLET || var[FLAGP][IX(i,j,k)]==OUTLET) {
      /* Set it to inlet if the flow velocity is positive or equal to 0*/
      if(para->bc->velPort[id]>=0) {
        var[FLAGP][IX(i,j,k)] = INLET;
        var[TEMPBC][IX(i,j,k)] = para->bc->TPort[id];
        for(Xid=0; Xid<para->cosim->para->nXi; Xid++)
          var[Xi1BC+Xid][IX(i,j,k)] = para->bc->XiPort[id][Xid];
        for(Cid=0; Cid<para->cosim->para->nC; Cid++)
          var[C1BC+Cid][IX(i,j,k)] = para->bc->CPort[id][Cid];


        if(i==0)
          var[VXBC][IX(i,j,k)] = para->bc->velPort[id];
        else if(i==imax+1)
          var[VXBC][IX(i,j,k)] = -para->bc->velPort[id];

        if(j==0)
          var[VYBC][IX(i,j,k)] = para->bc->velPort[id];
        else if(j==jmax+1)
          var[VYBC][IX(i,j,k)] = -para->bc->velPort[id];

        if(k==0)
          var[VZBC][IX(i,j,k)] = para->bc->velPort[id];
        else if(k==kmax+1)
          var[VZBC][IX(i,j,k)] = -para->bc->velPort[id];
      }
      /* Set it to outlet if the flow velocity is negative*/
      else
        var[FLAGP][IX(i,j,k)] = OUTLET;
    }
  }
  return 0;
} /* End of assign_inlet_outlet_bc()*/


/*
	* Integrate the coupled simulation exchange data over the surfaces
	*
	* Fluid port:
	*   - T/Xi/C: sum(u*T*dA)
	*   - m_dot:  sum(u*dA)
	*
	* Solid Surface Boundary:
	*   - T:      sum(T*dA)
	*   - Q_dot:  sum(q_dot*dA)
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param BINDEX Pointer to the boundary index
	*
	* @return 0 if no error occurred
	*/
int surface_integrate(PARA_DATA *para, REAL **var, int **BINDEX) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int i, j, k, it, bcid;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL vel_tmp, A_tmp;

  /****************************************************************************
  | Set the variable to 0
  ****************************************************************************/
  if(para->outp->version==DEBUG)
    ffd_log("surface_integrate(): Start to set the variable to 0",
            FFD_NORMAL);

  for(i=0; i<para->bc->nb_wall; i++)
    para->bc->temHeaAve[i] = 0;

  for(i=0; i<para->bc->nb_port; i++) {
    para->bc->TPortAve[i] = 0;
    para->bc->velPortAve[i] = 0;
    for(j=0; j<para->bc->nb_Xi; j++)
      para->bc->XiPortAve[i][j] = 0;
    for(j=0; j<para->bc->nb_C; j++)
      para->bc->CPortAve[i][j] = 0;
  }

  /****************************************************************************
  | Go through all the boundary cells
  ****************************************************************************/
  if(para->outp->version==DEBUG)
    ffd_log("surface_integrate(): Start to sum all the cells", FFD_NORMAL);

  for(it=0; it<para->geom->index; it++) {
    i = BINDEX[0][it];
    j = BINDEX[1][it];
    k = BINDEX[2][it];
    bcid = BINDEX[4][it];

    if(i==0 || i==imax+1) {
      vel_tmp = var[VX][IX(i,j,k)];
      A_tmp = area_yz(para, var, i, j, k);
    }
    else if(j==0 || j==jmax+1) {
      vel_tmp = var[VY][IX(i,j,k)];
      A_tmp = area_zx(para, var, i, j, k);
    }
    else if(k==0 || k==kmax+1) {
      vel_tmp = var[VZ][IX(i,j,k)];
      A_tmp = area_xy(para, var, i, j, k);
    }

    /*-------------------------------------------------------------------------
    | Set the thermal conditions data for Modelica.
    | In FFD simulation, the BINDEX[3][it] indicates: 1->T, 0->Heat Flux.
    | Those BINDEX[3][it] will be reset according to the Modelica data
    | para->comsim->para->bouCon (1->Heat Flux, 2->T).
    | Here is to give the Modelica the missing data (For instance, if Modelica
    | send FFD Temperature, FFD should then send Modelica Heat Flux).
    -------------------------------------------------------------------------*/
    /*-------------------------------------------------------------------------
    | Solid Wall
    --------------------------------------------------------------------------*/
    if(var[FLAGP][IX(i,j,k)]==SOLID && bcid >= para->bc->nb_block) {
      bcid = bcid - para->bc->nb_block;
	  switch(BINDEX[3][it]) {
        /* FFD uses heat flux as BC to compute temperature*/
        /* Then send Modelica the temperature*/
        case 0:
          para->bc->temHeaAve[bcid] += var[TEMP][IX(i,j,k)] * A_tmp;
          break;
        /* FFD uses temperature as BC to compute heat flux*/
        /* Then send Modelica the heat flux*/
        case 1:
          para->bc->temHeaAve[bcid] += var[QFLUX][IX(i,j,k)] * A_tmp;
          /*sprintf(msg, "Cell(%d,%d,%d):\tQFLUX=%f,\tA=%f", i,j,k,var[QFLUX][IX(i,j,k)], A_tmp);*/
          /*ffd_log(msg, FFD_NORMAL);*/
          break;
        default:
          sprintf(msg, "average_bc_area(): Thermal boundary (%d)"
                 "for cell (%d,%d,%d) was not defined",
                 BINDEX[3][it], i, j, k);
          ffd_log(msg, FFD_ERROR);
          return 1;
      }
    }
    /*-------------------------------------------------------------------------
    | Outlet
    -------------------------------------------------------------------------*/
    else if(var[FLAGP][IX(i,j,k)]==OUTLET) {
      if(para->outp->version==DEBUG) {
        sprintf(msg, "surface_integrate(): Set the outlet[%d, %d, %d]",
                i, j, k);
        ffd_log(msg, FFD_NORMAL);
      }

      para->bc->TPortAve[bcid] += var[TEMP][IX(i,j,k)] * A_tmp;
      para->bc->velPortAve[bcid] += vel_tmp * A_tmp;
      for(j=0; j<para->bc->nb_Xi; j++)
        para->bc->XiPortAve[bcid][j] += var[Xi1+j][IX(i,j,k)] * A_tmp;

      for(j=0; j<para->bc->nb_C; j++)
        para->bc->CPortAve[bcid][j] += var[C1+j][IX(i,j,k)] * A_tmp;

    }
    /*-------------------------------------------------------------------------
    | Inlet
    -------------------------------------------------------------------------*/
    else if(var[FLAGP][IX(i,j,k)]==INLET) {
      if(para->outp->version==DEBUG) {
        sprintf(msg, "surface_integrate(): Set 0 for inlet [%d,%d,%d].",
                i, j, k);
        ffd_log(msg, FFD_NORMAL);
      }

      para->bc->TPortAve[bcid] = 0;
      para->bc->velPortAve[bcid] = 0;
      for(j=0; j<para->bc->nb_Xi; j++)
        para->bc->XiPortAve[bcid][j] = 0;

      for(j=0; j<para->bc->nb_C; j++)
        para->bc->CPortAve[bcid][j] = 0;
    }

  } /* End of for(it=0; it<para->geom->index; it++)*/

  return 0;
} /* End of surface_integrate()*/

/*
	* Set sensor data
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD data
	*
	* @return 0 if no error occurred
	*/
int set_sensor_data(PARA_DATA *para, REAL **var) {
  int imax = para->geom->imax, jmax = para->geom->jmax,
      kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL u = var[VX][IX(imax/2,jmax/2,kmax/2)],
       v = var[VY][IX(imax/2,jmax/2,kmax/2)],
       w = var[VZ][IX(imax/2,jmax/2,kmax/2)];

  /* Averaged room temperature*/
  para->sens->senVal[0] = para->cosim->ffd->TRoo;

  /*Velocity at the center of the space*/
  para->sens->senVal[1] = sqrt(u*u + v*v + w*w);

  return 0;
} /* End of set_sensor_data*/
