within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record Daikin_WRA360_116kW_4_60COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 2.36231114404,
    V_flow_nominal = 0.0129762607513,
    leaCoe = 0.0106609843642,
    etaEle = 0.737581999584,
    PLos = 4731.51935299,
    dTSup = 10.0,
    UACon = 25362.0976534,
    UAEva = 196974.891726)
    "Calibrated parameters for Daikin WRA360"
  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for Daikin WRA360.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
