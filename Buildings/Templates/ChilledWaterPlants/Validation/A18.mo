within Buildings.Templates.ChilledWaterPlants.Validation;
model A18
  "Series chillers with WSE, variable primary, variable speed CW pumps, headered pumps"
  extends Buildings.Templates.ChilledWaterPlants.Validation.Base(redeclare
      Buildings.Templates.ChilledWaterPlants.Validation.UserProject.A18 CHI);
  annotation (experiment(Tolerance=1e-6, StopTime=1));
end A18;
