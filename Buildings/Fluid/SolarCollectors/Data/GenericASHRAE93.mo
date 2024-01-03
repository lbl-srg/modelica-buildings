within Buildings.Fluid.SolarCollectors.Data;
record GenericASHRAE93
  "Generic data record providing inputs for specific ASHRAE93 collector data records"
  extends Buildings.Fluid.SolarCollectors.Data.BaseClasses.Generic;

  parameter Real y_intercept "Y intercept (Maximum efficiency)";
  parameter Real slope(final max=0, final unit = "W/(m2.K)")
    "Slope from rating data";

annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info="<html>
<p>
Generic data file which is used for the
<a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector\"> 
Buildings.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector</a> model.
It establishes the base inputs needed to create model-specific data packages.
</p>
</html>"));
end GenericASHRAE93;
