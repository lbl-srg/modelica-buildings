within Buildings.Templates.ChilledWaterPlants.Components.Economizers;
model None "No waterside economizer"
  extends Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialEconomizer(
    final typ=Buildings.Templates.ChilledWaterPlants.Types.Economizer.None);

equation
  connect(port_a, port_b)
    annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
annotation (
 defaultComponentName="eco",
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end None;
