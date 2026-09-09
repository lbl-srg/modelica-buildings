/****************************************************************************
|
|  \file   cosimulation.c
|
|  \brief  Functions for cosimulation
|
|  \author Wangda Zuo
|          University of Miami, University of Colorado Boulder
|          W.Zuo@miami.edu, wangda.zuo@colorado.edu
|          Xu Han
|          Univeristy of Colorado Boulder, xuha3556@colorado.edu
|
|
|  \date   4/5/2020
|  \This file provides functions that are used for conducting the coupled simulation
|  \with Modelica
|
****************************************************************************/

#include "cosimulation.h"
#include "common.h"
static char comsg[1000] = { 0 };

extern int num_input;
extern int num_output;
extern double outp_Boundary_upper[];
extern double outp_Boundary_lower[];
extern OUTPUT_TYPE outp_name[];
extern INPUT_TYPE inpu_name[];

/* Declare and initialize variables */
extern int num_inlet, num_block, num_wall, dir_inlet;

/* temperature, heat flux or velocity will be overwritten or not */
extern int inlet_temp_re[];
extern int inlet_vel_re[];
extern int block_re[];
extern int wall_re[];
extern int wall_heat_re[];

/* temperature, heat flux or velocity will be overwritten by which isat input */
extern int inlet_temp_wh[];
extern int inlet_vel_wh[];
extern int block_wh[];
extern int wall_wh[];
extern int wall_heat_wh[];

/*
	* Read the coupled simulation parameters defined by Modelica
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param BINDEX pointer to boundary index
	*
	* @return 0 if no error occurred
	*/

int read_cosim_parameter(PARA_DATA *para) {
  int i;

  cosim_log("-------------------------------------------------------------------",
          COSIM_NORMAL);

  if(para->cosim->para->version=="DEBUG") {
    cosim_log("read_cosim_parameter(): "
            "Received the following coupled simulation parameters:",
             COSIM_NORMAL);
  }

  /****************************************************************************
  | Compare number of solid surface boundaries
  | (Wall, Window Glass with and without shading, and Window Frame)
  ****************************************************************************/
  if (para->cosim->para->version == "DEBUG") {
	cosim_log("Modelica Surfaces are:", COSIM_NORMAL);
	for (i = 0; i<para->cosim->para->nSur; i++) {
		sprintf(comsg, "\t%s", para->cosim->para->name[i]);
		cosim_log(comsg, COSIM_NORMAL);
	}
  }

  /****************************************************************************
  | Compare the number of fluid ports
  ****************************************************************************/
  if (para->cosim->para->version == "DEBUG") {
	sprintf(comsg, "\tnPorts=%d", para->cosim->para->nPorts);
	cosim_log(comsg, COSIM_NORMAL);
  }

  /****************************************************************************
  | Compare the number of sensors
  ****************************************************************************/
  if (para->cosim->para->version == "DEBUG") {
	sprintf(comsg, "\tnSen=%d", para->cosim->para->nSen);
	cosim_log(comsg, COSIM_NORMAL);
  }

  /****************************************************************************
  | Compare the number of species
  ****************************************************************************/
  if (para->cosim->para->version == "DEBUG") {
	sprintf(comsg, "\tnXi=%d", para->cosim->para->nXi);
	cosim_log(comsg, COSIM_NORMAL);
  }

  /****************************************************************************
  | Compare the number of trace substances
  ****************************************************************************/
  if (para->cosim->para->version == "DEBUG") {
	sprintf(comsg, "\tnC=%d", para->cosim->para->nC);
	cosim_log(comsg, COSIM_NORMAL);

	sprintf(comsg, "\tnConExtWin=%d", para->cosim->para->nConExtWin);
	cosim_log(comsg, COSIM_NORMAL);

	sprintf(comsg, "\tsha=%d", para->cosim->para->sha);
	cosim_log(comsg, COSIM_NORMAL);
  }

  /****************************************************************************
  | Print the information for surface boundaries
  ****************************************************************************/
  for(i=0; i<para->cosim->para->nSur; i++) {
    sprintf(comsg, "\tSurface %d: %s", i, para->cosim->para->name[i]);
    cosim_log(comsg, COSIM_NORMAL);
    sprintf(comsg, "\t\tArea:%f[m2],\t Tilt:%f[deg]",
					para->cosim->para->are[i], para->cosim->para->til[i]);
    cosim_log(comsg, COSIM_NORMAL);
    switch (para->cosim->para->bouCon[i]) {
      case 1:
        cosim_log("\t\tThermal boundary: Fixed temperature", COSIM_NORMAL);
        break;
      case 2:
        cosim_log("\t\tThermal boundary: Fixed heat flux", COSIM_NORMAL);
        break;
      default:
        sprintf(comsg,
        "Invalid value (%d) for thermal boundary condition. "
        "1: Fixed T; 2: Fixed heat flux",
		para->cosim->para->bouCon[i]);
        cosim_log(comsg, COSIM_ERROR);
        return 1;
    }
  }

  for(i=0; i<para->cosim->para->nPorts; i++) {
    sprintf(comsg, "\tFluid Ports %d: %s", i, para->cosim->para->portName[i]);
    cosim_log(comsg, COSIM_NORMAL);
  }

  for(i=0; i<para->cosim->para->nSen; i++) {
    sprintf(comsg, "\tSensor %d: %s", i, para->cosim->para->sensorName[i]);
    cosim_log(comsg, COSIM_NORMAL);
  }

  sprintf(comsg,"read_cosim_parameter(): check para->cosim->modelica->flag=%d", para->cosim->modelica->flag);
  cosim_log(comsg, COSIM_NORMAL);

  return 0;
} /* End of read_cosim_parameter()*/


