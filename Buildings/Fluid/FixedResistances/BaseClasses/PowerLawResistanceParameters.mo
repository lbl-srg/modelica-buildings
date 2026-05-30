within Buildings.Fluid.FixedResistances.BaseClasses;
model PowerLawResistanceParameters "Power law resistance parameters"
  parameter Real n(min=1, max=2)
    "Flow exponent, n=1 for laminar, n=2 for turbulent";
protected
  constant Real gamma(min=1) = 1.5
    "Normalized flow rate where dphi(0)/dpi intersects phi(1)";
  parameter Real m = 1/n "Flow exponent";
  parameter Real a = gamma
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real b = 1/8*m^2 - 3*gamma - 3/2*m + 35.0/8
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real c = -1/4*m^2 + 3*gamma + 5/2*m - 21.0/4
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real d = 1/8*m^2 - gamma - m + 15.0/8
    "Polynomial coefficient for regularized implementation of flow resistance";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Parameters that are required for the components that implement a power law resistance.
</p>
<p>
This model is similar to
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.PowerLawResistanceParameters\">
Buildings.Airflow.Multizone.BaseClasses.PowerLawResistanceParameters</a>
but it uses the parameter <code>n=1/m</code> as this is more customary
for use in flow through pipes and ducts.
</p>
</html>", revisions="<html>
<ul>
<li>
May 29, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>
"));
end PowerLawResistanceParameters;
