within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZNoRelief
  extends VAVMZNoEconomizer(redeclare UserProject.AirHandlersFans.VAVMZNoRelief
      VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end VAVMZNoRelief;
