within Buildings.Electrical.Interfaces;
model PartialTwoPort
  "Partial model of a generic two port systems with phase systems"
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
May 15, 2014, by Marco Bonvini:<br/>
Created documentation.
</li>
<li>
October 31, 2013, by Marco Bonvini:<br/>
Model included into the Buildings library.
</li>
</ul>
</html>", info="<html>
<p>
This is a partial model of a coponent with two electic terminals. It represents a common interface extendable by other models.
</p>
</html>"));
end PartialTwoPort;
