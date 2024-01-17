within Buildings.Fluid.SolarCollectors.Data;
record GenericEN12975
  "Generic data record for EN12975 solar collector models"
  extends Buildings.Fluid.SolarCollectors.Data.BaseClasses.Generic;

  parameter Real IAMDiff
    "Incidence angle modifier for diffuse irradiance (incidence angle of 50°)";
  parameter Real eta0 "Optical efficiency (Maximum efficiency)";
  parameter Real a1 "First order heat loss coefficient";
  parameter Real a2 "Second order heat loss coefficient";

annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info="<html>
<p>
Record containing performance parameters for EN12975 solar collector models.
</p>
</html>", revisions="<html>
<ul>
<li>
January, 2024, by Jelger Jansen:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">Buildings, #3604</a>.
</li>
</ul>
</html>"));
end GenericEN12975;
