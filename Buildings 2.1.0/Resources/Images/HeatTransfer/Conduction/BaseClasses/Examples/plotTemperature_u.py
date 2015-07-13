from buildingspy.io.outputfile import Reader
import matplotlib.pyplot as plt
from pylab import figure
import os

# Change fonts to use LaTeX fonts
from matplotlib import rc
rc('text', usetex=True)
rc('font', family='serif')

# Read results
ofr=Reader("Temperature_u.mat", "dymola")
(t, u)    = ofr.values("u")
u /= 1e6
(t, T)    = ofr.values("T")
(t, TMon) = ofr.values("TMonotone")
(t, e)    = ofr.values("errNonMonotone")
(t, eMon) = ofr.values("errMonotone")

# Plot figure
fig = plt.figure()
ax = fig.add_subplot(211)

ax.plot(u, T-273.15, 'r', label='$T$')
ax.plot(u, TMon-273.15, '--b', markevery=5, label='$T_{monotone}$')
ax.set_xlabel('u [MJ/kg]')
ax.set_ylabel('temperature [$^\circ$C]')
#ax.set_xticks(range(25))
#ax.set_xlim([0, 24])
ax.legend(loc='lower right')
ax.grid(True)

ax = fig.add_subplot(212)
ax.plot(u, e, 'r', label='$e$')
ax.plot(u, eMon, '--b', markevery=5, label='$e_{monotone}$')
ax.set_xlabel('u [MJ/kg]')
ax.set_ylabel('error [1]')
ax.legend(loc='lower right')
ax.grid(True)

# Save figure to file
plt.savefig('Temperature_u.pdf')
plt.savefig('Temperature_u.png')

plt.show()
