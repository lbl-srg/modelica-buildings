within Buildings.Controls.OBC.CDL;
package Logical "Package with logical blocks"

annotation (
Documentation(
info="<html>
<p>
Package with blocks for elementary mathematical functions
for boolean variables.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 22, 2016, by Michael Wetter:<br/>
Firt implementation, based on the blocks from the Modelica Standard Library.
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
          radius=25.0),
               Line(
          points={{-86,-22},{-50,-22},{-50,22},{48,22},{48,-22},{88,-24}},
          color={255,0,255})}));
end Logical;
