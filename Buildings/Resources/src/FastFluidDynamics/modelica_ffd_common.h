///////////////////////////////////////////////////////////////////////////////
///
/// \file   modelica_ffd_common.h
///
/// \brief  Define commonly used data for Modelica-FFD cosimulation
///
/// \author Wangda Zuo
///         University of Miami
///         W.Zuo@miami.edu
///
/// \date   8/3/2013
///
///////////////////////////////////////////////////////////////////////////////

typedef struct {
  int flag; // Flag for cosimulation: 0-> Stop; 1->Continue
  int ffdError; // 1: FFD exits with an error
  int nSur; // Number of surfaces
  int nSen; // Numver of sensors
  int nConExtWin; // Nmber of exterior construction with windows
  int nPorts; // Number of fluid ports
  int nXi; // Number of species
  int nC; // Number of trace substances 
  int sha; // 1: have shade ; 0: no shade 
  char *fileName; // Name of FFD input file
  char **name; // *name[nSur]: Name of surfaces and flow ports
  char **portName; // *name[nPorts]: Name of fluid ports
  float *are; // area of surface in the same order of name
  float *til; // tilt of surface in the same order of name
  int *bouCon; // Type of thermal bundary condition in the same order of name 
                 // 1: fixed temperature, 
                 // 2: fixed heat flow rate through the surface
  char **sensorName; // *sensorName[nSen]: Name of sensor in FFD
} ParameterSharedData;

typedef struct {
  float t; // Current time of integration
  int flag; // To control the data exhcange. 0: old data, 1: new data; -1: Stop cosimulation
  float dt; // Time step size for next synchronization
  float *temHea; // temHea[nSur]: Temperature or heat flow rate depending on surBou.bouCon
  float heaConvec; // Convective heat input into the room
  float latentHeat; // Latent heat input into the room
  float *shaConSig; // shaConSig[nConExtWin]. 
                    // 0: shade not deployed; 1: shade completely deployed
                    // Fixme: how to know if it has shade?
  float *shaAbsRad; // shaAbsRad[nConExtWin]: Radiation absorbed by shades
  float p; // Room average static pressure
  float *mFloRatPor; // mFloRatPor[nPorts]: Mass flow rates into the room
                      // positive: into the room; neative out of the room
  float *TPor; // TPor[nPorts] Air temperatures that the medium has if it were flowing into the room
              // Fixme: Will the element exist if not flowing into the room? 
              // Fixme: what will it be if not flowing into the room?
  float **XiPor; // XiPor[nPorts][Medium.nXi]: species concentration of inflowing medium at the port
             // First Medium.nXi elements are for port 1
  float **CPor; // CPor[nPorts][Medium.nC]: the trace substances of the inflowing medium
}ModelicaSharedData;

typedef struct {
  float t; // Current time of integration
  int flag; // To control the data exhcange. 0: old data, 1: new data
  float *temHea; // temHea[nSur]: Temperature or heat flow rate depending on surBou.bouCon
                 // 1: Return heat flow; 2: Return temperature
  float TRoo; // Averaged room air temperature
  float *TSha; // TSha[nConExtWin]: temperature fo the shade if there is a shade
  float *TPor; // TPor[nPorts] Air temperatures that the medium has at the prot
  float **XiPor; // XiPor[nPorts][Medium.nXi]: species concentration of medium at the port
             // First Medium.nXi elements are for port 1
  float **CPor; // CPor[nPorts][medium.nC]: the trace substances of medium at the port
}ffdSharedData;

typedef struct{
  ParameterSharedData *para;
  ffdSharedData *ffd;
  ModelicaSharedData *modelica;
} CosimulationData;
