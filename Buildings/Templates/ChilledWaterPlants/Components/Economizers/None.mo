within Buildings.Templates.ChilledWaterPlants.Components.Economizers;
model None "No waterside economizer"
  extends Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialEconomizer(
    final typ=Buildings.Templates.ChilledWaterPlants.Types.Economizer.None);

equation
  connect(port_a, port_b)
    annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
annotation (
 defaultComponentName="eco",
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
When no waterside economizer is considered this model shall
be used in replacement of the waterside economizer component.
The model resolves into a simple fluid pass-through on the CHW 
side, 
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
  Line(
          points={{400,80},{400,-80}},
          color={0,0,0},
          thickness=5,
          pattern=LinePattern.Dash)}));
end None;
