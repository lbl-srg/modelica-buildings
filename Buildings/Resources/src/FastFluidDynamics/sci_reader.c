/*
	*
	* \file   sci_reader.c
	*
	* \brief  Read mesh and simulation data defined by SCI
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

#include "sci_reader.h"

/*
	* Read the basic index information from input.cfd
	*
	* Specific method for advection will be selected according to the variable
	* type.
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	*
	* @return 0 if no error occurred
	*/
int read_sci_max(PARA_DATA *para, REAL **var) {
  char string[400];

  /* Open the file*/
  if((file_params=fopen(para->inpu->parameter_file_name,"r")) == NULL) {
    fprintf(stderr,"Error:can not open the file \"%s\".\n",
      para->inpu->parameter_file_name);
    return 1;
  }

  /* Get the first line for the length in X, Y and Z directions*/
  fgets(string, 400, file_params);
  sscanf(string,"%lf %lf %lf", &para->geom->Lx, &para->geom->Ly, &para->geom->Lz);

  /* Get the second line for the number of cells in X, Y and Z directions*/
  fgets(string, 400, file_params);
  sscanf(string,"%d %d %d", &para->geom->imax, &para->geom->jmax,
    &para->geom->kmax);

  fclose(file_params);
  return 0;
} /* End of read_sci_max()*/


	/*
		* Read other information from input.cfd
		*
		* @param para Pointer to FFD parameters
		* @param var Pointer to FFD simulation variables
		* @param var_type Type of variable
		* @param BINDEX Pointer to boundary index
		*
		* @return 0 if no error occurred
		*/
