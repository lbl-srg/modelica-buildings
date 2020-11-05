/****************************************************************************
|
|  \file   data_structure.h
|
|  \brief  Define the data used the FFD
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
|          Xu Han
|          University of Colorado Boulder
|          xuha3556@colorado.edu
|
|  \date   4/5/2020
|
|  This file provides functions that write the data file in different formats.
|
****************************************************************************/
#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#endif
#ifdef _MSC_VER
	#include <windows.h>
#elif defined __GNUC__
	#ifdef _WIN64
		#include <windows.h>
	#elif _WIN32
		#include <windows.h>
	#elif __APPLE__
		#include <unistd.h>
	#elif __linux__
		#include <unistd.h>
	#else
		#include <unistd.h>
	#endif
#else
	#include <unistd.h>
#endif

#include <stdio.h>
#include <time.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>

#ifndef REAL
#define REAL float
#define ifDouble 1/*index to show it is double*/
#endif

#ifndef _MODELICA_FFD_COMMON_H
#define _MODELICA_FFD_COMMON_H
#include "modelica_ffd_common.h"
#endif

/*-----------------------------------------------------------------------------
Problem with windows version
The stdlib.h which ships with the recent versions of Visual Studio has a
different (and conflicting) definition of the exit() function.
It clashes with the definition in glut.h.
Solution:
Override the definition in glut.h with that in stdlib.h.
Place the stdlib.h line above the glut.h line in the code.
-----------------------------------------------------------------------------*/

#define IX(i,j,k) ((i)+(IMAX)*(j)+(IJMAX)*(k))
#define FOR_EACH_CELL for(i=1; i<=imax; i++) { for(j=1; j<=jmax; j++) { for(k=1; k<=kmax; k++) {
#define FOR_ALL_CELL for(k=0; k<=kmax+1; k++) { for(j=0; j<=jmax+1; j++) { for(i=0; i<=imax+1; i++) {
#define FOR_ALL_CELL_IJK for(i=0; i<=imax+1; i++) { for(j=0; j<=jmax+1; j++) { for(k=0; k<=kmax+1; k++) {
#define FOR_U_CELL for(k=1; k<=kmax; k++) { for(j=1; j<=jmax; j++) { for(i=1; i<=imax-1; i++) {
#define FOR_V_CELL for(i=1; i<=imax; i++) { for(j=1; j<=jmax-1; j++) { for(k=1; k<=kmax; k++) {
#define FOR_W_CELL for(i=1; i<=imax; i++) { for(j=1; j<=jmax; j++) { for(k=1; k<=kmax-1; k++) {

#define FOR_KI for(i=1; i<=imax; i++) { for(k=1; k<=kmax; k++) {{
#define FOR_IJ for(i=1; i<=imax; i++) { for(j=1; j<=jmax; j++) {{
#define FOR_JK for(j=1; j<=jmax; j++) { for(k=1; k<=kmax; k++) {{
#define END_FOR }}}

#define SMALL 0.00001
#define SUCCESS 0
#define FAILURE 1
#define MAX_SOURCE_SIZE (0x100000)

#ifndef max
	#define max( a, b ) ( ((a) > (b)) ? (a) : (b) )
#endif

#ifndef sign
#define sign(x) ( (x > 0) - (x < 0) )
#endif

#define PI 3.1415926

#define RACK_MONITOR_POINTS 4

