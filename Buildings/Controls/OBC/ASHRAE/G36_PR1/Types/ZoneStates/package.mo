within Buildings.Controls.OBC.ASHRAE.G36_PR1.Types;
package ZoneStates "AHU Zone States"
  extends Modelica.Icons.Package;

  constant Integer cooling = 3 "Output of the space cooling control loop is nonzero";
  constant Integer deadband = 2 "When not in either heating or cooling";
  constant Integer heating = 1 "Output of the space heating control loop is nonzero";

annotation (
Documentation(info="<html>
<p>
This package provides constants that indicate the
AHU zone state.
</p>
</html>", revisions="<html>
<ul>
<li>
July 18, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZoneStates;
