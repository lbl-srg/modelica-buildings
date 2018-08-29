/*
	*
	* \file   initialization.h
	*
	* \brief  Set the initial values
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

#include "initialization.h"

/*
	* Initialize the parameters
	*
	* @param para Pointer to FFD parameters
	*
	* @return 0 if no error occurred
	*/
int initialize(PARA_DATA *para) {
  /* Define the default value for parameter*/
  set_default_parameter(para);

  /* Overwrite the default values using user defined values*/
  if(read_parameter(para)) {
    ffd_log("initialize(): Failed to read parameter file.", FFD_ERROR);
    return 1;
  }

  /*---------------------------------------------------------------------------
  | Output the help information
  ---------------------------------------------------------------------------*/
  if(para->outp->version==DEMO) {
    printf("\n\nHow to use this demo:\n\n" );
    printf("\t Switch Windows: \n");
    printf("\t\tVelocity: key '1'\n");
    printf("\t\tContaminant: key '2'\n");
    printf("\t\tTemperature: key '3'\n");
    printf("\t Add densities with the right mouse button\n");
    printf("\t Add velocities with the left mouse button\n");
    printf("\t Increase the inlet velocity with 'F' or 'f' key\n");
    printf("\t Decrease the inlet velocity with 'S' or 's' key\n");
    printf("\t Increase the BC temperature with 'H' or 'h' key\n");
    printf("\t Decrease the BC temperature with 'C' or 'c' key\n" );
    printf("\t Clear the simulation by pressing the '0' key\n" );
    printf("\t Quit by pressing the 'q' key\n" );
  }

  return 0;
} /* End of initialize( )*/

	/*
		* Set the default value for parameters
		*
		* @param para Pointer to FFD parameters
		*
		* @return No return needed
		*/
void set_default_parameter(PARA_DATA *para) {
  para->mytime->t  = 0.0;
  para->mytime->step_current = 0;
  para->mytime->t_start = clock();

  para->prob->alpha = (REAL) 2.376e-5; /* Thermal diffusity*/
  para->prob->diff = 0.00001;
  para->prob->force = 1.0;
  para->prob->heat = 1.0;
  para->prob->source = 100.0;

  para->prob->chen_a = (REAL) 0.03874; /* Coeffcient of Chen's model*/
  para->prob->Prt = (REAL) 0.9; /* Turbulent Prandl number*/
  para->prob->rho = (REAL) 1.0; /**/
  para->prob->tur_model = LAM; /* No turbulence model*/

  para->solv->check_residual = 0;
  para->solv->solver = GS; /* Gauss-Seidel Solver*/
  para->solv->interpolation = BILINEAR; /* Bilinear interpolation*/

  /* Default values for Input*/
  para->inpu->read_old_ffd_file = 0; /* Do not read the old FFD data as initial value*/

  /* Default values for Output*/
  para->outp->Temp_ref   = 0;/*35.5f;//10.25f;*/
  para->outp->cal_mean   = 0;
  para->outp->v_length   = 1;
  para->outp->winx       = 600;
  para->outp->winy       = 600;
  para->outp->winz       = 600;
  para->outp->v_ref      = 1.0;
  para->outp->version    = DEBUG; /* Running the debug version*/
  para->outp->i_N        = 1;
  para->outp->j_N        = 1;
  para->outp->k_N        = 1;
  para->outp->tstep_display = 10; /* Update the display for every 10 time steps*/
  para->outp->screen     = 1; /* Draw velocity*/
  para->geom->plane      = ZX; /* Draw ZX plane*/
  para->bc->nb_port = 0;
  para->bc->nb_Xi = 0;
  para->bc->nb_C = 0;
  para->sens->nb_sensor = 0; /* Number of sensors*/
} /* End of set_default_parameter*/

	/*
		* Set default initial values for simulation variables
		*
		* @param para Pointer to FFD parameters
		* @param var Pointer to FFD simulation variables
		* @param BINDEX Pointer to boundary index
		*
		* @return 0 if no error occurred
		*/
