/*
	*
	* \file   solver_tdma.c
	*
	* \brief Tri-Diagonal Matrix Algorithm Solver
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

#include "solver_tdma.h"

	/*
		* TDMA solver for 3D
		*
		* @param para Pointer to FFD parameters
		* @param var Pointer to FFD simulation variables
		* @param type Type of variable
		* @param psi Pointer to variable
		*
		* @return 0 if no error occurred
		*/
int TDMA_3D(PARA_DATA *para, REAL **var, int type, REAL *psi) {
  int imax = para->geom->imax;
  int jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int i, j, k;

  /*West to East*/
  for(i=1; i<=imax; i++) {
    if(TDMA_YZ(para, var, psi, i)) {
      ffd_log("TDMA_3D: Could not compute TDMA_YZ.", FFD_ERROR);
      return 1;
    }
  }
  /*South to North*/
  for(j=1; j<=jmax; j++) {
    if(TDMA_ZX(para, var, psi, j)) {
      ffd_log("TDMA_3D: Could not compute TDMA_ZX.", FFD_ERROR);
      return 1;
    }
  }
  /*Back to Front*/
  for(k=1; k<=kmax; k++) {
    if(TDMA_XY(para, var, psi, k)) {
      ffd_log("TDMA_3D: Could not compute TDMA_XY.", FFD_ERROR);
      return 1;
    }
  }
  /*East to West*/
  for(i=imax; i>=1; i--) {
    if(TDMA_YZ(para, var, psi, i)) {
      ffd_log("TDMA_3D: Could not compute TDMA_YZ.", FFD_ERROR);
      return 1;
    }
  }
  /*North to South*/
  for(j=jmax; j>=1; j--) {
    if(TDMA_ZX(para, var, psi, j)) {
      ffd_log("TDMA_3D: Could not compute TDMA_ZX.", FFD_ERROR);
      return 1;
    }
  }
  /*Front to Back*/
  for(k=kmax; k>=1; k--) {
    if(TDMA_XY(para, var, psi, k)) {
      ffd_log("TDMA_3D: Could not compute TDMA_YZ.", FFD_ERROR);
      return 1;
    }
  }
  return 0;
}/* end of TDMA_3D()*/

	/*
		* TDMA solver for XY-plane
		*
		* @param para Pointer to FFD parameters
		* @param var Pointer to FFD simulation variables
		* @param psi Pointer to variable
		* @param k K-index of the plane
		*
		* @return 0 if no error occurred
		*/
int TDMA_XY(PARA_DATA *para, REAL **var, REAL *psi, int k) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int i, j;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *b = var[B], *ap = var[AP], *af = var[AF], *ab = var[AB];
  REAL *ae = var[AE], *aw =var[AW], *an = var[AN], *as = var[AS];
  REAL *temp_ap, *temp_aw, *temp_ae, *temp_b, *temp_psi;

  temp_ap = (REAL *) malloc((jmax+1)*sizeof(REAL));
  if(temp_ap==NULL) {
    ffd_log("TDMA_XY(): Could not allocate memory for temp_ap.",
            FFD_ERROR);
    return 1;
  }
  temp_ae = (REAL *) malloc((jmax+1)*sizeof(REAL));
  if(temp_ae==NULL) {
    ffd_log("TDMA_XY(): Could not allocate memory for temp_ae.",
            FFD_ERROR);
    return 1;
  }
  temp_aw = (REAL *) malloc((jmax+1)*sizeof(REAL));
  if(temp_aw==NULL) {
    ffd_log("TDMA_XY(): Could not allocate memory for temp_aw.",
            FFD_ERROR);
    return 1;
  }
  temp_b = (REAL *) malloc((jmax+1)*sizeof(REAL));
  if(temp_b==NULL) {
    ffd_log("TDMA_XY(): Could not allocate memory for temp_b.",
            FFD_ERROR);
    return 1;
  }
  temp_psi = (REAL *) malloc((jmax+1)*sizeof(REAL));
  if(temp_psi==NULL) {
    ffd_log("TDMA_XY(): Could not allocate memory for temp_psi.",
            FFD_ERROR);
    return 1;
  }

  /*line-by-line from West to East*/
  for(i=1; i<=imax; i++) {
    for(j=1; j<=jmax; j++) {
      temp_b[j] = b[IX(i,j,k)]
                + ae[IX(i,j,k)]*psi[IX(i+1,j,k)] + aw[IX(i,j,k)]*psi[IX(i-1,j,k)]
                + af[IX(i,j,k)]*psi[IX(i,j,k+1)] + ab[IX(i,j,k)]*psi[IX(i,j,k-1)];
      temp_ap[j] = ap[IX(i,j,k)];
      temp_aw[j] = as[IX(i,j,k)];
      temp_ae[j] = an[IX(i,j,k)];
      temp_psi[j] = psi[IX(i,j,k)];
    }

    if(TDMA_1D(temp_ap, temp_ae, temp_aw, temp_b, temp_psi, jmax)) {
      ffd_log("TDMA_XY(): Could not compute TDMA_1D", FFD_ERROR);
      return 1;
    }
    for(j=1; j<=jmax; j++)
      psi[IX(i,j,k)] = temp_psi[j];
  }

  free(temp_ap);
  free(temp_ae);
  free(temp_aw);
  free(temp_b);
  free(temp_psi);
  return 0;
} /* End of TDMA_XY()*/

	/*
		* TDMA solver for YZ-plane
		*
		* @param para Pointer to FFD parameters
		* @param var Pointer to FFD simulation variables
		* @param psi Pointer to variable
		* @param i I-index of the plane
		*
		* @return 0 if no error occurred
		*/
