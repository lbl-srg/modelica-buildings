within Buildings.Templates.ChilledWaterPlants.Validation;
model A22 "Parallel air-cooled chillers, primary-distributed secondary"
  extends Buildings.Templates.ChilledWaterPlants.Validation.Base(redeclare
      Buildings.Templates.ChilledWaterPlants.Validation.UserProject.A22 CHI);
  annotation (experiment(Tolerance=1e-6, StopTime=1));
end A22;
