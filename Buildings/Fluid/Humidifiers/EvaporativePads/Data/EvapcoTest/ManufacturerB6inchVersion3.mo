within Buildings.Fluid.Humidifiers.EvaporativePads.Data.EvapcoTest;
record ManufacturerB6inchVersion3
  "Evapco test data for a 6-inch Version 3 evaporative pad from Manufacturer B"
  extends Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic (
    final efficiency(
      v={0,1.27,1.524,1.778,2.032,2.286,2.54,2.794,3.048,3.302,3.556,5,10},
      eta={0.831,0.753,0.737,0.719,0.701,0.687,0.681,0.661,0.649,0.636,0.627,0.555,
        0.370}),
    final dp_nominal=74.652,
    final v_nominal=3.556,
    final n=1.8610);

  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>
This data record contains performance data for a 6-inch Version 3 evaporative pad
from Manufacturer B in the Evapco Test. 
</p>
<p>
The data points are digitized from
<a href=\"https://www.evapco.com/sites/evapco.com/files/2019-02/Adiabatic-Pad-Saturation-White-Paper-11.2018.pdf\">
Adiabatic-Pad-Saturation-White-Paper-11.2018.pdf</a>. Data points for pressure drop
were extracted from the graph for air velocities between <i>1.27 - 3.556 m/s</i>. An
equation of the following form was fitted into the pressure drop data points:
</p>
<p align=\"center\">
<i>dp = a&sdot;v<sup>n</sup></i>
</p>
<p>
We found <i>a = 6.9674</i> and <i>n = 1.8610</i>. By setting the nominal air
velocity <i>v_nominal = 3.556 m/s</i> and plug this into the fitted equation, the
nominal pressure drop <i>dp_nominal = 74.652 Pa</i>. Only <i>dp_nominal</i>,
<i>v_nominal</i>, and the flow exponent for pressure drop <i>n</i> are included in
this data record.
</p>
<p>
Data points for saturation efficiency were extracted from the graph for air
velocities between <i>1.27 - 3.556 m/s</i>. An equation of the following form was
fitted into the saturation efficiency data points:
</p>
<p align=\"center\">
<i>&eta; = e<sup>-b &sdot; (v - c)</sup></i>
</p>
<p>
We found <i>b = 0.08093234</i> and <i>c = -2.28149984</i>. This fitted equation was
used to calculate the saturation efficiency for air velocities at <i>0 m/s</i>,
<i>5 m/s</i>, and <i>10 m/s</i>. These additional saturation efficiency values were
then added to the original set of saturation efficiency data points in this data
record.
</p>
</html>", revisions="<html>
<ul>
<li>
July 08, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end ManufacturerB6inchVersion3;
