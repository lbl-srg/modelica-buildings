within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences;
block NextBoiler
    "Identify next enable and disable boilers"

  parameter Integer nBoi=3
    "Total number of boilers";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoiSet[nBoi]
    "Vector of boilers status setpoint"
    annotation (Placement(transformation(extent={{-260,-20},{-220,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput chaPro
    "True: in the stage change process"
    annotation (Placement(transformation(extent={{-260,-180},{-220,-140}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaSet
    "Boiler stage setpoint"
    annotation (Placement(transformation(extent={{-260,90},{-220,130}}),
      iconTransformation(extent={{-140,50},{-100,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOnOff
    "True: if the stage change require one boiler to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{220,-40},{260,0}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yNexEnaBoi
    "Next enabling boiler index"
    annotation (Placement(transformation(extent={{220,140},{260,180}}),
      iconTransformation(extent={{100,70},{140,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yDisSmaBoi
    "Smaller boiler to be disabled in staging-up process"
    annotation (Placement(transformation(extent={{220,90},{260,130}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLasDisBoi
    "Disable last boiler when it is in stage-down process"
    annotation (Placement(transformation(extent={{220,-120},{260,-80}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yEnaSmaBoi
    "Smaller boiler to be enabled in stage-down process"
    annotation (Placement(transformation(extent={{220,-180},{260,-140}}),
      iconTransformation(extent={{100,-110},{140,-70}})));

protected
  parameter Integer boiInd[nBoi]={i for i in 1:nBoi}
    "Boiler index, {1,2,...,n}";

  Buildings.Controls.OBC.CDL.Integers.Change cha
    "Check if it is stage up or stage down"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));

  Buildings.Controls.OBC.CDL.Logical.Latch enaBoi[nBoi]
    "True when the boiler should be enabled"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));

  Buildings.Controls.OBC.CDL.Logical.Latch disBoi[nBoi]
    "True when the boiler should be disabled"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr anyEnaBoi(
    final nin=nBoi)
    "Check if there is any enabling boiler"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr anyDisBoi(
    final nin=nBoi)
    "Check if there is any disabling boiler"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

  Buildings.Controls.OBC.CDL.Logical.And enaDis
    "Check if enabling and disabling boilers at the same process"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));

  Buildings.Controls.OBC.CDL.Integers.Multiply proInt[nBoi]
    "Find out the index of enabling boiler"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));

  Buildings.Controls.OBC.CDL.Integers.Multiply proInt1[nBoi]
    "Find out the index of disabling boiler"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum enaBoiInd(
    final nin=nBoi)
    "Enabling boiler index"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum disBoiInd(
    final nin = nBoi)
    "Disabling boiler index"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Latch upPro
    "True when it is in stage up process"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));

  Buildings.Controls.OBC.CDL.Logical.Latch dowPro
    "True when it is in stage down process"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  Buildings.Controls.OBC.CDL.Integers.Multiply proInt2
    "Find out the index of enabling boiler"
    annotation (Placement(transformation(extent={{120,150},{140,170}})));

  Buildings.Controls.OBC.CDL.Integers.Multiply proInt3
    "Staging up process and it requires boiler on and off"
    annotation (Placement(transformation(extent={{120,110},{140,130}})));

  Buildings.Controls.OBC.CDL.Integers.Multiply proInt4
    "Disabling boiler during stage up process"
    annotation (Placement(transformation(extent={{180,100},{200,120}})));

  Buildings.Controls.OBC.CDL.Integers.Multiply proInt5
    "Find out the index of disabling boiler"
    annotation (Placement(transformation(extent={{120,-110},{140,-90}})));

  Buildings.Controls.OBC.CDL.Integers.Multiply proInt6
    "Staging down process and it requires boiler on and off"
    annotation (Placement(transformation(extent={{120,-150},{140,-130}})));

  Buildings.Controls.OBC.CDL.Integers.Multiply proInt7
    "Enabling boiler during stage down process"
    annotation (Placement(transformation(extent={{180,-170},{200,-150}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nBoi]
    "Boolean to integer"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nBoi]
    "Boolean to integer"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2
    "Boolean to integer"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3
    "Boolean to integer"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt4
    "Boolean to integer"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant boiIndVec[nBoi](
    final k=boiInd)
    "Vector of boiler index"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nBoi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-160,-170},{-140,-150}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg[nBoi]
    "Detect boilers being turned on"
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg[nBoi]
    "Detect boilers being turned off"
    annotation (Placement(transformation(extent={{-200,-110},{-180,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{-200,-170},{-180,-150}})));

equation
  connect(booRep.y,enaBoi. clr) annotation (Line(points={{-138,-160},{-130,-160},
          {-130,34},{-122,34}},   color={255,0,255}));

  connect(booRep.y,disBoi. clr) annotation (Line(points={{-138,-160},{-130,-160},
          {-130,-106},{-122,-106}}, color={255,0,255}));

  connect(enaBoi.y,anyEnaBoi. u) annotation (Line(points={{-98,40},{-90,40},{-90,
          -20},{-82,-20}},color={255,0,255}));

  connect(anyEnaBoi.y, enaDis.u1) annotation (Line(points={{-58,-20},{-22,-20}},
                          color={255,0,255}));

  connect(disBoi.y,anyDisBoi. u) annotation (Line(points={{-98,-100},{-90,-100},
          {-90,-60},{-82,-60}},color={255,0,255}));

  connect(anyDisBoi.y, enaDis.u2) annotation (Line(points={{-58,-60},{-30,-60},{
          -30,-28},{-22,-28}}, color={255,0,255}));

  connect(enaDis.y, yOnOff) annotation (Line(points={{2,-20},{240,-20}},
               color={255,0,255}));

  connect(uStaSet, cha.u)
    annotation (Line(points={{-240,110},{-202,110}}, color={255,127,0}));

  connect(disBoi.y, booToInt1.u)
    annotation (Line(points={{-98,-100},{-82,-100}}, color={255,0,255}));

  connect(enaBoi.y, booToInt.u)
    annotation (Line(points={{-98,40},{-82,40}}, color={255,0,255}));

  connect(booToInt.y, proInt.u1) annotation (Line(points={{-58,40},{-40,40},{-40,
          46},{-22,46}}, color={255,127,0}));

  connect(booToInt1.y, proInt1.u2) annotation (Line(points={{-58,-100},{-40,-100},
          {-40,-106},{-22,-106}}, color={255,127,0}));

  connect(boiIndVec.y, proInt.u2) annotation (Line(points={{-98,0},{-40,0},{-40,
          34},{-22,34}}, color={255,127,0}));

  connect(proInt.y,enaBoiInd. u)
    annotation (Line(points={{2,40},{18,40}}, color={255,127,0}));

  connect(boiIndVec.y, proInt1.u1) annotation (Line(points={{-98,0},{-40,0},{-40,
          -94},{-22,-94}}, color={255,127,0}));

  connect(proInt1.y,disBoiInd. u)
    annotation (Line(points={{2,-100},{18,-100}}, color={255,127,0}));

  connect(enaDis.y, booToInt2.u) annotation (Line(points={{2,-20},{20,-20},{20,-60},
          {38,-60}}, color={255,0,255}));

  connect(upPro.y, booToInt3.u)
    annotation (Line(points={{-98,130},{-82,130}}, color={255,0,255}));

  connect(booToInt3.y, proInt2.u1) annotation (Line(points={{-58,130},{-20,130},
          {-20,166},{118,166}}, color={255,127,0}));

  connect(enaBoiInd.y, proInt2.u2) annotation (Line(points={{42,40},{80,40},{80,
          154},{118,154}}, color={255,127,0}));

  connect(proInt2.y,yNexEnaBoi)
    annotation (Line(points={{142,160},{240,160}}, color={255,127,0}));

  connect(booToInt3.y, proInt3.u1) annotation (Line(points={{-58,130},{-20,130},
          {-20,126},{118,126}},color={255,127,0}));

  connect(booToInt2.y, proInt3.u2) annotation (Line(points={{62,-60},{70,-60},{70,
          114},{118,114}},color={255,127,0}));

  connect(proInt3.y, proInt4.u1) annotation (Line(points={{142,120},{160,120},{160,
          116},{178,116}}, color={255,127,0}));

  connect(disBoiInd.y, proInt4.u2) annotation (Line(points={{42,-100},{90,-100},
          {90,104},{178,104}}, color={255,127,0}));

  connect(proInt4.y,yDisSmaBoi)
    annotation (Line(points={{202,110},{240,110}}, color={255,127,0}));

  connect(dowPro.y, booToInt4.u)
    annotation (Line(points={{-98,90},{-82,90}}, color={255,0,255}));

  connect(booToInt4.y, proInt5.u1) annotation (Line(points={{-58,90},{100,90},{
          100,-94},{118,-94}},
                           color={255,127,0}));

  connect(disBoiInd.y, proInt5.u2) annotation (Line(points={{42,-100},{90,-100},
          {90,-106},{118,-106}}, color={255,127,0}));

  connect(proInt5.y,yLasDisBoi)
    annotation (Line(points={{142,-100},{240,-100}}, color={255,127,0}));

  connect(booToInt2.y, proInt6.u2) annotation (Line(points={{62,-60},{70,-60},{70,
          -146},{118,-146}}, color={255,127,0}));

  connect(booToInt4.y, proInt6.u1) annotation (Line(points={{-58,90},{100,90},{
          100,-134},{118,-134}},
                             color={255,127,0}));

  connect(proInt6.y, proInt7.u1) annotation (Line(points={{142,-140},{160,-140},
          {160,-154},{178,-154}}, color={255,127,0}));

  connect(enaBoiInd.y, proInt7.u2) annotation (Line(points={{42,40},{80,40},{80,
          -166},{178,-166}}, color={255,127,0}));

  connect(proInt7.y,yEnaSmaBoi)
    annotation (Line(points={{202,-160},{240,-160}}, color={255,127,0}));

  connect(falEdg.u, uBoiSet) annotation (Line(points={{-202,-100},{-212,-100},{
          -212,0},{-240,0}}, color={255,0,255}));

  connect(edg.u, uBoiSet) annotation (Line(points={{-202,40},{-212,40},{-212,0},
          {-240,0}}, color={255,0,255}));

  connect(falEdg.y, disBoi.u)
    annotation (Line(points={{-178,-100},{-122,-100}}, color={255,0,255}));
  connect(edg.y, enaBoi.u)
    annotation (Line(points={{-178,40},{-122,40}}, color={255,0,255}));
  connect(cha.up, upPro.u) annotation (Line(points={{-178,116},{-140,116},{-140,
          130},{-122,130}}, color={255,0,255}));
  connect(cha.down, dowPro.u) annotation (Line(points={{-178,104},{-140,104},{
          -140,90},{-122,90}}, color={255,0,255}));
  connect(chaPro, not1.u)
    annotation (Line(points={{-240,-160},{-202,-160}}, color={255,0,255}));
  connect(not1.y, booRep.u)
    annotation (Line(points={{-178,-160},{-162,-160}}, color={255,0,255}));
  connect(not1.y, upPro.clr) annotation (Line(points={{-178,-160},{-170,-160},{-170,
          124},{-122,124}}, color={255,0,255}));
  connect(not1.y, dowPro.clr) annotation (Line(points={{-178,-160},{-170,-160},{
          -170,84},{-122,84}}, color={255,0,255}));

annotation (
  defaultComponentName="nexBoi",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-220,-180},{220,180}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-100,76},{-64,66}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uStaSet"),
        Text(
          extent={{-100,8},{-58,-4}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uBoiSet"),
        Text(
          extent={{50,100},{98,80}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yNexEnaBoi"),
        Text(
          extent={{-98,-62},{-64,-74}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="chaPro"),
        Text(
          extent={{50,52},{98,32}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yDisSmaBoi"),
        Text(
          extent={{50,-28},{98,-48}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yDisLasBoi"),
        Text(
          extent={{44,-78},{98,-100}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yEnaSmaBoi"),
        Text(
          extent={{54,8},{96,-4}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yOnOff"),
      Text(
        extent={{-100,100},{100,-100}},
        lineColor={0,0,0},
          textString="?")}),
Documentation(info="<html>
<p>
This block identifies index of next enabled boiler (<code>yNexEnaBoi</code> and 
<code>yEnaSmaBoi</code>) or disabled boiler (<code>yDisSmaBoi</code> and 
<code>yLasDisBoi</code>) based on current boiler stage setpoint
<code>uStaSet</code> and the boiler status setpoint <code>uBoiSet</code>.
</p>
<p>
This implementation assumes that the stage-up process (increased <code>uStaSet</code>)
will enable only one more boiler (<code>yOnOff=false</code>), or enable a larger
boiler and disable a smaller boiler (<code>yOnOff=true</code>);
 the stage-down
process (decreased <code>uStaSet</code>) will disable only one existing boiler
(<code>yOnOff=false</code>), or disable a larger boiler and enable a smaller
boiler (<code>yOnOff=true</code>).
</p>
</html>", revisions="<html>
<ul>
<li>
July 07, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end NextBoiler;
