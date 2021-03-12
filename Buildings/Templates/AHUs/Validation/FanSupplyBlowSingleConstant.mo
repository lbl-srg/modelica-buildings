within Buildings.Templates.AHUs.Validation;
model FanSupplyBlowSingleConstant
  extends BaseNoEquipment(
    redeclare UserProject.AHUs.FanSupplyBlowSingleConstant ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end FanSupplyBlowSingleConstant;
