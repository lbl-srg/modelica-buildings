within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Validation;
model DownWithOnOff
  "Validate sequence of staging down process which requires one chiller ON and another chiller OFF"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Down
    dowProCon(
    final nChi=2,
    final totChiSta=3,
    final totSta=4,
    final havePonyChiller=true,
    final upOnOffSta={false,false,true},
    final dowOnOffSta={false,true,false},
    final chaChiWatIsoTim=300,
    final staVec={0,0.5,1,2},
    final desConWatPumSpe={0,0.5,0.75,0.6},
    final desConWatPumNum={0,1,1,2},
    final byPasSetTim=300,
    final minFloSet={0.5,1},
    final maxFloSet={1,1.5})
    "Stage down process when does require chiller on and off"
    annotation (Placement(transformation(extent={{20,120},{40,160}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp chiWatFlo1(
    final height=0.5 - 5/3,
    final duration=300,
    final offset=5/3,
    final startTime=800) "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-200,-40},{-180,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.1,
    final period=1500) "Boolean pulse"
    annotation (Placement(transformation(extent={{-200,170},{-180,190}})));
  Buildings.Controls.OBC.CDL.Logical.Not staDow1 "Stage down command"
    annotation (Placement(transformation(extent={{-160,170},{-140,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiLoa1(
    final k=1000) "Chiller load"
    annotation (Placement(transformation(extent={{-200,0},{-180,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minOPLR1(final k=0.78)
    "Minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant fulOpe1(final k=1)
    "Full open isolation valve"
    annotation (Placement(transformation(extent={{-200,-200},{-180,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerLoa(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-200,40},{-180,60}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneSta(
    final pre_u_start=false) "Chiller one status"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiOneLoa "Chiller one load"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaPri1[2](
    final k={2,1}) "Chiller enabling priority"
    annotation (Placement(transformation(extent={{-200,120},{-180,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staTwo1(
    final k=2) "Chiller stage two"
    annotation (Placement(transformation(extent={{-200,-120},{-180,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staOne1(
    final k=1) "Chiller stage one"
    annotation (Placement(transformation(extent={{-200,-80},{-180,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiSta1 "Logical switch"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch IsoValOne "Logical switch"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol3[2](
    final samplePeriod=fill(10, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant wseSta1(final k=false)
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-200,-240},{-180,-220}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol4(
    final samplePeriod=10)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{100,-160},{120,-140}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol5(
    final samplePeriod=20)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{100,-200},{120,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiTwoLoa "Chiller two load"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiTwoSta(
    final pre_u_start=true) "Chiller two status"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer3[2](
    final k=fill(0,2)) "Constant zero"
    annotation (Placement(transformation(extent={{80,140},{100,160}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol6(
    final samplePeriod=10) "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{80,170},{100,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiLoa3(final k=1000)
    "Chiller load"
    annotation (Placement(transformation(extent={{40,190},{60,210}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiLoa2[2] "Chiller load"
    annotation (Placement(transformation(extent={{140,170},{160,190}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol7(
    final samplePeriod=10)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{180,170},{200,190}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneHea(final pre_u_start=false)
    "Chiller one head pressure control"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiTwoHea(final pre_u_start=true)
    "Chiller two head pressure control"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerOpe2(
    final k=0) "Closed isolation valve"
    annotation (Placement(transformation(extent={{-200,-160},{-180,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Switch IsoValTwo "Logical switch"
    annotation (Placement(transformation(extent={{-120,-200},{-100,-180}})));

equation
  connect(booPul1.y, staDow1.u)
    annotation (Line(points={{-178,180},{-162,180}}, color={255,0,255}));
  connect(chiSta1.y, reaToInt2.u)
    annotation (Line(points={{-98,-90},{-82,-90}}, color={0,0,127}));
  connect(staDow1.y, chiOneLoa.u2)
    annotation (Line(points={{-138,180},{-130,180},{-130,50},{-122,50}},
      color={255,0,255}));
  connect(staDow1.y, chiTwoLoa.u2)
    annotation (Line(points={{-138,180},{-130,180},{-130,10},{-122,10}},
      color={255,0,255}));
  connect(chiLoa1.y, chiTwoLoa.u3)
    annotation (Line(points={{-178,10},{-160,10},{-160,2},{-122,2}},
      color={0,0,127}));
  connect(zerLoa.y, chiOneLoa.u3)
    annotation (Line(points={{-178,50},{-160,50},{-160,42},{-122,42}},
      color={0,0,127}));
  connect(chiLoa3.y, chiLoa2[1].u1)
    annotation (Line(points={{62,200},{120,200},{120,188},{138,188}},
      color={0,0,127}));
  connect(zerOrdHol6.y, chiLoa2[2].u1)
    annotation (Line(points={{102,180},{120,180},{120,188},{138,188}},
      color={0,0,127}));
  connect(zer3.y, chiLoa2.u3)
    annotation (Line(points={{102,150},{120,150},{120,172},{138,172}},
      color={0,0,127}));
  connect(dowProCon.yChiDem[2], zerOrdHol6.u)
    annotation (Line(points={{42,156},{60,156},{60,180},{78,180}},
      color={0,0,127}));
  connect(dowProCon.yChi[1], chiOneSta.u)
    annotation (Line(points={{42,151},{60,151},{60,100},{98,100}},
      color={255,0,255}));
  connect(dowProCon.yChi[2], chiTwoSta.u)
    annotation (Line(points={{42,153},{62,153},{62,60},{98,60}}, color={255,0,255}));
  connect(chiOneSta.y, chiLoa2[1].u2)
    annotation (Line(points={{122,100},{130,100},{130,180},{138,180}},
      color={255,0,255}));
  connect(chiTwoSta.y, chiLoa2[2].u2)
    annotation (Line(points={{122,60},{132,60},{132,180},{138,180}},
      color={255,0,255}));
  connect(chiLoa2[2].y, chiTwoLoa.u1)
    annotation (Line(points={{162,180},{170,180},{170,-10},{-140,-10},{-140,18},
      {-122,18}}, color={0,0,127}));
  connect(chiLoa2[1].y, zerOrdHol7.u)
    annotation (Line(points={{162,180},{178,180}}, color={0,0,127}));
  connect(zerOrdHol7.y, chiOneLoa.u1)
    annotation (Line(points={{202,180},{210,180},{210,30},{-140,30},{-140,58},
      {-122,58}}, color={0,0,127}));
  connect(staDow1.y, dowProCon.uStaDow)
    annotation (Line(points={{-138,180},{-130,180},{-130,159},{18,159}},
      color={255,0,255}));
  connect(enaPri1.y, dowProCon.uChiPri)
    annotation (Line(points={{-178,130},{-128,130},{-128,157},{18,157}},
      color={255,127,0}));
  connect(minOPLR1.y, dowProCon.minOPLR)
    annotation (Line(points={{-178,90},{-126, 90},{-126,153.8},{18,153.8}},
      color={0,0,127}));
  connect(chiOneLoa.y, dowProCon.uChiLoa[1])
    annotation (Line(points={{-98,50},{-90,50},{-90,150.8},{18,150.8}},
      color={0,0,127}));
  connect(chiTwoLoa.y, dowProCon.uChiLoa[2])
    annotation (Line(points={{-98,10},{-88,10},{-88,152.8},{18,152.8}},
      color={0,0,127}));
  connect(chiOneSta.y, dowProCon.uChi[1])
    annotation (Line(points={{122,100},{130,100},{130,80},{-80,80},{-80,148},
      {18,148}}, color={255,0,255}));
  connect(chiTwoSta.y, dowProCon.uChi[2])
    annotation (Line(points={{122,60},{132,60},{132,40},{-78,40},{-78,150},
      {18,150}}, color={255,0,255}));
  connect(chiWatFlo1.y, dowProCon.VChiWat_flow)
    annotation (Line(points={{-178,-30},{-76,-30},{-76,146},{18,146}},
      color={0,0,127}));
  connect(staDow1.y, chiSta1.u2)
    annotation (Line(points={{-138,180},{-130,180},{-130,-90},{-122,-90}},
      color={255,0,255}));
  connect(staOne1.y, chiSta1.u1)
    annotation (Line(points={{-178,-70},{-160,-70},{-160,-82},{-122,-82}},
      color={0,0,127}));
  connect(staTwo1.y, chiSta1.u3)
    annotation (Line(points={{-178,-110},{-160,-110},{-160,-98},{-122,-98}},
      color={0,0,127}));
  connect(reaToInt2.y, dowProCon.uChiSta)
    annotation (Line(points={{-58,-90},{-50,-90},{-50,143},{18,143}},
      color={255,127,0}));
  connect(dowProCon.yChiHeaCon[1], chiOneHea.u)
    annotation (Line(points={{42,136},{66,136},{66,-30},{98,-30}},
      color={255,0,255}));
  connect(dowProCon.yChiHeaCon[2], chiTwoHea.u)
    annotation (Line(points={{42,138},{68,138},{68,-70},{98,-70}},
      color={255,0,255}));
  connect(chiOneHea.y, dowProCon.uChiHeaCon[1])
    annotation (Line(points={{122,-30},{140,-30},{140,-50},{-48,-50},{-48,139},
      {18,139}}, color={255,0,255}));
  connect(chiTwoHea.y, dowProCon.uChiHeaCon[2])
    annotation (Line(points={{122,-70},{140,-70},{140,-90},{-46,-90},{-46,141},
      {18,141}}, color={255,0,255}));
  connect(zerOpe2.y, IsoValOne.u3)
    annotation (Line(points={{-178,-150},{-160,-150},{-160,-158},{-122,-158}},
      color={0,0,127}));
  connect(fulOpe1.y, IsoValTwo.u3)
    annotation (Line(points={{-178,-190},{-160,-190},{-160,-198},{-122,-198}},
      color={0,0,127}));
  connect(staDow1.y, IsoValOne.u2)
    annotation (Line(points={{-138,180},{-130,180},{-130,-150},{-122,-150}},
      color={255,0,255}));
  connect(staDow1.y, IsoValTwo.u2)
    annotation (Line(points={{-138,180},{-130,180},{-130,-190},{-122,-190}},
      color={255,0,255}));
  connect(dowProCon.yChiWatIsoVal, zerOrdHol3.u)
    annotation (Line(points={{42,144},{72,144},{72,-110},{98,-110}},
      color={0,0,127}));
  connect(zerOrdHol3[1].y, IsoValOne.u1)
    annotation (Line(points={{122,-110},{140,-110},{140,-130},{-140,-130},
      {-140,-142},{-122,-142}}, color={0,0,127}));
  connect(zerOrdHol3[2].y, IsoValTwo.u1)
    annotation (Line(points={{122,-110},{140,-110},{140,-130},{-140,-130},
      {-140,-182},{-122,-182}}, color={0,0,127}));
  connect(IsoValOne.y, dowProCon.uChiWatIsoVal[1])
    annotation (Line(points={{-98,-150},{-44,-150},{-44,136},{18,136}}, color={0,0,127}));
  connect(IsoValTwo.y, dowProCon.uChiWatIsoVal[2])
    annotation (Line(points={{-98,-190},{-42,-190},{-42,138},{18,138}},
      color={0,0,127}));
  connect(chiOneSta.y, dowProCon.uChiWatReq[1])
    annotation (Line(points={{122,100},{130,100},{130,80},{-30,80},{-30,133},
      {18,133}}, color={255,0,255}));
  connect(chiTwoSta.y, dowProCon.uChiWatReq[2])
    annotation (Line(points={{122,60},{132,60},{132,40},{-28,40},{-28,135},
      {18,135}}, color={255,0,255}));
  connect(chiOneSta.y, dowProCon.uConWatReq[1])
    annotation (Line(points={{122,100},{130,100},{130,80},{-26,80},{-26,131},
      {18,131}}, color={255,0,255}));
  connect(chiTwoSta.y, dowProCon.uConWatReq[2])
    annotation (Line(points={{122,60},{132,60},{132,40},{-24,40},{-24,133},{18,133}},
      color={255,0,255}));
  connect(chiOneSta.y, dowProCon.uChiConIsoVal[1])
    annotation (Line(points={{122,100},{130,100},{130,80},{-22,80},{-22,128},{18,128}},
      color={255,0,255}));
  connect(chiTwoSta.y, dowProCon.uChiConIsoVal[2])
    annotation (Line(points={{122,60},{132,60},{132,40},{-20,40},{-20,130},{18,130}},
      color={255,0,255}));
  connect(wseSta1.y, dowProCon.uWSE)
    annotation (Line(points={{-178,-230},{-10,-230},{-10,126},{18,126}},
      color={255,0,255}));
  connect(dowProCon.yDesConWatPumSpe, zerOrdHol4.u)
    annotation (Line(points={{42,129},{78,129},{78,-150},{98,-150}},
      color={0,0,127}));
  connect(zerOrdHol4.y, zerOrdHol5.u)
    annotation (Line(points={{122,-150},{140,-150},{140,-170},{80,-170},{80,-190},
      {98,-190}}, color={0,0,127}));
  connect(zerOrdHol4.y, dowProCon.uConWatPumSpeSet)
    annotation (Line(points={{122,-150},{140,-150},{140,-170},{-8,-170},{-8,123},
      {18,123}}, color={0,0,127}));
  connect(zerOrdHol5.y, dowProCon.uConWatPumSpe)
    annotation (Line(points={{122,-190},{140,-190},{140,-210},{-6,-210},{-6,121},
      {18,121}}, color={0,0,127}));

annotation (
 experiment(StopTime=1500, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Validation/DownWithOnOff.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Down\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Down</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 2, by Jianjun Hu:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-260},{220,260}}),
        graphics={
        Text(
          extent={{-194,232},{-4,216}},
          lineColor={0,0,127},
          textString="to stage 1 which only has small chiller enabled (chiller 1)."),
        Text(
          extent={{-194,244},{-6,234}},
          lineColor={0,0,127},
          textString="from stage 2 which only has large chiller enabled (chiller 2), "),
        Text(
          extent={{-204,256},{-156,248}},
          lineColor={0,0,127},
          textString="Stage down:")}));
end DownWithOnOff;
