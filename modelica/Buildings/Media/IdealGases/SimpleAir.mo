within Buildings.Media.IdealGases;
package SimpleAir "Air: Simple dry air model (0..100 degC)"
  extends Modelica.Media.Air.SimpleAir(
     T_min=Modelica.SIunits.Conversions.from_degC(-50));

  annotation (preferedView="info", Documentation(info="<html>
<p>
This partial package is identical to 
<a href=\"Modelica:Modelica.Media.Air.SimpleAir\">
Modelica.Media.Air.SimpleAir</a> except for the minimum fluid temperature.
The package is here for convenience so that all medium models that are typically used
with the <tt>Buildings</tt> library are at a central location.
</HTML>",
        revisions="<html>
<ul>
<li>
September 4, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end SimpleAir;
