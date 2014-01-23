within Districts.Electrical.AC.ThreePhasesBalanced.Sources;
model PVSimple
  import Districts;
  extends Districts.Electrical.AC.OnePhase.Sources.PVSimple(
    redeclare Interfaces.Terminal_p terminal,
    redeclare Loads.CapacitiveLoadP load);

end PVSimple;
