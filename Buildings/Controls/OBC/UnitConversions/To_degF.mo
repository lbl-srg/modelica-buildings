block To_degF "Block that converts temperature from degree Fahrenheit to kelvin"

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u(
    final unit = "degF",
    final quantity = "ThermodynamicTemperature")
    "Temperature in degree Fahrenheit"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final unit = "K",
    final quantity = "ThermodynamicTemperature")
    "Temperature in kelvin"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  parameter Real k = 9./5. "Multiplier";
  parameter Real p = (-9./5.) * 273.15 + 32 "Adder";

  Buildings.Controls.OBC.CDL.Continuous.AddParameter conv(
    final p = p,
    final k = k) "Unit converter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(u, conv.u)
    annotation (Line(points={{-60,0},{-12,0}}, color={0,0,127}));
  connect(conv.y, y)
    annotation (Line(points={{11,0},{50,0}}, color={0,0,127}));
  annotation (
      defaultComponentName = "To_degF",
    Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{20,58}}, color={28,108,200}),
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Text(
          extent={{-80,40},{0,0}},
          lineColor={0,0,127},
          textString="degF"),
        Text(
          extent={{0,-40},{80,0}},
          lineColor={0,0,127},
          textString="K")}),
        Documentation(info="<html>
<p>
Converts temperature given in degree Fahrenheit [degF] to kelvin [K].
</p>
</html>", revisions="<html>
<ul>
<li>
July 05, 2018, by Milica Grahovac:<br/>
Generated with Buildings/Resources/src/Controls/OBC/UnitConversions/unit_converters.py
First implementation.
</li>
</ul>
</html>"));
end To_degF;
