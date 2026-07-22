/****************************************************************************
| 
|  \file   geometry.c
| 
|  \brief  Calculate the geometry related information
| 
|  \author Wangda Zuo
|          University of Miami, University of Colorado Boulder
|          W.Zuo@miami.edu, wangda.zuo@colorado.edu
|          Wei Tian
|          University of Miami, Schneider Electric
|          w.tian@umiami.edu, Wei.Tian@Schneider-Electric.com
| 
|  \date   6/15/2017
| 
****************************************************************************/

#include "geometry.h"

/****************************************************************************
|  Calculate total fluid volume in the space
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| 
| \return Volume weighted average
****************************************************************************/
REAL fluid_volume(PARA_DATA *para, REAL **var) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int i, j, k;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL V = 0;

  FOR_EACH_CELL
    if(var[FLAGP][IX(i,j,k)]==FLUID) {
      V += vol(para, var, i, j, k);
    }
    else
      continue;
  END_FOR

  return V;
}/* End of fluid_volume( ) */

/****************************************************************************
|  Calculate the volume of control volume (i,j,k)
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param i I-index of the control volume
| \param j J-index of the control volume
| \param K K-index of the control volume
| 
| \return Volume
****************************************************************************/
REAL vol(PARA_DATA *para, REAL **var, int i, int j, int k) {

  return area_xy(para, var, i, j, k)
       * length_z(para, var, i, j, k);
} /* End of vol() */


/****************************************************************************
|  Calculate the XY area of control volume (i,j,k)
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param i I-index of the control volume
| \param j J-index of the control volume
| \param K K-index of the control volume
| 
| \return Area of XY surface
****************************************************************************/
REAL area_xy(PARA_DATA *para, REAL **var, int i, int j, int k) {
  return length_x(para, var, i, j, k)
       * length_y(para, var, i, j, k);
} /* End of area_xy() */

/****************************************************************************
|  Calculate the YZ area of control volume (i,j,k)
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param i I-index of the control volume
| \param j J-index of the control volume
| \param K K-index of the control volume
| 
| \return Area of YZ surface
****************************************************************************/
REAL area_yz(PARA_DATA *para, REAL **var, int i, int j, int k) {
  return length_y(para, var, i, j, k)
       * length_z(para, var, i, j, k);
} /* End of area_yz(); */

/****************************************************************************
|  Calculate the ZX area of control volume (i,j,k)
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param i I-index of the control volume
| \param j J-index of the control volume
| \param K K-index of the control volume
| 
| \return Area of ZX surface
****************************************************************************/
REAL area_zx(PARA_DATA *para, REAL **var, int i, int j, int k) {
  return length_z(para, var, i, j, k)
       * length_x(para, var, i, j, k);
} /* End of area_zx() */

/****************************************************************************
|  Calculate the X-length of control volume (i,j,k)
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param i I-index of the control volume
| \param j J-index of the control volume
| \param K K-index of the control volume
| 
| \return Length in X-direction
****************************************************************************/
REAL length_x(PARA_DATA *para, REAL **var, int i, int j, int k) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);

  if(i==0)
    return 0;
  else
    return (REAL) fabs(var[GX][IX(i,j,k)]-var[GX][IX(i-1,j,k)]);
} /* End of length_x() */

/****************************************************************************
|  Calculate the Y-length of control volume (i,j,k)
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param i I-index of the control volume
| \param j J-index of the control volume
| \param K K-index of the control volume
| 
| \return Length in Y-direction
****************************************************************************/
REAL length_y(PARA_DATA *para, REAL **var, int i, int j, int k) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);

  if(j==0)
    return 0;
  else
    return (REAL) fabs(var[GY][IX(i,j,k)]-var[GY][IX(i,j-1,k)]);
} /* End of length_y() */

/****************************************************************************
|  Calculate the Z-length of control volume (i,j,k)
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param i I-index of the control volume
| \param j J-index of the control volume
| \param K K-index of the control volume
| 
| \return Length in Z-direction
****************************************************************************/
REAL length_z(PARA_DATA *para, REAL **var, int i, int j, int k) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);

  if(k==0)
    return 0;
  else
    return (REAL) fabs(var[GZ][IX(i,j,k)]-var[GZ][IX(i,j,k-1)]);
} /* End of length_z() */

