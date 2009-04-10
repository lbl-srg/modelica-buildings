within Buildings.Fluids.Sensors;
model WetBulbTemperature "Ideal wet bulb temperature sensor"
  extends Modelica_Fluid.Sensors.BaseClasses.PartialFlowSensor;

annotation (
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
          graphics),
    Icon(graphics={
        Line(points={{-100,0},{92,0}}, color={0,128,255}),
        Ellipse(
          extent={{-20,-58},{20,-20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-40,60},{-12,60}}, color={0,0,0}),
        Line(points={{-40,30},{-12,30}}, color={0,0,0}),
        Line(points={{-40,0},{-12,0}}, color={0,0,0}),
        Rectangle(
          extent={{-12,60},{12,-24}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-12,60},{-12,80},{-10,86},{-6,88},{0,90},{6,88},{10,86},{12,
              80},{12,60},{-12,60}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Text(
          extent={{102,140},{-18,90}},
          lineColor={0,0,0},
          textString="T"),
        Line(
          points={{-12,60},{-12,-25}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{12,60},{12,-24}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{0,100},{0,50}}, color={0,0,127})}),
    Documentation(info="<HTML>
<p>
This component monitors the wet bulb temperature of the medium in the flow
between fluid ports. The sensor is ideal, i.e., it does not influence the fluid.
</p>
</HTML>
",
revisions="<html>
<ul>
<li>
September 10, 2008 by Michael Wetter:<br>
Renamed output port to have the same interfaces as the dry bulb temperature sensor.
</li>
<li>
May 5, 2008 by Michael Wetter:<br>
First implementation based on 
<a href=\"Modelica:Modelica_Fluid.Sensors.Temperature\">Modelica_Fluid.Sensors.Temperature</a>.
</li>
</ul>
</html>"));

  Modelica.Blocks.Interfaces.RealOutput T(
    start=Medium.T_default,
    final quantity="Temperature",
    final unit="K") "Wet bulb temperature in port medium" 
    annotation (Placement(transformation(
        origin={0,110},
        extent={{-10,-10},{10,10}},
        rotation=90),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,110})));

  parameter Medium.MassFlowRate m_flow_small(min=0) = 1e-4
    "For bi-directional flow, specific enthalpy is regularized in the region |m_flow| < m_flow_small (m_flow_small > 0 required)"
    annotation(Dialog(tab="Advanced"));
  Buildings.Utilities.Psychrometrics.WetBulbTemperature wetBulMod(redeclare
      package Medium = Medium) "Model for wet bulb temperature";

equation
  if allowFlowReversal then
    wetBulMod.dryBul.h  = Modelica_Fluid.Utilities.regStep(port_a.m_flow, port_b.h_outflow, port_a.h_outflow, m_flow_small);
    wetBulMod.dryBul.Xi = Modelica_Fluid.Utilities.regStep(port_a.m_flow, port_b.Xi_outflow, port_a.Xi_outflow, m_flow_small);
  else
    wetBulMod.dryBul.h = port_b.h_outflow;
    wetBulMod.dryBul.Xi = port_b.Xi_outflow;
  end if;
  wetBulMod.dryBul.p  = port_a.p;

  // Compute wet bulb temperature
  T = wetBulMod.wetBul.T;

end WetBulbTemperature;
