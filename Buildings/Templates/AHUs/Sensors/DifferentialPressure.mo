within Buildings.Templates.AHUs.Sensors;
model DifferentialPressure
  extends Interfaces.Sensor(
    y(final unit="Pa"),
    final typ=Types.Sensor.DifferentialPressure);
  Fluid.Sensors.RelativePressure senRelPre(
    redeclare final package Medium=Medium)
    "Relative pressure sensor"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-50}})));
equation
  connect(port_a, senRelPre.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,
          -40},{-30,-40}}, color={0,127,255}));
  connect(port_a, port_b)
    annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
  connect(senRelPre.port_b, port_bRef)
    annotation (Line(points={{-10,-40},{0,-40},{0,-100}}, color={0,127,255}));
  connect(senRelPre.p_rel, y) annotation (Line(points={{-20,-31},{-20,-20},{0,-20},
          {0,120}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end DifferentialPressure;
