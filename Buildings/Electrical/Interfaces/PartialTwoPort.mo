within Buildings.Electrical.Interfaces;
model PartialTwoPort "Model of a generic two port component with phase systems"

  replaceable package PhaseSystem_p =
      Buildings.Electrical.PhaseSystems.PartialPhaseSystem constrainedby
    Buildings.Electrical.PhaseSystems.PartialPhaseSystem
    "Phase system of terminal p"
    annotation (choicesAllMatching=true);

  replaceable package PhaseSystem_n =
      Buildings.Electrical.PhaseSystems.PartialPhaseSystem constrainedby
    Buildings.Electrical.PhaseSystems.PartialPhaseSystem
    "Phase system of terminal n"
    annotation (choicesAllMatching=true);

  extends Buildings.Electrical.Interfaces.PartialBaseTwoPort(
    redeclare replaceable Buildings.Electrical.Interfaces.Terminal terminal_n
      constrainedby Buildings.Electrical.Interfaces.Terminal(
        redeclare replaceable package PhaseSystem = PhaseSystem_n),
    redeclare replaceable Buildings.Electrical.Interfaces.Terminal terminal_p
      constrainedby Buildings.Electrical.Interfaces.Terminal(
        redeclare replaceable package PhaseSystem=PhaseSystem_p));

  annotation (Documentation(revisions="<html>
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
This is a model of a component with two electric terminals.
It represents a common interface that is extended by other models.
</p>
</html>"));
end PartialTwoPort;
