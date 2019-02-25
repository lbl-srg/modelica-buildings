# Python module with test functions.
# These functions are used to test the Modelica Python interface.
# They are not meaningful, but rather kept simple to test whether
# the interface is correct.
#
# Make sure that the python path is set, such as by running
# export PYTHONPATH=`pwd`

def r1_r1(xR):
    return 2.*xR

def r2_r1(xR):
    y = xR[0] * xR[1]
    return y

def r1_r2(xR):
    return [xR, 2.*xR]

def i1_i1(xI):
    return 2*xI

def i1_i2(xI):
    return [xI, 2*xI]

def r1i1_r2(xR, xI):
    return [2.*xR, 2.*float(xI)]

def s2_r1(xS):
    import os
    filNam = xS[0] + "." + xS[1]
    f = open(filNam, 'r')
    l = f.readline()
    f.close()
    os.remove(filNam)
    y = float(l)
    return y

def r1i1_r2i1(xR, xI):
    # Cast the return value to a long
    return [[2.*xR, 2.*float(xI)], long(3)]

# Functions with memory
def r1_r1PassPythonObject(xR, obj):
    if obj == None:
        # Initialize the Python object
        obj = {'a': xR, 'b': 1}
    else:
        # Use the python object
        obj['a'] = obj['a'] + xR
        obj['b'] = obj['b'] + 10
    # Return the sum of the dictionary,
    # and also return the dictionary so that it can be used again at the next
    # invocation.
    res = obj['a'] + obj['b']
    #raise Exception("Result is {}".format(res))
    return [res, obj]
