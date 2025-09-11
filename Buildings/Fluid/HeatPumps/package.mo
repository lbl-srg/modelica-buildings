within Buildings.Fluid;
package HeatPumps "Package with models for heat pumps"
  extends Modelica.Icons.Package;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains component models for heat pumps.
</p>
<p>
For chiller models, see
<a href=\"Buildings.Fluid.Chillers\">Buildings.Fluid.Chillers</a>.
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
end HeatPumps;
