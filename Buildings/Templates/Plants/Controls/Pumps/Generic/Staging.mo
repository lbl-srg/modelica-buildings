within Buildings.Templates.Plants.Controls.Pumps.Generic;
block Staging
  "Generic staging logic for all pump arrangements"
  parameter Boolean is_pri(start=true)
    "Set to true for primary pumps, false for secondary pumps"
    annotation (Evaluate=true,
    Dialog(enable=nPum > 0));
  parameter Boolean is_hdr(start=false)
    "Set to true for headered pumps, false for dedicated pumps"
    annotation (Evaluate=true,
    Dialog(enable=nPum > 0));
  parameter Boolean is_ctlDp(start=false)
    "Set to true for headered variable speed pumps using ∆p pump speed control"
    annotation (Evaluate=true,
    Dialog(enable=is_hdr));
  parameter Boolean have_valInlIso(start=false)
    "Set to true if the system as inlet isolation valves"
    annotation (Evaluate=true,
    Dialog(enable=is_pri));
  parameter Boolean have_valOutIso(start=false)
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
    min=1E-6,
    start=1E-6,
    unit="m3/s")
    "Design flow rate"
    annotation (Dialog(enable=is_hdr and is_ctlDp));
  parameter Real dtRun(
    min=0,
    start=600,
    unit="s")=600
    "Runtime before triggering stage command"
    annotation (Dialog(enable=is_hdr and is_ctlDp));
  parameter Real dVOffUp(
    max=1,
    min=0,
    start=0.03,
    unit="1")=0.03
    "Stage up flow point offset"
    annotation (Dialog(enable=is_hdr and is_ctlDp));
  parameter Real dVOffDow(
    max=1,
    min=0,
    start=0.03,
    unit="1")=dVOffUp
    "Stage down flow point offset"
    annotation (Dialog(enable=is_hdr and is_ctlDp));
  final parameter Real staPum[nPum, nPum](
    each unit="1",
    each min=0,
    each max=1)={fill(i / nPum, nPum) for i in 1:nPum}
    "Pump staging matrix"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Pum[nEqu]
    if is_pri and (not is_hdr or is_hdr and not is_ctlDp)
    "Pump command from equipment enable logic"
    annotation (Placement(transformation(extent={{-200,80},{-160,120}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
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
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
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
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum nPumHdrPriNotDp0(
    nin=nEqu)
    if is_pri and is_hdr and not is_ctlDp
    "Compute number of pumps to be staged on – Headered primary pumps not using ∆p control"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1Ava[nPum](
    each final k=true)
    if is_hdr
    "Pump available signal – Block does not handle faulted equipment yet"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput V_flow(
    final unit="m3/s")
    if is_hdr and is_ctlDp
    "Flow rate"
    annotation (Placement(transformation(extent={{-200,-40},{-160,0}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal sigPumPriDed(final nin
      =nEqu, final nout=nPum)
    if is_pri and not is_hdr
    "Extract dedicated primary pump command signal assuming nEqu=nPum"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));
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
    annotation (Placement(transformation(extent={{-200,-80},{-160,-40}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ValOutIso[nEqu]
    if is_pri and is_hdr and have_valOutIso
    "Equipment outlet isolation valve command"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Primary.EnableLeadHeadered enaLeaHdrPri(
    final typCon=Buildings.Templates.Plants.Controls.Types.EquipmentConnection.Parallel,
    final typValIso=Buildings.Templates.Plants.Controls.Types.Actuator.TwoPosition,
    final nValIso=2 * nEqu)
    if is_pri and is_hdr
    "Enable/disable lead primary headered pump"
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));
  Utilities.PlaceholderLogical phValInlIso[nEqu](each final have_inp=
        have_valInlIso, each final have_inpPh=true) if is_pri and is_hdr
    "Placeholder value if signal is not available"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Utilities.PlaceholderLogical phValOutIso[nEqu](each final have_inp=
        have_valOutIso, each final have_inpPh=true) if is_pri and is_hdr
    "Placeholder value if signal is not available"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Pla
    if not is_pri and is_hdr
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-200,120},{-160,160}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1(
    final integerTrue=1,
    final integerFalse=0)
    if is_pri and is_hdr and not is_ctlDp
    "Convert lead pump enable signal to integer"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,
      origin={-40,-50})));
  Buildings.Controls.OBC.CDL.Integers.Multiply nPumHdrPriNotDp
    if is_pri and is_hdr and not is_ctlDp
    "Reset number of enabled pumps to zero if lead pump disabled"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  StagingRotation.EquipmentEnable enaHdr(
    final staEqu=staPum)
    if is_hdr
    "Enable headered pumps"
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));
equation
  connect(u1Pum_actual, staHdrDp.u1_actual)
    annotation (Line(points={{-180,20},{-152,20},{-152,-14},{-142,-14}},
                                                                    color={255,0,255}));
  connect(staHdrDp.y1Up, nPumHdrDp.u1Up)
    annotation (Line(points={{-118,-14},{-100,-14},{-100,-18},{-12,-18}},
                                                                   color={255,0,255}));
  connect(staHdrDp.y1Dow, nPumHdrDp.u1Dow)
    annotation (Line(points={{-118,-26},{-100,-26},{-100,-22},{-12,-22}},
                                                                       color={255,0,255}));
  connect(u1Pum, booToInt.u)
    annotation (Line(points={{-180,100},{-142,100}},color={255,0,255}));
  connect(booToInt.y, nPumHdrPriNotDp0.u)
    annotation (Line(points={{-118,100},{-102,100}},color={255,127,0}));
  connect(u1Ava.y, sorRunTimHdr.u1Ava)
    annotation (Line(points={{12,-80},{20,-80},{20,-40},{-18,-40},{-18,14},{-12,
          14}},                                                    color={255,0,255}));
  connect(V_flow, staHdrDp.V_flow)
    annotation (Line(points={{-180,-20},{-146,-20},{-146,-26},{-142,-26}},
                                                                    color={0,0,127}));
  connect(u1Pum, sigPumPriDed.u)
    annotation (Line(points={{-180,100},{-156,100},{-156,-120},{-12,-120}},
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
  connect(u1ValInlIso, phValInlIso.u)
    annotation (Line(points={{-180,-60},{-142,-60}}, color={255,0,255}));
  connect(enaLeaHdrPri.y1, nPumHdrDp.u1Lea)
    annotation (Line(points={{-48,-80},{-20,-80},{-20,-14},{-12,-14}},color={255,0,255}));
  connect(phValInlIso.y, enaLeaHdrPri.u1ValIso[1:nEqu]) annotation (Line(points={{-118,
          -60},{-80,-60},{-80,-80},{-72,-80}},       color={255,0,255}));
  connect(phValOutIso.y, enaLeaHdrPri.u1ValIso[nEqu + 1:2*nEqu])
    annotation (Line(points={{-88,-100},{-80,-100},{-80,-80},{-72,-80}},
                                                   color={255,0,255}));
  connect(u1ValOutIso, phValOutIso.u)
    annotation (Line(points={{-180,-100},{-112,-100}},
                                                     color={255,0,255}));
  connect(u1ValOutIso, phValInlIso.uPh) annotation (Line(points={{-180,-100},{
          -146,-100},{-146,-66},{-142,-66}},
                                       color={255,0,255}));
  connect(u1ValInlIso, phValOutIso.uPh) annotation (Line(points={{-180,-60},{
          -152,-60},{-152,-106},{-112,-106}},
                                       color={255,0,255}));
  connect(u1Pla, nPumHdrDp.u1Lea)
    annotation (Line(points={{-180,140},{-20,140},{-20,-14},{-12,-14}},color={255,0,255}));
  connect(enaLeaHdrPri.y1, booToInt1.u)
    annotation (Line(points={{-48,-80},{-40,-80},{-40,-62}},
                                                           color={255,0,255}));
  connect(nPumHdrPriNotDp0.y, nPumHdrPriNotDp.u1)
    annotation (Line(points={{-78,100},{-60,100},{-60,106},{-12,106}},color={255,127,0}));
  connect(booToInt1.y, nPumHdrPriNotDp.u2)
    annotation (Line(points={{-40,-38},{-40,94},{-12,94}},  color={255,127,0}));
  connect(sorRunTimHdr.yIdx[1], y1LeaHdr_actual.index)
    annotation (Line(points={{12,14},{40,14},{40,28}},color={255,127,0}));
  connect(u1Pum_actual, sorRunTimHdr.u1Run)
    annotation (Line(points={{-180,20},{-16,20},{-16,26},{-12,26}},color={255,0,255}));
  connect(enaHdr.y1, y1)
    annotation (Line(points={{72,-20},{140,-20},{140,-60},{180,-60}},color={255,0,255}));
  connect(nPumHdrDp.y, enaHdr.uSta)
    annotation (Line(points={{12,-20},{48,-20}},color={255,127,0}));
  connect(nPumHdrPriNotDp.y, enaHdr.uSta)
    annotation (Line(points={{12,100},{20,100},{20,-20},{48,-20}},color={255,127,0}));
  connect(u1Ava.y, enaHdr.u1Ava)
    annotation (Line(points={{12,-80},{20,-80},{20,-26},{48,-26}},
      color={255,0,255}));
  connect(sorRunTimHdr.yIdx, enaHdr.uIdxAltSor)
    annotation (Line(points={{12,14},{40,14},{40,-14},{48,-14}},color={255,127,0}));
  connect(sigPumPriDed.y, y1) annotation (Line(points={{12,-120},{140,-120},{
          140,-60},{180,-60}}, color={255,0,255}));
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
<h5>Plants with dedicated primary pumps</h5>
<p> 
Primary pumps 
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Primary.EnableDedicated\">
Buildings.Templates.Plants.Controls.Pumps.Primary.Dedicated</a>.
</p>
<h5>Plants with headered primary pumps</h5>
<p>
Primary pumps are lead/lag alternated as described in
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.SortRuntime\">
Buildings.Templates.Plants.Controls.StagingRotation.SortRuntime</a>.
</p>
<p>
The lead primary pump is enabled as described in
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Primary.EnableLeadHeadered\">
Buildings.Templates.Plants.Controls.Pumps.Primary.EnableLeadHeadered</a>.
</p>
<p>
The number of operating primary pumps shall match the number of operating
equipment.
</p>
<h5>Plants with headered secondary pump</h5>
<p>
Secondary pumps are lead/lag alternated as described in
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.SortRuntime\">
Buildings.Templates.Plants.Controls.StagingRotation.SortRuntime</a>.
</p>
<p>
The lead secondary pump is enabled when the plant is enabled. 
Otherwise, the lead secondary pump is disabled.
<p>
Secondary pumps are staged as described in
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeaderedDeltaP\">
Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeaderedDeltaP</a>.
</p>
<h4>Details</h4>
<p>
At its current stage of development, this block contains no
logic for handling faulted equipment. 
It is therefore assumed that all pumps are available at all times.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Staging;
