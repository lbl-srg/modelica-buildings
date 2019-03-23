/*
 * Modelica external function to intialize EnergyPlus.
 *
 * Michael Wetter, LBNL                  3/1/2018
 * Thierry S. Nouidui, LBNL              3/23/2018
 */

#include "FMUZoneInstantiate.h"
#include "FMUEnergyPlusStructure.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

/* Returns the value references in selectedValueReferences
*/
void getValueReferences(
    char** requiredVars,
    const size_t nReqVar,
    char** variableNames,
    fmi2ValueReference* valueReferences,
    size_t nValRef,
    fmi2ValueReference* selectedValueReferences){
    int i;
    int j;
    for (i = 0; i < nReqVar; i++){
      for (j = 0; j < nValRef; j++){
         if ( strstr(requiredVars[i], variableNames[j]) != NULL ){
           /* Found the variable */
           selectedValueReferences[i] = valueReferences[j];
           break;
         }
      }
    }
  }

void getParametersFromEnergyPlus(
  FMUZone* zone,
  const char* parNames[], /* such as {"V", "AFlo", "mSenFac"} */
  double* parValues,
  size_t nPar)
  {
  int i;
  fmi2Status status;
  char** ptrVarNames = NULL;
  char** ptrFullNames = NULL;

  fmi2ValueReference* parameterValueReferences;
  writeLog(2, "Getting parameters from EnergyPlus.");

  parameterValueReferences = (fmi2ValueReference*)malloc(nPar * sizeof(fmi2ValueReference));
  if ( parameterValueReferences == NULL)
    ModelicaFormatError("Failed to allocate memory for parameterValueReferences in FMUZoneInstantiate.c.");

  buildVariableNames(zone->name, parNames, nPar, &ptrVarNames, &ptrFullNames);

  getValueReferences(ptrFullNames, nPar,
    zone->parameterVariableNames, zone->parameterValueReferences, zone->nParameterValueReferences,
    parameterValueReferences);
  /* Get initial parameter variables */

  /* writeLog(1, "begin getVariables"); */
  status = fmi2_import_get_real(zone->ptrBui->fmu, parameterValueReferences, nPar, parValues);
  /* writeLog(1, "end getVariables"); */
  if (status != fmi2OK ){
    ModelicaFormatError("Failed to get parameters for building %s, zone %s.",
    zone->ptrBui->name, zone->name);
  }

  for (i = 0; i < nPar; i++)
    free(ptrVarNames[i]);
  free(ptrVarNames);

  /* free(parameterValueReferences);  */

  return;
}


/*
 Appends a character array to another character array.

 The array size of buffer may be extended by this function
 to prevent a buffer overflow.

 Arguments:
  buffer The buffer to which the character array will be added.
  toAdd The character array that will be appended to \c buffer
  bufLen The length of the character array buffer. This parameter will
         be set to the new size of buffer if memory was reallocated.
*/
void saveAppend(char* *buffer, const char *toAdd, size_t *bufLen){
  const size_t minInc = 1024;
  const size_t nNewCha = strlen(toAdd);
  const size_t nBufCha = strlen(*buffer);
  /* reallocate memory if needed */
  if ( *bufLen < nNewCha + nBufCha + 1){
    *bufLen = *bufLen + nNewCha + minInc + 1;
    *buffer = realloc(*buffer, *bufLen);
    if (*buffer == NULL) {
      ModelicaError("Realloc failed in saveAppend.");
    }
  }
  /* append toAdd to buffer */
  strcpy(*buffer + strlen(*buffer), toAdd);
  return;
}


void saveAppendJSONElements(
  char* *buffer,
  const char* values[],
  size_t n,
  size_t* bufLen){
    int i;
    /* Write all values and value references in the format
        { "name": "V"},
        { "name": "AFlo"}
    */
    for(i = 0; i < n; i++){
      /* Build JSON string */
      saveAppend(buffer, "        { \"", bufLen);
      saveAppend(buffer, "name", bufLen);
      saveAppend(buffer, "\": \"", bufLen);
      saveAppend(buffer, values[i], bufLen);
      saveAppend(buffer, "\" }", bufLen);
      if (i < n-1)
        saveAppend(buffer, ",\n", bufLen);
      }
  }

