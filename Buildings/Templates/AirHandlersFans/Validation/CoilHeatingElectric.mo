within Buildings.Templates.AirHandlersFans.Validation;
model CoilHeatingElectric
  extends BaseNoEconomizer(redeclare UserProject.AHUs.CoilHeatingElectric VAV_1);

  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CoilHeatingElectric;
