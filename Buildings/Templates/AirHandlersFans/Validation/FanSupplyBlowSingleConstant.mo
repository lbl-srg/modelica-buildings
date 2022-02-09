within Buildings.Templates.AirHandlersFans.Validation;
model FanSupplyBlowSingleConstant
  extends BaseNoEconomizer(redeclare
      UserProject.AHUs.FanSupplyBlowSingleConstant VAV_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end FanSupplyBlowSingleConstant;
