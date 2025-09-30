/******************************************************************************
|
| \file   ffd_isat.c
|
| \brief  define function to perform ffd_isat training and testing
|
|  \author Xu Han
|          Univeristy of Colorado Boulder, xuha3556@colorado.edu
|          Wei Tian
|          University of Miami, Schneider Electric
|          w.tian@umiami.edu, Wei.Tian@Schneider-Electric.com
|          Dan Li
|          University of Miami
|
|  \date   4/5/2020
|
| \  All RIGHTS RESERVED.
******************************************************************************/
#include "ffd_isat.h"

/******************************************************************************
| recursive subroutine isatab( idtab, mode, nx, x, nf, nh, nhd, usrfgh, iusr, rusr, info, rinfo, fa, ga, ha, stats )
| -------  INPUT
|
|    idtab       - unique identifier of the table (idtab >= 0 )
|    mode        - integer determining the action to be taken 
|                  = 0 for a "regular query call" (i.e., given x, return fa)
|                  > 0 for "special calls" (described below)
|    nx          - number of components of x  ( nx >= 1 )
|    x           - components of x
|    nf          - number of components of f  ( nf >= 1 )
|    nh          - number of components of h  ( nh >= 0 )
|    nhd         - dimension of ha ( nhd >= max(1,nh) )
|    usrfgh      - name of the user-supplied subroutine that returns
|                  f(x), g(x) = df(x)/dx, and h(x) (see below)
|    iusr        - user-defined integer array passed to usrfgh
|                  Note: instead passing integer array
|                  ffd exchange struct pointer here
|    rusr        - user-defined real array passed to usrfgh
|    info        - integer array controlling ISATAB operations (see below)
|    rinfo       - real array controlling ISATAB operations (see below)
| 
| -------  OUTPUT
| 
|    fa          - piecewise-linear approximation to f(x)
|    ga          - piecewise-constant approximation to g(x) (for info(2)=1)
|                  (ga must be dimensioned at least nf*nx)
|    ha          - piecewise-constant approximation to h(x) (for info(3)=1)
|    stats       - statistics of ISATAB performance (see below)
| 
|   Note: Depending on  mode  and other settings, some of the input may not be
|   referenced, and some of the output may not be set. (Write for ISAT Fortan lib)
******************************************************************************/

/******************************************************************************
| This function calls the Fortran library that contains some open source 
| external code. Please see the following copyright notices:
******************************************************************************/

/*Copyright for ISAT library from Cornell Univeristy*/

/*Copyright © 2012, Cornell University
	All rights reserved.

	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are
	met:

	1. Redistributions of source code must retain the above copyright
	notice, this list of conditions and the following disclaimer.

	2. Redistributions in binary form must reproduce the above copyright
	notice, this list of conditions and the following disclaimer in the
	documentation and/or other materials provided with the distribution.

	3. Neither the name of the Cornell University nor the names of its
	contributors may be used to endorse or promote products derived from
	this software without specific prior written permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
	"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
	LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
	A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
	HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
	SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
	LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
	DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
	THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
	OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/
	
/*Copyright for ISAT library from Ithaca Combustion Enterprise*/

/*Copyright © 2012, Ithaca Combustion Enterprise, LLC
	All rights reserved.

	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are
	met:

	1. Redistributions of source code must retain the above copyright
	notice, this list of conditions and the following disclaimer.

	2. Redistributions in binary form must reproduce the above copyright
	notice, this list of conditions and the following disclaimer in the
	documentation and/or other materials provided with the distribution.

	3. Neither the name of the Ithaca Combustion Enterprise, LLC nor the
	names of its contributors may be used to endorse or promote products
	derived from this software without specific prior written permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
	"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
	LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
	A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
	HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
	SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
	LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
	DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
	THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
	OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/
	
/*Copyright for MINPACK library used in ISAT library*/

/*Minpack Copyright Notice (1999) University of Chicago.  All rights reserved

	Redistribution and use in source and binary forms, with or
	without modification, are permitted provided that the
	following conditions are met:

	1. Redistributions of source code must retain the above
	copyright notice, this list of conditions and the following
	disclaimer.

	2. Redistributions in binary form must reproduce the above
	copyright notice, this list of conditions and the following
	disclaimer in the documentation and/or other materials
	provided with the distribution.

	3. The end-user documentation included with the
	redistribution, if any, must include the following
	acknowledgment:

	   "This product includes software developed by the
	   University of Chicago, as Operator of Argonne National
	   Laboratory.

	Alternately, this acknowledgment may appear in the software
	itself, if and wherever such third-party acknowledgments
	normally appear.

	4. WARRANTY DISCLAIMER. THE SOFTWARE IS SUPPLIED "AS IS"
	WITHOUT WARRANTY OF ANY KIND. THE COPYRIGHT HOLDER, THE
	UNITED STATES, THE UNITED STATES DEPARTMENT OF ENERGY, AND
	THEIR EMPLOYEES: (1) DISCLAIM ANY WARRANTIES, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO ANY IMPLIED WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE
	OR NON-INFRINGEMENT, (2) DO NOT ASSUME ANY LEGAL LIABILITY
	OR RESPONSIBILITY FOR THE ACCURACY, COMPLETENESS, OR
	USEFULNESS OF THE SOFTWARE, (3) DO NOT REPRESENT THAT USE OF
	THE SOFTWARE WOULD NOT INFRINGE PRIVATELY OWNED RIGHTS, (4)
	DO NOT WARRANT THAT THE SOFTWARE WILL FUNCTION
	UNINTERRUPTED, THAT IT IS ERROR-FREE OR THAT ANY ERRORS WILL
	BE CORRECTED.

	5. LIMITATION OF LIABILITY. IN NO EVENT WILL THE COPYRIGHT
	HOLDER, THE UNITED STATES, THE UNITED STATES DEPARTMENT OF
	ENERGY, OR THEIR EMPLOYEES: BE LIABLE FOR ANY INDIRECT,
	INCIDENTAL, CONSEQUENTIAL, SPECIAL OR PUNITIVE DAMAGES OF
	ANY KIND OR NATURE, INCLUDING BUT NOT LIMITED TO LOSS OF
	PROFITS OR LOSS OF DATA, FOR ANY REASON WHATSOEVER, WHETHER
	SUCH LIABILITY IS ASSERTED ON THE BASIS OF CONTRACT, TORT
	(INCLUDING NEGLIGENCE OR STRICT LIABILITY), OR OTHERWISE,
	EVEN IF ANY OF SAID PARTIES HAS BEEN WARNED OF THE
	POSSIBILITY OF SUCH LOSS OR DAMAGES.*/
	
/*Copyright for LAPACK libraries used in ISAT library*/

	/*Copyright (c) 1992-2013 The University of Tennessee and The University
							of Tennessee Research Foundation.  All rights
							reserved.
	Copyright (c) 2000-2013 The University of California Berkeley. All
							rights reserved.
	Copyright (c) 2006-2013 The University of Colorado Denver.  All rights
							reserved.

	$COPYRIGHT$

	Additional copyrights may follow

	$HEADER$

	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are
	met:

	- Redistributions of source code must retain the above copyright
	  notice, this list of conditions and the following disclaimer.

	- Redistributions in binary form must reproduce the above copyright
	  notice, this list of conditions and the following disclaimer listed
	  in this license in the documentation and/or other materials
	  provided with the distribution.

	- Neither the name of the copyright holders nor the names of its
	  contributors may be used to endorse or promote products derived from
	  this software without specific prior written permission.

	The copyright holders provide no reassurances that the source code
	provided does not infringe any patent, copyright, or any other
	intellectual property rights of third parties.  The copyright holders
	disclaim any liability to any recipient for claims brought against
	recipient by any third party for infringement of that parties
	intellectual property rights.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
	"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
	LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
	A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
	OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
	SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
	LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
	DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
	THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
	OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/

/******************************************************************************
| Declaration of ISATAB in isat (external static library)
******************************************************************************/

