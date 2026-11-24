#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Example python code used to generate working fluid records for
Fluid.CHPs.OrganicRankine.Data.
Note that this script is not maintained.

This file was created at:
    Python 3.11.9
    Ubuntu 20.04.3
    CoolProp 6.6.0
    Modelica IBPSA Library 6612f5a
    Modelica Buildings Library c34c05a
"""

import CoolProp.CoolProp as CP

import numpy as np
import os

WITHIN = "IBPSA." # e.g. "IBPSA." or "Buildings."
FLUIDNAME = {"coolprop" : "n-Pentane",
             "modelica" : "Pentane",
             "description" : "n-pentane (R601)"}
""" To find a fluid name in CoolProp,
        ```
        import CoolProp
        print(CoolProp.__fluids__)
        ```
    The Modelica name will be used as the class name, so make sure it is legal.
    The description name is whatever you want it to appear
        in descriptions and documentations.
"""
dTRef = 30
    # Temperature difference from the reference line to the saturated vapour line
dirOutput = os.path.dirname(os.path.realpath(__file__))

def ModelicaArray(arr):
       s = "{\n" + " "*9 \
           + np.array2string(arr,
                             max_line_width=75,
                             precision=9,
                             separator=",",
                             prefix=" "*8).replace("[","").replace("]","") \
           + "}"
       return s

def WriteOneFile(fluid, dTRef = 30):
       nCP = fluid["coolprop"]
       nMO = fluid["modelica"]
       nDS = fluid["description"]
       
       TCri = CP.PropsSI(nCP, 'Tcrit')

       TMax = TCri -10
       TMin = 273.15 - 10

       T = np.linspace(TMin,TMax,10)
       p = CP.PropsSI('P','T',T,'Q',1,nCP)
       rhoLiq = CP.PropsSI('D','T',T,'Q',0,nCP)
       
       sSatLiq = CP.PropsSI('S','T',T,'Q',0,nCP) # Entropy of saturated liquid
       sSatVap = CP.PropsSI('S','T',T,'Q',1,nCP) # Entropy of saturated vapour
       sSupVap = CP.PropsSI('S','T',T+dTRef,'P',p,nCP) # Entropy of superheated vapour
       hSatLiq = CP.PropsSI('H','T',T,'Q',0,nCP) # Enthalpy of saturated liquid
       hSatVap = CP.PropsSI('H','T',T,'Q',1,nCP) # Enthalpy of saturated vapour
       hSupVap = CP.PropsSI('H','T',T+dTRef,'P',p,nCP) # Enthalpy of superheated vapour

       with open(os.path.join(dirOutput, nMO + '.mo'), 'w') as f:
           # header
           f.write(f'within {WITHIN}Fluid.CHPs.OrganicRankine.Data.WorkingFluids;\n')
           f.write(f'record {nMO} "Data record for {nDS}"\n')
           f.write('  extends Generic(\n')

           # data
           f.write(' '*4 + f'T = {ModelicaArray(T)},\n')
           f.write(' '*4 + f'p = {ModelicaArray(p)},\n')
           f.write(' '*4 + f'rhoLiq = {ModelicaArray(rhoLiq)},\n')
           f.write(' '*4 + f'dTRef = {str(dTRef)},\n')
           f.write(' '*4 + f'sSatLiq = {ModelicaArray(sSatLiq)},\n')
           f.write(' '*4 + f'sSatVap = {ModelicaArray(sSatVap)},\n')
           f.write(' '*4 + f'sRef = {ModelicaArray(sSupVap)},\n')
           f.write(' '*4 + f'hSatLiq = {ModelicaArray(hSatLiq)},\n')
           f.write(' '*4 + f'hSatVap = {ModelicaArray(hSatVap)},\n')
           f.write(' '*4 + f'hRef = {ModelicaArray(hSupVap)});\n')
              
           # annotation
           f.write(' '*2 + 'annotation (\n')
           f.write(' '*2 + 'defaultComponentPrefixes = "parameter",\n')
           f.write(' '*2 + 'defaultComponentName = "pro",\n')
           f.write(' '*2 + 'Documentation(info="<html>\n')
           f.write('<p>\n')
           f.write(f'Record containing properties of {nDS}.\n')
           f.write(f'Its name in CoolProp is \\"{nCP}\\".\n')
           f.write('A figure in the documentation of\n')
           f.write(f'<a href=\\"Modelica://{WITHIN}Fluid.CHPs.OrganicRankine.ConstantEvaporation\\">\n')
           f.write(f'{WITHIN}Fluid.CHPs.OrganicRankine.ConstantEvaporation</a>\n')
           f.write('shows which lines these arrays represent.\n')
           f.write('</p>\n')
           f.write('</html>"));\n')
           
           # end
           f.write(f'end {nMO};')
       print(f'File written: {nMO}.mo')

#######################################################################

WriteOneFile(FLUIDNAME,dTRef = dTRef)