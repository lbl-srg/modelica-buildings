within Buildings.Fluid.Sensors;
model SpecificEntropy "Ideal one port specific entropy sensor"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialAbsoluteSensor;
  extends Modelica.Icons.RotationalSensor;
  Modelica.Blocks.Interfaces.RealOutput s(final quantity="SpecificEntropy",
                                          final unit="J/(kg.K)")
    "Specific entropy in port medium"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  s = Medium.specificEntropy(state=Medium.setState_phX(
          p=port.p, h=inStream(port.h_outflow), X=inStream(port.Xi_outflow)));
annotation (defaultComponentName="senSpeEnt",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Line(points={{0,-70},{0,-100}}, color={0,0,127}),
        Text(
          extent={{-150,80},{150,120}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{156,-24},{54,-54}},
          lineColor={0,0,0},
          textString="s"),
        Line(points={{70,0},{100,0}}, color={0,0,127})}),
  Documentation(info="<html>
<p>
This model outputs the specific entropy of the fluid connected to its port.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
<p>
Read the
<a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a>
prior to using this model with one fluid port.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 29, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpecificEntropy;