/* Windows*/
#ifdef _MSC_VER
void ISATAB(int *idtab, int *mode, const int *nx, double x[], const int *nf, const int *nh, const int *nhd, void *usrfgh, \
	int iusr[], double rusr[], int info[], double rinfo[], double fa[], double ga[nx_SIZE][nf_SIZE], double ha[], double stats[]);
/* Linux*/
#else
void isatab_(int *idtab, int *mode, const int *nx, double x[], const int *nf, const int *nh, const int *nhd, void *usrfgh, \
	int iusr[], double rusr[], int info[], double rinfo[], double fa[], double ga[nx_SIZE][nf_SIZE], double ha[], double stats[]);
#endif

/******************************************************************************
| Initialize parameter for calling ISAT or slover
******************************************************************************/
  int num_input = 2;
  int num_output = 1;
  double outp_Boundary_upper[5] = { 0 };
  double outp_Boundary_lower[5] = { 0 };
  int divide_grid = 1;
  OUTPUT_TYPE outp_name[5] = { temp_occ };
  INPUT_TYPE inpu_name[10] = { sur_temp };
  /* Declare and initialize variables */
  int num_inlet = 0, num_block = 0, num_wall = 0, dir_inlet = 0;
  /* temperature, heat flux or velocity will be overwritten or not */
  int inlet_temp_re[10] = { 0 };
  int inlet_vel_re[10] = { 0 };
  int block_re[10] = { 0 };
  int wall_re[20] = { 0 };
  int wall_heat_re[20] = { 0 };
  /* temperature, heat flux or velocity will be overwritten by which isat input */
  int inlet_temp_wh[10] = { 0 };
  int inlet_vel_wh[10] = { 0 };
  int block_wh[10] = { 0 };
  int wall_wh[20] = { 0 };
  int wall_heat_wh[20] = { 0 };

  char filepath[400] = { 0 };
  int readexisting = 1;
  int writeexisting = 1;

  #define ISAT_SMALL 1e-6
  /* define the ita */
  float ita = 5 / 10000;              /* allow 5 add or grow per 10000 queries */
  float VPower = 1.0;
  int idtab = 1;                      /* Just set to 1 if only one table */
  int mode = 0;                       /* mode = 0 is defualt */
  int nx;                             /* Calculate in main */
  int nf;                             /* Calculate in main */
  int nh = 0;                         /* If the additional function h(x) is not required, set nh=0, nhd=1. */
  int nhd = 1;                        /* Function h is not used so far */

  /* define inputs of isat.lib */	
  double x[nx_SIZE] = {0};            /* Initialize x */
  double fa[nf_SIZE] = {0};           /* Initialize fa */
  double ga[nx_SIZE][nf_SIZE] = {0};  /* Initialize ga. Note: In Fortran, g(nf,nx). Initialize in C by a reverse matrix */
  double ha[nh_SIZE] = {0};           /* Initialize fa */
  double rusr[nf_SIZE] = {nf_SIZE};   /* Note rusr[1]=its length, so >=1. It may used to contain f in some special usage */

  int info[70] = {0};                 /* Initialize by default value 0 */
  double rinfo[100] = {0};            /* Initialize by default value 0 */
  double stats[100] = {0};            /* Initialize memory for store performance info */
  double unusedPointer = 0;           /* Initialize an unused pointer */
  int need[3] = {1,0,0};              /* Initialize need for call solver directly */  
  double time_elipse = 0; 	      /*the time before launching the isat */
  ffdIO ffdStruct;                    /* A struct passed to ffd contains constant */
                                      /* Note: only some constants could pass to ffd through here. Input and out put must in x,fa and ga. */
									  
/******************************************************************************
| Initialize variables for performance statistics
******************************************************************************/
  clock_t tStart = 0;
  clock_t tEnd = 0;
  time_t tExeStart;                   /*Start of system time*/
  time_t tExeEnd;                     /*End of system time*/
  double cpuISAT = 0;                 /*CPU secounds on ISAT*/
  double cpuDE = 0;                   /*CPU secounds on direct evaluation. Direct evaluation called by ISAT is not included.*/
  double cpuCum = 0;
  int nQuery = 0;                     /*Number of queries*/
  int QueryLimit = 10000;             /*Number of queries*/
  double errSum = 0;                  /*Sum of f error*/
  double errMax = 0;                  /*Max of f error*/
  int caltyp =0;                      /*0 training*/
                                      /*1 test*/
  /*Define hash table*/
  hashStruct l, *p, *r, *tmp, *records = NULL;

/******************************************************************************
| MPC control global variable
******************************************************************************/
  /*Logistic*/
  int useISAT = 1;                         /*If use ISAT.*/
  int useRandomTest = 0;                   /*If use Random Test.Need: xBoundary, nRanCall.*/
  int useTablePreparation = 1;             /*If use Table Preparation. Need: xBoundary, xStep.*/
  int useBinarySelectedPoint = 0;          /*If use binary selected training point, like binary tree.*/
  int useNumericalDifferentiation = 0;     /*If use numerical differentiation for ga. Note: Not been implemented yet.*/
  int useAccuracyTest = 1;                 /*If use accuracy test. Note: Perform a direct evaluation at each query. CPU time added in cpuDE*/
  int useErrorControlCorrection = 1;       /*if use error control correction. The total error defined as vector length. Use this to correct order of magnitudes of each component of output vector. Please implement this at ffd_ISAT.c */
  int useBoundaryCenterRange=0;            /*if use Boundary center range. The maximum inputs value difference equals xBoundaryCenterRange/2. Here use it to set limititon of different wall temperature.*/
  int useNormalDistribution=1;             /* = 0, use uniform distribution at random test = 1, use normal distribution at random test */                                             
  int useUnboundedTest = 1;                /* = 0, use xBoundary for random test = 1, use xBoundary2 for random test */                           
  int useRoundInput = 1;                   /* If use rounded input, chose rounded digits after decimal */
  
  double** xBoundary;                      /*Contains lower and upper boundary of x.*/
  double xBoundaryCenterRange = 10;        /*Contains centered range of inputs in a rectangular domian. To set maximum difference of inputs at different dimensions.*/
  
  double* xStep;                           /*Step size to generate table.*/

  int nRanCall = 10;                       /*Number of Random call for testing*/

  double** xBoundary2;                     /*Contains lower and upper boundary of x for "unbounded case".*/
	
  double mu=1.0, sigma=10/3;               /* for bounded */
  double sigma2=10/3;                      /* for unbounded */
  
/****************************************************/  
  int digAftdec = 1;                               
                           
  #define RoundDigitsControl 1                   
  #define MANUAL_TEST                            
  #ifdef MANUAL_TEST   /*Called by ISAT*/          
    double *input1, *input2;                     
    FILE *file_params_tmp;                       
    FILE *file_params_tmp1;                      
    char string[400];                            
    char char_tmp[400];                          
    int i_ite = 0;                               
    int j_ite = 0;                               
  #endif                                         
/****************************************************/

/* global variables */
  REAL **var;
  int  **BINDEX;
  REAL *locmin, *locmax;
  static PARA_DATA para;
  static GEOM_DATA geom;
  static PROB_DATA prob;
  static TIME_DATA mytime;
  static INPU_DATA inpu;
  static OUTP_DATA outp1;
  static BC_DATA bc;
  static SOLV_DATA solv;
  static SENSOR_DATA sens;
  static INIT_DATA init;
  clock_t start, end;

/****************************************************************************
| Assign the parameter for coupled simulation
|
| \para cosim Pointer to the coupled simulation parameters
|
| \return No return needed
****************************************************************************/

int isat_cosimulation(CosimulationData *cosim) {
	para.cosim = (CosimulationData *)malloc(sizeof(CosimulationData));
	para.cosim = cosim;

	if (para.cosim == NULL) {
		ModelicaError("Failed to allocate memory for para.cosim in isat_cosimulation() of ffd_isat.c");
	}

	if (isat_main() != 0) {
		cosim->para->ffdError = 1;
		return 1;
	}
	else
		return 0;
} /* End of ffd_cosimulation()*/

