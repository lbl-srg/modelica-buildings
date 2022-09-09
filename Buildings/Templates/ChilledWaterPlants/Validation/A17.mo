within Buildings.Templates.ChilledWaterPlants.Validation;
model A17 "Series chillers, constant primary, constant speed CW
pumps, headered pumps"
  extends Buildings.Templates.ChilledWaterPlants.Validation.BaseWaterCooled(
      redeclare
      Buildings.Templates.ChilledWaterPlants.Validation.UserProject.A17 chw);
  annotation (experiment(Tolerance=1e-6, StopTime=1));
end A17;
