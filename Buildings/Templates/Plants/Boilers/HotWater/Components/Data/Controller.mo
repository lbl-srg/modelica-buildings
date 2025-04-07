within Buildings.Templates.Plants.Boilers.HotWater.Components.Data;
record Controller "Record for plant controller"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Plants.Boilers.HotWater.Configuration.BoilerPlant cfg
    "Configuration parameters"
    annotation (Dialog(enable=false));

  parameter Modelica.Units.SI.Temperature THeaWatSup_nominal(
    displayUnit="degC",
    start=Buildings.Templates.Data.Defaults.THeaWatSup,
    final min=273.15)
    "Design (highest) HW supply temperature setpoint"
    annotation(Dialog(group="Temperature setpoints"));
  parameter Modelica.Units.SI.Temperature THeaWatConSup_nominal(
    displayUnit="degC",
    start=Buildings.Templates.Data.Defaults.THeaWatSup,
    final min=273.15)
    "Design (highest) HW supply temperature setpoint for condensing boilers"
    annotation(Dialog(group="Temperature setpoints", enable=cfg.have_boiCon and cfg.have_boiNon));
  parameter Modelica.Units.SI.Temperature TOutLck(
    displayUnit="degC",
    final min=273.15)=Buildings.Templates.Data.Defaults.TOutHeaWatLck
    "Outdoor air lockout temperature above which the plant is prevented from operating"
    annotation(Dialog(group="Temperature setpoints", enable=
    cfg.typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36));

  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatBoiCon_flow_nominal[cfg.nBoiCon](
    start=fill(0.1, cfg.nBoiCon),
    displayUnit=fill("L/s", cfg.nBoiCon),
    final min=fill(0, cfg.nBoiCon))
    "Design HW volume flow rate - Each condensing boiler"
    annotation(Dialog(group="Boiler flow setpoints", enable=
    cfg.typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36 and
    cfg.have_boiCon and cfg.have_valHeaWatMinBypCon));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatBoiCon_flow_min[cfg.nBoiCon](
    start=fill(0.1, cfg.nBoiCon),
    displayUnit=fill("L/s", cfg.nBoiCon),
    final min=fill(0, cfg.nBoiCon))
    "Minimum HW volume flow rate - Each condensing boiler"
    annotation(Dialog(group="Boiler flow setpoints", enable=
    cfg.typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36 and
    cfg.have_boiCon));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatBoiNon_flow_nominal[cfg.nBoiNon](
    start=fill(0.1, cfg.nBoiNon),
    displayUnit=fill("L/s", cfg.nBoiNon),
    final min=fill(0, cfg.nBoiNon))
    "Design HW volume flow rate - Each non-condensing boiler"
    annotation(Dialog(group="Boiler flow setpoints", enable=
    cfg.typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36 and
    cfg.have_boiNon and cfg.have_valHeaWatMinBypNon));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatBoiNon_flow_min[cfg.nBoiNon](
    start=fill(0.1, cfg.nBoiNon),
    displayUnit=fill("L/s", cfg.nBoiNon),
    final min=fill(0, cfg.nBoiNon))
    "Minimum HW volume flow rate - Each non-condensing boiler"
    annotation(Dialog(group="Boiler flow setpoints", enable=
    cfg.typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36 and
    cfg.have_boiNon));
  parameter Real ratFirBoiCon_min[cfg.nBoiCon](
    start=fill(0.2, cfg.nBoiCon),
    final unit=fill("1", cfg.nBoiCon))
    "Boiler minimum firing rate before cycling"
    annotation(Dialog(group="Minimum boiler firing rate", enable=
    cfg.typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36 and
    cfg.have_boiCon));
  parameter Real ratFirBoiNon_min[cfg.nBoiNon](
    start=fill(0.2, cfg.nBoiNon),
    final unit=fill("1", cfg.nBoiNon))
    "Boiler minimum firing rate before cycling"
    annotation(Dialog(group="Minimum boiler firing rate", enable=
    cfg.typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36 and
    cfg.have_boiCon));
  parameter Modelica.Units.SI.HeatFlowRate capBoiCon_nominal[cfg.nBoiCon](
    start=fill(1, cfg.nBoiCon),
    final min=fill(0, cfg.nBoiCon))
    "Design capacity - Each condensing boiler"
    annotation(Dialog(group="Capacity", enable=
    cfg.typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36));
  parameter Modelica.Units.SI.HeatFlowRate capBoiNon_nominal[cfg.nBoiNon](
    start=fill(1, cfg.nBoiNon),
    final min=fill(0, cfg.nBoiNon))
    "Design capacity - Each non-condensing boiler"
    annotation(Dialog(group="Capacity", enable=
    cfg.typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatPriCon_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)
    "Design primary HW volume flow rate - Condensing boilers"
    annotation(Dialog(group="Capacity", enable=
    cfg.typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36 and
    cfg.have_boiCon and
    cfg.typPumHeaWatSec==Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None and
    cfg.have_varPumHeaWatPriCon and
    cfg.typArrPumHeaWatPriCon==Buildings.Templates.Components.Types.PumpArrangement.Headered));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatPriNon_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)
    "Design primary HW volume flow rate - Non-condensing boilers"
    annotation(Dialog(group="Capacity", enable=
    cfg.typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36 and
    cfg.have_boiNon and
    cfg.typPumHeaWatSec==Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None and
    cfg.have_varPumHeaWatPriNon and
    cfg.typArrPumHeaWatPriCon==Buildings.Templates.Components.Types.PumpArrangement.Headered));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatSec_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)
    "Design secondary HW volume flow rate"
    annotation(Dialog(group="Capacity", enable=
    cfg.typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36 and
    cfg.typPumHeaWatSec<>Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None and
    cfg.have_senVHeaWatSec));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatRemSet_max[cfg.nSenDpHeaWatRem](
    start=fill(Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max, cfg.nSenDpHeaWatRem),
    final min=fill(0, cfg.nSenDpHeaWatRem))
    "Design (maximum) HW differential pressure setpoint - Remote sensor"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=
    cfg.typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36 and
    ((cfg.have_varPumHeaWatPriCon or cfg.have_varPumHeaWatPriNon) and
    cfg.typPumHeaWatSec==Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None or
    cfg.typPumHeaWatSec<>Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None)));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatLocSet_max(
    start=Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max,
    final min=0)
    "Design (maximum) HW differential pressure setpoint - Local sensor"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=cfg.typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36 and
    cfg.have_senDpHeaWatLoc));
  parameter Real yPumHeaWatPri_min(
    final unit="1",
    final min=0,
    final max=1)=0.1
    "Primary HW pump minimum speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=cfg.typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36 and
    (cfg.have_varPumHeaWatPriCon or cfg.have_varPumHeaWatPriNon) and
    cfg.typPumHeaWatSec==Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None));
  parameter Real yPumHeaWatSec_min(
    final unit="1",
    final min=0,
    final max=1)=0.1
    "Secondary HW pump minimum speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=cfg.typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36 and
    cfg.typPumHeaWatSec<>Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None));
  parameter Real yPumHeaWatPriSta_min[nSta](
    each final unit="1",
    each final min=0,
    each final max=1,
    each start=0.3)
    "Primary HW pump speed delivering minimum flow through boilers - Each plant stage"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=cfg.typ==Buildings.Templates.Plants.Boilers.HotWater.Types.Controller.Guideline36 and
    (cfg.have_varPumHeaWatPriCon or cfg.have_varPumHeaWatPriNon) and
    cfg.typPumHeaWatSec<>Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None));
  parameter Integer sta[:, cfg.nBoiCon + cfg.nBoiNon](
    each final min=0,
    each final max=1)
    "Staging matrix with plant stage as row index and boiler as column index (starting with condensing boilers): 0 for disabled, 1 for enabled"
    annotation (Dialog(group="Plant staging"));
  final parameter Integer nSta(start=1) = size(sta, 1)
    "Number of plant stages"
    annotation (Evaluate=true, Dialog(group="Plant staging"));
  annotation (
  defaultComponentName="datCtl",
  Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for
HW plant controllers that can be found within
<a href=\"modelica://Buildings.Templates.Plants.Boilers.HotWater.Components.Controls\">
Buildings.Templates.Plants.Boilers.HotWater.Components.Controls</a>.
</p>
<p>
For hybrid plants, units shall be indexed so that condensing boilers have the
lowest indices and non-condensing boilers have the highest indices.
</p>
</html>"));
end Controller;
