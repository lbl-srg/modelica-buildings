within Buildings.Airflow.Multizone.BaseClasses;
model PowerLawResistanceParameters "Power law resistance parameters"
  parameter Real m(min=0.5, max=1)
    "Flow exponent, m=0.5 for turbulent, m=1 for laminar";
protected
  constant Real gamma(min=1) = 1.5
    "Normalized flow rate where dphi(0)/dpi intersects phi(1)";

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
</html>", revisions="<html>
<ul>
<li>
June 26, 2021, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>
"));
end PowerLawResistanceParameters;