void buildJSONModelStructureForEnergyPlus(const FMUBuilding* bui, char* *buffer, size_t* size){
  int iZon;
  FMUZone** zones = (FMUZone**)bui->zones;

  saveAppend(buffer, "{\n", size);
  /* idf name */
  saveAppend(buffer, "  \"idf\": \"", size);
  saveAppend(buffer, bui->name, size);
  saveAppend(buffer, "\",\n", size);

  /* idd file */
  saveAppend(buffer, "  \"idd\": \"", size);
  saveAppend(buffer, bui->idd, size);
  saveAppend(buffer, "\",\n", size);

  /* weather file */
  saveAppend(buffer, "  \"weather\": \"", size);
  saveAppend(buffer, bui->weather, size);
  saveAppend(buffer, "\",\n", size);

  saveAppend(buffer, "  \"zones\": [\n    {\n", size);
  for(iZon = 0; iZon < bui->nZon; iZon++){
    /* Write zone name */
    saveAppend(buffer, "      \"name\": \"", size);
    saveAppend(buffer, zones[iZon]->name, size);
    saveAppend(buffer, "\",\n", size);
    /* Write parameters */
    saveAppend(buffer, "      \"parameters\": [\n", size);
    saveAppendJSONElements(
      buffer,
      (const char **)(zones[iZon]->parameterNames),
      zones[iZon]->nParameterValueReferences,
      size);
    saveAppend(buffer, "\n      ],\n", size);
    /* Write inputs */
    saveAppend(buffer, "      \"inputs\": [\n", size);
    saveAppendJSONElements(
      buffer,
      (const char **)(zones[iZon]->inputNames),
      zones[iZon]->nInputValueReferences,
      size);
    saveAppend(buffer, "\n      ],\n", size);
    /* Write outputs */
    saveAppend(buffer, "      \"outputs\": [\n", size);
    saveAppendJSONElements(
      buffer,
      (const char **)(zones[iZon]->outputNames),
      zones[iZon]->nOutputValueReferences,
      size);
    /* Close json array */
    saveAppend(buffer, "\n      ]\n    }\n  ]\n}\n", size);

    return;
  }
}


void writeModelStructureForEnergyPlus(const FMUBuilding* bui){
  char * buffer;
  size_t size;
  size_t lenNam;
  char * filNam;
  FILE* fp;

  /* Initial size which will grow as needed */
  size = 1024;

  buffer = (char*)malloc((size+1) * sizeof(char));
  if ( buffer == NULL)
    ModelicaFormatError("Failed to allocate memory for json buffer.");
  memset(buffer, '\0', size + 1);

  /* Build the json structure */
  buildJSONModelStructureForEnergyPlus(bui, &buffer, &size);

  /* Write to file */
  /* Build the file name */
  lenNam = strlen(bui->tmpDir) + strlen(SEPARATOR) + strlen(MOD_BUI_JSON);
  filNam = malloc((lenNam+1) * sizeof(char));
  if (filNam == NULL)
    ModelicaFormatError("Failed to allocate memory for name of '%s' file.", MOD_BUI_JSON);
  memset(filNam, '\0', lenNam+1);
  strcpy(filNam, bui->tmpDir);
  strcat(filNam, SEPARATOR);
  strcat(filNam, MOD_BUI_JSON);

  /* Open and write file */
  fp = fopen(filNam, "w");
  if (fp == NULL)
    ModelicaFormatError("Failed to open '%s' with write mode.", filNam);
  fprintf(fp, "%s", buffer);
  fclose(fp);
  free(filNam);
}


