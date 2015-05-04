within Buildings.Obsolete.Fluid.Movers.Examples;
model FlowMachine_y
  "Fan with zero mass flow rate and control signal y as input"
  extends Modelica.Icons.Example;
 extends Buildings.Obsolete.Fluid.Movers.Examples.BaseClasses.FlowMachine_ZeroFlow(
    gain(k=1),
    redeclare Buildings.Obsolete.Fluid.Movers.FlowMachine_y floMacSta(
      redeclare package Medium = Medium,
      pressure(V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
               dp={2*dp_nominal,dp_nominal,0}),
      filteredSpeed=false,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    redeclare Buildings.Obsolete.Fluid.Movers.FlowMachine_y floMacDyn(
      redeclare package Medium = Medium,
      pressure(V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
               dp={2*dp_nominal,dp_nominal,0}),
      filteredSpeed=false,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial));

equation
  connect(gain.y, floMacDyn.y) annotation (Line(
      points={{-25,100},{8,100},{8,30},{30,30},{30,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, floMacSta.y) annotation (Line(
      points={{-25,100},{30,100},{30,92}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{160,
            160}})),
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Fluid/Movers/Examples/FlowMachine_y.mos"
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
end FlowMachine_y;
