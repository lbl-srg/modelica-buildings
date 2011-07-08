from buildingspy.io.outputfile import Reader
import matplotlib.pyplot as plt

ofr=Reader("PlotDemo.mat", "dymola")
(time, T) = ofr.values("cap.T")
(time, y) = ofr.values("PID.y")

plt.figure()

plt.subplot(211)
plt.plot(time, T-273.15)
plt.xlabel('time [s]')
plt.ylabel('temperature [$^\circ$C]')
plt.grid(True)

plt.subplot(212)
plt.plot(time, y)
plt.xlabel('time [s]')
plt.ylabel('y [-]')
plt.grid(True)

plt.savefig('plot.pdf')
plt.savefig('plot.png')

plt.show()

