within Buildings.Templates.ChilledWaterPlant.Validation;
model RP1711_6_8
  "Parallel Chillers with WSE, Primary-Secondary CHW, Variable CW, Headered Pumps"
  extends Buildings.Templates.ChilledWaterPlant.Validation.BaseChilledWaterPlant(
    redeclare Buildings.Templates.ChilledWaterPlant.Validation.UserProject.RP1711_6_8 chw);
  annotation (experiment(Tolerance=1e-6, StopTime=1));
end RP1711_6_8;
