within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences;
block CHWIsoVal "Sequence of enable or disable chilled water isolation valve"

  parameter Boolean have_isoValEndSwi=false
    "True: chiller chilled water isolatiove valve have the end switch feedback";
  parameter Integer nChi=2
    "Total number of chiller, which is also the total number of chilled water isolation valve";
  parameter Real chaChiWatIsoTim(unit="s", start=120)
    "Time to slowly change isolation valve, should be determined in the field"
    annotation (Dialog(enable=not have_isoValEndSwi));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexChaChi
    "Index of next chiller that should change status"
    annotation (Placement(transformation(extent={{-260,158},{-220,198}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-260,50},{-220,90}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ChiIsoOpe[nChi] if have_isoValEndSwi
    "Chiller chilled water isolation valve open end switch. True: the valve is fully open"
    annotation (Placement(transformation(extent={{-260,10},{-220,50}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ChiIsoClo[nChi] if have_isoValEndSwi
    "Chiller chilled water isolation valve close end switch. True: the valve is fully closed"
    annotation (Placement(transformation(extent={{-260,-50},{-220,-10}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of resetting status of device before enabling or disabling isolation valve"
    annotation (Placement(transformation(extent={{-260,-120},{-220,-80}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaPro
    "Indicate if there is a stage up or stage down command"
    annotation (Placement(transformation(extent={{-260,-170},{-220,-130}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ChiWatIsoVal[nChi]
    "Chiller chilled water isolation valve command"
    annotation (Placement(transformation(extent={{220,100},{260,140}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaChiWatIsoVal
    "Status of chilled water isolation valve control: true=completed change of the isolation valve position"
    annotation (Placement(transformation(extent={{220,-130},{260,-90}}),
      iconTransformation(extent={{100,40},{140,80}})));

protected
  final parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=chaChiWatIsoTim) if not have_isoValEndSwi
    "Count the time after changing up-stream device status"
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-180,-110},{-160,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    if have_isoValEndSwi
    "Record the old chiller chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if it is time to change isolation valve position"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-140,-190},{-120,-170}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nChi]
    "Check next enabling isolation valve"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=nChi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-120,160},{-100,180}})));
  Buildings.Controls.OBC.CDL.Logical.And and5 if have_isoValEndSwi
    "Check if the isolation valve has been fully open"
    annotation (Placement(transformation(extent={{180,-120},{200,-100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nChi](
    final k=chiInd) "Chiller index array"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2 if not have_isoValEndSwi
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{140,-170},{160,-150}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=5) "Delay the true input"
    annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cloVal[nChi] if have_isoValEndSwi
    "1: valve is fully closed"
    annotation (Placement(transformation(extent={{-200,-40},{-180,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal opeVal[nChi] if have_isoValEndSwi
    "1: valve is fully open"
    annotation (Placement(transformation(extent={{-200,20},{-180,40}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1
    if have_isoValEndSwi
    "Record the old chiller chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-20,160},{0,180}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub[nChi] "Output the difference"
    annotation (Placement(transformation(extent={{40,140},{60,160}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs1[nChi] "Output the absolute"
    annotation (Placement(transformation(extent={{80,140},{100,160}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr[nChi](t=fill(0.5, nChi))
    "New isolation valve command"
    annotation (Placement(transformation(extent={{120,140},{140,160}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum(nin=nChi) if have_isoValEndSwi
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum1(nin=nChi) if have_isoValEndSwi
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1[2] if have_isoValEndSwi "Output the difference"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1[2](final t=fill(0.5, 2))
    if have_isoValEndSwi "Check if the isolation valve position has changed"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs2[2] if have_isoValEndSwi "Output the absolute"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    "Next enabled or disabled chiller"
    annotation (Placement(transformation(extent={{-160,160},{-140,180}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zer(final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-200,120},{-180,140}})));
  Buildings.Controls.OBC.CDL.Logical.And and1[nChi] if have_isoValEndSwi
    "Logical and"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[nChi] if have_isoValEndSwi
    "Logical and"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd enaVal(
    final nin=nChi) if have_isoValEndSwi
    "New valve should be enabled"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch isoValCha if have_isoValEndSwi
    "Check if isolation valve change is completed"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch isoValCha1[nChi] "Isolation valve command"
    annotation (Placement(transformation(extent={{180,110},{200,130}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator intRep1(
    final nout=nChi) "Replicate boolean input"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Logical.Change cha[nChi]
    "Check if there is chiller status changes"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat3 "Hold input"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nChi)
    "Check if there is any chiller status changes"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));

equation
  connect(uUpsDevSta, edg.u)
    annotation (Line(points={{-240,-100},{-182,-100}}, color={255,0,255}));
  connect(uStaPro, and2.u2)
    annotation (Line(points={{-240,-150},{-150,-150},{-150,-108},{-142,-108}},
          color={255,0,255}));
  connect(edg.y, and2.u1)
    annotation (Line(points={{-158,-100},{-142,-100}}, color={255,0,255}));
  connect(and2.y, lat.u)
    annotation (Line(points={{-118,-100},{-100,-100},{-100,-130},{-82,-130}},
          color={255,0,255}));
  connect(uStaPro, not1.u) annotation (Line(points={{-240,-150},{-150,-150},{-150,
          -180},{-142,-180}},color={255,0,255}));
  connect(not1.y, lat.clr)
    annotation (Line(points={{-118,-180},{-100,-180},{-100,-136},{-82,-136}},
      color={255,0,255}));
  connect(intRep.y, intEqu.u1)
    annotation (Line(points={{-98,170},{-82,170}},  color={255,127,0}));
  connect(lat.y, tim.u)
    annotation (Line(points={{-58,-130},{-22,-130}},color={255,0,255}));
  connect(conInt.y, intEqu.u2)
    annotation (Line(points={{-98,130},{-90,130},{-90,162},{-82,162}},
      color={255,127,0}));
  connect(lat1.y, and5.u2)
    annotation (Line(points={{2,-80},{80,-80},{80,-118},{178,-118}},
      color={255,0,255}));
  connect(uUpsDevSta, lat1.u) annotation (Line(points={{-240,-100},{-200,-100},{
          -200,-80},{-22,-80}}, color={255,0,255}));
  connect(not1.y, truDel.u) annotation (Line(points={{-118,-180},{-82,-180}},
         color={255,0,255}));
  connect(truDel.y, lat1.clr) annotation (Line(points={{-58,-180},{-30,-180},{-30,
          -86},{-22,-86}}, color={255,0,255}));
  connect(tim.passed, lat2.u) annotation (Line(points={{2,-138},{120,-138},{120,
          -160},{138,-160}}, color={255,0,255}));
  connect(truDel.y, lat2.clr) annotation (Line(points={{-58,-180},{120,-180},{120,
          -166},{138,-166}}, color={255,0,255}));
  connect(u1ChiIsoOpe, opeVal.u)
    annotation (Line(points={{-240,30},{-202,30}}, color={255,0,255}));
  connect(u1ChiIsoClo, cloVal.u)
    annotation (Line(points={{-240,-30},{-202,-30}}, color={255,0,255}));
  connect(intEqu.y, booToRea.u)
    annotation (Line(points={{-58,170},{-22,170}}, color={255,0,255}));
  connect(uChi, booToRea1.u)
    annotation (Line(points={{-240,70},{-180,70},{-180,100},{-162,100}},
          color={255,0,255}));
  connect(booToRea.y, sub.u2) annotation (Line(points={{2,170},{20,170},{20,144},
          {38,144}}, color={0,0,127}));
  connect(sub.y, abs1.u)
    annotation (Line(points={{62,150},{78,150}},   color={0,0,127}));
  connect(abs1.y, greThr.u)
    annotation (Line(points={{102,150},{118,150}}, color={0,0,127}));
  connect(opeVal.y, mulSum.u)
    annotation (Line(points={{-178,30},{-162,30}}, color={0,0,127}));
  connect(cloVal.y, mulSum1.u)
    annotation (Line(points={{-178,-30},{-162,-30}}, color={0,0,127}));
  connect(mulSum.y, triSam1.u)
    annotation (Line(points={{-138,30},{-82,30}},color={0,0,127}));
  connect(mulSum1.y, triSam.u)
    annotation (Line(points={{-138,-30},{-82,-30}},color={0,0,127}));
  connect(and2.y, triSam.trigger) annotation (Line(points={{-118,-100},{-100,-100},
          {-100,-50},{-70,-50},{-70,-42}},color={255,0,255}));
  connect(and2.y, triSam1.trigger) annotation (Line(points={{-118,-100},{-100,-100},
          {-100,10},{-70,10},{-70,18}},color={255,0,255}));
  connect(triSam1.y, sub1[1].u1) annotation (Line(points={{-58,30},{-40,30},{
          -40,6},{-22,6}}, color={0,0,127}));
  connect(triSam.y, sub1[2].u1) annotation (Line(points={{-58,-30},{-40,-30},{
          -40,6},{-22,6}}, color={0,0,127}));
  connect(mulSum.y, sub1[1].u2) annotation (Line(points={{-138,30},{-120,30},{
          -120,-6},{-22,-6}}, color={0,0,127}));
  connect(mulSum1.y, sub1[2].u2) annotation (Line(points={{-138,-30},{-120,-30},
          {-120,-6},{-22,-6}},color={0,0,127}));
  connect(sub1.y, abs2.u)
    annotation (Line(points={{2,0},{18,0}},  color={0,0,127}));
  connect(abs2.y, greThr1.u)
    annotation (Line(points={{42,0},{78,0}}, color={0,0,127}));
  connect(lat2.y,yChaChiWatIsoVal)  annotation (Line(points={{162,-160},{210,-160},
          {210,-110},{240,-110}}, color={255,0,255}));
  connect(and5.y,yChaChiWatIsoVal)  annotation (Line(points={{202,-110},{240,-110}},
          color={255,0,255}));
  connect(intSwi.y, intRep.u)
    annotation (Line(points={{-138,170},{-122,170}}, color={255,127,0}));
  connect(zer.y, intSwi.u3) annotation (Line(points={{-178,130},{-170,130},{-170,
          162},{-162,162}}, color={255,127,0}));
  connect(nexChaChi, intSwi.u1)
    annotation (Line(points={{-240,178},{-162,178}}, color={255,127,0}));
  connect(lat.y, intSwi.u2) annotation (Line(points={{-58,-130},{-40,-130},{-40,
          -60},{-210,-60},{-210,170},{-162,170}}, color={255,0,255}));
  connect(and1.y, not2.u)
    annotation (Line(points={{42,40},{58,40}},   color={255,0,255}));
  connect(not2.y, enaVal.u)
    annotation (Line(points={{82,40},{98,40}}, color={255,0,255}));
  connect(greThr1[1].y, isoValCha.u1) annotation (Line(points={{102,0},{120,0},{
          120,8},{138,8}}, color={255,0,255}));
  connect(enaVal.y, isoValCha.u2) annotation (Line(points={{122,40},{130,40},{130,
          0},{138,0}}, color={255,0,255}));
  connect(greThr1[2].y, isoValCha.u3) annotation (Line(points={{102,0},{120,0},{
          120,-8},{138,-8}}, color={255,0,255}));
  connect(isoValCha.y, and5.u1) annotation (Line(points={{162,0},{170,0},{170,-110},
          {178,-110}}, color={255,0,255}));
  connect(intEqu.y, and1.u1) annotation (Line(points={{-58,170},{-40,170},{-40,40},
          {18,40}}, color={255,0,255}));
  connect(uChi, and1.u2) annotation (Line(points={{-240,70},{-30,70},{-30,32},{18,
          32}},     color={255,0,255}));
  connect(booToRea1.y, sub.u1) annotation (Line(points={{-138,100},{-60,100},{-60,
          156},{38,156}}, color={0,0,127}));
  connect(isoValCha1.y, y1ChiWatIsoVal)
    annotation (Line(points={{202,120},{240,120}}, color={255,0,255}));
  connect(uChi, cha.u) annotation (Line(points={{-240,70},{-30,70},{-30,90},{-22,
          90}}, color={255,0,255}));
  connect(uChi, isoValCha1.u1) annotation (Line(points={{-240,70},{-30,70},{-30,
          128},{178,128}}, color={255,0,255}));
  connect(greThr.y, isoValCha1.u3) annotation (Line(points={{142,150},{160,150},
          {160,112},{178,112}}, color={255,0,255}));
  connect(cha.y, mulOr.u)
    annotation (Line(points={{2,90},{18,90}}, color={255,0,255}));
  connect(mulOr.y, lat3.u)
    annotation (Line(points={{42,90},{58,90}}, color={255,0,255}));
  connect(truDel.y, lat3.clr) annotation (Line(points={{-58,-180},{50,-180},{50,
          84},{58,84}}, color={255,0,255}));
  connect(lat3.y, intRep1.u)
    annotation (Line(points={{82,90},{98,90}}, color={255,0,255}));
  connect(intRep1.y, isoValCha1.u2) annotation (Line(points={{122,90},{140,90},{
          140,120},{178,120}}, color={255,0,255}));
annotation (
  defaultComponentName="enaChiIsoVal",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-220,-200},{220,200}})),
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
          textString="u1ChiIsoClo")}),
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
