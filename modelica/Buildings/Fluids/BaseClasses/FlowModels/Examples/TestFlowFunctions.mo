within Buildings.Fluids.BaseClasses.FlowModels.Examples;
model TestFlowFunctions "Test model for flow functions"
annotation (Commands(file="TestFlowFunctions.mos" "run"));
 Modelica.SIunits.MassFlowRate m_flow;
 Modelica.SIunits.MassFlowRate m1_flow;
 Modelica.SIunits.MassFlowRate m_flow_nominal=2;
 Modelica.SIunits.Time dTime= 1;
 Modelica.SIunits.Pressure dp;
 parameter Boolean linearized=false;
 parameter Real k = 0.05;
equation
  m_flow = time/dTime * m_flow_nominal;
  m_flow=FlowModels.basicFlowFunction_dp(dp=dp, k=k, m_flow_turbulent=m_flow_nominal*0.3, linearized=linearized);
  dp=FlowModels.basicFlowFunction_m_flow(m_flow=m1_flow, k=k, m_flow_turbulent=m_flow_nominal*0.3, linearized=linearized);
  annotation (Documentation(info="<html>
This model test the inverse functions. When translating this model in 
Dymola 7.2, there should be no numerical solution be required to solve
the nonlinear equation system.
</html>"));
end TestFlowFunctions;
