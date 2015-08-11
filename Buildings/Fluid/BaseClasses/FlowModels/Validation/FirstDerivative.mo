within Buildings.Fluid.BaseClasses.FlowModels.Validation;
model FirstDerivative
  "Test model for flow functions for 1st order differentiability"
  extends Modelica.Icons.Example;
  Modelica.SIunits.MassFlowRate m1_flow "Direct function input/output for dp1";
  Modelica.SIunits.MassFlowRate m2_flow "Direct function input/output for dp2";
  Modelica.SIunits.Pressure dp1 "Direct function input/output for m1_flow";
  Modelica.SIunits.Pressure dp2 "Direct function input/output for m2_flow";

  Modelica.SIunits.MassFlowRate m1_flow_comp "Comparison value for m1_flow";
  Modelica.SIunits.MassFlowRate m2_flow_comp "Comparison value for m2_flow";
  Modelica.SIunits.Pressure dp1_comp "Comparison value for dp1";
  Modelica.SIunits.Pressure dp2_comp "Comparison value for dp2";

  Modelica.SIunits.Pressure p1_nominal=101325;
  Modelica.SIunits.Time dTime= 1;
  Modelica.SIunits.Pressure p1 "Boundary condition";
  parameter Modelica.SIunits.Pressure p2 = 101325 "Boundary condition";
  parameter Boolean from_dp = true;
  parameter Real k = 0.5;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
    "Nominal flow rate";

initial equation
  m1_flow = m1_flow_comp;
  m2_flow = m2_flow_comp;
  dp1 = dp1_comp;
  dp2 = dp2_comp;

equation
  p1 = p1_nominal + (time-0.5)/dTime * 20;
  m1_flow = m2_flow;
  p2-p1 = dp1 + dp2;
  // fixme: from_dp causes only half of the function to be tested.
  if from_dp then
    m1_flow=FlowModels.basicFlowFunction_dp(dp=dp1, k=k, m_flow_turbulent=m_flow_nominal*0.3);
    m2_flow=FlowModels.basicFlowFunction_dp(dp=dp2, k=k, m_flow_turbulent=m_flow_nominal*0.3);
  else
    dp1=FlowModels.basicFlowFunction_m_flow(m_flow=m1_flow, k=k, m_flow_turbulent=m_flow_nominal*0.3);
    dp2=FlowModels.basicFlowFunction_m_flow(m_flow=m2_flow, k=k, m_flow_turbulent=m_flow_nominal*0.3);
  end if;
  assert(abs(dp1-dp2) < 1E-5, "Error in implementation.");

  der(m1_flow_comp) = der(m1_flow);
  der(m2_flow_comp) = der(m2_flow);
  der(dp1_comp) = der(dp1);
  der(dp2_comp) = der(dp2);

  assert(abs(m1_flow-m1_flow_comp) < 1E-2, "Model has an error for m1_flow");
  assert(abs(m2_flow-m2_flow_comp) < 1E-2, "Model has an error for m2_flow");
  assert(abs(dp1-dp1_comp) < 1E-2, "Model has an error for dp1");
  assert(abs(dp2-dp2_comp) < 1E-2, "Model has an error for dp2");
annotation (
experiment(StartTime=-1,
           StopTime=1.0,
           Tolerance=1e-08),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/FirstDerivative.mos"
        "Simulate and plot"),
              Documentation(info="<html>
<p>This model tests the first-order derivative of the flow functions.</p>
</html>", revisions="<html>
<ul>
<li>
July 27, 2015, by Michael Wetter:<br/>
Corrected wrong <code>.mos</code> script name.
</li>
<li>
July 20, 2015, by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>"));
end FirstDerivative;
