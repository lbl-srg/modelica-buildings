within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZCoilElectricHeating
  extends VAVMZNoEconomizer(redeclare
      UserProject.AirHandlersFans.VAVMZCoilElectricHeating VAV_1);

  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end VAVMZCoilElectricHeating;
