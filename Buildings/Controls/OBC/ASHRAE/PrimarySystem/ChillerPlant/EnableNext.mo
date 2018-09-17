within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block EnableNext "Sequence to enable next device"
  parameter Integer num = 2
    "Total number of devices";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaNex
    "Enable next device"
    annotation (Placement(transformation(extent={{-300,-240},{-260,-200}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDevSta[num]
    "Current devices operation status"
    annotation (Placement(transformation(extent={{-300,140},{-260,180}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDevSta[num]
    "Devices status after enabling one more device"
    annotation (Placement(transformation(extent={{260,-230},{280,-210}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(final k=num)
    "Number of devices, typically the same number of chillers"
    annotation (Placement(transformation(extent={{-240,230},{-220,250}})));
  Buildings.Controls.OBC.CDL.Integers.Equal twoDev
    "Check if it has two devices"
    annotation (Placement(transformation(extent={{-180,210},{-160,230}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(final k=2)
    "Constant number"
    annotation (Placement(transformation(extent={{-240,190},{-220,210}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[num]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-220,150},{-200,170}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(final nin=num)
    "Total number of operating devices"
    annotation (Placement(transformation(extent={{-180,150},{-160,170}})));
  Buildings.Controls.OBC.CDL.Integers.Equal zerOpeDev
    "Zero device is enabled"
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
  Buildings.Controls.OBC.CDL.Integers.Equal oneOpeDev
    "One device is enabled"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(final k=0)
    "Constant number"
    annotation (Placement(transformation(extent={{-160,110},{-140,130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(final k=1)
    "Constant number"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con5[num](
    final k={true,false}) if num==2
    "Logical constant"
    annotation (Placement(transformation(extent={{80,220},{100,240}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con6[num](
    final k={true,true}) if num==2
    "Logical constant"
    annotation (Placement(transformation(extent={{80,160},{100,180}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 if num==2
    "Total two devices and no device is enabled"
    annotation (Placement(transformation(extent={{40,190},{60,210}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi[num] if num==2
    "Logical switch"
    annotation (Placement(transformation(extent={{160,190},{180,210}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=num) if num==2
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{80,190},{100,210}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 if num==3
    "Total three devices and no device is enabled"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep2(
    final nout=num) if num==3
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con7[num](
    final k={true,false,false}) if num==3
    "Logical constant"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi1[num] if num==3
    "Logical switch"
    annotation (Placement(transformation(extent={{160,80},{180,100}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 if num==3
    "Total three devices and one device is enabled"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con8[num](
    final k={true,false,false}) if num==3
    "Logical constant"
    annotation (Placement(transformation(extent={{-220,-40},{-200,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con9[num](
    final k={false,true,false}) if num==3
    "Logical constant"
    annotation (Placement(transformation(extent={{-220,-130},{-200,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[num] if num==3 "Logical not"
    annotation (Placement(transformation(extent={{-180,-40},{-160,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3[num] if num==3 "Logical not"
    annotation (Placement(transformation(extent={{-180,-130},{-160,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And and4[num] if num==3 "Logical and"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And and5[num] if num==3 "Logical and"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And and7[num] if num==3 "Logical and"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Logical.And and8[num] if num==3 "Logical and"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2[num] if num==3 "Logical or"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd1(
    final nu=num) if num==3
    "Check if current devices status vector is {true, false, false}"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1[num] if num==3 "Logical or"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd2(
    final nu=num) if num==3
    "Check if current device status vector is {false, true, false}"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con11[num](
    final k={true,true,false}) if num==3
    "Logical constant"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con12[num](
    final k={false,true,true}) if num==3
    "Logical constant"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con13[num](
    final k={true,false,true}) if num==3
    "Logical constant"
    annotation (Placement(transformation(extent={{60,-140},{80,-120}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi2[num] if num==3
    "Logical switch"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi3[num] if num==3
    "Logical switch"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep3(
    final nout=num) if num==3
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep4(
    final nout=num) if num==3
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{20,-120},{40,-100}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi4[num] if num==3
    "Logical switch"
    annotation (Placement(transformation(extent={{160,30},{180,50}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep5(
    final nout=num) if num==3
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con10[num](
    final k={true,true,true}) if num==3
    "Logical constant"
    annotation (Placement(transformation(extent={{100,-200},{120,-180}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi5 "Logical switch"
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con14(final k=true)
    "Logical constant"
    annotation (Placement(transformation(extent={{-140,230},{-120,250}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con15(final k=false)
    "Logical constant"
    annotation (Placement(transformation(extent={{-140,190},{-120,210}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 if num==3 "Logical not"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5[num] if num==3 "Logical not"
    annotation (Placement(transformation(extent={{-220,30},{-200,50}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi6[num]
    "Logical switch"
    annotation (Placement(transformation(extent={{220,-230},{240,-210}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(nout=num)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-200,-230},{-180,-210}})));

equation
  connect(conInt2.y,twoDev. u2)
    annotation (Line(points={{-219,200},{-200,200},{-200,212},{-182,212}},
      color={255,127,0}));
  connect(conInt1.y,twoDev. u1)
    annotation (Line(points={{-219,240},{-200,240},{-200,220},{-182,220}},
      color={255,127,0}));
  connect(uDevSta, booToInt.u)
    annotation (Line(points={{-280,160},{-222,160}}, color={255,0,255}));
  connect(booToInt.y, mulSumInt.u)
    annotation (Line(points={{-199,160},{-182,160}}, color={255,127,0}));
  connect(mulSumInt.y, zerOpeDev.u1)
    annotation (Line(points={{-158.3,160},{-82,160}}, color={255,127,0}));
  connect(mulSumInt.y, oneOpeDev.u1)
    annotation (Line(points={{-158.3,160},{-100,160},{-100,90},{-82,90}},
      color={255,127,0}));
  connect(conInt5.y, oneOpeDev.u2)
    annotation (Line(points={{-139,80},{-100,80},{-100,82},{-82,82}},
      color={255,127,0}));
  connect(conInt4.y, zerOpeDev.u2)
    annotation (Line(points={{-139,120},{-120,120},{-120,152},{-82,152}},
      color={255,127,0}));
  connect(zerOpeDev.y, and2.u2)
    annotation (Line(points={{-59,160},{-30,160},{-30,192},{38,192}},
      color={255,0,255}));
  connect(and2.y, booRep.u)
    annotation (Line(points={{61,200},{78,200}}, color={255,0,255}));
  connect(booRep.y, logSwi.u2)
    annotation (Line(points={{101,200},{158,200}}, color={255,0,255}));
  connect(con5.y, logSwi.u1)
    annotation (Line(points={{101,230},{140,230},{140,208},{158,208}},
      color={255,0,255}));
  connect(con6.y, logSwi.u3)
    annotation (Line(points={{101,170},{140,170},{140,192},{158,192}},
      color={255,0,255}));
  connect(zerOpeDev.y, and1.u2)
    annotation (Line(points={{-59,160},{-30,160},{-30,82},{38,82}},
      color={255,0,255}));
  connect(and1.y, booRep2.u)
    annotation (Line(points={{61,90},{78,90}}, color={255,0,255}));
  connect(con7.y, logSwi1.u1)
    annotation (Line(points={{101,120},{140,120},{140,98},{158,98}},
      color={255,0,255}));
  connect(booRep2.y, logSwi1.u2)
    annotation (Line(points={{101,90},{158,90}}, color={255,0,255}));
  connect(oneOpeDev.y, and3.u2)
    annotation (Line(points={{-59,90},{-40,90},{-40,32},{38,32}},
      color={255,0,255}));
  connect(con8.y, not2.u)
    annotation (Line(points={{-199,-30},{-182,-30}}, color={255,0,255}));
  connect(con9.y, not3.u)
    annotation (Line(points={{-199,-120},{-182,-120}}, color={255,0,255}));
  connect(not2.y, and4.u2)
    annotation (Line(points={{-159,-30},{-140,-30},{-140,-38},{-102,-38}},
      color={255,0,255}));
  connect(con8.y, and7.u2)
    annotation (Line(points={{-199,-30},{-190,-30},{-190,-8},{-102,-8}},
      color={255,0,255}));
  connect(con9.y, and8.u2)
    annotation (Line(points={{-199,-120},{-190,-120},{-190,-98},{-102,-98}},
      color={255,0,255}));
  connect(not3.y, and5.u2)
    annotation (Line(points={{-159,-120},{-140,-120},{-140,-128},{-102,-128}},
      color={255,0,255}));
  connect(and7.y, or2.u1)
    annotation (Line(points={{-79,0},{-70,0},{-70,-20},{-62,-20}}, color={255,0,255}));
  connect(and4.y, or2.u2)
    annotation (Line(points={{-79,-30},{-70,-30},{-70,-28},{-62,-28}},
      color={255,0,255}));
  connect(and8.y, or1.u1)
    annotation (Line(points={{-79,-90},{-70,-90},{-70,-110},{-62,-110}},
      color={255,0,255}));
  connect(and5.y, or1.u2)
    annotation (Line(points={{-79,-120},{-70,-120},{-70,-118},{-62,-118}},
      color={255,0,255}));
  connect(or2.y, mulAnd1.u)
    annotation (Line(points={{-39,-20},{-22,-20}}, color={255,0,255}));
  connect(or1.y, mulAnd2.u)
    annotation (Line(points={{-39,-110},{-22,-110}}, color={255,0,255}));
  connect(con11.y, logSwi2.u1)
    annotation (Line(points={{81,0},{88,0},{88,-12},{98,-12}},
      color={255,0,255}));
  connect(mulAnd1.y, booRep3.u)
    annotation (Line(points={{1.7,-20},{18,-20}}, color={255,0,255}));
  connect(booRep3.y, logSwi2.u2)
    annotation (Line(points={{41,-20},{98,-20}}, color={255,0,255}));
  connect(mulAnd2.y, booRep4.u)
    annotation (Line(points={{1.7,-110},{18,-110}}, color={255,0,255}));
  connect(booRep4.y, logSwi3.u2)
    annotation (Line(points={{41,-110},{98,-110}}, color={255,0,255}));
  connect(con12.y, logSwi3.u1)
    annotation (Line(points={{81,-90},{88,-90},{88,-102},{98,-102}},
      color={255,0,255}));
  connect(logSwi3.y, logSwi2.u3)
    annotation (Line(points={{121,-110},{130,-110},{130,-80},{90,-80},
      {90,-28},{98,-28}}, color={255,0,255}));
  connect(uDevSta, and7.u1)
    annotation (Line(points={{-280,160},{-240,160},{-240,10},{-130,10},
      {-130,0},{-102,0}}, color={255,0,255}));
  connect(uDevSta, and8.u1)
    annotation (Line(points={{-280,160},{-240,160},{-240,10},{-130,10},
      {-130,-90},{-102,-90}}, color={255,0,255}));
  connect(con13.y, logSwi3.u3)
    annotation (Line(points={{81,-130},{90,-130},{90,-118},{98,-118}},
      color={255,0,255}));
  connect(and3.y, booRep5.u)
    annotation (Line(points={{61,40},{78,40}}, color={255,0,255}));
  connect(booRep5.y, logSwi4.u2)
    annotation (Line(points={{101,40},{158,40}}, color={255,0,255}));
  connect(logSwi2.y, logSwi4.u1)
    annotation (Line(points={{121,-20},{130,-20},{130,48},{158,48}},
      color={255,0,255}));
  connect(logSwi4.y, logSwi1.u3)
    annotation (Line(points={{181,40},{190,40},{190,60},{140,60},{140,82},
      {158,82}}, color={255,0,255}));
  connect(con10.y, logSwi4.u3)
    annotation (Line(points={{121,-190},{140,-190},{140,32},{158,32}},
      color={255,0,255}));
  connect(twoDev.y, logSwi5.u2)
    annotation (Line(points={{-159,220},{-82,220}},  color={255,0,255}));
  connect(con14.y, logSwi5.u1)
    annotation (Line(points={{-119,240},{-100,240},{-100,228},{-82,228}},
      color={255,0,255}));
  connect(con15.y, logSwi5.u3)
    annotation (Line(points={{-119,200},{-100,200},{-100,212},{-82,212}},
      color={255,0,255}));
  connect(logSwi5.y, and2.u1)
    annotation (Line(points={{-59,220},{-20,220},{-20,200},{38,200}},
      color={255,0,255}));
  connect(logSwi5.y, not4.u)
    annotation (Line(points={{-59,220},{-20,220},{-20,120},{-2,120}},
      color={255,0,255}));
  connect(not4.y, and1.u1)
    annotation (Line(points={{21,120},{30,120},{30,90},{38,90}},
      color={255,0,255}));
  connect(not4.y, and3.u1)
    annotation (Line(points={{21,120},{30,120},{30,40},{38,40}},
      color={255,0,255}));
  connect(uDevSta, not5.u)
    annotation (Line(points={{-280,160},{-240,160},{-240,40},{-222,40}},
      color={255,0,255}));
  connect(not5.y, and4.u1)
    annotation (Line(points={{-199,40},{-120,40},{-120,-30},{-102,-30}},
      color={255,0,255}));
  connect(not5.y, and5.u1)
    annotation (Line(points={{-199,40},{-120,40},{-120,-120},{-102,-120}},
      color={255,0,255}));
  connect(logSwi.y, logSwi6.u1)
    annotation (Line(points={{181,200},{200,200},{200,-212},{218,-212}},
      color={255,0,255}));
  connect(logSwi1.y, logSwi6.u1)
    annotation (Line(points={{181,90},{200,90},{200,-212},{218,-212}},
      color={255,0,255}));
  connect(logSwi6.y, yDevSta)
    annotation (Line(points={{241,-220},{270,-220}}, color={255,0,255}));
  connect(uEnaNex, booRep1.u)
    annotation (Line(points={{-280,-220},{-202,-220}}, color={255,0,255}));
  connect(booRep1.y, logSwi6.u2)
    annotation (Line(points={{-179,-220},{218,-220}}, color={255,0,255}));
  connect(uDevSta, logSwi6.u3)
    annotation (Line(points={{-280,160},{-240,160},{-240,-240},{200,-240},
      {200,-228},{218,-228}}, color={255,0,255}));

annotation (
  defaultComponentName = "enaNex",
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-260,-260},{260,260}}), graphics={Rectangle(
          extent={{-258,258},{-42,182}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-126,254},{-46,242}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Check if it has 2 
or 3 devices"),                              Rectangle(
          extent={{-258,178},{-42,62}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-96,148},{-44,140}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="no operating device?"),
          Text(
          extent={{-100,74},{-44,66}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="one operating device?"),
                                             Rectangle(
          extent={{2,258},{258,162}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{84,258},{256,232}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Totally two devices and none is operating,
then first one will be enabled "),
          Text(
          extent={{70,188},{254,166}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Totally two devices and one is operating,
then both devices will be enabled "),        Rectangle(
          extent={{2,138},{258,22}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{66,134},{250,112}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Totally three devices and none is operating,
then first one will be enabled"),
          Text(
          extent={{78,84},{252,62}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Totally three devices and one is operating,
then enable another one"),
          Text(
          extent={{112,40},{254,6}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="Totally three devices and two are operating,
then enable all"),                           Rectangle(
          extent={{-258,18},{118,-58}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),         Rectangle(
          extent={{-258,-62},{118,-158}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{-70,20},{50,6}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="{true, false, false} becomes {true, true, false}"),
          Text(
          extent={{-72,-62},{48,-76}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="{false, true, false} becomes {false, true, true}"),
          Text(
          extent={{-38,-144},{82,-158}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="{false, false, true} becomes {true, false, true}")}),
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-102,8},{-50,-4}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDevSta"),
        Text(
          extent={{-98,-70},{-48,-84}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uEnaNex"),
        Text(
          extent={{58,6},{98,-6}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yDevSta"),
        Text(
          extent={{-54,72},{58,28}},
          lineColor={192,192,192},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          textString="Enable Next")}),
Documentation(info="<html>
<p>
Block that enable one more additional device. Total number of device <code>num</code>
could be 2 or 3.
</p>
<p>
Input <code>uDevSta</code> is boolean vector indicating current devices status. 
When input <code>uEnaNex</code> becomes true, it will enable one more device 
as following:
</p>
<p>When there are two devices:</p>
<ul>
<li>
no device is running currently: (0, 0) becomes (1, 0)
</li>
<li>
one device is running currently: (1, 0) or (0, 1) becomes (1, 1)
</li>
</ul>

<p>When there are three devices:</p>
<ul>
<li>
no device is running currently: (0, 0, 0) becomes (1, 0, 0)
</li>
<li>
one device is running currently: (1, 0, 0) becomes (1, 1, 0), or (0, 1, 0) 
becomes (0, 1, 1), or (0, 0, 1) becomes (1, 0, 1)
</li>
<li>
two devices are running currently: (1, 1, 0), or (1, 0, 1), or (0, 1, 1) 
becomes (1, 1, 1)
</li>
</ul>


</html>",
revisions="<html>
<ul>
<li>
July 26, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableNext;
