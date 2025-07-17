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

#ifndef FMI3_ENUMS_H_
#define FMI3_ENUMS_H_

#include <FMI3/fmi3_function_types.h>
#include <fmilib_config.h>

#ifdef __cplusplus
extern "C" {
#endif

/** \file fmi3_enums.h
    \brief Definions the enum types used with FMI 3.0 libs
*/

/**    \addtogroup fmi3_utils
    @{
    \addtogroup fmi3_enums
    @}
*/
/** \addtogroup fmi3_enums Enum types used with FMI 3.0 libs
    @{
*/
/** \brief Naming convention for the variables in XML file*/
typedef enum fmi3_variable_naming_convension_enu_t
{
        fmi3_naming_enu_flat,
        fmi3_naming_enu_structured,
        fmi3_naming_enu_unknown
} fmi3_variable_naming_convension_enu_t;

/** \brief Convert a #fmi3_variable_naming_convension_enu_t constant into string */
FMILIB_EXPORT const char* fmi3_naming_convention_to_string(fmi3_variable_naming_convension_enu_t convention);

/** \brief FMU 3.0 kinds. Enum types are specified as bit fields.
     A multi-kind FMU, for example ME + CS is defined as:
     'int fmu_kind_me_cs = fmi3_fmu_kind_me | fmi3_fmu_kind_cs'
     The same technique can be used to check if a retrieved fmu_kind has a
     specific kind:
     'int has_cs = fmi3_fmu_kind_cs & my_retrieved_fmu_kind'
 */
typedef enum fmi3_fmu_kind_enu_t
{
        fmi3_fmu_kind_unknown   = 1 << 0,
        fmi3_fmu_kind_me        = 1 << 1,
        fmi3_fmu_kind_cs        = 1 << 2,
        fmi3_fmu_kind_se        = 1 << 3
} fmi3_fmu_kind_enu_t;

/** \brief Convert a #fmi3_fmu_kind_enu_t constant into string  */
FMILIB_EXPORT const char* fmi3_fmu_kind_to_string(fmi3_fmu_kind_enu_t kind);

/**  \brief Variability property for variables */
typedef enum fmi3_variability_enu_t {
        fmi3_variability_enu_constant    = 0,
        fmi3_variability_enu_fixed       = 1,
        fmi3_variability_enu_tunable     = 2,
        fmi3_variability_enu_discrete    = 3,
        fmi3_variability_enu_continuous  = 4,
        fmi3_variability_enu_unknown     = 5
} fmi3_variability_enu_t;

/** \brief Convert a #fmi3_variability_enu_t constant into string  */
FMILIB_EXPORT const char* fmi3_variability_to_string(fmi3_variability_enu_t v);

/**  \brief Causality property for variables */
typedef enum fmi3_causality_enu_t {
        fmi3_causality_enu_structural_parameter = 0,
        fmi3_causality_enu_parameter            = 1,
        fmi3_causality_enu_calculated_parameter = 2,
        fmi3_causality_enu_input                = 3,
        fmi3_causality_enu_output               = 4,
        fmi3_causality_enu_local                = 5,
        fmi3_causality_enu_independent          = 6,
        fmi3_causality_enu_unknown              = 7
} fmi3_causality_enu_t;

/** \brief Convert a #fmi3_causality_enu_t constant into string */
FMILIB_EXPORT const char* fmi3_causality_to_string(fmi3_causality_enu_t c);

/** \brief Convert a #fmi3_status_t variable to string */
FMILIB_EXPORT const char* fmi3_status_to_string(fmi3_status_t status);

/**
 * \brief Get the default variability for a given causality and if the variable is Float32/Float64.
 * For parameter type causality, the default is 'fixed'
 * For other causality, if Float32/64: 'continuous' and else: 'discrete'
 * 
 * @param c causality
 * @param isFloat non-zero for Float32/Float64 variables
 *
 * @return A default variability compatible with the given causality.
 *
 */
FMILIB_EXPORT fmi3_variability_enu_t fmi3_get_default_valid_variability(fmi3_causality_enu_t c, int isFloat);

/**
 * \brief Check if a given combination of variablity and causality is valid.
 *
 * @return 0 if not valid, non-zero otherwise
 */
FMILIB_EXPORT int fmi3_is_valid_variability_causality(fmi3_variability_enu_t v,
                                                      fmi3_causality_enu_t c);

/**  \brief Initial property for variables */
typedef enum fmi3_initial_enu_t {
        fmi3_initial_enu_exact,
        fmi3_initial_enu_approx,
        fmi3_initial_enu_calculated,
        fmi3_initial_enu_unknown /* must be last*/
} fmi3_initial_enu_t;

/** \brief Convert a #fmi3_initial_enu_t constant into string  */
FMILIB_EXPORT const char* fmi3_initial_to_string(fmi3_initial_enu_t c);

/**
    \brief Get default initial attribute value for the given variability and causality combination.
    @return The default initial attribute or fmi3_initial_enu_unknown if combination of causality
            and variability is not valid.
*/
FMILIB_EXPORT fmi3_initial_enu_t fmi3_get_default_initial(fmi3_variability_enu_t v, fmi3_causality_enu_t c);

/**
    \brief Check if the combination of variability, causality and initial is valid.
    @return Same initial as submitted if the combination is valid. Otherwise, same as fmi3_get_default_initial.
*/
FMILIB_EXPORT fmi3_initial_enu_t fmi3_get_valid_initial(fmi3_variability_enu_t v, fmi3_causality_enu_t c, fmi3_initial_enu_t i);

/** \brief Base types used in type definitions */
typedef enum fmi3_base_type_enu_t
{
    fmi3_base_type_float64 = 1,
    fmi3_base_type_float32,
    fmi3_base_type_int64,
    fmi3_base_type_int32,
    fmi3_base_type_int16,
    fmi3_base_type_int8,
    fmi3_base_type_uint64,
    fmi3_base_type_uint32,
    fmi3_base_type_uint16,
    fmi3_base_type_uint8,
    fmi3_base_type_bool,
    fmi3_base_type_binary,
    fmi3_base_type_clock,
    fmi3_base_type_str,
    fmi3_base_type_enum,
} fmi3_base_type_enu_t;

/**  \brief Convert base type constant to string
    @param bt Base type identifier.
    @return Corresponding base type name.
    */
FMILIB_EXPORT const char* fmi3_base_type_to_string(fmi3_base_type_enu_t bt);

/** \brief Base types used in type definitions */
typedef enum fmi3_interval_variability_enu_t {
    fmi3_interval_variability_unknown = 0,
    fmi3_interval_variability_constant,
    fmi3_interval_variability_fixed,
    fmi3_interval_variability_tunable,
    fmi3_interval_variability_changing,
    fmi3_interval_variability_countdown,
    fmi3_interval_variability_triggered
} fmi3_interval_variability_enu_t;

/** \brief List of capability flags for ModelExchange */
#define FMI3_ME_CAPABILITIES(H) \
    H(needsExecutionTool) \
    H(canBeInstantiatedOnlyOncePerProcess) \
    H(canGetAndSetFMUState) \
    H(canSerializeFMUState) \
    H(providesDirectionalDerivatives) \
    H(providesAdjointDerivatives) \
    H(providesPerElementDependencies) \
    \
    H(needsCompletedIntegratorStep) \
    H(providesEvaluateDiscreteStates)

/** \brief List of capability flags for CoSimulation */
#define FMI3_CS_CAPABILITIES(H) \
    H(needsExecutionTool) \
    H(canBeInstantiatedOnlyOncePerProcess) \
    H(canGetAndSetFMUState) \
    H(canSerializeFMUState) \
    H(providesDirectionalDerivatives) \
    H(providesAdjointDerivatives) \
    H(providesPerElementDependencies) \
    \
    H(canHandleVariableCommunicationStepSize) \
    H(maxOutputDerivativeOrder) \
    H(providesIntermediateUpdate) \
    H(mightReturnEarlyFromDoStep) \
    H(canReturnEarlyAfterIntermediateUpdate) \
    H(hasEventMode) \
    H(providesEvaluateDiscreteStates) \
    H(fixedInternalStepSize) \
    H(recommendedIntermediateInputSmoothness)


/** \brief List of capability flags for ScheduledExecution */
#define FMI3_SE_CAPABILITIES(H) \
    H(needsExecutionTool) \
    H(canBeInstantiatedOnlyOncePerProcess) \
    H(canGetAndSetFMUState) \
    H(canSerializeFMUState) \
    H(providesDirectionalDerivatives) \
    H(providesAdjointDerivatives) \
    H(providesPerElementDependencies)

#define FMI3_EXPAND_ME_CAPABILITIES_ENU(c) fmi3_me_ ## c,
#define FMI3_EXPAND_CS_CAPABILITIES_ENU(c) fmi3_cs_ ## c,
#define FMI3_EXPAND_SE_CAPABILITIES_ENU(c) fmi3_se_ ## c,

/** \brief Capability flags for ModelExchange, CoSimulation and ScheduledExecution */
typedef enum fmi3_capabilities_enu_t {
    FMI3_ME_CAPABILITIES(FMI3_EXPAND_ME_CAPABILITIES_ENU)
    FMI3_CS_CAPABILITIES(FMI3_EXPAND_CS_CAPABILITIES_ENU)
    FMI3_SE_CAPABILITIES(FMI3_EXPAND_SE_CAPABILITIES_ENU)
    fmi3_capabilities_num
} fmi3_capabilities_enu_t;

/** \brief Convert capability flag to a string
    @param id Capability flag ID.
    @return Name of the flag or Unknown if the id is out of range.
*/
FMILIB_EXPORT const char* fmi3_capability_to_string(fmi3_capabilities_enu_t id);

/** \brief List of SI base units used in Unit defitions*/
#define FMI3_SI_BASE_UNITS(H) \
    H(kg) H(m) H(s) H(A) H(K) H(mol) H(cd) H(rad)

/** \brief SI base units used in Unit defitions*/
typedef enum fmi3_SI_base_units_enu_t {
#define FMI3_EXPAND_SI_BASE_UNIT_ENU(c) fmi3_SI_base_unit_ ## c,
    FMI3_SI_BASE_UNITS(FMI3_EXPAND_SI_BASE_UNIT_ENU)
    fmi3_SI_base_units_Num
} fmi3_SI_base_units_enu_t;

/** \brief Convert SI base unit ID a string
    @param id SI base unit ID.
    @return Name of the base unit or "unknown" if the id is out of range.
*/
FMILIB_EXPORT const char * fmi3_SI_base_unit_to_string(fmi3_SI_base_units_enu_t id);

/** \brief Convert a list of SI base unit exponents (corresponding to the IDs from  fmi3_SI_base_units_enu_t)
    to a string of the form kg*m^2/s^2. Prints '-' if all the exponents are zero.
    @param exp An array of SI base units exponents.
    @param bufSize Size of the buffer to store the string.
    @param buf Buffer to store the string
    @return Required size of the buffer to store the string. This most likely be under [8*fmi3_SI_base_units_Num].
    If the return value is larger or equal than bufSize than the string could not be fitted in the buffer.
*/
FMILIB_EXPORT size_t fmi3_SI_base_unit_exp_to_string(const int exp[fmi3_SI_base_units_Num], size_t bufSize, char buf[]);


/** \brief Dependency factor kinds are used as part of ModelStructure definition */
typedef enum fmi3_dependencies_kind_enu_t
{
    fmi3_dependencies_kind_dependent = 0,
    fmi3_dependencies_kind_constant,
    fmi3_dependencies_kind_fixed,
    fmi3_dependencies_kind_tunable,
    fmi3_dependencies_kind_discrete,
    fmi3_dependencies_kind_num
} fmi3_dependencies_kind_enu_t;

/** \brief Test if the input argument of type fmi3_base_type_enu_t is representing bool.
    @param enums The object of type fmi3_base_type_enu_t to check.
    @return Returns true for bool, otherwise false.
*/
bool fmi3_base_type_enu_is_bool(fmi3_base_type_enu_t enums);


/** \brief Test if the input argument of type fmi3_base_type_enu_t is representing [u]int8/32/64.
    @param enums The object of type fmi3_base_type_enu_t to check.
    @return Returns true for any of the signed/unsigned integer types, otherwise false.
*/
bool fmi3_base_type_enu_is_int(fmi3_base_type_enu_t enums);

/** \brief Test if the input argument of type fmi3_base_type_enu_t* is representing float32 or float64.
    @param enums The object of type fmi3_base_type_enu_t to check.
    @return Returns true for float32 and float64, otherwise false.
*/
bool fmi3_base_type_enu_is_float(fmi3_base_type_enu_t enums);

/** \brief Test if the input argument of type fmi3_base_type_enu_t* is representing an enumeration.
    @param enums The object of type fmi3_base_type_enu_t to check.
    @return Returns true for enums otherwise false.
*/
bool fmi3_base_type_enu_is_enum(fmi3_base_type_enu_t enums);

/** \brief Bitness for types such as Float32/Float64 */
typedef enum fmi3_bitness_enu_t {
    fmi3_bitness_64 = 1,
    fmi3_bitness_32,
    fmi3_bitness_16,
    fmi3_bitness_8
} fmi3_bitness_enu_t;

/**  \brief Convert dependency factor kind constant to string
    @param fc Dependency factor kind identifier.
    @return Corresponding factor kind as string.
    */
FMILIB_EXPORT const char* fmi3_dependencies_kind_to_string(fmi3_dependencies_kind_enu_t fc);
/**
 @}
*/
#ifdef __cplusplus
}
#endif

#endif /* End of header file FMI3_ENUMS_H_ */
