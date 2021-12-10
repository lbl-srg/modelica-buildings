within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record Daikin_WRA300_93kW_4_60COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 2.14540444135,
    V_flow_nominal = 0.00946627483153,
    leaCoe = 0.00983531785764,
    etaEle = 0.735457127351,
    PLos = 5104.2326681,
    dTSup = 5.92067681695e-16,
    UACon = 16784.7393136,
    UAEva = 114049.474787)
    "Calibrated parameters for Daikin WRA300"
  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for Daikin WRA300.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
