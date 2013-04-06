within Buildings.Fluid.Sensors;
model Density "Ideal one port density sensor"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialAbsoluteSensor;
  extends Modelica.Icons.RotationalSensor;
  Modelica.Blocks.Interfaces.RealOutput d(final quantity="Density",
                                          final unit="kg/m3",
                                          min=0) "Density in port medium"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
          rotation=0)));

equation
  d = Medium.density(Medium.setState_phX(port.p, inStream(port.h_outflow), inStream(port.Xi_outflow)));
annotation (defaultComponentName="senDen",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),     graphics),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Line(points={{0,-70},{0,-100}}, color={0,0,127}),
        Text(
          extent={{-150,80},{150,120}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{154,-31},{56,-61}},
          lineColor={0,0,0},
          textString="d"),
        Line(points={{70,0},{100,0}}, color={0,0,127})}),
  Documentation(info="<html>
<p>
This component monitors the density of the fluid passing its port. 
The sensor is ideal, i.e. it does not influence the fluid.
</p>
<p>If using the one port sensor, read the 
<a href=\"modelica://Buildings.Fluid.Sensors\">Information</a> first.</p>
</html>
",
revisions="<html>
<ul>
<li>
September 29, 2009, by Michael Wetter:<br>
First implementation.
Implementation is based on <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"
));
end Density;
