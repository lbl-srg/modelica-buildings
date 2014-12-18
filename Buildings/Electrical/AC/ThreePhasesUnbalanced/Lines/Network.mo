within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines;
model Network "Three phases unbalanced AC network without neutral cable"
  extends Transmission.BaseClasses.PartialNetwork(
    redeclare
      Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Terminal_p terminal,
    redeclare Transmission.Grids.TestGrid2Nodes grid,
    redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.Line lines(commercialCable=grid.cables));
    Modelica.SIunits.Voltage Vabs[3,grid.nNodes]
    "RMS voltage of the grid nodes";
equation
  for i in 1:grid.nLinks loop
    connect(lines[i].terminal_p, terminal[grid.fromTo[i,1]]);
    connect(lines[i].terminal_n, terminal[grid.fromTo[i,2]]);
  end for;

  // fixme: rename Vabs to VAbs to use camel case notation.
  for i in 1:grid.nNodes loop
    Vabs[1,i] = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(terminal[i].phase[1].v);
    Vabs[2,i] = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(terminal[i].phase[2].v);
    Vabs[3,i] = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(terminal[i].phase[3].v);
  end for;
  annotation (
  defaultComponentName="net",
 Documentation(revisions="<html>
<ul>
<li>
October 6, 2014, by Marco Bonvini:<br/>
Revised documentation and model.
</li>
</ul>
</html>", info="<html>
<p>
This model represents a generalized electrical AC three phases unbalanced network
without neutral cable.
</p>
<p>
See <a href=\"modelica://Buildings.Electrical.Transmission.BaseClasses.PartialNetwork\">
Buildings.Electrical.Transmission.BaseClasses.PartialNetwork</a>
for information about the network model.
</p>
<p>
See <a href=\"modelica://Buildings.Electrical.Transmission.Grids.PartialGrid\">
Buildings.Electrical.Transmission.Grids.PartialGrid</a>
for more information about the topology of the network, such as
the number of nodes, how they are connected, and the length of each connection.
</p>
</html>"));
end Network;
