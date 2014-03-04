import pandas
import matplotlib.pyplot as plt
import numpy as np

"""
    GROUPS
    ---------------------------------------------------------------
    names      = {"AC_InHomeGrid", "AC_InHomeGridN", "AC_IEEE34_GridN"};
    methods    = {"Radau", "Dassl"};
    endTimes   = {3600, 7200, 21600, 43200, 84600, 423000, 846000};
    tolerances = {1e-4, 1e-5, 1e-6};
"""

data = pandas.io.parsers.read_csv("./benchmark.csv")

grpByMethod = data.groupby('method')
grpByEndTime = data.groupby('endTime')
grpByTolerance = data.groupby('tolerance')
grpByModel = data.groupby('model')

print data.endTime[data.method==1]
print data.CPUtime[data.method==1]

plt.subplot(1,1,1)
plt.plot(data.endTime[data.method==1], data.CPUtime[data.method==1], label="CPU time", alpha=0.7)
plt.ylabel("CPU time [s]")
plt.legend()
plt.show()

