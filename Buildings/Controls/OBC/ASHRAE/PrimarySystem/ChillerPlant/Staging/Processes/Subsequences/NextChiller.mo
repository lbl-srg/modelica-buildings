within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block NextChiller
  "Sequence for selecting next chiller to be enabled or disabled"

  parameter Integer nChi "Total number of chillers";
  parameter Boolean havePonyChiller = false
    "Flag to indicate if there is pony chiller";
  parameter Integer totChiSta
    "Total number of stages that do not have waterside economizer being enabled, zero stage should be seem as one stage";
  parameter Boolean upOnOffSta[totChiSta]
    "Flag of the stage when staging up to it, need to turn off small chiller, the array size should be total numble of non-WSE stage plus 1"
    annotation (Dialog(enable=havePonyChiller));
  parameter Boolean dowOnOffSta[totChiSta]
    "Flag of the stage when staging down to it, need to turn on small chiller, the array size should be total numble of non-WSE stage plus 1"
    annotation (Dialog(enable=havePonyChiller));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiPri[nChi]
    "Chiller enabling priority"
    annotation (Placement(transformation(extent={{-280,210},{-240,250}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiEna[nChi]
    "Chiller enabling status: true=ON"
    annotation (Placement(transformation(extent={{-280,170},{-240,210}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp
    "Stage up status: true=stage-up"
    annotation (Placement(transformation(extent={{-280,140},{-240,180}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Stage down status: true=stage-down"
    annotation (Placement(transformation(extent={{-280,-120},{-240,-80}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage index, does not include stages like X + WSE"
    annotation (Placement(transformation(extent={{-280,-80},{-240,-40}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yNexEnaChi
    "Next enabling chiller index"
    annotation (Placement(transformation(extent={{240,190},{280,230}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yDisSmaChi
    "Smaller chiller to be disabled in staging-up process"
    annotation (Placement(transformation(extent={{240,20},{280,60}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOnOff
    "Indicate if the stage require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{240,-60},{280,-20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLasDisChi
    "Disable last chiller when it is in stage-down process"
    annotation (Placement(transformation(extent={{240,-140},{280,-100}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yEnaSmaChi
    "Smaller chiller to be enabled in stage-down process"
    annotation (Placement(transformation(extent={{240,-240},{280,-200}}),
      iconTransformation(extent={{100,-110},{140,-70}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nChi]
    "Convert integer to real number"
    annotation (Placement(transformation(extent={{-60,220},{-40,240}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-180,180},{-160,200}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(final nin=nChi)
    "Sum up multiple inputs"
    annotation (Placement(transformation(extent={{-140,180},{-120,200}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter enaNexChi(
    final p=1, final k=1) "Enabling one more chiller"
    annotation (Placement(transformation(extent={{-80,180},{-60,200}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{160,200},{180,220}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexEnaChi(final nin=nChi)
    "New operating chiller at current stage"
    annotation (Placement(transformation(extent={{60,220},{80,240}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter disLasChi(
    final p=1, final k=1)
    "Next chiller in the prority array"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And  and2 "Logical and"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor disSmaChi(
    final nin=nChi) "Disable smaller chiller"
    annotation (Placement(transformation(extent={{60,130},{80,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con7(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch  swi3 "Logical switch"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{200,30},{220,50}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexDisChi(final nin=nChi)
    "Disable last chiller"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{20,-210},{40,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2 "Logical switch"
    annotation (Placement(transformation(extent={{120,-210},{140,-190}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor enaSmaChi(final nin=nChi)
    "Enable smaller chiller"
    annotation (Placement(transformation(extent={{60,-150},{80,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{60,-250},{80,-230}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt6
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{160,-130},{180,-110}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt7
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{200,-230},{220,-210}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{20,150},{40,170}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt4
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conInt1[totChiSta](
    final k=dowOnOffSta) if havePonyChiller
    "Stage index that when staging down to the stage, need to turn on small chiller"
    annotation (Placement(transformation(extent={{-220,-230},{-200,-210}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt5
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{20,-170},{40,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical or"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conInt2[totChiSta](
    final k=upOnOffSta) if havePonyChiller
    "Stage index that when staging up to the stage, need to turn off small chiller"
    annotation (Placement(transformation(extent={{-220,50},{-200,70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi4 "Logical switch"
    annotation (Placement(transformation(extent={{120,200},{140,220}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi5 "Logical switch"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ponChi(
    final k=havePonyChiller)
    "Indicate if there is pony chiller"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conInt3[totChiSta](
    final k=fill(false, totChiSta)) if not havePonyChiller
    "No OnOff chiller"
    annotation (Placement(transformation(extent={{-220,-10},{-200,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi6 "Logical switch"
    annotation (Placement(transformation(extent={{160,30},{180,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi7 "Logical switch"
    annotation (Placement(transformation(extent={{160,-230},{180,-210}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[totChiSta]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(
    final nin=totChiSta)
    "Identify stage that need chiller on-off"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=0.5)
    "Check if the stage change needs one chiller off and one chiller on"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2[totChiSta]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-120,-230},{-100,-210}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig1(
    final nin=totChiSta)
    "Identify stage that need chiller on-off"
    annotation (Placement(transformation(extent={{-80,-230},{-60,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr1(
    final threshold=0.5)
    "Check if the stage change needs one chiller off and one chiller on"
    annotation (Placement(transformation(extent={{-40,-230},{-20,-210}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt "Add two integer inputs"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));

equation
  connect(uChiPri,intToRea. u)
    annotation (Line(points={{-260,230},{-62,230}}, color={255,127,0}));
  connect(intToRea.y, nexEnaChi.u)
    annotation (Line(points={{-38,230},{58,230}}, color={0,0,127}));
  connect(uChiEna, booToRea.u)
    annotation (Line(points={{-260,190},{-182,190}}, color={255,0,255}));
  connect(mulSum.y, enaNexChi.u)
    annotation (Line(points={{-118,190},{-82,190}}, color={0,0,127}));
  connect(uStaUp, swi.u2)
    annotation (Line(points={{-260,160},{-42,160}}, color={255,0,255}));
  connect(enaNexChi.y, swi.u1)
    annotation (Line(points={{-58,190},{-50,190},{-50,168},{-42,168}},
      color={0,0,127}));
  connect(mulSum.y, swi.u3)
    annotation (Line(points={{-118,190},{-100,190},{-100,152},{-42,152}},
      color={0,0,127}));
  connect(booToRea.y, mulSum.u)
    annotation (Line(points={{-158,190},{-142,190}}, color={0,0,127}));
  connect(reaToInt1.y, yNexEnaChi)
    annotation (Line(points={{182,210},{260,210}}, color={255,127,0}));
  connect(uStaDow, swi1.u2)
    annotation (Line(points={{-260,-100},{-42,-100}}, color={255,0,255}));
  connect(uStaUp, and2.u1)
    annotation (Line(points={{-260,160},{-110,160},{-110,90},{-42,90}},
      color={255,0,255}));
  connect(intToRea.y, disSmaChi.u)
    annotation (Line(points={{-38,230},{0,230},{0,140},{58,140}},
      color={0,0,127}));
  connect(mulSum.y, reaToInt.u)
    annotation (Line(points={{-118,190},{-100,190},{-100,110},{18,110}},
      color={0,0,127}));
  connect(reaToInt.y, disSmaChi.index)
    annotation (Line(points={{42,110},{70,110},{70,128}}, color={255,127,0}));
  connect(and2.y, swi3.u2)
    annotation (Line(points={{-18,90},{118,90}}, color={255,0,255}));
  connect(con7.y, swi3.u3)
    annotation (Line(points={{82,70},{90,70},{90,82},{118,82}}, color={0,0,127}));
  connect(disSmaChi.y, swi3.u1)
    annotation (Line(points={{82,140},{100,140},{100,98},{118,98}}, color={0,0,127}));
  connect(swi.y, reaToInt3.u)
    annotation (Line(points={{-18,160},{18,160}}, color={0,0,127}));
  connect(reaToInt3.y, nexEnaChi.index)
    annotation (Line(points={{42,160},{70,160},{70,218}}, color={255,127,0}));
  connect(reaToInt2.y, yDisSmaChi)
    annotation (Line(points={{222,40},{260,40}}, color={255,127,0}));
  connect(intToRea.y, nexDisChi.u)
    annotation (Line(points={{-38,230},{0,230},{0,-80},{58,-80}}, color={0,0,127}));
  connect(swi1.y, reaToInt4.u)
    annotation (Line(points={{-18,-100},{18,-100}}, color={0,0,127}));
  connect(reaToInt4.y, nexDisChi.index)
    annotation (Line(points={{42,-100},{70,-100},{70,-92}}, color={255,127,0}));
  connect(uStaDow, and1.u1)
    annotation (Line(points={{-260,-100},{-120,-100},{-120,-200},{18,-200}},
      color={255,0,255}));
  connect(mulSum.y, swi1.u1)
    annotation (Line(points={{-118,190},{-100,190},{-100,-92},{-42,-92}},
      color={0,0,127}));
  connect(mulSum.y, disLasChi.u)
    annotation (Line(points={{-118,190},{-100,190},{-100,-140},{-82,-140}},
      color={0,0,127}));
  connect(disLasChi.y, swi1.u3)
    annotation (Line(points={{-58,-140},{-50,-140},{-50,-108},{-42,-108}},
      color={0,0,127}));
  connect(disLasChi.y, reaToInt5.u)
    annotation (Line(points={{-58,-140},{-50,-140},{-50,-160},{18,-160}},
      color={0,0,127}));
  connect(reaToInt5.y, enaSmaChi.index)
    annotation (Line(points={{42,-160},{70,-160},{70,-152}},
      color={255,127,0}));
  connect(intToRea.y, enaSmaChi.u)
    annotation (Line(points={{-38,230},{0,230},{0,-140},{58,-140}},
      color={0,0,127}));
  connect(and1.y, swi2.u2)
    annotation (Line(points={{42,-200},{118,-200}},
      color={255,0,255}));
  connect(enaSmaChi.y, swi2.u1)
    annotation (Line(points={{82,-140},{100,-140},{100,-192},{118,-192}},
      color={0,0,127}));
  connect(con1.y, swi2.u3)
    annotation (Line(points={{82,-240},{110,-240},{110,-208},{118,-208}},
      color={0,0,127}));
  connect(reaToInt6.y,yLasDisChi)
    annotation (Line(points={{182,-120},{260,-120}}, color={255,127,0}));
  connect(reaToInt7.y, yEnaSmaChi)
    annotation (Line(points={{222,-220},{260,-220}}, color={255,127,0}));
  connect(and1.y, or2.u2)
    annotation (Line(points={{42,-200},{50,-200},{50,-48},{58,-48}},
      color={255,0,255}));
  connect(and2.y, or2.u1)
    annotation (Line(points={{-18,90},{20,90},{20,-40},{58,-40}},
      color={255,0,255}));
  connect(or2.y, yOnOff)
    annotation (Line(points={{82,-40},{260,-40}}, color={255,0,255}));
  connect(conInt2.y, booToRea1.u)
    annotation (Line(points={{-198,60},{-182,60}}, color={255,0,255}));
  connect(booToRea1.y, extIndSig.u)
    annotation (Line(points={{-158,60},{-142,60}}, color={0,0,127}));
  connect(extIndSig.y, greEquThr.u)
    annotation (Line(points={{-118,60},{-82,60}}, color={0,0,127}));
  connect(greEquThr.y, and2.u2)
    annotation (Line(points={{-58,60},{-50,60},{-50,82},{-42,82}},
      color={255,0,255}));
  connect(conInt1.y, booToRea2.u)
    annotation (Line(points={{-198,-220},{-122,-220}}, color={255,0,255}));
  connect(booToRea2.y, extIndSig1.u)
    annotation (Line(points={{-98,-220},{-82,-220}}, color={0,0,127}));
  connect(extIndSig1.y, greEquThr1.u)
    annotation (Line(points={{-58,-220},{-42,-220}}, color={0,0,127}));
  connect(greEquThr1.y, and1.u2)
    annotation (Line(points={{-18,-220},{0,-220},{0,-208},{18,-208}},
      color={255,0,255}));
  connect(conInt.y, addInt.u2)
    annotation (Line(points={{-138,-80},{-120,-80},{-120,-66},{-82,-66}},
      color={255,127,0}));
  connect(uChiSta, addInt.u1)
    annotation (Line(points={{-260,-60},{-180,-60},{-180,-54},{-82,-54}},
      color={255,127,0}));
  connect(addInt.y, extIndSig.index)
    annotation (Line(points={{-58,-60},{-40,-60},{-40,-40},{-130,-40},
      {-130,48}}, color={255,127,0}));
  connect(addInt.y, extIndSig1.index)
    annotation (Line(points={{-58,-60},{-40,-60},{-40,-40},{-170,-40},
      {-170,-240},{-70,-240},{-70,-232}}, color={255,127,0}));
  connect(nexEnaChi.y, swi4.u1)
    annotation (Line(points={{82,230},{100,230},{100,218},{118,218}},
      color={0,0,127}));
  connect(uStaUp, swi4.u2)
    annotation (Line(points={{-260,160},{-110,160},{-110,210},{118,210}},
      color={255,0,255}));
  connect(con7.y, swi4.u3)
    annotation (Line(points={{82,70},{90,70},{90,202},{118,202}}, color={0,0,127}));
  connect(swi4.y, reaToInt1.u)
    annotation (Line(points={{142,210},{158,210}}, color={0,0,127}));
  connect(swi5.y, reaToInt6.u)
    annotation (Line(points={{142,-120},{158,-120}}, color={0,0,127}));
  connect(uStaDow, swi5.u2)
    annotation (Line(points={{-260,-100},{-120,-100},{-120,-120},{118,-120}},
      color={255,0,255}));
  connect(nexDisChi.y, swi5.u1)
    annotation (Line(points={{82,-80},{100,-80},{100,-112},{118,-112}},
      color={0,0,127}));
  connect(con1.y, swi5.u3)
    annotation (Line(points={{82,-240},{110,-240},{110,-128},{118,-128}},
      color={0,0,127}));
  connect(conInt3.y, booToRea1.u)
    annotation (Line(points={{-198,0},{-190,0},{-190,60},{-182,60}},
      color={255,0,255}));
  connect(conInt3.y, booToRea2.u)
    annotation (Line(points={{-198,0},{-190,0},{-190,-220},{-122,-220}},
      color={255,0,255}));
  connect(ponChi.y, swi6.u2)
    annotation (Line(points={{82,0},{90,0},{90,40},{158,40}}, color={255,0,255}));
  connect(swi3.y, swi6.u1)
    annotation (Line(points={{142,90},{150,90},{150,48},{158,48}},
      color={0,0,127}));
  connect(con7.y, swi6.u3)
    annotation (Line(points={{82,70},{120,70},{120,32},{158,32}},
      color={0,0,127}));
  connect(swi6.y, reaToInt2.u)
    annotation (Line(points={{182,40},{198,40}}, color={0,0,127}));
  connect(ponChi.y, swi7.u2)
    annotation (Line(points={{82,0},{90,0},{90,-220},{158,-220}},
      color={255,0,255}));
  connect(swi2.y, swi7.u1)
    annotation (Line(points={{142,-200},{150,-200},{150,-212},{158,-212}},
      color={0,0,127}));
  connect(con1.y, swi7.u3)
    annotation (Line(points={{82,-240},{152,-240},{152,-228},{158,-228}},
      color={0,0,127}));
  connect(swi7.y, reaToInt7.u)
    annotation (Line(points={{182,-220},{190,-220},{190,-220},{198,-220}},
      color={0,0,127}));

annotation (
  defaultComponentName="nexChi",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-240,-260},{240,260}})),
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
          extent={{-102,8},{-60,-4}},
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
          extent={{-98,-32},{-64,-46}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uChiSta"),
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
