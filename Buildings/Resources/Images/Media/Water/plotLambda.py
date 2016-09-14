import matplotlib.pyplot as plt

# Change fonts to use LaTeX fonts
from matplotlib import rc
rc('text', usetex=True)
rc('font', family='serif')
rc('font', size='12')

def lambda_T(T_degC):
    return 0.6065 * (-1.48445 + 4.12292*((273.15+T_degC)/298.15) - 1.63866*((T_degC+273.15)/298.15)**2)

T_degC=range(101)
lambdaList = list()
for TC in T_degC:
    lambdaList.append(lambda_T(TC))

# Plot figure
fig = plt.figure(figsize=(6, 2))
ax = fig.add_subplot(111)
ax.plot(T_degC, lambdaList)
ax.set_xlabel('$T \, [\mathrm{^\circ C}]$')
ax.set_ylabel('$\\lambda \, [\mathrm{kg/m^3}]$')
ax.grid(True)

# The next line avoids the x-label to be cut off.
plt.tight_layout(h_pad=1)

# Save plot
plt.savefig('plotLambda.pdf')
plt.savefig('plotLambda.png')

plt.show()