/****************************************************************************
| Main entrance of ffd_isat
| 
| return No return needed
****************************************************************************/
int isat_main () {

  /****************************************************************************
  | Setting for ISAT table
  |
  | Note: Setting in nameList file isat_1.nml is preferable if file exists
  ****************************************************************************/

  /*Note: C is zero based and Fortran is one based. Use manual num-1*/

  /*Basic setting*/
  info[1] = 0;      /*info(2) if_g     = 0, build the table from scratch
                    = 1, read existing table*/
  info[11] = 2;     /*info(12) isatop  = 1, write stats array in .op file for isat performance output on node 0
                    = 2, for isat performance output on all nodes*/

  info[21] = 1;     /*info(22) istats  = 0, stats and fa is not returned
                    = 1, return stats as well as fa*/
  /* may be overwritten */
  rinfo[0] = 0.4;   /*rinfo(1) errtol, Note: total error*/
                    /*Need muanally add a factor in f(x) if we want different accuray in myltiple out puts*/
                    /*Need double check*/

                    /*Checkpointing*/
  info[9] = 0;      /*info(10) ichin    = 0, the ISAT table is created from scratch
                    = 1,Read previous table, required tab file existed and identical case condition*/

  info[10] = 2;     /*info(11) ichout   = 1, To checkpoint the table occasionally on node 0
                    = 2, to checkpoint the table occasionally on all nodes*/

  info[19] = 1;     /*info(20) stats0   = 0, for ichin=1, continue from  stats  read from isat_#_P.tab
                    = 1  for ichin=1, re-initialize  stats*/

  /****************************************************************************
  | Initialize log file and executive time
  ****************************************************************************/
  tExeStart = time(NULL);
  sprintf(logMsg, "Executable start: %s", ctime(&tExeStart));
  cosim_log(logMsg, COSIM_NEW);
  para.bc = (BC_DATA *)malloc(sizeof(BC_DATA));
  if (para.bc == NULL) {
    ModelicaError("Failed to allocate memory for para.bc in isat_main () of ffd_isat.c");
  }
  para.geom = (GEOM_DATA *)malloc(sizeof(GEOM_DATA));
  if (para.geom == NULL) {
    ModelicaError("Failed to allocate memory for para.geom in isat_main () of ffd_isat.c");
  }
  para.inpu = (INPU_DATA *)malloc(sizeof(INPU_DATA));
  if (para.inpu == NULL) {
    ModelicaError("Failed to allocate memory for para.inpu in isat_main () of ffd_isat.c");
  }
  para.outp = (OUTP_DATA *)malloc(sizeof(OUTP_DATA));
  if (para.outp == NULL) {
    ModelicaError("Failed to allocate memory for para.outp in isat_main () of ffd_isat.c");
  }
  para.prob = (PROB_DATA *)malloc(sizeof(PROB_DATA));
  if (para.prob == NULL) {
    ModelicaError("Failed to allocate memory for para.prob in isat_main () of ffd_isat.c");
  }
  para.mytime = (TIME_DATA *)malloc(sizeof(TIME_DATA));
  if (para.mytime == NULL) {
    ModelicaError("Failed to allocate memory for para.mytime in isat_main () of ffd_isat.c");
  }
  para.solv = (SOLV_DATA *)malloc(sizeof(SOLV_DATA));
  if (para.solv == NULL) {
    ModelicaError("Failed to allocate memory for para.solv in isat_main () of ffd_isat.c");
  }
  para.sens = (SENSOR_DATA *)malloc(sizeof(SENSOR_DATA));
  if (para.sens == NULL) {
    ModelicaError("Failed to allocate memory for para.sens in isat_main () of ffd_isat.c");
  }
  para.init = (INIT_DATA *)malloc(sizeof(INIT_DATA));
  if (para.init == NULL) {
    ModelicaError("Failed to allocate memory for para.init in isat_main () of ffd_isat.c");
  }

  cosim_log("isat_main(): Start ISAT-FFD simulation", COSIM_NORMAL);

  /*read isat general settings*/
  if (read_isat_general() != 0) {
	  cosim_log("isat_main (): could not read_isat_general()", COSIM_ERROR);
	  return 1;
  }

  /*allocate memory for isat global variables*/
  if (allocate_memory_isat() != 0) {
	  cosim_log("isat_main (): could not allocate_memory_isat()", COSIM_ERROR);
	  return 1;
  }

  /*read isat input/output settings*/
  if (read_isat_input_output() != 0) {
	  cosim_log("isat_main (): could not read_isat_input_output()", COSIM_ERROR);
	  return 1;
  }

  /****************************************************************************
  | Calculate nx and nf
  ****************************************************************************/
  nx = num_input;
  nf = num_output;

  /****************************************************************************
  | Update non-rectangular input domain
  ****************************************************************************/
  if (useBoundaryCenterRange) {
  }
  /****************************************************************************
  | Use Binary Selected Point Training
  ****************************************************************************/
  if (useBinarySelectedPoint) {
	cosim_log("-------------------------------------------------------------------", COSIM_NORMAL);
	cosim_log("isat_main(): Start binary train", COSIM_NORMAL);
	binaryTrain();
  }
  /****************************************************************************
  | While loop test for cosimulation
  ****************************************************************************/
  cosim_loop(para);
  /****************************************************************************
  | Post precess of log
  ****************************************************************************/
  /* Inform Modelica the stopping command has been received*/
  para.cosim->para->flag = 2;
  /*ffd_log("ffd(): Sent stopping signal to Modelica", FFD_NORMAL);*/
  cosim_log("main(): Sent stopping signal to Modelica", COSIM_NORMAL);

  return 0;

} /* End of Main */

/****************************************************************************
|  Allocate memory for variables
|
| \isat global parameters
|
| \return No return needed
****************************************************************************/
int allocate_memory_isat() {
	int i, j;
	/****************************************************************************
	| Allocate memory for variables
	****************************************************************************/
	xStep = (REAL*)calloc(num_input, sizeof(REAL));
	if (xStep == NULL) {
		sprintf(logMsg, "allocate_memory_isat(): Could not allocate memory for xStep");
		cosim_log(logMsg, COSIM_ERROR);
		return 1;
	}
	for (i = 0; i < num_input; i++) {
		xStep[i] = 0.1;
	}

	xBoundary = (REAL**)malloc(num_input * sizeof(REAL*));
	xBoundary2 = (REAL**)malloc(num_input * sizeof(REAL*));
	for (i = 0; i < num_input; i++) {
		xBoundary[i] = (REAL*)calloc(2, sizeof(REAL));
		if (xBoundary[i] == NULL) {
			sprintf(logMsg, "allocate_memory_isat(): Could not allocate memory for xBoundary[%d]", i);
			ModelicaError(logMsg);
		}
		else {
			xBoundary[i][0] = 0;
			xBoundary[i][1] = 1;	
		}

		xBoundary2[i] = (REAL*)calloc(2, sizeof(REAL));
		if (xBoundary2[i] == NULL) {
			sprintf(logMsg, "allocate_memory_isat(): Could not allocate memory for xBoundary2[%d]", i);
			ModelicaError(logMsg);
		}
		else {
			xBoundary2[i][0] = 0;
			xBoundary2[i][1] = 1;
		}
	}

	return 0;
} /* End of allocate_memory() */


/****************************************************************************
| Prepare the training domain using recursion method
| 
|  Note: Table will prepared with xBoundary and xStep
|        Calling with input nx
| \param Demantion number of current recursion
| 
| \return No return needed
| 
| Fixme: Update 
****************************************************************************/
void nDemArrEva(int dimension, double xStep[]) {

  int i = dimension - 1;
  double currentX=0.0;

  if (i == -1) {
    /*Check hash table*/
    findHash();
    if (!p){
      addHash();
      evaluate();
    }
  }
  else {

    for (currentX = xBoundary[i][0]; currentX <= xBoundary[i][1]+ISAT_SMALL; currentX += xStep[i]) {
      x[i] = currentX;
      nDemArrEva(i,xStep);
    }

  } /*End of if*/
} /* End of iterate */


