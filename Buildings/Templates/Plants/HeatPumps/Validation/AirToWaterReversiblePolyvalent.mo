within Buildings.Templates.Plants.HeatPumps.Validation;
model AirToWaterReversiblePolyvalent
  "Validation of AWHP plant template with reversible (2-pipe) and polyvalent (4-pipe) units"
  extends Buildings.Templates.Plants.HeatPumps.Validation.AirToWater(
    redeclare Buildings.Templates.Plants.HeatPumps.Validation.UserProject.Data.AirToWaterPolyvalent datAll,
    pla(
      typ=Buildings.Templates.Plants.Controls.Types.PlantHeatPump.ReversiblePolyvalent,
      nHp_select=2,
      nPhp_select=3,
      typDis_select1=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2,
      typPumPri_select=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant,
      have_pumPriDedComHp_select=true,
      ctl(
        have_senVHeaWatPri_select=true,
        have_senVChiWatPri_select=true,
        have_senTChiWatSecRet_select=true,
        have_senTHeaWatSecRet_select=true)),
   ratLoa(
        table=[0,0,0; 5,0,0; 7,1,1; 10,0.5,0.8; 14,0,0.6; 16,0,1; 18,0,0.6; 22,
          0.1,0.1; 24,0,0])            );
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Validation/AirToWaterReversiblePolyvalent.mos"
    "Simulate and plot"),
  experiment(Tolerance=1e-6,
    StopTime=86400.0));
end AirToWaterReversiblePolyvalent;
