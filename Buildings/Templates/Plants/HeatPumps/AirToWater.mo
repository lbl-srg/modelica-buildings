within Buildings.Templates.Plants.HeatPumps;
model AirToWater "Air-to-water heat pump plant"
  extends Buildings.Templates.Plants.HeatPumps.Interfaces.PartialHeatPumpPlant(
    redeclare final package MediumSou=Buildings.Media.Air);
end AirToWater;
