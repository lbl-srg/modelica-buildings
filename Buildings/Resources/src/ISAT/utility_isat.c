/******************************************************************************
| 
|  \file   utility_isat.c
| 
|  \brief  define utility functions for isat_ffd
| 
|  \author Xu Han
|          Univeristy of Colorado Boulder, xuha3556@colorado.edu
|          Wei Tian
|          University of Miami, Schneider Electric
|          w.tian@umiami.edu, Wei.Tian@Schneider-Electric.com
|          Dan Li
|          University of Miami
|
|  \date   4/5/2020
| 
| \  All RIGHTS RESERVED.
******************************************************************************/
#include "utility_isat.h"
extern double ffdInput[];
extern double ffdOutput[];
extern char filepath[];

/******************************************************************************
|  Write the log file
| 
| \param message Pointer the message
| \param msg_type Type ogf message
| 
| \return No return needed
******************************************************************************/
void mpc_log(char *message, MPC_MSG_TYPE msg_type) {
  if(msg_type==MPC_NEW) {
    if((file_log=fopen("log.mpc","w+"))==NULL) {
        fprintf(stderr, "Error:can not open error file!\n");
        exit(1);
    }
  }
  else if((file_log=fopen("log.mpc","a+"))==NULL) {
    fprintf(stderr,"Error:can not open error file!\n");
    exit(1);
  }

  switch(msg_type) {
    case MPC_WARNING:
      fprintf(file_log, "WARNING in %s\n", message);
      break;
    case MPC_ERROR:
      fprintf(file_log, "ERROR in %s\n", message);
      break;
    /* Normal log */
    default:
      fprintf(file_log, "%s\n", message);
  }
  fclose(file_log);
} /* End of mpc_log() */



