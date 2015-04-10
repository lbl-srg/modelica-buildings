import matplotlib.pyplot as plt

# Change fonts to use LaTeX fonts
from matplotlib import rc
rc('text', usetex=True)
rc('font', family='serif')
rc('font', size='12')

def cp(T_degC):
    return 1000 * (4.20934 - 1.77775e-3*T_degC + 2.91202e-5*T_degC**2 - 1.05371e-7*T_degC**3)

T_degC=range(101)
cp20=cp(20)
cpRel = list()
for TC in T_degC:
    cpRel.append(cp(TC)/cp20)
print "At T=20, cp = ", cp20

# Plot figure
fig = plt.figure(figsize=(6, 2))
ax = fig.add_subplot(111)
ax.plot(T_degC, cpRel)
ax.set_xlabel('$T \, [^\circ C]$')
ax.set_ylabel('$c_p(T)/c_p(20^\circ C)$')
ax.grid(True)

# The next line avoids the x-label to be cut off.
plt.tight_layout(h_pad=1)

# Save plot
plt.savefig('plotCp.pdf')
plt.savefig('plotCp.png')

plt.show()

