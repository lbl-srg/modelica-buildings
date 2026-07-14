within Buildings.Fluid.Humidifiers.EvaporativePads.Data.EvapcoLabTest;
record ManufacturerA6inchVersion1
  "Evapco test data for a 6-inch Version 1 evaporative pad from Manufacturer A"
  extends Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic (
    final efficiency(
      v={0,1.27,1.524,1.778,2.032,2.2352,2.5146,2.7686,3.0226,3.302,3.556,5,10},
      eta={0.819,0.744,0.731,0.714,0.695,0.681,0.664,0.66,0.647,0.634,0.623,0.553,
        0.373}),
    final dp_nominal=48.5238,
    final v_nominal=3.556,
    final n=1.7360);

  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>
This data record contains performance data for a 6-inch Version 1 evaporative pad
from Manufacturer A in the Evapco Lab Test. 
</p>
<p>
For more information of the Evapco Lab Test and the evaporative pad naming
conventions, refer to the documentation at
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativePads.Data.EvapcoLabTest\">
Buildings.Fluid.Humidifiers.EvaporativePads.Data.EvapcoLabTest</a>.
</p>
<p>
The data points are digitized from
<a href=\"https://www.evapco.com/sites/evapco.com/files/2019-02/Adiabatic-Pad-Saturation-White-Paper-11.2018.pdf\">
Adiabatic-Pad-Saturation-White-Paper-11.2018.pdf</a>. Data points for pressure drop
were extracted from the graph for air velocities between <i>1.27 - 3.556 m/s</i>.
An equation of the following form was fitted into the pressure drop data points:
</p>
<p align=\"center\">
<i>dp = a&sdot;v<sup>n</sup></i>
</p>
<p>
We found <i>a = 5.2676</i> and <i>n = 1.7360</i>. By setting the nominal air
velocity <i>v_nominal = 3.556 m/s</i> and plug this into the fitted equation, the
nominal pressure drop <i>dp_nominal = 48.5238 Pa</i>. Only <i>dp_nominal</i>,
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
We found <i>b = 0.07878901</i> and <i>c = -2.52851027</i>. This fitted equation was
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
end ManufacturerA6inchVersion1;
