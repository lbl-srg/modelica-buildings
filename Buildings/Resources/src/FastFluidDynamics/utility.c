/****************************************************************************
| 
|  \file   utility.c
| 
|  \brief  Some frequently used functions for FFD
| 
|  \author Wangda Zuo
|          University of Miami, University of Colorado Boulder
|          W.Zuo@miami.edu, wangda.zuo@colorado.edu
|          Purdue University
|          Mingang Jin, Qingyan Chen
|          Jin55@purdue.edu, YanChen@purdue.edu
|          Wei Tian
|          University of Miami, Schneider Electric
|          w.tian@umiami.edu, Wei.Tian@Schneider-Electric.com
|          Xu Han
|          University of Colorado Boulder
|          xuha3556@colorado.edu
|
|  \date   4/5/2020
|
|  \add: add a function min_distance to calculate the distance of
| 	 a fluid cell to the nearest solid boundary condition, which
| 	 is to be used by Chen's zero equation turbulence model
| 
****************************************************************************/

#include "utility.h"

/****************************************************************************
|  Check the residual of equation
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param psi Pointer to the variable
| 
| \return 0 if no error occurred
****************************************************************************/
REAL check_residual(PARA_DATA *para, REAL **var, REAL *x, REAL *flag) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int i, j, k;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *aw = var[AW], *ae = var[AE], *as = var[AS], *an = var[AN];
  REAL *ap = var[AP], *ab = var[AB], *af = var[AF], *b = var[B];
  REAL tmp=0.0, residual = 0.0;
  int count = 0;

  FOR_EACH_CELL
    if (flag[IX(i,j,k)] >= 0) continue;
    tmp = fabs(x[IX(i,j,k)]+ (
        - ae[IX(i,j,k)]*x[IX(i+1,j,k)] - aw[IX(i,j,k)]*x[IX(i-1,j,k)]
        - an[IX(i,j,k)]*x[IX(i,j+1,k)] - as[IX(i,j,k)]*x[IX(i,j-1,k)]
        - af[IX(i,j,k)]*x[IX(i,j,k+1)] - ab[IX(i,j,k)]*x[IX(i,j,k-1)]
        - b[IX(i,j,k)])/ ap[IX(i, j, k)] );
    count += 1;

    if (residual < tmp) residual = tmp;
  END_FOR

	return residual;

}/* End of check_residual( ) */

/****************************************************************************
|  Write the log file
| 
| \param message Pointer the message
| \param msg_type Type of message
| 
| \return 0 if no error occurred
****************************************************************************/
void ffd_log(char *message, FFD_MSG_TYPE msg_type) {
  if(msg_type==FFD_NEW) {
    if((file_log=fopen("log.ffd","w+"))==NULL) {
        fprintf(stderr, "Error:can not open error file!\n");
        exit(1);
    }
  }

  else if((file_log=fopen("log.ffd","a+"))==NULL) {
    fprintf(stderr,"Error:can not open error file!\n");
    exit(1);
  }

  switch(msg_type) {
    case FFD_WARNING:
      fprintf(file_log, "WARNING in %s\n", message);
      break;
    case FFD_ERROR:
      fprintf(file_log, "ERROR in %s\n", message);
      break;
    /* Normal log */
    default:
      fprintf(file_log, "%s\n", message);
  }
  fclose(file_log);
} /* End of ffd_log() */


/****************************************************************************
|  Check the outflow rate of the scalar psi
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param psi Pointer to the variable
| \param BINDEX Pointer to the boundary index
| 
| \return 0 if no error occurred
****************************************************************************/
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
    if(flagp[IX(i,j,k)]==2 || flagp[IX(i, j, k)] == TILE) {
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
} /* End of outflow() */


/****************************************************************************
|  Check the inflow rate of the scalar psi
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param psi Pointer to the variable
| \param BINDEX Pointer to the boundary index
| 
| \return 0 if no error occurred
****************************************************************************/
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

        if(flagp[IX(i,j,k)]==0)  {
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
} /* End of inflow() */


/****************************************************************************
|  Check the minimum value of the scalar psi at (ci,cj,ck) and its surrounding
|  cells
| 
| \param para Pointer to FFD parameters
| \param psi Pointer to the variable
| \param ci Index in x direction
| \param cj Index in y direction
| \param ck Index in z direction
| 
| \return 0 if no error occurred
****************************************************************************/
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

}/* End of check_min( ) */


/****************************************************************************
|  Check the maximum value of the scalar psi at (ci,cj,ck) and its surrounding
|  cells
| 
| \param para Pointer to FFD parameters
| \param psi Pointer to the variable
| \param ci Index in x direction
| \param cj Index in y direction
| \param ck Index in z direction
| 
| \return 0 if no error occurred
****************************************************************************/
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

}/* End of check_max( ) */

/****************************************************************************
|  Calculate averaged value of psi
| 
| \param para Pointer to FFD parameters
| \param psi Pointer to the variable
| 
| \return Non-weighted average
****************************************************************************/
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

}/* End of average( ) */


/****************************************************************************
|  Calculate volume weighted averaged value of psi in a space
| 
|  The average is weighted by volume of each cell
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param psi Pointer to the variable
| 
| \return Volume weighted average
****************************************************************************/
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

}/* End of average_volume( ) */


