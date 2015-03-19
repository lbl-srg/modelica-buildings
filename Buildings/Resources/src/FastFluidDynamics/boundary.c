///////////////////////////////////////////////////////////////////////////////
///
/// \file   boundary.c
///
/// \brief  Set the boundary conditions
///
/// \author Mingang Jin, Qingyan Chen
///         Purdue University
///         Jin55@purdue.edu, YanChen@purdue.edu
///         Wangda Zuo
///         University of Miami
///         W.Zuo@miami.edu
///
/// \date   8/3/2013
///
/// This file provides functions that are used for setting the boundary
/// conditions.
/// It starts with \c set_bnd(). Then different subroutines are called
/// according to the properties of variables.
///
///////////////////////////////////////////////////////////////////////////////

#include "boundary.h"

///////////////////////////////////////////////////////////////////////////////
/// Entrance of setting boundary conditions
///
/// Specific boundary conditions will be selected according to the variable
/// type.
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param var_type The type of variable
///\param index Index of trace substances or species
///\param psi Pointer to the variable needing the boundary conditions
///\param BINDEX Pointer to boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int set_bnd(PARA_DATA *para, REAL **var, int var_type, int index, REAL *psi,
            int **BINDEX) {
  int flag;
  switch(var_type) {
    case VX:
      flag = set_bnd_vel(para, var, VX, psi, BINDEX);
      if(flag!=0)
        ffd_log("set_bnd(): Could not set boundary condition for X-velocity.",
                FFD_ERROR);
      break;
    case VY:
      flag = set_bnd_vel(para, var, VY, psi, BINDEX);
      if(flag!=0)
        ffd_log("set_bnd(): Could not set boundary condition for Y-velocity.",
                FFD_ERROR);
      break;
    case VZ:
      flag = set_bnd_vel(para, var, VZ, psi, BINDEX);
      if(flag!=0)
        ffd_log("set_bnd(): Could not set boundary condition for Z-velocity.",
                FFD_ERROR);
      break;
    case TEMP:
      flag = set_bnd_temp(para, var, TEMP, psi, BINDEX);
      if(flag!=0)
        ffd_log("set_bnd(): Could not set boundary condition for temperature.",
                FFD_ERROR);
      break;
    case Xi1:
    case Xi2:
    case C1:
    case C2:
      flag = set_bnd_trace(para, var, index, psi, BINDEX);
      if(flag!=0)
        ffd_log("set_bnd(): Could not set boundary condition for trace.",
                FFD_ERROR);
      break;
    default:
      flag = 1;
      sprintf(msg,
              "set_bnd(): boundary condition for variable type %d is not defined.",
              var_type);
      ffd_log(msg, FFD_ERROR);
  }

  return flag;
} // End of set_bnd()


