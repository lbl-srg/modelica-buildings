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

/**
* \file jm_vector_template.h
* \brief Vector template definition.
*
* This file is supposed to be included into a C-file that instantiate the template.
* jm_vector.h must be included before this file.
* It expects JM_TEMPLATE_INSTANCE_TYPE to be defined to the template type to be instantiated.
*/

#include <stdlib.h>
#include <string.h>
#include "jm_vector.h"

/** \addtogroup jm_vector  A vector of items (dynamic array)*/
/** @{
*/

#ifndef JM_TEMPLATE_INSTANCE_TYPE
#error "JM_TEMPLATE_INSTANCE_TYPE must be defined before including this file"
#endif

jm_vector(JM_TEMPLATE_INSTANCE_TYPE) * jm_vector_alloc(JM_TEMPLATE_INSTANCE_TYPE) (size_t size, size_t capacity, jm_callbacks* c) {
        size_t reserve;
        jm_callbacks* cc;
        jm_vector(JM_TEMPLATE_INSTANCE_TYPE) * v;
        if(c)
            cc = c;
        else
            cc = jm_get_default_callbacks();

        reserve = capacity;
        if(reserve < size) reserve = size;
        if(reserve > JM_VECTOR_MINIMAL_CAPACITY) {
            v = (jm_vector(JM_TEMPLATE_INSTANCE_TYPE)*)cc->malloc(
                        sizeof(jm_vector(JM_TEMPLATE_INSTANCE_TYPE)) +
                        sizeof(JM_TEMPLATE_INSTANCE_TYPE) * (reserve -JM_VECTOR_MINIMAL_CAPACITY));
            if(!v) return 0;
            v->capacity = reserve;
        }
        else {
            v = (jm_vector(JM_TEMPLATE_INSTANCE_TYPE)*)cc->malloc(sizeof(jm_vector(JM_TEMPLATE_INSTANCE_TYPE)));
            if(!v) return 0;
            v->capacity = JM_VECTOR_MINIMAL_CAPACITY;
        }
        v->callbacks = cc;
        v->items = &(v->preallocated[0]);
        v->size = size;
        return v;
}

void jm_vector_free(JM_TEMPLATE_INSTANCE_TYPE) (jm_vector(JM_TEMPLATE_INSTANCE_TYPE) * a) {
    if(!a) return;
    jm_vector_free_data(JM_TEMPLATE_INSTANCE_TYPE)(a);
    a->callbacks->free(a);
}

size_t jm_vector_init(JM_TEMPLATE_INSTANCE_TYPE)(jm_vector(JM_TEMPLATE_INSTANCE_TYPE)* a, size_t initSize, jm_callbacks* c) {        
        if(c)
            a->callbacks = c;
        else
            a->callbacks = jm_get_default_callbacks();
        a->items = a->preallocated;
        a->size = 0;
        a->capacity = JM_VECTOR_MINIMAL_CAPACITY;

        if(initSize > a->size)
            return jm_vector_resize(JM_TEMPLATE_INSTANCE_TYPE)(a, initSize);
        return 0;
}

size_t jm_vector_resize(JM_TEMPLATE_INSTANCE_TYPE)(jm_vector(JM_TEMPLATE_INSTANCE_TYPE)* a, size_t size) {
        if(size > a->capacity)  {
            if(jm_vector_reserve(JM_TEMPLATE_INSTANCE_TYPE)(a, size) < size) {
                a->size = a->capacity;
                return a->capacity;
            }
        }
        a->size = size;
        return size;
}

size_t jm_vector_reserve(JM_TEMPLATE_INSTANCE_TYPE)(jm_vector(JM_TEMPLATE_INSTANCE_TYPE)* a, size_t size) {
        void* newmem;
        if(size <= a->capacity) return a->capacity;
        newmem = a->callbacks->malloc(size * sizeof(JM_TEMPLATE_INSTANCE_TYPE));
        if(!newmem) return a->capacity;
        memcpy(newmem, a->items, a->size * sizeof(JM_TEMPLATE_INSTANCE_TYPE));
        if(a->items !=  a->preallocated) a->callbacks->free((void*)(a->items));
        a->items = newmem;
        a->capacity = size;
        return a->capacity;
}