/****************************************************************************
|  Perform a evaluation with current input in global variable
| 
|  Note: Use solver or ISAT depends on useISAT
| 
****************************************************************************/
void evaluate(){
  int i;
  /*check if use rounded input*/
  if (useRoundInput){
    for (i=0; i<nx; i++){
      x[i] = my_round(x[i],digAftdec);
    }
  }
  if (useISAT) {
	tStart = clock();

	/* Windows*/
	#ifdef _MSC_VER
		ISATAB(&idtab, &mode, &nx, x, &nf, &nh, &nhd, (void *)&unusedPointer, (int *)&ffdStruct, rusr, info, rinfo, fa, ga, ha, stats);
	/* Linux*/
	#else
		isatab_(&idtab, &mode, &nx, x, &nf, &nh, &nhd, (void *)&unusedPointer, (int *)&ffdStruct, rusr, info, rinfo, fa, ga, ha, stats);
	#endif
	tEnd = clock();
	cpuCum = (double)(tEnd - tStart) / CLOCKS_PER_SEC;
	cpuISAT += cpuCum;
  }
  else {
    tStart = clock();
    ffd_ISAT(need, x, fa, ga, (void *)&ffdStruct);
    cpuDE += (clock() - tStart) / CLOCKS_PER_SEC;
  }

  /*increase nQuery*/
  nQuery++;

  /*write record*/
  writeRecord();
 
  /*update time_elipse*/
  time_elipse = cpuISAT;

}/*end of evaluate*/

 /****************************************************************************
 |  Perform a direct evaluation of f and record accuracy
 | 
 |  Note: This function is only called by evaluate()
 ****************************************************************************/
void accuracyTest() {
  int i;
  double fDE[nf_SIZE] = { 0 };
  double dotProduct = 0;
  double err = 0;

  /*Direct evaluate*/
  tStart = clock();
  ffd_ISAT(need, x, fDE, ga, (void *)&ffdStruct);
  cpuDE += (clock() - tStart) / CLOCKS_PER_SEC;

  /*Record accuracy*/

  /*Use vector length to represent error: square root of the dot product*/
  for (i = 0; i < nf; i++)
    dotProduct += (fa[i] - fDE[i]) * (fa[i] - fDE[i]);

  err = sqrt(dotProduct);

  /*Update sum and max*/
  errSum += err;

  if (err > errMax)
    errMax = err;

}/*end of accurateTest*/


/****************************************************************************
|  Perform a evaluation with random input within boundary of x
| 
|  Note: Use solver or ISAT depends on useISAT
| 
|  param number of random calls
| 
|  return No return needed
****************************************************************************/
void randomCall (int nCall, int useNormalDistribution, int useUnboundedTest){
  int i, j, r;
  for (i = 0; i < nCall; i++) {
    /*Prepare input*/
    for (j = 0; j < nx; j++) {
      x[j] = getRandom(j,useNormalDistribution,useUnboundedTest);
    }
    evaluate();
  }

}

/****************************************************************************
| Write the information to log file
| return No return needed
****************************************************************************/
void writeRecord (){
  	int i;
	sprintf(logMsg, "nQuery,stats[1-5], isat_cum, cpu_cum:\t%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f", nQuery,stats[0],stats[1],stats[2],stats[3],stats[4],stats[8],stats[81],cpuISAT );
	cosim_log(logMsg, COSIM_NORMAL);
	for (i = 0; i < num_input; i++) {
		sprintf(logMsg, "\tinput[%d]:\t%f", i, x[i]);
		cosim_log(logMsg, COSIM_NORMAL);
	}
	for (i = 0; i < num_output; i++) {
		sprintf(logMsg, "\toutput[%d]:\t%f\t%f", i, fa[i], fa[i] * (outp_Boundary_upper[i] - outp_Boundary_lower[i]) + outp_Boundary_lower[i]);
		cosim_log(logMsg, COSIM_NORMAL);
	}
}


/****************************************************************************
| Generate a series of random number for testing isat
| return The series of random number distribution
****************************************************************************/
double getRandom (int dimension, int useNormalDistribution, int useUnboundedTest){
  double r;
  if (!useNormalDistribution){
	r = rand() %1000;
	if (useUnboundedTest)
	  return xBoundary2[dimension][0] + (xBoundary2[dimension][1]-xBoundary2[dimension][0]) * r/1000;
	else
	  return xBoundary[dimension][0] + (xBoundary[dimension][1]-xBoundary[dimension][0]) * r/1000;
  } 
  else {
	if (useUnboundedTest) {
	  return randNormal (mu,sigma2);
	}
	else {
	  r = randNormal (mu,sigma);
	  while (r < xBoundary[dimension][0] || r > xBoundary[dimension][1]) {
		r = randNormal (mu,sigma);
	  }
	return r;

	}/* end of if (useUnboundedTest) */
  }/* end of if (!useNormalDistribution) */

}

/****************************************************************************
|  Generate a series of random number in Normal distribution for testing isat
|  codes source: https://phoxis.org/2013/05/04/generating-random-numbers-from-normal-distribution-in-c/
|  Polar method: https://en.wikipedia.org/wiki/Marsaglia_polar_method
|  Box-method: https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform
|  normal distribution: https://en.wikipedia.org/wiki/Normal_distribution#Generating_values_from_normal_distribution
|  return The series of random number in Normal distribution
****************************************************************************/
double randNormal (double mu, double sigma) {
  double U1, U2, W, mult;
  static double X1, X2;
  static int call = 0;
 
  if (call == 1)
    {
      call = !call;
      return (mu + sigma * (double) X2);
    }
 
  do
    {
      U1 = -1 + ((double) rand () / RAND_MAX) * 2;
      U2 = -1 + ((double) rand () / RAND_MAX) * 2;
      W = pow (U1, 2) + pow (U2, 2);
    }
  while (W >= 1 || W == 0);
 
  mult = sqrt ((-2 * log (W)) / W);
  X1 = U1 * mult;
  X2 = U2 * mult;
 
  call = !call;
 
  return (mu + sigma * (double) X1);
}


/****************************************************************************
| Train the isat using binary-section method
| return No return needed
****************************************************************************/
void binaryTrain () {
  double sumOfGroAdd= 0;
  int i = 0,j = 0;
  int divide =1;
  double* xStep;

  xStep = (double*)calloc(num_input, sizeof(double));
  if (xStep == NULL) {
	  sprintf(logMsg, "allocate_memory_isat(): Could not allocate memory for xStep");
	  cosim_log(logMsg, COSIM_ERROR);
  }

  
  /*initialize the digAftdec*/
  if (RoundDigitsControl) digAftdec = 0;
  /*Round loop of evaluation*/
  do {
  /*dynamically change the digits*/
  if (RoundDigitsControl) digAftdec++;
    sumOfGroAdd  = stats[3]+stats[4];
    /*update xStep*/
    for (i=0; i<nx; i++) {
      xStep[i] = (xBoundary[i][1]- xBoundary[i][0])/divide;
    }

    /* evaluation with current divide */
	nDemArrEva(nx,xStep);
    divide = divide*2;
  } while (divide <= divide_grid);
 /* while (sumOfGroAdd + nQuery * 5 / 1000 <= (stats[3] + stats[4])); */

}

void NoTrain() {
  double sumOfGroAdd = 0;
  int i = 0, j = 0;
  int divide = 1;
  double* xStep;

  xStep = (double*)calloc(num_input, sizeof(double));
  if (xStep == NULL) {
	  sprintf(logMsg, "allocate_memory_isat(): Could not allocate memory for xStep");
	  cosim_log(logMsg, COSIM_ERROR);
  }

  /*initialize the digAftdec*/
  if (RoundDigitsControl) digAftdec = 0;
  cosim_log("NoTrain1", COSIM_NORMAL);

  nDemArrEva(nx, xStep);

}

/****************************************************************************
|  Round the float number to the user-specified accuracy
|  return Round-off number
****************************************************************************/
double my_round(double x, int digits) {
  double d,fac;

  d= digits;
  fac= pow(10, d);

  return floor(x*fac)/fac;
}

/****************************************************************************
|  Retrieve the inputs from hash table
|  return No return needed
****************************************************************************/
void findHash() {
  int i;

  memset(&l, 0, sizeof(hashStruct));

  for (i=0;i < nx; i++)
    l.key.x[i]  = x[i];

  HASH_FIND(hh, records, &l.key, sizeof(hashKey), p);

}

