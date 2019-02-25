# This script writes the heating and cooling Energy calculated by the 71T EnergyPlus model in a file.
# This file is used to parametrize the Modelica model.
# The heating and cooling power can be compared with roo.heaPorAir.Q_flow.
# The script also extracts roo.heaPorAir.Q_flow from the Modelica .mat file
# and plots the results against the EnergyPlus results.
# To run this file, the user needs to adjust the path to the .mat file.
import os

import pandas as pd
import numpy as np

import matplotlib.pyplot as plt
import matplotlib
from buildingspy.io.outputfile import Reader
from buildingspy.io.postprocess import Plotter

# Optionally, change fonts to use LaTeX fonts
#from matplotlib import rc
#rc('text', usetex=True)
#rc('font', family='serif')

ep_fil_name = os.path.join('Output', '71T_singleRoom_EC_NoDividers.csv')

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

# Internal heat gains
ep_int_con= \
           df['LIGHTS 1 ROOM 102:Lights Radiant Heating Rate [W](TimeStep)'] + \
           df['LIGHTS 1 ROOM 102_CHRIS:Lights Convective Heating Rate [W](TimeStep)'] + \
           df['ELECEQ 1 ROOM 102:Electric Equipment Radiant Heating Rate [W](TimeStep)'] + \
           df['ROOM 102:Zone Other Equipment Radiant Heating Rate [W](TimeStep)']

ep_int_rad= \
           df['LIGHTS 1 ROOM 102:Lights Convective Heating Rate [W](TimeStep)'] + \
           df['LIGHTS 1 ROOM 102_CHRIS:Lights Convective Heating Rate [W](TimeStep)'] + \
           df['ELECEQ 1 ROOM 102:Electric Equipment Convective Heating Rate [W](TimeStep)'] + \
           df['ROOM 102:Zone Other Equipment Convective Heating Rate [W](TimeStep)']


mo_fil_name="ElectroChromicWindow.mat"
mof=Reader(mo_fil_name, "dymola")
#(mo_tim, mo_inf) = mof.values("inf.m_flow")
# Heat gains in W/m2 (but they are zero anyway.
(mo_par, mo_qConGai_flow) =  mof.values("qConGai_flow.y")
(mo_par, mo_qRadGai_flow) =  mof.values("qRadGai_flow.y")

###############################################################
# Absorbed solar radiation
ep_AGla=8.71 # Glass area, from 71T_singleRoom_Geometry.txt
ep_qAbs_sol1=df['GLASS:Surface Window Total Absorbed Shortwave Radiation Rate Layer 1 [W](TimeStep)']/ep_AGla
ep_qAbs_sol2=df['GLASS:Surface Window Total Absorbed Shortwave Radiation Rate Layer 2 [W](TimeStep)']/ep_AGla

ep_HTotInc=df['GLASS:Surface Outside Face Incident Solar Radiation Rate per Area [W/m2](TimeStep)']
ep_HBeaInc=df['GLASS:Surface Outside Face Incident Beam Solar Radiation Rate per Area [W/m2](TimeStep)']


(_, mo_AGla) =  mof.values("roo.conExtWin[1].AGla")
print "Modelica glass area: AGla = {}".format(mo_AGla[0])
(mo_tim, mo_qAbs_sol1) = mof.values("roo.conExtWin[1].QAbsUns_flow[1]")
(mo_tim, mo_qAbs_sol2) = mof.values("roo.conExtWin[1].QAbsUns_flow[2]")
mo_qAbs_sol1 = mo_qAbs_sol1/mo_AGla[0]
mo_qAbs_sol2 = mo_qAbs_sol2/mo_AGla[0]


(_, mo_HBeaInc) = mof.values("roo.bouConExtWin.HDir[1]")
(_, mo_HTotInc) = mof.values("roo.bouConExtWin.HDif[1]")
mo_HTotInc = mo_HTotInc + mo_HBeaInc

