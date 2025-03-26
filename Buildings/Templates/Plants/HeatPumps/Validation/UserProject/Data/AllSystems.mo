within Buildings.Templates.Plants.HeatPumps.Validation.UserProject.Data;
class AllSystems
  "Top-level (whole building) system parameters"
  extends Buildings.Templates.Data.AllSystems(
    sysUni=Buildings.Templates.Types.Units.SI,
    stdEne=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    stdVen=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1,
    ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_3B);
  parameter Buildings.Templates.Plants.HeatPumps.Data.HeatPumpPlant pla(
    hp(
      capHeaHp_nominal=500E3,
      capCooHp_nominal=500E3,
      mHeaWatHp_flow_nominal=pla.hp.capHeaHp_nominal/abs(pla.ctl.THeaWatSup_nominal
           - Buildings.Templates.Data.Defaults.THeaWatRetMed)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      mChiWatHp_flow_nominal=pla.hp.capCooHp_nominal/abs(pla.ctl.TChiWatSup_nominal
           - Buildings.Templates.Data.Defaults.TChiWatRet)/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      dpHeaWatHp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
      TSouHeaHp_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
      TSouCooHp_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
      perFitHp(hea(
          P=pla.hp.capHeaHp_nominal/Buildings.Templates.Data.Defaults.COPHpAwHea,
          coeQ={-4.2670305442,-0.7381077035,6.0049480456,0,0},
          coeP={-4.9107455513,5.3665308366,0.5447612754,0,0},
          TRefLoa=pla.hp.THeaWatRetHp_nominal,
          TRefSou=pla.hp.TSouHeaHp_nominal), coo(
          P=pla.hp.capCooHp_nominal/Buildings.Templates.Data.Defaults.COPHpAwCoo,
          coeQ={-2.2545246871,6.9089257665,-3.6548225094,0,0},
          coeP={-5.8086010402,1.6894933858,5.1167787436,0,0},
          TRefLoa=pla.hp.TChiWatRetHp_nominal,
          TRefSou=pla.hp.TSouCooHp_nominal))),
    pumHeaWatPri(dp_nominal=fill(
      (if pla.cfg.have_chiWat and pla.cfg.typPumChiWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
        then max(pla.hp.dpHeaWatHp_nominal, pla.hp.dpChiWatHp_nominal) else  pla.hp.dpHeaWatHp_nominal) *1.2, pla.cfg.nPumHeaWatPri)
           .+ (if pla.cfg.typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only
           or pla.cfg.typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
           then Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max else 0)),
    pumHeaWatSec(
      m_flow_nominal=fill(
        pla.ctl.VHeaWatSec_flow_nominal*Buildings.Media.Water.d_const/max(1,pla.cfg.nPumHeaWatSec), pla.cfg.nPumHeaWatSec),
      dp_nominal=fill(Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max, pla.cfg.nPumHeaWatSec)),
    pumChiWatPri(dp_nominal=fill(pla.hp.dpChiWatHp_nominal*1.2, pla.cfg.nPumChiWatPri)
           .+ (if pla.cfg.typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only
           or pla.cfg.typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
           then Buildings.Templates.Data.Defaults.dpChiWatLocSet_max else 0)),
    pumChiWatSec(
      m_flow_nominal=fill(
        pla.ctl.VChiWatSec_flow_nominal*Buildings.Media.Water.d_const/max(1,pla.cfg.nPumChiWatSec), pla.cfg.nPumChiWatSec),
      dp_nominal=fill(Buildings.Templates.Data.Defaults.dpChiWatLocSet_max, pla.cfg.nPumChiWatSec)),
    ctl(
      THeaWatSupSet_min=298.15,
      VHeaWatSec_flow_nominal=pla.cfg.nHp * pla.ctl.VHeaWatHp_flow_nominal / 1.1,
      TChiWatSupSet_max=288.15,
      VChiWatSec_flow_nominal=pla.cfg.nHp * pla.ctl.VChiWatHp_flow_nominal / 1.1,
      dpChiWatRemSet_max={Buildings.Templates.Data.Defaults.dpChiWatRemSet_max},
      dpHeaWatRemSet_max={Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max},
      THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
      TOutChiWatLck=273.15,
      TOutHeaWatLck=Buildings.Templates.Data.Defaults.TOutHeaWatLck,
      VHeaWatHp_flow_nominal=pla.hp.mHeaWatHp_flow_nominal/Buildings.Media.Water.d_const,
      VChiWatHp_flow_nominal=pla.hp.mChiWatHp_flow_nominal/Buildings.Media.Water.d_const,
      capHeaHp_nominal=pla.hp.capHeaHp_nominal,
      capCooHp_nominal=pla.hp.capCooHp_nominal,
      TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
      yPumChiWatPriSet=if pla.cfg.have_chiWat and pla.cfg.typPumChiWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
        then pla.hp.mChiWatHp_flow_nominal/max(pla.hp.mHeaWatHp_flow_nominal, pla.hp.mChiWatHp_flow_nominal) else 1,
      yPumHeaWatPriSet=if pla.cfg.have_chiWat and pla.cfg.typPumChiWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
        then pla.hp.mHeaWatHp_flow_nominal/max(pla.hp.mHeaWatHp_flow_nominal, pla.hp.mChiWatHp_flow_nominal) else 1,
      staEqu={fill(i/pla.cfg.nHp, pla.cfg.nHp) for i in 1:pla.cfg.nHp}))
    "Parameters for heat pump plant"
    annotation (Dialog(group="Plants"),
    Placement(transformation(extent={{-10,0},{10,20}})));

  annotation (
    defaultComponentPrefixes="inner parameter",
    defaultComponentName="datAll",
    Documentation(
      info="<html>
<p>
This class provides the set of sizing and operating parameters for
the whole HVAC system.
It is aimed for validation purposes only.
</p>
</html>"));
end AllSystems;
