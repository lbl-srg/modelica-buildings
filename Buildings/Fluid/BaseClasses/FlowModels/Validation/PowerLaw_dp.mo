within Buildings.Fluid.BaseClasses.FlowModels.Validation;
model PowerLaw_dp "Test model for power law function"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Density rho = 1.2 "Fluid density";
  parameter Real C = 2/10^m "Flow coefficient, C = V_flow/ dp^m";
  parameter Real k = 2/10^m * rho "Flow coefficient, k = m_flow/ dp^m";

  constant Real m(min=0.5, max=1) = 0.8
    "Flow exponent, m=0.5 for turbulent, m=1 for laminar";
  constant Real n(min=1, max=2) = 1/m
    "Flow exponent, n=1 for laminar, n=2 for turbulent";
  parameter Modelica.Units.SI.MassFlowRate m_flow_turbulent(min=0) =
    k * 5^m
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
    dp_turbulent=dp_turbulent);
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
