within Buildings.Templates.Plants.HeatPumps.Validation;
model AirToWaterReversiblePolyvalent
  "Validation of AWHP plant template with reversible (2-pipe) and polyvalent (4-pipe) units"
  extends Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterReversibleHeatRecovery(
    redeclare Buildings.Templates.Plants.HeatPumps.Validation.UserProject.Data.AirToWaterReversiblePolyvalent datAll,
    pla(
      typ=Buildings.Templates.Plants.Controls.Types.PlantHeatPump.ReversiblePolyvalent,
      nHp_select=2,
      nPhp_select=1,
      typDis_select1=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2,
      typPumPri_select=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant,
      have_pumPriDedComHp_select=true,
      ctl(have_senTPriRet_select=true)),
    ratLoa(
      table=[
        0, 0, 0;
        5, 0, 0;
        7, 1, 1;
        10, 0.5, 0.8;
        14, 0, 0.6;
        16, 0, 1;
        18, 0, 0.6;
        22, 0.1, 0.1;
        24, 0, 0
      ]));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Validation/AirToWaterReversiblePolyvalent.mos"
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
  with two reversible (2-pipe) heat pumps with lead/lag alternation and one
  polyvalent (4-pipe) heat pump.
</p>
<p>
  The modeling assumptions are reproduced from the parent validation model,
  except for the load profile, which is deliberately chosen to maximize
  simultaneous heating and cooling loads during the first hours of the
  simulation, exercising the mode selection and staging logic for polyvalent
  heat pumps. Note that the concomitant load profile then exceeds the plant's
  simultaneous heating and cooling capacity, and the CHW supply temperature
  setpoint is not met during this period.
</p>
<p>Simulating this model shows how the plant responds to a varying load by</p>
<ul>
  <li>
    staging the polyvalent unit up first in simultaneous heating and cooling
    mode,
  </li>
  <li>
    enabling and alternating the reversible units in heating or cooling mode,
  </li>
  <li>
    switching the polyvalent unit to cooling-only mode when the heating load
    falls to zero,
  </li>
  <li>
    enabling the dedicated primary pumps as required by the served equipment,
  </li>
  <li>
    resetting the supply temperature and remote differential pressure in both
    the CHW and HW loops based on the valve position,
  </li>
  <li>
    staging and controlling the secondary pumps to meet the remote
    differential pressure setpoint.
  </li>
</ul>
</html>"));
end AirToWaterReversiblePolyvalent;
