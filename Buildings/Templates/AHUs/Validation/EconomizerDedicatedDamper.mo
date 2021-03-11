within Buildings.Templates.AHUs.Validation;
model EconomizerDedicatedDamper
  extends BaseNoEquipment(
    redeclare UserProject.AHUs.EconomizerDedicatedDamper ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end EconomizerDedicatedDamper;
