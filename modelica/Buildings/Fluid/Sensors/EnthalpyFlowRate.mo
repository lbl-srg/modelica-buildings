within Buildings.Fluid.Sensors;
model EnthalpyFlowRate "Ideal enthalphy flow rate sensor"
  extends Modelica.Fluid.Sensors.BaseClasses.PartialFlowSensor;
  extends Modelica.Icons.RotationalSensor;
  Modelica.Blocks.Interfaces.RealOutput H_flow(unit="W")
    "Enthalpy flow rate, positive if from port_a to port_b" 
    annotation (Placement(transformation(
        origin={0,110},
        extent={{-10,-10},{10,10}},
        rotation=90)));

annotation (
  Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics),
  Icon(graphics={
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255}),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Text(
          extent={{180,151},{20,99}},
          lineColor={0,0,0},
          textString="H_flow")}),
  Documentation(info="<HTML>
<p>
This component monitors the enthalphy flow rate of the medium in the flow
between fluid ports. The sensor is ideal, i.e., it does not influence the fluid.
</p>
<p>
For a sensor that measures the latent enthalpy flow rate, use
<a href=\"Modelica:Buildings.Fluid.Sensors.LatentEnthalpyFlowRate\">
Buildings.Fluid.Sensors.LatentEnthalpyFlowRate</a>.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
April 9, 2008 by Michael Wetter:<br>
First implementation based on enthalpy sensor of Modelica.Fluid.
</li>
</ul>
</html>"));

equation
  if allowFlowReversal then
     H_flow = port_a.m_flow * actualStream(port_a.h_outflow);
  else
     H_flow = port_a.m_flow * port_b.h_outflow;
  end if;
end EnthalpyFlowRate;
