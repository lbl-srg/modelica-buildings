within Buildings.Fluid.FixedResistances.BaseClasses.Validation;
model PowerLawFixedM "Test model for power law function"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Density rho = 1.2 "Fluid density";
  parameter Real C = 2/10^m "Flow coefficient, C = V_flow/ dp^m";
  parameter Real k = 2/10^m * rho "Flow coefficient, k = m_flow/ dp^m";

  constant Real m(min=0.5, max=1) = 0.8
    "Flow exponent, m=0.5 for turbulent, m=1 for laminar";
  parameter Modelica.Units.SI.PressureDifference dp_turbulent(min=0) = 5
    "Pressure difference where regularization starts";

  Modelica.Units.SI.PressureDifference dp "Pressure difference";
  Modelica.Units.SI.VolumeFlowRate V_flow
    "Volume flow rate computed with model powerLawFixedM that uses C";
  Modelica.Units.SI.MassFlowRate m2_flow
    "Mass flow rate computed based on V_flow to compare equality with m_flow";
  Modelica.Units.SI.MassFlowRate m_flow
    "Mass flow rate computed with model powerLawFixedM that uses k";

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
  V_flow = Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM(
    C=C,
    dp=dp,
    m=m,
    a=a,
    b=b,
    c=c,
    d=d,
    dp_turbulent=dp_turbulent);
  m2_flow = V_flow * rho;
  m_flow = Buildings.Fluid.FixedResistances.BaseClasses.powerLawFixedM(
    k=k,
    dp=dp,
    m=m,
    a=a,
    b=b,
    c=c,
    d=d,
    dp_turbulent=dp_turbulent);
  assert(abs(m_flow-m2_flow) < 1E-10,
    "Error: The two implementations of the power law model need to give identical results");
  annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/BaseClasses/Validation/PowerLawFixedM.mos"
     "Simulate and plot"),
  Documentation(info="<html>
<p>
This examples validates the implementation of
<a href=\"modelica://Buildings.Fluid.FixedResistances.BaseClasses.powerLawFixedM\">
Buildings.Fluid.FixedResistances.BaseClasses.powerLawFixedM</a>
by comparing it with the results from
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM\">
Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM</a>.
These functions differ in that the first returns the mass flow rate, and the
second the volume flow rate.
This validation model ensures that, after converting them to mass flow rate,
they compute the same results.
This is verified by an <code>assert</code> statement.
</p>
</html>", revisions="<html>
<ul>
<li>
December 19, 2025, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PowerLawFixedM;
