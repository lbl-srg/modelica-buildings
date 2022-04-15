within Buildings.Templates.ChilledWaterPlant.Validation;
model RP1711_6_6
  "Parallel Chillers, Primary-Secondary Chilled Water, Constant Condenser Water, Dedicated Primary Chilled Water Pumps, Headered Condenser Water Pumps"
  extends Buildings.Templates.ChilledWaterPlant.Validation.BaseWaterCooled(
    redeclare Buildings.Templates.ChilledWaterPlant.Validation.UserProject.RP1711_6_6 chw);
  annotation (experiment(Tolerance=1e-6, StopTime=1));
end RP1711_6_6;
