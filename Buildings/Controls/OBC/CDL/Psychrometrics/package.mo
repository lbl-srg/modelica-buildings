within Buildings.Controls.OBC.CDL;
package Psychrometrics "Package with psychrometric blocks"
  annotation (
    Documentation(
      info="<html>
<p>
This package contains blocks for psychrometric calculations.
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
        Line(
          points={{-78,86},{-78,-72}}),
        Polygon(
          points={{-78,88},{-76,74},{-80,74},{-78,88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-74,84},{-52,66}},
          textColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="X"),
        Line(
          points={{-78,-46},{-64,-42},{-40,-32},{-16,-18},{10,6},{30,40},{38,72}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{72,-72},{-76,-72}}),
        Polygon(
          points={{74,-72},{64,-70},{64,-74},{74,-72}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{72,-80},{82,-96}},
          textColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="T")}));
end Psychrometrics;
