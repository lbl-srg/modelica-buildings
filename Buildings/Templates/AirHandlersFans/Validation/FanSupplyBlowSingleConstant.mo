within Buildings.Templates.AirHandlersFans.Validation;
model FanSupplyBlowSingleConstant
  extends NoFanNoReliefSingleDamper(
    redeclare UserProject.AHUs.FanSupplyBlowSingleConstant ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end FanSupplyBlowSingleConstant;
