within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record Daikin_WRA060_19kW_4_50COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 2.02058512825,
    V_flow_nominal = 0.00203948729471,
    leaCoe = 0.00265331062627,
    etaEle = 0.818648566096,
    PLos = 834.025033052,
    dTSup = 10.0,
    UACon = 3132.54953048,
    UAEva = 22163.5117527)
    "Calibrated parameters for Daikin WRA060"

  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for Daikin WRA060.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
