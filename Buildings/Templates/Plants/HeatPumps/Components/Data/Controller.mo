within Buildings.Templates.Plants.HeatPumps.Components.Data;
record Controller
  "Record for plant controller"
  extends Modelica.Icons.Record;
  parameter Buildings.Templates.Plants.HeatPumps.Configuration.HeatPumpPlant cfg
    "Plant configuration parameters";
  // HW loop
  // RFE: Declare array parameters for unequally sized units.
  // The current implementation only supports equally sized units.
  parameter Modelica.Units.SI.Temperature THeaWatSup_nominal(
    displayUnit="degC",
    start=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    final min=273.15)
    "Maximum HW supply temperature setpoint (design HW supply temperature)"
    annotation (Dialog(group="Temperature setpoints",
      enable=cfg.have_heaWat));
  parameter Real THeaWatSupSet_min(
    final min=273.15,
    start=25 + 273.15,
    final unit="K",
    displayUnit="degC")
    "Minimum value to which the HW supply temperature can be reset"
    annotation (Dialog(group="Temperature setpoints",
      enable=cfg.have_heaWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Modelica.Units.SI.Temperature TOutHeaWatLck(
    displayUnit="degC",
    final min=273.15)=Buildings.Templates.Data.Defaults.TOutHeaWatLck
    "Outdoor air lockout temperature above which the HW loop is prevented from operating"
    annotation (Dialog(group="Temperature setpoints",
      enable=cfg.have_heaWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatHp_flow_nominal(
    start=0.1,
    displayUnit="L/s",
    final min=0)
    "Design HW volume flow rate - Each heat pump"
    annotation (Evaluate=true,
    Dialog(group="Heat pump flow setpoints",
      enable=cfg.have_heaWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Modelica.Units.SI.HeatFlowRate capHeaHp_nominal(
    start=1,
    final min=0)
    "Design heating capacity - Each heat pump"
    annotation (Dialog(group="Capacity",
      enable=cfg.have_heaWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatSec_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)
    "Design secondary HW volume flow rate"
    annotation (Evaluate=true,
    Dialog(group="Capacity",
      enable=cfg.have_heaWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and cfg.typPumHeaWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatRemSet_min(
    final min=0,
    start=5 * 6894)=5 * 6894
    "Minimum value to which the HW differential pressure can be reset - Remote sensor"
    annotation (Dialog(group=
      "Information provided by designer",
      enable=cfg.have_heaWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and (cfg.typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
        or cfg.typPumHeaWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None)));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatRemSet_max[:](
    start=fill(Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max, cfg.nSenDpHeaWatRem),
    final min=fill(0, cfg.nSenDpHeaWatRem))
    "Maximum HW differential pressure setpoint - Remote sensor"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_heaWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and (cfg.typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
        or cfg.typPumHeaWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None)));
  parameter Real yPumHeaWatPriSet(
    final max=1,
    final min=0,
    start=1,
    final unit="1")
    "Primary pump speed providing design heat pump flow in heating mode"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater and
      cfg.have_heaWat and cfg.have_pumHeaWatPriVar));
  parameter Real yPumHeaWatSec_min(
    final unit="1",
    final min=0,
    final max=1)=0.1
    "Secondary HW pump minimum speed"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_heaWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and cfg.typPumHeaWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None));
  // CHW loop
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal(
    displayUnit="degC",
    start=Buildings.Templates.Data.Defaults.TChiWatSup,
    final min=273.15)
    "Minimum CHW supply temperature setpoint (design CHW supply temperature)"
    annotation (Dialog(group="Temperature setpoints",
      enable=cfg.have_chiWat));
  parameter Modelica.Units.SI.Temperature TChiWatSupSet_max(
    final min=273.15,
    start=15 + 273.15,
    displayUnit="degC")
    "Maximum value to which the CHW supply temperature can be reset"
    annotation (Dialog(group="Temperature setpoints",
      enable=cfg.have_chiWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Modelica.Units.SI.Temperature TOutChiWatLck(
    displayUnit="degC",
    final min=273.15)=Buildings.Templates.Data.Defaults.TOutChiWatLck
    "Outdoor air lockout temperature below which the CHW loop is prevented from operating"
    annotation (Dialog(group="Temperature setpoints",
      enable=cfg.have_chiWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatHp_flow_nominal(
    start=0.1,
    displayUnit="L/s",
    final min=0)
    "Design CHW volume flow rate - Each heat pump"
    annotation (Evaluate=true,
    Dialog(group="Heat pump flow setpoints",
      enable=cfg.have_chiWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Modelica.Units.SI.HeatFlowRate capCooHp_nominal(
    start=1,
    final min=0)
    "Design cooling capacity - Each heat pump"
    annotation (Dialog(group="Capacity",
      enable=cfg.have_chiWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatSec_flow_nominal(
    start=0.01,
    displayUnit="L/s",
    final min=0)
    "Design secondary CHW volume flow rate"
    annotation (Evaluate=true,
    Dialog(group="Capacity",
      enable=cfg.have_chiWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and cfg.typPumChiWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None));
  parameter Modelica.Units.SI.PressureDifference dpChiWatRemSet_min(
    final min=0,
    start=5 * 6894)=5 * 6894
    "Minimum value to which the CHW differential pressure can be reset - Remote sensor"
    annotation (Dialog(group=
      "Information provided by designer",
      enable=cfg.have_chiWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and (cfg.typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
        or cfg.typPumChiWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None)));
  parameter Modelica.Units.SI.PressureDifference dpChiWatRemSet_max[:](
    start=fill(Buildings.Templates.Data.Defaults.dpChiWatRemSet_max, cfg.nSenDpChiWatRem),
    final min=fill(0, cfg.nSenDpChiWatRem))
    "Maximum CHW differential pressure setpoint - Remote sensor"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_chiWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and (cfg.typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
        or cfg.typPumChiWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None)));
  parameter Real yPumChiWatPriSet(
    final max=1,
    final min=0,
    start=1,
    final unit="1")
    "Primary pump speed providing design heat pump flow in cooling mode"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_chiWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
      and cfg.have_pumChiWatPriVar));
  parameter Real yPumChiWatSec_min(
    final unit="1",
    final min=0,
    final max=1)=0.1
    "Secondary CHW pump minimum speed"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_chiWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and cfg.typPumChiWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None));
  parameter Real schHea[:, 2](start=[
    0, 1;
    24 * 3600, 1])=[
    0, 1;
    24 * 3600, 1]
    "Heating mode enable schedule"
    annotation (Dialog(enable=not cfg.have_inpSch and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater,
    group="Plant enable"));
  parameter Real schCoo[:, 2](start=[
    0, 1;
    24 * 3600, 1])=[
    0, 1;
    24 * 3600, 1]
    "Cooling mode enable schedule"
    annotation (Dialog(enable=not cfg.have_inpSch and
    cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater,
    group="Plant enable"));
  // HACK(AntoineGautier):
  // Using cfg.nHp for size(staEqu, 2) is not supported by Dymola which fails to evaluate the array size.
  // So the size is kept unassigned and a check is performed at initialization.
  // Furthermore, a start value cannot be provided as the number of plant stages is not known beforehand.
  // If provided, there will likely be a mismatch between assigned value and start value.
  // Therefore, no enable annotation can be used.
  parameter Real staEqu[:, :](
    each final max=1,
    each final min=0,
    each final unit="1")
    "Staging matrix – Equipment required for each stage"
    annotation (Dialog(group="Equipment staging and rotation"));
  parameter Real plrSta(
    final max=1,
    final min=0,
    start=0.9,
    final unit="1")=0.9
    "Staging part load ratio"
    annotation (Dialog(group="Equipment staging and rotation",
    enable=cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  annotation (
    defaultComponentName="datCtl",
    Documentation(
      info="<html>
FIXME: Consider have_senV(Hea|Chi)WatSec=true systematically for primary-secondary
plants. We don't want to stage sceondary pumps based on speed, see
the caveats in G36 Section 5.21.7.4.
<p>
This record provides the set of sizing and operating parameters for
heat pump plant controllers that can be found within
<a href=\"modelica://Buildings.Templates.Plants.HeatPumps.Components.Controls\">
Buildings.Templates.Plants.HeatPumps.Components.Controls</a>.
</p>
</html>"));
end Controller;
