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

#ifndef FMI2_IMPORT_CAPI_H_
#define FMI2_IMPORT_CAPI_H_

#ifdef __cplusplus
extern "C" {
#endif

#include <JM/jm_callbacks.h>
#include <FMI/fmi_import_util.h>
#include <FMI/fmi_import_context.h>
/* #include <FMI2/fmi2_xml_model_description.h>*/

#include <FMI2/fmi2_types.h>
#include <FMI2/fmi2_functions.h>
#include <FMI2/fmi2_enums.h>
/* #include <FMI2/fmi2_capi.h> */

/**
\file fmi2_import_capi.h
Wrapper functions for the FMI 2.0 functions
*/

/**
 * \addtogroup fmi2_import_capi
 * @{
 */

/**	\addtogroup fmi2_import_capi_const_destroy FMI 2.0 Constructor and Destructor	
 * \brief Functions for instantiating and freeing the container of the struct that is responsible for the FMI functions.
 *
 *	Before any of the FMI functions may be called, the construction function must instantiate a fmi_import_t module.
 *	After the fmi_import_t module has been succesfully instantiated, all the FMI functions can be called. To unload
 *	the FMI functions, the destroy functions shall be called.
 *
 * 	\addtogroup fmi2_import_capi_me FMI 2.0 (ME) Model Exchange functions
 * \brief List of Model Exchange wrapper functions. Common functions are not listed.
 *	\addtogroup fmi2_import_capi_cs FMI 2.0 (CS) Co-Simulation functions 
 * \brief List of Co-Simulation wrapper functions. Common functions are not listed.
 *	\addtogroup fmi2_import_capi_common FMI 2.0 (ME & CS) Common functions
 * \brief List of wrapper functions that are in common for both Model Exchange and Co-Simulation.
 */

/**
 * \addtogroup fmi2_import_capi_const_destroy
 * @{
 */

/**
 * \brief Create a C-API struct. The C-API struct is a placeholder for the FMI DLL functions.
 *
 * This function may only be called once if it returned succesfully. fmi2_import_destroy_dllfmu 
 * must be called before this function can be called again. 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml().
 * @param fmuKind Specifies if ModelExchange or CoSimulation binary should be loaded.
 * @param callBackFunctions Callback functions to be used by the FMI functions internally. If this parameter is NULL
 *           then the jm_callbacks:: and fmi2_log_forwarding are utitlized to fill in the default structure.
 * @return Error status. If the function returns with an error, it is not allowed to call any of the other C-API functions.
 */
FMILIB_EXPORT jm_status_enu_t fmi2_import_create_dllfmu(fmi2_import_t* fmu, fmi2_fmu_kind_enu_t fmuKind, const fmi2_callback_functions_t* callBackFunctions);

/** \brief Free a C-API struct. All memory allocated since the struct was created is freed.
 * 
 * @param fmu A model description object returned from fmi2_import_parse_xml().
 */
FMILIB_EXPORT void fmi2_import_destroy_dllfmu(fmi2_import_t* fmu);

/**
 * \brief Set CAPI debug mode flag. Setting to non-zero prevents DLL unloading in fmi2_import_destroy_dllfmu
 *  while all the memory is deallocated. This is to support valgrind debugging. 
 * 
 * @param fmu C-API struct that has succesfully loaded the FMI function.
 * @param mode The debug mode to set.
 */
FMILIB_EXPORT void fmi2_import_set_debug_mode(fmi2_import_t* fmu, int mode);
/**@} */

/**
 * \addtogroup fmi2_import_capi_common
 * @{
 */

/**
 * \brief Wrapper for the FMI function fmiGetVersion() 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @return FMI version.
 */
FMILIB_EXPORT const char* fmi2_import_get_version(fmi2_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiSetDebugLogging(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param loggingOn Enable or disable the debug logger.
 * @param nCategories Number of categories to log.
 * @param categories Which categories to log.
* @return FMI status.
 */
 FMILIB_EXPORT fmi2_status_t fmi2_import_set_debug_logging(fmi2_import_t* fmu, fmi2_boolean_t loggingOn, size_t nCategories, fmi2_string_t categories[]);

/**
 * \brief Wrapper for the FMI function fmiInstantiate(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param instanceName The name of the instance.
 * @param fmuType fmi2_model_exchange or fmi2_cosimulation.
 * @param fmuResourceLocation Access path URI to the FMU archive resources. If this is NULL pointer the FMU will get the path to the unzipped location.
 * @param visible Indicates whether or not the simulator application window shoule be visible.
 * @return Error status. Returnes jm_status_error if fmiInstantiate returned NULL, otherwise jm_status_success.
 */
FMILIB_EXPORT jm_status_enu_t fmi2_import_instantiate(fmi2_import_t* fmu,
    fmi2_string_t instanceName, fmi2_type_t fmuType,
    fmi2_string_t fmuResourceLocation, fmi2_boolean_t visible);

/**
 * \brief Wrapper for the FMI function fmiFreeInstance(...) 
 * 
 * @param fmu An fmu description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 */
FMILIB_EXPORT void fmi2_import_free_instance(fmi2_import_t* fmu);


/**
 * \brief Calls the FMI function fmiSetupExperiment(...)
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param tolerance_defined True if the @p tolerance argument is to be used
 * @param tolerance Solvers internal to the FMU should use this tolerance or finer, if @p tolerance_defined is true
 * @param start_time Start time of the experiment
 * @param stop_time_defined True if the @p stop_time argument is to be used
 * @param stop_time Stop time of the experiment, if @p stop_time_defined is true
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_setup_experiment(fmi2_import_t* fmu,
    fmi2_boolean_t toleranceDefined, fmi2_real_t tolerance,
    fmi2_real_t startTime, fmi2_boolean_t stopTimeDefined,
    fmi2_real_t stopTime);

/**
 * \brief Calls the FMI function fmiEnterInitializationMode(...)
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_enter_initialization_mode(fmi2_import_t* fmu);

/**
 * \brief Calls the FMI function fmiExitInitializationMode(...)
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_exit_initialization_mode(fmi2_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiTerminate(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_terminate(fmi2_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiReset(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_reset(fmi2_import_t* fmu);


/**
 * \brief Wrapper for the FMI function fmiSetReal(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value Array of variable values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_set_real(fmi2_import_t* fmu, const fmi2_value_reference_t vr[], size_t nvr, const fmi2_real_t    value[]);

/**
 * \brief Wrapper for the FMI function fmiSetInteger(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value Array of variable values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_set_integer(fmi2_import_t* fmu, const fmi2_value_reference_t vr[], size_t nvr, const fmi2_integer_t value[]);

/**
 * \brief Wrapper for the FMI function fmiSetBoolean(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value Array of variable values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_set_boolean(fmi2_import_t* fmu, const fmi2_value_reference_t vr[], size_t nvr, const fmi2_boolean_t value[]);

/**
 * \brief Wrapper for the FMI function fmiSetString(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value Array of variable values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_set_string(fmi2_import_t* fmu, const fmi2_value_reference_t vr[], size_t nvr, const fmi2_string_t  value[]);


/**
 * \brief Wrapper for the FMI function fmiGetReal(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value (Output)Array of variable values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_get_real(fmi2_import_t* fmu, const fmi2_value_reference_t vr[], size_t nvr, fmi2_real_t    value[]);

/**
 * \brief Wrapper for the FMI function fmiGetInteger(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value (Output)Array of variable values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_get_integer(fmi2_import_t* fmu, const fmi2_value_reference_t vr[], size_t nvr, fmi2_integer_t value[]);

/**
 * \brief Wrapper for the FMI function fmiGetBoolean(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value (Output)Array of variable values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_get_boolean(fmi2_import_t* fmu, const fmi2_value_reference_t vr[], size_t nvr, fmi2_boolean_t value[]);

/**
 * \brief Wrapper for the FMI function fmiGetString(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value (Output)Array of variable values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_get_string(fmi2_import_t* fmu, const fmi2_value_reference_t vr[], size_t nvr, fmi2_string_t  value[]);

/**
 * \brief Wrapper for the FMI function fmiGetTypesPlatform(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @return The platform the FMU was compiled for.
 */
FMILIB_EXPORT const char* fmi2_import_get_types_platform(fmi2_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiGetFMUstate(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param s The state object to be set by the FMU
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_get_fmu_state           (fmi2_import_t* fmu, fmi2_FMU_state_t* s );

/**
 * \brief Wrapper for the FMI function fmiSetFMUstate(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param s The FMU state object
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_set_fmu_state           (fmi2_import_t* fmu, fmi2_FMU_state_t s);

/**
 * \brief Wrapper for the FMI function fmiFreeFMUstate(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param s The FMU state object
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_free_fmu_state          (fmi2_import_t* fmu, fmi2_FMU_state_t* s);

/**
 * \brief Wrapper for the FMI function fmiSerializedFMUstateSize(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param s The FMU state object
 * @param sz The size of the serialized state in bytes
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_serialized_fmu_state_size(fmi2_import_t* fmu, fmi2_FMU_state_t s, size_t* sz);

/**
 * \brief Wrapper for the FMI function fmiSerializeFMUstate(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param s The FMU state object
 * @param data The buffer that will receive serialized FMU state
 * @param sz The size of the data buffer
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_serialize_fmu_state     (fmi2_import_t* fmu, fmi2_FMU_state_t s, fmi2_byte_t data[], size_t sz);

/**
 * \brief Wrapper for the FMI function fmiSerializeFMUstate(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param data The buffer that contains serialized FMU state
 * @param sz The size of the data buffer
 * @param s The FMU state object to be created
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_de_serialize_fmu_state  (fmi2_import_t* fmu, const fmi2_byte_t data[], size_t sz, fmi2_FMU_state_t* s);



/**
 * \brief Wrapper for the FMI function fmiGetDirectionalDerivative(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param v_ref Value references for the seed vector
 * @param nv   size of v_ref array
 * @param z_ref Value references for the derivatives/outputs to be processed
 * @param nz Size of z_ref array
 * @param dv The seed vector.
 * @param dz Calculated directional derivative on output.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_get_directional_derivative(fmi2_import_t* fmu, const fmi2_value_reference_t v_ref[], size_t nv,
                                                                   const fmi2_value_reference_t z_ref[], size_t nz,
                                                                   const fmi2_real_t dv[], fmi2_real_t dz[]);

/**@} */

/**
 * \addtogroup fmi2_import_capi_me
 * @{
 */

/**
 * \brief Calls the FMI function fmiEnterEventMode(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_enter_event_mode(fmi2_import_t* fmu);

/**
 * \brief Calls the FMI function fmiNewDiscreteStates(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param eventInfo Pointer to fmi2_event_info_t structure that will be filled in.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_new_discrete_states(fmi2_import_t* fmu, fmi2_event_info_t* eventInfo);

/**
 * \brief Calls the FMI function fmiEnterContinuousTimeMode(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_enter_continuous_time_mode(fmi2_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiSetTime(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param time Set the current time.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_set_time(fmi2_import_t* fmu, fmi2_real_t time);

/**
 * \brief Wrapper for the FMI function fmiSetContinuousStates(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param x Array of state values.
 * @param nx Number of states.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_set_continuous_states(fmi2_import_t* fmu, const fmi2_real_t x[], size_t nx);

/**
 * \brief Wrapper for the FMI function fmiCompletedIntegratorStep(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param noSetFMUStatePriorToCurrentPoint True if fmiSetFMUState will no
          longer be called for time instants prior to current time in this
          simulation run.
 * @param enterEventMode (Output) Call fmiEnterEventMode indicator.
 * @param terminateSimulation (Output) Terminate simulation indicator.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_completed_integrator_step(fmi2_import_t* fmu,
    fmi2_boolean_t noSetFMUStatePriorToCurrentPoint,
    fmi2_boolean_t* enterEventMode, fmi2_boolean_t* terminateSimulation);

/**
 * \brief Wrapper for the FMI function fmiGetDerivatives(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param derivatives (Output) Array of the derivatives.
 * @param nx Number of derivatives.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_get_derivatives(fmi2_import_t* fmu, fmi2_real_t derivatives[], size_t nx);

/**
 * \brief Wrapper for the FMI function fmiGetEventIndicators(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param eventIndicators (Output) The event indicators.
 * @param ni Number of event indicators.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_get_event_indicators(fmi2_import_t* fmu, fmi2_real_t eventIndicators[], size_t ni);

/**
 * \brief Wrapper for the FMI function fmiGetContinuousStates(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param states (Output) Array of state values.
 * @param nx Number of states.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_get_continuous_states(fmi2_import_t* fmu, fmi2_real_t states[], size_t nx);

/**
 * \brief Wrapper for the FMI function fmiGetNominalsOfContinuousStates(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param x_nominal (Output) The nominal values.
 * @param nx Number of nominal values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_get_nominals_of_continuous_states(fmi2_import_t* fmu, fmi2_real_t x_nominal[], size_t nx);

/**@} */

/**
 * \addtogroup fmi2_import_capi_cs
 * @{
 */


/**
 * \brief Wrapper for the FMI function fmiSetRealInputDerivatives(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param order	Array of derivative orders.
 * @param value Array of variable values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_set_real_input_derivatives(fmi2_import_t* fmu, const fmi2_value_reference_t vr[], size_t nvr, const fmi2_integer_t order[], const  fmi2_real_t value[]);                                                  

/**
 * \brief Wrapper for the FMI function fmiGetOutputDerivatives(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param order	Array of derivative orders.
 * @param value (Output) Array of variable values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_get_real_output_derivatives(fmi2_import_t* fmu, const fmi2_value_reference_t vr[], size_t nvr, const fmi2_integer_t order[], fmi2_real_t value[]);                                              

/**
 * \brief Wrapper for the FMI function fmiCancelStep(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_cancel_step(fmi2_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiDoStep(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param currentCommunicationPoint Current communication point of the master.
 * @param communicationStepSize Communication step size.
 * @param newStep Indicates whether or not the last communication step was accepted by the master.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_do_step(fmi2_import_t* fmu, fmi2_real_t currentCommunicationPoint, fmi2_real_t communicationStepSize, fmi2_boolean_t newStep);

/**
 * \brief Wrapper for the FMI function fmiGetStatus(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param s Kind of status to return the value for.
 * @param value (Output) FMI status value.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_get_status(fmi2_import_t* fmu, const fmi2_status_kind_t s, fmi2_status_t*  value);

/**
 * \brief Wrapper for the FMI function fmiGetRealStatus(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param s Kind of status to return the value for.
 * @param value (Output) FMI real value.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_get_real_status(fmi2_import_t* fmu, const fmi2_status_kind_t s, fmi2_real_t*    value);

/**
 * \brief Wrapper for the FMI function fmiGetIntegerStatus(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu.
 * @param s Kind of status to return the value for.
 * @param value (Output) FMI integer value.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_get_integer_status(fmi2_import_t* fmu, const fmi2_status_kind_t s, fmi2_integer_t* value);

/**
 * \brief Wrapper for the FMI function fmiGetBooleanStatus(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu.
 * @param s Kind of status to return the value for.
 * @param value (Output) FMI boolean value.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_get_boolean_status(fmi2_import_t* fmu, const fmi2_status_kind_t s, fmi2_boolean_t* value);

/**
 * \brief Wrapper for the FMI function fmiGetStringStatus(...) 
 * 
 * @param fmu A model description object returned by fmi2_import_parse_xml() that has loaded the FMI functions, see fmi2_import_create_dllfmu().
 * @param s Kind of status to return the value for.
 * @param value (Output) FMI string value.
 * @return FMI status.
 */
FMILIB_EXPORT fmi2_status_t fmi2_import_get_string_status(fmi2_import_t* fmu, const fmi2_status_kind_t s, fmi2_string_t*  value);

/**@} */


/**@} */

#ifdef __cplusplus
}
#endif
#endif /* End of header FMI2_IMPORT_CAPI_H_ */