///////////////////////////////////////////////////////////////////////////////
/// Set boundary conditions for velocity
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param var_type The type of variable
///\param psi Pointer to the variable needing the boundary conditions
///\param BINDEX Pointer to boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int set_bnd_vel(PARA_DATA *para, REAL **var, int var_type, REAL *psi,
                int **BINDEX) {
  int i, j, k;
  int it;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int index= para->geom->index;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *aw = var[AW], *ae = var[AE], *as = var[AS], *an = var[AN];
  REAL *af = var[AF], *ab = var[AB];
  REAL *flagp = var[FLAGP];

  switch(var_type) {
    /* --------------------------------------------------------------------------
    | VX
    -------------------------------------------------------------------------- */
    case VX:
      for(it=0; it<index; it++) {
        i = BINDEX[0][it];
        j = BINDEX[1][it];
        k = BINDEX[2][it];
        // Inlet
        if(flagp[IX(i,j,k)]==0) {
          psi[IX(i,j,k)] = var[VXBC][IX(i,j,k)];
          if(i!=0) psi[IX(i-1,j,k)] = var[VXBC][IX(i,j,k)];
        }
        // Solid wall
        if(flagp[IX(i,j,k)]==1) {
          psi[IX(i,j,k)] = 0;
          if(i!=0) psi[IX(i-1,j,k)] = 0;
        }
        // Outlet
        if(flagp[IX(i,j,k)]==2) {
          // West
          if(i==0) {
            psi[IX(i,j,k)] = psi[IX(i+1,j,k)];
            aw[IX(i+1,j,k)] = 0;
          }
          // East
          if(i==imax+1) {
            psi[IX(i-1,j,k)] = psi[IX(i-2,j,k)];
            ae[IX(i-2,j,k)] = 0;
          }
          // South
          if(j==0) as[IX(i,j+1,k)] = 0;
          // North
          if(j==jmax+1) an[IX(i,j-1,k)] = 0;
          // Floor
          if(k==0) ab[IX(i,j,k+1)] = 0;
          // Ceiling
          if(k==kmax+1) af[IX(i,j,k-1)] = 0;
        }
      } // End of setting VX
      break;
    /* --------------------------------------------------------------------------
    | VY
    -------------------------------------------------------------------------- */
    case VY:
      for(it=0;it<index;it++) {
        i = BINDEX[0][it];
        j = BINDEX[1][it];
        k = BINDEX[2][it];
        // Inlet
        if(flagp[IX(i,j,k)]==0) {
          psi[IX(i,j,k)] = var[VYBC][IX(i,j,k)];
          if(j!=0) psi[IX(i,j-1,k)] = var[VYBC][IX(i,j,k)];
        }
        // Solid wall
        if(flagp[IX(i,j,k)]==1) {
          psi[IX(i,j,k)] = 0;
          if(j!=0) psi[IX(i,j-1,k)] = 0;
        }
        // Outlet
        if(flagp[IX(i,j,k)]==2) {
          // West
          if(i==0) aw[IX(i+1,j,k)]=0;
          // East
          if(i==imax+1) ae[IX(i-1,j,k)]=0;
          // South
          if(j==0) {
            as[IX(i,j+1,k)] = 0;
            psi[IX(i,j,k)] = psi[IX(i,j+1,k)];
          }
          // North
          if(j==jmax+1) {
            an[IX(i,j-2,k)] = 0;
            psi[IX(i,j-1,k)] = psi[IX(i,j-2,k)];
          }
          // Floor
          if(k==0) ab[IX(i,j,k+1)] = 0;
          if(k==kmax+1) af[IX(i,j,k-1)] = 0;
        }
      } // End of setting VY
      break;
    /* --------------------------------------------------------------------------
    | VZ
    -------------------------------------------------------------------------- */
    case VZ:
      for(it=0;it<index;it++) {
        i = BINDEX[0][it];
        j = BINDEX[1][it];
        k = BINDEX[2][it];
        // Inlet
        if(flagp[IX(i,j,k)]==INLET) {
          psi[IX(i,j,k)] = var[VZBC][IX(i,j,k)];
          if(k!=0) psi[IX(i,j,k-1)] = var[VZBC][IX(i,j,k)];
        }
        if(flagp[IX(i,j,k)]==SOLID) {
          psi[IX(i,j,k)] = 0;
          if(k!=0) psi[IX(i,j,k-1)] = 0;
        }
        if(flagp[IX(i,j,k)]==OUTLET) {
          // West
          if(i==0) aw[IX(i+1,j,k)] = 0;
          // East
          if(i==imax+1) ae[IX(i-1,j,k)] = 0;
          //South
          if(j==0) as[IX(i,j+1,k)] = 0;
          // North
          if(j==jmax+1) an[IX(i,j-1,k)] = 0;
          // Floor
          if(k==0) {
            ab[IX(i,j,k+1)] = 0;
            psi[IX(i,j,k)] = psi[IX(i,j,k+1)];
          }
          // Ceiling
          if(k==kmax+1) {
            af[IX(i,j,k-2)] = 0;
            psi[IX(i,j,k-1)] = psi[IX(i,j,k-2)];
          }
        }
      } // End of setting VZ
      break;
   } // End of switch case

   return 0;
}// End of set_bnd_vel( )


