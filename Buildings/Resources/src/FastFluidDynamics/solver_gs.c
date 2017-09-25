/*
	*
	* \file   solver_gs.c
	*
	* \brief  Gauss-Seidel solvers
	*
	* \author Mingang Jin, Qingyan Chen
	*         Purdue University
	*         Jin55@purdue.edu, YanChen@purdue.edu
	*         Wangda Zuo
	*         University of Miami
	*         W.Zuo@miami.edu
	*
	* \date   8/3/2013
	*
	*/

#include "solver_gs.h"

	/*
		* Gauss-Seidel solver for pressure
		*
		* @param para Pointer to FFD parameters
		* @param var Pointer to FFD simulation variables
		* @param Type Type of variable
		* @param x Pointer to variable
		*
		* @return Residual
		*/
REAL GS_P(PARA_DATA *para, REAL **var, int Type, REAL *x) {
  REAL *as = var[AS], *aw = var[AW], *ae = var[AE], *an = var[AN];
  REAL *ap = var[AP], *af = var[AF], *ab = var[AB], *b = var[B];
  int imax = para->geom->imax, jmax= para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  int i, j, k, it;
  REAL tmp1, tmp2, residual;
  REAL *flagp = var[FLAGP];

  /****************************************************************************
  | Solve the space using G-S sovler for 5 * 6 = 30 times
  ****************************************************************************/
  for(it=0; it<5; it++) {
    /*-------------------------------------------------------------------------
    | Solve in X(1->imax), Y(1->jmax), Z(1->kmax)
    -------------------------------------------------------------------------*/
    for(i=1; i<=imax; i++)
      for(j=1; j<=jmax; j++)
        for(k=1; k<=kmax; k++) {
          if (flagp[IX(i,j,k)]>=0) continue;
          /*if (i==imax && j==jmax && k==kmax) continue;*/

          x[IX(i,j,k)] = (  ae[IX(i,j,k)]*x[IX(i+1,j,k)]
                          + aw[IX(i,j,k)]*x[IX(i-1,j,k)]
                          + an[IX(i,j,k)]*x[IX(i,j+1,k)]
                          + as[IX(i,j,k)]*x[IX(i,j-1,k)]
                          + af[IX(i,j,k)]*x[IX(i,j,k+1)]
                          + ab[IX(i,j,k)]*x[IX(i,j,k-1)]
                          + b[IX(i,j,k)] ) / ap[IX(i,j,k)];
    }

    /*-------------------------------------------------------------------------
    | Solve in Y(1->kmax), X(1->imax), Z(1->kmax)
    -------------------------------------------------------------------------*/
    for(j=1; j<=jmax; j++)
      for(i=1; i<=imax; i++)
        for(k=1; k<=kmax; k++) {
          if (flagp[IX(i,j,k)]>=0) continue;
          /*if (i==imax && j==jmax && k==kmax) continue;*/

          x[IX(i,j,k)] = (  ae[IX(i,j,k)]*x[IX(i+1,j,k)]
                          + aw[IX(i,j,k)]*x[IX(i-1,j,k)]
                          + an[IX(i,j,k)]*x[IX(i,j+1,k)]
                          + as[IX(i,j,k)]*x[IX(i,j-1,k)]
                          + af[IX(i,j,k)]*x[IX(i,j,k+1)]
                          + ab[IX(i,j,k)]*x[IX(i,j,k-1)]
                          + b[IX(i,j,k)] ) / ap[IX(i,j,k)];
    }
    /*-------------------------------------------------------------------------
    | Solve in X(imax->), Y(jmax->1), Z(1->kmax)
    -------------------------------------------------------------------------*/
    for(i=imax; i>=1; i--)
      for(j=jmax; j>=1; j--)
        for(k=1; k<=kmax; k++) {
          if (flagp[IX(i,j,k)]>=0) continue;
          /*if (i==imax && j==jmax && k==kmax) continue;*/

          x[IX(i,j,k)] = (  ae[IX(i,j,k)]*x[IX(i+1,j,k)]
                          + aw[IX(i,j,k)]*x[IX(i-1,j,k)]
                          + an[IX(i,j,k)]*x[IX(i,j+1,k)]
                          + as[IX(i,j,k)]*x[IX(i,j-1,k)]
                          + af[IX(i,j,k)]*x[IX(i,j,k+1)]
                          + ab[IX(i,j,k)]*x[IX(i,j,k-1)]
                          + b[IX(i,j,k)] ) / ap[IX(i,j,k)];
    }
    /*-------------------------------------------------------------------------
    | Solve in Y(jmax->1), X(imax->1), Z(1->kmax)
    -------------------------------------------------------------------------*/
    for(j=jmax; j>=1; j--)
      for(i=imax; i>=1; i--)
        for(k=1; k<=kmax; k++) {
          if (flagp[IX(i,j,k)]>=0) continue;
          /*if (i==imax && j==jmax && k==kmax) continue;*/

          x[IX(i,j,k)] = (  ae[IX(i,j,k)]*x[IX(i+1,j,k)]
                          + aw[IX(i,j,k)]*x[IX(i-1,j,k)]
                          + an[IX(i,j,k)]*x[IX(i,j+1,k)]
                          + as[IX(i,j,k)]*x[IX(i,j-1,k)]
                          + af[IX(i,j,k)]*x[IX(i,j,k+1)]
                          + ab[IX(i,j,k)]*x[IX(i,j,k-1)]
                          + b[IX(i,j,k)] ) / ap[IX(i,j,k)];
    }
  }

  /****************************************************************************
  | Calculate residual
  ****************************************************************************/
  tmp1 = 0;
  tmp2 = (REAL)0.0000000001;

  FOR_EACH_CELL
    if (flagp[IX(i,j,k)]>=0) continue;
    /*if (i==imax && j==jmax && k==kmax) continue;*/
    tmp1 += (REAL) fabs(ap[IX(i,j,k)]*x[IX(i,j,k)]
        - ae[IX(i,j,k)]*x[IX(i+1,j,k)] - aw[IX(i,j,k)]*x[IX(i-1,j,k)]
        - an[IX(i,j,k)]*x[IX(i,j+1,k)] - as[IX(i,j,k)]*x[IX(i,j-1,k)]
        - af[IX(i,j,k)]*x[IX(i,j,k+1)] - ab[IX(i,j,k)]*x[IX(i,j,k-1)]
        - b[IX(i,j,k)]);
    tmp2 += (REAL) fabs(ap[IX(i,j,k)]*x[IX(i,j,k)]);
  END_FOR

  residual = tmp1 /tmp2;
  /*printf ("the pressure of cell[imax,jmax,kmax] is %f\n", x[IX(imax,jmax,kmax)]);*/
  /*printf ("the average pressure residual is %.12f\n", residual);*/
  /*printf ("it is %d \n", it);*/
  /*}*/
  return residual;

} /* End of GS_P()*/

	/*
		* Gauss-Seidel solver
		*
		* @param para Pointer to FFD parameters
		* @param var Pointer to FFD simulation variables
		* @param flag Pointer to the cell property flag
		* @param x Pointer to variable
		*
		* @return Residual
		*/
