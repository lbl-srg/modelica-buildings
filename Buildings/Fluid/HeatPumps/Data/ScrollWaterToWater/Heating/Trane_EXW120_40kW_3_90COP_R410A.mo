within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record Trane_EXW120_40kW_3_90COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 1.7751510289,
    V_flow_nominal = 0.00568762510737,
    leaCoe = 0.00493966413666,
    etaEle = 1.0,
    PLos = 2167.94596726,
    dTSup = 10.0,
    UACon = 4233.2477479,
    UAEva = 38367.2250194)
    "Calibrated parameters for Trane EXW120"

  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for Trane EXW120.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
