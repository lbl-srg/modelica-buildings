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
    annotation (Placement(transformation(extent={{-300,220},{-260,260}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiEna[nChi]
    "Chiller enabling status: true=ON"
    annotation (Placement(transformation(extent={{-300,180},{-260,220}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp
    "Stage up status: true=stage-up"
    annotation (Placement(transformation(extent={{-300,140},{-260,180}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Stage down status: true=stage-down"
    annotation (Placement(transformation(extent={{-300,-120},{-260,-80}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage index, does not include stages like X + WSE"
    annotation (Placement(transformation(extent={{-300,-80},{-260,-40}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yNexEnaChi
    "Next enabling chiller index"
    annotation (Placement(transformation(extent={{260,190},{300,230}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yDisSmaChi
    "Smaller chiller to be disabled in staging-up process"
    annotation (Placement(transformation(extent={{260,20},{300,60}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOnOff
    "Indicate if the stage require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{260,-60},{300,-20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLasDisChi
    "Disable last chiller when it is in stage-down process"
    annotation (Placement(transformation(extent={{260,-140},{300,-100}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yEnaSmaChi
    "Smaller chiller to be enabled in stage-down process"
    annotation (Placement(transformation(extent={{260,-240},{300,-200}}),
      iconTransformation(extent={{100,-110},{140,-70}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nChi]
    "Convert integer to real number"
    annotation (Placement(transformation(extent={{-40,230},{-20,250}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-220,120},{-200,140}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(final nin=nChi)
    "Sum up multiple inputs"
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter enaNexChi(
    final p=1, final k=1) "Enabling one more chiller"
    annotation (Placement(transformation(extent={{-60,180},{-40,200}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{180,200},{200,220}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{-20,150},{0,170}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexEnaChi(final nin=nChi)
    "New operating chiller at current stage"
    annotation (Placement(transformation(extent={{80,230},{100,250}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter disLasChi(
    final p=1, final k=1)
    "Next chiller in the prority array"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And  and2 "Logical and"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor disSmaChi(
    final nin=nChi) "Disable smaller chiller"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con7(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch  swi3 "Logical switch"
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{220,30},{240,50}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexDisChi(final nin=nChi)
    "Disable last chiller"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{40,-210},{60,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2 "Logical switch"
    annotation (Placement(transformation(extent={{140,-210},{160,-190}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor enaSmaChi(final nin=nChi)
    "Enable smaller chiller"
    annotation (Placement(transformation(extent={{80,-150},{100,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{80,-250},{100,-230}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt6
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{180,-130},{200,-110}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt7
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{220,-230},{240,-210}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{40,150},{60,170}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt4
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conInt1[totChiSta](
    final k=dowOnOffSta) if havePonyChiller
    "Stage index that when staging down to the stage, need to turn on small chiller"
    annotation (Placement(transformation(extent={{-200,-230},{-180,-210}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt5
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{40,-170},{60,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical or"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conInt2[totChiSta](
    final k=upOnOffSta) if havePonyChiller
    "Stage index that when staging up to the stage, need to turn off small chiller"
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi4 "Logical switch"
    annotation (Placement(transformation(extent={{140,200},{160,220}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi5 "Logical switch"
    annotation (Placement(transformation(extent={{140,-130},{160,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ponChi(
    final k=havePonyChiller)
    "Indicate if there is pony chiller"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conInt3[totChiSta](
    final k=fill(false, totChiSta)) if not havePonyChiller
    "No OnOff chiller"
    annotation (Placement(transformation(extent={{-200,-30},{-180,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi6 "Logical switch"
    annotation (Placement(transformation(extent={{180,30},{200,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi7 "Logical switch"
    annotation (Placement(transformation(extent={{180,-230},{200,-210}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[totChiSta]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(
    final nin=totChiSta)
    "Identify stage that need chiller on-off"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=0.5)
    "Check if the stage change needs one chiller off and one chiller on"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2[totChiSta]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-100,-230},{-80,-210}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig1(
    final nin=totChiSta)
    "Identify stage that need chiller on-off"
    annotation (Placement(transformation(extent={{-60,-230},{-40,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr1(
    final threshold=0.5)
    "Check if the stage change needs one chiller off and one chiller on"
    annotation (Placement(transformation(extent={{-20,-230},{0,-210}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt "Add two integer inputs"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg[nChi]
    "Rising edge, output true at the moment when input turns from false to true"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(
    final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nChi]
    "Record the old chiller status"
    annotation (Placement(transformation(extent={{-142,120},{-122,140}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1 "Logical or"
    annotation (Placement(transformation(extent={{-240,80},{-220,100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi8[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{-160,180},{-140,200}})));

equation
  connect(uChiPri,intToRea. u)
    annotation (Line(points={{-280,240},{-42,240}}, color={255,127,0}));
  connect(intToRea.y, nexEnaChi.u)
    annotation (Line(points={{-18,240},{78,240}}, color={0,0,127}));
  connect(uChiEna, booToRea.u)
    annotation (Line(points={{-280,200},{-240,200},{-240,130},{-222,130}},
      color={255,0,255}));
  connect(mulSum.y, enaNexChi.u)
    annotation (Line(points={{-98,190},{-62,190}},  color={0,0,127}));
  connect(uStaUp, swi.u2)
    annotation (Line(points={{-280,160},{-22,160}}, color={255,0,255}));
  connect(enaNexChi.y, swi.u1)
    annotation (Line(points={{-38,190},{-30,190},{-30,168},{-22,168}},
      color={0,0,127}));
  connect(mulSum.y, swi.u3)
    annotation (Line(points={{-98,190},{-80,190},{-80,152},{-22,152}},
      color={0,0,127}));
  connect(reaToInt1.y, yNexEnaChi)
    annotation (Line(points={{202,210},{280,210}}, color={255,127,0}));
  connect(uStaDow, swi1.u2)
    annotation (Line(points={{-280,-100},{-22,-100}}, color={255,0,255}));
  connect(uStaUp, and2.u1)
    annotation (Line(points={{-280,160},{-90,160},{-90,90},{-22,90}},
      color={255,0,255}));
  connect(intToRea.y, disSmaChi.u)
    annotation (Line(points={{-18,240},{20,240},{20,140},{78,140}},
      color={0,0,127}));
  connect(mulSum.y, reaToInt.u)
    annotation (Line(points={{-98,190},{-80,190},{-80,110},{38,110}},
      color={0,0,127}));
  connect(reaToInt.y, disSmaChi.index)
    annotation (Line(points={{62,110},{90,110},{90,128}}, color={255,127,0}));
  connect(and2.y, swi3.u2)
    annotation (Line(points={{2,90},{138,90}},   color={255,0,255}));
  connect(con7.y, swi3.u3)
    annotation (Line(points={{102,70},{110,70},{110,82},{138,82}},
      color={0,0,127}));
  connect(disSmaChi.y, swi3.u1)
    annotation (Line(points={{102,140},{120,140},{120,98},{138,98}},color={0,0,127}));
  connect(swi.y, reaToInt3.u)
    annotation (Line(points={{2,160},{38,160}}, color={0,0,127}));
  connect(reaToInt3.y, nexEnaChi.index)
    annotation (Line(points={{62,160},{90,160},{90,228}}, color={255,127,0}));
  connect(reaToInt2.y, yDisSmaChi)
    annotation (Line(points={{242,40},{280,40}}, color={255,127,0}));
  connect(intToRea.y, nexDisChi.u)
    annotation (Line(points={{-18,240},{20,240},{20,-80},{78,-80}},
      color={0,0,127}));
  connect(swi1.y, reaToInt4.u)
    annotation (Line(points={{2,-100},{38,-100}},   color={0,0,127}));
  connect(reaToInt4.y, nexDisChi.index)
    annotation (Line(points={{62,-100},{90,-100},{90,-92}}, color={255,127,0}));
  connect(uStaDow, and1.u1)
    annotation (Line(points={{-280,-100},{-100,-100},{-100,-200},{38,-200}},
      color={255,0,255}));
  connect(mulSum.y, swi1.u1)
    annotation (Line(points={{-98,190},{-80,190},{-80,-92},{-22,-92}},
      color={0,0,127}));
  connect(mulSum.y, disLasChi.u)
    annotation (Line(points={{-98,190},{-80,190},{-80,-140},{-62,-140}},
      color={0,0,127}));
  connect(disLasChi.y, swi1.u3)
    annotation (Line(points={{-38,-140},{-30,-140},{-30,-108},{-22,-108}},
      color={0,0,127}));
  connect(disLasChi.y, reaToInt5.u)
    annotation (Line(points={{-38,-140},{-30,-140},{-30,-160},{38,-160}},
      color={0,0,127}));
  connect(reaToInt5.y, enaSmaChi.index)
    annotation (Line(points={{62,-160},{90,-160},{90,-152}},
      color={255,127,0}));
  connect(intToRea.y, enaSmaChi.u)
    annotation (Line(points={{-18,240},{20,240},{20,-140},{78,-140}},
      color={0,0,127}));
  connect(and1.y, swi2.u2)
    annotation (Line(points={{62,-200},{138,-200}},
      color={255,0,255}));
  connect(enaSmaChi.y, swi2.u1)
    annotation (Line(points={{102,-140},{120,-140},{120,-192},{138,-192}},
      color={0,0,127}));
  connect(con1.y, swi2.u3)
    annotation (Line(points={{102,-240},{130,-240},{130,-208},{138,-208}},
      color={0,0,127}));
  connect(reaToInt6.y,yLasDisChi)
    annotation (Line(points={{202,-120},{280,-120}}, color={255,127,0}));
  connect(reaToInt7.y, yEnaSmaChi)
    annotation (Line(points={{242,-220},{280,-220}}, color={255,127,0}));
  connect(and1.y, or2.u2)
    annotation (Line(points={{62,-200},{70,-200},{70,-48},{78,-48}},
      color={255,0,255}));
  connect(and2.y, or2.u1)
    annotation (Line(points={{2,90},{40,90},{40,-40},{78,-40}},
      color={255,0,255}));
  connect(or2.y, yOnOff)
    annotation (Line(points={{102,-40},{280,-40}},color={255,0,255}));
  connect(conInt2.y, booToRea1.u)
    annotation (Line(points={{-178,40},{-162,40}}, color={255,0,255}));
  connect(booToRea1.y, extIndSig.u)
    annotation (Line(points={{-138,40},{-122,40}}, color={0,0,127}));
  connect(extIndSig.y, greEquThr.u)
    annotation (Line(points={{-98,40},{-62,40}},  color={0,0,127}));
  connect(greEquThr.y, and2.u2)
    annotation (Line(points={{-38,40},{-30,40},{-30,82},{-22,82}},
      color={255,0,255}));
  connect(conInt1.y, booToRea2.u)
    annotation (Line(points={{-178,-220},{-102,-220}}, color={255,0,255}));
  connect(booToRea2.y, extIndSig1.u)
    annotation (Line(points={{-78,-220},{-62,-220}}, color={0,0,127}));
  connect(extIndSig1.y, greEquThr1.u)
    annotation (Line(points={{-38,-220},{-22,-220}}, color={0,0,127}));
  connect(greEquThr1.y, and1.u2)
    annotation (Line(points={{2,-220},{20,-220},{20,-208},{38,-208}},
      color={255,0,255}));
  connect(conInt.y, addInt.u2)
    annotation (Line(points={{-118,-80},{-100,-80},{-100,-66},{-62,-66}},
      color={255,127,0}));
  connect(uChiSta, addInt.u1)
    annotation (Line(points={{-280,-60},{-220,-60},{-220,-54},{-62,-54}},
      color={255,127,0}));
  connect(addInt.y, extIndSig.index)
    annotation (Line(points={{-38,-60},{-20,-60},{-20,-40},{-110,-40},{-110,28}},
      color={255,127,0}));
  connect(addInt.y, extIndSig1.index)
    annotation (Line(points={{-38,-60},{-20,-60},{-20,-40},{-150,-40},{-150,-240},
      {-50,-240},{-50,-232}}, color={255,127,0}));
  connect(nexEnaChi.y, swi4.u1)
    annotation (Line(points={{102,240},{120,240},{120,218},{138,218}},
      color={0,0,127}));
  connect(uStaUp, swi4.u2)
    annotation (Line(points={{-280,160},{-90,160},{-90,210},{138,210}},
      color={255,0,255}));
  connect(con7.y, swi4.u3)
    annotation (Line(points={{102,70},{110,70},{110,202},{138,202}},
      color={0,0,127}));
  connect(swi4.y, reaToInt1.u)
    annotation (Line(points={{162,210},{178,210}}, color={0,0,127}));
  connect(swi5.y, reaToInt6.u)
    annotation (Line(points={{162,-120},{178,-120}}, color={0,0,127}));
  connect(uStaDow, swi5.u2)
    annotation (Line(points={{-280,-100},{-100,-100},{-100,-120},{138,-120}},
      color={255,0,255}));
  connect(nexDisChi.y, swi5.u1)
    annotation (Line(points={{102,-80},{120,-80},{120,-112},{138,-112}},
      color={0,0,127}));
  connect(con1.y, swi5.u3)
    annotation (Line(points={{102,-240},{130,-240},{130,-128},{138,-128}},
      color={0,0,127}));
  connect(conInt3.y, booToRea1.u)
    annotation (Line(points={{-178,-20},{-170,-20},{-170,40},{-162,40}},
      color={255,0,255}));
  connect(conInt3.y, booToRea2.u)
    annotation (Line(points={{-178,-20},{-170,-20},{-170,-220},{-102,-220}},
      color={255,0,255}));
  connect(ponChi.y, swi6.u2)
    annotation (Line(points={{102,0},{110,0},{110,40},{178,40}},
      color={255,0,255}));
  connect(swi3.y, swi6.u1)
    annotation (Line(points={{162,90},{170,90},{170,48},{178,48}},
      color={0,0,127}));
  connect(con7.y, swi6.u3)
    annotation (Line(points={{102,70},{140,70},{140,32},{178,32}},
      color={0,0,127}));
  connect(swi6.y, reaToInt2.u)
    annotation (Line(points={{202,40},{218,40}}, color={0,0,127}));
  connect(ponChi.y, swi7.u2)
    annotation (Line(points={{102,0},{110,0},{110,-220},{178,-220}},
      color={255,0,255}));
  connect(swi2.y, swi7.u1)
    annotation (Line(points={{162,-200},{170,-200},{170,-212},{178,-212}},
      color={0,0,127}));
  connect(con1.y, swi7.u3)
    annotation (Line(points={{102,-240},{172,-240},{172,-228},{178,-228}},
      color={0,0,127}));
  connect(swi7.y, reaToInt7.u)
    annotation (Line(points={{202,-220},{218,-220}},
      color={0,0,127}));
  connect(uStaDow, or1.u2)
    annotation (Line(points={{-280,-100},{-250,-100},{-250,82},{-242,82}},
      color={255,0,255}));
  connect(uStaUp, or1.u1)
    annotation (Line(points={{-280,160},{-250,160},{-250,90},{-242,90}},
      color={255,0,255}));
  connect(or1.y, booRep1.u)
    annotation (Line(points={{-218,90},{-202,90}}, color={255,0,255}));
  connect(booRep1.y, edg.u)
    annotation (Line(points={{-178,90},{-162,90}}, color={255,0,255}));
  connect(edg.y, triSam.trigger)
    annotation (Line(points={{-138,90},{-132,90},{-132,118.2}},
      color={255,0,255}));
  connect(booToRea.y, triSam.u)
    annotation (Line(points={{-198,130},{-144,130}}, color={0,0,127}));
  connect(booRep1.y, swi8.u2)
    annotation (Line(points={{-178,90},{-170,90},{-170,190},{-162,190}},
      color={255,0,255}));
  connect(triSam.y, swi8.u1)
    annotation (Line(points={{-120,130},{-110,130},{-110,170},{-200,170},
      {-200,198},{-162,198}}, color={0,0,127}));
  connect(booToRea.y, swi8.u3)
    annotation (Line(points={{-198,130},{-180,130},{-180,182},{-162,182}},
      color={0,0,127}));
  connect(swi8.y, mulSum.u)
    annotation (Line(points={{-138,190},{-130,190},{-130,190},{-122,190}},
      color={0,0,127}));

annotation (
  defaultComponentName="nexChi",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-260,-260},{260,260}})),
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
