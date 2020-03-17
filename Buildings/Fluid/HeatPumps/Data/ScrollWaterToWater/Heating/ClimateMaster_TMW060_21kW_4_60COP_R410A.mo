within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record ClimateMaster_TMW060_21kW_4_60COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 2.3017065409,
    V_flow_nominal = 0.00343193389885,
    leaCoe = 0.0001,
    etaEle = 1.0,
    PLos = 417.744706167,
    dTSup = 9.02301826552e-16,
    UACon = 6976.43602782,
    UAEva = 1012.57723222)
    "Calibrated parameters for ClimateMaster TMW060"

  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for ClimateMaster TMW060.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
