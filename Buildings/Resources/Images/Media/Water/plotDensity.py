import matplotlib.pyplot as plt

# Change fonts to use LaTeX fonts
from matplotlib import rc
rc('text', usetex=True)
rc('font', family='serif')
rc('font', size='12')

def rho_T(T_degC):
    return 1000.12 + 1.43711e-2*T_degC - 5.83576e-3*T_degC**2 + 1.5009e-5*T_degC**3

T_degC=range(101)
rho = list()
for TC in T_degC:
    rho.append(rho_T(TC))

# Plot figure
fig = plt.figure(figsize=(6, 2))
ax = fig.add_subplot(111)
ax.plot(T_degC, rho)
ax.set_xlabel('$T \, [\mathrm{^\circ C}]$')
ax.set_ylabel('$\\rho \, [\mathrm{kg/m^3}]$')
ax.grid(True)

# The next line avoids the x-label to be cut off.
plt.tight_layout(h_pad=1)

# Save plot
plt.savefig('plotRho.pdf')
plt.savefig('plotRho.png')

plt.show()