int write_output_data(PARA_DATA *para, REAL **var, int **BINDEX) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2)*(jmax + 2);
  char string[400], tmp[400], tmp1[400];
  int num_output, i, j, k;
  float wOutput[5] = {0};
  OUTPUT_TYPE outp_name[5] = {temp_occ};

  /* Open the output.isat file */
  char filenametmp[400];
  snprintf(filenametmp, sizeof(filenametmp), "%s%s", filepath, "set.isat");

  if ((file_params = fopen(filenametmp, "r")) == NULL) {
	sprintf(msg, "write_output_data(): Could not open the file %s.",filenametmp);
	ffd_log(msg, FFD_ERROR);
	return 1;
  }
  else {
	sprintf(msg, "write_output_data(): Start to read the file %s", filenametmp);
	ffd_log(msg, FFD_NORMAL);
  }

  /* Read the settings for outputs */
  int next = 0;
  while (next == 0) {
						 
	if (fgets(string, 400, file_params) == NULL)
		next = 1;
	if (EOF == sscanf(string, "%s", tmp)) {
		continue;
	}

	/* Read isat.num_output */
	if (!strcmp(tmp, "isat.num_output")) {
		sscanf(string, "%s%d", tmp, &num_output);
		if (num_output < 6) {
		sprintf(msg, "write_output_data(): %s=%d", tmp, num_output);
		ffd_log(msg, FFD_NORMAL);
		}
		else {
			sprintf(msg, "write_output_data(): the current version only supports no more than five outputs");
			ffd_log(msg, FFD_ERROR);
			return 1;
		}
	}

	/* Read outp.outp_name */
	else if (!strcmp(tmp, "/*outp.outp_name:")) {
		for (i = 0; i < num_output; i++) {
			fgets(string, 400, file_params);
			sscanf(string, "%s", tmp);
			if (!strcmp(tmp, "outp.outp_name")) {
				sscanf(string, "%s%s", tmp, tmp1);
				if (!strcmp(tmp1, "temp_roo"))
					outp_name[i] = temp_roo;
				else if (!strcmp(tmp1, "temp_occ"))
					outp_name[i] = temp_occ;
				else if (!strcmp(tmp1, "vel_occ"))
					outp_name[i] = vel_occ;
				else if (!strcmp(tmp1, "temp_sen"))
					outp_name[i] = temp_sen;
				else if (!strcmp(tmp1, "vel_sen"))
					outp_name[i] = vel_sen;
				else if (!strcmp(tmp1, "temp_rack"))
					outp_name[i] = temp_rack;
				else if (!strcmp(tmp1, "heat_wall1"))
					outp_name[i] = heat_wall1;
				else if (!strcmp(tmp1, "heat_wall2"))
					outp_name[i] = heat_wall2;
				else if (!strcmp(tmp1, "heat_wall3"))
					outp_name[i] = heat_wall3;
				else if (!strcmp(tmp1, "heat_wall4"))
					outp_name[i] = heat_wall4;
				else if (!strcmp(tmp1, "heat_wall5"))
					outp_name[i] = heat_wall5;
				else if (!strcmp(tmp1, "heat_wall6"))
					outp_name[i] = heat_wall6;
				else {
					sprintf(msg, "write_output_data(): %s is not valid input for %s", tmp1, tmp);
					ffd_log(msg, FFD_ERROR);
					return 1;
				}
				sprintf(msg, "write_output_data(): %s[%d]=%s", tmp, i, tmp1);
				ffd_log(msg, FFD_NORMAL);
			} /*end of if (!strcmp(tmp, "outp.outp_name"))*/
			else {
				sprintf(msg, "write_output_data(): wrong format for %s, which should be outp.outp_name", tmp);
				ffd_log(msg, FFD_ERROR);
				return 1;
			}
		} /*End of for (i = 0; i < num_output; i++)*/
	} /*End of else if (!strcmp(tmp, "/*outp.outp_name:"))*/
  } /* End of while (next = 0)*/

  fclose(file_params);

  /* Write outputs */
  for (i = 0; i < num_output; i++) {
	if (outp_name[i] == temp_roo) {
		ffdOutput[i] = average_room_temp(para, var);
		sprintf(msg, "write_output_data(): ffdOutput[%d]=%lf", i, ffdOutput[i]);
		ffd_log(msg, FFD_NORMAL);
	}
	else if (outp_name[i] == temp_occ) {
		ffdOutput[i] = average_volume_temp(para, var);
		sprintf(msg, "write_output_data(): ffdOutput[%d]=%lf", i, ffdOutput[i]);
		ffd_log(msg, FFD_NORMAL);
	}
	else if (outp_name[i] == vel_occ) {
		ffdOutput[i] = average_volume_vel(para, var);
		sprintf(msg, "write_output_data(): ffdOutput[%d]=%lf", i, ffdOutput[i]);
		ffd_log(msg, FFD_NORMAL);
	}
	else if (outp_name[i] == temp_sen) {
		ffdOutput[i] = sensor_temp(para, var);
		sprintf(msg, "write_output_data(): ffdOutput[%d]=%lf", i, ffdOutput[i]);
		ffd_log(msg, FFD_NORMAL);
	}
	else if (outp_name[i] == vel_sen) {
		ffdOutput[i] = sensor_vel(para, var);
		sprintf(msg, "write_output_data(): ffdOutput[%d]=%lf", i, ffdOutput[i]);
		ffd_log(msg, FFD_NORMAL);
	}
	else if (outp_name[i] == temp_rack) {
		ffdOutput[i] = maximum_rack_temp(para, var);
		sprintf(msg, "write_output_data(): ffdOutput[%d]=%lf", i, ffdOutput[i]);
		ffd_log(msg, FFD_NORMAL);
	}
	else if (outp_name[i] == heat_wall1) {
		ffdOutput[i] = para->bc->temHeaMean[0];
		sprintf(msg, "write_output_data(): ffdOutput[%d]=%lf", i, ffdOutput[i]);
		ffd_log(msg, FFD_NORMAL);
	}
	else if (outp_name[i] == heat_wall2) {
		ffdOutput[i] = para->bc->temHeaMean[1];
		sprintf(msg, "write_output_data(): ffdOutput[%d]=%lf", i, ffdOutput[i]);
		ffd_log(msg, FFD_NORMAL);
	}
	else if (outp_name[i] == heat_wall3) {
		ffdOutput[i] = para->bc->temHeaMean[2];
		sprintf(msg, "write_output_data(): ffdOutput[%d]=%lf", i, ffdOutput[i]);
		ffd_log(msg, FFD_NORMAL);
	}
	else if (outp_name[i] == heat_wall4) {
		ffdOutput[i] = para->bc->temHeaMean[3];
		sprintf(msg, "write_output_data(): ffdOutput[%d]=%lf", i, ffdOutput[i]);
		ffd_log(msg, FFD_NORMAL);
	}
	else if (outp_name[i] == heat_wall5) {
		ffdOutput[i] = para->bc->temHeaMean[4];
		sprintf(msg, "write_output_data(): ffdOutput[%d]=%lf", i, ffdOutput[i]);
		ffd_log(msg, FFD_NORMAL);
	}
	else if (outp_name[i] == heat_wall6) {
		ffdOutput[i] = para->bc->temHeaMean[5];
		sprintf(msg, "write_output_data(): ffdOutput[%d]=%lf", i, ffdOutput[i]);
		ffd_log(msg, FFD_NORMAL);
	}
	else {
		sprintf(msg, "write_output_data(): wrong format for names of outputs");
		ffd_log(msg, FFD_ERROR);
		return 1;
	}
  }

  sprintf(msg, "write_output_data(): finish writing output data");
  ffd_log(msg, FFD_NORMAL);
  
  return 0;
} /* End of write_output_data() */


