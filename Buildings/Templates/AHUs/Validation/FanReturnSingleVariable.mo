within Buildings.Templates.AHUs.Validation;
model FanReturnSingleVariable
  extends BaseNoEquipment(
     redeclare UserProject.AHUs.FanReturnSingleVariable ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end FanReturnSingleVariable;
