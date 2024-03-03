within Buildings.Templates.Plants.Controls.HeatPumps;
block AirToWater "Controller for AWHP plant"

  parameter Boolean have_heaWat
    "Set to true for plants that provide HW"
    annotation(Evaluate=true,
    Dialog(group="Plant configuration"));
  parameter Boolean have_chiWat
    "Set to true for plants that provide CHW"
    annotation(Evaluate=true,
    Dialog(group="Plant configuration"));
  parameter Boolean have_valInlIso
    "Set to true if the system as inlet isolation valves"
    annotation(Evaluate=true,
    Dialog(group="Plant configuration"));
  parameter Boolean have_valOutIso
    "Set to true if the system as outlet isolation valves"
    annotation(Evaluate=true,
    Dialog(group="Plant configuration"));
  final parameter Boolean have_pumHeaWatPri=have_heaWat
    "Set to true for plants with primary HW pumps"
    annotation(Evaluate=true);
  parameter Boolean have_pumChiWatPri(start=false)
    "Set to true for plants with separate primary CHW pumps"
    annotation(Evaluate=true,
    Dialog(enable=have_chiWat, group="Plant configuration"));
  parameter Boolean have_pumHeaWatSec
    "Set to true for plants with secondary HW pumps"
    annotation(Evaluate=true,
    Dialog(enable=have_heaWat, group="Plant configuration"));
  parameter Boolean have_pumChiWatSec
    "Set to true for plants with secondary CHW pumps"
    annotation(Evaluate=true,
    Dialog(enable=have_chiWat, group="Plant configuration"));
  parameter Boolean is_pumPriHdr
    "Set to true for primary headered pumps, false for dedicated pumps"
    annotation(Evaluate=true, Dialog(group="Plant configuration"));
  // Only constant primary pumping is supported for AWHP.
  final parameter Boolean is_pumPriCtlDp=false
    "Set to true for primary headered variable speed pumps using ∆p pump speed control"
    annotation(Evaluate=true, Dialog(group="Plant configuration"));
  // Only headered arrangements are supported for secondary pumps.
  final parameter Boolean is_pumSecHdr=true
    "Set to true for secondary headered pumps, false for dedicated pumps"
    annotation(Evaluate=true, Dialog(group="Plant configuration"));
  // Only ∆p controlled variable speed pumps are supported for secondary pumps.
  final parameter Boolean is_pumSecCtlDp=have_pumHeaWatSec or have_pumChiWatSec
    "Set to true for secondary headered variable speed pumps using ∆p pump speed control"
    annotation(Evaluate=true, Dialog(group="Plant configuration"));
  parameter Boolean have_hrc(start=false)=false
    "Set to true for plants with a sidestream heat recovery chiller"
    annotation(Evaluate=true,
    Dialog(group="Plant configuration", enable=have_heaWat and have_chiWat));
  parameter Boolean have_senPri_select(start=true)=true
    "Set to true for plants with primary flow and return temperature sensors"
    annotation(Evaluate=true,
    Dialog(group="Plant configuration", enable=not have_hrc and have_senSec));
  final parameter Boolean have_senPri=
    if have_hrc or not have_senSec then true else have_senPri_select
    "Set to true for plants with primary flow and return temperature sensors"
    annotation(Evaluate=true);
  parameter Boolean have_senSec_select(start=true)=true
    "Set to true for plants with secondary flow and return temperature sensors"
    annotation(Evaluate=true,
    Dialog(group="Plant configuration",
    enable=(have_pumHeaWatSec or have_pumChiWatSec) and have_senPri_select));
  final parameter Boolean have_senSec=
    if not (have_pumHeaWatSec or have_pumChiWatSec) then false
    elseif not have_senPri_select then true else have_senSec_select
    "Set to true for plants with secondary flow and return temperature sensors"
    annotation(Evaluate=true);
  parameter Integer nHp(min=1)
    "Number of heat pumps"
    annotation(Evaluate=true,
    Dialog(group="Plant configuration"));
  parameter Integer nPumHeaWatPri(
    min=1,
    start=0)=nHp
    "Number of primary HW pumps"
    annotation(Evaluate=true,
    Dialog(group="Plant configuration", enable=have_pumHeaWatPri));
  parameter Integer nPumChiWatPri(
    min=1,
    start=0)=nHp
    "Number of primary CHW pumps"
    annotation(Evaluate=true,
    Dialog(group="Plant configuration", enable=have_pumChiWatPri));
  parameter Integer nPumHeaWatSec(
    min=1,
    start=0)=nHp
    "Number of secondary HW pumps"
    annotation(Evaluate=true,
    Dialog(group="Plant configuration", enable=have_pumHeaWatSec));
  parameter Integer nPumChiWatSec(
    min=1,
    start=0)=nHp
    "Number of secondary CHW pumps"
    annotation(Evaluate=true,
    Dialog(group="Plant configuration", enable=have_pumChiWatSec));
  parameter Boolean have_senDpHeaWatLoc(start=true)=true
    "Set to true for local HW differential pressure sensor hardwired to plant or pump controller"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration", enable=have_heaWat and have_pumHeaWatSec));
  parameter Integer nSenDpHeaWatRem(min=if have_heaWat and have_pumHeaWatSec
         then 1 else 0, start=0)
    "Number of remote HW differential pressure sensors used for HW pump speed control"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration", enable=have_heaWat and have_pumHeaWatSec));
  parameter Boolean have_senDpChiWatLoc(start=true)=true
    "Set to true for local CHW differential pressure sensor hardwired to plant or pump controller"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration", enable=have_chiWat and have_pumChiWatSec));
  parameter Integer nSenDpChiWatRem(min=if have_chiWat and have_pumChiWatSec
         then 1 else 0, start=0)
    "Number of remote CHW differential pressure sensors used for CHW pump speed control"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration", enable=have_chiWat and have_pumChiWatSec));

  parameter Real THeaWatSup_nominal(
    min=273.15,
    start=50 + 273.15,
    unit="K",
    displayUnit="degC")
    "Design (maximum) HW supply temperature setpoint"
    annotation (Dialog(group="Information provided by designer", enable=have_heaWat));
  parameter Real TOutHeaWatLck(
    min=273.15,
    start=21 + 273.15,
    unit="K",
    displayUnit="degC")=294.15
    "Outdoor air lockout temperature above which the HW loop is prevented from operating"
    annotation (Dialog(group="Information provided by designer", enable=have_heaWat));
  parameter Real capHeaHp_nominal[nHp](
    min=fill(0, nHp),
    start=fill(1, nHp),
    unit=fill("W", nHp))
    "Design heating capacity - Each heat pump"
    annotation (Dialog(group="Information provided by designer", enable=have_heaWat));
  parameter Real VHeaWatPri_flow_nominal(
    min=0,
    start=1E-6,
    unit="m3/s")
    "Design primary HW volume flow rate"
    annotation (Evaluate=true,
    Dialog(group="Information provided by designer",
    enable=have_heaWat and have_pumHeaWatPri and is_pumPriCtlDp));
  parameter Real VHeaWatSec_flow_nominal(
    min=0,
    start=1E-6,
    unit="m3/s")
    "Design secondary HW volume flow rate"
    annotation (Evaluate=true,
    Dialog(group="Information provided by designer",
    enable=have_heaWat and have_pumHeaWatSec and is_pumSecCtlDp));
  parameter Real dpHeaWatRemSet_nominal[nSenDpHeaWatRem](
    min=fill(0, nSenDpHeaWatRem),
    start=fill(5E4, nSenDpHeaWatRem),
    unit="Pa")
    "Design (maximum) HW differential pressure setpoint - Remote sensor"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=have_heaWat and have_pumHeaWatSec));
  parameter Real dpHeaWatLocSet_nominal(
    min=0,
    start=15E4,
    unit="Pa")
    "Design (maximum) HW differential pressure setpoint - Local sensor"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=have_heaWat and have_pumHeaWatSec and have_senDpHeaWatLoc));

  parameter Real TChiWatSup_nominal(
    min=273.15,
    start=7 + 273.15,
    unit="K",
    displayUnit="degC")
    "Design (minimum) CHW supply temperature setpoint"
    annotation (Dialog(group="Information provided by designer", enable=have_chiWat));
  parameter Real TOutChiWatLck(
    min=273.15,
    start=16 + 273.15,
    unit="K",
    displayUnit="degC")=289.15
    "Outdoor air lockout temperature above which the CHW loop is prevented from operating"
    annotation (Dialog(group="Information provided by designer", enable=have_chiWat));
  parameter Real capCooHp_nominal[nHp](
    min=fill(0, nHp),
    start=fill(1, nHp),
    unit=fill("W", nHp))
    "Design cooling capacity - Each heat pump"
    annotation (Dialog(group="Information provided by designer", enable=have_chiWat));
  parameter Real VChiWatPri_flow_nominal(
    min=0,
    start=1E-6,
    unit="m3/s")
    "Design primary CHW volume flow rate"
    annotation (Evaluate=true,
    Dialog(group="Information provided by designer",
      enable=have_chiWat and have_pumChiWatPri and is_pumPriCtlDp));
  parameter Real VChiWatSec_flow_nominal(
    min=0,
    start=1E-6,
    unit="m3/s")
    "Design secondary CHW volume flow rate"
    annotation (Evaluate=true,
    Dialog(group="Information provided by designer",
      enable=have_chiWat and have_pumChiWatSec and is_pumSecCtlDp));
  parameter Real dpChiWatRemSet_nominal[nSenDpChiWatRem](
    min=fill(0, nSenDpChiWatRem),
    start=fill(5E4, nSenDpChiWatRem),
    unit="Pa")
    "Design (maximum) CHW differential pressure setpoint - Remote sensor"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=have_chiWat and have_pumChiWatSec));
  parameter Real dpChiWatLocSet_nominal(
    min=0,
    start=15E4,
    unit="Pa")
    "Design (maximum) CHW differential pressure setpoint - Local sensor"
    annotation (Dialog(group=
      "Information provided by testing, adjusting, and balancing contractor",
      enable=have_chiWat and have_pumChiWatSec and have_senDpChiWatLoc));

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
  parameter Real schHea[:, 2]=[
    0, 1;
    24 * 3600, 1]
    "Heating mode enable schedule"
    annotation (Dialog(enable=not have_inpSch, group="Plant enable"));
  parameter Real schCoo[:, 2]=[
    0, 1;
    24 * 3600, 1]
    "Cooling mode enable schedule"
    annotation (Dialog(enable=not have_inpSch, group="Plant enable"));
  parameter Integer nReqIgnHeaWat(min=0)=0
    "Number of ignored HW plant requests"
    annotation (Dialog(tab="Advanced", group="Plant enable"));
  parameter Integer nReqIgnChiWat(min=0)=0
    "Number of ignored CHW plant requests"
    annotation (Dialog(tab="Advanced", group="Plant enable"));
  parameter Real dTOutLck(
    min=0,
    unit="K")=0.5
    "Hysteresis for outdoor air lockout temperature"
    annotation (Dialog(tab="Advanced", group="Plant enable"));
  parameter Real dtRunEna(
    min=0,
    unit="s")=15*60
    "Minimum runtime of enable and disable states"
    annotation (Dialog(tab="Advanced", group="Plant enable"));
  parameter Real dtReqDis(
    min=0,
    unit="s")=3*60
    "Runtime with low number of request before disabling"
    annotation (Dialog(tab="Advanced", group="Plant enable"));
  parameter Real staEqu[:, nHp](
    max=1,
    min=0,
    unit="1")
    "Staging matrix – Equipment required for each stage"
    annotation(Dialog(group="Equipment staging and rotation"));
  final parameter Integer nSta = size(staEqu, 1)
    "Number of stages"
    annotation(Evaluate=true);
  final parameter Integer nEquAlt=
    max({sum({(if staEqu[i, j] > 0 and staEqu[i, j] < 1 then 1 else 0)
      for j in 1:nHp}) for i in 1:nSta})
    "Number of lead/lag alternate equipment"
    annotation(Evaluate=true);
  // RFE: The following could be evaluted from staEqu with a function such as Modelica.Math.BooleanVectors.index.
  parameter Integer idxEquAlt[nEquAlt]
    "Indices of lead/lag alternate equipment"
    annotation(Evaluate=true, Dialog(group="Equipment staging and rotation"));
  parameter Real dtVal(
    final min=0,
    start=90,
    final unit="s")=90
    "Nominal valve timing"
    annotation(Dialog(
    tab="Advanced", group="Equipment staging and rotation",
    enable=have_valInlIso or have_valOutIso));
  parameter Real dtHp(
    final min=0,
    final unit="s")=180
    annotation(Dialog(
    tab="Advanced", group="Equipment staging and rotation"));
  parameter Real plrSta(
    max=1,
    min=0,
    start=0.9,
    unit="1")=0.9
    "Staging part load ratio"
    annotation(Dialog(group="Equipment staging and rotation"));
  parameter Real dtRunSta(
    min=0,
    unit="s",
    displayUnit="min")=900
    "Minimum runtime of each stage"
    annotation (Dialog(tab="Advanced", group="Equipment staging and rotation"));
  parameter Real dtOff(
    min=0,
    unit="s")=900
    "Off time required before equipment is deemed available again"
    annotation (Dialog(tab="Advanced", group="Equipment staging and rotation"));

  parameter Real dtRunPumSta(
    min=0,
    start=600,
    unit="s")=600
    "Runtime before triggering stage command"
    annotation (Dialog(tab="Advanced", group="Pump staging",
    enable=is_pumPriHdr and is_pumPriCtlDp or is_pumSecHdr and is_pumSecCtlDp));
  parameter Real dVOffUpPumSta(
    max=1,
    min=0,
    start=0.03,
    unit="1")=0.03
    "Stage up flow point offset"
    annotation (Dialog(tab="Advanced", group="Pump staging",
    enable=is_pumPriHdr and is_pumPriCtlDp or is_pumSecHdr and is_pumSecCtlDp));
  parameter Real dVOffDowPumSta(
    max=1,
    min=0,
    start=0.03,
    unit="1")=dVOffUpPumSta
    "Stage down flow point offset"
    annotation (Dialog(tab="Advanced", group="Pump staging",
    enable=is_pumPriHdr and is_pumPriCtlDp or is_pumSecHdr and is_pumSecCtlDp));

  Enabling.Enable enaHea(
    final typ=Buildings.Templates.Plants.Controls.Types.Application.Heating,
    final TOutLck=TOutHeaWatLck,
    final dTOutLck=dTOutLck,
    final dtReq=dtReqDis,
    final dtRun=dtRunEna,
    final have_inpSch=have_inpSch,
    final nReqIgn=nReqIgnHeaWat,
    final sch=schHea) if have_heaWat
                      "Heating mode enable"
    annotation (Placement(transformation(extent={{-110,350},{-90,370}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReqHeaWat
    "Number of HW plant requests" annotation (Placement(transformation(extent={{-300,
            320},{-260,360}}),      iconTransformation(extent={{-180,20},{-140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-300,60},{-260,100}}),
      iconTransformation(extent={{-180,-40},{-140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SchHea if have_inpSch
    "Heating mode enable via schedule" annotation (Placement(transformation(
          extent={{-300,360},{-260,400}}), iconTransformation(extent={{-180,200},
            {-140,240}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReqChiWat
    "Number of CHW plant requests" annotation (Placement(transformation(extent={{-300,
            300},{-260,340}}),       iconTransformation(extent={{-180,0},{-140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SchCoo if have_inpSch
    "Cooling mode enable via schedule" annotation (Placement(transformation(
          extent={{-300,340},{-260,380}}), iconTransformation(extent={{-180,180},
            {-140,220}})));
  Utilities.StageIndex idxStaHea(final nSta=nSta, final dtRun=dtRunSta)
    if have_heaWat
    "Compute heating stage index"
    annotation (Placement(transformation(extent={{-10,350},{10,370}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HpAva[nHp]
    "FIXME(AntoineGautier): Heat pump available signal – Should rather be a fault code signal (AI)?"
    annotation (Placement(transformation(extent={{-300,240},{-260,280}}),
        iconTransformation(extent={{-180,160},{-140,200}})));
  StagingRotation.StageAvailability avaStaHea(final staEqu=staEqu)
    if have_heaWat
    "Evaluate heating stage availability"
    annotation (Placement(transformation(extent={{-110,310},{-90,330}})));
  StagingRotation.EquipmentEnable enaEquHea(final staEqu=staEqu) if have_heaWat
    "Compute enable command for equipment in heating mode"
    annotation (Placement(transformation(extent={{40,350},{60,370}})));
  Enabling.EventSequencing eveSeqEna[nHp](
    each final have_heaWat=have_heaWat,
    each final have_chiWat=have_chiWat,
    each final have_valInlIso=have_valInlIso,
    each final have_valOutIso=have_valOutIso,
    each final have_pumHeaWatPri=have_pumHeaWatPri,
    each final have_pumChiWatPri=have_pumChiWatPri,
    each final have_pumHeaWatSec=have_pumHeaWatSec,
    each final have_pumChiWatSec=have_pumChiWatSec,
    each final dtVal=dtVal,
    each final dtHp=dtHp)
    "Event sequencing for enabled equipment"
    annotation (Placement(transformation(extent={{140,284},{160,312}})));
  StagingRotation.StageAvailability avaStaCoo(final staEqu=staEqu)
    if have_chiWat
    "Evaluate cooling stage availability"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPri_actual[
    nPumHeaWatPri] if have_pumHeaWatPri "Primary HW pump status" annotation (
      Placement(transformation(extent={{-300,180},{-260,220}}),
        iconTransformation(extent={{-180,120},{-140,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPri_actual[
    nPumChiWatPri] if have_pumChiWatPri "Primary CHW pump status" annotation (
      Placement(transformation(extent={{-300,160},{-260,200}}),
        iconTransformation(extent={{-180,100},{-140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatSec_actual[
    nPumHeaWatSec] if have_pumHeaWatSec "Secondary HW pump status" annotation (
      Placement(transformation(extent={{-300,140},{-260,180}}),
        iconTransformation(extent={{-180,80},{-140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatSec_actual[
    nPumChiWatSec] if have_pumChiWatSec "Secondary CHW pump status" annotation (
     Placement(transformation(extent={{-300,120},{-260,160}}),
        iconTransformation(extent={{-180,60},{-140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatInlIso[nHp]
    if have_heaWat and have_valInlIso
    "Heat pump inlet HW inlet isolation valve command" annotation (Placement(
        transformation(extent={{260,300},{300,340}}), iconTransformation(extent={{140,120},
            {180,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatOutIso[nHp]
    if have_heaWat and have_valOutIso
    "Heat pump outlet HW isolation valve command" annotation (Placement(
        transformation(extent={{260,280},{300,320}}), iconTransformation(extent={{140,100},
            {180,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatInlIso[nHp]
    if have_chiWat and have_valInlIso
    "Heat pump inlet CHW isolation valve command" annotation (Placement(
        transformation(extent={{260,260},{300,300}}), iconTransformation(extent={{140,80},
            {180,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatOutIso[nHp]
    if have_chiWat and have_valOutIso
    "Heat pump outlet CHW isolation valve command" annotation (Placement(
        transformation(extent={{260,240},{300,280}}), iconTransformation(extent={{140,60},
            {180,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatPri[
    nPumHeaWatPri] if have_pumHeaWatPri "Primary HW pump start command"
    annotation (Placement(transformation(extent={{260,180},{300,220}}),
        iconTransformation(extent={{140,20},{180,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatPri[
    nPumChiWatPri] if have_pumChiWatPri "Primary CHW pump start command"
    annotation (Placement(transformation(extent={{260,160},{300,200}}),
        iconTransformation(extent={{140,0},{180,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatSec[
    nPumHeaWatSec] if have_pumHeaWatSec "Secondary HW pump start command"
    annotation (Placement(transformation(extent={{260,140},{300,180}}),
        iconTransformation(extent={{140,-40},{180,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatSec[
    nPumChiWatSec] if have_pumChiWatSec "Secondary CHW pump start command"
    annotation (Placement(transformation(extent={{260,120},{300,160}}),
        iconTransformation(extent={{140,-60},{180,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hp[nHp]
    "Heat pump enable command" annotation (Placement(transformation(extent={{
            260,360},{300,400}}), iconTransformation(extent={{140,180},{180,220}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hea[nHp]
    if have_heaWat and have_chiWat
    "Heat pump heating/cooling mode command: true=heating, false=cooling"
                                                                annotation (
      Placement(transformation(extent={{260,340},{300,380}}),
        iconTransformation(extent={{140,160},{180,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatPriRet(final unit="K",
      displayUnit="degC") if have_heaWat and have_senPri
    "Primary HW return temperature"                       annotation (Placement(
        transformation(extent={{-300,20},{-260,60}}), iconTransformation(extent={{-180,
            -60},{-140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHeaWatPri_flow(final unit="m3/s")
    if have_heaWat and have_senPri "Primary HW volume flow rate"
                                  annotation (Placement(transformation(extent={{
            -300,0},{-260,40}}), iconTransformation(extent={{-180,-80},{-140,-40}})));
  StagingRotation.StageChangeCommand chaStaHea(
    final have_inpPlrSta=false,
    final plrSta=plrSta,
    final staEqu=staEqu,
    final capEqu=capHeaHp_nominal,
    final dtRun=dtRunSta,
    final cp_default=cp_default,
    final rho_default=rho_default) if have_heaWat
    "Generate heating stage transition command"
    annotation (Placement(transformation(extent={{-40,308},{-20,332}})));
  StagingRotation.SortRuntime sorRunTimHea(idxEquAlt=idxEquAlt, nin=nHp)
                                                              if have_heaWat
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
    final sch=schCoo) if have_chiWat
    "Cooling mode enable"
    annotation (Placement(transformation(extent={{-110,90},{-90,110}})));
  StagingRotation.StageChangeCommand chaStaCoo(
    final have_inpPlrSta=false,
    final plrSta=plrSta,
    final staEqu=staEqu,
    final capEqu=capCooHp_nominal,
    final dtRun=dtRunSta,
    final cp_default=cp_default,
    final rho_default=rho_default) if have_chiWat
    "Generate cooling stage transition command"
    annotation (Placement(transformation(extent={{-40,50},{-20,74}})));
  Utilities.StageIndex idxStaCoo(final nSta=nSta, final dtRun=dtRunSta)
    if have_chiWat
    "Compute cooling stage index"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  StagingRotation.EquipmentEnable enaEquCoo(final staEqu=staEqu) if have_chiWat
    "Compute enable command for equipment in cooling mode"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatPriRet(final unit="K",
      displayUnit="degC") if have_chiWat and have_senPri
    "Primary CHW return temperature"                       annotation (
      Placement(transformation(extent={{-300,-40},{-260,0}}),
        iconTransformation(extent={{-180,-100},{-140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWatPri_flow(final unit="m3/s")
    if have_chiWat and have_senPri "Primary CHW volume flow rate"
                                   annotation (Placement(transformation(extent={
            {-300,-60},{-260,-20}}), iconTransformation(extent={{-180,-120},{-140,
            -80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant FIXME_THeaWatSupSet(k=
        THeaWatSup_nominal) "Replace with output of reset block"
    annotation (Placement(transformation(extent={{-370,272},{-350,292}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant FIXME_TChiWatSupSet(k=
        TChiWatSup_nominal) "Replace with output of reset block"
    annotation (Placement(transformation(extent={{-330,272},{-310,292}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hp_actual[nHp]
    "Heat pump status" annotation (Placement(transformation(extent={{-300,280},
            {-260,320}}), iconTransformation(extent={{-180,140},{-140,180}})));
  StagingRotation.EquipmentAvailability_state avaEquHeaCoo[nHp](
    each final have_heaWat=have_heaWat,
    each final have_chiWat=have_chiWat,
    each final dtOff=dtOff)
    "Evaluate equipment availability in heating or cooling mode"
    annotation (Placement(transformation(extent={{-150,250},{-130,270}})));
  Buildings.Controls.OBC.CDL.Logical.Pre y1HeaPre[nHp]
    "Left-limit of command signal to break algebraic loop"
    annotation (Placement(transformation(extent={{230,350},{210,370}})));
  StagingRotation.SortRuntime sorRunTimCoo(final idxEquAlt=idxEquAlt, nin=nHp)
                                                              if have_chiWat
    "Sort lead/lag alternate equipment by staging runtime – Cooling mode"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold DEBUG_y1UpHea(
      trueHoldDuration=1, falseHoldDuration=0)
    annotation (Placement(transformation(extent={{42,316},{62,336}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold DEBUG_y1DowHea(
      trueHoldDuration=1, falseHoldDuration=0)
    annotation (Placement(transformation(extent={{42,288},{62,308}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold DEBUG_y1UpCoo(
      trueHoldDuration=1, falseHoldDuration=0)
    annotation (Placement(transformation(extent={{40,52},{60,72}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold DEBUG_y1DowCoo(
      trueHoldDuration=1, falseHoldDuration=0)
    annotation (Placement(transformation(extent={{40,24},{60,44}})));
  Pumps.Generic.Staging staPumHeaWatPri(
    final is_pri=true,
    final have_valInlIso=have_valInlIso,
    final have_valOutIso=have_valOutIso,
    final nEqu=nHp,
    final nPum=nPumHeaWatPri,
    final is_hdr=is_pumPriHdr,
    final is_ctlDp=is_pumPriCtlDp,
    final V_flow_nominal=VHeaWatPri_flow_nominal,
    final dtRun=dtRunPumSta,
    final dVOffUp=dVOffUpPumSta,
    final dVOffDow=dVOffDowPumSta) if have_pumHeaWatPri
    "Primary HW pump staging"
    annotation (Placement(transformation(extent={{140,190},{160,210}})));
  Pumps.Generic.Staging staPumChiWatPri(
    final is_pri=true,
    final have_valInlIso=have_valInlIso,
    final have_valOutIso=have_valOutIso,
    final nEqu=nHp,
    final nPum=nPumChiWatPri,
    final is_hdr=is_pumPriHdr,
    final is_ctlDp=is_pumPriCtlDp,
    final V_flow_nominal=VChiWatPri_flow_nominal,
    final dtRun=dtRunPumSta,
    final dVOffUp=dVOffUpPumSta,
    final dVOffDow=dVOffDowPumSta) if have_pumChiWatPri
    "Primary CHW pump staging"
    annotation (Placement(transformation(extent={{190,170},{210,190}})));
  Pumps.Generic.Staging staPumChiWatSec(
    final is_pri=false,
    final nEqu=nHp,
    final nPum=nPumChiWatSec,
    final is_hdr=is_pumSecHdr,
    final is_ctlDp=is_pumSecCtlDp,
    final V_flow_nominal=VChiWatSec_flow_nominal,
    final dtRun=dtRunPumSta,
    final dVOffUp=dVOffUpPumSta,
    final dVOffDow=dVOffDowPumSta) if have_pumChiWatSec
    "Secondary CHW pump staging"
    annotation (Placement(transformation(extent={{190,130},{210,150}})));
  Pumps.Generic.Staging staPumHeaWatSec(
    final is_pri=false,
    final nEqu=nHp,
    final nPum=nPumHeaWatSec,
    final is_hdr=is_pumSecHdr,
    final is_ctlDp=is_pumSecCtlDp,
    final V_flow_nominal=VHeaWatSec_flow_nominal,
    final dtRun=dtRunPumSta,
    final dVOffUp=dVOffUpPumSta,
    final dVOffDow=dVOffDowPumSta) if have_pumHeaWatSec
    "Secondary HW pump staging"
    annotation (Placement(transformation(extent={{140,150},{160,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSecRet(final unit="K",
      displayUnit="degC") if have_heaWat and have_senSec
    "Secondary HW return temperature" annotation (Placement(transformation(
          extent={{-300,-100},{-260,-60}}), iconTransformation(extent={{-180,-140},
            {-140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHeaWatSec_flow(final unit="m3/s")
    if have_heaWat and have_senSec "Secondary HW volume flow rate" annotation (
      Placement(transformation(extent={{-300,-120},{-260,-80}}),
        iconTransformation(extent={{-180,-162},{-140,-122}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSecRet(final unit="K",
      displayUnit="degC") if have_chiWat and have_senSec
    "Secondary CHW return temperature" annotation (Placement(transformation(
          extent={{-300,-160},{-260,-120}}), iconTransformation(extent={{-180,-182},
            {-140,-142}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWatSec_flow(final unit="m3/s")
    if have_chiWat and have_senSec "Secondary CHW volume flow rate" annotation (
     Placement(transformation(extent={{-300,-180},{-260,-140}}),
        iconTransformation(extent={{-180,-202},{-140,-162}})));
  Utilities.PlaceHolderReal THeaWatRet(have_inp=have_senPri, have_inpPla=true)
    if have_heaWat "Select HW return temperature sensor"
    annotation (Placement(transformation(extent={{-230,30},{-210,50}})));
  Utilities.PlaceHolderReal VHeaWat_flow(have_inp=have_senPri, have_inpPla=true)
    if have_heaWat "Select HW flow sensor"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  Utilities.PlaceHolderReal TChiWatRet(have_inp=have_senPri, have_inpPla=true)
    if have_chiWat "Select CHW return temperature sensor"
    annotation (Placement(transformation(extent={{-230,-30},{-210,-10}})));
  Utilities.PlaceHolderReal VChiWat_flow(have_inp=have_senPri, have_inpPla=true)
    if have_chiWat "Select CHW flow sensor"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Pre y1HpPre[nHp]
    "Left-limit of command signal to break algebraic loop"
    annotation (Placement(transformation(extent={{200,370},{180,390}})));
equation
  connect(u1SchHea, enaHea.u1Sch) annotation (Line(points={{-280,380},{-180,380},
          {-180,364},{-112,364}}, color={255,0,255}));
  connect(nReqHeaWat, enaHea.nReq)
    annotation (Line(points={{-280,340},{-178,340},{-178,360},{-112,360}},
                                                     color={255,127,0}));
  connect(TOut, enaHea.TOut) annotation (Line(points={{-280,80},{-170,80},{-170,
          356},{-112,356}}, color={0,0,127}));
  connect(enaHea.y1, idxStaHea.u1Lea) annotation (Line(points={{-88,360},{-56,
          360},{-56,366},{-12,366}},  color={255,0,255}));
  connect(avaStaHea.y1, idxStaHea.u1Ava) annotation (Line(points={{-88,320},{
          -56,320},{-56,354},{-12,354}},
                                     color={255,0,255}));
  connect(idxStaHea.y,enaEquHea. uSta)
    annotation (Line(points={{12,360},{38,360}},   color={255,127,0}));
  connect(eveSeqEna.y1, y1Hp) annotation (Line(points={{162,312},{236,312},{236,
          380},{280,380}}, color={255,0,255}));
  connect(eveSeqEna.y1Hea, y1Hea) annotation (Line(points={{162,310},{238,310},{
          238,360},{280,360}},color={255,0,255}));
  connect(eveSeqEna.y1ValHeaWatOutIso, y1ValHeaWatOutIso) annotation (Line(
        points={{162,300},{240,300},{240,300},{280,300}},
                                                       color={255,0,255}));
  connect(eveSeqEna.y1ValHeaWatInlIso, y1ValHeaWatInlIso) annotation (Line(
        points={{162,302},{240,302},{240,320},{280,320}},
                                                       color={255,0,255}));
  connect(eveSeqEna.y1ValChiWatInlIso, y1ValChiWatInlIso) annotation (Line(
        points={{162,298},{238,298},{238,280},{280,280}},
                                                       color={255,0,255}));
  connect(eveSeqEna.y1ValChiWatOutIso, y1ValChiWatOutIso) annotation (Line(
        points={{162,296},{236,296},{236,260},{280,260}},
                                                       color={255,0,255}));
  connect(idxStaHea.y, chaStaHea.uSta) annotation (Line(points={{12,360},{24,
          360},{24,340},{-50,340},{-50,330},{-42,330}},
                                                   color={255,127,0}));
  connect(chaStaHea.y1Dow, idxStaHea.u1Dow) annotation (Line(points={{-18,316},
          {-14,316},{-14,358},{-12,358}},color={255,0,255}));
  connect(chaStaHea.y1Up, idxStaHea.u1Up) annotation (Line(points={{-18,324},{
          -16,324},{-16,362},{-12,362}},
                                     color={255,0,255}));
  connect(avaStaHea.y1, chaStaHea.u1AvaSta) annotation (Line(points={{-88,320},{
          -56,320},{-56,326},{-42,326}},  color={255,0,255}));
  connect(sorRunTimHea.yIdx, enaEquHea.uIdxAltSor) annotation (Line(points={{-18,284},
          {32,284},{32,366},{38,366}},      color={255,127,0}));
  connect(nReqChiWat, enaCoo.nReq) annotation (Line(points={{-280,320},{-182,320},
          {-182,100},{-112,100}},      color={255,127,0}));
  connect(TOut, enaCoo.TOut) annotation (Line(points={{-280,80},{-170,80},{-170,
          96},{-112,96}},   color={0,0,127}));
  connect(u1SchCoo, enaCoo.u1Sch) annotation (Line(points={{-280,360},{-180,360},
          {-180,104},{-112,104}}, color={255,0,255}));
  connect(avaStaCoo.y1, chaStaCoo.u1AvaSta) annotation (Line(points={{-88,60},{-56,
          60},{-56,68},{-42,68}},         color={255,0,255}));
  connect(enaCoo.y1, idxStaCoo.u1Lea) annotation (Line(points={{-88,100},{-56,100},
          {-56,106},{-12,106}},      color={255,0,255}));
  connect(chaStaCoo.y1Up, idxStaCoo.u1Up) annotation (Line(points={{-18,66},{-16,
          66},{-16,102},{-12,102}},      color={255,0,255}));
  connect(chaStaCoo.y1Dow, idxStaCoo.u1Dow) annotation (Line(points={{-18,58},{-14,
          58},{-14,98},{-12,98}},         color={255,0,255}));
  connect(idxStaCoo.y, enaEquCoo.uSta)
    annotation (Line(points={{12,100},{38,100}}, color={255,127,0}));
  connect(enaEquHea.y1, eveSeqEna.u1Hea) annotation (Line(points={{62,360},{80,360},
          {80,310},{138,310}},       color={255,0,255}));
  connect(enaEquCoo.y1, eveSeqEna.u1Coo) annotation (Line(points={{62,100},{80,100},
          {80,306},{138,306}}, color={255,0,255}));
  connect(FIXME_TChiWatSupSet.y, chaStaCoo.TSupSet) annotation (Line(points={{-308,
          282},{-52,282},{-52,64},{-42,64}},   color={0,0,127}));
  connect(FIXME_THeaWatSupSet.y, chaStaHea.TSupSet) annotation (Line(points={{-348,
          282},{-52,282},{-52,322},{-42,322}}, color={0,0,127}));
  connect(u1HpAva, avaEquHeaCoo.u1Ava)
    annotation (Line(points={{-280,260},{-152,260}}, color={255,0,255}));
  connect(y1Hea, y1HeaPre.u)
    annotation (Line(points={{280,360},{232,360}}, color={255,0,255}));
  connect(y1HeaPre.y, avaEquHeaCoo.u1Hea_actual) annotation (Line(points={{208,360},
          {160,360},{160,378},{-156,378},{-156,254},{-152,254}},      color={
          255,0,255}));
  connect(avaEquHeaCoo.y1Hea, avaStaHea.u1AvaEqu) annotation (Line(points={{-128,
          266},{-120,266},{-120,320},{-112,320}}, color={255,0,255}));
  connect(avaEquHeaCoo.y1Coo, avaStaCoo.u1AvaEqu) annotation (Line(points={{-128,
          254},{-120,254},{-120,60},{-112,60}}, color={255,0,255}));
  connect(avaStaCoo.y1, idxStaCoo.u1Ava) annotation (Line(points={{-88,60},{-56,
          60},{-56,94},{-12,94}},    color={255,0,255}));
  connect(avaEquHeaCoo.y1Hea, enaEquHea.u1AvaEqu) annotation (Line(points={{-128,
          266},{36,266},{36,354},{38,354}}, color={255,0,255}));
  connect(avaEquHeaCoo.y1Coo, enaEquCoo.u1AvaEqu) annotation (Line(points={{-128,
          254},{36,254},{36,94},{38,94}}, color={255,0,255}));
  connect(sorRunTimCoo.yIdx, enaEquCoo.uIdxAltSor) annotation (Line(
        points={{-18,14},{32,14},{32,106},{38,106}},   color={255,127,0}));
  connect(idxStaCoo.y, chaStaCoo.uSta) annotation (Line(points={{12,100},{24,100},
          {24,80},{-48,80},{-48,72},{-42,72}},     color={255,127,0}));
  connect(chaStaHea.y1Up, DEBUG_y1UpHea.u) annotation (Line(points={{-18,324},{14,
          324},{14,326},{40,326}}, color={255,0,255}));
  connect(chaStaHea.y1Dow, DEBUG_y1DowHea.u) annotation (Line(points={{-18,316},
          {12,316},{12,298},{40,298}}, color={255,0,255}));
  connect(chaStaCoo.y1Up, DEBUG_y1UpCoo.u) annotation (Line(points={{-18,66},{10,
          66},{10,62},{38,62}},    color={255,0,255}));
  connect(chaStaCoo.y1Dow, DEBUG_y1DowCoo.u) annotation (Line(points={{-18,58},{
          12,58},{12,34},{38,34}},     color={255,0,255}));
  connect(avaEquHeaCoo.y1Hea, sorRunTimHea.u1Ava) annotation (Line(points={{-128,
          266},{-120,266},{-120,284},{-42,284}}, color={255,0,255}));
  connect(avaEquHeaCoo.y1Coo, sorRunTimCoo.u1Ava) annotation (Line(points={{-128,
          254},{-120,254},{-120,14},{-42,14}}, color={255,0,255}));
  connect(staPumChiWatPri.y1, y1PumChiWatPri)
    annotation (Line(points={{212,180},{280,180}}, color={255,0,255}));
  connect(staPumChiWatPri.y1_actual, eveSeqEna.u1PumChiWatPri_actual)
    annotation (Line(points={{212,186},{220,186},{220,262},{122,262},{122,296},{
          138,296}}, color={255,0,255}));
  connect(eveSeqEna.y1PumChiWatPri, staPumChiWatPri.u1Pum) annotation (Line(
        points={{162,290},{178,290},{178,182},{188,182}}, color={255,0,255}));
  connect(u1PumChiWatPri_actual, staPumChiWatPri.u1Pum_actual) annotation (Line(
        points={{-280,180},{180,180},{180,176},{188,176}}, color={255,0,255}));
  connect(u1PumHeaWatPri_actual, staPumHeaWatPri.u1Pum_actual) annotation (Line(
        points={{-280,200},{130,200},{130,196},{138,196}}, color={255,0,255}));
  connect(staPumHeaWatPri.y1_actual, eveSeqEna.u1PumHeaWatPri_actual)
    annotation (Line(points={{162,206},{164,206},{164,260},{120,260},{120,298},{
          138,298}}, color={255,0,255}));
  connect(staPumHeaWatSec.y1, y1PumHeaWatSec)
    annotation (Line(points={{162,160},{280,160}}, color={255,0,255}));
  connect(staPumChiWatSec.y1, y1PumChiWatSec)
    annotation (Line(points={{212,140},{280,140}}, color={255,0,255}));
  connect(u1PumHeaWatSec_actual, staPumHeaWatSec.u1Pum_actual) annotation (Line(
        points={{-280,160},{120,160},{120,156},{138,156}}, color={255,0,255}));
  connect(u1PumChiWatSec_actual, staPumChiWatSec.u1Pum_actual) annotation (Line(
        points={{-280,140},{180,140},{180,136},{188,136}}, color={255,0,255}));
  connect(staPumHeaWatPri.y1, y1PumHeaWatPri) annotation (Line(points={{162,200},
          {216,200},{216,200},{280,200}}, color={255,0,255}));
  connect(staPumChiWatSec.y1_actual, eveSeqEna.u1PumChiWatSec_actual)
    annotation (Line(points={{212,146},{222,146},{222,266},{126,266},{126,290},{
          138,290}}, color={255,0,255}));
  connect(eveSeqEna.y1PumHeaWatPri, staPumHeaWatPri.u1Pum) annotation (Line(
        points={{162,292},{162,220},{130,220},{130,202},{138,202}},
        color={255,0,255}));
  connect(staPumHeaWatSec.y1_actual, eveSeqEna.u1PumHeaWatSec_actual)
    annotation (Line(points={{162,166},{166,166},{166,264},{124,264},{124,292},{
          138,292}}, color={255,0,255}));
  connect(VHeaWatSec_flow, staPumHeaWatSec.V_flow) annotation (Line(points={{-280,
          -100},{120,-100},{120,152},{138,152}}, color={0,0,127}));
  connect(VChiWatSec_flow, staPumChiWatSec.V_flow) annotation (Line(points={{-280,
          -160},{180,-160},{180,132},{188,132}}, color={0,0,127}));
  connect(THeaWatPriRet, THeaWatRet.u)
    annotation (Line(points={{-280,40},{-232,40}}, color={0,0,127}));
  connect(THeaWatRet.y, chaStaHea.TRet) annotation (Line(points={{-208,40},{-162,
          40},{-162,306},{-50,306},{-50,318},{-42,318}}, color={0,0,127}));
  connect(THeaWatSecRet, THeaWatRet.uPla) annotation (Line(points={{-280,-80},{-240,
          -80},{-240,36},{-232,36}}, color={0,0,127}));
  connect(VHeaWatPri_flow, VHeaWat_flow.u)
    annotation (Line(points={{-280,20},{-202,20}}, color={0,0,127}));
  connect(VHeaWat_flow.y, chaStaHea.V_flow) annotation (Line(points={{-178,20},{
          -160,20},{-160,304},{-48,304},{-48,314},{-42,314}}, color={0,0,127}));
  connect(VHeaWatSec_flow, VHeaWat_flow.uPla) annotation (Line(points={{-280,-100},
          {-206,-100},{-206,16},{-202,16}}, color={0,0,127}));
  connect(TChiWatPriRet, TChiWatRet.u)
    annotation (Line(points={{-280,-20},{-232,-20}}, color={0,0,127}));
  connect(TChiWatRet.y, chaStaCoo.TRet) annotation (Line(points={{-208,-20},{-158,
          -20},{-158,48},{-52,48},{-52,60},{-42,60}}, color={0,0,127}));
  connect(TChiWatSecRet, TChiWatRet.uPla) annotation (Line(points={{-280,-140},{
          -238,-140},{-238,-24},{-232,-24}}, color={0,0,127}));
  connect(VChiWatPri_flow, VChiWat_flow.u)
    annotation (Line(points={{-280,-40},{-202,-40}}, color={0,0,127}));
  connect(VChiWat_flow.y, chaStaCoo.V_flow) annotation (Line(points={{-178,-40},
          {-156,-40},{-156,38},{-50,38},{-50,56},{-42,56}}, color={0,0,127}));
  connect(VChiWatSec_flow, VChiWat_flow.uPla) annotation (Line(points={{-280,-160},
          {-204,-160},{-204,-44},{-202,-44}}, color={0,0,127}));
  connect(enaHea.y1, staPumHeaWatSec.u1Pla) annotation (Line(points={{-88,360},
          {-80,360},{-80,162},{128,162},{128,160},{138,160}},
                                         color={255,0,255}));
  connect(enaCoo.y1, staPumChiWatSec.u1Pla) annotation (Line(points={{-88,100},
          {-80,100},{-80,138},{186,138},{186,140},{188,140}},
                                         color={255,0,255}));
  connect(eveSeqEna.y1ValHeaWatInlIso, staPumHeaWatPri.u1ValInlIso) annotation (
     Line(points={{162,302},{170,302},{170,216},{134,216},{134,206},{138,206}},
        color={255,0,255}));
  connect(eveSeqEna.y1ValHeaWatOutIso, staPumHeaWatPri.u1ValOutIso) annotation (
     Line(points={{162,300},{168,300},{168,218},{132,218},{132,204},{138,204}},
        color={255,0,255}));
  connect(eveSeqEna.y1ValChiWatInlIso, staPumChiWatPri.u1ValInlIso) annotation (
     Line(points={{162,298},{182,298},{182,186},{188,186}}, color={255,0,255}));
  connect(eveSeqEna.y1ValChiWatOutIso, staPumChiWatPri.u1ValOutIso) annotation (
     Line(points={{162,296},{180,296},{180,184},{188,184}}, color={255,0,255}));
  connect(u1Hp_actual, staPumHeaWatPri.u1Equ_actual) annotation (Line(points={{
          -280,300},{-184,300},{-184,198},{138,198}}, color={255,0,255}));
  connect(u1Hp_actual, staPumChiWatPri.u1Equ_actual) annotation (Line(points={{
          -280,300},{-184,300},{-184,178},{188,178}}, color={255,0,255}));
  connect(eveSeqEna.y1AndHea, staPumHeaWatPri.u1Equ) annotation (Line(points={{162,308},
          {172,308},{172,214},{136,214},{136,208},{138,208}},
                                                   color={255,0,255}));
  connect(eveSeqEna.y1AndCoo, staPumChiWatPri.u1Equ) annotation (Line(points={{162,306},
          {184,306},{184,188},{188,188}},          color={255,0,255}));
  connect(u1Hp_actual, sorRunTimHea.u1Run) annotation (Line(points={{-280,300},
          {-60,300},{-60,296},{-42,296}}, color={255,0,255}));
  connect(u1Hp_actual, sorRunTimCoo.u1Run) annotation (Line(points={{-280,300},
          {-60,300},{-60,26},{-42,26}}, color={255,0,255}));
  connect(y1Hp, y1HpPre.u)
    annotation (Line(points={{280,380},{202,380}}, color={255,0,255}));
  connect(y1HpPre.y, avaEquHeaCoo.u1_actual) annotation (Line(points={{178,380},
          {-158,380},{-158,266},{-152,266}}, color={255,0,255}));
  annotation (
    defaultComponentName="ctl",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-140,-240},{140,240}}),
      graphics={
        Line(
          points={{-90,-80.3976},{68,-80.3976}},
          color={192,192,192}),
        Rectangle(
          extent={{-140,240},{140,-240}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,290},{150,250}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(coordinateSystem(extent={{-260,-400},{260,400}})),
    Documentation(info="<html>
<p>
FIXME: Add assert for is_pumPriHdr and nHp > 1 because a one-HP plant must have dedicated pumps.
</p>
</html>"));
end AirToWater;
