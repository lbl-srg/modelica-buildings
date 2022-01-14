within Buildings.Fluid.Sensors;
model MassFlowRate "Ideal sensor for mass flow rate"
extends Buildings.Fluid.Sensors.BaseClasses.PartialFlowSensor(
  final m_flow_nominal = 0,
  final m_flow_small = 0);
extends Modelica.Icons.RoundSensor;
Modelica.Blocks.Interfaces.RealOutput m_flow(quantity="MassFlowRate",
                                             final unit="kg/s")
  "Mass flow rate from port_a to port_b" annotation (Placement(
      transformation(
      origin={0,110},
      extent={{10,-10},{-10,10}},
      rotation=270)));

equation
m_flow = port_a.m_flow;
  annotation (
    defaultComponentName="senMasFlo",
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
      Line(points={{70,0},{100,0}}, color={0,128,255}),
      Text(
        extent={{162,120},{2,90}},
        textColor={0,0,0},
        textString="m_flow"),
      Line(points={{0,100},{0,70}}, color={0,0,127}),
      Line(points={{-100,0},{-70,0}}, color={0,128,255}),
      Text(
        extent={{-20,116},{-140,66}},
        textColor={0,0,0},
        textString=DynamicSelect("", String(m_flow, leftJustified=false, significantDigits=3)))}),
Documentation(info="<html>
<p>
This model outputs the mass flow rate flowing from
<code>port_a</code> to <code>port_b</code>.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>", revisions="<html>
<ul>
<li>
February 25, 2020, by Michael Wetter:<br/>
Changed icon to display its operating state.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1294\">#1294</a>.
</li>
<li>
February 21, 2020, by Michael Wetter:<br/>
Changed icon to display its operating state.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1294\">#1294</a>.
</li>
<li>
September 29, 2009, by Michael Wetter:<br/>
First implementation.
Implementation is based on <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"));
end MassFlowRate;
