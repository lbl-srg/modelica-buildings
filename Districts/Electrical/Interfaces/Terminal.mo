within Districts.Electrical.Interfaces;
connector Terminal "General power terminal"
replaceable package PhaseSystem = PhaseSystems.PartialPhaseSystem
    "Phase system"
  annotation (choicesAllMatching=true);
PhaseSystem.Voltage v[PhaseSystem.n] "voltage vector";
flow PhaseSystem.Current i[PhaseSystem.n] "current vector";
PhaseSystem.ReferenceAngle theta[PhaseSystem.m] if PhaseSystem.m > 0
    "optional vector of phase angles";
  annotation (Icon(graphics));
end Terminal;
