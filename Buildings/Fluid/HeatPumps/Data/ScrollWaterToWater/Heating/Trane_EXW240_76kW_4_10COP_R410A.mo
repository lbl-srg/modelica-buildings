within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record Trane_EXW240_76kW_4_10COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 2.15191083807,
    V_flow_nominal = 0.00932406376397,
    leaCoe = 0.00855730520196,
    etaEle = 0.771299720173,
    PLos = 3034.42959083,
    dTSup = 2.21163986317,
    UACon = 14814.6977543,
    UAEva = 97189.7265209)
    "Calibrated parameters for Trane EXW240"

  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for Trane EXW240.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
