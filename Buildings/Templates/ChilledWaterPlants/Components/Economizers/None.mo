within Buildings.Templates.ChilledWaterPlants.Components.Economizers;
model None "No economizer"
  extends Buildings.Templates.ChilledWaterPlants.Components.Economizers.Interfaces.PartialEconomizer(
    final typ=Buildings.Templates.ChilledWaterPlants.Types.Economizer.None);

equation
  connect(port_a, port_b)
    annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
annotation (
 defaultComponentName="eco",
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Icon(graphics={
      Line(
        points={{-102,-60},{100,-60}},
        color={28,108,200},
        thickness=1)}));
end None;