/****************************************************************************
| Add the new FFD simulations to hash table
| return No return needed
****************************************************************************/
void addHash() {
  int i;

  r = (hashStruct*)malloc( sizeof(hashStruct) );
  if (r == NULL) {
    ModelicaError("Failed to allocate memory for i in addHash() of ffd_isat.c");
  }

  memset(r, 0, sizeof(hashStruct));

  for (i=0;i < nx; i++)
    r->key.x[i]  = x[i];

  HASH_ADD(hh, records, key, sizeof(hashKey), r);

}

/****************************************************************************
|  New functions to update the digits (accuracy of round-off) dynamically
| 
|  return No return needed
****************************************************************************/
void update_digit() {
  if (!useBinarySelectedPoint && !caltyp) {
    digAftdec = 1;
  }
  /* else if evenly distribution and evaluation */
  else if (!useBinarySelectedPoint && caltyp) {
    digAftdec = 3;
  }
  /*else if binary and evaluation */
  else if (useBinarySelectedPoint && caltyp) {
    digAftdec = 3;
  }
  else {
    digAftdec = digAftdec;
  }
}

/****************************************************************************
|  Read isat general settings
| 
|  return No return needed
****************************************************************************/
int read_isat_general() {
  char filenametmp[400];
  char string[400], tmp[400], tmp1[400];
  int i;

  cosim_log("-------------------------------------------------------------------",
	COSIM_NORMAL);
  /****************************************************************************
  | overwrite the parameters by user settings
  ****************************************************************************/
  char *lastSlash = strrchr(para.cosim->para->fileName, '/');
  int nPath = strlen(para.cosim->para->fileName) - (strlen(lastSlash) - 1);

  para.cosim->para->filePath = (char*)calloc(nPath + 1, sizeof(char));
  para.inpu->parameter_file_path = (char*)calloc(nPath + 1, sizeof(char));
  if (para.cosim->para->filePath == NULL) {
	cosim_log("read_isat_parameters(): Could not allocate memory for the path to the FFD files", COSIM_ERROR);
	return 1;
  }
  else {
	strncpy(filepath, para.cosim->para->fileName, nPath);
  }
  snprintf(filenametmp, sizeof(filenametmp), "%s%s", filepath, "set.isat");


  /****************************************************************************
  | overwrite the parameters by user settings
  ****************************************************************************/
  if ((file_params = fopen(filenametmp, "r")) == NULL) {
	return 1;
  }
  else {
	sprintf(logMsg, "read_isat_parameters(): Read isat parameters from file %s", filenametmp);
	cosim_log(logMsg, COSIM_NORMAL);
  }
  /* Read the settings for outputs */
  int next = 0;
  while (next == 0) {
	if (fgets(string, 400, file_params) == NULL)
		next = 1;
	if (EOF == sscanf(string, "%s", tmp)) {
		continue;
	}

	/* Read isat.useISAT */
	if (!strcmp(tmp, "isat.useISAT")) {
		sscanf(string, "%s%d", tmp, &useISAT);
		sprintf(logMsg, "\tRead general settings of isat:");
		cosim_log(logMsg, COSIM_NORMAL);
		sprintf(logMsg, "\t\t%s=%d", tmp, useISAT);
		cosim_log(logMsg, COSIM_NORMAL);
	}

	/* Read isat.useBinarySelectedPoint */
	else if (!strcmp(tmp, "isat.useBinarySelectedPoint")) {
		sscanf(string, "%s%d", tmp, &useBinarySelectedPoint);
		sprintf(logMsg, "\t\t%s=%d", tmp, useBinarySelectedPoint);
		cosim_log(logMsg, COSIM_NORMAL);
	}

	/* Read isat.digAftdec */
	else if (!strcmp(tmp, "isat.digAftdec")) {
		sscanf(string, "%s%d", tmp, &digAftdec);
		sprintf(logMsg, "\t\t%s=%d", tmp, digAftdec);
		cosim_log(logMsg, COSIM_NORMAL);
	}

	/* Read isat.read_existing */
	else if (!strcmp(tmp, "isat.read_existing")) {
		sscanf(string, "%s%d", tmp, &readexisting);
		sprintf(logMsg, "\t\t%s=%d", tmp, readexisting);
		cosim_log(logMsg, COSIM_NORMAL);
	}

	/* Read isat.write_existing */
	else if (!strcmp(tmp, "isat.write_existing")) {
		sscanf(string, "%s%d", tmp, &writeexisting);
		sprintf(logMsg, "\t\t%s=%d", tmp, writeexisting);
		cosim_log(logMsg, COSIM_NORMAL);
	}

	/* Read isat.err_global */
	else if (!strcmp(tmp, "isat.err_global")) {
		sscanf(string, "%s%lf", tmp, &rinfo[0]);
		sprintf(logMsg, "\t\t%s=%lf", tmp, rinfo[0]);
		cosim_log(logMsg, COSIM_NORMAL);
	}

	/* Read isat.num_input */
	else if (!strcmp(tmp, "isat.num_input")) {
		sscanf(string, "%s%d", tmp, &num_input);
		if (num_input < 11) {
			sprintf(logMsg, "\t\t%s=%d", tmp, num_input);
			cosim_log(logMsg, COSIM_NORMAL);
		}
		else {
			sprintf(logMsg, "read_isat_parameters(): the current version only supports no more than ten inputs");
			cosim_log(logMsg, COSIM_ERROR);
			return 1;
		}
	}

	/* Read isat.num_output */
	else if (!strcmp(tmp, "isat.num_output")) {
		sscanf(string, "%s%d", tmp, &num_output);
		if (num_output < 6) {
			sprintf(logMsg, "\t\t%s=%d", tmp, num_output);
			cosim_log(logMsg, COSIM_NORMAL);
		}
		else {
			sprintf(logMsg, "read_isat_parameters(): the current version only supports no more than five outputs");
			cosim_log(logMsg, COSIM_ERROR);
			return 1;
		}
	}
  } /* End of while (next = 0)*/

  fclose(file_params);
  return 0;

}


