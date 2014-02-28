within Buildings.Electrical.Interfaces;
partial model PartialGround
  replaceable package PhaseSystem =
      Buildings.Electrical.PhaseSystems.PartialPhaseSystem constrainedby
    Buildings.Electrical.PhaseSystems.PartialPhaseSystem "Phase system"
    annotation (choicesAllMatching=true);

  replaceable Buildings.Electrical.Interfaces.Terminal terminal(redeclare
      package PhaseSystem = PhaseSystem) "Generalised terminal"
    annotation (Placement(transformation(extent={{-8,92},{8,108}}),
        iconTransformation(extent={{-8,92},{8,108}})));
equation
  terminal.v = zeros(PhaseSystem.n);
end PartialGround;