/****************************************************************************
|  Calculate time averaged value
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| 
| 
| \return 0 if no error occurred
****************************************************************************/
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

  /* Wall surfaces */
  for(i=0; i<para->bc->nb_wall; i++)
    para->bc->temHeaMean[i] = para->bc->temHeaMean[i] / step;

  /* Fluid ports */
  for(i=0; i<para->bc->nb_port; i++) {
    para->bc->TPortMean[i] = para->bc->TPortMean[i] / step;
    para->bc->velPortMean[i] = para->bc->velPortMean[i] / step;

    for(j=0; j<para->bc->nb_Xi; j++)
      para->bc->XiPortMean[i][j] = para->bc->XiPortMean[i][j] / step;
    for(j=0; j<para->bc->nb_C; j++)
      para->bc->CPortMean[i][j] = para->bc->CPortMean[i][j] / step;
  }

  /* Sensor data */
  para->sens->TRooMean = para->sens->TRooMean / step;
  for(i=0; i<para->sens->nb_sensor; i++)
    para->sens->senValMean[i] = para->sens->senValMean[i] / step;

  return 0;
} /* End of average_time() */

/****************************************************************************
|  Reset time averaged value to 0
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| 
| 
| \return 0 if no error occurred
****************************************************************************/
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

  /* Wall surfaces */
  for(i=0; i<para->bc->nb_wall; i++)
    para->bc->temHeaMean[i] = 0;

  /* Fluid ports */
  for(i=0; i<para->bc->nb_port; i++) {
    para->bc->TPortMean[i] = 0;
    para->bc->velPortMean[i] = 0;

    for(j=0; j<para->bc->nb_Xi; j++)
      para->bc->XiPortMean[i][j] = 0;
    for(j=0; j<para->bc->nb_C; j++)
      para->bc->CPortMean[i][j] = 0;
  }

  /* Sensor data */
  para->sens->TRooMean = 0;
  for(i=0; i<para->sens->nb_sensor; i++)
    para->sens->senValMean[i] = 0;


  /*Reset the time step to 0*/
  para->mytime->step_mean = 0;
  return 0;
} /* End of reset_time_averaged_data() */

/****************************************************************************
|  Add time averaged value for the time average later on
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| 
| 
| \return 0 if no error occurred
****************************************************************************/
int add_time_averaged_data(PARA_DATA *para, REAL **var) {
  int i, j;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int size = (imax+2) * (jmax+2) * (kmax+2);

  /* All the cells */
  for(i=0; i<size; i++) {
    var[VXM][i] += var[VX][i];
    var[VYM][i] += var[VY][i];
    var[VZM][i] += var[VZ][i];
    var[TEMPM][i] += var[TEMP][i];
  }

  /* Wall surfaces */
  for(i=0; i<para->bc->nb_wall; i++)
    para->bc->temHeaMean[i] += para->bc->temHeaAve[i];

  /* Fluid ports */
  for(i=0; i<para->bc->nb_port; i++) {
    para->bc->TPortMean[i] += para->bc->TPortAve[i];
    para->bc->velPortMean[i] += para->bc->velPortAve[i];

    for(j=0; j<para->bc->nb_Xi; j++)
      para->bc->XiPortMean[i][j] += para->bc->XiPortAve[i][j];
    for(j=0; j<para->bc->nb_C; j++)
      para->bc->CPortMean[i][j] += para->bc->CPortAve[i][j];

  }

  /* Sensor data */
  para->sens->TRooMean += para->sens->TRoo;
  for(j=0; j<para->sens->nb_sensor; j++)
    para->sens->senValMean[j] += para->sens->senVal[j];

  /* Update the step */
  para->mytime->step_mean++;

  return 0;
} /* End of add_time_averaged_data() */

