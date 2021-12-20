/*
    Copyright (C) 2012 Modelon AB

    This program is free software: you can redistribute it and/or modify
    it under the terms of the BSD style license.

     This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    FMILIB_License.txt file for more details.

    You should have received a copy of the FMILIB_License.txt file
    along with this program. If not, contact Modelon AB <http://www.modelon.com>.
*/

#ifndef FMI1_IMPORT_UTIL_H_
#define FMI1_IMPORT_UTIL_H_

#include <JM/jm_callbacks.h>

#ifdef __cplusplus
extern "C" {
#endif
/**
\addtogroup  fmi_import_utils Utility functions supporting interactions with the library
@{
*/
/** 
	\brief Create a unique temporary directory
	\param cb - callbacks for memory allocation and logging. Default callbacks are used if this parameter is NULL.
	\param systemTempDir - directory where the temp dir should be located both absolute and relative path are accepted.
				System-wide directory is used if this parameter is NULL.
	\param tempPrefix - File name template prefix used when creating temporaty directories. "fmil" is used if this is NULL.
	\return A pointer to the temporary directory name (absolute path, no terminating '/'). Caller is responsible for freeing the memory.
		The function returns NULL if there were errors in which case a message is send to the logger.	
*/
FMILIB_EXPORT char* fmi_import_mk_temp_dir(jm_callbacks* cb, const char* systemTempDir, const char* tempPrefix);

/**
\brief Remove directory and all it contents.
	\param cb - callbacks for memory allocation and logging. Default callbacks are used if this parameter is NULL.
	\param dir - path to be removed.
	\return Statuc success or error.
*/
FMILIB_EXPORT jm_status_enu_t fmi_import_rmdir(jm_callbacks* cb, const char* dir);

/** 
	\brief Create a file:// URL from absolute path
	\param cb - callbacks for memory allocation and logging. Default callbacks are used if this parameter is NULL.
	\param absPath - absolute path to be converted into the URL
	\return A pointer to the URL. Caller is responsible for freeing the memory.
		The function returns NULL if there were errors in which case a message is send to the logger.	
*/
FMILIB_EXPORT char* fmi_import_create_URL_from_abs_path(jm_callbacks* cb, const char* absPath);

/** Given directory name fmu_unzipped_path and model identifier consturct Dll/so name
	@return Pointer to a string with the file name. Caller is responsible for freeing the memory.
*/
FMILIB_EXPORT char* fmi_import_get_dll_path(const char* fmu_unzipped_path, const char* model_identifier, jm_callbacks* callBackFunctions);

/** Given directory name fmu_unzipped_path and model identifier consturct XML file name
	@return Pointer to a string with the file name. Caller is responsible for freeing the memory.
*/
FMILIB_EXPORT char* fmi_import_get_model_description_path(const char* fmu_unzipped_path, jm_callbacks* callBackFunctions);
/**
@}
@}
*/
#ifdef __cplusplus
}
#endif

#endif /* End of header file FMI1_IMPORT_UTIL_H_ */