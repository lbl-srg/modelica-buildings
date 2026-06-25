within Buildings.Templates.Plants.HeatPumps.Validation;
model AirToWaterPolyvalentOnly
  "Validation of AWHP plant template with polyvalent (4-pipe) units only"
  extends Buildings.Templates.Plants.HeatPumps.Validation.AirToWater(
    pla(
      typ=Buildings.Templates.Plants.Controls.Types.PlantHeatPump.Polyvalent,
        typArrPumPri_select=Buildings.Templates.Components.Types.PumpArrangement.Headered));
annotation(
  experiment(Tolerance=1e-6,
    StopTime=86400.0));
end AirToWaterPolyvalentOnly;
