within Buildings.Fluid.BaseClasses.FlowModels.Validation;
model InversePowerLaws "Test model for power law flow function and its inverse"
  extends Modelica.Icons.Example;
  Modelica.Units.SI.MassFlowRate m_flow;
  Modelica.Units.SI.PressureDifference dp(displayUnit="Pa")
    "Pressure difference";
  Modelica.Units.SI.PressureDifference dpCalc(displayUnit="Pa")
    "Pressure difference computed by the flow functions";
  Modelica.Units.SI.Pressure deltaDp(displayUnit="Pa")
    "Pressure difference between input and output to the functions";
  Modelica.Units.SI.Time dTime=2;
 parameter Real k = 0.5;
  parameter Real n(min=1, max=2) = 1/0.8
    "Flow exponent, n=1 for laminar, n=2 for turbulent";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1 "Nominal flow rate";
equation
  dp = (time-0.5)/dTime * 20;
  m_flow=FlowModels.powerLaw_dp(dp=dp, k=k, n=n, m_flow_turbulent=m_flow_nominal*0.3);
  dpCalc=FlowModels.powerLaw_m_flow(m_flow=m_flow, k=k, n=n, m_flow_turbulent=m_flow_nominal*0.3);
  deltaDp = dp - dpCalc;
annotation (
experiment(Tolerance=1e-06, StopTime=1),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/InversePowerLaws.mos"
        "Simulate and plot"),
              Documentation(info="<html>
<p>
This model tests the inverse formulation of the power law flow functions.
The pressure difference <code>dp</code> and <code>dpCalc</code> need to
be equal up to the solver tolerance, except for a small neighborhood
around the origin. In this neighborhood around the origin, the functions
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp</a>
and
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow</a>
are not invertible.
</p>
</html>", revisions="<html>
<ul>
<li>
May 30, 2026, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4620\">#4620</a>.
</li>
</ul>
</html>"));
end InversePowerLaws;