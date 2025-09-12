within Buildings.Fluid;
package CHPs "Package with model for combined heat and power device"
 extends Modelica.Icons.Package;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains models for combined heat and power plant.
</p>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-60,60},{60,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{12,-38},{32,24}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-12,-38},{-32,24}},
          color={0,0,0},
          thickness=0.5)}));
end CHPs;