/****************************************************************************
|  Check the energy transfer rate through the wall to the air
| 
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to the boundary index
| 
| \return 0 if no error occurred
| 
| \change h as it may change when flow is assumed to be turublent
| 
****************************************************************************/
REAL qwall(PARA_DATA *para, REAL **var,int **BINDEX) {
  int i, j, k;
  int it;
  int index = para->geom->index;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *psi=var[TEMP];
  REAL *gx = var[GX], *gy = var[GY], *gz = var[GZ];
  REAL coeff_h=para->prob->coeff_h*para->prob->Cp;
  REAL D = 1.0;
  REAL qwall=0;
  REAL axy, ayz, azx; /* Area of surfaces */
  REAL qwall_bc = 0.0;
  REAL *qflux = var[QFLUX];
  REAL *flagp = var[FLAGP];
  REAL A = 0.0;

  for(it=0; it<index; it++) {
    i=BINDEX[0][it];
    j=BINDEX[1][it];
    k=BINDEX[2][it];

    axy = area_xy(para, var, i, j, k);
    ayz = area_yz(para, var, i, j, k);
    azx = area_zx(para, var, i, j, k);

    if(flagp[IX(i,j,k)]==1) {
      if(i==0) {
        if(flagp[IX(i+1,j,k)]<0) {
          D = 0.5 * length_x(para, var, i + 1, j, k);
          coeff_h = h_coef(para, var, i + 1, j, k, D);
          qwall += (psi[IX(i,j,k)]-psi[IX(i+1,j,k)])*coeff_h*ayz;
          qwall_bc -= qflux[IX(i,j,k)]*ayz;
          A += ayz;
        }
      }
      else if(i==imax+1) {
        if(flagp[IX(i-1,j,k)]<0) {
          D = 0.5 * length_x(para, var, i - 1, j, k);
          coeff_h = h_coef(para, var, i - 1, j, k, D);
          qwall += (psi[IX(i,j,k)]-psi[IX(i-1,j,k)])*coeff_h*ayz;
          qwall_bc -= qflux[IX(i, j, k)] * ayz;
          A += ayz;
        }
      }
      else {
        if(flagp[IX(i+1,j,k)]<0) {
          D = 0.5 * length_x(para, var, i + 1, j, k);
          coeff_h = h_coef(para, var, i + 1, j, k, D);
          qwall += (psi[IX(i,j,k)]-psi[IX(i+1,j,k)])*coeff_h*ayz;
          qwall_bc -= qflux[IX(i, j, k)] * ayz;
          A += ayz;
        }
        if(flagp[IX(i-1,j,k)]<0) {
          D = 0.5 * length_x(para, var, i - 1, j, k);
          coeff_h = h_coef(para, var, i - 1, j, k, D);
          qwall += (psi[IX(i,j,k)]-psi[IX(i-1,j,k)])*coeff_h*ayz;
          qwall_bc -= qflux[IX(i, j, k)] * ayz;
          A += ayz;
        }
      }

      if(j==0) {
        if(flagp[IX(i,j+1,k)]<0) {
          D = 0.5 * length_y(para, var, i, j + 1, k);
          coeff_h = h_coef(para, var, i, j + 1, k, D);
          qwall += (psi[IX(i,j,k)]-psi[IX(i,j+1,k)])*coeff_h*azx;
          qwall_bc -= qflux[IX(i, j, k)] * azx;
          A += azx;
       }
      }
      else if(j==jmax+1) {
        if(flagp[IX(i,j-1,k)]<0) {
          D = 0.5 * length_y(para, var, i, j - 1, k);
          coeff_h = h_coef(para, var, i, j - 1, k, D);
          qwall += (psi[IX(i,j,k)]-psi[IX(i,j-1,k)])*coeff_h*azx;
          qwall_bc -= qflux[IX(i, j, k)] * azx;
          A += azx;
        }
      }
      else {
        if(flagp[IX(i,j-1,k)]<0) {
          D = 0.5 * length_y(para, var, i, j - 1, k);
          coeff_h = h_coef(para, var, i, j - 1, k, D);
          qwall += (psi[IX(i,j,k)]-psi[IX(i,j-1,k)])*coeff_h*azx;
          qwall_bc -= qflux[IX(i, j, k)] * azx;
          A += azx;
      }
        if(flagp[IX(i,j+1,k)]<0) {
          D = 0.5 * length_y(para, var, i, j + 1, k);
          coeff_h = h_coef(para, var, i, j + 1, k, D);
          qwall += (psi[IX(i,j,k)]-psi[IX(i,j+1,k)])*coeff_h*azx;
          qwall_bc -= qflux[IX(i, j, k)] * azx;
          A += azx;
        }
      }

      if(k==0) {
        if(flagp[IX(i,j,k+1)]<0) {
          D = 0.5 * length_z(para, var, i, j, k + 1);
          coeff_h = h_coef(para, var, i, j, k + 1, D);
          qwall += (psi[IX(i,j,k)]-psi[IX(i,j,k+1)])*coeff_h*axy;
          qwall_bc -= qflux[IX(i, j, k)] * axy;
          A += axy;
        }
      }
      else if(k==kmax+1) {
        if(flagp[IX(i,j,k-1)]<0) {
          D = 0.5 * length_z(para, var, i, j, k - 1);
          coeff_h = h_coef(para, var, i, j, k - 1, D);
          qwall += (psi[IX(i,j,k)]-psi[IX(i,j,k-1)])*coeff_h*axy;
          qwall_bc -= qflux[IX(i, j, k)] * axy;
          A += axy;
        }
      }
      else {
        if(flagp[IX(i,j,k+1)]<0) {
          D = 0.5 * length_z(para, var, i, j, k + 1);
          coeff_h = h_coef(para, var, i, j, k + 1, D);
          qwall += (psi[IX(i,j,k)]-psi[IX(i,j,k+1)])*coeff_h*axy;
          qwall_bc -= qflux[IX(i, j, k)] * axy;
          A += axy;
        }
        if(flagp[IX(i,j,k-1)]<0) {
          D = 0.5 * length_z(para, var, i, j, k - 1);
          coeff_h = h_coef(para, var, i, j, k - 1, D);
          qwall += (psi[IX(i,j,k)]-psi[IX(i,j,k-1)])*coeff_h*axy;
          qwall_bc -= qflux[IX(i, j, k)] * axy;
          A += axy;
        }
      }
    }
  }

  if (para->solv->check_residual == 1) {
      sprintf(msg, "Wall heat flux is %f", qwall_bc);
      ffd_log(msg, FFD_NORMAL);
  }

  return qwall;

} /* End of qwall() */

