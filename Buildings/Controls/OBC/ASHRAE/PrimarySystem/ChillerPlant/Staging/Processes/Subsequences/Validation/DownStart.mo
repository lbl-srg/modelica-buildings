within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.Validation;
model DownStart "Validate sequence of start staging down process"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DownStart
    staStaDow(
    final nChi=2,
    final byPasSetTim=300)
    "Chiller stage down when the process does not require one chiller on and another chiller off"
    annotation (Placement(transformation(extent={{-140,190},{-120,210}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DownStart
    staStaDow1(
    final nChi=2,
    final byPasSetTim=300,
    final minFloSet={1,1},
    final maxFloSet={1.5,1.5})
    "Chiller stage down when the process does require one chiller on and another chiller off"
    annotation (Placement(transformation(extent={{140,140},{160,160}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler demLimRel
    "To indicate if the demand limit has been released"
    annotation (Placement(transformation(extent={{160,200},{180,220}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15,
    final period=1200) "Boolean pulse"
    annotation (Placement(transformation(extent={{-320,210},{-300,230}})));
  Buildings.Controls.OBC.CDL.Logical.Not staDow "Stage down command"
    annotation (Placement(transformation(extent={{-280,210},{-260,230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOn[2](
    final k=fill(true,2))
    "Operating chiller one"
    annotation (Placement(transformation(extent={{-320,50},{-300,70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{-240,-250},{-220,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiLoa[2](
    final k=fill(1000,2)) "Chiller load"
    annotation (Placement(transformation(extent={{-320,130},{-300,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant nexEnaChi(
    final k=0) "Next enabling chiller"
    annotation (Placement(transformation(extent={{-320,-110},{-300,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minOPLR(
    final k=0.7)
    "Minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-320,170},{-300,190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant onOff(
    final k=false) "Chiller on-off command"
    annotation (Placement(transformation(extent={{-320,-70},{-300,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiFlo(
    final k=2) "Chilled water flow"
    annotation (Placement(transformation(extent={{-320,-30},{-300,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiHea[2](
    final k=fill(true,2))
    "Chiller head pressure control"
    annotation (Placement(transformation(extent={{-320,-150},{-300,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiIsoVal[2](
    final k=fill(1,2))
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{-320,-190},{-300,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nexDisChi(
    final k=2) "Next disable chiller"
    annotation (Placement(transformation(extent={{-320,-230},{-300,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-320,-270},{-300,-250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1[2](
    final k=fill(0,2)) "Constant zero"
    annotation (Placement(transformation(extent={{-320,90},{-300,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal[2](
    final k=fill(false,2)) "Constant false"
    annotation (Placement(transformation(extent={{-320,10},{-300,30}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-200,-250},{-180,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Pre                        pre2[2](
    final pre_u_start=fill(true,2)) "Break algebraic loop"
    annotation (Placement(transformation(extent={{-100,170},{-80,190}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi[2] "Logical switch"
    annotation (Placement(transformation(extent={{-240,50},{-220,70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[2] "Logical switch"
    annotation (Placement(transformation(extent={{-240,130},{-220,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.15,
    final period=1200) "Boolean pulse"
    annotation (Placement(transformation(extent={{-40,200},{-20,220}})));
  Buildings.Controls.OBC.CDL.Logical.Not staDow1 "Stage down command"
    annotation (Placement(transformation(extent={{0,200},{20,220}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3 "Logical switch"
    annotation (Placement(transformation(extent={{40,-240},{60,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerLoa(
    final k=0) "Zero load"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minOPLR1(final k=0.7)
    "Minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-40,160},{-20,180}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant onOff1(
    final k=true) "Chiller on-off command"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiFlo1(
    final k=2) "Chilled water flow"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nexDisChi1(
    final k=2) "Next disable chiller"
    annotation (Placement(transformation(extent={{-40,-220},{-20,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer2(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-40,-260},{-20,-240}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{80,-240},{100,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneSta(
    final pre_u_start=false) "Break algebraic loop"
    annotation (Placement(transformation(extent={{220,60},{240,80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiOneLoa "Chiller one"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiLoa2(
    final k=1000) "Chiller load"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiTwoLoa "Chiller two load"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiTwoSta(
    final pre_u_start=true) "Break algebraic loop"
    annotation (Placement(transformation(extent={{220,30},{240,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nexEnaChi3(
    final k=1) "Next enable chiller"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer4(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi4 "Logical switch"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant fulOpe(
    final k=1) "Full open"
    annotation (Placement(transformation(extent={{-40,-180},{-20,-160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerOpe(
    final k=0) "Zero open"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiIsoVal2
    "Chilled water isolation valve one"
    annotation (Placement(transformation(extent={{40,-180},{60,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiIsoVal1
    "Chilled water isolation valve one"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol(final
      samplePeriod=10) "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{200,160},{220,180}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1[2](
    final samplePeriod=fill(10,2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{260,-110},{280,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiLoa1[2] "Chiller load"
    annotation (Placement(transformation(extent={{260,160},{280,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer3[2](
    final k=fill(0,2)) "Constant zero"
    annotation (Placement(transformation(extent={{200,110},{220,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiLoa3(final k=1000)
    "Chiller load"
    annotation (Placement(transformation(extent={{200,200},{220,220}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol2(
    final samplePeriod=10)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{300,200},{320,220}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneHea(
    final pre_u_start=false) "Break algebraic loop"
    annotation (Placement(transformation(extent={{200,-20},{220,0}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiTwoHea(
    final pre_u_start=true) "Break algebraic loop"
    annotation (Placement(transformation(extent={{200,-50},{220,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{120,200},{140,220}})));

equation
  connect(booPul.y,staDow. u)
    annotation (Line(points={{-298,220},{-282,220}}, color={255,0,255}));
  connect(staDow.y, swi.u2)
    annotation (Line(points={{-258,220},{-250,220},{-250,-240},{-242,-240}},
      color={255,0,255}));
  connect(nexDisChi.y, swi.u1)
    annotation (Line(points={{-298,-220},{-260,-220},{-260,-232},{-242,-232}},
      color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{-298,-260},{-260,-260},{-260,-248},{-242,-248}},
      color={0,0,127}));
  connect(staDow.y, staStaDow.uStaDow)
    annotation (Line(points={{-258,220},{-250,220},{-250,209},{-142,209}},
      color={255,0,255}));
  connect(minOPLR.y, staStaDow.minOPLR)
    annotation (Line(points={{-298,180},{-188,180},{-188,207},{-142,207}},
      color={0,0,127}));
  connect(chiFlo.y, staStaDow.VChiWat_flow)
    annotation (Line(points={{-298,-20},{-176,-20},{-176,201},{-142,201}},
      color={0,0,127}));
  connect(onOff.y, staStaDow.uOnOff)
    annotation (Line(points={{-298,-60},{-172,-60},{-172,199},{-142,199}},
      color={255,0,255}));
  connect(nexEnaChi.y, staStaDow.nexEnaChi)
    annotation (Line(points={{-298,-100},{-168,-100},{-168,197},{-142,197}},
      color={255,127,0}));
  connect(swi.y, reaToInt.u)
    annotation (Line(points={{-218,-240},{-202,-240}}, color={0,0,127}));
  connect(reaToInt.y, staStaDow.nexDisChi)
    annotation (Line(points={{-178,-240},{-156,-240},{-156,191},{-142,191}},
      color={255,127,0}));
  connect(staStaDow.yChi, pre2.u)
    annotation (Line(points={{-118,195},{-110,195},{-110,180},{-102,180}},
      color={255,0,255}));
  connect(pre2.y, swi1.u2)
    annotation (Line(points={{-78,180},{-70,180},{-70,160},{-260,160},{-260,140},
      {-242,140}}, color={255,0,255}));
  connect(chiLoa.y, swi1.u1)
    annotation (Line(points={{-298,140},{-290,140},{-290,148},{-242,148}},
      color={0,0,127}));
  connect(zer1.y, swi1.u3)
    annotation (Line(points={{-298,100},{-280,100},{-280,132},{-242,132}},
      color={0,0,127}));
  connect(pre2.y, logSwi.u2)
    annotation (Line(points={{-78,180},{-70,180},{-70,160},{-260,160},{-260,60},
      {-242,60}}, color={255,0,255}));
  connect(chiOn.y, logSwi.u1)
    annotation (Line(points={{-298,60},{-290,60},{-290,68},{-242,68}},
      color={255,0,255}));
  connect(fal.y, logSwi.u3)
    annotation (Line(points={{-298,20},{-270,20},{-270,52},{-242,52}},
      color={255,0,255}));
  connect(swi1.y, staStaDow.uChiLoa)
    annotation (Line(points={{-218,140},{-184,140},{-184,205},{-142,205}},
      color={0,0,127}));
  connect(logSwi.y, staStaDow.uChi)
    annotation (Line(points={{-218,60},{-180,60},{-180,203},{-142,203}},
      color={255,0,255}));
  connect(booPul1.y, staDow1.u)
    annotation (Line(points={{-18,210},{-2,210}},color={255,0,255}));
  connect(staDow1.y, swi3.u2)
    annotation (Line(points={{22,210},{30,210},{30,-230},{38,-230}},
      color={255,0,255}));
  connect(nexDisChi1.y, swi3.u1)
    annotation (Line(points={{-18,-210},{0,-210},{0,-222},{38,-222}},
      color={0,0,127}));
  connect(zer2.y, swi3.u3)
    annotation (Line(points={{-18,-250},{0,-250},{0,-238},{38,-238}},
      color={0,0,127}));
  connect(swi3.y, reaToInt1.u)
    annotation (Line(points={{62,-230},{78,-230}}, color={0,0,127}));
  connect(staDow1.y, chiOneLoa.u2)
    annotation (Line(points={{22,210},{30,210},{30,120},{38,120}},
      color={255,0,255}));
  connect(zerLoa.y, chiOneLoa.u3)
    annotation (Line(points={{-18,120},{0,120},{0,112},{38,112}}, color={0,0,127}));
  connect(staDow1.y, chiTwoLoa.u2)
    annotation (Line(points={{22,210},{30,210},{30,80},{38,80}},
      color={255,0,255}));
  connect(chiLoa2.y, chiTwoLoa.u3)
    annotation (Line(points={{-18,80},{0,80},{0,72},{38,72}}, color={0,0,127}));
  connect(staStaDow1.yChi[1], chiOneSta.u)
    annotation (Line(points={{162,144},{192,144},{192,70},{218,70}},
      color={255,0,255}));
  connect(staStaDow1.yChi[2], chiTwoSta.u)
    annotation (Line(points={{162,146},{188,146},{188,40},{218,40}},
      color={255,0,255}));
  connect(staDow1.y, staStaDow1.uStaDow)
    annotation (Line(points={{22,210},{30,210},{30,159},{138,159}},
      color={255,0,255}));
  connect(minOPLR1.y, staStaDow1.minOPLR)
    annotation (Line(points={{-18,170},{0,170},{0,157},{138,157}},
      color={0,0,127}));
  connect(chiOneLoa.y, staStaDow1.uChiLoa[1])
    annotation (Line(points={{62,120},{84,120},{84,154},{138,154}},
      color={0,0,127}));
  connect(chiTwoLoa.y, staStaDow1.uChiLoa[2])
    annotation (Line(points={{62,80},{80,80},{80,156},{138,156}}, color={0,0,127}));
  connect(chiOneSta.y, staStaDow1.uChi[1])
    annotation (Line(points={{242,70},{320,70},{320,10},{88,10},{88,152},{138,152}},
      color={255,0,255}));
  connect(chiTwoSta.y, staStaDow1.uChi[2])
    annotation (Line(points={{242,40},{250,40},{250,14},{92,14},{92,154},{138,154}},
      color={255,0,255}));
  connect(chiFlo1.y, staStaDow1.VChiWat_flow)
    annotation (Line(points={{-18,30},{96,30},{96,151},{138,151}},
      color={0,0,127}));
  connect(onOff1.y, staStaDow1.uOnOff)
    annotation (Line(points={{-18,-10},{100,-10},{100,149},{138,149}},
      color={255,0,255}));
  connect(zer4.y, swi4.u3)
    annotation (Line(points={{-18,-90},{0,-90},{0,-78},{38,-78}},
      color={0,0,127}));
  connect(nexEnaChi3.y, swi4.u1)
    annotation (Line(points={{-18,-50},{0,-50},{0,-62},{38,-62}},
      color={0,0,127}));
  connect(swi4.y, reaToInt2.u)
    annotation (Line(points={{62,-70},{78,-70}}, color={0,0,127}));
  connect(staDow1.y, swi4.u2)
    annotation (Line(points={{22,210},{30,210},{30,-70},{38,-70}},
      color={255,0,255}));
  connect(reaToInt2.y, staStaDow1.nexEnaChi)
    annotation (Line(points={{102,-70},{104,-70},{104,147},{138,147}},
      color={255,127,0}));
  connect(fulOpe.y, chiIsoVal2.u3)
    annotation (Line(points={{-18,-170},{0,-170},{0,-178},{38,-178}},
      color={0,0,127}));
  connect(zerOpe.y, chiIsoVal1.u3)
    annotation (Line(points={{-18,-130},{0,-130},{0,-138},{38,-138}},
      color={0,0,127}));
  connect(staDow1.y, chiIsoVal1.u2)
    annotation (Line(points={{22,210},{30,210},{30,-130},{38,-130}},
      color={255,0,255}));
  connect(staDow1.y, chiIsoVal2.u2)
    annotation (Line(points={{22,210},{30,210},{30,-170},{38,-170}},
      color={255,0,255}));
  connect(staStaDow1.yChiWatIsoVal, zerOrdHol1.u)
    annotation (Line(points={{162,150},{184,150},{184,-100},{258,-100}},
      color={0,0,127}));
  connect(zerOrdHol1[1].y, chiIsoVal1.u1)
    annotation (Line(points={{282,-100},{300,-100},{300,-150},{20,-150},
      {20,-122},{38,-122}}, color={0,0,127}));
  connect(zerOrdHol1[2].y, chiIsoVal2.u1)
    annotation (Line(points={{282,-100},{300,-100},{300,-190},{20,-190},
      {20,-162},{38,-162}}, color={0,0,127}));
  connect(chiIsoVal1.y, staStaDow1.uChiWatIsoVal[1])
    annotation (Line(points={{62,-130},{116,-130},{116,142},{138,142}},
      color={0,0,127}));
  connect(chiIsoVal2.y, staStaDow1.uChiWatIsoVal[2])
    annotation (Line(points={{62,-170},{120,-170},{120,144},{138,144}},
      color={0,0,127}));
  connect(reaToInt1.y, staStaDow1.nexDisChi)
    annotation (Line(points={{102,-230},{124,-230},{124,141},{138,141}},
      color={255,127,0}));
  connect(chiOneSta.y, chiLoa1[1].u2)
    annotation (Line(points={{242,70},{320,70},{320,140},{250,140},{250,170},
      {258,170}}, color={255,0,255}));
  connect(chiTwoSta.y, chiLoa1[2].u2)
    annotation (Line(points={{242,40},{250,40},{250,170},{258,170}},
      color={255,0,255}));
  connect(zer3.y, chiLoa1.u3)
    annotation (Line(points={{222,120},{240,120},{240,162},{258,162}},
      color={0,0,127}));
  connect(staStaDow1.yChiDem[2], zerOrdHol.u)
    annotation (Line(points={{162,160},{192,160},{192,170},{198,170}},
      color={0,0,127}));
  connect(zerOrdHol.y, chiLoa1[2].u1)
    annotation (Line(points={{222,170},{240,170},{240,178},{258,178}},
      color={0,0,127}));
  connect(chiLoa3.y, chiLoa1[1].u1)
    annotation (Line(points={{222,210},{240,210},{240,178},{258,178}},
      color={0,0,127}));
  connect(chiLoa1[1].y, zerOrdHol2.u)
    annotation (Line(points={{282,170},{290,170},{290,210},{298,210}},
      color={0,0,127}));
  connect(chiLoa1[2].y, chiTwoLoa.u1)
    annotation (Line(points={{282,170},{290,170},{290,20},{20,20},{20,88},
      {38,88}}, color={0,0,127}));
  connect(zerOrdHol2.y, chiOneLoa.u1)
    annotation (Line(points={{322,210},{330,210},{330,100},{20,100},{20,128},
      {38,128}}, color={0,0,127}));
  connect(staStaDow1.yChiHeaCon[1], chiOneHea.u)
    annotation (Line(points={{162,154},{176,154},{176,-10},{198,-10}},
      color={255,0,255}));
  connect(staStaDow1.yChiHeaCon[2], chiTwoHea.u)
    annotation (Line(points={{162,156},{180,156},{180,-40},{198,-40}},
      color={255,0,255}));
  connect(chiOneHea.y, staStaDow1.uChiHeaCon[1])
    annotation (Line(points={{222,-10},{230,-10},{230,-26},{108,-26},{108,144},
      {138,144}}, color={255,0,255}));
  connect(chiTwoHea.y, staStaDow1.uChiHeaCon[2])
    annotation (Line(points={{222,-40},{230,-40},{230,-60},{112,-60},{112,146},
      {138,146}}, color={255,0,255}));
  connect(one.y, demLimRel.u)
    annotation (Line(points={{142,210},{158,210}}, color={0,0,127}));
  connect(staStaDow1.yReaDemLim, demLimRel.trigger)
    annotation (Line(points={{162,141},{170,141},{170,198.2}}, color={255,0,255}));
  connect(chiHea.y, staStaDow.uChiHeaCon)
    annotation (Line(points={{-298,-140},{-164,-140},{-164,195},{-142,195}},
      color={255,0,255}));
  connect(chiIsoVal.y, staStaDow.uChiWatIsoVal)
    annotation (Line(points={{-298,-180},{-160,-180},{-160,193},{-142,193}},
      color={0,0,127}));

annotation (
 experiment(StopTime=1200, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Subsequences/Validation/DownStart.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DownStart\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DownStart</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 26, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
     graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-340,-320},{340,320}})));
end DownStart;