void FMUZoneAllocateAndInstantiateBuilding(FMUBuilding* bui){
  /* This is the first call for this idf file.
     Allocate memory and load the fmu.
  */
  const char* FMUPath = "Buildings/Resources/src/EnergyPlus/FMUs/SingleZone.fmu";
	const char* tmpPath = bui->tmpDir;
  const fmi2Boolean visible = fmi2False;

  fmi2_callback_functions_t callBackFunctions;
  jm_callbacks callbacks;
  fmi_version_enu_t version;
  fmi2_fmu_kind_enu_t fmukind;
	jm_status_enu_t jm_status;
  int ret;

  if( access( FMUPath, F_OK ) == -1 ) {
    ModelicaFormatError("Requested to load fmu '%s' which does not exist.", FMUPath);
  }
  /* Write the model structure to the FMU Resources folder so that EnergyPlus can
     read it and set up the data structure.
  */
  writeModelStructureForEnergyPlus(bui);

/*
  fmi2Boolean loggingOn = fmi2True;
  fmi2Type fmuType = fmi2ModelExchange;
*/

  /* Set callback functions */
  callbacks.malloc = malloc;
  callbacks.calloc = calloc;
  callbacks.realloc = realloc;
  callbacks.free = free;
  callbacks.logger = fmilogger;
	callbacks.log_level = jm_log_level_all;
  callbacks.context = 0;

  bui->context = fmi_import_allocate_context(&callbacks);

  writeLog(3, "Getting fmi version.");
  version = fmi_import_get_fmi_version(bui->context, FMUPath, tmpPath);

  if (version != fmi_version_2_0_enu){
    fmi_import_free_context(bui->context);
    ModelicaFormatError("Wrong FMU version for %s, require FMI 2.0 for Model Exchange, received %s.", FMUPath, fmi_version_to_string(version));
  }

  writeLog(3, "Parsing xml file.");
  bui->fmu = fmi2_import_parse_xml(bui->context, tmpPath, 0);

	if(!bui->fmu) {
    fmi_import_free_context(bui->context);
		ModelicaError("Error parsing XML, exiting.");
	}
	/* modelName = fmi2_import_get_model_name(bui->fmu); */
	bui->GUID = fmi2_import_get_GUID(bui->fmu);

	if(fmi2_import_get_fmu_kind(bui->fmu) != fmi2_fmu_kind_cs) {
		fmukind = fmi2_fmu_kind_me;
	}
	else{
		ModelicaFormatError("Unxepected FMU kind for %s, require ME.", FMUPath);
	}

  callBackFunctions.logger = fmi2_log_forwarding;
  callBackFunctions.allocateMemory = calloc;
  callBackFunctions.freeMemory = free;
  callBackFunctions.componentEnvironment = bui->fmu;

  writeLog(3, "Loading dllfmu.");

/*
  if( access( "tmp-eplus-RefBldgSmallOfficeNew2004_Chicago/binaries/linux64/SingleZone.so", F_OK ) == -1 ) {
    ModelicaFormatError("Requested to load '%s' which does not exist.", "tmp-eplus-RefBldgSmallOfficeNew2004_Chicago/binaries/linux64/SingleZone.so");
  }
*/
  jm_status = fmi2_import_create_dllfmu(bui->fmu, fmukind, &callBackFunctions);
  if (jm_status == jm_status_error) {
    fmi_import_free_context(bui->context);
  	ModelicaFormatError("Could not create the DLL loading mechanism (C-API) for %s.", FMUPath);
  }

  writeLog(3, "Instantiating fmu.");

  /* Instantiate EnergyPlus */
  jm_status = fmi2_import_instantiate(bui->fmu, bui->name, fmi2_model_exchange, NULL, visible);

  writeLog(3, "Returned from instantiating fmu.");
  if(jm_status == jm_status_error){
    ModelicaFormatError("Failed to instantiate building FMU with name %s.",
    bui->name);
  }

  return;
}

/* This function is called for each zone in the 'initial equation section'
*/
void FMUZoneInstantiate(void* object, double startTime, double* AFlo, double* V, double* mSenFac){
  fmi2Status status;
  FMUZone* zone = (FMUZone*) object;

  double* outputs;

  printf("*** fmu address is %p\n", (void*)zone->ptrBui->fmu);
  if (zone->ptrBui->fmu == NULL){
    /* EnergyPlus is not yet loaded.
       This section is only executed once if the 'initial equation' section is called multiple times.
    */
    FMUZoneAllocateAndInstantiateBuilding(zone->ptrBui);
    /* This function can only be called once per building FMU */
    writeLog(0, "Setting up experiment.");

    status = fmi2_import_setup_experiment(
        zone->ptrBui->fmu,    /* fmu */
        fmi2False,            /* toleranceDefined */
        0.0,                  /* tolerance */
        startTime,            /* startTime */
        fmi2False,            /* stopTimeDefined */
        0);                   /* stopTime */

    writeLog(0, "Returned from setting up experiment.");
    if( status =! fmi2OK ){
      ModelicaFormatError("Failed to setup experiment for building with name %s.",  zone->ptrBui->name);
    }
  }

  /* Allocate memory */
  outputs = (double*)malloc(zone->nParameterValueReferences * sizeof(double));
  if (outputs == NULL)
    ModelicaError("Failed to allocated memory for outputs in FMUZoneInstantiate.c.");

  getParametersFromEnergyPlus(
    zone,
    (const char **)(zone->parameterNames),
    outputs,
    zone->nParameterValueReferences);

    /* Obtain the floor area and the volume of the zone */
    *V = outputs[0];
    *AFlo = outputs[1];
    *mSenFac = outputs[2];

    /* free(outputs); */
}
