within Buildings.Fluid.Sensors;
model Temperature "Ideal one port temperature sensor"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialAbsoluteSensor;

  Modelica.Blocks.Interfaces.RealOutput T(final quantity="ThermodynamicTemperature",
                                          final unit = "K",
                                          min=0,
                                          displayUnit = "degC")
    "Temperature in port medium"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  T = Medium.temperature(state=Medium.setState_phX(
        p=port.p, h=inStream(port.h_outflow), X=inStream(port.Xi_outflow)));

annotation (
  defaultComponentName="senTem",
  Documentation(info="<html>
<p>
This model outputs the temperature of the fluid connected to its port.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
<p>
To measure temperature in a duct or pipe, use
<a href=\"modelica://Buildings.Fluid.Sensors.TemperatureTwoPort\">Buildings.Fluid.Sensors.TemperatureTwoPort</a>
rather than this sensor.
Read the
<a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a>
prior to using this model to see about potential numerical problems if this sensor is used incorrectly
in a system model.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 21, 2020, by Michael Wetter:<br/>
Introduced parameter <code>warnAboutOnePortConnection</code> and updated documentation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1399\">#1399</a>.
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
</html>"),
  Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,100}}),
                        graphics={
        Line(points={{0,-70},{0,-100}}, color={0,0,127}),
        Ellipse(
          extent={{-20,-98},{20,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,40},{12,-68}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-12,40},{-12,80},{-10,86},{-6,88},{0,90},{6,88},{10,86},{
              12,80},{12,40},{-12,40}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-12,40},{-12,-64}},
          thickness=0.5),
        Line(
          points={{12,40},{12,-64}},
          thickness=0.5),
        Line(points={{-40,-20},{-12,-20}}),
        Line(points={{-40,20},{-12,20}}),
        Line(points={{-40,60},{-12,60}}),
        Line(points={{12,0},{60,0}}, color={0,0,127})}),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Ellipse(
          extent={{-20,-88},{20,-50}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,50},{12,-58}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-12,50},{-12,90},{-10,96},{-6,98},{0,100},{6,98},{10,96},{12,
              90},{12,50},{-12,50}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-12,50},{-12,-54}},
          thickness=0.5),
        Line(
          points={{12,50},{12,-54}},
          thickness=0.5),
        Line(points={{-40,-10},{-12,-10}}),
        Line(points={{-40,30},{-12,30}}),
        Line(points={{-40,70},{-12,70}}),
        Text(
          extent={{126,-30},{6,-60}},
          textColor={0,0,0},
          textString="T"),
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255}),
        Line(points={{12,0},{60,0}}, color={0,0,127}),
        Text(
          extent={{180,90},{60,40}},
          textColor={0,0,0},
          textString=DynamicSelect("", String(T-273.15, format=".1f")))}));
end Temperature;
