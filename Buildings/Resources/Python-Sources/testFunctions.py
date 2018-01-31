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

# Functions with memory
def r1_r1WithMemory(xR, obj):
    print("Hello from python {}.\n", type(obj))
    if obj == None:
        print("******************* The obj is None.")
        obj = {'a': 1, 'b': 1}
    else:
        print("******************* The obj is not none xR = {}, obj = {}".format(xR, obj))
        obj['a'] = obj['a'] + 1
        obj['b'] = obj['b'] + 10
    return [3.*xR, obj]
