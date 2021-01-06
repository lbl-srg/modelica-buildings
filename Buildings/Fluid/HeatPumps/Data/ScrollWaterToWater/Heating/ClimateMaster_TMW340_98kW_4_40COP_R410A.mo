within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record ClimateMaster_TMW340_98kW_4_40COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 2.1436051259,
    V_flow_nominal = 0.0118607090337,
    leaCoe = 0.0001,
    etaEle = 1.0,
    PLos = 6407.64092672,
    dTSup = 4.01978505385,
    UACon = 14154.9112764,
    UAEva = 13705.1289797)
    "Calibrated parameters for ClimateMaster TMW340"
  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for ClimateMaster TMW340.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
