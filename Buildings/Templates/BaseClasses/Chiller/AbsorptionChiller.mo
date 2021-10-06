within Buildings.Templates.BaseClasses.Chiller;
model AbsorptionChiller
  extends Buildings.Templates.Interfaces.Chiller(
    final typ=Buildings.Templates.Types.Chiller.AbsorptionChiller);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AbsorptionChiller;