# Heating and cooling power from Modelica.
(mo_tim, mo_roo_Q_flow)= mof.values("roo.heaPorAir.Q_flow")

###############################################################
# Plots
fig = plt.figure()
ax = fig.add_subplot(111)

ax.plot(1./3600/24*ep_tim, ep_qAbs_sol1, label='e+ outside pane')
ax.plot(1./3600/24*ep_tim, ep_qAbs_sol2, label='e+ roomside pane')
ax.plot(1./3600/24*mo_tim, mo_qAbs_sol1, label='Modelica outside pane')
ax.plot(1./3600/24*mo_tim, mo_qAbs_sol2, label='Modelica roomside pane')
ax.set_xlabel('time [days]')
ax.set_ylabel('Absorbed solar radiation [$\mathrm{W/m^2}$]')
ax.legend(loc='upper right')
ax.grid(True)

##ax = fig.add_subplot(212)

##ax.set_xlabel('time [days]')
##ax.plot(1./3600/24*ep_tim, ep_qAbs_sol1-Plotter.interpolate(ep_tim, mo_tim, mo_qAbs_sol1), label='error outside pane')
##ax.plot(1./3600/24*ep_tim, ep_qAbs_sol2-Plotter.interpolate(ep_tim, mo_tim, mo_qAbs_sol2), label='error roomside pane')
##ax.set_ylabel('Difference in absorbed solar radiation [$\mathrm{W/m^2}$]')
##ax.legend()
##ax.grid(True)

# Save figure to file
plt.savefig('plotAbsorbedRadiation.pdf')
plt.savefig('plotAbsorbedRadiation.png')

###############################################################
# Plots
fig = plt.figure()
ax = fig.add_subplot(111)

ax.plot(1./3600/24*ep_tim, ep_tot_heaCoo, label='e+')
ax.plot(1./3600/24*mo_tim, mo_roo_Q_flow, label='Modelica')
ax.set_xlabel('time [days]')
ax.set_ylabel('Sum of heating and cooling power [W]')
ax.legend(loc='lower right')
ax.grid(True)

# Save figure to file
plt.savefig('plotHeatingCoolingPower.pdf')
plt.savefig('plotHeatingCoolingPower.png')

fig = plt.figure()
#ax = fig.add_subplot(311)
#ax.plot(1./3600/24*ep_tim, ep_int_con, label='e+ convective')
#ax.plot(1./3600/24*ep_tim, ep_int_rad, label='e+ radiative')
#ax.plot(1./3600/24*mo_par, mo_qConGai_flow, label='Modelica convective')
#ax.plot(1./3600/24*mo_par, mo_qRadGai_flow, label='Modelica radiative')
#ax.set_xlabel('time [days]')
#ax.set_ylabel('heat gains [$\mathrm{W}$]')
#ax.legend()
#ax.grid(True)

ax = fig.add_subplot(111)
ax.plot(1./3600/24*ep_tim, ep_HBeaInc-Plotter.interpolate(ep_tim, mo_tim, mo_HBeaInc), label='beam')
ax.plot(1./3600/24*ep_tim, ep_HTotInc-Plotter.interpolate(ep_tim, mo_tim, mo_HTotInc), label='total')
#ax.plot(1./3600/24*ep_tim, ep_HBeaInc, label='e+ total')
#ax.plot(1./3600/24*ep_tim, ep_HTotInc, label='e+ beam')
#ax.plot(1./3600/24*mo_tim, mo_HBeaInc, label='Modelica total')
#ax.plot(1./3600/24*mo_tim, mo_HTotInc, label='Modelica beam')
ax.set_xlabel('time [days]')
ax.set_ylabel('difference in solar incidence [$\mathrm{W/m^2}$]')
ax.legend(loc='lower right')
ax.grid(True)


# Save figure to file
plt.savefig('plotBoundaryCondition.pdf')
plt.savefig('plotBoundaryCondition.png')

#plt.show()
