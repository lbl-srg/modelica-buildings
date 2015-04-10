within Buildings.Electrical.AC.ThreePhasesBalanced.Sensors;
model Probe "Model of a probe that measures RMS voltage and angle"
  extends OnePhase.Sensors.Probe(
  redeclare Buildings.Electrical.AC.ThreePhasesBalanced.Interfaces.Terminal_n term,
  V_nominal(start=480));
  annotation (
  defaultComponentName="sen",
  Documentation(info="<html>
<p>
This model represents a probe that measures the RMS voltage and the angle
of the voltage phasor at a given point.
</p>
</html>", revisions="<html>
<ul>
<li>
August 25, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>"));
end Probe;
