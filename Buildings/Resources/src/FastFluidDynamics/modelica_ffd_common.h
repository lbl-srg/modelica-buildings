/*
	*
	* @file   modelica_ffd_common.h
	*
	* @brief  Define commonly used data for Modelica-FFD coupled simulation
	*
	* @author Wangda Zuo
	*         University of Miami
	*         W.Zuo@miami.edu
	*
	* @date   8/3/2013
	*
	*/
#define REAL double
typedef struct {
  volatile int flag; /* Flag for coupled simulation: 0-> Stop; 1->Continue*/
  int ffdError; /* 0: FFD had no error;*/
  int nSur; /* Number of surfaces*/
  int nSen; /* Number of sensors*/
  int nConExtWin; /* Number of exterior construction with windows*/
  int nPorts; /* Number of fluid ports*/
  int nXi; /* Number of species*/
  int nC; /* Number of trace substances*/
  int sha; /* 1: have shade ; 0: no shade*/
  REAL rho_start; /* Density at initial state*/
  char *fileName; /* Name of FFD input file*/
  char *filePath; /* Path of FFD input file*/
  char **name; /* *name[nSur]: Name of surfaces and flow ports*/
  char **portName; /* *name[nPorts]: Name of fluid ports*/
  REAL *are; /* area of surface in the same order of name*/
  REAL *til; /* tilt of surface in the same order of name*/
  int *bouCon; /* Type of thermal boundary condition in the same order of name*/
                 /* 1: fixed temperature,*/
                 /* 2: fixed heat flow rate through the surface*/
  char **sensorName; /* *sensorName[nSen]: Name of sensor in FFD*/
  char *version; /* DEMO, DEBUG, RUN */
  int Sou; /* 1: have internal source ; 0: no internal source*/
  int nSou; /* Number of internal sources*/
  char **souName; /* *souName[nSou]: Name of internal heat sources*/
} ParameterSharedData;

typedef struct {
  REAL t; /* Current time of integration*/
	REAL lt; /* Last time of integration*/
  volatile int flag; /* To control the data exchange. 0: old data, 1: new data; -1: Stop coupled simulation*/
  REAL dt; /* Time step size for next synchronization*/
  REAL *temHea; /* temHea[nSur]: Temperature or heat flow rate depending on surBou.bouCon*/
  REAL sensibleHeat; /* Convective sensible heat input into the room*/
  REAL latentHeat; /* Latent heat input into the room*/
  REAL *shaConSig; /* shaConSig[nConExtWin], valid only when there is a shade*/
                    /* 0: shade not deployed; 1: shade completely deployed*/
  REAL *shaAbsRad; /* shaAbsRad[nConExtWin]: Radiation absorbed by shades*/
  REAL p; /* Room average static pressure*/
  REAL *mFloRatPor; /* mFloRatPor[nPorts]: Mass flow rates into the room*/
                      /* positive: into the room; negative out of the room*/
  REAL *TPor; /* TPor[nPorts] Air temperatures of the medium*/
               /* flowing through the inlet and outlet*/
  REAL **XiPor; /* XiPor[nPorts][Medium.nXi]: species concentration of inflowing medium at the port*/
             /* First Medium.nXi elements are for port 1*/
  REAL **CPor; /* CPor[nPorts][Medium.nC]: the trace substances of the inflowing medium*/
  REAL *sourceHeat; /* sourceHeat[nSou]: the internal source heat gain*/
}ModelicaSharedData;

typedef struct {
  REAL t; /* Current time of integration*/
  volatile int flag; /* To control the data exchange. 0: old data, 1: new data*/
  REAL *temHea; /* temHea[nSur]: Temperature or heat flow rate depending on surBou.bouCon*/
                 /* 1: Return heat flow; 2: Return temperature*/
  REAL TRoo; /* Averaged room air temperature*/
  REAL *TSha; /* TSha[nConExtWin]: temperature for the shade if there is a shade*/
  REAL *TPor; /* TPor[nPorts] Air temperatures that the medium has at the port*/
  REAL **XiPor; /* XiPor[nPorts][Medium.nXi]: species concentration of medium at the port*/
             /* First Medium.nXi elements are for port 1*/
  REAL **CPor; /* CPor[nPorts][medium.nC]: the trace substances of medium at the port*/
  REAL *senVal; /* senVal[nSen]: value of sensor data*/
  char *msg; /* Message to be passed to Modelica*/
  REAL *input;
  REAL *output;
  int nInput;
  int nOutput;
  REAL *wOutput; /* Weights for error control, this is need since each component of output vector has different order of magnitudes*/
}ffdSharedData;

typedef struct{
  ParameterSharedData *para;
  ffdSharedData *ffd;
  ModelicaSharedData *modelica;
  int started; /* 1 if cosimulation has been started, 0 otherwise */
} CosimulationData;

/* FFD_ISAT must NOT be defined here.
 *
 * This header is shared between two different builds:
 *   1. The plain FFD library (Resources/src/FastFluidDynamics/makefile),
 *      which builds libffd.so/ffd.dll and is used for FFD-Modelica
 *      co-simulation (e.g. Buildings.ThermalZones.Detailed.Examples.FFD).
 *   2. The ISAT library (Resources/src/ISAT/Linux/makefile), which
 *      temporarily copies its own modelica_ffd_common.h (which DOES
 *      define FFD_ISAT) over this file before compiling, and restores
 *      this file afterwards.
 *
 * When FFD_ISAT is defined here, parameter_reader.c and sci_reader.c
 * reference the extern globals "filepath" and "ffdInput", and ffd.c
 * calls write_output_data(), all of which are only implemented in the
 * ISAT-specific sources (Resources/src/ISAT/utility_isat.c and
 * Resources/src/ISAT/ffd_wrap.c). These are not part of the plain FFD
 * source list, so linking libffd.so fails with:
 *   undefined reference to `write_output_data'
 *   undefined reference to `ffdInput'
 *   undefined reference to `filepath'
 * Keep this macro undefined so the plain FFD build compiles and links
 * correctly. The ISAT build defines FFD_ISAT via its own copy of this
 * header (see the "all" target in Resources/src/ISAT/Linux/makefile).
 */
/* #define FFD_ISAT */

#ifdef FFD_ISAT
typedef enum { COSIM_WARNING, COSIM_ERROR, COSIM_NORMAL, COSIM_NEW } COSIM_MSG_TYPE;
typedef enum { temp_roo, temp_occ, vel_occ, temp_sen, vel_sen, temp_rack, heat_wall1, heat_wall2, heat_wall3, heat_wall4, heat_wall5, heat_wall6} OUTPUT_TYPE;
typedef enum { inlet_temp, inlet_mass, inlet_vel, block_temp, block_hea, rack_hea, sur_temp, sur_hea } INPUT_TYPE;
#endif

