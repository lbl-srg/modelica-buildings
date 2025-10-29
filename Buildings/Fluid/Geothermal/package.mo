within Buildings.Fluid;
package Geothermal "Package with models for geothermal heat exchange"
  extends Modelica.Icons.Package;

annotation (preferredView="info", Documentation(info="<html>
<p>
Package with models for geothermal heat exchange.
</p>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-80,60},{80,-60}},
          lineColor={255,255,255},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,60},{80,60}},
          color={0,0,0},
          thickness=1),
        Line(
          points={{-60,60},{-60,-40},{-48,-40},{-48,60}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-6,60},{-6,-40},{6,-40},{6,60}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{48,60},{48,-40},{60,-40},{60,60}},
          color={0,0,0},
          thickness=0.5)}));
end Geothermal;
