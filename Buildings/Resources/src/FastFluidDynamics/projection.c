/****************************************************************************
| 
|  \file   projection.c
| 
|  \brief  Solver for projection step
| 
|  \author Mingang Jin, Qingyan Chen
|          Purdue University
|          Jin55@purdue.edu, YanChen@purdue.edu
|          Wangda Zuo
|          University of Miami, University of Colorado Boulder
|          W.Zuo@miami.edu, wangda.zuo@colorado.edu
|          Wei Tian
|          University of Miami, Schneider Electric
|          w.tian@umiami.edu, Wei.Tian@Schneider-Electric.com
| 
|  \date   6/15/2017
| 
****************************************************************************/

#include "projection.h"

/****************************************************************************
|  Project the velocity
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
| 
| \return 0 if no error occurred
****************************************************************************/
int project(PARA_DATA *para, REAL **var, int **BINDEX) {
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL dt= para->mytime->dt;
  REAL *x = var[X], *y = var[Y], *z = var[Z];
  REAL *gx = var[GX], *gy = var[GY], *gz = var[GZ];
  REAL *u = var[VX], *v = var[VY], *w = var[VZ];
  REAL *p = var[IP], *b = var[B], *ap = var[AP], *ab = var[AB], *af = var[AF];
  REAL *ae = var[AE], *aw =var[AW], *an = var[AN], *as = var[AS];
  REAL dxe,dxw, dyn,dys,dzf,dzb,Dx,Dy,Dz;
  REAL *flagu = var[FLAGU],*flagv = var[FLAGV],*flagw = var[FLAGW];
  int num_swipe = para->solv->swipe_pro;
  REAL *flagp = var[FLAGP];
  REAL residual = 0.0;
  REAL rho = para->prob->rho;
  REAL cell_vol = 0.0;

  /****************************************************************************
  | Calculate all coefficients
  ****************************************************************************/
  FOR_EACH_CELL
    dxe =  x[IX(i+1,j,  k)]   -  x[IX(i,  j,  k)];
    dxw =  x[IX(i,  j,  k)]   -  x[IX(i-1,j,  k)];
    dyn =  y[IX(i,  j+1,k)]   -  y[IX(i,  j,  k)];
    dys =  y[IX(i,  j,  k)]   -  y[IX(i,  j-1,k)];
    dzf =  z[IX(i,  j,  k+1)] -  z[IX(i,  j,  k)];
    dzb =  z[IX(i,  j,  k)]   -  z[IX(i,  j,  k-1)];
    Dx  = gx[IX(i,  j,  k)]   - gx[IX(i-1,j,  k)];
    Dy  = gy[IX(i,  j,  k)]   - gy[IX(i,  j-1,k)];
    Dz  = gz[IX(i,  j,  k)]   - gz[IX(i,  j,  k-1)];

    ae[IX(i,j,k)] = Dy*Dz/dxe;
    aw[IX(i,j,k)] = Dy*Dz/dxw;
    an[IX(i,j,k)] = Dx*Dz/dyn;
    as[IX(i,j,k)] = Dx*Dz/dys;
    af[IX(i,j,k)] = Dx*Dy/dzf;
    ab[IX(i,j,k)] = Dx*Dy/dzb;
    b[IX(i,j,k)] = rho*Dx*Dy*Dz/dt*((u[IX(i-1,j,k)]-u[IX(i,j,k)])/Dx
                 + (v[IX(i,j-1,k)]-v[IX(i,j,k)])/Dy
                 + (w[IX(i,j,k-1)]-w[IX(i,j,k)])/Dz);
  END_FOR

  /****************************************************************************
  | Projection step
  ****************************************************************************/
  set_bnd_pressure(para, var, p,BINDEX);

  FOR_EACH_CELL
    ap[IX(i,j,k)] = ae[IX(i,j,k)] + aw[IX(i,j,k)] + as[IX(i,j,k)] + an[IX(i,j,k)]
                  + af[IX(i,j,k)] + ab[IX(i,j,k)];
  END_FOR
  
  /* solve equations */
  if (para->solv->solver == GS) {
    Gauss_Seidel(para, var, p, flagp, num_swipe);
    }
  else {
    Jacobi(para, var, p, flagp, num_swipe);
  }

  /* check residual after iterative solver */
  if (para->solv->check_residual == 1) {
      residual = check_residual(para, var, p, var[FLAGP]);
      sprintf(msg, "Residual in projection: %f", residual);
      ffd_log(msg, FFD_NORMAL);
  }

  /* set boundary condition */
  set_bnd_pressure(para, var, p,BINDEX);

  /****************************************************************************
  | Correct the velocity
  ****************************************************************************/
  FOR_U_CELL
    if (flagu[IX(i,j,k)]>=0) continue;
    u[IX(i,j,k)] -= dt/rho*(p[IX(i+1,j,k)]-p[IX(i,j,k)]) / (x[IX(i+1,j,k)]-x[IX(i,j,k)]);
  END_FOR

  FOR_V_CELL
    if (flagv[IX(i,j,k)]>=0) continue;
    v[IX(i,j,k)] -= dt/rho*(p[IX(i,j+1,k)]-p[IX(i,j,k)]) / (y[IX(i,j+1,k)]-y[IX(i,j,k)]);
  END_FOR

  FOR_W_CELL
    if (flagw[IX(i,j,k)]>=0) continue;
    w[IX(i,j,k)] -= dt/rho*(p[IX(i,j,k+1)]-p[IX(i,j,k)]) / (z[IX(i,j,k+1)]-z[IX(i,j,k)]);
  END_FOR

  /****************************************************************************
  | Check mass imbalance if needed
  ****************************************************************************/
  if (para->solv->check_residual == 1) {
      residual = check_mass_imbalance(para, var);
      sprintf(msg, "mass imbalance after projection: %f", residual);
      ffd_log(msg, FFD_NORMAL);
  }

  return 0;
} /* End of project( ) */

/****************************************************************************
|  Check the mass imbalance after projection
|  This usually indicates that the energy balance after advection could be problematic.
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
| 
| \return 0 if no error occurred
****************************************************************************/
int check_mass_imbalance(PARA_DATA *para, REAL **var) {
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2)*(jmax + 2);
  REAL *u = var[VX], *v = var[VY], *w = var[VZ];
  REAL *gx = var[GX], *gy = var[GY], *gz = var[GZ];
  REAL *flagp = var[FLAGP];
  REAL tmp = 0.0, imbalance = 0.0;
  int count = 0;

  FOR_EACH_CELL
	if (flagp[IX(i, j, k)] >= 0) continue;
	imbalance = (u[IX(i, j, k)] - u[IX(i - 1, j, k)]) / (gx[IX(i, j, k)] - gx[IX(i - 1, j, k)]) +
				(v[IX(i, j, k)] - v[IX(i, j - 1, k)]) / (gy[IX(i, j, k)] - gy[IX(i, j - 1, k)]) +
				(w[IX(i, j, k)] - w[IX(i, j, k - 1)]) / (gz[IX(i, j, k)] - gz[IX(i, j, k - 1)]);
	tmp += imbalance*imbalance;
	count += 1;
  END_FOR
  return sqrt(tmp/count);
}

