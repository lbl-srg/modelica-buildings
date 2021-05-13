within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record Daikin_WRA180_63kW_4_50COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 2.25650476224,
    V_flow_nominal = 0.00640722987639,
    leaCoe = 0.00303673424194,
    etaEle = 0.722176661834,
    PLos = 3128.08507812,
    dTSup = 3.10253510583e-16,
    UACon = 11553.9351864,
    UAEva = 83881.3683749)
    "Calibrated parameters for Daikin WRA180"

  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for Daikin WRA180.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
