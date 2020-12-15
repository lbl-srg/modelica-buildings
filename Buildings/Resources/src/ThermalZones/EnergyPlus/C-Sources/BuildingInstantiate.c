/*
 * Modelica external function to intialize EnergyPlus.
 *
 * Michael Wetter, LBNL                  3/1/2018
 * Thierry S. Nouidui, LBNL              3/23/2018
 */

#include "BuildingInstantiate.h"
#ifndef Buildings_BuildingInstantiate_c
#define Buildings_BuildingInstantiate_c

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdbool.h>

void buildJSONKeyValue(
  char* *buffer, size_t level, const char* key, const char* value, bool addComma, size_t* size,
  void (*SpawnFormatError)(const char *string, ...)){
  size_t i;
  for(i = 0; i < level; i++)
    saveAppend(buffer, "  ", size, SpawnFormatError);
  saveAppend(buffer, "\"", size, SpawnFormatError);
  saveAppend(buffer, key, size, SpawnFormatError);
  saveAppend(buffer, "\": \"", size, SpawnFormatError);
  saveAppend(buffer, value, size, SpawnFormatError);
  if (addComma)
    saveAppend(buffer, "\",\n", size, SpawnFormatError);
  else
    saveAppend(buffer, "\"\n", size, SpawnFormatError);
}

void openJSONModelBracket(char* *buffer, size_t* size, void (*SpawnFormatError)(const char *string, ...)){
  saveAppend(buffer, "      {\n", size, SpawnFormatError);
}

void closeJSONModelBracket(
  char* *buffer, size_t i, size_t iMax, size_t* size,
  void (*SpawnFormatError)(const char *string, ...)){
  if (i < iMax -1)
    saveAppend(buffer, "      },\n", size, SpawnFormatError);
  else
    saveAppend(buffer, "      }\n", size, SpawnFormatError);
}

void closeJSONModelArrayBracket(
  char* *buffer, size_t iMod, size_t nMod, size_t* size,
  void (*SpawnFormatError)(const char *string, ...)){
  /* Close json array bracket */
  if (iMod == nMod){
    /* There are no more other objects that belong to "model" */
    saveAppend(buffer, "    ]\n", size, SpawnFormatError);
  }
  else{
    /* There are other objects that belong to "model" */
    saveAppend(buffer, "    ],\n", size, SpawnFormatError);
  }
}