///////////////////////////////////////////////////////////////////////////////
/// Set the boundary condition for temperature
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param var_type The type of variable
///\param psi Pointer to the variable needing the boundary conditions
///\param BINDEX Pointer to boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int set_bnd_temp(PARA_DATA *para, REAL **var, int var_type, REAL *psi,
                 int **BINDEX) {
  int i, j, k;
  int it;
  int index=para->geom->index;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *aw = var[AW], *ae = var[AE], *as = var[AS], *an = var[AN];
  REAL *af = var[AF], *ab = var[AB], *b=var[B],
       *qflux = var[QFLUX], *qfluxbc = var[QFLUXBC];
  REAL axy, ayz, azx; // Area of surfaces
  REAL h;
  REAL rhoCp_1 = 1/ (para->prob->rho * para->prob->Cp);
  REAL D;
  REAL *flagp = var[FLAGP];

  /****************************************************************************
  | Go through all the boundary cells
  ****************************************************************************/
  for(it=0; it<index; it++) {
    i = BINDEX[0][it];
    j = BINDEX[1][it];
    k = BINDEX[2][it];

    axy = area_xy(para, var, i, j, k);
    ayz = area_yz(para, var, i, j, k);
    azx = area_zx(para, var, i, j, k);

    /*-------------------------------------------------------------------------
    | Inlet boundary
    | 0: Inlet, -1: Fluid,  1: Solid Wall or Block, 2: Outlet
    -------------------------------------------------------------------------*/
    if(flagp[IX(i,j,k)]==INLET) psi[IX(i,j,k)] = var[TEMPBC][IX(i,j,k)];

    /*-------------------------------------------------------------------------
    | Solid wall or block
    -------------------------------------------------------------------------*/
    if(flagp[IX(i,j,k)]==SOLID) {
      /*......................................................................
      | Constant temperature
      ......................................................................*/
      if(BINDEX[3][it]==1) {
        psi[IX(i,j,k)] = var[TEMPBC][IX(i,j,k)];

        // West boundary wall and eastern neighbor cell is fluid
        if(i==0) {
          if(flagp[IX(i+1,j,k)]==FLUID) {
            D = 0.5 * length_x(para,var,i+1,j,k);
            h = h_coef(para,var,i+1,j,k,D);
            aw[IX(i+1,j,k)] = h * rhoCp_1 * ayz;
            qflux[IX(i,j,k)] = h * (psi[IX(i+1,j,k)]-psi[IX(i,j,k)]);
          }
        } // End of if(i==0)
        // East boundary wall and western neighbor cell is fluid
        else if(i==imax+1) {
          if(flagp[IX(i-1,j,k)]==FLUID) {
            D = 0.5 * length_x(para,var,i-1,j,k);
            h = h_coef(para,var,i-1,j,k,D);
            ae[IX(i-1,j,k)] = h * rhoCp_1 * ayz;
            qflux[IX(i,j,k)] = h * (psi[IX(i-1,j,k)]-psi[IX(i,j,k)]);
          }
        } // End of else if(i==imax+1)
        // Between West and East
        else {
          // Eastern neighbor cell is fluid
          if(flagp[IX(i+1,j,k)]==FLUID) {
            D = 0.5 * length_x(para,var,i+1,j,k);
            h = h_coef(para,var,i+1,j,k,D);
            aw[IX(i+1,j,k)] = h * rhoCp_1 * ayz;
            qflux[IX(i,j,k)] = h * (psi[IX(i+1,j,k)]-psi[IX(i,j,k)]);
          }
          // Western neighbor cell is fluid
          if(flagp[IX(i-1,j,k)]==FLUID) {
            D = 0.5 * length_x(para,var,i-1,j,k);
            h = h_coef(para,var,i-1,j,k,D);
            ae[IX(i-1,j,k)] = h * rhoCp_1 * ayz;
            qflux[IX(i,j,k)] = h * (psi[IX(i-1,j,k)]-psi[IX(i,j,k)]);
          }
        } // End of 0<i<imax+1
        // South wall boundary and northern neighbor is fluid
        if(j==0) {
          if(flagp[IX(i,j+1,k)]==FLUID) {
            D = 0.5 * length_y(para,var,i,j+1,k);
            h = h_coef(para,var,i,j+1,k,D);
            as[IX(i,j+1,k)] = h * rhoCp_1 * azx;
            qflux[IX(i,j,k)] = h * (psi[IX(i,j+1,k)]-psi[IX(i,j,k)]);
          }
        }
        // North wall boundary and southern neighbor is fluid
        else if(j==jmax+1) {
          if(flagp[IX(i,j-1,k)]==FLUID) {
            D = 0.5 * length_y(para,var,i,j-1,k);
            h = h_coef(para,var,i,j-1,k,D);
            an[IX(i,j-1,k)] = h * rhoCp_1 * azx;
            qflux[IX(i,j,k)] = h * (psi[IX(i,j-1,k)]-psi[IX(i,j,k)]);
          }
        }
        // Between South and North
        else {
          // Southern neighbor is fluid
          if(flagp[IX(i,j-1,k)]==FLUID) {
            D = 0.5 * length_y(para,var,i,j-1,k);
            h = h_coef(para,var,i,j-1,k,D);
            an[IX(i,j-1,k)] = h * rhoCp_1 * azx;
            qflux[IX(i,j,k)] = h * (psi[IX(i,j-1,k)]-psi[IX(i,j,k)]);
          }
          // Northern neighbor is fluid
          if(flagp[IX(i,j+1,k)]==FLUID) {
            D = 0.5 * length_y(para,var,i,j+1,k);
            h = h_coef(para,var,i,j+1,k,D);
            as[IX(i,j+1,k)] = h * rhoCp_1 * azx;
            qflux[IX(i,j,k)] = h * (psi[IX(i,j+1,k)]-psi[IX(i,j,k)]);
          }
        }
        // Floor and ceiling neighbor is fluid
        if(k==0) {
          if(flagp[IX(i,j,k+1)]==FLUID) {
            D = 0.5 * length_z(para,var,i,j,k+1);
            h = h_coef(para,var,i,j,k+1,D);
            ab[IX(i,j,k+1)] = h * rhoCp_1 * axy;
            qflux[IX(i,j,k)] = h * (psi[IX(i,j,k+1)]-psi[IX(i,j,k)]);
          }
        }
        // Ceiling and floor neighbor is fluid
        else if(k==kmax+1) {
          if(flagp[IX(i,j,k-1)]==FLUID) {
            D = 0.5 * length_z(para,var,i,j,k-1);
            h = h_coef(para,var,i,j,k-1,D);
            af[IX(i,j,k-1)] = h * rhoCp_1 * axy;
            qflux[IX(i,j,k)] = h * (psi[IX(i,j,k-1)]-psi[IX(i,j,k)]);
          }
        }
        // Between Floor and Ceiling
        else {
          // Ceiling neighbor is fluid
          if(flagp[IX(i,j,k+1)]==FLUID) {
            D = 0.5 * length_z(para,var,i,j,k+1);
            h = h_coef(para,var,i,j,k+1,D);
            ab[IX(i,j,k+1)] = h * rhoCp_1 * axy;
            qflux[IX(i,j,k)] = h * (psi[IX(i,j,k+1)]-psi[IX(i,j,k)]);
          }
          // Floor neighbor is fluid
          if(flagp[IX(i,j,k-1)]==FLUID) {
            D = 0.5 * length_z(para,var,i,j,k-1);
            h = h_coef(para,var,i,j,k-1,D);
            af[IX(i,j,k-1)] = h * rhoCp_1 * axy;
            qflux[IX(i,j,k)] = h * (psi[IX(i,j,k-1)]-psi[IX(i,j,k)]);
          }
        }
      } // End of constant temperature wall
      /*.......................................................................
      | Constant heat flux
      .......................................................................*/
      if(BINDEX[3][it]==0) {
        // West wall boundary and eastern neighbor is fluid
        if(i==0) {
          if(flagp[IX(i+1,j,k)]==FLUID) {
            aw[IX(i+1,j,k)] = 0;
            D = 0.5 * length_z(para,var,i+1,j,k);
            h = h_coef(para,var,i+1,j,k,D);
            b[IX(i+1,j,k)] += rhoCp_1 * qfluxbc[IX(i,j,k)] * ayz;
            // get the temperature of solid surface
            psi[IX(i,j,k)] = qfluxbc[IX(i,j,k)]/h + psi[IX(i+1,j,k)];
          }
        } // End of if(i==0)
        // East wall boundary and western neighbor is fluid
        else if(i==imax+1) {
          if(flagp[IX(i-1,j,k)]==FLUID) {
            ae[IX(i-1,j,k)] = 0;
            D = 0.5 * length_z(para,var,i-1,j,k);
            h = h_coef(para,var,i-1,j,k,D);
            b[IX(i-1,j,k)] += rhoCp_1 * qfluxbc[IX(i,j,k)] * ayz;
            // get the temperature of solid surface
            psi[IX(i,j,k)] = qfluxbc[IX(i,j,k)]/h + psi[IX(i-1,j,k)];
          }
        } // End of else if(i==imax+1)
        // Between West and East
        else {
          // Eastern neighbor is fluid
          if(flagp[IX(i+1,j,k)]==FLUID) {
            aw[IX(i+1,j,k)] = 0;
            D = 0.5 * length_z(para,var,i+1,j,k);
            h = h_coef(para,var,i+1,j,k,D);
            b[IX(i+1,j,k)] += rhoCp_1 * qfluxbc[IX(i,j,k)] * ayz;
            // get the temperature of solid surface
            psi[IX(i,j,k)] = qfluxbc[IX(i,j,k)]/h + psi[IX(i+1,j,k)];
          }
          // Western neighbor is fluid
          if(flagp[IX(i-1,j,k)]==FLUID) {
            ae[IX(i-1,j,k)] = 0;
            D = 0.5 * length_z(para,var,i-1,j,k);
            h = h_coef(para,var,i-1,j,k,D);
            b[IX(i-1,j,k)] += rhoCp_1 * qfluxbc[IX(i,j,k)] * ayz;
            // get the temperature of solid surface
            psi[IX(i,j,k)] = qfluxbc[IX(i,j,k)]/h + psi[IX(i-1,j,k)];
          }
        } // End of else
        // South wall boundary and northern neighbor is fluid
        if(j==0) {
          if(flagp[IX(i,j+1,k)]==FLUID) {
            as[IX(i,j+1,k)] = 0;
            D = 0.5 * length_z(para,var,i,j+1,k);
            h = h_coef(para,var,i,j+1,k,D);
            b[IX(i,j+1,k)] += rhoCp_1 * qfluxbc[IX(i,j,k)] * azx;
            // get the temperature of solid surface
            psi[IX(i,j,k)] = qfluxbc[IX(i,j,k)]/h + psi[IX(i,j+1,k)];
          }
        }
        // North wall boundary and southern neighbor is fluid
        else if(j==jmax+1) {
          if(flagp[IX(i,j-1,k)]==FLUID) {
            an[IX(i,j-1,k)] = 0;
            D = 0.5 * length_z(para,var,i,j-1,k);
            h = h_coef(para,var,i,j-1,k,D);
            b[IX(i,j-1,k)] += rhoCp_1 * qfluxbc[IX(i,j,k)] * azx;
            // get the temperature of solid surface
            psi[IX(i,j,k)] = qfluxbc[IX(i,j,k)]/h + psi[IX(i,j-1,k)];
          }
        }
        // Between South and North
        else {
          // Southern neighbor is fluid
          if(flagp[IX(i,j-1,k)]==FLUID) {
            an[IX(i,j-1,k)] = 0;
            D = 0.5 * length_z(para,var,i,j-1,k);
            h = h_coef(para,var,i,j-1,k,D);
            b[IX(i,j-1,k)] += rhoCp_1 * qfluxbc[IX(i,j,k)] * azx;
            // get the temperature of solid surface
            psi[IX(i,j,k)] = qfluxbc[IX(i,j,k)]/h + psi[IX(i,j-1,k)];
          }
          // Northern neighbor is fluid
          if(flagp[IX(i,j+1,k)]==FLUID) {
            as[IX(i,j+1,k)] = 0;
            D = 0.5 * length_z(para,var,i,j+1,k);
            h = h_coef(para,var,i,j+1,k,D);
            b[IX(i,j+1,k)] += rhoCp_1 * qfluxbc[IX(i,j,k)] * azx;
            // get the temperature of solid surface
            psi[IX(i,j,k)] = qfluxbc[IX(i,j,k)]/h + psi[IX(i,j+1,k)];
          }
        }
        // Floor boundary and ceiling neighbor is fluid
        if(k==0) {
          if(flagp[IX(i,j,k+1)]==FLUID) {
            ab[IX(i,j,k+1)] = 0;
            D = 0.5 * length_z(para,var,i,j,k+1);
            h = h_coef(para,var,i,j,k+1,D);
            b[IX(i,j,k+1)] += rhoCp_1 * qfluxbc[IX(i,j,k)] * axy;
            // Get the temperature on the solid surface
            psi[IX(i,j,k)] = qfluxbc[IX(i,j,k)]/h + psi[IX(i,j,k+1)];
          }
        }
        // Ceiling boundary and floor neighbor is fluid
        else if(k==kmax+1) {
          if(flagp[IX(i,j,k-1)]==FLUID) {
            af[IX(i,j,k-1)] = 0;
            D = 0.5 * length_z(para,var,i,j,k-1);
            h = h_coef(para,var,i,j,k-1,D);
            b[IX(i,j,k-1)] += rhoCp_1 * qfluxbc[IX(i,j,k)] * axy;
            // Get the temperature on the solid surface
            psi[IX(i,j,k)] = qfluxbc[IX(i,j,k)]/h + psi[IX(i,j,k-1)];
          }
        }
        // Between Floor and Ceiling
        else {
          // Ceiling neighbor is fluid
          if(flagp[IX(i,j,k+1)]==FLUID) {
            ab[IX(i,j,k+1)] = 0;
            D = 0.5 * length_z(para,var,i,j,k+1);
            h = h_coef(para,var,i,j,k+1,D);
            b[IX(i,j,k+1)] += rhoCp_1 * qfluxbc[IX(i,j,k)] * axy;
            // Get the temperature on the solid surface
            psi[IX(i,j,k)] = qfluxbc[IX(i,j,k)]/h + psi[IX(i,j,k+1)];
          }
          // Floor neighbor is fluid
          if(flagp[IX(i,j,k-1)]==FLUID) {
            af[IX(i,j,k-1)] = 0;
            D = 0.5 * length_z(para,var,i,j,k-1);
            h = h_coef(para,var,i,j,k-1,D);
            b[IX(i,j,k-1)] += rhoCp_1 * qfluxbc[IX(i,j,k)] * axy;
            // Get the temperature on the solid surface
            psi[IX(i,j,k)] = qfluxbc[IX(i,j,k)]/h + psi[IX(i,j,k-1)];
          }
        }
      } // End of constant heat flux
    } // End of wall boundary

    /*-------------------------------------------------------------------------
    | Outlet boundary
    -------------------------------------------------------------------------*/
    if(flagp[IX(i,j,k)]==OUTLET) {
      // West
      if(i==0) {
        aw[IX(i+1,j,k)] = 0;
        psi[IX(i,j,k)] = psi[IX(i+1,j,k)];
      }
      // North
      if(i==imax+1) {
        ae[IX(i-1,j,k)] = 0;
        psi[IX(i,j,k)] = psi[IX(i-1,j,k)];
      }
      // South
      if(j==0) {
        as[IX(i,j+1,k)] = 0;
        psi[IX(i,j,k)] = psi[IX(i,j+1,k)];
      }
      // North
      if(j==jmax+1) {
        an[IX(i,j-1,k)] = 0;
        psi[IX(i,j,k)] = psi[IX(i,j-1,k)];
      }
      // Floor
      if(k==0) {
        ab[IX(i,j,k+1)] = 0;
        psi[IX(i,j,k)] = psi[IX(i,j,k+1)];
      }
      // Ceiling
      if(k==kmax+1) {
        af[IX(i,j,k-1)] = 0;
        psi[IX(i,j,k)] = psi[IX(i,j,k-1)];
      }
    } // End of boundary for outlet
  } // End of for() loop for go through the index

  return 0;
} // End of set_bnd_temp()

