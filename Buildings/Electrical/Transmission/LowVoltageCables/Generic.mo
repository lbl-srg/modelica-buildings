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
end Generic;
