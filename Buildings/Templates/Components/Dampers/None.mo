within Buildings.Templates.Components.Dampers;
model None "No damper"
  extends Buildings.Templates.Components.Dampers.Interfaces.PartialDamper(
    final typ=Buildings.Templates.Components.Types.Damper.None)
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