/****************************************************************************
|  Read isat input/output settings
|
|  return No return needed
****************************************************************************/
int read_isat_input_output() {
	char filenametmp[400];
	char string[400], tmp[400], tmp1[400];
	int i;

	cosim_log("-------------------------------------------------------------------",
		COSIM_NORMAL);
	/****************************************************************************
	| overwrite the parameters by user settings
	****************************************************************************/
	char* lastSlash = strrchr(para.cosim->para->fileName, '/');
	int nPath = strlen(para.cosim->para->fileName) - (strlen(lastSlash) - 1);

	para.cosim->para->filePath = (char*)calloc(nPath + 1, sizeof(char));
	para.inpu->parameter_file_path = (char*)calloc(nPath + 1, sizeof(char));
	if (para.cosim->para->filePath == NULL) {
		cosim_log("read_isat_input_output(): Could not allocate memory for the path to the FFD files", COSIM_ERROR);
		return 1;
	}
	else {
		strncpy(filepath, para.cosim->para->fileName, nPath);
	}
	snprintf(filenametmp, sizeof(filenametmp), "%s%s", filepath, "set.isat");


	/****************************************************************************
	| overwrite the parameters by user settings
	****************************************************************************/
	if ((file_params = fopen(filenametmp, "r")) == NULL) {
		return 1;
	}
	else {
		sprintf(logMsg, "read_isat_input_output(): Read isat parameters from file %s", filenametmp);
		cosim_log(logMsg, COSIM_NORMAL);
	}
	/* Read the settings for outputs */
	int next = 0;
	while (next == 0) {
		if (fgets(string, 400, file_params) == NULL)
			next = 1;
		if (EOF == sscanf(string, "%s", tmp)) {
			continue;
		}

		/* Read inpu.inpu_name */
		if (!strcmp(tmp, "/*inpu.inpu_name:")) {
			sprintf(logMsg, "\tRead input settings of isat and ffd:");
			cosim_log(logMsg, COSIM_NORMAL);
			for (i = 0; i < num_input; i++) {
				fgets(string, 400, file_params);
				sscanf(string, "%s", tmp);
				if (!strcmp(tmp, "inpu.inpu_name")) {
					sscanf(string, "%s%s", tmp, tmp1);
					if (!strcmp(tmp1, "inlet_temp"))
						inpu_name[i] = inlet_temp;
					else if (!strcmp(tmp1, "inlet_mass"))
						inpu_name[i] = inlet_mass;
					else if (!strcmp(tmp1, "inlet_vel"))
						inpu_name[i] = inlet_vel;
					else if (!strcmp(tmp1, "block_temp"))
						inpu_name[i] = block_temp;
					else if (!strcmp(tmp1, "block_hea"))
						inpu_name[i] = block_hea;
					else if (!strcmp(tmp1, "rack_hea"))
						inpu_name[i] = rack_hea;
					else if (!strcmp(tmp1, "sur_temp"))
						inpu_name[i] = sur_temp;
					else if (!strcmp(tmp1, "sur_hea"))
						inpu_name[i] = sur_hea;
					else {
						sprintf(logMsg, "read_isat_parameters(): %s is not valid input for %s", tmp1, tmp);
						cosim_log(logMsg, COSIM_ERROR);
						return 1;
					}
					sprintf(logMsg, "\t\t%s[%d]=%s", tmp, i, tmp1);
					cosim_log(logMsg, COSIM_NORMAL);
				} /*end of if (!strcmp(tmp, "inpu.inpu_name"))*/
				else {
					sprintf(logMsg, "read_isat_input_output(): wrong format for %s, which should be inpu.inpu_name", tmp);
					cosim_log(logMsg, COSIM_ERROR);
					return 1;
				}
			} /*End of for (i = 0; i < num_input; i++)*/
		} /*End of else if (!strcmp(tmp, "/*inpu.inpu_name:"))*/

		/* Read inpu.num_inlet */
		else if (!strcmp(tmp, "inpu.num_inlet")) {
			sscanf(string, "%s%d", tmp, &num_inlet);
			sprintf(logMsg, "\t\t%s=%d", tmp, num_inlet);
			cosim_log(logMsg, COSIM_NORMAL);
		}
		/* Read inpu.num_block */
		else if (!strcmp(tmp, "inpu.num_block")) {
			sscanf(string, "%s%d", tmp, &num_block);
			sprintf(logMsg, "\t\t%s=%d", tmp, num_block);
			cosim_log(logMsg, COSIM_NORMAL);
		}
		/* Read inpu.num_wall */
		else if (!strcmp(tmp, "inpu.num_wall")) {
			sscanf(string, "%s%d", tmp, &num_wall);
			sprintf(logMsg, "\t\t%s=%d", tmp, num_wall);
			cosim_log(logMsg, COSIM_NORMAL);
		}

		/* Read inpu.xBoundary_upper */
		else if (!strcmp(tmp, "/*inpu.xBoundary_upper:") && useBinarySelectedPoint == 1) {
			for (i = 0; i < num_input; i++) {
				fgets(string, 400, file_params);
				sscanf(string, "%s", tmp);
				if (!strcmp(tmp, "inpu.xBoundary_upper")) {
					sscanf(string, "%s%lf", tmp, &xBoundary[i][1]);
					sprintf(logMsg, "\t\t%s[%d]=%lf", tmp, i, xBoundary[i][1]);
					cosim_log(logMsg, COSIM_NORMAL);
				}
				else {
					sprintf(logMsg, "read_isat_input_output(): wrong format for %s, which should be outp.outp_name", tmp);
					cosim_log(logMsg, COSIM_ERROR);
					return 1;
				} /* End of if (!strcmp(tmp, "inpu.xBoundary_lower"))*/
			} /* End of for (i = 0; i < num_input; i++)*/
		} /* End of else if (!strcmp(tmp, "/*inpu.xBoundary_lower:"))*/

		else if (!strcmp(tmp, "/*inpu.xBoundary_lower:")) {
			for (i = 0; i < num_input; i++) {
				fgets(string, 400, file_params);
				sscanf(string, "%s", tmp);
				if (!strcmp(tmp, "inpu.xBoundary_lower")) {
					sscanf(string, "%s%lf", tmp, &xBoundary[i][0]);
					sprintf(logMsg, "\t\t%s[%d]=%lf", tmp, i, xBoundary[i][0]);
					cosim_log(logMsg, COSIM_NORMAL);
				}
				else {
					sprintf(logMsg, "read_isat_input_output(): wrong format for %s, which should be outp.outp_name", tmp);
					cosim_log(logMsg, COSIM_ERROR);
					return 1;
				} /* End of if (!strcmp(tmp, "inpu.xBoundary_lower"))*/
			} /* End of for (i = 0; i < num_input; i++)*/
		} /* End of else if (!strcmp(tmp, "/*inpu.xBoundary_lower:"))*/

		/* Read inpu.inlet_temp_re if inpu.num_inlet > 0 */
		else if (!strcmp(tmp, "/*inpu.divide:")) {
			if (useBinarySelectedPoint == 1) {
					fgets(string, 400, file_params);
					sscanf(string, "%s", tmp);
					if (!strcmp(tmp, "inpu.divide")) {
						sscanf(string, "%s%d", tmp, &divide_grid);
						sprintf(logMsg, "\t\t%s=%d", tmp, divide_grid);
						cosim_log(logMsg, COSIM_NORMAL);
					}
					else {
						sprintf(logMsg, "read_isat_input_output(): wrong format for %s, which should be inpu.divide", tmp);
						cosim_log(logMsg, COSIM_ERROR);
						return 1;
					} /* End of if (!strcmp(tmp, "inpu.inlet_temp_re")) */
			} /* End of if (num_input > 0) */
		} /* End of else if (!strcmp(tmp, "/*inpu.inlet_temp_re:")) */


		/* Read inpu.dir_inlet */
		else if (!strcmp(tmp, "inpu.dir_inlet")) {
			if (num_inlet > 0) {
				sscanf(string, "%s%d", tmp, &dir_inlet);
				sprintf(logMsg, "\t\t%s=%d", tmp, dir_inlet);
				cosim_log(logMsg, COSIM_NORMAL);
			}
		}

		/* Read inpu.inlet_temp_re if inpu.num_inlet > 0 */
		else if (!strcmp(tmp, "/*inpu.inlet_temp_re:")) {
			if (num_inlet > 0) {
				for (i = 0; i < num_inlet; i++) {
					fgets(string, 400, file_params);
					sscanf(string, "%s", tmp);
					if (!strcmp(tmp, "inpu.inlet_temp_re")) {
						sscanf(string, "%s%d", tmp, &inlet_temp_re[i]);
						sprintf(logMsg, "\t\t%s[%d]=%d", tmp, i, inlet_temp_re[i]);
						cosim_log(logMsg, COSIM_NORMAL);
					}
					else {
						sprintf(logMsg, "read_isat_input_output(): wrong format for %s, which should be inpu.inlet_temp_re", tmp);
						cosim_log(logMsg, COSIM_ERROR);
						return 1;
					} /* End of if (!strcmp(tmp, "inpu.inlet_temp_re")) */
				} /* End of for (i = 0; i < num_input; i++) */
			} /* End of if (num_input > 0) */
		} /* End of else if (!strcmp(tmp, "/*inpu.inlet_temp_re:")) */

		/* Read inpu.inlet_vel_re if inpu.num_inlet > 0 */
		else if (!strcmp(tmp, "/*inpu.inlet_vel_re:")) {
			if (num_inlet > 0) {
				for (i = 0; i < num_inlet; i++) {
					fgets(string, 400, file_params);
					sscanf(string, "%s", tmp);
					if (!strcmp(tmp, "inpu.inlet_vel_re")) {
						sscanf(string, "%s%d", tmp, &inlet_vel_re[i]);
						sprintf(logMsg, "\t\t%s[%d]=%d", tmp, i, inlet_vel_re[i]);
						cosim_log(logMsg, COSIM_NORMAL);
					}
					else {
						sprintf(logMsg, "read_isat_input_output(): wrong format for %s, which should be inpu.inlet_vel_re", tmp);
						cosim_log(logMsg, COSIM_ERROR);
						return 1;
					} /* End of if (!strcmp(tmp, "inpu.inlet_vel_re")) */
				} /* End of for (i = 0; i < num_input; i++) */
			} /* End of if (num_input > 0) */
		} /* End of else if (!strcmp(tmp, "/*inpu.inlet_vel_re:")) */

				/* Read inpu.inlet_temp_wh if inpu.num_inlet > 0 */
		else if (!strcmp(tmp, "/*inpu.inlet_temp_wh:")) {
			if (num_inlet > 0) {
				for (i = 0; i < num_inlet; i++) {
					fgets(string, 400, file_params);
					sscanf(string, "%s", tmp);
					if (!strcmp(tmp, "inpu.inlet_temp_wh")) {
						sscanf(string, "%s%d", tmp, &inlet_temp_wh[i]);
						sprintf(logMsg, "\t\t%s[%d]=%d", tmp, i, inlet_temp_wh[i]);
						cosim_log(logMsg, COSIM_NORMAL);
					}
					else {
						sprintf(logMsg, "read_isat_input_output(): wrong format for %s, which should be inpu.inlet_temp_wh", tmp);
						cosim_log(logMsg, COSIM_ERROR);
						return 1;
					} /* End of if (!strcmp(tmp, "inpu.inlet_temp_wh")) */
				} /* End of for (i = 0; i < num_input; i++) */
			} /* End of if (num_input > 0) */
		} /* End of else if (!strcmp(tmp, "/*inpu.inlet_temp_wh:")) */

		/* Read inpu.inlet_u_wh if inpu.num_inlet > 0 */
		else if (!strcmp(tmp, "/*inpu.inlet_vel_wh:")) {
			if (num_inlet > 0) {
				for (i = 0; i < num_inlet; i++) {
					fgets(string, 400, file_params);
					sscanf(string, "%s", tmp);
					if (!strcmp(tmp, "inpu.inlet_vel_wh")) {
						sscanf(string, "%s%d", tmp, &inlet_vel_wh[i]);
						sprintf(logMsg, "\t\t%s[%d]=%d", tmp, i, inlet_vel_wh[i]);
						cosim_log(logMsg, COSIM_NORMAL);
					}
					else {
						sprintf(logMsg, "read_isat_parameters(): wrong format for %s, which should be inpu.inlet_vel_wh", tmp);
						cosim_log(logMsg, COSIM_ERROR);
						return 1;
					} /* End of if (!strcmp(tmp, "inpu.inlet_vel_wh")) */
				} /* End of for (i = 0; i < num_input; i++) */
			} /* End of if (num_input > 0) */
		} /* End of else if (!strcmp(tmp, "/*inpu.inlet_vel_wh:")) */

		/* Read inpu.block_re if inpu.num_block > 0 */
		else if (!strcmp(tmp, "/*inpu.block_re:")) {
			if (num_block > 0) {
				for (i = 0; i < num_block; i++) {
					fgets(string, 400, file_params);
					sscanf(string, "%s", tmp);
					if (!strcmp(tmp, "inpu.block_re")) {
						sscanf(string, "%s%d", tmp, &block_re[i]);
						sprintf(logMsg, "\t\t%s[%d]=%d", tmp, i, block_re[i]);
						cosim_log(logMsg, COSIM_NORMAL);
					}
					else {
						sprintf(logMsg, "read_isat_input_output(): wrong format for %s, which should be inpu.block_re", tmp);
						cosim_log(logMsg, COSIM_ERROR);
						return 1;
					} /* End of if (!strcmp(tmp, "inpu.block_re")) */
				} /* End of for (i = 0; i < num_block; i++) */
			} /* End of if (num_block > 0) */
		} /* End of else if (!strcmp(tmp, "/*inpu.block_re:")) */

		/* Read inpu.block_wh if inpu.num_block > 0 */
		else if (!strcmp(tmp, "/*inpu.block_wh:")) {
			if (num_block > 0) {
				for (i = 0; i < num_block; i++) {
					fgets(string, 400, file_params);
					sscanf(string, "%s", tmp);
					if (!strcmp(tmp, "inpu.block_wh")) {
						sscanf(string, "%s%d", tmp, &block_wh[i]);
						sprintf(logMsg, "\t\t%s[%d]=%d", tmp, i, block_wh[i]);
						cosim_log(logMsg, COSIM_NORMAL);
					}
					else {
						sprintf(logMsg, "read_isat_input_output(): wrong format for %s, which should be inpu.block_wh", tmp);
						cosim_log(logMsg, COSIM_ERROR);
						return 1;
					} /* End of if (!strcmp(tmp, "inpu.block_wh")) */
				} /* End of for (i = 0; i < num_block; i++) */
			} /* End of if (num_block > 0) */
		} /* End of else if (!strcmp(tmp, "/*inpu.block_wh:")) */

		/* Read inpu.wall_re if inpu.num_wall > 0 */
		else if (!strcmp(tmp, "/*inpu.wall_re:")) {
			if (num_wall > 0) {
				for (i = 0; i < num_wall; i++) {
					fgets(string, 400, file_params);
					sscanf(string, "%s", tmp);
					if (!strcmp(tmp, "inpu.wall_re")) {
						sscanf(string, "%s%d", tmp, &wall_re[i]);
						sprintf(logMsg, "\t\t%s[%d]=%d", tmp, i, wall_re[i]);
						cosim_log(logMsg, COSIM_NORMAL);
					}
					else {
						sprintf(logMsg, "read_isat_input_output(): wrong format for %s, which should be inpu.wall_re", tmp);
						cosim_log(logMsg, COSIM_ERROR);
						return 1;
					} /* End of if (!strcmp(tmp, "inpu.wall_re")) */
				} /* End of for (i = 0; i < num_wall; i++) */
			} /* End of if (num_wall > 0) */
		} /* End of else if (!strcmp(tmp, "/*inpu.wall_re:")) */

		/* Read inpu.wall_wh if inpu.num_wall > 0 */
		else if (!strcmp(tmp, "/*inpu.wall_wh:")) {
			if (num_wall > 0) {
				for (i = 0; i < num_wall; i++) {
					fgets(string, 400, file_params);
					sscanf(string, "%s", tmp);
					if (!strcmp(tmp, "inpu.wall_wh")) {
						sscanf(string, "%s%d", tmp, &wall_wh[i]);
						sprintf(logMsg, "\t\t%s[%d]=%d", tmp, i, wall_wh[i]);
						cosim_log(logMsg, COSIM_NORMAL);
					}
					else {
						sprintf(logMsg, "read_isat_input_output(): wrong format for %s, which should be inpu.wall_wh", tmp);
						cosim_log(logMsg, COSIM_ERROR);
						return 1;
					} /* End of if (!strcmp(tmp, "inpu.wall_wh")) */
				} /* End of for (i = 0; i < num_wall; i++) */
			} /* End of if (num_wall > 0) */
		} /* End of else if (!strcmp(tmp, "/*inpu.wall_wh:")) */

		/* Read outp.outp_name */
		else if (!strcmp(tmp, "/*outp.outp_name:")) {
			sprintf(logMsg, "\tRead output settings of isat and ffd:");
			cosim_log(logMsg, COSIM_NORMAL);
			for (i = 0; i < num_output; i++) {
				fgets(string, 400, file_params);
				sscanf(string, "%s", tmp);
				if (!strcmp(tmp, "outp.outp_name")) {
					sscanf(string, "%s%s", tmp, tmp1);
					if (!strcmp(tmp1, "temp_roo"))
						outp_name[i] = temp_roo;
					else if (!strcmp(tmp1, "temp_occ"))
						outp_name[i] = temp_occ;
					else if (!strcmp(tmp1, "vel_occ"))
						outp_name[i] = vel_occ;
					else if (!strcmp(tmp1, "temp_sen"))
						outp_name[i] = temp_sen;
					else if (!strcmp(tmp1, "vel_sen"))
						outp_name[i] = vel_sen;
					else if (!strcmp(tmp1, "temp_rack"))
						outp_name[i] = temp_rack;
					else if (!strcmp(tmp1, "heat_wall1"))
						outp_name[i] = heat_wall1;
					else if (!strcmp(tmp1, "heat_wall2"))
						outp_name[i] = heat_wall2;
					else if (!strcmp(tmp1, "heat_wall3"))
						outp_name[i] = heat_wall3;
					else if (!strcmp(tmp1, "heat_wall4"))
						outp_name[i] = heat_wall4;
					else if (!strcmp(tmp1, "heat_wall5"))
						outp_name[i] = heat_wall5;
					else if (!strcmp(tmp1, "heat_wall6"))
						outp_name[i] = heat_wall6;
					else {
						sprintf(logMsg, "read_isat_input_output(): %s is not valid input for %s", tmp1, tmp);
						cosim_log(logMsg, COSIM_ERROR);
						return 1;
					}
					sprintf(logMsg, "\t\t%s[%d]=%s", tmp, i, tmp1);
					cosim_log(logMsg, COSIM_NORMAL);
				} /*end of if (!strcmp(tmp, "outp.outp_name"))*/
				else {
					sprintf(logMsg, "read_isat_input_output(): wrong format for %s, which should be outp.outp_name", tmp);
					cosim_log(logMsg, COSIM_ERROR);
					return 1;
				}
			} /*End of for (i = 0; i < num_output; i++)*/
		} /*End of else if (!strcmp(tmp, "/*outp.outp_name:"))*/

		/* Read outp.outp_weight */
		else if (!strcmp(tmp, "/*outp.outp_Boundary_upper:")) {
			for (i = 0; i < num_output; i++) {
				fgets(string, 400, file_params);
				sscanf(string, "%s", tmp);
				if (!strcmp(tmp, "outp.outp_Boundary_upper")) {
					sscanf(string, "%s%lf", tmp, &outp_Boundary_upper[i]);
					sprintf(logMsg, "\t\t%s[%d]=%lf", tmp, i, outp_Boundary_upper[i]);
					cosim_log(logMsg, COSIM_NORMAL);
				}
				else {
					sprintf(logMsg, "read_isat_input_output(): wrong format for %s, which should be outp.outp_name", tmp);
					cosim_log(logMsg, COSIM_ERROR);
					return 1;
				} /* End of if (!strcmp(tmp, "outp.outp_Boundary_upper"))*/
			} /* End of for (i = 0; i < num_output; i++)*/
		} /* End of else if (!strcmp(tmp, "/*outp.outp_Boundary_upper:"))*/

		else if (!strcmp(tmp, "/*outp.outp_Boundary_lower:")) {
			for (i = 0; i < num_output; i++) {
				fgets(string, 400, file_params);
				sscanf(string, "%s", tmp);
				if (!strcmp(tmp, "outp.outp_Boundary_lower")) {
					sscanf(string, "%s%lf", tmp, &outp_Boundary_lower[i]);
					sprintf(logMsg, "\t\t%s[%d]=%lf", tmp, i, outp_Boundary_lower[i]);
					cosim_log(logMsg, COSIM_NORMAL);
				}
				else {
					sprintf(logMsg, "read_isat_input_output(): wrong format for %s, which should be outp.outp_name", tmp);
					cosim_log(logMsg, COSIM_ERROR);
					return 1;
				} /* End of if (!strcmp(tmp, "outp.outp_Boundary_lower"))*/
			} /* End of for (i = 0; i < num_output; i++)*/
		} /* End of else if (!strcmp(tmp, "/*outp.outp_Boundary_lower:"))*/

		else if (!strcmp(tmp, "/*outp.wall_heat_re:")) {
			for (i = 0; i < para.cosim->para->nSur; i++) {
				fgets(string, 400, file_params);
				sscanf(string, "%s", tmp);
				if (!strcmp(tmp, "outp.wall_heat_re")) {
					sscanf(string, "%s%d", tmp, &wall_heat_re[i]);
					sprintf(logMsg, "\t\t%s[%d]=%d", tmp, i, wall_heat_re[i]);
					cosim_log(logMsg, COSIM_NORMAL);
				}
				else {
					sprintf(logMsg, "read_isat_input_output(): wrong format for %s, which should be outp.wall_heat_re", tmp);
					cosim_log(logMsg, COSIM_ERROR);
					return 1;
				} /* End of if (!strcmp(tmp, "outp.wall_heat_re:"))*/
			} /* End of for (i = 0; i < para.cosim->para->nSur; i++)*/
		} /* End of else if (!strcmp(tmp, "/*outp.wall_heat_re:"))*/

		else if (!strcmp(tmp, "/*outp.wall_heat_wh:")) {
			for (i = 0; i < para.cosim->para->nSur; i++) {
				fgets(string, 400, file_params);
				sscanf(string, "%s", tmp);
				if (!strcmp(tmp, "outp.wall_heat_wh")) {
					sscanf(string, "%s%d", tmp, &wall_heat_wh[i]);
					sprintf(logMsg, "\t\t%s[%d]=%d", tmp, i, wall_heat_wh[i]);
					cosim_log(logMsg, COSIM_NORMAL);
				}
				else {
					sprintf(logMsg, "read_isat_input_output(): wrong format for %s, which should be outp.wall_heat_wh", tmp);
					cosim_log(logMsg, COSIM_ERROR);
					return 1;
				} /* End of if (!strcmp(tmp, "outp.wall_heat_wh:"))*/
			} /* End of for (i = 0; i < para.cosim->para->nSur; i++)*/
		} /* End of else if (!strcmp(tmp, "/*outp.wall_heat_wh:"))*/

	} /* End of while (next = 0)*/

	fclose(file_params);
	return 0;

}



