/*
 * Modelica external function to intialize EnergyPlus.
 *
 * Michael Wetter, LBNL                  3/1/2018
 * Thierry S. Nouidui, LBNL                  3/23/2018
 */

#include "FMUEnergyPlusStructure.h"
#include <stdlib.h>

static void* getAdr(FMU *fmu, const char* functionName){
	void* fp;
        char msg[200];

#ifdef _MSC_VER
	fp = GetProcAddress(fmu->dllHandle, functionName);
#else
	fp = dlsym(fmu->dllHandle, functionName);
#endif
	if (!fp) {
                snprintf(msg, 200, "****** Function %s,  not "
                "found in the EnergyPlus functions library****** \n", 
                functionName);
		ModelicaError (msg);
	}
	return fp;
}

static int loadLib(const char* libPath, FMU *fmu) {
        char msg[200];
#ifdef _MSC_VER
	HINSTANCE h;
#else
	void *h;
#endif


#ifdef _MSC_VER
	h = LoadLibrary(libPath);
	if (h == NULL) {
		snprintf(msg, 200, "****** Unable to load the EnergyPlus "
                "functions library with path %s ****** \n", 
                libPath);
		ModelicaError(msg);
		return -1;
	}
	if (!h) {
		snprintf(msg, 200, "****** Unable to load the "
                "EnergyPlus functions library with path %s ****** \n", 
                libPath);
		ModelicaError(msg);
		return -1;
	}
#else
	h = dlopen(libPath, RTLD_LAZY);
	if (h == NULL) {
		snprintf(msg, 200, "****** Unable to load the "
                "EnergyPlus functions library with path %s ****** \n", 
                libPath);
		ModelicaError(msg);
		return -1;
               
	}
	if (!h) {
		snprintf(msg, 200, "****** Unable to load the "
                "EnergyPlus functions library with path %s ****** \n", 
                libPath);
		ModelicaError(msg);
		return -1;
	}
#endif

	fmu->dllHandle = h;

	fmu->instantiate = (fInstantiate)getAdr(fmu, "instantiate");
	if (!(fmu->instantiate)) {
		ModelicaError("Can't find function instantiate()\n");
		return -1;
	}

	fmu->setupExperiment = (fSetupExperiment)getAdr(fmu, "setupExperiment");
	if (!(fmu->setupExperiment)) {
                ModelicaError("Can't find function setupExperiment()\n");
		return -1;
	}

	fmu->setTime = (fSetTime)getAdr(fmu, "setTime");
	if (!(fmu->setTime)) {
                ModelicaMessage("Can't find function setTime()\n");
		return -1;
	}

	fmu->setVariables = (fSetVariables) getAdr(fmu, "setVariables");
	if (!(fmu->setVariables)) {
		ModelicaError("Can't find function setVariables()\n");
		return -1;
	}
	fmu->getVariables = (fGetVariables)getAdr(fmu, "getVariables");
	if (!(fmu->getVariables)) {
		ModelicaError("Can't find function getVariables()\n");
		return -1;
	}

	fmu->getNextEventTime = (fGetNextEventTime)getAdr(fmu, "getNextEventTime");
	if (!(fmu->getNextEventTime)) {
		ModelicaError("Can't find function getNextEventTime()\n");
		return -1;
	}

	fmu->terminate = (fTerminate)getAdr(fmu, "terminate");
	if (!(fmu->terminate)) {
		ModelicaError("Can't find function terminate()\n");
		return -1;
	}
	return 0; //success

}

void FMUZoneInitialize(void* object, double* AFlo, double* V, double* mSenFac){
  char msg[200]; 
  FMUZone* zone = (FMUZone*) object; 
  FMU* fmu;
  fmu = malloc(sizeof(FMU*));
  zone->ptrBui->fmu = fmu;
  int retVal;

  const char * inputNames[] = {"Attic,T", "Core_ZN,T", "Perimeter_ZN_1,T", 
				"Perimeter_ZN_2,T", "Perimeter_ZN_3,T", "Perimeter_ZN_4,T"};

  const unsigned int inputValueReferences[] = {0, 1, 2, 3, 4, 5,};
  const char * outputNames[] = {"Attic,QConSen_flow", "Core_ZN,QConSen_flow", 
                                 "Perimeter_ZN_1,QConSen_flow", "Perimeter_ZN_2,QConSen_flow", 
				"Perimeter_ZN_3,QConSen_flow", "Perimeter_ZN_4,QConSen_flow"};
   
  const unsigned int outputValueReferences[] = {6, 7, 8, 9, 10, 11};
  const char* input ="eplusfmi/RefBldgSmallOfficeNew2004_Chicago.idf";
  const char* weather ="eplusfmi/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw";
  const char* idd ="eplusfmi/Energy+.idd";

   
  /* Loading EnergyPlus library */
  const char* eplib = "eplusfmi/libepfmi.so";
  retVal = loadLib(eplib, zone->ptrBui->fmu);

  if (retVal  < 0) {
     snprintf(msg, 200, "There was an error loading the EnergyPlus library\n");
     ModelicaMessage(msg);
    }

  snprintf(msg, 200, "The number of zones of the building is %d\n.", zone->ptrBui->nZon);
  ModelicaMessage(msg);

  snprintf(msg, 200, "The name of the building is %s\n.", zone->ptrBui->name);
  ModelicaMessage(msg);
 
  snprintf(msg, 200, "Ready to instantiate the E+ FMU\n");
  ModelicaMessage(msg);

  int result = zone->ptrBui->fmu->instantiate(input, // input
                           weather, // weather
                           idd, // idd
                           "Alpha", // instanceName
                           NULL, // parameterNames
                           NULL, // parameterValueReferences[]
                           0, // nPar
                           inputNames, // inputNames
                           inputValueReferences, // inputValueReferences[]
                           6, // nInp
                           outputNames, // outputNames
                           outputValueReferences, // outputValueReferences[]
                           6, // nOut
                           NULL); //log);

  double tStart = 0.0;
  int stopTimeDefined = 1;
  double tEnd = 86400;

  result = zone->ptrBui->fmu->setupExperiment(tStart, 1, NULL);
  double time = tStart;

  double outputs[] = {0.0, 0.0};
  const unsigned int outputRefs[] = {6, 7};

  double inputs[] = {21.0, 21.0};
  const unsigned int inputRefs[] = {0, 1};

  result = zone->ptrBui->fmu->setVariables(inputRefs, inputs, 2, NULL);
  result = zone->ptrBui->fmu->getVariables(outputRefs, outputs, 2, NULL); 

  snprintf(msg, 200, "The output of value is is %f\n.", outputs[0]);
  ModelicaMessage(msg);
  snprintf(msg, 200, "The output of value is is %f\n.", outputs[1]);
  ModelicaMessage(msg);

/* Obtain the floor area and the volume of the zone */
  *AFlo = 30;
  *V = 2.7*30;
  *mSenFac = 1;
/*  snprintf(msg, 200,
    "*** In exchange for bldg: %s; zone: %s, n = %d, pointer to fmu %p.\n",
    zone->ptrBui->name,
    zone->name,
    zone->nValueReference,
    zone->ptrBui);
  ModelicaMessage(msg);
*/
  return;
}
