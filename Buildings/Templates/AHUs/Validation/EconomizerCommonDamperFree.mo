within Buildings.Templates.AHUs.Validation;
model EconomizerCommonDamperFree
  extends BaseNoEquipment(redeclare UserProject.AHUs.EconomizerCommonDamperFree
      ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end EconomizerCommonDamperFree;
