within Buildings.Templates.AirHandlersFans.Validation;
model CoilWaterBasedHeating
  extends NoEconomizer(    redeclare
      UserProject.AirHandlersFans.CoilWaterBasedHeating VAV_1);

  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CoilWaterBasedHeating;