int read_cosim_data(PARA_DATA *para) {
  int i=0, j=0;
  int size = para->cosim->para->nSur + para->cosim->para->nPorts * 2;
  float *input = malloc(sizeof(float)*size);
  if (input == NULL) {
	ModelicaError("Failed to allocate memory for input in read_cosim_data() of cosimulation.c");
  }

  cosim_log("-------------------------------------------------------------------",
	COSIM_NORMAL);
  /****************************************************************************
  | Wait for data to be updated by the other program
  ****************************************************************************/
  while (para->cosim->modelica->flag == 0) {
	if (para->cosim->para->version == DEBUG) {
		sprintf(comsg,
			"read_cosim_data(): Data is not ready with para->cosim->modelica->flag = %d",
			para->cosim->modelica->flag);
		cosim_log(comsg, COSIM_NORMAL);
	}
	if (para->cosim->para->flag == 0) {
		return 1;
	}
	Sleep(10);
	if (para->cosim->para->version == DEBUG)
		cosim_log("read_cosim_data(): Sleep for 0.01", COSIM_NORMAL);
  }

  if (para->cosim->para->version == DEBUG) {
	cosim_log("read_cosim_data(): Modelica data is ready.", COSIM_NORMAL);
	sprintf(comsg,
		"read_cosim_data(): Received the following data at t=%f[s]",
		para->cosim->modelica->t);
	cosim_log(comsg, COSIM_NORMAL);
  }

  double tmp = 0;
  int flag;
  sprintf(comsg,
	"read_cosim_data(): Start to read data from Modelica at t=%f[s]",
	para->cosim->modelica->t);
  cosim_log(comsg, COSIM_NORMAL);
  /****************************************************************************
  | Convert the port data from Modelica to FFD for the Inlet
  ****************************************************************************/
  for (i = 0; i < num_input; i++) {
	flag = 0;
	if (num_inlet > 0 && flag == 0) {
		for (j = 0; j < num_inlet; j++) {
			if (inlet_temp_wh[j] == i + 1) {
				para->cosim->ffd->input[i] = para->cosim->modelica->TPor[j] - 273.15;
				flag = 1;
				break;
			}
			else if (inlet_vel_wh[j] == i + 1) {
				para->cosim->ffd->input[i] = para->cosim->modelica->mFloRatPor[j];
				flag = 1;
				break;
			}
			if (flag == 1)
				break;
		}
	}
	if (num_block > 0 && flag == 0) {
		for (j = 0; j < num_block; j++) {
			if (block_wh[j] == i + 1) {
				para->cosim->ffd->input[i] = para->cosim->modelica->sourceHeat[j];
				int source_bou = 1;
				/*source_bou is defined by the users */
				switch (source_bou) {
				case 1: /* Temperature*/
					para->cosim->ffd->input[i] = para->cosim->modelica->sourceHeat[j] - 273.15;
					flag = 1;
					break;
				case 2: /* Heat flow rate*/
					para->cosim->ffd->input[i] = para->cosim->modelica->sourceHeat[j];
					flag = 1;
					break;
				}
			}
			if (flag == 1)
				break;
		}
	}
	if (num_wall > 0 && flag == 0) {
		for (j = 0; j < num_wall; j++) {
			if (wall_wh[j] == i + 1) {
				switch (para->cosim->para->bouCon[j]) {
				case 1: /* Temperature*/
					para->cosim->ffd->input[i] = para->cosim->modelica->temHea[j] - 273.15;
					flag = 1;
					break;
				case 2: /* Heat flow rate*/
					para->cosim->ffd->input[i] = para->cosim->modelica->temHea[j];
					flag = 1;
					break;
				default:
					sprintf(comsg,
						"Invalid value (%d) for thermal boundary condition. "
						"Expected value are 1->Fixed T; 2->Fixed heat flux",
						para->cosim->para->bouCon[i]);
					cosim_log(comsg, COSIM_ERROR);
					return 1;
				}
			}
			if (flag == 1)
				break;
		}
	}
	if (flag == 1) {
		sprintf(comsg, "\tpara->cosim->ffd->input[%d]: %lf", i, para->cosim->ffd->input[i]);
		cosim_log(comsg, COSIM_NORMAL);		
	}
	else {
		sprintf(comsg, "read_cosim_data(): failed to assign value for para->cosim->ffd->input[%d]", i);
		cosim_log(comsg, COSIM_ERROR);
	}
  }

  /* Change the flag to indicate that the data has been read*/
  para->cosim->modelica->flag = 0;
  if (para->cosim->para->version == DEBUG) {
	cosim_log("read_cosim_data(): Ended reading data from Modelica.",
		COSIM_NORMAL);
  }		
  return 0;
}
	/*
		* Write the FFD data for Modelica
		*
		* @param para Pointer to FFD parameters
		* @param var Pointer to FFD simulation variables
		*
		* @return 0 if no error occurred
		*/
