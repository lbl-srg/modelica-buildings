within Buildings.Templates.Plants.HeatPumps.Components.Data;
record Controller "Record for plant controller"
  extends Modelica.Icons.Record;

  // Generic
  parameter Buildings.Templates.Plants.HeatPumps.Configuration.HeatPumpPlant cfg
    "Configuration parameters";
  parameter Real PLRHeaPum_min[cfg.nHeaPum](
    start=fill(0.5, cfg.nHeaPum),
    final unit=fill("1", cfg.nHeaPum))
    "Heat pump minimum part load ratio"
    annotation(Dialog(group="Capacity", enable=cfg.have_heaWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop));

  // HW loop
  parameter Modelica.Units.SI.Temperature THeaWatSup_nominal(
    displayUnit="degC",
    start=Buildings.Templates.Data.Defaults.THeaWatSup,
    final min=273.15)
    "Design (highest) HW supply temperature setpoint"
    annotation(Dialog(group="Temperature setpoints", enable=cfg.have_heaWat));
  parameter Modelica.Units.SI.Temperature TOutHeaWatLck(
    displayUnit="degC",
    final min=273.15)=Buildings.Templates.Data.Defaults.TOutHeaWatLck
    "Outdoor air lockout temperature above which the HW loop is prevented from operating"
    annotation(Dialog(group="Temperature setpoints", enable=cfg.have_heaWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatHeaPum_flow_nominal[cfg.nHeaPum](
    start=fill(0.1, cfg.nHeaPum),
    displayUnit=fill("L/s", cfg.nHeaPum),
    final min=fill(0, cfg.nHeaPum))
    "Design HW volume flow rate - Each heat pump"
    annotation(Dialog(group="Heat pump flow setpoints", enable=cfg.have_heaWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    cfg.have_valHeaWatMinByp));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatHeaPum_flow_min[cfg.nHeaPum](
    start=fill(0.1, cfg.nHeaPum),
    displayUnit=fill("L/s", cfg.nHeaPum),
    final min=fill(0, cfg.nHeaPum))
    "Minimum HW volume flow rate - Each heat pump"
    annotation(Dialog(group="Heat pump flow setpoints", enable=cfg.have_heaWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop));
  parameter Modelica.Units.SI.HeatFlowRate capHeaHeaPum_nominal[cfg.nHeaPum](
    start=fill(1, cfg.nHeaPum),
    final min=fill(0, cfg.nHeaPum))
    "Design heating capacity - Each heat pump"
    annotation(Dialog(group="Capacity", enable=cfg.have_heaWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatPri_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)
    "Design primary HW volume flow rate - Total"
    annotation(Dialog(group="Capacity", enable=cfg.have_heaWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    cfg.typDisHeaWat==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only and
    cfg.typArrPumHeaWatPri==Buildings.Templates.Components.Types.PumpArrangement.Headered));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatSec_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)
    "Design secondary HW volume flow rate"
    annotation(Dialog(group="Capacity", enable=cfg.have_heaWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    cfg.typPumHeaWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None and
    cfg.have_senVHeaWatSec));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatRemSet_nominal[cfg.nSenDpHeaWatRem](
    start=fill(Buildings.Templates.Data.Defaults.dpHeaWatSet_max, cfg.nSenDpHeaWatRem),
    final min=fill(0, cfg.nSenDpHeaWatRem))
    "Design (maximum) HW differential pressure setpoint - Remote sensor"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=cfg.have_heaWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    (cfg.typDisHeaWat==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only or
    cfg.typPumHeaWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None)));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatLocSet_nominal(
    start=Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max,
    final min=0)
    "Design (maximum) HW differential pressure setpoint - Local sensor"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=cfg.have_heaWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    cfg.have_senDpHeaWatLoc));
  parameter Real yPumHeaWatPri_min(
    final unit="1",
    final min=0,
    final max=1)=0.1
    "Primary HW pump minimum speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=cfg.have_heaWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    cfg.typDisHeaWat==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only));
  parameter Real yPumHeaWatSec_min(
    final unit="1",
    final min=0,
    final max=1)=0.1
    "Secondary HW pump minimum speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=cfg.have_heaWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    cfg.typPumHeaWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None));

  // CHW loop
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal(
    displayUnit="degC",
    start=Buildings.Templates.Data.Defaults.TChiWatSup,
    final min=273.15)
    "Design (highest) CHW supply temperature setpoint"
    annotation(Dialog(group="Temperature setpoints", enable=cfg.have_chiWat));
  parameter Modelica.Units.SI.Temperature TOutChiWatLck(
    displayUnit="degC",
    final min=273.15)=Buildings.Templates.Data.Defaults.TOutChiWatLck
    "Outdoor air lockout temperature above which the CHW loop is prevented from operating"
    annotation(Dialog(group="Temperature setpoints", enable=cfg.have_chiWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatHeaPum_flow_nominal[cfg.nHeaPum](
    start=fill(0.1, cfg.nHeaPum),
    displayUnit=fill("L/s", cfg.nHeaPum),
    final min=fill(0, cfg.nHeaPum))
    "Design CHW volume flow rate - Each heat pump"
    annotation(Dialog(group="Heat pump flow setpoints", enable=cfg.have_chiWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    cfg.have_valChiWatMinByp));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatHeaPum_flow_min[cfg.nHeaPum](
    start=fill(0.1, cfg.nHeaPum),
    displayUnit=fill("L/s", cfg.nHeaPum),
    final min=fill(0, cfg.nHeaPum))
    "Minimum CHW volume flow rate - Each heat pump"
    annotation(Dialog(group="Heat pump flow setpoints", enable=cfg.have_chiWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop));
  parameter Modelica.Units.SI.HeatFlowRate capCooHeaPum_nominal[cfg.nHeaPum](
    start=fill(1, cfg.nHeaPum),
    final min=fill(0, cfg.nHeaPum))
    "Design cooling capacity - Each heat pump"
    annotation(Dialog(group="Capacity", enable=cfg.have_chiWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatPri_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)
    "Design primary CHW volume flow rate - Total"
    annotation(Dialog(group="Capacity", enable=cfg.have_chiWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    cfg.typDisChiWat==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only and
    cfg.typArrPumChiWatPri==Buildings.Templates.Components.Types.PumpArrangement.Headered));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatSec_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)
    "Design secondary CHW volume flow rate"
    annotation(Dialog(group="Capacity", enable=cfg.have_chiWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    cfg.typPumChiWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None and
    cfg.have_senVChiWatSec));
  parameter Modelica.Units.SI.PressureDifference dpChiWatRemSet_nominal[cfg.nSenDpChiWatRem](
    start=fill(Buildings.Templates.Data.Defaults.dpChiWatSet_max, cfg.nSenDpChiWatRem),
    final min=fill(0, cfg.nSenDpChiWatRem))
    "Design (maximum) CHW differential pressure setpoint - Remote sensor"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=cfg.have_chiWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    (cfg.typDisChiWat==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only or
    cfg.typPumChiWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None)));
  parameter Modelica.Units.SI.PressureDifference dpChiWatLocSet_nominal(
    start=Buildings.Templates.Data.Defaults.dpChiWatLocSet_max,
    final min=0)
    "Design (maximum) CHW differential pressure setpoint - Local sensor"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=cfg.have_chiWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    cfg.have_senDpChiWatLoc));
  parameter Real yPumChiWatPri_min(
    final unit="1",
    final min=0,
    final max=1)=0.1
    "Primary CHW pump minimum speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=cfg.have_chiWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    cfg.typDisChiWat==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only));
  parameter Real yPumChiWatSec_min(
    final unit="1",
    final min=0,
    final max=1)=0.1
    "Secondary CHW pump minimum speed"
    annotation(Dialog(group="Information provided by testing, adjusting, and balancing contractor",
    enable=cfg.have_chiWat and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.ClosedLoop and
    cfg.typPumChiWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None));

  annotation (
  defaultComponentName="datCtl",
  Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for
heat pump plant controllers that can be found within
<a href=\"modelica://Buildings.Templates.Plants.HeatPumps.Components.Controls\">
Buildings.Templates.Plants.HeatPumps.Components.Controls</a>.
</p>
</html>"));
end Controller;
