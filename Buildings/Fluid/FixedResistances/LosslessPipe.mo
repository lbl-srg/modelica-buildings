within Buildings.Fluid.FixedResistances;
model LosslessPipe "Pipe with no flow friction and no heat transfer"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  final parameter Boolean from_dp=true "Used to satisfy replaceable models";
  parameter Real n(min=1, max=2) = 2
    "Flow exponent, n=1 for laminar, n=2 for turbulent"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
equation
  dp=0;
  // Isenthalpic state transformation (no storage and no loss of energy)
  port_a.h_outflow = if allowFlowReversal then inStream(port_b.h_outflow) else Medium.h_default;
  port_b.h_outflow = inStream(port_a.h_outflow);

  // Mass balance (no storage)
  port_a.m_flow + port_b.m_flow = 0;

  // Transport of substances
  port_a.Xi_outflow = if allowFlowReversal then inStream(port_b.Xi_outflow) else Medium.X_default[1:Medium.nXi];
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);

  port_a.C_outflow = if allowFlowReversal then inStream(port_b.C_outflow) else zeros(Medium.nC);
  port_b.C_outflow = inStream(port_a.C_outflow);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,50},{100,-48}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={217,236,255})}),
defaultComponentName="pip",
    Documentation(info="<html>
<p>
Model of a pipe with no flow resistance, no heat loss and no transport delay.
This model can be used to replace a <code>replaceable</code> pipe model
in flow legs in which no friction should be modeled.
This is for example done in the outlet port of the
base class for three way valves,
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve\">
Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 17, 2026, by Michael Wetter:<br/>
Updated implementation to allow a flow coefficient <code>n</code> that is different from <code>2</code>.
This allows use of the model for not fully turbulent flow.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4620\">Buildings, #4620</a>.
</li>

<li>
June 23, 2018, by Filip Jorissen:<br/>
Implementation is now more efficient for <code>allowFlowReversal=false</code>.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/949\">#949</a>.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
June 13, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end LosslessPipe;
