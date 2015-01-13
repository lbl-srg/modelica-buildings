///////////////////////////////////////////////////////////////////////////////
///
/// \file   solver.c
///
/// \brief  Solver of FFD
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
///////////////////////////////////////////////////////////////////////////////

#include "solver.h"

///////////////////////////////////////////////////////////////////////////////
/// FFD solver
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param BINDEX Pointer to boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int FFD_solver(PARA_DATA *para, REAL **var, int **BINDEX) {
  int step_total = para->mytime->step_total;
  REAL t_steady = para->mytime->t_steady;
  double t_cosim;
  int flag, next;

  if(para->solv->cosimulation == 1)
    t_cosim = para->mytime->t + para->cosim->modelica->dt;

  /***************************************************************************
  | Solver Loop
  ***************************************************************************/
  next = 1;
  while(next==1) {
    //-------------------------------------------------------------------------
    // Integration
    //-------------------------------------------------------------------------
    flag = vel_step(para, var, BINDEX);
    if(flag != 0) {
      ffd_log("FFD_solver(): Could not solve velocity.", FFD_ERROR);
      return flag;
    }
    else if(para->outp->version==DEBUG)
      ffd_log("FFD_solver(): solved velocity step.", FFD_NORMAL);

    flag = temp_step(para, var, BINDEX);
    if(flag != 0) {
      ffd_log("FFD_solver(): Could not solve temperature.", FFD_ERROR);
      return flag;
    }
    else if(para->outp->version==DEBUG)
      ffd_log("FFD_solver(): solved temperature step.", FFD_NORMAL);

    flag = den_step(para, var, BINDEX);
    if(flag != 0) {
      ffd_log("FFD_solver(): Could not solve trace substance.", FFD_ERROR);
      return flag;
    }
    else if(para->outp->version==DEBUG)
      ffd_log("FFD_solver(): solved density step.", FFD_NORMAL);

    timing(para);

    //-------------------------------------------------------------------------
    // Process for Coupled simulation
    //-------------------------------------------------------------------------
    if(para->solv->cosimulation == 1) {
      /*.......................................................................
      | Condition 1: If synchronization point is reached,
      | Action:     Do data exchange
      .......................................................................*/
      if(fabs(para->mytime->t - t_cosim)<SMALL) {
        if(para->outp->version==DEBUG)
          ffd_log("FFD_solver(): Coupled simulation, reached synchronization point",
                  FFD_NORMAL);

        // Average the FFD simulation data
        flag = average_time(para, var);
        if(flag != 0) {
          ffd_log("FFD_solver(): Could not average the data over time.",
            FFD_ERROR);
          return flag;
        }

        // the data for coupled simulation
        flag = read_cosim_data(para, var, BINDEX);
        if(flag != 0) {
          ffd_log("FFD_solver(): Could not read coupled simulation data.", FFD_ERROR);
          return flag;
        }

        flag =  write_cosim_data(para, var);
        if(flag != 0) {
          ffd_log("FFD_solver(): Could not write coupled simulation data.", FFD_ERROR);
          return flag;
        }

        sprintf(msg, "ffd_solver(): Synchronized data at t=%f[s]\n", para->mytime->t);
        ffd_log(msg, FFD_NORMAL);

        // Set the next synchronization time
        t_cosim += para->cosim->modelica->dt;
        // Reset all the averaged data to 0
        flag = reset_time_averaged_data(para, var);
        if(flag != 0) {
          ffd_log("FFD_solver(): Could not reset averaged data.",
            FFD_ERROR);
          return flag;
        }

        /*.......................................................................
        | Check if Modelica asks to stop the simulation
        .......................................................................*/
        if(para->cosim->para->flag==0) {
          // Stop the solver
          next = 0;
          sprintf(msg,
                  "ffd_solver(): Received stop command from Modelica at "
                  "FFD time: %f[s], Modelica Time: %f[s].",
                  para->mytime->t, para->cosim->modelica->t);
          ffd_log(msg, FFD_NORMAL);
        }

        continue;
      } // End of Condition 1
      /*.......................................................................
      | Condition 2: synchronization point is not reached ,
      |             but already miss the synchronization point
      | Action:     Stop simulation
      .......................................................................*/
      else if(para->mytime->t-t_cosim>SMALL) {
        sprintf(msg,
          "ffd_solver(): Mis-matched synchronization step with "
                "t_ffd=%f[s], t_cosim=%f[s], dt_syn=%f[s], dt_ffd=%f[s].",
                para->mytime->t, t_cosim,
                para->cosim->modelica->dt, para->mytime->dt);
        ffd_log(msg, FFD_ERROR);
        sprintf(msg, "para->mytime->t - t_cosim=%lf", para->mytime->t - t_cosim);
        ffd_log(msg, FFD_ERROR);
        return 1;
      } // end of Condition 2
      /*.......................................................................
      | Condition 3: synchronization point is not reached
      |             and not miss the synchronization point
      | Action:     Do FFD internal simulation and add data for future average
      .......................................................................*/
      else {
        if(para->outp->version==DEBUG)
          ffd_log("FFD_solver(): Coupled simulation, prepare next step for FFD",
                  FFD_NORMAL);

        // Integrate the data on the boundary surface
        flag = surface_integrate(para, var, BINDEX);
        if(flag != 0) {
          ffd_log("FFD_solver(): "
            "Could not average the data on boundary.",
            FFD_ERROR);
          return flag;
        }
        else if (para->outp->version==DEBUG)
          ffd_log("FFD_solver(): completed surface integration",
                  FFD_NORMAL);

        flag = add_time_averaged_data(para, var);
        if(flag != 0) {
          ffd_log("FFD_solver(): "
            "Could not add the averaged data.",
            FFD_ERROR);
          return flag;
        }
        else if (para->outp->version==DEBUG)
          ffd_log("FFD_solver(): completed time average",
                  FFD_NORMAL);

      } // End of Condition 3
    } // End of coupled simulation
    //-------------------------------------------------------------------------
    // Process for single simulation
    //-------------------------------------------------------------------------
    else {
      if(para->outp->version==DEBUG)
        ffd_log("FFD_solver(): Single Simulation, prepare for next time step",
                FFD_NORMAL);

      // Start to record data for calculating mean velocity if needed
      if(para->mytime->t>t_steady && para->outp->cal_mean==0) {
        para->outp->cal_mean = 1;
        flag = reset_time_averaged_data(para, var);
        if(flag != 0) {
          ffd_log("FFD_solver(): Could not reset averaged data.",
            FFD_ERROR);
          return flag;
        }
        else
          ffd_log("FFD_solver(): Start to calculate mean properties.",
                   FFD_NORMAL);
      }

      if(para->outp->cal_mean==1) {
        flag = add_time_averaged_data(para, var);
        if(flag != 0) {
          ffd_log("FFD_solver(): Could not add the averaged data.",
            FFD_ERROR);
          return 1;
        }
      }
      next = para->mytime->step_current < step_total ? 1 : 0;
    }
  } // End of While loop

  return flag;
} // End of FFD_solver( )

