within Buildings.Templates.AHUs.Sensors;
model HumidityRatio
  extends Interfaces.Sensor(
    y(final unit="kg/kg"),
    final typ=Types.Sensor.AbsoluteHumidity);
  extends Data.AbsoluteHumidity
    annotation (IconMap(primitivesVisible=false));
  Fluid.Sensors.MassFractionTwoPort senMasFra(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Utilities.Psychrometrics.ToDryAir toDryAir annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,50})));
equation
  connect(port_a, senMasFra.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(senMasFra.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(senMasFra.X, toDryAir.XiTotalAir)
    annotation (Line(points={{0,11},{0,39}}, color={0,0,127}));
  connect(toDryAir.XiDry, y)
    annotation (Line(points={{0,61},{0,120}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end HumidityRatio;
