within Buildings.Templates.Components.Valves;
model None "No valve"
  extends Buildings.Templates.Components.Valves.Interfaces.PartialValve(
    final typ=Buildings.Templates.Components.Types.Valve.None);

equation
  connect(port_a, port_b)
    annotation (Line(points={{-100,0},{100,0},{100,0}}, color={0,127,255}));
end None;
