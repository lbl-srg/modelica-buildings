within Buildings.Fluid.BaseClasses.FlowModels.Validation;
model InvertingBasicFlowFunction_dp
  "Test model that inverts basicFlowFunction_dp"
  extends Modelica.Icons.Example;

 parameter Real k = 0.5 "Flow coefficient";
 parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1.5
    "Nominal mass flow rate";

 Modelica.SIunits.MassFlowRate m_flow "Mass flow rate";
 Modelica.SIunits.Pressure dp(displayUnit="Pa") "Pressure difference";
equation
  m_flow = 4*(time-0.5);
  m_flow = FlowModels.basicFlowFunction_dp(dp=dp, k=k, m_flow_turbulent=m_flow_nominal*0.3);

annotation (
experiment(StopTime=1),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/InvertingBasicFlowFunction_dp.mos"
        "Simulate and plot"),
              Documentation(info="<html>
<p>
This model tests whether the Modelica translator substitutes the
inverse function for
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</a>.
Specifically, this function declares in its <code>annotation</code> section
that its inverse is provided by
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>.
Translating this model should therefore give no nonlinear equations
after the symbolic manipulation.
</p>
</html>", revisions="<html>
<ul>
<li>
August 5, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end InvertingBasicFlowFunction_dp;
