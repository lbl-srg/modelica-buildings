within Buildings.Templates.AirHandlersFans.Validation;
model FanSupplyDrawSingleVariable
  extends NoEconomizer(    redeclare
      UserProject.AirHandlersFans.FanSupplyDrawSingleVariable VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end FanSupplyDrawSingleVariable;
