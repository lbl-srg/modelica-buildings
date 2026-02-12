within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences;
block CHWIsoVal_New
  "Sequence of enable or disable chilled water isolation valve"

  parameter Boolean have_isoValEndSwi=false
    "True: chiller chilled water isolatiove valve have the end switch feedback";
  parameter Integer nChi=2
    "Total number of chiller, which is also the total number of chilled water isolation valve";
  parameter Real chaChiWatIsoTim(unit="s")
    "Time to slowly change isolation valve, should be determined in the field"
    annotation (Dialog(enable=not have_isoValEndSwi));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexChaChi
    "Index of next chiller that should change status"
    annotation (Placement(transformation(extent={{-220,150},{-180,190}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-220,70},{-180,110}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ChiIsoOpe[nChi] if have_isoValEndSwi
    "Chiller chilled water isolation valve open end switch. True: the valve is fully open"
    annotation (Placement(transformation(extent={{-220,10},{-180,50}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ChiIsoClo[nChi] if have_isoValEndSwi
    "Chiller chilled water isolation valve close end switch. True: the valve is fully closed"
    annotation (Placement(transformation(extent={{-220,-50},{-180,-10}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of resetting status of device before enabling or disabling isolation valve"
    annotation (Placement(transformation(extent={{-220,-120},{-180,-80}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaPro
    "Indicate if there is a stage up or stage down command"
    annotation (Placement(transformation(extent={{-220,-170},{-180,-130}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ChiWatIsoVal[nChi]
    "Chiller chilled water isolation valve command"
    annotation (Placement(transformation(extent={{180,100},{220,140}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEnaChiWatIsoVal
    "Status of chilled water isolation valve control: true=enabled valve is fully open"
    annotation (Placement(transformation(extent={{180,-130},{220,-90}}),
      iconTransformation(extent={{100,40},{140,80}})));

protected
  final parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=chaChiWatIsoTim) if not have_isoValEndSwi
    "Count the time after changing up-stream device status"
    annotation (Placement(transformation(extent={{20,-140},{40,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat if not have_isoValEndSwi
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    if have_isoValEndSwi
    "Record the old chiller chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if it is time to change isolation valve position"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nChi]
    "Check next enabling isolation valve"
    annotation (Placement(transformation(extent={{-78,160},{-58,180}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=nChi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
  Buildings.Controls.OBC.CDL.Logical.And and5 if have_isoValEndSwi
    "Check if the isolation valve has been fully open"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nChi](
    final k=chiInd) "Chiller index array"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1 if have_isoValEndSwi
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2 if not have_isoValEndSwi
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{120,-174},{140,-154}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=5) "Delay the true input"
    annotation (Placement(transformation(extent={{-40,-180},{-20,-160}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cloVal[nChi] if have_isoValEndSwi
    "1: valve is fully closed"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal opeVal[nChi] if have_isoValEndSwi
    "1: valve is fully open"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1 if have_isoValEndSwi
    "Record the old chiller chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-20,160},{0,180}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub[nChi] "Output the difference"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs1[nChi] "Output the absolute"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr[nChi](t=fill(0.5, nChi))
    "New isolation valve command"
    annotation (Placement(transformation(extent={{120,110},{140,130}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum(nin=nChi) if have_isoValEndSwi
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum1(nin=nChi) if have_isoValEndSwi
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1[2] if have_isoValEndSwi "Output the difference"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1[2](final t=fill(0.5, 2))
    if have_isoValEndSwi "Check if the isolation valve position has changed"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs2[2] if have_isoValEndSwi "Output the absolute"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd enaIsoVal(
    final nin=2) if have_isoValEndSwi
    "Valve position changed"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));

equation
  connect(uUpsDevSta, edg.u)
    annotation (Line(points={{-200,-100},{-142,-100}}, color={255,0,255}));
  connect(uStaPro, and2.u2)
    annotation (Line(points={{-200,-150},{-110,-150},{-110,-108},{-102,-108}},
          color={255,0,255}));
  connect(edg.y, and2.u1)
    annotation (Line(points={{-118,-100},{-102,-100}}, color={255,0,255}));
  connect(and2.y, lat.u)
    annotation (Line(points={{-78,-100},{-60,-100},{-60,-130},{-42,-130}},
          color={255,0,255}));
  connect(uStaPro, not1.u) annotation (Line(points={{-200,-150},{-110,-150},{-110,
          -170},{-102,-170}},color={255,0,255}));
  connect(not1.y, lat.clr)
    annotation (Line(points={{-78,-170},{-60,-170},{-60,-136},{-42,-136}},
      color={255,0,255}));
  connect(nexChaChi, intRep.u)
    annotation (Line(points={{-200,170},{-142,170}}, color={255,127,0}));
  connect(intRep.y, intEqu.u1)
    annotation (Line(points={{-118,170},{-80,170}}, color={255,127,0}));
  connect(lat.y, tim.u)
    annotation (Line(points={{-18,-130},{18,-130}}, color={255,0,255}));
  connect(conInt.y, intEqu.u2)
    annotation (Line(points={{-118,130},{-100,130},{-100,162},{-80,162}},
      color={255,127,0}));
  connect(lat1.y, and5.u2)
    annotation (Line(points={{42,-80},{60,-80},{60,-68},{118,-68}},
      color={255,0,255}));
  connect(uUpsDevSta, lat1.u) annotation (Line(points={{-200,-100},{-160,-100},{
          -160,-80},{18,-80}},  color={255,0,255}));
  connect(not1.y, truDel.u) annotation (Line(points={{-78,-170},{-42,-170}},
         color={255,0,255}));
  connect(truDel.y, lat1.clr) annotation (Line(points={{-18,-170},{0,-170},{0,-86},
          {18,-86}}, color={255,0,255}));
  connect(tim.passed, lat2.u) annotation (Line(points={{42,-138},{60,-138},{60,-164},
          {118,-164}}, color={255,0,255}));
  connect(truDel.y, lat2.clr) annotation (Line(points={{-18,-170},{118,-170}},
          color={255,0,255}));
  connect(u1ChiIsoOpe, opeVal.u)
    annotation (Line(points={{-200,30},{-162,30}}, color={255,0,255}));
  connect(u1ChiIsoClo, cloVal.u)
    annotation (Line(points={{-200,-30},{-162,-30}}, color={255,0,255}));
  connect(intEqu.y, booToRea.u)
    annotation (Line(points={{-56,170},{-22,170}}, color={255,0,255}));
  connect(uChi, booToRea1.u)
    annotation (Line(points={{-200,90},{-42,90}}, color={255,0,255}));
  connect(booToRea1.y, sub.u1) annotation (Line(points={{-18,90},{0,90},{0,126},
          {38,126}}, color={0,0,127}));
  connect(booToRea.y, sub.u2) annotation (Line(points={{2,170},{20,170},{20,114},
          {38,114}}, color={0,0,127}));
  connect(sub.y, abs1.u)
    annotation (Line(points={{62,120},{78,120}}, color={0,0,127}));
  connect(abs1.y, greThr.u)
    annotation (Line(points={{102,120},{118,120}}, color={0,0,127}));
  connect(greThr.y, y1ChiWatIsoVal)
    annotation (Line(points={{142,120},{200,120}}, color={255,0,255}));
  connect(opeVal.y, mulSum.u)
    annotation (Line(points={{-138,30},{-122,30}}, color={0,0,127}));
  connect(cloVal.y, mulSum1.u)
    annotation (Line(points={{-138,-30},{-122,-30}}, color={0,0,127}));
  connect(mulSum.y, triSam1.u)
    annotation (Line(points={{-98,30},{-42,30}}, color={0,0,127}));
  connect(mulSum1.y, triSam.u)
    annotation (Line(points={{-98,-30},{-42,-30}}, color={0,0,127}));
  connect(and2.y, triSam.trigger) annotation (Line(points={{-78,-100},{-60,-100},
          {-60,-50},{-30,-50},{-30,-42}}, color={255,0,255}));
  connect(and2.y, triSam1.trigger) annotation (Line(points={{-78,-100},{-60,-100},
          {-60,10},{-30,10},{-30,18}}, color={255,0,255}));
  connect(triSam1.y, sub1[1].u1) annotation (Line(points={{-18,30},{-10,30},{-10,
          6},{-2,6}}, color={0,0,127}));
  connect(triSam.y, sub1[2].u1) annotation (Line(points={{-18,-30},{-10,-30},{-10,
          6},{-2,6}}, color={0,0,127}));
  connect(mulSum.y, sub1[1].u2) annotation (Line(points={{-98,30},{-80,30},{-80,
          -6},{-2,-6}}, color={0,0,127}));
  connect(mulSum1.y, sub1[2].u2) annotation (Line(points={{-98,-30},{-80,-30},{-80,
          -6},{-2,-6}}, color={0,0,127}));
  connect(sub1.y, abs2.u)
    annotation (Line(points={{22,0},{38,0}}, color={0,0,127}));
  connect(abs2.y, greThr1.u)
    annotation (Line(points={{62,0},{78,0}}, color={0,0,127}));
  connect(greThr1.y, enaIsoVal.u)
    annotation (Line(points={{102,0},{118,0}}, color={255,0,255}));
  connect(enaIsoVal.y, and5.u1) annotation (Line(points={{142,0},{150,0},{150,-30},
          {60,-30},{60,-60},{118,-60}}, color={255,0,255}));
  connect(lat2.y, yEnaChiWatIsoVal) annotation (Line(points={{142,-164},{160,-164},
          {160,-110},{200,-110}}, color={255,0,255}));
  connect(and5.y, yEnaChiWatIsoVal) annotation (Line(points={{142,-60},{160,-60},
          {160,-110},{200,-110}}, color={255,0,255}));
annotation (
  defaultComponentName="enaChiIsoVal",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-180,-200},{180,200}})),
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
          textString="y1EnaChiWatIsoVal"),
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
chilled water isolation valve position command. <code>y1EnaChiWatIsoVal</code> 
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
end CHWIsoVal_New;
