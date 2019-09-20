within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block NextChiller
  "Sequence for selecting next chiller to be enabled or disabled"

  parameter Integer nChi = 2 "Total number of chillers";
  parameter Boolean havePonChi = false
    "Flag to indicate if there is pony chiller";
  parameter Integer totChiSta = 3
    "Total number of stages that do not have waterside economizer being enabled, zero stage should be seem as one stage";
  parameter Integer upOnOffSta[totChiSta] = {0,0,0}
    "Index of stage when staging up to the stage, need to turn off small chiller. When no stage chang need the change, set it to zeros"
    annotation (Dialog(enable=havePonChi));
  parameter Integer dowOnOffSta[totChiSta] = {0,0,0}
    "Index of stage when staging down to the stage, need to turn on small chiller. When no stage chang need the change, set it to zeros"
    annotation (Dialog(enable=havePonChi));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiPri[nChi]
    "Chiller enabling priority"
    annotation (Placement(transformation(extent={{-240,180},{-200,220}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiEna[nChi]
    "Chiller enabling status: true=ON"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp
    "Stage up status: true=stage-up"
    annotation (Placement(transformation(extent={{-240,110},{-200,150}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Stage down status: true=stage-down"
    annotation (Placement(transformation(extent={{-242,-80},{-202,-40}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta
    "Current chiller stage index, does not include stages like X + WSE"
    annotation (Placement(transformation(extent={{-240,-40},{-200,0}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yNexEnaChi
    "Next enabling chiller index"
    annotation (Placement(transformation(extent={{200,180},{240,220}}),
      iconTransformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yDisSmaChi
    "Smaller chiller to be disabled in staging-up process"
    annotation (Placement(transformation(extent={{200,40},{240,80}}),
      iconTransformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOnOff
    "Indicate if the stage require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLasDisChi
    "Disable last chiller when it is in stage-down process"
    annotation (Placement(transformation(extent={{200,-60},{240,-20}}),
      iconTransformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yEnaSmaChi
    "Smaller chiller to be enabled in stage-down process"
    annotation (Placement(transformation(extent={{200,-180},{240,-140}}),
      iconTransformation(extent={{100,-100},{120,-80}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nChi]
    "Convert integer to real number"
    annotation (Placement(transformation(extent={{-60,190},{-40,210}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-180,150},{-160,170}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(final nin=nChi)
    "Sum up multiple inputs"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter enaNexChi(
    final p=1, final k=1) "Enabling one more chiller"
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{100,190},{120,210}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexEnaChi(final nin=nChi)
    "New operating chiller at current stage"
    annotation (Placement(transformation(extent={{60,190},{80,210}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter disLasChi(
    final p=1, final k=1)
    "Next chiller in the prority array"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[totChiSta]
    "Check if the stage change needs one chiller off and one chiller on"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Controls.OBC.CDL.Logical.And  and2 "Logical and"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor disSmaChi(
    final nin=nChi) "Disable smaller chiller"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con7(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch  swi3 "Logical switch"
    annotation (Placement(transformation(extent={{120,50},{140,70}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{160,50},{180,70}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexDisChi(final nin=nChi)
    "Disable last chiller"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[totChiSta]
    "Check if the stage change needs one chiller off and one chiller on"
    annotation (Placement(transformation(extent={{-140,-190},{-120,-170}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{-40,-170},{-20,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2 "Logical switch"
    annotation (Placement(transformation(extent={{120,-170},{140,-150}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor enaSmaChi(final nin=nChi)
    "Enable smaller chiller"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{60,-210},{80,-190}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt6
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt7
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{160,-170},{180,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[totChiSta](
    final k=upOnOffSta)
    "Stage index that when staging up to the stage, need to turn off small chiller"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt4
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1[totChiSta](
    final k=dowOnOffSta)
    "Stage index that when staging down to the stage, need to turn on small chiller"
    annotation (Placement(transformation(extent={{-180,-210},{-160,-190}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt5
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical or"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep(
    final nout=totChiSta)
    "Replicate integer input"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(final nu=totChiSta)
    "Check if the stage change needs one chiller off and one chiller on"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(final nu=totChiSta)
    "Check if the stage change needs one chiller off and one chiller on"
    annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));

equation
  connect(uChiPri,intToRea. u)
    annotation (Line(points={{-220,200},{-62,200}}, color={255,127,0}));
  connect(intToRea.y, nexEnaChi.u)
    annotation (Line(points={{-38,200},{58,200}}, color={0,0,127}));
  connect(uChiEna, booToRea.u)
    annotation (Line(points={{-220,160},{-182,160}}, color={255,0,255}));
  connect(mulSum.y, enaNexChi.u)
    annotation (Line(points={{-118,160},{-82,160}}, color={0,0,127}));
  connect(nexEnaChi.y, reaToInt1.u)
    annotation (Line(points={{82,200},{98,200}}, color={0,0,127}));
  connect(uStaUp, swi.u2)
    annotation (Line(points={{-220,130},{-42,130}}, color={255,0,255}));
  connect(enaNexChi.y, swi.u1)
    annotation (Line(points={{-58,160},{-50,160},{-50,138},{-42,138}},
      color={0,0,127}));
  connect(mulSum.y, swi.u3)
    annotation (Line(points={{-118,160},{-100,160},{-100,122},{-42,122}},
      color={0,0,127}));
  connect(booToRea.y, mulSum.u)
    annotation (Line(points={{-158,160},{-142,160}}, color={0,0,127}));
  connect(reaToInt1.y, yNexEnaChi)
    annotation (Line(points={{122,200},{220,200}}, color={255,127,0}));
  connect(uStaDow, swi1.u2)
    annotation (Line(points={{-222,-60},{-42,-60}}, color={255,0,255}));
  connect(uStaUp, and2.u1)
    annotation (Line(points={{-220,130},{-120,130},{-120,60},{-42,60}},
      color={255,0,255}));
  connect(intToRea.y, disSmaChi.u)
    annotation (Line(points={{-38,200},{0,200},{0,110},{58,110}},
      color={0,0,127}));
  connect(mulSum.y, reaToInt.u)
    annotation (Line(points={{-118,160},{-100,160},{-100,80},{18,80}},
      color={0,0,127}));
  connect(reaToInt.y, disSmaChi.index)
    annotation (Line(points={{42,80},{70,80},{70,98}}, color={255,127,0}));
  connect(and2.y, swi3.u2)
    annotation (Line(points={{-18,60},{118,60}}, color={255,0,255}));
  connect(con7.y, swi3.u3)
    annotation (Line(points={{82,40},{100,40},{100,52},{118,52}}, color={0,0,127}));
  connect(disSmaChi.y, swi3.u1)
    annotation (Line(points={{82,110},{100,110},{100,68},{118,68}}, color={0,0,127}));
  connect(swi3.y, reaToInt2.u)
    annotation (Line(points={{142,60},{158,60}}, color={0,0,127}));
  connect(swi.y, reaToInt3.u)
    annotation (Line(points={{-18,130},{18,130}}, color={0,0,127}));
  connect(reaToInt3.y, nexEnaChi.index)
    annotation (Line(points={{42,130},{70,130},{70,188}}, color={255,127,0}));
  connect(reaToInt2.y, yDisSmaChi)
    annotation (Line(points={{182,60},{220,60}}, color={255,127,0}));
  connect(intToRea.y, nexDisChi.u)
    annotation (Line(points={{-38,200},{0,200},{0,-40},{58,-40}}, color={0,0,127}));
  connect(swi1.y, reaToInt4.u)
    annotation (Line(points={{-18,-60},{18,-60}}, color={0,0,127}));
  connect(reaToInt4.y, nexDisChi.index)
    annotation (Line(points={{42,-60},{70,-60},{70,-52}}, color={255,127,0}));
  connect(uStaDow, and1.u1)
    annotation (Line(points={{-222,-60},{-120,-60},{-120,-160},{-42,-160}},
      color={255,0,255}));
  connect(mulSum.y, swi1.u1)
    annotation (Line(points={{-118,160},{-100,160},{-100,-52},{-42,-52}},
      color={0,0,127}));
  connect(mulSum.y, disLasChi.u)
    annotation (Line(points={{-118,160},{-100,160},{-100,-100},{-82,-100}},
      color={0,0,127}));
  connect(disLasChi.y, swi1.u3)
    annotation (Line(points={{-58,-100},{-50,-100},{-50,-68},{-42,-68}},
      color={0,0,127}));
  connect(disLasChi.y, reaToInt5.u)
    annotation (Line(points={{-58,-100},{-50,-100},{-50,-120},{18,-120}},
      color={0,0,127}));
  connect(reaToInt5.y, enaSmaChi.index)
    annotation (Line(points={{42,-120},{70,-120},{70,-112}},
      color={255,127,0}));
  connect(intToRea.y, enaSmaChi.u)
    annotation (Line(points={{-38,200},{0,200},{0,-100},{58,-100}},
      color={0,0,127}));
  connect(and1.y, swi2.u2)
    annotation (Line(points={{-18,-160},{118,-160}},
      color={255,0,255}));
  connect(enaSmaChi.y, swi2.u1)
    annotation (Line(points={{82,-100},{100,-100},{100,-152},{118,-152}},
      color={0,0,127}));
  connect(con1.y, swi2.u3)
    annotation (Line(points={{82,-200},{100,-200},{100,-168},{118,-168}},
      color={0,0,127}));
  connect(nexDisChi.y, reaToInt6.u)
    annotation (Line(points={{82,-40},{98,-40}}, color={0,0,127}));
  connect(reaToInt6.y,yLasDisChi)
    annotation (Line(points={{122,-40},{220,-40}}, color={255,127,0}));
  connect(swi2.y, reaToInt7.u)
    annotation (Line(points={{142,-160},{158,-160}}, color={0,0,127}));
  connect(reaToInt7.y, yEnaSmaChi)
    annotation (Line(points={{182,-160},{220,-160}}, color={255,127,0}));
  connect(and1.y, or2.u2)
    annotation (Line(points={{-18,-160},{90,-160},{90,-8},{158,-8}},
      color={255,0,255}));
  connect(and2.y, or2.u1)
    annotation (Line(points={{-18,60},{20,60},{20,0},{158,0}},
      color={255,0,255}));
  connect(or2.y, yOnOff)
    annotation (Line(points={{182,0},{220,0}}, color={255,0,255}));
  connect(uSta, intRep.u)
    annotation (Line(points={{-220,-20},{-182,-20}}, color={255,127,0}));
  connect(intRep.y, intEqu1.u1)
    annotation (Line(points={{-158,-20},{-150,-20},{-150,-180},{-142,-180}},
      color={255,127,0}));
  connect(conInt.y, intEqu.u1)
    annotation (Line(points={{-158,40},{-150,40},{-150,20},{-142,20}},
      color={255,127,0}));
  connect(intRep.y, intEqu.u2)
    annotation (Line(points={{-158,-20},{-150,-20},{-150,12},{-142,12}},
      color={255,127,0}));
  connect(intEqu.y, mulOr.u)
    annotation (Line(points={{-118,20},{-100,20},{-100,20},{-82,20}},
      color={255,0,255}));
  connect(mulOr.y, and2.u2)
    annotation (Line(points={{-58,20},{-50,20},{-50,52},{-42,52}},
      color={255,0,255}));
  connect(intEqu1.y, mulOr1.u)
    annotation (Line(points={{-118,-180},{-100,-180},{-100,-180},{-82,-180}},
      color={255,0,255}));
  connect(mulOr1.y, and1.u2)
    annotation (Line(points={{-58,-180},{-50,-180},{-50,-168},{-42,-168}},
      color={255,0,255}));
  connect(conInt1.y, intEqu1.u2)
    annotation (Line(points={{-158,-200},{-150,-200},{-150,-188},{-142,-188}},
      color={255,127,0}));

annotation (
  defaultComponentName="nexChi",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-200,-220},{200,220}})),
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-100,86},{-64,76}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uChiPri"),
        Text(
          extent={{-98,48},{-56,36}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiEna"),
        Text(
          extent={{-100,8},{-58,-4}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uStaUp"),
        Text(
          extent={{50,100},{98,80}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yNexEnaChi"),
        Text(
          extent={{-100,-74},{-58,-86}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uStaDow"),
        Text(
          extent={{-100,-32},{-76,-46}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uSta"),
        Text(
          extent={{50,52},{98,32}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yDisSmaChi"),
        Text(
          extent={{50,-28},{98,-48}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yDisLasChi"),
        Text(
          extent={{44,-78},{98,-100}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yEnaSmaChi"),
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
This block identifies index of next enable (<code>yNexEnaChi</code> and 
<code>yEnaSmaChi</code>) or disable chiller (<code>yDisSmaChi</code> and 
<code>yLasDisChi</code>) based on current chiller stage <code>uSta</code> and the 
chiller enabling priority <code>uChiPri</code>.
</p>
<ul>
<li>
The integer vector <code>upOnOffSta</code> indicates that when staging up to which 
stage, there will be one smaller chiller being disabled and one larger chiller being
enabled.
</li>
<li>
The integer vector <code>dowOnOffSta</code> indicates that when staging down to which 
stage, there will be one smaller chiller being enabled and one larger chiller being
disabled.
</li>
</ul>
<p>
This implementation assumes that the stage-up process will only enable one more
chiller, or enable a larger chiller and disable a smaller chiller; the stage-down
process will only disable one existing chiller, or disable a larger chiller and
enable a smaller chiller.
</p>
</html>", revisions="<html>
<ul>
<li>
September 15, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end NextChiller;
