within Buildings.Electrical.Transmission.MediumVoltageCables;
record Generic "Data record for a generic medium voltage cable"
  extends Modelica.Icons.MaterialProperty;
  extends Buildings.Electrical.Transmission.BaseClasses.BaseCable(
      final RCha=0.0,
      final XCha=0.0);

  annotation (Documentation(info="<html>
<p>
This is a base record for specifying physical properties for medium
voltage commercial cables. New cables can be added by extending the
it.
</p>
<p>
For medium voltage cables, the geometric properties of the cable and the material are
specified. See <a href=\"modelia://Buildings.Electrical.Transmission.Base.BaseCable\">
Buildings.Electrical.Transmission.Base.BaseCable</a> for a comprehensive list of
parameters that can be specified for a cable.
</p>
</html>"));
end Generic;
