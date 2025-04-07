within Buildings.Templates.Plants.Boilers.HotWater.Data;
record BoilerPlant "Record for HW plant model"
  extends Modelica.Icons.Record;
  parameter Buildings.Templates.Plants.Boilers.HotWater.Configuration.BoilerPlant cfg
    "Configuration parameters"
    annotation (Dialog(enable=false));
  parameter String id=""
    "System tag"
    annotation (Dialog(tab="Advanced"));
  parameter Buildings.Templates.Plants.Boilers.HotWater.Components.Data.Controller ctl(
    final cfg=cfg)
    "Controller"
    annotation(Dialog(group="Controls"));

  parameter Buildings.Templates.Plants.Boilers.HotWater.Components.Data.BoilerGroup boiCon(
    final nBoi=cfg.nBoiCon,
    final typMod=cfg.typMod,
    capBoi_nominal=ctl.capBoiCon_nominal,
    THeaWatBoiSup_nominal=fill(if cfg.have_boiCon and cfg.have_boiNon then ctl.THeaWatConSup_nominal
     else ctl.THeaWatSup_nominal, cfg.nBoiCon))
    "Condensing boilers"
    annotation(Dialog(group="Boilers", enable=cfg.have_boiCon));

  parameter Buildings.Templates.Plants.Boilers.HotWater.Components.Data.BoilerGroup boiNon(
    final nBoi=cfg.nBoiNon,
    final typMod=cfg.typMod,
    capBoi_nominal=ctl.capBoiNon_nominal,
    THeaWatBoiSup_nominal=fill(ctl.THeaWatSup_nominal, cfg.nBoiNon))
    "Non-condensing boilers"
    annotation(Dialog(group="Boilers", enable=cfg.have_boiNon));

  parameter Buildings.Templates.Components.Data.PumpMultiple pumHeaWatPriCon(
    final nPum=cfg.nPumHeaWatPriCon,
    final rho_default=cfg.rhoHeaWat_default,
    final typ=if cfg.have_boiCon then Buildings.Templates.Components.Types.Pump.Multiple
      else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=fill(if cfg.have_boiCon then sum(boiCon.mHeaWatBoi_flow_nominal) /
      max(cfg.nPumHeaWatPriCon, 1) else 0, cfg.nPumHeaWatPriCon))
    "Primary HW pumps - Condensing boilers"
    annotation(Dialog(group="Primary HW loop", enable=cfg.have_boiCon));
  parameter Buildings.Templates.Components.Data.PumpMultiple pumHeaWatPriNon(
    final nPum=cfg.nPumHeaWatPriNon,
    final rho_default=cfg.rhoHeaWat_default,
    final typ=if cfg.have_boiNon then Buildings.Templates.Components.Types.Pump.Multiple
      else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=fill(if cfg.have_boiNon then sum(boiNon.mHeaWatBoi_flow_nominal) /
      max(cfg.nPumHeaWatPriNon, 1) else 0, cfg.nPumHeaWatPriNon))
    "Primary HW pumps - Non-condensing boilers"
    annotation(Dialog(group="Primary HW loop", enable=have_boiNon));
  parameter Buildings.Templates.Components.Data.Valve valHeaWatMinBypCon(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    m_flow_nominal=
      if cfg.have_valHeaWatMinBypCon then max(ctl.VHeaWatBoiCon_flow_min) * cfg.rhoHeaWat_default
      else 0,
    dpValve_nominal=Buildings.Templates.Data.Defaults.dpValBypMin)
    "HW minimum flow bypass valve - Condensing boilers"
    annotation(Dialog(group="Primary HW loop", enable=cfg.have_valHeaWatMinBypCon));
  parameter Buildings.Templates.Components.Data.Valve valHeaWatMinBypNon(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    m_flow_nominal=
      if cfg.have_valHeaWatMinBypNon then max(ctl.VHeaWatBoiNon_flow_min) * cfg.rhoHeaWat_default
      else 0,
    dpValve_nominal=Buildings.Templates.Data.Defaults.dpValBypMin)
    "HW minimum flow bypass valve - Non-condensing boilers"
    annotation(Dialog(group="Primary HW loop", enable=cfg.have_valHeaWatMinBypNon));

  parameter Buildings.Templates.Components.Data.PumpMultiple pumHeaWatSec(
    final nPum=cfg.nPumHeaWatSec,
    final rho_default=cfg.rhoHeaWat_default,
    final typ=if cfg.typPumHeaWatSec==Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.Centralized
      then Buildings.Templates.Components.Types.Pump.Multiple
      else Buildings.Templates.Components.Types.Pump.None)
    "Secondary HW pumps"
    annotation(Dialog(group="Secondary HW loop",
    enable=cfg.typPumHeaWatSec==Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.Centralized));

  annotation (
  defaultComponentName="dat",
  Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for
the boiler plant model
<a href=\"modelica://Buildings.Templates.Plants.Boilers.HotWater.BoilerPlant\">
Buildings.Templates.Plants.Boilers.HotWater.BoilerPlant</a>.
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

end BoilerPlant;
