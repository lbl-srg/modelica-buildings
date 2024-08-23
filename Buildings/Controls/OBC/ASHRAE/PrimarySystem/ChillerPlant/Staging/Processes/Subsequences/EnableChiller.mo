within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block EnableChiller "Sequence for enabling chiller"

  parameter Integer nChi=2 "Total number of chillers";
  parameter Real proOnTim(
    final unit="s",
    final quantity="Time") = 300
    "Enabled chiller operation time to indicate if it is proven on";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexEnaChi
    "Index of next enabling chiller"
    annotation (Placement(transformation(extent={{-240,100},{-200,140}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp
    "Stage-up command"
    annotation (Placement(transformation(extent={{-240,40},{-200,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaChiWatIsoVal
    "Status of chilled water isolation valve control: true=enabled valve is fully open"
    annotation (Placement(transformation(extent={{-240,10},{-200,50}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
     annotation (Placement(transformation(extent={{-240,-20},{-200,20}}),
       iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Indicate if the stage require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-240,-70},{-200,-30}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexDisChi
    "Next disabling chiller when there is any stage up that need one chiller on and another off"
    annotation (Placement(transformation(extent={{-240,-170},{-200,-130}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller enabling status"
    annotation (Placement(transformation(extent={{200,-70},{240,-30}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yNewChiEna
    "Newly enabled chiller has been proven on by more than 5 minutes"
    annotation (Placement(transformation(extent={{200,-190},{240,-150}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

protected
  final parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "In staging up process and the chilled water isolation valve has open"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Logical.And and1[nChi] "Logical and"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nChi](
    final k=fill(true, nChi)) "True constant"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greEquThr[nChi](
    final t=fill(0.5, nChi))
    "Convert real input to boolean output"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  Buildings.Controls.OBC.CDL.Logical.And and3[nChi] "Logical and"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nChi](
    final k=fill(false, nChi)) "False constant"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi2[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{160,-60},{180,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical or"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(final nout=nChi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-160,110},{-140,130}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nChi]
    "Check next enabling isolation valve"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(final t=proOnTim)
    "Count the time after new chiller has been enabled"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nChi]
    "Record the old chiller status"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep3(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nChi](
    final k=chiInd) "Chiller index array"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep1(
    final nout=nChi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nChi]
    "Check next enabling isolation valve"
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi3[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator  booRep4(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi4 "Logical switch"
    annotation (Placement(transformation(extent={{160,-180},{180,-160}})));

equation
  connect(nexEnaChi, intRep.u)
    annotation (Line(points={{-220,120},{-162,120}}, color={255,127,0}));
  connect(intRep.y,intEqu. u1)
    annotation (Line(points={{-138,120},{-102,120}}, color={255,127,0}));
  connect(uEnaChiWatIsoVal,and2. u2)
    annotation (Line(points={{-220,30},{-180,30},{-180,52},{-162,52}},
      color={255,0,255}));
  connect(uStaUp, and2.u1)
    annotation (Line(points={{-220,60},{-162,60}}, color={255,0,255}));
  connect(and2.y,booRep. u)
    annotation (Line(points={{-138,60},{-102,60}}, color={255,0,255}));
  connect(intEqu.y,and1. u1)
    annotation (Line(points={{-78,120},{-42,120}},  color={255,0,255}));
  connect(booRep.y,and1. u2)
    annotation (Line(points={{-78,60},{-60,60},{-60,112},{-42,112}},
      color={255,0,255}));
  connect(and1.y,logSwi. u2)
    annotation (Line(points={{-18,120},{98,120}}, color={255,0,255}));
  connect(con.y,logSwi. u1)
    annotation (Line(points={{-18,150},{0,150},{0,128},{98,128}}, color={255,0,255}));
  connect(uChi,booToRea. u)
    annotation (Line(points={{-220,0},{-162,0}}, color={255,0,255}));
  connect(booToRea.y,triSam. u)
    annotation (Line(points={{-138,0},{-22,0}}, color={0,0,127}));
  connect(edg.y,booRep1. u)
    annotation (Line(points={{-78,-20},{-62,-20}}, color={255,0,255}));
  connect(booRep1.y,triSam. trigger)
    annotation (Line(points={{-38,-20},{-10,-20},{-10,-12}},   color={255,0,255}));
  connect(triSam.y,greEquThr. u)
    annotation (Line(points={{2,0},{18,0}}, color={0,0,127}));
  connect(and2.y,tim. u)
    annotation (Line(points={{-138,60},{-120,60},{-120,-110},{-102,-110}},
      color={255,0,255}));
  connect(booRep2.y,and3. u1)
    annotation (Line(points={{2,-110},{38,-110}}, color={255,0,255}));
  connect(and3.y,logSwi1. u2)
    annotation (Line(points={{62,-110},{98,-110}}, color={255,0,255}));
  connect(con1.y,logSwi1. u1)
    annotation (Line(points={{62,-80},{80,-80},{80,-102},{98,-102}},
      color={255,0,255}));
  connect(uChi,logSwi1. u3)
    annotation (Line(points={{-220,0},{-180,0},{-180,-130},{80,-130},{80,-118},
      {98,-118}}, color={255,0,255}));
  connect(booRep3.y,logSwi2. u2)
    annotation (Line(points={{102,-50},{158,-50}}, color={255,0,255}));
  connect(uOnOff,not2. u)
    annotation (Line(points={{-220,-50},{-162,-50}}, color={255,0,255}));
  connect(logSwi1.y,logSwi2. u3)
    annotation (Line(points={{122,-110},{140,-110},{140,-58},{158,-58}},
      color={255,0,255}));
  connect(logSwi.y,logSwi2. u1)
    annotation (Line(points={{122,120},{140,120},{140,-42},{158,-42}},
      color={255,0,255}));
  connect(logSwi2.y,yChi)
    annotation (Line(points={{182,-50},{220,-50}}, color={255,0,255}));
  connect(not2.y,or2. u1)
    annotation (Line(points={{-138,-50},{38,-50}},color={255,0,255}));
  connect(not1.y,or2. u2)
    annotation (Line(points={{2,-70},{20,-70},{20,-58},{38,-58}},
      color={255,0,255}));
  connect(or2.y,booRep3. u)
    annotation (Line(points={{62,-50},{78,-50}},color={255,0,255}));
  connect(conInt.y,intEqu. u2)
    annotation (Line(points={{-138,90},{-110,90},{-110,112},{-102,112}},
      color={255,127,0}));
  connect(nexDisChi, intRep1.u)
    annotation (Line(points={{-220,-150},{-162,-150}}, color={255,127,0}));
  connect(intRep1.y, intEqu1.u1)
    annotation (Line(points={{-138,-150},{-102,-150}}, color={255,127,0}));
  connect(conInt.y, intEqu1.u2)
    annotation (Line(points={{-138,90},{-110,90},{-110,-158},{-102,-158}},
      color={255,127,0}));
  connect(intEqu1.y, and3.u2)
    annotation (Line(points={{-78,-150},{20,-150},{20,-118},{38,-118}},
      color={255,0,255}));
  connect(uStaUp, edg.u)
    annotation (Line(points={{-220,60},{-190,60},{-190,-20},{-102,-20}},
      color={255,0,255}));
  connect(uStaUp, booRep4.u)
    annotation (Line(points={{-220,60},{-190,60},{-190,40},{-42,40}},
      color={255,0,255}));
  connect(booRep4.y, logSwi3.u2)
    annotation (Line(points={{-18,40},{58,40}}, color={255,0,255}));
  connect(uChi, logSwi3.u3)
    annotation (Line(points={{-220,0},{-180,0},{-180,20},{40,20},{40,32},
      {58,32}}, color={255,0,255}));
  connect(greEquThr.y, logSwi3.u1)
    annotation (Line(points={{42,0},{50,0},{50,48},{58,48}}, color={255,0,255}));
  connect(logSwi3.y, logSwi.u3)
    annotation (Line(points={{82,40},{90,40},{90,112},{98,112}},
      color={255,0,255}));
  connect(not2.y, logSwi4.u2)
    annotation (Line(points={{-138,-50},{-130,-50},{-130,-170},{158,-170}},
      color={255,0,255}));
  connect(and2.y, logSwi4.u1)
    annotation (Line(points={{-138,60},{-120,60},{-120,-162},{158,-162}},
      color={255,0,255}));
  connect(logSwi4.y, yNewChiEna)
    annotation (Line(points={{182,-170},{220,-170}}, color={255,0,255}));
  connect(tim.passed, not1.u)
    annotation (Line(points={{-78,-118},{-40,-118},{-40,-70},{-22,-70}},
      color={255,0,255}));
  connect(tim.passed, booRep2.u)
    annotation (Line(points={{-78,-118},{-40,-118},{-40,-110},{-22,-110}},
      color={255,0,255}));
  connect(tim.passed, logSwi4.u3)
    annotation (Line(points={{-78,-118},{-40,-118},{-40,-178},{158,-178}},
      color={255,0,255}));

annotation (
  defaultComponentName="enaChi",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-60,60},{60,20}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-52,20},{-40,0}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,20},{52,0}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,0},{60,-80}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,96},{-50,84}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="nexEnaChi"),
        Text(
          extent={{-98,-84},{-50,-96}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="nexDisChi"),
        Text(
          extent={{-100,66},{-68,56}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uStaUp"),
        Text(
          extent={{-98,26},{-34,14}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uEnaChiWatIsoVal"),
        Text(
          extent={{-100,-14},{-78,-24}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChi"),
        Text(
          extent={{-98,-54},{-72,-66}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOnOff"),
        Text(
          extent={{74,86},{100,76}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yChi"),
        Text(
          extent={{60,-72},{98,-84}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yNewChiEna")}),                            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-180},{200,180}}),
        graphics={
          Rectangle(
          extent={{-198,-62},{198,-178}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Rectangle(
          extent={{-198,178},{198,-38}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{14,174},{94,166}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Output new chiller status array:"),
          Text(
          extent={{40,-72},{120,-88}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Disable 
small chiller"),
          Text(
          extent={{16,168},{208,148}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString=
              "1. When the stage change does not require one chiller off and another chiller on."),
          Text(
          extent={{16,154},{208,136}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="2. When the stage change does require one chiller off and another chiller on, 
but the enabled chiller has not yet finished starting."),
          Text(
          extent={{-24,-132},{56,-140}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Output new chiller status array:"),
          Text(
          extent={{-20,-142},{152,-158}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="When the stage change does require one chiller off
and another chiller on, and the enabled chiller has finished starting.")}),
Documentation(info="<html>
<p>
Block that controlles chiller when there is staging up command <code>uStaUp=true</code>.
This implementation is based on ASHRAE Guideline36-2021, section 5.20.4.16,
item f and item g.1. These sections specify when the next chiller should be enabled
and when the running smaller chiller should be diabled.
</p>
<p>
When the stage-up process does not requires a smaller chiller being staged off and
a larger chiller being staged on (<code>uOnOff=false</code>):
</p>
<ul>
<li>
Start the next stage chiller after the chilled water isolation valve is fully open
<code>uEnaChiWatIsoVal=true</code>.
</li>
</ul>
<p>
For any stage change during which a smaller chiller is diabled and a larger chiller
is enabled (<code>uOnOff=true</code>):
</p>
<ul>
<li>
Wait 5 minutes (<code>proOnTim</code>) for the newly enabled chiller to prove that is 
operating correctly <code>yNewChiEna=true</code>, then shut off the smaller chiller.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 15, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableChiller;
