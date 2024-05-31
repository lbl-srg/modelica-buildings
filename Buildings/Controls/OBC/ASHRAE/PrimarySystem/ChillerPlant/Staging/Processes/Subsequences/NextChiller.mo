within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block NextChiller "Identify next enable and disable chillers"

  parameter Integer nChi=2 "Total number of chillers";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaSet
    "Chiller stage setpoint"
    annotation (Placement(transformation(extent={{-300,110},{-260,150}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiSet[nChi]
    "Vector of chillers status setpoint"
    annotation (Placement(transformation(extent={{-300,-40},{-260,0}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput endPro
    "True: the staging process is end"
    annotation (Placement(transformation(extent={{-300,-210},{-260,-170}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yUp
    "True if it is in staging up process"
    annotation (Placement(transformation(extent={{280,180},{320,220}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDow
    "True if it is in staging down process"
    annotation (Placement(transformation(extent={{280,120},{320,160}}),
        iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yNexEnaChi
    "Next enabling chiller index"
    annotation (Placement(transformation(extent={{280,70},{320,110}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yDisSmaChi
    "Smaller chiller to be disabled in staging-up process"
    annotation (Placement(transformation(extent={{280,20},{320,60}}),
      iconTransformation(extent={{100,-12},{140,28}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOnOff
    "True: if the stage change require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{280,-40},{320,0}}),
      iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLasDisChi
    "Disable last chiller when it is in stage-down process"
    annotation (Placement(transformation(extent={{280,-120},{320,-80}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yEnaSmaChi
    "Smaller chiller to be enabled in stage-down process"
    annotation (Placement(transformation(extent={{280,-170},{320,-130}}),
      iconTransformation(extent={{100,-110},{140,-70}})));

protected
  parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nChi]
    "Boolean to integer"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nChi]
    "Boolean to integer"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2
    "Boolean to integer"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3
    "Boolean to integer"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt4
    "Boolean to integer"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant chiIndVec[nChi](
    final k=chiInd) "Vector of chiller index"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-140,-200},{-120,-180}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1) "Constant 1"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Change cha
    "Check if it is stage up or stage down"
    annotation (Placement(transformation(extent={{-240,120},{-220,140}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg[nChi]
    "Check if the chiller is being enabled"
    annotation (Placement(transformation(extent={{-240,30},{-220,50}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg[nChi]
    "Check if the chiller is being disabled"
    annotation (Placement(transformation(extent={{-240,-30},{-220,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Latch enaChi[nChi]
    "True when the chiller should be enabled"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Logical.Latch disChi[nChi]
    "True when the chiller should be disabled"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyEnaChi(final nin=nChi)
    "Check if there is any enabling chiller"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyDisChi(final nin=nChi)
    "Check if there is any disabling chiller"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And enaDis
    "Check if enabling and disabling chillers at the same process"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt[nChi]
    "Find out the index of enabling chiller"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt1[nChi]
    "Find out the index of disabling chiller"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum enaChiInd(final nin = nChi)
    "Enabling chiller index"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum disChiInd(final nin = nChi)
    "Disabling chiller index"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Latch upPro
    "True when it is in stage up process"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Logical.Latch dowPro
    "True when it is in stage down process"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt2
    "Find out the index of enabling chiller"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt3
    "Staging up process and it requires chiller on and off"
    annotation (Placement(transformation(extent={{120,30},{140,50}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt4
    "Disabling chiller during stage up process"
    annotation (Placement(transformation(extent={{160,10},{180,30}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt5
    "Find out the index of disabling chiller"
    annotation (Placement(transformation(extent={{120,-140},{140,-120}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt6
    "Staging down process and it requires chiller on and off"
    annotation (Placement(transformation(extent={{120,-190},{140,-170}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt7
    "Enabling chiller during stage down process"
    annotation (Placement(transformation(extent={{160,-210},{180,-190}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    "Output 1 when it is not in the staging up process"
    annotation (Placement(transformation(extent={{240,30},{260,50}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    "Output 1 when it is not in the staging up process"
    annotation (Placement(transformation(extent={{240,80},{260,100}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi2
    "Output 1 when it is not in the staging down process"
    annotation (Placement(transformation(extent={{240,-160},{260,-140}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi3
    "Output 1 when it is not in the staging down process"
    annotation (Placement(transformation(extent={{240,-110},{260,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nChi](
    final k=fill(false, nChi))
    "False constant"
    annotation (Placement(transformation(extent={{-240,-130},{-220,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nChi](
    final k=fill(true, nChi))
    "Constant true"
    annotation (Placement(transformation(extent={{-240,-90},{-220,-70}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel[nChi](
    final delayTime=fill(1, nChi),
    final delayOnInit=fill(true, nChi))
    "Check if it has passed initial time"
    annotation (Placement(transformation(extent={{-200,-90},{-180,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi2[nChi]
    "Logical switch"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
equation
  connect(uChiSet, edg.u) annotation (Line(points={{-280,-20},{-250,-20},{-250,40},
          {-242,40}}, color={255,0,255}));
  connect(booRep.y, enaChi.clr) annotation (Line(points={{-118,-190},{-110,-190},
          {-110,34},{-102,34}},   color={255,0,255}));
  connect(booRep.y, disChi.clr) annotation (Line(points={{-118,-190},{-110,-190},
          {-110,-86},{-102,-86}},   color={255,0,255}));
  connect(enaChi.y, anyEnaChi.u) annotation (Line(points={{-78,40},{-70,40},{-70,
          -20},{-62,-20}},  color={255,0,255}));
  connect(anyEnaChi.y, enaDis.u1) annotation (Line(points={{-38,-20},{-2,-20}},
          color={255,0,255}));
  connect(disChi.y, anyDisChi.u) annotation (Line(points={{-78,-80},{-70,-80},{-70,
          -100},{-62,-100}}, color={255,0,255}));
  connect(anyDisChi.y, enaDis.u2) annotation (Line(points={{-38,-100},{-10,-100},
          {-10,-28},{-2,-28}}, color={255,0,255}));
  connect(enaDis.y, yOnOff) annotation (Line(points={{22,-20},{300,-20}},
          color={255,0,255}));
  connect(uStaSet, cha.u)
    annotation (Line(points={{-280,130},{-242,130}}, color={255,127,0}));
  connect(disChi.y, booToInt1.u)
    annotation (Line(points={{-78,-80},{-70,-80},{-70,-140},{-62,-140}},
         color={255,0,255}));
  connect(enaChi.y, booToInt.u)
    annotation (Line(points={{-78,40},{-62,40}}, color={255,0,255}));
  connect(booToInt.y, proInt.u1) annotation (Line(points={{-38,40},{-20,40},{-20,
          46},{-2,46}},  color={255,127,0}));
  connect(booToInt1.y, proInt1.u2) annotation (Line(points={{-38,-140},{-20,-140},
          {-20,-136},{-2,-136}},  color={255,127,0}));
  connect(chiIndVec.y, proInt.u2) annotation (Line(points={{-78,0},{-20,0},{-20,
          34},{-2,34}},  color={255,127,0}));
  connect(proInt.y, enaChiInd.u)
    annotation (Line(points={{22,40},{38,40}},  color={255,127,0}));
  connect(chiIndVec.y, proInt1.u1) annotation (Line(points={{-78,0},{-20,0},{-20,
          -124},{-2,-124}},  color={255,127,0}));
  connect(proInt1.y, disChiInd.u)
    annotation (Line(points={{22,-130},{38,-130}},  color={255,127,0}));
  connect(cha.down, dowPro.u) annotation (Line(points={{-218,124},{-120,124},{-120,
          110},{-102,110}}, color={255,0,255}));
  connect(enaDis.y, booToInt2.u) annotation (Line(points={{22,-20},{30,-20},{30,
          -60},{38,-60}}, color={255,0,255}));
  connect(upPro.y, booToInt3.u)
    annotation (Line(points={{-78,160},{-62,160}}, color={255,0,255}));
  connect(booToInt3.y, proInt2.u1) annotation (Line(points={{-38,160},{110,160},
          {110,96},{118,96}}, color={255,127,0}));
  connect(enaChiInd.y, proInt2.u2) annotation (Line(points={{62,40},{80,40},{80,
          84},{118,84}},color={255,127,0}));
  connect(booToInt3.y, proInt3.u1) annotation (Line(points={{-38,160},{110,160},
          {110,46},{118,46}},color={255,127,0}));
  connect(booToInt2.y, proInt3.u2) annotation (Line(points={{62,-60},{100,-60},{
          100,34},{118,34}},  color={255,127,0}));
  connect(proInt3.y, proInt4.u1) annotation (Line(points={{142,40},{150,40},{150,
          26},{158,26}}, color={255,127,0}));
  connect(disChiInd.y, proInt4.u2) annotation (Line(points={{62,-130},{90,-130},
          {90,14},{158,14}}, color={255,127,0}));
  connect(dowPro.y, booToInt4.u)
    annotation (Line(points={{-78,110},{-62,110}}, color={255,0,255}));
  connect(booToInt4.y, proInt5.u1) annotation (Line(points={{-38,110},{70,110},{
          70,-124},{118,-124}}, color={255,127,0}));
  connect(disChiInd.y, proInt5.u2) annotation (Line(points={{62,-130},{90,-130},
          {90,-136},{118,-136}}, color={255,127,0}));
  connect(booToInt2.y, proInt6.u2) annotation (Line(points={{62,-60},{100,-60},{
          100,-186},{118,-186}}, color={255,127,0}));
  connect(booToInt4.y, proInt6.u1) annotation (Line(points={{-38,110},{70,110},{
          70,-174},{118,-174}}, color={255,127,0}));
  connect(proInt6.y, proInt7.u1) annotation (Line(points={{142,-180},{150,-180},
          {150,-194},{158,-194}}, color={255,127,0}));
  connect(enaChiInd.y, proInt7.u2) annotation (Line(points={{62,40},{80,40},{80,
          -206},{158,-206}}, color={255,127,0}));
  connect(endPro, dowPro.clr) annotation (Line(points={{-280,-190},{-210,-190},{
          -210,104},{-102,104}}, color={255,0,255}));
  connect(endPro, upPro.clr) annotation (Line(points={{-280,-190},{-210,-190},{-210,
          154},{-102,154}}, color={255,0,255}));
  connect(endPro, booRep.u)
    annotation (Line(points={{-280,-190},{-142,-190}}, color={255,0,255}));
  connect(uChiSet, falEdg.u) annotation (Line(points={{-280,-20},{-242,-20}},
          color={255,0,255}));
  connect(upPro.y, yUp) annotation (Line(points={{-78,160},{-70,160},{-70,200},{
          300,200}}, color={255,0,255}));
  connect(dowPro.y, yDow) annotation (Line(points={{-78,110},{-70,110},{-70,140},
          {300,140}},color={255,0,255}));
  connect(upPro.y, intSwi1.u2) annotation (Line(points={{-78,160},{-70,160},{-70,
          200},{200,200},{200,90},{238,90}}, color={255,0,255}));
  connect(proInt2.y, intSwi1.u1) annotation (Line(points={{142,90},{180,90},{180,
          98},{238,98}}, color={255,127,0}));
  connect(one.y, intSwi1.u3) annotation (Line(points={{142,-40},{220,-40},{220,82},
          {238,82}}, color={255,127,0}));
  connect(intSwi1.y, yNexEnaChi)
    annotation (Line(points={{262,90},{300,90}}, color={255,127,0}));
  connect(upPro.y, intSwi.u2) annotation (Line(points={{-78,160},{-70,160},{-70,
          200},{200,200},{200,40},{238,40}}, color={255,0,255}));
  connect(proInt4.y, intSwi.u1) annotation (Line(points={{182,20},{210,20},{210,
          48},{238,48}}, color={255,127,0}));
  connect(one.y, intSwi.u3) annotation (Line(points={{142,-40},{220,-40},{220,32},
          {238,32}}, color={255,127,0}));
  connect(intSwi.y, yDisSmaChi)
    annotation (Line(points={{262,40},{300,40}}, color={255,127,0}));
  connect(intSwi3.y, yLasDisChi)
    annotation (Line(points={{262,-100},{300,-100}}, color={255,127,0}));
  connect(dowPro.y, intSwi3.u2) annotation (Line(points={{-78,110},{-70,110},{-70,
          140},{190,140},{190,-100},{238,-100}}, color={255,0,255}));
  connect(dowPro.y, intSwi2.u2) annotation (Line(points={{-78,110},{-70,110},{-70,
          140},{190,140},{190,-150},{238,-150}}, color={255,0,255}));
  connect(proInt5.y, intSwi3.u1) annotation (Line(points={{142,-130},{180,-130},
          {180,-92},{238,-92}}, color={255,127,0}));
  connect(proInt7.y, intSwi2.u1) annotation (Line(points={{182,-200},{200,-200},
          {200,-142},{238,-142}}, color={255,127,0}));
  connect(intSwi2.y, yEnaSmaChi)
    annotation (Line(points={{262,-150},{300,-150}}, color={255,127,0}));
  connect(one.y, intSwi3.u3) annotation (Line(points={{142,-40},{220,-40},{220,-108},
          {238,-108}}, color={255,127,0}));
  connect(one.y, intSwi2.u3) annotation (Line(points={{142,-40},{220,-40},{220,-158},
          {238,-158}}, color={255,127,0}));
  connect(cha.up, upPro.u) annotation (
    Line(points={{-218,136},{-120,136},{-120,160},{-102,160}}, color = {255, 0, 255}));
  connect(con2.y, truDel.u)
    annotation (Line(points={{-218,-80},{-202,-80}}, color={255,0,255}));
  connect(truDel.y, logSwi1.u2)
    annotation (Line(points={{-178,-80},{-142,-80}}, color={255,0,255}));
  connect(falEdg.y, logSwi1.u1) annotation (Line(points={{-218,-20},{-150,-20},{
          -150,-72},{-142,-72}}, color={255,0,255}));
  connect(con.y, logSwi1.u3) annotation (Line(points={{-218,-120},{-160,-120},{-160,
          -88},{-142,-88}}, color={255,0,255}));
  connect(logSwi1.y, disChi.u) annotation (Line(points={{-118,-80},{-102,-80}},
          color={255,0,255}));
  connect(truDel.y, logSwi2.u2) annotation (Line(points={{-178,-80},{-170,-80},{
          -170,40},{-142,40}}, color={255,0,255}));
  connect(logSwi2.y, enaChi.u)
    annotation (Line(points={{-118,40},{-102,40}}, color={255,0,255}));
  connect(con.y, logSwi2.u3) annotation (Line(points={{-218,-120},{-160,-120},{-160,
          32},{-142,32}}, color={255,0,255}));
  connect(edg.y, logSwi2.u1) annotation (Line(points={{-218,40},{-180,40},{-180,
          48},{-142,48}}, color={255,0,255}));
annotation (
  defaultComponentName="nexChi",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-260,-220},{280,220}})),
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
          extent={{50,50},{98,30}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yNexEnaChi"),
        Text(
          extent={{-98,-62},{-64,-74}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="endPro"),
        Text(
          extent={{50,20},{98,0}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yDisSmaChi"),
        Text(
          extent={{50,-48},{98,-68}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yDisLasChi"),
        Text(
          extent={{44,-78},{98,-100}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yEnaSmaChi"),
        Text(
          extent={{54,-22},{96,-34}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yOnOff"),
      Text(
        extent={{-100,100},{100,-100}},
        textColor={0,0,0},
          textString="?"),
        Text(
          extent={{60,96},{102,84}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yUp"),
        Text(
          extent={{60,76},{102,64}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yDow")}),
Documentation(info="<html>
<p>
This block identifies index of next enabling (<code>yNexEnaChi</code> and 
<code>yEnaSmaChi</code>) or disabling chiller (<code>yDisSmaChi</code> and 
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
<p>
<b>Note that when applying the sequence</b>:
</p>
<ul>
<li>
If it is not in the staging process, the outputs <code>yNexEnaChi</code>,
<code>yDisSmaChi</code>, <code>yLasDisChi</code>, <code>yEnaSmaChi</code> equal 1.
The <code>yOnOff</code> is <code>false</code>.
</li>
<li>
If it is in the staging up process (<code>yUp=true</code>), the outputs
<code>yLasDisChi</code> and <code>yEnaSmaChi</code>, which becomes valid only when
it is in staging down process, equal to the default 1. 
</li>
<li>
If it is in the staging down process (<code>yDow=true</code>), the outputs
<code>yNexEnaChi</code> and <code>yDisSmaChi</code>, which becomes valid only when
it is in staging up process, equal to the default 1. 
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
May 06, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end NextChiller;
