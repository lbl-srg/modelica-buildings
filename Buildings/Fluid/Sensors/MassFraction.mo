within Buildings.Fluid.Sensors;
model MassFraction "Ideal one port mass fraction sensor"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialAbsoluteSensor(
    redeclare replaceable package Medium =
        Modelica.Media.Interfaces.PartialCondensingGases);
  extends Buildings.Fluid.BaseClasses.IndexMassFraction(substanceName = "water");
  extends Modelica.Icons.RotationalSensor;

  Modelica.Blocks.Interfaces.RealOutput X(min=-1e-3,
                                          max=1.001,
                                          unit="1") "Mass fraction in port"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  Medium.MassFraction XiVec[Medium.nXi](
      quantity=Medium.extraPropertiesNames)
    "Mass fraction vector, needed because indexed argument for the operator inStream is not supported";

equation
  XiVec = inStream(port.Xi_outflow);
  X = if i_x > Medium.nXi then (1-sum(XiVec)) else XiVec[i_x];
annotation (defaultComponentName="senMasFra",
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
          textString="X"),
        Line(points={{70,0},{100,0}}, color={0,0,127})}),
  Documentation(info="<html>
<p>
This model outputs the mass fraction of the fluid connected to its port.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
<p>
Read the
<a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a>
prior to using this model with one fluid port.
</p>
</html>", revisions="<html>
<ul>
<li>
September 10, 2013, by Michael Wetter:<br/>
Changed <code>min</code> and <code>max</code> values for
output signals to allow for numerical approximation error
without violating these bounds.<br/>
Changed medium declaration in the <code>extends</code> statement
to <code>replaceable</code> to avoid a translation error in
OpenModelica.
</li>
<li>
August 31, 2013, by Michael Wetter:<br/>
Revised model to use base class
<a href=\"modelica://Buildings.Fluid.BaseClasses.IndexMassFraction\">
Buildings.Fluid.BaseClasses.IndexMassFraction</a>.
</li>
<li>
February 22, by Michael Wetter:<br/>
Improved the code that searches for the index of the substance in the medium model.
</li>
<li>
April 7, 2009 by Michael Wetter:<br/>
First implementation.
Implementation is based on enthalpy sensor of <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"));
end MassFraction;
