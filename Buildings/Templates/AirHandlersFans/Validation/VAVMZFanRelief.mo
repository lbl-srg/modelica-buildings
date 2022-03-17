within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZFanRelief
  extends VAVMZNoEconomizer(redeclare
      UserProject.AirHandlersFans.VAVMZFanRelief VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end VAVMZFanRelief;
