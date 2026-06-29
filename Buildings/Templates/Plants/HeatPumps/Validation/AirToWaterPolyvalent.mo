within Buildings.Templates.Plants.HeatPumps.Validation;
model AirToWaterPolyvalent
  "Validation of AWHP plant template with polyvalent (4-pipe) units only"
  extends Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterReversiblePolyvalent(pla(
      typ=Buildings.Templates.Plants.Controls.Types.PlantHeatPump.Polyvalent,
      nPhp_select=3,
      typDis_select1=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only,
      typArrPumPri_select=Buildings.Templates.Components.Types.PumpArrangement.Headered));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Validation/AirToWaterPolyvalent.mos"
    "Simulate and plot"),
  experiment(Tolerance=1e-6,
    StopTime=86400.0));
end AirToWaterPolyvalent;
