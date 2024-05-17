within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block NextChiller "Identify next enable and disable chillers"

  parameter Integer nChi=2 "Total number of chillers";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaSet
    "Chiller stage setpoint"
    annotation (Placement(transformation(extent={{-280,110},{-240,150}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiSet[nChi]
    "Vector of chillers status setpoint"
    annotation (Placement(transformation(extent={{-280,-40},{-240,0}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput endPro
    "True: the staging process is end"
    annotation (Placement(transformation(extent={{-280,-180},{-240,-140}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yUp
    "True if it is in staging up process"
    annotation (Placement(transformation(extent={{240,180},{280,220}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDow
    "True if it is in staging down process"
    annotation (Placement(transformation(extent={{240,120},{280,160}}),
        iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yNexEnaChi
    "Next enabling chiller index"
    annotation (Placement(transformation(extent={{240,70},{280,110}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yDisSmaChi
    "Smaller chiller to be disabled in staging-up process"
    annotation (Placement(transformation(extent={{240,20},{280,60}}),
      iconTransformation(extent={{100,-12},{140,28}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOnOff
    "True: if the stage change require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{240,-40},{280,0}}),
      iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLasDisChi
    "Disable last chiller when it is in stage-down process"
    annotation (Placement(transformation(extent={{240,-120},{280,-80}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yEnaSmaChi
    "Smaller chiller to be enabled in stage-down process"
    annotation (Placement(transformation(extent={{240,-170},{280,-130}}),
      iconTransformation(extent={{100,-110},{140,-70}})));

protected
  parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nChi]
    "Boolean to integer"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nChi]
    "Boolean to integer"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2
    "Boolean to integer"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3
    "Boolean to integer"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt4
    "Boolean to integer"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant chiIndVec[nChi](
    final k=chiInd) "Vector of chiller index"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-180,-170},{-160,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1) "Constant 1"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Change cha
    "Check if it is stage up or stage down"
    annotation (Placement(transformation(extent={{-220,120},{-200,140}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg[nChi]
    "Check if the chiller is being enabled"
    annotation (Placement(transformation(extent={{-220,30},{-200,50}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg[nChi]
    "Check if the chiller is being disabled"
    annotation (Placement(transformation(extent={{-220,-110},{-200,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Latch enaChi[nChi]
    "True when the chiller should be enabled"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Controls.OBC.CDL.Logical.Latch disChi[nChi]
    "True when the chiller should be disabled"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyEnaChi(final nin=nChi)
    "Check if there is any enabling chiller"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyDisChi(final nin=nChi)
    "Check if there is any disabling chiller"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And enaDis
    "Check if enabling and disabling chillers at the same process"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt[nChi]
    "Find out the index of enabling chiller"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt1[nChi]
    "Find out the index of disabling chiller"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum enaChiInd(final nin = nChi)
    "Enabling chiller index"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum disChiInd(final nin = nChi)
    "Disabling chiller index"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Latch upPro
    "True when it is in stage up process"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Controls.OBC.CDL.Logical.Latch dowPro
    "True when it is in stage down process"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt2
    "Find out the index of enabling chiller"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt3
    "Staging up process and it requires chiller on and off"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt4
    "Disabling chiller during stage up process"
    annotation (Placement(transformation(extent={{120,10},{140,30}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt5
    "Find out the index of disabling chiller"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt6
    "Staging down process and it requires chiller on and off"
    annotation (Placement(transformation(extent={{80,-160},{100,-140}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt7
    "Enabling chiller during stage down process"
    annotation (Placement(transformation(extent={{120,-180},{140,-160}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    "Output 1 when it is not in the staging up process"
    annotation (Placement(transformation(extent={{200,30},{220,50}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    "Output 1 when it is not in the staging up process"
    annotation (Placement(transformation(extent={{200,80},{220,100}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi2
    "Output 1 when it is not in the staging down process"
    annotation (Placement(transformation(extent={{200,-160},{220,-140}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi3
    "Output 1 when it is not in the staging down process"
    annotation (Placement(transformation(extent={{200,-110},{220,-90}})));

equation
  connect(uChiSet, edg.u) annotation (Line(points={{-260,-20},{-230,-20},{-230,40},
          {-222,40}},       color={255,0,255}));
  connect(edg.y, enaChi.u)
    annotation (Line(points={{-198,40},{-142,40}},   color={255,0,255}));
  connect(falEdg.y, disChi.u)
    annotation (Line(points={{-198,-100},{-142,-100}}, color={255,0,255}));
  connect(booRep.y, enaChi.clr) annotation (Line(points={{-158,-160},{-150,-160},
          {-150,34},{-142,34}},   color={255,0,255}));
  connect(booRep.y, disChi.clr) annotation (Line(points={{-158,-160},{-150,-160},
          {-150,-106},{-142,-106}}, color={255,0,255}));
  connect(enaChi.y, anyEnaChi.u) annotation (Line(points={{-118,40},{-110,40},{-110,
          -20},{-102,-20}}, color={255,0,255}));
  connect(anyEnaChi.y, enaDis.u1) annotation (Line(points={{-78,-20},{-42,-20}},
                          color={255,0,255}));
  connect(disChi.y, anyDisChi.u) annotation (Line(points={{-118,-100},{-110,-100},
          {-110,-60},{-102,-60}}, color={255,0,255}));
  connect(anyDisChi.y, enaDis.u2) annotation (Line(points={{-78,-60},{-50,-60},{
          -50,-28},{-42,-28}}, color={255,0,255}));
  connect(enaDis.y, yOnOff) annotation (Line(points={{-18,-20},{260,-20}},
               color={255,0,255}));
  connect(uStaSet, cha.u)
    annotation (Line(points={{-260,130},{-222,130}}, color={255,127,0}));
  connect(disChi.y, booToInt1.u)
    annotation (Line(points={{-118,-100},{-102,-100}}, color={255,0,255}));
  connect(enaChi.y, booToInt.u)
    annotation (Line(points={{-118,40},{-102,40}}, color={255,0,255}));
  connect(booToInt.y, proInt.u1) annotation (Line(points={{-78,40},{-60,40},{-60,
          46},{-42,46}}, color={255,127,0}));
  connect(booToInt1.y, proInt1.u2) annotation (Line(points={{-78,-100},{-60,-100},
          {-60,-106},{-42,-106}}, color={255,127,0}));
  connect(chiIndVec.y, proInt.u2) annotation (Line(points={{-118,0},{-60,0},{-60,
          34},{-42,34}}, color={255,127,0}));
  connect(proInt.y, enaChiInd.u)
    annotation (Line(points={{-18,40},{-2,40}}, color={255,127,0}));
  connect(chiIndVec.y, proInt1.u1) annotation (Line(points={{-118,0},{-60,0},{-60,
          -94},{-42,-94}}, color={255,127,0}));
  connect(proInt1.y, disChiInd.u)
    annotation (Line(points={{-18,-100},{-2,-100}}, color={255,127,0}));
  connect(cha.down, dowPro.u) annotation (Line(points={{-198,124},{-160,124},{-160,
          80},{-142,80}}, color={255,0,255}));
  connect(enaDis.y, booToInt2.u) annotation (Line(points={{-18,-20},{-10,-20},{-10,
          -60},{-2,-60}}, color={255,0,255}));
  connect(upPro.y, booToInt3.u)
    annotation (Line(points={{-118,160},{-102,160}}, color={255,0,255}));
  connect(booToInt3.y, proInt2.u1) annotation (Line(points={{-78,160},{70,160},{
          70,96},{78,96}},      color={255,127,0}));
  connect(enaChiInd.y, proInt2.u2) annotation (Line(points={{22,40},{40,40},{40,
          84},{78,84}},    color={255,127,0}));
  connect(booToInt3.y, proInt3.u1) annotation (Line(points={{-78,160},{70,160},
          {70,46},{78,46}},    color={255,127,0}));
  connect(booToInt2.y, proInt3.u2) annotation (Line(points={{22,-60},{60,-60},{
          60,34},{78,34}},    color={255,127,0}));
  connect(proInt3.y, proInt4.u1) annotation (Line(points={{102,40},{110,40},{
          110,26},{118,26}}, color={255,127,0}));
  connect(disChiInd.y, proInt4.u2) annotation (Line(points={{22,-100},{50,-100},
          {50,14},{118,14}},   color={255,127,0}));
  connect(dowPro.y, booToInt4.u)
    annotation (Line(points={{-118,80},{-102,80}}, color={255,0,255}));
  connect(booToInt4.y, proInt5.u1) annotation (Line(points={{-78,80},{30,80},{30,
          -94},{78,-94}},  color={255,127,0}));
  connect(disChiInd.y, proInt5.u2) annotation (Line(points={{22,-100},{50,-100},
          {50,-106},{78,-106}},  color={255,127,0}));
  connect(booToInt2.y, proInt6.u2) annotation (Line(points={{22,-60},{60,-60},{60,
          -156},{78,-156}},      color={255,127,0}));
  connect(booToInt4.y, proInt6.u1) annotation (Line(points={{-78,80},{30,80},{30,
          -144},{78,-144}},  color={255,127,0}));
  connect(proInt6.y, proInt7.u1) annotation (Line(points={{102,-150},{110,-150},
          {110,-164},{118,-164}}, color={255,127,0}));
  connect(enaChiInd.y, proInt7.u2) annotation (Line(points={{22,40},{40,40},{40,
          -176},{118,-176}}, color={255,127,0}));
  connect(endPro, dowPro.clr) annotation (Line(points={{-260,-160},{-190,-160},{
          -190,74},{-142,74}}, color={255,0,255}));
  connect(endPro, upPro.clr) annotation (Line(points={{-260,-160},{-190,-160},{-190,
          154},{-142,154}}, color={255,0,255}));
  connect(endPro, booRep.u)
    annotation (Line(points={{-260,-160},{-182,-160}}, color={255,0,255}));
  connect(uChiSet, falEdg.u) annotation (Line(points={{-260,-20},{-230,-20},{-230,
          -100},{-222,-100}},      color={255,0,255}));
  connect(upPro.y, yUp) annotation (Line(points={{-118,160},{-110,160},{-110,200},
          {260,200}},color={255,0,255}));
  connect(dowPro.y, yDow) annotation (Line(points={{-118,80},{-110,80},{-110,140},
          {260,140}},color={255,0,255}));
  connect(upPro.y, intSwi1.u2) annotation (Line(points={{-118,160},{-110,160},{-110,
          200},{160,200},{160,90},{198,90}}, color={255,0,255}));
  connect(proInt2.y, intSwi1.u1) annotation (Line(points={{102,90},{140,90},{140,
          98},{198,98}}, color={255,127,0}));
  connect(one.y, intSwi1.u3) annotation (Line(points={{102,-40},{180,-40},{180,82},
          {198,82}}, color={255,127,0}));
  connect(intSwi1.y, yNexEnaChi)
    annotation (Line(points={{222,90},{260,90}}, color={255,127,0}));
  connect(upPro.y, intSwi.u2) annotation (Line(points={{-118,160},{-110,160},{-110,
          200},{160,200},{160,40},{198,40}}, color={255,0,255}));
  connect(proInt4.y, intSwi.u1) annotation (Line(points={{142,20},{170,20},{170,
          48},{198,48}}, color={255,127,0}));
  connect(one.y, intSwi.u3) annotation (Line(points={{102,-40},{180,-40},{180,32},
          {198,32}}, color={255,127,0}));
  connect(intSwi.y, yDisSmaChi)
    annotation (Line(points={{222,40},{260,40}}, color={255,127,0}));
  connect(intSwi3.y, yLasDisChi)
    annotation (Line(points={{222,-100},{260,-100}}, color={255,127,0}));
  connect(dowPro.y, intSwi3.u2) annotation (Line(points={{-118,80},{-110,80},{-110,
          140},{150,140},{150,-100},{198,-100}}, color={255,0,255}));
  connect(dowPro.y, intSwi2.u2) annotation (Line(points={{-118,80},{-110,80},{-110,
          140},{150,140},{150,-150},{198,-150}}, color={255,0,255}));
  connect(proInt5.y, intSwi3.u1) annotation (Line(points={{102,-100},{140,-100},
          {140,-92},{198,-92}}, color={255,127,0}));
  connect(proInt7.y, intSwi2.u1) annotation (Line(points={{142,-170},{160,-170},
          {160,-142},{198,-142}}, color={255,127,0}));
  connect(intSwi2.y, yEnaSmaChi)
    annotation (Line(points={{222,-150},{260,-150}}, color={255,127,0}));
  connect(one.y, intSwi3.u3) annotation (Line(points={{102,-40},{180,-40},{180,-108},
          {198,-108}}, color={255,127,0}));
  connect(one.y, intSwi2.u3) annotation (Line(points={{102,-40},{180,-40},{180,-158},
          {198,-158}}, color={255,127,0}));
  connect(cha.up, upPro.u) annotation (
    Line(points = {{-198, 136}, {-160, 136}, {-160, 160}, {-142, 160}}, color = {255, 0, 255}));

annotation (
  defaultComponentName="nexChi",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-240,-220},{240,220}})),
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
