within Buildings.Fluid.BaseClasses.FlowModels.Validation;
model InvertingBasicFlowFunction_dp_inv
  "Test model that inverts basicFlowFunction_dp_inv"
  extends Modelica.Icons.Example;

  parameter Real k = 0.5 "Flow coefficient";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.5
    "Nominal mass flow rate";

  Modelica.Units.SI.MassFlowRate m_flow(start=0) "Mass flow rate";
  Modelica.Units.SI.PressureDifference dp(displayUnit="Pa")
    "Pressure difference";

equation
  dp = 4*(time-0.5);
  dp = FlowModels.basicFlowFunction_dp_inv(
    m_flow=m_flow,
    k=k,
    m_flow_turbulent=m_flow_nominal*0.3);

  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/InvertingBasicFlowFunction_dp_inv.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests whether the Modelica translator substitutes the
inverse function for
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv</a>.
Specifically, this function declares in its <code>annotation</code> section
that its inverse is provided by
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</a>.
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
end InvertingBasicFlowFunction_dp_inv;
