from buildingspy.io.outputfile import Reader
import matplotlib.pyplot as plt
from pylab import figure
import os

# Change fonts to use LaTeX fonts
from matplotlib import rc
rc('text', usetex=True)
rc('font', family='serif')

# Read results
ofr1=Reader(os.path.join("case1", "PIDHysteresis.mat"), "dymola")
ofr2=Reader(os.path.join("case2", "PIDHysteresis.mat"), "dymola")
(time1, T1) = ofr1.values("cap.T")
(time1, y1) = ofr1.values("con.y")
(time2, T2) = ofr2.values("cap.T")
(time2, y2) = ofr2.values("con.y")

# Plot figure
fig = plt.figure()
ax = fig.add_subplot(211)

ax.plot(time1/3600, T1-273.15, label='$T_1$')
ax.plot(time2/3600, T2-273.15, label='$T_2$')
ax.set_xlabel('time [h]')
ax.set_ylabel('temperature [$^\circ$C]')
ax.set_xticks(range(25))
ax.set_xlim([0, 24])
ax.grid(True)

ax = fig.add_subplot(212)
ax.plot(time1/3600, y1, label='$y_1$')
ax.plot(time2/3600, y2, label='$y_2$')
ax.set_xlabel('time [h]')
ax.set_ylabel('y [-]')
ax.set_xticks(range(25))
ax.set_xlim([0, 24])
ax.grid(True)

# Save figure to file
plt.savefig('plot.pdf')
plt.savefig('plot.png')

plt.show()