///////////////////////////////////////////////////////////////////////////////
/// Set the boundary condition for trace substance
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param trace_index Index of the trace substance
///\param psi Pointer to the variable needing the boundary conditions
///\param BINDEX Pointer to boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int set_bnd_trace(PARA_DATA *para, REAL **var, int trace_index, REAL *psi,
                 int **BINDEX) {
  int i, j, k, it;
  int index=para->geom->index;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *aw = var[AW], *ae = var[AE], *as = var[AS], *an = var[AN];
  REAL *af = var[AF], *ab = var[AB];
  REAL *flagp = var[FLAGP];

  /****************************************************************************
  | Go through all the boundary cells
  ****************************************************************************/
  for(it=0; it<index; it++) {
    i = BINDEX[0][it];
    j = BINDEX[1][it];
    k = BINDEX[2][it];

    /*-------------------------------------------------------------------------
    | Inlet boundary
    -------------------------------------------------------------------------*/
    if(flagp[IX(i,j,k)]==INLET) {
      //id = BINDEX[4][it];
      psi[IX(i,j,k)] = 0.1; //var[trace_index][IX(i,j,k)];
    }
    /*-------------------------------------------------------------------------
    | Solid wall or block
    -------------------------------------------------------------------------*/
    else if(flagp[IX(i,j,k)]==SOLID) {
      /*.......................................................................
      | Neumann B.C.
      .......................................................................*/
      // Eastern neighbor is fluid
      if(i!=imax+1 && flagp[IX(i+1,j,k)]==FLUID) {
          aw[IX(i+1,j,k)] = 0;
          psi[IX(i,j,k)] = psi[IX(i+1,j,k)];
      }
      // Western neighbor is fluid
      if((i=!0) && (flagp[IX(i-1,j,k)]==FLUID)) {
          ae[IX(i-1,j,k)] = 0;
          psi[IX(i,j,k)] = psi[IX(i-1,j,k)];
      }
      // Northern neighbor is fluid
      if(j!=jmax+1 && flagp[IX(i,j+1,k)]==FLUID) {
          as[IX(i,j+1,k)] = 0;
          psi[IX(i,j,k)] = psi[IX(i,j+1,k)];
      }
      // Southern neighbor is fluid
      if(j!=0 && flagp[IX(i,j-1,k)]==FLUID) {
          an[IX(i,j-1,k)] = 0;
          psi[IX(i,j,k)] = psi[IX(i,j-1,k)];
      }
      // Ceiling neighbor is fluid
      if(k!=kmax+1 && flagp[IX(i,j,k+1)]==FLUID) {
          ab[IX(i,j,k+1)] = 0;
          psi[IX(i,j,k)] = psi[IX(i,j,k+1)];
      }
      // Floor neighbor is fluid
      if(k==kmax+1 && flagp[IX(i,j,k-1)]==FLUID) {
          af[IX(i,j,k-1)] = 0;
          psi[IX(i,j,k)] = psi[IX(i,j,k-1)];
      }
    } // End of wall boundary
    /*-------------------------------------------------------------------------
    | Outlet boundary
    -------------------------------------------------------------------------*/
    else if(flagp[IX(i,j,k)]==OUTLET) {
      // West
      if(i==0) {
        aw[IX(i+1,j,k)] = 0;
        psi[IX(i,j,k)] = psi[IX(i+1,j,k)];
      }
      // North
      if(i==imax+1) {
        ae[IX(i-1,j,k)] = 0;
        psi[IX(i,j,k)] = psi[IX(i-1,j,k)];
      }
      // South
      if(j==0) {
        as[IX(i,j+1,k)] = 0;
        psi[IX(i,j,k)] = psi[IX(i,j+1,k)];
      }
      // North
      if(j==jmax+1) {
        an[IX(i,j-1,k)] = 0;
        psi[IX(i,j,k)] = psi[IX(i,j-1,k)];
      }
      // Floor
      if(k==0) {
        ab[IX(i,j,k+1)] = 0;
        psi[IX(i,j,k)] = psi[IX(i,j,k+1)];
      }
      // Ceiling
      if(k==kmax+1) {
        af[IX(i,j,k-1)] = 0;
        psi[IX(i,j,k)] = psi[IX(i,j,k-1)];
      }
    } // End of boundary for outlet
  } // End of for() loop for go through the index

  return 0;
} // End of set_bnd_trace()

