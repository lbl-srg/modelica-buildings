within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZFanSupplyBlowThrough "Validation model for multiple-zone VAV"
  extends VAVMZNoEconomizer(redeclare
      UserProject.AirHandlersFans.VAVMZFanSupplyBlowThrough VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end VAVMZFanSupplyBlowThrough;
