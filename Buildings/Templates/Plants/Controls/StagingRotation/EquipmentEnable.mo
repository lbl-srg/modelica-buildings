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
    annotation (Placement(transformation(extent={{-240,-20},{-200,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaEqu[nEqu]
    "Equipment available signal" annotation (Placement(transformation(extent={{-240,
            -100},{-200,-60}}),
                              iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant traMatStaEqu[nEqu, nSta](
    final k=traStaEqu)     "Transpose of staging matrix"
    annotation (Placement(transformation(extent={{-190,70},{-170,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nEqu]
    "Equipment enable command"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
                        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor reqEquSta[nEqu](each final
      nin=nSta) "Extract equipment required at given stage"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(final nout=nEqu)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum nEquStaRea(nin=nEqu)
    "Return the number of equipment required"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isReq[nEqu](each final t=0.99)
    "Return true if equipment required without lead/lag alternate"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And isReqAva[nEqu]
    "Return true if equipment required without lead/lag alternate and available"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isReqPosAlt[nEqu](each final
            t=0)
    "Return true if equipment required (with or without lead/lag alternate)"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold isNotReqNoAlt[nEqu](each final
            t=1)
    "Return true if equipment not required or required with lead/lag alternate"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd isReqAltAva[nEqu](
    each final nin=3)
    "Return true if equipment required with lead/lag alternate and available"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or ena[nEqu]
    "Enable equipment required without lead/lag alternate and available or lead/lag alternate equipment to meet stage requirement"
    annotation (Placement(transformation(extent={{110,-10},{130,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger nEquSta
    "Number of equipment required"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Controls.OBC.CDL.Integers.Subtract nAltReq
    "Number of lead/lag alternate equipment to run to meet stage requirement"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.CDL.Logical.And isReqAltAvaNee[nEqu]
    "Return true if equipment required with lead/lag alternate and available and needed to meet stage requirement"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Integers.Change cha "Detect stage index change"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Pre y1Pre[nEqu]
    "Left limit of y1 in discrete time"
    annotation (Placement(transformation(extent={{180,-70},{160,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nEqu]
    "Switch to newly computed value at stage change"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(final
      nout=nEqu)
    "Replicate signal"
    annotation (Placement(transformation(extent={{110,-70},{130,-50}})));
  Utilities.CountTrue nReq(nin=nEqu)
    "Count the number of required equipment without lead/lag alternate, not necessarily available"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Utilities.CountTrue nEnaAvaPre(nin=nEqu)
    "Count the number of previously enabled equipment that are available"
    annotation (Placement(transformation(extent={{100,-110},{80,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Less intLes
    "Compare to required number of equipment"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Or swiEna
    "Evaluate condition to switch to newly computed enable signal"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And isEnaPreAva[nEqu]
    "Return true if equipment previously enabled and available"
    annotation (Placement(transformation(extent={{130,-110},{110,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdxAltSor[nEquAlt]
    "Indices of lead/lag alternate equipment sorted by increasing runtime"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Utilities.TrueArrayConditional truArrCon(
    final is_fix=true,                     final nout=nEqu, nin=nEquAlt)
    "Generate array of size nEqu with nAltReq true elements at uIdxAltSor indices "
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(final k=1)
    "Constant"
    annotation (Placement(transformation(extent={{-190,10},{-170,30}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    "Maximum between stage index and 1"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold greZer(final t=0)
    "Check if stage index is greater than zero"
    annotation (Placement(transformation(extent={{-170,-50},{-150,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(final realTrue=
        1, final realFalse=0) "Cast to real"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator    reaScaRep(final
      nout=nEqu)
    "Replicate signal"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply voiStaZer[nEqu]
    "Void if stage is equal to zero"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
equation
  // HACK(AntoineGautier): Explicit `for` loops needed for OCT that cannot flatten the model otherwise.
  for i in 1:nEqu loop
    for j in 1:i loop
    end for;
  end for;
  connect(intScaRep.y, reqEquSta.index)
    annotation (Line(points={{-108,0},{-100,0},{-100,60},{-150,60},{-150,68}},
                                                        color={255,127,0}));
  connect(traMatStaEqu.y, reqEquSta.u)
    annotation (Line(points={{-168,80},{-162,80}},
                                                 color={0,0,127}));
  connect(isReq.y, isReqAva.u1)
    annotation (Line(points={{-38,-40},{-12,-40}},
                                                 color={255,0,255}));
  connect(u1AvaEqu, isReqAva.u2) annotation (Line(points={{-220,-80},{-30,-80},
          {-30,-48},{-12,-48}},
                          color={255,0,255}));
  connect(isReqPosAlt.y, isReqAltAva.u[1]) annotation (Line(points={{-38,40},{
          -30,40},{-30,37.6667},{-12,37.6667}},
                            color={255,0,255}));
  connect(isNotReqNoAlt.y, isReqAltAva.u[2]) annotation (Line(points={{-38,0},{
          -30,0},{-30,40},{-12,40}},        color={255,0,255}));
  connect(u1AvaEqu, isReqAltAva.u[3]) annotation (Line(points={{-220,-80},{-30,
          -80},{-30,42.3333},{-12,42.3333}},
                                 color={255,0,255}));
  connect(isReqAva.y, ena.u2) annotation (Line(points={{12,-40},{104,-40},{104,
          -8},{108,-8}}, color={255,0,255}));
  connect(nEquStaRea.y, nEquSta.u)
    annotation (Line(points={{-38,80},{-12,80}}, color={0,0,127}));
  connect(nEquSta.y, nAltReq.u1) annotation (Line(points={{12,80},{50,80},{50,
          46},{58,46}}, color={255,127,0}));
  connect(isReqAltAva.y, isReqAltAvaNee.u2) annotation (Line(points={{12,40},{
          30,40},{30,-8},{78,-8}},             color={255,0,255}));
  connect(isReqAltAvaNee.y, ena.u1)
    annotation (Line(points={{102,0},{108,0}}, color={255,0,255}));
  connect(uSta, cha.u) annotation (Line(points={{-220,0},{-190,0},{-190,-60},{
          28,-60}}, color={255,127,0}));
  connect(logSwi.y, y1)
    annotation (Line(points={{182,0},{220,0}}, color={255,0,255}));
  connect(y1, y1Pre.u) annotation (Line(points={{220,0},{190,0},{190,-60},{182,
          -60}},
        color={255,0,255}));
  connect(y1Pre.y, logSwi.u3) annotation (Line(points={{158,-60},{150,-60},{150,
          -8},{158,-8}}, color={255,0,255}));
  connect(ena.y, logSwi.u1) annotation (Line(points={{132,0},{138,0},{138,8},{
          158,8}},
               color={255,0,255}));
  connect(booScaRep.y, logSwi.u2) annotation (Line(points={{132,-60},{144,-60},
          {144,0},{158,0}},color={255,0,255}));
  connect(nReq.y, nAltReq.u2) annotation (Line(points={{12,0},{50,0},{50,34},{
          58,34}}, color={255,127,0}));
  connect(isReq.y, nReq.u1) annotation (Line(points={{-38,-40},{-20,-40},{-20,0},
          {-12,0}}, color={255,0,255}));
  connect(nEnaAvaPre.y, intLes.u1) annotation (Line(points={{78,-100},{70,-100},
          {70,-84},{22,-84},{22,-100},{28,-100}}, color={255,127,0}));
  connect(nEquSta.y, intLes.u2) annotation (Line(points={{12,80},{16,80},{16,
          -108},{28,-108}}, color={255,127,0}));
  connect(swiEna.y, booScaRep.u)
    annotation (Line(points={{102,-60},{108,-60}},
                                                 color={255,0,255}));
  connect(cha.y, swiEna.u1)
    annotation (Line(points={{52,-60},{78,-60}}, color={255,0,255}));
  connect(intLes.y, swiEna.u2) annotation (Line(points={{52,-100},{60,-100},{60,
          -68},{78,-68}}, color={255,0,255}));
  connect(isEnaPreAva.y, nEnaAvaPre.u1)
    annotation (Line(points={{108,-100},{102,-100}},
                                                   color={255,0,255}));
  connect(y1Pre.y, isEnaPreAva.u2) annotation (Line(points={{158,-60},{150,-60},
          {150,-108},{132,-108}}, color={255,0,255}));
  connect(u1AvaEqu, isEnaPreAva.u1) annotation (Line(points={{-220,-80},{140,
          -80},{140,-100},{132,-100}},
                                  color={255,0,255}));
  connect(nAltReq.y, truArrCon.u)
    annotation (Line(points={{82,40},{98,40}}, color={255,127,0}));
  connect(uIdxAltSor, truArrCon.uIdx) annotation (Line(points={{-220,100},{90,
          100},{90,34},{98,34}},
                            color={255,127,0}));
  connect(truArrCon.y1, isReqAltAvaNee.u1) annotation (Line(points={{122,40},{
          130,40},{130,20},{70,20},{70,0},{78,0}},
                                               color={255,0,255}));
  connect(one.y, maxInt.u1) annotation (Line(points={{-168,20},{-166,20},{-166,
          6},{-162,6}}, color={255,127,0}));
  connect(uSta, maxInt.u2) annotation (Line(points={{-220,0},{-166,0},{-166,-6},
          {-162,-6}}, color={255,127,0}));
  connect(maxInt.y, intScaRep.u)
    annotation (Line(points={{-138,0},{-132,0}}, color={255,127,0}));
  connect(uSta, greZer.u) annotation (Line(points={{-220,0},{-190,0},{-190,-40},
          {-172,-40}}, color={255,127,0}));
  connect(greZer.y, booToRea.u)
    annotation (Line(points={{-148,-40},{-142,-40}}, color={255,0,255}));
  connect(booToRea.y, reaScaRep.u)
    annotation (Line(points={{-118,-40},{-112,-40}}, color={0,0,127}));
  connect(reqEquSta.y, voiStaZer.u1) annotation (Line(points={{-138,80},{-120,
          80},{-120,86},{-102,86}}, color={0,0,127}));
  connect(reaScaRep.y, voiStaZer.u2) annotation (Line(points={{-88,-40},{-80,
          -40},{-80,64},{-110,64},{-110,74},{-102,74}}, color={0,0,127}));
  connect(voiStaZer.y, nEquStaRea.u)
    annotation (Line(points={{-78,80},{-62,80}}, color={0,0,127}));
  connect(voiStaZer.y, isReqPosAlt.u) annotation (Line(points={{-78,80},{-70,80},
          {-70,40},{-62,40}}, color={0,0,127}));
  connect(voiStaZer.y, isNotReqNoAlt.u) annotation (Line(points={{-78,80},{-70,
          80},{-70,0},{-62,0}}, color={0,0,127}));
  connect(voiStaZer.y, isReq.u) annotation (Line(points={{-78,80},{-70,80},{-70,
          -40},{-62,-40}}, color={0,0,127}));
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
    Diagram(coordinateSystem(extent={{-200,-120},{200,120}})),
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
