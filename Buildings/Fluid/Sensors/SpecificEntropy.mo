within Buildings.Fluid.Sensors;
model SpecificEntropy "Ideal one port specific entropy sensor"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialAbsoluteSensor;
  extends Modelica.Icons.RotationalSensor;
  Modelica.Blocks.Interfaces.RealOutput s(final quantity="SpecificEntropy",
                                          final unit="J/(kg.K)")
    "Specific entropy in port medium"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
          rotation=0)));

equation
  s = Medium.specificEntropy(Medium.setState_phX(port.p,
          inStream(port.h_outflow), inStream(port.Xi_outflow)));
annotation (defaultComponentName="senSpeEnt",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
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
This component monitors the specific entropy of the fluid passing its port. 
The sensor is ideal, i.e. it does not influence the fluid.
</p>
</html>
",
revisions="<html>
<ul>
<li>
September 29, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpecificEntropy;
