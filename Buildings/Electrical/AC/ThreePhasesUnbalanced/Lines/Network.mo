within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines;
model Network
  extends Transmission.BaseClasses.PartialNetwork(
    redeclare
      Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Terminal_p         terminal,
    redeclare Transmission.Grids.TestGrid2Nodes grid,
    redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.Line lines(commercialCable_low=grid.cables));
    Modelica.SIunits.Voltage Vabs[3,grid.Nnodes] "RMS voltage of the grid nodes";
equation
  for i in 1:grid.Nlinks loop
    connect(lines[i].terminal_p, terminal[grid.FromTo[i,1]]);
    connect(lines[i].terminal_n, terminal[grid.FromTo[i,2]]);
  end for;

  for i in 1:grid.Nnodes loop
    Vabs[1,i] = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(terminal[i].phase[1].v);
    Vabs[2,i] = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(terminal[i].phase[2].v);
    Vabs[3,i] = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(terminal[i].phase[3].v);
  end for;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Network;
