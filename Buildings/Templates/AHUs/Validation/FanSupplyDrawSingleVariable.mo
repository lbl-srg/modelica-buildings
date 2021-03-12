within Buildings.Templates.AHUs.Validation;
model FanSupplyDrawSingleVariable
  extends BaseNoEquipment(
     redeclare UserProject.AHUs.FanSupplyDrawSingleVariable ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end FanSupplyDrawSingleVariable;