REAL Gauss_Seidel(PARA_DATA *para, REAL **var, REAL *flag, REAL *x) {
  REAL *as = var[AS], *aw = var[AW], *ae = var[AE], *an = var[AN];
  REAL *ap = var[AP], *af = var[AF], *ab = var[AB], *b = var[B];
  int imax = para->geom->imax, jmax= para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  int i, j, k, it=0;
  REAL tmp1, tmp2, residual;

  /****************************************************************************
  | Gauss-Seidel solver
  ****************************************************************************/
  for(it=0; it<20; it++) {
    for(i=1; i<=imax; i++)
      for(j=1; j<=jmax; j++)
        for(k=1; k<=kmax; k++) {
          if (flag[IX(i,j,k)]>=0) continue;


          x[IX(i,j,k)] = (  ae[IX(i,j,k)]*x[IX(i+1,j,k)]
                          + aw[IX(i,j,k)]*x[IX(i-1,j,k)]
                          + an[IX(i,j,k)]*x[IX(i,j+1,k)]
                          + as[IX(i,j,k)]*x[IX(i,j-1,k)]
                          + af[IX(i,j,k)]*x[IX(i,j,k+1)]
                          + ab[IX(i,j,k)]*x[IX(i,j,k-1)]
                          + b[IX(i,j,k)] ) / ap[IX(i,j,k)];

        }

    for(i=imax; i>=1; i--)
      for(j=jmax; j>=1; j--)
        for(k=kmax; k>=1; k--) {
          if (flag[IX(i,j,k)]>=0) continue;

          x[IX(i,j,k)] = (  ae[IX(i,j,k)]*x[IX(i+1,j,k)]
                          + aw[IX(i,j,k)]*x[IX(i-1,j,k)]
                          + an[IX(i,j,k)]*x[IX(i,j+1,k)]
                          + as[IX(i,j,k)]*x[IX(i,j-1,k)]
                          + af[IX(i,j,k)]*x[IX(i,j,k+1)]
                          + ab[IX(i,j,k)]*x[IX(i,j,k-1)]
                          + b[IX(i,j,k)] ) / ap[IX(i,j,k)];
        }
  }

  /****************************************************************************
  | Calculate residual
  ****************************************************************************/
  tmp1 = 0;
  tmp2 = (REAL)0.0000000001;

  FOR_EACH_CELL
    if (flag[IX(i,j,k)]>=0) continue;
    tmp1 += (REAL) fabs(ap[IX(i,j,k)]*x[IX(i,j,k)]
        - ae[IX(i,j,k)]*x[IX(i+1,j,k)] - aw[IX(i,j,k)]*x[IX(i-1,j,k)]
        - an[IX(i,j,k)]*x[IX(i,j+1,k)] - as[IX(i,j,k)]*x[IX(i,j-1,k)]
        - af[IX(i,j,k)]*x[IX(i,j,k+1)] - ab[IX(i,j,k)]*x[IX(i,j,k-1)]
        - b[IX(i,j,k)]);
    tmp2 += (REAL) fabs(ap[IX(i,j,k)]*x[IX(i,j,k)]);
  END_FOR

  residual = tmp1 /tmp2;
  /*printf ("the average residual for velocity/T is %.12f\n", tmp1/(imax*jmax*kmax));*/
  return residual;

} /* End of Gauss-Seidel( )*/
