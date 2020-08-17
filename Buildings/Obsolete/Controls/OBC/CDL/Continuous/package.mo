within Buildings.Obsolete.Controls.OBC.CDL;
<<<<<<< HEAD
package Continuous "Package with obsolete models of the Control Description Language"
  extends Modelica.Icons.Package;
annotation (preferredView="info",
Documentation(info="<html>
<p>
Package that contains obsolete components that were part of the
OpenBuildingControl (OBC) package
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous\">
Buildings.Controls.OBC.CDL.Continuous</a>.
</p>
</html>"));
=======
package Continuous "Package with blocks for continuous variables"

annotation (
Documentation(
info="<html>
<p>
Package with blocks for elementary mathematical functions
for continuous variables.
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
Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
               Text(
        extent={{-52,86},{52,-92}},
        lineColor={0,0,0},
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid,
        textString="R"),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0)}));
>>>>>>> master
end Continuous;
