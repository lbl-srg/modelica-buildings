within Buildings.Templates.AHUs.Sensors;
model AbsoluteHumidity
  extends Interfaces.Sensor(
    y(final unit="kg/kg"),
    final typ=Types.Sensor.AbsoluteHumidity);
  extends Data.AbsoluteHumidity
    annotation (IconMap(primitivesVisible=false));
  Fluid.Sensors.MassFractionTwoPort senMasFra(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(port_a, senMasFra.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(senMasFra.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end AbsoluteHumidity;
