within Buildings.Fluid.BaseClasses.FlowModels.Validation;
model InversePowerLaws "Test model for power law flow function and its inverse"
  extends Modelica.Icons.Example;

  parameter Real k = 0.5;
  parameter Real n[3](each min=1, each max=2) = {1, 1/0.8, 2}
    "Flow exponent, n=1 for laminar, n=2 for turbulent";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1 "Nominal flow rate";
  parameter Modelica.Units.SI.MassFlowRate m_flow_turbulent=m_flow_nominal*0.3
    "Mass flow rate where transition to turbulent flow occurs";

  Modelica.Units.SI.MassFlowRate m_flow[3];
  Modelica.Units.SI.PressureDifference dp(displayUnit="Pa")
    "Pressure difference";
  Modelica.Units.SI.PressureDifference dpCalc[3](each displayUnit="Pa")
    "Pressure difference computed by the flow functions";
  Modelica.Units.SI.Pressure deltaDp[3](each displayUnit="Pa")
    "Pressure difference between input and output to the functions";
  Modelica.Units.SI.Time dTime=2;

protected
  parameter Modelica.Units.SI.PressureDifference dp_turbulent[3](
    each displayUnit="Pa", each fixed=false)
    "Pressure difference where turbulent flow occurs";
  parameter Real m[3](each fixed=false) "Flow exponent for the pressure drop";
  parameter Real a1[3](each fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real a3[3](each fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real a5[3](each fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real C[3](each fixed=false)
    "Coefficient 1/k^n, based on the definition k = m_flow / dp^(1/n)";
  parameter Real b1[3](each fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real b3[3](each fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real b5[3](each fixed=false)
    "Polynomial coefficient for regularized implementation of flow resistance";

initial equation
  for i in 1:3 loop
    (dp_turbulent[i], m[i], a1[i], a3[i], a5[i], C[i], b1[i], b3[i], b5[i]) =
      Buildings.Fluid.BaseClasses.FlowModels.powerLawData(
        k=k, n=n[i], m_flow_turbulent=m_flow_turbulent);
  end for;

equation
  dp = (time-0.5)/dTime * 20;
  for i in 1:3 loop
    m_flow[i]=FlowModels.powerLaw_dp(
      dp=dp, k=k, n=n[i], m_flow_turbulent=m_flow_turbulent,
      dp_turbulent=dp_turbulent[i], m=m[i], a1=a1[i], a3=a3[i], a5=a5[i],
      C=C[i], b1=b1[i], b3=b3[i], b5=b5[i]);
    dpCalc[i]=FlowModels.powerLaw_m_flow(
      m_flow=m_flow[i], k=k, n=n[i], m_flow_turbulent=m_flow_turbulent,
      dp_turbulent=dp_turbulent[i], m=m[i], a1=a1[i], a3=a3[i], a5=a5[i],
      C=C[i], b1=b1[i], b3=b3[i], b5=b5[i]);
    deltaDp[i] = dp - dpCalc[i];
  end for;
annotation (
experiment(Tolerance=1e-06, StopTime=1),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/InversePowerLaws.mos"
        "Simulate and plot"),
               Documentation(info="<html>
<p>
This model tests the inverse formulation of the power law flow functions
for three values of the flow exponent: <i>n=1</i> (laminar flow),
<i>n=1.25</i>, and <i>n=2</i> (turbulent flow).
</p>
<p>
The pressure difference <code>dp</code> and <code>dpCalc</code> need to
be equal up to the solver tolerance, except for a small neighborhood
around the origin. In this neighborhood around the origin, the functions
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp</a>
and
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow</a>
do not have an analytic expression for their inverse function and hence
the implementation of the inverse function slightly differs.
</p>
</html>", revisions="<html>
<ul>
<li>
May 30, 2026, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4620\">Buildings, #4620</a>.
</li>
</ul>
</html>"));
end InversePowerLaws;