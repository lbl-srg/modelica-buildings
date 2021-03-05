within Buildings.Templates.AHUs.Validation;
model SupplyFanBlowSingleConstant
  extends BaseNoEquipment(
    redeclare UserProject.AHUs.SupplyFanBlowSingleConstant ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end SupplyFanBlowSingleConstant;