int write_cosim_data(PARA_DATA *para){
  int i, j, id;

  cosim_log("-------------------------------------------------------------------",
          COSIM_NORMAL);
  /****************************************************************************
  | Wait if the previous data has not been read by Modelica
  ****************************************************************************/
  while(para->cosim->ffd->flag==1) {
    cosim_log("write_cosim_data(): Wait since previous data is not taken "
            "by Modelica", COSIM_NORMAL);
    Sleep(10);
  }

  /****************************************************************************
  | Start to write new data
  ****************************************************************************/
  cosim_log("write_cosim_data(): "
	"Start to write the following coupled simulation data to Modelica:",
	COSIM_NORMAL);

  /****************************************************************************
  | Note: we assumed fixed values by default for some parameters. The values
  | can be assigned by isat output, which is defined by users. 
  | For example, para->cosim->ffd->TRoo = para->cosim->ffd->output[0];
  ****************************************************************************/

  /****************************************************************************
  | Set the time and space averaged temperature of space
  | Convert T from degC to K
  ****************************************************************************/
  for (i = 0; i<num_output; i++) {
	  if (outp_name[i] == temp_roo) {
		  para->cosim->ffd->TRoo = para->cosim->ffd->output[i];
		  sprintf(comsg, "\tpara->cosim->ffd->TRoo: %f",
			  para->cosim->ffd->TRoo);
		  cosim_log(comsg, COSIM_NORMAL);
		  break;
	  }
	  else {
		  para->cosim->ffd->TRoo = 25.0 + 273.15; /*assumed a fixed value if no info returned from isat outputs*/
	  }
  }

  /****************************************************************************
  | Set temperature of shading devices (currently not supported)
  ****************************************************************************/
  /*Note: we assumed a fixed value here, which can be assigned by isat outputs*/
  if (para->cosim->para->sha==1) {
    for(i=0; i<para->cosim->para->nConExtWin; i++) {
      para->cosim->ffd->TSha[i] = 20 + 273.15; /*assumed a fixed value*/
    }
  }
			
  /****************************************************************************
  | Set data for fluid ports
  ****************************************************************************/
  for(i=0; i<para->cosim->para->nPorts; i++) {
	/* Get the corresponding ID in Modelica*/
	/*-------------------------------------------------------------------------
	| Assign the temperature
	-------------------------------------------------------------------------*/   
	para->cosim->ffd->TPor[i] = 25.0 + 273.15; /*assumed a fixed value*/

    for(j=0; j<para->cosim->para->nXi; j++) {
		para->cosim->ffd->XiPor[i][j] = 0.01; /*assumed a fixed value*/
    }
    /*-------------------------------------------------------------------------
    | Assign the C
    -------------------------------------------------------------------------*/
    for(j=0; j<para->cosim->para->nC; j++) {
		para->cosim->ffd->CPor[i][j] = 0.01; /*assumed a fixed value*/
    }
  }

  /****************************************************************************
  | Set data for solid surfaces
  ****************************************************************************/
  for (i = 0; i < para->cosim->para->nSur; i++) {
    /* Set the B.C. Temperature*/
    if (para->cosim->para->bouCon[i]==2) {
		para->cosim->ffd->temHea[i] = 25 + 273.15; /*assumed a fixed value*/
    }
    /* Set the heat flux*/
    else {
		if (wall_heat_re[i] == 1) {
			para->cosim->ffd->temHea[i] = para->cosim->ffd->output[wall_heat_wh[i]-1];
			sprintf(comsg, "\tpara->cosim->ffd->temHea[%d]: %f",
				i, para->cosim->ffd->temHea[i]);
			cosim_log(comsg, COSIM_NORMAL);
		}
		else {
			para->cosim->ffd->temHea[i] = 0.0; /*assumed a fixed value*/
		}
    }
  }

  /****************************************************************************
  | Set data for sensors
  ****************************************************************************/
  for(i=0; i<para->cosim->para->nSen; i++) {
	para->cosim->ffd->senVal[i] = para->cosim->ffd->output[i];
    sprintf(comsg, "\tpara->cosim->ffd->output[%d]: %f",
		i, para->cosim->ffd->senVal[i]);
    cosim_log(comsg, COSIM_NORMAL);
  }

  /****************************************************************************
  | Inform Modelica that the FFD data is updated
  ****************************************************************************/
  para->cosim->ffd->flag = 1;

  return 0;
} /* End of write_cosim_data()*/


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
  int IMAX = imax + 2, IJMAX = (imax + 2)*(jmax + 2);
  REAL vel_tmp, A_tmp;

  /****************************************************************************
  | Set the variable to 0
  ****************************************************************************/
  if (para->outp->version == DEBUG)
	ffd_log("surface_integrate(): Start to set the variable to 0",
		FFD_NORMAL);

  for (i = 0; i<para->bc->nb_wall; i++)
	para->bc->temHeaAve[i] = 0;

  for (i = 0; i<para->bc->nb_port; i++) {
	para->bc->TPortAve[i] = 0;
	para->bc->velPortAve[i] = 0;
	for (j = 0; j<para->bc->nb_Xi; j++)
		para->bc->XiPortAve[i][j] = 0;
	for (j = 0; j<para->bc->nb_C; j++)
		para->bc->CPortAve[i][j] = 0;
  }

  /****************************************************************************
  | Go through all the boundary cells
  ****************************************************************************/
  if (para->outp->version == DEBUG)
	ffd_log("surface_integrate(): Start to sum all the cells", FFD_NORMAL);

  for (it = 0; it<para->geom->index; it++) {
	i = BINDEX[0][it];
	j = BINDEX[1][it];
	k = BINDEX[2][it];
	bcid = BINDEX[4][it];

	if (i == 0 || i == imax + 1) {
		vel_tmp = var[VX][IX(i, j, k)];
		A_tmp = area_yz(para, var, i, j, k);
	}
	else if (j == 0 || j == jmax + 1) {
		vel_tmp = var[VY][IX(i, j, k)];
		A_tmp = area_zx(para, var, i, j, k);
	}
	else if (k == 0 || k == kmax + 1) {
		vel_tmp = var[VZ][IX(i, j, k)];
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
	if (var[FLAGP][IX(i, j, k)] == SOLID && bcid >= para->bc->nb_block) {
		switch (BINDEX[3][it]) {
			/* FFD uses heat flux as BC to compute temperature*/
			/* Then send Modelica the temperature*/
		case 0:
			para->bc->temHeaAve[bcid - para->bc->nb_block] += var[TEMP][IX(i, j, k)] * A_tmp;
			break;
			/* FFD uses temperature as BC to compute heat flux*/
			/* Then send Modelica the heat flux*/
		case 1:
			para->bc->temHeaAve[bcid - para->bc->nb_block] += var[QFLUX][IX(i, j, k)] * A_tmp;
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
	else if (var[FLAGP][IX(i, j, k)] == OUTLET) {
		if (para->outp->version == DEBUG) {
			sprintf(msg, "surface_integrate(): Set the outlet[%d, %d, %d]",
				i, j, k);
			ffd_log(msg, FFD_NORMAL);
		}

		para->bc->TPortAve[bcid] += var[TEMP][IX(i, j, k)] * A_tmp;
		para->bc->velPortAve[bcid] += vel_tmp * A_tmp;
		for (j = 0; j<para->bc->nb_Xi; j++)
			para->bc->XiPortAve[bcid][j] += var[Xi1 + j][IX(i, j, k)] * A_tmp;

		for (j = 0; j<para->bc->nb_C; j++)
			para->bc->CPortAve[bcid][j] += var[C1 + j][IX(i, j, k)] * A_tmp;

	}
	/*-------------------------------------------------------------------------
	| Inlet
	-------------------------------------------------------------------------*/
	else if (var[FLAGP][IX(i, j, k)] == INLET) {
		if (para->outp->version == DEBUG) {
			sprintf(msg, "surface_integrate(): Set 0 for inlet [%d,%d,%d].",
				i, j, k);
			ffd_log(msg, FFD_NORMAL);
		}

		para->bc->TPortAve[bcid] = 0;
		para->bc->velPortAve[bcid] = 0;
		for (j = 0; j<para->bc->nb_Xi; j++)
			para->bc->XiPortAve[bcid][j] = 0;

		for (j = 0; j<para->bc->nb_C; j++)
			para->bc->CPortAve[bcid][j] = 0;
	}

  } /* End of for(it=0; it<para->geom->index; it++)*/

	return 0;
} /* End of surface_integrate()*/


/****************************************************************************
|  Write the log file
| 
| \param message Pointer the message
| \param msg_type Type of message
| 
| \return 0 if no error occurred
****************************************************************************/
void cosim_log(char *message, COSIM_MSG_TYPE msg_type) {
  if (msg_type == COSIM_NEW) {
	if ((file_log = fopen("log.isat", "w+")) == NULL) {
		fprintf(stderr, "Error:can not open error file!\n");
		exit(1);
	}
  }

  else if ((file_log = fopen("log.isat", "a+")) == NULL) {
	fprintf(stderr, "Error:can not open error file!\n");
	exit(1);
  }

  switch (msg_type) {
	case COSIM_WARNING:
		fprintf(file_log, "WARNING in %s\n", message);
		break;
	case COSIM_ERROR:
		fprintf(file_log, "ERROR in %s\n", message);
		break;
	/* Normal log */
	default:
		fprintf(file_log, "%s\n", message);
  }
  fclose(file_log);

} /* End of cosim_log() */
