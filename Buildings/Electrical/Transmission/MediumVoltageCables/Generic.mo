within Buildings.Electrical.Transmission.MediumVoltageCables;
record Generic "Data record for a generic medium voltage cable"
  extends Modelica.Icons.MaterialProperty;
  extends Buildings.Electrical.Transmission.BaseClasses.BaseCable(
      final RCha=0.0,
      final XCha=0.0);

  annotation (Documentation(info="<html>
<p>
This is a base record for specifying physical properties for medium
voltage commercial cables. New cables can be added by extending
it.
</p>
<p>
For medium voltage cables, the geometric properties of the cable and the material are
specified. For example some of the properties that are specified are:
</p>
<pre>
Rdc  : Characteristic DC resistance at T = Tref[Ohm/m]
Tref : Reference temperature of the material [K]
d    : Inner diameter [m]
D    : Outer diameter [m]
Amp  : Ampacity [A]
</pre>
<p>
other properties like the GMD (Geometric Mean Diameter) and the GMR
(Geometric Mean Radius) by default are computed using functions,
but can be override.
</p>
<p>
See <a href=\"modelia://Buildings.Electrical.Transmission.Base.BaseCable\">
Buildings.Electrical.Transmission.Base.BaseCable</a> for a comprehensive list of
parameters that can be specified for a cable.
</p>
</html>"));
end Generic;
