within Buildings.Electrical.Interfaces;
model PartialTwoPort
  replaceable package PhaseSystem_p =
      Buildings.Electrical.PhaseSystems.PartialPhaseSystem constrainedby
    Buildings.Electrical.PhaseSystems.PartialPhaseSystem
    "Phase system: terminal p"
    annotation (choicesAllMatching=true);
  replaceable package PhaseSystem_n =
      Buildings.Electrical.PhaseSystems.PartialPhaseSystem constrainedby
    Buildings.Electrical.PhaseSystems.PartialPhaseSystem
    "Phase system: terminal n"
    annotation (choicesAllMatching=true);
  replaceable Buildings.Electrical.Interfaces.Terminal terminal_n(redeclare
      package PhaseSystem = PhaseSystem_n) "Generalised terminal"
    annotation (Placement(transformation(extent={{-108,-8},{-92,8}})));
  replaceable Buildings.Electrical.Interfaces.Terminal terminal_p(redeclare
      package PhaseSystem = PhaseSystem_p) "Generalised terminal"
    annotation (Placement(transformation(extent={{92,-8},{108,8}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end PartialTwoPort;
