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
  double* parValues)
  {
  fmi2Status status;

  writeLog(2, "Getting parameters from EnergyPlus.");
  status = fmi2_import_get_real(
    zone->ptrBui->fmu,
    zone->parameterValueReferences,
    ZONE_N_PAR,
    parValues);
  /* writeLog(1, "end getVariables"); */
  if (status != fmi2OK ){
    ModelicaFormatError("Failed to get parameters for building %s, zone %s.",
    zone->ptrBui->name, zone->name);
  }
  return;
}


void buildJSONModelStructureForEnergyPlus(const FMUBuilding* bui, char* *buffer, size_t* size){
  int iZon;
  FMUZone** zones = (FMUZone**)bui->zones;

  saveAppend(buffer, "{\n", size);
  saveAppend(buffer, "  \"version\": \"0.1\",\n", size);
  saveAppend(buffer, "  \"EnergyPlus\": {\n", size);
  /* idf name */
  saveAppend(buffer, "    \"idf\": \"", size);
  saveAppend(buffer, bui->name, size);
  saveAppend(buffer, "\",\n", size);

  /* idd file */
  saveAppend(buffer, "    \"idd\": \"", size);
  saveAppend(buffer, bui->idd, size);
  saveAppend(buffer, "\",\n", size);

  /* weather file */
  saveAppend(buffer, "    \"weather\": \"", size);
  saveAppend(buffer, bui->weather, size);
  saveAppend(buffer, "\"\n", size);
  saveAppend(buffer, "  },\n", size);
  /* fmu */
  saveAppend(buffer, "  \"fmu\": {\n", size);
  saveAppend(buffer, "      \"name\": \"", size);
  saveAppend(buffer, bui->fmuAbsPat, size);
  saveAppend(buffer, "\",\n", size);
  saveAppend(buffer, "      \"version\": \"2.0\",\n", size);
  saveAppend(buffer, "      \"kind\"   : \"ME\"\n", size);
  saveAppend(buffer, "  },\n", size);

  saveAppend(buffer, "  \"model\": {\n", size);
  saveAppend(buffer, "    \"zones\": [\n", size);
  for(iZon = 0; iZon < bui->nZon; iZon++){
    /* Write zone name */
    ModelicaFormatMessage("Writing zone data %s.", zones[iZon]->name);
    saveAppend(buffer, "        { \"name\": \"", size);
    saveAppend(buffer, zones[iZon]->name, size);
    if (iZon < (bui->nZon) - 1)
      saveAppend(buffer, "\" },\n", size);
    else
      saveAppend(buffer, "\" }\n", size);
  }
  /* Close json array */
  saveAppend(buffer, "    ]\n  }\n}\n", size);
  return;
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

void setValueReference(
  const char* fmuNam,
  fmi2_import_variable_list_t* varLis,
  const fmi2_value_reference_t varValRef[],
  size_t nVar,
  fmi2Byte** modNames,
  const size_t nNam,
  fmi2ValueReference** modValRef){

  size_t iMod;
  size_t iFMI;
  fmi2_import_variable_t* fmiVar;
  fmi2_value_reference_t vr;
  fmi2_import_variable_t* var;

  for (iMod = 0; iMod < nNam; iMod++){
    for (iFMI = 0; iFMI < nVar; iFMI++){
      var = fmi2_import_get_variable(varLis, iFMI);
      if (strcmp(modNames[iMod], fmi2_import_get_variable_name(var)) == 0){
        /* Found the variable */
        (*modValRef)[iMod] = varValRef[iFMI];
        break;
      }
    }
    if (iFMI == nVar){
      ModelicaFormatError("Failed to find variable %s in %s.", modNames[iMod], fmuNam);
      }
    }
 }


void setValueReferences(FMUBuilding* fmuBui){
  size_t i;
  size_t iZon;
  size_t vr;
  FMUZone* zone;

  fmi2_import_variable_list_t* vl = fmi2_import_get_variable_list(fmuBui->fmu, 0);
  const fmi2_value_reference_t* vrl = fmi2_import_get_value_referece_list(vl);
  size_t nv = fmi2_import_get_variable_list_size(vl);

  writeLog(3, "Searching for variable reference.");
  /* Set value references for the parameters by assigning the values obtained from the FMU */
  for(iZon = 0; iZon < fmuBui->nZon; iZon++){
    zone = (FMUZone*) fmuBui->zones[iZon];
    setValueReference(
      fmuBui->fmuAbsPat,
      vl, vrl, nv,
      zone->parameterVariableNames,
      ZONE_N_PAR,
      &(zone->parameterValueReferences));
   setValueReference(
      fmuBui->fmuAbsPat,
      vl, vrl, nv,
      zone->inputVariableNames,
      ZONE_N_INP,
      &(zone->inputValueReferences));
   setValueReference(
     fmuBui->fmuAbsPat,
     vl, vrl, nv,
     zone->outputVariableNames,
     ZONE_N_OUT,
     &(zone->outputValueReferences));
  }
  fmi2_import_free_variable_list(vl);
  return;
}

void generateFMU(const char* FMUPath){
  /* Generate the FMU */
  const char* cmd = "cp -p ";
  const char* testFMU = "Buildings/Resources/src/EnergyPlus/FMUs/SingleZone.fmu";
  char* fulCmd;
  size_t len;
  int retVal;
  writeLog(3, "Entered generateFMU.");

  len = strlen(cmd) + strlen(FMUPath) + 1 + strlen(testFMU) + 1;
  fulCmd = malloc(len * sizeof(char));
  if (fulCmd == NULL){
    ModelicaFormatError("Failed to allocate memory in generateFMU().");
  }
  memset(fulCmd, '\0', len);
  strcpy(fulCmd, cmd);
  strcat(fulCmd, testFMU);
  strcat(fulCmd, " ");
  strcat(fulCmd, FMUPath);
  /* Generate the FMU */
  retVal = system(fulCmd);
  if (retVal != 0){
    ModelicaFormatError("Generating FMU failed using command '%s'.", fulCmd);
  }
  free(fulCmd);
}

void FMUZoneAllocateAndInstantiateBuilding(FMUBuilding* bui){
  /* This is the first call for this idf file.
     Allocate memory and load the fmu.
  */
  const char* FMUPath;
	const char* tmpPath = bui->tmpDir;
  const fmi2Boolean visible = fmi2False;

  /* fmi2_import_model_counts_t  mc; */
  fmi2_callback_functions_t callBackFunctions;
  jm_callbacks* callbacks;
  fmi_version_enu_t version;
  fmi2_fmu_kind_enu_t fmukind;
	jm_status_enu_t jm_status;
  int ret;

  writeLog(3, "Entered FMUZoneAllocateAndInstantiateBuilding.");

  FMUPath = bui->fmuAbsPat;
  generateFMU(FMUPath);

  if( access( FMUPath, F_OK ) == -1 ) {
    ModelicaFormatError("Requested to load fmu '%s' which does not exist.", FMUPath);
  }
  /* Write the model structure to the FMU Resources folder so that EnergyPlus can
     read it and set up the data structure.
  */
  writeModelStructureForEnergyPlus(bui);

  /* Set callback functions */
  callbacks = jm_get_default_callbacks();

  bui->context = fmi_import_allocate_context(callbacks);

  writeLog(3, "Getting fmi version.");
  version = fmi_import_get_fmi_version(bui->context, FMUPath, tmpPath);

  if (version != fmi_version_2_0_enu){
    ModelicaFormatError("Wrong FMU version for %s, require FMI 2.0 for Model Exchange, received %s.", FMUPath, fmi_version_to_string(version));
  }

  writeLog(3, "Parsing xml file.");
  bui->fmu = fmi2_import_parse_xml(bui->context, tmpPath, 0);

	if(!bui->fmu) {
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

  /* Get model statistics
  fmi2_import_collect_model_counts(bui->fmu, &mc);
  printf("*** Number of discrete variables %u.\n", mc.num_discrete);
 */
  callBackFunctions.logger = fmi2_log_forwarding; /* fmilogger; */
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
  	ModelicaFormatError("Could not create the DLL loading mechanism (C-API) for %s.", FMUPath);
  }
  else{
    bui->dllfmu_created = fmi2_true;
  }

  writeLog(3, "Instantiating fmu.");

  /* Instantiate EnergyPlus */
  jm_status = fmi2_import_instantiate(bui->fmu, bui->name, fmi2_model_exchange, NULL, visible);

  writeLog(3, "Returned from instantiating fmu.");
  if(jm_status == jm_status_error){
    ModelicaFormatError("Failed to instantiate building FMU with name %s.",  bui->name);
  }
  /* Set the value references for all parameters, inputs and outputs */
  setValueReferences(bui);

  return;
}

fmi2Status do_event_iteration(fmi2_import_t *fmu, fmi2_event_info_t *eventInfo){
  size_t i = 0;
  const size_t nMax = 50;
  fmi2Status status;

  eventInfo->newDiscreteStatesNeeded = fmi2_true;
  eventInfo->terminateSimulation     = fmi2_false;
  while (eventInfo->newDiscreteStatesNeeded && !eventInfo->terminateSimulation && i < nMax) {
    i++;
    status = fmi2_import_new_discrete_states(fmu, eventInfo);
  }
  if (eventInfo->terminateSimulation){
    ModelicaFormatError("FMU requested to terminate the simulation.");
  }
  if (i == nMax){
    ModelicaFormatError("Did not converge during event iteration.");
  }
  return status;
}
/* This function is called for each zone in the 'initial equation section'
*/
void FMUZoneInstantiate(void* object, double startTime, double* AFlo, double* V, double* mSenFac){
  fmi2_status_t status;
  FMUZone* zone = (FMUZone*) object;

  double outputValues[ZONE_N_OUT];

  writeLog(3, "Entered FMUZoneInstantiate.");

  if (zone->ptrBui->fmu == NULL){
    /* EnergyPlus is not yet loaded.
       This section is only executed once if the 'initial equation' section is called multiple times.
    */

    /* Instantiate the FMU for this building */
    FMUZoneAllocateAndInstantiateBuilding(zone->ptrBui);

    writeLog(3, "Setting debug logging.");
  	status = fmi2_import_set_debug_logging(
        zone->ptrBui->fmu,
        fmi2_true, /* Logging on */
        0, /* nCategories */
        0); /* Which categories to log */
    if( status != fmi2_status_ok ){
      ModelicaFormatError("Failed to set debug logging for FMU with name %s.",  zone->ptrBui->fmuAbsPat);
    }


    writeLog(3, "Setting up experiment.");
    /* This function can only be called once per building FMU */
    status = fmi2_import_setup_experiment(
        zone->ptrBui->fmu,    /* fmu */
        fmi2False,            /* toleranceDefined */
        0.0,                  /* tolerance */
        startTime,            /* startTime */
        fmi2False,            /* stopTimeDefined */
        0);                   /* stopTime */
    writeLog(3, "Returned from setup_experiment.");
    if( status != fmi2_status_ok ){
      ModelicaFormatError("Failed to setup experiment for FMU with name %s.",  zone->ptrBui->fmuAbsPat);
    }
  }
    writeLog(0, "Getting parameters.");

    getParametersFromEnergyPlus(zone, outputValues);

   /* Obtain the floor area and the volume of the zone */
    *V = outputValues[0];
    *AFlo = outputValues[1];
    *mSenFac = outputValues[2];

  /* Set flag to indicate that this zone has been properly initialized */
  zone->isInstantiated = fmi2True;

}
