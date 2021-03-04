within Buildings.Templates.AHUs.Sensors;
model None
  extends Buildings.Templates.AHUs.Interfaces.Sensor(
    final typ=Types.Sensor.None);
equation
  connect(port_a, port_b)
    annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
  annotation (
    defaultComponentName="sen",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                              Line(
          points={{-100,0},{100,0}},
          color={28,108,200},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end None;
