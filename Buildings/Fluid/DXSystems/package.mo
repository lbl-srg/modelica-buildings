within Buildings.Fluid;
package DXSystems "DX(Direct Expansion) cooling coil models"
  extends Modelica.Icons.Package;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains air source and water source DX coil models.
</p>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-80,60},{40,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Ellipse(
          extent={{-60,40},{20,-40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-32,38},{-52,-24}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-8,38},{12,-24}},
          color={0,0,0},
          thickness=0.5),
        Rectangle(
          extent={{40,60},{80,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(
          points={{80,60},{40,-60}},
          color={0,0,0},
          thickness=0.5)}));
end DXSystems;