/****************************************************************************
|  Main logic of cosimulation
| 
|  return No return needed
****************************************************************************/
int cosim_loop() {
  int i, next, flag;
  float *input;
  int size = para.cosim->para->nSur + para.cosim->para->nPorts * 2 + para.cosim->para->nSou;
  para.cosim->ffd->input = (REAL*)malloc(size * sizeof(REAL));
  if (para.cosim->ffd->input == NULL) {
    ModelicaError("Failed to allocate memory for para.cosim->ffd->input in cosim_loop() of ffd_isat.c");
  }
  para.cosim->ffd->output = (REAL*)malloc(num_output * sizeof(REAL));
  if (para.cosim->ffd->output == NULL) {
    ModelicaError("Failed to allocate memory for para.cosim->ffd->output in cosim_loop() of ffd_isat.c");
  }
  flag = read_cosim_data(&para);

  for (i = 0; i < num_input; i++) {
	x[i] = para.cosim->ffd->input[i];
  }

  evaluate();
  for (i = 0; i < num_output; i++) {
	para.cosim->ffd->output[i] = fa[i] * (outp_Boundary_upper[i] - outp_Boundary_lower[i]) + outp_Boundary_lower[i];
  }
  flag = write_cosim_data(&para);
	
  next = 1;
  while (next == 1) {
	/*.......................................................................
	| Check if Modelica asks to stop the simulation
	.......................................................................*/
	if (para.cosim->para->flag == 0) {
		/* Stop the solver*/
		next = 0;
	}
	else {
		flag = read_cosim_data(&para);
		if (flag > 0) {
			next = 0;
			sprintf(logMsg, "cosim_loop(): Received stop command: cosim->para->flag = %d", para.cosim->para->flag);
			cosim_log(logMsg, COSIM_NORMAL);
		}
		else {
			for (i = 0; i < num_input; i++) {
				x[i] = para.cosim->ffd->input[i];
			}
		  evaluate();
		}
	
	}
	for (i = 0; i < num_output; i++) {
		para.cosim->ffd->output[i] = fa[i] * (outp_Boundary_upper[i] - outp_Boundary_lower[i]) + outp_Boundary_lower[i];
	}


	if (para.cosim->para->flag == 0) {
		/* Stop the solver*/
		next = 0;
	}
	else {
		flag = write_cosim_data(&para);
	}
  }
}
