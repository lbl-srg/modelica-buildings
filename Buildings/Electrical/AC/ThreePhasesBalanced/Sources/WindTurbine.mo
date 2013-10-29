within Buildings.Electrical.AC.ThreePhasesBalanced.Sources;
model WindTurbine
  import Buildings;
  extends Buildings.Electrical.AC.OnePhase.Sources.WindTurbine(
    redeclare Interfaces.Terminal_p terminal,
    redeclare Loads.CapacitiveLoadP load);
end WindTurbine;
