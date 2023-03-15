within Buildings.Templates.HeatingPlants.HotWater.Components.BoilerGroups;
model BoilerGroupPolynomial
  extends Buildings.Templates.HeatingPlants.HotWater.Components.Interfaces.BoilerGroup(
    final typMod=Buildings.Templates.Components.Types.ModelBoilerHotWater.Polynomial,
    redeclare final Buildings.Templates.Components.Boilers.HotWaterPolynomial boi);

annotation(defaultComponentName="boi");
end BoilerGroupPolynomial;
