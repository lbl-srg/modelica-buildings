within Buildings.Controls.OBC.ASHRAE.G36_PR1;
package TerminalUnits "Control sequences for terminal units"

  annotation (
Documentation(info="<html>
<p>
This package contains control sequences for terminal units.
</p>
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
          thickness=0.5)}));
end TerminalUnits;
