within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record Daikin_WRA048_16kW_4_60COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 1.98348644579,
    V_flow_nominal = 0.00165211643646,
    leaCoe = 0.00243670163031,
    etaEle = 0.788717592763,
    PLos = 698.088177298,
    dTSup = 2.36774358188,
    UACon = 2860.44257631,
    UAEva = 17688.743889)
    "Calibrated parameters for Daikin WRA048"
  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for Daikin WRA048.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
