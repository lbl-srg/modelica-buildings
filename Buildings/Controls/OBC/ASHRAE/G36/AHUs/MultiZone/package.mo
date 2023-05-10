within Buildings.Controls.OBC.ASHRAE.G36.AHUs;
package MultiZone "Sequences for multi zone AHU control"

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains control sequences from ASHRAE Guideline 36 for multi zone air handling units.
</p>
</html>"),
  Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),      Rectangle(
            extent={{-78,78},{74,-76}},
            lineColor={0,0,0},
            lineThickness=0.5),
                             Rectangle(
            extent={{-44,44},{40,-42}},
            lineColor={0,0,0},
            lineThickness=0.5),
      Line(
        points={{-24,44},{-24,78}},
        color={0,0,0},
        thickness=0.5),
      Line(
        points={{20,44},{20,78}},
        color={0,0,0},
        thickness=0.5),
      Line(
        points={{22,-76},{22,-42}},
        color={0,0,0},
        thickness=0.5),
      Line(
        points={{-22,-76},{-22,-42}},
        color={0,0,0},
        thickness=0.5),
      Line(
        points={{-78,24},{-44,24}},
        color={0,0,0},
        thickness=0.5),
      Line(
        points={{-78,-24},{-44,-24}},
        color={0,0,0},
        thickness=0.5),
      Line(
        points={{40,-24},{74,-24}},
        color={0,0,0},
        thickness=0.5),
      Line(
        points={{40,24},{74,24}},
        color={0,0,0},
        thickness=0.5)}));
end MultiZone;
