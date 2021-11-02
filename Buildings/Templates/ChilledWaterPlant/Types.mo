within Buildings.Templates.ChilledWaterPlant;
package Types
  extends Modelica.Icons.TypesPackage;
  type ChilledWaterReturnSection = enumeration(
      NoEconomizer "No waterside economizer",
      WatersideEconomizer
      "Waterisde economizer");
  type ChilledWaterPumpGroup = enumeration(
      HeaderedPrimary "Headered primary pumps only",
      DedicatedPrimary "Dedicated primary pumps only",
      HeaderedPrimarySecondary "Headered primary pumps with secondary pumps",
      DedicatedPrimarySecondary "Dedicated primary pumps with secondary pumps");
  type Chiller = enumeration(
      ElectricChiller
      "Electric water cooled chiller",
      AbsorptionChiller
      "Absorption chiller");
  type ChillerGroup = enumeration(
      ChillerParallel
      "Chillers in parallel",
      ChillerSeries
      "Chillers in series");
  type ChilledWaterPlant = enumeration(
      WaterCooledChiller
      "Water cooled chiller plant",
      AirCooledChiller
      "Air cooled chiller plant");
  type CondenserWaterPumpGroup = enumeration(
      Headered "Headered condensing water pumps",
      Dedicated "Dedicated condensing water pumps");
  type Controller = enumeration(
      Guideline36 "Guideline 36 control sequence",
      OpenLoop "Open loop");
  type CoolingTowerGroup = enumeration(
      CoolingTowerParallel
      "Cooling towers in parallel");
end Types;