///////////////////////////////////////////////////////////////////////////////
/// Set the boundary condition for pressure
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param p Pointer to pressure variable
///\param BINDEX Pointer to boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int set_bnd_pressure(PARA_DATA *para, REAL **var, REAL *p, int **BINDEX) {
  int i, j, k, it;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int index=para->geom->index;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *aw = var[AW], *ae = var[AE], *as = var[AS], *an = var[AN];
  REAL *af = var[AF], *ab = var[AB];

  REAL *flagp = var[FLAGP];

  for(it=0;it<index;it++) {
    i = BINDEX[0][it];
    j = BINDEX[1][it];
    k = BINDEX[2][it];

    /*-------------------------------------------------------------------------
    | For X direction
    -------------------------------------------------------------------------*/
    if(i>0) {
      if(flagp[IX(i-1,j,k)]<0) {
        p[IX(i,j,k)] = p[IX(i-1,j,k)];
        ae[IX(i-1,j,k)] = 0;
      }
    }
    if(i<imax+1) {
      if(flagp[IX(i+1,j,k )]<0) {
        p[IX(i,j,k)] = p[IX(i+1,j,k)];
        aw[IX(i+1,j,k)] = 0;
      }
    }
    /*-------------------------------------------------------------------------
    | For Y direction
    -------------------------------------------------------------------------*/
    if(j>0) {
      if(flagp[IX(i,j-1,k)]<0) {
        p[IX(i,j,k)] = p[IX(i,j-1,k )];
        an[IX(i,j-1,k)] = 0;
      }
    }
    if(j<jmax+1) {
      if(flagp[IX(i,j+1,k)]<0) {
        p[IX(i,j,k )] = p[IX(i,j+1,k )];
        as[IX(i,j+1,k)] = 0;
      }
    }
    /*-------------------------------------------------------------------------
    | For Z direction
    -------------------------------------------------------------------------*/
    if(k>0) {
      if(flagp[IX(i,j,k-1)]<0) {
        p[IX(i,j,k)] = p[IX(i,j,k-1)];
        af[IX(i,j,k-1)] = 0;
      }
    }
    if(k<kmax+1) {
      if(flagp[IX(i,j,k+1 )]<0) {
        p[IX(i,j,k)] = p[IX(i,j,k+1)];
        ab[IX(i,j,k+1)] = 0;
      }
    }
  }

  return 0;
} // End of set_bnd_pressure()