/****************************************************************************
|  Free memory for BINDEX
| 
| \param BINDEX Pointer to the boundary index
| 
| 
| \return 0 if no error occurred
****************************************************************************/
void free_index(int **BINDEX) {
  if(BINDEX[0]) free(BINDEX[0]);
  if(BINDEX[1]) free(BINDEX[1]);
  if(BINDEX[2]) free(BINDEX[2]);
  if(BINDEX[3]) free(BINDEX[3]);
  if(BINDEX[4]) free(BINDEX[4]);
  if(BINDEX[5]) free(BINDEX[5]);
} /* End of free_index () */

/****************************************************************************
|  Free memory for FFD simulation variables
| 
| \param var Pointer to FFD simulation variables
| 
| 
| \return 0 if no error occurred
****************************************************************************/
void free_data(REAL **var) {
  int nb_var = C2BC + 1;
  int i;
  for (i = 0; i < nb_var; i++) {
	if (var[i]) free(var[i]);
  }
} /* End of free_data() */

/****************************************************************************
|  Determine the maximum value of given scalar variable
| 
| \param para Pointer to FFD parameters
| \param dat Pointer to scalar variable
| 
| \return Smax Maximum value of the scalar variable
****************************************************************************/
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
} /* End of scalar_global_max() */

/****************************************************************************
|  Determine the minimum value of given scalar variable
| 
| \param para Pointer to FFD parameters
| \param dat Pointer to scalar variable
| 
| \return Smin Minimum value of the scalar variable
****************************************************************************/
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
} /* End of scalar_global_min() */

/****************************************************************************
|  Determine the maximum velocity
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| 
| \return Vmax Maximum velocity in the simulated domain
****************************************************************************/
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
} /* End of  V_global_max() */

/****************************************************************************
|  Determine the minimum velocity
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| 
| \return Vmin Minimum velocity in the simulated domain
****************************************************************************/
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
} /* End of V_global_min() */

/****************************************************************************
|  Check the minimum to the solid boudaries
|  cells used in calculation of zero equation tuebulence model
| 
| \param para Pointer to FFD parameters
| \param var Pointer to the variable
| \param
| 
| \return 0 if no error occurred
****************************************************************************/
int min_distance(PARA_DATA *para, REAL **var, int **BINDEX) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int i, j, k;
  REAL *x = var[X], *y = var[Y], *z = var[Z];
  int it, i_bc, j_bc, k_bc;
  int index = para->geom->index;
  int IMAX = imax + 2, IJMAX = (imax + 2)*(jmax + 2);
  REAL tmp = 1e12; /* define a large number */
  REAL lx, ly, lz, l;

  /* Loop all the fluid cells */
  FOR_EACH_CELL
    /* initiate the tmp variable after every iteragion */
    tmp = 1e12;
    /* pass if the cell is not fluid */
    if (var[FLAGP][IX(i, j, k)] >= 0) continue;
    /* go through all the boudnary conditions and find minimal */
    for (it = 0; it < index; it++) {
      i_bc = BINDEX[0][it];
      j_bc = BINDEX[1][it];
      k_bc = BINDEX[2][it];
      if (var[FLAGP][IX(i_bc, j_bc, k_bc)] == INLET || var[FLAGP][IX(i_bc, j_bc, k_bc)] == OUTLET) continue;
      /* caculate the distance in each dimension and find the Euler distance l */
      lx = fabs(x[IX(i, j, k)] - x[IX(i_bc, j_bc, k_bc)]);
      ly = fabs(y[IX(i, j, k)] - y[IX(i_bc, j_bc, k_bc)]);
      lz = fabs(z[IX(i, j, k)] - z[IX(i_bc, j_bc, k_bc)]);
      l = sqrt(lx*lx + ly*ly + lz*lz);
      /* store the minimal value during the looping to tmp */
      if (l < tmp) {
        tmp = l;
      }
    }
  /* store the minimal value associated with (i,j,k) to global var */
  var[MIN_DISTANCE][IX(i, j, k)] = tmp;

  END_FOR
  return 0;

}/* End of min_distance( ) */

 /****************************************************************************
 |  Check the volumetric inflow rate
 | 
 | \param para Pointer to FFD parameters
 | \param var Pointer to FFD simulation variables
 | \param psi Pointer to the variable
 | \param BINDEX Pointer to the boundary index
 | 
 | \return 0 if no error occurred
 ****************************************************************************/
