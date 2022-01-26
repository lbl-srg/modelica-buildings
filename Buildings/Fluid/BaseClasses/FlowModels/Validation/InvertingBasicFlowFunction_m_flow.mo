within Buildings.Fluid.BaseClasses.FlowModels.Validation;
model InvertingBasicFlowFunction_m_flow
  "Test model that inverts basicFlowFunction_m_flow"
  extends Modelica.Icons.Example;

 parameter Real k = 0.5 "Flow coefficient";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.5
    "Nominal mass flow rate";

  Modelica.Units.SI.MassFlowRate m_flow(start=0) "Mass flow rate";
  Modelica.Units.SI.PressureDifference dp(displayUnit="Pa")
    "Pressure difference";
equation
  dp = 4*(time-0.5);
  dp = FlowModels.basicFlowFunction_m_flow(m_flow=m_flow, k=k, m_flow_turbulent=m_flow_nominal*0.3);

annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/InvertingBasicFlowFunction_m_flow.mos"
        "Simulate and plot"),
              Documentation(info="<html>
<p>
This model tests whether the Modelica translator substitutes the
inverse function for
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>.
Specifically, this function declares in its <code>annotation</code> section
that its inverse is provided by
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</a>.
Translating this model should therefore give no nonlinear equations
after the symbolic manipulation.
</p>
</html>", revisions="<html>
<ul>
<li>
January 25, 2019, by Michael Wetter:<br/>
Added start value to avoid warning in JModelica.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
August 5, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end InvertingBasicFlowFunction_m_flow;
