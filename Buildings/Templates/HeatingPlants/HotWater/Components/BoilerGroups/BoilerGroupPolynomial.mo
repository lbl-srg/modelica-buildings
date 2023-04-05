within Buildings.Templates.HeatingPlants.HotWater.Components.BoilerGroups;
model BoilerGroupPolynomial
  extends Buildings.Templates.HeatingPlants.HotWater.Components.BoilerGroup(
      final typMod=Buildings.Templates.Components.Types.ModelBoilerHotWater.Polynomial,
      redeclare final Buildings.Templates.Components.Boilers.HotWaterPolynomial
      boiPol);

annotation(defaultComponentName="boi");
end BoilerGroupPolynomial;
