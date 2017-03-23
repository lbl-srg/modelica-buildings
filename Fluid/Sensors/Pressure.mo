within Buildings.Fluid.Sensors;
model Pressure "Ideal pressure sensor"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialAbsoluteSensor;
  extends Modelica.Icons.RotationalSensor;
  Modelica.Blocks.Interfaces.RealOutput p(final quantity="Pressure",
                                          final unit="Pa",
                                          min=0) "Pressure at port"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
          rotation=0)));
equation
  p = port.p;
  annotation (defaultComponentName="senPre",
  Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1})),
  Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Line(points={{70,0},{100,0}}, color={0,0,127}),
        Line(points={{0,-70},{0,-100}}, color={0,127,255}),
        Text(
          extent={{-150,80},{150,120}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{151,-20},{57,-50}},
          lineColor={0,0,0},
          textString="p")}),
    Documentation(info="<html>
<p>
This model outputs the absolute pressure of the fluid connected to its port. 
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 29, 2009, by Michael Wetter:<br/>
First implementation, based on <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"));
end Pressure;
