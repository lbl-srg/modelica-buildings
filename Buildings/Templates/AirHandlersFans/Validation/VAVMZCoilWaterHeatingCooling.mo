within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZCoilWaterHeatingCooling
  extends VAVMZNoEconomizer(redeclare
      UserProject.AirHandlersFans.VAVMZCoilWaterHeatingCooling VAV_1);

  annotation (
    experiment(Tolerance=1e-6, StopTime=1),
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VAVMZCoilWaterHeatingCooling;
