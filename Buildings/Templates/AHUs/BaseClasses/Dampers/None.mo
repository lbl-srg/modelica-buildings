within Buildings.Templates.AHUs.BaseClasses.Dampers;
model None
  extends Buildings.Templates.Interfaces.Damper(
    final typ=Templates.AHUs.Types.Damper.None)
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
equation
  connect(port_a, port_b)
    annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
  annotation (Icon(graphics={                                 Line(
          points={{-100,0},{100,0}},
          color={28,108,200},
          thickness=1)}));
end None;
