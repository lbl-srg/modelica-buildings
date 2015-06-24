within Buildings.Fluid.BaseClasses.FlowModels.Examples;
model TestFlowFunctions "Test model for flow functions"
  extends Modelica.Icons.Example;
 Modelica.SIunits.MassFlowRate m1_flow;
 Modelica.SIunits.MassFlowRate m2_flow;
 Modelica.SIunits.Pressure dp1;
 Modelica.SIunits.Pressure dp2;
 Modelica.SIunits.Pressure p1_nominal=101325;
 Modelica.SIunits.Time dTime= 1;
 Modelica.SIunits.Pressure p1 "Boundary condition";
 parameter Modelica.SIunits.Pressure p2 = 101325 "Boundary condition";
 parameter Boolean from_dp = true;
 parameter Real k = 0.5;
 parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1 "Nominal flow rate";
equation
  p1 = p1_nominal + (time-0.5)/dTime * 20;
  m1_flow = m2_flow;
  p2-p1 = dp1 + dp2;
  if from_dp then
  m1_flow=FlowModels.basicFlowFunction_dp(dp=dp1, k=k, m_flow_turbulent=m_flow_nominal*0.3);
  m2_flow=FlowModels.basicFlowFunction_dp(dp=dp2, k=k, m_flow_turbulent=m_flow_nominal*0.3);
  else
  dp1=FlowModels.basicFlowFunction_m_flow(m_flow=m1_flow, k=k, m_flow_turbulent=m_flow_nominal*0.3);
  dp2=FlowModels.basicFlowFunction_m_flow(m_flow=m2_flow, k=k, m_flow_turbulent=m_flow_nominal*0.3);
  end if;
  assert(abs(dp1-dp2) < 1E-5, "Error in implementation.");
annotation (
experiment(StartTime=-1, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Examples/TestFlowFunctions.mos"
        "Simulate and plot"),
              Documentation(info="<html>
This model test the inverse functions. When translating this model in
Dymola 7.2, there should be no numerical solution be required to solve
the nonlinear equation system.
</html>"));
end TestFlowFunctions;