void buildJSONModelStructureForEnergyPlus(
  const FMUBuilding* bui, char* *buffer, size_t* size, char** modelHash){
  size_t i;
  size_t iWri;
  size_t nSch;
  FMUZone** zones = (FMUZone**)bui->zones;
  FMUInputVariable** inpVars= NULL;
  FMUOutputVariable** outVars = NULL;
  /* Total number of models */
  const size_t nMod = bui->nZon + bui->nInputVariables + bui->nOutputVariables;
  /* Number of models written to json so far */
  size_t iMod = 0;

  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  saveAppend(buffer, "{\n", size, SpawnFormatError);
  buildJSONKeyValue(buffer, 1, "version", "0.1", true, size, SpawnFormatError);
  saveAppend(buffer, "  \"EnergyPlus\": {\n", size, SpawnFormatError);
  /* idf name */
  buildJSONKeyValue(buffer, 2, "idf", bui->idfName, true, size, SpawnFormatError);

  /* weather file */
  buildJSONKeyValue(buffer, 2, "weather", bui->weather, false, size, SpawnFormatError);
  saveAppend(buffer, "  },\n", size, SpawnFormatError);

  /* model information */
  saveAppend(buffer, "  \"model\": {\n", size, SpawnFormatError);
  /* Write zone names */
  for(i = 0; i < bui->nZon; i++){
    if (i == 0){
      saveAppend(buffer, "    \"zones\": [\n", size, SpawnFormatError);
    }
    openJSONModelBracket(buffer, size, SpawnFormatError);
    buildJSONKeyValue(buffer, 4, "name", zones[i]->name, false, size, SpawnFormatError);
    closeJSONModelBracket(buffer, i, bui->nZon, size, SpawnFormatError);
  }
  iMod = bui->nZon;
  if (iMod > 0)
    closeJSONModelArrayBracket(buffer, iMod, nMod, size, SpawnFormatError);


  /* Write schedule names */
  if (bui->nInputVariables > 0)
    inpVars = (FMUInputVariable**)bui->inputVariables;

  /* Count the number of schedules */
  nSch = 0;
  for(i = 0; i < bui->nInputVariables; i++){
    if (inpVars[i]->componentType == NULL){
      /* This is a schedule, not an EMS actuator */
      nSch++;
    }
  }
  /* Write the schedule objects, if any. */
  iWri = 0;
  for(i = 0; i < bui->nInputVariables; i++){
    if (inpVars[i]->componentType == NULL){ /* Found a schedule */
      if (iWri == 0){
        saveAppend(buffer, "    \"schedules\": [\n", size, SpawnFormatError);
      }
      openJSONModelBracket(buffer, size, SpawnFormatError);
      buildJSONKeyValue(buffer, 4, "name", inpVars[i]->name, true, size, SpawnFormatError);
      buildJSONKeyValue(buffer, 4, "unit", inpVars[i]->unit, true, size, SpawnFormatError);
      buildJSONKeyValue(buffer, 4, "fmiName", inpVars[i]->inputs->fmiNames[0], false, size, SpawnFormatError);
      closeJSONModelBracket(buffer, iWri, nSch, size, SpawnFormatError);
      iWri++;
    }
  }
  if (nSch > 0){
    iMod += nSch;
    closeJSONModelArrayBracket(buffer, iMod, nMod, size, SpawnFormatError);
  }


  /* Write the EMS actuator objects, if any */
  iWri = 0;
  for(i = 0; i < bui->nInputVariables; i++){
    if (inpVars[i]->componentType != NULL){ /* Found an EMS actuator */
      if (iWri == 0){
        saveAppend(buffer, "    \"emsActuators\": [\n", size, SpawnFormatError);
      }
      openJSONModelBracket(buffer, size, SpawnFormatError);
      buildJSONKeyValue(buffer, 4, "variableName", inpVars[i]->name, true, size, SpawnFormatError);
      buildJSONKeyValue(buffer, 4, "componentType", inpVars[i]->componentType, true, size, SpawnFormatError);
      buildJSONKeyValue(buffer, 4, "controlType", inpVars[i]->controlType, true, size, SpawnFormatError);
      buildJSONKeyValue(buffer, 4, "unit", inpVars[i]->unit, true, size, SpawnFormatError);
      buildJSONKeyValue(buffer, 4, "fmiName", inpVars[i]->inputs->fmiNames[0], false, size, SpawnFormatError);
      closeJSONModelBracket(buffer, iWri, bui->nInputVariables-nSch, size, SpawnFormatError);
      iWri++;
    }
  }
  if (bui->nInputVariables-nSch > 0){
    iMod += bui->nInputVariables-nSch;
    closeJSONModelArrayBracket(buffer, iMod, nMod, size, SpawnFormatError);
  }

  /* Write output names */
  if (bui->nOutputVariables > 0){
    outVars = (FMUOutputVariable**)bui->outputVariables;
  }
  for(i = 0; i < bui->nOutputVariables; i++){
    if (i == 0){
      saveAppend(buffer, "    \"outputVariables\": [\n", size, SpawnFormatError);
    }
    openJSONModelBracket(buffer, size, SpawnFormatError);
    buildJSONKeyValue(buffer, 4, "name", outVars[i]->name, true, size, SpawnFormatError);
    buildJSONKeyValue(buffer, 4, "key",  outVars[i]->key,  true, size, SpawnFormatError);
    buildJSONKeyValue(buffer, 4, "fmiName",  outVars[i]->outputs->fmiNames[0], false, size, SpawnFormatError);
    closeJSONModelBracket(buffer, i, bui->nOutputVariables, size, SpawnFormatError);
  }
  if (bui->nOutputVariables > 0){
    iMod += bui->nOutputVariables;
    closeJSONModelArrayBracket(buffer, iMod, nMod, size, SpawnFormatError);
  }

  /* Close json object for model */
  saveAppend(buffer, "  },\n", size, SpawnFormatError);

  *modelHash = (char*)( cryptographicsHash(*buffer, bui->SpawnError) );

    /* fmu */
  saveAppend(buffer, "  \"fmu\": {\n", size, SpawnFormatError);
  buildJSONKeyValue(buffer, 3, "name", bui->fmuAbsPat, true, size, SpawnFormatError);
  buildJSONKeyValue(buffer, 3, "version", "2.0", true, size, SpawnFormatError);
  buildJSONKeyValue(buffer, 3, "kind", "ME", false, size, SpawnFormatError);
  saveAppend(buffer, "  }\n", size, SpawnFormatError);

  /* Close json structure */
  saveAppend(buffer, "}\n", size, SpawnFormatError);

  return;
}


