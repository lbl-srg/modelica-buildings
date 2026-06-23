within Buildings.Templates.Plants.Controls.HeatPumps;
block AirToWater
  "Controller for AWHP plant"
  parameter Buildings.Templates.Plants.Controls.Types.PlantHeatPump typ =
    Buildings.Templates.Plants.Controls.Types.PlantHeatPump.Reversible
    "Type of plant"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration"));
  final parameter Boolean have_heaWat = true
    "Set to true for plants that provide HW"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration"));
  final parameter Boolean have_chiWat =
    typ <> Buildings.Templates.Plants.Controls.Types.PlantHeatPump.HeatingOnly
    "Set to true for plants that provide CHW"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration"));
  final parameter Boolean have_hrc =
    typ ==
      Buildings.Templates.Plants.Controls.Types.PlantHeatPump.ReversibleHeatRecovery
    "Set to true for plants with sidestream heat recovery chiller"
    annotation(Evaluate=true);
  final parameter Boolean have_hp =
    typ <> Buildings.Templates.Plants.Controls.Types.PlantHeatPump.Polyvalent
    "Set to true for plants with 2-pipe heat pumps"
    annotation(Evaluate=true);
  final parameter Boolean have_php =
    typ ==
      Buildings.Templates.Plants.Controls.Types.PlantHeatPump.ReversiblePolyvalent
      or typ ==
        Buildings.Templates.Plants.Controls.Types.PlantHeatPump.Polyvalent
    "Set to true for plants with polyvalent heat pumps"
    annotation(Evaluate=true);
  parameter Boolean is_priOnl = false
    "Set to true for primary-only plant"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration"));
  parameter Boolean have_valHpInlIso(start=false)
    "Set to true for plants with isolation valves at heat pump inlet"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration",
        enable=have_hp));
  parameter Boolean have_valHpOutIso(start=false)
    "Set to true for plants with isolation valves at heat pump outlet"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration",
        enable=have_hp));
  parameter Boolean have_valPhpInlIso(start=false)
    "Set to true for isolation valves at polyvalent HP inlet"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration",
        enable=have_php));
  parameter Boolean have_valPhpOutIso(start=false)
    "Set to true for isolation valves at polyvalent HP outlet"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration",
        enable=have_php));
  final parameter Boolean have_pumHeaWatPri = have_heaWat
    "Set to true for plants with primary HW pumps"
    annotation(Evaluate=true);
  parameter Boolean have_pumChiWatPriDedHp_select(start=false)=false
    "Set to true for HP with separate dedicated primary pumps for CHW and HW circuits"
    annotation(Evaluate=true,
      Dialog(enable=have_chiWat and not have_pumPriHdr,
        group="Plant configuration"));
  final parameter Boolean have_pumChiWatPriDedHp =
    if have_chiWat and not have_pumPriHdr
    then have_pumChiWatPriDedHp_select else false
    "Set to true for HP with separate dedicated primary CHW pumps"
    annotation(Evaluate=true);
  final parameter Boolean have_pumChiWatPri =
    have_chiWat and (have_pumPriHdr or have_pumChiWatPriDedHp or have_php)
    "Set to true for HP with separate dedicated primary pumps for CHW and HW circuits"
    annotation(Evaluate=true);
  parameter Boolean have_pumPriHdr
    "Set to true for headered primary pumps, false for dedicated pumps"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration"));
  parameter Boolean have_pumHeaWatPriVar_select(start=true)=true
    "Set to true for variable speed primary HW pumps, false for constant speed pumps"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration",
        enable=have_pumHeaWatPri and not is_priOnl));
  parameter Boolean have_pumChiWatPriVar_select(start=true)=true
    "Set to true for variable speed primary CHW pumps, false for constant speed pumps"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration",
        enable=have_pumChiWatPri and not is_priOnl));
  final parameter Boolean have_pumHeaWatPriVar =
    have_pumHeaWatPri and (is_priOnl or have_pumHeaWatPriVar_select)
    "Set to true for variable speed primary HW pumps, false for constant speed pumps"
    annotation(Evaluate=true);
  final parameter Boolean have_pumChiWatPriVar =
    have_pumChiWatPri and (is_priOnl or have_pumChiWatPriVar_select)
    "Set to true for variable speed primary CHW pumps, false for constant speed pumps"
    annotation(Evaluate=true);
  final parameter Boolean have_pumPriCtlDp = is_priOnl
    "Set to true for primary variable speed pumps using ∆p pump speed control"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration"));
  final parameter Boolean have_pumHeaWatSec = have_heaWat and not is_priOnl
    "Set to true for plants with secondary HW pumps"
    annotation(Evaluate=true);
  final parameter Boolean have_pumChiWatSec = have_chiWat and not is_priOnl
    "Set to true for plants with secondary CHW pumps"
    annotation(Evaluate=true);
  // Only headered arrangements are supported for secondary pumps.
  final parameter Boolean have_pumSecHdr = true
    "Set to true for headered secondary pumps, false for dedicated pumps"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration"));
  // Only ∆p controlled variable speed pumps are supported for secondary pumps.
  final parameter Boolean have_pumSecCtlDp =
    have_pumHeaWatSec or have_pumChiWatSec
    "Set to true for secondary variable speed pumps using ∆p pump speed control"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration"));
  parameter Boolean have_senVHeaWatPri_select(start=false)
    "Set to true for plants with primary HW flow sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=have_heaWat and not have_hrc and have_senVHeaWatSec));
  final parameter Boolean have_senVHeaWatPri =
    have_heaWat
      and (if have_hrc or not have_senVHeaWatSec
      then true else have_senVHeaWatPri_select)
    "Set to true for plants with primary HW flow sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors"));
  // Secondary flow sensor required for secondary HW pump staging.
  final parameter Boolean have_senVHeaWatSec = have_pumHeaWatSec
    "Set to true for plants with secondary HW flow sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors"));
  parameter Boolean have_senVChiWatPri_select(start=false)
    "Set to true for plants with primary CHW flow sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=have_chiWat and not have_hrc and have_senVChiWatSec));
  final parameter Boolean have_senVChiWatPri =
    have_chiWat
      and (if have_hrc or not have_senVChiWatSec
      then true else have_senVChiWatPri_select)
    "Set to true for plants with primary CHW flow sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors"));
  // Secondary flow sensor required for secondary CHW pump staging.
  final parameter Boolean have_senVChiWatSec(start=false) = have_pumChiWatSec
    "Set to true for plants with secondary CHW flow sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors"));
  parameter Boolean have_senTHeaWatPriRet_select(start=false)
    "Set to true for plants with primary HW return temperature sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=have_heaWat and not have_hrc and have_senTHeaWatSecRet));
  final parameter Boolean have_senTHeaWatPriRet =
    have_heaWat
      and (if have_hrc or not have_senTHeaWatSecRet
      then true else have_senTHeaWatPriRet_select)
    "Set to true for plants with primary HW return temperature sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors"));
  parameter Boolean have_senTChiWatPriRet_select(start=false)
    "Set to true for plants with primary CHW return temperature sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=have_chiWat and not have_hrc and have_senTChiWatSecRet));
  final parameter Boolean have_senTChiWatPriRet =
    have_chiWat
      and (if have_hrc or not have_senTChiWatSecRet
      then true else have_senTChiWatPriRet_select)
    "Set to true for plants with primary CHW return temperature sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors"));
  // For primary-secondary plants, SHWST sensor is required for plant staging.
  final parameter Boolean have_senTHeaWatSecSup = have_pumHeaWatSec
    "Set to true for plants with secondary HW supply temperature sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors"));
  // For primary-secondary plants, SCHWST sensor is required for plant staging.
  final parameter Boolean have_senTChiWatSecSup = have_pumChiWatSec
    "Set to true for plants with secondary CHW supply temperature sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors"));
  // Following return temperature sensors are:
  // - optional for primary-secondary plants without HRC,
  // - required for plants with HRC: downstream of HRC.
  parameter Boolean have_senTHeaWatSecRet_select(start=false)=false
    "Set to true for plants with secondary HW return temperature sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=have_pumHeaWatSec and not have_hrc));
  parameter Boolean have_senTChiWatSecRet_select(start=false)=false
    "Set to true for plants with secondary CHW return temperature sensor"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=have_pumChiWatSec and not have_hrc));
  final parameter Boolean have_senTHeaWatSecRet =
    if have_hrc
    then true
    elseif not have_pumHeaWatSec
    then false
    else have_senTHeaWatSecRet_select
    "Set to true for plants with secondary HW return temperature sensor"
    annotation(Evaluate=true);
  final parameter Boolean have_senTChiWatSecRet(start=false) =
    if have_hrc
    then true
    elseif not have_pumChiWatSec
    then false
    else have_senTChiWatSecRet_select
    "Set to true for plants with secondary CHW return temperature sensor"
    annotation(Evaluate=true);
  parameter Integer nHp_select(min=if have_hp then 1 else 0, start=1)
    "Number of 2-pipe heat pumps"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration",
        enable=have_hp));
  final parameter Integer nHp = if have_hp then nHp_select else 0
    "Number of 2-pipe heat pumps"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration"));
  parameter Integer nPhp_select(min=if have_php then 1 else 0, start=1)
    "Number of polyvalent heat pumps"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration",
        enable=have_php));
  final parameter Integer nPhp = if have_php then nPhp_select else 0
    "Number of polyvalent heat pumps"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration"));
  parameter Integer nPumHeaWatPri_select(
    min=if have_pumHeaWatPri then 1 else 0,
    start=0)=nHp + nPhp
    "Number of primary HW pumps"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration",
        enable=have_pumHeaWatPri and have_pumPriHdr));
  final parameter Integer nPumHeaWatPriDedHp =
    if have_hp and not have_pumPriHdr then nHp else 0
    "Number of dedicated primary HW pumps serving HP"
    annotation(Evaluate=true);
  final parameter Integer nPumHeaWatPriDedPhp =
    if have_php and not have_pumPriHdr then nPhp else 0
    "Number of dedicated primary HW pumps serving polyvalent HP"
    annotation(Evaluate=true);
  final parameter Integer nPumHeaWatPri =
    if have_pumHeaWatPri and have_pumPriHdr
    then nPumHeaWatPri_select
    elseif have_pumHeaWatPri and not have_pumPriHdr
    then nHp + nPhp
    else 0
    "Number of primary HW pumps"
    annotation(Evaluate=true);
  parameter Integer nPumChiWatPri_select(
    min=if have_pumChiWatPri then 1 else 0,
    start=0)=nHp + nPhp
    "Number of primary CHW pumps"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration",
        enable=have_pumChiWatPri and have_pumPriHdr));
  final parameter Integer nPumChiWatPriDedHp =
    if have_pumChiWatPriDedHp then nHp else 0
    "Number of dedicated primary CHW pumps serving HP"
    annotation(Evaluate=true);
  final parameter Integer nPumChiWatPriDedPhp =
    if have_php and not have_pumPriHdr then nPhp else 0
    "Number of dedicated primary CHW pumps serving polyvalent HP"
    annotation(Evaluate=true);
  final parameter Integer nPumChiWatPri =
    if have_pumChiWatPri and have_pumPriHdr
    then nPumChiWatPri_select
    elseif have_pumChiWatPri and not have_pumPriHdr
    then nPumChiWatPriDedHp + nPumChiWatPriDedPhp
    else 0
    "Number of primary CHW pumps"
    annotation(Evaluate=true);
  parameter Integer nPumHeaWatSec_select(
    min=if have_pumHeaWatSec then 1 else 0,
    start=0)=nHp + nPhp
    "Number of secondary HW pumps"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration",
        enable=have_pumHeaWatSec));
  final parameter Integer nPumHeaWatSec =
    if have_pumHeaWatSec then nPumHeaWatSec_select else 0
    "Number of secondary HW pumps"
    annotation(Evaluate=true);
  parameter Integer nPumChiWatSec_select(
    min=if have_pumChiWatSec then 1 else 0,
    start=0)=nHp + nPhp
    "Number of secondary CHW pumps"
    annotation(Evaluate=true,
      Dialog(group="Plant configuration",
        enable=have_pumChiWatSec));
  final parameter Integer nPumChiWatSec =
    if have_pumChiWatSec then nPumChiWatSec_select else 0
    "Number of secondary CHW pumps"
    annotation(Evaluate=true);
  parameter Boolean have_senDpHeaWatRemWir(start=false)=false
    "Set to true for remote HW differential pressure sensor(s) hardwired to plant or pump controller"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=have_heaWat));
  parameter Integer nSenDpHeaWatRem(min=if have_heaWat then 1 else 0, start=0)
    "Number of remote HW differential pressure sensors used for HW pump speed control"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=have_heaWat and have_pumHeaWatSec));
  parameter Boolean have_senDpChiWatRemWir(start=false)=false
    "Set to true for remote CHW differential pressure sensor(s) hardwired to plant or pump controller"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=have_chiWat));
  parameter Integer nSenDpChiWatRem(min=if have_chiWat then 1 else 0, start=0)
    "Number of remote CHW differential pressure sensors used for CHW pump speed control"
    annotation(Evaluate=true,
      Dialog(group="Sensors",
        enable=have_chiWat));
  parameter Real THeaWatSup_nominal(
    min=273.15,
    start=50 + 273.15,
    unit="K",
    displayUnit="degC")
    "Design HW supply temperature (maximum setpoint)"
    annotation(Dialog(group="Information provided by designer",
      enable=have_heaWat));
  parameter Real THeaWatSupSet_min(
    min=273.15,
    start=25 + 273.15,
    unit="K",
    displayUnit="degC")
    "Minimum value to which the HW supply temperature can be reset"
    annotation(Dialog(group="Information provided by designer",
      enable=have_heaWat));
  parameter Real TOutHeaWatLck(
    min=273.15,
    start=21 + 273.15,
    unit="K",
    displayUnit="degC")=294.15
    "Outdoor air lockout temperature above which the HW loop is prevented from operating"
    annotation(Dialog(group="Information provided by designer",
      enable=have_heaWat));
  parameter Real capHeaHp_nominal[nHp](
    min=fill(0, nHp),
    start=fill(1, nHp),
    unit=fill("W", nHp))
    "Design heating capacity - Each heat pump"
    annotation(Dialog(group="Information provided by designer",
      enable=have_heaWat));
  parameter Real VHeaWatHp_flow_nominal[nHp](
    min=fill(0, nHp),
    start=fill(1E-6, nHp),
    unit=fill("m3/s", nHp))
    "Design HW volume flow rate - Each heat pump"
    annotation(Evaluate=true,
      Dialog(group="Information provided by designer",
        enable=have_heaWat and is_priOnl));
  parameter Real VHeaWatHp_flow_min[nHp](
    min=fill(0, nHp),
    start=fill(0, nHp),
    unit=fill("m3/s", nHp))
    "Minimum HW volume flow rate - Each heat pump"
    annotation(Evaluate=true,
      Dialog(group="Information provided by designer",
        enable=have_heaWat and is_priOnl));
  parameter Real capHeaPhp_nominal[nPhp](
    min=fill(0, nPhp),
    start=fill(1, nPhp),
    unit=fill("W", nPhp))
    "Design heating capacity - Each polyvalent heat pump"
    annotation(Dialog(group="Information provided by designer",
      enable=have_php));
  parameter Real capHeaShcPhp_nominal[nPhp](
    min=fill(0, nPhp),
    start=fill(1, nPhp),
    unit=fill("W", nPhp))
    "Design heating capacity in SHC mode - Each polyvalent heat pump"
    annotation(Dialog(group="Information provided by designer",
      enable=have_php));
  parameter Real VHeaWatPhp_flow_nominal[nPhp](
    min=fill(0, nPhp),
    start=fill(1E-6, nPhp),
    unit=fill("m3/s", nPhp))
    "Design HW volume flow rate - Each polyvalent heat pump"
    annotation(Evaluate=true,
      Dialog(group="Information provided by designer",
        enable=have_php and is_priOnl));
  parameter Real VHeaWatPhp_flow_min[nPhp](
    min=fill(0, nPhp),
    start=fill(0, nPhp),
    unit=fill("m3/s", nPhp))
    "Minimum HW volume flow rate - Each polyvalent heat pump"
    annotation(Evaluate=true,
      Dialog(group="Information provided by designer",
        enable=have_php and is_priOnl));
  parameter Real VHeaWatPri_flow_nominal(
    min=0,
    start=sum(VHeaWatHp_flow_nominal),
    unit="m3/s")=sum(VHeaWatHp_flow_nominal)
    "Primary HW volume flow rate"
    annotation(Evaluate=true,
      Dialog(group="Information provided by designer",
        enable=have_heaWat and is_priOnl and have_pumPriHdr));
  parameter Real VHeaWatSec_flow_nominal(
    min=0,
    start=1E-6,
    unit="m3/s")
    "Design secondary HW volume flow rate"
    annotation(Evaluate=true,
      Dialog(group="Information provided by designer",
        enable=have_heaWat and have_pumHeaWatSec and have_pumSecCtlDp));
  parameter Real dpHeaWatRemSet_max[nSenDpHeaWatRem](
    min=fill(0, nSenDpHeaWatRem),
    start=fill(5E4, nSenDpHeaWatRem),
    unit=fill("Pa", nSenDpHeaWatRem))
    "Maximum HW differential pressure setpoint - Remote sensor"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=have_heaWat and have_pumHeaWatSec));
  parameter Real dpHeaWatRemSet_min(
    min=0,
    start=5*6894,
    unit="Pa")=5*6894
    "Minimum value to which the HW differential pressure can be reset - Remote sensor"
    annotation(Dialog(group="Information provided by designer",
      enable=have_heaWat and have_pumHeaWatSec));
  parameter Real yPumHeaWatPriHdrSet(
    max=2,
    min=0,
    start=1,
    unit="1")
    "Primary HW pump speed providing design flow – Headered pumps"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=have_heaWat and not is_priOnl and have_pumHeaWatPriVar and have_pumPriHdr));
  parameter Real yPumHeaWatPriDedHpSet(
    max=2,
    min=0,
    start=1,
    unit="1")
    "Primary pump speed providing design flow in heating mode – HP dedicated pumps"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=have_heaWat and not is_priOnl and have_pumHeaWatPriVar and have_hp and not have_pumPriHdr));
  parameter Real yPumHeaWatPriDedPhpSet(
    max=2,
    min=0,
    start=1,
    unit="1")
    "Primary HW pump speed providing design flow – Polyvalent HP dedicated pumps"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=have_heaWat and not is_priOnl and have_pumHeaWatPriVar and
          have_php and not have_pumPriHdr));
  parameter Real TChiWatSup_nominal(
    min=273.15,
    start=7 + 273.15,
    unit="K",
    displayUnit="degC")
    "Design CHW supply temperature (minimum setpoint)"
    annotation(Dialog(group="Information provided by designer",
      enable=have_chiWat));
  parameter Real TChiWatSupSet_max(
    min=273.15,
    start=15 + 273.15,
    unit="K",
    displayUnit="degC")
    "Maximum value to which the CHW supply temperature can be reset"
    annotation(Dialog(group="Information provided by designer",
      enable=have_chiWat));
  parameter Real TOutChiWatLck(
    min=273.15,
    start=16 + 273.15,
    unit="K",
    displayUnit="degC")=289.15
    "Outdoor air lockout temperature below which the CHW loop is prevented from operating"
    annotation(Dialog(group="Information provided by designer",
      enable=have_chiWat));
  parameter Real capCooHp_nominal[nHp](
    min=fill(0, nHp),
    start=fill(1, nHp),
    unit=fill("W", nHp))
    "Design cooling capacity - Each heat pump"
    annotation(Dialog(group="Information provided by designer",
      enable=have_chiWat));
  parameter Real VChiWatHp_flow_nominal[nHp](
    min=fill(0, nHp),
    start=fill(1E-6, nHp),
    unit=fill("m3/s", nHp))
    "Design CHW volume flow rate - Each heat pump"
    annotation(Evaluate=true,
      Dialog(group="Information provided by designer",
        enable=have_chiWat and is_priOnl));
  parameter Real VChiWatHp_flow_min[nHp](
    min=fill(0, nHp),
    start=fill(0, nHp),
    unit=fill("m3/s", nHp))
    "Minimum CHW volume flow rate - Each heat pump"
    annotation(Evaluate=true,
      Dialog(group="Information provided by designer",
        enable=have_chiWat and is_priOnl));
  parameter Real capCooPhp_nominal[nPhp](
    min=fill(0, nPhp),
    start=fill(1, nPhp),
    unit=fill("W", nPhp))
    "Design cooling capacity - Each polyvalent heat pump"
    annotation(Dialog(group="Information provided by designer",
      enable=have_php));
  parameter Real capCooShcPhp_nominal[nPhp](
    min=fill(0, nPhp),
    start=fill(1, nPhp),
    unit=fill("W", nPhp))
    "Design cooling capacity in SHC mode - Each polyvalent heat pump"
    annotation(Dialog(group="Information provided by designer",
      enable=have_php));
  parameter Real VChiWatPhp_flow_nominal[nPhp](
    min=fill(0, nPhp),
    start=fill(1E-6, nPhp),
    unit=fill("m3/s", nPhp))
    "Design CHW volume flow rate - Each polyvalent heat pump"
    annotation(Evaluate=true,
      Dialog(group="Information provided by designer",
        enable=have_php and is_priOnl));
  parameter Real VChiWatPhp_flow_min[nPhp](
    min=fill(0, nPhp),
    start=fill(0, nPhp),
    unit=fill("m3/s", nPhp))
    "Minimum CHW volume flow rate - Each polyvalent heat pump"
    annotation(Evaluate=true,
      Dialog(group="Information provided by designer",
        enable=have_php and is_priOnl));
  parameter Real VChiWatPri_flow_nominal(
    min=0,
    start=sum(VChiWatHp_flow_nominal),
    unit="m3/s")=sum(VChiWatHp_flow_nominal)
    "Primary CHW volume flow rate"
    annotation(Evaluate=true,
      Dialog(group="Information provided by designer",
        enable=have_chiWat and is_priOnl and have_pumPriHdr));
  parameter Real VChiWatSec_flow_nominal(
    min=0,
    start=1E-6,
    unit="m3/s")
    "Design secondary CHW volume flow rate"
    annotation(Evaluate=true,
      Dialog(group="Information provided by designer",
        enable=have_pumChiWatSec and have_pumSecCtlDp));
  parameter Real dpChiWatRemSet_max[nSenDpChiWatRem](
    min=fill(0, nSenDpChiWatRem),
    start=fill(5E4, nSenDpChiWatRem),
    unit=fill("Pa", nSenDpChiWatRem))
    "Maximum CHW differential pressure setpoint - Remote sensor"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=have_pumChiWatSec));
  parameter Real dpChiWatRemSet_min(
    min=0,
    start=5*6894,
    unit="Pa")=5*6894
    "Minimum value to which the CHW differential pressure can be reset - Remote sensor"
    annotation(Dialog(group="Information provided by designer",
      enable=have_pumChiWatSec));
  parameter Real yPumChiWatPriHdrSet(
    max=2,
    min=0,
    start=1,
    unit="1") "Primary CHW pump speed providing design flow – Headered pumps"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=have_chiWat and not is_priOnl and have_pumChiWatPriVar and have_pumPriHdr));
  parameter Real yPumChiWatPriDedHpSet(
    max=2,
    min=0,
    start=1,
    unit="1") "Primary pump speed providing design flow in cooling mode – HP dedicated pumps"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=have_chiWat and not is_priOnl and have_pumChiWatPriVar and have_hp and not have_pumPriHdr));
  parameter Real yPumChiWatPriDedPhpSet(
    max=2,
    min=0,
    start=1,
    unit="1")
    "Primary CHW pump speed providing design flow – Polyvalent HP dedicated pumps"
    annotation(Dialog(
      group="Information provided by testing, adjusting, and balancing contractor",
      enable=have_chiWat and not is_priOnl and have_pumChiWatPriVar and
          have_php and not have_pumPriHdr));
  parameter Real cp_default(
    min=0,
    unit="J/(kg.K)")=4184
    "Default specific heat capacity used to compute required capacity"
    annotation(Evaluate=true,
      Dialog(group="Information provided by designer"));
  parameter Real rho_default(
    min=0,
    unit="kg/m3")=996
    "Default density used to compute required capacity"
    annotation(Evaluate=true,
      Dialog(group="Information provided by designer"));
  parameter Boolean have_inpSch = false
    "Set to true to provide schedule via software input point"
    annotation(Dialog(group="Plant enable"),
      Evaluate=true);
  parameter Real schHea[:, 2](start=[0,1; 24*3600,1])=[0,1; 24*3600,1]
    "Heating mode enable schedule"
    annotation(Dialog(enable=not have_inpSch,
      group="Plant enable"));
  parameter Real schCoo[:, 2](start=[0,1; 24*3600,1])=[0,1; 24*3600,1]
    "Cooling mode enable schedule"
    annotation(Dialog(enable=not have_inpSch,
      group="Plant enable"));
  parameter Integer nReqIgnHeaWat(min=0)=0
    "Number of ignored HW plant requests"
    annotation(Dialog(tab="Advanced",
      group="Plant enable"));
  parameter Integer nReqIgnChiWat(min=0)=0
    "Number of ignored CHW plant requests"
    annotation(Dialog(tab="Advanced",
      group="Plant enable"));
  parameter Real dTOutLck(
    min=0,
    unit="K")=0.5
    "Hysteresis for outdoor air lockout temperature"
    annotation(Dialog(tab="Advanced",
      group="Plant enable"));
  parameter Real dtRunEna(
    min=0,
    unit="s")=15*60
    "Minimum runtime of enable and disable states"
    annotation(Dialog(tab="Advanced",
      group="Plant enable"));
  parameter Real dtReqDis(
    min=0,
    unit="s")=3*60
    "Runtime with low number of request before disabling"
    annotation(Dialog(tab="Advanced",
      group="Plant enable"));
  final parameter Integer nStaHp = size(staHp, 1)
    "Number of stages in heat pump staging matrix"
    annotation(Evaluate=true);
  // We don't use a start attribute for staHp to avoid
  // incompatible sizes for variable and its start value.
  parameter Real staHp[:, :](
    each final max=1,
    each final min=0,
    each final unit="1") = {i / nHp for _ in 1:nHp, i in 1:nHp}
    "Heat pump staging matrix – Equipment required for each stage"
    annotation(Dialog(group="Equipment staging and rotation",
      enable=have_hp and not have_php));
  final parameter Integer nSta = if have_php then nHp + nPhp else nStaHp
    "Number of stages"
    annotation(Evaluate=true);
  final parameter Integer nAltHp(final min=0) =
    if have_hp and not have_php
    then (if nHp == 1
      then 1
      else max(
        {sum(
          {(if staHp[i, j] > 0 and staHp[i, j] < 1
          then 1 else 0) for j in 1:nHp}) for i in 1:nStaHp}))
    else nHp
    "Number of lead/lag alternate heat pumps"
    annotation(Evaluate=true);
  // We don't use a start attribute for idxAltHp_select to avoid
  // incompatible sizes for variable and its start value.
  parameter Integer idxAltHp_select[:](
    each final min=1) = 1:nHp
    "Indices of lead/lag alternate heat pumps"
    annotation(Evaluate=true,
      Dialog(group="Equipment staging and rotation",
        enable=have_hp and not have_php));
  final parameter Integer idxAltHp[:] =
    if have_hp and not have_php then idxAltHp_select else 1:nHp
    "Indices of lead/lag alternate heat pumps"
    annotation(Evaluate=true,
      Dialog(group="Equipment staging and rotation"));
  parameter Real plrSta(
    max=1,
    min=0,
    start=0.9,
    unit="1")=0.9
    "Staging part load ratio"
    annotation(Dialog(group="Equipment staging and rotation"));
  parameter Real dTHea(
    min=0,
    unit="K")=2.5
    "Delta-T triggering stage up command for heating applications (>0)"
    annotation(Dialog(tab="Advanced",
      group="Equipment staging and rotation",
      enable=have_heaWat));
  parameter Real dTCoo(
    min=0,
    unit="K")=1
    "Delta-T triggering stage up command for cooling applications (>0)"
    annotation(Dialog(tab="Advanced",
      group="Equipment staging and rotation",
      enable=have_chiWat));
  parameter Real dtVal(
    min=0,
    start=90,
    unit="s")=90
    "Nominal valve timing"
    annotation(Dialog(tab="Advanced",
      group="Equipment staging and rotation",
      enable=have_valHpInlIso or have_valHpOutIso));
  parameter Real dtRunSta(
    min=0,
    unit="s",
    displayUnit="min")=900
    "Minimum runtime of each stage"
    annotation(Dialog(tab="Advanced",
      group="Equipment staging and rotation"));
  parameter Real dtOff(
    min=0,
    unit="s")=900
    "Off time required before equipment is deemed available again"
    annotation(Dialog(tab="Advanced",
      group="Equipment staging and rotation"));
  parameter Real dtOffHp(
    min=0,
    unit="s")=180
    "Heat pump internal shutdown cycle timing (before closing isolation valves or disabling primary pumps)"
    annotation(Dialog(tab="Advanced",
      group="Equipment staging and rotation"));
  parameter Real dtPri(
    min=0,
    unit="s")=900
    "Runtime with high primary-setpoint Delta-T before staging up"
    annotation(Dialog(tab="Advanced",
      group="Equipment staging and rotation"));
  parameter Real dtSec(
    min=0,
    start=600,
    unit="s")=600
    "Runtime with high secondary-primary and secondary-setpoint Delta-T before staging up"
    annotation(Dialog(tab="Advanced",
      group="Equipment staging and rotation",
      enable=have_pumHeaWatSec or have_pumChiWatSec));
  parameter Real dtRunPumSta(
    min=0,
    start=600,
    unit="s")=600
    "Runtime before triggering stage change command based on efficiency condition"
    annotation(Dialog(tab="Advanced",
      group="Pump staging",
      enable=have_pumPriHdr and have_pumPriCtlDp
        or have_pumSecHdr and have_pumSecCtlDp));
  parameter Real dtRunFaiSafPumSta(
    min=0,
    start=300,
    unit="s")=300
    "Runtime before triggering stage change command based on failsafe condition"
    annotation(Dialog(tab="Advanced",
      group="Pump staging",
      enable=have_pumPriHdr and have_pumPriCtlDp
        or have_pumSecHdr and have_pumSecCtlDp));
  parameter Real dtRunFaiSafLowYPumSta(
    min=0,
    start=600,
    unit="s")=dtRunPumSta
    "Runtime before triggering stage change command based on low pump speed failsafe condition"
    annotation(Dialog(tab="Advanced",
      group="Pump staging",
      enable=have_pumPriHdr and have_pumPriCtlDp
        or have_pumSecHdr and have_pumSecCtlDp));
  parameter Real dVOffUpPumSta(
    max=1,
    min=0,
    start=0.03,
    unit="1")=0.03
    "Stage up flow point offset"
    annotation(Dialog(tab="Advanced",
      group="Pump staging",
      enable=have_pumPriHdr and have_pumPriCtlDp
        or have_pumSecHdr and have_pumSecCtlDp));
  parameter Real dVOffDowPumSta(
    max=1,
    min=0,
    start=0.03,
    unit="1")=dVOffUpPumSta
    "Stage down flow point offset"
    annotation(Dialog(tab="Advanced",
      group="Pump staging",
      enable=have_pumPriHdr and have_pumPriCtlDp
        or have_pumSecHdr and have_pumSecCtlDp));
  parameter Real dpOffPumSta(
    min=0,
    start=1E4,
    unit="Pa")=1E4
    "Stage change ∆p point offset (>0)"
    annotation(Dialog(tab="Advanced",
      group="Pump staging",
      enable=have_pumPriHdr and have_pumPriCtlDp
        or have_pumSecHdr and have_pumSecCtlDp));
  parameter Real yUpPumSta(
    min=0,
    start=0.99,
    unit="1")=0.99
    "Stage up pump speed point"
    annotation(Dialog(tab="Advanced",
      group="Pump staging",
      enable=have_pumPriHdr and have_pumPriCtlDp
        or have_pumSecHdr and have_pumSecCtlDp));
  parameter Real yDowPumSta(
    min=0,
    start=0.4,
    unit="1")=0.4
    "Stage down pump speed point"
    annotation(Dialog(tab="Advanced",
      group="Pump staging",
      enable=have_pumPriHdr and have_pumPriCtlDp
        or have_pumSecHdr and have_pumSecCtlDp));
  parameter Real dtHol(
    min=0,
    unit="s")=900
    "Minimum hold time during stage change"
    annotation(Dialog(tab="Advanced",
      group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec or have_pumChiWatSec));
  parameter Real resDpHeaWat_max(
    max=1,
    min=0,
    unit="1")=0.5
    "Upper limit of plant reset interval for HW differential pressure reset"
    annotation(Dialog(tab="Advanced",
      group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec));
  parameter Real resTHeaWatSup_min(
    max=1,
    min=0,
    unit="1")=resDpHeaWat_max
    "Lower limit of plant reset interval for HW supply temperature reset"
    annotation(Dialog(tab="Advanced",
      group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec));
  parameter Real resDpChiWat_max(
    max=1,
    min=0,
    unit="1")=0.5
    "Upper limit of plant reset interval for CHW differential pressure reset"
    annotation(Dialog(tab="Advanced",
      group="Plant reset",
      enable=have_pumChiWatSec));
  parameter Real resTChiWatSup_min(
    max=1,
    min=0,
    unit="1")=resDpChiWat_max
    "Lower limit of plant reset interval for CHW supply temperature reset"
    annotation(Dialog(tab="Advanced",
      group="Plant reset",
      enable=have_pumChiWatSec));
  parameter Real res_init(
    max=1,
    min=0,
    unit="1")=1
    "Initial reset value"
    annotation(Dialog(tab="Advanced",
      group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec or have_pumChiWatSec));
  parameter Real res_min(
    max=1,
    min=0,
    unit="1")=0
    "Minimum reset value"
    annotation(Dialog(tab="Advanced",
      group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec or have_pumChiWatSec));
  parameter Real res_max(
    max=1,
    min=0,
    unit="1")=1
    "Maximum reset value"
    annotation(Dialog(tab="Advanced",
      group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec or have_pumChiWatSec));
  parameter Real dtDel(
    min=100*1E-15,
    unit="s")=900
    "Delay time before the reset begins"
    annotation(Dialog(tab="Advanced",
      group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec or have_pumChiWatSec));
  parameter Real dtResHeaWat(
    min=1E-3,
    unit="s")=300
    "Time step for HW plant reset"
    annotation(Dialog(tab="Advanced",
      group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec));
  parameter Integer nReqResIgnHeaWat(min=0)=2
    "Number of ignored requests for HW plant reset"
    annotation(Dialog(tab="Advanced",
      group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec));
  parameter Real triHeaWat(
    max=0,
    unit="1")=-0.02
    "Trim amount for HW plant reset"
    annotation(Dialog(tab="Advanced",
      group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec));
  parameter Real rspHeaWat(
    min=0,
    unit="1")=0.03
    "Respond amount for HW plant reset"
    annotation(Dialog(tab="Advanced",
      group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec));
  parameter Real rspHeaWat_max(
    min=0,
    unit="1")=0.07
    "Maximum response per time interval for HW plant reset"
    annotation(Dialog(tab="Advanced",
      group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec));
  parameter Real dtResChiWat(
    min=1E-3,
    unit="s")=300
    "Time step for CHW plant reset"
    annotation(Dialog(tab="Advanced",
      group="Plant reset",
      enable=have_pumChiWatSec));
  parameter Integer nReqResIgnChiWat(min=0)=2
    "Number of ignored requests for CHW plant reset"
    annotation(Dialog(tab="Advanced",
      group="Plant reset",
      enable=have_pumChiWatSec));
  parameter Real triChiWat(
    max=0,
    unit="1")=-0.02
    "Trim amount for CHW plant reset"
    annotation(Dialog(tab="Advanced",
      group="Plant reset",
      enable=have_pumChiWatSec));
  parameter Real rspChiWat(
    min=0,
    unit="1")=0.03
    "Respond amount for CHW plant reset"
    annotation(Dialog(tab="Advanced",
      group="Plant reset",
      enable=have_pumChiWatSec));
  parameter Real rspChiWat_max(
    min=0,
    unit="1")=0.07
    "Maximum response per time interval for CHW plant reset"
    annotation(Dialog(tab="Advanced",
      group="Plant reset",
      enable=have_pumChiWatSec));
  parameter Real yPumHeaWatPri_min(
    max=1,
    min=0,
    start=0.1,
    unit="1")=0.1
    "Minimum primary HW pump speed"
    annotation(Dialog(tab="Advanced",
      group="Pump control",
      enable=have_heaWat and have_pumPriCtlDp));
  parameter Real kCtlDpHeaWat(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps,
    start=1)=1
    "Gain of controller for HW loop ∆p control"
    annotation(Dialog(tab="Advanced",
      group="Loop differential pressure",
      enable=have_heaWat));
  parameter Real TiCtlDpHeaWat(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps,
    start=60,
    unit="s")=60
    "Time constant of integrator block for HW loop ∆p control"
    annotation(Dialog(tab="Advanced",
      group="Loop differential pressure",
      enable=have_heaWat));
  parameter Real yPumChiWatPri_min(
    max=1,
    min=0,
    start=0.1,
    unit="1")=0.1
    "Minimum primary CHW pump speed"
    annotation(Dialog(tab="Advanced",
      group="Pump control",
      enable=have_pumChiWatPri and have_pumPriCtlDp));
  parameter Real kCtlDpChiWat(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps,
    start=1)=1
    "Gain of controller for CHW loop ∆p control"
    annotation(Dialog(tab="Advanced",
      group="Loop differential pressure",
      enable=have_chiWat));
  parameter Real TiCtlDpChiWat(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps,
    start=60,
    unit="s")=60
    "Time constant of integrator block for CHW loop ∆p control"
    annotation(Dialog(tab="Advanced",
      group="Loop differential pressure",
      enable=have_chiWat));
  parameter Real yPumHeaWatSec_min(
    max=1,
    min=0,
    start=0.1,
    unit="1")=0.1
    "Minimum secondary HW pump speed"
    annotation(Dialog(tab="Advanced",
      group="Pump control",
      enable=have_pumHeaWatSec));
  parameter Real yPumChiWatSec_min(
    max=1,
    min=0,
    start=0.1,
    unit="1")=0.1
    "Minimum secondary CHW pump speed"
    annotation(Dialog(tab="Advanced",
      group="Pump control",
      enable=have_pumChiWatSec));
  parameter Real kValMinByp(
    min=0,
    start=1)=1
    "Gain of controller"
    annotation(Dialog(tab="Advanced",
      group="Minimum flow control",
      enable=is_priOnl));
  parameter Modelica.Units.SI.Time TiValMinByp(
    min=Buildings.Controls.OBC.CDL.Constants.small,
    start=0.5)=60
    "Time constant of integrator block"
    annotation(Dialog(tab="Advanced",
      group="Minimum flow control",
      enable=is_priOnl));
  // Sidestream HRC parameters
  parameter Boolean have_reqFloHrc(start=false)=false
    "Set to true if HRC provides flow request point via network interface"
    annotation(Evaluate=true,
      Dialog(tab="Advanced",
        group="Sidestream HRC",
        enable=have_hrc));
  parameter Real TChiWatSupHrc_min(
    min=273.15,
    start=4 + 273.15,
    unit="K",
    displayUnit="degC")
    "Sidestream HRC – Minimum allowable CHW supply temperature"
    annotation(Dialog(group="Information provided by designer",
      enable=have_hrc));
  parameter Real THeaWatSupHrc_max(
    min=273.15,
    start=60 + 273.15,
    unit="K",
    displayUnit="degC")
    "Sidestream HRC – Maximum allowable HW supply temperature"
    annotation(Dialog(group="Information provided by designer",
      enable=have_hrc));
  parameter Real COPHeaHrc_nominal(
    min=1.1,
    start=2.8,
    unit="1")
    "Sidestream HRC – Heating COP at design heating conditions"
    annotation(Dialog(group="Information provided by designer",
      enable=have_hrc));
  parameter Real capCooHrc_min(
    min=0,
    start=0,
    unit="W")
    "Sidestream HRC – Minimum cooling capacity below which cycling occurs"
    annotation(Dialog(group="Information provided by designer",
      enable=have_hrc));
  parameter Real capHeaHrc_min(
    min=0,
    start=0,
    unit="W")
    "Sidestream HRC – Minimum heating capacity below which cycling occurs"
    annotation(Dialog(group="Information provided by designer",
      enable=have_hrc));
  parameter Real dtLoaHrc(
    min=0,
    start=600,
    unit="s")=600
    "Runtime with sufficient load before enabling"
    annotation(Dialog(tab="Advanced",
      group="Sidestream HRC",
      enable=have_hrc));
  parameter Real dtTem1Hrc(
    min=0,
    start=180,
    unit="s")=180
    "Runtime with first temperature threshold exceeded before disabling"
    annotation(Dialog(tab="Advanced",
      group="Sidestream HRC",
      enable=have_hrc));
  parameter Real dtTem2Hrc(
    min=0,
    start=60,
    unit="s")=60
    "Runtime with second temperature threshold exceeded before disabling"
    annotation(Dialog(tab="Advanced",
      group="Sidestream HRC",
      enable=have_hrc));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1AvaHp[nHp](each k=true)
    "Heat pump available signal – Block does not handle faulted equipment yet"
    annotation(Placement(transformation(extent={{-240,270},{-220,290}}),
      iconTransformation(extent={{-240,220},{-200,260}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReqPlaHeaWat
    if have_heaWat
    "Number of HW plant requests"
    annotation(Placement(transformation(extent={{-300,320},{-260,360}}),
      iconTransformation(extent={{-240,60},{-200,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")
    "Outdoor air temperature"
    annotation(Placement(transformation(extent={{-300,60},{-260,100}}),
      iconTransformation(extent={{-240,-20},{-200,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SchHea
    if have_heaWat and have_inpSch
    "Heating mode enable via schedule"
    annotation(Placement(transformation(extent={{-300,360},{-260,400}}),
      iconTransformation(extent={{-240,380},{-200,420}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReqPlaChiWat
    if have_chiWat
    "Number of CHW plant requests"
    annotation(Placement(transformation(extent={{-300,300},{-260,340}}),
      iconTransformation(extent={{-240,40},{-200,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SchCoo
    if have_chiWat and have_inpSch
    "Cooling mode enable via schedule"
    annotation(Placement(transformation(extent={{-300,340},{-260,380}}),
      iconTransformation(extent={{-240,360},{-200,400}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReqResHeaWat
    if have_heaWat
    "Sum of HW reset requests of all heating loads served"
    annotation(Placement(transformation(extent={{-300,-420},{-260,-380}}),
      iconTransformation(extent={{-240,20},{-200,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReqResChiWat
    if have_chiWat
    "Sum of CHW reset requests of all heating loads served"
    annotation(Placement(transformation(extent={{-300,-440},{-260,-400}}),
      iconTransformation(extent={{-240,0},{-200,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Php_actual[nPhp]
    if have_php
    "Polyvalent heat pump status"
    annotation(Placement(transformation(extent={{-300,420},{-260,460}}),
      iconTransformation(extent={{-240,300},{-200,340}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPriDedPhp_actual[nPumHeaWatPriDedPhp]
    if have_pumHeaWatPri and not have_pumPriHdr and have_php
    "Primary HW pump status"
    annotation(Placement(transformation(extent={{-300,180},{-260,220}}),
      iconTransformation(extent={{-240,240},{-200,280}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPriHdr_actual[nPumChiWatPri]
    if have_pumChiWatPri and have_pumPriHdr
    "Primary CHW pump status – Headered pumps"
    annotation(Placement(transformation(extent={{-300,160},{-260,200}}),
      iconTransformation(extent={{-240,220},{-200,260}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatSec_actual[nPumHeaWatSec]
    if have_pumHeaWatSec
    "Secondary HW pump status"
    annotation(Placement(transformation(extent={{-300,100},{-260,140}}),
      iconTransformation(extent={{-240,160},{-200,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatSec_actual[nPumChiWatSec]
    if have_pumChiWatSec
    "Secondary CHW pump status"
    annotation(Placement(transformation(extent={{-300,80},{-260,120}}),
      iconTransformation(extent={{-240,140},{-200,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatPriRet(
    final unit="K",
    displayUnit="degC")
    if have_heaWat and have_senTHeaWatPriRet
    "Primary HW return temperature"
    annotation(Placement(transformation(extent={{-300,20},{-260,60}}),
      iconTransformation(extent={{-240,-60},{-200,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHeaWatPri_flow(
    final unit="m3/s")
    if have_heaWat and have_senVHeaWatPri
    "Primary HW volume flow rate"
    annotation(Placement(transformation(extent={{-300,0},{-260,40}}),
      iconTransformation(extent={{-240,-80},{-200,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatLoc(final unit="Pa")
    if have_heaWat and not have_senDpHeaWatRemWir
    "Local HW differential pressure"
    annotation(Placement(transformation(extent={{-300,-280},{-260,-240}}),
      iconTransformation(extent={{-240,-360},{-200,-320}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatLocSet[nSenDpHeaWatRem](
    each final unit="Pa")
    if have_heaWat and not have_senDpHeaWatRemWir
    "Local HW differential pressure setpoint output from each of the remote loops"
    annotation(Placement(transformation(extent={{-300,-260},{-260,-220}}),
      iconTransformation(extent={{-240,-340},{-200,-300}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatRem[nSenDpHeaWatRem](
    each final unit="Pa")
    if have_heaWat and have_senDpHeaWatRemWir
    "Remote HW differential pressure"
    annotation(Placement(transformation(extent={{-300,-240},{-260,-200}}),
      iconTransformation(extent={{-240,-320},{-200,-280}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatLoc(final unit="Pa")
    if have_chiWat and not have_senDpChiWatRemWir
    "Local CHW differential pressure"
    annotation(Placement(transformation(extent={{-300,-340},{-260,-300}}),
      iconTransformation(extent={{-240,-420},{-200,-380}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatLocSet[nSenDpChiWatRem](
    each final unit="Pa")
    if have_chiWat and not have_senDpChiWatRemWir
    "Local CHW differential pressure setpoint output from each of the remote loops"
    annotation(Placement(transformation(extent={{-300,-320},{-260,-280}}),
      iconTransformation(extent={{-240,-400},{-200,-360}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatRem[nSenDpChiWatRem](
    each final unit="Pa")
    if have_chiWat and have_senDpChiWatRemWir
    "Remote CHW differential pressure"
    annotation(Placement(transformation(extent={{-300,-300},{-260,-260}}),
      iconTransformation(extent={{-240,-380},{-200,-340}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatHpInlIso[nHp]
    if have_heaWat and have_valHpInlIso
    "Heat pump inlet HW isolation valve command"
    annotation(Placement(transformation(extent={{260,380},{300,420}}),
      iconTransformation(extent={{200,380},{240,420}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatHpOutIso[nHp]
    if have_heaWat and have_valHpOutIso
    "Heat pump outlet HW isolation valve command"
    annotation(Placement(transformation(extent={{260,360},{300,400}}),
      iconTransformation(extent={{200,360},{240,400}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatHpInlIso[nHp]
    if have_chiWat and have_valHpInlIso
    "Heat pump inlet CHW isolation valve command"
    annotation(Placement(transformation(extent={{260,340},{300,380}}),
      iconTransformation(extent={{200,340},{240,380}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatHpOutIso[nHp]
    if have_chiWat and have_valHpOutIso
    "Heat pump outlet CHW isolation valve command"
    annotation(Placement(transformation(extent={{260,320},{300,360}}),
      iconTransformation(extent={{200,320},{240,360}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatPriHdr[nPumHeaWatPri]
    if have_pumHeaWatPri and have_pumPriHdr
    "Primary HW pump start command – Headered pumps"
    annotation(Placement(transformation(extent={{260,220},{300,260}}),
      iconTransformation(extent={{200,180},{240,220}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatPriHdr[nPumChiWatPri]
    if have_pumChiWatPri and have_pumPriHdr
    "Primary CHW pump start command – Headered pumps"
    annotation(Placement(transformation(extent={{260,160},{300,200}}),
      iconTransformation(extent={{200,120},{240,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatSec[nPumHeaWatSec]
    if have_pumHeaWatSec
    "Secondary HW pump start command"
    annotation(Placement(transformation(extent={{260,100},{300,140}}),
      iconTransformation(extent={{200,60},{240,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatSec[nPumChiWatSec]
    if have_pumChiWatSec
    "Secondary CHW pump start command"
    annotation(Placement(transformation(extent={{260,80},{300,120}}),
      iconTransformation(extent={{200,40},{240,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hp[nHp]
    if have_hp
    "Heat pump enable command"
    annotation(Placement(transformation(extent={{260,460},{300,500}}),
      iconTransformation(extent={{200,420},{240,460}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HeaHp[nHp]
    if have_hp and have_heaWat and have_chiWat
    "Heat pump heating/cooling mode command: true=heating, false=cooling"
    annotation(Placement(transformation(extent={{260,440},{300,480}}),
      iconTransformation(extent={{200,400},{240,440}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HeaPhp[nPhp]
    if have_php
    "Polyvalent HP heating on/off command"
    annotation(Placement(transformation(extent={{260,420},{300,460}}),
      iconTransformation(extent={{200,300},{240,340}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1CooPhp[nPhp]
    if have_php
    "Polyvalent HP cooling on/off command"
    annotation(Placement(transformation(extent={{260,400},{300,440}}),
      iconTransformation(extent={{200,280},{240,320}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatPhpInlIso[nPhp]
    if have_php and have_valPhpInlIso
    "Polyvalent HP inlet HW isolation valve command"
    annotation(Placement(transformation(extent={{260,300},{300,340}}),
      iconTransformation(extent={{200,260},{240,300}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatPhpInlIso[nPhp]
    if have_php and have_valPhpInlIso
    "Polyvalent HP inlet CHW isolation valve command"
    annotation(Placement(transformation(extent={{260,260},{300,300}}),
      iconTransformation(extent={{200,220},{240,260}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatPhpOutIso[nPhp]
    if have_php and have_valPhpOutIso
    "Polyvalent HP outlet HW isolation valve command"
    annotation(Placement(transformation(extent={{260,280},{300,320}}),
      iconTransformation(extent={{200,240},{240,280}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatPhpOutIso[nPhp]
    if have_php and have_valPhpOutIso
    "Polyvalent HP outlet CHW isolation valve command"
    annotation(Placement(transformation(extent={{260,240},{300,280}}),
      iconTransformation(extent={{200,200},{240,240}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpHeaWatRemSet[nSenDpHeaWatRem](
    each final min=0,
    each final unit="Pa")
    if have_heaWat
    "HW differential pressure setpoint"
    annotation(Placement(transformation(extent={{260,-100},{300,-60}}),
      iconTransformation(extent={{200,-180},{240,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpChiWatRemSet[nSenDpChiWatRem](
    each final min=0,
    each final unit="Pa")
    if have_chiWat
    "CHW differential pressure setpoint"
    annotation(Placement(transformation(extent={{260,-120},{300,-80}}),
      iconTransformation(extent={{200,-200},{240,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumHeaWatPriHdr(
    final unit="1")
    if have_pumHeaWatPriVar and have_pumPriHdr
    "Primary HW pump speed command – Headered pumps"
    annotation(Placement(transformation(extent={{260,60},{300,100}}),
      iconTransformation(extent={{200,20},{240,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumChiWatPriHdr(
    final unit="1")
    if have_pumChiWatPriVar and have_pumPriHdr
    "Primary CHW pump speed command – Headered pumps"
    annotation(Placement(transformation(extent={{260,40},{300,80}}),
      iconTransformation(extent={{200,0},{240,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumHeaWatSec(final unit="1")
    if have_pumHeaWatSec
    "Primary HW pump speed command"
    annotation(Placement(transformation(extent={{260,-60},{300,-20}}),
      iconTransformation(extent={{200,-100},{240,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumChiWatSec(final unit="1")
    if have_pumChiWatSec
    "Primary CHW pump speed command"
    annotation(Placement(transformation(extent={{260,-80},{300,-40}}),
      iconTransformation(extent={{200,-120},{240,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiWatSupSet(
    final unit="K",
    displayUnit="degC")
    if have_chiWat
    "Plant CHW supply temperature setpoint"
    annotation(Placement(transformation(extent={{260,-240},{300,-200}}),
      iconTransformation(extent={{200,-320},{240,-280}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaWatSupSet(
    final unit="K",
    displayUnit="degC")
    if have_heaWat
    "Plant HW supply temperature setpoint"
    annotation(Placement(transformation(extent={{260,-220},{300,-180}}),
      iconTransformation(extent={{200,-300},{240,-260}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatPriRet(
    final unit="K",
    displayUnit="degC")
    if have_chiWat and have_senTChiWatPriRet
    "Primary CHW return temperature"
    annotation(Placement(transformation(extent={{-300,-40},{-260,0}}),
      iconTransformation(extent={{-240,-120},{-200,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWatPri_flow(
    final unit="m3/s")
    if have_chiWat and have_senVChiWatPri
    "Primary CHW volume flow rate"
    annotation(Placement(transformation(extent={{-300,-60},{-260,-20}}),
      iconTransformation(extent={{-240,-140},{-200,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hp_actual[nHp]
    "Heat pump status"
    annotation(Placement(transformation(extent={{-300,280},{-260,320}}),
      iconTransformation(extent={{-240,320},{-200,360}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumHeaWatPriDedHp[nPumHeaWatPriDedHp](
    each final unit="1")
    if have_pumHeaWatPriVar and not have_pumPriHdr and have_hp
    "Primary HW pump speed command – HP dedicated pumps"
    annotation(Placement(transformation(extent={{260,20},{300,60}}),
      iconTransformation(extent={{200,-20},{240,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumChiWatPriDedHp[nPumChiWatPriDedHp](
    each final unit="1")
    if have_pumChiWatPriVar and have_pumChiWatPriDedHp
    "Primary CHW pump speed command – HP dedicated pumps"
    annotation(Placement(transformation(extent={{260,-20},{300,20}}),
      iconTransformation(extent={{200,-60},{240,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSecRet(
    final unit="K",
    displayUnit="degC")
    if have_heaWat and have_senTHeaWatSecRet
    "Secondary HW return temperature"
    annotation(Placement(transformation(extent={{-300,-100},{-260,-60}}),
      iconTransformation(extent={{-240,-180},{-200,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHeaWatSec_flow(
    final unit="m3/s")
    if have_heaWat and have_senVHeaWatSec
    "Secondary HW volume flow rate"
    annotation(Placement(transformation(extent={{-300,-140},{-260,-100}}),
      iconTransformation(extent={{-240,-220},{-200,-180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSecRet(
    final unit="K",
    displayUnit="degC")
    if have_chiWat and have_senTChiWatSecRet
    "Secondary CHW return temperature"
    annotation(Placement(transformation(extent={{-300,-180},{-260,-140}}),
      iconTransformation(extent={{-240,-260},{-200,-220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWatSec_flow(
    final unit="m3/s")
    if have_chiWat and have_senVChiWatSec
    "Secondary CHW volume flow rate"
    annotation(Placement(transformation(extent={{-300,-220},{-260,-180}}),
      iconTransformation(extent={{-240,-300},{-200,-260}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaWatSupHpSet[nHp](
    each final unit="K",
    each final quantity="ThermodynamicTemperature",
    each displayUnit="degC") if have_heaWat and have_hp
    "HP HW supply temperature setpoint"
    annotation(Placement(transformation(extent={{260,-140},{300,-100}}),
      iconTransformation(extent={{200,-220},{240,-180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatPriSup(
    final unit="K",
    displayUnit="degC")
    if have_heaWat
    "Primary HW supply temperature"
    annotation(Placement(transformation(extent={{-300,40},{-260,80}}),
      iconTransformation(extent={{-240,-40},{-200,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatPriSup(
    final unit="K",
    displayUnit="degC")
    if have_chiWat
    "Primary CHW return temperature"
    annotation(Placement(transformation(extent={{-300,-20},{-260,20}}),
      iconTransformation(extent={{-240,-100},{-200,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSecSup(
    final unit="K",
    displayUnit="degC")
    if have_heaWat and have_senTHeaWatSecSup
    "Secondary HW supply temperature"
    annotation(Placement(transformation(extent={{-300,-80},{-260,-40}}),
      iconTransformation(extent={{-240,-160},{-200,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSecSup(
    final unit="K",
    displayUnit="degC")
    if have_chiWat and have_senTChiWatSecSup
    "Secondary CHW return temperature"
    annotation(Placement(transformation(extent={{-300,-160},{-260,-120}}),
      iconTransformation(extent={{-240,-240},{-200,-200}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hrc
    if have_hrc
    "Sidestream HRC enable command"
    annotation(Placement(transformation(extent={{260,-300},{300,-260}}),
      iconTransformation(extent={{200,-340},{240,-300}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1CooHrc
    if have_hrc
    "Sidestream HRC mode command: true for cooling, false for heating"
    annotation(Placement(transformation(extent={{260,-320},{300,-280}}),
      iconTransformation(extent={{200,-360},{240,-320}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatHrc
    if have_hrc
    "Sidestream HRC CHW pump enable command"
    annotation(Placement(transformation(extent={{260,-380},{300,-340}}),
      iconTransformation(extent={{200,-380},{240,-340}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatHrc
    if have_hrc
    "Sidestream HRC HW pump enable command"
    annotation(Placement(transformation(extent={{260,-400},{300,-360}}),
      iconTransformation(extent={{200,-400},{240,-360}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaWatSupHrcSet(
    final unit="K",
    displayUnit="degC")
    if have_hrc
    "Sidestream HRC HW supply temperature setpoint"
    annotation(Placement(transformation(extent={{260,-340},{300,-300}}),
      iconTransformation(extent={{200,-420},{240,-380}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRetUpsHrc(
    final unit="K",
    displayUnit="degC")
    if have_hrc
    "CHW return temperature upstream of HRC"
    annotation(Placement(transformation(extent={{-300,-200},{-260,-160}}),
      iconTransformation(extent={{-240,-280},{-200,-240}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatRetUpsHrc(
    final unit="K",
    displayUnit="degC")
    if have_hrc
    "HW return temperature upstream of HRC"
    annotation(Placement(transformation(extent={{-300,-120},{-260,-80}}),
      iconTransformation(extent={{-240,-200},{-200,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hrc_actual
    if have_hrc
    "HRC status"
    annotation(Placement(transformation(extent={{-300,-360},{-260,-320}}),
      iconTransformation(extent={{-240,120},{-200,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ReqFloChiWat
    if have_hrc and have_reqFloHrc
    "CHW flow request from HRC"
    annotation(Placement(transformation(extent={{-300,-380},{-260,-340}}),
      iconTransformation(extent={{-240,100},{-200,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ReqFloConWat
    if have_hrc and have_reqFloHrc
    "CW flow request from HRC"
    annotation(Placement(transformation(extent={{-300,-400},{-260,-360}}),
      iconTransformation(extent={{-240,80},{-200,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValHeaWatMinByp(
    final unit="1")
    if have_heaWat and is_priOnl
    "HW minimum flow bypass valve command"
    annotation(Placement(transformation(extent={{260,-260},{300,-220}}),
      iconTransformation(extent={{200,-140},{240,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValChiWatMinByp(
    final unit="1")
    if have_chiWat and is_priOnl
    "CHW minimum flow bypass valve command"
    annotation(Placement(transformation(extent={{260,-280},{300,-240}}),
      iconTransformation(extent={{200,-160},{240,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiWatSupHpSet[nHp](
    each final unit="K",
    each final quantity="ThermodynamicTemperature",
    each displayUnit="degC") if have_chiWat and have_hp
    "HP CHW supply temperature setpoint"
    annotation(Placement(transformation(extent={{260,-160},{300,-120}}),
      iconTransformation(extent={{200,-240},{240,-200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiWatSupHrcSet(
    final unit="K",
    displayUnit="degC")
    if have_hrc
    "Sidestream HRC CHW supply temperature setpoint"
    annotation(Placement(transformation(extent={{260,-360},{300,-320}}),
      iconTransformation(extent={{200,-440},{240,-400}})));
  Enabling.Enable enaHea(
    final typ=Buildings.Templates.Plants.Controls.Types.Application.Heating,
    final TOutLck=TOutHeaWatLck,
    final dTOutLck=dTOutLck,
    final dtReq=dtReqDis,
    final dtRun=dtRunEna,
    final have_inpSch=have_inpSch,
    final nReqIgn=nReqIgnHeaWat,
    final sch=schHea)
    if have_heaWat
    "Heating mode enable"
    annotation(Placement(transformation(extent={{-110,350},{-90,370}})));
  Utilities.StageIndex idxStaHea(
    final use_twoMod=have_php,
    final nSta=nSta,
    final dtRun=dtRunSta)
    if have_heaWat
    "Compute heating stage index"
    annotation(Placement(transformation(extent={{-10,350},{10,370}})));
  StagingRotation.StageAvailability avaStaHea(
    final have_php=have_php,
    final staEqu=if have_php then staPhp.staHea else staHp)
    if have_heaWat
    "Evaluate heating stage availability"
    annotation(Placement(transformation(extent={{-110,320},{-90,340}})));
  PolyvalentHeatPumps.EquipmentEnable enaEquHea(
    final nStaHp=nStaHp,
    final staHp=staHp,
    final nHp=nHp,
    final nAltHp_select=nAltHp,
    final nPhp=nPhp) if have_heaWat
    "Compute enable command for equipment in heating mode"
    annotation (Placement(transformation(extent={{40,350},{60,370}})));
  StagingRotation.EventSequencingHeatPumps seqEve[nHp + nPhp](
    final is_php={i > nHp for i in 1:nHp + nPhp},
    each final have_heaWat=have_heaWat,
    each final have_chiWat=have_chiWat,
    final have_valInlIso={if i <= nHp
    then have_valHpInlIso else have_valPhpInlIso for i in 1:nHp + nPhp},
    final have_valOutIso={if i <= nHp
    then have_valHpOutIso else have_valPhpOutIso for i in 1:nHp + nPhp},
    each final have_pumHeaWatPri=have_pumHeaWatPri,
    final have_pumChiWatPri={if i <= nHp
    then have_pumPriHdr or have_pumChiWatPriDedHp else true for i in 1:nHp +
      nPhp},
    each final have_pumHeaWatSec=have_pumHeaWatSec,
    each final have_pumChiWatSec=have_pumChiWatSec,
    each final dtVal=dtVal,
    each final dtOff=dtOffHp)
    "Event sequencing"
    annotation(Placement(transformation(extent={{140,284},{160,312}})));
  StagingRotation.StageAvailability avaStaCoo(
    final have_php=have_php,
    final staEqu=if have_php then staPhp.staCoo else staHp)
    if have_chiWat
    "Evaluate cooling stage availability"
    annotation(Placement(transformation(extent={{-110,60},{-90,80}})));
  StagingRotation.StageChangeCommand chaStaHea(
    typ=Buildings.Templates.Plants.Controls.Types.Application.Heating,
    final have_php=have_php,
    final have_pumSec=have_pumHeaWatSec,
    final have_inpPlrSta=false,
    final plrSta=plrSta,
    final staEqu=if have_php then staPhp.staHea else staHp,
    final capEqu={if i <= nHp then capHeaHp_nominal[i] elseif i <= nHp + nPhp
         then capHeaPhp_nominal[i - nHp] else capHeaShcPhp_nominal[i - nHp -
        nPhp] for i in 1:nHp + 2*nPhp},
    final dtRun=dtRunSta,
    final cp_default=cp_default,
    final rho_default=rho_default,
    final dT=dTHea,
    final dtPri=dtPri,
    final dtSec=dtSec)
    if have_heaWat
    "Generate heating stage transition command"
    annotation(Placement(transformation(extent={{-40,306},{-20,334}})));
  Enabling.Enable enaCoo(
    final typ=Buildings.Templates.Plants.Controls.Types.Application.Cooling,
    final TOutLck=TOutChiWatLck,
    final dTOutLck=dTOutLck,
    final dtReq=dtReqDis,
    final dtRun=dtRunEna,
    final have_inpSch=have_inpSch,
    final nReqIgn=nReqIgnChiWat,
    final sch=schCoo)
    if have_chiWat
    "Cooling mode enable"
    annotation(Placement(transformation(extent={{-110,90},{-90,110}})));
  StagingRotation.StageChangeCommand chaStaCoo(
    final typ=Buildings.Templates.Plants.Controls.Types.Application.Cooling,
    final have_php=have_php,
    final have_pumSec=have_pumChiWatSec,
    final have_inpPlrSta=false,
    final plrSta=plrSta,
    final staEqu=if have_php then staPhp.staCoo else staHp,
    final capEqu={if i <= nHp
    then capCooHp_nominal[i]
    elseif i <= nHp + nPhp
    then capCooPhp_nominal[i - nHp]
    else capCooShcPhp_nominal[i - nHp - nPhp] for i in 1:nHp + 2 * nPhp},
    final dtRun=dtRunSta,
    final cp_default=cp_default,
    final rho_default=rho_default,
    final dT=dTCoo,
    final dtPri=dtPri,
    final dtSec=dtSec)
    if have_chiWat
    "Generate cooling stage transition command"
    annotation(Placement(transformation(extent={{-40,46},{-20,74}})));
  Utilities.StageIndex idxStaCoo(
    final use_twoMod=have_php,
    final nSta=nSta,
    final dtRun=dtRunSta)
    if have_chiWat
    "Compute cooling stage index"
    annotation(Placement(transformation(extent={{-10,90},{10,110}})));
  PolyvalentHeatPumps.EquipmentEnable enaEquCoo(
    final nStaHp=nStaHp,
    final staHp=staHp,
    final nHp=nHp,
    final nAltHp_select=nAltHp,
    final nPhp=nPhp) if have_chiWat
    "Compute enable command for equipment in cooling mode"
    annotation (Placement(transformation(extent={{50,90},{70,110}})));
  StagingRotation.EquipmentAvailability avaHeaCooHp[nHp](
    each final have_heaWat=have_heaWat,
    each final have_chiWat=have_chiWat,
    each final dtOff=dtOff)
    if have_hp
    "Evaluate HP availability in heating or cooling mode"
    annotation(Placement(transformation(extent={{-150,230},{-130,250}})));
  StagingRotation.SortRuntime sorRunTimHp(final idxEquAlt=idxAltHp, nin=nHp)
    "Sort lead/lag alternate HP by staging runtime"
    annotation(Placement(transformation(extent={{-150,260},{-130,280}})));
  Pumps.Generic.StagingHeadered staPumHeaWatPri(
    final is_pri=true,
    final is_ctlDp=have_pumPriCtlDp,
    final have_valInlIso=if have_hp
      then have_valHpInlIso else have_valPhpInlIso,
    final have_valOutIso=if have_hp
      then have_valHpOutIso else have_valPhpOutIso,
    final nEqu=nHp + nPhp,
    final nPum=nPumHeaWatPri,
    final is_hdr=have_pumPriHdr,
    final dtRun=dtRunPumSta,
    final dVOffUp=dVOffUpPumSta,
    final dVOffDow=dVOffDowPumSta,
    final nSenDp=if have_senDpHeaWatRemWir then nSenDpHeaWatRem else 1,
    final V_flow_nominal=VHeaWatPri_flow_nominal,
    final dtRunFaiSaf=dtRunFaiSafPumSta,
    final dtRunFaiSafLowY=dtRunFaiSafLowYPumSta,
    final dpOff=dpOffPumSta,
    final yUp=yUpPumSta,
    final yDow=yDowPumSta)
    if have_pumHeaWatPri
    "Primary HW pump staging"
    annotation(Placement(transformation(extent={{140,190},{160,210}})));
  Pumps.Generic.StagingHeadered staPumChiWatPri(
    final is_pri=true,
    final is_ctlDp=have_pumPriCtlDp,
    final have_valInlIso=if have_hp
      then have_valHpInlIso else have_valPhpInlIso,
    final have_valOutIso=if have_hp
      then have_valHpOutIso else have_valPhpOutIso,
    final nEqu=nHp + nPhp,
    final nPum=nPumChiWatPri,
    final is_hdr=have_pumPriHdr,
    final dtRun=dtRunPumSta,
    final dVOffUp=dVOffUpPumSta,
    final dVOffDow=dVOffDowPumSta,
    final nSenDp=if have_senDpChiWatRemWir then nSenDpChiWatRem else 1,
    final V_flow_nominal=VChiWatPri_flow_nominal,
    final dtRunFaiSaf=dtRunFaiSafPumSta,
    final dtRunFaiSafLowY=dtRunFaiSafLowYPumSta,
    final dpOff=dpOffPumSta,
    final yUp=yUpPumSta,
    final yDow=yDowPumSta)
    if have_pumChiWatPri
    "Primary CHW pump staging"
    annotation(Placement(transformation(extent={{190,170},{210,190}})));
  Pumps.Generic.StagingHeadered staPumChiWatSec(
    final is_pri=false,
    final nEqu=nHp + nPhp,
    final nPum=nPumChiWatSec,
    final is_hdr=have_pumSecHdr,
    final is_ctlDp=have_pumSecCtlDp,
    final nSenDp=if have_senDpChiWatRemWir then nSenDpChiWatRem else 1,
    final V_flow_nominal=VChiWatSec_flow_nominal,
    final dtRun=dtRunPumSta,
    final dtRunFaiSaf=dtRunFaiSafPumSta,
    final dtRunFaiSafLowY=dtRunFaiSafLowYPumSta,
    final dVOffUp=dVOffUpPumSta,
    final dVOffDow=dVOffDowPumSta,
    final dpOff=dpOffPumSta,
    final yUp=yUpPumSta,
    final yDow=yDowPumSta)
    if have_pumChiWatSec
    "Secondary CHW pump staging"
    annotation(Placement(transformation(extent={{190,130},{210,150}})));
  Pumps.Generic.StagingHeadered staPumHeaWatSec(
    final is_pri=false,
    final nEqu=nHp + nPhp,
    final nPum=nPumHeaWatSec,
    final is_hdr=have_pumSecHdr,
    final is_ctlDp=have_pumSecCtlDp,
    final nSenDp=if have_senDpHeaWatRemWir then nSenDpHeaWatRem else 1,
    final V_flow_nominal=VHeaWatSec_flow_nominal,
    final dtRun=dtRunPumSta,
    final dtRunFaiSaf=dtRunFaiSafPumSta,
    final dtRunFaiSafLowY=dtRunFaiSafLowYPumSta,
    final dVOffUp=dVOffUpPumSta,
    final dVOffDow=dVOffDowPumSta,
    final dpOff=dpOffPumSta,
    final yUp=yUpPumSta,
    final yDow=yDowPumSta)
    if have_pumHeaWatSec
    "Secondary HW pump staging"
    annotation(Placement(transformation(extent={{140,150},{160,170}})));
  Utilities.PlaceholderReal THeaWatRet(
    final have_inp=have_senTHeaWatPriRet,
    final have_inpPh=true)
    if have_heaWat
    "Select HW return temperature sensor"
    annotation(Placement(transformation(extent={{-230,30},{-210,50}})));
  Utilities.PlaceholderReal VHeaWatSta_flow(
    final have_inp=have_senVHeaWatPri,
    final have_inpPh=true)
    if have_heaWat
    "For staging logic select primary flow sensor if both primary and secondary sensors available"
    annotation(Placement(transformation(extent={{-190,10},{-170,30}})));
  Utilities.PlaceholderReal TChiWatRet(
    final have_inp=have_senTChiWatPriRet,
    final have_inpPh=true)
    if have_chiWat
    "Select CHW return temperature sensor"
    annotation(Placement(transformation(extent={{-230,-30},{-210,-10}})));
  Utilities.PlaceholderReal VChiWatSta_flow(
    final have_inp=have_senVChiWatPri,
    final have_inpPh=true)
    if have_chiWat
    "For staging logic select primary flow sensor if both primary and secondary sensors available"
    annotation(Placement(transformation(extent={{-190,-52},{-170,-32}})));
  StagingRotation.StageCompletion comStaCoo(nin=nHp + 2 * nPhp)
    if have_chiWat
    "Check successful completion of cooling stage change"
    annotation(Placement(transformation(extent={{-40,20},{-20,40}})));
  StagingRotation.StageCompletion comStaHea(nin=nHp + 2 * nPhp)
    if have_heaWat
    "Check successful completion of heating stage change"
    annotation(Placement(transformation(extent={{-40,280},{-20,300}})));
  Setpoints.PlantReset resHeaWat(
    final TSup_nominal=THeaWatSup_nominal,
    final TSupSetLim=THeaWatSupSet_min,
    final dpSet_max=dpHeaWatRemSet_max,
    final dpSet_min=dpHeaWatRemSet_min,
    final dtDel=dtDel,
    final dtHol=dtHol,
    final dtRes=dtResHeaWat,
    final nReqResIgn=nReqResIgnHeaWat,
    final nSenDpRem=nSenDpHeaWatRem,
    final resDp_max=resDpHeaWat_max,
    final resTSup_min=resTHeaWatSup_min,
    final res_init=res_init,
    final res_max=res_max,
    final res_min=res_min,
    final rsp=rspHeaWat,
    final rsp_max=rspHeaWat_max,
    final tri=triHeaWat)
    if have_heaWat
    "HW plant reset"
    annotation(Placement(transformation(extent={{50,230},{70,250}})));
  Setpoints.PlantReset resChiWat(
    final TSup_nominal=TChiWatSup_nominal,
    final TSupSetLim=TChiWatSupSet_max,
    final dpSet_max=dpChiWatRemSet_max,
    final dpSet_min=dpChiWatRemSet_min,
    final dtDel=dtDel,
    final dtHol=dtHol,
    final dtRes=dtResChiWat,
    final nReqResIgn=nReqResIgnChiWat,
    final nSenDpRem=nSenDpChiWatRem,
    final resDp_max=resDpChiWat_max,
    final resTSup_min=resTChiWatSup_min,
    final res_init=res_init,
    final res_max=res_max,
    final res_min=res_min,
    final rsp=rspChiWat,
    final rsp_max=rspChiWat_max,
    final tri=triChiWat)
    if have_chiWat
    "CHW plant reset"
    annotation(Placement(transformation(extent={{50,-50},{70,-30}})));
  Pumps.Primary.VariableSpeedHeatPumps ctlPumPri(
    final have_heaWat=have_heaWat,
    final have_chiWat=have_chiWat,
    final have_pumPriCtlDp=have_pumPriCtlDp,
    final have_pumPriHdr=have_pumPriHdr,
    final have_pumChiWatPriDedHp=have_pumChiWatPriDedHp,
    final nHp=nHp,
    final nPhp=nPhp,
    final nPumHeaWatPri=nPumHeaWatPri,
    final nPumChiWatPri=nPumChiWatPri,
    final yPumHeaWatPriHdrSet=yPumHeaWatPriHdrSet,
    final yPumChiWatPriHdrSet=yPumChiWatPriHdrSet,
    final yPumHeaWatPriDedHpSet=yPumHeaWatPriDedHpSet,
    final yPumChiWatPriDedHpSet=yPumChiWatPriDedHpSet,
    final yPumHeaWatPriDedPhpSet=yPumHeaWatPriDedPhpSet,
    final yPumChiWatPriDedPhpSet=yPumChiWatPriDedPhpSet,
    final have_senDpChiWatRemWir=have_senDpChiWatRemWir,
    final have_senDpHeaWatRemWir=have_senDpHeaWatRemWir,
    final kCtlDpChiWat=kCtlDpChiWat,
    final kCtlDpHeaWat=kCtlDpHeaWat,
    final nSenDpChiWatRem=nSenDpChiWatRem,
    final nSenDpHeaWatRem=nSenDpHeaWatRem,
    final TiCtlDpChiWat=TiCtlDpChiWat,
    final TiCtlDpHeaWat=TiCtlDpHeaWat,
    final yPumChiWatPri_min=yPumChiWatPri_min,
    final yPumHeaWatPri_min=yPumHeaWatPri_min)
    if have_pumHeaWatPriVar or have_pumChiWatPriVar
    "Primary pump speed control"
    annotation (Placement(transformation(extent={{190,54},{210,98}})));
  Pumps.Generic.ControlDifferentialPressure ctlPumHeaWatSec(
    final have_senDpRemWir=have_senDpHeaWatRemWir,
    final nPum=nPumHeaWatSec,
    final nSenDpRem=nSenDpHeaWatRem,
    final y_min=yPumHeaWatSec_min,
    final k=kCtlDpHeaWat,
    final Ti=TiCtlDpHeaWat)
    if have_pumHeaWatSec and have_pumSecCtlDp
    "Secondary HW pump speed control"
    annotation(Placement(transformation(extent={{140,10},{160,30}})));
  Pumps.Generic.ControlDifferentialPressure ctlPumChiWatSec(
    final have_senDpRemWir=have_senDpChiWatRemWir,
    final nPum=nPumChiWatSec,
    final nSenDpRem=nSenDpChiWatRem,
    final y_min=yPumChiWatSec_min,
    final k=kCtlDpChiWat,
    final Ti=TiCtlDpChiWat)
    if have_pumChiWatSec and have_pumSecCtlDp
    "Secondary CHW pump speed control"
    annotation(Placement(transformation(extent={{190,-18},{210,2}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repTChiWatSupHpSet(final
      nout=nHp) if have_chiWat and have_hp "Replicate CHWST setpoint"
    annotation (Placement(transformation(extent={{210,-150},{230,-130}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repTHeaWatSupHpSet(final
      nout=nHp) if have_heaWat and have_hp "Replicate HWST setpoint"
    annotation (Placement(transformation(extent={{152,-130},{172,-110}})));
  HeatRecoveryChillers.Controller hrc(
    final COPHea_nominal=COPHeaHrc_nominal,
    final TChiWatSup_min=TChiWatSupHrc_min,
    final THeaWatSup_max=THeaWatSupHrc_max,
    final capCoo_min=capCooHrc_min,
    final capHea_min=capHeaHrc_min,
    final cp_default=cp_default,
    final dtLoa=dtLoaHrc,
    final dtRun=dtRunEna,
    final dtTem1=dtTem1Hrc,
    final dtTem2=dtTem2Hrc,
    final have_reqFlo=have_reqFloHrc,
    final rho_default=rho_default)
    if have_hrc
    "Sidestream heat recovery chiller control"
    annotation(Placement(transformation(extent={{200,-320},{220,-288}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal pasDpHeaWatRemSet(
    final nin=nSenDpHeaWatRem,
    final nout=nSenDpHeaWatRem)
    if have_heaWat and have_senDpHeaWatRemWir
    "Direct pass through for HW ∆p setpoint"
    annotation(Placement(transformation(extent={{90,270},{110,290}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal pasDpChiWatRemSet(
    final nin=nSenDpChiWatRem,
    final nout=nSenDpChiWatRem)
    if have_chiWat and have_senDpChiWatRemWir
    "Direct pass through for CHW ∆p setpoint"
    annotation(Placement(transformation(extent={{90,50},{110,70}})));
  MinimumFlow.ControllerHeatPumps ctlFloMin(
    final have_chiWat=have_chiWat,
    final have_heaWat=have_heaWat,
    final have_pumPriHdr=have_pumPriHdr,
    have_pumChiWatPriDedHp=have_pumChiWatPriDedHp,
    final nHp=nHp,
    final nPhp=nPhp,
    final have_valInlIso=have_valHpInlIso or have_valPhpInlIso,
    final have_valOutIso=have_valHpOutIso or have_valPhpOutIso,
    final k=kValMinByp,
    final Ti=TiValMinByp,
    final VChiWat_flow_min={if i <= nHp
    then VChiWatHp_flow_min[i]
    else VChiWatPhp_flow_min[i - nHp] for i in 1:nHp + nPhp},
    final VChiWat_flow_nominal={if i <= nHp
    then VChiWatHp_flow_nominal[i]
    else VChiWatPhp_flow_nominal[i - nHp] for i in 1:nHp + nPhp},
    final VHeaWat_flow_min={if i <= nHp
    then VHeaWatHp_flow_min[i]
    else VHeaWatPhp_flow_min[i - nHp] for i in 1:nHp + nPhp},
    final VHeaWat_flow_nominal={if i <= nHp
    then VHeaWatHp_flow_nominal[i]
    else VHeaWatPhp_flow_nominal[i - nHp] for i in 1:nHp + nPhp})
    if is_priOnl
    "CHW/HW minimum flow bypass valve controller"
    annotation(Placement(transformation(extent={{202,-250},{222,-218}})));
  Utilities.PlaceholderReal VHeaWatLoa_flow(
    final have_inp=is_priOnl,
    final have_inpPh=true)
    if have_heaWat
    "For HRC logic select either primary or secondary sensor depending on plant configuration"
    annotation(Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Utilities.PlaceholderReal VChiWatLoa_flow(
    final have_inp=is_priOnl,
    final have_inpPh=true)
    if have_chiWat
    "For HRC logic select either primary or secondary sensor depending on plant configuration"
    annotation(Placement(transformation(extent={{-140,-110},{-120,-90}})));
  StagingRotation.SortRuntime sorRunTimPhp(nin=nPhp)
    if have_php
    "Sort lead/lag alternate polyvalent HP by staging runtime"
    annotation(Placement(transformation(extent={{-150,450},{-130,470}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1AvaPhp[nPhp](
    each k=true)
    if have_php
    "Polyvalent heat pump available signal – Block does not handle faulted equipment yet"
    annotation(Placement(transformation(extent={{-240,410},{-220,430}}),
      iconTransformation(extent={{-240,220},{-200,260}})));
  PolyvalentHeatPumps.StagingParameters staPhp(final nHp=nHp, final nPhp=nPhp)
    "Staging parameters for plants with polyvalent HP"
    annotation(Placement(transformation(extent={{-250,470},{-230,490}})));
  StagingRotation.EquipmentAvailability avaHeaCooPhp[nPhp](
    each final have_heaWat=have_heaWat,
    each final have_chiWat=have_chiWat,
    each final dtOff=dtOff)
    if have_php
    "Evaluate polyvalent HP availability in heating or cooling mode"
    annotation(Placement(transformation(extent={{-150,390},{-130,410}})));
  Buildings.Controls.OBC.CDL.Logical.And y1ShcPhp[nPhp] if have_php
    "Polyvalent HP enabled in SHC mode"
    annotation(Placement(transformation(extent={{200,450},{180,470}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPriDedHp_actual[nPumChiWatPriDedHp]
    if have_pumChiWatPri and have_pumChiWatPriDedHp
    "Primary CHW pump status – HP dedicated pumps"
    annotation(Placement(transformation(extent={{-300,140},{-260,180}}),
      iconTransformation(extent={{-240,200},{-200,240}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPriDedPhp_actual[nPumChiWatPriDedPhp]
    if have_pumChiWatPri and not have_pumPriHdr and have_php
    "Primary CHW pump status – Polyvalent HP dedicated pumps"
    annotation(Placement(transformation(extent={{-300,120},{-260,160}}),
      iconTransformation(extent={{-240,180},{-200,220}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatPriDedHp[nPumChiWatPriDedHp]
    if have_pumChiWatPri and have_pumChiWatPriDedHp
    "Primary CHW pump start command – HP dedicated pumps"
    annotation(Placement(transformation(extent={{260,140},{300,180}}),
      iconTransformation(extent={{200,100},{240,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatPriDedPhp[nPumChiWatPriDedPhp]
    if have_pumChiWatPri and not have_pumPriHdr and have_php
    "Primary CHW pump start command – Polyvalent HP dedicated pumps"
    annotation(Placement(transformation(extent={{260,120},{300,160}}),
      iconTransformation(extent={{200,80},{240,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumChiWatPriDedPhp[nPumChiWatPriDedPhp](
    each final unit="1")
    if have_pumChiWatPriVar and not have_pumPriHdr and have_php
    "Primary CHW pump speed command – Polyvalent HP dedicated pumps"
    annotation(Placement(transformation(extent={{260,-40},{300,0}}),
      iconTransformation(extent={{200,-80},{240,-40}})));
  PolyvalentHeatPumps.RoutingPrimaryPumpStatus rouPumChiWatPri(
    final have_pumPriHdr=have_pumPriHdr,
    final nPumPriDedHp=nPumChiWatPriDedHp,
    final nPumPriDedPhp=nPumChiWatPriDedPhp,
    final nPumPri=nPumChiWatPri)
    if have_pumChiWatPri
    "Reroute primary CHW pump status signal"
    annotation(Placement(transformation(extent={{-230,150},{-210,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPriHdr_actual[nPumHeaWatPri]
    if have_pumHeaWatPri and have_pumPriHdr
    "Primary HW pump status"
    annotation(Placement(transformation(extent={{-300,220},{-260,260}}),
      iconTransformation(extent={{-240,280},{-200,320}})));
  PolyvalentHeatPumps.RoutingPrimaryPumpStatus rouPumHeaWatPri(
    final have_pumPriHdr=have_pumPriHdr,
    final nPumPriDedHp=nPumHeaWatPriDedHp,
    final nPumPriDedPhp=nPumHeaWatPriDedPhp,
    final nPumPri=nPumHeaWatPri)
    if have_pumHeaWatPri
    "Reroute primary HW pump status signal"
    annotation(Placement(transformation(extent={{-230,210},{-210,230}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPriDedHp_actual[nPumHeaWatPriDedHp]
    if have_pumHeaWatPri and not have_pumPriHdr and have_hp
    "Primary HW pump status"
    annotation(Placement(transformation(extent={{-300,200},{-260,240}}),
      iconTransformation(extent={{-240,260},{-200,300}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatPriDedHp[nPumHeaWatPriDedHp]
    if have_pumHeaWatPri and have_hp and not have_pumPriHdr
    "Primary HW pump start command – HP dedicated pumps"
    annotation(Placement(transformation(extent={{260,200},{300,240}}),
      iconTransformation(extent={{200,160},{240,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatPriDedPhp[nPumHeaWatPriDedPhp]
    if have_pumHeaWatPri and have_php and not have_pumPriHdr
    "Primary HW pump start command – Polyvalent HP dedicated pumps"
    annotation(Placement(transformation(extent={{260,180},{300,220}}),
      iconTransformation(extent={{200,140},{240,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumHeaWatPriDedPhp[nPumHeaWatPriDedPhp](
    each final unit="1")
    if have_pumHeaWatPriVar and not have_pumPriHdr and have_php
    "Primary HW pump speed command – Polyvalent HP dedicated pumps"
    annotation(Placement(transformation(extent={{260,0},{300,40}}),
      iconTransformation(extent={{200,-40},{240,0}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(message=
        "\"Primary-secondary plants with headered pumps are not supported when both reversible and polyvalent HP are present")
    annotation (Placement(transformation(extent={{210,-430},{230,-410}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=is_priOnl)
    annotation (Placement(transformation(extent={{100,-410},{120,-390}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(k=typ <> Buildings.Templates.Plants.Controls.Types.PlantHeatPump.ReversiblePolyvalent)
    annotation (Placement(transformation(extent={{130,-430},{150,-410}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(final k=not
        have_pumPriHdr)
    annotation (Placement(transformation(extent={{100,-450},{120,-430}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(nin=3)
    annotation (Placement(transformation(extent={{170,-430},{190,-410}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold y1EnaHeaHol[nHp](each
      trueHoldDuration=1)
    annotation (Placement(transformation(extent={{100,358},{120,378}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaWatSupPhpSet[nPhp](
    each final unit="K",
    each final quantity="ThermodynamicTemperature",
    each displayUnit="degC") if have_heaWat and have_php
    "Polyvalent HP HW supply temperature setpoint" annotation (Placement(
        transformation(extent={{260,-180},{300,-140}}), iconTransformation(
          extent={{200,-260},{240,-220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiWatSupPhpSet[nPhp](
    each final unit="K",
    each final quantity="ThermodynamicTemperature",
    each displayUnit="degC") if have_chiWat and have_php
    "Polyvalent HP CHW supply temperature setpoint" annotation (Placement(
        transformation(extent={{260,-200},{300,-160}}), iconTransformation(
          extent={{200,-280},{240,-240}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repTHeaWatSupPhpSet(final
      nout=nPhp) if have_heaWat and have_php "Replicate HWST setpoint"
    annotation (Placement(transformation(extent={{150,-170},{170,-150}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repTChiWatSupPhpSet(final
      nout=nPhp) if have_chiWat and have_php "Replicate CHWST setpoint"
    annotation (Placement(transformation(extent={{210,-190},{230,-170}})));
equation
  connect(u1Php_actual, sorRunTimPhp.u1Run)
    annotation(Line(points={{-280,440},{-180,440},{-180,466},{-152,466}},
      color={255,0,255}));
  connect(u1AvaPhp.y, sorRunTimPhp.u1Ava)
    annotation(Line(points={{-218,420},{-170,420},{-170,454},{-152,454}},
      color={255,0,255}));
  connect(u1SchHea, enaHea.u1Sch)
    annotation(Line(points={{-280,380},{-180,380},{-180,364},{-112,364}},
      color={255,0,255}));
  connect(nReqPlaHeaWat, enaHea.nReqPla)
    annotation(Line(points={{-280,340},{-178,340},{-178,360},{-112,360}},
      color={255,127,0}));
  connect(TOut, enaHea.TOut)
    annotation(Line(points={{-280,80},{-170,80},{-170,356},{-112,356}},
      color={0,0,127}));
  connect(enaHea.y1, idxStaHea.u1Lea)
    annotation(Line(points={{-88,360},{-20,360},{-20,366},{-12,366}},
      color={255,0,255}));
  connect(avaStaHea.y1, idxStaHea.u1AvaSta)
    annotation(Line(points={{-88,330},{-56,330},{-56,354},{-12,354}},
      color={255,0,255}));
  connect(idxStaHea.y, enaEquHea.uSta)
    annotation(Line(points={{12,360},{38,360}},
      color={255,127,0}));
  connect(seqEve[1:nHp].y1, y1Hp)
    annotation(Line(points={{162,310},{238,310},{238,480},{280,480}},
      color={255,0,255}));
  connect(seqEve[1:nHp].y1Hea, y1HeaHp)
    annotation(Line(points={{162,308},{240,308},{240,460},{280,460}},
      color={255,0,255}));
  connect(seqEve[1:nHp].y1ValHeaWatOutIso, y1ValHeaWatHpOutIso)
    annotation(Line(points={{162,298},{240,298},{240,380},{280,380}},
      color={255,0,255}));
  connect(seqEve[1:nHp].y1ValHeaWatInlIso, y1ValHeaWatHpInlIso)
    annotation(Line(points={{162,300},{242,300},{242,400},{280,400}},
      color={255,0,255}));
  connect(seqEve[1:nHp].y1ValChiWatInlIso, y1ValChiWatHpInlIso)
    annotation(Line(points={{162,296},{238,296},{238,360},{280,360}},
      color={255,0,255}));
  connect(seqEve[1:nHp].y1ValChiWatOutIso, y1ValChiWatHpOutIso)
    annotation(Line(points={{162,294},{236,294},{236,340},{280,340}},
      color={255,0,255}));
  connect(idxStaHea.y, chaStaHea.uSta)
    annotation(Line(
      points={{12,360},{20,360},{20,340},{-50,340},{-50,328},{-42,328}},
      color={255,127,0}));
  connect(chaStaHea.y1Dow, idxStaHea.u1Dow)
    annotation(Line(points={{-18,318},{-14,318},{-14,358},{-12,358}},
      color={255,0,255}));
  connect(chaStaHea.y1Up, idxStaHea.u1Up)
    annotation(Line(points={{-18,322},{-16,322},{-16,362},{-12,362}},
      color={255,0,255}));
  connect(chaStaHea.y1Lck, chaStaCoo.u1Lck) annotation (Line(points={{-18,314},
          {-14,314},{-14,62},{-42,62}},
                                 color={255,0,255}));
  connect(chaStaHea.uStaOppNexHig, chaStaCoo.yStaNexHig) annotation (Line(points={{-42,332},
          {-42,336},{-8,336},{-8,65.8},{-18,65.8}},
                                        color={255,0,255}));
  connect(avaStaHea.y1, chaStaHea.u1AvaSta)
    annotation(Line(points={{-88,330},{-56,330},{-56,326},{-42,326}},
      color={255,0,255}));
  connect(nReqPlaChiWat, enaCoo.nReqPla)
    annotation(Line(points={{-280,320},{-182,320},{-182,100},{-112,100}},
      color={255,127,0}));
  connect(TOut, enaCoo.TOut)
    annotation(Line(points={{-280,80},{-170,80},{-170,96},{-112,96}},
      color={0,0,127}));
  connect(u1SchCoo, enaCoo.u1Sch)
    annotation(Line(points={{-280,360},{-180,360},{-180,104},{-112,104}},
      color={255,0,255}));
  connect(avaStaCoo.y1, chaStaCoo.u1AvaSta)
    annotation(Line(points={{-88,70},{-56,70},{-56,66},{-42,66}},
      color={255,0,255}));
  connect(enaCoo.y1, idxStaCoo.u1Lea)
    annotation(Line(points={{-88,100},{-56,100},{-56,106},{-12,106}},
      color={255,0,255}));
  connect(chaStaCoo.y1Up, idxStaCoo.u1Up)
    annotation(Line(points={{-18,62},{-16,62},{-16,102},{-12,102}},
      color={255,0,255}));
  connect(chaStaCoo.y1Dow, idxStaCoo.u1Dow)
    annotation(Line(points={{-18,58},{-14,58},{-14,98},{-12,98}},
      color={255,0,255}));
  connect(idxStaCoo.y, enaEquCoo.uSta)
    annotation(Line(points={{12,100},{48,100}},
      color={255,127,0}));
  connect(avaStaCoo.y1, idxStaCoo.u1AvaSta)
    annotation(Line(points={{-88,70},{-56,70},{-56,94},{-12,94}},
      color={255,0,255}));
  connect(idxStaCoo.y, chaStaCoo.uSta)
    annotation(Line(
      points={{12,100},{20,100},{20,80},{-48,80},{-48,68},{-42,68}},
      color={255,127,0}));
  connect(staPumHeaWatPri.y1, y1PumHeaWatPriHdr)
    annotation(Line(points={{162,200},{222,200},{222,240},{280,240}},
      color={255,0,255}));
  connect(staPumHeaWatPri.y1[nPumHeaWatPri - nPumHeaWatPriDedPhp +
    1:nPumHeaWatPri], y1PumHeaWatPriDedPhp)
    annotation(Line(points={{162,200},{246,200},{246,200},{280,200}},
      color={255,0,255}));
  connect(staPumHeaWatPri.y1[1:nPumHeaWatPriDedHp], y1PumHeaWatPriDedHp)
    annotation(Line(points={{162,200},{246,200},{246,220},{280,220}},
      color={255,0,255}));
  connect(staPumChiWatPri.y1, y1PumChiWatPriHdr)
    annotation(Line(points={{212,180},{280,180}},
      color={255,0,255}));
  connect(staPumChiWatPri.y1[nPumChiWatPri - nPumChiWatPriDedPhp +
    1:nPumChiWatPri], y1PumChiWatPriDedPhp)
    annotation(Line(points={{212,180},{246,180},{246,140},{280,140}},
      color={255,0,255}));
  connect(staPumChiWatPri.y1[1:nPumChiWatPriDedHp], y1PumChiWatPriDedHp)
    annotation(Line(points={{212,180},{246,180},{246,160},{280,160}},
      color={255,0,255}));
  connect(staPumChiWatPri.y1_actual, seqEve.u1PumChiWatPri_actual)
    annotation(Line(
      points={{212,186},{220,186},{220,262},{122,262},{122,296},{138,296}},
      color={255,0,255}));
  connect(seqEve.y1PumChiWatPri, staPumChiWatPri.u1PumPri)
    annotation(Line(points={{162,288},{178,288},{178,182},{188,182}},
      color={255,0,255}));
  connect(rouPumChiWatPri.y1, staPumChiWatPri.u1Pum_actual)
    annotation(Line(points={{-208,160},{114,160},{114,180},{188,180}},
      color={255,0,255}));
  connect(rouPumHeaWatPri.y1, staPumHeaWatPri.u1Pum_actual)
    annotation(Line(points={{-208,220},{128,220},{128,200},{138,200}},
      color={255,0,255}));
  connect(staPumHeaWatPri.y1_actual, seqEve.u1PumHeaWatPri_actual)
    annotation(Line(
      points={{162,206},{164,206},{164,260},{120,260},{120,298},{138,298}},
      color={255,0,255}));
  connect(staPumHeaWatSec.y1, y1PumHeaWatSec)
    annotation(Line(points={{162,160},{222,160},{222,120},{280,120}},
      color={255,0,255}));
  connect(staPumChiWatSec.y1, y1PumChiWatSec)
    annotation(Line(points={{212,140},{246,140},{246,100},{280,100}},
      color={255,0,255}));
  connect(u1PumHeaWatSec_actual, staPumHeaWatSec.u1Pum_actual)
    annotation(Line(points={{-280,120},{120,120},{120,160},{138,160}},
      color={255,0,255}));
  connect(u1PumChiWatSec_actual, staPumChiWatSec.u1Pum_actual)
    annotation(Line(points={{-280,100},{-238,100},{-238,140},{188,140}},
      color={255,0,255}));
  connect(staPumHeaWatPri.y1, y1PumHeaWatPriHdr)
    annotation(Line(points={{162,200},{216,200},{216,240},{280,240}},
      color={255,0,255}));
  connect(seqEve.y1PumHeaWatPri, staPumHeaWatPri.u1PumPri)
    annotation(Line(points={{162,290},{162,220},{130,220},{130,202},{138,202}},
      color={255,0,255}));
  connect(VHeaWatSec_flow, staPumHeaWatSec.V_flow)
    annotation(Line(points={{-280,-120},{-156,-120},{-156,158},{138,158}},
      color={0,0,127}));
  connect(VChiWatSec_flow, staPumChiWatSec.V_flow)
    annotation(Line(points={{-280,-200},{-154,-200},{-154,138},{188,138}},
      color={0,0,127}));
  connect(THeaWatPriRet, THeaWatRet.u)
    annotation(Line(points={{-280,40},{-232,40}},
      color={0,0,127}));
  connect(THeaWatRet.y, chaStaHea.TRet)
    annotation(Line(
      points={{-208,40},{-168,40},{-168,306},{-50,306},{-50,314},{-42,314}},
      color={0,0,127}));
  connect(THeaWatSecRet, THeaWatRet.uPh)
    annotation(Line(points={{-280,-80},{-240,-80},{-240,34},{-232,34}},
      color={0,0,127}));
  connect(VHeaWatPri_flow, VHeaWatSta_flow.u)
    annotation(Line(points={{-280,20},{-192,20}},
      color={0,0,127}));
  connect(VHeaWatSta_flow.y, chaStaHea.V_flow)
    annotation(Line(
      points={{-168,20},{-166,20},{-166,304},{-48,304},{-48,312},{-42,312}},
      color={0,0,127}));
  connect(VHeaWatSec_flow, VHeaWatSta_flow.uPh)
    annotation(Line(points={{-280,-120},{-200,-120},{-200,14},{-192,14}},
      color={0,0,127}));
  connect(TChiWatPriRet, TChiWatRet.u)
    annotation(Line(points={{-280,-20},{-232,-20}},
      color={0,0,127}));
  connect(TChiWatRet.y, chaStaCoo.TRet)
    annotation(Line(
      points={{-208,-20},{-164,-20},{-164,48},{-50,48},{-50,54},{-42,54}},
      color={0,0,127}));
  connect(TChiWatSecRet, TChiWatRet.uPh)
    annotation(Line(points={{-280,-160},{-238,-160},{-238,-26},{-232,-26}},
      color={0,0,127}));
  connect(VChiWatPri_flow, VChiWatSta_flow.u)
    annotation(Line(points={{-280,-40},{-204,-40},{-204,-42},{-192,-42}},
      color={0,0,127}));
  connect(VChiWatSta_flow.y, chaStaCoo.V_flow)
    annotation(Line(
      points={{-168,-42},{-162,-42},{-162,38},{-48,38},{-48,52},{-42,52}},
      color={0,0,127}));
  connect(VChiWatSec_flow, VChiWatSta_flow.uPh)
    annotation(Line(points={{-280,-200},{-204,-200},{-204,-48},{-192,-48}},
      color={0,0,127}));
  connect(enaHea.y1, staPumHeaWatSec.u1Pla)
    annotation(Line(points={{-88,360},{-82,360},{-82,168},{138,168}},
      color={255,0,255}));
  connect(enaCoo.y1, staPumChiWatSec.u1Pla)
    annotation(Line(
      points={{-88,100},{-80,100},{-80,142},{170,142},{170,148},{188,148}},
      color={255,0,255}));
  connect(seqEve.y1ValHeaWatInlIso, staPumHeaWatPri.u1ValInlIso)
    annotation(Line(
      points={{162,300},{170,300},{170,216},{134,216},{134,206},{138,206}},
      color={255,0,255}));
  connect(seqEve.y1ValHeaWatOutIso, staPumHeaWatPri.u1ValOutIso)
    annotation(Line(
      points={{162,298},{168,298},{168,218},{132,218},{132,204},{138,204}},
      color={255,0,255}));
  connect(seqEve.y1ValChiWatInlIso, staPumChiWatPri.u1ValInlIso)
    annotation(Line(points={{162,296},{182,296},{182,186},{188,186}},
      color={255,0,255}));
  connect(seqEve.y1ValChiWatOutIso, staPumChiWatPri.u1ValOutIso)
    annotation(Line(points={{162,294},{180,294},{180,184},{188,184}},
      color={255,0,255}));
  connect(u1Hp_actual, sorRunTimHp.u1Run)
    annotation(Line(points={{-280,300},{-160,300},{-160,276},{-152,276}},
      color={255,0,255}));
  connect(u1AvaHp.y, sorRunTimHp.u1Ava)
    annotation(Line(points={{-218,280},{-200,280},{-200,264},{-152,264}},
      color={255,0,255}));
  connect(idxStaCoo.y, comStaCoo.uSta)
    annotation(Line(
      points={{12,100},{20,100},{20,-12},{-46,-12},{-46,34},{-42,34}},
      color={255,127,0}));
  connect(comStaCoo.y1, chaStaCoo.u1StaPro)
    annotation(Line(
      points={{-18,24},{-10,24},{-10,48},{-46,48},{-46,64},{-42,64}},
      color={255,0,255}));
  connect(u1Hp_actual, comStaCoo.u1_actual[1:nHp])
    annotation(Line(points={{-280,300},{-60,300},{-60,26},{-42,26}},
      color={255,0,255}));
  connect(u1Php_actual, comStaCoo.u1_actual[nHp + 1:nHp + nPhp])
    annotation(Line(points={{-280,440},{-60,440},{-60,26},{-42,26}},
      color={255,0,255}));
  connect(u1Php_actual, comStaCoo.u1_actual[nHp + nPhp + 1:nHp + 2 * nPhp])
    annotation(Line(points={{-280,440},{-60,440},{-60,26},{-42,26}},
      color={255,0,255}));
  connect(y1Hp, comStaCoo.u1[1:nHp])
    annotation(Line(points={{280,480},{-58,480},{-58,30},{-42,30}},
      color={255,0,255}));
  connect(y1CooPhp, comStaCoo.u1[nHp + 1:nHp + nPhp])
    annotation(Line(points={{280,420},{-58,420},{-58,30},{-42,30}},
      color={255,0,255}));
  connect(y1ShcPhp.y, comStaCoo.u1[nHp + nPhp + 1:nHp + 2 * nPhp])
    annotation(Line(points={{178,460},{-54,460},{-54,30},{-42,30}},
      color={255,0,255}));
  connect(idxStaHea.y, comStaHea.uSta)
    annotation(Line(
      points={{12,360},{20,360},{20,248},{-44,248},{-44,294},{-42,294}},
      color={255,127,0}));
  connect(u1Hp_actual, comStaHea.u1_actual[1:nHp])
    annotation(Line(points={{-280,300},{-60,300},{-60,286},{-42,286}},
      color={255,0,255}));
  connect(u1Php_actual, comStaHea.u1_actual[nHp + 1:nHp + nPhp])
    annotation(Line(points={{-280,440},{-60,440},{-60,286},{-42,286}},
      color={255,0,255}));
  connect(u1Php_actual, comStaHea.u1_actual[nHp + nPhp + 1:nHp + 2 * nPhp])
    annotation(Line(points={{-280,440},{-60,440},{-60,286},{-42,286}},
      color={255,0,255}));
  connect(y1Hp, comStaHea.u1[1:nHp])
    annotation(Line(points={{280,480},{-58,480},{-58,290},{-42,290}},
      color={255,0,255}));
  connect(y1HeaPhp, comStaHea.u1[nHp + 1:nHp + nPhp])
    annotation(Line(points={{280,440},{-58,440},{-58,290},{-42,290}},
      color={255,0,255}));
  connect(y1ShcPhp.y, comStaHea.u1[nHp + nPhp + 1:nHp + 2 * nPhp])
    annotation(Line(points={{178,460},{-54,460},{-54,290},{-42,290}},
      color={255,0,255}));
  connect(comStaHea.y1, chaStaHea.u1StaPro)
    annotation(Line(
      points={{-18,284},{-10,284},{-10,308},{-44,308},{-44,324},{-42,324}},
      color={255,0,255}));
  connect(resHeaWat.dpSet, dpHeaWatRemSet)
    annotation(Line(points={{72,246},{240,246},{240,-80},{280,-80}},
      color={0,0,127}));
  connect(resChiWat.dpSet, dpChiWatRemSet)
    annotation(Line(points={{72,-34},{238,-34},{238,-100},{280,-100}},
      color={0,0,127}));
  connect(nReqResHeaWat, resHeaWat.nReqRes)
    annotation(Line(points={{-280,-400},{30,-400},{30,246},{48,246}},
      color={255,127,0}));
  connect(nReqResChiWat, resChiWat.nReqRes)
    annotation(Line(points={{-280,-420},{40,-420},{40,-34},{48,-34}},
      color={255,127,0}));
  connect(enaCoo.y1, resChiWat.u1Ena)
    annotation(Line(points={{-88,100},{-80,100},{-80,-40},{48,-40}},
      color={255,0,255}));
  connect(enaHea.y1, resHeaWat.u1Ena)
    annotation(Line(points={{-88,360},{-82,360},{-82,240},{48,240}},
      color={255,0,255}));
  connect(comStaHea.y1, resHeaWat.u1StaPro)
    annotation(Line(points={{-18,284},{-10,284},{-10,234},{48,234}},
      color={255,0,255}));
  connect(comStaCoo.y1, resChiWat.u1StaPro)
    annotation(Line(points={{-18,24},{-10,24},{-10,-46},{48,-46}},
      color={255,0,255}));
  connect(resChiWat.TSupSet, chaStaCoo.TSupSet)
    annotation(Line(
      points={{72,-46},{116,-46},{116,-20},{-52,-20},{-52,60},{-42,60}},
      color={0,0,127}));
  connect(resHeaWat.TSupSet, chaStaHea.TSupSet)
    annotation(Line(
      points={{72,234},{118,234},{118,220},{-52,220},{-52,320},{-42,320}},
      color={0,0,127}));
  connect(ctlPumPri.yPumHeaWatPriHdr, yPumHeaWatPriHdr)
    annotation(Line(points={{212,76},{246,76},{246,80},{280,80}},
      color={0,0,127}));
  connect(ctlPumPri.yPumChiWatPriHdr, yPumChiWatPriHdr)
    annotation(Line(points={{212,72},{246,72},{246,60},{280,60}},
      color={0,0,127}));
  connect(ctlPumPri.yPumHeaWatPriDedHp, yPumHeaWatPriDedHp)
    annotation(Line(points={{212,68},{222,68},{222,40},{280,40}},
      color={0,0,127}));
  connect(ctlPumPri.yPumHeaWatPriDedPhp, yPumHeaWatPriDedPhp)
    annotation(Line(points={{212,59.8},{222,59.8},{222,20},{280,20}},
      color={0,0,127}));
  connect(y1PumHeaWatPriHdr, ctlPumPri.u1PumHeaWatPriHdr)
    annotation(Line(points={{280,240},{172,240},{172,96},{188,96}},
      color={255,0,255}));
  connect(y1PumChiWatPriHdr, ctlPumPri.u1PumChiWatPriHdr)
    annotation(Line(
      points={{280,180},{222,180},{222,120},{186,120},{186,74},{188,74}},
      color={255,0,255}));
  connect(y1PumHeaWatPriDedHp, ctlPumPri.u1PumHeaWatPriDedHp)
    annotation(Line(points={{280,220},{172,220},{172,94},{188,94}},
      color={255,0,255}));
  connect(y1PumChiWatPriDedHp, ctlPumPri.u1PumChiWatPriDedHp)
    annotation(Line(
      points={{280,160},{222,160},{222,120},{186,120},{186,72},{188,72}},
      color={255,0,255}));
  connect(y1PumHeaWatPriDedPhp, ctlPumPri.u1PumHeaWatPriDedPhp)
    annotation(Line(points={{280,200},{172,200},{172,92},{188,92}},
      color={255,0,255}));
  connect(y1PumChiWatPriDedPhp, ctlPumPri.u1PumChiWatPriDedPhp)
    annotation(Line(
      points={{280,140},{222,140},{222,120},{186,120},{186,70},{188,70}},
      color={255,0,255}));
  connect(y1HeaHp, ctlPumPri.u1HeaHp)
    annotation(Line(points={{280,460},{174,460},{174,76},{188,76}},
      color={255,0,255}));
  connect(ctlPumHeaWatSec.y, yPumHeaWatSec)
    annotation(Line(points={{162,20},{166,20},{166,-40},{280,-40}},
      color={0,0,127}));
  connect(ctlPumChiWatSec.y, yPumChiWatSec)
    annotation(Line(points={{212,-8},{246,-8},{246,-60},{280,-60}},
      color={0,0,127}));
  connect(u1PumHeaWatSec_actual, ctlPumHeaWatSec.y1_actual)
    annotation(Line(points={{-280,120},{120,120},{120,28},{138,28}},
      color={255,0,255}));
  connect(u1PumChiWatSec_actual, ctlPumChiWatSec.y1_actual)
    annotation(Line(points={{-280,100},{-238,100},{-238,0},{188,0}},
      color={255,0,255}));
  connect(resChiWat.dpSet, ctlPumChiWatSec.dpRemSet)
    annotation(Line(points={{72,-34},{178,-34},{178,-4},{188,-4}},
      color={0,0,127}));
  connect(dpHeaWatRem, ctlPumHeaWatSec.dpRem)
    annotation(Line(points={{-280,-220},{130,-220},{130,20},{138,20}},
      color={0,0,127}));
  connect(resHeaWat.dpSet, ctlPumHeaWatSec.dpRemSet)
    annotation(Line(points={{72,246},{122,246},{122,24},{138,24}},
      color={0,0,127}));
  connect(dpHeaWatLoc, ctlPumHeaWatSec.dpLoc)
    annotation(Line(points={{-280,-260},{134,-260},{134,12},{138,12}},
      color={0,0,127}));
  connect(dpHeaWatLocSet, ctlPumHeaWatSec.dpLocSet)
    annotation(Line(points={{-280,-240},{132,-240},{132,16},{138,16}},
      color={0,0,127}));
  connect(dpChiWatRem, ctlPumChiWatSec.dpRem)
    annotation(Line(points={{-280,-280},{180,-280},{180,-8},{188,-8}},
      color={0,0,127}));
  connect(dpChiWatLocSet, ctlPumChiWatSec.dpLocSet)
    annotation(Line(points={{-280,-300},{182,-300},{182,-12},{188,-12}},
      color={0,0,127}));
  connect(dpChiWatLoc, ctlPumChiWatSec.dpLoc)
    annotation(Line(points={{-280,-320},{184,-320},{184,-16},{188,-16}},
      color={0,0,127}));
  connect(resChiWat.TSupSet, repTChiWatSupHpSet.u) annotation (Line(points={{72,
          -46},{116,-46},{116,-140},{208,-140}}, color={0,0,127}));
  connect(resHeaWat.TSupSet, repTHeaWatSupHpSet.u) annotation (Line(points={{72,
          234},{118,234},{118,-120},{150,-120}}, color={0,0,127}));
  connect(resChiWat.TSupSet, TChiWatSupSet)
    annotation(Line(
      points={{72,-46},{116,-46},{116,-202},{188,-202},{188,-220},{280,-220}},
      color={0,0,127}));
  connect(resHeaWat.TSupSet, THeaWatSupSet)
    annotation(Line(points={{72,234},{118,234},{118,-200},{280,-200}},
      color={0,0,127}));
  connect(hrc.y1, y1Hrc)
    annotation(Line(points={{222,-296},{240,-296},{240,-280},{280,-280}},
      color={255,0,255}));
  connect(hrc.y1Coo, y1CooHrc)
    annotation(Line(points={{222,-300},{280,-300}},
      color={255,0,255}));
  connect(hrc.y1PumChiWat, y1PumChiWatHrc)
    annotation(Line(points={{222,-308},{236,-308},{236,-360},{280,-360}},
      color={255,0,255}));
  connect(hrc.y1PumHeaWat, y1PumHeaWatHrc)
    annotation(Line(points={{222,-312},{232,-312},{232,-380},{280,-380}},
      color={255,0,255}));
  connect(TChiWatSupSet, hrc.TChiWatSupSet)
    annotation(Line(points={{280,-220},{188,-220},{188,-302},{198,-302}},
      color={0,0,127}));
  connect(THeaWatSupSet, hrc.THeaWatSupSet)
    annotation(Line(points={{280,-200},{186,-200},{186,-312},{198,-312}},
      color={0,0,127}));
  connect(enaCoo.y1, hrc.u1Coo)
    annotation(Line(points={{-88,100},{-80,100},{-80,-290},{198,-290}},
      color={255,0,255}));
  connect(enaHea.y1, hrc.u1Hea)
    annotation(Line(points={{-88,360},{-82,360},{-82,-292},{198,-292}},
      color={255,0,255}));
  connect(TChiWatRetUpsHrc, hrc.TChiWatRetUpsHrc)
    annotation(Line(points={{-280,-180},{-242,-180},{-242,-306},{198,-306}},
      color={0,0,127}));
  connect(THeaWatRetUpsHrc, hrc.THeaWatRetUpsHrc)
    annotation(Line(points={{-280,-100},{-246,-100},{-246,-316},{198,-316}},
      color={0,0,127}));
  connect(THeaWatSecRet, hrc.THeaWatHrcLvg)
    annotation(Line(points={{-280,-80},{-240,-80},{-240,-314},{198,-314}},
      color={0,0,127}));
  connect(TChiWatSecRet, hrc.TChiWatHrcLvg)
    annotation(Line(points={{-280,-160},{-238,-160},{-238,-304},{198,-304}},
      color={0,0,127}));
  connect(u1Hrc_actual, hrc.u1Hrc_actual)
    annotation(Line(points={{-280,-340},{190,-340},{190,-294},{198,-294}},
      color={255,0,255}));
  connect(u1ReqFloChiWat, hrc.u1ReqFloChiWat)
    annotation(Line(points={{-280,-360},{192,-360},{192,-296},{198,-296}},
      color={255,0,255}));
  connect(u1ReqFloConWat, hrc.u1ReqFloConWat)
    annotation(Line(points={{-280,-380},{194,-380},{194,-298},{198,-298}},
      color={255,0,255}));
  connect(TChiWatPriSup, chaStaCoo.TPriSup)
    annotation(Line(points={{-280,0},{-242,0},{-242,58},{-42,58}},
      color={0,0,127}));
  connect(THeaWatSecSup, chaStaHea.TSecSup)
    annotation(Line(points={{-280,-60},{-250,-60},{-250,316},{-42,316}},
      color={0,0,127}));
  connect(TChiWatSecSup, chaStaCoo.TSecSup)
    annotation(Line(points={{-280,-140},{-248,-140},{-248,56},{-42,56}},
      color={0,0,127}));
  connect(THeaWatPriSup, chaStaHea.TPriSup)
    annotation(Line(points={{-280,60},{-252,60},{-252,318},{-42,318}},
      color={0,0,127}));
  connect(ctlPumHeaWatSec.y, staPumHeaWatSec.y)
    annotation(Line(
      points={{162,20},{166,20},{166,148},{136,148},{136,152},{138,152}},
      color={0,0,127}));
  connect(ctlPumChiWatSec.y, staPumChiWatSec.y)
    annotation(Line(
      points={{212,-8},{218,-8},{218,126},{186,126},{186,132},{188,132}},
      color={0,0,127}));
  connect(ctlPumHeaWatSec.dpLocSetMax, staPumHeaWatSec.dpSet[1])
    annotation(Line(
      points={{162,16},{164,16},{164,146},{132,146},{132,156},{138,156}},
      color={0,0,127}));
  connect(ctlPumChiWatSec.dpLocSetMax, staPumChiWatSec.dpSet[1])
    annotation(Line(
      points={{212,-12},{216,-12},{216,124},{182,124},{182,136},{188,136}},
      color={0,0,127}));
  connect(dpHeaWatLoc, staPumHeaWatSec.dp[1])
    annotation(Line(points={{-280,-260},{134,-260},{134,154},{138,154}},
      color={0,0,127}));
  connect(dpChiWatLoc, staPumChiWatSec.dp[1])
    annotation(Line(points={{-280,-320},{184,-320},{184,134},{188,134}},
      color={0,0,127}));
  connect(dpChiWatRem, staPumChiWatSec.dp)
    annotation(Line(points={{-280,-280},{180,-280},{180,134},{188,134}},
      color={0,0,127}));
  connect(dpHeaWatRem, staPumHeaWatSec.dp)
    annotation(Line(points={{-280,-220},{130,-220},{130,154},{138,154}},
      color={0,0,127}));
  connect(resHeaWat.dpSet, pasDpHeaWatRemSet.u)
    annotation(Line(points={{72,246},{82,246},{82,280},{88,280}},
      color={0,0,127}));
  connect(pasDpHeaWatRemSet.y, staPumHeaWatSec.dpSet)
    annotation(Line(points={{112,280},{126,280},{126,156},{138,156}},
      color={0,0,127}));
  connect(pasDpChiWatRemSet.y, staPumChiWatSec.dpSet)
    annotation(Line(points={{112,60},{128,60},{128,136},{188,136}},
      color={0,0,127}));
  connect(resChiWat.dpSet, pasDpChiWatRemSet.u)
    annotation(Line(points={{72,-34},{80,-34},{80,60},{88,60}},
      color={0,0,127}));
  connect(resChiWat.dpSet, ctlPumPri.dpChiWatRemSet)
    annotation(Line(points={{72,-34},{178,-34},{178,62},{188,62}},
      color={0,0,127}));
  connect(resHeaWat.dpSet, ctlPumPri.dpHeaWatRemSet)
    annotation(Line(points={{72,246},{122,246},{122,84},{188,84}},
      color={0,0,127}));
  connect(dpHeaWatRem, ctlPumPri.dpHeaWatRem)
    annotation(Line(points={{-280,-220},{130,-220},{130,82},{188,82}},
      color={0,0,127}));
  connect(dpHeaWatLocSet, ctlPumPri.dpHeaWatLocSet)
    annotation(Line(points={{-280,-240},{132,-240},{132,80},{188,80}},
      color={0,0,127}));
  connect(dpHeaWatLoc, ctlPumPri.dpHeaWatLoc)
    annotation(Line(points={{-280,-260},{134,-260},{134,78},{188,78}},
      color={0,0,127}));
  connect(pasDpHeaWatRemSet.y, staPumHeaWatPri.dpSet)
    annotation(Line(points={{112,280},{126,280},{126,196},{138,196}},
      color={0,0,127}));
  connect(pasDpChiWatRemSet.y, staPumChiWatPri.dpSet)
    annotation(Line(points={{112,60},{128,60},{128,176},{188,176}},
      color={0,0,127}));
  connect(ctlPumPri.dpChiWatLocSetMax, staPumChiWatPri.dpSet[1])
    annotation(Line(
      points={{212,84},{214,84},{214,108},{168,108},{168,176},{188,176}},
      color={0,0,127}));
  connect(ctlPumPri.dpHeaWatLocSetMax, staPumHeaWatPri.dpSet[1])
    annotation(Line(points={{212,88},{212,106},{124,106},{124,196},{138,196}},
      color={0,0,127}));
  connect(ctlPumPri.yPumHeaWatPriHdr, staPumHeaWatPri.y)
    annotation(Line(
      points={{212,76},{220,76},{220,110},{136,110},{136,192},{138,192}},
      color={0,0,127}));
  connect(ctlPumPri.yPumChiWatPriHdr, staPumChiWatPri.y)
    annotation(Line(
      points={{212,72},{222,72},{222,112},{178,112},{178,172},{188,172}},
      color={0,0,127}));
  connect(ctlPumPri.yPumChiWatPriDedHp, yPumChiWatPriDedHp)
    annotation(Line(points={{212,64},{220,64},{220,0},{280,0}},
      color={0,0,127}));
  connect(ctlPumPri.yPumChiWatPriDedPhp, yPumChiWatPriDedPhp)
    annotation(Line(points={{212,56},{220,56},{220,-20},{280,-20}},
      color={0,0,127}));
  connect(u1PumHeaWatPriHdr_actual, ctlPumPri.u1PumHeaWatPriHdr_actual)
    annotation(Line(points={{-280,240},{-258,240},{-258,86},{110,86},{110,90},{188,
          90}},
      color={255,0,255}));
  connect(u1PumChiWatPriHdr_actual, ctlPumPri.u1PumChiWatPriHdr_actual)
    annotation(Line(points={{-280,180},{114,180},{114,68},{188,68}},
      color={255,0,255}));
  connect(u1PumHeaWatPriDedHp_actual, ctlPumPri.u1PumHeaWatPriDedHp_actual)
    annotation(Line(points={{-280,220},{-258,220},{-258,86},{-36,86},{-36,88},{
          188,88}},
      color={255,0,255}));
  connect(u1PumChiWatPriDedHp_actual, ctlPumPri.u1PumChiWatPriDedHp_actual)
    annotation(Line(points={{-280,160},{-256,160},{-256,84},{176,84},{176,66},{
          188,66}},
      color={255,0,255}));
  connect(u1PumHeaWatPriDedPhp_actual, ctlPumPri.u1PumHeaWatPriDedPhp_actual)
    annotation(Line(points={{-280,200},{116,200},{116,86},{188,86}},
      color={255,0,255}));
  connect(u1PumChiWatPriDedPhp_actual, ctlPumPri.u1PumChiWatPriDedPhp_actual)
    annotation(Line(points={{-280,140},{114,140},{114,64},{188,64}},
      color={255,0,255}));
  connect(dpChiWatRem, ctlPumPri.dpChiWatRem)
    annotation(Line(points={{-280,-280},{180,-280},{180,60},{188,60}},
      color={0,0,127}));
  connect(dpChiWatLocSet, ctlPumPri.dpChiWatLocSet)
    annotation(Line(points={{-280,-300},{182,-300},{182,58},{188,58}},
      color={0,0,127}));
  connect(dpChiWatLoc, ctlPumPri.dpChiWatLoc)
    annotation(Line(points={{-280,-320},{184,-320},{184,56},{188,56}},
      color={0,0,127}));
  connect(dpHeaWatRem, staPumHeaWatPri.dp)
    annotation(Line(points={{-280,-220},{130,-220},{130,194},{138,194}},
      color={0,0,127}));
  connect(dpChiWatRem, staPumChiWatPri.dp)
    annotation(Line(points={{-280,-280},{182,-280},{182,174},{188,174}},
      color={0,0,127}));
  connect(dpHeaWatLoc, staPumHeaWatPri.dp[1])
    annotation(Line(points={{-280,-260},{134,-260},{134,194},{138,194}},
      color={0,0,127}));
  connect(dpChiWatLoc, staPumChiWatPri.dp[1])
    annotation(Line(points={{-280,-320},{184,-320},{184,174},{188,174}},
      color={0,0,127}));
  connect(VChiWatPri_flow, staPumChiWatPri.V_flow)
    annotation(Line(points={{-280,-40},{-254,-40},{-254,178},{188,178}},
      color={0,0,127}));
  connect(VHeaWatPri_flow, staPumHeaWatPri.V_flow)
    annotation(Line(points={{-280,20},{-244,20},{-244,198},{138,198}},
      color={0,0,127}));
  connect(ctlFloMin.yValHeaWatMinByp, yValHeaWatMinByp)
    annotation(Line(points={{224,-240},{280,-240}},
      color={0,0,127}));
  connect(ctlFloMin.yValChiWatMinByp, yValChiWatMinByp)
    annotation(Line(points={{224,-244},{252,-244},{252,-260},{280,-260}},
      color={0,0,127}));
  connect(y1Hp, ctlFloMin.u1Hp)
    annotation(Line(
      points={{280,480},{238,480},{238,-98},{190,-98},{190,-219.8},{200,-219.8}},
      color={255,0,255}));
  connect(y1HeaHp, ctlFloMin.u1HeaHp)
    annotation(Line(
      points={{280,460},{238,460},{238,-98},{190,-98},{190,-221.8},{200,-221.8}},
      color={255,0,255}));
  connect(y1HeaPhp, ctlFloMin.u1HeaPhp)
    annotation(Line(
      points={{280,440},{238,440},{238,-98},{190,-98},{190,-221.8},{200,-221.8}},
      color={255,0,255}));
  connect(y1CooPhp, ctlFloMin.u1CooPhp)
    annotation(Line(
      points={{280,420},{238,420},{238,-98},{190,-98},{190,-221.8},{200,-221.8}},
      color={255,0,255}));
  connect(seqEve.y1ValHeaWatInlIso, ctlFloMin.u1ValHeaWatInlIso)
    annotation(Line(
      points={{162,300},{242,300},{242,-198},{194,-198},{194,-223.8},{200,-223.8}},
      color={255,0,255}));
  connect(seqEve.y1ValHeaWatOutIso, ctlFloMin.u1ValHeaWatOutIso)
    annotation(Line(
      points={{162,298},{242,298},{242,-202},{194,-202},{194,-225.8},{200,-225.8}},
      color={255,0,255}));
  connect(seqEve.y1ValChiWatInlIso, ctlFloMin.u1ValChiWatInlIso)
    annotation(Line(
      points={{162,296},{244,296},{244,-204},{196,-204},{196,-227.8},{200,-227.8}},
      color={255,0,255}));
  connect(seqEve.y1ValChiWatOutIso, ctlFloMin.u1ValChiWatOutIso)
    annotation(Line(
      points={{162,294},{246,294},{246,-206},{198,-206},{198,-229.8},{200,-229.8}},
      color={255,0,255}));
  connect(u1PumHeaWatPriDedHp_actual, ctlFloMin.u1PumHeaWatPriDedHp_actual)
    annotation(Line(points={{-280,220},{-258,220},{-258,86},{112,86},{112,
          -233.8},{200,-233.8}},
      color={255,0,255}));
  connect(u1PumHeaWatPriDedPhp_actual, ctlFloMin.u1PumHeaWatPriDedPhp_actual)
    annotation(Line(points={{-280,200},{116,200},{116,-235.8},{200,-235.8}},
      color={255,0,255}));
  connect(u1PumChiWatPriDedHp_actual, ctlFloMin.u1PumChiWatPriDedHp_actual)
    annotation(Line(points={{-280,160},{-258,160},{-258,-239.8},{200,-239.8}},
      color={255,0,255}));
  connect(u1PumChiWatPriDedPhp_actual, ctlFloMin.u1PumChiWatPriDedPhp_actual)
    annotation(Line(points={{-280,140},{114,140},{114,-241.8},{200,-241.8}},
      color={255,0,255}));
  connect(VHeaWatPri_flow, ctlFloMin.VHeaWatPri_flow)
    annotation(Line(points={{-280,20},{-244,20},{-244,-243.8},{200,-243.8}},
      color={0,0,127}));
  connect(VChiWatPri_flow, ctlFloMin.VChiWatPri_flow)
    annotation(Line(points={{-280,-40},{-254,-40},{-254,-245.8},{200,-245.8}},
      color={0,0,127}));
  connect(VHeaWatSec_flow, VHeaWatLoa_flow.uPh)
    annotation(Line(points={{-280,-120},{-156,-120},{-156,-66},{-142,-66}},
      color={0,0,127}));
  connect(VHeaWatPri_flow, VHeaWatLoa_flow.u)
    annotation(Line(points={{-280,20},{-244,20},{-244,-60},{-142,-60}},
      color={0,0,127}));
  connect(VChiWatSec_flow, VChiWatLoa_flow.uPh)
    annotation(Line(points={{-280,-200},{-154,-200},{-154,-106},{-142,-106}},
      color={0,0,127}));
  connect(VChiWatPri_flow, VChiWatLoa_flow.u)
    annotation(Line(points={{-280,-40},{-254,-40},{-254,-100},{-142,-100}},
      color={0,0,127}));
  connect(VChiWatLoa_flow.y, hrc.VChiWatLoa_flow)
    annotation(Line(points={{-118,-100},{-100,-100},{-100,-308},{198,-308}},
      color={0,0,127}));
  connect(VHeaWatLoa_flow.y, hrc.VHeaWatLoa_flow)
    annotation(Line(points={{-118,-60},{-98,-60},{-98,-318},{198,-318}},
      color={0,0,127}));
  connect(repTHeaWatSupHpSet.y, THeaWatSupHpSet)
    annotation (Line(points={{174,-120},{280,-120}}, color={0,0,127}));
  connect(repTChiWatSupHpSet.y, TChiWatSupHpSet)
    annotation (Line(points={{232,-140},{280,-140}}, color={0,0,127}));
  connect(TChiWatSupSet, TChiWatSupHrcSet)
    annotation(Line(points={{280,-220},{250,-220},{250,-340},{280,-340}},
      color={0,0,127}));
  connect(THeaWatSupSet, THeaWatSupHrcSet)
    annotation(Line(points={{280,-200},{248,-200},{248,-320},{280,-320}},
      color={0,0,127}));
  connect(idxStaCoo.y, avaStaHea.uStaOpp)
    annotation(Line(
      points={{12,100},{16,100},{16,122},{-118,122},{-118,336},{-112,336}},
      color={255,127,0}));
  connect(idxStaHea.y, avaStaCoo.uStaOpp)
    annotation(Line(
      points={{12,360},{20,360},{20,120},{-116,120},{-116,76},{-112,76}},
      color={255,127,0}));
  connect(idxStaCoo.y, chaStaHea.uStaOpp)
    annotation(Line(
      points={{12,100},{16,100},{16,122},{-118,122},{-118,346},{-48,346},{-48,
          330},{-42,330}},
      color={255,127,0}));
  connect(idxStaHea.y, chaStaCoo.uStaOpp)
    annotation(Line(
      points={{12,360},{20,360},{20,120},{-116,120},{-116,86},{-46,86},{-46,70},
          {-42,70}},
      color={255,127,0}));
  connect(chaStaHea.staTra, enaEquHea.staTra)
    annotation(Line(points={{-18,330},{22,330},{22,368},{38,368}},
      color={0,0,127}));
  connect(chaStaCoo.staTra, enaEquCoo.staTra)
    annotation(Line(points={{-18,70},{22,70},{22,108},{48,108}},
      color={0,0,127}));
  connect(sorRunTimHp.yIdx,enaEquHea.uIdxSorHp)
    annotation(Line(points={{-128,264},{24,264},{24,366},{38,366}},
      color={255,127,0}));
  connect(sorRunTimPhp.yIdx,enaEquHea.uIdxSorPhp)
    annotation(Line(points={{-128,454},{26,454},{26,364},{38,364}},
      color={255,127,0}));
  connect(sorRunTimHp.yIdx,enaEquCoo.uIdxSorHp)
    annotation(Line(points={{-128,264},{24,264},{24,106},{48,106}},
      color={255,127,0}));
  connect(sorRunTimPhp.yIdx,enaEquCoo.uIdxSorPhp)
    annotation(Line(points={{-128,454},{26,454},{26,104},{48,104}},
      color={255,127,0}));
  connect(u1AvaHp.y, avaHeaCooHp.u1Ava)
    annotation(Line(points={{-218,280},{-200,280},{-200,240},{-152,240}},
      color={255,0,255}));
  connect(avaHeaCooHp.y1Hea, avaStaHea.u1Ava[1:nHp])
    annotation(Line(points={{-128,246},{-120,246},{-120,330},{-112,330}},
      color={255,0,255}));
  connect(avaHeaCooHp.y1Coo, avaStaCoo.u1Ava[1:nHp])
    annotation(Line(points={{-128,234},{-120,234},{-120,70},{-112,70}},
      color={255,0,255}));
  connect(avaHeaCooPhp.y1Coo, avaStaCoo.u1Ava[nHp + 1:nHp + nPhp])
    annotation(Line(points={{-128,394},{-120,394},{-120,70},{-112,70}},
      color={255,0,255}));
  connect(avaHeaCooPhp.y1Shc, avaStaCoo.u1Ava[nHp + nPhp + 1:nHp + 2 * nPhp])
    annotation(Line(points={{-128,400},{-120,400},{-120,70},{-112,70}},
      color={255,0,255}));
  connect(avaHeaCooPhp.y1Hea, avaStaHea.u1Ava[nHp + 1:nHp + nPhp])
    annotation(Line(points={{-128,406},{-120,406},{-120,330},{-112,330}},
      color={255,0,255}));
  connect(avaHeaCooPhp.y1Shc, avaStaHea.u1Ava[nHp + nPhp + 1:nHp + 2 * nPhp])
    annotation(Line(points={{-128,400},{-120,400},{-120,330},{-112,330}},
      color={255,0,255}));
  connect(u1AvaPhp.y, avaHeaCooPhp.u1Ava)
    annotation(Line(points={{-218,420},{-170,420},{-170,400},{-152,400}},
      color={255,0,255}));
  connect(enaEquHea.y1Php1Or2, avaHeaCooPhp.u1EnaHea)
    annotation(Line(
      points={{62,352},{78,352},{78,416},{-160,416},{-160,406},{-152,406}},
      color={255,0,255}));
  connect(enaEquHea.y1Hp, avaHeaCooHp.u1EnaHea)
    annotation(Line(
      points={{62,368},{70,368},{70,378},{-158,378},{-158,246},{-152,246}},
      color={255,0,255}));
  connect(enaEquCoo.y1Php1Or2, avaHeaCooPhp.u1EnaCoo)
    annotation(Line(
      points={{72,92},{80,92},{80,386},{-160,386},{-160,394},{-152,394}},
      color={255,0,255}));
  connect(enaEquCoo.y1Hp, avaHeaCooHp.u1EnaCoo)
    annotation(Line(
      points={{72,108},{78,108},{78,218},{-158,218},{-158,234},{-152,234}},
      color={255,0,255}));
  connect(avaHeaCooHp.y1Coo,enaEquCoo.u1AvaHp)
    annotation(Line(
      points={{-128,234},{-120,234},{-120,116},{40,116},{40,96},{48,96}},
      color={255,0,255}));
  connect(avaHeaCooHp.y1Hea,enaEquHea.u1AvaHp)
    annotation(Line(points={{-128,246},{28,246},{28,356},{38,356}},
      color={255,0,255}));
  connect(avaHeaCooPhp.y1Hea,enaEquHea.u1AvaPhp1)
    annotation(Line(points={{-128,406},{36,406},{36,354},{38,354}},
      color={255,0,255}));
  connect(avaHeaCooPhp.y1Shc,enaEquHea.u1AvaPhp2)
    annotation(Line(points={{-128,400},{34,400},{34,352},{38,352}},
      color={255,0,255}));
  connect(avaHeaCooPhp.y1Coo,enaEquCoo.u1AvaPhp1)
    annotation(Line(points={{-128,394},{32,394},{32,94},{48,94}},
      color={255,0,255}));
  connect(avaHeaCooPhp.y1Shc,enaEquCoo.u1AvaPhp2)
    annotation(Line(points={{-128,400},{34,400},{34,92},{48,92}},
      color={255,0,255}));
  connect(enaEquHea.y1Php2, seqEve.u1Shc)
    annotation(Line(points={{62,360},{70,360},{70,306},{138,306}},
      color={255,0,255}));
  connect(enaEquHea.y1HpPhp1, seqEve.u1Hea)
    annotation(Line(points={{62,356},{68,356},{68,310},{138,310}},
      color={255,0,255}));
  connect(enaEquCoo.y1HpPhp1, seqEve.u1Coo)
    annotation(Line(points={{72,96},{84,96},{84,308},{138,308}},
      color={255,0,255}));
  connect(seqEve[nHp + 1:nHp + nPhp].y1ValHeaWatInlIso, y1ValHeaWatPhpInlIso)
    annotation(Line(points={{162,300},{242,300},{242,320},{280,320}},
      color={255,0,255}));
  connect(seqEve[nHp + 1:nHp + nPhp].y1ValChiWatInlIso, y1ValChiWatPhpInlIso)
    annotation(Line(points={{162,296},{238,296},{238,280},{280,280}},
      color={255,0,255}));
  connect(seqEve[nHp + 1:nHp + nPhp].y1ValHeaWatOutIso, y1ValHeaWatPhpOutIso)
    annotation(Line(points={{162,298},{242,298},{242,300},{280,300}},
      color={255,0,255}));
  connect(seqEve[nHp + 1:nHp + nPhp].y1ValChiWatOutIso, y1ValChiWatPhpOutIso)
    annotation(Line(points={{162,294},{238,294},{238,260},{280,260}},
      color={255,0,255}));
  connect(seqEve[nHp + 1:nHp + nPhp].y1AndHea, y1HeaPhp)
    annotation(Line(points={{162,306},{236,306},{236,440},{280,440}},
      color={255,0,255}));
  connect(seqEve[nHp + 1:nHp + nPhp].y1AndCoo, y1CooPhp)
    annotation(Line(points={{162,304},{234,304},{234,420},{280,420}},
      color={255,0,255}));
  connect(y1HeaPhp, y1ShcPhp.u1)
    annotation(Line(points={{280,440},{220,440},{220,460},{202,460}},
      color={255,0,255}));
  connect(y1CooPhp, y1ShcPhp.u2)
    annotation(Line(points={{280,420},{214,420},{214,452},{202,452}},
      color={255,0,255}));
  connect(idxStaCoo.y, idxStaHea.uStaOpp)
    annotation(Line(
      points={{12,100},{15.7576,100},{15.7576,130.121},{-118.182,130.121},{-118.182,346},{-48,346},{-48,351},{-12,351}},
      color={255,127,0}));
  connect(idxStaHea.y, idxStaCoo.uStaOpp)
    annotation(Line(
      points={{12,360},{20,360},{20,120},{-116.061,120},{-116.061,96},{-116,96},{-116,86},{-46,86},{-46,91},{-12,91}},
      color={255,127,0}));
  connect(u1PumChiWatPriHdr_actual, rouPumChiWatPri.u1PumPriHdr_actual)
    annotation(Line(points={{-280,180},{-256,180},{-256,168},{-232,168}},
      color={255,0,255}));
  connect(u1PumChiWatPriDedHp_actual, rouPumChiWatPri.u1PumPriDedHp_actual)
    annotation(Line(points={{-280,160},{-232,160}},
      color={255,0,255}));
  connect(u1PumChiWatPriDedPhp_actual, rouPumChiWatPri.u1PumPriDedPhp_actual)
    annotation(Line(points={{-280,140},{-256,140},{-256,151.8},{-232,151.8}},
      color={255,0,255}));
  connect(u1PumHeaWatPriHdr_actual, rouPumHeaWatPri.u1PumPriHdr_actual)
    annotation(Line(points={{-280,240},{-244,240},{-244,228},{-232,228}},
      color={255,0,255}));
  connect(u1PumHeaWatPriDedHp_actual, rouPumHeaWatPri.u1PumPriDedHp_actual)
    annotation(Line(points={{-280,220},{-232,220}},
      color={255,0,255}));
  connect(u1PumHeaWatPriDedPhp_actual, rouPumHeaWatPri.u1PumPriDedPhp_actual)
    annotation(Line(points={{-280,200},{-256,200},{-256,211.8},{-232,211.8}},
      color={255,0,255}));
  connect(con.y, mulOr.u[1]) annotation (Line(points={{122,-400},{160,-400},{160,
          -422.333},{168,-422.333}},     color={255,0,255}));
  connect(con1.y, mulOr.u[2]) annotation (Line(points={{152,-420},{160,-420},{
          160,-420},{168,-420}}, color={255,0,255}));
  connect(con2.y, mulOr.u[3]) annotation (Line(points={{122,-440},{160,-440},{160,
          -417.667},{168,-417.667}},     color={255,0,255}));
  connect(mulOr.y, assMes.u)
    annotation (Line(points={{192,-420},{208,-420}}, color={255,0,255}));
  connect(enaEquHea.y1Hp, y1EnaHeaHol.u)
    annotation (Line(points={{62,368},{98,368}}, color={255,0,255}));
  connect(resChiWat.TSupSet, repTChiWatSupPhpSet.u) annotation (Line(points={{72,
          -46},{116,-46},{116,-180},{208,-180}}, color={0,0,127}));
  connect(resHeaWat.TSupSet, repTHeaWatSupPhpSet.u) annotation (Line(points={{72,
          234},{118,234},{118,-160},{148,-160}}, color={0,0,127}));
  connect(repTHeaWatSupPhpSet.y, THeaWatSupPhpSet)
    annotation (Line(points={{172,-160},{280,-160}}, color={0,0,127}));
  connect(repTChiWatSupPhpSet.y, TChiWatSupPhpSet)
    annotation (Line(points={{232,-180},{280,-180}}, color={0,0,127}));
annotation(defaultComponentName="ctl",
  Icon(coordinateSystem(preserveAspectRatio=true,
    extent={{-200,-460},{200,460}},
    grid={2,2}),
    graphics={Rectangle(extent={{-200,460},{200,-460}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(extent={{-150,510},{150,470}},
      textString="%name",
      textColor={0,0,255})}),
  Diagram(coordinateSystem(extent={{-200,-460},{200,460}},
    grid={2,2})),
  Documentation(
    info="<html>
<p>
  This block implements the sequence of operation for plants with air-to-water
  heat pumps. Most parts of the sequence of operation are similar to that
  described in ASHRAE, 2021 for chiller plants.
</p>
<p>
  The supported plant configurations are enumerated in the table below.<br />
</p>
<table summary=\"summary\" border=\"1\">
  <tr>
    <th>Configuration parameter</th>
    <th>Options</th>
    <th>Notes</th>
  </tr>
  <tr>
    <td>Function</td>
    <td>
      Heating and cooling<br />
      Heating-only<br />
      Cooling-only
    </td>
    <td></td>
  </tr>
  <tr>
    <td>Heat recovery</td>
    <td>
      Without sidestream heat recovery chiller<br />
      With sidestream heat recovery chiller
    </td>
    <td>
      This option is only available for heating and cooling plants. When
      selected, the plant controller incorporates logic to manage a chiller
      and its associated dedicated primary CHW and CW pumps. The chiller is
      considered connected in a sidestream configuration to both the CHW
      return and the HW return.
    </td>
  </tr>
  <tr>
    <td>Type of distribution</td>
    <td>
      Variable primary-only<br />
      Constant primary-variable secondary centralized
    </td>
    <td>
      It is assumed that the HW and the CHW loops have the same type of
      distribution, as specified by this parameter.<br />
      Most AWHPs on the market use a reverse cycle for defrosting. This
      requires maximum primary flow during defrost cycles. Consequently,
      variable primary plants commonly adopt a high minimum flow setpoint,
      typically close to the design flow rate, effectively operating akin to
      constant primary plants but with variable speed pumps controlling the
      loop differential pressure. While the flow rate directed towards the
      loads varies, the bypass valve control loop ensures a constant primary
      flow for a given number of staged units.<br />
      \"Centralized secondary pumps\" refers to configurations with a single
      group of secondary pumps that is typically integrated into the plant.<br />
      Distributed secondary pumps with multiple secondary loops served by
      dedicated secondary pumps are currently not supported.
    </td>
  </tr>
  <tr>
    <td>Type of primary pump arrangement</td>
    <td>
      Dedicated<br />
      Headered
    </td>
    <td>
      It is assumed that the HW and the CHW loops have the same type of
      primary pump arrangement, as specified by this parameter.
    </td>
  </tr>
  <tr>
    <td>Separate dedicated primary CHW pumps</td>
    <td>
      False<br />
      True
    </td>
    <td>
      This option is only available for heating and cooling plants with
      dedicated primary pumps. If this option is not selected, each AWHP uses
      a common dedicated primary pump for HW and CHW – this pump is then
      denoted as the primary HW pump. Otherwise, each AWHP relies on a
      separate dedicated HW pump and a separate dedicated CHW pump.
    </td>
  </tr>
  <tr>
    <td>Type of primary HW pumps</td>
    <td>
      Variable speed<br />
      Constant speed
    </td>
    <td>
      For constant primary-variable secondary distributions, the variable
      speed primary pumps are commanded at fixed speeds, determined during the
      Testing, Adjusting and Balancing phase to provide design AWHP flow in
      heating and cooling modes. The same intent is achieved with constant
      speed primary pumps through the use of balancing valves.<br />
      This parameter is only available for constant primary-variable secondary
      plants.
    </td>
  </tr>
  <tr>
    <td>Type of primary CHW pumps</td>
    <td>
      Variable speed<br />
      Constant speed
    </td>
    <td>See the note above on primary HW pumps.</td>
  </tr>
</table>
<h4>Details</h4>
<p>
  A staging matrix <code>staEqu</code> is required as a parameter. See the
  documentation of
  <a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable\">
    Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable</a>
  for the associated definition and requirements.
</p>
<p>
  Depending on the plant configuration, the term \"primary HW pumps\" (and the
  corresponding variables containing <code>*pumHeaWatPri*</code>) refers
  either to primary HW pumps for plants with separate primary HW and CHW pumps
  (either headered or dedicated) or to dedicated primary pumps for plants with
  common primary pumps serving both the HW and CHW loops.
</p>
<p>
  At its current stage of development, this controller contains no logic for
  handling faulted equipment. It is therefore assumed that any equipment is
  available at all times.
</p>
<h4>References</h4>
<ul>
  <li id=\"ASHRAE2021\">
    ASHRAE, 2021. Guideline 36-2021, High-Performance Sequences of Operation
    for HVAC Systems. Atlanta, GA.
  </li>
</ul>
</html>",
    revisions="<html>
<ul>
  <li>
    June 10, 2026, by Antoine Gautier:<br />
    Refactored with a single instance of <code>SortRuntime</code> for both
    modes.<br />
    This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4624\">#4624</a>.
  </li>
  <li>
    March 23, 2026, by Antoine Gautier:<br />
    Refactored HP and HRC points with two separate outputs for HW and CHW
    supply temperature setpoints.<br />
    This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4507\">#4507</a>.
  </li>
  <li>
    January 23, 2025, by Antoine Gautier:<br />
    Refactored to use \"required to run\" conditions in the equipment
    availability logic.<br />
    This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4432\">#4432</a>.
  </li>
  <li>
    May 31, 2024, by Antoine Gautier:<br />
    Added sidestream heat recovery chiller, primary-only pumping and failsafe
    staging conditions.<br />
    This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3808\">#3808</a>.
  </li>
  <li>
    March 29, 2024, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end AirToWater;
