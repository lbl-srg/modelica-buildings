This folder contains

1. 71T_singleRoom_EC_NoDividers.idf: The EnergyPlus model of RoomB of the 71T test facility
2  validateModelicaEnergyPlus.py: A python script which reads the results of the EnergyPlus model
and write the heating and cooling power needed to maintain the setpoint.
3. EnergyPlusHeatingCoolingPower.txt: The reference results which can be compared to the results of the Modelica
model, specifically of the variable roo.heaPorAir.Q_flow.
4. plotHeatingCoolingPower.pdf: A comparison between the combined heating and cooling calculated by Energyplus and the Modelica model.
