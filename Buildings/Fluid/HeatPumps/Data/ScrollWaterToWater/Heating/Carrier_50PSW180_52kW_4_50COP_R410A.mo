within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record Carrier_50PSW180_52kW_4_50COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 2.17984156405,
    V_flow_nominal = 0.00696068884655,
    leaCoe = 0.00108868592572,
    etaEle = 0.937361296479,
    PLos = 1811.46067781,
    dTSup = 4.04195833004,
    UACon = 8707.82060032,
    UAEva = 7982.84714185)
    "Calibrated parameters for Carrier 50PSW180"

  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for Carrier 50PSW180.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