///////////////////////////////////////////////////////////////////////////////
/// Calculate the temperature
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param BINDEX Pointer to boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int temp_step(PARA_DATA *para, REAL **var, int **BINDEX) {
  REAL *T = var[TEMP], *T0 = var[TMP1];
  int flag = 0;

  flag = advect(para, var, TEMP, 0, T0, T, BINDEX);
  if(flag!=0) {
    ffd_log("temp_step(): Could not advect temperature.", FFD_ERROR);
    return flag;
  }

  flag = diffusion(para, var, TEMP, 0, T, T0, BINDEX);
  if(flag!=0) {
    ffd_log("temp_step(): Could not diffuse temperature.", FFD_ERROR);
    return flag;
  }

  return flag;
} // End of temp_step( )

///////////////////////////////////////////////////////////////////////////////
/// Calculate the contaminant concentration
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param BINDEX Pointer to boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int den_step(PARA_DATA *para, REAL **var, int **BINDEX) {
  REAL *den, *den0 = var[TMP1];
  int i, flag = 0;

  /****************************************************************************
  | Solve the species
  ****************************************************************************/
  for(i=0; i<para->bc->nb_Xi; i++) {
    if(para->outp->version==DEBUG) {
      sprintf(msg, "den_step(): start to solve Xi%d", i+1);
      ffd_log(msg, FFD_NORMAL);
    }
    den = var[Xi1+i];
    flag = advect(para, var, Xi1+i, i, den0, den, BINDEX);
    if(flag!=0) {
      sprintf(msg, "den_step(): Could not advect species %d", i+1);
      ffd_log(msg, FFD_ERROR);
      return flag;
    }

    flag = diffusion(para, var, Xi1+i, i, den, den0, BINDEX);
    if(flag!=0) {
      sprintf(msg, "den_step(): Could not diffuse species %d", i+1);
      ffd_log(msg, FFD_ERROR);
      return flag;
    }
  }

  /****************************************************************************
  | Solve the trace substances
  ****************************************************************************/
  for(i=0; i<para->bc->nb_C; i++) {
    if(para->outp->version==DEBUG) {
      sprintf(msg, "den_step(): start to solve C%d", i+1);
      ffd_log(msg, FFD_NORMAL);
    }
    den = var[C1+i];
    flag = advect(para, var, Xi1, i, den0, den, BINDEX);
    if(flag!=0) {
      sprintf(msg, "den_step(): Could not advect trace substance %d", i+1);
      ffd_log(msg, FFD_ERROR);
      return flag;
    }

    flag = diffusion(para, var, Xi1, i, den, den0, BINDEX);
    if(flag!=0) {
      sprintf(msg, "den_step(): Could not diffuse trace substance %d", i+1);
      ffd_log(msg, FFD_ERROR);
      return flag;
    }
  }

  return flag;
} // End of den_step( )

