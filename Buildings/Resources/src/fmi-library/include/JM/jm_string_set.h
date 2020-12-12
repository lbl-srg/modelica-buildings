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

#ifndef JM_STRING_SET_H
#define JM_STRING_SET_H

#include <string.h>
#include <stdio.h>

#include "jm_types.h"
#include "jm_vector.h"
#ifdef __cplusplus
extern "C" {
#endif
/** \file jm_string_set.h Definition of ::jm_string_set and supporting functions
	*
	* \addtogroup jm_utils
	* @{
	*    \addtogroup jm_string_set_group
	* @}
	*/

	/** \addtogroup jm_string_set_group A set of strings
	 @{
	*/

/** 
	\brief Set of string is based on a vector	

*/
typedef struct jm_vector_jm_string jm_string_set; /* equivalent to "typedef jm_vector(jm_string) jm_string_set" which Doxygen does not understand */

/**
\brief Find a string in a set.

\param s A string set.
\param str Search string.
\return If found returns a pointer to the string saved in the set. If not found returns NULL.
*/
static jm_string jm_string_set_find(jm_string_set* s, jm_string str) {
    jm_string* found = jm_vector_bsearch(jm_string)(s,&str,jm_compare_string);
    if(found) return *found;
    return 0;
}

/**
\brief Find index of a string in a set.

\param s A string set.
\param str Search string.
\return If found returns the index to the string saved in the set. If not found returns the insertion index of the string.
*/
static size_t jm_string_set_find_index(jm_string_set* s, jm_string str) {
    size_t len = jm_vector_get_size(jm_string)(s);
    size_t first = 0;
    size_t mid = 0;
    size_t last = len - 1;
    if(len == 0) {
        return 0;
    }
    while (first <= last) {
        mid = (last + first)/2;
        if (strcmp(jm_vector_get_item(jm_string)(s,mid), str) == 0) {
            return mid;
        } else if (strcmp(jm_vector_get_item(jm_string)(s,mid), str) > 0) {
            if (mid == 0) return first;
            last = mid - 1;
        } else if (strcmp(jm_vector_get_item(jm_string)(s,mid), str) < 0) {
            first = mid + 1;
        }
    }
    return first;
}

/**
*  \brief Put an element in the set if it is not there yet.
*
*  @param s A string set.
*  \param str String to put.
*  @return A pointer to the inserted (or found) element or zero pointer if failed.
*/
static jm_string jm_string_set_put(jm_string_set* s, jm_string str) {
    jm_string* pnewstr;
    char* newstr = 0;
    size_t len = strlen(str) + 1;
    size_t idx = jm_string_set_find_index(s, str);

    if (idx != jm_vector_get_size(jm_string)(s)) {
        if (strcmp(jm_vector_get_item(jm_string)(s, idx), str) != 0) {
            pnewstr = jm_vector_insert(jm_string)(s, idx, str);
        } else {
            return jm_vector_get_item(jm_string)(s, idx);
        }
    } else {
        pnewstr = jm_vector_push_back(jm_string)(s, str);
    }
    if(pnewstr) *pnewstr = newstr = s->callbacks->malloc(len);
    if(!pnewstr || !newstr) return 0;
    memcpy(newstr, str, len);
    return *pnewstr;
}

/** @}
	*/

#ifdef __cplusplus
}
#endif

#endif /* JM_STRING_SET_H */
