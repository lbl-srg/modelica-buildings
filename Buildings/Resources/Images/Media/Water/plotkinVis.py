import matplotlib.pyplot as plt
import math

# Change fonts to use LaTeX fonts
from matplotlib import rc
rc('text', usetex=True)
rc('font', family='serif')
rc('font', size='12')

def kinVis_T(T_degC):
	if T_degC < 5: 
		return 1000000*(-(4.63023776563*pow(10,-8))*(T_degC+273.15) + 1.44011135763*pow(10,-5))
	else:
		return 1000000*(1.0*pow(10,-6)*math.exp(-(7.22111000000000*pow(10,-7))*pow((T_degC+273.15),3) + 0.000809102858950000*pow((T_degC+273.15),2) - 0.312920238272193*(T_degC+273.15) + 40.4003044106506))
    

T_degC=range(101)
kinVis = list()
for TC in T_degC:
    kinVis.append(kinVis_T(TC))

# Plot figure
fig = plt.figure(figsize=(6, 2))
ax = fig.add_subplot(111)
ax.plot(T_degC, kinVis)
ax.set_xlabel('$T \, [\mathrm{^\circ C}]$')
ax.set_ylabel('$\\nu \, [\mathrm{mm^2/s}]$')
ax.grid(True)

# The next line avoids the x-label to be cut off.
plt.tight_layout(h_pad=1)

# Save plot
plt.savefig('plotkinVis.pdf')
plt.savefig('plotkinVis.png')

plt.show()