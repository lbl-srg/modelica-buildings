within Buildings.Controls.OBC.UnitConversions;
block From_degF "Block that converts temperature from degree Fahrenheit to kelvin"

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u(
    final unit = "degF",
    final quantity = "ThermodynamicTemperature")
    "Temperature in degree Fahrenheit"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final unit = "K",
    final quantity = "ThermodynamicTemperature")
    "Temperature in kelvin"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  constant Real k = 5./9. "Multiplier";
  constant Real p = -32. * (5./9.) + 273.15 "Adder";

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k = k) "Gain factor"
    annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter conv(
    final p = p) "Unit converter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(conv.y, y)
    annotation (Line(points={{12,0},{60,0},{60,0},{120,0}},color={0,0,127}));
  connect(u, gai.u)
    annotation (Line(points={{-120,0},{-70,0}}, color={0,0,127}));
  connect(gai.y, conv.u)
    annotation (Line(points={{-46,0},{-12,0}}, color={0,0,127}));

  annotation (
      defaultComponentName = "from_degF",
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
          textString="degF"),
        Text(
          extent={{10,-70},{90,-30}},
          textColor={0,0,127},
          textString="K"),
        Polygon(
        points={{90,0},{30,20},{30,-20},{90,0}},
        lineColor={191,0,0},
        fillColor={191,0,0},
        fillPattern=FillPattern.Solid),
        Line(points={{-90,0},{30,0}}, color={191,0,0})}),
        Documentation(info="<html>
<p>
Converts temperature given in degree Fahrenheit [degF] to kelvin [K].
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
end From_degF;
