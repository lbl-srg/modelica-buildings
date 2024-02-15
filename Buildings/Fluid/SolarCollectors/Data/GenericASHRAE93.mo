within Buildings.Fluid.SolarCollectors.Data;
record GenericASHRAE93
  "Generic data record for ASHRAE93 solar collector models"
  extends Buildings.Fluid.SolarCollectors.Data.BaseClasses.Generic;

  parameter Real y_intercept(final min=0, final max=1, final unit="1")
    "y intercept (Maximum efficiency)";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer slope(final max=0)
    "Slope from rating data";

annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info="<html>
<p>
Record containing performance parameters for ASHRAE93 solar collector models.
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
end GenericASHRAE93;