REAL vol_inflow(PARA_DATA *para, REAL **var, int **BINDEX) {
  int i, j, k;
  int it;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int index = para->geom->index;
  int IMAX = imax + 2, IJMAX = (imax + 2)*(jmax + 2);
  REAL *gx = var[GX], *gy = var[GY], *gz = var[GZ];
  REAL *u = var[VX], *v = var[VY], *w = var[VZ];
  REAL mass_in = 0;
  REAL *flagp = var[FLAGP];

  /*---------------------------------------------------------------------------
  | Compute the total inflow
  ---------------------------------------------------------------------------*/
  for (it = 0; it<index; it++) {
    i = BINDEX[0][it];
    j = BINDEX[1][it];
    k = BINDEX[2][it];

    if (flagp[IX(i, j, k)] == 0) {
      if (i == 0) mass_in += u[IX(i, j, k)] * (gy[IX(i, j, k)]
          - gy[IX(i, j - 1, k)])* (gz[IX(i, j, k)] - gz[IX(i, j, k - 1)]);

      if (i == imax + 1) mass_in += (-u[IX(i, j, k)])*(gy[IX(i, j, k)]
          - gy[IX(i, j - 1, k)])* (gz[IX(i, j, k)] - gz[IX(i, j, k - 1)]);

      if (j == 0) mass_in += v[IX(i, j, k)] * (gx[IX(i, j, k)]
          - gx[IX(i - 1, j, k)])* (gz[IX(i, j, k)] - gz[IX(i, j, k - 1)]);

      if (j == jmax + 1) mass_in += (-v[IX(i, j, k)])*(gx[IX(i, j, k)]
          - gx[IX(i - 1, j, k)])* (gz[IX(i, j, k)] - gz[IX(i, j, k - 1)]);

      if (k == 0) mass_in += w[IX(i, j, k)] * (gx[IX(i, j, k)]
          - gx[IX(i - 1, j, k)])* (gy[IX(i, j, k)] - gy[IX(i, j - 1, k)]);

      if (k == kmax + 1) mass_in += (-w[IX(i, j, k)])*(gx[IX(i, j, k)]
          - gx[IX(i - 1, j, k)])* (gy[IX(i, j, k)] - gy[IX(i, j - 1, k)]);
    }
  }
  return mass_in;
} /* End of vol_inflow() */

