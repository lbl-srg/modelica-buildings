within Buildings.Obsolete.Media.IdealGases;
package SimpleAir "Air: Simple dry air model (-50..100 degC)"
  extends Modelica.Media.Air.SimpleAir(
     T_min=Modelica.SIunits.Conversions.from_degC(-50));

replaceable function enthalpyOfCondensingGas
    "Enthalpy of steam per unit mass of steam"
  extends Modelica.Icons.Function;
  input Temperature T "temperature";
  output SpecificEnthalpy h "steam enthalpy";
algorithm
  h := 0;
  annotation (Documentation(info="<html>
<p>
Dummy function that returns <code>0</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 27, 2011, by Michael Wetter:<br/>
First implementation to allow using the room model with a medium that does not contain water vapor.
</li>
</ul>
</html>"));
end enthalpyOfCondensingGas;

replaceable function saturationPressure
    "Return saturation pressure of condensing fluid"
  extends Modelica.Icons.Function;
  input Temperature Tsat "saturation temperature";
  output AbsolutePressure psat "saturation pressure";
algorithm
  psat := 0;
  annotation (Documentation(info="<html>
<p>
Dummy function that returns <code>0</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 27, 2011, by Michael Wetter:<br/>
First implementation to allow using the room model with a medium that does not contain water vapor.
</li>
</ul>
</html>"));
end saturationPressure;

  annotation (preferredView="info", Documentation(info="<html>
<p>
This package is identical to
<a href=\"modelica://Modelica.Media.Air.SimpleAir\">
Modelica.Media.Air.SimpleAir</a> except for the minimum fluid temperature.
The package is here for convenience so that all medium models that are typically used
with the <code>Buildings</code> library are at a central location.
</html>",
        revisions="<html>
<ul>
<li>
April 27, 2011, by Michael Wetter:<br/>
Added function <code>enthalpyOfCondensingGas</code>, which returns <code>0</code>,
to allow using the room model with a medium that does not contain water vapor.
</li><li>
September 4, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SimpleAir;