void writeModelStructureForEnergyPlus(const FMUBuilding* bui, char** modelicaBuildingsJsonFile, char** modelHash){
  char * buffer;
  size_t size;
  size_t lenNam;
  FILE* fp;

  /* Initial size which will grow as needed */
  size = 1024;

  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  mallocString(size+1, "Failed to allocate memory for json buffer.", &buffer, SpawnFormatError);
  memset(buffer, '\0', size + 1);

  /* Build the json structure */
  buildJSONModelStructureForEnergyPlus(bui, &buffer, &size, modelHash);

  /* Write to file */
  /* Build the file name */
  lenNam = strlen(bui->tmpDir) + strlen(SEPARATOR) + strlen(MOD_BUI_JSON);

  mallocString(lenNam+1, "Failed to allocate memory for json file name.", modelicaBuildingsJsonFile, SpawnFormatError);
  memset(*modelicaBuildingsJsonFile, '\0', lenNam+1);
  strcpy(*modelicaBuildingsJsonFile, bui->tmpDir);
  strcat(*modelicaBuildingsJsonFile, SEPARATOR);
  strcat(*modelicaBuildingsJsonFile, MOD_BUI_JSON);

  /* Open and write file */
  fp = fopen(*modelicaBuildingsJsonFile, "w");
  if (fp == NULL)
    SpawnFormatError("Failed to open '%s' with write mode.", *modelicaBuildingsJsonFile);
  fprintf(fp, "%s", buffer);
  fclose(fp);
}

void setAttributesReal(
  FMUBuilding* bui,
  fmi2_import_variable_list_t* varLis,
  const fmi2_value_reference_t varValRef[],
  const size_t nVar,
  const spawnReals* ptrSpawnReals){

  const char* fmuNam = bui->fmuAbsPat;
  const char* idfName = bui->idfName;
  size_t iFMI;
  fmi2_import_variable_t* var;
  bool found;
  size_t i;

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  for(i = 0; i < ptrSpawnReals->n; i++){
    found = false;
    if (bui->logLevel >= TIMESTEP)
        SpawnFormatMessage("Setting variable reference for %s.", ptrSpawnReals->fmiNames[i]);

    for (iFMI = 0; iFMI < nVar; iFMI++){
      var = fmi2_import_get_variable(varLis, iFMI);
      if (strcmp(ptrSpawnReals->fmiNames[i], fmi2_import_get_variable_name(var)) == 0){
        /* Found the variable */
        fmi2_import_real_variable_t* varRea = fmi2_import_get_variable_as_real(var);
        ptrSpawnReals->units[i] = fmi2_import_get_real_variable_unit(varRea);
        /* If a unit is not specified in modelDescription.xml, then unit is NULL */

        if (ptrSpawnReals->units[i] == NULL){
          SpawnFormatMessage("Warning: Variable %s does not specify units in %s. It will not be converted to SI units.\n",
            ptrSpawnReals->fmiNames[i], fmuNam);
        }

        if (bui->logLevel >= MEDIUM){
          if (ptrSpawnReals->units[i] == NULL)
            SpawnFormatMessage("Variable with name %s has no units and valRef= %d.", ptrSpawnReals->fmiNames[i], varValRef[iFMI]);
          else{
            const char* unitName = fmi2_import_get_unit_name(ptrSpawnReals->units[i]); /* This is 'W', 'm2', etc. */
            SpawnFormatMessage("Variable with name %s has unit = %s and valRef= %d.", ptrSpawnReals->fmiNames[i], unitName, varValRef[iFMI]);
          }
        }
        ptrSpawnReals->valRefs[i] = varValRef[iFMI];
        found = true;
        break;
      }
    }
    if (!found)
      SpawnFormatError("Failed to find variable %s in %s.",
        ptrSpawnReals->fmiNames[i], fmuNam);
  }
}

