within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record Carrier_50PSW360_105kW_4_50COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 2.16843356806,
    V_flow_nominal = 0.0140160866901,
    leaCoe = 0.00223124798723,
    etaEle = 0.949322443561,
    PLos = 3584.93101188,
    dTSup = 3.97822933689,
    UACon = 16612.2868599,
    UAEva = 15988.0119559)
    "Calibrated parameters for Carrier 50PSW360"

  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for Carrier 50PSW360.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
