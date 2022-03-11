within Buildings.Templates.ZoneEquipment.Validation;
model VAVBoxReheatHotWaterG36
  extends VAVBoxCoolingOnly(redeclare
      UserProject.ZoneEquipment.VAVBoxReheatHotWaterG36 ter);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end VAVBoxReheatHotWaterG36;
