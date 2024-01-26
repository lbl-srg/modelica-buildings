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
  // RFE: Support unequally sized units with array instance.
  parameter Buildings.Templates.Components.Data.HeatPump heaPum(
    final cpHeaWat_default=cfg.cpHeaWat_default,
    final cpChiWat_default=cfg.cpChiWat_default)
    "Heat pump characteritics - Single unit"
    annotation (Dialog(group="Heat pumps"));
  // HW loop
  parameter Buildings.Templates.Components.Data.PumpMultiple pumHeaWatPri(
    final nPum=cfg.nPumHeaWatPri,
    final rho_default=cfg.rhoHeaWat_default,
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    m_flow_nominal=fill(sum(heaPum.mHeaWat_flow_nominal) / max(cfg.nPumHeaWatPri, 1), cfg.nPumHeaWatPri))
    "Primary HW pumps"
    annotation (Dialog(group="Primary HW loop",
      enable=cfg.have_heaWat));
  parameter Buildings.Templates.Components.Data.Valve valHeaWatMinByp(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    m_flow_nominal=if cfg.have_valHeaWatMinByp then max(ctl.VHeaWatHeaPum_flow_min) * cfg.rhoHeaWat_default
      else 0,
    dpValve_nominal=Buildings.Templates.Data.Defaults.dpValBypMin)
    "HW minimum flow bypass valve"
    annotation (Dialog(group="Primary HW loop",
      enable=cfg.have_heaWat and cfg.have_valHeaWatMinByp));
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
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    m_flow_nominal=fill(sum(heaPum.mChiWat_flow_nominal) / max(cfg.nPumChiWatPri, 1), cfg.nPumChiWatPri))
    "Primary CHW pumps"
    annotation (Dialog(group="Primary CHW loop",
      enable=cfg.have_chiWat));
  parameter Buildings.Templates.Components.Data.Valve valChiWatMinByp(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    m_flow_nominal=if cfg.have_valChiWatMinByp then max(ctl.VChiWatHeaPum_flow_min) * cfg.rhoChiWat_default
      else 0,
    dpValve_nominal=Buildings.Templates.Data.Defaults.dpValBypMin)
    "CHW minimum flow bypass valve"
    annotation (Dialog(group="Primary CHW loop",
      enable=cfg.have_chiWat));
  parameter Buildings.Templates.Components.Data.PumpMultiple pumChiWatSec(
    final nPum=cfg.nPumChiWatSec,
    final rho_default=cfg.rhoChiWat_default,
    final typ=if cfg.typPumChiWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
      then Buildings.Templates.Components.Types.Pump.Multiple else Buildings.Templates.Components.Types.Pump.None)
    "Secondary CHW pumps"
    annotation (Dialog(group="Secondary CHW loop",
      enable=cfg.have_chiWat and cfg.typPumChiWatSec==Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized));
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
