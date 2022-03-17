within Buildings.Templates.ZoneEquipment.Validation;
model VAVBoxReheat "Validation model for VAV terminal unit with reheat"
  extends VAVBoxCoolingOnly(redeclare UserProject.ZoneEquipment.VAVBoxReheat
      ter);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end VAVBoxReheat;
