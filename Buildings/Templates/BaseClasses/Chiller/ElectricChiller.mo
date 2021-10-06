within Buildings.Templates.BaseClasses.Chiller;
model ElectricChiller
  extends Buildings.Templates.Interfaces.Chiller(
    final typ=Buildings.Templates.Types.Chiller.ElectricChiller);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ElectricChiller;
