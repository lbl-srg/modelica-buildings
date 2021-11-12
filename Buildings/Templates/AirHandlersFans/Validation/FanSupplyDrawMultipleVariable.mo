within Buildings.Templates.AirHandlersFans.Validation;
model FanSupplyDrawMultipleVariable
  extends NoEconomizer(
    redeclare UserProject.AHUs.FanSupplyDrawMultipleVariable ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end FanSupplyDrawMultipleVariable;
