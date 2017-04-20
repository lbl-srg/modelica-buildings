within Buildings.Fluid.Air.BaseClasses;
block EssentialParameter "Essential parameters for air handling unit"
  replaceable parameter Data.Generic.AirHandlingUnit dat constrainedby
    Data.Generic.AirHandlingUnit "Essential data for AHU"
    annotation (Placement(transformation(extent={{-80,72},{-60,92}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This  block declares parameters that are required by most classes in the package 
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
