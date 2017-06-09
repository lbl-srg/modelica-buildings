within Buildings.Fluid.Air.BaseClasses;
record EssentialParameter "Essential parameters for air handling unit"

  replaceable parameter Buildings.Fluid.Air.Data.Generic.AirHandlingUnit dat
    constrainedby Buildings.Fluid.Air.Data.Generic.AirHandlingUnit
  "Essential data for AHU"
    annotation (Placement(transformation(extent={{-80,72},{-60,92}})));

  annotation (
Documentation(info="<html>
<p>
This  block declares parameters that are required by most classes in the package
<a href=\"modelica://Buildings.Fluid.Air\">Buildings.Fluid.Air</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 08, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EssentialParameter;
