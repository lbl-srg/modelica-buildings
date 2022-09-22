within Buildings.Templates.ChilledWaterPlants.Validation;
model A19 "Parallel chillers, primary-secondary, constant speed CW
pumps, dedicated primary pumps, headered CW pumps"
  extends Buildings.Templates.ChilledWaterPlants.Validation.Base(redeclare
      Buildings.Templates.ChilledWaterPlants.Validation.UserProject.A19 CHI);
  annotation (experiment(Tolerance=1e-6, StopTime=1));
end A19;