int set_initial_data(PARA_DATA *para, REAL **var, int **BINDEX) {
  int i, j;
  int size = (para->geom->imax+2)*(para->geom->jmax+2)*(para->geom->kmax+2);
  int flag = 0;

  para->mytime->t = 0.0;
  para->mytime->step_current = 0;
  para->outp->cal_mean = 0;

  /****************************************************************************
  | Set initial value for FFD variables
  ****************************************************************************/
  for(i=0; i<size; i++) {
    var[GX][i]      = 0.0;
    var[GY][i]      = 0.0;
    var[GZ][i]      = 0.0;
    var[VX][i]      = para->init->u;
    var[VY][i]      = para->init->v;
    var[VZ][i]      = para->init->w;
    var[VXM][i]     = 0.0;
    var[VYM][i]     = 0.0;
    var[VZM][i]     = 0.0;
    var[VXS][i]     = 0.0;
    var[VYS][i]     = 0.0;
    var[VZS][i]     = 0.0;
    var[TEMP][i]    = para->init->T;
    var[TEMPM][i]   = 0.0;
    var[TEMPS][i]   = 0.0;  /* Source of temperature*/
    var[IP][i]      = 0.0;
    var[AP][i]      = 0.0;
    var[AW][i]      = 0.0;
    var[AE][i]      = 0.0;
    var[AS][i]      = 0.0;
    var[AN][i]      = 0.0;
    var[AB][i]      = 0.0;
    var[AF][i]      = 0.0;
    var[B][i]       = 0.0;
    var[AP0][i]     = 0.0;
    var[TMP1][i]    = 0.0;
    var[TMP2][i]    = 0.0;
    var[TMP3][i]    = 0.0;
    var[PP][i]      = 0.0;
    var[FLAGP][i]   = -1.0;
    var[FLAGU][i]   = -1.0;
    var[FLAGV][i]   = -1.0;
    var[FLAGW][i]   = -1.0;
    var[VXBC][i]    = 0.0;
    var[VYBC][i]    = 0.0;
    var[VZBC][i]    = 0.0;
    var[TEMPBC][i]  = 0.0;
    var[QFLUXBC][i] = 0.0;
    var[QFLUX][i]   = 0.0;
    var[Xi1][i]     = 0.0;
    var[Xi2][i]     = 0.0;
    var[Xi1S][i]    = 0.0;
    var[Xi2S][i]    = 0.0;
    var[Xi1BC][i]   = 0.0;
    var[Xi2BC][i]   = 0.0;
    var[C1][i]      = 0.0;
    var[C2][i]      = 0.0;
    var[C1S][i]     = 0.0;
    var[C2S][i]     = 0.0;
    var[C1BC][i]    = 0.0;
    var[C2BC][i]    = 0.0;
  }

  /* Calculate the thermal diffusivity*/
  para->prob->alpha = para->prob->cond / (para->prob->rho*para->prob->Cp);

  /****************************************************************************
  | Read the configurations defined by SCI
  ****************************************************************************/
  if(para->inpu->parameter_file_format == SCI) {
    flag = read_sci_input(para, var, BINDEX);
    if(flag != 0) {
      sprintf(msg, "set_inital_data(): Could not read file %s",
              para->inpu->parameter_file_name);
      ffd_log(msg, FFD_ERROR);
      return flag;
    }
    flag = read_sci_zeroone(para, var, BINDEX);
    if(flag != 0) {
      ffd_log("set_inital_data(): Could not read block information file",
               FFD_ERROR);
      return flag;
    }
    mark_cell(para, var);
  }

  /****************************************************************************
  | Allocate memory for sensor data if there is at least one sensor
  ****************************************************************************/
  if(para->sens->nb_sensor>0) {
    para->sens->senVal = (REAL *) malloc(para->sens->nb_sensor*sizeof(REAL));
    if(para->sens->senVal==NULL) {
      ffd_log("set_initial_data(): Could not allocate memory for "
        "para->sens->senVal", FFD_ERROR);
      return -1;
    }
    para->sens->senValMean = (REAL *) malloc(para->sens->nb_sensor*sizeof(REAL));
    if(para->sens->senValMean==NULL) {
      ffd_log("set_initial_data(): Could not allocate memory for "
        "para->sens->senValMean", FFD_ERROR);
      return 1;
    }
  }

  /****************************************************************************
  | Allocate memory for Species
  ****************************************************************************/
  if(para->bc->nb_port>0&&para->bc->nb_Xi>0) {
    para->bc->XiPort = (REAL **) malloc(sizeof(REAL*)*para->bc->nb_port);
    para->bc->XiPortAve = (REAL **) malloc(sizeof(REAL*)*para->bc->nb_port);
    para->bc->XiPortMean = (REAL **) malloc(sizeof(REAL*)*para->bc->nb_port);
    if(para->bc->XiPort==NULL ||
       para->bc->XiPortAve==NULL ||
       para->bc->XiPortMean==NULL) {
      ffd_log("set_initial_data(): Could not allocate memory for XiPort.",
              FFD_ERROR);
      return 1;
    }

    for(i=0; i<para->bc->nb_port; i++) {
      para->bc->XiPort[i] = (REAL *) malloc(sizeof(REAL)*para->bc->nb_Xi);
      para->bc->XiPortAve[i] = (REAL *) malloc(sizeof(REAL)*para->bc->nb_Xi);
      para->bc->XiPortMean[i] = (REAL *) malloc(sizeof(REAL)*para->bc->nb_Xi);
      if(para->bc->XiPort[i]==NULL ||
         para->bc->XiPortAve[i]==NULL ||
         para->bc->XiPortMean[i]==NULL) {
        sprintf(msg, "set_initial_data(): Could not allocate memory for "
                "Xi at Port[%d].", i);
        ffd_log(msg, FFD_ERROR);
        return 1;
      }

      for(j=0; j<para->bc->nb_Xi; j++) {
        para->bc->XiPort[i][j] = 0.0;
        para->bc->XiPortAve[i][j] = 0.0;
        para->bc->XiPortMean[i][j] = 0.0;
      }
    }
    if(para->outp->version==DEBUG) {
      ffd_log("Allocated memory for Xi", FFD_NORMAL);
    }
  }
  else  if(para->outp->version==DEBUG) {
      ffd_log("No Xi in the simulation", FFD_NORMAL);
  }

  /****************************************************************************
  | Allocate memory for Substances
  ****************************************************************************/
  if(para->bc->nb_port>0&&para->bc->nb_C>0) {
    para->bc->CPort = (REAL **) malloc(sizeof(REAL *)*para->bc->nb_port);
    para->bc->CPortAve = (REAL **) malloc(sizeof(REAL *)*para->bc->nb_port);
    para->bc->CPortMean = (REAL **) malloc(sizeof(REAL *)*para->bc->nb_port);
    if(para->bc->CPort==NULL || para->bc->CPortAve==NULL
       || para->bc->CPortMean) {
      ffd_log("set_initial_data(): Could not allocate memory for CPort.",
              FFD_ERROR);
      return 1;
    }

    for(i=0; i<para->bc->nb_port; i++) {
      para->bc->CPort[i] = (REAL *) malloc(sizeof(REAL)*para->bc->nb_C);
      para->bc->CPortAve[i] = (REAL *) malloc(sizeof(REAL)*para->bc->nb_C);
      para->bc->CPortMean[i] = (REAL *) malloc(sizeof(REAL)*para->bc->nb_C);
      if(para->bc->CPort[i]==NULL || para->bc->CPortAve[i]==NULL
         || para->bc->CPortMean[i]) {
        ffd_log("set_initial_data(): "
                "Could not allocate memory for C at Port[i].",
                FFD_ERROR);
        return 1;
      }

      for(j=0; j<para->bc->nb_C; j++) {
        para->bc->CPort[i][j] = 0.0;
        para->bc->CPortAve[i][j] = 0.0;
        para->bc->CPortMean[i][j] = 0.0;
      }
    }
    if(para->outp->version==DEBUG) {
      ffd_log("Allocated memory for C", FFD_NORMAL);
    }
  }
  else if(para->outp->version==DEBUG) {
      ffd_log("No C in the simulation", FFD_NORMAL);
  }

  /****************************************************************************
  | Pre-calculate data needed but not change in the simulation
  ****************************************************************************/
  para->geom->volFlu = fluid_volume(para, var);
  para->geom->pindex     = (int) para->geom->jmax/2;

  /****************************************************************************
  | Set all the averaged data to 0
  ****************************************************************************/
  flag = reset_time_averaged_data(para, var);
  if(flag != 0) {
    ffd_log("FFD_solver(): Could not reset averaged data.",
      FFD_ERROR);
    return flag;
  }

  /****************************************************************************
  | Conduct the data exchange at the initial state of cosimulation
  ****************************************************************************/
  if(para->solv->cosimulation==1) {
    /*------------------------------------------------------------------------
    | Calculate the area of boundary
    ------------------------------------------------------------------------*/
    flag = bounary_area(para, var, BINDEX);
    if(flag != 0) {
      ffd_log("set_initial_data(): Could not get the boundary area.",
              FFD_ERROR);
      return flag;
    }
    /*------------------------------------------------------------------------
    | Read the cosimulation parameter data (Only need once)
    ------------------------------------------------------------------------*/
    flag = read_cosim_parameter(para, var, BINDEX);
    if(flag != 0) {
      ffd_log("set_initial_data(): Could not read cosimulation parameters.",
              FFD_ERROR);
      return 1;
    }
    /*------------------------------------------------------------------------
    | Read the cosimulation data
    ------------------------------------------------------------------------*/
    flag = read_cosim_data(para, var, BINDEX);
    if(flag != 0) {
      ffd_log("set_initial_data(): Could not read initial data for "
               "cosimulaiton.", FFD_ERROR);
      return flag;
    }

    /*------------------------------------------------------------------------
    | Perform the simulation for one step to update the FFD initial condition
    ------------------------------------------------------------------------*/
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

    /* Integrate the data on the boundary surface*/
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

    /* Average the FFD simulation data*/
    flag = average_time(para, var);
    if(flag != 0) {
      ffd_log("FFD_solver(): Could not average the data over time.",
        FFD_ERROR);
      return flag;
    }

    /*------------------------------------------------------------------------
    | Write the cosimulation data
    ------------------------------------------------------------------------*/
    flag = write_cosim_data(para, var);
    if(flag != 0) {
      ffd_log("set_initial_data(): Could not write initial data for "
              "cosimulaiton.", FFD_ERROR);
      return flag;
    }
  }

  return flag;
} /* set_initial_data()*/
