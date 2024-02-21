within Buildings.Templates.Plants.Controls.StagingRotation;
block StageAvailability "Compute stage availability"
  parameter Real staEqu[:,:](
    each unit="1",
    each min=0,
    each max=1)
    "Staging matrix – Equipment required for each stage";
  final parameter Integer nSta = size(staEqu, 1)
    "Number of stages"
    annotation(Evaluate=true);
  final parameter Integer nEqu = size(staEqu, 2)
    "Number of equipment"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaEqu[nEqu]
    "Equipment available signal" annotation (Placement(transformation(extent={{-180,
            -80},{-140,-40}}),iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nSta]
    "Stage available signal" annotation (Placement(transformation(extent={{140,-20},
            {180,20}}), iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant matStaEqu[nSta,nEqu](
    final k=staEqu) "Staging matrix"
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isReq[nSta,nEqu](
    each final t=0.99)
    "Return true if equipment required without lead/lag alternate"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isReqPosAlt[nSta,nEqu](
    each final t=0)
    "Return true if equipment required (with or without lead/lag alternate)"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold isNotReqNoAlt[nSta,nEqu](
    each final t=1)
    "Return true if equipment not required or required with lead/lag alternate"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorReplicator booVecRep(
    final nin=nEqu,
    final nout=nSta)
    "Replicate equipment available signal"
    annotation (Placement(transformation(extent={{-130,-70},{-110,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And isReqAva[nSta,nEqu]
    "Return true if equipment required without lead/lag alternate and available"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And isReqAltAva[nSta,nEqu]
    "Return true if equipment required (with or without lead/lag alternate) and available"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or isReqAvaOrNotReq[nSta,nEqu]
    "Return true if equipment required without lead/lag alternate and available, or if not required"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd all[nSta](
    each final nin=nEqu)
    "Return true if previous block condition valid for all elements"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And isAva[nSta]
    "Return true if stage available"
    annotation (Placement(transformation(extent={{110,-10},{130,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum nEquSta[nSta](
    each final nin=nEqu)
    "Return the number of equipment required at each stage"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nSta,nEqu]
    "Convert to integer"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqual isReqAltAvaGreReq[nSta]
    "Return true if number of required available equipment higher than number of required equipment"
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum nReqAltAva[nSta](each final nin=
        nEqu)
    "Number of equipment required (with or without lead/lag alternate) and available"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger nEquStaInt[nSta]
    "Integer cast of number of equipment required at each stage"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
equation
  connect(matStaEqu.y, isReq.u) annotation (Line(points={{-108,0},{-90,0},{-90,-40},
          {-82,-40}},  color={0,0,127}));
  connect(matStaEqu.y, isReqPosAlt.u) annotation (Line(points={{-108,0},{-90,0},
          {-90,40},{-82,40}}, color={0,0,127}));
  connect(matStaEqu.y, isNotReqNoAlt.u)
    annotation (Line(points={{-108,0},{-82,0}},  color={0,0,127}));
  connect(isReq.y, isReqAva.u1) annotation (Line(points={{-58,-40},{-42,-40}},
                      color={255,0,255}));
  connect(booVecRep.y, isReqAva.u2) annotation (Line(points={{-108,-60},{-50,-60},
          {-50,-48},{-42,-48}}, color={255,0,255}));
  connect(booVecRep.y, isReqAltAva.u2) annotation (Line(points={{-108,-60},{-50,
          -60},{-50,32},{-42,32}},
                               color={255,0,255}));
  connect(isReqAva.y, isReqAvaOrNotReq.u2) annotation (Line(points={{-18,-40},{-10,
          -40},{-10,-28},{-2,-28}},color={255,0,255}));
  connect(isNotReqNoAlt.y, isReqAvaOrNotReq.u1) annotation (Line(points={{-58,0},
          {-10,0},{-10,-20},{-2,-20}},color={255,0,255}));
  connect(isAva.y, y1)
    annotation (Line(points={{132,0},{160,0}}, color={255,0,255}));
  connect(isReqAvaOrNotReq.y, all.u)
    annotation (Line(points={{22,-20},{28,-20}}, color={255,0,255}));
    connect(matStaEqu.y, nEquSta.u) annotation (Line(points={{-108,0},{-90,0},{-90,
          80},{-82,80}},
                       color={0,0,127}));
  connect(nReqAltAva.y, isReqAltAvaGreReq.u1)
    annotation (Line(points={{52,40},{68,40}}, color={255,127,0}));
  connect(nReqAltAva.u, booToInt.y)
    annotation (Line(points={{28,40},{22,40}}, color={255,127,0}));
  connect(nEquSta.y, nEquStaInt.u)
    annotation (Line(points={{-58,80},{-42,80}}, color={0,0,127}));
  connect(nEquStaInt.y, isReqAltAvaGreReq.u2) annotation (Line(points={{-18,80},
          {60,80},{60,32},{68,32}}, color={255,127,0}));
  connect(u1AvaEqu, booVecRep.u)
    annotation (Line(points={{-160,-60},{-132,-60}}, color={255,0,255}));
  connect(isReqPosAlt.y, isReqAltAva.u1)
    annotation (Line(points={{-58,40},{-42,40}}, color={255,0,255}));
  connect(isReqAltAva.y, booToInt.u)
    annotation (Line(points={{-18,40},{-2,40}}, color={255,0,255}));
  connect(isReqAltAvaGreReq.y, isAva.u1) annotation (Line(points={{92,40},{100,40},
          {100,0},{108,0}}, color={255,0,255}));
  connect(all.y, isAva.u2) annotation (Line(points={{52,-20},{100,-20},{100,-8},
          {108,-8}}, color={255,0,255}));
annotation (
   defaultComponentName="avaSta",
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
   Diagram(coordinateSystem(extent={{-140,-100},{
            140,100}})),
    Documentation(info="<html>
<p>
A stage is deemed available if both the following are true:
</p>
<ul>
<li>
Each equipment required to run at that stage without
lead/lag alternate is available.
</li>
<li>
The number of equipment required to run at that stage –
with or without lead/lag alternate – that are available
is higher than the number of equipment required to run 
at that stage.
</li>
</ul>
<p>
Otherwise, the stage is deemed unavailable.
</p>
</html>"));
end StageAvailability;
