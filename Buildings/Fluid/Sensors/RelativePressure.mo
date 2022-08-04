within Buildings.Fluid.Sensors;
model RelativePressure "Ideal relative pressure sensor"
  extends Modelica.Icons.RectangularSensor;
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the sensor"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(m_flow(min=0),
                                p(start=Medium.p_default),
                                redeclare package Medium = Medium)
    "Fluid connector of stream a"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(m_flow(min=0),
                                p(start=Medium.p_default),
                                redeclare package Medium = Medium)
    "Fluid connector of stream b"
    annotation (Placement(transformation(extent={{110,-12},{90,8}}), iconTransformation(extent={{110,-10},{90,10}})));

  Modelica.Blocks.Interfaces.RealOutput p_rel(final quantity="PressureDifference",
                                              final unit="Pa",
                                              displayUnit="Pa")
    "Relative pressure of port_a minus port_b" annotation (Placement(transformation(
        origin={0,-90},
        extent={{10,-10},{-10,10}},
        rotation=90)));
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

  // Relative pressure
  p_rel = port_a.p - port_b.p;
  annotation (defaultComponentName="senRelPre",
    Icon(graphics={
        Line(points={{-100,0},{-70,0}}, color={0,127,255}),
        Line(points={{70,0},{100,0}}, color={0,127,255}),
        Line(points={{0,-30},{0,-80}}, color={0,0,127}),
        Text(
          extent={{-150,40},{150,80}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{130,-70},{4,-100}},
          textColor={0,0,0},
          textString="p_rel"),
        Line(
          points={{32,3},{-58,3}},
          color={0,128,255}),
        Polygon(
          points={{22,18},{62,3},{22,-12},{22,18}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-20,-56},{-140,-106}},
          textColor={0,0,0},
          textString=DynamicSelect("", String(p_rel, leftJustified=false, significantDigits=3)))}),
    Documentation(info="<html>
<p>
The relative pressure <code>port_a.p - port_b.p</code> is determined between
the two ports of this component and is provided as output signal. The
sensor should be connected in parallel with other equipment, no flow
through the sensor is allowed.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 25, 2020, by Michael Wetter:<br/>
Changed icon to display its operating state.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1294\">#1294</a>.
</li>
<li>
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
<li>
February 19, 2016, by Michael Wetter:<br/>
Corrected the quantity of the output signal from <code>Pressure</code>
to <code>PressureDifference</code>.
This was needed for the model
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
Buildings.Fluid.Movers.FlowControlled_m_flow</a>
when revising it for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/417\">
issue 417</a>.
</li>
<li>
September 29, 2009, by Michael Wetter:<br/>
First implementation, based on <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"));
end RelativePressure;
