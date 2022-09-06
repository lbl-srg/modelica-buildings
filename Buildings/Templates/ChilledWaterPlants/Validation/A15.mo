within Buildings.Templates.ChilledWaterPlants.Validation;
model A15
  "Parallel chillers, variable primary, constant speed CW pumps, dedicated pumps"
  extends Buildings.Templates.ChilledWaterPlants.Validation.BaseWaterCooled(
      redeclare
      Buildings.Templates.ChilledWaterPlants.Validation.UserProject.RP1711_6_2
      chw);
  annotation (experiment(Tolerance=1e-6, StopTime=1));
end A15;
