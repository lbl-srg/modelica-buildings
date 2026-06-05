within Buildings.Fluid.BaseClasses.FlowModels.Validation;
model PowerLaw_dp "Test model for power law function"
  extends Modelica.Icons.Example;

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


  parameter Modelica.Units.SI.Density rho = 1.2 "Fluid density";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 5
    "Nominal mass flow rate used to compute the flow coefficient k and C for the power law model";
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa") = 10
    "Nominal pressure difference used to compute the flow coefficient k and C for the power law model";

  constant Real n(min=1, max=2) = 1/0.8
    "Flow exponent, n=1 for laminar, n=2 for turbulent";
  constant Real m(min=0.5, max=1) = 1/n
    "Inverse of flow exponent";

  parameter Real C = m_flow_nominal/rho/dp_nominal^m "Flow coefficient, C = V_flow/ dp^m";
  parameter Real k = m_flow_nominal/dp_nominal^(1/n) "Flow coefficient, k = m_flow/ dp^(1/n)";


  parameter Modelica.Units.SI.MassFlowRate m_flow_turbulent(min=0) =
    m_flow_nominal
    "Mass flow rate where regularization starts, here set to the same value as m_flow_nominal";

  parameter Modelica.Units.SI.PressureDifference dp_turbulent(min=0) =
    (m_flow_turbulent/k)^n
    "Pressure difference where regularization starts";
  Modelica.Units.SI.PressureDifference dp "Pressure difference";
  Modelica.Units.SI.VolumeFlowRate V_flow
    "Volume flow rate computed with model powerLawFixedM that uses C";
  Modelica.Units.SI.MassFlowRate m2_flow
    "Mass flow rate computed based on V_flow to compare equality with m_flow";
  Modelica.Units.SI.MassFlowRate m_flow
    "Mass flow rate computed with model powerLawFixedM that uses k";

equation
  dp = 20*(-1+2*time);
  V_flow = Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM(
    C=C,
    a=a, b=b, c=c, d=d,
    dp=dp,
    m=1/n,
    dp_turbulent=dp_turbulent);
  m2_flow = V_flow * rho;
  m_flow = Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp(
    k=k,
    dp=dp,
    n=n,
    m_flow_turbulent=m_flow_turbulent);

  annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/PowerLaw_dp.mos"
     "Simulate and plot"),
  Documentation(info="<html>
<p>
This example compares the mass flow rate of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp</a>
by comparing it with the mass flow rate from
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM\">
Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM</a>.
Outside the turbulent region, the two models give the same result.
However, inside the turbulent region, the results differ slightly because
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp</a>
uses a 5th order polynominal to ensure C2 continuity, while
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM\">
Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM</a>
uses a 7th order polynomial.


</p>
</html>", revisions="<html>
<ul>
<li>
December 19, 2025, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PowerLaw_dp;