int TDMA_YZ(PARA_DATA *para, REAL **var, REAL *psi, int i)
{
  int imax = para->geom->imax;
  int jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int j, k;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *b = var[B], *ap = var[AP], *af = var[AF], *ab = var[AB];
  REAL *ae = var[AE], *aw =var[AW], *an = var[AN], *as = var[AS];
  REAL *temp_ap, *temp_aw, *temp_ae, *temp_b, *temp_psi;

  temp_ap = (REAL *) malloc((kmax+1)*sizeof(REAL));
  if(temp_ap==NULL) {
    ffd_log("TDMA_YZ(): Could not allocate memory for temp_ap.",
            FFD_ERROR);
    return 1;
  }
  temp_ae = (REAL *) malloc((kmax+1)*sizeof(REAL));
  if(temp_ae==NULL) {
    ffd_log("TDMA_YZ(): Could not allocate memory for temp_ae.",
            FFD_ERROR);
    return 1;
  }
  temp_aw = (REAL *) malloc((kmax+1)*sizeof(REAL));
  if(temp_aw==NULL) {
    ffd_log("TDMA_YZ(): Could not allocate memory for temp_aw.",
            FFD_ERROR);
    return 1;
  }
  temp_b = (REAL *) malloc((kmax+1)*sizeof(REAL));
  if(temp_b==NULL) {
    ffd_log("TDMA_YZ(): Could not allocate memory for temp_b.",
            FFD_ERROR);
    return 1;
  }
  temp_psi = (REAL *) malloc((kmax+1)*sizeof(REAL));
  if(temp_psi==NULL) {
    ffd_log("TDMA_YZ(): Could not allocate memory for temp_psi.",
            FFD_ERROR);
    return 1;
  }

  /*line-by-line from South to North*/
  for(j=1; j<=jmax; j++) {
    for(k=1; k<=kmax; k++) {
      temp_b[k] = b[IX(i,j,k)]
                + ae[IX(i,j,k)]*psi[IX(i+1,j,k)] + aw[IX(i,j,k)]*psi[IX(i-1,j,k)]
                + an[IX(i,j,k)]*psi[IX(i,j+1,k)] + as[IX(i,j,k)]*psi[IX(i,j-1,k)];
      temp_ap[k] = ap[IX(i,j,k)];
      temp_aw[k] = ab[IX(i,j,k)];
      temp_ae[k] = af[IX(i,j,k)];
      temp_psi[k] = psi[IX(i,j,k)];
    }

    if(TDMA_1D(temp_ap, temp_ae, temp_aw, temp_b, temp_psi, kmax)) {
      ffd_log("TDMA_YZ(): Could not compute TDMA_1D", FFD_ERROR);
      return 1;
    }
    for(k=1; k<=kmax; k++)  psi[IX(i,j,k)] = temp_psi[k];

  }

  free(temp_ap);
  free(temp_ae);
  free(temp_aw);
  free(temp_b);
  free(temp_psi);
  return 0;
} /* End of TDMA_YZ()*/

	/*
		* TDMA solver for ZX-plane
		*
		* @param para Pointer to FFD parameters
		* @param var Pointer to FFD simulation variables
		* @param psi Pointer to variable
		* @param j J-index of the plane
		*
		* @return 0 if no error occurred
		*/
