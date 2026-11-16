within Buildings.Fluid.BaseClasses.FlowModels.Validation;
model InvertingBasicFlowFunction_m_flow_inv
  "Test model that inverts basicFlowFunction_m_flow_inv"
  extends Modelica.Icons.Example;

  parameter Real k = 0.5 "Flow coefficient";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1.5
    "Nominal mass flow rate";

  Modelica.Units.SI.MassFlowRate m_flow "Mass flow rate";
  Modelica.Units.SI.PressureDifference dp(displayUnit="Pa", start=0)
    "Pressure difference";

equation
  m_flow = 4*(time-0.5);
  m_flow = FlowModels.basicFlowFunction_m_flow_inv(
    dp=dp,
    k=k,
    m_flow_turbulent=m_flow_nominal*0.3);

  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/InvertingBasicFlowFunction_m_flow_inv.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests whether the Modelica translator substitutes the
inverse function for
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv</a>.
Specifically, this function declares in its <code>annotation</code> section
that its inverse is provided by
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>.
Translating this model should therefore give no nonlinear equations
after the symbolic manipulation.
</p>
</html>",
      revisions="<html>
<ul>
<li>
October 22, 2026, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4798\">Buildings, #4798</a>.
</li>
</ul>
</html>"));
end InvertingBasicFlowFunction_m_flow_inv;
