within Buildings.Airflow.Multizone.BaseClasses.Examples;
model PowerLaw05
  "Test model for power law function with constant exponent of 0.5"
  extends Modelica.Icons.Example;
  parameter Real C = 2/10^m "Flow coefficient, C = V_flow/ dp^m";

  constant Real m(min=0.5, max=1) = 0.5
    "Flow exponent, m=0.5 for turbulent, m=1 for laminar";
  parameter Modelica.Units.SI.PressureDifference dp_turbulent(min=0) = 5
    "Pressure difference where regularization starts";
  final parameter Real sqrt_dp_turbulent(min=0) = sqrt(dp_turbulent)
    "Square root of pressure difference where regularization starts";

  Modelica.Units.SI.PressureDifference dp "Pressure difference";
  Modelica.Units.SI.VolumeFlowRate V_flow
    "Volume flow rate computed with model powerLaw";
  Modelica.Units.SI.VolumeFlowRate VFixed_flow
    "Volume flow rate computed with model powerLawFixed";

  constant Real gamma(min=1) = 1.5
    "Normalized flow rate where dphi(0)/dpi intersects phi(1)";
  constant Real a = gamma
    "Polynomial coefficient for regularized implementation of flow resistance";
  constant Real b = 1/8*m^2 - 3*gamma - 3/2*m + 35.0/8
    "Polynomial coefficient for regularized implementation of flow resistance";
  constant Real c = -1/4*m^2 + 3*gamma + 5/2*m - 21.0/4
    "Polynomial coefficient for regularized implementation of flow resistance";
  constant Real d = 1/8*m^2 - gamma - m + 15.0/8
    "Polynomial coefficient for regularized implementation of flow resistance";

equation
  dp = 10*(-1+2*time);
  V_flow = Buildings.Airflow.Multizone.BaseClasses.powerLaw(
    dp=dp,
    C=C,
    m=m,
    dp_turbulent=dp_turbulent);
  VFixed_flow = Buildings.Airflow.Multizone.BaseClasses.powerLaw05(
    C=C,
    dp=dp,
    a=a,
    b=b,
    c=c,
    d=d,
    dp_turbulent=dp_turbulent,
    sqrt_dp_turbulent=sqrt_dp_turbulent);
  assert(abs(V_flow-VFixed_flow) < 1E-10, "Error: The two implementations of the power law model need to give identical results");
  annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/BaseClasses/Examples/PowerLaw05.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This examples demonstrates the
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.powerLaw\">
Buildings.Airflow.Multizone.BaseClasses.powerLaw</a>
and
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.powerLaw05\">
Buildings.Airflow.Multizone.BaseClasses.powerLaw05</a>
functions.
They need to return the same function value.
This is verified by an <code>assert</code> statement.
</p>
</html>", revisions="<html>
<ul>
<li>
September 19. 2025, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2043\">IBPSA, #2043</a>.
</li>
</ul>
</html>"));
end PowerLaw05;
