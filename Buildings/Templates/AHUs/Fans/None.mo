within Buildings.Templates.AHUs.Fans;
model None "No fan"
  extends Interfaces.Fan(
    final typ=Types.Fan.None);
equation
  connect(port_a, port_b)
  annotation (Line(points={{-100,0},{6,0},{6,0},{100,0}}, color={0,127,255}));
  annotation (
    defaultComponentName="fan",
    Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Line(
          points={{-100,0},{100,0}},
          color={28,108,200},
          thickness=1)}),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end None;