/****************************************************************************
|  Check the volumetric inflow rate
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param psi Pointer to the variable
| \param BINDEX Pointer to the boundary index
| 
| \return 0 if no error occurred
****************************************************************************/
REAL vol_outflow(PARA_DATA *para, REAL **var, int **BINDEX){
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
    if(flagp[IX(i,j,k)]==OUTLET) {
      if(i==0) {
        mass_out += (-u[IX(i,j,k)])
                  * (gy[IX(i,j,k)]-gy[IX(i,j-1,k)])
                  * (gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
      }
      else if (i==imax+1) {
        mass_out += u[IX(i-1,j,k)]
                  * (gy[IX(i,j,k)]-gy[IX(i,j-1,k)])
                  * (gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
      }
      else {
        mass_out += u[IX(i,j,k)]
                  * (gy[IX(i,j,k)]-gy[IX(i,j-1,k)])
                  * (gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
      }

      if(j==0) {
        mass_out += (-v[IX(i,j,k)])*(gx[IX(i,j,k)]
                          -gx[IX(i-1,j,k)])* (gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
      }
      else if (j==jmax+1) {
        mass_out += v[IX(i,j-1,k)]*(gx[IX(i,j,k)]
                          -gx[IX(i-1,j,k)])* (gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
      }
      else {
        mass_out += v[IX(i,j,k)]*(gx[IX(i,j,k)]
                          -gx[IX(i-1,j,k)])* (gz[IX(i,j,k)]-gz[IX(i,j,k-1)]);
      }

      if(k==0) {
        mass_out += (-w[IX(i,j,k)])*(gx[IX(i,j,k)]
                          -gx[IX(i-1,j,k)])* (gy[IX(i,j,k)]-gy[IX(i,j-1,k)]);
      }
      else if (k==kmax+1){
        mass_out += w[IX(i,j,k-1)]*(gx[IX(i,j,k)]
                          -gx[IX(i-1,j,k)])* (gy[IX(i,j,k)]-gy[IX(i,j-1,k)]);
      }
      else {
        mass_out += w[IX(i,j,k)]*(gx[IX(i,j,k)]
                          -gx[IX(i-1,j,k)])* (gy[IX(i,j,k)]-gy[IX(i,j-1,k)]);
      }
    }
  }

  return mass_out;
}

/****************************************************************************
|  Check flow rates through all the tiles
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to the boundary index
| 
| \return 0 if no error occurred
****************************************************************************/
FILE *FILE_TILE_FLOW;
int check_tile_flowrate(PARA_DATA *para, REAL **var, int **BINDEX) {
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2)*(jmax + 2);
  int it, id;
  int index = para->geom->index;
  REAL *flagp = var[FLAGP];
  int nb_ports = para->bc->nb_port;
  REAL A=0.0, V_tmp=0.0;
  REAL Axy=0.0, Ayz=0.0, Azx=0.0;
  REAL *QPort = para->bc->QPort;
  REAL *u = var[VX], *v = var[VY], *w = var[VZ];
  int put_X = para->geom->tile_putX, put_Y =para->geom->tile_putY, put_Z = para->geom->tile_putZ;

  /* Set the value of para->bc->QPort =0 */
  for (i = 0; i < para->bc->nb_port; i++) {
    QPort[i] = 0.0;
  }

  /* Loop all the boundary cells and calculate the flow rates at tiles */
  for (it = 0; it < index; it++) {
    i = BINDEX[0][it];
    j = BINDEX[1][it];
    k = BINDEX[2][it];
    id = BINDEX[4][it];

    if (flagp[IX(i, j, k)] == TILE) {
      /* West or East Boundary */
      if (put_X) {
        A = area_yz(para, var, i, j, k);

        if (i > 0)
            V_tmp = u[IX(i - 1, j, k)];
        else
            V_tmp = u[IX(i, j, k)];

        QPort[id] += V_tmp*A;
      }
      /* South and North Boundary */
      if (put_Y) {
        A = area_zx(para, var, i, j, k);

        if (j > 0)
          V_tmp = v[IX(i, j - 1, k)];
        else
          V_tmp = v[IX(i, j, k)];

        QPort[id] += V_tmp*A;
      }
      /* Ceiling and Floor Boundary */
      if (put_Z) {
        A = area_xy(para, var, i, j, k);

        if (k >0 )
            V_tmp = w[IX(i, j, k - 1)];
        else
            V_tmp = w[IX(i, j, k)];

        QPort[id] += V_tmp*A;
      }
    }
    else if (flagp[IX(i, j, k)] == OUTLET) {
		/* West or East Boundary */
		A = area_yz(para, var, i, j, k);

		if (i > 0)
		  V_tmp = u[IX(i - 1, j, k)];
		else
		  V_tmp = u[IX(i, j, k)];

		QPort[id] += V_tmp*A;
		/* South and North Boundary */
		A = area_zx(para, var, i, j, k);

		if (j > 0)
		  V_tmp = v[IX(i, j - 1, k)];
		else
		  V_tmp = v[IX(i, j, k)];

		QPort[id] += V_tmp*A;
		/* Ceiling and Floor Boundary */
		A = area_xy(para, var, i, j, k);

		if (k >0 )
		  V_tmp = w[IX(i, j, k - 1)];
		else
		  V_tmp = w[IX(i, j, k)];

		QPort[id] += V_tmp*A;
    }
    else if (flagp[IX(i, j, k)] == INLET) {
      Ayz = area_yz(para, var, i, j, k);
      Azx = area_zx(para, var, i, j, k);
      Axy = area_xy(para, var, i, j, k);

      if (i > 0)
        V_tmp = u[IX(i - 1, j, k)];
      else
        V_tmp = u[IX(i, j, k)];

      QPort[id] += V_tmp*Ayz;

      if (j > 0)
        V_tmp = v[IX(i, j - 1, k)];
      else
        V_tmp = v[IX(i, j, k)];

      QPort[id] += V_tmp*Azx;

      if (k >0 )
        V_tmp = w[IX(i, j, k - 1)];
      else
        V_tmp = w[IX(i, j, k)];

      QPort[id] += V_tmp*Axy;
    }
  } /*end of for*/

  /* Write the results into files */
  if (para->mytime->step_current == 0) {
    /* create a new .dat file */
    if ((FILE_TILE_FLOW = fopen("tile_flowrates.dat", "w+")) == NULL) {
      fprintf(stderr, "Error:can not open error file!\n");
      exit(1);
    }
    fprintf(FILE_TILE_FLOW, "Time\t");
    for (i = 0; i < para->bc->nb_port; i++) {
      fprintf(FILE_TILE_FLOW, "%s\t", para->bc->portName[i]);
    }
    fprintf(FILE_TILE_FLOW, "\n");
    fprintf(FILE_TILE_FLOW, "%.4f\t", para->mytime->t);
    for (i = 0; i < para->bc->nb_port; i++) {
      fprintf(FILE_TILE_FLOW, "%f\t", QPort[i] * 2118.88);
    }
    fprintf(FILE_TILE_FLOW, "\n");
    fclose(FILE_TILE_FLOW);
  }
  else {
    if ((FILE_TILE_FLOW = fopen("tile_flowrates.dat", "a+")) == NULL) {
      fprintf(stderr, "Error:can not open error file!\n");
      exit(1);
    }
    fprintf(FILE_TILE_FLOW, "%.4f\t", para->mytime->t);
    for (i = 0; i < para->bc->nb_port; i++) {
      fprintf(FILE_TILE_FLOW, "%f\t", QPort[i] * 2118.88);
    }
    fprintf(FILE_TILE_FLOW, "\n");

    fclose(FILE_TILE_FLOW);
  }
  /* Output to screen or txt files */

  if(para->outp->version==DEBUG){
    for (i = 0; i < para->bc->nb_port; i++) {
      printf("%s--->>>>>>>>>>%f CFM\t\n",para->bc->portName[i],QPort[i]* 2118.88);
    }
  }
  return 0;
}

/****************************************************************************
|  Check flow rates at inlets when t=0
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to the boundary index
| 
| \return 0 if no error occurred
****************************************************************************/
REAL initial_inflows(PARA_DATA *para, REAL **var, int **BINDEX) {
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2)*(jmax + 2);
  int it, id;
  int index = para->geom->index;
  REAL *flagp = var[FLAGP];
  int nb_ports = para->bc->nb_port;
  REAL A = 0.0, V_tmp = 0.0;
  REAL *QPort = para->bc->QPort;
  REAL *u = var[VXBC], *v = var[VYBC], *w = var[VZBC];
  REAL inflow = 0.0;

  /* Loop all the boundary cells and calculate the flow rates at tiles */
  for (it = 0; it < index; it++) {
    i = BINDEX[0][it];
    j = BINDEX[1][it];
    k = BINDEX[2][it];
    id = BINDEX[4][it];
    if (flagp[IX(i, j, k)] == INLET) {
      /* West or East Boundary */
      if (i == 0 || i == imax + 1) {
        A = area_yz(para, var, i, j, k);

        if (i == 0)
          V_tmp = u[IX(i, j, k)];
        else
          V_tmp = -1*u[IX(i, j, k)];

        QPort[id] += V_tmp*A;
      }
      /* South and North Boundary */
      if (j == 0 || j == jmax + 1) {
        A = area_zx(para, var, i, j, k);

        if (j == 0)
          V_tmp = v[IX(i, j, k)];
        else
          V_tmp = -1*v[IX(i, j, k)];

        inflow += V_tmp*A;
      }
      /* Ceiling and Floor Boundary */
      if (k == 0 || k == kmax + 1) {
        A = area_xy(para, var, i, j, k);

        if (k == 0)
          V_tmp = w[IX(i, j, k)];
        else
          V_tmp = -1*w[IX(i, j, k)];

        inflow += V_tmp*A;
      }
    }
  } /*end of for*/

  return inflow;
}

/****************************************************************************
|  Parse the command-line argument
| 
| \param argc number of argument
| \param argv command-line argument
| 
| \return 0 if no error occurred
****************************************************************************/
int parse_argument(int argc, char **argv, int *platform_device) {
  size_t optind;
  for (optind = 1; optind < argc && argv[optind][0] == '-'; optind++) {
    switch (argv[optind][1]) {
      case 'P'/*platform*/:
        platform_device[0] = argv[optind][2] - '0';
        break;
      case 'p'/*platform*/:
        platform_device[0] = argv[optind][2] - '0';
        break;
      case 'C'/*CPU*/:
        platform_device[1] = argv[optind][2] - '0';
        break;
      case 'c'/*CPU*/:
        platform_device[1] = argv[optind][2] - '0';
        break;
      case 'G'/*GPU*/:
        platform_device[2] = argv[optind][2] - '0';
        break;
      case 'g'/*GPU*/:
        platform_device[2] = argv[optind][2] - '0';
        break;
      default:
        printf("parse_argument(): command-line argument is not legal");
        exit(1);
    }
  }
  return 0; /* if it is "-1", that means the device or platform is not */
}

/****************************************************************************
|  calculate momentum kick: 1/rho*S (unit: N/kg)
|  1/rho*S = V_dot*(V1-V2)/V = A*V2*(V2/beta-V2)/A*h = V2*(V2/beta-V2)/h
|  where: V1 and V2 are the velocities supposing that tiles are partially or fully open
|         A is tha area of tile, h is the height of the space, beta is open-area-ratio
|  return 1/rho*S
****************************************************************************/
REAL get_momentum_kick(REAL V2,REAL beta, REAL h){
  REAL momentum_kick = 0.0;
  momentum_kick = V2*(V2/beta-V2)/h;
  return momentum_kick;
}

/****************************************************************************
|  find the monitoring points in front of each rack
|  monitors are 6 inch (0.1524 m) in front of rack
|  FIXME: ONLY ABLE TO HANDLE RACK WHOSE AIRLOW IS IN X DIRECTION!
|  return 0 if all points are found
****************************************************************************/
int get_monitor_points(PARA_DATA *para, REAL **var,int SI,int SJ,int SK, int EI,int EJ,int EK,int rack_flow_direction,int id_rack){
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2)*(jmax + 2);
  REAL delta = 0.0;
  REAL length = 0.0;
  REAL monitorX=0.0, monitorY=0.0, monitorZ=0.0;

  /* calculate length in Y */
  i = SI;
  k = SK;
  for (j=SJ;j<=EJ;j++){
    if (j==0){
      delta = 0.0;
    }
    else{
      delta = var[GY][IX(i,j,k)]-var[GY][IX(i,j-1,k)];
    }
    length += delta;
  }
  /* find the base coordinate for all monitor points (on the floor) */
  monitorY = var[GY][IX(SI,EJ,SK)] - 0.5*length;
  /* find monitorZ base */
  if (SK == 0){
    monitorZ = var[GZ][IX(SI,SJ,SK)];
  }
  else{
    monitorZ = var[GZ][IX(SI,SJ,SK-1)];
  }
  /* find monitorX base, which is dependent on the flow direction in rack */
  if (sign(rack_flow_direction) == 1){
    if (SI==0){
      ffd_log("get_monitor_points(): monitor points are ouside the domain",FFD_ERROR);
      return 1;
    }
    else{
      monitorX = var[GX][IX(SI-1,SJ,SK)] - 0.1524;
    }
  }
  else if (sign(rack_flow_direction) == -1){
    monitorX = var[GX][IX(EI,SJ,SK)] + 0.1524;
  }
  else{
    ffd_log("get_monitor_points(): ONLY ABLE TO HANDLE RACK FLOW DIRECTION OF X",FFD_ERROR);
    return 1;
  }

  /* manually set the height of the monitor points based on the paper */
  /* Zachary Pardey, Jim VanGilder, 2015, CREATING A CALIBRATED CFD MODEL OF A MIDSIZE DATA CENTER */
  /* P1: 0.53m, P2: 0.91m, P3: 1.30m, P4: 1.68m in Z direction */
  /* para->sens->coordMoniPoints[A][B][C]-> A: which rack; B: which monitor point; C: which coordinate */
  for(i=0;i<4;i++){
    para->sens->coordMoniPoints[id_rack][i][0] = monitorX;
    para->sens->coordMoniPoints[id_rack][i][1] = monitorY;
  }
  para->sens->coordMoniPoints[id_rack][0][2] = monitorZ + 0.53;
  para->sens->coordMoniPoints[id_rack][1][2] = monitorZ + 0.91;
  para->sens->coordMoniPoints[id_rack][2][2] = monitorZ + 1.30;
  para->sens->coordMoniPoints[id_rack][3][2] = monitorZ + 1.68;

  /* return */
  return 0;
}

/****************************************************************************
|  find the indexes of the monitoring points
|  monitors are 6 inch (0.1524 m) in front of rack
|  FIXME: ONLY ABLE TO HANDLE RACK WHOSE AIRLOW IS IN X DIRECTION!
|  return 0 if all points are found
****************************************************************************/
int get_monitor_index(PARA_DATA *para, REAL **var){
  int i, j, k;
  int ip=0,jp=0,kp=0;
  int id,point;
  REAL xp,yp,zp;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2)*(jmax + 2);
  REAL *flagp = var[FLAGP];
  REAL eulerian_dis;
  REAL minimal_dis;
  /* loop all the cells, which can be very time consuming */
  for(id=0;id<para->bc->nb_rack;id++){
    for (point=0;point<4;point++){
      xp = para->sens->coordMoniPoints[id][point][0];
      yp = para->sens->coordMoniPoints[id][point][1];
      zp = para->sens->coordMoniPoints[id][point][2];
      minimal_dis = 1e5;
      /* find the closest fluid cell */
      FOR_ALL_CELL
        if (flagp[IX(i,j,k)]!=FLUID) continue;
        eulerian_dis = sqrt( (xp-var[X][IX(i,j,k)])*(xp-var[X][IX(i,j,k)])
                            +(yp-var[Y][IX(i,j,k)])*(yp-var[Y][IX(i,j,k)])
                            +(zp-var[Z][IX(i,j,k)])*(zp-var[Z][IX(i,j,k)]));
        if (eulerian_dis<minimal_dis){
          minimal_dis = eulerian_dis;
          ip = i;
          jp = j;
          kp = k;
        }
      END_FOR
      /* update index */
      para->sens->indexMoniPoints[id][point][0] = ip;
      para->sens->indexMoniPoints[id][point][1] = jp;
      para->sens->indexMoniPoints[id][point][2] = kp;
    }
  }
  return 0;
}

