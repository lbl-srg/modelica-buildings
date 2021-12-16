within Buildings.Templates.AirHandlersFans.Validation;
model CoilHeatingElectric
  extends NoEconomizer(   redeclare
    UserProject.AHUs.CoilHeatingElectric ahu);

  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CoilHeatingElectric;
