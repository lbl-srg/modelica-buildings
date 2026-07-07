within Buildings.Templates.Plants.HeatPumps.Data;
record HeatPumpPlant
  "Record for heat pump plant"
  extends Modelica.Icons.Record;
  // Generic
  parameter Buildings.Templates.Plants.HeatPumps.Configuration.HeatPumpPlant cfg
    "Configuration parameters"
    annotation(Dialog(enable=false));
  parameter String id = ""
    "System tag"
    annotation(Dialog(tab="Advanced"));
  parameter Buildings.Templates.Plants.HeatPumps.Components.Data.Controller ctl(
    final cfg=cfg,
    VChiWatHp_flow_nominal=hp.mChiWatHp_flow_nominal / cfg.rhoChiWat_default,
    VChiWatPhp_flow_nominal=hp.mChiWatPhp_flow_nominal / cfg.rhoChiWat_default,
    VHeaWatHp_flow_nominal=hp.mHeaWatHp_flow_nominal / cfg.rhoHeaWat_default,
    VHeaWatPhp_flow_nominal=hp.mHeaWatPhp_flow_nominal / cfg.rhoHeaWat_default)
    "Controller"
    annotation(Dialog(group="Controls"));
  parameter Buildings.Templates.Plants.HeatPumps.Components.Data.HeatPumpGroup hp(
    final have_hp=cfg.have_hp,
    final have_php=cfg.have_php,
    final typHp=cfg.typHp,
    final is_rev=cfg.is_rev,
    final cpHeaWat_default=cfg.cpHeaWat_default,
    final cpChiWatPhp_default=cfg.cpChiWat_default,
    final cpSou_default=cfg.cpSou_default,
    capCooHp_nominal=ctl.capCooHp_nominal,
    capCooPhp_nominal=ctl.capCooPhp_nominal,
    capCooShcPhp_nominal=ctl.capCooShcPhp_nominal,
    capHeaHp_nominal=ctl.capHeaHp_nominal,
    capHeaPhp_nominal=ctl.capHeaPhp_nominal,
    capHeaShcPhp_nominal=ctl.capHeaShcPhp_nominal,
    TChiWatSupHp_nominal=ctl.TChiWatSup_nominal,
    TChiWatSupPhp_nominal=ctl.TChiWatSup_nominal,
    THeaWatSupHp_nominal=ctl.THeaWatSup_nominal,
    THeaWatSupPhp_nominal=ctl.THeaWatSup_nominal)
    "Nominal conditions and performance data"
    annotation(Dialog(group="Heat pumps and polyvalent units"));
  parameter Modelica.Units.SI.PressureDifference dpBalHeaWatHp_nominal(
    final min=0,
    start=0) = 0
    "HP HW balancing valve pressure drop at design HW flow"
    annotation(Dialog(group="Heat pumps and polyvalent units"));
  parameter Modelica.Units.SI.PressureDifference dpBalChiWatHp_nominal(
    final min=0,
    start=0) = 0
    "HP CHW balancing valve pressure drop at design CHW flow"
    annotation(Dialog(group="Heat pumps and polyvalent units"));
  parameter Modelica.Units.SI.PressureDifference dpBalHeaWatPhp_nominal(
    final min=0,
    start=0) = 0
    "Polyvalent unit HW balancing valve pressure drop at design HW flow"
    annotation(Dialog(group="Heat pumps and polyvalent units"));
  parameter Modelica.Units.SI.PressureDifference dpBalChiWatPhp_nominal(
    final min=0,
    start=0) = 0
    "Polyvalent unit CHW balancing valve pressure drop at design CHW flow"
    annotation(Dialog(group="Heat pumps and polyvalent units"));
  // HW loop
  final parameter Modelica.Units.SI.MassFlowRate mPumHeaWatPriDed_flow_nominal[cfg.nPumHeaWatPri] =
    {if i <= cfg.nHp
      then (if cfg.have_pumChiWatPriDedHp then hp.mHeaWatHp_flow_nominal
        else max(hp.mHeaWatHp_flow_nominal, hp.mChiWatHp_flow_nominal))
      else hp.mHeaWatPhp_flow_nominal for i in 1:cfg.nPumHeaWatPri}
    "Dedicated primary HW pump mass flow rate";
  parameter Buildings.Templates.Components.Data.PumpMultiple pumHeaWatPri(
    final nPum=cfg.nPumHeaWatPri,
    final rho_default=cfg.rhoHeaWat_default,
    final typ=if cfg.typPumHeaWatPri <>
      Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
      then Buildings.Templates.Components.Types.Pump.Multiple
      else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=if cfg.typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      then mPumHeaWatPriDed_flow_nominal
      else fill(
        (cfg.nHp * hp.mHeaWatHp_flow_nominal + cfg.nPhp *
          hp.mHeaWatPhp_flow_nominal) / max(cfg.nPumHeaWatPri, 1),
        cfg.nPumHeaWatPri))
    "Primary HW pumps"
    annotation(Dialog(group="Primary HW loop"));
  final parameter Buildings.Templates.Components.Data.PumpSingle pumHeaWatPriSin[max(
    cfg.nPumHeaWatPri, 1)](
    each typ=pumHeaWatPri.typ,
    m_flow_nominal=if pumHeaWatPri.typ ==
      Buildings.Templates.Components.Types.Pump.None then {0}
      else pumHeaWatPri.m_flow_nominal,
    dp_nominal=if pumHeaWatPri.typ ==
      Buildings.Templates.Components.Types.Pump.None then {0}
      else pumHeaWatPri.dp_nominal,
    per(
      pressure(
        V_flow=if pumHeaWatPri.typ ==
          Buildings.Templates.Components.Types.Pump.None then [0]
          else pumHeaWatPri.per.pressure.V_flow,
        dp=if pumHeaWatPri.typ == Buildings.Templates.Components.Types.Pump.None
          then [0] else pumHeaWatPri.per.pressure.dp)),
    each rho_default=pumHeaWatPri.rho_default)
    "Cast multiple pump record into single pump record array";
  parameter Modelica.Units.SI.PressureDifference dpValCheHeaWat_nominal[cfg.nPumHeaWatPri](
    each start=0) = fill(
    Buildings.Templates.Data.Defaults.dpValChe, cfg.nPumHeaWatPri)
    "Primary (HW or common HW and CHW) pump check valve pressure drop at design flow rate (selection conditions) – Each unit"
    annotation(Dialog(group="Primary HW loop"));
  parameter Buildings.Templates.Components.Data.Valve valHeaWatMinByp(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    m_flow_nominal=if cfg.have_valHeaWatMinByp
      then max(ctl.VHeaWatHp_flow_min, ctl.VHeaWatPhp_flow_min) *
        cfg.rhoHeaWat_default
      else max(hp.mHeaWatHp_flow_nominal, hp.mHeaWatPhp_flow_nominal),
    dpValve_nominal=Buildings.Templates.Data.Defaults.dpValBypMin)
    "HW minimum flow bypass valve"
    annotation(Dialog(group="Primary HW loop",
      enable=cfg.have_valHeaWatMinByp));
  parameter Modelica.Units.SI.Volume VTanHeaWat(start=0) = if cfg.have_heaWat
    then 4 * 60 * (cfg.nHp * hp.mHeaWatHp_flow_nominal + cfg.nPhp *
      hp.mHeaWatPhp_flow_nominal) / cfg.rhoHeaWat_default
    else 0
    "Volume of HW buffer tank"
    annotation(Dialog(group="Primary HW loop",
      enable=cfg.typTanHeaWat <>
        Buildings.Templates.Components.Types.IntegrationPoint.None));
  parameter Buildings.Templates.Components.Data.PumpMultiple pumHeaWatSec(
    final nPum=cfg.nPumHeaWatSec,
    final rho_default=cfg.rhoHeaWat_default,
    final typ=if cfg.typPumHeaWatSec ==
      Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
      then Buildings.Templates.Components.Types.Pump.Multiple
      else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=fill(
      ctl.VHeaWatSec_flow_nominal * cfg.rhoHeaWat_default / max(
        1, cfg.nPumHeaWatSec),
      cfg.nPumHeaWatSec))
    "Secondary HW pumps"
    annotation(Dialog(group="Secondary HW loop",
      enable=cfg.have_heaWat
        and cfg.typPumHeaWatSec ==
          Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized));
  // CHW loop
  final parameter Modelica.Units.SI.MassFlowRate mPumChiWatPriDed_flow_nominal[cfg.nPumChiWatPri] =
    {if i >= cfg.nPumChiWatPri - cfg.nPhp + 1 then hp.mChiWatPhp_flow_nominal
      else hp.mHeaWatHp_flow_nominal for i in 1:cfg.nPumChiWatPri}
    "Dedicated primary CHW pump mass flow rate";
  parameter Buildings.Templates.Components.Data.PumpMultiple pumChiWatPri(
    final nPum=cfg.nPumChiWatPri,
    final rho_default=cfg.rhoChiWat_default,
    final typ=if cfg.typPumChiWatPri <>
      Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
      then Buildings.Templates.Components.Types.Pump.Multiple
      else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=if cfg.typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      then mPumChiWatPriDed_flow_nominal
      else fill(
        (hp.mChiWatHp_flow_nominal * cfg.nHp + hp.mChiWatPhp_flow_nominal *
          cfg.nPhp) / max(cfg.nPumChiWatPri, 1),
        cfg.nPumChiWatPri))
    "Primary CHW pumps"
    annotation(Dialog(group="Primary CHW loop",
      enable=cfg.typPumChiWatPriDedHp <>
        Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
        or cfg.have_php));
  final parameter Buildings.Templates.Components.Data.PumpSingle pumChiWatPriSin[max(
    cfg.nPumChiWatPri, 1)](
    each typ=pumChiWatPri.typ,
    m_flow_nominal=if pumChiWatPri.typ ==
      Buildings.Templates.Components.Types.Pump.None then {0}
      else pumChiWatPri.m_flow_nominal,
    dp_nominal=if pumChiWatPri.typ ==
      Buildings.Templates.Components.Types.Pump.None then {0}
      else pumChiWatPri.dp_nominal,
    per(
      pressure(
        V_flow=if pumChiWatPri.typ ==
          Buildings.Templates.Components.Types.Pump.None then [0]
          else pumChiWatPri.per.pressure.V_flow,
        dp=if pumChiWatPri.typ == Buildings.Templates.Components.Types.Pump.None
          then [0] else pumChiWatPri.per.pressure.dp)),
    each rho_default=pumChiWatPri.rho_default)
    "Cast multiple pump record into single pump record array";
  parameter Modelica.Units.SI.PressureDifference dpValCheChiWat_nominal[cfg.nPumChiWatPri](
    each start=0) = fill(
    Buildings.Templates.Data.Defaults.dpValChe, cfg.nPumChiWatPri)
    "Primary CHW pump check valve pressure drop at design CHW flow rate – Each unit"
    annotation(Dialog(group="Primary CHW loop",
      enable=cfg.typPumChiWatPri <>
        Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None));
  parameter Buildings.Templates.Components.Data.Valve valChiWatMinByp(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    m_flow_nominal=if cfg.have_valChiWatMinByp
      then max(ctl.VChiWatHp_flow_min, ctl.VChiWatPhp_flow_min) *
        cfg.rhoChiWat_default
      else max(hp.mChiWatHp_flow_nominal, hp.mChiWatPhp_flow_nominal),
    dpValve_nominal=Buildings.Templates.Data.Defaults.dpValBypMin)
    "CHW minimum flow bypass valve"
    annotation(Dialog(group="Primary CHW loop",
      enable=cfg.have_valChiWatMinByp));
  parameter Modelica.Units.SI.Volume VTanChiWat(start=0) = if cfg.have_chiWat
    then 2 * 60 * (cfg.nHp * hp.mChiWatHp_flow_nominal + cfg.nPhp *
      hp.mChiWatPhp_flow_nominal) / cfg.rhoChiWat_default
    else 0
    "Volume of HW buffer tank"
    annotation(Dialog(group="Primary CHW loop",
      enable=cfg.typTanChiWat <>
        Buildings.Templates.Components.Types.IntegrationPoint.None));
  parameter Buildings.Templates.Components.Data.PumpMultiple pumChiWatSec(
    final nPum=cfg.nPumChiWatSec,
    final rho_default=cfg.rhoChiWat_default,
    final typ=if cfg.typPumChiWatSec ==
      Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
      then Buildings.Templates.Components.Types.Pump.Multiple
      else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=fill(
      ctl.VChiWatSec_flow_nominal * cfg.rhoChiWat_default / max(
        1, cfg.nPumChiWatSec),
      cfg.nPumChiWatSec))
    "Secondary CHW pumps"
    annotation(Dialog(group="Secondary CHW loop",
      enable=cfg.typPumChiWatSec ==
        Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized));
  // Sidestream HRC
  parameter Buildings.Templates.Components.Data.Chiller hrc(
    typ=if cfg.have_hrc
      then Buildings.Templates.Components.Types.Chiller.WaterCooled
      else Buildings.Templates.Components.Types.Chiller.None,
    TChiWatSup_nominal=ctl.TChiWatSup_nominal)
    "Chiller"
    annotation(Dialog(group="Sidetream heat recovery chiller",
      enable=cfg.have_hrc));
  /*
   * HACK(AntoineGautier):
   * The bindings for per.pressure in the single pump record declarations below
   * are identical to the default bindings in the PumpSingle class definition.
   * They are needed here for Dymola (version 2024x Refresh 1) that fails
   * to evaluate the size of per.pressure.dp otherwise.
   */
  parameter Buildings.Templates.Components.Data.PumpSingle pumChiWatHrc(
    final rho_default=cfg.rhoChiWat_default,
    final typ=if cfg.have_hrc
      then Buildings.Templates.Components.Types.Pump.Single
      else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=hrc.mChiWat_flow_nominal,
    dp_nominal=hrc.dpChiWat_nominal,
    per(
      pressure(
        V_flow=if pumChiWatHrc.typ <>
          Buildings.Templates.Components.Types.Pump.None
          then {0, 1, 2} * pumChiWatHrc.m_flow_nominal / cfg.rhoChiWat_default
          else {0, 0, 0},
        dp=if pumChiWatHrc.typ <> Buildings.Templates.Components.Types.Pump.None
          then {1.14, 1, 0.42} * pumChiWatHrc.dp_nominal else {0, 0, 0})))
    "HRC CHW pump"
    annotation(Dialog(group="Sidetream heat recovery chiller",
      enable=cfg.have_hrc));
  parameter Buildings.Templates.Components.Data.PumpSingle pumHeaWatHrc(
    final rho_default=cfg.rhoHeaWat_default,
    final typ=if cfg.have_hrc
      then Buildings.Templates.Components.Types.Pump.Single
      else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=hrc.mCon_flow_nominal,
    dp_nominal=hrc.dpCon_nominal,
    per(
      pressure(
        V_flow=if pumHeaWatHrc.typ <>
          Buildings.Templates.Components.Types.Pump.None
          then {0, 1, 2} * pumHeaWatHrc.m_flow_nominal / cfg.rhoHeaWat_default
          else {0, 0, 0},
        dp=if pumHeaWatHrc.typ <> Buildings.Templates.Components.Types.Pump.None
          then {1.14, 1, 0.42} * pumHeaWatHrc.dp_nominal else {0, 0, 0})))
    "HRC HW pump"
    annotation(Dialog(group="Sidetream heat recovery chiller",
      enable=cfg.have_hrc));
annotation(defaultComponentName="dat",
  Documentation(
    info="<html>
<p>
  This record provides the set of sizing and operating parameters for the heat
  pump plant models within
  <a href=\"modelica://Buildings.Templates.Plants.HeatPumps\">
    Buildings.Templates.Plants.HeatPumps</a>.
</p>
<p>
  Most of the parameters should be assigned through the sub-record dedicated
  to the controller. All parameters that are also needed to parameterize other
  plant components are propagated from the controller sub-record to the
  corresponding equipment sub-records. Note that those parameter bindings are
  not final so they may be overwritten in case a component is parameterized at
  nominal conditions that differ from the design conditions specified in the
  controller sub-record.
</p>
<p>Only identical heat pumps are currently supported.</p>
<p>
  The heat pump performance data are provided via the subrecords
  <code>hp.perHeaHp</code> and <code>hp.perCooHp</code> for the heating mode
  and the cooling mode, respectively. For the required format of the
  performance data files, please refer to the documentation of the block
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep\">
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep</a>.
</p>
</html>"));
end HeatPumpPlant;
