within Buildings.Templates.ZoneEquipment.Validation;
model VAVBoxReheatControlG36 "Validation model for VAV terminal unit with reheat"
  extends VAVBoxCoolingOnly(redeclare
      UserProject.ZoneEquipment.VAVBoxReheatControlG36 ter);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end VAVBoxReheatControlG36;
