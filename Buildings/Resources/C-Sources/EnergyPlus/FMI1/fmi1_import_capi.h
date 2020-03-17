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

#ifndef FMI1_IMPORT_CAPI_H_
#define FMI1_IMPORT_CAPI_H_

#ifdef __cplusplus
extern "C" {
#endif

#include <JM/jm_callbacks.h>
#include <FMI/fmi_import_util.h>
#include <FMI/fmi_import_context.h>
/* #include <FMI1/fmi1_xml_model_description.h>*/

#include <FMI1/fmi1_types.h>
#include <FMI1/fmi1_functions.h>
#include <FMI1/fmi1_enums.h>
/* #include <FMI1/fmi1_capi.h> */

/**
\file fmi1_import_capi.h
Wrapper functions for the FMI 1.0 functions
*/

/**
 * \addtogroup fmi1_import_capi
 * @{
 */

/**	\addtogroup fmi1_import_capi_const_destroy FMI 1.0 Constructor and Destructor	
 * \brief Functions for instantiating and freeing the container of the struct that is responsible for the FMI functions.
 *
 *	Before any of the FMI functions may be called, the construction function must instantiate a fmi_import_t module.
 *	After the fmi_import_t module has been succesfully instantiated, all the FMI functions can be called. To unload
 *	the FMI functions, the destroy functions shall be called.
 *
 * 	\addtogroup fmi1_import_capi_me FMI 1.0 (ME) Model Exchange functions
 * \brief List of Model Exchange wrapper functions. Common functions are not listed.
 *	\addtogroup fmi1_import_capi_cs FMI 1.0 (CS) Co-Simulation functions 
 * \brief List of Co-Simulation wrapper functions. Common functions are not listed.
 *	\addtogroup fmi1_import_capi_common FMI 1.0 (ME & CS) Common functions
 * \brief List of wrapper functions that are in common for both Model Exchange and Co-Simulation.
 */

/**
 * \addtogroup fmi1_import_capi_const_destroy
 * @{
 */

/**
 * \brief Create a C-API struct. The C-API struct is a placeholder for the FMI DLL functions.
 *
 * This function may only be called once if it returned succesfully. fmi1_import_destroy_dllfmu 
 * must be called before this function can be called again. 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml().
 * @param callBackFunctions Callback functions used by the FMI functions internally.
 * @param registerGlobally Register the FMU globally to enable use of fmi1_log_forwarding(). If this parameter is non-zero the code becomes non-thread safe.
 * @return Error status. If the function returns with an error, it is not allowed to call any of the other C-API functions.
 */
FMILIB_EXPORT jm_status_enu_t fmi1_import_create_dllfmu(fmi1_import_t* fmu, fmi1_callback_functions_t callBackFunctions, int registerGlobally);

/** \brief Free a C-API struct. All memory allocated since the struct was created is freed.
 * 
 * @param fmu A model description object returned from fmi1_import_parse_xml().
 */
FMILIB_EXPORT void fmi1_import_destroy_dllfmu(fmi1_import_t* fmu);

/**
 * \brief Set CAPI debug mode flag. Setting to non-zero prevents DLL unloading in fmi1_import_destroy_dllfmu
 *  while all the memory is deallocated. This is to support valgrind debugging. 
 * 
 * @param fmu C-API struct that has succesfully loaded the FMI function.
 * @param mode The debug mode to set.
 */
FMILIB_EXPORT void fmi1_import_set_debug_mode(fmi1_import_t* fmu, int mode);

/**@} */

/**
 * \addtogroup fmi1_import_capi_common
 * @{
 */

/**
 * \brief Wrapper for the FMI function fmiGetVersion() 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @return FMI version.
 */
FMILIB_EXPORT const char* fmi1_import_get_version(fmi1_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiSetDebugLogging(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param loggingOn Enable or disable the debug logger.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_set_debug_logging(fmi1_import_t* fmu, fmi1_boolean_t loggingOn);

/**
 * \brief Wrapper for the FMI function fmiSetReal(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value Array of variable values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_set_real(fmi1_import_t* fmu, const fmi1_value_reference_t vr[], size_t nvr, const fmi1_real_t    value[]);

/**
 * \brief Wrapper for the FMI function fmiSetInteger(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value Array of variable values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_set_integer(fmi1_import_t* fmu, const fmi1_value_reference_t vr[], size_t nvr, const fmi1_integer_t value[]);

/**
 * \brief Wrapper for the FMI function fmiSetBoolean(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value Array of variable values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_set_boolean(fmi1_import_t* fmu, const fmi1_value_reference_t vr[], size_t nvr, const fmi1_boolean_t value[]);

/**
 * \brief Wrapper for the FMI function fmiSetString(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value Array of variable values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_set_string(fmi1_import_t* fmu, const fmi1_value_reference_t vr[], size_t nvr, const fmi1_string_t  value[]);


/**
 * \brief Wrapper for the FMI function fmiGetReal(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value (Output)Array of variable values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_get_real(fmi1_import_t* fmu, const fmi1_value_reference_t vr[], size_t nvr, fmi1_real_t    value[]);

/**
 * \brief Wrapper for the FMI function fmiGetInteger(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value (Output)Array of variable values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_get_integer(fmi1_import_t* fmu, const fmi1_value_reference_t vr[], size_t nvr, fmi1_integer_t value[]);

/**
 * \brief Wrapper for the FMI function fmiGetBoolean(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value (Output)Array of variable values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_get_boolean(fmi1_import_t* fmu, const fmi1_value_reference_t vr[], size_t nvr, fmi1_boolean_t value[]);

/**
 * \brief Wrapper for the FMI function fmiGetString(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value (Output)Array of variable values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_get_string(fmi1_import_t* fmu, const fmi1_value_reference_t vr[], size_t nvr, fmi1_string_t  value[]);

/**@} */

/**
 * \addtogroup fmi1_import_capi_me
 * @{
 */

/**
 * \brief Wrapper for the FMI function fmiGetModelTypesPlatform(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @return The platform the FMU was compiled for.
 */
FMILIB_EXPORT const char* fmi1_import_get_model_types_platform(fmi1_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiInstantiateModel(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param instanceName The name of the instance.
 * @return Error status. Returnes jm_status_error if fmiInstantiateModel returned NULL, otherwise jm_status_success.
 */
FMILIB_EXPORT jm_status_enu_t fmi1_import_instantiate_model(fmi1_import_t* fmu, fmi1_string_t instanceName);

/**
 * \brief Wrapper for the FMI function fmiFreeModelInstance(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 */
FMILIB_EXPORT void fmi1_import_free_model_instance(fmi1_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiSetTime(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param time Set the current time.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_set_time(fmi1_import_t* fmu, fmi1_real_t time);

/**
 * \brief Wrapper for the FMI function fmiSetContinuousStates(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param x Array of state values.
 * @param nx Number of states.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_set_continuous_states(fmi1_import_t* fmu, const fmi1_real_t x[], size_t nx);

/**
 * \brief Wrapper for the FMI function fmiCompletedIntegratorStep(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param callEventUpdate (Output) Call fmiEventUpdate indicator.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_completed_integrator_step(fmi1_import_t* fmu, fmi1_boolean_t* callEventUpdate);

/**
 * \brief Wrapper for the FMI function fmiInitialize(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param toleranceControlled Enable or disable the use of relativeTolerance in the FMU.
 * @param relativeTolerance A relative tolerance used in the FMU.
 * @param eventInfo (Output) fmiEventInfo struct.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_initialize(fmi1_import_t* fmu, fmi1_boolean_t toleranceControlled, fmi1_real_t relativeTolerance, fmi1_event_info_t* eventInfo);

/**
 * \brief Wrapper for the FMI function fmiGetDerivatives(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param derivatives (Output) Array of the derivatives.
 * @param nx Number of derivatives.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_get_derivatives(fmi1_import_t* fmu, fmi1_real_t derivatives[], size_t nx);

/**
 * \brief Wrapper for the FMI function fmiGetEventIndicators(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param eventIndicators (Output) The event indicators.
 * @param ni Number of event indicators.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_get_event_indicators(fmi1_import_t* fmu, fmi1_real_t eventIndicators[], size_t ni);

/**
 * \brief Wrapper for the FMI function fmiEventUpdate(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param intermediateResults Indicate whether or not the fmiEventUpdate shall return after every internal event interation.
 * @param eventInfo (Output) An fmiEventInfo struct.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_eventUpdate(fmi1_import_t* fmu, fmi1_boolean_t intermediateResults, fmi1_event_info_t* eventInfo);

/**
 * \brief Wrapper for the FMI function fmiGetContinuousStates(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param states (Output) Array of state values.
 * @param nx Number of states.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_get_continuous_states(fmi1_import_t* fmu, fmi1_real_t states[], size_t nx);

/**
 * \brief Wrapper for the FMI function fmiGetNominalContinuousStates(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param x_nominal (Output) The nominal values.
 * @param nx Number of nominal values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_get_nominal_continuous_states(fmi1_import_t* fmu, fmi1_real_t x_nominal[], size_t nx);

/**
 * \brief Wrapper for the FMI function fmiGetStateValueReferences(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param vrx (Output) The value-references of the states.
 * @param nx Number of value-references.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_get_state_value_references(fmi1_import_t* fmu, fmi1_value_reference_t vrx[], size_t nx);

/**
 * \brief Wrapper for the FMI function fmiTerminate(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_terminate(fmi1_import_t* fmu);

/**@} */

/**
 * \addtogroup fmi1_import_capi_cs
 * @{
 */

/**
 * \brief Wrapper for the FMI function fmiGetTypesPlatform(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @return The platform the FMU was compiled for.
 */
FMILIB_EXPORT const char* fmi1_import_get_types_platform(fmi1_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiInstantiateSlave(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param instanceName The name of the instance.
 * @param fmuLocation Access path to the FMU archive. If null FMU will get the path to the directory where it was unpacked.
 * @param mimeType MIME type. If NULL the FMU will get "application/x-fmu-sharedlibrary".
 * @param timeout Communication timeout value in milli-seconds.
 * @param visible Indicates whether or not the simulator application window shoule be visible.
 * @param interactive Indicates whether the simulator application must be manually started by the user.
 * @return Error status. Returnes jm_status_error if fmiInstantiateSlave returned NULL, otherwise jm_status_success.
 */
FMILIB_EXPORT jm_status_enu_t fmi1_import_instantiate_slave(fmi1_import_t* fmu, fmi1_string_t instanceName, fmi1_string_t fmuLocation, fmi1_string_t mimeType,
																 fmi1_real_t timeout, fmi1_boolean_t visible, fmi1_boolean_t interactive);

/**
 * \brief Wrapper for the FMI function fmiInitializeSlave(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param tStart Start time of the simulation
 * @param StopTimeDefined Indicates whether or not the stop time is used.
 * @param tStop The stop time of the simulation.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_initialize_slave(fmi1_import_t* fmu, fmi1_real_t tStart, fmi1_boolean_t StopTimeDefined, fmi1_real_t tStop);

/**
 * \brief Wrapper for the FMI function fmiTerminateSlave(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_terminate_slave(fmi1_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiResetSlave(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_reset_slave(fmi1_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiFreeSlaveInstance(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 */
FMILIB_EXPORT void fmi1_import_free_slave_instance(fmi1_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiSetRealInputDerivatives(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param order	Array of derivative orders.
 * @param value Array of variable values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_set_real_input_derivatives(fmi1_import_t* fmu, const fmi1_value_reference_t vr[], size_t nvr, const fmi1_integer_t order[], const  fmi1_real_t value[]);                                                  

/**
 * \brief Wrapper for the FMI function fmiGetOutputDerivatives(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param order	Array of derivative orders.
 * @param value (Output) Array of variable values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_get_real_output_derivatives(fmi1_import_t* fmu, const fmi1_value_reference_t vr[], size_t nvr, const fmi1_integer_t order[], fmi1_real_t value[]);                                              

/**
 * \brief Wrapper for the FMI function fmiCancelStep(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_cancel_step(fmi1_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiDoStep(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param currentCommunicationPoint Current communication point of the master.
 * @param communicationStepSize Communication step size.
 * @param newStep Indicates whether or not the last communication step was accepted by the master.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_do_step(fmi1_import_t* fmu, fmi1_real_t currentCommunicationPoint, fmi1_real_t communicationStepSize, fmi1_boolean_t newStep);

/**
 * \brief Wrapper for the FMI function fmiGetStatus(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param s Kind of status to return the value for.
 * @param value (Output) FMI status value.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_get_status(fmi1_import_t* fmu, const fmi1_status_kind_t s, fmi1_status_t*  value);

/**
 * \brief Wrapper for the FMI function fmiGetRealStatus(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param s Kind of status to return the value for.
 * @param value (Output) FMI real value.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_get_real_status(fmi1_import_t* fmu, const fmi1_status_kind_t s, fmi1_real_t*    value);

/**
 * \brief Wrapper for the FMI function fmiGetIntegerStatus(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param s Kind of status to return the value for.
 * @param value (Output) FMI integer value.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_get_integer_status(fmi1_import_t* fmu, const fmi1_status_kind_t s, fmi1_integer_t* value);

/**
 * \brief Wrapper for the FMI function fmiGetBooleanStatus(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param s Kind of status to return the value for.
 * @param value (Output) FMI boolean value.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_get_boolean_status(fmi1_import_t* fmu, const fmi1_status_kind_t s, fmi1_boolean_t* value);

/**
 * \brief Wrapper for the FMI function fmiGetStringStatus(...) 
 * 
 * @param fmu A model description object returned by fmi1_import_parse_xml() that has loaded the FMI functions, see fmi1_import_create_dllfmu().
 * @param s Kind of status to return the value for.
 * @param value (Output) FMI string value.
 * @return FMI status.
 */
FMILIB_EXPORT fmi1_status_t fmi1_import_get_string_status(fmi1_import_t* fmu, const fmi1_status_kind_t s, fmi1_string_t*  value);

/**@} */


/**@} */

#ifdef __cplusplus
}
#endif
#endif /* End of header FMI1_IMPORT_CAPI_H_ */
