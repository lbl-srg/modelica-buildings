within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines;
model NetworkN
  extends Transmission.Base.PartialNetwork(
    redeclare
      Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Terminal4_p         terminal,
    redeclare Transmission.Grids.TestGrid2Nodes grid,
    redeclare Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.LineN lines(commercialCable_low=grid.cables));
    Modelica.SIunits.Voltage Vabs[3,grid.Nnodes]
    "RMS voltage of the grid nodes";
equation
  for i in 1:grid.Nlinks loop
    connect(lines[i].terminal_p, terminal[grid.FromTo[i,1]]);
    connect(lines[i].terminal_n, terminal[grid.FromTo[i,2]]);
  end for;

  for i in 1:grid.Nnodes loop
    Vabs[1,i] = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(terminal[i].phase[1].v - terminal[i].phase[4].v);
    Vabs[2,i] = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(terminal[i].phase[2].v - terminal[i].phase[4].v);
    Vabs[3,i] = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(terminal[i].phase[3].v - terminal[i].phase[4].v);
  end for;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end NetworkN;
