within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block NextChiller "Identify next enable and disable chillers"

  parameter Integer nChi=2 "Total number of chillers";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaSet
    "Chiller stage setpoint"
    annotation (Placement(transformation(extent={{-260,110},{-220,150}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiSet[nChi]
    "Vector of chillers status setpoint"
    annotation (Placement(transformation(extent={{-260,-40},{-220,0}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput endPro
    "True: the staging process is end"
    annotation (Placement(transformation(extent={{-260,-180},{-220,-140}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yNexEnaChi
    "Next enabling chiller index"
    annotation (Placement(transformation(extent={{220,140},{260,180}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yDisSmaChi
    "Smaller chiller to be disabled in staging-up process"
    annotation (Placement(transformation(extent={{220,90},{260,130}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOnOff
    "True: if the stage change require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{220,-40},{260,0}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLasDisChi
    "Disable last chiller when it is in stage-down process"
    annotation (Placement(transformation(extent={{220,-120},{260,-80}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yEnaSmaChi
    "Smaller chiller to be enabled in stage-down process"
    annotation (Placement(transformation(extent={{220,-180},{260,-140}}),
      iconTransformation(extent={{100,-110},{140,-70}})));

  Buildings.Controls.OBC.CDL.Integers.Change cha
    "Check if it is stage up or stage down"
    annotation (Placement(transformation(extent={{-200,120},{-180,140}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg[nChi]
    "Check if the chiller is being enabled"
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg[nChi]
    "Check if the chiller is being disabled"
    annotation (Placement(transformation(extent={{-200,-110},{-180,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Latch enaChi[nChi]
    "True when the chiller should be enabled"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Logical.Latch disChi[nChi]
    "True when the chiller should be disabled"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyEnaChi(final nin=nChi)
    "Check if there is any enabling chiller"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyDisChi(final nin=nChi)
    "Check if there is any disabling chiller"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And enaDis
    "Check if enabling and disabling chillers at the same process"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt[nChi]
    "Find out the index of enabling chiller"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt1[nChi]
    "Find out the index of disabling chiller"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum enaChiInd(final nin = nChi)
    "Enabling chiller index"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum disChiInd(final nin = nChi)
    "Disabling chiller index"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Latch upPro
    "True when it is in stage up process"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Logical.Latch dowPro
    "True when it is in stage down process"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt2
    "Find out the index of enabling chiller"
    annotation (Placement(transformation(extent={{120,150},{140,170}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt3
    "Staging up process and it requires chiller on and off"
    annotation (Placement(transformation(extent={{120,110},{140,130}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt4
    "Disabling chiller during stage up process"
    annotation (Placement(transformation(extent={{180,100},{200,120}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt5
    "Find out the index of disabling chiller"
    annotation (Placement(transformation(extent={{120,-110},{140,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt6
    "Staging down process and it requires chiller on and off"
    annotation (Placement(transformation(extent={{120,-150},{140,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt7
    "Enabling chiller during stage down process"
    annotation (Placement(transformation(extent={{180,-170},{200,-150}})));

protected
  parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nChi]
    "Boolean to integer"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nChi]
    "Boolean to integer"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2
    "Boolean to integer"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3
    "Boolean to integer"
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt4
    "Boolean to integer"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant chiIndVec[nChi](
    final k=chiInd)
    "Vector of chiller index"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-160,-170},{-140,-150}})));

equation
  connect(uChiSet, edg.u) annotation (Line(points={{-240,-20},{-210,-20},{-210,40},
          {-202,40}},       color={255,0,255}));
  connect(edg.y, enaChi.u)
    annotation (Line(points={{-178,40},{-122,40}},   color={255,0,255}));
  connect(falEdg.y, disChi.u)
    annotation (Line(points={{-178,-100},{-122,-100}}, color={255,0,255}));
  connect(booRep.y, enaChi.clr) annotation (Line(points={{-138,-160},{-130,-160},
          {-130,34},{-122,34}},   color={255,0,255}));
  connect(booRep.y, disChi.clr) annotation (Line(points={{-138,-160},{-130,-160},
          {-130,-106},{-122,-106}}, color={255,0,255}));
  connect(enaChi.y, anyEnaChi.u) annotation (Line(points={{-98,40},{-90,40},{-90,
          -20},{-82,-20}},color={255,0,255}));
  connect(anyEnaChi.y, enaDis.u1) annotation (Line(points={{-58,-20},{-22,-20}},
                          color={255,0,255}));
  connect(disChi.y, anyDisChi.u) annotation (Line(points={{-98,-100},{-90,-100},
          {-90,-60},{-82,-60}},color={255,0,255}));
  connect(anyDisChi.y, enaDis.u2) annotation (Line(points={{-58,-60},{-30,-60},{
          -30,-28},{-22,-28}}, color={255,0,255}));
  connect(enaDis.y, yOnOff) annotation (Line(points={{2,-20},{240,-20}},
               color={255,0,255}));
  connect(uStaSet, cha.u)
    annotation (Line(points={{-240,130},{-202,130}}, color={255,127,0}));
  connect(disChi.y, booToInt1.u)
    annotation (Line(points={{-98,-100},{-82,-100}}, color={255,0,255}));
  connect(enaChi.y, booToInt.u)
    annotation (Line(points={{-98,40},{-82,40}}, color={255,0,255}));
  connect(booToInt.y, proInt.u1) annotation (Line(points={{-58,40},{-40,40},{-40,
          46},{-22,46}}, color={255,127,0}));
  connect(booToInt1.y, proInt1.u2) annotation (Line(points={{-58,-100},{-40,-100},
          {-40,-106},{-22,-106}}, color={255,127,0}));
  connect(chiIndVec.y, proInt.u2) annotation (Line(points={{-98,0},{-40,0},{-40,
          34},{-22,34}}, color={255,127,0}));
  connect(proInt.y, enaChiInd.u)
    annotation (Line(points={{2,40},{18,40}}, color={255,127,0}));
  connect(chiIndVec.y, proInt1.u1) annotation (Line(points={{-98,0},{-40,0},{-40,
          -94},{-22,-94}}, color={255,127,0}));
  connect(proInt1.y, disChiInd.u)
    annotation (Line(points={{2,-100},{18,-100}}, color={255,127,0}));
  connect(cha.up, upPro.u) annotation (Line(points={{-178,136},{-140,136},{-140,
          160},{-122,160}}, color={255,0,255}));
  connect(cha.down, dowPro.u) annotation (Line(points={{-178,124},{-140,124},{-140,
          90},{-122,90}}, color={255,0,255}));
  connect(enaDis.y, booToInt2.u) annotation (Line(points={{2,-20},{20,-20},{20,-60},
          {38,-60}}, color={255,0,255}));
  connect(upPro.y, booToInt3.u)
    annotation (Line(points={{-98,160},{-82,160}}, color={255,0,255}));
  connect(booToInt3.y, proInt2.u1) annotation (Line(points={{-58,160},{-20,160},
          {-20,166},{118,166}}, color={255,127,0}));
  connect(enaChiInd.y, proInt2.u2) annotation (Line(points={{42,40},{80,40},{80,
          154},{118,154}}, color={255,127,0}));
  connect(proInt2.y, yNexEnaChi)
    annotation (Line(points={{142,160},{240,160}}, color={255,127,0}));
  connect(booToInt3.y, proInt3.u1) annotation (Line(points={{-58,160},{-20,160},
          {-20,126},{118,126}},color={255,127,0}));
  connect(booToInt2.y, proInt3.u2) annotation (Line(points={{62,-60},{70,-60},{70,
          114},{118,114}},color={255,127,0}));
  connect(proInt3.y, proInt4.u1) annotation (Line(points={{142,120},{160,120},{160,
          116},{178,116}}, color={255,127,0}));
  connect(disChiInd.y, proInt4.u2) annotation (Line(points={{42,-100},{90,-100},
          {90,104},{178,104}}, color={255,127,0}));
  connect(proInt4.y, yDisSmaChi)
    annotation (Line(points={{202,110},{240,110}}, color={255,127,0}));
  connect(dowPro.y, booToInt4.u)
    annotation (Line(points={{-98,90},{-82,90}}, color={255,0,255}));
  connect(booToInt4.y, proInt5.u1) annotation (Line(points={{-58,90},{100,90},{100,
          -94},{118,-94}}, color={255,127,0}));
  connect(disChiInd.y, proInt5.u2) annotation (Line(points={{42,-100},{90,-100},
          {90,-106},{118,-106}}, color={255,127,0}));
  connect(proInt5.y, yLasDisChi)
    annotation (Line(points={{142,-100},{240,-100}}, color={255,127,0}));
  connect(booToInt2.y, proInt6.u2) annotation (Line(points={{62,-60},{70,-60},{70,
          -146},{118,-146}}, color={255,127,0}));
  connect(booToInt4.y, proInt6.u1) annotation (Line(points={{-58,90},{100,90},{100,
          -134},{118,-134}}, color={255,127,0}));
  connect(proInt6.y, proInt7.u1) annotation (Line(points={{142,-140},{160,-140},
          {160,-154},{178,-154}}, color={255,127,0}));
  connect(enaChiInd.y, proInt7.u2) annotation (Line(points={{42,40},{80,40},{80,
          -166},{178,-166}}, color={255,127,0}));
  connect(proInt7.y, yEnaSmaChi)
    annotation (Line(points={{202,-160},{240,-160}}, color={255,127,0}));
  connect(endPro, dowPro.clr) annotation (Line(points={{-240,-160},{-170,-160},{
          -170,84},{-122,84}}, color={255,0,255}));
  connect(endPro, upPro.clr) annotation (Line(points={{-240,-160},{-170,-160},{-170,
          154},{-122,154}}, color={255,0,255}));
  connect(endPro, booRep.u)
    annotation (Line(points={{-240,-160},{-162,-160}}, color={255,0,255}));
  connect(uChiSet, falEdg.u) annotation (Line(points={{-240,-20},{-210,-20},{
          -210,-100},{-202,-100}}, color={255,0,255}));
annotation (
  defaultComponentName="nexChi",
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
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-100,76},{-64,66}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uStaSet"),
        Text(
          extent={{-100,8},{-58,-4}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiSet"),
        Text(
          extent={{50,100},{98,80}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yNexEnaChi"),
        Text(
          extent={{-98,-62},{-64,-74}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="endPro"),
        Text(
          extent={{50,52},{98,32}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yDisSmaChi"),
        Text(
          extent={{50,-28},{98,-48}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yDisLasChi"),
        Text(
          extent={{44,-78},{98,-100}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yEnaSmaChi"),
        Text(
          extent={{54,8},{96,-4}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yOnOff"),
      Text(
        extent={{-100,100},{100,-100}},
        textColor={0,0,0},
          textString="?")}),
Documentation(info="<html>
<p>
This block identifies index of next enable (<code>yNexEnaChi</code> and 
<code>yEnaSmaChi</code>) or disable chiller (<code>yDisSmaChi</code> and 
<code>yLasDisChi</code>) based on current chiller stage setpoint
<code>uStaSet</code> and the chiller status setpoint <code>uChiSet</code>.
</p>
<p>
This implementation assumes that the stage-up process (increased <code>uStaSet</code>)
will enable only one more chiller (<code>yOnOff=false</code>), or enable a larger
chiller and disable a smaller chiller (<code>yOnOff=true</code>); the stage-down
process (dicreased <code>uStaSet</code>) will disable only one existing chiller
(<code>yOnOff=false</code>), or disable a larger chiller and enable a smaller
chiller (<code>yOnOff=true</code>).
</p>
</html>", revisions="<html>
<ul>
<li>
May 06, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end NextChiller;
