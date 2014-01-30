within Buildings.Electrical.Interfaces;
connector Terminal "General electric terminal"
  extends Buildings.Electrical.Interfaces.BaseTerminal;
replaceable package PhaseSystem = PhaseSystems.PartialPhaseSystem
    "Phase system"
  annotation (choicesAllMatching=true);
PhaseSystem.Voltage v[PhaseSystem.n] "Voltage vector";
flow PhaseSystem.Current i[PhaseSystem.n] "Current vector";
PhaseSystem.ReferenceAngle theta[PhaseSystem.m] if PhaseSystem.m > 0
    "Optional vector of phase angles";
  annotation (Icon(graphics), Documentation(revisions="<html>
<ul>
<li>
October 31, 2013, by Marco Bonvini:<br/>
Model included into the Buildings library.
</li>
</ul>
</html>"));
end Terminal;
