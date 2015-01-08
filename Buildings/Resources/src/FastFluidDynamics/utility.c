///////////////////////////////////////////////////////////////////////////////
///
/// \file   utility.c
///
/// \brief  Some frequently used functions for FFD
///
/// \author Wangda Zuo, Ana Cohen
///         University of Miami
///         W.Zuo@miami.edu
///         Purdue University
///         Mingang Jin, Qingyan Chen
///         Jin55@purdue.edu, YanChen@purdue.edu
///
/// \date   8/3/2013
///
///////////////////////////////////////////////////////////////////////////////

#include "utility.h"

///////////////////////////////////////////////////////////////////////////////
/// Check the residual of equation
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param psi Pointer to the variable
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
REAL check_residual(PARA_DATA *para, REAL **var, REAL *x) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int i, j, k;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *aw = var[AW], *ae = var[AE], *as = var[AS], *an = var[AN];
  REAL *ap = var[AP], *ab = var[AB], *af = var[AF], *b = var[B];
  REAL tmp, residual = 0.0;

  FOR_EACH_CELL
    tmp = ap[IX(i,j,k)]*x[IX(i,j,k)]
        - ae[IX(i,j,k)]*x[IX(i+1,j,k)] - aw[IX(i,j,k)]*x[IX(i-1,j,k)]
        - an[IX(i,j,k)]*x[IX(i,j+1,k)] - as[IX(i,j,k)]*x[IX(i,j-1,k)]
        - af[IX(i,j,k)]*x[IX(i,j,k+1)] - ab[IX(i,j,k)]*x[IX(i,j,k-1)]
        - b[IX(i,j,k)];
    residual += tmp * tmp;
  END_FOR

  return residual / (imax*jmax*kmax);

}// End of check_residual( )

///////////////////////////////////////////////////////////////////////////////
/// Write the log file
///
///\param message Pointer the message
///\param msg_type Type of message
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
void ffd_log(char *message, FFD_MSG_TYPE msg_type) {
  char mymsg[400];
  if(msg_type==FFD_NEW) {
    if((file_log=fopen("ffd.log","w+"))==NULL) {
        fprintf(stderr, "Error: Cannot open log file.\n");
        exit(1);
    }
  }
  else if((file_log=fopen("ffd.log","a+"))==NULL) {
    fprintf(stderr,"Error: Cannot open log file.\n");
    exit(1);
  }

  switch(msg_type) {
    case FFD_WARNING:
    case FFD_ERROR:
      fprintf(file_log, "ERROR in %s\n", message);
      sprintf(mymsg, "ERROR in FFD: %s\n", message);
      modelicaError(mymsg);
      break;
    // Normal log
    default:
      fprintf(file_log, "%s\n", message);
  }
  fclose(file_log);
} // End of ffd_log()

