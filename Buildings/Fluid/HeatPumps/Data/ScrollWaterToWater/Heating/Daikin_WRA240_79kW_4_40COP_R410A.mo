within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record Daikin_WRA240_79kW_4_40COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 2.17536546687,
    V_flow_nominal = 0.0081233732836,
    leaCoe = 0.0070428590136,
    etaEle = 0.727791339852,
    PLos = 4018.51603651,
    dTSup = 2.84985105778e-23,
    UACon = 12615.4293459,
    UAEva = 94620.7400986)
    "Calibrated parameters for Daikin WRA240"
  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for Daikin WRA240.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
