within Buildings.Fluid.Movers.Examples;
model FlowMachine_dp
  import Buildings;
  extends Modelica.Icons.Example;
 extends Buildings.Fluid.Movers.Examples.BaseClasses.FlowMachine_ZeroFlow(
    gain(k=dp_nominal),
    redeclare Buildings.Fluid.Movers.FlowMachine_dp floMacSta(
      redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal),
    redeclare Buildings.Fluid.Movers.FlowMachine_dp floMacDyn(
      redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal));

equation
  connect(gain.y, floMacSta.dp_in) annotation (Line(
      points={{-25,100},{35,100},{35,88.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, floMacDyn.dp_in) annotation (Line(
      points={{-25,100},{10,100},{10,30},{35,30},{35,8.2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{160,
            160}}), graphics),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Examples/FlowMachine_dp.mos" "Simulate and plot"),
    Documentation(info="<html>
This example demonstrates and tests the use of a flow machine whose mass flow rate is reduced to zero.
</html>", revisions="<html>
<ul>
<li>March 24 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),    Diagram);
end FlowMachine_dp;
