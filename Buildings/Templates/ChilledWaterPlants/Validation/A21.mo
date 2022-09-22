within Buildings.Templates.ChilledWaterPlants.Validation;
model A21 "Parallel chillers with WSE, primary-secondary, variable speed
CW pumps, headered pumps"
  extends Buildings.Templates.ChilledWaterPlants.Validation.Base(redeclare
      Buildings.Templates.ChilledWaterPlants.Validation.UserProject.A21 CHI);
  annotation (experiment(Tolerance=1e-6, StopTime=1));
end A21;
