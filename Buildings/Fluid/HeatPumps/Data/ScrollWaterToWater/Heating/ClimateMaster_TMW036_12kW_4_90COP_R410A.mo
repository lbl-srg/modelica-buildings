within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record ClimateMaster_TMW036_12kW_4_90COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 2.02993657028,
    V_flow_nominal = 0.0017713046171,
    leaCoe = 0.0001,
    etaEle = 1.0,
    PLos = 334.350812253,
    dTSup = 4.68810579482e-16,
    UACon = 2434.90888536,
    UAEva = 925.546637632)
    "Calibrated parameters for ClimateMaster TMW036"
  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for ClimateMaster TMW036.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
