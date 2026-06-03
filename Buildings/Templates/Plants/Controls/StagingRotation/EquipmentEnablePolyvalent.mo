within Buildings.Templates.Plants.Controls.StagingRotation;
block EquipmentEnablePolyvalent
  "Return array of equipment to be enabled at given stage"
  parameter Integer nHp
    "Number of reversible heat pumps"
    annotation (Evaluate=true);
  parameter Integer nShc
    "Number of polyvalent units"
    annotation (Evaluate=true);
  final parameter Integer nEquAlt = nHp + nShc
    "Number of lead/lag alternate equipment";
  final parameter Integer nSta = nHp + nShc
    "Number of stages";
  final parameter Integer nCol = nHp + 2 * nShc
    "Number of columns in staging matrix";
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdxHpSor[nHp]
    "Indices of heat pumps sorted by increasing runtime" annotation (Placement(
        transformation(extent={{-260,120},{-220,160}}),iconTransformation(
          extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta "Stage index"
    annotation (Placement(transformation(extent={{-260,-20},{-220,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HpAva[nHp]
    "HP available signal" annotation (Placement(transformation(extent={{-260,-140},
            {-220,-100}}),iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput staTra[nCol, nSta]
    "Transpose of staging matrix at current heating or cooling stage"
    annotation (Placement(transformation(extent={{-260,20},{-220,60}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hp[nHp]
    "HP enable command" annotation (Placement(transformation(extent={{220,60},{260,
            100}}), iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor reqEquSta[nCol](
    each final nin=nSta)
    "Extract equipment required at given stage"
    annotation (Placement(transformation(extent={{-130,30},{-110,50}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    final nout=nCol)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isHpReq[nHp](each final t=1E-4)
    "Return true if lead/lag alternate equipment required – HP"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1)
    "Constant"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    "Maximum between stage index and 1"
    annotation (Placement(transformation(extent={{-170,-10},{-150,10}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold greZer(
    final t=0)
    "Check if stage index is greater than zero"
    annotation (Placement(transformation(extent={{-190,-50},{-170,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=1,
    final realFalse=0)
    "Cast to real"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(final nout=
        nCol)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-130,-50},{-110,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply voiStaZer[nCol]
    "Void if stage is equal to zero"
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal reqHpSta(
    nin=nCol,
    nout=nHp,
    extract={i for i in 1:nHp}) "Extract heat pumps required at given stage"
    annotation (Placement(transformation(extent={{-50,90},{-30,110}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal reqShc1Sta(
    nin=nCol,
    nout=nShc,
    extract={nHp + i for i in 1:nShc})
    "Extract SHC units required in single mode at given stage"
    annotation (Placement(transformation(extent={{-48,30},{-28,50}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal reqShc2Sta(
    nin=nCol,
    nout=nShc,
    extract={nHp + nShc + i for i in 1:nShc})
    "Extract SHC units required in SHC mode at given stage"
    annotation (Placement(transformation(extent={{-48,-30},{-28,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdxShcSor[nShc]
    "Indices of SHC units sorted by increasing runtime" annotation (Placement(
        transformation(extent={{-260,140},{-220,180}}), iconTransformation(
          extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Shc1Ava[nShc]
    "Polyvalent HP in single mode available signal" annotation (Placement(
        transformation(extent={{-260,-160},{-220,-120}}), iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Shc2Ava[nShc]
    "Polyvalent HP in SHC mode available signal" annotation (Placement(
        transformation(extent={{-260,-180},{-220,-140}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  SelectSortedAvailable selHpSorAva(final nEqu=nHp, final nEquAlt=nHp)
    "Select units by priority order and availability – HP"
    annotation (Placement(transformation(extent={{90,70},{110,90}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isShc1Req[nShc](each final
            t=1E-4)
    "Return true if lead/lag alternate equipment required – Polyvalent HP in single mode"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isShc2Req[nShc](each final
            t=1E-4)
    "Return true if lead/lag alternate equipment required – Polyvalent HP in SHC mode"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum nHpReqRea(nin=nHp)
    "Number of lead/lag alternate equipment to run to meet stage requirement – HP"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum nShc1ReqRea(nin=nShc)
    "Number of lead/lag alternate equipment to run to meet stage requirement – Polyvalent HP in single mode"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum nShc2ReqRea(nin=nShc)
    "Number of lead/lag alternate equipment to run to meet stage requirement – Polyvalent HP in SHC mode"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  SelectSortedAvailable selShc1SorAva(final nEqu=nShc, final nEquAlt=nShc)
    "Select units by priority order and availability – Polyvalent HP in single mode"
    annotation (Placement(transformation(extent={{92,10},{112,30}})));
  SelectSortedAvailable selShc2SorAva(final nEqu=nShc, final nEquAlt=nShc)
    "Select units by priority order and availability – Polyvalent HP in SHC mode"
    annotation (Placement(transformation(extent={{92,-50},{112,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not notSelShc1[nShc]
    "Return true if equipment not selected in single mode"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And notSelShc1AndAva[nShc]
    "Return true if equipment not selected in single mode AND available"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And isHpReqAltAvaNee[nHp]
    "Return true if equipment required with lead/lag alternate and available and needed to meet stage requirement"
    annotation (Placement(transformation(extent={{130,70},{150,90}})));
  Buildings.Controls.OBC.CDL.Logical.And isShc1ReqAltAvaNee1[nShc]
    "Return true if equipment required with lead/lag alternate and available and needed to meet stage requirement"
    annotation (Placement(transformation(extent={{130,10},{150,30}})));
  Buildings.Controls.OBC.CDL.Logical.And isShc2ReqAltAvaNee[nShc]
    "Return true if equipment required with lead/lag alternate and available and needed to meet stage requirement"
    annotation (Placement(transformation(extent={{128,-50},{148,-30}})));
  UpdateEnableState y1HpUpd(final nEqu=nHp) "Update enable state"
    annotation (Placement(transformation(extent={{190,70},{210,90}})));
  UpdateEnableState y1Shc1Upd(final nEqu=nShc) "Update enable state"
    annotation (Placement(transformation(extent={{190,10},{210,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Shc1[nHp]
    "Polyvalent HP enable command in single mode" annotation (Placement(
        transformation(extent={{220,0},{260,40}}),  iconTransformation(extent={{
            100,-20},{140,20}})));
  UpdateEnableState y1Shc2Upd(final nEqu=nShc) "Update enable state"
    annotation (Placement(transformation(extent={{190,-50},{210,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Shc2[nHp]
    "Polyvalent HP enable command in SHC mode" annotation (Placement(
        transformation(extent={{220,-60},{260,-20}}),iconTransformation(extent={
            {100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger nHpReq
    "Number of lead/lag alternate equipment to run to meet stage requirement – HP"
    annotation (Placement(transformation(extent={{50,90},{70,110}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger nShc1Req
    "Number of lead/lag alternate equipment to run to meet stage requirement – Polyvalent HP in single mode"
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger nShc2Req
    "Number of lead/lag alternate equipment to run to meet stage requirement – Polyvalent HP in SHC mode"
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));
equation
  connect(intScaRep.y, reqEquSta.index)
    annotation (Line(points={{-118,0},{-110,0},{-110,20},{-120,20},{-120,28}},
      color={255,127,0}));
  connect(one.y, maxInt.u1)
    annotation (Line(points={{-178,20},{-174,20},{-174,6},{-172,6}},color={255,127,0}));
  connect(uSta, maxInt.u2)
    annotation (Line(points={{-240,0},{-186,0},{-186,-6},{-172,-6}},color={255,127,0}));
  connect(maxInt.y, intScaRep.u)
    annotation (Line(points={{-148,0},{-142,0}},color={255,127,0}));
  connect(uSta, greZer.u)
    annotation (Line(points={{-240,0},{-200,0},{-200,-40},{-192,-40}},color={255,127,0}));
  connect(greZer.y, booToRea.u)
    annotation (Line(points={{-168,-40},{-162,-40}},color={255,0,255}));
  connect(booToRea.y, reaScaRep.u)
    annotation (Line(points={{-138,-40},{-132,-40}},color={0,0,127}));
  connect(reqEquSta.y, voiStaZer.u1)
    annotation (Line(points={{-108,40},{-100,40},{-100,6},{-90,6}},   color={0,0,127}));
  connect(reaScaRep.y, voiStaZer.u2)
    annotation (Line(points={{-108,-40},{-100,-40},{-100,-6},{-90,-6}},
      color={0,0,127}));
  connect(staTra, reqEquSta.u)
    annotation (Line(points={{-240,40},{-132,40}}, color={0,0,127}));
  connect(voiStaZer.y, reqHpSta.u) annotation (Line(points={{-66,0},{-60,0},{-60,
          100},{-52,100}},   color={0,0,127}));
  connect(voiStaZer.y, reqShc1Sta.u) annotation (Line(points={{-66,0},{-60,0},{-60,
          40},{-50,40}},          color={0,0,127}));
  connect(voiStaZer.y, reqShc2Sta.u) annotation (Line(points={{-66,0},{-60,0},{-60,
          -20},{-50,-20}},      color={0,0,127}));
  connect(reqHpSta.y, isHpReq.u)
    annotation (Line(points={{-28,100},{-20,100},{-20,80},{-12,80}},
                                                 color={0,0,127}));
  connect(reqShc1Sta.y, isShc1Req.u)
    annotation (Line(points={{-26,40},{-20,40},{-20,20},{-12,20}},
                                                 color={0,0,127}));
  connect(reqShc2Sta.y, isShc2Req.u)
    annotation (Line(points={{-26,-20},{-20,-20},{-20,-40},{-12,-40}},
                                               color={0,0,127}));
  connect(uIdxHpSor, selHpSorAva.uIdxSor) annotation (Line(points={{-240,140},{82,
          140},{82,86},{88,86}}, color={255,127,0}));
  connect(u1HpAva, selHpSorAva.u1Ava) annotation (Line(points={{-240,-120},{78,-120},
          {78,74},{88,74}}, color={255,0,255}));
  connect(uIdxShcSor, selShc1SorAva.uIdxSor) annotation (Line(points={{-240,160},
          {80,160},{80,26},{90,26}}, color={255,127,0}));
  connect(u1Shc1Ava, selShc1SorAva.u1Ava) annotation (Line(points={{-240,-140},{
          82,-140},{82,14},{90,14}}, color={255,0,255}));
  connect(selShc1SorAva.y1, notSelShc1.u) annotation (Line(points={{114,20},{120,
          20},{120,-80},{-12,-80}},                     color={255,0,255}));
  connect(notSelShc1.y, notSelShc1AndAva.u1)
    annotation (Line(points={{12,-80},{28,-80}}, color={255,0,255}));
  connect(notSelShc1AndAva.y, selShc2SorAva.u1Ava) annotation (Line(points={{52,-80},
          {84,-80},{84,-46},{90,-46}},    color={255,0,255}));
  connect(u1Shc2Ava, notSelShc1AndAva.u2) annotation (Line(points={{-240,-160},{
          20,-160},{20,-88},{28,-88}}, color={255,0,255}));
  connect(selHpSorAva.y1, isHpReqAltAvaNee.u1)
    annotation (Line(points={{112,80},{128,80}},color={255,0,255}));
  connect(isHpReq.y, isHpReqAltAvaNee.u2) annotation (Line(points={{12,80},{40,80},
          {40,60},{124,60},{124,72},{128,72}}, color={255,0,255}));
  connect(selShc1SorAva.y1, isShc1ReqAltAvaNee1.u1)
    annotation (Line(points={{114,20},{128,20}},color={255,0,255}));
  connect(isShc1Req.y, isShc1ReqAltAvaNee1.u2) annotation (Line(points={{12,20},
          {40,20},{40,0},{124,0},{124,12},{128,12}},   color={255,0,255}));
  connect(selShc2SorAva.y1, isShc2ReqAltAvaNee.u1)
    annotation (Line(points={{114,-40},{126,-40}},
                                              color={255,0,255}));
  connect(isShc2Req.y, isShc2ReqAltAvaNee.u2) annotation (Line(points={{12,-40},
          {20,-40},{20,-56},{104,-56},{104,-48},{126,-48}},
                                                    color={255,0,255}));
  connect(y1HpUpd.y1, y1Hp)
    annotation (Line(points={{212,80},{240,80}}, color={255,0,255}));
  connect(uSta, y1HpUpd.uSta) annotation (Line(points={{-240,0},{-180,0},{-180,-120},
          {176,-120},{176,84},{188,84}},color={255,127,0}));
  connect(isHpReqAltAvaNee.y, y1HpUpd.u1)
    annotation (Line(points={{152,80},{188,80}}, color={255,0,255}));
  connect(u1HpAva, y1HpUpd.u1Ava) annotation (Line(points={{-240,-120},{178,-120},
          {178,76},{188,76}}, color={255,0,255}));
  connect(y1Shc1Upd.y1, y1Shc1)
    annotation (Line(points={{212,20},{240,20}}, color={255,0,255}));
  connect(isShc1ReqAltAvaNee1.y, y1Shc1Upd.u1)
    annotation (Line(points={{152,20},{188,20}}, color={255,0,255}));
  connect(u1Shc1Ava, y1Shc1Upd.u1Ava) annotation (Line(points={{-240,-140},{180,
          -140},{180,16},{188,16}}, color={255,0,255}));
  connect(uSta, y1Shc1Upd.uSta) annotation (Line(points={{-240,0},{-180,0},{-180,
          -120},{176,-120},{176,24},{188,24}},
                                             color={255,127,0}));
  connect(y1Shc2Upd.y1, y1Shc2)
    annotation (Line(points={{212,-40},{240,-40}},
                                               color={255,0,255}));
  connect(notSelShc1AndAva.y, y1Shc2Upd.u1Ava) annotation (Line(points={{52,-80},
          {162,-80},{162,-44},{188,-44}},
                                        color={255,0,255}));
  connect(isShc2ReqAltAvaNee.y, y1Shc2Upd.u1)
    annotation (Line(points={{150,-40},{188,-40}},
                                               color={255,0,255}));
  connect(uSta, y1Shc2Upd.uSta) annotation (Line(points={{-240,0},{-180,0},{-180,
          -100},{176,-100},{176,-36},{188,-36}},
                                           color={255,127,0}));
  connect(uIdxShcSor, selShc2SorAva.uIdxSor) annotation (Line(points={{-240,160},
          {80,160},{80,-34},{90,-34}},
                                   color={255,127,0}));
  connect(reqHpSta.y, nHpReqRea.u)
    annotation (Line(points={{-28,100},{18,100}}, color={0,0,127}));
  connect(reqShc2Sta.y, nShc2ReqRea.u)
    annotation (Line(points={{-26,-20},{18,-20}}, color={0,0,127}));
  connect(reqShc1Sta.y, nShc1ReqRea.u)
    annotation (Line(points={{-26,40},{18,40}}, color={0,0,127}));
  connect(nHpReqRea.y, nHpReq.u)
    annotation (Line(points={{42,100},{48,100}}, color={0,0,127}));
  connect(nHpReq.y, selHpSorAva.n) annotation (Line(points={{72,100},{78,100},{78,
          80},{88,80}}, color={255,127,0}));
  connect(nHpReq.y, y1HpUpd.n) annotation (Line(points={{72,100},{180,100},{180,
          88},{188,88}}, color={255,127,0}));
  connect(nShc1ReqRea.y, nShc1Req.u)
    annotation (Line(points={{42,40},{48,40}}, color={0,0,127}));
  connect(nShc2ReqRea.y, nShc2Req.u)
    annotation (Line(points={{42,-20},{48,-20}}, color={0,0,127}));
  connect(nShc1Req.y, selShc1SorAva.n) annotation (Line(points={{72,40},{76,40},
          {76,20},{90,20}}, color={255,127,0}));
  connect(nShc2Req.y, selShc2SorAva.n) annotation (Line(points={{72,-20},{76,-20},
          {76,-40},{90,-40}}, color={255,127,0}));
  connect(nShc1Req.y, y1Shc1Upd.n) annotation (Line(points={{72,40},{180,40},{180,
          28},{188,28}}, color={255,127,0}));
  connect(nShc2Req.y, y1Shc2Upd.n) annotation (Line(points={{72,-20},{182,-20},{
          182,-32},{188,-32}}, color={255,127,0}));
  annotation (
    defaultComponentName="enaEqu",
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
        extent={{-220,-180},{220,180}})),
    Documentation(
      info="<html>
<p>
This block generates the equipment enable commands based on the
active stage index <code>uSta</code>, the equipment available
signal <code>u1Ava</code> and the indices of lead/lag alternate
equipment, sorted by increasing staging runtime.
</p>
<p>
A staging matrix <code>staEqu</code> is required as a parameter.
</p>
<ul>
<li>Each row of this matrix corresponds to a given stage.</li>
<li>Each column of this matrix corresponds to a given equipment.</li>
<li>A coefficient <code>staEqu[i, j]</code> equal to <i>0</i>
means that equipment <code>j</code> shall not be enabled at
stage <code>i</code>.</li>
<li>A coefficient <code>staEqu[i, j]</code> equal to <i>1</i>
means that equipment <code>j</code> is required at stage <code>i</code>.
If equipment <code>j</code> is unavailable, stage <code>i</code> is
deemed unavailable.
</li>
<li>A coefficient <code>staEqu[i, j]</code> strictly lower than <i>1</i>
and strictly greater than <i>0</i> means that equipment <code>j</code>
may be enabled at stage <code>i</code> as a lead/lag alternate equipment.
If equipment <code>j</code> is unavailable but another lead/lag alternate
equipment is available, then the latter equipment is enabled.
Stage <code>i</code> is only deemed unavailable if all
lead/lag alternate equipment specified for stage <code>i</code>
are unavailable.
</li>
<li>
The sum of the coefficients in a given row <code>∑_j staEqu[i, j]</code>
gives the number of equipment required at stage <code>i</code>.
If this number cannot be achieved with the available equipment,
stage <code>i</code> is deemed unavailable.
</li>
<li>
The condition <code>∑_j staEqu[i+1, j] &ge; ∑_j staEqu[i, j]</code>
is required for all <code>i &lt; size(staEqu, 1)</code>.
</li>
</ul>
<p>
The state of the enable signals is only updated at stage change, or
if the number of previously enabled equipment that is available is
strictly less than the number of equipment required to run.
This avoids hot swapping equipment, e.g., an equipment would not be started
and another stopped during operation just to fulfill the priority order.
However, when a lead/lag alternate equipment becomes unavailable and another
lead/lag alternate equipment can be enabled to meet the number of required
equipment, then the state of the enable signals is updated.
</p>
</html>", revisions="<html>
<ul>
<li>
June 2, 2026, by Antoine Gautier:<br/>
Added logic to remove unavailable equipment from staging order.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4624\">#4624</a>.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end EquipmentEnablePolyvalent;
