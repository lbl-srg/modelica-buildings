within Buildings.Electrical.AC.ThreePhasesBalanced.Lines;
model TwoPortInductance
  extends Buildings.Electrical.AC.OnePhase.Lines.TwoPortInductance(redeclare
      Interfaces.Terminal_n terminal_n, redeclare Interfaces.Terminal_p
      terminal_p);
  annotation (Diagram(graphics),                             Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                                  graphics));
end TwoPortInductance;