#define X     0
#define Y     1
#define Z     2
#define VX    3
#define VY    4
#define VZ    5
#define VXM   6
#define VYM   7
#define VZM   8
#define VXS   9
#define VYS   10
#define VZS   11
#define IP    12
#define QFLUXBC 13 /* Heat flux on the boundary*/
#define QFLUX 14  /* Heat flux*/
#define TMP1  15
#define TMP2  16
#define TMP3  17
#define TEMP  18
#define TEMPS 19
#define TEMPM 20
#define AP    21
#define AN    22
#define AS    23
#define AW    24
#define AE    25
#define AF    26
#define AB    27
#define  B    28
#define GX    29
#define GY    30
#define GZ    31
#define AP0   32
#define PP    33
#define FLAGP 34
#define FLAGU 35
#define FLAGV 36
#define FLAGW 37
#define LOCMIN 38
#define LOCMAX 39
#define VXBC 40
#define VYBC 41
#define VZBC 42
#define TEMPBC 43
#define Xi1 44
#define Xi2 45
#define Xi1S 46
#define Xi2S 47
#define Xi1BC 48
#define Xi2BC 49
#define C1  50
#define C2  51
#define C1S 52
#define C2S 53
#define C1BC 54
#define TMP4 55
#define MIN_DISTANCE 56 /* the minimal distance to the boundaries, using in zero equation model */
#define TILE_OPEN_BC 57 /* the opening ratio of the tiles */
#define TILE_RESI_BC 58 /* the corresponding resistance ratio of the opening ratio for the tiles */
#define TILE_FLOW_BC 59 /* the velocity at each tile */
#define PBC 60 /* the pressure boundary condition for outlets/tiles */
#define IPS 61 /* the pressure source associated with the tile when simulating the room and plenum together */
#define APXS 62 /* Source for AP VX */
#define APYS 63 /* Source for AP VY */
#define APZS 64 /* Source for AP VZ */
#define RESX 65 /* Resistance in X, i.e., tile, plastic curtain, etc. */
#define RESY 66 /* Resistance source in Y, i.e., tile, plastic curtain, etc. */
#define RESZ 67 /* Resistance source in Z, i.e., tile, plastic curtain, etc. */
#define C2BC 68  /* Last variable */

typedef enum{NOSLIP, SLIP, INFLOW, OUTFLOW, PERIODIC, SYMMETRY} BCTYPE;

#define SOLID 1
#define INLET 0
#define OUTLET 2
#define TILE 3
#define RACK_INLET 4
#define RACK_OUTLET 5
#define FLUID -1

#define RACK 100

typedef enum{TCONST, QCONST, ADIBATIC} BCTTYPE;

typedef enum{GS, TDMA, JACOBI} SOLVERTYPE;

typedef enum{SEMI, LAX, UPWIND, UPWIND_NEW, CENTRAL} ADVECTION;

typedef enum{LAM, CHEN, CONSTANT} TUR_MODEL;

typedef enum{BILINEAR, FSJ, HYBRID} INTERPOLATION;

typedef enum{DEMO, DEBUG, RUN} VERSION;

typedef enum{FFD, SCI, TECPLOT} FILE_FORMAT;

typedef enum{FFD_WARNING, FFD_ERROR, FFD_NORMAL, FFD_NEW} FFD_MSG_TYPE;

typedef enum{XY, YZ, ZX} PLANETYPE;

typedef enum { ADV, DIF, PRO } FFD_TERM;

typedef enum { AIRFLOW_BASE, PRESSURE_BASE, HYBRID_BASE, NS_SOURCE, NO_EXIST } TILE_FLOW_CORRECTION;

typedef enum { PRESCRIBED_VALUE, ZERO_GRADIENT } BC_TYPE;

typedef enum { PLT, VTK, NO} RLT_FILE;

/* Parameter for geometry and mesh*/
typedef struct {
  REAL  Lx; /* Domain size in x-direction (meter)*/
  REAL  Ly; /* Domain size in y-direction (meter)*/
  REAL  Lz; /* Domain size in z-direction (meter)*/
  int   imax; /* Number of interior cells in x-direction*/
  int   jmax; /* Number of interior cells in y-direction*/
  int   kmax; /* Number of interior cells in z-direction*/
  int   index; /* Total number of boundary cells*/
  int   pindex; /* Index in plane*/
  PLANETYPE   plane; /* plane selection*/
  REAL  dx; /* Length delta_x of one cell in x-direction for uniform grid only*/
  REAL  dy; /* Length delta_y of one cell in y-direction for uniform grid only*/
  REAL  dz; /* Length delta_z of one cell in z-direction for uniform grid only*/
  REAL  volFlu; /* Total volume of fluid cells*/
  int   uniform; /* Only for generating grid by FFD. 1: uniform grid; 0: non-uniform grid*/
  int tile_putX; /* tile is put in X direction */
  int tile_putY; /* tile is put in Y direction */
  int tile_putZ; /* tile is put in Z direction */
} GEOM_DATA;

