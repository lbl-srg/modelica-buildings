within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record Daikin_WRA036_13kW_4_50COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 2.18937967922,
    V_flow_nominal = 0.00136995091062,
    leaCoe = 0.00204441726371,
    etaEle = 0.75022416333,
    PLos = 454.268261392,
    dTSup = 10.0,
    UACon = 2854.56883514,
    UAEva = 14984.5402787)
    "Calibrated parameters for Daikin WRA036"

  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for Daikin WRA036.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
