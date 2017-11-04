# -*- coding: utf-8 -*-
"""
Author: Yangyang Fu
Email: yangyang.fu@colorado.edu
Date: 11/3/2017

"""
from buildingspy.simulate.Simulator import Simulator
from buildingspy.io.outputfile import Reader
import pandas as pd
import datetime as dt
import scipy.interpolate as interpolate
import matplotlib.pyplot as plt
import numpy as np

def integral(t, v):
    '''Get the integral of the data series.
    '''

    import numpy as np
    
    val=0.0
    val=np.trapz(v,t)
    return val
    
def autolabel(rects):
    """
    Attach a text label above each bar displaying its height
    """
    for rect in rects:
        height = rect.get_height()
        ax.text(rect.get_x() + rect.get_width()/2., 1.05*height,
                '%d' % int(height),
                ha='center', va='bottom')


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



r2 = Reader('model2.mat',"dymola")
t2,switchTimes2 = r2.values('swiTim.y')
t2,freeCoolingHours2 = r2.values('FCHou.y')
t2,partialMechanicalHours2 = r2.values('PMCHou.y')
t2,fullMechanicalHours2 = r2.values('FMCHou.y')
t2,hvacKWH2 = r2.values('HVAC_kWh.y')
t2,itKWH2 = r2.values('IT_kWh.y')

"""
------------------------- Interpolate ---------------------------------------
"""               
baseDay = dt.datetime(2017,1,1,0,0,0)  
endDay = dt.datetime(2018,1,1,0,0,0)     
datetimeBase = baseDay.toordinal() 
datetimeEnd = endDay.toordinal() 
datetime1 = datetimeBase + t1
datetime2 = datetimeBase + t2

# Generate evenly spaced samp;e data by interpolation for system 1
t1_new = range(0,31536001,3600)

f1_switchTimes = interpolate.interp1d(t1,switchTimes1, kind='linear')
switchTimes1_new = f1_switchTimes(t1_new)
f1_freeCoolingHours = interpolate.interp1d(t1,freeCoolingHours1, kind='linear')
freeCoolingHours1_new = f1_freeCoolingHours(t1_new)
f1_partialMechanicalHours = interpolate.interp1d(t1,partialMechanicalHours1, kind='linear')
partialMechanicalHours1_new = f1_partialMechanicalHours(t1_new)
f1_fullMechanicalHours = interpolate.interp1d(t1,fullMechanicalHours1, kind='linear')
fullMechanicalHours1_new = f1_fullMechanicalHours(t1_new)
result1=pd.DataFrame({'switchTimes':switchTimes1_new,
                      'freeCoolingHours':freeCoolingHours1_new,
                      'partialMechanicalHours':partialMechanicalHours1_new,
                      'fullMechanicalHours':fullMechanicalHours1_new},index=t1_new)
                      
# Generate evenly spaced samp;e data by interpolation for system 2
t2_new = t1_new

f2_switchTimes = interpolate.interp1d(t2,switchTimes2, kind='linear')
switchTimes2_new = f2_switchTimes(t2_new)
f2_freeCoolingHours = interpolate.interp1d(t2,freeCoolingHours2, kind='linear')
freeCoolingHours2_new = f2_freeCoolingHours(t2_new)
f2_partialMechanicalHours = interpolate.interp1d(t2,partialMechanicalHours2, kind='linear')
partialMechanicalHours2_new = f2_partialMechanicalHours(t2_new)
f2_fullMechanicalHours = interpolate.interp1d(t2,fullMechanicalHours2, kind='linear')
fullMechanicalHours2_new = f2_fullMechanicalHours(t2_new)
result2 = pd.DataFrame({'switchTimes':switchTimes2_new,
                      'freeCoolingHours':freeCoolingHours2_new,
                      'partialMechanicalHours':partialMechanicalHours2_new,
                      'fullMechanicalHours':fullMechanicalHours2_new},index=t2_new)

fig = plt.figure(figsize=(10.0,8.0),dpi=100)
plt.plot(t1_new[0:24], switchTimes1_new[0:24])
#plt.scatter(t1, switchTimes1)
plt.show()

"""
------------------------- Plotting ------------------------------------------

"""
days=[31,28,31,30,31,30,31,31,30,31,30,31]
months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']

# 1. Switch times
pre1 = 0
pre2 = 0
dfs1=[]
dfs2=[]
for i in range(0,12,1): 
    startT = 0
    endT = sum(days[0:i+1])*24
    loc1 = result1[endT:endT+1]
    loc2 = result2[endT:endT+1]
    if i >0:
        pre1.index = [endT*3600]
        pre2.index = [endT*3600]
    data1 = loc1 - pre1
    pre1 = loc1
    dfs1.append(data1)  
    
    data2 = loc2 - pre2
    pre2 = loc2
    dfs2.append(data2)     
result1_month = pd.concat(dfs1)
result2_month = pd.concat(dfs2)  

result1_month.index = months
result2_month.index = months  
    
    
'''------------------------ Bar charts for switch times -----------------------
'''    
## plot bar chart 
N = 12

x1 = result1_month['switchTimes']
ind = np.arange(N)  # the x locations for the groups
width = 0.35       # the width of the bars

fig, ax = plt.subplots()
rects1 = ax.bar(ind, x1, width, color='r')

x2 = result2_month['switchTimes']
rects2 = ax.bar(ind + width, x2, width, color='y')

# add some text for labels, title and axes ticks
ax.set_ylabel('Switch Times')
ax.set_title('Switch Times Comparison')
ax.set_xticks(ind + width / 2)
ax.set_xticklabels(months)

ax.legend((rects1[0], rects2[0]), ('Case 1', 'Case 2'))

autolabel(rects1)
autolabel(rects2)

plt.show()
    
'''-------------------- Bar charts for economizing hours ------------------------
'''    
    
    