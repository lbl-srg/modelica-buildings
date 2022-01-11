within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record Daikin_WRA120_37kW_4_40COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 2.03662365096,
    V_flow_nominal = 0.00402163945373,
    leaCoe = 0.00568133095128,
    etaEle = 0.802185040279,
    PLos = 1669.72414504,
    dTSup = 10.0,
    UACon = 6395.36493022,
    UAEva = 43952.8437636)
    "Calibrated parameters for Daikin WRA120"
  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for Daikin WRA120.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
