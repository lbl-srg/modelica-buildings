within Buildings.Electrical.AC.OnePhase.Lines;
model Network "Single phase AC network"
  extends Buildings.Electrical.Transmission.Base.PartialNetwork(
    redeclare Interfaces.Terminal_p terminal,
    redeclare Transmission.Grids.TestGrid2Nodes grid,
    redeclare Line lines(commercialCable_low=grid.cables));
equation
  for i in 1:grid.Nlinks loop
    connect(lines[i].terminal_p, terminal[grid.FromTo[i,1]]);
    connect(lines[i].terminal_n, terminal[grid.FromTo[i,2]]);
  end for;
  annotation (Icon(graphics={             Line(
          points={{-92,-60},{-72,-20},{-52,-60},{-32,-100},{-12,-60}},
          color={0,0,0},
          smooth=Smooth.Bezier)}));
end Network;
