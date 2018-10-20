within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record Daikin_WRA150_49kW_4_70COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 2.11953593283,
    V_flow_nominal = 0.00458293691848,
    leaCoe = 0.00521346182908,
    etaEle = 0.727713452257,
    PLos = 1973.27851471,
    dTSup = 2.82899331265e-17,
    UACon = 10364.1606457,
    UAEva = 52300.8714734)
    "Calibrated parameters for Daikin WRA150"
  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for Daikin WRA150.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