size_t jm_vector_copy(JM_TEMPLATE_INSTANCE_TYPE)(jm_vector(JM_TEMPLATE_INSTANCE_TYPE)* destination, jm_vector(JM_TEMPLATE_INSTANCE_TYPE)* source) {
        size_t destsize = jm_vector_resize(JM_TEMPLATE_INSTANCE_TYPE)(destination, source->size);
        if(destsize > 0) {
            memcpy((void*)destination->items, (void*)source->items, sizeof(JM_TEMPLATE_INSTANCE_TYPE)*destsize);
        }
        return destination->size;
}

size_t jm_vector_append(JM_TEMPLATE_INSTANCE_TYPE)(jm_vector(JM_TEMPLATE_INSTANCE_TYPE)* destination, jm_vector(JM_TEMPLATE_INSTANCE_TYPE)* source) {
        size_t oldsize, newsize;
        oldsize = jm_vector_get_size(JM_TEMPLATE_INSTANCE_TYPE)(destination);
        newsize = jm_vector_resize(JM_TEMPLATE_INSTANCE_TYPE)(destination, source->size + oldsize);
        memcpy((void*)(destination->items + oldsize), (void*)source->items, sizeof(JM_TEMPLATE_INSTANCE_TYPE)*(newsize - oldsize));
        return (newsize - oldsize);
}

JM_TEMPLATE_INSTANCE_TYPE* jm_vector_insert(JM_TEMPLATE_INSTANCE_TYPE)(jm_vector(JM_TEMPLATE_INSTANCE_TYPE)* a, size_t index, JM_TEMPLATE_INSTANCE_TYPE item) {
        size_t reserve;
        JM_TEMPLATE_INSTANCE_TYPE* pitem;
        if(index >= a->size) return 0;
        if(a->size == a->capacity) {
                if(a->capacity > JM_VECTOR_MAX_MEMORY_CHUNK)
                        reserve = JM_VECTOR_MAX_MEMORY_CHUNK + a->capacity;
                else
                        reserve = a->capacity * 2;
                if( jm_vector_reserve(JM_TEMPLATE_INSTANCE_TYPE)(a, reserve) != reserve) return 0;
        }
        assert(a->size < a->capacity);
        memmove((void*)(a->items+index+1),(void*)(a->items+index), (a->size - index)*sizeof(JM_TEMPLATE_INSTANCE_TYPE));
        a->items[index] = item;
        pitem = &(a->items[index]);
        a->size++;
        return pitem;
}

JM_TEMPLATE_INSTANCE_TYPE* jm_vector_resize1(JM_TEMPLATE_INSTANCE_TYPE) (jm_vector(JM_TEMPLATE_INSTANCE_TYPE) * a) {
        size_t reserve;
        JM_TEMPLATE_INSTANCE_TYPE* pitem;
        if(a->size == a->capacity) {
                if(a->capacity > JM_VECTOR_MAX_MEMORY_CHUNK)
                        reserve = JM_VECTOR_MAX_MEMORY_CHUNK + a->capacity;
                else
                        reserve = a->capacity * 2;
                if( jm_vector_reserve(JM_TEMPLATE_INSTANCE_TYPE)(a, reserve) != reserve) return 0;
        }
        assert(a->size < a->capacity);
        pitem = &(a->items[a->size]);
        a->size++;
        return pitem;
}

JM_TEMPLATE_INSTANCE_TYPE* jm_vector_push_back(JM_TEMPLATE_INSTANCE_TYPE) (jm_vector(JM_TEMPLATE_INSTANCE_TYPE) * a, JM_TEMPLATE_INSTANCE_TYPE item) {
        JM_TEMPLATE_INSTANCE_TYPE* pitem= jm_vector_resize1(JM_TEMPLATE_INSTANCE_TYPE) (a);
        if(!pitem) return 0;
        *pitem = item;
        return pitem;
}

void jm_vector_remove_item(JM_TEMPLATE_INSTANCE_TYPE)(jm_vector(JM_TEMPLATE_INSTANCE_TYPE)* v, size_t index) {
    size_t n =v->size - index -1;
    assert(index < v->size);
    if(n) {
        memmove((void*)&(v->items[index]),(void*) &(v->items[index+1]), n * sizeof(JM_TEMPLATE_INSTANCE_TYPE));
    }
    v->size--;
}

void jm_vector_zero(JM_TEMPLATE_INSTANCE_TYPE)(jm_vector(JM_TEMPLATE_INSTANCE_TYPE)* a) {
    if(jm_vector_get_size(JM_TEMPLATE_INSTANCE_TYPE)(a) > 0) {
        memset((void*)a->items,0,a->size * sizeof(JM_TEMPLATE_INSTANCE_TYPE));
    }
}

