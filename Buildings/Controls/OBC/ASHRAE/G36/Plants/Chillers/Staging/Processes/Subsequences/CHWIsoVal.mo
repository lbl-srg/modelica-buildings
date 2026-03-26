within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences;
block CHWIsoVal "Sequence of enable or disable chilled water isolation valve"

  parameter Boolean have_isoValEndSwi=false
    "True: chiller chilled water isolatiove valve have the end switch feedback";
  parameter Integer nChi=2
    "Total number of chiller, which is also the total number of chilled water isolation valve";
  parameter Real chaChiWatIsoTim(
    start=120,
    unit="s")=0
    "Time to slowly change isolation valve, should be determined in the field";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexChaChi
    "Index of next chiller that should change status"
    annotation (Placement(transformation(extent={{-260,238},{-220,278}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-260,130},{-220,170}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ChiIsoOpe[nChi] if have_isoValEndSwi
    "Chiller chilled water isolation valve open end switch. True: the valve is fully open"
    annotation (Placement(transformation(extent={{-260,90},{-220,130}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ChiIsoClo[nChi] if have_isoValEndSwi
    "Chiller chilled water isolation valve close end switch. True: the valve is fully closed"
    annotation (Placement(transformation(extent={{-260,30},{-220,70}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of resetting status of device before enabling or disabling isolation valve"
    annotation (Placement(transformation(extent={{-260,-210},{-220,-170}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaPro
    "Indicate if there is a stage up or stage down command"
    annotation (Placement(transformation(extent={{-260,-260},{-220,-220}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ChiWatIsoVal[nChi]
    "Chiller chilled water isolation valve command"
    annotation (Placement(transformation(extent={{220,170},{260,210}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    unit=fill("1", nChi))
    "Chiller chilled water isolation valve position setpoint"
    annotation (Placement(transformation(extent={{220,-120},{260,-80}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaChiWatIsoVal
    "Status of chilled water isolation valve control: true=completed change of the isolation valve position"
    annotation (Placement(transformation(extent={{220,-220},{260,-180}}),
      iconTransformation(extent={{100,40},{140,80}})));

protected
  final parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=chaChiWatIsoTim)
    "Count the time after changing up-stream device status"
    annotation (Placement(transformation(extent={{0,-230},{20,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-180,-200},{-160,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{-80,-230},{-60,-210}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    if have_isoValEndSwi
    "Record the old chiller chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if it is time to change isolation valve position"
    annotation (Placement(transformation(extent={{-140,-200},{-120,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-140,-280},{-120,-260}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nChi]
    "Check next enabling isolation valve"
    annotation (Placement(transformation(extent={{-80,240},{-60,260}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=nChi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-120,240},{-100,260}})));
  Buildings.Controls.OBC.CDL.Logical.And and5 if have_isoValEndSwi
    "Check if the isolation valve has been fully open"
    annotation (Placement(transformation(extent={{180,-210},{200,-190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nChi](
    final k=chiInd) "Chiller index array"
    annotation (Placement(transformation(extent={{-120,280},{-100,300}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{0,-180},{20,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2 if not have_isoValEndSwi
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{140,-260},{160,-240}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=5) "Delay the true input"
    annotation (Placement(transformation(extent={{-80,-280},{-60,-260}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cloVal[nChi] if have_isoValEndSwi
    "1: valve is fully closed"
    annotation (Placement(transformation(extent={{-200,40},{-180,60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal opeVal[nChi] if have_isoValEndSwi
    "1: valve is fully open"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1
    if have_isoValEndSwi
    "Record the old chiller chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-20,240},{0,260}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-160,180},{-140,200}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub[nChi] "Output the difference"
    annotation (Placement(transformation(extent={{40,210},{60,230}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs1[nChi] "Output the absolute"
    annotation (Placement(transformation(extent={{80,210},{100,230}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr[nChi](t=fill(0.5, nChi))
    "New isolation valve command"
    annotation (Placement(transformation(extent={{120,210},{140,230}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum(nin=nChi) if have_isoValEndSwi
    "Total number of full open valves"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum1(nin=nChi) if have_isoValEndSwi
    "Total number of full closed valves"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1[2] if have_isoValEndSwi "Output the difference"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1[2](final t=fill(0.5, 2))
    if have_isoValEndSwi "Check if the isolation valve position has changed"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs2[2] if have_isoValEndSwi "Output the absolute"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    "Next enabled or disabled chiller"
    annotation (Placement(transformation(extent={{-160,240},{-140,260}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zer(final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-200,200},{-180,220}})));
  Buildings.Controls.OBC.CDL.Logical.And and1[nChi]
    "Logical and"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[nChi]
    "Logical and"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd enaVal(
    final nin=nChi)
    "New valve should be enabled"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));
  Buildings.Controls.OBC.CDL.Logical.Switch isoValCha if have_isoValEndSwi
    "Check if isolation valve change is completed"
    annotation (Placement(transformation(extent={{140,70},{160,90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch isoValCha1[nChi] "Isolation valve command"
    annotation (Placement(transformation(extent={{180,180},{200,200}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator intRep1(
    final nout=nChi) "Replicate boolean input"
    annotation (Placement(transformation(extent={{40,160},{60,180}})));
  Buildings.Controls.OBC.CDL.Logical.Change cha[nChi]
    "Check if there is chiller status changes"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat3 "Hold input"
    annotation (Placement(transformation(extent={{0,160},{20,180}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nChi)
    "Check if there is any chiller status changes"
    annotation (Placement(transformation(extent={{-60,160},{-40,180}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nChi]
    "Chilled water isolation valve position setpoint"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin
    "Slowly changing the valve position"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=nChi)
    "Duplicate position setpoint"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=0) "Zero constant"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(
    final k=chaChiWatIsoTim)
    "Isolation valve position changing time"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Switch iniPos
    "Initial position of the being changed valve"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cloPos(
    final k=0) "Closed valve"
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant opePos(
    final k=1) "Open valve"
    annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Switch endPos
    "Ending position of the being changed valve"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1[nChi]
    "Chilled water isolation valve position setpoint"
    annotation (Placement(transformation(extent={{180,-110},{200,-90}})));

equation
  connect(uUpsDevSta, edg.u)
    annotation (Line(points={{-240,-190},{-182,-190}}, color={255,0,255}));
  connect(uStaPro, and2.u2)
    annotation (Line(points={{-240,-240},{-150,-240},{-150,-198},{-142,-198}},
          color={255,0,255}));
  connect(edg.y, and2.u1)
    annotation (Line(points={{-158,-190},{-142,-190}}, color={255,0,255}));
  connect(and2.y, lat.u)
    annotation (Line(points={{-118,-190},{-100,-190},{-100,-220},{-82,-220}},
          color={255,0,255}));
  connect(uStaPro, not1.u) annotation (Line(points={{-240,-240},{-150,-240},{-150,
          -270},{-142,-270}},color={255,0,255}));
  connect(not1.y, lat.clr)
    annotation (Line(points={{-118,-270},{-100,-270},{-100,-226},{-82,-226}},
      color={255,0,255}));
  connect(intRep.y, intEqu.u1)
    annotation (Line(points={{-98,250},{-82,250}},  color={255,127,0}));
  connect(lat.y, tim.u)
    annotation (Line(points={{-58,-220},{-2,-220}}, color={255,0,255}));
  connect(conInt.y, intEqu.u2)
    annotation (Line(points={{-98,290},{-90,290},{-90,242},{-82,242}},
      color={255,127,0}));
  connect(lat1.y, and5.u2)
    annotation (Line(points={{22,-170},{80,-170},{80,-208},{178,-208}},
      color={255,0,255}));
  connect(uUpsDevSta, lat1.u) annotation (Line(points={{-240,-190},{-200,-190},{
          -200,-170},{-2,-170}},color={255,0,255}));
  connect(not1.y, truDel.u) annotation (Line(points={{-118,-270},{-82,-270}},
         color={255,0,255}));
  connect(truDel.y, lat1.clr) annotation (Line(points={{-58,-270},{-10,-270},{-10,
          -176},{-2,-176}},color={255,0,255}));
  connect(tim.passed, lat2.u) annotation (Line(points={{22,-228},{120,-228},{120,
          -250},{138,-250}}, color={255,0,255}));
  connect(truDel.y, lat2.clr) annotation (Line(points={{-58,-270},{120,-270},{120,
          -256},{138,-256}}, color={255,0,255}));
  connect(u1ChiIsoOpe, opeVal.u)
    annotation (Line(points={{-240,110},{-202,110}}, color={255,0,255}));
  connect(u1ChiIsoClo, cloVal.u)
    annotation (Line(points={{-240,50},{-202,50}},   color={255,0,255}));
  connect(intEqu.y, booToRea.u)
    annotation (Line(points={{-58,250},{-22,250}}, color={255,0,255}));
  connect(uChi, booToRea1.u)
    annotation (Line(points={{-240,150},{-180,150},{-180,190},{-162,190}},
          color={255,0,255}));
  connect(booToRea.y, sub.u2) annotation (Line(points={{2,250},{20,250},{20,214},
          {38,214}}, color={0,0,127}));
  connect(sub.y, abs1.u)
    annotation (Line(points={{62,220},{78,220}}, color={0,0,127}));
  connect(abs1.y, greThr.u)
    annotation (Line(points={{102,220},{118,220}}, color={0,0,127}));
  connect(opeVal.y, mulSum.u)
    annotation (Line(points={{-178,110},{-162,110}}, color={0,0,127}));
  connect(cloVal.y, mulSum1.u)
    annotation (Line(points={{-178,50},{-162,50}}, color={0,0,127}));
  connect(mulSum.y, triSam1.u)
    annotation (Line(points={{-138,110},{-82,110}}, color={0,0,127}));
  connect(mulSum1.y, triSam.u)
    annotation (Line(points={{-138,50},{-82,50}},  color={0,0,127}));
  connect(and2.y, triSam.trigger) annotation (Line(points={{-118,-190},{-100,-190},
          {-100,30},{-70,30},{-70,38}},   color={255,0,255}));
  connect(and2.y, triSam1.trigger) annotation (Line(points={{-118,-190},{-100,-190},
          {-100,90},{-70,90},{-70,98}},color={255,0,255}));
  connect(triSam1.y, sub1[1].u1) annotation (Line(points={{-58,110},{-50,110},{-50,
          86},{-2,86}}, color={0,0,127}));
  connect(triSam.y, sub1[2].u1) annotation (Line(points={{-58,50},{-50,50},{-50,
          86},{-2,86}}, color={0,0,127}));
  connect(mulSum.y, sub1[1].u2) annotation (Line(points={{-138,110},{-110,110},{
          -110,74},{-2,74}},  color={0,0,127}));
  connect(mulSum1.y, sub1[2].u2) annotation (Line(points={{-138,50},{-110,50},{-110,
          74},{-2,74}},  color={0,0,127}));
  connect(sub1.y, abs2.u)
    annotation (Line(points={{22,80},{38,80}}, color={0,0,127}));
  connect(abs2.y, greThr1.u)
    annotation (Line(points={{62,80},{78,80}}, color={0,0,127}));
  connect(lat2.y,yChaChiWatIsoVal)  annotation (Line(points={{162,-250},{210,-250},
          {210,-200},{240,-200}}, color={255,0,255}));
  connect(and5.y,yChaChiWatIsoVal)  annotation (Line(points={{202,-200},{240,-200}},
          color={255,0,255}));
  connect(intSwi.y, intRep.u)
    annotation (Line(points={{-138,250},{-122,250}}, color={255,127,0}));
  connect(zer.y, intSwi.u3) annotation (Line(points={{-178,210},{-170,210},{-170,
          242},{-162,242}}, color={255,127,0}));
  connect(nexChaChi, intSwi.u1)
    annotation (Line(points={{-240,258},{-162,258}}, color={255,127,0}));
  connect(lat.y, intSwi.u2) annotation (Line(points={{-58,-220},{-40,-220},{-40,
          -150},{-210,-150},{-210,250},{-162,250}}, color={255,0,255}));
  connect(and1.y, not2.u)
    annotation (Line(points={{22,120},{38,120}}, color={255,0,255}));
  connect(not2.y, enaVal.u)
    annotation (Line(points={{62,120},{78,120}}, color={255,0,255}));
  connect(greThr1[1].y, isoValCha.u1) annotation (Line(points={{102,80},{120,80},
          {120,88},{138,88}}, color={255,0,255}));
  connect(enaVal.y, isoValCha.u2) annotation (Line(points={{102,120},{130,120},{
          130,80},{138,80}}, color={255,0,255}));
  connect(greThr1[2].y, isoValCha.u3) annotation (Line(points={{102,80},{120,80},
          {120,72},{138,72}},color={255,0,255}));
  connect(isoValCha.y, and5.u1) annotation (Line(points={{162,80},{170,80},{170,
          -200},{178,-200}}, color={255,0,255}));
  connect(intEqu.y, and1.u1) annotation (Line(points={{-58,250},{-30,250},{-30,120},
          {-2,120}},color={255,0,255}));
  connect(uChi, and1.u2) annotation (Line(points={{-240,150},{-40,150},{-40,112},
          {-2,112}},color={255,0,255}));
  connect(booToRea1.y, sub.u1) annotation (Line(points={{-138,190},{-120,190},{-120,
          226},{38,226}}, color={0,0,127}));
  connect(isoValCha1.y, y1ChiWatIsoVal)
    annotation (Line(points={{202,190},{240,190}}, color={255,0,255}));
  connect(uChi, cha.u) annotation (Line(points={{-240,150},{-110,150},{-110,170},
          {-102,170}}, color={255,0,255}));
  connect(uChi, isoValCha1.u1) annotation (Line(points={{-240,150},{-110,150},{-110,
          198},{178,198}}, color={255,0,255}));
  connect(greThr.y, isoValCha1.u3) annotation (Line(points={{142,220},{160,220},
          {160,182},{178,182}}, color={255,0,255}));
  connect(cha.y, mulOr.u)
    annotation (Line(points={{-78,170},{-62,170}}, color={255,0,255}));
  connect(mulOr.y, lat3.u)
    annotation (Line(points={{-38,170},{-2,170}}, color={255,0,255}));
  connect(truDel.y, lat3.clr) annotation (Line(points={{-58,-270},{-10,-270},{-10,
          164},{-2,164}}, color={255,0,255}));
  connect(lat3.y, intRep1.u)
    annotation (Line(points={{22,170},{38,170}}, color={255,0,255}));
  connect(intRep1.y, isoValCha1.u2) annotation (Line(points={{62,170},{110,170},
          {110,190},{178,190}},color={255,0,255}));
  connect(intEqu.y, swi.u2) annotation (Line(points={{-58,250},{-30,250},{-30,
          -120},{118,-120}},
                       color={255,0,255}));
  connect(booToRea1.y, swi.u3) annotation (Line(points={{-138,190},{-120,190},{
          -120,-128},{118,-128}},
                             color={0,0,127}));
  connect(lin.y, reaScaRep.u)
    annotation (Line(points={{102,-40},{118,-40}}, color={0,0,127}));
  connect(con.y, lin.x1) annotation (Line(points={{42,-10},{60,-10},{60,-32},{78,
          -32}}, color={0,0,127}));
  connect(con1.y, lin.x2) annotation (Line(points={{42,-70},{60,-70},{60,-44},{78,
          -44}}, color={0,0,127}));
  connect(tim.y, lin.u) annotation (Line(points={{22,-220},{50,-220},{50,-40},{78,
          -40}}, color={0,0,127}));
  connect(enaVal.y, iniPos.u2) annotation (Line(points={{102,120},{130,120},{130,
          10},{-110,10},{-110,-20},{-82,-20}}, color={255,0,255}));
  connect(cloPos.y, iniPos.u1) annotation (Line(points={{-178,0},{-160,0},{-160,
          -12},{-82,-12}}, color={0,0,127}));
  connect(opePos.y, iniPos.u3) annotation (Line(points={{-178,-50},{-148,-50},{-148,
          -28},{-82,-28}}, color={0,0,127}));
  connect(iniPos.y, lin.f1) annotation (Line(points={{-58,-20},{0,-20},{0,-36},{
          78,-36}}, color={0,0,127}));
  connect(enaVal.y, endPos.u2) annotation (Line(points={{102,120},{130,120},{130,
          10},{-110,10},{-110,-70},{-82,-70}}, color={255,0,255}));
  connect(opePos.y, endPos.u1) annotation (Line(points={{-178,-50},{-148,-50},{-148,
          -62},{-82,-62}}, color={0,0,127}));
  connect(cloPos.y, endPos.u3) annotation (Line(points={{-178,0},{-160,0},{-160,
          -78},{-82,-78}}, color={0,0,127}));
  connect(endPos.y, lin.f2) annotation (Line(points={{-58,-70},{0,-70},{0,-48},{
          78,-48}}, color={0,0,127}));
  connect(reaScaRep.y, swi.u1) annotation (Line(points={{142,-40},{160,-40},{
          160,-70},{100,-70},{100,-112},{118,-112}},
                                                 color={0,0,127}));
  connect(swi.y, swi1.u3) annotation (Line(points={{142,-120},{160,-120},{160,
          -108},{178,-108}},
                       color={0,0,127}));
  connect(booToRea1.y, swi1.u1) annotation (Line(points={{-138,190},{-120,190},{
          -120,-92},{178,-92}}, color={0,0,127}));
  connect(swi1.y, yChiWatIsoVal)
    annotation (Line(points={{202,-100},{240,-100}}, color={0,0,127}));
  connect(intRep1.y, swi1.u2) annotation (Line(points={{62,170},{110,170},{110,-100},
          {178,-100}}, color={255,0,255}));
annotation (
  defaultComponentName="enaChiIsoVal",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-220,-320},{220,320}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-100,-74},{-64,-86}},
          textColor={255,0,255},
          textString="uStaPro"),
        Text(
          extent={{-98,-42},{-50,-56}},
          textColor={255,0,255},
          textString="uUpsDevSta"),
        Text(
          extent={{-100,86},{-52,74}},
          textColor={255,127,0},
          textString="nexChaChi"),
        Text(
          extent={{-98,58},{-76,46}},
          textColor={255,0,255},
          textString="uChi"),
        Text(
          extent={{32,70},{96,54}},
          textColor={255,0,255},
          textString="yChaChiWatIsoVal"),
        Polygon(
          points={{-60,40},{-60,-40},{0,0},{-60,40}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{60,40},{60,-40},{0,0},{60,40}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{44,-54},{98,-66}},
          textColor={255,0,255},
          textString="y1ChiWatIsoVal"),
        Text(
          extent={{-98,28},{-48,14}},
          textColor={255,0,255},
          textString="u1ChiIsoOpe",
          visible=have_isoValEndSwi),
        Text(
          extent={{-98,-4},{-52,-18}},
          textColor={255,0,255},
          visible=have_isoValEndSwi,
          textString="u1ChiIsoClo"),
        Text(
          extent={{44,8},{98,-4}},
          textColor={0,0,127},
          textString="yChiWatIsoVal")}),
 Documentation(info="<html>
<p>
Block updates chiller chilled water isolation valve enabling-disabling status when 
there is stage change command (<code>uStaPro=true</code>). It will also generate 
status to indicate if the valve reset process has finished.
This development is based on ASHRAE Guideline 36-2021, 
section 5.20.4.16, item e, and section 5.20.4.17, item c, which specifies when 
and how the isolation valve should be controlled when it is in the stage changing process.
</p>
<ul>
<li>
When there is the stage up command (<code>uStaPro=true</code>) and next chiller 
head pressure control has been enabled (<code>uUpsDevSta=true</code>),
the chilled water isolation valve of the next enabling chiller indicated 
by <code>nexChaChi</code> will be enabled. 
</li>
<li>
When there is the stage down command (<code>uStaPro=true</code>) and the disabling chiller 
(<code>nexChaChi</code>) has been shut off (<code>uUpsDevSta=true</code>),
the chiller's isolation valve will be disabled. 
</li>
</ul>
<p>
The valve should open or close slowly. 
The valve time <code>chaChiWatIsoTim</code> should be determined in the field. 
</p>
<p>
This sequence will generate array <code>y1ChiWatIsoVal</code>, which indicates 
chilled water isolation valve position command. <code>yChaChiWatIsoVal</code> 
will be true when all the enabled valves are fully open and all the disabled valves
are fully closed. 
</p>
</html>", revisions="<html>
<ul>
<li>
February 4, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end CHWIsoVal;
