within Buildings.Templates.AHUs.Validation;
model EconomizerCommonDamper
  extends BaseNoEquipment(redeclare UserProject.AHUs.EconomizerCommonDamper ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end EconomizerCommonDamper;