/******************************************************************************
|  Calculate volume weighted averaged value of temperature in a space
| 
|  The average is weighted by volume of each cell
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| 
| \return Volume weighted average
******************************************************************************/
REAL average_room_temp(PARA_DATA *para, REAL **var) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int i, j, k, k_occ;
  int IMAX = imax + 2, IJMAX = (imax + 2)*(jmax + 2);
  REAL tmp1 = 0, tmp2 = 0, tmp3 = 0;

  FOR_EACH_CELL
	if (var[FLAGP][IX(i, j, k)] == FLUID) {
		tmp1 = vol(para, var, i, j, k);
		tmp2 += var[TEMP][IX(i, j, k)] * tmp1;
		tmp3 += tmp1;
	}
	else
		continue;
  END_FOR

  if (tmp3 > 0) {
	return tmp2 / tmp3 + 273.15;
  }
  else {
	sprintf(msg, "average_room_temp(): the volume of fluid is zero.");
	ffd_log(msg, FFD_ERROR);
	return 0;
  }
}/* End of average_room_temp( ) */

/******************************************************************************
|  Calculate volume weighted averaged value of temperature in a space
| 
|  The average is weighted by volume of each cell
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| 
| \return Volume weighted average
******************************************************************************/
REAL average_volume_temp(PARA_DATA *para, REAL **var) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int i, j, k, k_occ;
  int IMAX = imax + 2, IJMAX = (imax + 2)*(jmax + 2);
  REAL tmp1 = 0, tmp2 = 0, tmp3 = 0;

  /*k_occ represents the height of occupant zone, which can be defined by users*/
  /*here k_occ is set as kmax by default, which calculates room-averaged value*/
  k_occ = kmax;

  FOR_EACH_CELL
	if (var[FLAGP][IX(i, j, k)] == FLUID && k < k_occ) {
		tmp1 = vol(para, var, i, j, k);
		tmp2 += var[TEMP][IX(i, j, k)] * tmp1;
		tmp3 += tmp1;
	}
	else
		continue;
  END_FOR

  if (tmp3 > 0) {
	return tmp2 / tmp3 + 273.15;
  }
  else {
	sprintf(msg, "average_volume_temp(): the volume of fluid is zero.");
	ffd_log(msg, FFD_ERROR);
	return 0;
  }
}/* End of average_volume_temp( ) */

/******************************************************************************
|  Calculate volume weighted averaged value of velocity in a space
| 
|  The average is weighted by volume of each cell
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| 
| \return Volume weighted average
******************************************************************************/
REAL average_volume_vel(PARA_DATA *para, REAL **var) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int i, j, k, k_occ;
  int IMAX = imax + 2, IJMAX = (imax + 2)*(jmax + 2);
  REAL tmp1 = 0, tmp2 = 0, tmp3 = 0, u, v, w;

  /*k_occ represents the height of occupant zone, which can be defined by users
  here k_occ is set as kmax by default, which calculates room-averaged value*/
  k_occ = kmax;

  FOR_EACH_CELL
	if (var[FLAGP][IX(i, j, k)] == FLUID && k < k_occ) {
		u = var[VX][IX(i, j, k)];
		v = var[VY][IX(i, j, k)];
		w = var[VZ][IX(i, j, k)];
		tmp1 = vol(para, var, i, j, k);
		tmp2 += sqrt(u*u + v*v + w*w) * tmp1;
		tmp3 += tmp1;
	}
	else
		continue;
  END_FOR

  if (tmp3 > 0){
	return tmp2 / tmp3;
  }
  else{
	sprintf(msg, "average_room_vel(): the volume of fluid is zero.");
		ffd_log(msg, FFD_ERROR);
  return 0;
  }
}/* End of average_volume_vel( ) */

