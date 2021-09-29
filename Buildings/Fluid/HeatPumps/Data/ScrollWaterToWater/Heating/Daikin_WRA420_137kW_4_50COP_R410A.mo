within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record Daikin_WRA420_137kW_4_50COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 2.31768014295,
    V_flow_nominal = 0.0151967313394,
    leaCoe = 0.0108643581925,
    etaEle = 0.749270140609,
    PLos = 6263.77526408,
    dTSup = 10.0,
    UACon = 24801.5921552,
    UAEva = 297902.470363)
    "Calibrated parameters for Daikin WRA420"

  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for Daikin WRA420.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
