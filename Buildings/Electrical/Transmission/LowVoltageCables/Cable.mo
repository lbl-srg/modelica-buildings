within Buildings.Electrical.Transmission.LowVoltageCables;
record Cable "Low Voltage Cable Type"
  extends Modelica.Icons.MaterialProperty;
  extends Buildings.Electrical.Transmission.Base.BaseCable(
    final size="",
    final Rdc=0.0,
    final d=0.0,
    final D=0.0,
    final GMR=0.0,
    final GMD=0.0);
end Cable;
