within Buildings.Fluid.BaseClasses.FlowModels.Validation;
model PowerLaw_dp "Test model for power law function"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Density rho = 1.2 "Fluid density";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 5
    "Nominal mass flow rate used to compute the flow coefficient k and C for the power law model";
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa") = 10
    "Nominal pressure difference used to compute the flow coefficient k and C for the power law model";

  parameter Real n(min=1, max=2) = 1/0.8
    "Flow exponent, n=1 for laminar, n=2 for turbulent";

  parameter Real C = m_flow_nominal/rho/dp_nominal^n "Flow coefficient, C = V_flow/ dp^m";
  parameter Real k = m_flow_nominal/dp_nominal^(1/n) "Flow coefficient, k = m_flow/ dp^n";


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
  dp = 10*(-1+2*time);
  V_flow = Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM(
    C=C,
    dp=dp,
    m=m,
    dp_turbulent=dp_turbulent);
  m2_flow = V_flow * rho;
  m_flow = Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp(
    k=k,
    dp=dp,
    n=n,
    m_flow_turbulent=m_flow_turbulent);
  assert(abs(m_flow-m2_flow) < 1E-10,
    "Error: The two implementations of the power law model need to give identical results");
  annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/PowerLaw_dp.mos"
     "Simulate and plot"),
  Documentation(info="<html>
<p>
This examples validates the implementation of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp</a>
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
end PowerLaw_dp;
