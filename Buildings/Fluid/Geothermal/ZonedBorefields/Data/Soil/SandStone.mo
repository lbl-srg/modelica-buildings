within Buildings.Fluid.Geothermal.ZonedBorefields.Data.Soil;
record SandStone
  "Soil data record of sandstone heat transfer properties"
  extends Buildings.Fluid.Geothermal.ZonedBorefields.Data.Soil.Template(
    kSoi=2.5,
    dSoi=1800,
    cSoi=1200);
  annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="soiDat",
Documentation(
info="<html>
<p>
This soil data record contains the heat transfer properties of sandstone.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 21, 2018, by Jianjun Hu:<br/>
Changed the default properties based on Table 4 in the
<a href=\"http://www.15000inc.com/wp/wp-content/uploads/Geothermal-Heat-Pump-Design-Manual.pdf\">
McQuay geothermal heat pump design manual</a>.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1062\">#1062</a>.
</li>

<li>
July 15, 2018, by Michael Wetter:<br/>
Revised implementation, added <code>defaultComponentPrefixes</code> and
<code>defaultComponentName</code>.
</li>
<li>
June 28, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end SandStone;
