within Buildings.Templates.ChilledWaterPlants.Components.EconomizerSection;
model None "No economizer"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.EconomizerSection.Interfaces.PartialEconomizer(
      final typ=Buildings.Templates.ChilledWaterPlants.Components.Types.EconomizerFlowControl.NoEconomizer);

equation
  connect(port_b2, port_a2)
    annotation (Line(points={{-100,-60},{100,-60}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Icon(graphics={
      Line(
        points={{-102,-60},{100,-60}},
        color={28,108,200},
        thickness=1)}));
end None;
