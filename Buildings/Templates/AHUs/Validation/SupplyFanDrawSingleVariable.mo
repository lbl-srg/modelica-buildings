within Buildings.Templates.AHUs.Validation;
model SupplyFanDrawSingleVariable
  extends BaseNoEquipment(
     redeclare UserProject.AHUs.SupplyFanDrawSingleVariable ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end SupplyFanDrawSingleVariable;