int read_sci_input(PARA_DATA *para, REAL **var, int **BINDEX) {
  int i, j, k;
  int ii,ij,ik;
  REAL tempx, tempy, tempz;
  REAL Lx = para->geom->Lx;
  REAL Ly = para->geom->Ly;
  REAL Lz = para->geom->Lz;
  REAL *gx = var[GX], *gy = var[GY], *gz = var[GZ];
  REAL *x = var[X], *y = var[Y], *z = var[Z];
  int IWWALL,IEWALL,ISWALL,INWALL,IBWALL,ITWALL;
  int SI,SJ,SK,EI,EJ,EK,FLTMP;
  REAL TMP,MASS,U,V,W;
  char name[100];
  int imax = para->geom->imax;
  int jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int index=0;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  char string[400];
  REAL *delx, *dely, *delz;
  REAL *flagp = var[FLAGP];
  int bcnameid = -1;

  /* Open the parameter file*/
  if((file_params=fopen(para->inpu->parameter_file_name,"r")) == NULL ) {
    sprintf(msg,"read_sci_input(): Could not open the file \"%s\".",
            para->inpu->parameter_file_name);
    ffd_log(msg, FFD_ERROR);
    return 1;
  }

  sprintf(msg, "read_sci_input(): Start to read sci input file %s",
          para->inpu->parameter_file_name);
  ffd_log(msg, FFD_NORMAL);

  /* Ignore the first and second lines*/
  fgets(string, 400, file_params);
  fgets(string, 400, file_params);

  /*****************************************************************************
  | Convert the cell dimensions defined by SCI to coordinates in FFD
  *****************************************************************************/
  /* Allocate temporary memory for dimension of each cell*/
  delx = (REAL *) malloc ((imax+2)*sizeof(REAL));
  dely = (REAL *) malloc ((jmax+2)*sizeof(REAL));
  delz = (REAL *) malloc ((kmax+2)*sizeof(REAL));

  if( !delx || !dely ||!delz ) {
    ffd_log("read_sci_input(): Cannot allocate memory for delx, dely or delz.",
            FFD_ERROR);
    return 1;
  }

  delx[0]=0;
  dely[0]=0;
  delz[0]=0;

  /* Read cell dimensions in X, Y, Z directions*/
  for(i=1; i<=imax; i++) fscanf(file_params, "%lf", &delx[i]);
  fscanf(file_params,"\n");
  for(j=1; j<=jmax; j++) fscanf(file_params, "%lf", &dely[j]);
  fscanf(file_params,"\n");
  for(k=1; k<=kmax; k++) fscanf(file_params, "%lf", &delz[k]);
  fscanf(file_params,"\n");

  /* Store the locations of grid cell surfaces*/
  tempx = 0.0; tempy = 0.0; tempz = 0.0;
  for(i=0; i<=imax+1; i++) {
    tempx += delx[i];
    if(i>=imax) tempx = Lx;
    for(j=0; j<=jmax+1; j++)
      for(k=0; k<=kmax+1; k++) var[GX][IX(i,j,k)]=tempx;
  }

  for(j=0; j<=jmax+1; j++) {
    tempy += dely[j];
    if(j>=jmax) tempy = Ly;
    for(i=0; i<=imax+1; i++)
      for(k=0; k<=kmax+1; k++) var[GY][IX(i,j,k)] = tempy;
  }

  for(k=0; k<=kmax+1; k++) {
    tempz += delz[k];
    if(k>=kmax) tempz = Lz;
    for(i=0; i<=imax+1; i++)
      for(j=0; j<=jmax+1; j++) var[GZ][IX(i,j,k)] = tempz;
  }

  /*****************************************************************************
  | Convert the coordinates for cell surfaces to
  | the coordinates for the cell center
  *****************************************************************************/
  FOR_ALL_CELL
    if(i<1)
      x[IX(i,j,k)] = 0;
    else if(i>imax)
      x[IX(i,j,k)] = Lx;
    else
      x[IX(i,j,k)] = (REAL) 0.5 * (gx[IX(i,j,k)]+gx[IX(i-1,j,k)]);

    if(j<1)
      y[IX(i,j,k)] = 0;
    else if(j>jmax)
      y[IX(i,j,k)] = Ly;
    else
      y[IX(i,j,k)] = (REAL) 0.5 * (gy[IX(i,j,k)]+gy[IX(i,j-1,k)]);

    if(k<1)
      z[IX(i,j,k)] = 0;
    else if(k>kmax)
      z[IX(i,j,k)] = Lz;
    else
      z[IX(i,j,k)] = (REAL) 0.5 * (gz[IX(i,j,k)]+gz[IX(i,j,k-1)]);
  END_FOR

  /* Get the wall property*/
  fgets(string, 400, file_params);
  sscanf(string,"%d%d%d%d%d%d", &IWWALL, &IEWALL, &ISWALL,
         &INWALL, &IBWALL, &ITWALL);

  /*****************************************************************************
  | Read total number of boundary conditions
  *****************************************************************************/
  fgets(string, 400, file_params);
  sscanf(string,"%d", &para->bc->nb_bc);
  sprintf(msg, "read_sci_input(): para->bc->nb_bc=%d", para->bc->nb_bc);
  ffd_log(msg, FFD_NORMAL);

  /*****************************************************************************
  | Read the inlet boundary conditions
  *****************************************************************************/
  /* Get number of inlet boundaries*/
  fgets(string, 400, file_params);
  sscanf(string,"%d", &para->bc->nb_inlet);
  sprintf(msg, "read_sci_input(): para->bc->nb_inlet=%d", para->bc->nb_inlet);
  ffd_log(msg, FFD_NORMAL);

  index=0;
  /* Set inlet boundary*/
  if(para->bc->nb_inlet!=0) {
    /*-------------------------------------------------------------------------
    | Allocate the memory for bc name
    -------------------------------------------------------------------------*/
    para->bc->inletName = (char**) malloc(para->bc->nb_inlet*sizeof(char*));
    if(para->bc->inletName==NULL) {
      ffd_log("read_sci_input(): Could not allocate memory for "
              "para->bc->inletName.", FFD_ERROR);
      return 1;
    }

    /*-------------------------------------------------------------------------
    | Loop for each inlet boundary
    --------------------------------------------------------------------------*/
    for(i=0; i<para->bc->nb_inlet; i++) {
      /*.......................................................................
      | Get the names of boundary
      .......................................................................*/
      fgets(string, 400, file_params);
      /* Get the length of name (The name may contain white space)*/
      for(j=0; string[j] != '\n' && string[j] != '\r'; j++) {
        continue;
      }

      para->bc->inletName[i] = (char*)malloc((j+1)*sizeof(char));
      if(para->bc->inletName[i]==NULL) {
        sprintf(msg, "read_sci_input(): Could not allocate memory for "
                "para->bc->inletName[%d].", i);
        ffd_log(msg, FFD_ERROR);
        return 1;
      }

      strncpy(para->bc->inletName[i], (const char*)string, j);
      /* Add an ending*/
      para->bc->inletName[i][j] = '\0';
      sprintf(msg, "read_sci_input(): para->bc->inletName[%d]=%s",
              i, para->bc->inletName[i]);
      ffd_log(msg, FFD_NORMAL);
      /*.......................................................................
      | Get the boundary conditions
      .......................................................................*/
      fgets(string, 400, file_params);
      sscanf(string,"%d%d%d%d%d%d%lf%lf%lf%lf%lf", &SI, &SJ, &SK, &EI,
             &EJ, &EK, &TMP, &MASS, &U, &V, &W);
      sprintf(msg, "read_sci_input(): VX=%f, VY=%f, VZ=%f, T=%f, Xi=%f",
              U, V, W, TMP, MASS);
      ffd_log(msg, FFD_NORMAL);
      if(EI==0) {
        if(SI==1) SI = 0;
        EI = SI + EI;
        EJ = SJ + EJ - 1;
        EK = SK + EK - 1;
      }

      if(EJ==0) {
        if(SJ==1) SJ = 0;
        EI = SI + EI - 1;
        EJ = SJ + EJ;
        EK = SK + EK - 1;
      }

      if(EK==0) {
        if(SK==1) SK = 0;
        EI = SI + EI - 1;
        EJ = SJ + EJ - 1;
        EK = SK + EK;
      }

      /* Assign the inlet boundary condition for each cell*/
      for(ii=SI; ii<=EI; ii++)
        for(ij=SJ; ij<=EJ; ij++)
          for(ik=SK; ik<=EK; ik++) {
            BINDEX[0][index] = ii;
            BINDEX[1][index] = ij;
            BINDEX[2][index] = ik;
            BINDEX[4][index] = i;
            index++;

            var[TEMPBC][IX(ii,ij,ik)] = TMP;
            var[VXBC][IX(ii,ij,ik)] = U;
            var[VYBC][IX(ii,ij,ik)] = V;
            var[VZBC][IX(ii,ij,ik)] = W;
            var[Xi1BC][IX(ii,ij,ik)] = MASS;

            flagp[IX(ii,ij,ik)] = INLET; /* Cell flag to be inlet*/
            if(para->outp->version==DEBUG) {
              sprintf(msg, "read_sci_input(): get inlet cell[%d,%d,%d]=%.1f",
                ii, ij, ik, flagp[IX(ii,ij,ik)]);
              ffd_log(msg, FFD_NORMAL);
            }

          } /* End of assigning the inlet B.C. for each cell*/

    } /* End of loop for each inlet boundary*/
  } /* End of setting inlet boundary*/

  /*****************************************************************************
  | Read the outlet boundary conditions
  *****************************************************************************/
  fgets(string, 400, file_params);
  sscanf(string, "%d", &para->bc->nb_outlet);
  sprintf(msg, "read_sci_input(): para->bc->nb_outlet=%d", para->bc->nb_outlet);
  ffd_log(msg, FFD_NORMAL);

  if(para->bc->nb_outlet!=0) {
    para->bc->outletName = (char**) malloc(para->bc->nb_outlet*sizeof(char*));
    if(para->bc->outletName==NULL) {
      ffd_log("read_sci_input(): Could not allocate memory for "
              "para->bc->outletName.", FFD_ERROR);
      return 1;
    }

    for(i=0; i<para->bc->nb_outlet; i++) {
      /*.......................................................................
      | Get the names of boundary
      .......................................................................*/
      fgets(string, 400, file_params);
      /* Get the length of name (The name may contain white space)*/
      for(j=0; string[j] != '\n' && string[j] != '\r'; j++) {
        continue;
      }

      para->bc->outletName[i] = (char*)malloc((j+1)*sizeof(char));
      if(para->bc->outletName[i]==NULL) {
        sprintf(msg, "read_sci_input(): Could not allocate memory "
          "for para->bc->outletName[%d].", i);
        ffd_log(msg, FFD_ERROR);
        return 1;
      }

      strncpy(para->bc->outletName[i], (const char*)string, j);
      /* Add an ending*/
      para->bc->outletName[i][j] = '\0';
      sprintf(msg, "read_sci_input(): para->bc->outletName[%d]=%s",
              i, para->bc->outletName[i]);
      ffd_log(msg, FFD_NORMAL);

      /*.......................................................................
      | Get the boundary conditions
      .......................................................................*/
      fgets(string, 400, file_params);
      sscanf(string,"%d%d%d%d%d%d%lf%lf%lf%lf%lf",
             &SI, &SJ, &SK, &EI,
             &EJ, &EK, &TMP, &MASS, &U, &V, &W);

      sprintf(msg, "read_sci_input(): VX=%f, VY=%f, VX=%f, T=%f, Xi=%f",
              U, V, W, TMP, MASS);
      ffd_log(msg, FFD_NORMAL);

      if(EI==0) {
        if(SI==1) SI=0;
        EI = SI + EI;
        EJ = SJ + EJ - 1;
        EK = SK + EK - 1;
      }

      if(EJ==0) {
        if(SJ==1) SJ=0;
        EI = SI+EI-1;
        EJ = SJ+EJ;
        EK = SK+EK-1;
      }

      if(EK==0) {
        if(SK==1) SK = 0;
        EI = SI+EI-1;
        EJ = SJ+EJ-1;
        EK = SK+EK;
      }
      /* Assign the outlet boundary condition for each cell*/
      for(ii=SI; ii<=EI ;ii++)
        for(ij=SJ; ij<=EJ ;ij++)
          for(ik=SK; ik<=EK; ik++) {
            BINDEX[0][index] = ii;
            BINDEX[1][index] = ij;
            BINDEX[2][index] = ik;
            BINDEX[4][index] = para->bc->nb_inlet + i;
            index++;

            /* Give the initial value, but the value will be overwritten later*/
            var[TEMPBC][IX(ii,ij,ik)] = TMP;
            var[VXBC][IX(ii,ij,ik)] = U;
            var[VYBC][IX(ii,ij,ik)] = V;
            var[VZBC][IX(ii,ij,ik)] = W;
            var[Xi1BC][IX(ii,ij,ik)] = MASS;
            flagp[IX(ii,ij,ik)] = OUTLET;
            if(para->outp->version==DEBUG) {
              sprintf(msg, "read_sci_input(): get outlet cell[%d,%d,%d]=%.1f",
                ii, ij, ik, flagp[IX(ii,ij,ik)]);
              ffd_log(msg, FFD_NORMAL);
            }
          } /* End of assigning the outlet B.C. for each cell*/
    } /* End of loop for each outlet boundary*/
  } /* End of setting outlet boundary*/

  /*****************************************************************************
  | - Copy the inlet and outlet information to ports
  | - Allocate memory for related port variables
  *****************************************************************************/
  para->bc->nb_port = para->bc->nb_inlet+para->bc->nb_outlet;

  if(para->bc->nb_port>0) {
    /* Allocate memory for the array of ports' names*/
    para->bc->portName = (char**) malloc(para->bc->nb_port*sizeof(char*));
    if(para->bc->portName==NULL) {
      ffd_log("read_sci_input(): Could not allocate memory for para->bc->portName.",
      FFD_ERROR);
      return 1;
    }
    /*--------------------------------------------------------------------------
    | Copy the inlet names to ports' names
    --------------------------------------------------------------------------*/
    for(i=0; i<para->bc->nb_inlet; i++) {
      /* Allocate memory for inlet name*/
      para->bc->portName[i] =
        (char*) malloc(sizeof(char)*(sizeof(para->bc->inletName[i])+1));

      if(para->bc->portName[i]==NULL) {
        ffd_log("read_sci_input():"
                "Could not allocate memory for para->bc->portName.",
        FFD_ERROR);
        return 1;
      }

      /* Copy the inlet name*/
      strcpy(para->bc->portName[i], para->bc->inletName[i]);
      sprintf(msg, "read_sci_input(): Port[%d]:%s",
              i, para->bc->portName[i]);
      ffd_log(msg, FFD_NORMAL);
    }

    /*--------------------------------------------------------------------------
    | Copy the outlet names to ports' names
    --------------------------------------------------------------------------*/
    j = para->bc->nb_inlet;
    for(i=0; i<para->bc->nb_outlet; i++) {
      /* Allocate memory for outlet name*/
      para->bc->portName[i+j] =
        (char*) malloc(sizeof(char)*(sizeof(para->bc->outletName[i])+1));
      if(para->bc->portName[i+j]==NULL) {
        ffd_log("read_sci_input(): "
                "Could not allocate memory for para->bc->portName.",
        FFD_ERROR);
        return 1;
      }
      else {
        strcpy(para->bc->portName[i+j], para->bc->outletName[i]);
        sprintf(msg, "read_sci_input(): Port[%d]:%s",
                i+j, para->bc->portName[i+j]);
        ffd_log(msg, FFD_NORMAL);
      }
    }
    /*--------------------------------------------------------------------------
    | Allocate memory for the surface area
    --------------------------------------------------------------------------*/
    para->bc->APort = (REAL*) malloc(para->bc->nb_port*sizeof(REAL));
    if(para->bc->APort==NULL) {
      ffd_log("read_sci_input(): "
              "Could not allocate memory for para->bc->APort.",
      FFD_ERROR);
      return 1;
    }
    /*--------------------------------------------------------------------------
    | Allocate memory for the velocity (used for inlet only)
    --------------------------------------------------------------------------*/
    para->bc->velPort = (REAL*) malloc(para->bc->nb_port*sizeof(REAL));
    if(para->bc->velPort==NULL) {
      ffd_log("read_sci_input(): "
              "Could not allocate memory for para->bc->velPort.",
      FFD_ERROR);
      return 1;
    }
    /*--------------------------------------------------------------------------
    | Allocate memory for the averaged velocity
    --------------------------------------------------------------------------*/
    para->bc->velPortAve = (REAL*) malloc(para->bc->nb_port*sizeof(REAL));
    if(para->bc->velPortAve==NULL) {
      ffd_log("read_sci_input(): "
              "Could not allocate memory for para->bc->velAve.",
      FFD_ERROR);
      return 1;
    }
    /*--------------------------------------------------------------------------
    | Allocate memory for mean velocity
    --------------------------------------------------------------------------*/
    para->bc->velPortMean = (REAL*) malloc(para->bc->nb_port*sizeof(REAL));
    if(para->bc->velPortMean==NULL) {
      ffd_log("read_sci_input(): "
              "Could not allocate memory for para->bc->velPortMean.",
      FFD_ERROR);
      return 1;
    }
    /*--------------------------------------------------------------------------
    | Allocate memory for the temperature (used for inlet only)
    --------------------------------------------------------------------------*/
    para->bc->TPort = (REAL*) malloc(para->bc->nb_port*sizeof(REAL));
    if(para->bc->TPort==NULL) {
      ffd_log("read_sci_input(): "
              "Could not allocate memory for para->bc->TPort.",
      FFD_ERROR);
      return 1;
    }
    /*--------------------------------------------------------------------------
    | Allocate memory for the averaged temperature
    --------------------------------------------------------------------------*/
    para->bc->TPortAve = (REAL*) malloc(para->bc->nb_port*sizeof(REAL));
    if(para->bc->TPortAve==NULL) {
      ffd_log("read_sci_input(): "
              "Could not allocate memory for para->bc->TPortAve.",
      FFD_ERROR);
      return 1;
    }
    /*--------------------------------------------------------------------------
    | Allocate memory for the mean velocity
    --------------------------------------------------------------------------*/
    para->bc->TPortMean = (REAL*) malloc(para->bc->nb_port*sizeof(REAL));
    if(para->bc->TPortMean==NULL) {
      ffd_log("read_sci_input(): "
              "Could not allocate memory for para->bc->TPortMean.",
      FFD_ERROR);
      return 1;
    }
    /*--------------------------------------------------------------------------
    | Allocate memory for port ID
    --------------------------------------------------------------------------*/
    para->bc->portId = (int*) malloc(para->bc->nb_port*sizeof(int));
    if(para->bc->portId==NULL) {
      ffd_log("read_sci_input(): "
              "Could not allocate memory for para->bc->portId.",
      FFD_ERROR);
      return 1;
    }
  }
  /*****************************************************************************
  | initialize the para->bc->portID
  *****************************************************************************/
  for (i = 0; i < para->bc->nb_port; i++) {
	  para->bc->portId[i] = 0;
  }
  /*****************************************************************************
  | Read the internal solid block boundary conditions
  *****************************************************************************/
  fgets(string, 400, file_params);
  sscanf(string, "%d", &para->bc->nb_block);
  sprintf(msg, "read_sci_input(): para->bc->nb_block=%d", para->bc->nb_block);
  ffd_log(msg, FFD_NORMAL);

  if(para->bc->nb_block!=0) {
    para->bc->blockName = (char**) malloc(para->bc->nb_block*sizeof(char*));
    if(para->bc->blockName==NULL) {
      ffd_log("read_sci_input(): Could not allocate memory for para->bc->blockName.",
      FFD_ERROR);
      return 1;
    }

    for(i=0; i<para->bc->nb_block; i++) {
      /*.......................................................................
      | Get the names of boundary
      .......................................................................*/
      fgets(string, 400, file_params);
      /* Get the length of name (The name may contain white space)*/
      for(j=0; string[j] != '\n' && string[j] != '\r'; j++) {
        continue;
      }

      para->bc->blockName[i] = (char*)malloc((j+1)*sizeof(char));
      if(para->bc->blockName[i]==NULL) {
        sprintf(msg,"read_sci_input(): Could not allocate memory for "
          "para->bc->blockName[%d].", i);
        ffd_log(msg, FFD_ERROR);
        return 1;
      }

      strncpy(para->bc->blockName[i], (const char*)string, j);
      /* Add an ending*/
      para->bc->blockName[i][j] = '\0';
      sprintf(msg, "read_sci_input(): para->bc->blockName[%d]=%s",
              i, para->bc->blockName[i]);
      ffd_log(msg, FFD_NORMAL);

      /*.......................................................................
      | Get the boundary conditions
      .......................................................................*/
      fgets(string, 400, file_params);
      /* X_index_start, Y_index_Start, Z_index_Start,*/
      /* X_index_End, Y_index_End, Z_index_End,*/
      /* Thermal Condition (0: Flux; 1:Temperature), Value of thermal condition*/
      sscanf(string,"%d%d%d%d%d%d%d%lf", &SI, &SJ, &SK, &EI, &EJ, &EK,
                                        &FLTMP, &TMP);
      sprintf(msg, "read_sci_input(): VX=%f, VY=%f, VX=%f, ThermalBC=%d, T/q_dot=%f, Xi=%f",
              U, V, W, FLTMP, TMP, MASS);
      ffd_log(msg, FFD_NORMAL);

      if(SI==1) {
        SI=0;
        if(EI>=imax) EI=EI+SI+1;
        else EI=EI+SI;
      }
      else
        EI=EI+SI-1;

      if(SJ==1) {
        SJ=0;
        if(EJ>=jmax) EJ=EJ+SJ+1;
        else EJ=EJ+SJ;
      }
      else
        EJ=EJ+SJ-1;

      if(SK==1) {
        SK=0;
        if(EK>=kmax) EK=EK+SK+1;
        else EK=EK+SK;
      }
      else
        EK=EK+SK-1;

      for(ii=SI; ii<=EI; ii++)
        for(ij=SJ; ij<=EJ; ij++)
          for(ik=SK; ik<=EK; ik++) {
            BINDEX[0][index] = ii;
            BINDEX[1][index] = ij;
            BINDEX[2][index] = ik;
            BINDEX[3][index] = FLTMP;
            BINDEX[4][index] = i;
            index++;

            switch(FLTMP) {
              case 1:
                var[TEMPBC][IX(ii,ij,ik)] = TMP;
                break;
              case 0:
                var[QFLUXBC][IX(ii,ij,ik)] = TMP;
                break;
              default:
                sprintf(msg, "read_sci_input(): Thermal BC (%d)"
                  "for cell(%d,%d,%d) was not defined",
                  FLTMP, ii, ij, ik);
                ffd_log(msg, FFD_ERROR);
                return 1;
            }

            flagp[IX(ii,ij,ik)] = SOLID; /* Flag for solid*/
          } /* End of assigning value for internal solid block*/
    }
  }

  /*****************************************************************************
  | Read the wall boundary conditions
  *****************************************************************************/
  fgets(string, 400, file_params);
  sscanf(string,"%d", &para->bc->nb_wall);
  sprintf(msg, "read_sci_input(): para->bc->nb_wall=%d", para->bc->nb_wall);
  ffd_log(msg, FFD_NORMAL);

  if(para->bc->nb_wall!=0) {
    /*-------------------------------------------------------------------------
    | Allocate the memory for bc name and id
    -------------------------------------------------------------------------*/
    para->bc->wallName = (char**)malloc(para->bc->nb_wall*sizeof(char*));
    if(para->bc->wallName==NULL) {
      ffd_log("read_sci_input(): Could not allocate memory for "
      "para->bc->wallName.", FFD_ERROR);
      return 1;
    }

    para->bc->wallId = (int *)malloc(sizeof(int)*para->bc->nb_wall);
    if(para->bc->wallId==NULL) {
      ffd_log("read_sci_input(): Could not allocate memory for "
      "para->bc->wallId.", FFD_ERROR);
      return 1;
    }

    for(i=0; i<para->bc->nb_wall; i++)
      para->bc->wallId[i] = -1;

    para->bc->AWall = (REAL*) malloc(para->bc->nb_wall*sizeof(REAL));
    if(para->bc->AWall==NULL) {
      ffd_log("read_sci_input(): Could not allocate memory for "
      "para->bc->AWall.", FFD_ERROR);
      return 1;
    }

    para->bc->temHea = (REAL*) malloc(para->bc->nb_wall*sizeof(REAL));
    if(para->bc->temHea==NULL) {
      ffd_log("read_sci_input(): Could not allocate memory for "
      "para->bc->heaTem.", FFD_ERROR);
      return 1;
    }

    para->bc->temHeaAve = (REAL*) malloc(para->bc->nb_wall*sizeof(REAL));
    if(para->bc->temHeaAve==NULL) {
      ffd_log("read_sci_input(): Could not allocate memory for "
      "para->bc->temHeaAve.", FFD_ERROR);
    return 1;
    }

    para->bc->temHeaMean = (REAL*) malloc(para->bc->nb_wall*sizeof(REAL));
    if(para->bc->temHeaMean==NULL) {
      ffd_log("read_sci_input(): Could not allocate memory for "
      "para->bc->temHeaMean.", FFD_ERROR);
      return 1;
    }

    /*-------------------------------------------------------------------------
    | Read wall conditions for each wall
    -------------------------------------------------------------------------*/
    for(i=0; i<para->bc->nb_wall; i++) {
      /*.......................................................................
      | Get the names of boundary
      .......................................................................*/
      fgets(string, 400, file_params);
      /* Get the length of name (The name may contain white space)*/
      for(j=0; string[j] != '\n' && string[j] != '\r'; j++) {
        continue;
      }

      para->bc->wallName[i] = (char*)malloc((j+1)*sizeof(char));
      if(para->bc->wallName[i]==NULL) {
        sprintf(msg, "read_sci_input(): Could not allocate memory for "
                "para->bc->wallName[%d].", i);
        ffd_log(msg, FFD_ERROR);
        return 1;
      }

      strncpy(para->bc->wallName[i], (const char*)string, j);
      /* Add an ending*/
      para->bc->wallName[i][j] = '\0';
      sprintf(msg, "read_sci_input(): para->bc->wallName[%d]=\"%s\"",
             i, para->bc->wallName[i]);
      ffd_log(msg, FFD_NORMAL);
      /*.......................................................................
      | Get the boundary conditions
      .......................................................................*/
      /* X_index_start, Y_index_Start, Z_index_Start,*/
      /* X_index_End, Y_index_End, Z_index_End,*/
      /* Thermal Condition (0: Flux; 1:Temperature), Value of thermal condition*/
      fgets(string, 400, file_params);
      sscanf(string,"%d%d%d%d%d%d%d%lf", &SI, &SJ, &SK, &EI,
             &EJ, &EK, &FLTMP, &TMP);
      sprintf(msg, "read_sci_input(): ThermalBC=%d, T/q_dot=%f",
              FLTMP, TMP);
      ffd_log(msg, FFD_NORMAL);

      /* Reset X index*/
      if(SI==1) { /* West*/
        SI = 0;
        if(EI>=imax) EI = EI + 1;
      }
      else if(SI==imax+1) /* East*/
        EI = EI + SI;
      else /* Internal*/
        EI = EI + SI - 1;

      /* Reset Y index*/
      if(SJ==1) { /* South*/
        SJ = 0;
        if(EJ>=jmax) EJ = EJ + 1;
      }
      else if(SJ==jmax+1) /* North*/
        EJ = EJ + SJ;
      else /* Internal*/
        EJ = EJ + SJ - 1;
      /* Reset Z index*/
      if(SK==1) { /* Floor*/
        SK = 0;
        if(EK>=kmax) EK = EK + 1;
      }
      else if (SK==kmax+1) /* Ceiling*/
        EK = EK + SK;
      else /* Internal*/
          EK = EK + SK -1;

      /* Assign value for each wall cell*/
      for(ii=SI; ii<=EI; ii++)
        for(ij=SJ; ij<=EJ; ij++)
          for(ik=SK; ik<=EK; ik++) {
            /* If cell hasn't been updated (default value -1)*/
            if(flagp[IX(ii,ij,ik)]<0) {
              BINDEX[0][index] = ii;
              BINDEX[1][index] = ij;
              BINDEX[2][index] = ik;
              /* Define the thermal boundary property*/
              BINDEX[3][index] = FLTMP;
              BINDEX[4][index] = i;
              index++;

              /* Set the cell to solid*/
              flagp[IX(ii,ij,ik)] = SOLID;
              if(FLTMP==1) var[TEMPBC][IX(ii,ij,ik)] = TMP;
              if(FLTMP==0) var[QFLUXBC][IX(ii,ij,ik)] = TMP;
            }
          } /* End of assigning value for each wall cell*/
    } /* End of assigning value for each wall surface*/
  } /* End of assigning value for wall boundary*/

  /*****************************************************************************
  | Read the boundary conditions for contaminant source
  | Warning: The data is ignored in current version
  *****************************************************************************/
  fgets(string, 400, file_params);
  sscanf(string,"%d", &para->bc->nb_source);
  sprintf(msg, "read_sci_input(): para->bc->nb_source=%d", para->bc->nb_source);
  ffd_log(msg, FFD_NORMAL);

  if(para->bc->nb_source!=0) {
    sscanf(string,"%s%d%d%d%d%d%d%lf",
           name, &SI, &SJ, &SK, &EI, &EJ, &EK, &MASS);
    bcnameid++;

    sprintf(msg, "read_sci_input(): Source %s is not used in current version.",
            name);
    ffd_log(msg, FFD_WARNING);
    sprintf(msg, "read_sci_input(): Xi_dot=%f", MASS);
    ffd_log(msg, FFD_NORMAL);
    /*Warning: Need to add code to assign the BC value as other part does*/
  }

  para->geom->index=index;

  /*****************************************************************************
  | Read other simulation data
  *****************************************************************************/
  /* Discard the unused data*/
  fgets(string, 400, file_params); /*maximum iteration*/
  fgets(string, 400, file_params); /*convergence rate*/
  fgets(string, 400, file_params); /*Turbulence model*/
  fgets(string, 400, file_params); /*initial value*/
  fgets(string, 400, file_params); /*minimum value*/
  fgets(string, 400, file_params); /*maximum value*/
  fgets(string, 400, file_params); /*fts value*/
  fgets(string, 400, file_params); /*under relaxation*/
  fgets(string, 400, file_params); /*reference point*/
  fgets(string, 400, file_params); /*monitoring point*/

  /* Discard setting for restarting the old FFD simulation*/
  fgets(string, 400, file_params);
  /*
  sscanf(string,"%d", &para->inpu->read_old_ffd_file);
  sprintf(msg, "read_sci_input(): para->inpu->read_old_ffd_file=%d",
          para->inpu->read_old_ffd_file);
  ffd_log(msg, FFD_NORMAL);
  */
  /* Discard the unused data*/
  fgets(string, 400, file_params); /*print frequency*/
  fgets(string, 400, file_params); /*Pressure variable Y/N*/
  fgets(string, 400, file_params); /*Steady state, buoyancy.*/

  /* Discard physical properties*/
  fgets(string, 400, file_params);
  /*
  sscanf(string,"%f %f %f %f %f %f %f %f %f", &para->prob->rho,
         &para->prob->nu, &para->prob->cond,
         &para->prob->gravx, &para->prob->gravy, &para->prob->gravz,
         &para->prob->beta, &trefmax, &para->prob->Cp);

  sprintf(msg, "read_sci_input(): para->prob->rho=%f", para->prob->rho);
  ffd_log(msg, FFD_NORMAL);

  sprintf(msg, "read_sci_input(): para->prob->nu=%f", para->prob->nu);
  ffd_log(msg, FFD_NORMAL);

  sprintf(msg, "read_sci_input(): para->prob->cond=%f", para->prob->cond);
  ffd_log(msg, FFD_NORMAL);

  sprintf(msg, "read_sci_input(): para->prob->gravx=%f", para->prob->gravx);
  ffd_log(msg, FFD_NORMAL);

  sprintf(msg, "read_sci_input(): para->prob->gravy=%f", para->prob->gravy);
  ffd_log(msg, FFD_NORMAL);

  sprintf(msg, "read_sci_input(): para->prob->gravz=%f", para->prob->gravz);
  ffd_log(msg, FFD_NORMAL);

  sprintf(msg, "read_sci_input(): para->prob->beta=%f", para->prob->beta);
  ffd_log(msg, FFD_NORMAL);

  //para->prob->trefmax=trefmax;
  sprintf(msg, "read_sci_input(): para->prob->Cp=%f", para->prob->Cp);
  ffd_log(msg, FFD_NORMAL);
  */

  /* Read simulation time settings*/
  fgets(string, 400, file_params);
  sscanf(string,"%lf %lf %d", &para->mytime->t_start, &para->mytime->dt,
    &para->mytime->step_total);

  sprintf(msg, "read_sci_input(): para->mytime->t_start=%f",
          para->mytime->t_start);
  ffd_log(msg, FFD_NORMAL);

  sprintf(msg, "read_sci_input(): para->mytime->dt=%f", para->mytime->dt);
  ffd_log(msg, FFD_NORMAL);

  sprintf(msg, "read_sci_input(): para->mytime->step_total=%d",
          para->mytime->step_total);
  ffd_log(msg, FFD_NORMAL);

  fgets(string, 400, file_params); /*prandtl*/

  /*****************************************************************************
  | Conclude the reading process
  *****************************************************************************/
  fclose(file_params);

  free(delx);
  free(dely);
  free(delz);

  sprintf(msg, "read_sci_input(): Read sci input file %s",
          para->inpu->parameter_file_name);
  ffd_log(msg, FFD_NORMAL);
  /* Free the filePath allocated in parameter_reader.c*/
  if (para->cosim->para->filePath != NULL){
    free(para->cosim->para->filePath);
  }
  return 0;
} /* End of read_sci_input()*/


	/*
		* Read the file to identify the block cells in space
		*
		* @param para Pointer to FFD parameters
		* @param var Pointer to FFD simulation variables
		* @param BINDEX Pointer to boundary index
		*
		* @return 0 if no error occurred
		*/
