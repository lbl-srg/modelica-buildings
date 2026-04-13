within Buildings.Templates.Plants.Controls.HeatPumps;
block AirToWater
  "Controller for AWHP plant"

  final parameter Boolean have_sorRunTim=true
    "Set to true if the staging order algorithm includes the sequence of sorting
    runtime for equipment rotation";

  parameter Boolean have_heaWat
    "Set to true for plants that provide HW"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));

  parameter Boolean have_chiWat
    "Set to true for plants that provide CHW"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));

  parameter Boolean is_priOnl=false
    "Set to true for primary-only plant"
    annotation(Evaluate=true,
    Dialog(group="Plant configuration"));
  parameter Boolean have_hrc_select(start=false)=false
    "Set to true for plants with sidestream heat recovery chiller"
    annotation (Dialog(group="Plant configuration", enable=have_heaWat and have_chiWat));
  final parameter Boolean have_hrc=if have_heaWat and have_chiWat then have_hrc_select
    else false
    "Set to true for plants with sidestream heat recovery chiller"
    annotation (Evaluate=true);
  parameter Boolean have_valHpInlIso
    "Set to true for plants with isolation valves at heat pump inlet"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));
  parameter Boolean have_valHpOutIso
    "Set to true for plants with isolation valves at heat pump outlet"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));
  final parameter Boolean have_pumHeaWatPri=have_heaWat
    "Set to true for plants with primary HW pumps"
    annotation (Evaluate=true);
  parameter Boolean have_pumChiWatPriDed_select(start=false)=false
    "Set to true for plants with separate dedicated primary CHW pumps"
    annotation (Evaluate=true,
    Dialog(enable=have_chiWat and not have_pumPriHdr, group="Plant configuration"));
  final parameter Boolean have_pumChiWatPriDed=
    if have_chiWat and not have_pumPriHdr then have_pumChiWatPriDed_select else false
    "Set to true for plants with separate dedicated primary CHW pumps"
    annotation (Evaluate=true);
  final parameter Boolean have_pumChiWatPri=
    have_chiWat and (have_pumPriHdr or have_pumChiWatPriDed)
    "Set to true for plants with separate primary CHW pumps"
    annotation (Evaluate=true);
  parameter Boolean have_pumPriHdr
    "Set to true for headered primary pumps, false for dedicated pumps"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));
  parameter Boolean have_pumHeaWatPriVar_select(start=true)=true
    "Set to true for variable speed primary HW pumps, false for constant speed pumps"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration", enable=have_pumHeaWatPri and not is_priOnl));
  parameter Boolean have_pumChiWatPriVar_select(start=true)=true
    "Set to true for variable speed primary CHW pumps, false for constant speed pumps"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration", enable=have_pumChiWatPri and not is_priOnl));
  final parameter Boolean have_pumHeaWatPriVar=
    have_pumHeaWatPri and (is_priOnl or have_pumHeaWatPriVar_select)
    "Set to true for variable speed primary HW pumps, false for constant speed pumps"
    annotation (Evaluate=true);
  final parameter Boolean have_pumChiWatPriVar=
    have_pumChiWatPri and (is_priOnl or have_pumChiWatPriVar_select)
    "Set to true for variable speed primary CHW pumps, false for constant speed pumps"
    annotation (Evaluate=true);
  final parameter Boolean have_pumPriCtlDp=is_priOnl
    "Set to true for primary variable speed pumps using ∆p pump speed control"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));
  final parameter Boolean have_pumHeaWatSec=
    have_heaWat and not is_priOnl
    "Set to true for plants with secondary HW pumps"
    annotation (Evaluate=true);
  final parameter Boolean have_pumChiWatSec=
    have_chiWat and not is_priOnl
    "Set to true for plants with secondary CHW pumps"
    annotation (Evaluate=true);
  // Only headered arrangements are supported for secondary pumps.
  final parameter Boolean have_pumSecHdr=true
    "Set to true for headered secondary pumps, false for dedicated pumps"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));
  // Only ∆p controlled variable speed pumps are supported for secondary pumps.
  final parameter Boolean have_pumSecCtlDp=have_pumHeaWatSec or have_pumChiWatSec
    "Set to true for secondary variable speed pumps using ∆p pump speed control"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));
  parameter Boolean have_senVHeaWatPri_select(start=false)
    "Set to true for plants with primary HW flow sensor"
    annotation (Evaluate=true,
    Dialog(group="Sensors",
      enable=have_heaWat and not have_hrc and have_senVHeaWatSec));
  final parameter Boolean have_senVHeaWatPri=have_heaWat and
    (if have_hrc or not have_senVHeaWatSec then true else have_senVHeaWatPri_select)
    "Set to true for plants with primary HW flow sensor"
    annotation (Evaluate=true, Dialog(group="Sensors"));
  // Secondary flow sensor required for secondary HW pump staging.
  final parameter Boolean have_senVHeaWatSec=have_pumHeaWatSec
    "Set to true for plants with secondary HW flow sensor"
    annotation (Evaluate=true, Dialog(group="Sensors"));
  parameter Boolean have_senVChiWatPri_select(start=false)
    "Set to true for plants with primary CHW flow sensor"
    annotation (Evaluate=true,
    Dialog(group="Sensors",
      enable=have_chiWat and not have_hrc and have_senVChiWatSec));
  final parameter Boolean have_senVChiWatPri=have_chiWat and
    (if have_hrc or not have_senVChiWatSec then true
    else have_senVChiWatPri_select)
    "Set to true for plants with primary CHW flow sensor"
    annotation (Evaluate=true, Dialog(group="Sensors"));
  // Secondary flow sensor required for secondary CHW pump staging.
  final parameter Boolean have_senVChiWatSec(start=false)=have_pumChiWatSec
    "Set to true for plants with secondary CHW flow sensor"
    annotation (Evaluate=true, Dialog(group="Sensors"));
  parameter Boolean have_senTHeaWatPriRet_select(start=false)
    "Set to true for plants with primary HW return temperature sensor"
    annotation (Evaluate=true,
    Dialog(group="Sensors",
      enable=have_heaWat and not have_hrc and have_senTHeaWatSecRet));
  final parameter Boolean have_senTHeaWatPriRet=have_heaWat and
    (if have_hrc or not have_senTHeaWatSecRet then true else have_senTHeaWatPriRet_select)
    "Set to true for plants with primary HW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Sensors"));
  parameter Boolean have_senTChiWatPriRet_select(start=false)
    "Set to true for plants with primary CHW return temperature sensor"
    annotation (Evaluate=true,
    Dialog(group="Sensors",
      enable=have_chiWat and not have_hrc and have_senTChiWatSecRet));
  final parameter Boolean have_senTChiWatPriRet=have_chiWat and
    (if have_hrc or not have_senTChiWatSecRet then true else have_senTChiWatPriRet_select)
    "Set to true for plants with primary CHW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Sensors"));
  // For primary-secondary plants, SHWST sensor is required for plant staging.
  final parameter Boolean have_senTHeaWatSecSup=have_pumHeaWatSec
    "Set to true for plants with secondary HW supply temperature sensor"
    annotation (Evaluate=true, Dialog(group="Sensors"));
  // For primary-secondary plants, SCHWST sensor is required for plant staging.
  final parameter Boolean have_senTChiWatSecSup=have_pumChiWatSec
    "Set to true for plants with secondary CHW supply temperature sensor"
    annotation (Evaluate=true, Dialog(group="Sensors"));
  // Following return temperature sensors are:
  // - optional for primary-secondary plants without HRC,
  // - required for plants with HRC: downstream of HRC.
  parameter Boolean have_senTHeaWatSecRet_select(start=false)=false
    "Set to true for plants with secondary HW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Sensors",
      enable=have_pumHeaWatSec and not have_hrc));
  parameter Boolean have_senTChiWatSecRet_select(start=false)=false
    "Set to true for plants with secondary CHW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Sensors",
    enable=have_pumChiWatSec and not have_hrc));
  final parameter Boolean have_senTHeaWatSecRet=
    if have_hrc then true
    elseif not have_pumHeaWatSec then false
    else have_senTHeaWatSecRet_select
    "Set to true for plants with secondary HW return temperature sensor"
    annotation (Evaluate=true);
  final parameter Boolean have_senTChiWatSecRet(start=false)=
    if have_hrc then true
    elseif not have_pumChiWatSec then false
    else have_senTChiWatSecRet_select
    "Set to true for plants with secondary CHW return temperature sensor"
    annotation (Evaluate=true);

  parameter Integer nHp(min=1)
    "Number of heat pumps. If this is a hybrid plant, this is the number of 2-pipe
    heat pumps"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));

  final parameter Integer nHpTot=if have_fouPip then nHp+1 else nHp
    "Number of heat pumps calculation used for internal logic blocks"
    annotation (Evaluate=true);

  parameter Boolean have_fouPip=false
    "True: The plant is a hybrid heat pump plant with a four-pipe heat pump"
    annotation (Evaluate=true,
      Dialog(group="Plant configuration"));

  final parameter Boolean is_fouPip[nHpTot,1]=if have_fouPip then [fill(false,nHp);have_fouPip] else [fill(false,nHp)]
    "Vector of flag for each heat pump: true - the heat pump is a 4-pipe heat pump";

  parameter Integer nPumHeaWatPri(
    min=if have_pumHeaWatPri then 1 else 0,
    start=0)=nHp
    "Number of primary HW pumps"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration",
      enable=have_pumHeaWatPri));

  final parameter Integer nPumHeaWatPriTot = if have_fouPip then nPumHeaWatPri+1 else nPumHeaWatPri
    "Total number of HW primary pumps to assume for internal logic processing";

  parameter Integer nPumChiWatPri(
    min=if have_pumChiWatPri then 1 else 0,
    start=if have_pumChiWatPri then nHp else 0)=if have_pumChiWatPri then nHp else 0
    "Number of primary CHW pumps"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration",
      enable=have_pumChiWatPri));

  final parameter Integer nPumChiWatPriTot = if have_fouPip then nPumChiWatPri+1 else nPumChiWatPri
    "Total number of CHW primary pumps to assume for internal logic processing";

  parameter Integer nPumHeaWatSec(
    min=if have_pumHeaWatSec then 1 else 0,
    start=0)=nHpTot
    "Number of secondary HW pumps"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration",
      enable=have_pumHeaWatSec));
  parameter Integer nPumChiWatSec(
    min=if have_pumChiWatSec then 1 else 0,
    start=0)=nHpTot
    "Number of secondary CHW pumps"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration",
      enable=have_pumChiWatSec));
  parameter Boolean have_senDpHeaWatRemWir(start=false)=false
    "Set to true for remote HW differential pressure sensor(s) hardwired to plant or pump controller"
    annotation (Evaluate=true,
    Dialog(group="Sensors",
      enable=have_heaWat));
  parameter Integer nSenDpHeaWatRem(
    final min=if have_heaWat then 1 else 0,
    start=0)
    "Number of remote HW differential pressure sensors used for HW pump speed control"
    annotation (Evaluate=true,
    Dialog(group="Sensors",
      enable=have_heaWat and have_pumHeaWatSec));
  parameter Boolean have_senDpChiWatRemWir(start=false)=false
    "Set to true for remote CHW differential pressure sensor(s) hardwired to plant or pump controller"
    annotation (Evaluate=true,
    Dialog(group="Sensors",
      enable=have_chiWat));
  parameter Integer nSenDpChiWatRem(
    final min=if have_chiWat then 1 else 0,
    start=0)
    "Number of remote CHW differential pressure sensors used for CHW pump speed control"
    annotation (Evaluate=true,
    Dialog(group="Sensors",
      enable=have_chiWat));
  parameter Real THeaWatSup_nominal(
    min=273.15,
    start=50 + 273.15,
    unit="K",
    displayUnit="degC")
    "Design HW supply temperature (maximum setpoint)"
    annotation (Dialog(group="Information provided by designer",
      enable=have_heaWat));
  parameter Real THeaWatSupSet_min(
    min=273.15,
    start=25 + 273.15,
    unit="K",
    displayUnit="degC")
    "Minimum value to which the HW supply temperature can be reset"
    annotation (Dialog(group="Information provided by designer",
      enable=have_heaWat));
  parameter Real TOutHeaWatLck(
    min=273.15,
    start=21 + 273.15,
    unit="K",
    displayUnit="degC")=294.15
    "Outdoor air lockout temperature above which the HW loop is prevented from operating"
    annotation (Dialog(group="Information provided by designer",
      enable=have_heaWat));
  parameter Real capHeaHp_nominal[nHpTot](
    min=fill(0, nHpTot),
    start=fill(1, nHpTot),
    unit=fill("W", nHpTot))
    "Design heat pump heating capacity - Each heat pump"
    annotation (Dialog(group="Information provided by designer",
      enable=have_heaWat));
  parameter Real VHeaWatHp_flow_nominal[nHpTot](
    final min=fill(0, nHpTot),
    start=fill(1E-6, nHpTot),
    final unit=fill("m3/s", nHpTot))
    "Design heat pump HW volume flow rate - Each heat pump"
    annotation (Evaluate=true,
    Dialog(group="Information provided by designer",
      enable=have_heaWat and is_priOnl));
  parameter Real VHeaWatHp_flow_min[nHpTot](
    final min=fill(0, nHpTot),
    start=fill(0, nHpTot),
    final unit=fill("m3/s", nHpTot))
    "Minimum heat pump HW volume flow rate - Each heat pump"
    annotation (Evaluate=true,
    Dialog(group="Information provided by designer",
      enable=have_heaWat and is_priOnl));
  parameter Real VHeaWatPri_flow_nominal(
    min=0,
    start=sum(VHeaWatHp_flow_nominal),
    unit="m3/s")=sum(VHeaWatHp_flow_nominal)
    "Primary HW volume flow rate"
    annotation (Evaluate=true,
    Dialog(group="Information provided by designer",
      enable=have_heaWat and is_priOnl and have_pumPriHdr));
  parameter Real VHeaWatSec_flow_nominal(
    min=0,
    start=1E-6,
    unit="m3/s")
    "Design secondary HW volume flow rate"
    annotation (Evaluate=true,
    Dialog(group="Information provided by designer",
      enable=have_heaWat and have_pumHeaWatSec and have_pumSecCtlDp));
  parameter Real dpHeaWatRemSet_max[nSenDpHeaWatRem](
    min=fill(0, nSenDpHeaWatRem),
    start=fill(5E4, nSenDpHeaWatRem),
    unit=fill("Pa", nSenDpHeaWatRem))
    "Maximum HW differential pressure setpoint - Remote sensor"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=have_heaWat and have_pumHeaWatSec));
  parameter Real dpHeaWatRemSet_min(
    min=0,
    start=5*6894,
    unit="Pa")=5*6894
    "Minimum value to which the HW differential pressure can be reset - Remote sensor"
    annotation (Dialog(group=
      "Information provided by designer",
      enable=have_heaWat and have_pumHeaWatSec));
  parameter Real yPumHeaWatPriSet(
    max=2,
    min=0,
    start=1,
    unit="1")=1
    "Primary pump speed providing design heat pump flow in heating mode"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=have_heaWat and have_pumHeaWatPriVar));
  parameter Real TChiWatSup_nominal(
    min=273.15,
    start=7 + 273.15,
    unit="K",
    displayUnit="degC")
    "Design CHW supply temperature (minimum setpoint)"
    annotation (Dialog(group="Information provided by designer",
      enable=have_chiWat));
  parameter Real TChiWatSupSet_max(
    min=273.15,
    start=15 + 273.15,
    unit="K",
    displayUnit="degC")
    "Maximum value to which the CHW supply temperature can be reset"
    annotation (Dialog(group="Information provided by designer",
      enable=have_chiWat));
  parameter Real TOutChiWatLck(
    min=273.15,
    start=16 + 273.15,
    unit="K",
    displayUnit="degC")=289.15
    "Outdoor air lockout temperature below which the CHW loop is prevented from operating"
    annotation (Dialog(group="Information provided by designer",
      enable=have_chiWat));
  parameter Real capCooHp_nominal[nHpTot](
    min=fill(0, nHpTot),
    start=fill(1, nHpTot),
    unit=fill("W", nHpTot))
    "Design heat pump cooling capacity - Each heat pump"
    annotation (Dialog(group="Information provided by designer",
      enable=have_chiWat));
  parameter Real VChiWatHp_flow_nominal[nHpTot](
    final min=fill(0, nHpTot),
    start=fill(1E-6, nHpTot),
    final unit=fill("m3/s", nHpTot))
    "Design heat pump CHW volume flow rate - Each heat pump"
    annotation (Evaluate=true,
    Dialog(group="Information provided by designer",
      enable=have_chiWat and is_priOnl));
  parameter Real VChiWatHp_flow_min[nHpTot](
    final min=fill(0, nHpTot),
    start=fill(0, nHpTot),
    final unit=fill("m3/s", nHpTot))
    "Minimum heat pump CHW volume flow rate - Each heat pump"
    annotation (Evaluate=true,
    Dialog(group="Information provided by designer",
      enable=have_chiWat and is_priOnl));
  parameter Real VChiWatPri_flow_nominal(
    final min=0,
    start=sum(VChiWatHp_flow_nominal),
    final unit="m3/s")=sum(VChiWatHp_flow_nominal)
    "Primary CHW volume flow rate"
    annotation (Evaluate=true,
    Dialog(group="Information provided by designer",
      enable=have_chiWat and is_priOnl and have_pumPriHdr));
  parameter Real VChiWatSec_flow_nominal(
    min=0,
    start=1E-6,
    unit="m3/s")
    "Design secondary CHW volume flow rate"
    annotation (Evaluate=true,
    Dialog(group="Information provided by designer",
      enable=have_pumChiWatSec and have_pumSecCtlDp));
  parameter Real dpChiWatRemSet_max[nSenDpChiWatRem](
    min=fill(0, nSenDpChiWatRem),
    start=fill(5E4, nSenDpChiWatRem),
    unit=fill("Pa", nSenDpChiWatRem))
    "Maximum CHW differential pressure setpoint - Remote sensor"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=have_pumChiWatSec));
  parameter Real dpChiWatRemSet_min(
    min=0,
    start=5*6894,
    unit="Pa")=5*6894
    "Minimum value to which the CHW differential pressure can be reset - Remote sensor"
    annotation (Dialog(group=
      "Information provided by designer",
      enable=have_pumChiWatSec));
  parameter Real yPumChiWatPriSet(
    max=2,
    min=0,
    start=1,
    unit="1")=1
    "Primary pump speed providing design heat pump flow in cooling mode"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=have_chiWat and have_pumChiWatPriVar));
  parameter Real cp_default(
    min=0,
    unit="J/(kg.K)")=4184
    "Default specific heat capacity used to compute required capacity"
    annotation (Evaluate=true,
    Dialog(group="Information provided by designer"));
  parameter Real rho_default(
    min=0,
    unit="kg/m3")=996
    "Default density used to compute required capacity"
    annotation (Evaluate=true,
    Dialog(group="Information provided by designer"));
  parameter Boolean have_inpSch=false
    "Set to true to provide schedule via software input point"
    annotation (Dialog(group="Plant enable"),
    Evaluate=true);
  parameter Real schHea[:, 2](start=[0,1; 24*3600,1])=[0,1; 24*3600,1]
    "Heating mode enable schedule"
    annotation (Dialog(enable=not have_inpSch,group="Plant enable"));
  parameter Real schCoo[:, 2](start=[0,1; 24*3600,1])=[0,1; 24*3600,1]
    "Cooling mode enable schedule"
    annotation (Dialog(enable=not have_inpSch,group="Plant enable"));
  parameter Integer nReqIgnHeaWat(min=0)=0
    "Number of ignored HW plant requests"
    annotation (Dialog(tab="Advanced",group="Plant enable"));
  parameter Integer nReqIgnChiWat(min=0)=0
    "Number of ignored CHW plant requests"
    annotation (Dialog(tab="Advanced",group="Plant enable"));
  parameter Real dTOutLck(
    min=0,
    unit="K")=0.5
    "Hysteresis for outdoor air lockout temperature"
    annotation (Dialog(tab="Advanced",group="Plant enable"));
  parameter Real dtRunEna(
    min=0,
    unit="s")=15*60
    "Minimum runtime of enable and disable states"
    annotation (Dialog(tab="Advanced",group="Plant enable"));

  parameter Real dtReqDis(
    min=0,
    unit="s")=3*60
    "Runtime with low number of request before disabling"
    annotation (Dialog(tab="Advanced",group="Plant enable"));

  parameter Real staEqu[:, nHpTot](
    each final max=1,
    each final min=0,
    each final unit="1")
    "Staging matrix – Equipment required for each stage"
    annotation (Dialog(group="Equipment staging and rotation", enable=not have_fouPip));

  parameter Real staEquDouMod[:, nHpTot](
    each final max=1,
    each final min=0,
    each final unit="1")=staEqu
   "Staging matrix for heating-cooling mode – Equipment required for each stage"
    annotation (Dialog(group="Equipment staging and rotation", enable=have_fouPip));

  parameter Real staEquSinMod[:, nHpTot](
    each final max=1,
    each final min=0,
    each final unit="1")=staEqu
    "Staging matrix for heating-only and cooling-only mode– Equipment required for each stage"
    annotation (Dialog(group="Equipment staging and rotation", enable=have_fouPip));

  final parameter Real staEquTem[:,:]=if have_fouPip then staEquSinMod else staEqu
    "Temporary placeholder";

  final parameter Integer nSta(
    final min=1)=size(staEquTem, 1)
    "Number of stages"
    annotation (Evaluate=true);

  final parameter Integer nEquAlt(
    final min=0)=if nHpTot==1 then 1 else
    max({sum({(if staEquTem[i, j] > 0 and staEquTem[i, j] < 1 then 1 else 0) for j in 1:nHpTot}) for i in 1:nSta})
    "Number of lead/lag alternate equipment"
    annotation (Evaluate=true);

  parameter Integer idxEquAlt[nEquAlt](final min=fill(1, nEquAlt))
    "Indices of lead/lag alternate equipment"
    annotation (Evaluate=true,
    Dialog(group="Equipment staging and rotation"));

  parameter Real plrSta(
    max=1,
    min=0,
    start=0.9,
    unit="1")=0.9
    "Staging part load ratio"
    annotation (Dialog(group="Equipment staging and rotation"));
  parameter Real dTHea(
    min=0,
    unit="K")=2.5
    "Delta-T triggering stage up command for heating appplications (>0)"
    annotation (Dialog(tab="Advanced",group="Equipment staging and rotation",
    enable=have_heaWat));
  parameter Real dTCoo(
    min=0,
    unit="K")=1
    "Delta-T triggering stage up command for cooling applications (>0)"
    annotation (Dialog(tab="Advanced",group="Equipment staging and rotation",
    enable=have_chiWat));
  parameter Real dtVal(
    min=0,
    start=90,
    unit="s")=90
    "Nominal valve timing"
    annotation (Dialog(tab="Advanced",group="Equipment staging and rotation",
      enable=have_valHpInlIso or have_valHpOutIso));
  parameter Real dtRunSta(
    min=0,
    unit="s",
    displayUnit="min")=900
    "Minimum runtime of each stage"
    annotation (Dialog(tab="Advanced",group="Equipment staging and rotation"));
  parameter Real dtOff(
    min=0,
    unit="s")=900
    "Off time required before equipment is deemed available again"
    annotation (Dialog(tab="Advanced",group="Equipment staging and rotation"));
  parameter Real dtOffHp(
    min=0,
    unit="s")=180
    "Heat pump internal shutdown cycle timing (before closing isolation valves or disabling primary pumps)"
    annotation (Dialog(tab="Advanced",group="Equipment staging and rotation"));
  parameter Real dtPri(
    min=0,
    unit="s")=900
    "Runtime with high primary-setpoint Delta-T before staging up"
    annotation (Dialog(tab="Advanced",group="Equipment staging and rotation"));
  parameter Real dtSec(
    min=0,
    start=600,
    unit="s")=600
    "Runtime with high secondary-primary and secondary-setpoint Delta-T before staging up"
    annotation (Dialog(tab="Advanced",group="Equipment staging and rotation",
    enable=have_pumHeaWatSec or have_pumChiWatSec));
  parameter Real dtRunPumSta(
    min=0,
    start=600,
    unit="s")=600
    "Runtime before triggering stage change command based on efficiency condition"
    annotation (Dialog(tab="Advanced",group="Pump staging",
      enable=have_pumPriHdr and have_pumPriCtlDp or have_pumSecHdr and have_pumSecCtlDp));
  parameter Real dtRunFaiSafPumSta(
    min=0,
    start=300,
    unit="s")=300
    "Runtime before triggering stage change command based on failsafe condition"
    annotation (Dialog(tab="Advanced",group="Pump staging",
      enable=have_pumPriHdr and have_pumPriCtlDp or have_pumSecHdr and have_pumSecCtlDp));
  parameter Real dtRunFaiSafLowYPumSta(
    min=0,
    start=600,
    unit="s")=dtRunPumSta
    "Runtime before triggering stage change command based on low pump speed failsafe condition"
    annotation (Dialog(tab="Advanced",group="Pump staging",
      enable=have_pumPriHdr and have_pumPriCtlDp or have_pumSecHdr and have_pumSecCtlDp));
  parameter Real dVOffUpPumSta(
    max=1,
    min=0,
    start=0.03,
    unit="1")=0.03
    "Stage up flow point offset"
    annotation (Dialog(tab="Advanced",group="Pump staging",
      enable=have_pumPriHdr and have_pumPriCtlDp or have_pumSecHdr and have_pumSecCtlDp));
  parameter Real dVOffDowPumSta(
    max=1,
    min=0,
    start=0.03,
    unit="1")=dVOffUpPumSta
    "Stage down flow point offset"
    annotation (Dialog(tab="Advanced",group="Pump staging",
      enable=have_pumPriHdr and have_pumPriCtlDp or have_pumSecHdr and have_pumSecCtlDp));
  parameter Real dpOffPumSta(
    min=0,
    start=1E4,
    unit="Pa")=1E4
    "Stage change ∆p point offset (>0)"
    annotation (Dialog(tab="Advanced",group="Pump staging",
      enable=have_pumPriHdr and have_pumPriCtlDp or have_pumSecHdr and have_pumSecCtlDp));
  parameter Real yUpPumSta(
    min=0,
    start=0.99,
    unit="1")=0.99
    "Stage up pump speed point"
    annotation (Dialog(tab="Advanced",group="Pump staging",
      enable=have_pumPriHdr and have_pumPriCtlDp or have_pumSecHdr and have_pumSecCtlDp));
  parameter Real yDowPumSta(
    min=0,
    start=0.4,
    unit="1")=0.4
    "Stage down pump speed point"
    annotation (Dialog(tab="Advanced",group="Pump staging",
      enable=have_pumPriHdr and have_pumPriCtlDp or have_pumSecHdr and have_pumSecCtlDp));
  parameter Real dtHol(
    min=0,
    unit="s")=900
    "Minimum hold time during stage change"
    annotation (Dialog(tab="Advanced",group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec or have_pumChiWatSec));
  parameter Real resDpHeaWat_max(
    max=1,
    min=0,
    unit="1")=0.5
    "Upper limit of plant reset interval for HW differential pressure reset"
    annotation (Dialog(tab="Advanced",group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec));
  parameter Real resTHeaWatSup_min(
    max=1,
    min=0,
    unit="1")=resDpHeaWat_max
    "Lower limit of plant reset interval for HW supply temperature reset"
    annotation (Dialog(tab="Advanced",group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec));
  parameter Real resDpChiWat_max(
    max=1,
    min=0,
    unit="1")=0.5
    "Upper limit of plant reset interval for CHW differential pressure reset"
    annotation (Dialog(tab="Advanced",group="Plant reset",
      enable=have_pumChiWatSec));
  parameter Real resTChiWatSup_min(
    max=1,
    min=0,
    unit="1")=resDpChiWat_max
    "Lower limit of plant reset interval for CHW supply temperature reset"
    annotation (Dialog(tab="Advanced",group="Plant reset",
      enable=have_pumChiWatSec));
  parameter Real res_init(
    max=1,
    min=0,
    unit="1")=1
    "Initial reset value"
    annotation (Dialog(tab="Advanced",group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec or have_pumChiWatSec));
  parameter Real res_min(
    max=1,
    min=0,
    unit="1")=0
    "Minimum reset value"
    annotation (Dialog(tab="Advanced",group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec or have_pumChiWatSec));
  parameter Real res_max(
    max=1,
    min=0,
    unit="1")=1
    "Maximum reset value"
    annotation (Dialog(tab="Advanced",group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec or have_pumChiWatSec));
  parameter Real dtDel(
    min=100*1E-15,
    unit="s")=900
    "Delay time before the reset begins"
    annotation (Dialog(tab="Advanced",group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec or have_pumChiWatSec));
  parameter Real dtResHeaWat(
    min=1E-3,
    unit="s")=300
    "Time step for HW plant reset"
    annotation (Dialog(tab="Advanced",group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec));
  parameter Integer nReqResIgnHeaWat(min=0)=2
    "Number of ignored requests for HW plant reset"
    annotation (Dialog(tab="Advanced",group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec));
  parameter Real triHeaWat(
    max=0,
    unit="1")=-0.02
    "Trim amount for HW plant reset"
    annotation (Dialog(tab="Advanced",group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec));
  parameter Real rspHeaWat(
    min=0,
    unit="1")=0.03
    "Respond amount for HW plant reset"
    annotation (Dialog(tab="Advanced",group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec));
  parameter Real rspHeaWat_max(
    min=0,
    unit="1")=0.07
    "Maximum response per time interval for HW plant reset"
    annotation (Dialog(tab="Advanced",group="Plant reset",
      enable=have_heaWat and have_pumHeaWatSec));
  parameter Real dtResChiWat(
    min=1E-3,
    unit="s")=300
    "Time step for CHW plant reset"
    annotation (Dialog(tab="Advanced",group="Plant reset",
      enable=have_pumChiWatSec));
  parameter Integer nReqResIgnChiWat(min=0)=2
    "Number of ignored requests for CHW plant reset"
    annotation (Dialog(tab="Advanced",group="Plant reset",
      enable=have_pumChiWatSec));
  parameter Real triChiWat(
    max=0,
    unit="1")=-0.02
    "Trim amount for CHW plant reset"
    annotation (Dialog(tab="Advanced",group="Plant reset",
      enable=have_pumChiWatSec));
  parameter Real rspChiWat(
    min=0,
    unit="1")=0.03
    "Respond amount for CHW plant reset"
    annotation (Dialog(tab="Advanced",group="Plant reset",
      enable=have_pumChiWatSec));
  parameter Real rspChiWat_max(
    min=0,
    unit="1")=0.07
    "Maximum response per time interval for CHW plant reset"
    annotation (Dialog(tab="Advanced",group="Plant reset",
      enable=have_pumChiWatSec));
  parameter Real yPumHeaWatPri_min(
    max=1,
    min=0,
    start=0.1,
    unit="1")=0.1
    "Minimum primary HW pump speed"
    annotation(Dialog(tab="Advanced",group="Pump control",
    enable=have_heaWat and have_pumPriCtlDp));
  parameter Real kCtlDpHeaWat(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps,
    start=1)=1
    "Gain of controller for HW loop ∆p control"
    annotation (Dialog(tab="Advanced", group="Loop differential pressure", enable=have_heaWat));
  parameter Real TiCtlDpHeaWat(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps,
    start=60,
    unit="s")=60
    "Time constant of integrator block for HW loop ∆p control"
    annotation (Dialog(tab="Advanced", group="Loop differential pressure", enable=have_heaWat));
  parameter Real yPumChiWatPri_min(
    max=1,
    min=0,
    start=0.1,
    unit="1")=0.1
    "Minimum primary CHW pump speed"
    annotation(Dialog(tab="Advanced",group="Pump control",
      enable=have_pumChiWatPri and have_pumPriCtlDp));
  parameter Real kCtlDpChiWat(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps,
    start=1)=1
    "Gain of controller for CHW loop ∆p control"
    annotation (Dialog(tab="Advanced", group="Loop differential pressure", enable=have_chiWat));
  parameter Real TiCtlDpChiWat(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps,
    start=60,
    unit="s")=60
    "Time constant of integrator block for CHW loop ∆p control"
    annotation (Dialog(tab="Advanced", group="Loop differential pressure", enable=have_chiWat));
  parameter Real yPumHeaWatSec_min(
    max=1,
    min=0,
    start=0.1,
    unit="1")=0.1
    "Minimum secondary HW pump speed"
    annotation (Dialog(tab="Advanced",group="Pump control",
      enable=have_pumHeaWatSec));
  parameter Real yPumChiWatSec_min(
    max=1,
    min=0,
    start=0.1,
    unit="1")=0.1
    "Minimum secondary CHW pump speed"
    annotation (Dialog(tab="Advanced",group="Pump control",
      enable=have_pumChiWatSec));
  parameter Real kValMinByp(
    min=0,
    start=1)=1
    "Gain of controller"
    annotation (Dialog(tab="Advanced",group="Minimum flow control",
      enable=is_priOnl));
  parameter Modelica.Units.SI.Time TiValMinByp(
    min=Buildings.Controls.OBC.CDL.Constants.small,
    start=0.5)=60
    "Time constant of integrator block"
    annotation (Dialog(tab="Advanced",group="Minimum flow control",
      enable=is_priOnl));
  // Sidestream HRC parameters
  parameter Boolean have_reqFloHrc(start=false)=false
    "Set to true if HRC provides flow request point via network interface"
    annotation (Evaluate=true,
      Dialog(tab="Advanced", group="Sidestream HRC", enable=have_hrc));
  parameter Real TChiWatSupHrc_min(
    min=273.15,
    start=4 + 273.15,
    unit="K",
    displayUnit="degC")
    "Sidestream HRC – Minimum allowable CHW supply temperature"
    annotation (Dialog(group="Information provided by designer", enable=have_hrc));
  parameter Real THeaWatSupHrc_max(
    min=273.15,
    start=60 + 273.15,
    unit="K",
    displayUnit="degC")
    "Sidestream HRC – Maximum allowable HW supply temperature"
    annotation (Dialog(group="Information provided by designer", enable=have_hrc));
  parameter Real COPHeaHrc_nominal(
    min=1.1,
    start=2.8,
    unit="1")
    "Sidestream HRC – Heating COP at design heating conditions"
    annotation (Dialog(group="Information provided by designer", enable=have_hrc));
  parameter Real capCooHrc_min(
    min=0,
    start=0,
    unit="W")
    "Sidestream HRC – Minimum cooling capacity below which cycling occurs"
    annotation (Dialog(group="Information provided by designer", enable=have_hrc));
  parameter Real capHeaHrc_min(
    min=0,
    start=0,
    unit="W")
    "Sidestream HRC – Minimum heating capacity below which cycling occurs"
    annotation (Dialog(group="Information provided by designer", enable=have_hrc));
  parameter Real dtLoaHrc(
    min=0,
    start=600,
    unit="s")=600
    "Runtime with sufficient load before enabling"
    annotation(Dialog(tab="Advanced", group="Sidestream HRC", enable=have_hrc));
  parameter Real dtTem1Hrc(
    min=0,
    start=180,
    unit="s")=180
    "Runtime with first temperature threshold exceeded before disabling"
    annotation(Dialog(tab="Advanced", group="Sidestream HRC", enable=have_hrc));
  parameter Real dtTem2Hrc(
    min=0,
    start=60,
    unit="s")=60
    "Runtime with second temperature threshold exceeded before disabling"
    annotation(Dialog(tab="Advanced", group="Sidestream HRC", enable=have_hrc));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SchHea
    if have_heaWat and have_inpSch
    "Heating mode enable via schedule"
    annotation (Placement(transformation(extent={{-300,360},{-260,400}}),
      iconTransformation(extent={{-240,340},{-200,380}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SchCoo
    if have_chiWat and have_inpSch
    "Cooling mode enable via schedule"
    annotation (Placement(transformation(extent={{-300,340},{-260,380}}),
      iconTransformation(extent={{-240,320},{-200,360}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPri_actual[nPumHeaWatPri]
    if have_pumHeaWatPri "Primary HW pump status"
    annotation (Placement(transformation(extent={{-300,180},{-260,220}}),
      iconTransformation(extent={{-240,260},{-200,300}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPri_actual[nPumChiWatPri]
    if have_pumChiWatPri or have_fouPip
                         "Primary CHW pump status"
    annotation (Placement(transformation(extent={{-300,160},{-260,200}}),
      iconTransformation(extent={{-240,240},{-200,280}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatSec_actual[nPumHeaWatSec]
    if have_pumHeaWatSec
    "Secondary HW pump status"
    annotation (Placement(transformation(extent={{-300,140},{-260,180}}),
      iconTransformation(extent={{-240,180},{-200,220}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatSec_actual[nPumChiWatSec]
    if have_pumChiWatSec
    "Secondary CHW pump status"
    annotation (Placement(transformation(extent={{-300,120},{-260,160}}),
      iconTransformation(extent={{-240,160},{-200,200}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hp_actual[nHp]
                      "Heat pump status"
    annotation (Placement(transformation(extent={{-300,280},{-260,320}}),
      iconTransformation(extent={{-240,300},{-200,340}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hrc_actual if have_hrc
    "HRC status"
    annotation (Placement(transformation(extent={{-300,-320},{-260,-280}}),
      iconTransformation(extent={{-240,140},{-200,180}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ReqFloChiWat
    if have_hrc and have_reqFloHrc
    "CHW flow request from HRC"
    annotation (Placement(transformation(extent={{-300,-340},{-260,-300}}),
      iconTransformation(extent={{-240,120},{-200,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ReqFloConWat
    if have_hrc and have_reqFloHrc
    "CW flow request from HRC"
    annotation (Placement(transformation(extent={{-300,-360},{-260,-320}}),
      iconTransformation(extent={{-240,100},{-200,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReqPlaHeaWat
    if have_heaWat
    "Number of HW plant requests"
    annotation (Placement(transformation(extent={{-300,320},{-260,360}}),
      iconTransformation(extent={{-240,78},{-200,118}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReqPlaChiWat
    if have_chiWat
    "Number of CHW plant requests"
    annotation (Placement(transformation(extent={{-300,300},{-260,340}}),
      iconTransformation(extent={{-240,58},{-200,98}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReqResHeaWat
    if have_heaWat
    "Sum of HW reset requests of all heating loads served"
    annotation (Placement(transformation(extent={{-300,-380},{-260,-340}}),
      iconTransformation(extent={{-240,38},{-200,78}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReqResChiWat
    if have_chiWat
    "Sum of CHW reset requests of all cooling loads served"
    annotation (Placement(transformation(extent={{-300,-400},{-260,-360}}),
      iconTransformation(extent={{-240,18},{-200,58}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-300,100},{-260,140}}),
      iconTransformation(extent={{-240,-2},{-200,38}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatPriRet(
    final unit="K",
    displayUnit="degC") if have_heaWat and have_senTHeaWatPriRet
    "Primary HW return temperature"
    annotation (Placement(transformation(extent={{-300,60},{-260,100}}),
      iconTransformation(extent={{-240,-42},{-200,-2}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHeaWatPri_flow(
    final unit="m3/s") if have_heaWat and have_senVHeaWatPri
    "Primary HW volume flow rate"
    annotation (Placement(transformation(extent={{-300,40},{-260,80}}),
      iconTransformation(extent={{-240,-62},{-200,-22}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatLoc(
    final unit="Pa")
    if have_heaWat and not have_senDpHeaWatRemWir
    "Local HW differential pressure"
    annotation (Placement(transformation(extent={{-300,-240},{-260,-200}}),
      iconTransformation(extent={{-240,-342},{-200,-302}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatLocSet[nSenDpHeaWatRem](
    each final unit="Pa")
    if have_heaWat and not have_senDpHeaWatRemWir
    "Local HW differential pressure setpoint output from each of the remote loops"
    annotation (Placement(transformation(extent={{-300,-220},{-260,-180}}),
      iconTransformation(extent={{-240,-322},{-200,-282}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatRem[nSenDpHeaWatRem](
    each final unit="Pa") if have_heaWat and have_senDpHeaWatRemWir
    "Remote HW differential pressure"
    annotation (Placement(transformation(extent={{-300,-200},{-260,-160}}),
      iconTransformation(extent={{-240,-302},{-200,-262}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatLoc(
    final unit="Pa")
    if have_chiWat and not have_senDpChiWatRemWir
    "Local CHW differential pressure"
    annotation (Placement(transformation(extent={{-300,-300},{-260,-260}}),
      iconTransformation(extent={{-240,-402},{-200,-362}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatLocSet[nSenDpChiWatRem](
    each final unit="Pa")
    if have_chiWat and not have_senDpChiWatRemWir
    "Local CHW differential pressure setpoint output from each of the remote loops"
    annotation (Placement(transformation(extent={{-300,-280},{-260,-240}}),
      iconTransformation(extent={{-240,-382},{-200,-342}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatRem[nSenDpChiWatRem](
    each final unit="Pa") if have_chiWat and have_senDpChiWatRemWir
    "Remote CHW differential pressure"
    annotation (Placement(transformation(extent={{-300,-260},{-260,-220}}),
      iconTransformation(extent={{-240,-362},{-200,-322}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatPriRet(
    final unit="K",
    displayUnit="degC") if have_chiWat and have_senTChiWatPriRet
    "Primary CHW return temperature"
    annotation (Placement(transformation(extent={{-300,0},{-260,40}}),
      iconTransformation(extent={{-240,-102},{-200,-62}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWatPri_flow(
    final unit="m3/s") if have_chiWat and have_senVChiWatPri
    "Primary CHW volume flow rate"
    annotation (Placement(transformation(extent={{-300,-20},{-260,20}}),
      iconTransformation(extent={{-240,-122},{-200,-82}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSecRet(
    final unit="K",
    displayUnit="degC") if have_heaWat and have_senTHeaWatSecRet
    "Secondary HW return temperature"
    annotation (Placement(transformation(extent={{-300,-60},{-260,-20}}),
      iconTransformation(extent={{-240,-162},{-200,-122}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHeaWatSec_flow(
    final unit="m3/s") if have_heaWat and have_senVHeaWatSec
    "Secondary HW volume flow rate"
    annotation (Placement(transformation(extent={{-300,-100},{-260,-60}}),
      iconTransformation(extent={{-240,-202},{-200,-162}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSecRet(
    final unit="K",
    displayUnit="degC") if have_chiWat and have_senTChiWatSecRet
    "Secondary CHW return temperature"
    annotation (Placement(transformation(extent={{-300,-140},{-260,-100}}),
      iconTransformation(extent={{-240,-242},{-200,-202}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWatSec_flow(
    final unit="m3/s") if have_chiWat and have_senVChiWatSec
    "Secondary CHW volume flow rate"
    annotation (Placement(transformation(extent={{-300,-180},{-260,-140}}),
      iconTransformation(extent={{-240,-282},{-200,-242}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatPriSup(
    final unit="K",
    displayUnit="degC") if have_heaWat
    "Primary HW supply temperature"
    annotation (Placement(transformation(extent={{-300,80},{-260,120}}),
      iconTransformation(extent={{-240,-22},{-200,18}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatPriSup(
    final unit="K",
    displayUnit="degC") if have_chiWat
    "Primary CHW return temperature"
    annotation (Placement(transformation(extent={{-300,20},{-260,60}}),
      iconTransformation(extent={{-240,-82},{-200,-42}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSecSup(
    final unit="K",
    displayUnit="degC") if have_heaWat and have_senTHeaWatSecSup
    "Secondary HW supply temperature"
    annotation (Placement(transformation(extent={{-300,-40},{-260,0}}),
      iconTransformation(extent={{-240,-142},{-200,-102}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSecSup(
    final unit="K",
    displayUnit="degC") if have_chiWat and have_senTChiWatSecSup
    "Secondary CHW return temperature"
    annotation (Placement(transformation(extent={{-300,-120},{-260,-80}}),
      iconTransformation(extent={{-240,-222},{-200,-182}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRetUpsHrc(
    final unit="K",
    displayUnit="degC") if have_hrc
    "CHW return temperature upstream of HRC"
    annotation (Placement(transformation(extent={{-300,-160},{-260,-120}}),
      iconTransformation(extent={{-240,-262},{-200,-222}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatRetUpsHrc(
    final unit="K",
    displayUnit="degC") if have_hrc
    "HW return temperature upstream of HRC"
    annotation (Placement(transformation(extent={{-300,-80},{-260,-40}}),
      iconTransformation(extent={{-240,-182},{-200,-142}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatHpInlIso[nHp]
    if have_heaWat and have_valHpInlIso
    "Heat pump inlet HW inlet isolation valve command"
    annotation (Placement(transformation(extent={{300,300},{340,340}}),
      iconTransformation(extent={{200,310},{240,350}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatHpOutIso[nHp]
    if have_heaWat and have_valHpOutIso
    "Heat pump outlet HW isolation valve command"
    annotation (Placement(transformation(extent={{300,280},{340,320}}),
      iconTransformation(extent={{200,290},{240,330}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatHpInlIso[nHp]
    if have_chiWat and have_valHpInlIso
    "Heat pump inlet CHW isolation valve command"
    annotation (Placement(transformation(extent={{300,260},{340,300}}),
      iconTransformation(extent={{200,270},{240,310}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatHpOutIso[nHp]
    if have_chiWat and have_valHpOutIso
    "Heat pump outlet CHW isolation valve command"
    annotation (Placement(transformation(extent={{300,240},{340,280}}),
      iconTransformation(extent={{200,250},{240,290}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatPri[nPumHeaWatPri]
    if have_pumHeaWatPri "Primary HW pump start command"
    annotation (Placement(transformation(extent={{300,180},{340,220}}),
      iconTransformation(extent={{200,210},{240,250}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatPri[nPumChiWatPri]
    if have_chiWat and (have_pumChiWatPri or have_fouPip)
                                         "Primary CHW pump start command"
    annotation (Placement(transformation(extent={{300,160},{340,200}}),
      iconTransformation(extent={{200,190},{240,230}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatSec[nPumHeaWatSec]
    if have_pumHeaWatSec
    "Secondary HW pump start command"
    annotation (Placement(transformation(extent={{300,140},{340,180}}),
      iconTransformation(extent={{200,150},{240,190}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatSec[nPumChiWatSec]
    if have_pumChiWatSec
    "Secondary CHW pump start command"
    annotation (Placement(transformation(extent={{300,120},{340,160}}),
      iconTransformation(extent={{200,130},{240,170}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hp[nHp]
                      "Heat pump enable command"
    annotation (Placement(transformation(extent={{300,360},{340,400}}),
      iconTransformation(extent={{200,370},{240,410}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HeaHp[nHp]
    if have_heaWat and have_chiWat
    "Heat pump heating/cooling mode command: true=heating, false=cooling"
    annotation (Placement(transformation(extent={{300,340},{340,380}}),
      iconTransformation(extent={{200,350},{240,390}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1CooHrc if have_hrc
    "Sidestream HRC mode command: true for cooling, false for heating"
    annotation (Placement(transformation(extent={{300,-320},{340,-280}}),
      iconTransformation(extent={{200,-250},{240,-210}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatHrc if
    have_hrc
    "Sidestream HRC CHW pump enable command"
    annotation (Placement(transformation(extent={{300,-380},{340,-340}}),
      iconTransformation(extent={{200,-270},{240,-230}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatHrc if
    have_hrc
    "Sidestream HRC HW pump enable command"
    annotation (Placement(transformation(extent={{300,-400},{340,-360}}),
      iconTransformation(extent={{200,-290},{240,-250}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hrc if have_hrc
    "Sidestream HRC enable command"
    annotation (Placement(transformation(extent={{300,-300},{340,-260}}),
      iconTransformation(extent={{200,-230},{240,-190}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yMod if have_fouPip
    "Operation mode integer signal for each HP"
    annotation (Placement(transformation(extent={{300,320},{340,360}}),
      iconTransformation(extent={{200,330},{240,370}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpHeaWatRemSet[nSenDpHeaWatRem](
    each final min=0,
    each final unit="Pa") if have_heaWat
    "HW differential pressure setpoint"
    annotation (Placement(transformation(extent={{300,-80},{340,-40}}),
      iconTransformation(extent={{200,-110},{240,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpChiWatRemSet[nSenDpChiWatRem](
    each final min=0,
    each final unit="Pa") if have_chiWat
    "CHW differential pressure setpoint"
    annotation (Placement(transformation(extent={{300,-100},{340,-60}}),
      iconTransformation(extent={{200,-130},{240,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumHeaWatPriHdr(
    final unit="1") if have_pumHeaWatPriVar and have_pumPriHdr
    "Primary headered HW pump speed command"
    annotation (Placement(transformation(extent={{300,80},{340,120}}),
      iconTransformation(extent={{200,90},{240,130}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumChiWatPriHdr(
    final unit="1") if have_pumChiWatPriVar and have_pumPriHdr
    "Primary headered CHW pump speed command"
    annotation (Placement(transformation(extent={{300,60},{340,100}}),
      iconTransformation(extent={{200,70},{240,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumHeaWatSec(
    final unit="1")
    if have_pumHeaWatSec
    "Primary HW pump speed command"
    annotation (Placement(transformation(extent={{300,-20},{340,20}}),
      iconTransformation(extent={{200,10},{240,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumChiWatSec(
    final unit="1") if have_pumChiWatSec
    "Primary CHW pump speed command"
    annotation (Placement(transformation(extent={{300,-40},{340,0}}),
      iconTransformation(extent={{200,-10},{240,30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiWatSupSet(
    final unit="K",
    displayUnit="degC") if have_chiWat
    "CHW supply temperature setpoint"
    annotation (Placement(transformation(extent={{300,-200},{340,-160}}),
      iconTransformation(extent={{200,-190},{240,-150}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaWatSupSet(
    final unit="K",
    displayUnit="degC") if have_heaWat
    "HW supply temperature setpoint"
    annotation (Placement(transformation(extent={{300,-180},{340,-140}}),
      iconTransformation(extent={{200,-170},{240,-130}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumHeaWatPriDed[nPumHeaWatPri](
    each final unit="1") if have_pumHeaWatPriVar and not have_pumPriHdr
    "Primary dedicated HW pump speed command"
    annotation (Placement(transformation(extent={{300,40},{340,80}}),
      iconTransformation(extent={{200,50},{240,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumChiWatPriDed[nPumChiWatPri](
    each final unit="1") if have_pumChiWatPriVar and have_pumChiWatPriDed
    "Primary dedicated CHW pump speed command"
    annotation (Placement(transformation(extent={{300,20},{340,60}}),
      iconTransformation(extent={{200,30},{240,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupSet[nHp](
    each final unit="K",
    each final quantity="ThermodynamicTemperature",
    each displayUnit="degC") "Active HP supply temperature setpoint"
    annotation (Placement(transformation(extent={{300,-140},{340,-100}}),
      iconTransformation(extent={{200,-150},{240,-110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupSetHrc(
    final unit="K",
    displayUnit="degC") if have_hrc
    "Sidestream HRC active supply temperature setpoint"
    annotation (Placement(transformation(extent={{300,-340},{340,-300}}),
      iconTransformation(extent={{200,-310},{240,-270}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValHeaWatMinByp(
    final unit="1") if have_heaWat and is_priOnl and not have_fouPip
    "HW minimum flow bypass valve command"
    annotation (Placement(transformation(extent={{300,-240},{340,-200}}),
      iconTransformation(extent={{200,-50},{240,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValChiWatMinByp(
    final unit="1") if have_chiWat and is_priOnl and not have_fouPip
    "CHW minimum flow bypass valve command"
    annotation (Placement(transformation(extent={{300,-260},{340,-220}}),
      iconTransformation(extent={{200,-70},{240,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1AvaHp[nHpTot](
    each k=true)
    "Heat pump available signal – Block does not handle faulted equipment yet"
    annotation (Placement(transformation(extent={{-220,210},{-200,230}}),
        iconTransformation(extent={{-240,220},{-200,260}})));

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
    annotation (Placement(transformation(extent={{-110,350},{-90,370}})));
  Utilities.StageIndex idxStaHea(
    final nSta=nSta,
    final dtRun=dtRunSta)
    if have_heaWat
    "Compute heating stage index"
    annotation (Placement(transformation(extent={{-10,350},{10,370}})));
  StagingRotation.StageAvailability avaStaHea(
    final nSta=nSta,
    final nEqu=nHpTot)
    if have_heaWat
    "Evaluate heating stage availability"
    annotation (Placement(transformation(extent={{-110,320},{-90,340}})));
  StagingRotation.EquipmentEnable enaEquHea(
    final is_pumApp=false,
    final have_fouPip=have_fouPip,
    final nEquAlt=nEquAlt,
    final nSta=nSta,
    final nEqu=nHpTot,
    final staEqu=staEqu,
    final staEquSinMod=staEquSinMod,
    final staEquDouMod=staEquDouMod)
    if have_heaWat
    "Compute enable command for equipment in heating mode"
    annotation (Placement(transformation(extent={{40,350},{60,370}})));
  StagingRotation.EventSequencing seqEve[nHpTot](
    each final have_heaWat=have_heaWat,
    each final have_chiWat=have_chiWat,
    each final have_fouPip=have_fouPip,
    each final have_valInlIso=have_valHpInlIso,
    each final have_valOutIso=have_valHpOutIso,
    each final have_pumHeaWatPri=have_pumHeaWatPri,
    each final have_pumChiWatPri=have_pumChiWatPri,
    each final have_pumHeaWatSec=have_pumHeaWatSec,
    each final have_pumChiWatSec=have_pumChiWatSec,
    each final dtVal=dtVal,
    each final dtOff=dtOffHp)
    "Event sequencing"
    annotation (Placement(transformation(extent={{140,284},{160,312}})));
  StagingRotation.StageAvailability avaStaCoo(
    final nSta=nSta,
    final nEqu=nHpTot)
    if have_chiWat
    "Evaluate cooling stage availability"
    annotation (Placement(transformation(extent={{-110,60},{-90,80}})));
  StagingRotation.StageChangeCommand chaStaHea(
    final typ=Buildings.Templates.Plants.Controls.Types.Application.Heating,
    final have_fouPip=have_fouPip,
    final have_pumSec=have_pumHeaWatSec,
    final have_inpPlrSta=false,
    final plrSta=plrSta,
    final staEqu=staEqu,
    final staEquSinMod=staEquSinMod,
    final staEquDouMod=staEquDouMod,
    final nSta=nSta,
    final nEqu=nHpTot,
    final capEqu=capHeaHp_nominal,
    final dtRun=dtRunSta,
    final cp_default=cp_default,
    final rho_default=rho_default,
    final dT=dTHea,
    final dtPri=dtPri,
    final dtSec=dtSec) if have_heaWat
    "Generate heating stage transition command"
    annotation (Placement(transformation(extent={{-40,308},{-20,332}})));
  StagingRotation.SortRuntime sorRunTimHea(
    final idxEquAlt=idxEquAlt,
    final nin=nHpTot) if have_heaWat and have_sorRunTim
    "Sort lead/lag alternate equipment by staging runtime – Heating mode"
    annotation (Placement(transformation(extent={{-40,280},{-20,300}})));
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
    annotation (Placement(transformation(extent={{-110,90},{-90,110}})));
  StagingRotation.StageChangeCommand chaStaCoo(
    final typ=Buildings.Templates.Plants.Controls.Types.Application.Cooling,
    final have_fouPip=have_fouPip,
    final have_pumSec=have_pumChiWatSec,
    final have_inpPlrSta=false,
    final plrSta=plrSta,
    final staEqu=staEqu,
    final staEquSinMod=staEquSinMod,
    final staEquDouMod=staEquDouMod,
    final nSta=nSta,
    final nEqu=nHpTot,
    final capEqu=capCooHp_nominal,
    final dtRun=dtRunSta,
    final cp_default=cp_default,
    final rho_default=rho_default,
    final dT=dTCoo,
    final dtPri=dtPri,
    final dtSec=dtSec) if have_chiWat
    "Generate cooling stage transition command"
    annotation (Placement(transformation(extent={{-40,50},{-20,74}})));
  Utilities.StageIndex idxStaCoo(
    final nSta=nSta,
    final dtRun=dtRunSta)
    if have_chiWat
    "Compute cooling stage index"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  StagingRotation.EquipmentEnable enaEquCoo(
    final is_pumApp=false,
    final have_fouPip=have_fouPip,
    final nEquAlt=nEquAlt,
    final nSta=nSta,
    final nEqu=nHpTot,
    final staEqu=staEqu,
    final staEquSinMod=staEquSinMod,
    final staEquDouMod=staEquDouMod)
    if have_chiWat
    "Compute enable command for equipment in cooling mode"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  StagingRotation.EquipmentAvailability avaEquHeaCoo[nHpTot](
    each final have_heaWat=have_heaWat,
    each final have_chiWat=have_chiWat,
    each final dtOff=dtOff)
    "Evaluate equipment availability in heating or cooling mode"
    annotation (Placement(transformation(extent={{-150,210},{-130,230}})));
  Buildings.Controls.OBC.CDL.Logical.Pre y1HeaPre[nHpTot]
    if have_heaWat and have_chiWat
    "Left-limit of command signal to break algebraic loop"
    annotation (Placement(transformation(extent={{230,350},{210,370}})));
  StagingRotation.SortRuntime sorRunTimCoo(
    final idxEquAlt=idxEquAlt, nin=nHpTot) if have_chiWat and have_sorRunTim
    "Sort lead/lag alternate equipment by staging runtime – Cooling mode"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Pumps.Generic.StagingHeadered staPumHeaWatPri(
    final is_pri=true,
    final is_ctlDp=have_pumPriCtlDp,
    final have_valInlIso=have_valHpInlIso,
    final have_valOutIso=have_valHpOutIso,
    final nEqu=nHpTot,
    final nPum=nPumHeaWatPriTot,
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
    annotation (Placement(transformation(extent={{140,190},{160,210}})));
  Pumps.Generic.StagingHeadered staPumChiWatPri(
    final is_pri=true,
    final is_ctlDp=have_pumPriCtlDp,
    final have_valInlIso=have_valHpInlIso,
    final have_valOutIso=have_valHpOutIso,
    final nEqu=nHpTot,
    final nPum=nPumChiWatPriTot,
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
    final yDow=yDowPumSta) if have_pumChiWatPri or have_fouPip
    "Primary CHW pump staging"
    annotation (Placement(transformation(extent={{190,170},{210,190}})));
  Pumps.Generic.StagingHeadered staPumChiWatSec(
    final is_pri=false,
    final nEqu=nHpTot,
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
    annotation (Placement(transformation(extent={{190,130},{210,150}})));
  Pumps.Generic.StagingHeadered staPumHeaWatSec(
    final is_pri=false,
    final nEqu=nHpTot,
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
    annotation (Placement(transformation(extent={{140,150},{160,170}})));
  Utilities.PlaceholderReal THeaWatRet(
    final have_inp=have_senTHeaWatPriRet,
    final have_inpPh=true) if have_heaWat
    "Select HW return temperature sensor"
    annotation (Placement(transformation(extent={{-230,30},{-210,50}})));
  Utilities.PlaceholderReal VHeaWatSta_flow(
    final have_inp=have_senVHeaWatPri,
    final have_inpPh=true) if have_heaWat
    "For staging logic select primary flow sensor if both primary and secondary sensors available"
    annotation (Placement(transformation(extent={{-190,10},{-170,30}})));
  Utilities.PlaceholderReal TChiWatRet(
    final have_inp=have_senTChiWatPriRet,
    final have_inpPh=true) if have_chiWat
    "Select CHW return temperature sensor"
    annotation (Placement(transformation(extent={{-230,-30},{-210,-10}})));
  Utilities.PlaceholderReal VChiWatSta_flow(
    final have_inp=have_senVChiWatPri,
    final have_inpPh=true) if have_chiWat
    "For staging logic select primary flow sensor if both primary and secondary sensors available"
    annotation (Placement(transformation(extent={{-190,-52},{-170,-32}})));
  Buildings.Controls.OBC.CDL.Logical.Pre y1HpPre[nHpTot]
    "Left-limit of command signal to break algebraic loop"
    annotation (Placement(transformation(extent={{200,370},{180,390}})));
  StagingRotation.StageCompletion comStaCoo(
    final nin=nHpTot) if have_chiWat
    "Check successful completion of cooling stage change"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  StagingRotation.StageCompletion comStaHea(
    final nin=nHpTot) if have_heaWat
    "Check successful completion of heating stage change"
    annotation (Placement(transformation(extent={{-40,246},{-20,266}})));
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
    final tri=triHeaWat) if have_heaWat
    "HW plant reset"
    annotation (Placement(transformation(extent={{50,230},{70,250}})));
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
    final tri=triChiWat) if have_chiWat
    "CHW plant reset"
    annotation (Placement(transformation(extent={{50,-50},{70,-30}})));
  Pumps.Primary.VariableSpeed ctlPumPri(
    final have_heaWat=have_heaWat,
    final have_chiWat=have_chiWat,
    final have_pumPriCtlDp=have_pumPriCtlDp,
    final have_pumChiWatPriDed=have_pumChiWatPriDed,
    final have_pumPriHdr=have_pumPriHdr,
    final nEqu=nHpTot,
    final nPumHeaWatPri=nPumHeaWatPriTot,
    final nPumChiWatPri=nPumChiWatPriTot,
    final yPumHeaWatPriSet=yPumHeaWatPriSet,
    final yPumChiWatPriSet=yPumChiWatPriSet,
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
    annotation (Placement(transformation(extent={{190,70},{210,98}})));
  Pumps.Generic.ControlDifferentialPressure ctlPumHeaWatSec(
    final have_senDpRemWir=have_senDpHeaWatRemWir,
    final nPum=nPumHeaWatSec,
    final nSenDpRem=nSenDpHeaWatRem,
    final y_min=yPumHeaWatSec_min,
    final k=kCtlDpHeaWat,
    final Ti=TiCtlDpHeaWat) if have_pumHeaWatSec and have_pumSecCtlDp
    "Secondary HW pump speed control"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Pumps.Generic.ControlDifferentialPressure ctlPumChiWatSec(
    final have_senDpRemWir=have_senDpChiWatRemWir,
    final nPum=nPumChiWatSec,
    final nSenDpRem=nSenDpChiWatRem,
    final y_min=yPumChiWatSec_min,
    final k=kCtlDpChiWat,
    final Ti=TiCtlDpChiWat) if have_pumChiWatSec and have_pumSecCtlDp
    "Secondary CHW pump speed control"
    annotation (Placement(transformation(extent={{190,-30},{210,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiTSupSet[nHpTot]
    if have_heaWat and have_chiWat
    "Select supply temperature setpoint based on operating mode"
    annotation (Placement(transformation(extent={{190,-130},{210,-110}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repTChiWatSupSet(
    final nout=nHpTot) if have_chiWat
    "Replicate CHWST setpoint"
    annotation (Placement(transformation(extent={{150,-150},{170,-130}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repTHeaWatSupSet(
    final nout=nHpTot) if have_heaWat
    "Replicate HWST setpoint"
    annotation (Placement(transformation(extent={{150,-110},{170,-90}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal pasTHeaWatSupSet(
    final nin=nHpTot,
    final nout=nHpTot) if have_heaWat and not have_chiWat
    "Direct pass through for HWST setpoint"
    annotation (Placement(transformation(extent={{214,-110},{234,-90}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal pasTChiWatSupSet(
    final nin=nHpTot,
    final nout=nHpTot) if have_chiWat and not have_heaWat
    "Direct pass through for CHWST setpoint"
    annotation (Placement(transformation(extent={{214,-150},{234,-130}})));
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
    final rho_default=rho_default) if have_hrc
    "Sidestream heat recovery chiller control"
    annotation (Placement(transformation(extent={{200,-320},{220,-288}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal pasDpHeaWatRemSet(
    final nin=nSenDpHeaWatRem,
    final nout=nSenDpHeaWatRem)
    if have_heaWat and have_senDpHeaWatRemWir
    "Direct pass through for HW ∆p setpoint"
    annotation (Placement(transformation(extent={{90,110},{110,130}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal pasDpChiWatRemSet(
    final nin=nSenDpChiWatRem,
    final nout=nSenDpChiWatRem)
    if have_chiWat and have_senDpChiWatRemWir
    "Direct pass through for CHW ∆p setpoint"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  MinimumFlow.ControllerDualMode ctlFloMin(
    final have_chiWat=have_chiWat,
    final have_heaWat=have_heaWat,
    final have_pumChiWatPri=have_pumChiWatPri,
    final have_valInlIso=have_valHpInlIso,
    final have_valOutIso=have_valHpOutIso,
    final k=kValMinByp,
    final nEqu=nHpTot,
    final Ti=TiValMinByp,
    final VChiWat_flow_min=VChiWatHp_flow_min,
    final VChiWat_flow_nominal=VChiWatHp_flow_nominal,
    final VHeaWat_flow_min=VHeaWatHp_flow_min,
    final VHeaWat_flow_nominal=VHeaWatHp_flow_nominal)
    if is_priOnl and not have_fouPip
    "CHW/HW minimum flow bypass valve controller"
    annotation (Placement(transformation(extent={{260,-248},{280,-224}})));
  Utilities.PlaceholderReal VHeaWatLoa_flow(
    final have_inp=is_priOnl,
    final have_inpPh=true) if have_heaWat
    "For HRC logic select either primary or secondary sensor depending on plant configuration"
    annotation (Placement(transformation(extent={{-140,-84},{-120,-64}})));
  Utilities.PlaceholderReal VChiWatLoa_flow(
    final have_inp=is_priOnl,
    final have_inpPh=true) if have_chiWat
    "For HRC logic select either primary or secondary sensor depending on plant configuration"
    annotation (Placement(transformation(extent={{-140,-124},{-120,-104}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2[nHpTot]
    "Generate heating mode availability signal for both 2-pipe and 4-pipe modules"
    annotation (Placement(transformation(extent={{-110,260},{-90,280}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1[nHpTot]
    "Generate cooling mode availability signal for both 2-pipe and 4-pipe modules"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Logical.Or or6[nPumHeaWatPriTot]
    if have_pumHeaWatPri and have_fouPip
    "Combine primary pump signals for 4-pipe HP with other HPs in heating mode"
    annotation (Placement(transformation(extent={{-80,-420},{-60,-400}})));
  Buildings.Controls.OBC.CDL.Logical.Or or7[nPumChiWatPriTot]
    if have_chiWat and have_fouPip
    "Combine primary pump signals for 4-pipe HP with primary pump signals for other HPs in cooling mode"
    annotation (Placement(transformation(extent={{-80,-450},{-60,-430}})));
  StagingRotation.HybridOperation ctlPlaHyb(
    final have_heaWat=have_heaWat,
    final have_sorRunTim=have_sorRunTim,
    final have_chiWat=have_chiWat,
    final nHp=nHpTot,
    final is_fouPip=is_fouPip,
    final staEquDouMod=staEquDouMod,
    final staEquSinMod=staEquSinMod,
    final idxEquAlt=idxEquAlt) if have_fouPip "Hybrid plant control module"
    annotation (Placement(transformation(extent={{60,-114},{80,-86}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu if have_fouPip
    "Check status of 4-pipe ASHP"
    annotation (Placement(transformation(extent={{80,-160},{100,-140}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(k=Buildings.Templates.Plants.Controls.HeatPumps.Types.OperationModes.Heating)
    if have_fouPip "Constant Integer signal indicating heating-only mode"
    annotation (Placement(transformation(extent={{50,-170},{70,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant staMat[nSta,nHpTot](k=staEqu)
    if not have_fouPip "Staging matrix signal"
    annotation (Placement(transformation(extent={{-220,250},{-200,270}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(k=false)
    if not have_fouPip "Constant Boolean false signal"
    annotation (Placement(transformation(extent={{-240,390},{-220,410}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(nout=nHpTot)
    if not have_fouPip "Replicate signal by number of heat pumps"
    annotation (Placement(transformation(extent={{-150,260},{-130,280}})));
  Buildings.Controls.OBC.CDL.Logical.And andHeaEna[nHpTot]
    "Check if heat pumps are commanded enabled in heating mode"
    annotation (Placement(transformation(extent={{-20,424},{-40,444}})));
  Buildings.Controls.OBC.CDL.Logical.And andCooEna[nHpTot]
    "Check if heat pumps are commanded enabled in cooling mode"
    annotation (Placement(transformation(extent={{-140,408},{-160,428}})));
  Buildings.Controls.OBC.CDL.Logical.Not notCooMod[nHpTot]
    "Derive cooling mode signal from heating mode signal"
    annotation (Placement(transformation(extent={{-100,400},{-120,420}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal pasHeaPumSta(
    final nin=nHpTot,
    final nout=nHpTot)
    "Pass-through block for actual heat pump status"
    annotation (Placement(transformation(extent={{-220,290},{-200,310}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HpFouPip_actual if have_fouPip
    "4-pipe air-source heat pump status"
    annotation (Placement(transformation(extent={{-300,210},{-260,250}}),
      iconTransformation(extent={{-240,280},{-200,320}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HpFouPip if have_fouPip
    "4-pipe air-source heat pump enable command"
    annotation (Placement(transformation(extent={{300,410},{340,450}}),
      iconTransformation(extent={{200,390},{240,430}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatPriFouPip
    if have_fouPip
    "Primary HW pump start command"
    annotation (Placement(transformation(extent={{300,-540},{340,-500}}),
      iconTransformation(extent={{200,-410},{240,-370}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatPriFouPip
    if have_fouPip
    "Primary CHW pump start command"
    annotation (Placement(transformation(extent={{300,-560},{340,-520}}),
      iconTransformation(extent={{200,-430},{240,-390}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPriFouPip_actual
    if have_fouPip
    "Primary CHW pump status for 4-pipe HP in hybrid plant"
    annotation (Placement(transformation(extent={{-300,-500},{-260,-460}}),
      iconTransformation(extent={{-240,200},{-200,240}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPriFouPip_actual
    if have_pumHeaWatPri and have_fouPip
    "Primary HW pump status for 4-pipe HP in hybrid plant"
    annotation (Placement(transformation(extent={{-300,-480},{-260,-440}}),
      iconTransformation(extent={{-240,220},{-200,260}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal pasPumHeaWatPriSta(
    final nin=nPumHeaWatPriTot,
    final nout=nPumHeaWatPriTot) if have_pumHeaWatPri
    "Pass-through block for actual primary HW pump status"
    annotation (Placement(transformation(extent={{-240,190},{-220,210}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal pasPumChiWatPriSta(
    final nin=nPumChiWatPriTot,
    final nout=nPumChiWatPriTot) if have_pumChiWatPri or have_fouPip
    "Pass-through block for actual primary CHW pump status"
    annotation (Placement(transformation(extent={{-208,170},{-188,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupSetFouPip(
    each final unit="K",
    each final quantity="ThermodynamicTemperature",
    each displayUnit="degC") if have_fouPip
    "Active HP supply temperature setpoint"
    annotation (Placement(transformation(extent={{300,-580},{340,-540}}),
      iconTransformation(extent={{200,-450},{240,-410}})));
  Buildings.Controls.OBC.CDL.Logical.Or or3[nPumHeaWatPriTot] if have_fouPip
    "Pump speed calculation enable signal in hybrid plant"
    annotation (Placement(transformation(extent={{210,40},{190,60}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal pasPumHeaWatPri(
    final nin=nPumHeaWatPriTot,
    final nout=nPumHeaWatPriTot) if not have_fouPip
    "Pass-through block for primary HW pump enable signal"
    annotation (Placement(transformation(extent={{210,10},{190,30}})));
equation
  connect(u1SchHea, enaHea.u1Sch)
    annotation (Line(points={{-280,380},{-180,380},{-180,364},{-112,364}},color={255,0,255}));
  connect(nReqPlaHeaWat, enaHea.nReqPla) annotation (Line(points={{-280,340},{-178,
          340},{-178,360},{-112,360}}, color={255,127,0}));
  connect(TOut, enaHea.TOut)
    annotation (Line(points={{-280,120},{-170,120},{-170,356},{-112,356}}, color={0,0,127}));
  connect(enaHea.y1, idxStaHea.u1Lea)
    annotation (Line(points={{-88,360},{-56,360},{-56,366},{-12,366}},color={255,0,255}));
  connect(avaStaHea.y1, idxStaHea.u1AvaSta)
    annotation (Line(points={{-88,330},{-56,330},{-56,354},{-12,354}},color={255,0,255}));
  connect(idxStaHea.y, enaEquHea.uSta)
    annotation (Line(points={{12,360},{20,360},{20,362},{38,362}},
                                                color={255,127,0}));
  connect(seqEve[1:nHp].y1ValHeaWatOutIso, y1ValHeaWatHpOutIso) annotation (Line(
        points={{162,298},{288,298},{288,300},{320,300}}, color={255,0,255}));
  connect(seqEve[1:nHp].y1ValHeaWatInlIso, y1ValHeaWatHpInlIso) annotation (Line(
        points={{162,300},{282,300},{282,320},{320,320}}, color={255,0,255}));
  connect(seqEve[1:nHp].y1ValChiWatInlIso, y1ValChiWatHpInlIso) annotation (Line(
        points={{162,296},{278,296},{278,280},{320,280}}, color={255,0,255}));
  connect(seqEve[1:nHp].y1ValChiWatOutIso, y1ValChiWatHpOutIso) annotation (Line(
        points={{162,294},{276,294},{276,260},{320,260}}, color={255,0,255}));
  connect(idxStaHea.y, chaStaHea.uSta)
    annotation (Line(points={{12,360},{20,360},{20,340},{-50,340},{-50,330},{-42,330}},
      color={255,127,0}));
  connect(chaStaHea.y1Dow, idxStaHea.u1Dow)
    annotation (Line(points={{-18,316},{-14,316},{-14,358},{-12,358}},color={255,0,255}));
  connect(chaStaHea.y1Up, idxStaHea.u1Up)
    annotation (Line(points={{-18,324},{-16,324},{-16,362},{-12,362}},color={255,0,255}));
  connect(avaStaHea.y1, chaStaHea.u1AvaSta)
    annotation (Line(points={{-88,330},{-56,330},{-56,328},{-42,328}},color={255,0,255}));
  connect(sorRunTimHea.yIdx, enaEquHea.uIdxAltSor)
    annotation (Line(points={{-18,284},{32,284},{32,366},{38,366}},color={255,127,0}));
  connect(nReqPlaChiWat, enaCoo.nReqPla) annotation (Line(points={{-280,320},{-182,
          320},{-182,100},{-112,100}}, color={255,127,0}));
  connect(TOut, enaCoo.TOut)
    annotation (Line(points={{-280,120},{-170,120},{-170,96},{-112,96}},
                                                                      color={0,0,127}));
  connect(u1SchCoo, enaCoo.u1Sch)
    annotation (Line(points={{-280,360},{-180,360},{-180,104},{-112,104}},color={255,0,255}));
  connect(avaStaCoo.y1, chaStaCoo.u1AvaSta)
    annotation (Line(points={{-88,70},{-56,70},{-56,70},{-42,70}},color={255,0,255}));
  connect(enaCoo.y1, idxStaCoo.u1Lea)
    annotation (Line(points={{-88,100},{-56,100},{-56,106},{-12,106}},color={255,0,255}));
  connect(chaStaCoo.y1Up, idxStaCoo.u1Up)
    annotation (Line(points={{-18,66},{-16,66},{-16,102},{-12,102}},color={255,0,255}));
  connect(chaStaCoo.y1Dow, idxStaCoo.u1Dow)
    annotation (Line(points={{-18,58},{-14,58},{-14,98},{-12,98}},color={255,0,255}));
  connect(idxStaCoo.y, enaEquCoo.uSta)
    annotation (Line(points={{12,100},{20,100},{20,102},{38,102}},
                                                color={255,127,0}));
  connect(enaEquHea.y1, seqEve.u1Hea) annotation (Line(points={{62,360},{80,360},
          {80,310},{138,310}}, color={255,0,255}));
  connect(enaEquCoo.y1, seqEve.u1Coo) annotation (Line(points={{62,100},{80,100},
          {80,306},{138,306}}, color={255,0,255}));
  connect(avaStaCoo.y1, idxStaCoo.u1AvaSta)
    annotation (Line(points={{-88,70},{-56,70},{-56,94},{-12,94}},color={255,0,255}));
  connect(sorRunTimCoo.yIdx, enaEquCoo.uIdxAltSor)
    annotation (Line(points={{-18,24},{32,24},{32,106},{38,106}},color={255,127,0}));
  connect(idxStaCoo.y, chaStaCoo.uSta)
    annotation (Line(points={{12,100},{20,100},{20,80},{-48,80},{-48,72},{-42,72}},
      color={255,127,0}));
  connect(staPumChiWatPri.y1_actual, seqEve.u1PumChiWatPri_actual) annotation (
      Line(points={{212,186},{220,186},{220,262},{122,262},{122,296},{138,296}},
        color={255,0,255}));
  connect(seqEve.y1PumChiWatPri, staPumChiWatPri.u1Pum) annotation (Line(points={{162,288},
          {178,288},{178,182},{188,182}},           color={255,0,255}));
  connect(pasPumChiWatPriSta.y, staPumChiWatPri.u1Pum_actual)
    annotation (Line(points={{-186,180},{188,180}},                    color={255,0,255}));
  connect(pasPumHeaWatPriSta.y, staPumHeaWatPri.u1Pum_actual)
    annotation (Line(points={{-218,200},{138,200}},                    color={255,0,255}));
  connect(staPumHeaWatPri.y1_actual, seqEve.u1PumHeaWatPri_actual) annotation (
      Line(points={{162,206},{164,206},{164,260},{120,260},{120,298},{138,298}},
        color={255,0,255}));
  connect(staPumHeaWatSec.y1, y1PumHeaWatSec)
    annotation (Line(points={{162,160},{320,160}},color={255,0,255}));
  connect(staPumChiWatSec.y1, y1PumChiWatSec)
    annotation (Line(points={{212,140},{320,140}},color={255,0,255}));
  connect(u1PumHeaWatSec_actual, staPumHeaWatSec.u1Pum_actual)
    annotation (Line(points={{-280,160},{120,160},{120,160},{138,160}},color={255,0,255}));
  connect(u1PumChiWatSec_actual, staPumChiWatSec.u1Pum_actual)
    annotation (Line(points={{-280,140},{180,140},{180,140},{188,140}},color={255,0,255}));
  connect(staPumChiWatSec.y1_actual, seqEve.u1PumChiWatSec_actual) annotation (
      Line(points={{212,146},{222,146},{222,266},{126,266},{126,290},{138,290}},
        color={255,0,255}));
  connect(seqEve.y1PumHeaWatPri, staPumHeaWatPri.u1Pum) annotation (Line(points={{162,290},
          {162,220},{130,220},{130,202},{138,202}},           color={255,0,255}));
  connect(staPumHeaWatSec.y1_actual, seqEve.u1PumHeaWatSec_actual) annotation (
      Line(points={{162,166},{166,166},{166,264},{124,264},{124,292},{138,292}},
        color={255,0,255}));
  connect(VHeaWatSec_flow, staPumHeaWatSec.V_flow)
    annotation (Line(points={{-280,-80},{-156,-80},{-156,158},{138,158}},  color={0,0,127}));
  connect(VChiWatSec_flow, staPumChiWatSec.V_flow)
    annotation (Line(points={{-280,-160},{-154,-160},{-154,138},{188,138}},color={0,0,127}));
  connect(THeaWatPriRet, THeaWatRet.u)
    annotation (Line(points={{-280,80},{-240,80},{-240,40},{-232,40}},
                                                  color={0,0,127}));
  connect(THeaWatRet.y, chaStaHea.TRet)
    annotation (Line(points={{-208,40},{-168,40},{-168,306},{-50,306},{-50,314},{-42,314}},
      color={0,0,127}));
  connect(THeaWatSecRet, THeaWatRet.uPh) annotation (Line(points={{-280,-40},{-240,
          -40},{-240,34},{-232,34}}, color={0,0,127}));
  connect(VHeaWatPri_flow, VHeaWatSta_flow.u) annotation (Line(points={{-280,60},
          {-244,60},{-244,20},{-192,20}}, color={0,0,127}));
  connect(VHeaWatSta_flow.y, chaStaHea.V_flow) annotation (Line(points={{-168,20},
          {-166,20},{-166,304},{-48,304},{-48,312},{-42,312}}, color={0,0,127}));
  connect(VHeaWatSec_flow, VHeaWatSta_flow.uPh) annotation (Line(points={{-280,-80},
          {-200,-80},{-200,14},{-192,14}}, color={0,0,127}));
  connect(TChiWatPriRet, TChiWatRet.u)
    annotation (Line(points={{-280,20},{-246,20},{-246,-20},{-232,-20}},
                                                    color={0,0,127}));
  connect(TChiWatRet.y, chaStaCoo.TRet)
    annotation (Line(points={{-208,-20},{-164,-20},{-164,48},{-50,48},{-50,56},{-42,56}},
      color={0,0,127}));
  connect(TChiWatSecRet, TChiWatRet.uPh) annotation (Line(points={{-280,-120},{-238,
          -120},{-238,-26},{-232,-26}},      color={0,0,127}));
  connect(VChiWatPri_flow, VChiWatSta_flow.u) annotation (Line(points={{-280,0},
          {-204,0},{-204,-42},{-192,-42}}, color={0,0,127}));
  connect(VChiWatSta_flow.y, chaStaCoo.V_flow) annotation (Line(points={{-168,-42},
          {-162,-42},{-162,38},{-48,38},{-48,54},{-42,54}}, color={0,0,127}));
  connect(VChiWatSec_flow, VChiWatSta_flow.uPh) annotation (Line(points={{-280,-160},
          {-204,-160},{-204,-48},{-192,-48}}, color={0,0,127}));
  connect(enaHea.y1, staPumHeaWatSec.u1Pla)
    annotation (Line(points={{-88,360},{-82,360},{-82,168},{138,168}},
      color={255,0,255}));
  connect(enaCoo.y1, staPumChiWatSec.u1Pla)
    annotation (Line(points={{-88,100},{-80,100},{-80,142},{170,142},{170,148},
          {188,148}},
      color={255,0,255}));
  connect(seqEve.y1ValHeaWatInlIso, staPumHeaWatPri.u1ValInlIso) annotation (
      Line(points={{162,300},{170,300},{170,216},{134,216},{134,206},{138,206}},
        color={255,0,255}));
  connect(seqEve.y1ValHeaWatOutIso, staPumHeaWatPri.u1ValOutIso) annotation (
      Line(points={{162,298},{168,298},{168,218},{132,218},{132,204},{138,204}},
        color={255,0,255}));
  connect(seqEve.y1ValChiWatInlIso, staPumChiWatPri.u1ValInlIso) annotation (
      Line(points={{162,296},{182,296},{182,186},{188,186}}, color={255,0,255}));
  connect(seqEve.y1ValChiWatOutIso, staPumChiWatPri.u1ValOutIso) annotation (
      Line(points={{162,294},{180,294},{180,184},{188,184}}, color={255,0,255}));
  connect(idxStaCoo.y, comStaCoo.uSta)
    annotation (Line(points={{12,100},{20,100},{20,-12},{-46,-12},{-46,4},{-42,4}},
      color={255,127,0}));
  connect(comStaCoo.y1, chaStaCoo.u1StaPro)
    annotation (Line(points={{-18,-6},{-10,-6},{-10,48},{-46,48},{-46,66},{-42,66}},
      color={255,0,255}));
  connect(y1HpPre.y, comStaCoo.u1)
    annotation (Line(points={{178,380},{-160,380},{-160,-8},{-102,-8},{-102,0},{
          -42,0}},                                                  color={255,0,255}));
  connect(idxStaHea.y, comStaHea.uSta)
    annotation (Line(points={{12,360},{20,360},{20,244},{-44,244},{-44,260},{-42,
          260}},
      color={255,127,0}));
  connect(y1HpPre.y, comStaHea.u1)
    annotation (Line(points={{178,380},{-62,380},{-62,256},{-42,256}},color={255,0,255}));
  connect(comStaHea.y1, chaStaHea.u1StaPro)
    annotation (Line(points={{-18,250},{-10,250},{-10,306},{-46,306},{-46,324},{
          -42,324}},
      color={255,0,255}));
  connect(resHeaWat.dpSet, dpHeaWatRemSet)
    annotation (Line(points={{72,246},{290,246},{290,-60},{320,-60}}, color={0,0,127}));
  connect(resChiWat.dpSet, dpChiWatRemSet)
    annotation (Line(points={{72,-34},{286,-34},{286,-80},{320,-80}}, color={0,0,127}));
  connect(nReqResHeaWat,resHeaWat.nReqRes)
    annotation (Line(points={{-280,-360},{30,-360},{30,246},{48,246}},color={255,127,0}));
  connect(nReqResChiWat,resChiWat.nReqRes)
    annotation (Line(points={{-280,-380},{40,-380},{40,-34},{48,-34}},color={255,127,0}));
  connect(enaCoo.y1, resChiWat.u1Ena)
    annotation (Line(points={{-88,100},{-80,100},{-80,-40},{48,-40}},color={255,0,255}));
  connect(enaHea.y1, resHeaWat.u1Ena)
    annotation (Line(points={{-88,360},{-82,360},{-82,240},{48,240}},color={255,0,255}));
  connect(comStaHea.y1, resHeaWat.u1StaPro)
    annotation (Line(points={{-18,250},{-10,250},{-10,234},{48,234}},color={255,0,255}));
  connect(comStaCoo.y1, resChiWat.u1StaPro)
    annotation (Line(points={{-18,-6},{-10,-6},{-10,-46},{48,-46}},color={255,0,255}));
  connect(resChiWat.TSupSet, chaStaCoo.TSupSet)
    annotation (Line(points={{72,-46},{116,-46},{116,-20},{-52,-20},{-52,64},{-42,
          64}},
      color={0,0,127}));
  connect(resHeaWat.TSupSet, chaStaHea.TSupSet)
    annotation (Line(points={{72,234},{118,234},{118,220},{-52,220},{-52,322},{-42,
          322}},
      color={0,0,127}));
  connect(ctlPumPri.yPumHeaWatPriHdr, yPumHeaWatPriHdr)
    annotation (Line(points={{212,84},{260,84},{260,100},{320,100}},color={0,0,127}));
  connect(ctlPumPri.yPumChiWatPriHdr, yPumChiWatPriHdr)
    annotation (Line(points={{212,80},{320,80}},                  color={0,0,127}));
  connect(staPumChiWatPri.y1, ctlPumPri.u1PumChiWatPri)
    annotation (Line(points={{212,180},{226,180},{226,120},{186,120},{186,82},{
          188,82}},
      color={255,0,255}));
  connect(seqEve.y1Hea, ctlPumPri.u1Hea) annotation (Line(points={{162,308},{
          174,308},{174,84},{188,84}}, color={255,0,255}));
  connect(ctlPumHeaWatSec.y, yPumHeaWatSec)
    annotation (Line(points={{162,0},{320,0}},                    color={0,0,127}));
  connect(ctlPumChiWatSec.y, yPumChiWatSec)
    annotation (Line(points={{212,-20},{320,-20}},                  color={0,0,127}));
  connect(u1PumHeaWatSec_actual, ctlPumHeaWatSec.y1_actual)
    annotation (Line(points={{-280,160},{122,160},{122,8},{138,8}},  color={255,0,255}));
  connect(u1PumChiWatSec_actual, ctlPumChiWatSec.y1_actual)
    annotation (Line(points={{-280,140},{170,140},{170,-12},{188,-12}},
                                                                   color={255,0,255}));
  connect(resChiWat.dpSet, ctlPumChiWatSec.dpRemSet)
    annotation (Line(points={{72,-34},{178,-34},{178,-16},{188,-16}},
                                                                  color={0,0,127}));
  connect(dpHeaWatRem, ctlPumHeaWatSec.dpRem)
    annotation (Line(points={{-280,-180},{130,-180},{130,0},{138,0}},  color={0,0,127}));
  connect(resHeaWat.dpSet, ctlPumHeaWatSec.dpRemSet)
    annotation (Line(points={{72,246},{122,246},{122,4},{138,4}},   color={0,0,127}));
  connect(dpHeaWatLoc, ctlPumHeaWatSec.dpLoc)
    annotation (Line(points={{-280,-220},{134,-220},{134,-8},{138,-8}},color={0,0,127}));
  connect(dpHeaWatLocSet, ctlPumHeaWatSec.dpLocSet)
    annotation (Line(points={{-280,-200},{132,-200},{132,-4},{138,-4}},color={0,0,127}));
  connect(dpChiWatRem, ctlPumChiWatSec.dpRem)
    annotation (Line(points={{-280,-240},{180,-240},{180,-20},{188,-20}},
                                                                     color={0,0,127}));
  connect(dpChiWatLocSet, ctlPumChiWatSec.dpLocSet)
    annotation (Line(points={{-280,-260},{182,-260},{182,-24},{188,-24}},
                                                                       color={0,0,127}));
  connect(dpChiWatLoc, ctlPumChiWatSec.dpLoc)
    annotation (Line(points={{-280,-280},{184,-280},{184,-28},{188,-28}},
                                                                       color={0,0,127}));
  connect(u1AvaHp.y, avaEquHeaCoo.u1Ava) annotation (Line(points={{-198,220},{
          -152,220}},                       color={255,0,255}));
  connect(repTChiWatSupSet.y, swiTSupSet.u3) annotation (Line(points={{172,-140},
          {178,-140},{178,-128},{188,-128}}, color={0,0,127}));
  connect(repTHeaWatSupSet.y, swiTSupSet.u1) annotation (Line(points={{172,-100},
          {178,-100},{178,-112},{188,-112}}, color={0,0,127}));
  connect(resChiWat.TSupSet, repTChiWatSupSet.u) annotation (Line(points={{72,-46},
          {120,-46},{120,-140},{148,-140}}, color={0,0,127}));
  connect(resHeaWat.TSupSet, repTHeaWatSupSet.u) annotation (Line(points={{72,234},
          {118,234},{118,-100},{148,-100}}, color={0,0,127}));
  connect(seqEve[1:nHp].y1Hea, swiTSupSet[1:nHp].u2) annotation (Line(points={{162,308},{174,
          308},{174,-120},{188,-120}}, color={255,0,255}));
  connect(swiTSupSet[1:nHp].y, TSupSet) annotation (Line(points={{212,-120},{320,-120}},
                                  color={0,0,127}));
  connect(pasTChiWatSupSet.y, TSupSet) annotation (Line(points={{236,-140},{290,
          -140},{290,-120},{320,-120}}, color={0,0,127}));
  connect(pasTHeaWatSupSet.y, TSupSet) annotation (Line(points={{236,-100},{290,
          -100},{290,-120},{320,-120}}, color={0,0,127}));
  connect(repTChiWatSupSet.y, pasTChiWatSupSet.u)
    annotation (Line(points={{172,-140},{212,-140}}, color={0,0,127}));
  connect(repTHeaWatSupSet.y, pasTHeaWatSupSet.u)
    annotation (Line(points={{172,-100},{212,-100}}, color={0,0,127}));
  connect(resChiWat.TSupSet, TChiWatSupSet) annotation (Line(points={{72,-46},{
          142,-46},{142,-180},{320,-180}},  color={0,0,127}));
  connect(resHeaWat.TSupSet, THeaWatSupSet) annotation (Line(points={{72,234},{
          280,234},{280,-160},{320,-160}},  color={0,0,127}));
  connect(hrc.y1, y1Hrc) annotation (Line(points={{222,-296},{280,-296},{280,-280},
          {320,-280}}, color={255,0,255}));
  connect(hrc.y1Coo, y1CooHrc)
    annotation (Line(points={{222,-300},{320,-300}}, color={255,0,255}));
  connect(hrc.TSupSet, TSupSetHrc) annotation (Line(points={{222,-304},{280,-304},
          {280,-320},{320,-320}}, color={0,0,127}));
  connect(hrc.y1PumChiWat, y1PumChiWatHrc) annotation (Line(points={{222,-308},{
          276,-308},{276,-360},{320,-360}}, color={255,0,255}));
  connect(hrc.y1PumHeaWat, y1PumHeaWatHrc) annotation (Line(points={{222,-312},{
          272,-312},{272,-380},{320,-380}}, color={255,0,255}));
  connect(TChiWatSupSet, hrc.TChiWatSupSet) annotation (Line(points={{320,-180},
          {188,-180},{188,-302},{198,-302}}, color={0,0,127}));
  connect(THeaWatSupSet, hrc.THeaWatSupSet) annotation (Line(points={{320,-160},
          {186,-160},{186,-312},{198,-312}}, color={0,0,127}));
  connect(enaCoo.y1, hrc.u1Coo) annotation (Line(points={{-88,100},{-80,100},{-80,
          -290},{198,-290}}, color={255,0,255}));
  connect(enaHea.y1, hrc.u1Hea) annotation (Line(points={{-88,360},{-82,360},{-82,
          -292},{198,-292}}, color={255,0,255}));
  connect(TChiWatRetUpsHrc, hrc.TChiWatRetUpsHrc) annotation (Line(points={{-280,
          -140},{-242,-140},{-242,-306},{198,-306}}, color={0,0,127}));
  connect(THeaWatRetUpsHrc, hrc.THeaWatRetUpsHrc) annotation (Line(points={{-280,
          -60},{-246,-60},{-246,-316},{198,-316}}, color={0,0,127}));
  connect(THeaWatSecRet, hrc.THeaWatHrcLvg) annotation (Line(points={{-280,-40},
          {-240,-40},{-240,-314},{198,-314}}, color={0,0,127}));
  connect(TChiWatSecRet, hrc.TChiWatHrcLvg) annotation (Line(points={{-280,-120},
          {-238,-120},{-238,-304},{198,-304}}, color={0,0,127}));
  connect(u1Hrc_actual, hrc.u1Hrc_actual) annotation (Line(points={{-280,-300},{
          190,-300},{190,-294},{198,-294}}, color={255,0,255}));
  connect(u1ReqFloChiWat, hrc.u1ReqFloChiWat) annotation (Line(points={{-280,-320},
          {192,-320},{192,-296},{198,-296}}, color={255,0,255}));
  connect(u1ReqFloConWat, hrc.u1ReqFloConWat) annotation (Line(points={{-280,-340},
          {194,-340},{194,-298},{198,-298}}, color={255,0,255}));
  connect(TChiWatPriSup, chaStaCoo.TPriSup) annotation (Line(points={{-280,40},{
          -242,40},{-242,60},{-42,60}}, color={0,0,127}));
  connect(THeaWatSecSup, chaStaHea.TSecSup) annotation (Line(points={{-280,-20},
          {-250,-20},{-250,316},{-42,316}}, color={0,0,127}));
  connect(TChiWatSecSup, chaStaCoo.TSecSup) annotation (Line(points={{-280,-100},
          {-248,-100},{-248,58},{-42,58}}, color={0,0,127}));
  connect(THeaWatPriSup, chaStaHea.TPriSup) annotation (Line(points={{-280,100},
          {-252,100},{-252,318},{-42,318}}, color={0,0,127}));
  connect(ctlPumHeaWatSec.y, staPumHeaWatSec.y) annotation (Line(points={{162,0},
          {166,0},{166,148},{136,148},{136,152},{138,152}},    color={0,0,127}));
  connect(ctlPumChiWatSec.y, staPumChiWatSec.y) annotation (Line(points={{212,-20},
          {218,-20},{218,126},{186,126},{186,132},{188,132}},      color={0,0,127}));
  connect(ctlPumHeaWatSec.dpLocSetMax, staPumHeaWatSec.dpSet[1]) annotation (Line(
        points={{162,-4},{164,-4},{164,146},{132,146},{132,156},{138,156}},
        color={0,0,127}));
  connect(ctlPumChiWatSec.dpLocSetMax, staPumChiWatSec.dpSet[1]) annotation (Line(
        points={{212,-24},{216,-24},{216,124},{182,124},{182,136},{188,136}},
        color={0,0,127}));
  connect(dpHeaWatLoc, staPumHeaWatSec.dp[1]) annotation (Line(points={{-280,-220},
          {134,-220},{134,154},{138,154}}, color={0,0,127}));
  connect(dpChiWatLoc, staPumChiWatSec.dp[1]) annotation (Line(points={{-280,-280},
          {184,-280},{184,134},{188,134}}, color={0,0,127}));
  connect(dpChiWatRem, staPumChiWatSec.dp) annotation (Line(points={{-280,-240},
          {180,-240},{180,134},{188,134}}, color={0,0,127}));
  connect(dpHeaWatRem, staPumHeaWatSec.dp) annotation (Line(points={{-280,-180},
          {130,-180},{130,154},{138,154}}, color={0,0,127}));
  connect(resHeaWat.dpSet, pasDpHeaWatRemSet.u) annotation (Line(points={{72,
          246},{82,246},{82,120},{88,120}}, color={0,0,127}));
  connect(pasDpHeaWatRemSet.y, staPumHeaWatSec.dpSet) annotation (Line(points={
          {112,120},{126,120},{126,156},{138,156}}, color={0,0,127}));
  connect(pasDpChiWatRemSet.y, staPumChiWatSec.dpSet) annotation (Line(points={{112,60},
          {128,60},{128,136},{188,136}},          color={0,0,127}));
  connect(resChiWat.dpSet, pasDpChiWatRemSet.u) annotation (Line(points={{72,-34},
          {80,-34},{80,60},{88,60}},      color={0,0,127}));
  connect(resChiWat.dpSet, ctlPumPri.dpChiWatRemSet) annotation (Line(points={{
          72,-34},{178,-34},{178,78},{188,78}}, color={0,0,127}));
  connect(resHeaWat.dpSet, ctlPumPri.dpHeaWatRemSet) annotation (Line(points={{
          72,246},{122,246},{122,92},{188,92}}, color={0,0,127}));
  connect(dpHeaWatRem, ctlPumPri.dpHeaWatRem) annotation (Line(points={{-280,
          -180},{130,-180},{130,90},{188,90}}, color={0,0,127}));
  connect(dpHeaWatLocSet, ctlPumPri.dpHeaWatLocSet) annotation (Line(points={{
          -280,-200},{132,-200},{132,88},{188,88}}, color={0,0,127}));
  connect(dpHeaWatLoc, ctlPumPri.dpHeaWatLoc) annotation (Line(points={{-280,
          -220},{134,-220},{134,86},{188,86}}, color={0,0,127}));
  connect(pasDpHeaWatRemSet.y, staPumHeaWatPri.dpSet) annotation (Line(points={
          {112,120},{126,120},{126,196},{138,196}}, color={0,0,127}));
  connect(pasDpChiWatRemSet.y, staPumChiWatPri.dpSet) annotation (Line(points={
          {112,60},{128,60},{128,176},{188,176}}, color={0,0,127}));
  connect(ctlPumPri.dpChiWatLocSetMax, staPumChiWatPri.dpSet[1]) annotation (
      Line(points={{212,92},{214,92},{214,108},{168,108},{168,176},{188,176}},
        color={0,0,127}));
  connect(ctlPumPri.dpHeaWatLocSetMax, staPumHeaWatPri.dpSet[1]) annotation (
      Line(points={{212,96},{212,106},{124,106},{124,196},{138,196}}, color={0,
          0,127}));
  connect(dpHeaWatRem, staPumHeaWatPri.dp) annotation (Line(points={{-280,-180},
          {130,-180},{130,194},{138,194}}, color={0,0,127}));
  connect(dpChiWatRem, staPumChiWatPri.dp) annotation (Line(points={{-280,-240},
          {182,-240},{182,174},{188,174}}, color={0,0,127}));
  connect(dpHeaWatLoc, staPumHeaWatPri.dp[1]) annotation (Line(points={{-280,
          -220},{134,-220},{134,194},{138,194}}, color={0,0,127}));
  connect(dpChiWatLoc, staPumChiWatPri.dp[1]) annotation (Line(points={{-280,
          -280},{184,-280},{184,174},{188,174}}, color={0,0,127}));
  connect(dpChiWatLoc, ctlPumPri.dpChiWatLoc) annotation (Line(points={{-280,
          -280},{184,-280},{184,72},{188,72}}, color={0,0,127}));
  connect(VChiWatPri_flow, staPumChiWatPri.V_flow) annotation (Line(points={{-280,0},
          {-140,0},{-140,178},{188,178}},         color={0,0,127}));
  connect(VHeaWatPri_flow, staPumHeaWatPri.V_flow) annotation (Line(points={{-280,60},
          {-136,60},{-136,198},{138,198}},          color={0,0,127}));
  connect(pasPumHeaWatPriSta.y, ctlPumPri.u1PumHeaWatPri_actual) annotation (
      Line(points={{-218,200},{116,200},{116,94},{188,94}}, color={255,0,255}));
  connect(pasPumChiWatPriSta.y, ctlPumPri.u1PumChiWatPri_actual) annotation (
      Line(points={{-186,180},{114,180},{114,80},{188,80}},
        color={255,0,255}));
  connect(dpChiWatRem, ctlPumPri.dpChiWatRem) annotation (Line(points={{-280,
          -240},{180,-240},{180,76},{188,76}}, color={0,0,127}));
  connect(dpChiWatLocSet, ctlPumPri.dpChiWatLocSet) annotation (Line(points={{
          -280,-260},{182,-260},{182,74},{188,74}}, color={0,0,127}));
  connect(ctlFloMin.yValHeaWatMinByp, yValHeaWatMinByp)
    annotation (Line(points={{282,-236},{284,-236},{284,-220},{320,-220}},
                                                     color={0,0,127}));
  connect(ctlFloMin.yValChiWatMinByp, yValChiWatMinByp) annotation (Line(points={{282,
          -240},{320,-240}},                            color={0,0,127}));
  connect(seqEve.y1, ctlFloMin.u1Equ) annotation (Line(points={{162,310},{250,
          310},{250,-226},{258,-226}},             color={255,0,255}));
  connect(seqEve.y1Hea, ctlFloMin.u1HeaEqu) annotation (Line(points={{162,308},
          {248,308},{248,-228},{258,-228}},             color={255,0,255}));
  connect(seqEve.y1ValHeaWatInlIso, ctlFloMin.u1ValHeaWatInlIso) annotation (Line(
        points={{162,300},{246,300},{246,-230},{258,-230}},
        color={255,0,255}));
  connect(seqEve.y1ValHeaWatOutIso, ctlFloMin.u1ValHeaWatOutIso) annotation (Line(
        points={{162,298},{244,298},{244,-232},{258,-232}},
        color={255,0,255}));
  connect(seqEve.y1ValChiWatInlIso, ctlFloMin.u1ValChiWatInlIso) annotation (Line(
        points={{162,296},{242,296},{242,-234},{258,-234}},
        color={255,0,255}));
  connect(seqEve.y1ValChiWatOutIso, ctlFloMin.u1ValChiWatOutIso) annotation (Line(
        points={{162,294},{240,294},{240,-236},{258,-236}},
                             color={255,0,255}));
  connect(pasPumHeaWatPriSta.y, ctlFloMin.u1PumHeaWatPri_actual) annotation (
      Line(points={{-218,200},{-144,200},{-144,-232},{228,-232},{228,-238},{258,
          -238}},                                               color={255,0,255}));
  connect(pasPumChiWatPriSta.y, ctlFloMin.u1PumChiWatPri_actual) annotation (
      Line(points={{-186,180},{-148,180},{-148,-236},{236,-236},{236,-240},{258,
          -240}},                                               color={255,0,255}));
  connect(VHeaWatPri_flow, ctlFloMin.VHeaWatPri_flow) annotation (Line(points={{-280,60},
          {-244,60},{-244,-76},{-160,-76},{-160,-248},{240,-248},{240,-242},{258,
          -242}},                                     color={0,0,127}));
  connect(VChiWatPri_flow, ctlFloMin.VChiWatPri_flow) annotation (Line(points={{-280,0},
          {-256,0},{-256,-116},{-152,-116},{-152,-244},{258,-244}},
                                                    color={0,0,127}));
  connect(ctlPumPri.yPumHeaWatPriHdr, staPumHeaWatPri.y) annotation (Line(
        points={{212,84},{220,84},{220,110},{136,110},{136,192},{138,192}},
        color={0,0,127}));
  connect(ctlPumPri.yPumChiWatPriHdr, staPumChiWatPri.y) annotation (Line(
        points={{212,80},{222,80},{222,112},{178,112},{178,172},{188,172}},
        color={0,0,127}));
  connect(VHeaWatSec_flow, VHeaWatLoa_flow.uPh) annotation (Line(points={{-280,-80},
          {-142,-80}},                       color={0,0,127}));
  connect(VHeaWatPri_flow, VHeaWatLoa_flow.u) annotation (Line(points={{-280,60},
          {-244,60},{-244,-74},{-142,-74}}, color={0,0,127}));
  connect(VChiWatSec_flow, VChiWatLoa_flow.uPh) annotation (Line(points={{-280,-160},
          {-154,-160},{-154,-120},{-142,-120}}, color={0,0,127}));
  connect(VChiWatPri_flow, VChiWatLoa_flow.u) annotation (Line(points={{-280,0},
          {-254,0},{-254,-114},{-142,-114}}, color={0,0,127}));
  connect(VChiWatLoa_flow.y, hrc.VChiWatLoa_flow) annotation (Line(points={{-118,
          -114},{-100,-114},{-100,-308},{198,-308}}, color={0,0,127}));
  connect(VHeaWatLoa_flow.y, hrc.VHeaWatLoa_flow) annotation (Line(points={{-118,
          -74},{-98,-74},{-98,-318},{198,-318}}, color={0,0,127}));
  connect(avaEquHeaCoo.y1Hea, or2.u2) annotation (Line(points={{-128,226},{-122,
          226},{-122,262},{-112,262}}, color={255,0,255}));
  connect(or2.y, avaStaHea.u1Ava) annotation (Line(points={{-88,270},{-80,270},{
          -80,312},{-120,312},{-120,334},{-112,334}},  color={255,0,255}));
  connect(or2.y, sorRunTimHea.u1Ava) annotation (Line(points={{-88,270},{-48,
          270},{-48,284},{-42,284}}, color={255,0,255}));
  connect(or2.y, enaEquHea.u1Ava) annotation (Line(points={{-88,270},{34,270},{
          34,358},{38,358}},                                         color={255,
          0,255}));
  connect(avaEquHeaCoo.y1Coo, or1.u1) annotation (Line(points={{-128,214},{-124,
          214},{-124,20},{-122,20}}, color={255,0,255}));
  connect(or1.y, enaEquCoo.u1Ava) annotation (Line(points={{-98,20},{-54,20},{-54,
          88},{28,88},{28,98},{38,98}},                       color={255,0,255}));
  connect(or1.y, avaStaCoo.u1Ava) annotation (Line(points={{-98,20},{-92,20},{-92,
          52},{-120,52},{-120,74},{-112,74}},     color={255,0,255}));
  connect(or1.y, sorRunTimCoo.u1Ava) annotation (Line(points={{-98,20},{-54,20},
          {-54,24},{-42,24}}, color={255,0,255}));
  connect(staPumChiWatPri.y1, or7.u2) annotation (Line(points={{212,180},{226,
          180},{226,-56},{-106,-56},{-106,-448},{-82,-448}},
                 color={255,0,255}));
  connect(staPumHeaWatPri.y1, or6.u2) annotation (Line(points={{162,200},{232,
          200},{232,-60},{-100,-60},{-100,-418},{-82,-418}},
                                                         color={255,0,255}));
  connect(enaCoo.y1, ctlPlaHyb.u1EnaCoo) annotation (Line(points={{-88,100},{-80,
          100},{-80,-40},{36,-40},{36,-90},{58,-90}}, color={255,0,255}));
  connect(enaHea.y1, ctlPlaHyb.u1EnaHea) annotation (Line(points={{-88,360},{-84,
          360},{-84,-94},{58,-94}}, color={255,0,255}));
  connect(y1HpPre.y, ctlPlaHyb.u1Hp) annotation (Line(points={{178,380},{-160,380},
          {-160,-8},{-64,-8},{-64,-98},{58,-98}},
                                                color={255,0,255}));
  connect(seqEve.y1Hea, ctlPlaHyb.uMod) annotation (Line(points={{162,308},{176,
          308},{176,-44},{124,-44},{124,-104},{92,-104},{92,-124},{52,-124},{52,
          -102},{58,-102}}, color={255,0,255}));
  connect(staPumHeaWatPri.y1, ctlPlaHyb.u1PumPriHea) annotation (Line(points={{162,
          200},{232,200},{232,-60},{48,-60},{48,-110},{58,-110}}, color={255,0,255}));
  connect(staPumChiWatPri.y1, ctlPlaHyb.u1PumPriCoo) annotation (Line(points={{212,180},
          {226,180},{226,-56},{44,-56},{44,-106},{58,-106}},      color={255,0,255}));
  connect(ctlPlaHyb.y1PumPri, or6.u1) annotation (Line(points={{82,-88},{84,-88},
          {84,-58},{-90,-58},{-90,-410},{-82,-410}},color={255,0,255}));
  connect(ctlPlaHyb.y1PumPri, or7.u1) annotation (Line(points={{82,-88},{84,-88},
          {84,-58},{-90,-58},{-90,-440},{-82,-440}},color={255,0,255}));
  connect(ctlPlaHyb.yAvaFouPipCoo, or1.u2) annotation (Line(points={{82,-92},{96,
          -92},{96,-52},{-124,-52},{-124,12},{-122,12}}, color={255,0,255}));
  connect(ctlPlaHyb.yAvaFouPipHea, or2.u1) annotation (Line(points={{82,-96},{
          100,-96},{100,-76},{-68,-76},{-68,246},{-116,246},{-116,270},{-112,
          270}},
        color={255,0,255}));
  connect(ctlPlaHyb.yHeaCoo, enaEquHea.u1HeaCoo) annotation (Line(points={{82,-100},
          {104,-100},{104,-12},{72,-12},{72,224},{38,224},{38,354}}, color={255,
          0,255}));
  connect(ctlPlaHyb.yHeaCoo, enaEquCoo.u1HeaCoo) annotation (Line(points={{82,-100},
          {104,-100},{104,-12},{72,-12},{72,84},{36,84},{36,94},{38,94}},
                                                                  color={255,0,255}));
  connect(ctlPlaHyb.yStaEqu, avaStaCoo.staEqu) annotation (Line(points={{82,-108},
          {88,-108},{88,-128},{-72,-128},{-72,44},{-128,44},{-128,66},{-112,66}},
        color={0,0,127}));
  connect(ctlPlaHyb.yStaEqu, avaStaHea.staEqu) annotation (Line(points={{82,-108},
          {88,-108},{88,-128},{-72,-128},{-72,290},{-128,290},{-128,326},{-112,326}},
        color={0,0,127}));
  connect(ctlPlaHyb.yIdxSta, enaEquHea.uIdxAltSor) annotation (Line(points={{82,-112},
          {84,-112},{84,-120},{26,-120},{26,366},{38,366}},       color={255,127,
          0}));
  connect(ctlPlaHyb.yIdxSta, enaEquCoo.uIdxAltSor) annotation (Line(points={{82,-112},
          {84,-112},{84,-120},{26,-120},{26,106},{38,106}},       color={255,127,
          0}));
  connect(ctlPlaHyb.yMod[nHpTot], intEqu.u1) annotation (Line(points={{82,-104},
          {90,-104},{90,-132},{72,-132},{72,-150},{78,-150}},
                                                          color={255,127,0}));
  connect(conInt.y, intEqu.u2) annotation (Line(points={{72,-160},{72,-158},{78,
          -158}}, color={255,127,0}));
if have_fouPip then
  connect(intEqu.y, swiTSupSet[nHpTot].u2) annotation (Line(points={{102,-150},{110,
          -150},{110,-120},{188,-120}}, color={255,0,255}));
end if;
  connect(staMat.y, avaStaHea.staEqu) annotation (Line(points={{-198,260},{-164,
          260},{-164,326},{-112,326}},                       color={0,0,127}));
  connect(staMat.y, avaStaCoo.staEqu) annotation (Line(points={{-198,260},{-164,
          260},{-164,204},{-72,204},{-72,44},{-128,44},{-128,66},{-112,66}},
        color={0,0,127}));
  connect(con.y, enaEquHea.u1HeaCoo) annotation (Line(points={{-218,400},{-66,
          400},{-66,344},{38,344},{38,354}},
                                    color={255,0,255}));
  connect(con.y, enaEquCoo.u1HeaCoo) annotation (Line(points={{-218,400},{16,400},
          {16,94},{38,94}},       color={255,0,255}));
  connect(con.y, booScaRep.u) annotation (Line(points={{-218,400},{-190,400},{
          -190,270},{-152,270}}, color={255,0,255}));
  connect(booScaRep.y, or2.u1)
    annotation (Line(points={{-128,270},{-112,270}}, color={255,0,255}));
  connect(booScaRep.y, or1.u2) annotation (Line(points={{-128,270},{-120,270},{
          -120,80},{-132,80},{-132,12},{-122,12}}, color={255,0,255}));
  connect(y1HpPre.y, andHeaEna.u1) annotation (Line(points={{178,380},{-12,380},
          {-12,434},{-18,434}}, color={255,0,255}));
  connect(y1HpPre.y, andCooEna.u1) annotation (Line(points={{178,380},{-132,380},
          {-132,418},{-138,418}}, color={255,0,255}));
  connect(y1HeaPre.y, andHeaEna.u2) annotation (Line(points={{208,360},{160,360},
          {160,378},{-18,378},{-18,426}}, color={255,0,255}));
  connect(notCooMod.y, andCooEna.u2)
    annotation (Line(points={{-122,410},{-138,410}}, color={255,0,255}));
  connect(y1HeaPre.y, notCooMod.u) annotation (Line(points={{208,360},{160,360},
          {160,378},{-88,378},{-88,410},{-98,410}}, color={255,0,255}));
  connect(andHeaEna.y, avaEquHeaCoo.u1EnaHea) annotation (Line(points={{-42,434},
          {-184,434},{-184,226},{-152,226}}, color={255,0,255}));
  connect(andCooEna.y, avaEquHeaCoo.u1EnaCoo) annotation (Line(points={{-162,418},
          {-192,418},{-192,214},{-152,214}}, color={255,0,255}));
  connect(pasHeaPumSta.y, sorRunTimHea.u1Run) annotation (Line(points={{-198,
          300},{-60,300},{-60,296},{-42,296}}, color={255,0,255}));
  connect(pasHeaPumSta.y, comStaHea.u1_actual) annotation (Line(points={{-198,300},
          {-60,300},{-60,252},{-42,252}},      color={255,0,255}));
  connect(pasHeaPumSta.y, sorRunTimCoo.u1Run) annotation (Line(points={{-198,
          300},{-60,300},{-60,36},{-42,36}}, color={255,0,255}));
  connect(pasHeaPumSta.y, comStaCoo.u1_actual) annotation (Line(points={{-198,
          300},{-60,300},{-60,-4},{-42,-4}}, color={255,0,255}));
  connect(seqEve[nHpTot].y1, y1HpFouPip) annotation (Line(points={{162,310},{
          276,310},{276,430},{320,430}},
                                     color={255,0,255}));
  connect(seqEve.y1, y1HpPre.u) annotation (Line(points={{162,310},{276,310},{276,
          380},{202,380}},     color={255,0,255}));
  connect(seqEve.y1Hea, y1HeaPre.u) annotation (Line(points={{162,308},{272,308},
          {272,360},{232,360}}, color={255,0,255}));
  connect(u1HpFouPip_actual, pasHeaPumSta.u[nHpTot]) annotation (Line(points={{-280,
          230},{-236,230},{-236,300},{-222,300}}, color={255,0,255}));
  connect(u1Hp_actual, pasHeaPumSta.u[1:nHp])
    annotation (Line(points={{-280,300},{-222,300}}, color={255,0,255}));
  connect(ctlPlaHyb.yMod[nHpTot], yMod) annotation (Line(points={{82,-104},{86,-104},
          {86,340},{320,340}}, color={255,127,0}));
  connect(seqEve[1:nHp].y1, y1Hp) annotation (Line(points={{162,310},{276,310},{
          276,380},{320,380}}, color={255,0,255}));
  connect(seqEve[1:nHp].y1Hea, y1HeaHp) annotation (Line(points={{162,308},{272,
          308},{272,360},{320,360}}, color={255,0,255}));
  connect(staPumHeaWatPri.y1[1:nPumHeaWatPri], y1PumHeaWatPri)
    annotation (Line(points={{162,200},{320,200}}, color={255,0,255}));
  connect(staPumChiWatPri.y1[1:nPumChiWatPri], y1PumChiWatPri)
    annotation (Line(points={{212,180},{320,180}}, color={255,0,255}));
  connect(or6[nHpTot].y, y1PumHeaWatPriFouPip) annotation (Line(points={{-58,
          -410},{150,-410},{150,-520},{320,-520}}, color={255,0,255}));
  connect(or7[nHpTot].y, y1PumChiWatPriFouPip) annotation (Line(points={{-58,
          -440},{160,-440},{160,-540},{320,-540}}, color={255,0,255}));
  connect(u1PumHeaWatPri_actual, pasPumHeaWatPriSta.u[1:nPumHeaWatPri])
    annotation (Line(points={{-280,200},{-242,200}}, color={255,0,255}));
  connect(u1PumChiWatPri_actual, pasPumChiWatPriSta.u[1:nPumChiWatPri])
    annotation (Line(points={{-280,180},{-210,180}}, color={255,0,255}));
  connect(u1PumChiWatPriFouPip_actual, pasPumChiWatPriSta.u[nPumChiWatPriTot])
    annotation (Line(points={{-280,-480},{-210,-480},{-210,180}}, color={255,0,255}));
  connect(u1PumHeaWatPriFouPip_actual, pasPumHeaWatPriSta.u[nPumHeaWatPriTot])
    annotation (Line(points={{-280,-460},{-242,-460},{-242,200}}, color={255,0,255}));
  connect(swiTSupSet[nHpTot].y, TSupSetFouPip) annotation (Line(points={{212,-120},
          {260,-120},{260,-560},{320,-560}}, color={0,0,127}));
  connect(ctlPumPri.yPumHeaWatPriDed[1:nPumHeaWatPri], yPumHeaWatPriDed)
    annotation (Line(points={{212,76},{270,76},{270,60},{320,60}}, color={0,0,
          127}));
  connect(ctlPumPri.yPumChiWatPriDed[1:nPumChiWatPri], yPumChiWatPriDed)
    annotation (Line(points={{212,72},{260,72},{260,40},{320,40}}, color={0,0,
          127}));
  connect(ctlPlaHyb.yHeaCoo, chaStaCoo.u1HeaCoo) annotation (Line(points={{82,-100},
          {104,-100},{104,-12},{72,-12},{72,84},{-52,84},{-52,68},{-42,68}},
        color={255,0,255}));
  connect(ctlPlaHyb.yHeaCoo, chaStaHea.u1HeaCoo) annotation (Line(points={{82,-100},
          {104,-100},{104,-12},{72,-12},{72,224},{38,224},{38,344},{-52,344},{-52,
          326},{-42,326}}, color={255,0,255}));
  connect(staPumHeaWatPri.y1, or3.u1) annotation (Line(points={{162,200},{232,200},
          {232,50},{212,50}}, color={255,0,255}));
  connect(staPumChiWatPri.y1, or3.u2) annotation (Line(points={{212,180},{226,180},
          {226,42},{212,42}}, color={255,0,255}));
  connect(or3.y, ctlPumPri.u1PumHeaWatPri) annotation (Line(points={{188,50},{172,
          50},{172,96},{188,96}}, color={255,0,255}));
  connect(staPumHeaWatPri.y1, pasPumHeaWatPri.u) annotation (Line(points={{162,200},
          {232,200},{232,20},{212,20}}, color={255,0,255}));
  connect(pasPumHeaWatPri.y, ctlPumPri.u1PumHeaWatPri) annotation (Line(points={
          {188,20},{172,20},{172,96},{188,96}}, color={255,0,255}));
  annotation (
    defaultComponentName="ctl",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-200,-360},{200,360}}),
      graphics={
        Rectangle(
          extent={{-200,360},{200,-360}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,410},{150,370}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(
      coordinateSystem(
        extent={{-260,-560},{300,460}})),
    Documentation(
      info="<html>
<p>
This block implements the sequence of operation for plants with
air-to-water heat pumps.
Most parts of the sequence of operation are similar to that
described in ASHRAE, 2021 for chiller plants.
</p>
<p>
The supported plant configurations are enumerated in the table below.<br/>
</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Configuration parameter</th><th>Options</th><th>Notes</th></tr>
<tr><td>Function</td>
<td>
Heating and cooling<br/>
Heating-only<br/>
Cooling-only
</td>
<td>
</td>
</tr>
<tr><td>Heat recovery</td>
<td>
Without sidestream heat recovery chiller<br/>
With sidestream heat recovery chiller
</td>
<td>
This option is only available for heating and cooling plants.
When selected, the plant controller incorporates logic to manage a chiller
and its associated dedicated primary CHW and CW pumps.
The chiller is considered connected in a sidestream configuration to both
the CHW return and the HW return.
</td>
</tr>
<tr><td>Type of distribution</td>
<td>
Variable primary-only<br/>
Constant primary-variable secondary centralized
</td>
<td>
It is assumed that the HW and the CHW loops have the
same type of distribution, as specified by this parameter.<br/>
Most AWHPs on the market use a reverse cycle for defrosting.
This requires maximum primary flow during defrost cycles.
Consequently, variable primary plants commonly adopt a high
minimum flow setpoint, typically close to the design flow rate,
effectively operating akin to constant primary plants but with
variable speed pumps controlling the loop differential pressure.
While the flow rate directed towards the loads varies,
the bypass valve control loop ensures a constant primary flow
for a given number of staged units.<br/>
\"Centralized secondary pumps\" refers to configurations with a single
group of secondary pumps that is typically integrated into the plant.<br/>
Distributed secondary pumps with multiple secondary loops served
by dedicated secondary pumps are currently not supported.
</td>
</tr>
<tr><td>Type of primary pump arrangement</td>
<td>
Dedicated<br/>
Headered
</td>
<td>It is assumed that the HW and the CHW loops have the
same type of primary pump arrangement, as specified by this parameter.
</td>
</tr>
<tr><td>Separate dedicated primary CHW pumps</td>
<td>
False<br/>
True
</td>
<td>This option is only available for heating and cooling plants
with dedicated primary pumps.
If this option is not selected, each AWHP uses
a common dedicated primary pump for HW and CHW –
this pump is then denoted as the primary HW pump.
Otherwise, each AWHP relies on a separate dedicated HW pump
and a separate dedicated CHW pump.
</td>
</tr>
<tr><td>Type of primary HW pumps</td>
<td>
Variable speed<br/>
Constant speed
</td>
<td>
For constant primary-variable secondary distributions, the variable
speed primary pumps are commanded at fixed speeds, determined during the
Testing, Adjusting and Balancing phase to provide design AWHP flow in
heating and cooling modes.
The same intent is achieved with constant speed primary pumps through the
use of balancing valves.<br/>
This parameter is only available for constant primary-variable secondary plants.
</td>
</tr>
<tr><td>Type of primary CHW pumps</td>
<td>
Variable speed<br/>
Constant speed
</td>
<td>See the note above on primary HW pumps.</td>
</tr>
</table>
<h4>Details</h4>
<p>
A staging matrix <code>staEqu</code> is required as a parameter.
See the documentation of
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable\">
Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable</a>
for the associated definition and requirements.
</p>
<p>
Depending on the plant configuration, the term \"primary HW pumps\"
(and the corresponding variables containing <code>*pumHeaWatPri*</code>)
refers either to primary HW pumps for plants with separate primary
HW and CHW pumps (either headered or dedicated)
or to dedicated primary pumps for plants with common primary pumps
serving both the HW and CHW loops.
</p>
<p>
At its current stage of development, this controller contains no
logic for handling faulted equipment.
It is therefore assumed that any equipment is available at all times.
</p>
<h4>References</h4>
<ul>
<li id=\"ASHRAE2021\">
ASHRAE, 2021. Guideline 36-2021, High-Performance Sequences of Operation
for HVAC Systems. Atlanta, GA.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
January 23, 2025, by Antoine Gautier:<br/>
Refactored to use \"required to run\" conditions in the equipment availability logic.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4432\">#4432</a>.
</li>
<li>
May 31, 2024, by Antoine Gautier:<br/>
Added sidestream heat recovery chiller, primary-only pumping and
failsafe staging conditions.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3808\">#3808</a>.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirToWater;