/******************************************************************************
|  Return value of temperature at sensor location
******************************************************************************/
REAL sensor_temp(PARA_DATA *para, REAL **var) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2)*(jmax + 2);
  int i, j, k;

  /*i, j and k represent the location of the sensor, which can be defined by users
  here i, j and k are set in the center of the room by default*/
  i = imax / 2;
  j = jmax / 2;
  k = kmax / 2;

  return var[TEMPM][IX(i, j, k)] + 273.15;

}/* End of sensor_temp( ) */

/******************************************************************************
|  Return value of velocity at sensor location
******************************************************************************/
REAL sensor_vel(PARA_DATA *para, REAL **var) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2)*(jmax + 2);
  int i, j, k;
  double u, v, w;

  /*i, j and k represent the location of the sensor, which can be defined by users.
  here i, j and k are set in the center of the room by default*/
  i = imax / 2;
  j = jmax / 2;
  k = kmax / 2;

  /*calcualte velocity in x, y and z direction at sensor location*/
  u = var[VX][IX(i, j, k)];
  v = var[VY][IX(i, j, k)];
  w = var[VZ][IX(i, j, k)];

  /*return velocity magnitude at sensor location*/
  return sqrt(u*u + v*v + w*w);
}/* End of sensor_temp( ) */

/******************************************************************************
|  Calculate volume weighted averaged value of temperature in a space
| 
|  The average is weighted by volume of each cell
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| 
| \return Volume weighted average
******************************************************************************/
REAL maximum_rack_temp(PARA_DATA *para, REAL **var) {
  int i, j;
  int ip, jp, kp;
  REAL T1, T2, T3, T4, Tave = 0, Tmax = 0;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2)*(jmax + 2);

  if (para->bc->nb_rack > 0) {
	/*find monitor index*/
	if (get_monitor_index(para, var) != 0) {
		ffd_log("write_monitor_data(): cannot find the index of monitoring cells", FFD_ERROR);
	}

	/*get temperatures at monitored points of each rack*/
	for (i = 0;i < para->bc->nb_rack;i++) {
		/*Point1*/
		ip = para->sens->indexMoniPoints[i][0][0];
		jp = para->sens->indexMoniPoints[i][0][1];
		kp = para->sens->indexMoniPoints[i][0][2];
		T1 = var[TEMP][IX(ip, jp, kp)];
		/*Point2*/
		ip = para->sens->indexMoniPoints[i][1][0];
		jp = para->sens->indexMoniPoints[i][1][1];
		kp = para->sens->indexMoniPoints[i][1][2];
		T2 = var[TEMP][IX(ip, jp, kp)];
		/*Point3*/
		ip = para->sens->indexMoniPoints[i][2][0];
		jp = para->sens->indexMoniPoints[i][2][1];
		kp = para->sens->indexMoniPoints[i][2][2];
		T3 = var[TEMP][IX(ip, jp, kp)];
		/*Point4*/
		ip = para->sens->indexMoniPoints[i][3][0];
		jp = para->sens->indexMoniPoints[i][3][1];
		kp = para->sens->indexMoniPoints[i][3][2];
		T4 = var[TEMP][IX(ip, jp, kp)];

		/*calculate average rack-inlet temperature*/
		Tave = (T1 + T2 + T3 + T4) / 4;
		if (Tave > Tmax) {
			Tmax = Tave;
		}
	}
  }
  else {
	sprintf(msg, "maximum_rack_temp(): there's no rack in this case.");
	ffd_log(msg, FFD_ERROR);
	return 0;
  }

  return Tmax + 273.15;
}/* End of maximum_rack_temp() */
