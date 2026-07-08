within Buildings.Fluid.Humidifiers.EvaporativePads.Data.MuntersCELdek;
record CELdek7090dash15slash150mm
  "Data for CELdek 7090-15/150mm evaporative pad"
  extends Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic (
    final efficiency(
      v={0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5,10},
      eta={0.926,0.908,0.881,0.854,0.828,0.808,0.788,0.766,0.752,0.731,0.719,0.547}),
    final dp_nominal=160,
    final v_nominal=3.5,
    final n=1.9259);

  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>
This data record contains performance data for a CELdek 7090-15/150mm evaporative
pad. 
</p>
<p>
The data points are digitized from
<a href=\"https://munters.sies.si/images/pdf/celdek7090.pdf\">
https://munters.sies.si/images/pdf/celdek7090.pdf</a>. Data points for pressure drop
were extracted from the graph for air velocities between <i>0.6 - 3.5 m/s</i>. An
equation of the following form was fitted into the pressure drop data points:
</p>
<p align=\"center\">
<i>dp = a&sdot;v<sup>n</sup></i>
</p>
<p>
We found <i>a = 14.3956</i> and <i>n = 1.9259</i>. By setting the nominal air
velocity <i>v_nominal = 3.5 m/s</i> and plug this into the fitted equation, the
nominal pressure drop <i>dp_nominal = 160 Pa</i>. Only <i>dp_nominal</i>,
<i>v_nominal</i>, and the flow exponent for pressure drop <i>n</i> are included in
this data record.
</p>
<p>
Data points for saturation efficiency were extracted from the graph for air
velocities between <i>0.5 - 5 m/s</i>. An equation of the following form was fitted
into the saturation efficiency data points:
</p>
<p align=\"center\">
<i>&eta; = e<sup>-b &sdot; (v - c)</sup></i>
</p>
<p>
We found <i>b = 0.05258724</i> and <i>c = -1.46471901</i>. This fitted equation was
used to calculate the saturation efficiency for air velocities at <i>0 m/s</i> and
<i>10 m/s</i>. These additional saturation efficiency values were then added to the
original set of saturation efficiency data points in this data record.
</p>
</html>", revisions="<html>
<ul>
<li>
July 08, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end CELdek7090dash15slash150mm;