///////////////////////////////////////////////////////////////////////////////
/// Check the outflow rate of the scalar psi
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param psi Pointer to the variable
///\param BINDEX Pointer to the boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
REAL outflow(PARA_DATA *para, REAL **var, REAL *psi, int **BINDEX) {
  int i, j, k;
  int it;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int index= para->geom->index;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *gx = var[GX], *gy = var[GY], *gz = var[GZ];
  REAL *u = var[VX], *v = var[VY], *w = var[VZ];
  REAL mass_out=0;
  REAL *flagp = var[FLAGP];

  /*---------------------------------------------------------------------------
  | Compute the total outflow
  ---------------------------------------------------------------------------*/
  for(it=0;it<index;it++) {
    i=BINDEX[0][it];
    j=BINDEX[1][it];
    k=BINDEX[2][it];
    if(flagp[IX(i,j,k)]==2) {
      if(i==0)
        mass_out += psi[IX(i,j,k)] * (-u[IX(i,j,k)])
                  * (gy[IX(i,j,k)]-gy[IX(i,j-1,k)])
                  * (gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
      if(i==imax+1)
        mass_out += psi[IX(i-1,j,k)] * u[IX(i-1,j,k)]
                  * (gy[IX(i,j,k)]-gy[IX(i,j-1,k)])
                  * (gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
      if(j==0) mass_out += psi[IX(i,j,k)]*(-v[IX(i,j,k)])*(gx[IX(i,j,k)]
                          -gx[IX(i-1,j,k)])* (gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
      if(j==jmax+1) mass_out += psi[IX(i,j,k)]*v[IX(i,j-1,k)]*(gx[IX(i,j,k)]
                          -gx[IX(i-1,j,k)])* (gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
      if(k==0) mass_out += psi[IX(i,j,k)]*(-w[IX(i,j,k)])*(gx[IX(i,j,k)]
                          -gx[IX(i-1,j,k)])* (gy[IX(i,j,k)]-gy[IX(i,j-1,k)]);
      if(k==kmax+1) mass_out += psi[IX(i,j,k)]*w[IX(i,j,k-1)]*(gx[IX(i,j,k)]
                          -gx[IX(i-1,j,k)])* (gy[IX(i,j,k)]-gy[IX(i,j-1,k)]);
    }

  }

  return mass_out;
} // End of outflow()


///////////////////////////////////////////////////////////////////////////////
/// Check the inflow rate of the scalar psi
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param psi Pointer to the variable
///\param BINDEX Pointer to the boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
REAL inflow(PARA_DATA *para, REAL **var, REAL *psi, int **BINDEX) {
  int i, j, k;
  int it;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int index= para->geom->index;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *gx = var[GX], *gy = var[GY], *gz = var[GZ];
  REAL *u = var[VX], *v = var[VY], *w = var[VZ];
  REAL mass_in=0;
  REAL *flagp = var[FLAGP];

  /*---------------------------------------------------------------------------
  | Compute the total inflow
  ---------------------------------------------------------------------------*/
    for(it=0;it<index;it++) {
		  i=BINDEX[0][it];
      j=BINDEX[1][it];
      k=BINDEX[2][it];

        if(flagp[IX(i,j,k)]==0)	{
					if(i==0) mass_in += psi[IX(i,j,k)]*u[IX(i,j,k)]*(gy[IX(i,j,k)]
                              -gy[IX(i,j-1,k)])* (gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
					if(i==imax+1) mass_in += psi[IX(i,j,k)]*(-u[IX(i,j,k)])*(gy[IX(i,j,k)]
                              -gy[IX(i,j-1,k)])* (gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
					if(j==0) mass_in += psi[IX(i,j,k)]*v[IX(i,j,k)]*(gx[IX(i,j,k)]
                              -gx[IX(i-1,j,k)])* (gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
					if(j==jmax+1) mass_in += psi[IX(i,j,k)]*(-v[IX(i,j,k)])*(gx[IX(i,j,k)]
                              -gx[IX(i-1,j,k)])* (gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
					if(k==0) mass_in += psi[IX(i,j,k)]*w[IX(i,j,k)]*(gx[IX(i,j,k)]
                              -gx[IX(i-1,j,k)])* (gy[IX(i,j,k)]-gy[IX(i,j-1,k)]);
					if(k==kmax+1) mass_in += psi[IX(i,j,k)]*(-w[IX(i,j,k)])*(gx[IX(i,j,k)]
                              -gx[IX(i-1,j,k)])* (gy[IX(i,j,k)]-gy[IX(i,j-1,k)]);
			  }
	  }

	return mass_in;
} // End of inflow()


///////////////////////////////////////////////////////////////////////////////
/// Check the minimum value of the scalar psi at (ci,cj,ck) and its surrounding
/// cells
///
///\param para Pointer to FFD parameters
///\param psi Pointer to the variable
///\param ci Index in x direction
///\param cj Index in y direction
///\param ck Index in z direction
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
REAL check_min(PARA_DATA *para, REAL *psi, int ci, int cj, int ck) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int i, j, k;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL tmp = psi[IX(ci,cj,ck)];


  for(i=0;i<=1;i++)
    for(j=0;j<=1;j++)
      for(k=0;k<=1;k++) {
        if(tmp>psi[IX(ci+i,cj+j,ck+k)]) tmp=psi[IX(ci+i,cj+j,ck+k)];
      }

 return tmp;

}// End of check_min( )


///////////////////////////////////////////////////////////////////////////////
/// Check the maximum value of the scalar psi at (ci,cj,ck) and its surrounding
/// cells
///
///\param para Pointer to FFD parameters
///\param psi Pointer to the variable
///\param ci Index in x direction
///\param cj Index in y direction
///\param ck Index in z direction
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
REAL check_max(PARA_DATA *para, REAL *psi, int ci, int cj, int ck) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int i, j, k;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL tmp = psi[IX(ci,cj,ck)];

  for(i=0;i<=1;i++)
    for(j=0;j<=1;j++)
      for(k=0;k<=1;k++) {
        if(tmp<psi[IX(ci+i,cj+j,ck+k)]) tmp=psi[IX(ci+i,cj+j,ck+k)];
      }

return tmp;

}// End of check_max( )

///////////////////////////////////////////////////////////////////////////////
/// Calculate averaged value of psi
///
///\param para Pointer to FFD parameters
///\param psi Pointer to the variable
///
///\return Non-weighted average
///////////////////////////////////////////////////////////////////////////////
REAL average(PARA_DATA *para, REAL *psi) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int i, j, k;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL tmp=0;

  FOR_EACH_CELL
    tmp +=psi[IX(i,j,k)];
  END_FOR

  return tmp / (imax*jmax*kmax);

}// End of average( )


///////////////////////////////////////////////////////////////////////////////
/// Calculate volume weighted averaged value of psi in a space
///
/// The average is weighted by volume of each cell
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param psi Pointer to the variable
///
///\return Volume weighted average
///////////////////////////////////////////////////////////////////////////////
REAL average_volume(PARA_DATA *para, REAL **var, REAL *psi) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int i, j, k;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL tmp1 = 0, tmp2 = 0;

  if (para->geom->volFlu==0)
    return 0;
  else {
    FOR_EACH_CELL
      if(var[FLAGP][IX(i,j,k)]==FLUID) {
        tmp1 = vol(para, var, i, j, k);
        tmp2 += psi[IX(i,j,k)]*tmp1;
      }
      else
        continue;
    END_FOR

    return tmp2 / para->geom->volFlu;
  }

}// End of average_volume( )


///////////////////////////////////////////////////////////////////////////////
/// Calculate time averaged value
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int average_time(PARA_DATA *para, REAL **var) {
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  int step = para->mytime->step_mean;

  FOR_ALL_CELL
    var[VXM][IX(i,j,k)] = var[VXM][IX(i,j,k)] / step;
    var[VYM][IX(i,j,k)] = var[VYM][IX(i,j,k)] / step;
    var[VZM][IX(i,j,k)] = var[VZM][IX(i,j,k)] / step;
    var[TEMPM][IX(i,j,k)] = var[TEMPM][IX(i,j,k)] / step;
  END_FOR

  // Wall surfaces
  for(i=0; i<para->bc->nb_wall; i++)
    para->bc->temHeaMean[i] = para->bc->temHeaMean[i] / step;

  // Fluid ports
  for(i=0; i<para->bc->nb_port; i++) {
    para->bc->TPortMean[i] = para->bc->TPortMean[i] / step;
    para->bc->velPortMean[i] = para->bc->velPortMean[i] / step;

    for(j=0; j<para->bc->nb_Xi; j++)
      para->bc->XiPortMean[i][j] = para->bc->XiPortMean[i][j] / step;
    for(j=0; j<para->bc->nb_C; j++)
      para->bc->CPortMean[i][j] = para->bc->CPortMean[i][j] / step;
  }

  // Sensor data
  para->sens->TRooMean = para->sens->TRooMean / step;
  for(i=0; i<para->sens->nb_sensor; i++)
    para->sens->senValMean[i] = para->sens->senValMean[i] / step;

  return 0;
} // End of average_time()

///////////////////////////////////////////////////////////////////////////////
/// Reset time averaged value to 0
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int reset_time_averaged_data (PARA_DATA *para, REAL **var) {
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);


  FOR_ALL_CELL
    var[VXM][IX(i,j,k)] = 0;
    var[VYM][IX(i,j,k)] = 0;
    var[VZM][IX(i,j,k)] = 0;
    var[TEMPM][IX(i,j,k)] = 0;
  END_FOR

  // Wall surfaces
  for(i=0; i<para->bc->nb_wall; i++)
    para->bc->temHeaMean[i] = 0;

  // Fluid ports
  for(i=0; i<para->bc->nb_port; i++) {
    para->bc->TPortMean[i] = 0;
    para->bc->velPortMean[i] = 0;

    for(j=0; j<para->bc->nb_Xi; j++)
      para->bc->XiPortMean[i][j] = 0;
    for(j=0; j<para->bc->nb_C; j++)
      para->bc->CPortMean[i][j] = 0;
  }

  // Sensor data
  para->sens->TRooMean = 0;
  for(i=0; i<para->sens->nb_sensor; i++)
    para->sens->senValMean[i] = 0;


  //Reset the time step to 0
  para->mytime->step_mean = 0;
  return 0;
} // End of reset_time_averaged_data()

///////////////////////////////////////////////////////////////////////////////
/// Add time averaged value for the time average later on
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int add_time_averaged_data(PARA_DATA *para, REAL **var) {
  int i, j;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int size = (imax+2) * (jmax+2) * (kmax+2);

  // All the cells
  for(i=0; i<size; i++) {
    var[VXM][i] += var[VX][i];
    var[VYM][i] += var[VY][i];
    var[VZM][i] += var[VZ][i];
    var[TEMPM][i] += var[TEMP][i];
  }

  // Wall surfaces
  for(i=0; i<para->bc->nb_wall; i++)
    para->bc->temHeaMean[i] += para->bc->temHeaAve[i];

  // Fluid ports
  for(i=0; i<para->bc->nb_port; i++) {
    para->bc->TPortMean[i] += para->bc->TPortAve[i];
    para->bc->velPortMean[i] += para->bc->velPortAve[i];

    for(j=0; j<para->bc->nb_Xi; j++)
      para->bc->XiPortMean[i][j] += para->bc->XiPortAve[i][j];
    for(j=0; j<para->bc->nb_C; j++)
      para->bc->CPortMean[i][j] += para->bc->CPortAve[i][j];

  }

  // Sensor data
  para->sens->TRooMean += para->sens->TRoo;
  for(j=0; j<para->sens->nb_sensor; j++)
    para->sens->senValMean[j] += para->sens->senVal[j];

  // Update the step
  para->mytime->step_mean++;

  return 0;
} // End of add_time_averaged_data()

///////////////////////////////////////////////////////////////////////////////
/// Check the energy transfer rate through the wall to the air
///
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param BINDEX Pointer to the boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
REAL qwall(PARA_DATA *para, REAL **var,int **BINDEX) {
  int i, j, k;
  int it;
  int index = para->geom->index;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *psi=var[TEMP];
  REAL *gx = var[GX], *gy = var[GY], *gz = var[GZ];
  REAL coeff_h=para->prob->coeff_h;
  REAL qwall=0;

  REAL *flagp = var[FLAGP];

  for(it=0; it<index; it++) {
    i=BINDEX[0][it];
    j=BINDEX[1][it];
    k=BINDEX[2][it];

    if(flagp[IX(i,j,k)]==1) {
      if(i==0) {
        if(flagp[IX(i+1,j,k)]<0) {
          qwall += (psi[IX(i,j,k)]-psi[IX(i+1,j,k)])*coeff_h
                *(gy[IX(i,j,k)]-gy[IX(i,j-1,k)])*(gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
        }
      }
      else if(i==imax+1) {
	      if(flagp[IX(i-1,j,k)]<0) {
          qwall += (psi[IX(i,j,k)]-psi[IX(i-1,j,k)])*coeff_h
                *(gy[IX(i,j,k)]-gy[IX(i,j-1,k)])*(gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
        }
      }
		  else {
			  if(flagp[IX(i+1,j,k)]<0) {
          qwall += (psi[IX(i,j,k)]-psi[IX(i+1,j,k)])*coeff_h
                *(gy[IX(i,j,k)]-gy[IX(i,j-1,k)])*(gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
        }
				if(flagp[IX(i-1,j,k)]<0) {
          qwall += (psi[IX(i,j,k)]-psi[IX(i-1,j,k)])*coeff_h
                *(gy[IX(i,j,k)]-gy[IX(i,j-1,k)])*(gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
        }
			}

	  	if(j==0) {
        if(flagp[IX(i,j+1,k)]<0) {
          qwall += (psi[IX(i,j,k)]-psi[IX(i,j+1,k)])*coeff_h
                *(gx[IX(i,j,k)]-gx[IX(i-1,j,k)])*(gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
       }
		  }
		  else if(j==jmax+1) {
		    if(flagp[IX(i,j-1,k)]<0) {
         qwall += (psi[IX(i,j,k)]-psi[IX(i,j-1,k)])*coeff_h
                *(gx[IX(i,j,k)]-gx[IX(i-1,j,k)])*(gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
        }
	  	}
		  else {
		    if(flagp[IX(i,j-1,k)]<0) {
          qwall += (psi[IX(i,j,k)]-psi[IX(i,j-1,k)])*coeff_h
                *(gx[IX(i,j,k)]-gx[IX(i-1,j,k)])*(gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
      }
			  if(flagp[IX(i,j+1,k)]<0) {
          qwall += (psi[IX(i,j,k)]-psi[IX(i,j+1,k)])*coeff_h
                *(gx[IX(i,j,k)]-gx[IX(i-1,j,k)])*(gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
        }
			}

			if(k==0) {
        if(flagp[IX(i,j,k+1)]<0) {
          qwall += (psi[IX(i,j,k)]-psi[IX(i,j,k+1)])*coeff_h
                *(gy[IX(i,j,k)]-gy[IX(i,j-1,k)])*(gx[IX(i,j,k)]-gx[IX(i-1,j,k)]);
        }
			}
			else if(k==kmax+1) {
		    if(flagp[IX(i,j,k-1)]<0) {
          qwall += (psi[IX(i,j,k)]-psi[IX(i,j,k-1)])*coeff_h
                *(gy[IX(i,j,k)]-gy[IX(i,j-1,k)])*(gx[IX(i,j,k)]-gx[IX(i-1,j,k)]);
        }
      }
      else {
        if(flagp[IX(i,j,k+1)]<0) {
          qwall += (psi[IX(i,j,k)]-psi[IX(i,j,k+1)])*coeff_h
                *(gy[IX(i,j,k)]-gy[IX(i,j-1,k)])*(gx[IX(i,j,k)]-gx[IX(i-1,j,k)]);
        }
        if(flagp[IX(i,j,k-1)]<0) {
          qwall += (psi[IX(i,j,k)]-psi[IX(i,j,k-1)])*coeff_h
                *(gy[IX(i,j,k)]-gy[IX(i,j-1,k)])*(gx[IX(i,j,k)]-gx[IX(i-1,j,k)]);
        }
      }
    }
  }

  return qwall;

} // End of qwall()

///////////////////////////////////////////////////////////////////////////////
/// Free memory for BINDEX
///
///\param BINDEX Pointer to the boundary index
///
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
void free_index(int **BINDEX) {
  if(BINDEX[0]) free(BINDEX[0]);
  if(BINDEX[1]) free(BINDEX[1]);
  if(BINDEX[2]) free(BINDEX[2]);
} // End of free_index ()

///////////////////////////////////////////////////////////////////////////////
/// Free memory for FFD simulation variables
///
///\param var Pointer to FFD simulation variables
///
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
void free_data(REAL **var) {
  if(var[X]) free(var[X]);
  if(var[Y]) free(var[Y]);
  if(var[Z]) free(var[Z]);
  if(var[VX]) free(var[VX]);
  if(var[VY]) free(var[VY]);
  if(var[VZ]) free(var[VZ]);
  if(var[VXS]) free(var[VXS]);
  if(var[VYS]) free(var[VYS]);
  if(var[VZS]) free(var[VZS]);
  if(var[VXM]) free(var[VXM]);
  if(var[VYM]) free(var[VYM]);
  if(var[VZM]) free(var[VZM]);
  if(var[TEMP]) free(var[TEMP]);
  if(var[TEMPM]) free(var[TEMPM]);
  if(var[TEMPS]) free(var[TEMPS]);
  if(var[IP]) free(var[IP]);
  if(var[TMP1]) free(var[TMP1]);
  if(var[TMP2]) free(var[TMP2]);
  if(var[TMP3]) free(var[TMP3]);
  if(var[AP]) free(var[AP]);
  if(var[AN]) free(var[AN]);
  if(var[AS]) free(var[AS]);
  if(var[AE]) free(var[AE]);
  if(var[AW]) free(var[AW]);
  if(var[AF]) free(var[AF]);
  if(var[AB]) free(var[AB]);
  if(var[B])  free(var[B]);
  if(var[GX])  free(var[GX]);
  if(var[GY])  free(var[GY]);
  if(var[GZ])  free(var[GZ]);
  if(var[AP0])  free(var[AP0]);
  if(var[PP])  free(var[PP]);
  if(var[FLAGP])  free(var[FLAGP]);
  if(var[FLAGU])  free(var[FLAGU]);
  if(var[FLAGV])  free(var[FLAGV]);
  if(var[FLAGW])  free(var[FLAGW]);
  if(var[LOCMIN])  free(var[LOCMIN]);
  if(var[LOCMAX])  free(var[LOCMAX]);
  if(var[VXBC])  free(var[VXBC]);
  if(var[VYBC])  free(var[VYBC]);
  if(var[VZBC])  free(var[VZBC]);
  if(var[TEMPBC])  free(var[TEMPBC]);
  if(var[Xi1])  free(var[Xi1]);
  if(var[Xi2])  free(var[Xi2]);
  if(var[Xi1BC])  free(var[Xi1BC]);
  if(var[Xi2BC])  free(var[Xi2BC]);
  if(var[C1])  free(var[C1]);
  if(var[C2])  free(var[C2]);
  if(var[C1BC])  free(var[C1BC]);
  if(var[C2BC])  free(var[C2BC]);
  if(var[QFLUXBC])  free(var[QFLUXBC]);
  if(var[QFLUX])  free(var[QFLUX]);

} // End of free_data()

///////////////////////////////////////////////////////////////////////////////
/// Determine the maximum value of given scalar variable
///
///\param para Pointer to FFD parameters
///\param dat Pointer to scalar variable
///
///\return Smax Maximum value of the scalar variable
///////////////////////////////////////////////////////////////////////////////
REAL scalar_global_max(PARA_DATA *para, REAL *dat) {
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL Smax;

  Smax = dat[IX(1,1,1)];

  FOR_ALL_CELL
    Smax = Smax > dat[IX(i,j,k)] ? Smax : dat[IX(i,j,k)];
  END_FOR

  return Smax;
} // End of scalar_global_max()

///////////////////////////////////////////////////////////////////////////////
/// Determine the minimum value of given scalar variable
///
///\param para Pointer to FFD parameters
///\param dat Pointer to scalar variable
///
///\return Smin Minimum value of the scalar variable
///////////////////////////////////////////////////////////////////////////////
REAL scalar_global_min(PARA_DATA *para, REAL *dat) {
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL SMin;

  SMin = dat[IX(1,1,1)];

  FOR_ALL_CELL
    SMin = SMin < dat[IX(i,j,k)] ? SMin : dat[IX(i,j,k)];
  END_FOR

  return SMin;
} // End of scalar_global_min()

///////////////////////////////////////////////////////////////////////////////
/// Determine the maximum velocity
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///
///\return Vmax Maximum velocity in the simulated domain
///////////////////////////////////////////////////////////////////////////////
REAL V_global_max(PARA_DATA *para, REAL **var) {
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *u = var[VX], *v = var[VY], *w = var[VZ];
  REAL Vmax, tmp;

  Vmax = 0;

  FOR_ALL_CELL
    tmp = (u[IX(i,j,k)]*u[IX(i,j,k)] + v[IX(i,j,k)]*v[IX(i,j,k)]
         + w[IX(i,j,k)]*w[IX(i,j,k)]);
     Vmax =Vmax > tmp ? Vmax : tmp;
  END_FOR

  return sqrt(Vmax);
} // End of  V_global_max()

///////////////////////////////////////////////////////////////////////////////
/// Determine the minimum velocity
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///
///\return Vmin Minimum velocity in the simulated domain
///////////////////////////////////////////////////////////////////////////////
REAL V_global_min(PARA_DATA *para, REAL **var) {
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *u = var[VX], *v = var[VY], *w = var[VZ];
  REAL tmp, Vmin;

  Vmin = 0;

  FOR_ALL_CELL
    tmp = (u[IX(i,j,k)]*u[IX(i,j,k)])+(v[IX(i,j,k)]*v[IX(i,j,k)]
         + w[IX(i,j,k)]*w[IX(i,j,k)]);
    Vmin = Vmin < tmp ? Vmin : tmp;
  END_FOR

  return sqrt(Vmin);
} // End of V_global_min()
