within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record ClimateMaster_TMW120_42kW_4_50COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 2.2476274626,
    V_flow_nominal = 0.00665394781546,
    leaCoe = 0.0001,
    etaEle = 1.0,
    PLos = 958.859267653,
    dTSup = 1.25716725318e-15,
    UACon = 11851.7167307,
    UAEva = 2121.46076035)
    "Calibrated parameters for ClimateMaster TMW120"
  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for ClimateMaster TMW120.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
