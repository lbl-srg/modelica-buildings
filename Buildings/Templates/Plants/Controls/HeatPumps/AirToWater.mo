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
  parameter Boolean have_valInlIso(start=false)
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
  parameter Integer nHp(final min=1)
    "Number of heat pumps"
    annotation(Evaluate=true,
    Dialog(group="Plant configuration"));
  parameter Integer nPumHeaWatPri(final min=1, start=0)=nHp
    "Number of primary HW pumps"
    annotation(Evaluate=true,
    Dialog(group="Plant configuration", enable=have_pumHeaWatPri));
  parameter Integer nPumChiWatPri(final min=1, start=0)=nHp
    "Number of primary CHW pumps"
    annotation(Evaluate=true,
    Dialog(group="Plant configuration", enable=have_pumChiWatPri));
  parameter Integer nPumHeaWatSec(final min=1, start=0)=nHp
    "Number of secondary HW pumps"
    annotation(Evaluate=true,
    Dialog(group="Plant configuration", enable=have_pumHeaWatSec));
  parameter Integer nPumChiWatSec(final min=1, start=0)=nHp
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
  parameter Real VHeaWatSec_flow_nominal(
    min=0,
    start=0.01,
    unit="m3/s")
    "Design secondary HW volume flow rate"
    annotation (Evaluate=true,
    Dialog(group="Information provided by designer", enable=have_heaWat and have_pumHeaWatSec));
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
  parameter Real VChiWatSec_flow_nominal(
    min=0,
    start=0.01,
    unit="m3/s")
    "Design secondary CHW volume flow rate"
    annotation (Evaluate=true,
    Dialog(group="Information provided by designer", enable=have_chiWat and have_pumChiWatSec));
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
  // RFE: The following could be evaluted with a function such as Modelica.Math.BooleanVectors.index.
  parameter Integer idxEquAlt[nEquAlt]
    "Indices of lead/lag alternate equipment"
    annotation(Evaluate=true, Dialog(group="Equipment staging and rotation"));
  parameter Real dtVal_nominal(
    min=0,
    start=90,
    unit="s")=90
    "Nominal valve timing"
    annotation(Dialog(
    tab="Advanced", group="Equipment staging and rotation",
    enable=have_valInlIso or have_valOutIso));
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
            322},{-260,362}}),      iconTransformation(extent={{-140,120},{-100,
            160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-300,60},{-260,100}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SchHea if have_inpSch
    "Heating mode enable via schedule" annotation (Placement(transformation(
          extent={{-300,362},{-260,402}}), iconTransformation(extent={{-140,160},
            {-100,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReqChiWat
    "Number of CHW plant requests" annotation (Placement(transformation(extent={{-300,
            300},{-260,340}}),       iconTransformation(extent={{-140,100},{-100,
            140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SchCoo if have_inpSch
    "Cooling mode enable via schedule" annotation (Placement(transformation(
          extent={{-300,342},{-260,382}}), iconTransformation(extent={{-140,140},
            {-100,180}})));
  Utilities.StageIndex idxStaHea(final nSta=nSta, final dtRun=dtRunSta)
    if have_heaWat
    "Compute heating stage index"
    annotation (Placement(transformation(extent={{-10,350},{10,370}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava[nHp]
    "FIXME(AntoineGautier): Heat pump available signal – Should rather be a fault code signal (AI)?"
    annotation (Placement(transformation(extent={{-300,240},{-260,280}}),
        iconTransformation(extent={{-140,160},{-100,200}})));
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
                                          each final dtVal_nominal=
        dtVal_nominal) "Event sequencing for enabled equipment"
    annotation (Placement(transformation(extent={{140,284},{160,312}})));
  StagingRotation.StageAvailability avaStaCoo(final staEqu=staEqu)
    if have_chiWat
    "Evaluate cooling stage availability"
    annotation (Placement(transformation(extent={{-110,130},{-90,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPri_actual[
    nPumHeaWatPri] if have_pumHeaWatPri "Primary HW pump status" annotation (
      Placement(transformation(extent={{-300,180},{-260,220}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPri_actual[
    nPumChiWatPri] if have_pumChiWatPri "Primary CHW pump status" annotation (
      Placement(transformation(extent={{-300,160},{-260,200}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatSec_actual[
    nPumHeaWatSec] if have_pumHeaWatSec "Secondary HW pump status" annotation (
      Placement(transformation(extent={{-300,120},{-260,160}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatSec_actual[
    nPumChiWatSec] if have_pumChiWatSec "Secondary CHW pump status" annotation (
     Placement(transformation(extent={{-300,100},{-260,140}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatInlIso[nHp]
    if have_heaWat and have_valInlIso
    "Heat pump inlet HW inlet isolation valve command" annotation (Placement(
        transformation(extent={{260,300},{300,340}}), iconTransformation(extent
          ={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatOutIso[nHp]
    if have_heaWat and have_valOutIso
    "Heat pump outlet HW isolation valve command" annotation (Placement(
        transformation(extent={{260,280},{300,320}}), iconTransformation(extent
          ={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatInlIso[nHp]
    if have_chiWat and have_valInlIso
    "Heat pump inlet CHW isolation valve command" annotation (Placement(
        transformation(extent={{260,260},{300,300}}), iconTransformation(extent
          ={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatOutIso[nHp]
    if have_chiWat and have_valOutIso
    "Heat pump outlet CHW isolation valve command" annotation (Placement(
        transformation(extent={{260,240},{300,280}}), iconTransformation(extent
          ={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatPri[
    nPumHeaWatPri] if have_pumHeaWatPri "Primary HW pump start command"
    annotation (Placement(transformation(extent={{260,200},{300,240}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatPri[
    nPumChiWatPri] if have_pumChiWatPri "Primary CHW pump start command"
    annotation (Placement(transformation(extent={{260,180},{300,220}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatSec[
    nPumHeaWatSec] if have_pumHeaWatSec "Secondary HW pump start command"
    annotation (Placement(transformation(extent={{260,140},{300,180}}),
        iconTransformation(extent={{100,-120},{140,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatSec[
    nPumChiWatSec] if have_pumChiWatSec "Secondary CHW pump start command"
    annotation (Placement(transformation(extent={{260,120},{300,160}}),
        iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nHp]
    "Heat pump enable command" annotation (Placement(transformation(extent={{260,360},
            {300,400}}),          iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hea[nHp]
    if have_heaWat and have_chiWat
    "Heating/cooling mode command: true=heating, false=cooling" annotation (
      Placement(transformation(extent={{260,340},{300,380}}),
        iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatRet(final unit="K",
      displayUnit="degC")
    "HW return temperature used to compute required capacity" annotation (
      Placement(transformation(extent={{-300,20},{-260,60}}),
        iconTransformation(extent={{-140,-118},{-100,-78}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHeaWat_flow(final unit="m3/s")
    "HW volume flow rate used to compute required capacity" annotation (
      Placement(transformation(extent={{-300,0},{-260,40}}),   iconTransformation(
          extent={{-140,-140},{-100,-100}})));
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
  StagingRotation.SortRuntime sorRunTimHea(final nin=nEquAlt) if have_heaWat
    "Sort lead/lag alternate equipment by staging runtime – Heating mode"
    annotation (Placement(transformation(extent={{-40,280},{-20,300}})));
  Buildings.Controls.OBC.CDL.Logical.Pre y1Pre[nHp]
    "Left-limit of command signal to break algebraic loop"
    annotation (Placement(transformation(extent={{220,370},{200,390}})));
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
    annotation (Placement(transformation(extent={{-110,170},{-90,190}})));
  StagingRotation.StageChangeCommand chaStaCoo(
    final have_inpPlrSta=false,
    final plrSta=plrSta,
    final staEqu=staEqu,
    final capEqu=capCooHp_nominal,
    final dtRun=dtRunSta,
    final cp_default=cp_default,
    final rho_default=rho_default) if have_chiWat
    "Generate cooling stage transition command"
    annotation (Placement(transformation(extent={{-40,130},{-20,154}})));
  Utilities.StageIndex idxStaCoo(final nSta=nSta, final dtRun=dtRunSta)
    if have_chiWat
    "Compute cooling stage index"
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  StagingRotation.EquipmentEnable enaEquCoo(final staEqu=staEqu) if have_chiWat
    "Compute enable command for equipment in cooling mode"
    annotation (Placement(transformation(extent={{40,170},{60,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(final unit="K",
      displayUnit="degC")
    "CHW return temperature used to compute required capacity" annotation (
      Placement(transformation(extent={{-300,-40},{-260,0}}),
        iconTransformation(extent={{-140,-178},{-100,-138}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(final unit="m3/s")
    "CHW volume flow rate used to compute required capacity" annotation (
      Placement(transformation(extent={{-300,-60},{-260,-20}}),
        iconTransformation(extent={{-140,-198},{-100,-158}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant FIXME_THeaWatSupSet(k=
        THeaWatSup_nominal) "Replace with output of reset block"
    annotation (Placement(transformation(extent={{-320,230},{-300,250}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant FIXME_TChiWatSupSet(k=
        TChiWatSup_nominal) "Replace with output of reset block"
    annotation (Placement(transformation(extent={{-280,230},{-260,250}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1_actual[nHp]
    "Heat pump status" annotation (Placement(transformation(extent={{-300,280},{
            -260,320}}), iconTransformation(extent={{-140,40},{-100,80}})));
  StagingRotation.EquipmentAvailability avaHeaCoo[nHp](each final have_heaWat=
        have_heaWat, each final have_chiWat=have_chiWat)
    "Evaluate equipment availability in heating or cooling mode"
    annotation (Placement(transformation(extent={{-150,250},{-130,270}})));
  Buildings.Controls.OBC.CDL.Logical.Pre y1HeaPre[nHp]
    "Left-limit of command signal to break algebraic loop"
    annotation (Placement(transformation(extent={{160,350},{140,370}})));
  StagingRotation.SortRuntime sorRunTimCoo(final nin=nEquAlt) if have_chiWat
    "Sort lead/lag alternate equipment by staging runtime – Cooling mode"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal y1PreEquAlt(
    final nin=nHp,
    final nout=nEquAlt,
    final extract=idxEquAlt)
    "Extract signal for lead/lag alternate equipment only"
    annotation (Placement(transformation(extent={{190,370},{170,390}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal avaHeaEquAlt(
    final nin=nHp,
    final nout=nEquAlt,
    final extract=idxEquAlt) if have_heaWat
    "Extract signal for lead/lag alternate equipment only"
    annotation (Placement(transformation(extent={{-110,274},{-90,294}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal avaCooEquAlt(
    final nin=nHp,
    final nout=nEquAlt,
    final extract=idxEquAlt) if have_chiWat
    "Extract signal for lead/lag alternate equipment only"
    annotation (Placement(transformation(extent={{-110,84},{-90,104}})));
equation
  connect(u1SchHea, enaHea.u1Sch) annotation (Line(points={{-280,382},{-180,382},
          {-180,364},{-112,364}}, color={255,0,255}));
  connect(nReqHeaWat, enaHea.nReq)
    annotation (Line(points={{-280,342},{-178,342},{-178,360},{-112,360}},
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
  connect(eveSeqEna.y1, y1) annotation (Line(points={{162,310},{236,310},{236,380},
          {280,380}}, color={255,0,255}));
  connect(eveSeqEna.y1Hea, y1Hea) annotation (Line(points={{162,308},{238,308},{
          238,360},{280,360}},color={255,0,255}));
  connect(eveSeqEna.y1ValHeaWatOutIso, y1ValHeaWatOutIso) annotation (Line(
        points={{162,302},{240,302},{240,300},{280,300}},
                                                       color={255,0,255}));
  connect(eveSeqEna.y1ValHeaWatInlIso, y1ValHeaWatInlIso) annotation (Line(
        points={{162,304},{240,304},{240,320},{280,320}},
                                                       color={255,0,255}));
  connect(eveSeqEna.y1ValChiWatInlIso, y1ValChiWatInlIso) annotation (Line(
        points={{162,300},{238,300},{238,280},{280,280}},
                                                       color={255,0,255}));
  connect(eveSeqEna.y1ValChiWatOutIso, y1ValChiWatOutIso) annotation (Line(
        points={{162,298},{236,298},{236,260},{280,260}},
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
  connect(sorRunTimHea.yIdx, enaEquHea.uIdxAltSor) annotation (Line(points={{-18,290},
          {32,290},{32,366},{38,366}},      color={255,127,0}));
  connect(y1, y1Pre.u)
    annotation (Line(points={{280,380},{222,380}}, color={255,0,255}));
  connect(u1PumHeaWatPri_actual, eveSeqEna.u1PumHeaWatPri_actual) annotation (
      Line(points={{-280,200},{-176,200},{-176,226},{84,226},{84,298},{138,298}},
        color={255,0,255}));
  connect(u1PumChiWatPri_actual, eveSeqEna.u1PumChiWatPri_actual) annotation (
      Line(points={{-280,180},{-176,180},{-176,224},{86,224},{86,296},{138,296}},
        color={255,0,255}));
  connect(u1PumHeaWatSec_actual, eveSeqEna.u1PumHeaWatSec_actual) annotation (
      Line(points={{-280,140},{-174,140},{-174,222},{88,222},{88,292},{138,292}},
        color={255,0,255}));
  connect(u1PumChiWatSec_actual, eveSeqEna.u1PumChiWatSec_actual) annotation (
      Line(points={{-280,120},{-172,120},{-172,220},{90,220},{90,290},{138,290}},
        color={255,0,255}));
  connect(nReqChiWat, enaCoo.nReq) annotation (Line(points={{-280,320},{-182,320},
          {-182,180},{-112,180}},      color={255,127,0}));
  connect(TOut, enaCoo.TOut) annotation (Line(points={{-280,80},{-170,80},{-170,
          176},{-112,176}}, color={0,0,127}));
  connect(u1SchCoo, enaCoo.u1Sch) annotation (Line(points={{-280,362},{-180,362},
          {-180,184},{-112,184}}, color={255,0,255}));
  connect(avaStaCoo.y1, chaStaCoo.u1AvaSta) annotation (Line(points={{-88,140},{
          -56,140},{-56,148},{-42,148}},  color={255,0,255}));
  connect(enaCoo.y1, idxStaCoo.u1Lea) annotation (Line(points={{-88,180},{-56,
          180},{-56,186},{-12,186}}, color={255,0,255}));
  connect(chaStaCoo.y1Up, idxStaCoo.u1Up) annotation (Line(points={{-18,146},{
          -16,146},{-16,182},{-12,182}}, color={255,0,255}));
  connect(chaStaCoo.y1Dow, idxStaCoo.u1Dow) annotation (Line(points={{-18,138},
          {-14,138},{-14,178},{-12,178}}, color={255,0,255}));
  connect(idxStaCoo.y, enaEquCoo.uSta)
    annotation (Line(points={{12,180},{38,180}}, color={255,127,0}));
  connect(enaEquHea.y1, eveSeqEna.u1Hea) annotation (Line(points={{62,360},{80,360},
          {80,310},{138,310}},       color={255,0,255}));
  connect(enaEquCoo.y1, eveSeqEna.u1Coo) annotation (Line(points={{62,180},{80,180},
          {80,306},{138,306}}, color={255,0,255}));
  connect(eveSeqEna.y1PumHeaWatPri, y1PumHeaWatPri) annotation (Line(points={{162,294},
          {234,294},{234,220},{280,220}},      color={255,0,255}));
  connect(eveSeqEna.y1PumChiWatPri, y1PumChiWatPri) annotation (Line(points={{162,292},
          {232,292},{232,200},{280,200}},      color={255,0,255}));
  connect(eveSeqEna.y1PumHeaWatSec, y1PumHeaWatSec) annotation (Line(points={{162,288},
          {230,288},{230,160},{280,160}},      color={255,0,255}));
  connect(eveSeqEna.y1PumChiWatSec, y1PumChiWatSec) annotation (Line(points={{162,286},
          {228,286},{228,140},{280,140}},      color={255,0,255}));
  connect(THeaWatRet, chaStaHea.TRet) annotation (Line(points={{-280,40},{-162,40},
          {-162,306},{-50,306},{-50,318},{-42,318}}, color={0,0,127}));
  connect(VHeaWat_flow, chaStaHea.V_flow) annotation (Line(points={{-280,20},{-160,
          20},{-160,304},{-48,304},{-48,314},{-42,314}}, color={0,0,127}));
  connect(TChiWatRet, chaStaCoo.TRet) annotation (Line(points={{-280,-20},{-158,
          -20},{-158,128},{-52,128},{-52,140},{-42,140}}, color={0,0,127}));
  connect(VChiWat_flow, chaStaCoo.V_flow) annotation (Line(points={{-280,-40},{-156,
          -40},{-156,118},{-50,118},{-50,136},{-42,136}}, color={0,0,127}));
  connect(FIXME_TChiWatSupSet.y, chaStaCoo.TSupSet) annotation (Line(points={{-258,
          240},{-52,240},{-52,144},{-42,144}}, color={0,0,127}));
  connect(FIXME_THeaWatSupSet.y, chaStaHea.TSupSet) annotation (Line(points={{-298,
          240},{-52,240},{-52,322},{-42,322}}, color={0,0,127}));
  connect(u1Ava, avaHeaCoo.u1Ava)
    annotation (Line(points={{-280,260},{-152,260}}, color={255,0,255}));
  connect(u1_actual, avaHeaCoo.u1_actual) annotation (Line(points={{-280,300},{-184,
          300},{-184,266},{-152,266}}, color={255,0,255}));
  connect(y1Hea, y1HeaPre.u)
    annotation (Line(points={{280,360},{162,360}}, color={255,0,255}));
  connect(y1HeaPre.y, avaHeaCoo.u1Hea_actual) annotation (Line(points={{138,360},
          {82,360},{82,382},{-156,382},{-156,254},{-152,254}},   color={255,0,255}));
  connect(avaHeaCoo.y1Hea, avaStaHea.u1AvaEqu) annotation (Line(points={{-128,266},
          {-120,266},{-120,320},{-112,320}}, color={255,0,255}));
  connect(avaHeaCoo.y1Coo, avaStaCoo.u1AvaEqu) annotation (Line(points={{-128,254},
          {-120,254},{-120,140},{-112,140}}, color={255,0,255}));
  connect(avaStaCoo.y1, idxStaCoo.u1Ava) annotation (Line(points={{-88,140},{
          -56,140},{-56,174},{-12,174}},
                                     color={255,0,255}));
  connect(avaHeaCoo.y1Hea, enaEquHea.u1AvaEqu) annotation (Line(points={{-128,266},
          {36,266},{36,354},{38,354}}, color={255,0,255}));
  connect(avaHeaCoo.y1Coo, enaEquCoo.u1AvaEqu) annotation (Line(points={{-128,254},
          {36,254},{36,174},{38,174}}, color={255,0,255}));
  connect(sorRunTimCoo.yIdx, enaEquCoo.uIdxAltSor) annotation (Line(
        points={{-18,100},{32,100},{32,186},{38,186}}, color={255,127,0}));
  connect(y1Pre.y, y1PreEquAlt.u)
    annotation (Line(points={{198,380},{192,380}}, color={255,0,255}));
  connect(y1PreEquAlt.y, sorRunTimHea.u1Run) annotation (Line(points={{168,380},
          {-60,380},{-60,290},{-42,290}},      color={255,0,255}));
  connect(y1PreEquAlt.y, sorRunTimCoo.u1Run) annotation (Line(points={{168,380},
          {-60,380},{-60,100},{-42,100}},      color={255,0,255}));
  connect(avaHeaCoo.y1Hea, avaHeaEquAlt.u) annotation (Line(points={{-128,266},{
          -120,266},{-120,284},{-112,284}}, color={255,0,255}));
  connect(avaHeaEquAlt.y, sorRunTimHea.u1Ava)
    annotation (Line(points={{-88,284},{-42,284}}, color={255,0,255}));
  connect(avaCooEquAlt.y, sorRunTimCoo.u1Ava)
    annotation (Line(points={{-88,94},{-42,94}},   color={255,0,255}));
  connect(avaHeaCoo.y1Coo, avaCooEquAlt.u) annotation (Line(points={{-128,254},{
          -120,254},{-120,94},{-112,94}},   color={255,0,255}));
  connect(idxStaCoo.y, chaStaCoo.uSta) annotation (Line(points={{12,180},{24,
          180},{24,160},{-48,160},{-48,152},{-42,152}},
                                                   color={255,127,0}));
  annotation (
    defaultComponentName="ctl",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-200},{100,200}}),
      graphics={
        Line(
          points={{-90,-80.3976},{68,-80.3976}},
          color={192,192,192}),
        Rectangle(
          extent={{-100,200},{100,-200}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,250},{150,210}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(coordinateSystem(extent={{-260,-400},{260,400}})),
    Documentation(info="<html>
<p>
Staging runtime: the HP enable command is used to compute the equipment runtime,
as opposed to the equipment status because the status will come and go if 
the heat pump cycles on low load.
</p>
</html>"));
end AirToWater;
