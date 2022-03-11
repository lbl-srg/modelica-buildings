within Buildings.Templates.ZoneEquipment.Validation;
model VAVBoxReheatHotWater
  extends VAVBoxCoolingOnly(redeclare
      UserProject.ZoneEquipment.VAVBoxReheatHotWater ter);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end VAVBoxReheatHotWater;
