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
    final min=0)
    "Design heat pump HW volume flow rate - Each heat pump"
    annotation (Evaluate=true,
    Dialog(group="Heat pump flow setpoints",
      enable=cfg.have_heaWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatHp_flow_min(
    start=VHeaWatHp_flow_nominal,
    final min=0)=1.1*VHeaWatHp_flow_nominal
    "Minimum heat pump HW volume flow rate - Each heat pump"
    annotation (Evaluate=true,
    Dialog(group="Heat pump flow setpoints",
      enable=cfg.have_heaWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
      and cfg.typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only));
  parameter Modelica.Units.SI.HeatFlowRate capHeaHp_nominal(
    start=1,
    final min=0)
    "Design heat pump heating capacity - Each heat pump"
    annotation (Dialog(group="Capacity",
      enable=cfg.have_heaWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatPri_flow_nominal(
    start=VHeaWatHp_flow_nominal*cfg.nHp,
    final min=0)=VHeaWatHp_flow_nominal*cfg.nHp
    "Design primary HW volume flow rate"
    annotation (Evaluate=true,
    Dialog(group="Capacity",
      enable=cfg.have_heaWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
      and cfg.typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
      and cfg.typArrPumPri==Buildings.Templates.Components.Types.PumpArrangement.Headered));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatSec_flow_nominal(
    start=0.01,
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
      enable=cfg.have_heaWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  // HACK(AntoineGautier):
  // Using cfg.nSenDpHeaWatRem for size(dpHeaWatRemSet_max, 1) is not supported by Dymola which fails to "evaluate and check the size declaration".
  // So the size is kept unassigned.
  // This requires explicitely providing a value with OCT, even if enable=false.
  parameter Modelica.Units.SI.PressureDifference dpHeaWatRemSet_max[:](
    start=fill(Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max, cfg.nSenDpHeaWatRem),
    final min=fill(0, cfg.nSenDpHeaWatRem))
    "Maximum HW differential pressure setpoint - Remote sensor"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_heaWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Real dpHeaWatLocSet_min(
    start=0,
    final unit="Pa",
    final min=0)=5 * 6895
    "Minimum HW loop differential pressure setpoint local to the plant"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_heaWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and not cfg.have_senDpHeaWatRemWir));
  parameter Real dpHeaWatLocSet_max(
    start=1E5,
    final unit="Pa",
    final min=0)
    "Maximum HW loop differential pressure setpoint local to the plant"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_heaWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and not cfg.have_senDpHeaWatRemWir));
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
  parameter Real yPumHeaWatPri_min(
    final max=1,
    final min=0,
    start=0.1,
    final unit="1")=0.1
    "Primary HW pump minimum speed"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_heaWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
      and cfg.typPumHeaWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
      and cfg.typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only));
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
    final min=0)
    "Design heat pump CHW volume flow rate - Each heat pump"
    annotation (Evaluate=true,
    Dialog(group="Heat pump flow setpoints",
      enable=cfg.have_chiWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatHp_flow_min(
    start=VChiWatHp_flow_nominal,
    final min=0)=1.1*VChiWatHp_flow_nominal
    "Minimum heat pump CHW volume flow rate - Each heat pump"
    annotation (Evaluate=true,
    Dialog(group="Heat pump flow setpoints",
      enable=cfg.have_chiWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
      and cfg.typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only));
  parameter Modelica.Units.SI.HeatFlowRate capCooHp_nominal(
    start=1,
    final min=0)
    "Design heat pump cooling capacity - Each heat pump"
    annotation (Dialog(group="Capacity",
      enable=cfg.have_chiWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatPri_flow_nominal(
    start=VChiWatHp_flow_nominal*cfg.nHp,
    final min=0)=VChiWatHp_flow_nominal*cfg.nHp
    "Design primary CHW volume flow rate"
    annotation (Evaluate=true,
    Dialog(group="Capacity",
      enable=cfg.have_chiWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
      and cfg.typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
      and cfg.typArrPumPri==Buildings.Templates.Components.Types.PumpArrangement.Headered));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatSec_flow_nominal(
    start=0.01,
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
  // HACK(AntoineGautier):
  // Using cfg.nSenDpChiWatRem for size(dpChiWatRemSet_max, 1) is not supported by Dymola which fails to "evaluate and check the size declaration".
  // So the size is kept unassigned.
  // This requires explicitely providing a value with OCT, even if enable=false.
  parameter Modelica.Units.SI.PressureDifference dpChiWatRemSet_max[:](
    start=fill(Buildings.Templates.Data.Defaults.dpChiWatRemSet_max, cfg.nSenDpChiWatRem),
    final min=fill(0, cfg.nSenDpChiWatRem))
    "Maximum CHW differential pressure setpoint - Remote sensor"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_chiWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and (cfg.typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
        or cfg.typPumChiWatSec<>Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None)));
  parameter Real dpChiWatLocSet_min(
    start=0,
    final unit="Pa",
    final min=0)=5 * 6895
    "Minimum CHW loop differential pressure setpoint local to the plant"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_chiWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and not cfg.have_senDpChiWatRemWir));
  parameter Real dpChiWatLocSet_max(
    start=1E5,
    final unit="Pa",
    final min=0)
    "Maximum CHW loop differential pressure setpoint local to the plant"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_chiWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and not cfg.have_senDpChiWatRemWir));
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
  parameter Real yPumChiWatPri_min(
    final max=1,
    final min=0,
    start=0.1,
    final unit="1")=0.1
    "Primary CHW pump minimum speed"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_chiWat and cfg.typCtl==Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
      and cfg.typPumChiWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
      and cfg.typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only));
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
  // Using cfg.nHp for size(staEqu, 2) is not supported by Dymola which fails to "evaluate and check the size declaration".
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
  parameter Real TChiWatSupHrc_min(
    final min=273.15,
    start=4 + 273.15,
    final unit="K",
    displayUnit="degC")
    "Sidestream HRC – Minimum allowable CHW supply temperature"
    annotation (Dialog(group="Information provided by designer", enable=cfg.have_hrc));
  parameter Real THeaWatSupHrc_max(
    final min=273.15,
    start=60 + 273.15,
    final unit="K",
    displayUnit="degC")
    "Sidestream HRC – Maximum allowable HW supply temperature"
    annotation (Dialog(group="Information provided by designer", enable=cfg.have_hrc));
  parameter Real COPHeaHrc_nominal(
    final min=1.1,
    final unit="1",
    start=2.8)
    "Sidestream HRC – Heating COP at design heating conditions"
    annotation (Dialog(group="Information provided by designer", enable=cfg.have_hrc));
  parameter Real capCooHrc_min(
    start=0,
    final min=0,
    final unit="W")
    "Sidestream HRC – Minimum cooling capacity below which cycling occurs"
    annotation (Dialog(group="Information provided by designer", enable=cfg.have_hrc));
  parameter Real capHeaHrc_min(
    start=0,
    final min=0,
    final unit="W")
    "Sidestream HRC – Minimum heating capacity below which cycling occurs"
    annotation (Dialog(group="Information provided by designer", enable=cfg.have_hrc));
  annotation (
    defaultComponentName="datCtl",
    Documentation(
      info="<html>
<p>
This record provides the set of parameters for
heat pump plant controllers that can be found within
<a href=\"modelica://Buildings.Templates.Plants.HeatPumps.Components.Controls\">
Buildings.Templates.Plants.HeatPumps.Components.Controls</a>.
</p>
</html>"));
end Controller;
