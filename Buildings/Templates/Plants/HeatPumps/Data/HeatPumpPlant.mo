within Buildings.Templates.Plants.HeatPumps.Data;
record HeatPumpPlant "Record for heat pump plant"
  extends Modelica.Icons.Record;

  parameter
    Buildings.Templates.Plants.HeatPumps.Configuration.HeatPumpPlant cfg
    "Configuration parameters"
    annotation (Dialog(enable=false));

  parameter String id=""
    "System tag"
    annotation (Dialog(tab="Advanced"));

  parameter Modelica.Units.SI.Density rho_default=
    Modelica.Media.Water.ConstantPropertyLiquidWater.d_const
    "HW default density"
    annotation(Dialog(enable=false));

  parameter Buildings.Templates.Plants.HeatPumps.Components.Data.Controller ctl(
    final typ=cfg.typCtl,
    final nHeaPum=cfg.nHeaPum,
    final typPumHeaWatSec=cfg.typPumHeaWatSec,
    final nPumHeaWatPri=cfg.nPumHeaWatPri,
    final nPumHeaWatSec=cfg.nPumHeaWatSec,
    final have_valHeaWatMinByp=cfg.have_valHeaWatMinByp,
    final have_senDpHeaWatLoc=cfg.have_senDpHeaWatLoc,
    final nSenDpHeaWatRem=cfg.nSenDpHeaWatRem,
    final have_senVHeaWatSec=cfg.have_senVHeaWatSec,
    final typArrPumHeaWatPri=cfg.typArrPumHeaWatPri,
    final typDisHeaWat=cfg.typDisHeaWat)
    "Controller"
    annotation(Dialog(group="Controls"));

  parameter Buildings.Templates.Components.Data.HeatPump heaPum
    "Heat pump characteritics - Single unit"
    annotation (Dialog(group="Heat pumps"));

  parameter Buildings.Templates.Components.Data.PumpMultiple pumHeaWatPri(
    final nPum=cfg.nPumHeaWatPri,
    final rho_default=rho_default,
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    m_flow_nominal=fill(sum(heaPum.mHeaWat_flow_nominal) / max(cfg.nPumHeaWatPri, 1),
      cfg.nPumHeaWatPri))
    "Primary HW pumps"
    annotation(Dialog(group="Primary HW loop"));
  parameter Buildings.Templates.Components.Data.Valve valHeaWatMinByp(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    m_flow_nominal=
      if cfg.have_valHeaWatMinByp then max(ctl.VHeaWatHeaPum_flow_min) * rho_default
      else 0,
    dpValve_nominal=Buildings.Templates.Data.Defaults.dpValBypMin)
    "HW minimum flow bypass valve"
    annotation(Dialog(group="Primary HW loop"));

  parameter Buildings.Templates.Components.Data.PumpMultiple pumHeaWatSec(
    final nPum=cfg.nPumHeaWatSec,
    final rho_default=rho_default,
    final typ=if cfg.typPumHeaWatSec==Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
      then Buildings.Templates.Components.Types.Pump.Multiple
      else Buildings.Templates.Components.Types.Pump.None)
    "Secondary HW pumps"
    annotation(Dialog(group="Secondary HW loop",
    enable=cfg.typPumHeaWatSec==Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized));

  annotation (
  defaultComponentName="dat",
  Documentation(info="<html>
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
