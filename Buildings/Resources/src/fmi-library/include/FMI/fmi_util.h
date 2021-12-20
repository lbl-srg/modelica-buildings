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

#ifndef FMI_UTIL_H
#define FMI_UTIL_H
#include <fmilib_config.h>
#include <JM/jm_callbacks.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
	@file fmi_util.h 
	\brief Some low-level utility functions suitable for all standards.

	*/
/** \addtogroup jm_utils
  * @{
*/
/** \brief Given directory name fmu_unzipped_path and construct the directory path for Dll/so
	\param fmu_unzipped_path Directory name where FMU is unpacked.
	\param callbacks Callbacks for memory allocation.
	@return Pointer to a string with the directory name (last symbol is directory separator). Caller is responsible for freeing the memory.
*/
FMILIB_EXPORT char* fmi_construct_dll_dir_name(jm_callbacks* callbacks, const char* fmu_unzipped_path);

/** \brief Given model_identifier construct the dll/so name by adding platform suffix
	\param callbacks Callbacks for memory allocation.
	\param dll_dir_name Directory path for Dll/so as returned by fmi_construct_dll_dir_name
	\param model_identifier The FMU model identifier.
	@return Pointer to a string with the file name. Caller is responsible for freeing the memory.
*/
FMILIB_EXPORT char* fmi_construct_dll_file_name(jm_callbacks* callbacks, const char* dll_dir_name, const char* model_identifier);

/** @} */
#ifdef __cplusplus
}
#endif

/* FMI_UTIL_H */
#endif
