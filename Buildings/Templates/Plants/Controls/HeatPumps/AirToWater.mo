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
    final sch=schHea)
    "Heating mode enable"
    annotation (Placement(transformation(extent={{-162,350},{-142,370}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nReqHeaWat
    "Number of HW plant requests" annotation (Placement(transformation(extent={{
            -240,320},{-200,360}}), iconTransformation(extent={{-140,120},{-100,
            160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-240,280},{-200,320}}),
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
  Utilities.StageIndex idxStaHea(final nSta=nStaHea,
                                                  final dtRun=dtRunSta)
    "Compute heating stage index"
    annotation (Placement(transformation(extent={{-110,350},{-90,370}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava[nHp]
    "FIXME(AntoineGautier): Heat pump available signal – Should rather be a fault code signal (AI)?"
    annotation (Placement(transformation(extent={{-240,240},{-200,280}}),
        iconTransformation(extent={{-140,160},{-100,200}})));
  StagingRotation.StageAvailability avaStaHea(final staEqu=staEquHea)
    "Evaluate heating stage availability"
    annotation (Placement(transformation(extent={{-160,270},{-140,290}})));
  StagingRotation.EquipmentEnable equEnaHea(final staEqu=staEquHea)
    "Compute enable command for equipment in heating mode"
    annotation (Placement(transformation(extent={{-70,350},{-50,370}})));
  Enabling.EventSequencing eveSeqEna[nHp](each final dtVal_nominal=
        dtVal_nominal) "Event sequencing for enabled equipment"
    annotation (Placement(transformation(extent={{-30,344},{-10,372}})));
  StagingRotation.StageAvailability avaStaCoo(final staEqu=staEquCoo)
    "Evaluate cooling stage availability"
    annotation (Placement(transformation(extent={{-160,230},{-140,250}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatPri_actual[
    nPumHeaWatPri] if have_pumHeaWatPri "Primary HW pump status" annotation (
      Placement(transformation(extent={{-240,200},{-200,240}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatPri_actual[
    nPumChiWatPri] if have_pumChiWatPri "Primary CHW pump status" annotation (
      Placement(transformation(extent={{-240,180},{-200,220}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumHeaWatSec_actual[
    nPumHeaWatSec] if have_pumHeaWatSec "Secondary HW pump status" annotation (
      Placement(transformation(extent={{-240,140},{-200,180}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumChiWatSec_actual[
    nPumChiWatSec] if have_pumChiWatSec "Secondary CHW pump status" annotation (
     Placement(transformation(extent={{-240,120},{-200,160}}),
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
equation
  connect(u1SchHea, enaHea.u1Sch) annotation (Line(points={{-220,380},{-180,380},
          {-180,364},{-164,364}}, color={255,0,255}));
  connect(nReqHeaWat, enaHea.nReq)
    annotation (Line(points={{-220,340},{-186,340},{-186,360},{-164,360}},
                                                     color={255,127,0}));
  connect(TOut, enaHea.TOut) annotation (Line(points={{-220,300},{-180,300},{-180,
          356},{-164,356}}, color={0,0,127}));
  connect(enaHea.y1, idxStaHea.u1Lea) annotation (Line(points={{-140,360},{-130,
          360},{-130,366},{-112,366}},color={255,0,255}));
  connect(u1Ava, avaStaHea.u1AvaEqu)
    annotation (Line(points={{-220,260},{-180,260},{-180,280},{-162,280}},
                                                     color={255,0,255}));
  connect(avaStaHea.y1, idxStaHea.u1Ava) annotation (Line(points={{-138,280},{
          -130,280},{-130,354},{-112,354}},
                                     color={255,0,255}));
  connect(idxStaHea.y, equEnaHea.uSta)
    annotation (Line(points={{-88,360},{-72,360}}, color={255,127,0}));
  connect(equEnaHea.y1, eveSeqEna.u1)
    annotation (Line(points={{-48,360},{-40,360},{-40,370},{-32,370}},
                                                  color={255,0,255}));
  connect(u1Ava, avaStaCoo.u1AvaEqu) annotation (Line(points={{-220,260},{-180,
          260},{-180,240},{-162,240}},
                                  color={255,0,255}));
  connect(eveSeqEna.y1, y1) annotation (Line(points={{-8,370},{40,370},{40,380},
          {220,380}}, color={255,0,255}));
  connect(eveSeqEna.y1Hea, y1Hea) annotation (Line(points={{-8,368},{40,368},{
          40,360},{220,360}}, color={255,0,255}));
  connect(eveSeqEna.y1ValHeaWatOutIso, y1ValHeaWatOutIso) annotation (Line(
        points={{-8,362},{36,362},{36,300},{220,300}}, color={255,0,255}));
  connect(eveSeqEna.y1ValHeaWatInlIso, y1ValHeaWatInlIso) annotation (Line(
        points={{-8,364},{38,364},{38,320},{220,320}}, color={255,0,255}));
  connect(eveSeqEna.y1ValChiWatInlIso, y1ValChiWatInlIso) annotation (Line(
        points={{-8,360},{34,360},{34,280},{220,280}}, color={255,0,255}));
  connect(eveSeqEna.y1ValChiWatOutIso, y1ValChiWatOutIso) annotation (Line(
        points={{-8,358},{32,358},{32,260},{220,260}}, color={255,0,255}));
  connect(u1Ava, equEnaHea.u1AvaEqu) annotation (Line(points={{-220,260},{-80,
          260},{-80,354},{-72,354}}, color={255,0,255}));
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
    Diagram(coordinateSystem(extent={{-200,-400},{200,400}})));
end AirToWater;
