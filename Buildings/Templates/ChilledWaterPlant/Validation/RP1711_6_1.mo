within Buildings.Templates.ChilledWaterPlant.Validation;
model RP1711_6_1
  "Parallel Chillers, Variable Primary Chilled Water, Constant Condenser Water, Headered Pumps"
  extends
    Buildings.Templates.ChilledWaterPlant.Validation.BaseWaterCooled(
    redeclare Buildings.Templates.ChilledWaterPlant.Validation.UserProject.RP1711_6_1 chw);
  annotation (experiment(Tolerance=1e-6, StopTime=1));
end RP1711_6_1;
