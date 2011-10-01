within Buildings.Fluid.Movers.Examples;
model FlowMachine_Nrpm
  import Buildings;
  extends Modelica.Icons.Example;
 extends Buildings.Fluid.Movers.Examples.BaseClasses.FlowMachine_ZeroFlow(
    gain(k=1500),
    redeclare Buildings.Fluid.Movers.FlowMachine_Nrpm floMacSta(
      redeclare package Medium = Medium,
      pressure(V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
               dp={2*dp_nominal,dp_nominal,0})),
    redeclare Buildings.Fluid.Movers.FlowMachine_Nrpm floMacDyn(
      redeclare package Medium = Medium,
      pressure(V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
               dp={2*dp_nominal,dp_nominal,0})));

equation
  connect(gain.y, floMacSta.Nrpm) annotation (Line(
      points={{-25,100},{30,100},{30,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, floMacDyn.Nrpm) annotation (Line(
      points={{-25,100},{10,100},{10,30},{30,30},{30,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{160,
            160}}), graphics),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Examples/FlowMachine_Nrpm.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This example demonstrates and tests the use of a flow machine whose mass flow rate is reduced to zero.
</html>", revisions="<html>
<ul>
<li>March 24 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),    Diagram);
end FlowMachine_Nrpm;
