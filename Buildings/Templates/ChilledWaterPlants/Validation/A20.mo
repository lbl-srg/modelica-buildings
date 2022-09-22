within Buildings.Templates.ChilledWaterPlants.Validation;
model A20 "Parallel chillers, primary-secondary, constant speed CW
pumps, headered pumps"
  extends Buildings.Templates.ChilledWaterPlants.Validation.Base(redeclare
      Buildings.Templates.ChilledWaterPlants.Validation.UserProject.A20 CHI);
  annotation (experiment(Tolerance=1e-6, StopTime=1));
end A20;
