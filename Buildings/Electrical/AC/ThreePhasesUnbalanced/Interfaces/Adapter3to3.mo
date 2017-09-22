within Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces;
model Adapter3to3
  "Adapter from 3 single phase connectors to a connector with 3 phases"
  extends Modelica.Blocks.Icons.Block;

  Buildings.Electrical.Interfaces.Terminal terminals[3](
    redeclare final package PhaseSystem = PhaseSystems.OnePhase)
    "Generalized terminal"
    annotation (Placement(transformation(extent={{-92,-6},{-108,10}}),
        iconTransformation(extent={{-106,8},{-90,-8}})));

  Interfaces.Terminal_p terminal "Connector with 3 lines"
   annotation (Placement(transformation(extent={{90,-10},{110,10}}),
                          iconTransformation(extent={{90,-10},{110,10}})));
equation
  for i in 1:3 loop
    terminal.phase[i].v     = terminals[i].v;
    terminal.phase[i].i     = -terminals[i].i;
    Connections.branch(terminal.phase[i].theta, terminals[i].theta);
    terminal.phase[i].theta = terminals[i].theta;
  end for;

  annotation (
  defaultComponentName="ada",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(points={{-64,0},{66,0}}, color={28,108,200})}),    Documentation(info="<html>
<p>
Adapter that connect 3 single phase connectors with a connector that has 3 phases.
</p>
</html>", revisions="<html>
<ul>
<li>
February 25, 2016, by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
</ul>
</html>"));
end Adapter3to3;
