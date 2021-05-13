within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record ClimateMaster_TMW170_48kW_4_30COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 2.14272406967,
    V_flow_nominal = 0.00593752063272,
    leaCoe = 0.0001,
    etaEle = 1.0,
    PLos = 3217.60778902,
    dTSup = 4.12544294557,
    UACon = 7127.67902377,
    UAEva = 6702.69056458)
    "Calibrated parameters for ClimateMaster TMW170"

  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for ClimateMaster TMW170.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
