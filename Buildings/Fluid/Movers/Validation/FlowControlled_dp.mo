within Buildings.Fluid.Movers.Validation;
model FlowControlled_dp "Fan with zero mass flow rate and head as input"
  extends Modelica.Icons.Example;
 extends Buildings.Fluid.Movers.Validation.BaseClasses.FlowMachine_ZeroFlow(
    gain(k=dp_nominal),
    redeclare Buildings.Fluid.Movers.FlowControlled_dp floMacSta(
      redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
      filteredSpeed=false,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      per(use_powerCharacteristic=true,
          power(V_flow={0,0.5, 1.0}*1.2, P={0,250, 1000}))),
    redeclare Buildings.Fluid.Movers.FlowControlled_dp floMacDyn(
      redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
      filteredSpeed=false,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial));

equation
  connect(gain.y, floMacSta.dp_in) annotation (Line(
      points={{-25,100},{29.8,100},{29.8,92}},
      color={0,0,127}));
  connect(gain.y, floMacDyn.dp_in) annotation (Line(
      points={{-25,100},{10,100},{10,30},{29.8,30},{29.8,12}},
      color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{160,
            160}})),
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Validation/FlowControlled_dp.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates and tests the use of a flow machine whose mass flow rate is reduced to zero.
</p>
<p>
The fans have been configured as steady-state models.
This ensures that the actual speed is equal to the input signal.
The fan <code>floMacSta</code> computes the power consumption based
on its performance data, whereas
<code>floMacDyn</code> computes it based on the flow work
and the hydraulic and motor efficiency.
</p>
</html>", revisions="<html>
<ul>
<li>
September 2, 2015, by Michael Wetter:<br/>
Changed example so that the fans use different powers, one being computed
based on efficiency, the other based on the specified power.
This is for
<a href=\"modelica://https://github.com/lbl-srg/modelica-buildings/issues/457\">issue 457</a>.
</li>
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
end FlowControlled_dp;
