within Buildings.Templates.Plants.HeatPumps.Data;
record HeatPumpPlant
  "Record for heat pump plant"
  extends Modelica.Icons.Record;
  // Generic
  parameter Buildings.Templates.Plants.HeatPumps.Configuration.HeatPumpPlant cfg
    "Configuration parameters"
    annotation (Dialog(enable=false));
  parameter String id=""
    "System tag"
    annotation (Dialog(tab="Advanced"));
  parameter Buildings.Templates.Plants.HeatPumps.Components.Data.Controller ctl(
    final cfg=cfg)
    "Controller"
    annotation (Dialog(group="Controls"));
  parameter Buildings.Templates.Plants.HeatPumps.Components.Data.HeatPumpGroup
    hp(
    final typ=cfg.typ,
    final nHp=cfg.nHp,
    final is_rev=cfg.is_rev,
    final typMod=cfg.typMod,
    final cpHeaWat_default=cfg.cpHeaWat_default,
    final cpSou_default=cfg.cpSou_default,
    TChiWatSupHp_nominal=ctl.TChiWatSup_nominal,
    capCooHp_nominal=ctl.capCooHp_nominal,
    mHeaWatHp_flow_nominal=ctl.VHeaWatHp_flow_nominal*cfg.rhoHeaWat_default,
    capHeaHp_nominal=ctl.capHeaHp_nominal,
    mChiWatHp_flow_nominal=ctl.VChiWatHp_flow_nominal*cfg.rhoChiWat_default,
    THeaWatSupHp_nominal=ctl.THeaWatSup_nominal)
    "Heat pumps"
    annotation (Dialog(group="Heat pumps"));
  parameter Modelica.Units.SI.PressureDifference dpBalHeaWatHp_nominal(start=0)=0
    "HP HW balancing valve pressure drop at design HW flow"
    annotation (Dialog(group="Heat pumps",
      enable=cfg.typPumHeaWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant));
  parameter Modelica.Units.SI.PressureDifference dpBalChiWatHp_nominal(start=0)=0
    "HP CHW balancing valve pressure drop at design CHW flow"
    annotation (Dialog(group="Heat pumps",
      enable=cfg.typPumChiWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant));
  // HW loop
  parameter Buildings.Templates.Components.Data.PumpMultiple pumHeaWatPri(
    final nPum=cfg.nPumHeaWatPri,
    final rho_default=cfg.rhoHeaWat_default,
    final typ=if cfg.typPumHeaWatPri <> Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
      then Buildings.Templates.Components.Types.Pump.Multiple else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=fill(hp.nHp * (
      if cfg.have_chiWat and cfg.typPumChiWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None then
        max(hp.mHeaWatHp_flow_nominal, hp.mChiWatHp_flow_nominal) else hp.mHeaWatHp_flow_nominal) /
        max(cfg.nPumHeaWatPri, 1),
      cfg.nPumHeaWatPri))
    "Primary HW pumps"
    annotation (Dialog(group="Primary HW loop"));
  final parameter Buildings.Templates.Components.Data.PumpSingle pumHeaWatPriSin[max(cfg.nPumHeaWatPri, 1)](
    each typ=pumHeaWatPri.typ,
    m_flow_nominal=if pumHeaWatPri.typ == Buildings.Templates.Components.Types.Pump.None
      then {0} else pumHeaWatPri.m_flow_nominal,
    dp_nominal=if pumHeaWatPri.typ == Buildings.Templates.Components.Types.Pump.None
      then {0} else pumHeaWatPri.dp_nominal,
    per(
      pressure(
        V_flow=if pumHeaWatPri.typ == Buildings.Templates.Components.Types.Pump.None
          then [0] else pumHeaWatPri.per.pressure.V_flow,
        dp=if pumHeaWatPri.typ == Buildings.Templates.Components.Types.Pump.None
          then [0] else pumHeaWatPri.per.pressure.dp)),
    each rho_default=pumHeaWatPri.rho_default)
    "Cast multiple pump record into single pump record array";
  parameter Modelica.Units.SI.PressureDifference dpValCheHeaWat_nominal(start=0)=
    Buildings.Templates.Data.Defaults.dpValChe
    "Primary (HW or common HW and CHW) pump check valve pressure drop at design flow rate (selection conditions)"
    annotation(Dialog(group="Primary HW loop"));
  parameter Buildings.Templates.Components.Data.Valve valHeaWatMinByp(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    m_flow_nominal=
      if cfg.have_valHeaWatMinByp then ctl.VHeaWatHp_flow_min * cfg.rhoHeaWat_default
      else 0,
    dpValve_nominal=Buildings.Templates.Data.Defaults.dpValBypMin)
    "HW minimum flow bypass valve"
    annotation(Dialog(group="Primary HW loop", enable=cfg.have_valHeaWatMinByp));
  parameter Modelica.Units.SI.Volume VTanHeaWat(start=0)=
    if cfg.have_heaWat then 240 * cfg.nHp * hp.mHeaWatHp_flow_nominal / cfg.rhoHeaWat_default
    else 0
    "Volume of HW buffer tank"
    annotation (Dialog(group="Primary HW loop",
    enable=cfg.typTanHeaWat<>Buildings.Templates.Components.Types.IntegrationPoint.None));
  parameter Buildings.Templates.Components.Data.PumpMultiple pumHeaWatSec(
    final nPum=cfg.nPumHeaWatSec,
    final rho_default=cfg.rhoHeaWat_default,
    final typ=if cfg.typPumHeaWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
      then Buildings.Templates.Components.Types.Pump.Multiple else Buildings.Templates.Components.Types.Pump.None)
    "Secondary HW pumps"
    annotation (Dialog(group="Secondary HW loop",
      enable=cfg.have_heaWat and cfg.typPumHeaWatSec==Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized));
  // CHW loop
  parameter Buildings.Templates.Components.Data.PumpMultiple pumChiWatPri(
    final nPum=cfg.nPumChiWatPri,
    final rho_default=cfg.rhoChiWat_default,
    final typ=if cfg.typPumChiWatPri <> Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
      then Buildings.Templates.Components.Types.Pump.Multiple else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=fill(hp.mChiWatHp_flow_nominal * hp.nHp / max(cfg.nPumChiWatPri, 1), cfg.nPumChiWatPri))
    "Primary CHW pumps"
    annotation (Dialog(group="Primary CHW loop",
      enable=cfg.typPumChiWatPri<>Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None));
  final parameter Buildings.Templates.Components.Data.PumpSingle pumChiWatPriSin[max(cfg.nPumChiWatPri, 1)](
    each typ=pumChiWatPri.typ,
    m_flow_nominal=if pumChiWatPri.typ == Buildings.Templates.Components.Types.Pump.None
      then {0} else pumChiWatPri.m_flow_nominal,
    dp_nominal=if pumChiWatPri.typ == Buildings.Templates.Components.Types.Pump.None
      then {0} else pumChiWatPri.dp_nominal,
    per(
      pressure(
        V_flow=if pumChiWatPri.typ == Buildings.Templates.Components.Types.Pump.None
          then [0] else pumChiWatPri.per.pressure.V_flow,
        dp=if pumChiWatPri.typ == Buildings.Templates.Components.Types.Pump.None
          then [0] else pumChiWatPri.per.pressure.dp)),
    each rho_default=pumChiWatPri.rho_default)
    "Cast multiple pump record into single pump record array";
  parameter Modelica.Units.SI.PressureDifference dpValCheChiWat_nominal(start=0)=
    Buildings.Templates.Data.Defaults.dpValChe
    "Primary CHW pump check valve pressure drop at design CHW flow rate"
    annotation(Dialog(group="Primary CHW loop",
      enable=cfg.typPumChiWatPri<>Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None));
  parameter Buildings.Templates.Components.Data.Valve valChiWatMinByp(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    m_flow_nominal=
      if cfg.have_valChiWatMinByp then ctl.VChiWatHp_flow_min * cfg.rhoChiWat_default
      else 0,
    dpValve_nominal=Buildings.Templates.Data.Defaults.dpValBypMin)
    "CHW minimum flow bypass valve"
    annotation(Dialog(group="Primary CHW loop", enable=cfg.have_valChiWatMinByp));
  parameter Modelica.Units.SI.Volume VTanChiWat(start=0)=
    if cfg.have_chiWat then 120 * cfg.nHp * hp.mChiWatHp_flow_nominal / cfg.rhoChiWat_default
    else 0
    "Volume of HW buffer tank"
    annotation (Dialog(group="Primary CHW loop",
    enable=cfg.typTanChiWat<>Buildings.Templates.Components.Types.IntegrationPoint.None));
  parameter Buildings.Templates.Components.Data.PumpMultiple pumChiWatSec(
    final nPum=cfg.nPumChiWatSec,
    final rho_default=cfg.rhoChiWat_default,
    final typ=if cfg.typPumChiWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
      then Buildings.Templates.Components.Types.Pump.Multiple else Buildings.Templates.Components.Types.Pump.None)
    "Secondary CHW pumps"
    annotation (Dialog(group="Secondary CHW loop",
      enable=cfg.typPumChiWatSec==Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized));
  // Sidestream HRC
  parameter Buildings.Templates.Components.Data.Chiller hrc(
    typ=if cfg.have_hrc then Buildings.Templates.Components.Types.Chiller.WaterCooled
      else Buildings.Templates.Components.Types.Chiller.None,
    cpChiWat_default=cfg.cpChiWat_default,
    cpCon_default=cfg.cpHeaWat_default,
    COP_nominal=ctl.COPHeaHrc_nominal - 1,
    TChiWatSup_nominal=ctl.TChiWatSup_nominal,
    TChiWatSup_min=ctl.TChiWatSupHrc_min,
    TConEnt_nominal=if cfg.have_hrc then
      hrc.TConLvg_nominal - hrc.QCon_flow_nominal / hrc.mCon_flow_nominal / hrc.cpCon_default
      else 273.15,
    TConLvg_nominal=ctl.THeaWatSup_nominal,
    TConLvg_max=ctl.THeaWatSupHrc_max,
    PLR_min=abs(ctl.capCooHrc_min / hrc.cap_nominal))
    "Chiller"
    annotation (Dialog(group="Sidetream heat recovery chiller", enable=cfg.have_hrc));
  /* HACK(AntoineGautier):
  The bindings for per.pressure in the single pump record declarations below
  are identical to the default bindings in the PumpSingle class definition.
  However, they are needed for Dymola (version 2024x Refresh 1) that fails
  to evaluate the size of per.pressure.dp otherwise.
  */
  parameter Buildings.Templates.Components.Data.PumpSingle pumChiWatHrc(
    final rho_default=cfg.rhoChiWat_default,
    final typ=if cfg.have_hrc then Buildings.Templates.Components.Types.Pump.Single
      else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=hrc.mChiWat_flow_nominal,
    dp_nominal=hrc.dpChiWat_nominal,
    per(pressure(
      V_flow=if pumChiWatHrc.typ<>Buildings.Templates.Components.Types.Pump.None then
      {0, 1, 2} * pumChiWatHrc.m_flow_nominal / cfg.rhoChiWat_default else {0,0,0},
      dp=if pumChiWatHrc.typ<>Buildings.Templates.Components.Types.Pump.None then
      {1.14, 1, 0.42} * pumChiWatHrc.dp_nominal else {0,0,0})))
    annotation (Dialog(group="Sidetream heat recovery chiller", enable=cfg.have_hrc));
  parameter Buildings.Templates.Components.Data.PumpSingle pumHeaWatHrc(
    final rho_default=cfg.rhoHeaWat_default,
    final typ=if cfg.have_hrc then Buildings.Templates.Components.Types.Pump.Single
      else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=hrc.mCon_flow_nominal,
    dp_nominal=hrc.dpCon_nominal,
    per(pressure(
      V_flow=if pumHeaWatHrc.typ<>Buildings.Templates.Components.Types.Pump.None then
      {0, 1, 2} * pumHeaWatHrc.m_flow_nominal / cfg.rhoHeaWat_default else {0,0,0},
      dp=if pumHeaWatHrc.typ<>Buildings.Templates.Components.Types.Pump.None then
      {1.14, 1, 0.42} * pumHeaWatHrc.dp_nominal else {0,0,0})))
    "HRC HW pump"
    annotation (Dialog(group="Sidetream heat recovery chiller", enable=cfg.have_hrc));
  annotation (
    defaultComponentName="dat",
    Documentation(
      info="<html>
<p>
This record provides the set of sizing and operating parameters for
the heat pump plant models within
<a href=\"modelica://Buildings.Templates.Plants.HeatPumps\">
Buildings.Templates.Plants.HeatPumps</a>.
</p>
<p>
Most of the parameters should be assigned through the sub-record
dedicated to the controller.
All parameters that are also needed to parameterize other plant
components are propagated from the controller sub-record
to the corresponding equipment sub-records.
Note that those parameter bindings are not final so they may be
overwritten in case a component is parameterized at nominal
conditions that differ from the design conditions specified
in the controller sub-record.
</p>
</html>"));


end HeatPumpPlant;
