within Buildings.Templates.AirHandlersFans.Validation;
model FanSupplyDrawSingleVariable
  extends BaseNoEconomizer(redeclare
      UserProject.AHUs.FanSupplyDrawSingleVariable VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end FanSupplyDrawSingleVariable;
