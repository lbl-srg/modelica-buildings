#!/usr/bin/env python
from multiprocessing import Pool
import os

import buildingspy.simulate.Simulator as si
from buildingspy.io.outputfile import Reader

# timeout for the simulations
TimeOUT = 120

# Path of the library
libraryPath = "./../../Buildings"

# List that contains the names of the models
models = []
models.append('Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.Examples.AC_InHomeGrid')
models.append('Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.Examples.AC_InHomeGridN')
models.append('Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.Examples.AC_IEEE34_GridN')

# List that contains the simulation time frames
simulationTimes = [3600, 42300, 84600, 846000, 8460000]

# List of solvers to be tested
solvers = ["Dassl", "Radau"]

# List of tolerances
tolerances = [1e-6]

s = si.Simulator(models[0], 'dymola', packagePath = libraryPath)

s.setStopTime(86400)
s.setTimeOut(60)
s.showProgressBar(True)
s.setSolver("Radau")
s.setTolerance(1e-6)
s.addPreProcessingStatement("Evaluate:= true;")
s.addPreProcessingStatement("experimentSetupOutput(equdistant=false, events=false);")
s.printModelAndTime()
s.simulate()

# Load the results
resultFile = os.path.join(".", "AC_InHomeGridN.mat")
r = Reader(resultFile, "dymola")

# Get results
(time, CPUtime) = r.values('CPUtime')

print CPUtime[-1]
