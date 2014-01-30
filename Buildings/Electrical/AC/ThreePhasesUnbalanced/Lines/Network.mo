within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines;
model Network
  extends Transmission.Base.PartialNetwork(
    redeclare
      Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Terminal_p         terminal,
    redeclare Transmission.Grids.TestGrid2Nodes grid,
    redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.Line lines(commercialCable_low=grid.cables));
equation
  for i in 1:grid.Nlinks loop
    connect(lines[i].terminal_p, terminal[grid.FromTo[i,1]]);
    connect(lines[i].terminal_n, terminal[grid.FromTo[i,2]]);
  end for;
end Network;
