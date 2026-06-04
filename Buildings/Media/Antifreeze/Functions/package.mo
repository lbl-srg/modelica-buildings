within Buildings.Media.Antifreeze;
package Functions "Medium packages of secondary working fluids"
  extends Modelica.Icons.VariantsPackage;

  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains media functions for liquid mixtures used in HVAC
applications. The media functions evaluate the thermophysical
properties at a user-specifiable temperature <code>property_T</code>,
and the thermophysical properties are then kept constant during the simulation.
</p>
<h4>Usage</h4>
<p>
The functions are implemented to allow function calls from data records
(or models) without having to instantiate a media package, as
instantiating a media package from a <code>record</code> is not allowed
in Modelica.
</p>
</html>"));
end Functions;