void setValueReferences(FMUBuilding* bui){
  size_t i;
  FMUZone* zone;
  FMUInputVariable* inpVar;
  FMUOutputVariable* outVar;

  fmi2_import_variable_list_t* vl = fmi2_import_get_variable_list(bui->fmu, 0);
  const fmi2_value_reference_t* vrl = fmi2_import_get_value_referece_list(vl);
  size_t nv = fmi2_import_get_variable_list_size(vl);

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  /* Set value references for the zones by assigning the values obtained from the FMU */
  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("Setting variable references for zones.");

  for(i = 0; i < bui->nZon; i++){
    zone = (FMUZone*) bui->zones[i];
    setAttributesReal(bui, vl, vrl, nv, zone->parameters);
    setAttributesReal(bui, vl, vrl, nv, zone->inputs);
    setAttributesReal(bui, vl, vrl, nv, zone->outputs);
  }

  /* Set value references for the input variables by assigning the values obtained from the FMU */
  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("Setting variable references for input variables.");

  for(i = 0; i < bui->nInputVariables; i++){
    inpVar = (FMUInputVariable*) bui->inputVariables[i];
    setAttributesReal(bui, vl, vrl, nv, inpVar->inputs);
    inpVar->valueReferenceIsSet = true;
  }

  /* Set value references for the output variables by assigning the values obtained from the FMU */
  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("Setting variable references for output variables.");

  for(i = 0; i < bui->nOutputVariables; i++){
    outVar = (FMUOutputVariable*) bui->outputVariables[i];
    setAttributesReal(bui, vl, vrl, nv, outVar->outputs);
    outVar->valueReferenceIsSet = true;
  }

  /* Free the variable list */
  fmi2_import_free_variable_list(vl);

  return;
}

void generateFMU(FMUBuilding* bui, const char* modelicaBuildingsJsonFile){
  /* Generate the FMU */
  char* cmd;
  char* optionFlags;
  char* outputFlag;
  char* createFlag;
  char* fulCmd;
  size_t len;
  int retVal;

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;
  void (*SpawnError)(const char *string) = bui->SpawnError;

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("Entered generateFMU with FMUPath = %s.\n", bui->fmuAbsPat);

  if( access(modelicaBuildingsJsonFile, F_OK ) == -1 ) {
    SpawnFormatError("Requested to use json file '%s' which does not exist.", modelicaBuildingsJsonFile);
  }
#ifdef _WIN32 /* Win32 or Win64 */
  cmd = "/Resources/bin/spawn-win64/bin/spawn.exe";
#elif __APPLE__
  cmd = "/Resources/bin/spawn-darwin64/bin/spawn";
#else
  cmd = "/Resources/bin/spawn-linux64/bin/spawn";
#endif
  optionFlags = " --no-compress "; /* Flag for command */
  outputFlag = " --output-path "; /* Flag for command */
  createFlag = " --create "; /* Flag for command */
  len = strlen(bui->buildingsLibraryRoot) + strlen(cmd) + strlen(optionFlags)
    + strlen(outputFlag) + strlen("\"") + strlen(bui->fmuAbsPat) + strlen("\"")
    + strlen(createFlag) + strlen("\"") + strlen(modelicaBuildingsJsonFile) + strlen("\"")
    + 1;

  mallocString(len, "Failed to allocate memory in generateFMU().", &fulCmd, SpawnFormatError);
  memset(fulCmd, '\0', len);
  strcpy(fulCmd, bui->buildingsLibraryRoot); /* This is for example /mtn/shared/Buildings */
  strcat(fulCmd, cmd);
  /* Check if the executable exists
     Linux return 0, and Windows returns 2 if file does not exist */
  if( access(fulCmd, F_OK ) != 0 ) {
    SpawnFormatError("Executable '%s' does not exist: '%s'.", fulCmd, strerror(errno));
  }
  /* Make sure the file is executable */
  /* Windows has no mode X_OK = 1, see https://docs.microsoft.com/en-us/cpp/c-runtime-library/reference/access-waccess?view=vs-2019 */
#ifndef _WIN32
  if( access(fulCmd, X_OK ) != 0 ) {
    SpawnFormatError("File '%s' exists, but fails to have executable flag set: '%s.", fulCmd, strerror(errno));
  }
#endif
  /* Continue building the command line */
  strcat(fulCmd, optionFlags);
  strcat(fulCmd, outputFlag);
  strcat(fulCmd, "\"");
  strcat(fulCmd, bui->fmuAbsPat);
  strcat(fulCmd, "\"");
  strcat(fulCmd, createFlag);
  strcat(fulCmd, "\"");
  strcat(fulCmd, modelicaBuildingsJsonFile);
  strcat(fulCmd, "\"");

  /* Generate the FMU */
  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("Executing %s\n", fulCmd);

  retVal = system(fulCmd);
  /* Check if generated FMU indeed exists */
  if( access( bui->fmuAbsPat, F_OK ) != 0 ) {
    SpawnFormatError("Executing '%s' failed to generate fmu '%s'.", fulCmd, bui->fmuAbsPat);
  }
  if (retVal != 0){
    fprintf(stdout, "*** Warning: Generating FMU returned value %d, but FMU exists.\n", retVal);
/*    SpawnFormatError("Generating FMU failed using command '%s', return value %d.", fulCmd, retVal);*/
  }
  free(fulCmd);
}