/****************************************************************************
|  write temperature at monitoring points
|  monitors are 6 inch (0.1524 m) in front of rack
|  FIXME: ONLY ABLE TO HANDLE RACK WHOSE AIRLOW IS IN X DIRECTION!
|  return 0 if all points are found
****************************************************************************/
int write_monitor_data(PARA_DATA *para, REAL **var){
  int i, j;
  int ip,jp,kp;
  REAL T1,T2,T3,T4;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2)*(jmax + 2);
  FILE *datafile;
  /* find monitor index */
  if (get_monitor_index(para,var)!=0){
    ffd_log("write_monitor_data(): cannot find the index of monitoring cells",FFD_ERROR);
  }
  /* open output file */
  if ((datafile = fopen("monitor_data.dat", "w+")) == NULL) {
    ffd_log("write_monitor_data(): Failed to open output file!\n", FFD_ERROR);
    return 1;
  }
  /* write header */
  fprintf(datafile,"Rack\t\tP1\t\tP2\t\tP3\t\tP4\t\t\n");
  for(i=0;i<para->bc->nb_rack;i++){
    /* P1 */
    ip = para->sens->indexMoniPoints[i][0][0];
    jp = para->sens->indexMoniPoints[i][0][1];
    kp = para->sens->indexMoniPoints[i][0][2];
    T1 = var[TEMP][IX(ip,jp,kp)];
    /* P2 */
    ip = para->sens->indexMoniPoints[i][1][0];
    jp = para->sens->indexMoniPoints[i][1][1];
    kp = para->sens->indexMoniPoints[i][1][2];
    T2 = var[TEMP][IX(ip,jp,kp)];
    /* P3 */
    ip = para->sens->indexMoniPoints[i][2][0];
    jp = para->sens->indexMoniPoints[i][2][1];
    kp = para->sens->indexMoniPoints[i][2][2];
    T3 = var[TEMP][IX(ip,jp,kp)];
    /* P4 */
    ip = para->sens->indexMoniPoints[i][3][0];
    jp = para->sens->indexMoniPoints[i][3][1];
    kp = para->sens->indexMoniPoints[i][3][2];
    T4 = var[TEMP][IX(ip,jp,kp)];
    /* write results */
    fprintf(datafile,"%s\t%.2f\t%.2f\t%.2f\t%.2f\n",para->bc->rackName[i],T1,T2,T3,T4);
  }

  fclose(datafile);
  return 0;
}
