within Buildings.Fluid.BaseClasses.FlowModels.Validation;
model InvertingPowerLaw_dp
  "Test model that inverts powerLaw_dp"
  extends Modelica.Icons.Example;

 parameter Real k = 0.5 "Flow coefficient";
  parameter Real n(min=1, max=2) = 1.5
    "Flow exponent, n=1 for laminar, n=2 for turbulent";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1.5
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate m_flow_turbulent(min=0)=
    m_flow_nominal*0.3
    "Mass flow rate where transition to turbulent flow occurs";

  Modelica.Units.SI.MassFlowRate m_flow "Mass flow rate";
  Modelica.Units.SI.PressureDifference dp(displayUnit="Pa", start=0)
    "Pressure difference";

protected
  parameter Modelica.Units.SI.PressureDifference dp_turbulent(
    displayUnit="Pa", fixed=false)
    "Pressure difference where turbulent flow occurs";
  parameter Real m(fixed=false) "Flow exponent for the pressure drop";
  parameter Real a1(fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real a3(fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real a5(fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real C(fixed=false)
    "Coefficient 1/k^n, based on the definition k = m_flow / dp^(1/n)";
  parameter Real b1(fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real b3(fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real b5(fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";

initial equation
  (dp_turbulent, m, a1, a3, a5, C, b1, b3, b5) =
    Buildings.Fluid.BaseClasses.FlowModels.powerLawData(
      k=k, n=n, m_flow_turbulent=m_flow_turbulent);

equation
  m_flow = 4*(time-0.5);
  m_flow = Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp(
    dp=dp,
    k=k,
    n=n,
    m_flow_turbulent=m_flow_turbulent,
    dp_turbulent=dp_turbulent,
    m=m,
    a1=a1,
    a3=a3,
    a5=a5,
    C=C,
    b1=b1,
    b3=b3,
    b5=b5);

annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/InvertingPowerLaw_dp.mos"
        "Simulate and plot"),
              Documentation(info="<html>
<p>
This model tests whether the Modelica translator substitutes the
inverse function for
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp</a>.
Specifically, this function declares in its <code>annotation</code> section
that its inverse is provided by
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow</a>.
Translating this model should therefore give no nonlinear equations
after the symbolic manipulation.
</p>
</html>", revisions="<html>
<ul>
<li>
May 30, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end InvertingPowerLaw_dp;