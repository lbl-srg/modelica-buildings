within Buildings.Templates.AirHandlersFans.Validation;
model CoilElectricHeating
  extends BaseNoEconomizer(redeclare
      UserProject.AirHandlersFans.CoilElectricHeating VAV_1);

  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CoilElectricHeating;
