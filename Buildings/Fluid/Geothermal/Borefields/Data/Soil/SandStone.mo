within Buildings.Fluid.Geothermal.Borefields.Data.Soil;
record SandStone
  "Soil data record of sandstone heat transfer properties"
  extends
    Buildings.Fluid.Geothermal.Borefields.Data.Soil.Template(
    kSoi=2.8,
    dSoi=540,
    cSoi=1210);
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
