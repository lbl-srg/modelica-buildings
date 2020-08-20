within Buildings.Applications.DHC.CentralPlants.Heating.Generation1.Subsystems;
model FeedwaterSubsystem
  "Feedwater subsystem with a single tank and parallel pumps"
  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end FeedwaterSubsystem;