///////////////////////////////////////////////////////////////////////////////
/// Enforce the mass conservation by adjusting the outlet flow rate
///
/// The details ware published in the paper
/// "W. Zuo, J. Hu, Q. Chen 2010.
/// Improvements on FFD modeling by using different numerical schemes,
/// Numerical Heat Transfer, Part B Fundamentals, 58(1), 1-16."
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param BINDEX Pointer to boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int mass_conservation(PARA_DATA *para, REAL **var, int **BINDEX) {
  int i, j, k;
  int it;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int index= para->geom->index;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *u = var[VX], *v = var[VY], *w = var[VZ];
  REAL dvel;
  REAL *flagp = var[FLAGP];

  dvel = adjust_velocity(para, var, BINDEX); //(mass_in-mass_out)/area_out

  /*---------------------------------------------------------------------------
  | Adjust the outflow
  ---------------------------------------------------------------------------*/
  for(it=0;it<index;it++) {
    i = BINDEX[0][it];
    j = BINDEX[1][it];
    k = BINDEX[2][it];
    if(flagp[IX(i,j,k)]==2) {
      if(i==0) u[IX(i,j,k)] -= dvel;
      if(i==imax+1) u[IX(i-1,j,k)]+= dvel;
      if(j==0) v[IX(i,j,k)] -= dvel;
      if(j==jmax+1) v[IX(i,j-1,k)] += dvel;
      if(k==0) w[IX(i,j,k)] -= dvel;
      if(k==kmax+1) w[IX(i,j,k-1)] += dvel;
    }
  }

  return 0;
} // End of mass_conservation()

