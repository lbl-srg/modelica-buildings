within Buildings.Electrical.Transmission.MediumVoltageCables;
record Cable "Low Voltage Cable Type"
  extends Modelica.Icons.MaterialProperty;
  extends Buildings.Electrical.Transmission.BaseClasses.BaseCable(
                                                           final RCha=0.0,
      final XCha=0.0);

end Cable;
