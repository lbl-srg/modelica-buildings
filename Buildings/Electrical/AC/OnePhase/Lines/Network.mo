within Buildings.Electrical.AC.OnePhase.Lines;
model Network "Single phase AC network"
  extends Buildings.Electrical.Transmission.BaseClasses.PartialNetwork(
    redeclare Interfaces.Terminal_p terminal,
    redeclare replaceable Transmission.Grids.TestGrid2Nodes grid,
    redeclare Line lines(
      commercialCable_low=grid.cables,
      each use_C=use_C,
      each modelMode=modelMode));
  parameter Boolean use_C = false "If true, model the cable capacity"
    annotation(Dialog(tab="Model", group="Assumptions"));
  parameter Buildings.Electrical.Types.Assumption modelMode=Types.Assumption.FixedZ_steady_state
    "Select between steady state and dynamic model"
    annotation(Dialog(tab="Model", group="Assumptions", enable = use_C), choices(choice=Buildings.Electrical.Types.Assumption.FixedZ_steady_state
        "Steady state", choice=Buildings.Electrical.Types.Assumption.FixedZ_dynamic "Dynamic"));
  Modelica.SIunits.Voltage Vabs[grid.nNodes] "RMS voltage of the grid nodes";
equation
  for i in 1:grid.nLinks loop
    connect(lines[i].terminal_p, terminal[grid.fromTo[i,1]]);
    connect(lines[i].terminal_n, terminal[grid.fromTo[i,2]]);
  end for;

  for i in 1:grid.nNodes loop
    Vabs[i] = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(terminal[i].v);
  end for;

  annotation (
    defaultComponentName="net",
Icon(graphics={             Line(
          points={{-92,-60},{-72,-20},{-52,-60},{-32,-100},{-12,-60}},
          color={0,0,0},
          smooth=Smooth.Bezier)}), Documentation(info="<html>
<p>
This model represents a generalized electrical AC single phase network.
</p>
<p>
Look at <a href=\"modelica://Buildings.Electrical.Transmission.BaseClasses.PartialNetwork\">
Buildings.Electrical.Transmission.BaseClasses.PartialNetwork</a>
for information about the network model.
</p>
<p>
Look at <a href=\"modelica://Buildings.Electrical.Transmission.Grids.PartialGrid\">
Buildings.Electrical.Transmission.Grids.PartialGrid</a>
for more information about the topology of the network, such as
the number of nodes, how they are connected, and the length of each connection.
</p>
</html>", revisions="<html>
<ul>
<li>
August 24, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
end Network;