///////////////////////////////////////////////////////////////////////////////
/// Get the mass flow difference divided by outflow area
///
/// The details were published in the paper
/// "W. Zuo, J. Hu, Q. Chen 2010.
/// Improvements on FFD modeling by using different numerical schemes,
/// Numerical Heat Transfer, Part B Fundamentals, 58(1), 1-16."
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param BINDEX Pointer to boundary index
///
///\return Mass flow difference divided by the outflow area
///////////////////////////////////////////////////////////////////////////////
REAL adjust_velocity(PARA_DATA *para, REAL **var, int **BINDEX) {
  int i, j, k;
  int it;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int index= para->geom->index;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *u = var[VX], *v = var[VY], *w = var[VZ];
  REAL mass_in = (REAL) 0.0, mass_out = (REAL) 0.00000001;
  REAL area_out=0;
  REAL *flagp = var[FLAGP];
  REAL axy, ayz, azx;

  // Go through all the inlets and outlets
  for(it=0; it<index; it++) {
    i = BINDEX[0][it];
    j = BINDEX[1][it];
    k = BINDEX[2][it];

    axy = area_xy(para, var, i, j, k);
    ayz = area_yz(para, var, i, j, k);
    azx = area_zx(para, var, i, j, k);
    /*-------------------------------------------------------------------------
    | Compute the total inflow
    -------------------------------------------------------------------------*/
    if(flagp[IX(i,j,k)]==0) {
      // West
      if(i==0) mass_in += u[IX(i,j,k)] * ayz;
      // East
      if(i==imax+1) mass_in += (-u[IX(i,j,k)]) * ayz;
      // South
      if(j==0) mass_in += v[IX(i,j,k)] * azx;
      // North
      if(j==jmax+1) mass_in += (-v[IX(i,j,k)]) * azx;
      // Floor
      if(k==0) mass_in += w[IX(i,j,k)] * axy;
      // Ceiling
      if(k==kmax+1) mass_in += (-w[IX(i,j,k)]) * axy;
    }
    /*-------------------------------------------------------------------------
    | Compute the total outflow
    -------------------------------------------------------------------------*/
    if(flagp[IX(i,j,k)]==2) {
      // West
      if(i==0) {
        mass_out += (-u[IX(i,j,k)]) * ayz;
        area_out +=  ayz;
      }
      // East
      if(i==imax+1) {
        mass_out += u[IX(i-1,j,k)] * ayz;
        area_out += ayz;
      }
      // South
      if(j==0) {
        mass_out += (-v[IX(i,j,k)]) * azx;
        area_out += azx;
      }
      // North
      if(j==jmax+1) {
        mass_out += v[IX(i,j-1,k)] * azx;
        area_out += azx;
      }
      // Floor
      if(k==0) {
        mass_out += (-w[IX(i,j,k)]) * axy;
        area_out += axy;
      }
      // Ceiling
      if(k==kmax+1) {
        mass_out += w[IX(i,j,k-1)] * axy;
        area_out += axy;
      }
    } // End of computing outflow
  } // End of for loop for going through all the inlets and outlets

  /*---------------------------------------------------------------------------
  | Return the adjusted velocity for mass conservation
  ---------------------------------------------------------------------------*/
  return (mass_in-mass_out)/area_out;
} // End of adjust_velocity()

///////////////////////////////////////////////////////////////////////////////
/// Calculate convective heat transfer coefficient divided by
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param i I-index of the cell
///\param j J-index of the cell
///\param k K-index of the cell
///\param D distance from the cell center to the wall
///
///\return Mass flow difference divided by the outflow area
///////////////////////////////////////////////////////////////////////////////
REAL h_coef(PARA_DATA *para, REAL **var, int i, int j, int k, REAL D) {
  REAL h, kapa;
  REAL nu = para->prob->nu;

  switch(para->prob->tur_model) {
    case LAM:
      kapa = nu;
      break;
    case CONSTANT:
      kapa = (REAL)101.0 * nu;
      break;
    case CHEN:
      kapa = nu + nu_t_chen_zero_equ(para, var, i, j, k);
      break;
    default:
      sprintf(msg, "h_coef(): Value (%d) for para->prob->tur_model"
              "was not correct.", para->prob->tur_model);
      ffd_log(msg, FFD_ERROR);
  }
  h = para->prob->Cp * para->prob->rho * para->prob->alpha * kapa
    / (nu * D);

  return h;

} // End of h_coef()
