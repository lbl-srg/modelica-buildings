within Buildings.Templates.Plants.HeatPumps.Validation;
model AirToWaterPolyvalent
  "Validation of AWHP plant template with polyvalent units"
  extends Buildings.Templates.Plants.HeatPumps.Validation.AirToWater(
    pla(
      typ=Buildings.Templates.Plants.HeatPumps.Types.Plant.ReversiblePolyvalent,
      nPhp_select=2,
      typDis_select1=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2,
      typPumPri_select=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable,
      have_pumPriComHp_select=false)
                                   );

annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Validation/AirToWaterPolyvalent.mos"
    "Simulate and plot"),
  experiment(Tolerance=1e-6,
    StopTime=86400.0));
end AirToWaterPolyvalent;
