within Buildings.Templates.Plants.HeatPumps.Validation;
model AirToWaterPolyvalent
  "Validation of AWHP plant template with polyvalent (4-pipe) units only"
  extends Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterReversiblePolyvalent(
    redeclare Buildings.Templates.Plants.HeatPumps.Validation.UserProject.Data.AirToWaterPolyvalent datAll,
    pla(
      typ=Buildings.Templates.Plants.Controls.Types.PlantHeatPump.Polyvalent,
      nPhp_select=3,
      typDis_select1=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only,
      typArrPumPri_select=Buildings.Templates.Components.Types.PumpArrangement.Headered,
      nPumHeaWatPri_select=2,
      nPumChiWatPri_select=2));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Validation/AirToWaterPolyvalent.mos"
    "Simulate and plot"),
  experiment(Tolerance=1e-6,
    StopTime=86400.0),
  Documentation(
    info="<html>
<p>
  This model extends
  <a href=\"modelica://Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterReversibleHeatRecovery\">
    Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterReversibleHeatRecovery</a>
  and validates the AWHP plant template
  <a href=\"modelica://Buildings.Templates.Plants.HeatPumps.AirToWater\">
    Buildings.Templates.Plants.HeatPumps.AirToWater</a> in a configuration
  with three polyvalent (4-pipe) heat pumps with lead/lag alternation, and a
  primary-only distribution system with headered pumps.
</p>
<p>
  The modeling assumptions are reproduced from the parent validation model,
  except for the load profile, which is deliberately chosen to increase
  simultaneous heating and cooling loads, exercising the mode selection and
  staging logic for polyvalent heat pumps.
</p>
<p>Simulating this model shows how the plant responds to a varying load by</p>
<ul>
  <li>
    enabling and alternating the polyvalent units in different operating
    modes,
  </li>
  <li>
    resetting the supply temperature and remote differential pressure in both
    the CHW and HW loops based on the valve position,
  </li>
  <li>
    staging and controlling the primary headered pumps to meet the remote
    differential pressure setpoint.
  </li>
</ul>
</html>"));
end AirToWaterPolyvalent;
