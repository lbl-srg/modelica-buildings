within Buildings.Templates.ChilledWaterPlant.Components.Economizer;
model None "No economizer"
  extends
    Buildings.Templates.ChilledWaterPlant.Components.Economizer.Interfaces.PartialEconomizer(
     final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.Economizer.NoEconomizer);

equation
  connect(port_b2, port_a2)
    annotation (Line(points={{-100,-60},{100,-60}}, color={0,127,255}));
  connect(port_a1, port_b1)
    annotation (Line(points={{-100,60},{100,60}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Icon(graphics={
      Line(
        points={{-102,-60},{100,-60}},
        color={28,108,200},
        thickness=1),
      Line(
        points={{100,60},{-100,60}},
        color={28,108,200},
        thickness=1)}));
end None;
