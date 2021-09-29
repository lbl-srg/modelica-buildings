within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record Trane_EXW060_21kW_4_30COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 1.97339400782,
    V_flow_nominal = 0.00299097356737,
    leaCoe = 0.00368947815377,
    etaEle = 0.894909766227,
    PLos = 677.578359509,
    dTSup = 10.0,
    UACon = 3260.47025405,
    UAEva = 41007.3610647)
    "Calibrated parameters for Trane EXW060"

  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for Trane EXW060.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
