within Buildings.Templates.HeatingPlants.HotWater.Components.BoilerGroups;
model BoilerGroupTable
  extends Buildings.Templates.HeatingPlants.HotWater.Components.BoilerGroup(
      final typMod=Buildings.Templates.Components.Types.ModelBoilerHotWater.Table,
      redeclare final Buildings.Templates.Components.Boilers.HotWaterTable
      boiPol);

annotation(defaultComponentName="boi");
end BoilerGroupTable;
