within Buildings.Electrical.Transmission.LowVoltageCables;
record Generic "Data record for a generic low voltage cable"
  extends Modelica.Icons.MaterialProperty;
  extends Buildings.Electrical.Transmission.BaseClasses.BaseCable(
    final size="",
    final Rdc=0.0,
    final d=0.0,
    final D=0.0,
    final GMR=0.0,
    final GMD=0.0);
  annotation (Documentation(info="<html>
<p>
This is a base record for specifying physical properties for low
voltage commercial cables. New cables can be added by extending the
it.
</p>
<p>
For low voltage cables, only the characteristic resistance and reactance are
specified. See <a href=\"modelia://Buildings.Electrical.Transmission.Base.BaseCable\">
Buildings.Electrical.Transmission.Base.BaseCable</a> for a comprehensive list of
parameters that can be specified for a cable.
</p>
</html>", revisions="<html>
<ul>
<li>
Sept 19, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>"));
end Generic;