/****************************************************************************
|  Calculate the area of boundary surface
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
| \param A Pointer to the array of area
| 
| \return 0 if no error occurred
****************************************************************************/
int bounary_area(PARA_DATA *para, REAL **var, int **BINDEX) {

  int i, j, k, it, id;
  int index= para->geom->index, imax = para->geom->imax,
      jmax = para->geom->jmax, kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);

  REAL *flagp = var[FLAGP];
  REAL tmp;
  REAL *AWall = para->bc->AWall;
  REAL *APort = para->bc->APort;

  if(para->bc->nb_wall>0)
    for(id=0; id<para->bc->nb_wall; id++) AWall[id] = 0;
  if(para->bc->nb_port>0)
    for(id=0; id<para->bc->nb_port; id++) APort[id] = 0;

  for(it=0; it<index; it++) {
    i = BINDEX[0][it];
    j = BINDEX[1][it];
    k = BINDEX[2][it];
    id = BINDEX[4][it] - para->bc->nb_block;

    /*-------------------------------------------------------------------------
    | Calculate wall or windows
    --------------------------------------------------------------------------*/
    if(flagp[IX(i,j,k)]==SOLID && id >= 0) {
      /* West or East Boundary */
      if(i==0 || i==imax+1) {
        tmp = area_yz(para, var, i, j, k);
        AWall[id] += tmp;
      }
      /* South and North Boundary */
      if(j==0 || j==jmax+1) {
        tmp = area_zx(para, var, i, j, k);
        AWall[id] += tmp;
      }
      /* Ceiling and Floor Boundary */
      if(k==0 || k==kmax+1) {
        tmp = area_xy(para, var, i, j, k);
        AWall[id] += tmp;
      }
    } /* End of Wall boudary */

    /*-------------------------------------------------------------------------
    | Calculate inlets and outlets
    -------------------------------------------------------------------------*/
    if(flagp[IX(i,j,k)]==INLET||flagp[IX(i,j,k)]==OUTLET || flagp[IX(i, j, k)] == TILE) {
      /* West or East Boundary */
      if(i==0 || i==imax+1) {
        tmp = area_yz(para, var, i, j, k);
        /*sprintf(msg, "Cell(%d,%d,%d):\t %f", i, j, k, tmp);*/
        /*ffd_log(msg, FFD_NORMAL);*/
        APort[id + para->bc->nb_block] += tmp;
      }
      /* South and North Boundary */
      if(j==0 || j==jmax+1) {
        tmp = area_zx(para, var, i, j, k);
        APort[id + para->bc->nb_block] += tmp;
      }
      /* Ceiling and Floor Boundary */
      if(k==0 || k==kmax+1) {
        tmp = area_xy(para, var, i, j, k);
        APort[id + para->bc->nb_block] += tmp;
      }
    }
  } /* End of for(it=0; it<index; it++) */

  ffd_log("bounary_area(): Calculated surface area for FFD boundaries are:",
    FFD_NORMAL);

  if(para->bc->nb_wall>0) {
    ffd_log("\tWall boundaries:", FFD_NORMAL);
    for(id=0; id<para->bc->nb_wall; id++) {
      sprintf(msg, "\t\t%s: %f[m2]", para->bc->wallName[id], AWall[id]);
      ffd_log(msg, FFD_NORMAL);
    }
  }

  if(para->bc->nb_inlet>0) {
    ffd_log("\tInlet boundaries:", FFD_NORMAL);
    for(id=0; id<para->bc->nb_inlet; id++) {
      sprintf(msg, "\t\t%s: %f[m2]", para->bc->portName[id], APort[id]);
      ffd_log(msg, FFD_NORMAL);
    }
  }

  if(para->bc->nb_outlet>0) {
    ffd_log("\tOutlet boundaries:", FFD_NORMAL);
    for(id=para->bc->nb_inlet; id<para->bc->nb_port; id++) {
      sprintf(msg, "\t\t%s: %f[m2]", para->bc->portName[id], APort[id]);
      ffd_log(msg, FFD_NORMAL);
    }
  }
  return 0;
} /* End of bounary_area() */

/****************************************************************************
|  Calculate the area of inlet or outlet of rack
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
| \param A Pointer to the array of area
| 
| \return 0 if no error occurred
| \ Version 1.0
| \ Wei Tian, 1-20-2018, Wei.Tian@Schneider-Electric.com
****************************************************************************/
int rack_fluid_area(PARA_DATA *para, REAL **var, int **BINDEX) {
  int i, j, k, it, id, obj_type;
  REAL *flagp = var[FLAGP];
  int index= para->geom->index, imax = para->geom->imax,
      jmax = para->geom->jmax, kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL axy, ayz, azx;

  /* Initialize the area */
  for (i=0; i<para->bc->nb_rack; i++){
    para->bc->RackArea[i] = 0.0;
  }

  /* Loop all the boundary cells */
  for(it=0; it<index; it++) {
    i = BINDEX[0][it];
    j = BINDEX[1][it];
    k = BINDEX[2][it];
    id = BINDEX[4][it];
    obj_type = BINDEX[5][it];

    /* calculate the area */
    axy = area_xy(para, var, i, j, k);
    ayz = area_yz(para, var, i, j, k);
    azx = area_zx(para, var, i, j, k);
 
    /* If it is rack cell and it is a rack inlet boundary */
    if (obj_type == RACK && flagp[IX(i,j,k)]==RACK_INLET) {
      if (para->bc->RackDir[id] == 1 || para->bc->RackDir[id] == -1) {
        para->bc->RackArea[id] += ayz;
      }
      else if (para->bc->RackDir[id] == 2 || para->bc->RackDir[id] == -2) {
        para->bc->RackArea[id] += azx;
      }
      else if (para->bc->RackDir[id] == 3 || para->bc->RackDir[id] == -3) {
        para->bc->RackArea[id] += axy;
      }
      else{
        ffd_log("rack_fluid_area(): fail to detect the flow direction of the rack", FFD_ERROR);
        return 1;
      }
    } /*end of if (obj_type == RACK && flagp[IX(i,j,k)]==RACK_INLET)*/
  } /*end of for(it=0; it<index; it++)*/
  /* return 0 */
  return 0;
}
