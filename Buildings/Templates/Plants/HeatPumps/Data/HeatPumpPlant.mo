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
  // HW loop
  parameter Buildings.Templates.Components.Data.PumpMultiple pumHeaWatPri(
    final nPum=cfg.nPumHeaWatPri,
    final rho_default=cfg.rhoHeaWat_default,
    final typ=if cfg.typPumHeaWatPri <> Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
      then Buildings.Templates.Components.Types.Pump.Multiple else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=fill(hp.mHeaWatHp_flow_nominal * hp.nHp / max(cfg.nPumHeaWatPri, 1), cfg.nPumHeaWatPri))
    "Primary HW pumps"
    annotation (Dialog(group="Primary HW loop",
      enable=cfg.have_heaWat));
  final parameter Buildings.Templates.Components.Data.PumpSingle pumHeaWatPriSin[max(pumHeaWatPri.nPum, 1)](
    each typ=pumHeaWatPri.typ,
    m_flow_nominal=if pumHeaWatPri.typ == Buildings.Templates.Components.Types.Pump.None
      then {0} else pumHeaWatPri.m_flow_nominal,
    dp_nominal=if pumHeaWatPri.typ == Buildings.Templates.Components.Types.Pump.None
      then {0} else pumHeaWatPri.dp_nominal,
    per(
      pressure(
        V_flow=if pumHeaWatPri.typ == Buildings.Templates.Components.Types.Pump.None
          then
              [0] else pumHeaWatPri.per.pressure.V_flow,
        dp=if pumHeaWatPri.typ == Buildings.Templates.Components.Types.Pump.None
          then
              [0] else pumHeaWatPri.per.pressure.dp)),
    each rho_default=pumHeaWatPri.rho_default)
    "Cast multiple pump record into single pump record array";
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
      enable=cfg.typPumChiWatPri<>Buildings.Templates.Components.Types.None));
  final parameter Buildings.Templates.Components.Data.PumpSingle pumChiWatPriSin[max(pumChiWatPri.nPum, 1)](
    each typ=pumChiWatPri.typ,
    m_flow_nominal=if pumChiWatPri.typ == Buildings.Templates.Components.Types.Pump.None
      then {0} else pumChiWatPri.m_flow_nominal,
    dp_nominal=if pumChiWatPri.typ == Buildings.Templates.Components.Types.Pump.None
      then {0} else pumChiWatPri.dp_nominal,
    per(
      pressure(
        V_flow=if pumChiWatPri.typ == Buildings.Templates.Components.Types.Pump.None
          then
              [
          0] else pumChiWatPri.per.pressure.V_flow,
        dp=if pumChiWatPri.typ == Buildings.Templates.Components.Types.Pump.None
          then
              [
          0] else pumChiWatPri.per.pressure.dp)),
    each rho_default=pumChiWatPri.rho_default)
    "Cast multiple pump record into single pump record array";
  parameter Buildings.Templates.Components.Data.PumpMultiple pumChiWatSec(
    final nPum=cfg.nPumChiWatSec,
    final rho_default=cfg.rhoChiWat_default,
    final typ=if cfg.typPumChiWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
      then Buildings.Templates.Components.Types.Pump.Multiple else Buildings.Templates.Components.Types.Pump.None)
    "Secondary CHW pumps"
    annotation (Dialog(group="Secondary CHW loop",
      enable=cfg.typPumChiWatSec==Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized));
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
