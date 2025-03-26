within Buildings.Templates.Components.Routing;
model Junction "Flow splitter with fixed resistance at each port"
  extends Buildings.Fluid.FixedResistances.Junction
  annotation (
    IconMap(primitivesVisible = false));

  parameter Buildings.Templates.Components.Types.IconPipe icon_pipe1 =
    Buildings.Templates.Components.Types.IconPipe.Supply
    "Pipe symbol - Branch 1"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Buildings.Templates.Components.Types.IconPipe icon_pipe2 = icon_pipe1
    "Pipe symbol - Branch 2"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Buildings.Templates.Components.Types.IconPipe icon_pipe3 = icon_pipe1
    "Pipe symbol - Branch 3"
    annotation(Dialog(tab="Graphics", enable=false));
  annotation (Icon(graphics={
  Line(
    points={{-100,0},{0,0}},
    color={0,0,0},
    thickness=5,
    pattern=if icon_pipe1==Buildings.Templates.Components.Types.IconPipe.Supply then
    LinePattern.Solid elseif icon_pipe1==Buildings.Templates.Components.Types.IconPipe.Return
    then LinePattern.Dash else LinePattern.None),
  Line(
    points={{0,0},{100,0}},
    color={0,0,0},
    thickness=5,
    pattern=if icon_pipe2==Buildings.Templates.Components.Types.IconPipe.Supply then
    LinePattern.Solid elseif icon_pipe2==Buildings.Templates.Components.Types.IconPipe.Return
    then LinePattern.Dash else LinePattern.None),
  Line(
    points={{0,0},{0,-100}},
    color={0,0,0},
    thickness=5,
    pattern=if icon_pipe3==Buildings.Templates.Components.Types.IconPipe.Supply then
    LinePattern.Solid elseif icon_pipe3==Buildings.Templates.Components.Types.IconPipe.Return
    then LinePattern.Dash else LinePattern.None)}), Documentation(info="<html>
<p>
This is a model of a flow junction with an optional fixed resistance 
in each flow leg and an optional mixing volume at the junction.
This model is identical to 
<a href=\"modelica://Buildings.Fluid.FixedResistances.Junction\">
Buildings.Fluid.FixedResistances.Junction</a>
except for the icon which has been changed for better integration
into the templates.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Junction;
