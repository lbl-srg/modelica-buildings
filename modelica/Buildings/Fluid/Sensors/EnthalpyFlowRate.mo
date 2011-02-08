within Buildings.Fluid.Sensors;
model EnthalpyFlowRate "Ideal enthalphy flow rate sensor"
  extends Modelica.Fluid.Sensors.BaseClasses.PartialFlowSensor;
  extends Modelica.Icons.RotationalSensor;
  parameter Medium.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate, used for regularization near zero flow"
    annotation(Dialog(group = "Nominal condition"));
  parameter Medium.MassFlowRate m_flow_small(min=0) = 1E-4*m_flow_nominal
    "For bi-directional flow, temperature is regularized in the region |m_flow| < m_flow_small (m_flow_small > 0 required)"
    annotation(Dialog(group="Advanced"));

  Modelica.Blocks.Interfaces.RealOutput H_flow(unit="W")
    "Enthalpy flow rate, positive if from port_a to port_b"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{-10,-10},{10,10}},
        rotation=90)));

equation
  if allowFlowReversal then
    H_flow = port_a.m_flow * Modelica.Fluid.Utilities.regStep(port_a.m_flow,
                 port_b.h_outflow,
                 port_a.h_outflow, m_flow_small);

  else
    H_flow = port_a.m_flow * port_b.h_outflow;
  end if;
annotation (defaultComponentName="senEntFlo",
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
<a href=\"modelica://Buildings.Fluid.Sensors.LatentEnthalpyFlowRate\">
Buildings.Fluid.Sensors.LatentEnthalpyFlowRate</a>.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
April 9, 2008 by Michael Wetter:<br>
First implementation based on enthalpy sensor of <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"));
end EnthalpyFlowRate;
