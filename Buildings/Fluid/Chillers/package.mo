within Buildings.Fluid;
package Chillers "Package with models for chillers"
  extends Modelica.Icons.Package;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains component models for chillers.
</p>
<p>
For heat pump models, see
<a href=\"Buildings.Fluid.HeatPumps\">Buildings.Fluid.HeatPumps</a>.
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
          points={{-12,38},{-32,-24}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{12,38},{32,-24}},
          color={0,0,0},
          thickness=0.5)}));
end Chillers;
