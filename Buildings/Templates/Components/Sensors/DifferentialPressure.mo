within Buildings.Templates.Components.Sensors;
model DifferentialPressure
  extends Buildings.Templates.Interfaces.Sensor(
    y(final unit="Pa", displayUnit="Pa"),
    final isDifPreSen=true);

  Fluid.Sensors.RelativePressure senRelPre(
    redeclare final package Medium=Medium) if have_sen
    "Relative pressure sensor"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-50}})));
equation
  connect(port_a, senRelPre.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,
          -40},{-50,-40}}, color={0,127,255}));
  connect(port_a, port_b)
    annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
  connect(senRelPre.port_b, port_bRef)
    annotation (Line(points={{-30,-40},{0,-40},{0,-100}}, color={0,127,255}));
  connect(senRelPre.p_rel, y) annotation (Line(points={{-40,-31},{-40,80},{0,80},
          {0,120}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end DifferentialPressure;
