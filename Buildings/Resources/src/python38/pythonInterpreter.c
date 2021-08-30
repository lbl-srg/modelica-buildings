#define _GNU_SOURCE
#include <stdlib.h> /* for putenv */

#include "pythonInterpreter.h"

#if defined(_WIN32)     /* Win32 or Win64              */
#define putenv(x) (_putenv(x))
#endif

#if PY_MAJOR_VERSION >= 3
#define PyInt_AsLong(x) (PyLong_AsLong((x)))
#define PyString_FromString(x) (PyUnicode_FromString(x))
#define PyString_AsString(x) (PyBytes_AsString(x))
#define PyInt_Check(x) (PySet_Check(x))
#endif

extern char **environ;

/*
 Appends a character array to another character array.

 The array size of buffer may be extended by this function
 to prevent a buffer overflow.

 Arguments:
  buffer The buffer to which the character array will be added.
  toAdd The character array that will be appended to \c buffer
  bufLen The length of the character array buffer. This parameter will
		 be set to the new size of buffer if memory was reallocated.
*/
static void saveAppendModelica(
	char* *buffer,
	const char *toAdd,
	size_t *bufLen,
	const char *moduleName,
	void(*ModelicaFormatError)(const char *string, ...)
) {
	const size_t minInc = 1024;
	const size_t nNewCha = strlen(toAdd);
	const size_t nBufCha = strlen(*buffer);
	/* reallocate memory if needed */
	if (*bufLen < nNewCha + nBufCha + 1) {
		*bufLen = *bufLen + nNewCha + minInc + 1;
		*buffer = realloc(*buffer, *bufLen);
		if (*buffer == NULL) {
			ModelicaFormatError("Realloc failed in saveAppendModelica %s.", moduleName);
		}
	}
	/* append toAdd to buffer */
	strcpy(*buffer + strlen(*buffer), toAdd);
	return;
}


/* Create the structure and initialize its pointer to NULL. */
void* initPythonMemory()
{
	pythonPtr* ptr = malloc(sizeof(pythonPtr));
	/* Set ptr to null as pythonExchangeValuesNoModelica is checking for this */
	ptr->ptr = NULL;
	ptr->isInitialized = 0;
	ptr->pModule = NULL;
	ptr->pFunc = NULL;
	ptr->pythonPath = NULL;
	return (void*)ptr;
}

