within Buildings.Fluid.SolarCollectors.Data.BaseClasses;
record Generic
  "Generic data record providing common inputs for ASHRAE93 and EN12975 solar collector models"
  extends Modelica.Icons.Record;

  parameter Buildings.Fluid.SolarCollectors.Types.Area ATyp
    "Gross, absorber, or aperture area";
  parameter Modelica.Units.SI.Area A "Area";
  parameter Buildings.Fluid.SolarCollectors.Types.HeatCapacity CTyp
    "Total thermal capacity or fluid volume and 'dry' thermal capacity or mass";
  parameter Modelica.Units.SI.HeatCapacity C
    "Dry or total thermal capacity of the solar thermal collector";
  parameter Modelica.Units.SI.Volume V "Fluid volume";
  parameter Modelica.Units.SI.Mass mDry "Dry mass";
  parameter Real mperA_flow_nominal(unit="kg/(s.m2)")
    "Nominal mass flow rate per unit area of collector";
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")
    "Nominal pressure drop";
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal=10
    "Nominal temperature difference (between the collector inlet and outlet) specified in ratings data";
  parameter Real b0 "1st incident angle modifier coefficient";
  parameter Real b1 "2nd incident angle modifier coefficient";

annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info="<html>
<p>
Partial record containing common performance parameters for ASHRAE93 and EN12975
solar collector models.
</p>
</html>", revisions="<html>
<ul>
<li>
January, 2024, by Jelger Jansen:<br/>
Refactor model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">Buildings, #3604</a>.
</li>
<li>
January 4, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
