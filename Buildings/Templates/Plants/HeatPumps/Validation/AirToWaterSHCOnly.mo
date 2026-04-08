within Buildings.Templates.Plants.HeatPumps.Validation;
model AirToWaterSHCOnly
  "Validation of AWHP plant template with polyvalent units only (without 2-pipe AWHP)"
  extends Buildings.Templates.Plants.HeatPumps.Validation.AirToWater(
    pla(
      typ=Buildings.Templates.Plants.HeatPumps.Types.Plant.Polyvalent));

annotation(
  experiment(Tolerance=1e-6,
    StopTime=86400.0));
end AirToWaterSHCOnly;
