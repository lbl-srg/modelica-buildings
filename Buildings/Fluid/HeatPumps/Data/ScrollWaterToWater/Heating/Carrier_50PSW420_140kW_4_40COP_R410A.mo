within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Heating;
record Carrier_50PSW420_140kW_4_40COP_R410A =
  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic (
    volRat = 2.23739862891,
    V_flow_nominal = 0.0192598232371,
    leaCoe = 0.0156269077066,
    etaEle = 1.0,
    PLos = 5208.69616148,
    dTSup = 9.97163386698e-17,
    UACon = 22875.6244158,
    UAEva = 20395.4876127)
    "Calibrated parameters for Carrier 50PSW420"

  annotation (
    defaultComponentPrefixes = "parameter",
    defaultComponentName="datHeaPum",
    preferredView="info",
  Documentation(info="<html>
<p>
Calibrated parameters for Carrier 50PSW420.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Massimo Cimmino:<br/>
Calibrated parameters.
</li>
</ul>
</html>"));
