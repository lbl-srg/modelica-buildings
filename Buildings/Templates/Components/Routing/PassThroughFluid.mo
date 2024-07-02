within Buildings.Templates.Components.Routing;
model PassThroughFluid "Direct fluid pass-through"
  extends Buildings.Fluid.Interfaces.PartialTwoPort
    annotation (
    IconMap(primitivesVisible = false));

  parameter Buildings.Templates.Components.Types.IntegrationPoint icon_pipe=
      Buildings.Templates.Components.Types.IntegrationPoint.Supply
    "Pipe symbol" annotation (Dialog(tab="Graphics", enable=false));

equation
  connect(port_a, port_b) annotation (Line(points={{-100,0},{0,0},{0,0},{100,0}},
        color={0,127,255}));
  annotation (
    defaultComponentName="pas",
    Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={
    Line(
    points={{-100,0},{100,0}},
    color={0,0,0},
    thickness=5,
    visible=icon_pipe<>Buildings.Templates.Components.Types.IntegrationPoint.None,
    pattern=if icon_pipe==Buildings.Templates.Components.Types.IntegrationPoint.Supply then
    LinePattern.Solid else LinePattern.Dash)}),
    Documentation(info="<html>
<p>
This is a model of a direct fluid pass-through used for
templating purposes.
</p>
</html>", revisions="<html>
<ul>
<li>
February 11, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PassThroughFluid;
