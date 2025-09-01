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
      mHeaWatHp_flow_nominal=pla.hp.capHeaHp_nominal / abs(pla.ctl.THeaWatSup_nominal -
        Buildings.Templates.Data.Defaults.THeaWatRetMed) / Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      mChiWatHp_flow_nominal=pla.hp.capCooHp_nominal / abs(pla.ctl.TChiWatSup_nominal -
        Buildings.Templates.Data.Defaults.TChiWatRet) / Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      dpHeaWatHp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
      TSouHeaHp_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
      TSouCooHp_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
      perHeaHp(
        fileName=Modelica.Utilities.Files.loadResource(
          "modelica://Buildings/Resources/Data/Templates/Components/HeatPumps/Validation/AWHP_Heating.txt"),
        PLRSup={1},
        use_TEvaOutForTab=false,
        use_TConOutForTab=true,
        tabUppBou=[263.15,325.15; 313.15,325.15]),
      perCooHp(
        fileName=Modelica.Utilities.Files.loadResource(
          "modelica://Buildings/Resources/Data/Templates/Components/HeatPumps/Validation/AWHP_Cooling.txt"),
        PLRSup={1},
        use_TEvaOutForTab=true,
        use_TConOutForTab=false),
      PHp_min=1.0E3),
    pumHeaWatPri(
      dp_nominal=fill(1.5 *(if pla.cfg.have_chiWat and pla.cfg.typPumChiWatPri ==
        Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None then max(pla.hp.dpHeaWatHp_nominal, pla.hp.dpChiWatHp_nominal)
        else pla.hp.dpHeaWatHp_nominal), pla.cfg.nPumHeaWatPri) .+(if pla.cfg.typDis ==
        Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
        then Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max else 0)),
    pumHeaWatSec(
      m_flow_nominal=fill(pla.ctl.VHeaWatSec_flow_nominal * Buildings.Media.Water.d_const /
        max(1, pla.cfg.nPumHeaWatSec), pla.cfg.nPumHeaWatSec),
      dp_nominal=fill(Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max, pla.cfg.nPumHeaWatSec)),
    pumChiWatPri(
      dp_nominal=fill(1.5 * pla.hp.dpChiWatHp_nominal, pla.cfg.nPumChiWatPri) .+
        (if pla.cfg.typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
        then Buildings.Templates.Data.Defaults.dpChiWatLocSet_max else 0)),
    pumChiWatSec(
      m_flow_nominal=fill(pla.ctl.VChiWatSec_flow_nominal * Buildings.Media.Water.d_const /
        max(1, pla.cfg.nPumChiWatSec), pla.cfg.nPumChiWatSec),
      dp_nominal=fill(Buildings.Templates.Data.Defaults.dpChiWatLocSet_max, pla.cfg.nPumChiWatSec)),
    hrc(
      cap_nominal=500E3,
      dpChiWat_nominal=Buildings.Templates.Data.Defaults.dpChiWatChi,
      dpCon_nominal=Buildings.Templates.Data.Defaults.dpConWatChi,
      mChiWat_flow_nominal=pla.hrc.cap_nominal / abs(pla.ctl.TChiWatSup_nominal -
        Buildings.Templates.Data.Defaults.TChiWatRet) / Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      mCon_flow_nominal=pla.hrc.cap_nominal * (1 + 1 / (pla.ctl.COPHeaHrc_nominal -1)) /
        abs(pla.ctl.THeaWatSup_nominal - Buildings.Templates.Data.Defaults.THeaWatRetMed) /
        Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
      TCon_nominal=pla.ctl.THeaWatSup_nominal,
      per(
      fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/Examples/TableData2DLoadDep_Chiller.txt"),
        PLRSup={0.45,0.5,0.55,0.6,0.65,0.7,0.75,0.8,0.9,1.0},
        PLRCyc_min=0.2,
        P_min=50,
        use_TEvaOutForTab=true,
        use_TConOutForTab=true)),
    ctl(
      THeaWatSupSet_min=298.15,
      VHeaWatSec_flow_nominal=pla.cfg.nHp*pla.ctl.VHeaWatHp_flow_nominal/1.1,
      TChiWatSupSet_max=288.15,
      VChiWatSec_flow_nominal=pla.cfg.nHp*pla.ctl.VChiWatHp_flow_nominal/1.1,
      dpChiWatRemSet_max={Buildings.Templates.Data.Defaults.dpChiWatRemSet_max},
      dpHeaWatRemSet_max={Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max},
      dpChiWatLocSet_max=Buildings.Templates.Data.Defaults.dpChiWatLocSet_max,
      dpHeaWatLocSet_max=Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max,
      THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSupMed,
      TOutChiWatLck=273.15,
      TOutHeaWatLck=Buildings.Templates.Data.Defaults.TOutHeaWatLck,
      VHeaWatHp_flow_nominal=pla.hp.mHeaWatHp_flow_nominal/Buildings.Media.Water.d_const,
      VChiWatHp_flow_nominal=pla.hp.mChiWatHp_flow_nominal/Buildings.Media.Water.d_const,
      capHeaHp_nominal=pla.hp.capHeaHp_nominal,
      capCooHp_nominal=pla.hp.capCooHp_nominal,
      TChiWatSup_nominal=Buildings.Templates.Data.Defaults.TChiWatSup,
      yPumChiWatPriSet=if pla.cfg.have_chiWat and pla.cfg.typPumChiWatPri ==
          Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None then pla.hp.mChiWatHp_flow_nominal
          /max(pla.hp.mHeaWatHp_flow_nominal, pla.hp.mChiWatHp_flow_nominal)
           else 1,
      yPumHeaWatPriSet=if pla.cfg.have_chiWat and pla.cfg.typPumChiWatPri ==
          Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None then pla.hp.mHeaWatHp_flow_nominal
          /max(pla.hp.mHeaWatHp_flow_nominal, pla.hp.mChiWatHp_flow_nominal)
           else 1,
      staEqu={fill(i/pla.cfg.nHp, pla.cfg.nHp) for i in 1:pla.cfg.nHp},
      TChiWatSupHrc_min=Buildings.Templates.Data.Defaults.TChiWatSup_min,
      THeaWatSupHrc_max=pla.ctl.THeaWatSup_nominal + 5,
      COPHeaHrc_nominal=4.6,
      capCooHrc_min=pla.hrc.cap_nominal*pla.hrc.per.PLRCyc_min,
      capHeaHrc_min=(1 + 1 / (pla.ctl.COPHeaHrc_nominal -1))*pla.ctl.capCooHrc_min))
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