/* Parameter for the data output control*/
typedef struct{
  int cal_mean; /* 1: Calculate mean value; 0: False*/
  REAL v_max; /* Maximum velocity for visualizations (Reference)*/
  REAL v_ref; /* Reference velocity for visualization*/
  REAL Temp_ref; /* Reference temperature for visualizations*/
  REAL v_length; /* Change of velocity vector length in demo window*/
  REAL Tmax; /* Maximum temperature for visualizations (Reference)*/
  REAL Tmin; /* Minimum temperature for visualizations (Reference)*/
  int i_N; /* Number of grids plotted in x direction*/
  int j_N; /* Number of grids plotted in y direction*/
  int k_N; /* Number of grids plotted in z direction*/
  int winx; /* Resolution of screen at x direction in pixel*/
  int winy; /* Resolution of screen at y direction in pixel*/
  int winz; /* Resolution of screen at x direction in pixel*/
  int omx; /* Internal*/
  int omy; /* Internal*/
  int mx; /* Internal*/
  int my; /* Internal*/
  int win_id; /* Internal: Windows id*/
  int mouse_down[3]; /* Internal: Record for mouse action*/
  VERSION version; /* DEMO, DEBUG, RUN*/
  int screen; /* Screen for display: 1 velocity; 2: temperature; 3: contaminant*/
  int tstep_display; /* Number of time steps to update the visualization*/
  int mouse_i; /* mouse click located i */
  int mouse_j; /*mouse click located j*/
  int mouse_k; /* mouse click located k */
  RLT_FILE result_file; /* result file type */
  int OutputDynamicFile; /*determine if wants to output the files for animation*/
} OUTP_DATA;

typedef struct {
	int cal_mean; /*1: Calculate mean value; 0: False*/
	VERSION version; /* DEMO, DEBUG, RUN*/
} OUTP_DATA_SIMP;

typedef struct{
  FILE_FORMAT parameter_file_format; /* Format of extra parameter file*/
  char parameter_file_name[1024]; /* Name of extra parameter file*/
  char block_file_name[1024]; /* Name of file stores block information*/
  int read_old_ffd_file; /* 1: Read previous FFD file; 0: False*/
  char old_ffd_file_name[100]; /* Name of previous FFD simulation data file*/
	char *parameter_file_path; /* Path of parameter file */
} INPU_DATA;

typedef struct{
  REAL  nu; /* Kinematic viscosity*/
  REAL  rho; /* Density*/
  REAL  diff; /* Diffusivity for contaminants*/
  REAL  alpha; /* Thermal diffusivity*/
  REAL  coeff_h; /* Convective heat transfer coefficient near the wall*/
  REAL  gravx; /* Gravity in x direction*/
  REAL  gravy; /* Gravity in y direction*/
  REAL  gravz; /* Gravity in z direction*/
  REAL  beta; /* Thermal expansion coefficient*/
  REAL cond; /* Conductivity*/
  REAL Cp; /* Specific heat capacity*/
  REAL force; /* Force to be added in demo window for velocity when left-click on mouse*/
  REAL heat; /* Heat to be added in demo window for contaminants when click middle button on mouse*/
  REAL source; /* Source to be added in demo window for contaminants when right click on mouse*/
  int movie; /* Output data for making animation (1:yes, 0:no)*/
  int output;   /* Internal: 0: have not been written; 1: done*/
  TUR_MODEL tur_model; /* LAM, CHEN, CONSTANT*/
  REAL chen_a; /* Coefficient of Chen's zero equation turbulence model*/
  REAL Prt; /* Turbulent Prandtl number*/
  REAL Temp_Buoyancy; /* Reference temperature for calculating buoyancy force*/
  REAL Tem_Ave_LastTime; /* Record average fluid temeprature in last time */
  REAL Energy_Imb_Adv; /* Energy imbalance after advection, W */
  REAL coef_CONSTANT; /* Constant for constant turbulence models */
  REAL coef_stanchion; /* the stanchion model coefficient */
}PROB_DATA;

