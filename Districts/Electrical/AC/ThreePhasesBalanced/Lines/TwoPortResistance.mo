within Districts.Electrical.AC.ThreePhasesBalanced.Lines;
model TwoPortResistance
  extends Districts.Electrical.AC.OnePhase.Lines.TwoPortResistance(
      redeclare Interfaces.Terminal_n terminal_n,
      redeclare Interfaces.Terminal_p terminal_p);
end TwoPortResistance;
