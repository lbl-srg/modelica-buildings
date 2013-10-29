within Buildings.Electrical.AC.ThreePhasesBalanced.Sources;
model PVSimple
  import Buildings;
  extends Buildings.Electrical.AC.OnePhase.Sources.PVSimple(
    redeclare Interfaces.Terminal_p terminal,
    redeclare Loads.CapacitiveLoadP load);

end PVSimple;
