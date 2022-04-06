within Buildings.Templates.ChilledWaterPlant.Validation;
model RP1711_6_3
  "Parallel Chillers with Waterside Economizer, Variable Primary Chilled Water, Variable Condenser Water, Headered Pumps"
  extends
    Buildings.Templates.ChilledWaterPlant.Validation.BaseChilledWaterPlant(
    redeclare Buildings.Templates.ChilledWaterPlant.Validation.UserProject.RP1711_6_3 chw);
  annotation (experiment(Tolerance=1e-6, StopTime=1));
end RP1711_6_3;
