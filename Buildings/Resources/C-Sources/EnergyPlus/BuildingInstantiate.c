/*
 * Modelica external function to intialize EnergyPlus.
 *
 * Michael Wetter, LBNL                  3/1/2018
 * Thierry S. Nouidui, LBNL              3/23/2018
 */

#include "BuildingInstantiate.h"
#include "EnergyPlusStructure.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

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
/*    setValueReference(
      fmuBui->fmuAbsPat,
      vl, vrl, nv,
      zone->parInpVarNames,
      ZONE_N_PAR_INP,
      &(zone->parInpValReferences));
*/
    setValueReference(
      fmuBui->fmuAbsPat,
      vl, vrl, nv,
      zone->parOutVarNames,
      ZONE_N_PAR_OUT,
      &(zone->parOutValReferences));
   setValueReference(
      fmuBui->fmuAbsPat,
      vl, vrl, nv,
      zone->inpVarNames,
      ZONE_N_INP,
      &(zone->inpValReferences));
   setValueReference(
     fmuBui->fmuAbsPat,
     vl, vrl, nv,
     zone->outVarNames,
     ZONE_N_OUT,
     &(zone->outValReferences));
  }
  fmi2_import_free_variable_list(vl);
  return;
}

void generateFMU(const char* FMUPath){
  /* Generate the FMU */
  const char* cmd = "cp -p ";
  const char* testFMU = "Buildings/Resources/src/EnergyPlus/FMUs/TwoZones.fmu";
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

void setEnergyPlusDebugLevel(FMUBuilding* bui){
    fmi2Status status;

    writeLog(3, "Setting debug logging.");
  	status = fmi2_import_set_debug_logging(
        bui->fmu,
        fmi2_true, /* Logging on */
        0, /* nCategories */
        0); /* Which categories to log */
    if( status != fmi2_status_ok ){
      ModelicaFormatError("Failed to set debug logging for FMU with name %s.",  bui->fmuAbsPat);
    }
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

    /* Set callback functions */
  callbacks = jm_get_default_callbacks();

  bui->context = fmi_import_allocate_context(callbacks);

  writeLog(3, "Getting fmi version.");
  version = fmi_import_get_fmi_version(bui->context, FMUPath, tmpPath);

  if (version != fmi_version_2_0_enu){
    ModelicaFormatError("Wrong FMU version for %s, require FMI 2.0 for Model Exchange, received %s.",
    FMUPath, fmi_version_to_string(version));
  }

  writeLog(3, "Parsing xml file.");
  bui->fmu = fmi2_import_parse_xml(bui->context, tmpPath, 0);
	if(!bui->fmu) {
		ModelicaFormatError("Error parsing XML for %s.", FMUPath);
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
}

void generateAndInstantiateBuilding(FMUBuilding* bui){
  /* This is the first call for this idf file.
     Allocate memory and load the fmu.
  */

  writeLog(3, "Entered ZoneAllocateAndInstantiateBuilding.");

  generateFMU(bui->fmuAbsPat);

  if( access( bui->fmuAbsPat, F_OK ) == -1 ) {
    ModelicaFormatError("Requested to load fmu '%s' which does not exist.", bui->fmuAbsPat);
  }
  /* Write the model structure to the FMU Resources folder so that EnergyPlus can
     read it and set up the data structure.
  */
  writeModelStructureForEnergyPlus(bui);
  importEnergyPlusFMU(bui);
  setEnergyPlusDebugLevel(bui);
  /* Set the value references for all parameters, inputs and outputs */
  setValueReferences(bui);

  return;
}
