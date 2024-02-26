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
  parameter Integer nHp(min=1)
    "Number of heat pumps"
    annotation(Evaluate=true,
    Dialog(group="Plant configuration"));
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
  parameter Real TOutLckHea(
    min=100,
    unit="K",
    displayUnit="degC")=291.15
    "Heating mode outdoor air lockout temperature"
    annotation (Dialog(group="Plant enable"));
  parameter Real TOutLckCoo(
    min=100,
    unit="K",
    displayUnit="degC")=288.15
    "Cooling mode outdoor air lockout temperature"
    annotation (Dialog(group="Plant enable"));
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
  parameter Real dtRun(
    min=0,
    unit="s")=15*60
    "Minimum runtime of enable and disable states"
    annotation (Dialog(tab="Advanced", group="Plant enable"));
  parameter Real dtReq(
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
      for j in 1:nEqu}) for i in 1:nSta})
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

  Enabling.Enable enaHea(
    final typ=Buildings.Templates.Plants.Controls.Types.Application.Heating,
    final TOutLck=TOutLckHea,
    final dTOutLck=dTOutLck,
    final dtReq=dtReq,
    final dtRun=dtRun,
    final have_inpSch=have_inpSch,
    final nReqIgn=nReqIgnHeaWat,
    final sch=schHea) "Heating mode enable"
    annotation (Placement(transformation(extent={{-130,350},{-110,370}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReqHeaWat
    "Number of HW plant requests" annotation (Placement(transformation(extent={{
            -240,320},{-200,360}}), iconTransformation(extent={{-140,120},{-100,
            160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SchHea if have_inpSch
    "Heating mode enable via schedule" annotation (Placement(transformation(
          extent={{-240,360},{-200,400}}), iconTransformation(extent={{-140,160},
            {-100,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReqChiWat
    "Number of CHW plant requests" annotation (Placement(transformation(extent={
            {-240,300},{-200,340}}), iconTransformation(extent={{-140,100},{-100,
            140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SchCoo if have_inpSch
    "Cooling mode enable via schedule" annotation (Placement(transformation(
          extent={{-240,340},{-200,380}}), iconTransformation(extent={{-140,140},
            {-100,180}})));
  Utilities.StageIndex idxStaHea(final nSta=nSta, final dtRun=dtRunSta)
    "Compute heating stage index"
    annotation (Placement(transformation(extent={{-10,350},{10,370}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava[nHp]
    "FIXME(AntoineGautier): Heat pump available signal – Should rather be a fault code signal (AI)?"
    annotation (Placement(transformation(extent={{-240,280},{-200,320}}),
        iconTransformation(extent={{-140,160},{-100,200}})));
  StagingRotation.StageAvailability avaStaHea(final staEqu=staEquHea)
    "Evaluate heating stage availability"
    annotation (Placement(transformation(extent={{-130,310},{-110,330}})));
  StagingRotation.EquipmentEnable enaEquHea(final staEqu=staEqu)
    "Compute enable command for equipment in heating mode"
    annotation (Placement(transformation(extent={{40,350},{60,370}})));
  Enabling.EventSequencing eveSeqEna[nHp](each final dtVal_nominal=
        dtVal_nominal) "Event sequencing for enabled equipment"
    annotation (Placement(transformation(extent={{100,284},{120,312}})));
  StagingRotation.StageAvailability avaStaCoo(final staEqu=staEquCoo)
    "Evaluate cooling stage availability"
    annotation (Placement(transformation(extent={{-130,190},{-110,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPri_actual[
    nPumHeaWatPri] if have_pumHeaWatPri "Primary HW pump status" annotation (
      Placement(transformation(extent={{-240,180},{-200,220}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPri_actual[
    nPumChiWatPri] if have_pumChiWatPri "Primary CHW pump status" annotation (
      Placement(transformation(extent={{-240,160},{-200,200}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatSec_actual[
    nPumHeaWatSec] if have_pumHeaWatSec "Secondary HW pump status" annotation (
      Placement(transformation(extent={{-240,120},{-200,160}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatSec_actual[
    nPumChiWatSec] if have_pumChiWatSec "Secondary CHW pump status" annotation (
     Placement(transformation(extent={{-240,100},{-200,140}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatInlIso[nHp]
    if have_heaWat and have_valInlIso
    "Heat pump inlet HW inlet isolation valve command" annotation (Placement(
        transformation(extent={{200,300},{240,340}}), iconTransformation(extent
          ={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValHeaWatOutIso[nHp]
    if have_heaWat and have_valOutIso
    "Heat pump outlet HW isolation valve command" annotation (Placement(
        transformation(extent={{200,280},{240,320}}), iconTransformation(extent
          ={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatInlIso[nHp]
    if have_chiWat and have_valInlIso
    "Heat pump inlet CHW isolation valve command" annotation (Placement(
        transformation(extent={{200,260},{240,300}}), iconTransformation(extent
          ={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ValChiWatOutIso[nHp]
    if have_chiWat and have_valOutIso
    "Heat pump outlet CHW isolation valve command" annotation (Placement(
        transformation(extent={{200,240},{240,280}}), iconTransformation(extent
          ={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatPri[
    nPumHeaWatPri] if have_pumHeaWatPri "Primary HW pump start command"
    annotation (Placement(transformation(extent={{200,200},{240,240}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatPri[
    nPumChiWatPri] if have_pumChiWatPri "Primary CHW pump start command"
    annotation (Placement(transformation(extent={{200,180},{240,220}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumHeaWatSec[
    nPumHeaWatSec] if have_pumHeaWatSec "Secondary HW pump start command"
    annotation (Placement(transformation(extent={{200,140},{240,180}}),
        iconTransformation(extent={{100,-120},{140,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumChiWatSec[
    nPumChiWatSec] if have_pumChiWatSec "Secondary CHW pump start command"
    annotation (Placement(transformation(extent={{200,120},{240,160}}),
        iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nHp]
    "Heat pump enable command" annotation (Placement(transformation(extent={{
            200,360},{240,400}}), iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hea[nHp]
    if have_heaWat and have_chiWat
    "Heating/cooling mode command: true=heating, false=cooling" annotation (
      Placement(transformation(extent={{200,340},{240,380}}),
        iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatRet(final unit="K",
      displayUnit="degC")
    "HW return temperature used to compute required capacity" annotation (
      Placement(transformation(extent={{-240,20},{-200,60}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHeaWat_flow(final unit="m3/s")
    "HW volume flow rate used to compute required capacity" annotation (
      Placement(transformation(extent={{-240,-20},{-200,20}}),
                                                             iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  StagingRotation.StageChangeCommand chaStaHea(final staEqu=staEqu)
    "Generate heating stage transition command"
    annotation (Placement(transformation(extent={{-50,308},{-30,332}})));
  StagingRotation.SortRuntime sorRunTim(final nin=nHp)
    "Sort equipment by staging runtime"
    annotation (Placement(transformation(extent={{-50,270},{-30,290}})));
  Buildings.Controls.OBC.CDL.Logical.Pre y1Pre[nHp]
    "Left-limit of command signal to break algebraic loop"
    annotation (Placement(transformation(extent={{160,370},{140,390}})));
  Enabling.Enable enaCoo(
    final typ=Buildings.Templates.Plants.Controls.Types.Application.Cooling,
    final TOutLck=TOutLckCoo,
    final dTOutLck=dTOutLck,
    final dtReq=dtReq,
    final dtRun=dtRun,
    final have_inpSch=have_inpSch,
    final nReqIgn=nReqIgnChiWat,
    final sch=schCoo) "Cooling mode enable"
    annotation (Placement(transformation(extent={{-130,230},{-110,250}})));
  StagingRotation.StageChangeCommand chaStaCoo(final staEqu=staEqu)
    "Generate cooling stage transition command"
    annotation (Placement(transformation(extent={{-50,190},{-30,214}})));
  Utilities.StageIndex idxStaCoo(final nSta=nSta, final dtRun=dtRunSta)
    "Compute cooling stage index"
    annotation (Placement(transformation(extent={{-10,230},{10,250}})));
  StagingRotation.EquipmentEnable enaEquCoo(final staEqu=staEqu)
    "Compute enable command for equipment in cooling mode"
    annotation (Placement(transformation(extent={{40,230},{60,250}})));
equation
  connect(u1SchHea, enaHea.u1Sch) annotation (Line(points={{-220,380},{-180,380},
          {-180,364},{-132,364}}, color={255,0,255}));
  connect(nReqHeaWat, enaHea.nReq)
    annotation (Line(points={{-220,340},{-178,340},{-178,360},{-132,360}},
                                                     color={255,127,0}));
  connect(TOut, enaHea.TOut) annotation (Line(points={{-220,80},{-170,80},{-170,
          356},{-132,356}}, color={0,0,127}));
  connect(enaHea.y1, idxStaHea.u1Lea) annotation (Line(points={{-108,360},{-60,360},
          {-60,366},{-12,366}},       color={255,0,255}));
  connect(u1Ava, avaStaHea.u1AvaEqu)
    annotation (Line(points={{-220,300},{-174,300},{-174,320},{-132,320}},
                                                     color={255,0,255}));
  connect(avaStaHea.y1, idxStaHea.u1Ava) annotation (Line(points={{-108,320},{-60,
          320},{-60,354},{-12,354}}, color={255,0,255}));
  connect(idxStaHea.y,enaEquHea. uSta)
    annotation (Line(points={{12,360},{38,360}},   color={255,127,0}));
  connect(enaEquHea.y1, eveSeqEna.u1)
    annotation (Line(points={{62,360},{70,360},{70,310},{98,310}},
                                                  color={255,0,255}));
  connect(u1Ava, avaStaCoo.u1AvaEqu) annotation (Line(points={{-220,300},{-174,
          300},{-174,200},{-132,200}},
                                  color={255,0,255}));
  connect(eveSeqEna.y1, y1) annotation (Line(points={{122,310},{176,310},{176,380},
          {220,380}}, color={255,0,255}));
  connect(eveSeqEna.y1Hea, y1Hea) annotation (Line(points={{122,308},{178,308},{
          178,360},{220,360}},color={255,0,255}));
  connect(eveSeqEna.y1ValHeaWatOutIso, y1ValHeaWatOutIso) annotation (Line(
        points={{122,302},{180,302},{180,300},{220,300}},
                                                       color={255,0,255}));
  connect(eveSeqEna.y1ValHeaWatInlIso, y1ValHeaWatInlIso) annotation (Line(
        points={{122,304},{180,304},{180,320},{220,320}},
                                                       color={255,0,255}));
  connect(eveSeqEna.y1ValChiWatInlIso, y1ValChiWatInlIso) annotation (Line(
        points={{122,300},{178,300},{178,280},{220,280}},
                                                       color={255,0,255}));
  connect(eveSeqEna.y1ValChiWatOutIso, y1ValChiWatOutIso) annotation (Line(
        points={{122,298},{176,298},{176,260},{220,260}},
                                                       color={255,0,255}));
  connect(u1Ava,enaEquHea. u1AvaEqu) annotation (Line(points={{-220,300},{30,
          300},{30,354},{38,354}},   color={255,0,255}));
  connect(idxStaHea.y, chaStaHea.uSta) annotation (Line(points={{12,360},{20,360},
          {20,340},{-54,340},{-54,330},{-52,330}}, color={255,127,0}));
  connect(chaStaHea.y1Dow, idxStaHea.u1Dow) annotation (Line(points={{-28,316},{
          -16,316},{-16,358},{-12,358}}, color={255,0,255}));
  connect(chaStaHea.y1Up, idxStaHea.u1Up) annotation (Line(points={{-28,324},{-20,
          324},{-20,362},{-12,362}}, color={255,0,255}));
  connect(avaStaHea.y1, chaStaHea.u1AvaSta) annotation (Line(points={{-108,320},
          {-60,320},{-60,326},{-52,326}}, color={255,0,255}));
  connect(sorRunTim.yIdx, enaEquHea.uIdxAltSor) annotation (Line(points={{
          -28,280},{26,280},{26,366},{38,366}}, color={255,127,0}));
  connect(u1Ava, sorRunTim.u1Ava) annotation (Line(points={{-220,300},{-174,300},
          {-174,274},{-52,274}},      color={255,0,255}));
  connect(y1, y1Pre.u)
    annotation (Line(points={{220,380},{162,380}}, color={255,0,255}));
  connect(y1Pre.y, sorRunTim.u1Run) annotation (Line(points={{138,380},{-80,380},
          {-80,280},{-52,280}},                         color={255,0,255}));
  connect(enaEquHea.y1, eveSeqEna.u1Hea) annotation (Line(points={{62,360},{70,
          360},{70,307.8},{98,307.8}}, color={255,0,255}));
  connect(u1PumHeaWatPri_actual, eveSeqEna.u1PumHeaWatPri_actual) annotation (
      Line(points={{-220,200},{-180,200},{-180,186},{80,186},{80,294},{98,294}},
        color={255,0,255}));
  connect(u1PumChiWatPri_actual, eveSeqEna.u1PumChiWatPri_actual) annotation (
      Line(points={{-220,180},{-180,180},{-180,184},{82,184},{82,292},{98,292}},
        color={255,0,255}));
  connect(u1PumHeaWatSec_actual, eveSeqEna.u1PumHeaWatSec_actual) annotation (
      Line(points={{-220,140},{-178,140},{-178,182},{84,182},{84,288},{98,288}},
        color={255,0,255}));
  connect(u1PumChiWatSec_actual, eveSeqEna.u1PumChiWatSec_actual) annotation (
      Line(points={{-220,120},{-176,120},{-176,180},{86,180},{86,286},{98,286}},
        color={255,0,255}));
  connect(nReqChiWat, enaCoo.nReq) annotation (Line(points={{-220,320},{-182,
          320},{-182,240},{-132,240}}, color={255,127,0}));
  connect(TOut, enaCoo.TOut) annotation (Line(points={{-220,80},{-170,80},{-170,
          236},{-132,236}}, color={0,0,127}));
  connect(u1SchCoo, enaCoo.u1Sch) annotation (Line(points={{-220,360},{-180,360},
          {-180,244},{-132,244}}, color={255,0,255}));
  connect(avaStaCoo.y1, chaStaCoo.u1AvaSta) annotation (Line(points={{-108,200},
          {-60,200},{-60,208},{-52,208}}, color={255,0,255}));
  connect(enaCoo.y1, idxStaCoo.u1Lea) annotation (Line(points={{-108,240},{-60,
          240},{-60,246},{-12,246}}, color={255,0,255}));
  connect(chaStaCoo.y1Up, idxStaCoo.u1Up) annotation (Line(points={{-28,206},{
          -20,206},{-20,242},{-12,242}}, color={255,0,255}));
  connect(chaStaCoo.y1Dow, idxStaCoo.u1Dow) annotation (Line(points={{-28,198},
          {-16,198},{-16,238},{-12,238}}, color={255,0,255}));
  connect(u1Ava, idxStaCoo.u1Ava) annotation (Line(points={{-220,300},{-174,300},
          {-174,260},{-24,260},{-24,234},{-12,234}}, color={255,0,255}));
  connect(idxStaCoo.y, enaEquCoo.uSta)
    annotation (Line(points={{12,240},{38,240}}, color={255,127,0}));
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
    Diagram(coordinateSystem(extent={{-200,-400},{200,400}})),
    Documentation(info="<html>
<p>
Staging runtime: the HP enable command is used to compute the equipment runtime,
as opposed to the equipment status because the status will come and go if 
the heat pump cycles on low load.
</p>
</html>"));
end AirToWater;
