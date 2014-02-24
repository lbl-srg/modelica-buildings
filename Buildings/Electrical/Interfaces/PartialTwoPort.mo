within Buildings.Electrical.Interfaces;
model PartialTwoPort
  "Partial model for a generic two port systems. It does not contain any constraint or relationship between the two ports"
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
  extends Buildings.Electrical.Interfaces.PartialBaseTwoPort( redeclare replaceable
      Buildings.Electrical.Interfaces.Terminal                                                                   terminal_n(redeclare
        replaceable package PhaseSystem=PhaseSystem_n), redeclare replaceable
      Buildings.Electrical.Interfaces.Terminal                                                 terminal_p(redeclare
        replaceable package PhaseSystem=PhaseSystem_p));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(revisions="<html>
<ul>
<li>
October 31, 2013, by Marco Bonvini:<br/>
Model included into the Buildings library.
</li>
</ul>
</html>"));
end PartialTwoPort;
