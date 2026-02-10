within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Staging.Processes.Subsequences;
block CHWIsoVal "Sequence of enable or disable chilled water isolation valve"

  parameter Integer nChi=2
    "Total number of chiller, which is also the total number of chilled water isolation valve";
  parameter Real chaChiWatIsoTim(
    final unit="s",
    final quantity="Time")
    "Time to slowly change isolation valve, should be determined in the field";
  parameter Real iniValPos
    "Initial valve position, if it needs to turn on chiller, the value should be 0";
  parameter Real endValPos
    "Ending valve position, if it needs to turn on chiller, the value should be 1";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexChaChi
    "Index of next chiller that should change status"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    final unit=fill("1", nChi),
    final min=fill(0, nChi),
    final max=fill(1, nChi)) "Chilled water isolation valve position"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of resetting status of device before enabling or disabling isolation valve"
    annotation (Placement(transformation(extent={{-200,-160},{-160,-120}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaPro
    "Indicate if there is a stage up or stage down command"
    annotation (Placement(transformation(extent={{-200,-200},{-160,-160}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoVal[nChi](
    final unit=fill("1", nChi),
    final min=fill(0, nChi),
    final max=fill(1, nChi)) "Chiller chilled water isolation valve position"
    annotation (Placement(transformation(extent={{180,-60},{220,-20}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEnaChiWatIsoVal
    "Status of chilled water isolation valve control: true=enabled valve is fully open"
    annotation (Placement(transformation(extent={{180,120},{220,160}}),
      iconTransformation(extent={{100,40},{140,80}})));

protected
  final parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con7(
    final k=chaChiWatIsoTim) "Time to change chilled water isolation valve"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con8(
    final k=endValPos)
    "Ending valve position"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con6(
    final k=iniValPos)
    "Initial isolation valve position"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con9(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin1
    "Chilled water isolation valve setpoint"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=chaChiWatIsoTim)
    "Count the time after changing up-stream device status"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{20,-190},{40,-170}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nChi]
    "Record the old chiller chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{20,-150},{40,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if it is time to change isolation valve position"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-40,-196},{-20,-176}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,-190},{80,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[nChi] "Logical not"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nChi]
    "Check next enabling isolation valve"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=nChi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=nChi)
    "Replicate real input"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys3[nChi](
    final uLow=fill(0.025, nChi),
    final uHigh=fill(0.05, nChi)) "Check if isolation valve is enabled"
    annotation (Placement(transformation(extent={{-120,210},{-100,230}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys4[nChi](
    final uLow=fill(0.925, nChi),
    final uHigh=fill(0.975, nChi)) "Check if isolation valve is open more than 95%"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3[nChi] "Logical not"
    annotation (Placement(transformation(extent={{-60,180},{-40,200}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4[nChi] "Logical not"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  Buildings.Controls.OBC.CDL.Logical.And and4[nChi] "Logical and"
    annotation (Placement(transformation(extent={{-20,180},{0,200}})));
  Buildings.Controls.OBC.CDL.Logical.And and3[nChi] "Logical and"
    annotation (Placement(transformation(extent={{-20,210},{0,230}})));
  Buildings.Controls.OBC.CDL.Logical.Or  or2[nChi] "Logicla or"
    annotation (Placement(transformation(extent={{20,210},{40,230}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd1(
    final nin=nChi)
    "Logical and"
    annotation (Placement(transformation(extent={{60,210},{80,230}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Check if the isolation valve has been fully open"
    annotation (Placement(transformation(extent={{100,130},{120,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nChi](
    final k=chiInd) "Chiller index array"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "Logical latch, maintain ON signal until condition changes"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=5) "Delay the true input"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Logical and"
    annotation (Placement(transformation(extent={{140,130},{160,150}})));

equation
  connect(uChiWatIsoVal, triSam.u)
    annotation (Line(points={{-180,-100},{-82,-100}}, color={0,0,127}));
  connect(con9.y, lin1.x1)
    annotation (Line(points={{22,80},{30,80},{30,68},{38,68}},
      color={0,0,127}));
  connect(con6.y, lin1.f1)
    annotation (Line(points={{-18,80},{-10,80},{-10,64},{38,64}},
      color={0,0,127}));
  connect(con7.y, lin1.x2)
    annotation (Line(points={{-18,30},{-10,30},{-10,56},{38,56}},
      color={0,0,127}));
  connect(con8.y, lin1.f2)
    annotation (Line(points={{22,30},{30,30},{30,52},{38,52}}, color={0,0,127}));
  connect(tim.y, lin1.u)
    annotation (Line(points={{-78,60},{38,60}}, color={0,0,127}));
  connect(uUpsDevSta, edg.u)
    annotation (Line(points={{-180,-140},{-102,-140}}, color={255,0,255}));
  connect(uStaPro, and2.u2)
    annotation (Line(points={{-180,-180},{-60,-180},{-60,-148},{-42,-148}},
          color={255,0,255}));
  connect(edg.y, and2.u1)
    annotation (Line(points={{-78,-140},{-42,-140}}, color={255,0,255}));
  connect(and2.y, lat.u)
    annotation (Line(points={{-18,-140},{0,-140},{0,-180},{18,-180}},
          color={255,0,255}));
  connect(uStaPro, not1.u) annotation (Line(points={{-180,-180},{-60,-180},{-60,
          -186},{-42,-186}}, color={255,0,255}));
  connect(not1.y, lat.clr)
    annotation (Line(points={{-18,-186},{18,-186}},
      color={255,0,255}));
  connect(lat.y, booRep1.u)
    annotation (Line(points={{42,-180},{58,-180}}, color={255,0,255}));
  connect(booRep1.y, swi.u2)
    annotation (Line(points={{82,-180},{100,-180},{100,-40},{118,-40}},
      color={255,0,255}));
  connect(swi.y, yChiWatIsoVal)
    annotation (Line(points={{142,-40},{200,-40}}, color={0,0,127}));
  connect(booRep.y, triSam.trigger)
    annotation (Line(points={{42,-140},{60,-140},{60,-120},{-70,-120},{-70,-112}},
      color={255,0,255}));
  connect(and2.y, booRep.u)
    annotation (Line(points={{-18,-140},{18,-140}},
      color={255,0,255}));
  connect(booRep1.y, not2.u)
    annotation (Line(points={{82,-180},{100,-180},{100,-110},{-40,-110},{-40,
          -80},{-22,-80}}, color={255,0,255}));
  connect(not2.y, swi1.u2)
    annotation (Line(points={{2,-80},{20,-80},{20,-60},{58,-60}},
      color={255,0,255}));
  connect(triSam.y, swi1.u3)
    annotation (Line(points={{-58,-100},{40,-100},{40,-68},{58,-68}},
      color={0,0,127}));
  connect(swi1.y, swi.u3)
    annotation (Line(points={{82,-60},{110,-60},{110,-48},{118,-48}},
      color={0,0,127}));
  connect(uChiWatIsoVal, swi1.u1)
    annotation (Line(points={{-180,-100},{-140,-100},{-140,-52},{58,-52}},
      color={0,0,127}));
  connect(swi2.y, swi.u1)
    annotation (Line(points={{82,0},{100,0},{100,-32},{118,-32}},
      color={0,0,127}));
  connect(nexChaChi, intRep.u)
    annotation (Line(points={{-180,0},{-82,0}}, color={255,127,0}));
  connect(intRep.y, intEqu.u1)
    annotation (Line(points={{-58,0},{-22,0}}, color={255,127,0}));
  connect(intEqu.y, swi2.u2)
    annotation (Line(points={{2,0},{58,0}}, color={255,0,255}));
  connect(lin1.y, reaRep.u)
    annotation (Line(points={{62,60},{78,60}}, color={0,0,127}));
  connect(lat.y, tim.u)
    annotation (Line(points={{42,-180},{50,-180},{50,-220},{-110,-220},{-110,60},
          {-102,60}}, color={255,0,255}));
  connect(reaRep.y, swi2.u1)
    annotation (Line(points={{102,60},{120,60},{120,30},{40,30},{40,8},{58,8}},
      color={0,0,127}));
  connect(triSam.y, swi2.u3)
    annotation (Line(points={{-58,-100},{40,-100},{40,-8},{58,-8}},
      color={0,0,127}));
  connect(uChiWatIsoVal, hys4.u)
    annotation (Line(points={{-180,-100},{-140,-100},{-140,160},{-122,160}},
      color={0,0,127}));
  connect(uChiWatIsoVal, hys3.u)
    annotation (Line(points={{-180,-100},{-140,-100},{-140,220},{-122,220}},
      color={0,0,127}));
  connect(hys3.y, and3.u1)
    annotation (Line(points={{-98,220},{-22,220}},color={255,0,255}));
  connect(hys4.y, and3.u2)
    annotation (Line(points={{-98,160},{-80,160},{-80,212},{-22,212}},
      color={255,0,255}));
  connect(hys4.y, not4.u)
    annotation (Line(points={{-98,160},{-62,160}}, color={255,0,255}));
  connect(hys3.y, not3.u)
    annotation (Line(points={{-98,220},{-70,220},{-70,190},{-62,190}},
      color={255,0,255}));
  connect(not4.y, and4.u2)
    annotation (Line(points={{-38,160},{-32,160},{-32,182},{-22,182}},
      color={255,0,255}));
  connect(not3.y, and4.u1)
    annotation (Line(points={{-38,190},{-22,190}},color={255,0,255}));
  connect(and3.y, or2.u1)
    annotation (Line(points={{2,220},{18,220}},  color={255,0,255}));
  connect(and4.y, or2.u2)
    annotation (Line(points={{2,190},{10,190},{10,212},{18,212}},
      color={255,0,255}));
  connect(mulAnd1.y, and5.u1)
    annotation (Line(points={{82,220},{90,220},{90,140},{98,140}},
      color={255,0,255}));
  connect(or2.y, mulAnd1.u)
    annotation (Line(points={{42,220},{58,220}}, color={255,0,255}));
  connect(conInt.y, intEqu.u2)
    annotation (Line(points={{-58,-30},{-40,-30},{-40,-8},{-22,-8}},
      color={255,127,0}));
  connect(lat1.y, and5.u2)
    annotation (Line(points={{22,140},{80,140},{80,132},{98,132}},
      color={255,0,255}));
  connect(uUpsDevSta, lat1.u) annotation (Line(points={{-180,-140},{-130,-140},
          {-130,140},{-2,140}}, color={255,0,255}));
  connect(not1.y, truDel.u) annotation (Line(points={{-18,-186},{0,-186},{0,
          -230},{-120,-230},{-120,100},{-102,100}}, color={255,0,255}));
  connect(truDel.y, lat1.clr) annotation (Line(points={{-78,100},{-70,100},{-70,
          134},{-2,134}},  color={255,0,255}));
  connect(tim.passed, lat2.u) annotation (Line(points={{-78,52},{-60,52},{-60,
          110},{-42,110}}, color={255,0,255}));
  connect(truDel.y, lat2.clr) annotation (Line(points={{-78,100},{-70,100},{-70,
          104},{-42,104}}, color={255,0,255}));
  connect(and5.y, and1.u1)
    annotation (Line(points={{122,140},{138,140}}, color={255,0,255}));
  connect(and1.y, yEnaChiWatIsoVal)
    annotation (Line(points={{162,140},{200,140}}, color={255,0,255}));
  connect(lat2.y, and1.u2) annotation (Line(points={{-18,110},{130,110},{130,
          132},{138,132}}, color={255,0,255}));
annotation (
  defaultComponentName="enaChiIsoVal",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-240},{180,240}}),
          graphics={
          Rectangle(
          extent={{-158,238},{178,122}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-38,184},{172,150}},
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Check if all enabled CHW isolation valves 
have been fully open")}),
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-96,-74},{-60,-86}},
          textColor={255,0,255},
          textString="uStaPro"),
        Text(
          extent={{-96,-42},{-46,-56}},
          textColor={255,0,255},
          textString="uUpsDevSta"),
        Text(
          extent={{-96,86},{-48,74}},
          textColor={255,127,0},
          textString="nexChaChi"),
        Text(
          extent={{-96,58},{-42,46}},
          textColor={0,0,127},
          textString="uChiWatIsoVal"),
        Text(
          extent={{32,70},{96,54}},
          textColor={255,0,255},
          textString="yEnaChiWatIsoVal"),
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
by <code>nexChaChi</code> will be enabled (<code>iniValPos=0</code>, 
<code>endValPos=1</code>). 
</li>
<li>
When there is the stage down command (<code>uStaPro=true</code>) and the disabling chiller 
(<code>nexChaChi</code>) has been shut off (<code>uUpsDevSta=true</code>),
the chiller's isolation valve will be disabled (<code>iniValPos=1</code>, 
<code>endValPos=0</code>). 
</li>
</ul>
<p>
The valve should open or close slowly. For example, this could be accomplished by 
resetting the valve position X /seconds, where X = (<code>endValPos</code> - 
<code>iniValPos</code>) / <code>chaChiWatIsoTim</code>.
The valve time <code>chaChiWatIsoTim</code> should be determined in the field. 
</p>
<p>
This sequence will generate array <code>yChiWatIsoVal</code>, which indicates 
chilled water isolation valve position setpoint. <code>yEnaChiWatIsoVal</code> 
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
