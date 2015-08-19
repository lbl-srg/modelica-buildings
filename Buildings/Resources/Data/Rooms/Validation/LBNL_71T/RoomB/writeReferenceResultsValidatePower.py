# This script writes the heating and cooling Energy calculated by the 71T EnergyPlus model in a file.
# This file is used to parametrize the Modelica model. A copy of this file is in 
# Buildings/Resources/Data/Rooms/Validation/LBNL_71T/RoomB
# The heating and cooling power can be compared with roo.heaPorAir.Q_flow.
# The script also extracts roo.heaPorAir.Q_flow from the Modelica .mat file
# and plot the results against the EnergyPlus results.
# To run this file, the user needs to adjust the path to the .mat file.
import os

import pandas as pd
import numpy as np

import matplotlib.pyplot as plt
import matplotlib
from buildingspy.io.outputfile import Reader
from buildingspy.io.postprocess import Plotter

# Path to the .csv file with the EnergyPlus results.
ep_fil_name = os.path.join('Output', '71T_singleRoom_EC_NoDividers.csv')
# Read EnergyPlus results file
df = pd.read_csv(ep_fil_name)
# EnergyPlus uses 15 min intervals
dt_ep=15*60
# Heating and cooling power from EnergyPlus
ep_tot_hea=df['ROOM 102 IDEAL LOADS AIR SYSTEM:Zone Ideal Loads Zone Total Heating Rate [W](TimeStep)']
ep_tot_coo=df['ROOM 102 IDEAL LOADS AIR SYSTEM:Zone Ideal Loads Zone Total Cooling Rate [W](TimeStep)']
# Sum of heating and cooling power
ep_tot_heaCoo=ep_tot_hea-ep_tot_coo

ep_tim=np.array(range(0, len(ep_tot_hea)/ (3600/dt_ep) /24*86400, dt_ep), dtype=float)
ep_tim=ep_tim+dt_ep

# Write reference results in a new file 
with open("EnergyPlusHeatingCoolingPower.txt", "w") as f:
    f.write("#1\n");
    f.write("double	EnergyPlus(672, 2)\n");
    for (t,v) in zip(ep_tim, ep_tot_heaCoo):
        f.write("{0}\t{1}\n".format(t,v))
f.close()

# Path to the .mat file with the Dymola results.
mo_fil_name="/home/thierry/vmWareLinux/proj/buildings_library/models/modelica/git/71_T/modelica-buildings/Buildings/ElectroChromicWindow.mat"
mof=Reader(mo_fil_name, "dymola")
# Heating and cooling power from Modelica.
(mo_tim, mo_roo_Q_flow)= mof.values("roo.heaPorAir.Q_flow")

###############################################################
# Plots
fig = plt.figure()
ax = fig.add_subplot(111)

ax.plot(1./3600/24*ep_tim, ep_tot_heaCoo, label='e+')
ax.plot(1./3600/24*mo_tim, mo_roo_Q_flow, label='Modelica')
ax.set_xlabel('time [days]')
ax.set_ylabel('Sum of heating and cooling power [W]')
ax.legend(loc='upper right')
ax.grid(True)

# # Save figure to file
# plt.savefig('plotHeatingCoolingPower.pdf')

plt.show()

