within Districts.Electrical.AC.ThreePhasesBalanced.Lines;
model TwoPortRL
  extends Districts.Electrical.AC.OnePhase.Lines.TwoPortRL(
      redeclare Interfaces.Terminal_n terminal_n,
      redeclare Interfaces.Terminal_p terminal_p);
end TwoPortRL;
