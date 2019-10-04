within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Validation;
model Down "Validate sequence of staging down process"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Down
    dowProCon(
    final nChi=2,
    final totChiSta=3,
    final totSta=4,
    final chaChiWatIsoTim=300,
    final staVec={0,0.5,1,2},
    final desConWatPumSpe={0,0.5,0.75,0.6},
    final desConWatPumNum={0,1,1,2},
    final byPasSetTim=300,
    final minFloSet={1,1},
    final maxFloSet={1.5,1.5})
    "Stage down process when does not require chiller on and off"
    annotation (Placement(transformation(extent={{-160,120},{-140,160}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Down
    dowProCon1(
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
    annotation (Placement(transformation(extent={{200,120},{220,160}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp chiWatFlo(
    final height=-1,
    final duration=300,
    final offset=2,
    final startTime=800) "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-380,-40},{-360,-20}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=2) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-300,-140},{-280,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp chiWatFlo1(
    final height=0.5 - 5/3,
    final duration=300,
    final offset=5/3,
    final startTime=800) "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.1,
    final period=1500) "Boolean pulse"
    annotation (Placement(transformation(extent={{-380,170},{-360,190}})));
  Buildings.Controls.OBC.CDL.Logical.Not staDow "Stage down command"
    annotation (Placement(transformation(extent={{-340,170},{-320,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiLoa[2](
    final k=fill(1000,2)) "Chiller load"
    annotation (Placement(transformation(extent={{-380,40},{-360,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minOPLR(
    final k=0.78) "Minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-380,80},{-360,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant fulOpe[2](
    final k=fill(1, 2)) "Full open isolation valve"
    annotation (Placement(transformation(extent={{-380,-170},{-360,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1[2](
    final k=fill(0,2)) "Constant zero"
    annotation (Placement(transformation(extent={{-380,0},{-360,20}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre2[2](
    final pre_u_start=fill(true,2)) "Break algebraic loop"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[2] "Logical switch"
    annotation (Placement(transformation(extent={{-300,20},{-280,40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaPri[2](final k={1,2})
    "Chiller enabling priority"
    annotation (Placement(transformation(extent={{-380,120},{-360,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staTwo(
    final k=2) "Chiller stage two"
    annotation (Placement(transformation(extent={{-380,-120},{-360,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staOne(
    final k=1) "Chiller stage one"
    annotation (Placement(transformation(extent={{-380,-80},{-360,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiSta "Logical switch"
    annotation (Placement(transformation(extent={{-300,-100},{-280,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-260,-100},{-240,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch IsoVal[2] "Logical switch"
    annotation (Placement(transformation(extent={{-260,-170},{-240,-150}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[2](
    final samplePeriod=fill(10, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant wseSta(final k=false)
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-380,-210},{-360,-190}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1(
    final samplePeriod=10)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol2(
    final samplePeriod=20)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.1,
    final period=1500) "Boolean pulse"
    annotation (Placement(transformation(extent={{-20,170},{0,190}})));
  Buildings.Controls.OBC.CDL.Logical.Not staDow1 "Stage down command"
    annotation (Placement(transformation(extent={{20,170},{40,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiLoa1(
    final k=1000) "Chiller load"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minOPLR1(final k=0.78)
    "Minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant fulOpe1(final k=1)
    "Full open isolation valve"
    annotation (Placement(transformation(extent={{-20,-200},{0,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerLoa(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneSta(
    final pre_u_start=false) "Chiller one status"
    annotation (Placement(transformation(extent={{280,90},{300,110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiOneLoa "Chiller one load"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaPri1[2](
    final k={2,1}) "Chiller enabling priority"
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staTwo1(
    final k=2) "Chiller stage two"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staOne1(
    final k=1) "Chiller stage one"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiSta1 "Logical switch"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch IsoValOne "Logical switch"
    annotation (Placement(transformation(extent={{60,-160},{80,-140}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol3[2](
    final samplePeriod=fill(10, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{280,-120},{300,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant wseSta1(final k=false)
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-20,-240},{0,-220}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol4(
    final samplePeriod=10)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{280,-160},{300,-140}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol5(
    final samplePeriod=20)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{280,-200},{300,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiTwoLoa "Chiller two load"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiTwoSta(
    final pre_u_start=true) "Chiller two status"
    annotation (Placement(transformation(extent={{280,50},{300,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer3[2](
    final k=fill(0,2)) "Constant zero"
    annotation (Placement(transformation(extent={{260,140},{280,160}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol6(
    final samplePeriod=10) "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{260,170},{280,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiLoa3(final k=1000)
    "Chiller load"
    annotation (Placement(transformation(extent={{220,190},{240,210}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiLoa2[2] "Chiller load"
    annotation (Placement(transformation(extent={{320,170},{340,190}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol7(
    final samplePeriod=10)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{360,170},{380,190}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneHea(final pre_u_start=false)
    "Chiller one head pressure control"
    annotation (Placement(transformation(extent={{280,-40},{300,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiTwoHea(final pre_u_start=true)
    "Chiller two head pressure control"
    annotation (Placement(transformation(extent={{280,-80},{300,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerOpe2(
    final k=0) "Closed isolation valve"
    annotation (Placement(transformation(extent={{-20,-160},{0,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Switch IsoValTwo "Logical switch"
    annotation (Placement(transformation(extent={{60,-200},{80,-180}})));

equation
  connect(booPul.y,staDow. u)
    annotation (Line(points={{-358,180},{-342,180}}, color={255,0,255}));
  connect(staDow.y, dowProCon.uStaDow)
    annotation (Line(points={{-318,180},{-310,180},{-310,159},{-162,159}},
      color={255,0,255}));
  connect(enaPri.y, dowProCon.uChiPri)
    annotation (Line(points={{-358,130},{-300,130},{-300,157},{-162,157}},
      color={255,127,0}));
  connect(minOPLR.y, dowProCon.minOPLR)
    annotation (Line(points={{-358,90},{-298,90},{-298,153.8},{-162,153.8}},
      color={0,0,127}));
  connect(dowProCon.yChi, pre2.u)
    annotation (Line(points={{-138,152},{-90,152},{-90,110},{-82,110}},
      color={255,0,255}));
  connect(pre2.y, swi1.u2)
    annotation (Line(points={{-58,110},{-40,110},{-40,70},{-320,70},{-320,30},
      {-302,30}}, color={255,0,255}));
  connect(chiLoa.y, swi1.u1)
    annotation (Line(points={{-358,50},{-340,50},{-340,38},{-302,38}},
      color={0,0,127}));
  connect(zer1.y, swi1.u3)
    annotation (Line(points={{-358,10},{-340,10},{-340,22},{-302,22}},
      color={0,0,127}));
  connect(swi1.y, dowProCon.uChiLoa)
    annotation (Line(points={{-278,30},{-270,30},{-270,151.8},{-162,151.8}},
      color={0,0,127}));
  connect(pre2.y, dowProCon.uChi)
    annotation (Line(points={{-58,110},{-40,110},{-40,70},{-268,70},{-268,149},
      {-162,149}}, color={255,0,255}));
  connect(chiWatFlo.y, dowProCon.VChiWat_flow)
    annotation (Line(points={{-358,-30},{-266,-30},{-266,146},{-162,146}},
      color={0,0,127}));
  connect(staDow.y, chiSta.u2)
    annotation (Line(points={{-318,180},{-310,180},{-310,-90},{-302,-90}},
      color={255,0,255}));
  connect(staTwo.y, chiSta.u3)
    annotation (Line(points={{-358,-110},{-340,-110},{-340,-98},{-302,-98}},
      color={0,0,127}));
  connect(staOne.y, chiSta.u1)
    annotation (Line(points={{-358,-70},{-340,-70},{-340,-82},{-302,-82}},
      color={0,0,127}));
  connect(chiSta.y, reaToInt1.u)
    annotation (Line(points={{-278,-90},{-262,-90}},   color={0,0,127}));
  connect(reaToInt1.y, dowProCon.uChiSta)
    annotation (Line(points={{-238,-90},{-230,-90},{-230,143},{-162,143}},
      color={255,127,0}));
  connect(pre2.y, dowProCon.uChiHeaCon)
    annotation (Line(points={{-58,110},{-40,110},{-40,70},{-228,70},{-228,140},
      {-162,140}}, color={255,0,255}));
  connect(staDow.y, booRep.u)
    annotation (Line(points={{-318,180},{-310,180},{-310,-130},{-302,-130}},
      color={255,0,255}));
  connect(booRep.y, IsoVal.u2)
    annotation (Line(points={{-278,-130},{-270,-130},{-270,-160},{-262,-160}},
      color={255,0,255}));
  connect(fulOpe.y, IsoVal.u3)
    annotation (Line(points={{-358,-160},{-340,-160},{-340,-168},{-262,-168}},
      color={0,0,127}));
  connect(dowProCon.yChiWatIsoVal, zerOrdHol.u)
    annotation (Line(points={{-138,144},{-92,144},{-92,40},{-82,40}},
      color={0,0,127}));
  connect(zerOrdHol.y, IsoVal.u1)
    annotation (Line(points={{-58,40},{-44,40},{-44,-140},{-266,-140},{-266,-152},
      {-262,-152}}, color={0,0,127}));
  connect(IsoVal.y, dowProCon.uChiWatIsoVal)
    annotation (Line(points={{-238,-160},{-226,-160},{-226,137},{-162,137}},
      color={0,0,127}));
  connect(pre2.y, dowProCon.uChiWatReq)
    annotation (Line(points={{-58,110},{-40,110},{-40,70},{-224,70},{-224,134},
      {-162,134}}, color={255,0,255}));
  connect(pre2.y, dowProCon.uConWatReq)
    annotation (Line(points={{-58,110},{-40,110},{-40,70},{-222,70},{-222,132},
      {-162,132}}, color={255,0,255}));
  connect(pre2.y, dowProCon.uChiConIsoVal)
    annotation (Line(points={{-58,110},{-40,110},{-40,70},{-220,70},{-220,129},
      {-162,129}}, color={255,0,255}));
  connect(wseSta.y, dowProCon.uWSE)
    annotation (Line(points={{-358,-200},{-218,-200},{-218,126},{-162,126}},
      color={255,0,255}));
  connect(dowProCon.yDesConWatPumSpe, zerOrdHol1.u)
    annotation (Line(points={{-138,129},{-100,129},{-100,-10},{-82,-10}},
      color={0,0,127}));
  connect(zerOrdHol1.y, dowProCon.uConWatPumSpeSet)
    annotation (Line(points={{-58,-10},{-48,-10},{-48,-90},{-216,-90},{-216,123},
      {-162,123}}, color={0,0,127}));
  connect(zerOrdHol1.y, zerOrdHol2.u)
    annotation (Line(points={{-58,-10},{-48,-10},{-48,-30},{-100,-30},{-100,-50},
      {-82,-50}}, color={0,0,127}));
  connect(zerOrdHol2.y, dowProCon.uConWatPumSpe)
    annotation (Line(points={{-58,-50},{-52,-50},{-52,-70},{-214,-70},{-214,121},
      {-162,121}}, color={0,0,127}));
  connect(booPul1.y, staDow1.u)
    annotation (Line(points={{2,180},{18,180}}, color={255,0,255}));
  connect(chiSta1.y, reaToInt2.u)
    annotation (Line(points={{82,-90},{98,-90}}, color={0,0,127}));
  connect(staDow1.y, chiOneLoa.u2)
    annotation (Line(points={{42,180},{50,180},{50,50},{58,50}},
      color={255,0,255}));
  connect(staDow1.y, chiTwoLoa.u2)
    annotation (Line(points={{42,180},{50,180},{50,10},{58,10}},
      color={255,0,255}));
  connect(chiLoa1.y, chiTwoLoa.u3)
    annotation (Line(points={{2,10},{20,10},{20,2},{58,2}}, color={0,0,127}));
  connect(zerLoa.y, chiOneLoa.u3)
    annotation (Line(points={{2,50},{20,50},{20,42},{58,42}}, color={0,0,127}));
  connect(chiLoa3.y, chiLoa2[1].u1)
    annotation (Line(points={{242,200},{300,200},{300,188},{318,188}},
      color={0,0,127}));
  connect(zerOrdHol6.y, chiLoa2[2].u1)
    annotation (Line(points={{282,180},{300,180},{300,188},{318,188}},
      color={0,0,127}));
  connect(zer3.y, chiLoa2.u3)
    annotation (Line(points={{282,150},{300,150},{300,172},{318,172}},
      color={0,0,127}));
  connect(dowProCon1.yChiDem[2], zerOrdHol6.u)
    annotation (Line(points={{222,156},{240,156},{240,180},{258,180}},
      color={0,0,127}));
  connect(dowProCon1.yChi[1], chiOneSta.u)
    annotation (Line(points={{222,151},{240,151},{240,100},{278,100}},
      color={255,0,255}));
  connect(dowProCon1.yChi[2], chiTwoSta.u)
    annotation (Line(points={{222,153},{242,153},{242,60},{278,60}},
      color={255,0,255}));
  connect(chiOneSta.y, chiLoa2[1].u2)
    annotation (Line(points={{302,100},{310,100},{310,180},{318,180}},
      color={255,0,255}));
  connect(chiTwoSta.y, chiLoa2[2].u2)
    annotation (Line(points={{302,60},{312,60},{312,180},{318,180}},
      color={255,0,255}));
  connect(chiLoa2[2].y, chiTwoLoa.u1)
    annotation (Line(points={{342,180},{350,180},{350,-10},{40,-10},{40,18},
      {58,18}},  color={0,0,127}));
  connect(chiLoa2[1].y, zerOrdHol7.u)
    annotation (Line(points={{342,180},{358,180}}, color={0,0,127}));
  connect(zerOrdHol7.y, chiOneLoa.u1)
    annotation (Line(points={{382,180},{390,180},{390,30},{40,30},{40,58},{58,58}},
      color={0,0,127}));
  connect(staDow1.y, dowProCon1.uStaDow)
    annotation (Line(points={{42,180},{50,180},{50,159},{198,159}},
      color={255,0,255}));
  connect(enaPri1.y, dowProCon1.uChiPri)
    annotation (Line(points={{2,130},{52,130},{52,157},{198,157}},
      color={255,127,0}));
  connect(minOPLR1.y, dowProCon1.minOPLR)
    annotation (Line(points={{2,90},{54,90},{54,153.8},{198,153.8}},
      color={0,0,127}));
  connect(chiOneLoa.y, dowProCon1.uChiLoa[1])
    annotation (Line(points={{82,50},{90,50},{90,150.8},{198,150.8}},
      color={0,0,127}));
  connect(chiTwoLoa.y, dowProCon1.uChiLoa[2])
    annotation (Line(points={{82,10},{92,10},{92,152.8},{198,152.8}},
      color={0,0,127}));
  connect(chiOneSta.y, dowProCon1.uChi[1])
    annotation (Line(points={{302,100},{310,100},{310,80},{100,80},{100,148},
      {198,148}},  color={255,0,255}));
  connect(chiTwoSta.y, dowProCon1.uChi[2])
    annotation (Line(points={{302,60},{312,60},{312,40},{102,40},{102,150},
      {198,150}},  color={255,0,255}));
  connect(chiWatFlo1.y, dowProCon1.VChiWat_flow)
    annotation (Line(points={{2,-30},{104,-30},{104,146},{198,146}},
      color={0,0,127}));
  connect(staDow1.y, chiSta1.u2)
    annotation (Line(points={{42,180},{50,180},{50,-90},{58,-90}},
      color={255,0,255}));
  connect(staOne1.y, chiSta1.u1)
    annotation (Line(points={{2,-70},{20,-70},{20,-82},{58,-82}},
      color={0,0,127}));
  connect(staTwo1.y, chiSta1.u3)
    annotation (Line(points={{2,-110},{20,-110},{20,-98},{58,-98}},
      color={0,0,127}));
  connect(reaToInt2.y, dowProCon1.uChiSta)
    annotation (Line(points={{122,-90},{130,-90},{130,143},{198,143}},
      color={255,127,0}));
  connect(dowProCon1.yChiHeaCon[1], chiOneHea.u)
    annotation (Line(points={{222,136},{246,136},{246,-30},{278,-30}},
      color={255,0,255}));
  connect(dowProCon1.yChiHeaCon[2], chiTwoHea.u)
    annotation (Line(points={{222,138},{248,138},{248,-70},{278,-70}},
      color={255,0,255}));
  connect(chiOneHea.y, dowProCon1.uChiHeaCon[1])
    annotation (Line(points={{302,-30},{320,-30},{320,-50},{132,-50},{132,139},
      {198,139}}, color={255,0,255}));
  connect(chiTwoHea.y, dowProCon1.uChiHeaCon[2])
    annotation (Line(points={{302,-70},{320,-70},{320,-90},{134,-90},{134,141},
      {198,141}}, color={255,0,255}));
  connect(zerOpe2.y, IsoValOne.u3)
    annotation (Line(points={{2,-150},{20,-150},{20,-158},{58,-158}},
      color={0,0,127}));
  connect(fulOpe1.y, IsoValTwo.u3)
    annotation (Line(points={{2,-190},{20,-190},{20,-198},{58,-198}},
      color={0,0,127}));
  connect(staDow1.y, IsoValOne.u2)
    annotation (Line(points={{42,180},{50,180},{50,-150},{58,-150}},
      color={255,0,255}));
  connect(staDow1.y, IsoValTwo.u2)
    annotation (Line(points={{42,180},{50,180},{50,-190},{58,-190}},
      color={255,0,255}));
  connect(dowProCon1.yChiWatIsoVal, zerOrdHol3.u)
    annotation (Line(points={{222,144},{252,144},{252,-110},{278,-110}},
      color={0,0,127}));
  connect(zerOrdHol3[1].y, IsoValOne.u1)
    annotation (Line(points={{302,-110},{320,-110},{320,-130},{40,-130},{40,-142},
      {58,-142}}, color={0,0,127}));
  connect(zerOrdHol3[2].y, IsoValTwo.u1)
    annotation (Line(points={{302,-110},{320,-110},{320,-130},{40,-130},{40,-182},
      {58,-182}}, color={0,0,127}));
  connect(IsoValOne.y, dowProCon1.uChiWatIsoVal[1])
    annotation (Line(points={{82,-150},{136,-150},{136,136},{198,136}},
      color={0,0,127}));
  connect(IsoValTwo.y, dowProCon1.uChiWatIsoVal[2])
    annotation (Line(points={{82,-190},{138,-190},{138,138},{198,138}},
      color={0,0,127}));
  connect(chiOneSta.y, dowProCon1.uChiWatReq[1])
    annotation (Line(points={{302,100},{310,100},{310,80},{150,80},{150,133},
      {198,133}}, color={255,0,255}));
  connect(chiTwoSta.y, dowProCon1.uChiWatReq[2])
    annotation (Line(points={{302,60},{312,60},{312,40},{152,40},{152,135},
      {198,135}}, color={255,0,255}));
  connect(chiOneSta.y, dowProCon1.uConWatReq[1])
    annotation (Line(points={{302,100},{310,100},{310,80},{154,80},{154,131},
      {198,131}}, color={255,0,255}));
  connect(chiTwoSta.y, dowProCon1.uConWatReq[2])
    annotation (Line(points={{302,60},{312,60},{312,40},{156,40},{156,133},
      {198,133}}, color={255,0,255}));
  connect(chiOneSta.y, dowProCon1.uChiConIsoVal[1])
    annotation (Line(points={{302,100},{310,100},{310,80},{158,80},{158,128},
      {198,128}}, color={255,0,255}));
  connect(chiTwoSta.y, dowProCon1.uChiConIsoVal[2])
    annotation (Line(points={{302,60},{312,60},{312,40},{160,40},{160,130},
      {198,130}}, color={255,0,255}));
  connect(wseSta1.y, dowProCon1.uWSE)
    annotation (Line(points={{2,-230},{170,-230},{170,126},{198,126}},
      color={255,0,255}));
  connect(dowProCon1.yDesConWatPumSpe, zerOrdHol4.u)
    annotation (Line(points={{222,129},{258,129},{258,-150},{278,-150}},
      color={0,0,127}));
  connect(zerOrdHol4.y, zerOrdHol5.u)
    annotation (Line(points={{302,-150},{320,-150},{320,-170},{260,-170},
      {260,-190},{278,-190}}, color={0,0,127}));
  connect(zerOrdHol4.y, dowProCon1.uConWatPumSpeSet)
    annotation (Line(points={{302,-150},{320,-150},{320,-170},{172,-170},
      {172,123},{198,123}},  color={0,0,127}));
  connect(zerOrdHol5.y, dowProCon1.uConWatPumSpe)
    annotation (Line(points={{302,-190},{320,-190},{320,-210},{174,-210},{174,121},
      {198,121}}, color={0,0,127}));

annotation (
 experiment(StopTime=1500, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Validation/Down.mos"
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
        coordinateSystem(preserveAspectRatio=false, extent={{-400,-260},{400,260}}),
        graphics={
          Rectangle(
          extent={{-38,258},{398,-258}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Rectangle(
          extent={{-398,258},{-42,-258}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-384,258},{-336,250}},
          lineColor={0,0,127},
          textString="Stage down:"),
        Text(
          extent={{-374,246},{-214,236}},
          lineColor={0,0,127},
          textString="from stage 2 which has chiller one and two enabled, "),
        Text(
          extent={{-378,234},{-276,220}},
          lineColor={0,0,127},
          textString="to stage 1 which only has chiller 1."),
        Text(
          extent={{-14,232},{176,216}},
          lineColor={0,0,127},
          textString="to stage 1 which only has small chiller enabled (chiller 1)."),
        Text(
          extent={{-14,244},{174,234}},
          lineColor={0,0,127},
          textString="from stage 2 which only has large chiller enabled (chiller 2), "),
        Text(
          extent={{-24,256},{24,248}},
          lineColor={0,0,127},
          textString="Stage down:")}));
end Down;
