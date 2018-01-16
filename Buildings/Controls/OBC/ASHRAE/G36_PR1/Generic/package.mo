within Buildings.Controls.OBC.ASHRAE.G36_PR1;
package Generic "Generic control sequences"

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains generic sequences that would be needed for both AHU and
terminal units control.
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
          radius=25.0)}));
end Generic;
