within Buildings.Templates.AHUs.Validation;
model SupplyFanDrawMultipleVariable
  extends BaseNoEquipment(
    redeclare UserProject.AHUs.SupplyFanDrawMultipleVariable ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end SupplyFanDrawMultipleVariable;
