within Districts.Electrical.AC.ThreePhasesBalanced.Sources;
model WindTurbine
  import Districts;
  extends Districts.Electrical.AC.OnePhase.Sources.WindTurbine(
    redeclare Interfaces.Terminal_p terminal,
    redeclare Loads.CapacitiveLoadP load);
end WindTurbine;
