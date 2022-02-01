within Buildings.Controls.OBC.UnitConversions;
block From_psi "Block that converts pressure from pound-force per square inch to pascal"

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u(
    final quantity = "Pressure")
    "Pressure in pound-force per square inch"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final unit = "Pa",
    final quantity = "Pressure")
    "Pressure in pascal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  constant Real k = 6895. "Multiplier";

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter conv(
    final k = k) "Unit converter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(u, conv.u)
    annotation (Line(points={{-120,0},{-12,0}},color={0,0,127}));
  connect(conv.y, y)
    annotation (Line(points={{12,0},{120,0}},color={0,0,127}));
  annotation (
      defaultComponentName = "from_psi",
    Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{20,58}}, color={28,108,200}),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Text(
          extent={{-80,50},{0,10}},
          textColor={0,0,127},
          textString="psi"),
        Text(
          extent={{10,-70},{90,-30}},
          textColor={0,0,127},
          textString="Pa"),
        Polygon(
        points={{90,0},{30,20},{30,-20},{90,0}},
        lineColor={191,0,0},
        fillColor={191,0,0},
        fillPattern=FillPattern.Solid),
        Line(points={{-90,0},{30,0}}, color={191,0,0})}),
        Documentation(info="<html>
<p>
Converts pressure given in pound-force per square inch [psi] to pascal [Pa].
</p>
</html>", revisions="<html>
<ul>
<li>
November 29, 2021, by Michael Wetter:<br/>
Regenerated files with <code>Text</code> annotation using now the <code>textColor</code> attribute
rather than the deprecated <code>lineColor</code> attribute.
</li>
<li>
July 05, 2018, by Milica Grahovac:<br/>
Generated with <code>Buildings/Resources/src/Controls/OBC/UnitConversions/unit_converters.py</code>.<br/>
First implementation.
</li>
</ul>
</html>"));
end From_psi;
