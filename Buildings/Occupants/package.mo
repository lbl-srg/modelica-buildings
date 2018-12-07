within Buildings;
package Occupants "Package with models to simulate building occupant behaviors"
  extends Modelica.Icons.Package;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains models to simulate building occupancy and occupant behaviors.
See Wang et al., 2018 for a detailed description of this package.
</p>
<h4>References</h4>
<p>
Zhe Wang, Tianzhen Hong and Ruoxi Jia (2018).<br/>
Buildings.Occupants: a Modelica package for modelling occupant behaviour in buildings.<br/>
Journal of Building Performance Simulation.<br/>
<a href=\"https://https://doi.org/10.1080/19401493.2018.1543352\">DOI: 10.1080/19401493.2018.1543352</a>.
</p>
</html>"),
  Icon(graphics={
      Line(points={{-32,-70},{0,-20},{32,-70}}, color={0,0,0}),
      Line(points={{0,-20},{0,40}}, color={0,0,0}),
      Line(points={{-28,20},{28,20}}, color={0,0,0}),
      Ellipse(extent={{-14,40},{14,70}}, lineColor={0,0,0})}));
end Occupants;