typedef struct {
  int nb_inlet; /* Number of inlet boundaries, provided by SCI*/
  int nb_outlet; /* Number of outlet boundaries, provided by SCI*/
  int nb_block; /* Number of internal block boundaries, provided by SCI*/
  int nb_wall; /* Number of wall boundaries, provided by SCI*/
  int nb_source; /* Number of sources, provided by SCI*/
  int nb_bc; /* Number of boundaries, provided by SCI*/
  int nb_ConExtWin; /* Number of exterior construction with windows*/
  int nb_port; /* nPort = nInlet + nOutlet*/
  int nb_Xi; /* Number of species*/
  int nb_C; /* Number of substances*/
  int sha; /* 1: have shade ; 0: no shade*/
  char **wallName; /* *wallName[nb_wall]: Name of solid boundary (Wall, Window)*/
  char **inletName; /* *inletName[nb_inlet]: Name of inlet boundary*/
  char **outletName; /* *inletName[nb_outlet]: Name of outlet boundary*/
  char **portName; /* *portName[nb_port]: Name of ports*/
  char **blockName; /* *blockName[nb_block]: Name of internal block*/
  char **sourceName; /* *sourceName[nb_source]: Name of the source*/
  char** rackName; /* *rackNmae[nb_rack]: name of rack */
  int *wallId; /* wallId[nb_wall]: Modelica wall boundary ID*/
  int *portId; /* portId[nb_port]: Modelica outlet boundary ID*/
  REAL *AWall; /* AWall[nb_wall]: Area of the surfaces*/
  REAL *APort; /* APort[nb_port]: Area of the outlets*/
  REAL *temHea; /* temHea[nb_wall]: Value of thermal conditions at solid surface*/
  REAL *temHeaAve; /* temHeaAve[nb_wall]: Surface averaged value of temHea*/
  REAL *temHeaMean; /* temHeaMean[nb_wall]: Time averaged value of temHeaAve*/
  REAL *velPort; /* velPort[nb_port]: Velocity of air into the room*/
                      /* positive: into the room; negative out of the room*/
  REAL* QPort; /* mass flowrate of the port */
  REAL *velPortAve; /* velPortAve[nb_port]: Surface averaged value of velPort*/
  REAL *velPortMean; /* velPortMean[nb_port]: Time averaged value of velPortAve*/
  REAL *TPort; /* TPort[nb_port] Air temperatures that the medium has if it were flowing into the room*/
  REAL *TPortAve; /* TPortAve[nb_port] Surface averaged value of TPort*/
  REAL *TPortMean; /* TPortMean[nb_port] Time averaged value of TPortAve*/
  REAL **XiPort; /* XiPor[nb_port][nb_Xi]: species concentration of inflowing medium*/
  REAL **XiPortAve; /* XiPortAve[nb_port][nb_Xi]: Surface averaged value of XiPort*/
  REAL **XiPortMean; /* XiPortAve[nb_port][nb_Xi]: Time averaged value of XiPortAve*/
  REAL **CPort; /* CPor[nb_port][nb_C]: the trace substances of the inflowing medium*/
  REAL **CPortAve; /* CPortAve[nb_port][nb_C]: Surface averaged value of CPort*/
  REAL **CPortMean; /* CPortMean[nb_port][nb_C]: Time averaged value of CPort*/
  int nb_rack; /* number of rack in the data center room */
  int** RackMap; /* Map the inlet and outlet cell of rack, a N by 3 array, where N is number of racks */
  REAL* RackFlowRate; /* The volumetric flow rate for each rack in M3/s, a vector of N elements */
  int* RackDir; /* The cooling air flow direction of the rack, +1: X, -1: Y, +2: Y, -2: -Y, +3: Z, -3: -Z */
  REAL* HeatDiss; /* Heat dissipation of rack in W, a vector of N element */
  REAL* RackArea; /* Inlet or outlet area of rack, a vector of N element */
  BC_TYPE outlet_bc; /* type of outlet bc */
  int hasTile; /* 1: Has tile, 0: no tile */
}BC_DATA;

typedef struct {
  int nb_inlet; /* Number of inlet boundaries, provided by SCI */
  int nb_outlet; /* Number of outlet boundaries, provided by SCI */
  int nb_block; /* Number of internal block boundaries, provided by SCI */
  int nb_wall; /* Number of wall boundaries, provided by SCI */
  int nb_source; /* Number of sources, provided by SCI */
  int nb_bc; /* Number of boundaries, provided by SCI */
  int nb_ConExtWin; /* Number of exterior construction with windows */
  int nb_port; /* nPort = nInlet + nOutlet */
  int nb_Xi; /* Number of species */
  int nb_C; /* Number of substances */
  int sha; /* 1: have shade ; 0: no shade */
  REAL mass_in;
  REAL mass_out;
  REAL mass_corr;
  BC_TYPE outlet_bc; /* type of outlet bc */
}BC_DATA_SIMP;

