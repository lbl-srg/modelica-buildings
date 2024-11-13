within Buildings.Templates.Plants.Controls.Pumps.Generic;
block StagingHeadered "Generic staging logic for headered pumps"
  parameter Boolean is_pri(start=true)
    "Set to true for primary pumps, false for secondary pumps"
    annotation (Evaluate=true,
    Dialog(enable=nPum > 0));
  parameter Boolean is_hdr(start=false)
    "Set to true for headered pumps, false for dedicated pumps"
    annotation (Evaluate=true,
    Dialog(enable=nPum > 0));
  parameter Boolean is_ctlDp(start=false)
    "Set to true for variable speed pumps using ∆p pump speed control"
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
  parameter Integer nSenDp(final min=1, start=1)
    "Number of hardwired ∆p sensors"
    annotation (Evaluate=true,
      Dialog(enable=is_hdr and is_ctlDp));
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
    "Runtime before triggering stage change command based on efficiency condition"
    annotation (Dialog(enable=is_hdr and is_ctlDp));
  parameter Real dtRunFaiSaf(
    final min=0,
    final unit="s",
    start=300)=300
    "Runtime before triggering stage change command based on failsafe condition"
    annotation (Dialog(enable=is_hdr and is_ctlDp));
  parameter Real dtRunFaiSafLowY(
    min=0,
    start=600,
    unit="s")=dtRun
    "Runtime before triggering stage change command based on low pump speed failsafe condition"
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
  parameter Real dpOff(
    final min=0,
    final unit="Pa",
    start=1E4)=1E4
    "Stage change ∆p point offset (>0)"
    annotation (Dialog(enable=is_hdr and is_ctlDp));
  parameter Real yUp(
    final min=0,
    final unit="1",
    start=0.99)=0.99
    "Stage up pump speed point"
    annotation (Dialog(enable=is_hdr and is_ctlDp));
  parameter Real yDow(
    final min=0,
    final unit="1",
    start=0.4)=0.4
    "Stage down pump speed point"
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
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Pum_actual[nPum]
    "Pump status – Hardware point"
    annotation (Placement(transformation(extent={{-200,20},{-160,60}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nPum]
    "Pump command – Hardware point"
    annotation (Placement(transformation(extent={{160,-80},{200,-40}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1_actual[nEqu]
    "Pump status to equipment enable logic"
    annotation (Placement(transformation(extent={{160,60},{200,100}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Utilities.StageIndex nPumHdrDp(
    final have_inpAva=false,
    final nSta=nPum)
    if is_hdr and is_ctlDp
    "Compute number of pumps to be staged on – Headered pumps using ∆p control"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Generic.StagingHeaderedDeltaP staHdrDp(
    final nSenDp=nSenDp,
    final V_flow_nominal=V_flow_nominal,
    final dVOffDow=dVOffDow,
    final dVOffUp=dVOffUp,
    final dpOff=dpOff,
    final dtRun=dtRun,
    final dtRunFaiSaf=dtRunFaiSaf,
    final dtRunFaiSafLowY=dtRunFaiSafLowY,
    final nPum=nPum,
    final yDow=yDow,
    final yUp=yUp)
    if is_hdr and is_ctlDp
    "Stage headered variable speed pumps using ∆p control"
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));
  StagingRotation.SortRuntime sorRunTimHdr(
    nin=nPum)
    if is_hdr
    "Sort by increasing staging runtime"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
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
    "Pump available signal – Block does not handle faulted equipment yet"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput V_flow(
    final unit="m3/s")
    if is_hdr and is_ctlDp
    "Flow rate"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal sigPumPriDed(final nin
      =nEqu, final nout=nPum)
    if is_pri and not is_hdr
    "Extract dedicated primary pump command signal assuming nEqu=nPum"
    annotation (Placement(transformation(extent={{-10,-170},{10,-150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal y1Ded_actual(
    nin=nPum,
    nout=nEqu)
    if not is_hdr
    "Extract dedicated pump status assuming nEqu=nPum"
    annotation (Placement(transformation(extent={{70,90},{90,110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractor y1LeaHdr_actual(
    final nin=nPum)
    if is_hdr
    "Lead headered pump status"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(
    final nout=nEqu)
    if is_hdr
    "Replicate signal"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ValInlIso[nEqu]
    if is_pri and is_hdr and have_valInlIso
    "Equipment inlet isolation valve command"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ValOutIso[nEqu]
    if is_pri and is_hdr and have_valOutIso
    "Equipment outlet isolation valve command"
    annotation (Placement(transformation(extent={{-200,-140},{-160,-100}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Primary.EnableLeadHeadered enaLeaHdrPri(
    final typCon=Buildings.Templates.Plants.Controls.Types.EquipmentConnection.Parallel,
    final typValIso=Buildings.Templates.Plants.Controls.Types.Actuator.TwoPosition,
    final nValIso=2 * nEqu)
    if is_pri and is_hdr
    "Enable/disable lead primary headered pump"
    annotation (Placement(transformation(extent={{-70,-110},{-50,-90}})));
  Utilities.PlaceholderLogical phValInlIso[nEqu](each final have_inp=
        have_valInlIso, each final have_inpPh=true) if is_pri and is_hdr
    "Placeholder value if signal is not available"
    annotation (Placement(transformation(extent={{-130,-90},{-110,-70}})));
  Utilities.PlaceholderLogical phValOutIso[nEqu](each final have_inp=
        have_valOutIso, each final have_inpPh=true) if is_pri and is_hdr
    "Placeholder value if signal is not available"
    annotation (Placement(transformation(extent={{-130,-130},{-110,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Pla
    if not is_pri and is_hdr
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-200,140},{-160,180}}),
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
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  StagingRotation.EquipmentEnable enaHdr(
    final staEqu=staPum)
    if is_hdr
    "Enable headered pumps"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput y(final unit="1")
    if is_hdr and is_ctlDp
    "Pump speed command" annotation (Placement(transformation(extent={{-200,-80},
            {-160,-40}}), iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dp[nSenDp](each final unit=
        "Pa") if is_hdr and is_ctlDp "Loop differential pressure" annotation (
      Placement(transformation(extent={{-200,-60},{-160,-20}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpSet[nSenDp](each final unit
      ="Pa") if is_hdr and is_ctlDp "Loop differential pressure setpoint"
    annotation (Placement(transformation(extent={{-200,-40},{-160,0}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
equation
  connect(u1Pum_actual, staHdrDp.u1_actual)
    annotation (Line(points={{-180,40},{-152,40},{-152,8},{-132,8}},color={255,0,255}));
  connect(staHdrDp.y1Up, nPumHdrDp.u1Up)
    annotation (Line(points={{-108,6},{-100,6},{-100,2},{-12,2}},  color={255,0,255}));
  connect(staHdrDp.y1Dow, nPumHdrDp.u1Dow)
    annotation (Line(points={{-108,-6},{-100,-6},{-100,-2},{-12,-2}},  color={255,0,255}));
  connect(u1Pum, booToInt.u)
    annotation (Line(points={{-180,120},{-142,120}},color={255,0,255}));
  connect(booToInt.y, nPumHdrPriNotDp0.u)
    annotation (Line(points={{-118,120},{-102,120}},color={255,127,0}));
  connect(u1Ava.y, sorRunTimHdr.u1Ava)
    annotation (Line(points={{12,-100},{20,-100},{20,-20},{-18,-20},{-18,34},{-12,
          34}},                                                    color={255,0,255}));
  connect(V_flow, staHdrDp.V_flow)
    annotation (Line(points={{-180,0},{-142,0},{-142,4},{-132,4}},  color={0,0,127}));
  connect(u1Pum, sigPumPriDed.u)
    annotation (Line(points={{-180,120},{-156,120},{-156,-160},{-12,-160}},
      color={255,0,255}));
  connect(u1Pum_actual, y1Ded_actual.u)
    annotation (Line(points={{-180,40},{-152,40},{-152,100},{68,100}},
                                                                    color={255,0,255}));
  connect(y1Ded_actual.y, y1_actual)
    annotation (Line(points={{92,100},{140,100},{140,80},{180,80}},
                                                                 color={255,0,255}));
  connect(u1Pum_actual, y1LeaHdr_actual.u)
    annotation (Line(points={{-180,40},{-152,40},{-152,60},{28,60}},color={255,0,255}));
  connect(y1LeaHdr_actual.y, booScaRep.u)
    annotation (Line(points={{52,60},{68,60}},color={255,0,255}));
  connect(booScaRep.y, y1_actual)
    annotation (Line(points={{92,60},{140,60},{140,80},{180,80}},color={255,0,255}));
  connect(u1ValInlIso, phValInlIso.u)
    annotation (Line(points={{-180,-100},{-152,-100},{-152,-80},{-132,-80}},
                                                     color={255,0,255}));
  connect(enaLeaHdrPri.y1, nPumHdrDp.u1Lea)
    annotation (Line(points={{-48,-100},{-20,-100},{-20,6},{-12,6}},  color={255,0,255}));
  connect(phValInlIso.y, enaLeaHdrPri.u1ValIso[1:nEqu]) annotation (Line(points={{-108,
          -80},{-80,-80},{-80,-100},{-72,-100}},     color={255,0,255}));
  connect(phValOutIso.y, enaLeaHdrPri.u1ValIso[nEqu + 1:2*nEqu])
    annotation (Line(points={{-108,-120},{-80,-120},{-80,-100},{-72,-100}},
                                                   color={255,0,255}));
  connect(u1ValOutIso, phValOutIso.u)
    annotation (Line(points={{-180,-120},{-132,-120}},
                                                     color={255,0,255}));
  connect(u1ValOutIso, phValInlIso.uPh) annotation (Line(points={{-180,-120},{-148,
          -120},{-148,-86},{-132,-86}},color={255,0,255}));
  connect(u1ValInlIso, phValOutIso.uPh) annotation (Line(points={{-180,-100},{-152,
          -100},{-152,-126},{-132,-126}},
                                       color={255,0,255}));
  connect(u1Pla, nPumHdrDp.u1Lea)
    annotation (Line(points={{-180,160},{-20,160},{-20,6},{-12,6}},    color={255,0,255}));
  connect(enaLeaHdrPri.y1, booToInt1.u)
    annotation (Line(points={{-48,-100},{-40,-100},{-40,-62}},
                                                           color={255,0,255}));
  connect(nPumHdrPriNotDp0.y, nPumHdrPriNotDp.u1)
    annotation (Line(points={{-78,120},{-60,120},{-60,126},{-12,126}},color={255,127,0}));
  connect(booToInt1.y, nPumHdrPriNotDp.u2)
    annotation (Line(points={{-40,-38},{-40,114},{-12,114}},color={255,127,0}));
  connect(sorRunTimHdr.yIdx[1], y1LeaHdr_actual.index)
    annotation (Line(points={{12,34},{40,34},{40,48}},color={255,127,0}));
  connect(u1Pum_actual, sorRunTimHdr.u1Run)
    annotation (Line(points={{-180,40},{-16,40},{-16,46},{-12,46}},color={255,0,255}));
  connect(enaHdr.y1, y1)
    annotation (Line(points={{72,0},{140,0},{140,-60},{180,-60}},    color={255,0,255}));
  connect(nPumHdrDp.y, enaHdr.uSta)
    annotation (Line(points={{12,0},{48,0}},    color={255,127,0}));
  connect(nPumHdrPriNotDp.y, enaHdr.uSta)
    annotation (Line(points={{12,120},{20,120},{20,0},{48,0}},    color={255,127,0}));
  connect(u1Ava.y, enaHdr.u1Ava)
    annotation (Line(points={{12,-100},{20,-100},{20,-6},{48,-6}},
      color={255,0,255}));
  connect(sorRunTimHdr.yIdx, enaHdr.uIdxAltSor)
    annotation (Line(points={{12,34},{40,34},{40,6},{48,6}},    color={255,127,0}));
  connect(sigPumPriDed.y, y1) annotation (Line(points={{12,-160},{140,-160},{140,
          -60},{180,-60}},     color={255,0,255}));
  connect(dpSet, staHdrDp.dpSet) annotation (Line(points={{-180,-20},{-140,-20},
          {-140,0},{-132,0}}, color={0,0,127}));
  connect(dp, staHdrDp.dp) annotation (Line(points={{-180,-40},{-138,-40},{-138,
          -4},{-132,-4}}, color={0,0,127}));
  connect(y, staHdrDp.y) annotation (Line(points={{-180,-60},{-136,-60},{-136,-8},
          {-132,-8}}, color={0,0,127}));
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
        extent={{-160,-180},{160,180}})),
    Documentation(
      info="<html>
<h5>Plants with headered primary pumps that are not controlled to maintain differential pressure or flow setpoint</h5>
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
The number of operating primary pumps matches the number of operating
equipment.
</p>
<h5>Plants with headered primary pumps that are controlled to maintain differential pressure or flow setpoint</h5>
<p>
Primary pumps are lead/lag alternated as described in
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.SortRuntime\">
Buildings.Templates.Plants.Controls.StagingRotation.SortRuntime</a>.
</p>
<p>
The lead primary pump is enabled as described in
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Primary.EnableLeadHeadered\">
Buildings.Templates.Plants.Controls.Pumps.Primary.EnableLeadHeadered</a>.
<p>
Primary pumps are staged as described in
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeaderedDeltaP\">
Buildings.Templates.Plants.Controls.Pumps.Generic.StagingHeaderedDeltaP</a>.
</p>
<h5>Plants with headered secondary pumps</h5>
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
To simplify integration into the plant controller this block also
serves as a pass-through for the dedicated primary pump command signal 
that is generated in
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.EventSequencing\">
Buildings.Templates.Plants.Controls.StagingRotation.EventSequencing</a>.
For this purpose, the block includes the parameter <code>is_hdr</code> to
specify whether the pumps are headered or dedicated.
</p>
<p>
At its current stage of development, this block contains no
logic for handling faulted equipment. 
It is therefore assumed that all pumps are available at all times.
</p>
</html>", revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
Added failsafe conditions for headered variable speed pumps using ∆p pump speed control.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end StagingHeadered;
