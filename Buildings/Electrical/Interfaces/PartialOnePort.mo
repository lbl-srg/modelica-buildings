within Buildings.Electrical.Interfaces;
model PartialOnePort "Model of a generic one port component with phase systems"

  replaceable package PhaseSystem =
  Buildings.Electrical.PhaseSystems.PartialPhaseSystem constrainedby
    Buildings.Electrical.PhaseSystems.PartialPhaseSystem
  "Phase system";

  extends Buildings.Electrical.Interfaces.PartialBaseOnePort(
  redeclare replaceable Buildings.Electrical.Interfaces.Terminal terminal(
  redeclare replaceable package PhaseSystem = PhaseSystem));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
  coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This is a model of a component with one electric terminal. It represents 
a common interface that is extended by other models. </p>
</html>", revisions="<html>
<ul>
<li>October 15, 2021, by Mingzhe Liu:<br>First implementation. </li>
</ul>
</html>"));

end PartialOnePort;