int read_sci_zeroone(PARA_DATA *para, REAL **var, int **BINDEX) {
  int i, j, k;
  int delcount=0;
  int mark;
  int imax = para->geom->imax;
  int jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int index = para->geom->index;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *flagp = var[FLAGP];

  if( (file_params=fopen(para->inpu->block_file_name,"r")) == NULL ) {
    sprintf(msg, "read_sci_input():Could not open file \"%s\"!\n",
            para->inpu->block_file_name);
    ffd_log(msg, FFD_ERROR);
    return 1;
  }

  sprintf(msg, "read_sci_input(): start to read block information from \"%s\".",
          para->inpu->block_file_name);
  ffd_log(msg, FFD_NORMAL);

  for(k=1;k<=kmax;k++)
    for(j=1;j<=jmax;j++)
      for(i=1;i<=imax;i++) {
        fscanf(file_params,"%d" ,&mark);

        /* mark=1 block cell;mark=0 fluid cell*/

        if(mark==1) {
          flagp[IX(i,j,k)] = SOLID;
          BINDEX[0][index] = i;
          BINDEX[1][index] = j;
          BINDEX[2][index] = k;
          index++;
        }
        delcount++;

        if(delcount==25) {
          fscanf(file_params,"\n");
          delcount=0;
        }
      }

  fclose(file_params);
  para->geom->index=index;

  sprintf(msg, "read_sci_input(): end of reading zeroone.dat.");
  ffd_log(msg, FFD_NORMAL);

  return 0;
} /* End of read_sci_zeroone()*/


	/*
		* Identify the properties of cells
		*
		* @param para Pointer to FFD parameters
		* @param var Pointer to FFD simulation variables
		*
		* @return 0 if no error occurred
		*/
