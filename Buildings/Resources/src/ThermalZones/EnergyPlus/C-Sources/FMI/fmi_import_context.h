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


/** \file fmi_import_context.h
*  \brief Import context is the entry point to the library. It is used to initialize, unzip, get FMI version and start parsing.
*/

#ifndef FMI_IMPORT_CONTEXT_H_
#define FMI_IMPORT_CONTEXT_H_

#include <stddef.h>
#include <fmilib_config.h>
#include <JM/jm_callbacks.h>
#include <FMI2/fmi2_xml_callbacks.h>
#include <FMI/fmi_version.h> 
#include <FMI1/fmi1_types.h>
#include <FMI1/fmi1_enums.h>
#include <FMI2/fmi2_types.h>
#include <FMI2/fmi2_enums.h>

#ifdef __cplusplus
extern "C" {
#endif

	
/** 
\addtogroup fmi_import FMI import library
@{
\addtogroup fmi_import_context Library initialization
Interaction with an FMU by means of the FMI Library starts with allocation of 
an ::fmi_import_context_t structure. This is done with a call to fmi_import_allocate_context().
The next step is detection of FMI standard used in the specific FMU. This is achieved by
calling fmi_import_get_fmi_version() function. When the standard is known a standard
specific function for processing model description XML should be called to create an
opaque FMU structure. This is done by calling either fmi1_import_parse_xml() or fmi2_import_parse_xml().
With the FMU structure available one can proceed by loading the FMU binary 
(fmi1_import_create_dllfmu() or fmi2_import_create_dllfmu()). After that 
the code is able to interact with the FMU by means of the methonds presented 
in \ref fmi1_import_capi and \ref fmi2_import_capi.

\addtogroup  fmi1_import
\addtogroup  fmi2_import
\addtogroup  fmi_import_utils
@}
\addtogroup fmi_import_context
@{
*/

/** \brief FMI version independent library context. 
	Opaque struct returned from fmi_import_allocate_context()
*/
typedef struct fmi_xml_context_t fmi_import_context_t ;

/** \brief Create fmi_import_context_t structure.
	@param callbacks - a pointer to the library callbacks for memory management and logging. May be NULL if defaults are utilized.
	@return A new structure if memory allocation was successful.
*/
FMILIB_EXPORT fmi_import_context_t* fmi_import_allocate_context( jm_callbacks* callbacks);

/**
	\brief Free memory allocated for the library context.
	@param c - library context allocated by fmi_import_allocate_context()
*/
FMILIB_EXPORT void fmi_import_free_context( fmi_import_context_t* c);

/**
    \brief If this configuration option is set, the model description will be
    checked to follow the variable naming conventions. Variables not following
    the convention will be logged.
*/
#define FMI_IMPORT_NAME_CHECK 1

/**
    \brief Sets advanced configuration, if zero is passed default configuration
    is set. Currently only one non default configuration is available:
    FMI_IMPORT_XML_NAME_CHECK.
    @param conf - specifies the configuration to use
*/
FMILIB_EXPORT void fmi_import_set_configuration( fmi_import_context_t* c, int conf);

/**
	\brief Unzip an FMU specified by the fileName into directory dirName and parse XML to get FMI standard version.
	@param c - library context.
	@param fileName - an FMU file name.
	@param dirName - a directory name where the FMU should be unpacked
*/
FMILIB_EXPORT fmi_version_enu_t fmi_import_get_fmi_version( fmi_import_context_t* c, const char* fileName, const char* dirName);

/**
	\brief FMU version 1.0 object
*/
typedef struct fmi1_import_t fmi1_import_t;

/**
	\brief FMU version 2.0 object
*/
typedef struct fmi2_import_t fmi2_import_t;

/**
	\brief Parse FMI 1.0 XML file found in the directory dirName.
	\param c - library context.
	\param dirName - a directory where the FMU was unpacked and XML file is present.
	\return fmi1_import_t:: opaque object pointer
*/
FMILIB_EXPORT fmi1_import_t* fmi1_import_parse_xml( fmi_import_context_t* c, const char* dirName);

/**
    \brief Create ::fmi2_import_t structure and parse the FMI 2.0 XML file found in the directory dirName.
	\param context - library context.
	\param dirPath - a directory where the FMU was unpacked and XML file is present.
	\param xml_callbacks Callbacks to use for processing of annotations (may be NULL).
	\return fmi2_import_t:: opaque object pointer
*/
FMILIB_EXPORT fmi2_import_t* fmi2_import_parse_xml( fmi_import_context_t* context, const char* dirPath, fmi2_xml_callbacks_t* xml_callbacks);

/** 
@}
*/

#ifdef __cplusplus
}
#endif
#endif
