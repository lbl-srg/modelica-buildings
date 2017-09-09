within Buildings.Controls.OBC.ASHRAE.G36;
package TerminalUnit "Control sequences as defined in G36"
  extends Modelica.Icons.Package;

  annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          extent={{-70,60},{-30,20}},
          lineColor={0,0,127},
          lineThickness=0.5),
        Rectangle(
          extent={{-70,-20},{-30,-60}},
          lineColor={0,0,127},
          lineThickness=0.5),
        Rectangle(
          extent={{30,20},{70,-20}},
          lineColor={0,0,127},
          lineThickness=0.5),
        Line(
          points={{-30,40},{0,40},{0,10},{30,10}},
          color={0,0,127},
          thickness=0.5),
        Line(
          points={{-30,-40},{0,-40},{0,-10},{30,-10}},
          color={0,0,127},
          thickness=0.5)}),
Documentation(info="<html>
<p>
This package contains composite control sequences from
ASHRAE Guideline 36. TerminalUnit sequences consist of atomic
control sequences from <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHU\">
Buildings.Controls.OBC.ASHRAE.G36.AHU</a> package.
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
end TerminalUnit;
