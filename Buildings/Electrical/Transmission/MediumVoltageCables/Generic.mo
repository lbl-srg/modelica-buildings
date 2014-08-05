within Buildings.Electrical.Transmission.MediumVoltageCables;
record Generic "Data record for a generic medium voltage cable"
  extends Modelica.Icons.MaterialProperty;
  extends Buildings.Electrical.Transmission.BaseClasses.BaseCable(
      final RCha=0.0,
      final XCha=0.0);

end Generic;