/* Set the categories to be logged.
   Note that EnergyPlus has the following levels:
      std::map<EnergyPlus::Error, fmi2Status> logLevelMap = {
        {EnergyPlus::Error::Info, fmi2OK},
        {EnergyPlus::Error::Warning, fmi2Warning},
        {EnergyPlus::Error::Severe, fmi2Error},
        {EnergyPlus::Error::Fatal, fmi2Fatal}
      };
   bui->logLevel is {ERRORS = 1, WARNINGS = 2, QUIET = 3, MEDIUM = 4, TIMESTEP = 5};
*/
void setFMUDebugLevel(FMUBuilding* bui){
  fmi2_string_t* categories;
  size_t i;
  fmi2Status status;

  /* Get the number of log categories defined in the XML */
  const size_t nCat = fmi2_import_get_log_categories_num(bui->fmu);
  /* Number of log categories needed from EnergyPlus. Note that Modelica has
     one more category for log at time step level */
  const size_t nCatReq = (bui->logLevel <= nCat) ? bui->logLevel : nCat;
/*
  if (nCat != 4){
    bui->SpawnFormatError("FMU %s specified %u categories, but require 4 categories.",
      bui->fmuAbsPat, nCat, bui->logLevel);
  }
*/

  /* Get the log categories that we need */
  categories = NULL;
  categories = (fmi2_string_t*)malloc(nCatReq * sizeof(fmi2_string_t));
  if (categories == NULL){
    bui->SpawnFormatError("Failed to allocate memory for error categories for FMU %s", bui->fmuAbsPat);
  }
  /* Assign the categories as specified in modelDescription.xml */
  for(i=0; i < nCatReq; i++){
    categories[i] = fmi2_import_get_log_category(bui->fmu, i);
  }

  if (bui->logLevel >= MEDIUM)
    bui->SpawnFormatMessage("Setting debug logging.");
  status = fmi2_import_set_debug_logging(
    bui->fmu,
    fmi2_true,        /* Logging on */
    (size_t)nCatReq, /* nCategories */
    categories);        /* Which categories to log */
  if( status != fmi2_status_ok ){
    bui->SpawnMessage("Log categories:");
    for(i = 0; i < nCatReq; i++){
      bui->SpawnFormatMessage("  Category[%u] = '%s'", i, categories[i]);
    }
    bui->SpawnFormatError("fmi2SetDebugLogging returned '%s' for FMU with name %s. Verbosity = %u", fmi2_status_to_string(status), bui->fmuAbsPat, bui->logLevel);
  }
  /* Free storage */
  /* This gives Warning C4090 in Microsoft compiler
  free(categories);
  */
}