void pythonExchangeValuesNoModelica(const char * moduleName,
	const char * functionName,
	const char * pythonPath,
	const double * dblValWri, size_t nDblWri,
	double * dblValRea, size_t nDblRea,
	const int * intValWri, size_t nIntWri,
	int * intValRea, size_t nIntRea,
	const char ** strValWri, size_t nStrWri,
	void(*ModelicaFormatError)(const char *string, ...),
	void* memory, int passPythonObject)
{
	/* PyObject, *pModule, *pFunc; */
	PyObject *pName;
	PyObject *pArgsDbl, *pArgsInt, *pArgsStr;
	PyObject *pArgs, *pValue;
	Py_ssize_t pIndVal;
	PyObject *pItemDbl = NULL;
	PyObject *pItemInt = NULL;
	PyObject* obj;
	char* arg = "";
	Py_ssize_t i;
	Py_ssize_t iArg = 0;
	Py_ssize_t nArg = 0;
	Py_ssize_t iRet = 0;
	Py_ssize_t nRet = 0;
	pythonPtr* ptrMemory = (pythonPtr*)memory;
	size_t lenPath = strlen("PYTHONPATH=");

	if (ptrMemory->pythonPath == NULL) {
		/* Construct the python path */
		ptrMemory->pythonPath = malloc(sizeof(char) * (lenPath + 1));
		if (ptrMemory->pythonPath == NULL) {
			ModelicaFormatError("Failed to allocate memory for PYTHONPATH in pythonExchangeValuesNoModelica for %s.", moduleName);
		}
		strcpy(ptrMemory->pythonPath, "PYTHONPATH=");
    if (pythonPath == NULL) {
      ModelicaFormatError("PYTHONPATH is not set and is needed for %s.", moduleName);
    }
		saveAppendModelica(&(ptrMemory->pythonPath), pythonPath, &lenPath, moduleName, ModelicaFormatError);
		if (0 != putenv(ptrMemory->pythonPath)) {
			ModelicaFormatError("Failed to set %s in pythonExchangeValuesNoModelica for %s.", ptrMemory->pythonPath, moduleName);
		}
	}
	/*//////////////////////////////////////////////////////////////////////////*/
	/* Initialize Python interpreter*/
	if (!Py_IsInitialized())
		Py_Initialize();
	/* Set the entries for sys.argv.*/
	/* This is required if a script uses sys.argv, such as bacpypes.*/
	/* See also http://stackoverflow.com/questions/19381441/python-modelica-connection-fails-due-to-import-error*/
	PySys_SetArgv(0, &arg);

	/*//////////////////////////////////////////////////////////////////////////*/
	/* Load Python module*/
	if (!ptrMemory->isInitialized) {
		pName = PyString_FromString(moduleName);
		if (!pName) {
			(*ModelicaFormatError)("Failed to convert moduleName '%s' to Python object.\n", moduleName);
		}

		ptrMemory->pModule = PyImport_Import(pName);
		Py_DECREF(pName);
		if (!ptrMemory->pModule) {
			/*    PyErr_Print();*/
			PyObject *pValue, *pType, *pTraceBack;
			PyErr_Fetch(&pType, &pValue, &pTraceBack);
			if (pType != NULL)
				Py_DECREF(pType);
			if (pTraceBack != NULL)
				Py_DECREF(pTraceBack);
			/* Py_Finalize(); // removed, see note at other Py_Finalize() statement*/
			(*ModelicaFormatError)("Failed to load \"%s\".\n\
This may occur if you did not set the PYTHONPATH environment variable\n\
or if the Python module contains a syntax error.\n\
The error message is \"%s\"",
moduleName,
PyString_AsString(PyObject_Repr(pValue)));
		}

		/*//////////////////////////////////////////////////////////////////////////*/
		/* Python module is successfully loaded.*/
		/* Load function*/
		ptrMemory->pFunc = PyObject_GetAttrString(ptrMemory->pModule, functionName);
		/* pFunc is a new reference */

		if (!(ptrMemory->pFunc && PyCallable_Check(ptrMemory->pFunc))) {
			if (PyErr_Occurred())
				PyErr_Print();
			/* Py_Finalize(); // removed, see note at other Py_Finalize() statement*/
			(*ModelicaFormatError)(
				"Cannot find function \"%s\".\nMake sure PYTHONPATH contains the path of the module that contains this function.\n",
				functionName);
		}
		ptrMemory->isInitialized = 1;
	}
	/*//////////////////////////////////////////////////////////////////////////*/
	/* The function is loaded.*/
	/*//////////////////////////////////////////////////////////////////////////*/
	/* Create arguments for the python function*/
	if (nDblWri > 0)
		nArg++;
	if (nIntWri > 0)
		nArg++;
	if (nStrWri > 0)
		nArg++;
	if (passPythonObject > 0)
		nArg++;
	if (nArg > 0)
		pArgs = PyTuple_New(nArg);
	else
		pArgs = NULL;

	/* Convert the arguments*/
	/* a) Convert double[]*/
	if (nDblWri > 0) {
		pArgsDbl = PyList_New(nDblWri);
		for (i = 0; i < nDblWri; ++i) {
			/* Convert argument to a python float*/
			pValue = PyFloat_FromDouble(dblValWri[i]);
			if (!pValue) {
				/* Failed to convert argument.*/
				Py_DECREF(pArgsDbl);
				Py_DECREF(ptrMemory->pModule);
				/* According to the Modelica specification,*/
				/* the function ModelicaError never returns to the calling function.*/
				(*ModelicaFormatError)("Cannot convert double argument number %i to Python format.", i);
			}
			/* pValue reference stolen here*/
			PyList_SetItem(pArgsDbl, i, pValue);
		}
		/* If there is only a scalar double, then don't build a list.*/
		/* Just put the scalar value into the list of arguments*/
		if (nDblWri == 1)
			PyTuple_SetItem(pArgs, iArg, PyList_GetItem(pArgsDbl, (Py_ssize_t)0));
		else
			PyTuple_SetItem(pArgs, iArg, pArgsDbl);
		iArg++;
	}
	/* b) Convert int[]*/
	if (nIntWri > 0) {
		pArgsInt = PyList_New(nIntWri);
		for (i = 0; i < nIntWri; ++i) {
			/* Convert argument to a python integer*/
			pValue = PyLong_FromLong((long)intValWri[i]);
			if (!pValue) {
				/* Failed to convert argument.*/
				Py_DECREF(pArgsInt);
				Py_DECREF(ptrMemory->pModule);
				/* According to the Modelica specification,*/
				/* the function ModelicaError never returns to the calling function.*/
				(*ModelicaFormatError)("Cannot convert integer argument number %i to Python format.", i);
			}
			/* pValue reference stolen here*/
			PyList_SetItem(pArgsInt, i, pValue);
		}
		/* If there is only a scalar integer, then don't build a list.*/
		/* Just put the scalar value into the list of arguments*/
		if (nIntWri == 1)
			PyTuple_SetItem(pArgs, iArg, PyList_GetItem(pArgsInt, (Py_ssize_t)0));
		else
			PyTuple_SetItem(pArgs, iArg, pArgsInt);
		iArg++;
	}
	/* c) Convert char **, an array of character arrays*/
	if (nStrWri > 0) {
		pArgsStr = PyList_New(nStrWri);

		for (i = 0; i < nStrWri; ++i) {
			/* Convert argument to a python float*/
			/*      Py_ssize_t len = 0;*/
			/* According to the Modelica Specification, strings are terminated by '\0'*/
			/* Seek the string length*/
			/*      while (strValWri[i][len] != '\0')*/
			/*	len++;*/

			/*      pValue = PyString_FromStringAndSize(strValWri[i], len);*/
			pValue = PyString_FromString(strValWri[i]);
			if (!pValue) {
				/* Failed to convert argument.*/
				Py_DECREF(pArgsStr);
				Py_DECREF(ptrMemory->pModule);
				/* According to the Modelica specification,*/
				/* the function ModelicaError never returns to the calling function.*/
				(*ModelicaFormatError)("Cannot convert string argument number %i to Python format.", i);
			}
			/* pValue reference stolen here*/
			PyList_SetItem(pArgsStr, i, pValue);
		}
		/* If there is only a scalar string, then don't build a list.*/
		/* Just put the scalar value into the list of arguments.*/
		if (nStrWri == 1)
			PyTuple_SetItem(pArgs, iArg, PyList_GetItem(pArgsStr, (Py_ssize_t)0));
		else
			PyTuple_SetItem(pArgs, iArg, pArgsStr);
		iArg++;
	}

	/* d) Convert object*/
	if (passPythonObject > 0) {
		/* Put the memory into the argument list.*/
		/* In the first call, put Py_None int obj, but in subsequent calls, use ptr. */
		obj = (ptrMemory->ptr == NULL) ? Py_None : ptrMemory->ptr;

		PyTuple_SetItem(pArgs, iArg, obj);
		iArg++;
	}

	/*//////////////////////////////////////////////////////////////////////////*/
	/*//////////////////////////////////////////////////////////////////////////*/
	/* Call the Python function*/
	pValue = PyObject_CallObject(ptrMemory->pFunc, pArgs);
	if (pArgs != NULL)
		Py_DECREF(pArgs);

	/*//////////////////////////////////////////////////////////////////////////*/
	/* Check whether the call to the Python function failed.*/
	if (pValue == NULL) {

		PyObject *pValue, *pType, *pTraceBack;
		PyErr_Fetch(&pType, &pValue, &pTraceBack);
		if (pType != NULL)
			Py_DECREF(pType);
		if (pTraceBack != NULL)
			Py_DECREF(pTraceBack);
		Py_DECREF(ptrMemory->pFunc);
		Py_DECREF(ptrMemory->pModule);
		(*ModelicaFormatError)("Call to Python function \"%s\" failed.\n \
This is often due to an error in the Python script,\n \
or because the list of arguments of the Python function is incorrect.\n \
Check the module \"%s\".\n \
The error message is %s.",
functionName, moduleName,
PyString_AsString(PyObject_Repr(pValue)));
		/* Py_Finalize(); // removed, see note at other Py_Finalize() statement*/
	}

	/*//////////////////////////////////////////////////////////////////////////*/
	/* Set up the variables that indicate the return data types of the function*/
	if (nDblRea > 0)
		nRet++;
	if (nIntRea > 0)
		nRet++;
	if (passPythonObject)
		nRet++;

	/* Check whether the function must returns some values*/
	if (nRet > 0) {
		/*//////////////////////////////////////////////////////////////////////////*/
		/* The function returned some arguments.*/
		/* If there are multiple return values, then it must be a list*/
		if (nRet > 1) {
			/* Check whether it is a list*/
			if (!PyList_Check(pValue)) {
				(*ModelicaFormatError)("Python function \"%s\" does not return a list.\n\
The returned object is \"%s\"",
functionName, PyString_AsString(PyObject_Repr(pValue)));
			}
		}
		/* Check whether the list has the right number of arguments.*/
		/* If nRet==2, then it must be a list with two values. If nRet > 2, it may*/
		/* be a list with three values, or a two lists, one with one and one with two values.*/
		/* Hence, we only check for nRet==2.*/
		if (nRet == 2) {
			if (nRet != PyList_Size(pValue)) {
				(*ModelicaFormatError)("Python function \"%s\", returns a list with %i elements,\n \
but expected two elements.\n\
The returned object is \"%s\"",
functionName,
PyList_Size(pValue),
PyString_AsString(PyObject_Repr(pValue)));
			}
		}
		/*//////////////////////////////////////////////////////////////////////////*/
		/* Parse double values, if we have some*/
		if (nDblRea > 0) {
			/* Check if the function only returns double values*/
			if (nRet == 1) {
				pItemDbl = pValue;
			}
			else {
				pItemDbl = PyList_GetItem(pValue, iRet);
				iRet++;
			}
			/* Check the number of return arguments*/
			if (nDblRea > 1 && nDblRea != PyList_Size(pItemDbl))
				(*ModelicaFormatError)("For Python function \"%s\", Modelica declares that Python returns %i doubles,\
 but Python returned %i values.\n\
The returned object is \"%s\"",
functionName, nDblRea, PyList_Size(pItemDbl),
PyString_AsString(PyObject_Repr(pValue)));

			/* The number of arguments is correct. Retrieve them and parse them.*/
			/* If nDblRea == 1, then it is a scalar, else it is a list*/
			if (nDblRea == 1) {
				/* Check whether it is a float or an integer.*/
				/* (For integers, PyFloat_Check(p) returns false, hence we also call PyInt_Check(p))*/
				if (PyFloat_Check(pItemDbl) || PyLong_Check(pItemDbl) || PyInt_Check(pItemDbl))
					dblValRea[0] = PyFloat_AsDouble(pItemDbl);
				else
					(*ModelicaFormatError)("Python function \"%s\" returns an invalid object for a scalar double value.\n\
There should only be one double value returned.\n\
The returned object is \"%s\".",
functionName, PyString_AsString(PyObject_Repr(pValue)));
			}
			else { /* We have nDblRea > 1, iterate through the list*/
				for (pIndVal = 0; pIndVal < PyList_Size(pItemDbl); ++pIndVal) {
					PyObject *p = PyList_GetItem(pItemDbl, pIndVal);
					/* Check whether it is a float or an integer.*/
					/* (For integers, PyFloat_Check(p) returns false, hence we also call PyInt_Check(p))*/
					if (PyFloat_Check(p) || PyLong_Check(p) || PyInt_Check(p))
						dblValRea[pIndVal] = PyFloat_AsDouble(p);
					else
						(*ModelicaFormatError)("Python function \"%s\" returns an invalid object for a scalar double value.\n\
The returned object is \"%s\".",
functionName, PyString_AsString(PyObject_Repr(pValue)));
				} /* for(...)*/
			}
		}/* nDblRea > 0*/
		else {
			/* Modelica has no arrays with zero length. Hence, dblValRea has size 1 if nDblRea = 0.*/
			/* Assign a zero value to this element.*/
			dblValRea[0] = 0;
		}


		/*//////////////////////////////////////////////////////////////////////////*/
		/* Parse integer values*/
		if (nIntRea > 0) {
			/* Check if the function only returns integer values*/
			if (nRet == 1)
				pItemInt = pValue;
			else {
				pItemInt = PyList_GetItem(pValue, iRet);
				iRet++;
			}
			/* Check the number of return arguments*/
			if (nIntRea > 1 && nIntRea != PyList_Size(pItemInt))
				(*ModelicaFormatError)("For Python function \"%s\", Modelica declares that Python returns %i integers,\
 but Python returned %i values.\n\
The returned object is \"%s\"",
functionName, nIntRea, PyList_Size(pItemInt),
PyString_AsString(PyObject_Repr(pValue)));

			/* The number of arguments is correct. Retrieve them and parse them.*/
			/* If nDblRea == 1, then it is a scalar, else it is a list*/
			if (nIntRea == 1) {
				/* Check whether it is an integer.*/
				if (!(PyLong_Check(pItemInt) || PyInt_Check(pItemDbl)))
					(*ModelicaFormatError)("Python function \"%s\" returns an invalid object for a scalar integer value.\n\
The returned object is \"%s\".",
functionName, PyString_AsString(PyObject_Repr(pValue)));
				intValRea[0] = PyInt_AsLong(pItemInt);
			}
			else { /* We have nIntRea > 1, iterate through the list*/
				for (pIndVal = 0; pIndVal < PyList_Size(pItemInt); ++pIndVal) {
					PyObject *p = PyList_GetItem(pItemInt, pIndVal);
					if (!PyLong_Check(p))
						(*ModelicaFormatError)("Python function \"%s\" returns an invalid object for a scalar integer value.\n\
The returned object is \"%s\".",
functionName, PyString_AsString(PyObject_Repr(pValue)));
					intValRea[pIndVal] = PyInt_AsLong(p);
				} /* for(...)*/
			}
		} /* end if nIntRea > 0*/
		else {
			/* Modelica has no arrays with zero length. Hence, intValRea has size 1 if nIntRea = 0.*/
			/* Assign a zero value to this element.*/
			intValRea[0] = 0;
		}

		/*//////////////////////////////////////////////////////////////////////////*/
		/* Parse the memory to the Python object*/
		if (passPythonObject > 0) {
			ptrMemory->ptr = (void*)PyList_GetItem(pValue, iRet);
			iRet++;
		}
	}
	/*//////////////////////////////////////////////////////////////////////////*/
	/* Decrement the reference counters*/
	/* causes sometimes a segmentation fault    Py_DECREF(pValue);*/
	/* causes sometimes a segmentation fault    Py_DECREF(pFunc);*/
	/* causes sometimes a segmentation fault    Py_DECREF(pModule);*/
	/* causes sometimes a segmentation fault    Py_DECREF(pModule);*/
	/* Undo all initializations*/
	/* We uncommented Py_Finalize() because it caused a segmentation fault on Ubuntu 12.04 32 bit.*/
	/* The segmentation fault was randomly produced by the statement, and often observed when running*/
	/* simulateModel("Buildings.Utilities.IO.Python27.Functions.Examples.TestPythonInterface");*/
	/**/
	/* See also the discussion at*/
	/* http://stackoverflow.com/questions/7676314/py-initialize-py-finalize-not-working-twice-with-numpy*/
	/**/
	/*  Py_Finalize();*/

	return;
}

/*
// 3/26/2013- TN: checkStringLength is commented out since it is not used.
void checkStringLength(const char * str, size_t strLen){
  int i;
  int n;

  n = -1;
  for(i = 0; i < strLen+1; i++){
	if (str[i] == '\0'){
	  n = i;
	  break;
	}
  }
  if (n == -1)
	//    ModelicaFormatError("String %.2s has more than %d characters. Increase parameter strLen.",
	ModelicaFormatError("String %s has more than %d characters. Increase parameter strLen.",
						str, strLen);
  return;
}
*/

void freePythonMemory(void* object)
{
	if (object != NULL) {
		pythonPtr* p = (pythonPtr*)object;
		free(p->pythonPath);
		free(p);
	}
}
