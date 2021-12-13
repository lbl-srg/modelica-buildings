within Buildings.Templates.Components;
package Sensors
  extends Modelica.Icons.Package;




annotation (Documentation(info="<html>
<p>
The parameter typ is set by default to the type of
sensor that the class name indicates.
It can be overriden and set to None to avoid instantiating a sensor
(a fluid pass through is used instead).
Connect sensor variables as input points to the control system such as
connect(TAirSup.busCon, busAHU.TAirSup).
</p>
</html>"));
end Sensors;
