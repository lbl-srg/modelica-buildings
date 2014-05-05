within Districts.Electrical.AC.ThreePhasesBalanced.Lines;
model TwoPortInductance
  extends Districts.Electrical.AC.OnePhase.Lines.TwoPortInductance(
      redeclare Interfaces.Terminal_n terminal_n,
      redeclare Interfaces.Terminal_p terminal_p);
end TwoPortInductance;
