within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1NLoadsLinearized
  "Validation of AWHP plant template with a distributed set of terminal loads"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1NLoads(
    pla(linearized=true));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"),
  Documentation(
    info="",
    revisions="<html>
<ul>
<li>
September 18, 2026, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end HardCase1NLoadsLinearized;
