within Buildings.Fluid.HeatPumps.Data.EquationFitReversible;
record EnergyPlus =
 Buildings.Fluid.HeatPumps.Data.EquationFitReversible.Generic (
    dpHeaSou_nominal = 30000,
    dpHeaLoa_nominal = 30000,
    hea(
      TRefLoa = 10 + 273.15,
      TRefSou = 10 + 273.15,
      Q_flow = 39040.92,
      P = 5130,
      mLoa_flow = 1.89,
      mSou_flow = 1.89,
      coeQ = {-3.33491153,-0.51451946,4.51592706,0.01797107,0.155797661},
      coeP = {-8.93121751,8.57035762,1.29660976,-0.21629222,0.033862378}),
    coo(
      TRefSou = 10 + 273.15,
      TRefLoa = 10 + 273.15,
      Q_flow = -39890.91,
      P = 4790,
      coeQ = {-1.52030596,3.46625667,-1.32267797,0.09395678,0.038975504},
      coeP = {-8.59564386,0.96265085,8.69489229,0.02501669,-0.20132665}))
   "Data record for reverse heat pump used in EnergyPlus example file"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  defaultComponentName="EPdataHP",
  defaultComponentPrefixes="parameter",
  Documentation(info= "<html>
<p>
This data corresponds to the EnergyPlus example file <code>GSHPSimple-GLHE.idf</code>
from EnergyPlus 9.1, with a nominal cooling capacity of <i>39890</i> Watts and
nominal heating capacity of <i>39040</i> Watt.
</p>
</html>", revisions="<html>
<ul>
<li>
September 16, 2019 by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
June 19, 2019 by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
