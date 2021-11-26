within Buildings.Templates.Components.Fans;
model None "No fan"
  extends Buildings.Templates.Components.Fans.Interfaces.PartialFan(
    final typ=Buildings.Templates.Components.Types.Fan.None);
equation
  connect(port_a, V_flow.port_a)
    annotation (Line(points={{-100,0},{70,0}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Line(
          points={{-100,0},{100,0}},
          color={28,108,200},
          thickness=1)}),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
end None;
