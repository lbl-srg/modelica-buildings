within Buildings.Controls.OBC.ASHRAE.G36.AHUs;
package SingleZone "Sequences for single zone AHU control"

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains control sequences from ASHRAE Guideline 36 for single zone air handling units.
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
            extent={{-66,70},{70,-72}},
            lineColor={0,0,127},
            lineThickness=0.5)}));
end SingleZone;