///////////////////////////////////////////////////////////////////////////////
/// Calculate the velocity
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param BINDEX Pointer to boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int vel_step(PARA_DATA *para, REAL **var,int **BINDEX) {
  REAL *u  = var[VX],  *v  = var[VY],    *w  = var[VZ];
  REAL *u0 = var[TMP1], *v0 = var[TMP2], *w0 = var[TMP3];
  int flag = 0;

  flag = advect(para, var, VX, 0, u0, u, BINDEX);
  if(flag!=0) {
    ffd_log("vel_step(): Could not advect for velocity X.", FFD_ERROR);
    return flag;
  }

  flag = advect(para, var, VY, 0, v0, v, BINDEX);
  if(flag!=0) {
    ffd_log("vel_step(): Could not advect for velocity Y.", FFD_ERROR);
    return flag;
  }

  flag = advect(para, var, VZ, 0, w0, w, BINDEX);
  if(flag!=0) {
    ffd_log("vel_step(): Could not advect for velocity Z.", FFD_ERROR);
    return flag;
  }

  flag = diffusion(para, var, VX, 0, u, u0, BINDEX);
  if(flag!=0) {
    ffd_log("vel_step(): Could not diffuse velocity X.", FFD_ERROR);
    return flag;
  }

  flag = diffusion(para, var, VY, 0, v, v0, BINDEX);
  if(flag!=0) {
    ffd_log("vel_step(): Could not diffuse velocity Y.", FFD_ERROR);
    return flag;
  }

  flag = diffusion(para, var, VZ, 0, w, w0, BINDEX);
  if(flag!=0) {
    ffd_log("vel_step(): Could not diffuse velocity Z.", FFD_ERROR);
    return flag;
  }

  flag = project(para, var,BINDEX);
  if(flag!=0) {
    ffd_log("vel_step(): Could not project velocity.", FFD_ERROR);
    return flag;
  }

  if(para->bc->nb_outlet!=0) flag = mass_conservation(para, var,BINDEX);
  if(flag!=0) {
    ffd_log("vel_step(): Could not conduct mass conservation correction.",
            FFD_ERROR);
    return flag;
  }

  return flag;
} // End of vel_step( )

///////////////////////////////////////////////////////////////////////////////
/// Solver for equations
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param var_type Variable type
///\param Pointer to variable
///
///\return 0 if not error occurred
///////////////////////////////////////////////////////////////////////////////
int equ_solver(PARA_DATA *para, REAL **var, int var_type, REAL *psi) {
  REAL *flagp = var[FLAGP], *flagu = var[FLAGU],
       *flagv = var[FLAGV], *flagw = var[FLAGW];
  int flag = 0;

  switch(var_type) {
    case VX:
      Gauss_Seidel(para, var, flagu, psi);
      break;
    case VY:
      Gauss_Seidel(para, var, flagv, psi);
      break;
    case VZ:
      Gauss_Seidel(para, var, flagw, psi);
      break;
    case TEMP:
    case IP:
    case Xi1:
    case Xi2:
    case C1:
    case C2:
      Gauss_Seidel(para, var, flagp, psi);
      break;
    default:
      sprintf(msg, "equ_solver(): Solver for variable type %d is not defined.",
              var_type);
      ffd_log(msg, FFD_ERROR);
      flag = 1;
      break;
  }

  return flag;
}// end of equ_solver
