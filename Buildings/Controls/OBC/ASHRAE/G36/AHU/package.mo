within Buildings.Controls.OBC.ASHRAE.G36;
package AHU "AHU Sequences as defined in guideline G36"
  extends Modelica.Icons.Package;

  annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),      Rectangle(
            extent={{-60,60},{60,-60}},
            lineColor={0,0,127},
            lineThickness=0.5)}),
  Documentation(info="<html>
<p>
This package contains atomic control sequences from
ASHRAE Guideline 36. The sequences are created using CDL basic blocks:
<a href=\"modelica://Buildings.Controls.OBC.CDL\">
Buildings.Controls.OBC.CDL</a>.
</p>
<p>
The atomic sequences can be used for composing sequences in package
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnit\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnit</a>
</p>
</html>", revisions="<html>
<ul>
<li>
July 10, 2017, by Milica Grahovac:<br/>
First revision.
</li>
<li>
July 1, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end AHU;