typedef struct {
  int nb_sensor; /* Number of sensors*/
  char **sensorName; /* *sensorName[nb_sensor]: Name of sensor in FFD*/
  int **senIndex; /* senIndex[nb_sensor][3]: i, j, k Index of sensors*/
  REAL *senVal; /* senVal[nb_sensor]: Instantiate value of sensor point*/
  REAL *senValMean; /* snValMean[nb_sensor]: Time averaged value of senVal;*/
  REAL TRoo; /* Volumed averaged value of temperature in the space*/
  REAL TRooMean; /* Time averaged value of TRoo;*/
  REAL*** coordMoniPoints; /*coordMoniPoints[A][B][C]-> A: which rack; B: which monitor point; C: which coordinate*/
  int*** indexMoniPoints; /* indexMoniPoints[A][B][C]-> A: which rack; B: which monitor point; C: which coordinate*/
} SENSOR_DATA;

typedef struct {
  int nb_sensor; /* Number of sensors */
  REAL TRoo; /* Volumed averaged value of temperature in the space */
  REAL TRooMean; /* Time averaged value of TRoo; */
} SENSOR_DATA_SIMP;

typedef struct {
  double dt; /* FFD simulation time step size*/
  double t; /* Internal: current time*/
  REAL t_steady; /* Necessary time for reaching the steady state from initial condition*/
  int step_total; /* The interval of iteration step to output data*/
  int step_current; /* Internal: current iteration step*/
  int step_mean; /* Internal: steps for time average*/
  double t_start; /* Internal: clock time when simulation starts*/
  double t_end; /* Internal: clock time when simulation ends*/
}TIME_DATA;

typedef struct {
  REAL dt; /* FFD simulation time step size */
  REAL t; /* Internal: current time */
  REAL t_steady; /* Necessary time for reaching the steady state from initial condition */
  int step_total; /* The interval of iteration step to output data */
  int step_current; /* Internal: current iteration step */
  int step_mean; /* Internal: steps for time average */
  REAL t_start; /* Internal: clock time when simulation starts */
  REAL t_end; /* Internal: clock time when simulation ends */
}GPU_TIME_DATA;

typedef struct {
  SOLVERTYPE solver;  /* Solver type: GS, TDMA*/
  int check_residual; /* 1: check, 0: do not check*/
  int check_conservation; /*1: check, 0 : do not check residual after iterative solver*/
  ADVECTION advection_solver; /* Type of advection solver: SEMI, LAX, UPWIND, UPWIND_NEW*/
  INTERPOLATION interpolation; /* Interpolation in semi-Lagrangian method: BILINEAR, FSJ, HYBRID*/
  int cosimulation;  /* 0: single; 1: coupled simulation*/
  int nextstep; /* Internal: 1: yes; 0: no, wait*/
  int swipe_adv; /* swipe numbers in GS for advection, if using implicit scheme */
  int swipe_dif; /* swipe numbers in GS for diffusion */
  int swipe_pro; /* swipe numbers in GS for projection */
  TILE_FLOW_CORRECTION tile_flow_correct; /* how to correct the flow rates at tiles */
  int mass_conservation_on; /* apply forced mass conservation or not */
}SOLV_DATA;

typedef struct {
  REAL T; /* Initial temperature*/
  REAL u; /* Initial velocity for u*/
  REAL v; /* Initial velocity for v*/
  REAL w; /* Initial velocity for w*/
}INIT_DATA;

typedef struct {
  GEOM_DATA  *geom;
  INPU_DATA  *inpu;
  OUTP_DATA  *outp;
  PROB_DATA  *prob;
  TIME_DATA  *mytime;
  BC_DATA    *bc;
  SOLV_DATA  *solv;
  CosimulationData *cosim;
  SENSOR_DATA *sens;
  INIT_DATA *init;
}PARA_DATA;

typedef struct {
  GEOM_DATA  geom;
  OUTP_DATA_SIMP  outp_simp;
  PROB_DATA  prob;
  GPU_TIME_DATA  mytime;
  BC_DATA_SIMP  bc_simp;
  SOLV_DATA  solv;
  SENSOR_DATA_SIMP sens_simp;
  INIT_DATA init;
}PARA_DATA_SIMP;

typedef struct {
  double number0;
  double number1;
  int command;
} ReceivedData;

typedef struct {
  int feedback;
} SentCommand;

typedef struct {
  double number0;
  double number1;
  int command;
}SentData;

typedef struct {
  int feedback;
}ReceivedCommand;

char msg[1000];
