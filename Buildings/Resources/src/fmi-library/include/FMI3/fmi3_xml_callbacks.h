/*
    Copyright (C) 2023 Modelon AB

    This program is free software: you can redistribute it and/or modify
    it under the terms of the BSD style license.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    FMILIB_License.txt file for more details.

    You should have received a copy of the FMILIB_License.txt file
    along with this program. If not, contact Modelon AB <http://www.modelon.com>.
*/

#ifndef FMI3_XML_CALLBACKS_H
#define FMI3_XML_CALLBACKS_H

#include <fmilib_config.h>

#ifdef __cplusplus
extern "C" {
#endif
/** \file fmi3_xml_callbacks.h Definition of ::fmi3_xml_callbacks_t and supporting functions
    *
    * \addtogroup fmi3_utils
    * @{
        \addtogroup fmi3_xml_callbacks
    * @}
*/
/** \addtogroup fmi3_xml_callbacks Definition of XML callbacks struct
* @{  */
typedef struct fmi3_xml_callbacks_t fmi3_xml_callbacks_t;

/** \name XML handling callbacks
* @{ 
*/
/** \brief Handle start of an XML element within tool annotation in a SAX parser.
*
*   @param context as specified when setting up the callbacks,
*   @param parentName - tool name as given by name attibute to the Tool elelent,
*   @param parent - NULL for model level annotations; fmi3_import_variable_t * variable pointer for variable annotations. 
*   @param elm - name of the element, 
*   @param attr - attributes (names and values).
*  The function should return 0 on success or error code on exit (in which case parsing will be aborted).
*/
typedef int (*fmi3_xml_element_start_handle_ft)(void* context, const char *toolName, void* parent, const char *elm, const char **attr);

/** \brief Handle data of an XML element within tool annotation in a SAX parser.
*
*  @param context as specified when setting up the callbacks
*  @param s - data string
*  @param len - length of the data.
*  The function should return 0 on success or error code on exit (in which case parsing will be aborted).
*/
typedef int (*fmi3_xml_element_data_handle_ft)(void* context, const char *s, int len);

/** \brief Handle end of an XML element within tool annotation in a SAX parser.
*
*  @param context as specified when setting up the callbacks
*  @param elm - name of the element.
*  The function should return 0 on success or error code on exit (in which case parsing will be aborted).
*/
typedef int (*fmi3_xml_element_end_handle_ft)(void* context, const char *elm);

/** \brief XML callbacks are used to process parts of XML that are not handled by the library */
struct fmi3_xml_callbacks_t {
    fmi3_xml_element_start_handle_ft startHandle; /** \brief Handle start of an XML element within tool annotation in a SAX parser. */
    fmi3_xml_element_data_handle_ft  dataHandle;  /** \brief Handle data of an XML element within tool annotation in a SAX parser.  */
    fmi3_xml_element_end_handle_ft   endHandle;   /** \brief Handle end of an XML element within tool annotation in a SAX parser. */
    void* context;    /** \brief Context ponter is forwarded to the handle functions. */
};

/** \addtogroup fmi3_xml_callbacks Definition of XML callbacks struct
* @{  */
typedef struct fmi_termicon_xml_callbacks_t fmi_termicon_xml_callbacks_t;

/** \name XML handling callbacks
* @{ 
*/
/** \brief Handle start of an XML element within tool annotation in a SAX parser.
*
*   @param context as specified when setting up the callbacks,
*   @param parentName - tool name as given by name attibute to the Tool elelent,
*   @param parent - NULL for model level annotations; fmi3_import_variable_t * variable pointer for variable annotations. 
*   @param elm - name of the element, 
*   @param attr - attributes (names and values).
*  The function should return 0 on success or error code on exit (in which case parsing will be aborted).
*/
typedef int (*fmi_termicon_xml_element_start_handle_ft)(void* context, const char *toolName, void* parent, const char *elm, const char **attr);

/** \brief Handle data of an XML element within tool annotation in a SAX parser.
*
*  @param context as specified when setting up the callbacks
*  @param s - data string
*  @param len - length of the data.
*  The function should return 0 on success or error code on exit (in which case parsing will be aborted).
*/
typedef int (*fmi_termicon_xml_element_data_handle_ft)(void* context, const char *s, int len);

/** \brief Handle end of an XML element within tool annotation in a SAX parser.
*
*  @param context as specified when setting up the callbacks
*  @param elm - name of the element.
*  The function should return 0 on success or error code on exit (in which case parsing will be aborted).
*/
typedef int (*fmi_termicon_xml_element_end_handle_ft)(void* context, const char *elm);

/** \brief XML callbacks are used to process parts of XML that are not handled by the library */
struct fmi_termicon_xml_callbacks_t {
    fmi_termicon_xml_element_start_handle_ft startHandle; /** \brief Handle start of an XML element within tool annotation in a SAX parser. */
    fmi_termicon_xml_element_data_handle_ft  dataHandle;  /** \brief Handle data of an XML element within tool annotation in a SAX parser.  */
    fmi_termicon_xml_element_end_handle_ft   endHandle;   /** \brief Handle end of an XML element within tool annotation in a SAX parser. */
    void* context;    /** \brief Context ponter is forwarded to the handle functions. */
};

/** @} 
*  @}
*/

#ifdef __cplusplus
}
#endif
/* JM_CONTEXT_H */
#endif
