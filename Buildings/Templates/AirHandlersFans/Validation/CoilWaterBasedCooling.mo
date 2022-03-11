within Buildings.Templates.AirHandlersFans.Validation;
model CoilWaterBasedCooling
  extends NoEconomizer(    redeclare
      UserProject.AirHandlersFans.CoilWaterBasedCooling VAV_1);

  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CoilWaterBasedCooling;
