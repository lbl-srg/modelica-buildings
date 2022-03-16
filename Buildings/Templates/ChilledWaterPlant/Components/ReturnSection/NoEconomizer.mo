within Buildings.Templates.ChilledWaterPlant.Components.ReturnSection;
model NoEconomizer
  extends
    Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.Interfaces.PartialReturnSection(
      dat(final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.ReturnSection.NoEconomizer));

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
end NoEconomizer;
