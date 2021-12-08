within Buildings.Templates.AirHandlersFans.Validation;
model FanSupplyDrawArrayVariable
  extends NoEconomizer(
    redeclare UserProject.AHUs.FanSupplyDrawArrayVariable ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end FanSupplyDrawArrayVariable;