void jm_vector_foreach_c(JM_TEMPLATE_INSTANCE_TYPE)(jm_vector(JM_TEMPLATE_INSTANCE_TYPE)* a,
                                                    void (*f)(JM_TEMPLATE_INSTANCE_TYPE, void*), void * data) {
        size_t i;
        for(i = 0; i < jm_vector_get_size(JM_TEMPLATE_INSTANCE_TYPE)(a); i++)
            f(jm_vector_get_item(JM_TEMPLATE_INSTANCE_TYPE)(a, i), data);
}

void jm_vector_foreach(JM_TEMPLATE_INSTANCE_TYPE)(jm_vector(JM_TEMPLATE_INSTANCE_TYPE)* a,
                                                    void (*f)(JM_TEMPLATE_INSTANCE_TYPE)) {
        size_t i;
        for(i = 0; i < jm_vector_get_size(JM_TEMPLATE_INSTANCE_TYPE)(a); i++)
            f(jm_vector_get_item(JM_TEMPLATE_INSTANCE_TYPE)(a, i));
}

void jm_vector_qsort(JM_TEMPLATE_INSTANCE_TYPE)(jm_vector(JM_TEMPLATE_INSTANCE_TYPE)* v, jm_compare_ft f) {
    if(jm_vector_get_size(JM_TEMPLATE_INSTANCE_TYPE)(v) > 1) {
        qsort((void*)v->items, jm_vector_get_size(JM_TEMPLATE_INSTANCE_TYPE)(v), sizeof(JM_TEMPLATE_INSTANCE_TYPE),f);
    }
}

#define jm_vector_ptr2index(T) jm_mangle(jm_vector_ptr2index, T)

static size_t jm_vector_ptr2index(JM_TEMPLATE_INSTANCE_TYPE)(jm_vector(JM_TEMPLATE_INSTANCE_TYPE)* v, JM_TEMPLATE_INSTANCE_TYPE* itemp) {
    if(itemp)
        return (itemp - v->items);
    else
        return jm_vector_get_size(JM_TEMPLATE_INSTANCE_TYPE)(v);
}


size_t jm_vector_bsearch_index(JM_TEMPLATE_INSTANCE_TYPE)(jm_vector(JM_TEMPLATE_INSTANCE_TYPE)* v, JM_TEMPLATE_INSTANCE_TYPE* key, jm_compare_ft f) {
    return jm_vector_ptr2index(JM_TEMPLATE_INSTANCE_TYPE)(v, jm_vector_bsearch(JM_TEMPLATE_INSTANCE_TYPE)(v, key,f));
}

JM_TEMPLATE_INSTANCE_TYPE* jm_vector_bsearch(JM_TEMPLATE_INSTANCE_TYPE)(jm_vector(JM_TEMPLATE_INSTANCE_TYPE)* v, JM_TEMPLATE_INSTANCE_TYPE* key, jm_compare_ft f) {
    return bsearch(key, v->items,
                   jm_vector_get_size(JM_TEMPLATE_INSTANCE_TYPE)(v),
                   sizeof(JM_TEMPLATE_INSTANCE_TYPE),
                   f);
}

JM_TEMPLATE_INSTANCE_TYPE* jm_vector_find(JM_TEMPLATE_INSTANCE_TYPE)(jm_vector(JM_TEMPLATE_INSTANCE_TYPE)* a, JM_TEMPLATE_INSTANCE_TYPE* itemp, jm_compare_ft f) {
    size_t i = jm_vector_get_size(JM_TEMPLATE_INSTANCE_TYPE)(a);
    while(i--) {
        JM_TEMPLATE_INSTANCE_TYPE* cur = jm_vector_get_itemp(JM_TEMPLATE_INSTANCE_TYPE)(a, i);
        if(f(cur, itemp) == 0)
           return cur;
    };
    return 0;
}

size_t jm_vector_find_index(JM_TEMPLATE_INSTANCE_TYPE)(jm_vector(JM_TEMPLATE_INSTANCE_TYPE)* v, JM_TEMPLATE_INSTANCE_TYPE* itemp, jm_compare_ft f) {
    return jm_vector_ptr2index(JM_TEMPLATE_INSTANCE_TYPE)(v,jm_vector_find(JM_TEMPLATE_INSTANCE_TYPE)(v, itemp, f));
}

/** @}
*/