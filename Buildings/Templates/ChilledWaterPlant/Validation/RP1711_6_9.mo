within Buildings.Templates.ChilledWaterPlant.Validation;
model RP1711_6_9
  "Parallel Chillers, Primary-Distributed Secondary, Air-Cooled"
  extends Buildings.Templates.ChilledWaterPlant.Validation.BaseWaterCooled(
    redeclare Buildings.Templates.ChilledWaterPlant.Validation.UserProject.RP1711_6_9 chw);
  annotation (experiment(Tolerance=1e-6, StopTime=1));
end RP1711_6_9;
