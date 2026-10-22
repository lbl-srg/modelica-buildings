within Buildings.Templates.Plants.HeatPumps.Validation.UserProject.Data;
class BaseAirToWater
  "Top-level (whole building) system parameters"
  extends Buildings.Templates.Data.AllSystems(
    sysUni=Buildings.Templates.Types.Units.SI,
    stdEne=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    stdVen=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1,
    ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_3B);
  parameter Buildings.Templates.Plants.HeatPumps.Data.HeatPumpPlant pla(
    pumHeaWatPri(
      dp_nominal=fill(
        1.5 * (if pla.cfg.have_chiWat
          and pla.cfg.typArrPumPri ==
            Buildings.Templates.Components.Types.PumpArrangement.Dedicated
          and pla.cfg.have_hp
          and not pla.cfg.have_pumChiWatPriDedHp
          then max(pla.hp.dpHeaWatHp_nominal, pla.hp.dpChiWatHp_nominal)
          else pla.hp.dpHeaWatHp_nominal),
        pla.cfg.nPumHeaWatPri) .+ (if pla.cfg.typDis ==
        Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
        then Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max else 0)),
    pumHeaWatSec(
      dp_nominal=fill(
        Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max,
        pla.cfg.nPumHeaWatSec)),
    pumChiWatPri(
      dp_nominal=fill(1.5 * pla.hp.dpChiWatHp_nominal, pla.cfg.nPumChiWatPri) .+
        (if pla.cfg.typDis ==
          Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
          then Buildings.Templates.Data.Defaults.dpChiWatLocSet_max else 0)),
    pumChiWatSec(
      dp_nominal=fill(
        Buildings.Templates.Data.Defaults.dpChiWatLocSet_max,
        pla.cfg.nPumChiWatSec)),
    ctl(
      THeaWatSupSet_min=298.15,
      VHeaWatSec_flow_nominal=(pla.cfg.nHp * pla.ctl.VHeaWatHp_flow_nominal +
        pla.cfg.nPhp * pla.ctl.VHeaWatPhp_flow_nominal) / 1.1,
      TChiWatSupSet_max=288.15,
      VChiWatSec_flow_nominal=(pla.cfg.nHp * pla.ctl.VChiWatHp_flow_nominal +
        pla.cfg.nPhp * pla.ctl.VHeaWatPhp_flow_nominal) / 1.1,
      dpChiWatRemSet_max={Buildings.Templates.Data.Defaults.dpChiWatRemSet_max},
      dpHeaWatRemSet_max={Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max},
      dpChiWatLocSet_max=Buildings.Templates.Data.Defaults.dpChiWatLocSet_max,
      dpHeaWatLocSet_max=Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max,
      THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
      TOutChiWatLck=273.15,
      TOutHeaWatLck=Buildings.Templates.Data.Defaults.TOutHeaWatLck,
      TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup))
    "Parameters for heat pump plant"
    annotation(Dialog(group="Plants"),
      Placement(transformation(extent={{-10,0},{10,20}})));
annotation(defaultComponentPrefixes="inner parameter",
  defaultComponentName="datAll",
  Documentation(
    info="<html>
<p>
  This class provides the set of sizing and operating parameters for the whole
  HVAC system. It is aimed for validation purposes only.
</p>
</html>"));
end BaseAirToWater;
