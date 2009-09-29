within Buildings.Fluids.Sensors;
model RelativeTemperature "Ideal relative temperature sensor"
  extends Modelica.Icons.TranslationalSensor;
  replaceable package Medium = 
    Modelica.Media.Interfaces.PartialMedium "Medium in the sensor"  annotation (
      choicesAllMatching = true);
  Modelica.Fluid.Interfaces.FluidPort_a port_a(m_flow(min=0),
                                redeclare package Medium = Medium) 
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
          rotation=0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(m_flow(min=0),
                                redeclare package Medium = Medium) 
    annotation (Placement(transformation(extent={{110,-10},{90,10}}, rotation=
           0)));

  Modelica.Blocks.Interfaces.RealOutput T_rel(final quantity="ThermodynamicTemperature",
                                              final unit = "K", displayUnit = "degC", min=0)
    "Relative temperature signal"                                                                               annotation (Placement(
        transformation(
        origin={0,-90},
        extent={{10,-10},{-10,10}},
        rotation=90)));
  annotation (
    Icon(graphics={
        Line(points={{-100,0},{-70,0}}, color={0,127,255}),
        Line(points={{70,0},{100,0}}, color={0,127,255}),
        Line(points={{0,-30},{0,-80}}, color={0,0,127}),
        Text(
          extent={{-150,40},{150,80}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{128,-70},{10,-100}},
          lineColor={0,0,0},
          textString="T_rel"),
        Line(
          points={{34,3},{-56,3}},
          color={0,128,255},
          smooth=Smooth.None),
        Polygon(
          points={{24,18},{64,3},{24,-12},{24,18}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(graphics),
    Documentation(info="<HTML>
<p>
The relative temperature \"T(port_a) - T(port_b)\" is determined between
the two ports of this component and is provided as output signal. The
sensor should be connected in parallel with other equipment, no flow
through the sensor is allowed.
</p>
</HTML>
"));
equation
  // Zero flow equations for connectors
  port_a.m_flow = 0;
  port_b.m_flow = 0;

  // No contribution of specific quantities
  port_a.h_outflow = 0;
  port_b.h_outflow = 0;
  port_a.Xi_outflow = zeros(Medium.nXi);
  port_b.Xi_outflow = zeros(Medium.nXi);
  port_a.C_outflow  = zeros(Medium.nC);
  port_b.C_outflow  = zeros(Medium.nC);

  // Relative temperature
  T_rel = Medium.temperature(Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow))) -
          Medium.temperature(Medium.setState_phX(port_b.p, inStream(port_b.h_outflow), inStream(port_b.Xi_outflow)));
end RelativeTemperature;
