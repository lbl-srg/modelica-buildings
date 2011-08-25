#!/usr/bin/env python
from multiprocessing import Pool
import buildingspy.simulate.Simulator as si    
import os
#################################################################
def simulateCase(simulator):
    simulator.printModelAndTime()
    simulator.simulate()
    
#################################################################
def runHydronic(tau, kConstant, useSafeDivision, stopTime, timeOut):
    import buildingspy.simulate.Simulator as si
    import os
    if kConstant == "true":
        kDes = "Con"
    else:
        kDes = "Var"

    suffix = str(int(stopTime/(24*3600))) + "d"

    if useSafeDivision == "true":
        safDivDes = "useSafDiv"
    else:
        safDivDes = "noSafDiv"

    outDes="HydronicHeating-k" + kDes + "-" + str(tau) + "-" + suffix + "-" + safDivDes

    s = si.Simulator('Buildings.Examples.HydronicHeating', 'dymola', os.path.join("..", outDes))
    s.addParameters({'temSup.use_constantK': kConstant, 
                     'temRet.use_constantK': kConstant, 
                     'temSup.tau' : tau,
                     'temRet.tau' : tau,
                     'hex.bal1.use_safeDivision': useSafeDivision, 
                     'hex.bal2.use_safeDivision': useSafeDivision, 
                     'pumRad.vol.steBal.use_safeDivision': useSafeDivision, 
                     'pumBoi.vol.steBal.use_safeDivision': useSafeDivision, 
                     'fanSup.vol.steBal.use_safeDivision': useSafeDivision, 
                     'fanRet.vol.steBal.use_safeDivision': useSafeDivision})
    s.setStopTime(stopTime)
    s.setTimeOut(timeOut)
    s.showProgressBar(False)
    return s


#################################################################
def getClosedLoopParameterList(tau, kConstant, useSafeDivision):
    d = {
        'heaCoi.bal1.use_safeDivision': useSafeDivision,
        'heaCoi.bal2.use_safeDivision': useSafeDivision,
        'cor.terHea.bal1.use_safeDivision': useSafeDivision,
        'cor.terHea.bal2.use_safeDivision': useSafeDivision,
        'per1.terHea.bal1.use_safeDivision': useSafeDivision,
        'per1.terHea.bal2.use_safeDivision': useSafeDivision,
        'per2.terHea.bal1.use_safeDivision': useSafeDivision,
        'per2.terHea.bal2.use_safeDivision': useSafeDivision,
        'per3.terHea.bal1.use_safeDivision': useSafeDivision,
        'per3.terHea.bal2.use_safeDivision': useSafeDivision,
        'per4.terHea.bal1.use_safeDivision': useSafeDivision,
        'per4.terHea.bal2.use_safeDivision': useSafeDivision,
        'TCoiHeaOut.tau': tau,
        'TCoiCooOut.tau': tau,
        'TSup.tau': tau,
        'TRet.tau': tau,
        'TMix.tau': tau,
        'cor.TSup.tau': tau,
        'per1.TSup.tau': tau,
        'per2.TSup.tau': tau,
        'per3.TSup.tau': tau,
        'per4.TSup.tau': tau,
        'TCoiHeaOut.use_constantK': kConstant,
        'TCoiCooOut.use_constantK': kConstant,
        'TSup.use_constantK': kConstant,
        'TRet.use_constantK': kConstant,
        'TMix.use_constantK': kConstant,
        'cor.TSup.use_constantK': kConstant,
        'per1.TSup.use_constantK': kConstant,
        'per2.TSup.use_constantK': kConstant,
        'per3.TSup.use_constantK': kConstant,
        'per4.TSup.use_constantK': kConstant}
    return d;

#################################################################
def runClosedLoop(tau, kConstant, useSafeDivision, stopTime, timeOut):
    import buildingspy.simulate.Simulator as si    
    import os

    if kConstant == "true":
        kDes = "Con"
    else:
        kDes = "Var"

    suffix = str(int(stopTime/(24*3600))) + "d"

    if useSafeDivision == "true":
        safDivDes = "useSafDiv"
    else:
        safDivDes = "noSafDiv"

    outDes="ClosedLoop-k" + kDes + "-" + str(tau) + "-" + suffix + "-" + safDivDes

    s = si.Simulator('Buildings.Examples.VAVReheat.ClosedLoop', 'dymola', os.path.join("..", outDes))
    s.addParameters(getClosedLoopParameterList(tau, kConstant, useSafeDivision))
    s.setStopTime(stopTime)
    s.setTimeOut(timeOut)
    s.showProgressBar(False)
    return s

#################################################################

if __name__ == '__main__':

    # Build list of cases to run
    li = []
    for tau in [1, 30, 60]:
        ca=dict()
        for kCon in ["true", "false"]:
            for useSafDiv in ["true", "false"]:
                li.append(runHydronic(tau=tau, kConstant=kCon, useSafeDivision=useSafDiv, 
                            stopTime = 365*86400, timeOut = 5*3600))


    for tau in [1, 30, 60]:
        for kCon in ["true", "false"]:
            for useSafDiv in ["true", "false"]:
                li.append(runClosedLoop(tau=tau, kConstant=kCon, 
                              useSafeDivision=useSafDiv, 
                              stopTime = 2*86400, timeOut=1*3600))

    for tau in [1, 30, 60]:
        for kCon in ["true", "false"]:
            for useSafDiv in ["true", "false"]:
                li.append(runClosedLoop(tau=tau, kConstant=kCon, 
                              useSafeDivision=useSafDiv, 
                              stopTime = 365*86400, timeOut=10*3600))

    #################################################################
    # High resolution output
    outDes="ClosedLoop-kCon-1-2d-higRes-useSafDiv"
    s = si.Simulator('Buildings.Examples.VAVReheat.ClosedLoop', 'dymola', os.path.join("..", outDes))
    s.addParameters(getClosedLoopParameterList(tau=1, kConstant="true", useSafeDivision="true"))
    s.setTimeOut(1*3600)
    s.setStopTime(2*24*3600)
    s.addPreProcessingStatement("Advanced.StoreProtectedVariables:=true;")
    s.setNumberOfIntervals(5000)
    s.showProgressBar(False)
    li.append(s)

    #################################################################
    # Medium test
    med = {"BuiPerSat": "Buildings.Media.PerfectGases.MoistAir",
           "BuiPerUns": "Buildings.Media.PerfectGases.MoistAirUnsaturated",
           "BuiConSat": "Buildings.Media.GasesConstantDensity.MoistAir",
           "BuiConUns": "Buildings.Media.GasesConstantDensity.MoistAirUnsaturated",
           "BuiDecSat": "Buildings.Media.GasesPTDecoupled.MoistAir",
           "BuiDecUns": "Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated",
           "ModAirMoi": "Modelica.Media.Air.MoistAir"}
    k=med.keys()
    v=med.values()
    for i in range(len(k)):
        outDes="ClosedLoop-kVar-1-365d-" + k[i] + "-useSafDiv"
        s = si.Simulator('Buildings.Examples.VAVReheat.ClosedLoop', 'dymola', os.path.join("..", outDes))
        s.addParameters(getClosedLoopParameterList(tau=1, kConstant="false", useSafeDivision="true"))
        s.addModelModifier('redeclare package MediumA = ' + v[i])
        s.setTimeOut(15*3600)
        s.setStopTime(365*24*3600)
        s.setNumberOfIntervals(500)
        s.showProgressBar(False)
        li.append(s)


    # Number of parallel processes
    nPro = 16
    po = Pool(nPro)
    # Run all cases
    po.map(simulateCase, li)



