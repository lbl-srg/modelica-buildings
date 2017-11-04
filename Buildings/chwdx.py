# -*- coding: utf-8 -*-
"""
Author: Yangyang Fu
Email: yangyang.fu@colorado.edu
Date: 11/3/2017

"""
from buildingspy.simulate.Simulator import Simulator
from buildingspy.io.outputfile import Reader
import pandas as pd

def integral(t, v):
    '''Get the integral of the data series.
    '''

    import numpy as np
    
    val=0.0
    val=np.trapz(v,t)
    return val



# Specify package path
path = "/home/yangyangfu/github/modelica-buildings/Buildings"

# Set simulation parameters
startTime = 0
stopTime = 365*24*3600
solver = "cvode"

# calculate the chilled water system
model1 = "Buildings.Applications.DataCenters.ChillerCooled.Examples.IntegratedPrimaryLoadSideEconomizer"

s1 = Simulator(model1, "dymola", packagePath = path)
s1.setStopTime(stopTime)
s1.setStartTime(startTime)
s1.setResultFile('model1')
s1.setSolver(solver)
s1.showProgressBar(show=True)
#s1.simulate()


# calculate the dx cooling system
model2 = "Buildings.Applications.DataCenters.DXCooled.Examples.DXCooledAirsideEconomizer"

s2 = Simulator(model2, "dymola", packagePath = path)
s2.setStopTime(stopTime)
s2.setStartTime(startTime)
s2.setResultFile('model2')
s2.setSolver(solver)
s2.showProgressBar(show=True)
#s2.simulate()

"""
----------------------Read simulation results--------------------------

"""
r1 = Reader('model1.mat',"dymola")
t1,switchTimes1 = r1.values('swiTim.y')
t1,freeCoolingHours1 = r1.values('FCHou.y')
t1,partialMechanicalHours1 = r1.values('PMCHou.y')
t1,fullMechanicalHours1 = r1.values('FMCHou.y')
t1,hvacKWH1 = r1.values('HVAC_kWh.y')
t1,itKWH1 = r1.values('IT_kWh.y')
result1=pd.DataFrame({'switchTimes':switchTimes1,
                      'freeCoolingHours':freeCoolingHours1,
                      'partialMechanicalHours':partialMechanicalHours1,
                      'fullMechanicalHours':fullMechanicalHours1},index=t1)


r2 = Reader('model2.mat',"dymola")
t2,switchTimes2 = r2.values('swiTim.y')
t2,freeCoolingHours2 = r2.values('FCHou.y')
t2,partialMechanicalHours2 = r2.values('PMCHou.y')
t2,fullMechanicalHours2 = r2.values('FMCHou.y')
t2,hvacKWH2 = r2.values('HVAC_kWh.y')
t2,itKWH2 = r2.values('IT_kWh.y')
result2=pd.DataFrame({'switchTimes':switchTimes2,
                      'freeCoolingHours':freeCoolingHours2,
                      'partialMechanicalHours':partialMechanicalHours2,
                      'fullMechanicalHours':fullMechanicalHours2},index=t2)
"""
------------------------- Plotting ------------------------------------------

"""
days=[31,28,31,30,31,30,31,31,30,31,30,31]
# 1. Switch times
for i in range(0,12,1): 
    start = sum(days[0:i])*24*3600
    end = sum(days[0:i+1])*24*3600