/* Logger function used for Spawn */
void spawnLogger(
  fmi2_component_environment_t env,
  fmi2_string_t instanceName,
  fmi2_status_t status,
  fmi2_string_t category,
  fmi2_string_t message, ...)
{
  /* EnergyPlus has for category always "EnergyPlus message", so we don't report this here */
  int len;
  const char* signature = "In %s: EnergyPlus %s: %s\n";
  char msg[SPAWN_LOGGER_BUFFER_LENGTH];

  FMUBuilding* bui = (FMUBuilding*)env;

  va_list argp;
  va_start(argp, message);

  len = vsnprintf(msg, SPAWN_LOGGER_BUFFER_LENGTH, message, argp);
  if (len < 0)
    bui->SpawnFormatError("Failed to parse message '%s' from EnergyPlus.", message);

  if (status == fmi2_status_ok || status == fmi2_status_pending || status == fmi2_status_discard){
    if (bui->logLevel >= QUIET)
      bui->SpawnFormatMessage(signature, instanceName, "Info", msg);
  }
  else if (status == fmi2_status_warning){
    if (bui->logLevel >= WARNINGS)
      bui->SpawnFormatMessage(signature, instanceName, fmi2_status_to_string(status), msg);
  }
  else{
    /* This captures fmi2_status_error and fmi2_status_fatal.
       They are written for any logLevel. */
    bui->SpawnFormatMessage(signature, instanceName, fmi2_status_to_string(status), msg);
  }

  va_end(argp);
}

/* Import the EnergyPlus FMU
*/
void importEnergyPlusFMU(FMUBuilding* bui){
  const fmi2Boolean visible = fmi2False;

  /* fmi2_import_model_counts_t  mc; */
  fmi2_callback_functions_t callBackFunctions;
  jm_callbacks* callbacks;
  fmi_version_enu_t version;
  fmi2_fmu_kind_enu_t fmukind;
  jm_status_enu_t jm_status;

  const char* tmpPath = bui->tmpDir;
  const char* FMUPath = bui->fmuAbsPat;

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  /* Set callback functions */
  callbacks = jm_get_default_callbacks();

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("Calling fmi_import_allocate_context(callbacks = %p)", callbacks);
  bui->context = fmi_import_allocate_context(callbacks);

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("Getting fmi version, bui->context = %p, FMUPath = %s, tmpPath = %s.", bui->context, FMUPath, tmpPath);
  version = fmi_import_get_fmi_version(bui->context, FMUPath, tmpPath);

  if (version != fmi_version_2_0_enu){
    SpawnFormatError("Wrong FMU version for %s, require FMI 2.0 for Model Exchange, received %s.",
    FMUPath, fmi_version_to_string(version));
  }

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("Parsing xml file %s", tmpPath);
  bui->fmu = fmi2_import_parse_xml(bui->context, tmpPath, 0);
	if(!bui->fmu) {
		SpawnFormatError("Error parsing XML for %s.", FMUPath);
	}

	/* modelName = fmi2_import_get_model_name(bui->fmu); */
	bui->GUID = fmi2_import_get_GUID(bui->fmu);

  fmukind = fmi2_import_get_fmu_kind(bui->fmu);
  if(fmukind != fmi2_fmu_kind_me){
    SpawnFormatError("Unxepected FMU kind for %s, require ME.", FMUPath);
  }

  /* Get model statistics
  fmi2_import_collect_model_counts(bui->fmu, &mc);
  printf("*** Number of discrete variables %lu.\n", mc.num_discrete);
 */
  callBackFunctions.logger = spawnLogger;
  callBackFunctions.allocateMemory = calloc;
  callBackFunctions.freeMemory = free;
  callBackFunctions.stepFinished = NULL; /* synchronous execution */
  callBackFunctions.componentEnvironment = bui;

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("Loading dllfmu.");

  jm_status = fmi2_import_create_dllfmu(bui->fmu, fmukind, &callBackFunctions);
  if (jm_status == jm_status_error) {
  	SpawnFormatError("Could not create the DLL loading mechanism (C-API) for %s.", FMUPath);
  }
  else{
    bui->dllfmu_created = fmi2_true;
  }

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("Instantiating fmu.");

  /* Instantiate EnergyPlus */
  jm_status = fmi2_import_instantiate(
    bui->fmu,
    bui->modelicaNameBuilding,
    fmi2_model_exchange,
    NULL,
    visible);

  /* SpawnFormatError("%s", "***** This line is never reached on Windows.\n"); */

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("Returned from instantiating fmu.");
  if(jm_status == jm_status_error){
    SpawnFormatError("Failed to instantiate building FMU with name %s.",  bui->modelicaNameBuilding);
  }
  /* Set the debug level in the FMU */
  setFMUDebugLevel(bui);
}