int TDMA_ZX(PARA_DATA *para, REAL **var, REAL *psi, int j)
{
  int imax = para->geom->imax;
  int jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int k, i;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *b = var[B], *ap = var[AP], *af = var[AF], *ab = var[AB];
  REAL *ae = var[AE], *aw =var[AW], *an = var[AN], *as = var[AS];
  REAL *temp_ap, *temp_aw, *temp_ae, *temp_b, *temp_psi;

  temp_ap = (REAL *) malloc((imax+1)*sizeof(REAL));
  if(temp_ap==NULL) {
    ffd_log("TDMA_ZX(): Could not allocate memory for temp_ap.",
            FFD_ERROR);
    return 1;
  }
  temp_ae = (REAL *) malloc((imax+1)*sizeof(REAL));
  if(temp_ae==NULL) {
    ffd_log("TDMA_ZX(): Could not allocate memory for temp_ae.",
            FFD_ERROR);
    return 1;
  }
  temp_aw = (REAL *) malloc((imax+1)*sizeof(REAL));
  if(temp_aw==NULL) {
    ffd_log("TDMA_ZX(): Could not allocate memory for temp_aw.",
            FFD_ERROR);
    return 1;
  }
  temp_b = (REAL *) malloc((imax+1)*sizeof(REAL));
  if(temp_b==NULL) {
    ffd_log("TDMA_ZX(): Could not allocate memory for temp_b.",
            FFD_ERROR);
    return 1;
  }
  temp_psi = (REAL *) malloc((imax+1)*sizeof(REAL));
  if(temp_psi==NULL) {
    ffd_log("TDMA_ZX(): Could not allocate memory for temp_psi.",
            FFD_ERROR);
    return 1;
  }

  /*line-by-line from South to North*/
  for(k=1; k<=kmax; k++) {
    for(i=1; i<=imax; i++) {
      temp_b[i] = b[IX(i,j,k)]
               + af[IX(i,j,k)]*psi[IX(i,j,k+1)] + ab[IX(i,j,k)]*psi[IX(i,j,k-1)]
               + an[IX(i,j,k)]*psi[IX(i,j+1,k)] + as[IX(i,j,k)]*psi[IX(i,j-1,k)];
      temp_ap[i] = ap[IX(i,j,k)];
      temp_aw[i] = aw[IX(i,j,k)];
      temp_ae[i] = ae[IX(i,j,k)];
      temp_psi[i] = psi[IX(i,j,k)];
    }

    if(TDMA_1D(temp_ap, temp_ae, temp_aw, temp_b, temp_psi, imax)) {
      ffd_log("TDMA_ZX(): Could not compute TDMA_1D", FFD_ERROR);
      return 1;
    }

    for(i=1; i<=imax; i++)  psi[IX(i,j,k)] = temp_psi[i];
  }

  free(temp_ap);
  free(temp_ae);
  free(temp_aw);
  free(temp_b);
  free(temp_psi);
  return 0;
} /* End of TDMA_ZX()*/

	/*
		* TDMA solver for 1D array
		*
		* @param ap Pointer to coefficient for center
		* @param ae Pointer to coefficient for east
		* @param aw Pointer to coefficient for west
		* @param b Pointer to b
		* @param psi Pointer to variable
		* @param LENGTH Length of the array
		*
		* @return 0 if no error occurred
		*/
int TDMA_1D(REAL *ap, REAL *ae, REAL *aw, REAL *b, REAL *psi,
             int LENGTH) {
  REAL *P, *Q;
  int i;

  P = (REAL *)malloc(LENGTH * sizeof(REAL));
  if(P==NULL) {
    ffd_log("TDMA_1D(): Could not allocate memory for P.", FFD_ERROR);
    return 1;
  }
  Q = (REAL *)malloc(LENGTH * sizeof(REAL));
  if(Q==NULL) {
    ffd_log("TDMA_1D(): Could not allocate memory for Q.", FFD_ERROR);
    return 1;
  }
  for(i=1; i<=LENGTH-1; i++) {
    P[i] = ae[i] / (ap[i] - aw[i]*P[i-1]);
    Q[i] = (b[i] + aw[i]*Q[i-1]) / (ap[i] - aw[i]*P[i-1]);
  }

  for(i=LENGTH-1; i>=1; i--)
    psi[i] = P[i]*psi[i+1] + Q[i];

  free(P);
  free(Q);
  return 0;
} /* end of TDMA_1D() */
