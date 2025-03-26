within Buildings.Electrical.Interfaces;
model Ground "Generalized model of a ground connection."
  replaceable package PhaseSystem =
      Buildings.Electrical.PhaseSystems.PartialPhaseSystem constrainedby
    Buildings.Electrical.PhaseSystems.PartialPhaseSystem "Phase system"
    annotation (choicesAllMatching=true);

  replaceable Buildings.Electrical.Interfaces.Terminal terminal(
    redeclare package PhaseSystem = PhaseSystem) "Generalized terminal"
    annotation (Placement(transformation(extent={{-8,92},{8,108}}),
        iconTransformation(extent={{-8,92},{8,108}})));
equation
  terminal.v = zeros(PhaseSystem.n);
  annotation (Documentation(info="<html>
<p>
Given a generic electric connector
<a href=\"modelica://Buildings.Electrical.Interfaces.Terminal\">
Buildings.Electrical.Interfaces.Terminal</a> this
model imposes the following condition on the voltage <code>V[PhaseSystem.n]</code>
</p>
<p align=\"center\" style=\"font-style:italic;\">
<b>V</b> = <span style=\"text-decoration: overline;\">0</span>,
</p>
<p>
where <span style=\"text-decoration: overline;\">0</span> is a null vector of length <code>PhaseSystem.n</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 15, 2014, by Marco Bonvini:<br/>
Created documentation.
</li>
</ul>
</html>"));
end Ground;
