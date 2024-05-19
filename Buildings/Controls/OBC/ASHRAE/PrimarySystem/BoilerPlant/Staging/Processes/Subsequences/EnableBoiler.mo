within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences;
block EnableBoiler
    "Sequence for enabling boiler"

  parameter Integer nBoi = 3
    "Total number of boilers";

  parameter Real proOnTim(
    final unit="s",
    final quantity="Time",
    displayUnit="s") = 300
    "Enabled boiler operation time to indicate if it is proven on";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp
    "Continuous stage-up command until change process is completed"
    annotation (Placement(transformation(extent={{-240,40},{-200,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Status of upstream device: true=upstream device is proved functional"
    annotation (Placement(transformation(extent={{-240,10},{-200,50}}),
        iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoi[nBoi]
    "Boiler status: true=ON"
     annotation (Placement(transformation(extent={{-240,-20},{-200,20}}),
       iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Indicate if the stage require one boiler to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-240,-70},{-200,-30}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexDisBoi
    "Next disabling boiler when there is any stage up that need one boiler on and another off"
    annotation (Placement(transformation(extent={{-240,-170},{-200,-130}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexEnaBoi
    "Index of next enabling boiler"
    annotation (Placement(transformation(extent={{-240,100},{-200,140}}),
      iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yBoi[nBoi]
    "Boiler enabling status"
    annotation (Placement(transformation(extent={{200,-70},{240,-30}}),
      iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yBoiEnaPro
    "True signal when the boiler enabling process has been completed"
    annotation (Placement(transformation(extent={{200,-190},{240,-150}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

protected
  final parameter Integer boiInd[nBoi]={i for i in 1:nBoi}
    "Boiler index, {1,2,...,n}";

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nBoi]
    "Logical switch"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical And"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nBoi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));

  Buildings.Controls.OBC.CDL.Logical.And and1[nBoi]
    "Logical and"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nBoi](
    final k=fill(true, nBoi))
    "True constant"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nBoi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greEquThr[nBoi](
    final t=fill(0.5, nBoi))
    "Check boilers that are on"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1[nBoi]
    "Logical switch"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));

  Buildings.Controls.OBC.CDL.Logical.And and3[nBoi]
    "Logical and"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nBoi](
    final k=fill(false, nBoi))
    "False constant"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi2[nBoi]
    "Logical switch"
    annotation (Placement(transformation(extent={{160,-60},{180,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Logical or"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=nBoi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-160,110},{-140,130}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nBoi]
    "Check next enabling boiler"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=proOnTim)
    "Count the time after new boiler has been enabled"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nBoi]
    "Record the old boiler status"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nBoi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(
    final nout=nBoi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep3(
    final nout=nBoi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nBoi](
    final k=boiInd)
    "Boiler index array"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep1(
    final nout=nBoi)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nBoi]
    "Check next enabling boiler"
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi3[nBoi]
    "Logical switch"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator  booRep4(
    final nout=nBoi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi4
    "Logical switch"
    annotation (Placement(transformation(extent={{120,-180},{140,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Xor xor[nBoi]
    "Boolean Exclusive Or"
    annotation (Placement(transformation(extent={{-68,-230},{-48,-210}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3[nBoi]
    "Logical Not"
    annotation (Placement(transformation(extent={{-20,-230},{0,-210}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nin=nBoi+1)
    "Multi-input Logical And"
    annotation (Placement(transformation(extent={{52,-230},{72,-210}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1[nBoi] "Logical pre block"
    annotation (Placement(transformation(extent={{-160,-240},{-140,-220}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2
    "Logical pre block"
    annotation (Placement(transformation(extent={{20,-210},{40,-190}})));

equation
  connect(nexEnaBoi, intRep.u)
    annotation (Line(points={{-220,120},{-162,120}}, color={255,127,0}));

  connect(intRep.y,intEqu. u1)
    annotation (Line(points={{-138,120},{-102,120}}, color={255,127,0}));

  connect(uUpsDevSta, and2.u2) annotation (Line(points={{-220,30},{-180,30},{-180,
          52},{-162,52}}, color={255,0,255}));

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

  connect(uBoi,booToRea. u)
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

  connect(uBoi,logSwi1. u3)
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

  connect(logSwi2.y,yBoi)
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

  connect(nexDisBoi, intRep1.u)
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

  connect(uBoi, logSwi3.u3)
    annotation (Line(points={{-220,0},{-180,0},{-180,20},{40,20},{40,32},
      {58,32}}, color={255,0,255}));

  connect(greEquThr.y, logSwi3.u1)
    annotation (Line(points={{42,0},{50,0},{50,48},{58,48}}, color={255,0,255}));

  connect(logSwi3.y, logSwi.u3)
    annotation (Line(points={{82,40},{90,40},{90,112},{98,112}},
      color={255,0,255}));

  connect(not2.y, logSwi4.u2)
    annotation (Line(points={{-138,-50},{-130,-50},{-130,-170},{118,-170}},
      color={255,0,255}));

  connect(logSwi4.y, yBoiEnaPro)
    annotation (Line(points={{142,-170},{220,-170}}, color={255,0,255}));

  connect(tim.passed, booRep2.u) annotation (Line(points={{-78,-118},{-32,-118},
          {-32,-110},{-22,-110}}, color={255,0,255}));
  connect(tim.passed, logSwi4.u3) annotation (Line(points={{-78,-118},{-32,-118},
          {-32,-178},{118,-178}}, color={255,0,255}));
  connect(tim.passed, not1.u) annotation (Line(points={{-78,-118},{-32,-118},{-32,
          -70},{-22,-70}}, color={255,0,255}));
  connect(xor.y, not3.u)
    annotation (Line(points={{-46,-220},{-22,-220}},   color={255,0,255}));
  connect(uBoi, xor.u1) annotation (Line(points={{-220,0},{-180,0},{-180,-200},{
          -130,-200},{-130,-220},{-70,-220}},
                       color={255,0,255}));
  connect(not3.y, mulAnd.u[1:nBoi]) annotation (Line(points={{2,-220},{50,-220}},
                                        color={255,0,255}));
  connect(mulAnd.y, logSwi4.u1) annotation (Line(points={{74,-220},{100,-220},{100,
          -162},{118,-162}},     color={255,0,255}));
  connect(logSwi2.y, pre1.u) annotation (Line(points={{182,-50},{190,-50},{190,-250},
          {-180,-250},{-180,-230},{-162,-230}}, color={255,0,255}));
  connect(pre1.y, xor.u2) annotation (Line(points={{-138,-230},{-100,-230},{-100,
          -228},{-70,-228}}, color={255,0,255}));
  connect(and2.y, pre2.u) annotation (Line(points={{-138,60},{-120,60},{-120,-200},
          {18,-200}}, color={255,0,255}));
  connect(pre2.y, mulAnd.u[nBoi+1]) annotation (Line(points={{42,-200},{46,-200},{46,
          -220},{50,-220}}, color={255,0,255}));
annotation (
  defaultComponentName="enaBoi",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                    graphics={
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
          textString="nexEnaBoi"),
        Text(
          extent={{-98,-84},{-50,-96}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="nexDisBoi"),
        Text(
          extent={{-100,66},{-68,56}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uStaUp"),
        Text(
          extent={{-98,26},{-34,14}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uUpsDevSta"),
        Text(
          extent={{-100,-14},{-78,-24}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uBoi"),
        Text(
          extent={{-98,-54},{-72,-66}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOnOff"),
        Text(
          extent={{74,86},{100,76}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yBoi"),
        Text(
          extent={{60,-72},{98,-84}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yNewBoiEna")}),
        Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-200,-260},{200,180}}),
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
          extent={{20,158},{100,150}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Output new boiler status array:\n1. When the stage change does not require one boiler off and another boiler on.\n2. When the stage change does require one boiler off and another boiler on,\n    but the enabled boiler has not yet finished starting."),
          Text(
          extent={{34,-140},{114,-148}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Output new boiler status array:\nWhen the stage change does require one boiler off and another boiler on,\nand the enabled boiler has finished starting.")}),
Documentation(info="<html>
<p>
Block that controls boiler when there is staging up command <code>uStaUp=true</code>.
This implementation is based on RP-1711, March 2020 draft, sections 5.3.3.11,
5.3.3.13, 5.3.3.14 and 5.3.3.15. These sections specify when the next boiler should be enabled
and when the running smaller boiler should be diabled.
</p>
<p>
When the stage-up process does not requires a smaller boiler being staged off and
a larger boiler being staged on (<code>uOnOff=false</code>):
</p>
<ul>
<li>
Start the next stage boiler after the upstream device is proved functional
<code>uUpsDevSta=true</code>.
</li>
</ul>
<p>
For any stage change during which a smaller boiler is diabled and a larger boiler
is enabled (<code>uOnOff=true</code>):
</p>
<ul>
<li>
Wait 5 minutes (<code>proOnTim</code>) for the newly enabled boiler to prove that it is 
operating correctly, then shut off the smaller boiler.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
July 08, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableBoiler;
