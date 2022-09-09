within Buildings.Templates.ChilledWaterPlants.Validation;
model A16
  "Parallel chillers with WSE, variable primary, variable speed CW pumps, headered pumps"
  extends Buildings.Templates.ChilledWaterPlants.Validation.BaseWaterCooled(
      redeclare
      Buildings.Templates.ChilledWaterPlants.Validation.UserProject.A16 chw);
  annotation (experiment(Tolerance=1e-6, StopTime=1));
end A16;