void setReusableFMU(FMUBuilding* bui){
  int iBui;
  FMUBuilding* ptrBui;

  for(iBui = 0; iBui < getBuildings_nFMU(); iBui++){
    ptrBui = (FMUBuilding*)(getBuildingsFMU(iBui));
    if ((iBui != bui->iFMU) && (ptrBui->modelHash != NULL)){
      if (strcmp(bui->modelHash, ptrBui->modelHash) == 0 ){
        /* Check if the FMU indeed was generated */
        if( access( ptrBui->fmuAbsPat, F_OK ) != -1 ) {
          /* We can use the same FMU as will be used for building iBui */
          bui->usePrecompiledFMU = true;
          bui->precompiledFMUAbsPat = ptrBui->fmuAbsPat;
        }
      }
    }
  }
}


int deleteFile(const char* fileName){
  /* Remove file if it exists */
  if (access(fileName, F_OK) == 0) {
    /* FMU exists. Delete it. */
    return remove(fileName);
  }
  else
    return 0;
}

void copyBinaryFile(
  const char* src,
  const char* des,
  void (*SpawnFormatError)(const char *string, ...)){

    FILE* srcFil;
    FILE* desFil;
    size_t n, m;
    unsigned char buff[8192];

    srcFil = fopen(src, "rb");

    if( srcFil == NULL )
    {
        SpawnFormatError("Failed to open %s, %s.", src, strerror(errno));
     }

    desFil = fopen(des, "wb");

    if( desFil == NULL )
    {
      fclose(srcFil);
      SpawnFormatError("Failed to open %s, %s.", des, strerror(errno));
    }

    do {
        n = fread(buff, 1, sizeof buff, srcFil);
        if (n)
          m = fwrite(buff, 1, n, desFil);
        else
          m = 0;
    } while ((n > 0) && (n == m));
    if (m)
      SpawnFormatError("Error during copying %s to %s.", src, des);

    if ( fclose(srcFil) != 0 )
      SpawnFormatError("Failed to close %s, %s.", src, strerror(errno));
    if ( fclose(desFil) != 0 )
      SpawnFormatError("Failed to close %s, %s.", des, strerror(errno));
  }


void generateAndInstantiateBuilding(FMUBuilding* bui){
  /* This is the first call for this idf file.
     Allocate memory and load the fmu.
  */
  char* modelicaBuildingsJsonFile;

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("Entered EnergyPlusZoneAllocateAndInstantiateBuilding.\n");

  if (bui->usePrecompiledFMU)
    SpawnFormatMessage("Using pre-compiled FMU %s\n", bui->precompiledFMUAbsPat);

  /* Write the model structure to the FMU Resources folder so that EnergyPlus can
     read it and set up the data structure.
  */
  writeModelStructureForEnergyPlus(bui, &modelicaBuildingsJsonFile, &(bui->modelHash));

  setReusableFMU(bui);

  if ( deleteFile(bui->fmuAbsPat) != 0 )
    SpawnFormatError("Failed to remove old FMU '%s': '%s'.", bui->fmuAbsPat, strerror(errno));

  if (bui->usePrecompiledFMU){
    if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage("Copying FMU %s to %s as buildings are identical.\n", bui->precompiledFMUAbsPat, bui->fmuAbsPat);
    copyBinaryFile(bui->precompiledFMUAbsPat, bui->fmuAbsPat, SpawnFormatError);
  }
  else
    generateFMU(bui, modelicaBuildingsJsonFile);

  free(modelicaBuildingsJsonFile);

  if( access( bui->fmuAbsPat, F_OK ) == -1 ) {
    SpawnFormatError("Requested to load fmu '%s' which does not exist.", bui->fmuAbsPat);
  }

  importEnergyPlusFMU(bui);

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("FMU for building %s is at %p.\n", bui->modelicaNameBuilding, bui->fmu);

  /* Set the value references for all parameters, inputs and outputs */
  setValueReferences(bui);

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("FMU for building %s returns from generateAndInstantiateBuilding.\n", bui->modelicaNameBuilding);

  return;
}
#endif
