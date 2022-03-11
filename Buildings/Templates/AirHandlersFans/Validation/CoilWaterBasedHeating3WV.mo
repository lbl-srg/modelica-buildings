within Buildings.Templates.AirHandlersFans.Validation;
model CoilWaterBasedHeating3WV
  extends NoEconomizer(    redeclare
      UserProject.AirHandlersFans.CoilWaterBasedHeating3WV VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CoilWaterBasedHeating3WV;
