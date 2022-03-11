within Buildings.Templates.AirHandlersFans.Validation;
model CoilWaterBasedHeating2WV
  extends NoEconomizer(    redeclare
      UserProject.AirHandlersFans.CoilWaterBasedHeating2WV VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CoilWaterBasedHeating2WV;
