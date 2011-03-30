within Buildings.Fluid.Sensors;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Info;
  annotation (DocumentationClass=true, Documentation(info="<html>
<p>
This package contains models of sensors.
There are models with one and with two fluid ports.
</p>
<p>
Note that sensors with two ports should be used
if the measured quantity depends on the direction of the flow,
such as temperature, relative humidity or density. 
The use of sensors with one fluid port is <i>discouraged</i> for such
quantities,
unless the sensor is directly connected to the port of a volume
in the package
<a href=\"modelica://Buildings.Fluid.MixingVolumes\">
Buildings.Fluid.MixingVolumes</a>.
For an explanation, see
<a href=\"modelica:Modelica.Fluid.Examples.Explanatory.MeasuringTemperature\">
Modelica.Fluid.Examples.Explanatory.MeasuringTemperature</a>.
</p>
<p>
For quantities that do not depend on the flow direction,
such as static pressure, sensors with one or with two 
ports can be used for all connection topologies.
</p>
</html>"));

end UsersGuide;
