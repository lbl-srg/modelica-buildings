within Buildings.Applications.DHC.CentralPlants.Heating.Generation1.Subsystems;
model CondensateSubsystem
  "Condensate subsystem with a storage tank and parallel pumps"
  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CondensateSubsystem;
