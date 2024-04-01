within Buildings.Templates.Plants.Controls;
package Setpoints "Plant reset logic"
  annotation (
    preferredView="info",
    Documentation(
      info="<html>
<p>
This package contains plant reset sequences.
</p>
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
          extent={{-100,100},{100,-100}},
          textColor={0,0,0},
          textString="S")}));
end Setpoints;
