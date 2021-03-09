within Buildings.Templates.AHUs.Validation;
model EconomizerCommonDamperTandem
  extends BaseNoEquipment(redeclare
      UserProject.AHUs.EconomizerCommonDamperTandem ahu);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end EconomizerCommonDamperTandem;
