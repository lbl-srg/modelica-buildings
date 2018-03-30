/*
 * Modelica external function to intialize EnergyPlus.
 *
 * Michael Wetter, LBNL                  3/1/2018
 * Thierry S. Nouidui, LBNL              3/23/2018
 */

#include "FMUEnergyPlusStructure.h"
#include <stdlib.h>

static void* getAdr(FMU *fmu, const char* functionName){
	void* fp;
        char* msg;
	msg = (char*) malloc((strlen(functionName)+150)*sizeof(char));
#ifdef _MSC_VER
	fp = GetProcAddress(fmu->dllHandle, functionName);
#else
	fp = dlsym(fmu->dllHandle, functionName);
#endif
	if (!fp) {
                sprintf(msg, "****** Function %s,  not "
                "found in the EnergyPlus functions library****** \n",
                functionName);
		ModelicaError (msg);
	}
        free (msg);
	return fp;
}

static int loadLib(const char* libPath, FMU *fmu) {
        char* msg;
        msg = (char*) malloc((strlen(libPath)+150)*sizeof(char));
#ifdef _MSC_VER
	HINSTANCE h;
#else
	void *h;
#endif


#ifdef _MSC_VER
	h = LoadLibrary(libPath);
	if (h == NULL) {
		sprintf(msg, "****** Unable to load the EnergyPlus "
                "functions library with path %s ****** \n",
                libPath);
		ModelicaError(msg);
	}
	if (!h) {
		sprintf(msg, "****** Unable to load the "
                "EnergyPlus functions library with path %s ****** \n",
                libPath);
		ModelicaError(msg);
	}
#else
	h = dlopen(libPath, RTLD_LAZY);
	if (h == NULL) {
		sprintf(msg, "****** Unable to load the "
                "EnergyPlus functions library with path %s ****** \n",
                libPath);
		ModelicaError(msg);

	}
	if (!h) {
		sprintf(msg, "****** Unable to load the "
                "EnergyPlus functions library with path %s ****** \n",
                libPath);
		ModelicaError(msg);
	}
#endif

	fmu->dllHandle = h;

	fmu->instantiate = (fInstantiate)getAdr(fmu, "instantiate");
	if (!(fmu->instantiate)) {
		ModelicaError("Can't find function instantiate().\n");
	}

	fmu->setupExperiment = (fSetupExperiment)getAdr(fmu, "setupExperiment");
	if (!(fmu->setupExperiment)) {
                ModelicaError("Can't find function setupExperiment().\n");
	}

	fmu->setTime = (fSetTime)getAdr(fmu, "setTime");
	if (!(fmu->setTime)) {
                ModelicaMessage("Can't find function setTime().\n");
	}

	fmu->setVariables = (fSetVariables) getAdr(fmu, "setVariables");
	if (!(fmu->setVariables)) {
		ModelicaError("Can't find function setVariables().\n");
	}
	fmu->getVariables = (fGetVariables)getAdr(fmu, "getVariables");
	if (!(fmu->getVariables)) {
		ModelicaError("Can't find function getVariables().\n");
	}

	fmu->getNextEventTime = (fGetNextEventTime)getAdr(fmu, "getNextEventTime");
	if (!(fmu->getNextEventTime)) {
		ModelicaError("Can't find function getNextEventTime().\n");
	}

	fmu->terminate = (fTerminate)getAdr(fmu, "terminate");
	if (!(fmu->terminate)) {
		ModelicaError("Can't find function terminate().\n");
	}
        free (msg);
	return 0; //success

}

