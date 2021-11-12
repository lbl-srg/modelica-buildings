within Buildings.Templates.ChilledWaterPlant.Components;
package Types
  extends Modelica.Icons.TypesPackage;
  type ChilledWaterReturnSection = enumeration(
      NoEconomizer "No waterside economizer",
      WatersideEconomizer
      "Waterisde economizer");
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
  type CondenserWaterPumpGroup = enumeration(
      Headered "Headered condensing water pumps",
      Dedicated "Dedicated condensing water pumps");
  type Controller = enumeration(
      Guideline36 "Guideline 36 control sequence",
      OpenLoop "Open loop");
  type CoolingTowerGroup = enumeration(
      CoolingTowerParallel
      "Cooling towers in parallel");
  type PrimaryPumpGroup = enumeration(
      Headered "Headered primary pumps",
      Dedicated "Dedicated primary pumps");
  type SecondaryPumpGroup = enumeration(
      None "No secondary pumps",
      Centralized "Centralized secondary pumps",
      Distributed "Distributed secondary pumps");
end Types;
