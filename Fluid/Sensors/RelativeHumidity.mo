within Buildings.Fluid.Sensors;
model RelativeHumidity "Ideal one port relative humidity sensor"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialAbsoluteSensor;
  extends Modelica.Icons.RotationalSensor;

  Modelica.Blocks.Interfaces.RealOutput phi(unit="1", min=0)
    "Relative humidity in port medium"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
          rotation=0)));

protected
  Medium.BaseProperties med "Medium state at dry bulb temperature";

equation
  med.p = port.p;
  med.h = inStream(port.h_outflow);
  med.Xi = inStream(port.Xi_outflow);
  phi = med.phi;

annotation (defaultComponentName="senRelHum",
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
          extent={{160,-30},{60,-60}},
          lineColor={0,0,0},
          textString="phi"),
        Line(points={{70,0},{100,0}}, color={0,0,127})}),
  Documentation(info="<html>
<p>
This model outputs the relative humidity of the fluid connected to its port. 
The sensor is ideal, i.e. it does not influence the fluid.
</p>
<p>
Note that this sensor can only be used with media that contain the variable <code>phi</code>,
which is typically the case for moist air models.
</p>
<p>
Read the 
<a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a>
prior to using this model with one fluid port.
</p>
</html>
", revisions="<html>
<ul>
<li>
May 12, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end RelativeHumidity;