void FMUZoneInitialize(void* object, double* AFlo, double* V, double* mSenFac){
  fmi2Byte msg[200];
  FMUZone* zone = (FMUZone*) object;
  FMU* fmu;
	int cntr=0;
	int retVal;
	int i, j, k ;

  int nZon=zone->ptrBui->nZon;
	//fmi2ValueReference* inputValueReferences=(fmi2ValueReference* )malloc(5*nZon*sizeof(fmi2ValueReference));
	//fmi2ValueReference* outputValueReferences=(fmi2ValueReference* )malloc(4*nZon*sizeof(fmi2ValueReference));
	int nInp = 5*nZon;
	int nOut = 4*nZon;
	char inputNames[nInp][20];
	char outputNames[nOut][20];
	fmi2ValueReference inputValueReferences [5*nZon];
	fmi2ValueReference outputValueReferences [4*nZon];

	const char* consInputNames[]={"T", "X", "mInlets_flow", "TInlet", "QGaiRad_flow"};
	const char* consOutputNames[]={"TRad", "QConSen_flow", "QLat_flow", "QPeo_flow"};

	fmu = (FMU*)malloc(sizeof(FMU));
	FMUZone** tmpZon;
	tmpZon=(FMUZone**)malloc(nZon*sizeof(FMUZone*));
	//inputNames=(char*)malloc((5*nZon+1)*sizeof(char*));
	//outputNames=(char**)malloc((4*nZon+1)*sizeof(char*));
	for(i=0; i<nZon; i++){
		tmpZon[i] = (FMUZone*)malloc(sizeof(FMUZone));
		char* name = ((FMUZone*)(zone->ptrBui->zones[i]))->name;
		tmpZon[i]->name=name;
		zone->ptrBui->zones[i] = tmpZon[i];
	// 	for (j=0; j<nZon*5; j++){
	// 				inputNames[j]=(char*)malloc((strlen(name)+20)*sizeof(char));
	// 	}
	// 	for (j=0; j<nZon*4; j++){
	// 				outputNames[j]=(char*)malloc((strlen(name)+20)*sizeof(char));
	// 	}
	}

	zone->ptrBui->fmu = fmu;
	for (i=0; i<nZon*5; i++){
		inputValueReferences[i]=i;
	}

	for (i=0; i<nZon*4; i++){
		outputValueReferences[i]=i+nZon*5;
	}

	while (cntr<nZon*5){
		for (j=0; j<nZon; j++) {
			for (k=0; k<5; k++){
				sprintf(inputNames[cntr], "%s%s%s", ((FMUZone*)(zone->ptrBui->zones[j]))->name, ",", consInputNames[k]);
				cntr++;

			}
		}
	}

  cntr = 0;
	while (cntr<nZon*4){
		for (j=0; j<nZon; j++) {
			for (k=0; k<4; k++){
				sprintf(outputNames[cntr], "%s%s%s", ((FMUZone*)(zone->ptrBui->zones[j]))->name, ",", consInputNames[k]);
				cntr++;
			}
		}
	}

cntr = 0;
/* The size of the inputs for each zone is fixed at 5 */
for (i=0; i<nZon; i++) {
	for (j=0; j<5; j++){
		tmpZon[i]->inputValueReferences[j]=inputValueReferences[cntr];
		strcpy(tmpZon[i]->inputVariableNames[j], inputNames[cntr]);
		cntr++;
}
}

  cntr = 0;
	for (i=0; i<nZon; i++) {
		for (j=0; j<4; j++){
			tmpZon[i]->outputValueReferences[j]=outputValueReferences[cntr];
			strcpy(tmpZon[i]->outputVariableNames[j], outputNames[cntr]);
			cntr++;
	}
}

for (i=0; i<5; i++) {
	ModelicaFormatMessage("input reference in zone1 %d\n", ((FMUZone*)(zone->ptrBui->zones[0]))->inputValueReferences[i]);
	ModelicaFormatMessage("input name in zone1 %s\n", ((FMUZone*)(zone->ptrBui->zones[0]))->inputVariableNames[i]);
}
for (i=0; i<5; i++) {
	ModelicaFormatMessage("input reference in zone2 %d\n", ((FMUZone*)(zone->ptrBui->zones[1]))->inputValueReferences[i]);
	ModelicaFormatMessage("input name in zone2 %s\n", ((FMUZone*)(zone->ptrBui->zones[1]))->inputVariableNames[i]);
}


for (i=0; i<4; i++) {
	ModelicaFormatMessage("output reference in zone1 %d\n", ((FMUZone*)(zone->ptrBui->zones[0]))->outputValueReferences[i]);
	ModelicaFormatMessage("output name in zone1 %s\n", ((FMUZone*)(zone->ptrBui->zones[0]))->outputVariableNames[i]);
}
for (i=0; i<4; i++) {
	ModelicaFormatMessage("output reference in zone2 %d\n", ((FMUZone*)(zone->ptrBui->zones[1]))->outputValueReferences[i]);
	ModelicaFormatMessage("output name in zone2 %s\n", ((FMUZone*)(zone->ptrBui->zones[1]))->outputVariableNames[i]);
}


  // fmi2String inputNames[] = {"Attic,T", "Core_ZN,T", "Perimeter_ZN_1,T",
	// 			"Perimeter_ZN_2,T", "Perimeter_ZN_3,T", "Perimeter_ZN_4,T"};
  //
  // //const fmi2ValueReference inputValueReferences[] = {0, 1, 2, 3, 4, 5,};
  // fmi2String outputNames[] = {"Attic,QConSen_flow", "Core_ZN,QConSen_flow",
  //                                "Perimeter_ZN_1,QConSen_flow", "Perimeter_ZN_2,QConSen_flow",
	// 			"Perimeter_ZN_3,QConSen_flow", "Perimeter_ZN_4,QConSen_flow"};
  //
  // //const fmi2ValueReference outputValueReferences[] = {6, 7, 8, 9, 10, 11};
  fmi2String input ="/home/thierry/eplusfmi/RefBldgSmallOfficeNew2004_Chicago.idf";
  fmi2String weather ="/home/thierry/eplusfmi/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw";
  fmi2String idd ="/home/thierry/eplusfmi/Energy+.idd";
  //
  //
  // /* Loading EnergyPlus library */
  // fmi2String eplib = "/home/thierry/eplusfmi/libepfmi.so";
  // retVal = loadLib(eplib, zone->ptrBui->fmu);
  //
  // if (retVal  < 0) {
  //    snprintf(msg, 200, "There was an error loading the EnergyPlus library\n");
  //    ModelicaMessage(msg);
  //   }
  //
  // snprintf(msg, 200, "The number of zones of the building is %d\n.", zone->ptrBui->nZon);
  // ModelicaMessage(msg);
  //
  // snprintf(msg, 200, "The name of the building is %s\n.", zone->ptrBui->name);
  // ModelicaMessage(msg);
  //
  // snprintf(msg, 200, "Ready to instantiate the E+ FMU\n");
  // ModelicaMessage(msg);
  //
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
  //
  // double tStart = 0.0;
  // int stopTimeDefined = 1;
  // double tEnd = 86400;
  //
  // result = zone->ptrBui->fmu->setupExperiment(tStart, 1, NULL);
  // double time = tStart;
  //
  // double outputs[] = {0.0, 0.0};
  // const unsigned int outputRefs[] = {6, 7};
  // //fmi2String* = {}
  // //fmi2ValueReference parameterValueReferences = {12, 18, 24}
  //
  // double inputs[] = {21.0, 21.0};
  // const unsigned int inputRefs[] = {0, 1};
  //
  // result = zone->ptrBui->fmu->setVariables(inputRefs, inputs, 2, NULL);
  // result = zone->ptrBui->fmu->getVariables(outputRefs, outputs, 2, NULL);
  //
  // snprintf(msg, 200, "The output of value is is %f\n.", outputs[0]);
  // ModelicaMessage(msg);
  // snprintf(msg, 200, "The output of value is is %f\n.", outputs[1]);
  // ModelicaMessage(msg);

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
