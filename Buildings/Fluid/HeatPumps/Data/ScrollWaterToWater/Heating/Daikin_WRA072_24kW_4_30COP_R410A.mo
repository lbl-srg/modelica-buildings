within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record Daikin_WRA072_24kW_4_30COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 1.97046126937,
    V_flow_nominal = 0.00251615132207,
    leaCoe = 0.00317911390448,
    etaEle = 0.854244522432,
    PLos = 1299.86121735,
    dTSup = 0.0,
    UACon = 3112.7917639,
    UAEva = 29257.8652993)
    "Calibrated parameters for Daikin WRA072"
  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for Daikin WRA072.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
