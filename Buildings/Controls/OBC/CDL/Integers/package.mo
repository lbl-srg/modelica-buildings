within Buildings.Controls.OBC.CDL;
package Integers "Package with blocks for integer variables"
  annotation (
    Documentation(
      info="<html>
<p>
Package with blocks for elementary mathematical functions
for integer variables.
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 22, 2016, by Michael Wetter:<br/>
Firt implementation, based on the blocks from the Modelica Standard Library.
</li>
</ul>
</html>"),
    Icon(
      graphics={
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
        Text(
          extent={{-56,90},{48,-88}},
          textColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="Z")}));
end Integers;
