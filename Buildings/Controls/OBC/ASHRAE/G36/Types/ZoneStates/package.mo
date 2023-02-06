within Buildings.Controls.OBC.ASHRAE.G36.Types;
package ZoneStates "AHU Zone States"
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
</html>"), Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0)}));
end ZoneStates;
