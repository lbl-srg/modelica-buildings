within Buildings.Templates.Plants.Controls.Pumps.Generic;
block Staging
  "Generic staging logic for all pump arrangements and routing of pump status"
  parameter Boolean is_pri(
    start=true)
    "Set to true for primary pumps, false for secondary pumps"
    annotation (Evaluate=true,
    Dialog(enable=nPum > 0));
  parameter Boolean is_hdr(
    start=false)
    "Set to true for headered pumps, false for dedicated pumps"
    annotation (Evaluate=true,
    Dialog(enable=nPum > 0));
  parameter Boolean is_ctlDp(
    start=false)
    "Set to true for headered variable speed pumps using ∆p pump speed control"
    annotation (Evaluate=true,
    Dialog(enable=is_hdr));
  parameter Boolean have_valInlIso(
    start=false)
    "Set to true if the system as inlet isolation valves"
    annotation (Evaluate=true,
    Dialog(enable=is_pri));
  parameter Boolean have_valOutIso(
    start=false)
    "Set to true if the system as outlet isolation valves"
    annotation (Evaluate=true,
    Dialog(enable=is_pri));
  parameter Integer nEqu
    "Number of equipment"
    annotation (Evaluate=true);
  parameter Integer nPum
    "Number of pumps"
    annotation (Evaluate=true);
  parameter Real V_flow_nominal(
    final min=1E-6,
    start=1E-6,
    final unit="m3/s")
    "Design flow rate"
    annotation (Dialog(enable=is_hdr and is_ctlDp));
  parameter Real dtRun(
    final min=0,
    start=600,
    final unit="s")=600
    "Runtime before triggering stage command"
    annotation (Dialog(enable=is_hdr and is_ctlDp));
  parameter Real dVOffUp(
    final max=1,
    final min=0,
    start=0.03,
    final unit="1")=0.03
    "Stage up flow point offset"
    annotation (Dialog(enable=is_hdr and is_ctlDp));
  parameter Real dVOffDow(
    final max=1,
    final min=0,
    start=0.03,
    final unit="1")=dVOffUp
    "Stage down flow point offset"
    annotation (Dialog(enable=is_hdr and is_ctlDp));
  final parameter Real staPum[nPum, nPum](
    each unit="1",
    each min=0,
    each max=1)={fill(i / nPum, nPum) for i in 1:nPum}
    "Pump staging matrix";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Pum[nEqu]
    if is_pri and (not is_hdr or is_hdr and not is_ctlDp)
    "Pump command from equipment enable logic"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Pum_actual[nPum]
    "Pump status – Hardware point"
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nPum]
    "Pump command – Hardware point"
    annotation (Placement(transformation(extent={{160,-80},{200,-40}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1_actual[nEqu]
    "Pump status to equipment enable logic"
    annotation (Placement(transformation(extent={{160,40},{200,80}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Utilities.StageIndex nPumHdrDp(
    final have_inpAva=false,
    final nSta=nPum,
    final dtRun=dtRun)
    if is_hdr and is_ctlDp
    "Compute number of pumps to be staged on – Headered pumps using ∆p control"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Generic.StagingHeaderedDeltaP staHdrDp(
    final nPum=nPum,
    final V_flow_nominal=V_flow_nominal,
    final dtRun=dtRun,
    final dVOffUp=dVOffUp,
    final dVOffDow=dVOffDow)
    if is_hdr and is_ctlDp
    "Stage headered variable speed pumps using ∆p control"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  StagingRotation.SortRuntime sorRunTimHdr(
    nin=nPum)
    if is_hdr
    "Sort by increasing staging runtime"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nEqu](
    each final integerTrue=1,
    each final integerFalse=0)
    if is_pri and is_hdr and not is_ctlDp
    "Convert to integer"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum nPumHdrPriNotDp0(
    nin=nEqu)
    if is_pri and is_hdr and not is_ctlDp
    "Compute number of pumps to be staged on – Headered primary pumps not using ∆p control"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1Ava[nPum](
    each final k=true)
    if is_hdr
    "FIXME: Pump available signal – Check how to handle pump availability"
    annotation (Placement(transformation(extent={{-200,50},{-180,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput V_flow(
    final unit="m3/s")
    if is_hdr and is_ctlDp
    "Flow rate"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal sigPumPriDed(
    nin=nEqu,
    nout=nPum)
    if is_pri and not is_hdr
    "Extract dedicated primary pump command signal assuming nEqu=nPum"
    annotation (Placement(transformation(extent={{-152,-110},{-132,-90}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal y1Ded_actual(
    nin=nPum,
    nout=nEqu)
    if not is_hdr
    "Extract dedicated pump status assuming nEqu=nPum"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractor y1LeaHdr_actual(
    final nin=nPum)
    if is_hdr
    "Lead headered pump status"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(
    final nout=nEqu)
    if is_hdr
    "Replicate signal"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ValInlIso[nEqu]
    if is_pri and is_hdr and have_valInlIso
    "Equipment inlet isolation valve command"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Equ[nEqu]
    if not is_hdr and is_pri
    "Equipment enable signal"
    annotation (Placement(transformation(extent={{-200,-140},{-160,-100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Equ_actual[nEqu]
    if not is_hdr and is_pri
    "Equipment status"
    annotation (Placement(transformation(extent={{-200,-160},{-160,-120}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ValOutIso[nEqu]
    if is_pri and is_hdr and have_valOutIso
    "Equipment outlet isolation valve command"
    annotation (Placement(transformation(extent={{-200,-80},{-160,-40}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Primary.Dedicated enaDed[nPum](each have_req=false) if is_pri and not is_hdr
    "Command dedicated primary pumps"
    annotation (Placement(transformation(extent={{-10,-150},{10,-130}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal sigEqu(
    nin=nEqu,
    nout=nPum)
    if is_pri and not is_hdr
    "Extract equipment command signal assuming nEqu=nPum"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal sigEqu_actual(
    nin=nEqu,
    nout=nPum)
    if is_pri and not is_hdr
    "Extract equipment status signal assuming nEqu=nPum"
    annotation (Placement(transformation(extent={{-152,-150},{-132,-130}})));
  Primary.EnableLeadHeadered enaLeaHdrPri(
    final typCon=Buildings.Templates.Plants.Controls.Types.EquipmentConnection.Parallel,
    final typValIso=Buildings.Templates.Plants.Controls.Types.Actuator.TwoPosition,
    final nValIso=2 * nEqu)
    if is_pri and is_hdr
    "Enable/disable lead primary headered pump"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  Utilities.PlaceHolder phValInlIso[nEqu](each final have_inp=have_valInlIso,
      each final have_inpPla=true) if is_pri and is_hdr
    "Placeholder value if signal is not available"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Utilities.PlaceHolder phValOutIso[nEqu](each final have_inp=have_valOutIso,
      each final have_inpPla=true) if is_pri and is_hdr
    "Placeholder value if signal is not available"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Pla
    if not is_pri and is_hdr
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1(
    final integerTrue=1,
    final integerFalse=0)
    if is_pri and is_hdr and not is_ctlDp
    "Convert lead pump enable signal to integer"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,
      origin={-40,100})));
  Buildings.Controls.OBC.CDL.Integers.Multiply nPumHdrPriNotDp
    if is_pri and is_hdr and not is_ctlDp
    "Reset number of enabled pumps to zero if lead pump disabled"
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  StagingRotation.EquipmentEnable enaHdr(
    final staEqu=staPum)
    if is_hdr
    "Enable headered pumps"
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));
equation
  connect(u1Pum_actual, staHdrDp.u1_actual)
    annotation (Line(points={{-180,20},{-152,20},{-152,6},{-142,6}},color={255,0,255}));
  connect(staHdrDp.y1Up, nPumHdrDp.u1Up)
    annotation (Line(points={{-118,6},{-96,6},{-96,-18},{-12,-18}},color={255,0,255}));
  connect(staHdrDp.y1Dow, nPumHdrDp.u1Dow)
    annotation (Line(points={{-118,-6},{-100,-6},{-100,-22},{-12,-22}},color={255,0,255}));
  connect(u1Pum, booToInt.u)
    annotation (Line(points={{-180,120},{-142,120}},color={255,0,255}));
  connect(booToInt.y, nPumHdrPriNotDp0.u)
    annotation (Line(points={{-118,120},{-102,120}},color={255,127,0}));
  connect(u1Ava.y, sorRunTimHdr.u1Ava)
    annotation (Line(points={{-178,60},{-20,60},{-20,14},{-12,14}},color={255,0,255}));
  connect(V_flow, staHdrDp.V_flow)
    annotation (Line(points={{-180,0},{-146,0},{-146,-6},{-142,-6}},color={0,0,127}));
  connect(u1Pum, sigPumPriDed.u)
    annotation (Line(points={{-180,120},{-156,120},{-156,-100},{-154,-100}},
      color={255,0,255}));
  connect(u1Pum_actual, y1Ded_actual.u)
    annotation (Line(points={{-180,20},{-152,20},{-152,80},{68,80}},color={255,0,255}));
  connect(y1Ded_actual.y, y1_actual)
    annotation (Line(points={{92,80},{140,80},{140,60},{180,60}},color={255,0,255}));
  connect(u1Pum_actual, y1LeaHdr_actual.u)
    annotation (Line(points={{-180,20},{-152,20},{-152,40},{28,40}},color={255,0,255}));
  connect(y1LeaHdr_actual.y, booScaRep.u)
    annotation (Line(points={{52,40},{68,40}},color={255,0,255}));
  connect(booScaRep.y, y1_actual)
    annotation (Line(points={{92,40},{140,40},{140,60},{180,60}},color={255,0,255}));
  connect(u1Equ_actual, sigEqu_actual.u)
    annotation (Line(points={{-180,-140},{-154,-140}},color={255,0,255}));
  connect(u1Equ, sigEqu.u)
    annotation (Line(points={{-180,-120},{-122,-120}},color={255,0,255}));
  connect(u1ValInlIso, phValInlIso.u)
    annotation (Line(points={{-180,-40},{-142,-40}}, color={255,0,255}));
  connect(enaLeaHdrPri.y1, nPumHdrDp.u1Lea)
    annotation (Line(points={{-48,-60},{-20,-60},{-20,-14},{-12,-14}},color={255,0,255}));
  connect(phValInlIso.y, enaLeaHdrPri.u1ValIso[1:nEqu]) annotation (Line(points
        ={{-118,-40},{-80,-40},{-80,-60},{-72,-60}}, color={255,0,255}));
  connect(phValOutIso.y, enaLeaHdrPri.u1ValIso[nEqu + 1:2*nEqu])
    annotation (Line(points={{-88,-60},{-72,-60}}, color={255,0,255}));
  connect(u1ValOutIso, phValOutIso.u)
    annotation (Line(points={{-180,-60},{-112,-60}}, color={255,0,255}));
  connect(u1ValOutIso, phValInlIso.uPla) annotation (Line(points={{-180,-60},{-146,
          -60},{-146,-44},{-142,-44}}, color={255,0,255}));
  connect(u1ValInlIso, phValOutIso.uPla) annotation (Line(points={{-180,-40},{-152,
          -40},{-152,-64},{-112,-64}}, color={255,0,255}));
  connect(u1Pla, nPumHdrDp.u1Lea)
    annotation (Line(points={{-180,-80},{-20,-80},{-20,-14},{-12,-14}},color={255,0,255}));
  connect(enaLeaHdrPri.y1, booToInt1.u)
    annotation (Line(points={{-48,-60},{-40,-60},{-40,88}},color={255,0,255}));
  connect(nPumHdrPriNotDp0.y, nPumHdrPriNotDp.u1)
    annotation (Line(points={{-78,120},{-20,120},{-20,126},{-12,126}},color={255,127,0}));
  connect(booToInt1.y, nPumHdrPriNotDp.u2)
    annotation (Line(points={{-40,112},{-40,114},{-12,114}},color={255,127,0}));
  connect(sorRunTimHdr.yIdx[1], y1LeaHdr_actual.index)
    annotation (Line(points={{12,14},{40,14},{40,28}},color={255,127,0}));
  connect(u1Pum_actual, sorRunTimHdr.u1Run)
    annotation (Line(points={{-180,20},{-16,20},{-16,26},{-12,26}},color={255,0,255}));
  connect(enaHdr.y1, y1)
    annotation (Line(points={{72,-20},{140,-20},{140,-60},{180,-60}},color={255,0,255}));
  connect(nPumHdrDp.y, enaHdr.uSta)
    annotation (Line(points={{12,-20},{48,-20}},color={255,127,0}));
  connect(nPumHdrPriNotDp.y, enaHdr.uSta)
    annotation (Line(points={{12,120},{20,120},{20,-20},{48,-20}},color={255,127,0}));
  connect(u1Ava.y, enaHdr.u1Ava)
    annotation (Line(points={{-178,60},{-20,60},{-20,0},{28,0},{28,-26},{48,-26}},
      color={255,0,255}));
  connect(sorRunTimHdr.yIdx, enaHdr.uIdxAltSor)
    annotation (Line(points={{12,14},{40,14},{40,-14},{48,-14}},color={255,127,0}));
  connect(enaDed.y1, y1) annotation (Line(points={{12,-140},{140,-140},{140,-60},
          {180,-60}}, color={255,0,255}));
  connect(sigEqu.y, enaDed.u1Equ) annotation (Line(points={{-98,-120},{-80,-120},
          {-80,-136},{-12,-136}}, color={255,0,255}));
  connect(sigEqu_actual.y, enaDed.u1Equ_actual)
    annotation (Line(points={{-130,-140},{-12,-140}}, color={255,0,255}));
  connect(sigPumPriDed.y, enaDed.u1) annotation (Line(points={{-130,-100},{-60,
          -100},{-60,-132},{-12,-132}}, color={255,0,255}));
  annotation (
    defaultComponentName="staPum",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(
      coordinateSystem(
        extent={{-160,-160},{160,160}})),
    Documentation(
      info="<html>
<p>
For secondary headered pumps: the lead pump is enabled when the plant
is enabled. Otherwise, the lead pump is disabled.
<p>
</html>"));
end Staging;
