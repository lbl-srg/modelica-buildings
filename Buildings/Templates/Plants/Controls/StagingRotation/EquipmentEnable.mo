within Buildings.Templates.Plants.Controls.StagingRotation;
block EquipmentEnable
  "Return array of equipment to enable at given stage"
  parameter Real staEqu[:,:](
    each unit="1",
    each min=0,
    each max=1)
    "Staging matrix – Equipment required for each stage";
  final parameter Integer nEquAlt=
    max({sum({(if staEqu[i, j] > 0 and staEqu[i, j] < 1 then 1 else 0)
      for j in 1:nEqu}) for i in 1:nSta})
    "Number of lead/lag alternate equipment"
    annotation(Evaluate=true);
  final parameter Integer nSta = size(staEqu, 1)
    "Number of stages"
    annotation(Evaluate=true);
  final parameter Integer nEqu = size(staEqu, 2)
    "Number of equipment"
    annotation(Evaluate=true);
  final parameter Real traStaEqu[nEqu, nSta]=
    {{staEqu[i, j] for i in 1:nSta} for j in 1:nEqu}
    "Tranpose of staging matrix";
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta "Stage index"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaEqu[nEqu]
    "Equipment available signal" annotation (Placement(transformation(extent={{-220,
            -100},{-180,-60}}),
                              iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant traMatStaEqu[nEqu, nSta](
    final k=traStaEqu)     "Transpose of staging matrix"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nEqu]
    "Equipment enable command"
    annotation (Placement(transformation(extent={{180,-20},{220,20}}),
                        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor reqEquSta[nEqu](each final
      nin=nSta) "Extract equipment required at given stage"
    annotation (Placement(transformation(extent={{-130,70},{-110,90}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(final nout=nEqu)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum nEquStaRea(final nin=nEqu)
    "Return the number of equipment required"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isReq[nEqu](each final t=0.99)
    "Return true if equipment required without lead/lag alternate"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And isReqAva[nEqu]
    "Return true if equipment required without lead/lag alternate and available"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isReqPosAlt[nEqu](each final
            t=0)
    "Return true if equipment required (with or without lead/lag alternate)"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold isNotReqNoAlt[nEqu](each final
            t=1)
    "Return true if equipment not required or required with lead/lag alternate"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd isReqAltAva[nEqu](
    each final nin=3)
    "Return true if equipment required with lead/lag alternate and available"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or ena[nEqu]
    "Enable equipment required without lead/lag alternate and available or lead/lag alternate equipment to meet stage requirement"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger nEquSta
    "Number of equipment required"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Integers.Subtract nAltReq
    "Number of lead/lag alternate equipment to run to meet stage requirement"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Buildings.Controls.OBC.CDL.Logical.And isReqAltAvaNee[nEqu]
    "Return true if equipment required with lead/lag alternate and available and needed to meet stage requirement"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Controls.OBC.CDL.Integers.Change cha "Detect stage index change"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Pre y1Pre[nEqu]
    "Left limit of y1 in discrete time"
    annotation (Placement(transformation(extent={{150,-70},{130,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nEqu]
    "Switch to newly computed value at stage change"
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(final
      nout=nEqu)
    "Replicate signal"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Utilities.CountTrue nReq(nin=nEqu)
    "Count the number of required equipment without lead/lag alternate, not necessarily available"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Utilities.CountTrue nEnaAvaPre(nin=nEqu)
    "Count the number of previously enabled equipment that are available"
    annotation (Placement(transformation(extent={{70,-110},{50,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Less intLes
    "Compare to required number of equipment"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Or swiEna
    "Evaluate condition to switch to newly computed enable signal"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And isEnaPreAva[nEqu]
    "Return true if equipment previously enabled and available"
    annotation (Placement(transformation(extent={{100,-110},{80,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdxAltSor[nEquAlt]
    "Indices of lead/lag alternate equipment sorted by increasing runtime"
    annotation (Placement(transformation(extent={{-220,80},{-180,120}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Utilities.TrueArrayConditional truArrCon(final nout=nEqu, nin=nEquAlt)
    "Generate nEqu-array of nAltReq true elements at uIdxAltSor indices "
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
equation
  // HACK(AntoineGautier): Explicit `for` loops needed for OCT that cannot flatten the model otherwise.
  for i in 1:nEqu loop
    for j in 1:i loop
    end for;
  end for;
   connect(uSta, intScaRep.u)
    annotation (Line(points={{-200,0},{-162,0}},color={255,127,0}));
  connect(intScaRep.y, reqEquSta.index)
    annotation (Line(points={{-138,0},{-120,0},{-120,68}},
                                                        color={255,127,0}));
  connect(traMatStaEqu.y, reqEquSta.u)
    annotation (Line(points={{-138,80},{-132,80}},
                                                 color={0,0,127}));
  connect(reqEquSta.y, nEquStaRea.u)
    annotation (Line(points={{-108,80},{-92,80}}, color={0,0,127}));
  connect(reqEquSta.y, isReq.u) annotation (Line(points={{-108,80},{-100,80},{-100,
          -40},{-92,-40}}, color={0,0,127}));
  connect(isReq.y, isReqAva.u1)
    annotation (Line(points={{-68,-40},{-42,-40}},
                                                 color={255,0,255}));
  connect(u1AvaEqu, isReqAva.u2) annotation (Line(points={{-200,-80},{-60,-80},{
          -60,-48},{-42,-48}},
                          color={255,0,255}));
  connect(reqEquSta.y, isReqPosAlt.u) annotation (Line(points={{-108,80},{-100,80},
          {-100,40},{-92,40}},color={0,0,127}));
  connect(reqEquSta.y, isNotReqNoAlt.u) annotation (Line(points={{-108,80},{-100,
          80},{-100,0},{-92,0}},
                            color={0,0,127}));
  connect(isReqPosAlt.y, isReqAltAva.u[1]) annotation (Line(points={{-68,40},{
          -60,40},{-60,37.6667},{-42,37.6667}},
                            color={255,0,255}));
  connect(isNotReqNoAlt.y, isReqAltAva.u[2]) annotation (Line(points={{-68,0},{-60,
          0},{-60,40},{-42,40}},            color={255,0,255}));
  connect(u1AvaEqu, isReqAltAva.u[3]) annotation (Line(points={{-200,-80},{-60,
          -80},{-60,42.3333},{-42,42.3333}},
                                 color={255,0,255}));
  connect(isReqAva.y, ena.u2) annotation (Line(points={{-18,-40},{74,-40},{74,-8},
          {78,-8}},      color={255,0,255}));
  connect(nEquStaRea.y, nEquSta.u)
    annotation (Line(points={{-68,80},{-42,80}}, color={0,0,127}));
  connect(nEquSta.y, nAltReq.u1) annotation (Line(points={{-18,80},{20,80},{20,
          46},{28,46}}, color={255,127,0}));
  connect(isReqAltAva.y, isReqAltAvaNee.u2) annotation (Line(points={{-18,40},{
          0,40},{0,-8},{48,-8}},               color={255,0,255}));
  connect(isReqAltAvaNee.y, ena.u1)
    annotation (Line(points={{72,0},{78,0}},   color={255,0,255}));
  connect(uSta, cha.u) annotation (Line(points={{-200,0},{-170,0},{-170,-60},{
          -2,-60}}, color={255,127,0}));
  connect(logSwi.y, y1)
    annotation (Line(points={{152,0},{200,0}}, color={255,0,255}));
  connect(y1, y1Pre.u) annotation (Line(points={{200,0},{160,0},{160,-60},{152,-60}},
        color={255,0,255}));
  connect(y1Pre.y, logSwi.u3) annotation (Line(points={{128,-60},{120,-60},{120,
          -8},{128,-8}}, color={255,0,255}));
  connect(ena.y, logSwi.u1) annotation (Line(points={{102,0},{108,0},{108,8},{128,
          8}}, color={255,0,255}));
  connect(booScaRep.y, logSwi.u2) annotation (Line(points={{102,-60},{114,-60},{
          114,0},{128,0}}, color={255,0,255}));
  connect(nReq.y, nAltReq.u2) annotation (Line(points={{-18,0},{20,0},{20,34},{
          28,34}}, color={255,127,0}));
  connect(isReq.y, nReq.u1) annotation (Line(points={{-68,-40},{-50,-40},{-50,0},
          {-42,0}}, color={255,0,255}));
  connect(nEnaAvaPre.y, intLes.u1) annotation (Line(points={{48,-100},{40,-100},
          {40,-84},{-8,-84},{-8,-100},{-2,-100}}, color={255,127,0}));
  connect(nEquSta.y, intLes.u2) annotation (Line(points={{-18,80},{-14,80},{-14,
          -108},{-2,-108}}, color={255,127,0}));
  connect(swiEna.y, booScaRep.u)
    annotation (Line(points={{72,-60},{78,-60}}, color={255,0,255}));
  connect(cha.y, swiEna.u1)
    annotation (Line(points={{22,-60},{48,-60}}, color={255,0,255}));
  connect(intLes.y, swiEna.u2) annotation (Line(points={{22,-100},{30,-100},{30,
          -68},{48,-68}}, color={255,0,255}));
  connect(isEnaPreAva.y, nEnaAvaPre.u1)
    annotation (Line(points={{78,-100},{72,-100}}, color={255,0,255}));
  connect(y1Pre.y, isEnaPreAva.u2) annotation (Line(points={{128,-60},{120,-60},
          {120,-108},{102,-108}}, color={255,0,255}));
  connect(u1AvaEqu, isEnaPreAva.u1) annotation (Line(points={{-200,-80},{110,-80},
          {110,-100},{102,-100}}, color={255,0,255}));
  connect(nAltReq.y, truArrCon.u)
    annotation (Line(points={{52,40},{68,40}}, color={255,127,0}));
  connect(uIdxAltSor, truArrCon.uIdx) annotation (Line(points={{-200,100},{60,
          100},{60,34},{68,34}},
                            color={255,127,0}));
  connect(truArrCon.y1, isReqAltAvaNee.u1) annotation (Line(points={{92,40},{
          100,40},{100,20},{40,20},{40,0},{48,0}},
                                               color={255,0,255}));
          annotation (
 defaultComponentName="enaEqu",
 Icon(
  coordinateSystem(
    preserveAspectRatio=true,
    extent={{-100,-100},{100,100}}),
  graphics={
    Line(
      points={{-90,-80.3976},{68,-80.3976}},
      color={192,192,192}),
    Rectangle(
      extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(
      extent={{-150,150},{150,110}},
      textString="%name",
      textColor={0,0,255})}),
    Diagram(coordinateSystem(extent={{-180,-120},{180,120}})),
    Documentation(info="<html>
<p>
\"Count the number of required equipment without lead/lag alternate not necessarily available\":
because we don't want to replace an unavailable required equipment by a lead/lag alternate equipment.
</p>
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
</html>"));
end EquipmentEnable;
