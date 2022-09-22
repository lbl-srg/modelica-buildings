within Buildings.Templates.ChilledWaterPlants.Validation;
model A15
  "Parallel chillers, variable primary, constant speed CW pumps, dedicated pumps"
  extends Buildings.Templates.ChilledWaterPlants.Validation.Base(redeclare
      Buildings.Templates.ChilledWaterPlants.Validation.UserProject.A15 CHI);
  annotation (experiment(Tolerance=1e-6, StopTime=1));
end A15;
