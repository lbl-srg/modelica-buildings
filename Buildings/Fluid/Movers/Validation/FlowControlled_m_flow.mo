within Buildings.Fluid.Movers.Validation;
model FlowControlled_m_flow
  "Fan with zero mass flow rate and mass flow rate as input"
  extends Modelica.Icons.Example;
 extends Buildings.Fluid.Movers.Validation.BaseClasses.FlowMachine_ZeroFlow(
    gain(k=m_flow_nominal),
    redeclare Buildings.Fluid.Movers.FlowControlled_m_flow floMacSta(
      redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
      filteredSpeed=false,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    redeclare Buildings.Fluid.Movers.FlowControlled_m_flow floMacDyn(
      redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
      filteredSpeed=false,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial));

equation
  connect(gain.y, floMacSta.m_flow_in) annotation (Line(
      points={{-25,100},{29.8,100},{29.8,92}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, floMacDyn.m_flow_in) annotation (Line(
      points={{-25,100},{10,100},{10,30},{29.8,30},{29.8,12}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{160,
            160}})),
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Validation/FlowControlled_m_flow.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates and tests the use of a flow machine whose mass flow rate is reduced to zero.
</p>
<p>
The fans have been configured as steady-state models.
This ensures that the actual speed is equal to the input signal.
</p>
</html>", revisions="<html>
<ul>
<li>
February 14, 2012, by Michael Wetter:<br/>
Added filter for start-up and shut-down transient.
</li>
<li>
March 24 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlowControlled_m_flow;
