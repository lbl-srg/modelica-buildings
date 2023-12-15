within Buildings.Templates.Plants.HeatPumps;
model AirSource "Air-source heat pump plant"
  extends Buildings.Templates.Plants.HeatPumps.Interfaces.PartialHeatPumpPlant(
    redeclare final package MediumSou=Buildings.Media.Air);
end AirSource;