void mark_cell(PARA_DATA *para, REAL **var) {
  int i,j, k;
  int imax = para->geom->imax;
  int jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *flagu = var[FLAGU],*flagv = var[FLAGV],*flagw = var[FLAGW];
  REAL *flagp = var[FLAGP];

  flagp[IX(0,0,0)] = SOLID;
  flagp[IX(0,0,kmax+1)] = SOLID;
  flagp[IX(0,jmax+1,0)] = SOLID;
  flagp[IX(0,jmax+1,kmax+1)] = SOLID;
  flagp[IX(imax+1,0,0)] = SOLID;
  flagp[IX(imax+1,0,kmax+1)] = SOLID;
  flagp[IX(imax+1,jmax+1,0)] = SOLID;
  flagp[IX(imax+1,jmax+1,kmax+1)] = SOLID;

  FOR_EACH_CELL

    if(flagp[IX(i,j,k)]>=0) continue;

    if(flagp[IX(i-1,j,k)]>=0 && flagp[IX(i+1,j,k)]>=0 &&
      flagp[IX(i,j-1,k)]>=0 && flagp[IX(i,j+1,k)]>=0 &&
      flagp[IX(i,j,k-1)]>=0 && flagp[IX(i,j,k+1)]>=0 )
      flagp[IX(i,j,k)] = SOLID;
  END_FOR

  FOR_ALL_CELL

  if(flagp[IX(i,j,k)]==1) {

    flagu[IX(i,j,k)]=1;
    flagv[IX(i,j,k)]=1;
    flagw[IX(i,j,k)]=1;

    if(i!=0) flagu[IX(i-1,j,k)]=1;
    if(j!=0) flagv[IX(i,j-1,k)]=1;
    if(k!=0) flagw[IX(i,j,k-1)]=1;
  }

  if(flagp[IX(i,j,k)]==0) {
    flagu[IX(i,j,k)]=0;
    flagv[IX(i,j,k)]=0;
    flagw[IX(i,j,k)]=0;

    if(i!=0) flagu[IX(i-1,j,k)]=0;
    if(j!=0) flagv[IX(i,j-1,k)]=0;
    if(k!=0) flagw[IX(i,j,k-1)]=0;
}

  if(flagp[IX(i,j,k)]==2) {

    flagu[IX(i,j,k)]=2;
    flagv[IX(i,j,k)]=2;
    flagw[IX(i,j,k)]=2;

    if(i!=0) flagu[IX(i-1,j,k)]=2;
    if(j!=0) flagv[IX(i,j-1,k)]=2;
    if(k!=0) flagw[IX(i,j,k-1)]=2;
}

  END_FOR
} /* End of mark_cell()*/
