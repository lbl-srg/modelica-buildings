within Buildings.Templates.Plants.HeatPumps.Components.Data;
record Controller
  "Record for plant controller"
  extends Modelica.Icons.Record;
  parameter Buildings.Templates.Plants.HeatPumps.Configuration.HeatPumpPlant cfg
    "Plant configuration parameters";
  parameter Real schHea[:, 2](start=[0, 1; 24 * 3600, 1]) = [0, 1; 24 * 3600, 1]
    "Heating mode enable schedule"
    annotation(Dialog(
      enable=not cfg.have_inpSch
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater,
      group="Hot water plant"));
  parameter Modelica.Units.SI.Temperature THeaWatSup_nominal(
    final min=273.15,
    start=Buildings.Templates.Data.Defaults.THeaWatSupMed,
    displayUnit="degC")
    "Maximum HW supply temperature setpoint (design HW supply temperature)"
    annotation(Dialog(group="Hot water plant",
      enable=cfg.have_heaWat));
  parameter Real THeaWatSupSet_min(
    final min=273.15,
    start=25 + 273.15,
    final unit="K",
    displayUnit="degC")
    "Minimum value to which the HW supply temperature can be reset"
    annotation(Dialog(group="Hot water plant",
      enable=cfg.have_heaWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Modelica.Units.SI.Temperature TOutHeaWatLck(final min=273.15) =
    Buildings.Templates.Data.Defaults.TOutHeaWatLck
    "Outdoor air lockout temperature above which the HW loop is prevented from operating"
    annotation(Dialog(group="Hot water plant",
      enable=cfg.have_heaWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatPri_flow_nominal(
    final min=0,
    start=VHeaWatHp_flow_nominal * cfg.nHp) =
    VHeaWatHp_flow_nominal * cfg.nHp + VHeaWatShc_flow_nominal * cfg.nShc
    "Design primary HW volume flow rate"
    annotation(Evaluate=true,
      Dialog(group="Hot water plant",
        enable=cfg.have_heaWat
          and cfg.typCtl ==
            Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
          and cfg.typDis ==
            Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
          and cfg.typArrPumPri ==
            Buildings.Templates.Components.Types.PumpArrangement.Headered));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatSec_flow_nominal(
    final min=0,
    start=0.01)
    "Design secondary HW volume flow rate"
    annotation(Evaluate=true,
      Dialog(group="Hot water plant",
        enable=cfg.have_heaWat
          and cfg.typCtl ==
            Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
          and cfg.typPumHeaWatSec <>
            Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatRemSet_min(
    final min=0,
    start=5 * 6894) = 5 * 6894
    "Minimum value to which the HW differential pressure can be reset – Remote sensor"
    annotation(Dialog(group="Hot water plant",
      enable=cfg.have_heaWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Real schCoo[:, 2](start=[0, 1; 24 * 3600, 1]) = [0, 1; 24 * 3600, 1]
    "Cooling mode enable schedule"
    annotation(Dialog(
      enable=not cfg.have_inpSch
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater,
      group="Chilled water plant"));
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal(
    final min=273.15,
    start=Buildings.Templates.Data.Defaults.TChiWatSup,
    displayUnit="degC")
    "Minimum CHW supply temperature setpoint (design CHW supply temperature)"
    annotation(Dialog(group="Chilled water plant",
      enable=cfg.have_chiWat));
  parameter Modelica.Units.SI.Temperature TChiWatSupSet_max(
    final min=273.15,
    start=15 + 273.15,
    displayUnit="degC")
    "Maximum value to which the CHW supply temperature can be reset"
    annotation(Dialog(group="Chilled water plant",
      enable=cfg.have_chiWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Modelica.Units.SI.Temperature TOutChiWatLck(final min=273.15) =
    Buildings.Templates.Data.Defaults.TOutChiWatLck
    "Outdoor air lockout temperature below which the CHW loop is prevented from operating"
    annotation(Dialog(group="Chilled water plant",
      enable=cfg.have_chiWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatPri_flow_nominal(
    final min=0,
    start=VChiWatHp_flow_nominal * cfg.nHp) =
    VChiWatHp_flow_nominal * cfg.nHp + VChiWatShc_flow_nominal * cfg.nShc
    "Design primary CHW volume flow rate"
    annotation(Evaluate=true,
      Dialog(group="Chilled water plant",
        enable=cfg.have_chiWat
          and cfg.typCtl ==
            Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
          and cfg.typDis ==
            Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
          and cfg.typArrPumPri ==
            Buildings.Templates.Components.Types.PumpArrangement.Headered));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatSec_flow_nominal(
    final min=0,
    start=0.01)
    "Design secondary CHW volume flow rate"
    annotation(Evaluate=true,
      Dialog(group="Chilled water plant",
        enable=cfg.have_chiWat
          and cfg.typCtl ==
            Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
          and cfg.typPumChiWatSec <>
            Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None));
  parameter Modelica.Units.SI.PressureDifference dpChiWatRemSet_min(
    final min=0,
    start=5 * 6894) = 5 * 6894
    "Minimum value to which the CHW differential pressure can be reset – Remote sensor"
    annotation(Dialog(group="Chilled water plant",
      enable=cfg.have_chiWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and (cfg.typDis ==
          Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
          or cfg.typPumChiWatSec <>
            Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None)));
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
    annotation(Dialog(group="Equipment staging and rotation"));
  parameter Real plrSta(
    final max=1,
    final min=0,
    final unit="1",
    start=0.9) = 0.9
    "Staging part load ratio"
    annotation(Dialog(group="Equipment staging and rotation",
      enable=cfg.typCtl ==
        Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatHp_flow_nominal(
    final min=0,
    start=0.1)
    "Design HW volume flow rate – Each heat pump"
    annotation(Evaluate=true,
      Dialog(group="Plant equipment – Heat pumps",
        enable=cfg.have_hp
          and cfg.have_heaWat
          and cfg.typCtl ==
            Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
          and cfg.typDis ==
            Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatHp_flow_min(
    final min=0,
    start=VHeaWatHp_flow_nominal) = 1.1 * VHeaWatHp_flow_nominal
    "Minimum heat pump HW volume flow rate – Each heat pump"
    annotation(Evaluate=true,
      Dialog(group="Plant equipment – Heat pumps",
        enable=cfg.have_hp
          and cfg.have_heaWat
          and cfg.typCtl ==
            Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
          and cfg.typDis ==
            Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only));
  parameter Modelica.Units.SI.HeatFlowRate capHeaHp_nominal(final min=0, start=1)
    "Design heating capacity – Each heat pump"
    annotation(Dialog(group="Plant equipment – Heat pumps",
      enable=cfg.have_hp
        and cfg.have_heaWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatHp_flow_nominal(
    final min=0,
    start=0.1)
    "Design CHW volume flow rate – Each heat pump"
    annotation(Evaluate=true,
      Dialog(group="Plant equipment – Heat pumps",
        enable=cfg.have_hp
          and cfg.have_chiWat
          and cfg.typCtl ==
            Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
          and cfg.typDis ==
            Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatHp_flow_min(
    final min=0,
    start=VChiWatHp_flow_nominal) = 1.1 * VChiWatHp_flow_nominal
    "Minimum heat pump CHW volume flow rate – Each heat pump"
    annotation(Evaluate=true,
      Dialog(group="Plant equipment – Heat pumps",
        enable=cfg.have_hp
          and cfg.have_chiWat
          and cfg.typCtl ==
            Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
          and cfg.typDis ==
            Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only));
  parameter Modelica.Units.SI.HeatFlowRate capCooHp_nominal(final min=0, start=1)
    "Design cooling capacity – Each heat pump"
    annotation(Dialog(group="Plant equipment – Heat pumps",
      enable=cfg.have_hp
        and cfg.have_chiWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  // FIXME: SHC unit parameters waiting to be propagated
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatShc_flow_nominal(
    final min=0,
    start=0.1)
    "Design HW volume flow rate – Each unit"
    annotation(Evaluate=true,
      Dialog(group="Plant equipment – Polyvalent units",
        enable=cfg.have_shc
          and cfg.typCtl ==
            Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
          and cfg.typDis ==
            Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only));
  parameter Modelica.Units.SI.VolumeFlowRate VHeaWatShc_flow_min(
    final min=0,
    start=VHeaWatShc_flow_nominal) = 1.1 * VHeaWatShc_flow_nominal
    "Minimum heat pump HW volume flow rate – Each unit"
    annotation(Evaluate=true,
      Dialog(group="Plant equipment – Polyvalent units",
        enable=cfg.have_shc
          and cfg.typCtl ==
            Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
          and cfg.typDis ==
            Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only));
  parameter Modelica.Units.SI.HeatFlowRate capHeaShc_nominal(final min=0, start=1)
    "Design heating capacity – Each unit"
    annotation(Dialog(group="Plant equipment – Polyvalent units",
      enable=cfg.have_shc
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatShc_flow_nominal(
    final min=0,
    start=0.1)
    "Design CHW volume flow rate – Each unit"
    annotation(Evaluate=true,
      Dialog(group="Plant equipment – Polyvalent units",
        enable=cfg.have_shc
          and cfg.typCtl ==
            Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
          and cfg.typDis ==
            Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only));
  parameter Modelica.Units.SI.VolumeFlowRate VChiWatShc_flow_min(
    final min=0,
    start=VChiWatShc_flow_nominal) = 1.1 * VChiWatShc_flow_nominal
    "Minimum heat pump CHW volume flow rate – Each unit"
    annotation(Evaluate=true,
      Dialog(group="Plant equipment – Polyvalent units",
        enable=cfg.have_shc
          and cfg.typCtl ==
            Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
          and cfg.typDis ==
            Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only));
  parameter Modelica.Units.SI.HeatFlowRate capCooShc_nominal(final min=0, start=1)
    "Design cooling capacity – Each unit"
    annotation(Dialog(group="Plant equipment – Polyvalent units",
      enable=cfg.have_shc
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Real TChiWatSupHrc_min(
    final min=273.15,
    start=4 + 273.15,
    final unit="K",
    displayUnit="degC")
    "Minimum allowable CHW supply temperature – HRC"
    annotation(Dialog(
      group="Plant equipment – Sidestream heat recovery chiller",
      enable=cfg.have_hrc));
  parameter Real THeaWatSupHrc_max(
    final min=273.15,
    start=60 + 273.15,
    final unit="K",
    displayUnit="degC")
    "Maximum allowable HW supply temperature – HRC"
    annotation(Dialog(
      group="Plant equipment – Sidestream heat recovery chiller",
      enable=cfg.have_hrc));
  parameter Real COPHeaHrc_nominal(final min=1.1, start=2.8, final unit="1")
    "Heating COP at design heating conditions – HRC"
    annotation(Dialog(
      group="Plant equipment – Sidestream heat recovery chiller",
      enable=cfg.have_hrc));
  parameter Real capCooHrc_min(final min=0, start=0, final unit="W")
    "Minimum cooling capacity below which cycling occurs – HRC"
    annotation(Dialog(
      group="Plant equipment – Sidestream heat recovery chiller",
      enable=cfg.have_hrc));
  parameter Real capHeaHrc_min(final min=0, start=0, final unit="W")
    "Minimum heating capacity below which cycling occurs – HRC"
    annotation(Dialog(
      group="Plant equipment – Sidestream heat recovery chiller",
      enable=cfg.have_hrc));
  // HACK(AntoineGautier):
  // Using cfg.nSenDpHeaWatRem for size(dpHeaWatRemSet_max, 1) is not supported by Dymola which fails to "evaluate and check the size declaration".
  // So the size is kept unassigned.
  // This requires explicitely providing a value with OCT, even if enable=false.
  parameter Modelica.Units.SI.PressureDifference dpHeaWatRemSet_max[:](
    final min=fill(0, cfg.nSenDpHeaWatRem),
    start=fill(
      Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max,
      cfg.nSenDpHeaWatRem))
    "Maximum HW differential pressure setpoint – Remote sensor"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_heaWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater));
  parameter Real dpHeaWatLocSet_min(final min=0, start=0, final unit="Pa") = 5 * 6895
    "Minimum HW loop differential pressure setpoint local to the plant"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_heaWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and not cfg.have_senDpHeaWatRemWir));
  parameter Real dpHeaWatLocSet_max(final min=0, start=1E5, final unit="Pa")
    "Maximum HW loop differential pressure setpoint local to the plant"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_heaWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and not cfg.have_senDpHeaWatRemWir));
  parameter Real yPumHeaWatPriHdrSet(final max=2, final min=0, start=1, final unit="1")
    "Headered primary HW pump speed providing design flow in heating mode"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_heaWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and cfg.typDis ==
          Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2
        and cfg.typArrPumPri ==
          Buildings.Templates.Components.Types.PumpArrangement.Headered
        and (cfg.typPumHeaWatPriHp ==
          Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
          or cfg.typPumHeaWatPriShc ==
            Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable)));
  parameter Real yPumHeaWatPriHpSet(final max=2, final min=0, start=1, final unit="1")
    "Heat pump dedicated primary pump speed providing design flow in heating mode"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_heaWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and cfg.typDis ==
          Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2
        and cfg.typArrPumPri ==
          Buildings.Templates.Components.Types.PumpArrangement.Dedicated
        and cfg.typPumHeaWatPriHp ==
          Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable));
  parameter Real yPumHeaWatPriShcSet(final max=2, final min=0, start=1, final unit="1")
    "Polyvalent unit dedicated primary HW pump speed providing design flow"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_heaWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and cfg.typDis ==
          Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2
        and cfg.typArrPumPri ==
          Buildings.Templates.Components.Types.PumpArrangement.Dedicated
        and cfg.typPumHeaWatPriShc ==
          Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable));
  parameter Real yPumHeaWatPri_min(final max=1, final min=0, start=0.1, final unit="1") = 0.1
    "Primary HW pump minimum speed"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_heaWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and cfg.typDis ==
          Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
        and (cfg.typPumHeaWatPriHp ==
          Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
          or cfg.typPumHeaWatPriShc ==
            Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable)));
  parameter Real yPumHeaWatSec_min(final max=1, final min=0, final unit="1", start=0.1) = 0.1
    "Secondary HW pump minimum speed"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_heaWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and cfg.typPumHeaWatSec <>
          Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None));
  // HACK(AntoineGautier):
  // Using cfg.nSenDpChiWatRem for size(dpChiWatRemSet_max, 1) is not supported by Dymola which fails to "evaluate and check the size declaration".
  // So the size is kept unassigned.
  // This requires explicitely providing a value with OCT, even if enable=false.
  parameter Modelica.Units.SI.PressureDifference dpChiWatRemSet_max[:](
    final min=fill(0, cfg.nSenDpChiWatRem),
    start=fill(
      Buildings.Templates.Data.Defaults.dpChiWatRemSet_max,
      cfg.nSenDpChiWatRem))
    "Maximum CHW differential pressure setpoint – Remote sensor"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_chiWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and (cfg.typDis ==
          Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
          or cfg.typPumChiWatSec <>
            Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None)));
  parameter Real dpChiWatLocSet_min(final min=0, start=0, final unit="Pa") = 5 * 6895
    "Minimum CHW loop differential pressure setpoint local to the plant"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_chiWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and not cfg.have_senDpChiWatRemWir));
  parameter Real dpChiWatLocSet_max(final min=0, start=1E5, final unit="Pa")
    "Maximum CHW loop differential pressure setpoint local to the plant"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_chiWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and not cfg.have_senDpChiWatRemWir));
  parameter Real yPumChiWatPriHdrSet(final max=2, final min=0, start=1, final unit="1")
    "Headered primary pump speed providing design flow in cooling mode"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_chiWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and cfg.typDis ==
          Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2
        and cfg.typArrPumPri ==
          Buildings.Templates.Components.Types.PumpArrangement.Headered
        and (cfg.typPumChiWatPriHp ==
          Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
          or cfg.typPumChiWatPriShc ==
            Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable)));
  parameter Real yPumChiWatPriHpSet(final max=2, final min=0, start=1, final unit="1")
    "Heat pump dedicated primary pump speed providing design flow in cooling mode"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_chiWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and cfg.typDis ==
          Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2
        and cfg.typArrPumPri ==
          Buildings.Templates.Components.Types.PumpArrangement.Dedicated
        and cfg.typPumChiWatPriHp ==
          Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable));
  parameter Real yPumChiWatPriShcSet(final max=2, final min=0, start=1, final unit="1")
    "Polyvalent unit dedicated primary pump speed providing design flow in cooling mode"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_chiWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and cfg.typDis ==
          Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2
        and cfg.typArrPumPri ==
          Buildings.Templates.Components.Types.PumpArrangement.Dedicated
        and cfg.typPumChiWatPriShc ==
          Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable));
  parameter Real yPumChiWatPri_min(final max=1, final min=0, start=0.1, final unit="1") = 0.1
    "Primary CHW pump minimum speed"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_chiWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and cfg.typDis ==
          Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
        and (cfg.typPumChiWatPriHp ==
          Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
          or cfg.typPumChiWatPriShc ==
            Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable)));
  parameter Real yPumChiWatSec_min(final max=1, final min=0, final unit="1", start=0.1) = 0.1
    "Secondary CHW pump minimum speed"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=cfg.have_chiWat
        and cfg.typCtl ==
          Buildings.Templates.Plants.HeatPumps.Types.Controller.AirToWater
        and cfg.typPumChiWatSec <>
          Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None));
annotation(defaultComponentName="datCtl",
  Documentation(
    info="<html>
<p>
  This record provides the set of parameters for heat pump plant controllers
  that can be found within
  <a href=\"modelica://Buildings.Templates.Plants.HeatPumps.Components.Controls\">
    Buildings.Templates.Plants.HeatPumps.Components.Controls</a>.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    June 4, 2024, by Michael Wetter:<br />
    Corrected display unit for Dymola 2024x Refresh1.
  </li>
</ul>
</html>"));
end Controller;
