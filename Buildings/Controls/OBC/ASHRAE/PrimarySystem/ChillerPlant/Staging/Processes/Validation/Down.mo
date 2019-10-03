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
    annotation (Placement(transformation(extent={{-160,80},{-140,120}})));
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
    annotation (Placement(transformation(extent={{200,80},{220,120}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp chiWatFlo(
    final height=-1,
    final duration=300,
    final offset=2,
    final startTime=800) "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-380,-80},{-360,-60}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=2) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-300,-180},{-280,-160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp chiWatFlo1(
    final height=0.5 - 5/3,
    final duration=300,
    final offset=5/3,
    final startTime=800) "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15,
    final period=1200) "Boolean pulse"
    annotation (Placement(transformation(extent={{-380,130},{-360,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not staDow "Stage down command"
    annotation (Placement(transformation(extent={{-340,130},{-320,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiLoa[2](
    final k=fill(1000,2)) "Chiller load"
    annotation (Placement(transformation(extent={{-380,0},{-360,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minOPLR(
    final k=0.78) "Minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-380,40},{-360,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant fulOpe[2](
    final k=fill(1, 2)) "Full open isolation valve"
    annotation (Placement(transformation(extent={{-380,-210},{-360,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1[2](
    final k=fill(0,2)) "Constant zero"
    annotation (Placement(transformation(extent={{-380,-40},{-360,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre2[2](
    final pre_u_start=fill(true,2)) "Break algebraic loop"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[2] "Logical switch"
    annotation (Placement(transformation(extent={{-300,-20},{-280,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaPri[2](final k={1,2})
    "Chiller enabling priority"
    annotation (Placement(transformation(extent={{-380,80},{-360,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staTwo(
    final k=2) "Chiller stage two"
    annotation (Placement(transformation(extent={{-380,-160},{-360,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staOne(
    final k=1) "Chiller stage one"
    annotation (Placement(transformation(extent={{-380,-120},{-360,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiSta "Logical switch"
    annotation (Placement(transformation(extent={{-300,-140},{-280,-120}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-260,-140},{-240,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch IsoVal[2] "Logical switch"
    annotation (Placement(transformation(extent={{-260,-210},{-240,-190}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[2](
    final samplePeriod=fill(10, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant wseSta(final k=false)
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-380,-250},{-360,-230}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1(
    final samplePeriod=10)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol2(
    final samplePeriod=20)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.15,
    final period=1200) "Boolean pulse"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not staDow1 "Stage down command"
    annotation (Placement(transformation(extent={{20,130},{40,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiLoa1(
    final k=1000) "Chiller load"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minOPLR1(final k=0.78)
    "Minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant fulOpe1(final k=1)
    "Full open isolation valve"
    annotation (Placement(transformation(extent={{-20,-240},{0,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerLoa(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneSta(
    final pre_u_start=false) "Chiller one status"
    annotation (Placement(transformation(extent={{280,50},{300,70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiOneLoa "Chiller one load"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaPri1[2](
    final k={1,2}) "Chiller enabling priority"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staTwo1(
    final k=2) "Chiller stage two"
    annotation (Placement(transformation(extent={{-20,-160},{0,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staOne1(
    final k=1) "Chiller stage one"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiSta1 "Logical switch"
    annotation (Placement(transformation(extent={{60,-140},{80,-120}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{100,-140},{120,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch IsoValOne "Logical switch"
    annotation (Placement(transformation(extent={{60,-200},{80,-180}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol3[2](
    final samplePeriod=fill(10, 2))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{280,-160},{300,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant wseSta1(final k=false)
    "Waterside economizer status"
    annotation (Placement(transformation(extent={{-20,-280},{0,-260}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol4(
    final samplePeriod=10)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{280,-200},{300,-180}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol5(
    final samplePeriod=20)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{280,-240},{300,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiTwoLoa "Chiller two load"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiTwoSta(
    final pre_u_start=true) "Chiller two status"
    annotation (Placement(transformation(extent={{280,10},{300,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer3[2](
    final k=fill(0,2)) "Constant zero"
    annotation (Placement(transformation(extent={{260,100},{280,120}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol6(
    final samplePeriod=10) "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{260,130},{280,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiLoa3(final k=1000)
    "Chiller load"
    annotation (Placement(transformation(extent={{220,150},{240,170}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiLoa2[2] "Chiller load"
    annotation (Placement(transformation(extent={{320,130},{340,150}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol7(
    final samplePeriod=10)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{360,130},{380,150}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiOneHea(final pre_u_start=false)
    "Chiller one head pressure control"
    annotation (Placement(transformation(extent={{280,-80},{300,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiTwoHea(final pre_u_start=true)
    "Chiller two head pressure control"
    annotation (Placement(transformation(extent={{280,-120},{300,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerOpe2(
    final k=0) "Closed isolation valve"
    annotation (Placement(transformation(extent={{-20,-200},{0,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Switch IsoValTwo "Logical switch"
    annotation (Placement(transformation(extent={{60,-240},{80,-220}})));

equation
  connect(booPul.y,staDow. u)
    annotation (Line(points={{-358,140},{-342,140}}, color={255,0,255}));
  connect(staDow.y, dowProCon.uStaDow)
    annotation (Line(points={{-318,140},{-310,140},{-310,119},{-162,119}},
      color={255,0,255}));
  connect(enaPri.y, dowProCon.uChiPri)
    annotation (Line(points={{-358,90},{-300,90},{-300,117},{-162,117}},
      color={255,127,0}));
  connect(minOPLR.y, dowProCon.minOPLR)
    annotation (Line(points={{-358,50},{-298,50},{-298,113.8},{-162,113.8}},
      color={0,0,127}));
  connect(dowProCon.yChi, pre2.u)
    annotation (Line(points={{-138,111},{-90,111},{-90,70},{-82,70}},
      color={255,0,255}));
  connect(pre2.y, swi1.u2)
    annotation (Line(points={{-58,70},{-40,70},{-40,30},{-320,30},{-320,-10},
      {-302,-10}}, color={255,0,255}));
  connect(chiLoa.y, swi1.u1)
    annotation (Line(points={{-358,10},{-340,10},{-340,-2},{-302,-2}},
      color={0,0,127}));
  connect(zer1.y, swi1.u3)
    annotation (Line(points={{-358,-30},{-340,-30},{-340,-18},{-302,-18}},
      color={0,0,127}));
  connect(swi1.y, dowProCon.uChiLoa)
    annotation (Line(points={{-278,-10},{-270,-10},{-270,111.8},{-162,111.8}},
      color={0,0,127}));
  connect(pre2.y, dowProCon.uChi)
    annotation (Line(points={{-58,70},{-40,70},{-40,30},{-268,30},{-268,109},
      {-162,109}}, color={255,0,255}));
  connect(chiWatFlo.y, dowProCon.VChiWat_flow)
    annotation (Line(points={{-358,-70},{-266,-70},{-266,106},{-162,106}},
      color={0,0,127}));
  connect(staDow.y, chiSta.u2)
    annotation (Line(points={{-318,140},{-310,140},{-310,-130},{-302,-130}},
      color={255,0,255}));
  connect(staTwo.y, chiSta.u3)
    annotation (Line(points={{-358,-150},{-340,-150},{-340,-138},{-302,-138}},
      color={0,0,127}));
  connect(staOne.y, chiSta.u1)
    annotation (Line(points={{-358,-110},{-340,-110},{-340,-122},{-302,-122}},
      color={0,0,127}));
  connect(chiSta.y, reaToInt1.u)
    annotation (Line(points={{-278,-130},{-262,-130}}, color={0,0,127}));
  connect(reaToInt1.y, dowProCon.uChiSta)
    annotation (Line(points={{-238,-130},{-230,-130},{-230,103},{-162,103}},
      color={255,127,0}));
  connect(pre2.y, dowProCon.uChiHeaCon)
    annotation (Line(points={{-58,70},{-40,70},{-40,30},{-228,30},{-228,100},
      {-162,100}}, color={255,0,255}));
  connect(staDow.y, booRep.u)
    annotation (Line(points={{-318,140},{-310,140},{-310,-170},{-302,-170}},
      color={255,0,255}));
  connect(booRep.y, IsoVal.u2)
    annotation (Line(points={{-278,-170},{-270,-170},{-270,-200},{-262,-200}},
      color={255,0,255}));
  connect(fulOpe.y, IsoVal.u3)
    annotation (Line(points={{-358,-200},{-340,-200},{-340,-208},{-262,-208}},
      color={0,0,127}));
  connect(dowProCon.yChiWatIsoVal, zerOrdHol.u)
    annotation (Line(points={{-138,107},{-92,107},{-92,0},{-82,0}},
      color={0,0,127}));
  connect(zerOrdHol.y, IsoVal.u1)
    annotation (Line(points={{-58,0},{-44,0},{-44,-180},{-266,-180},{-266,-192},
      {-262,-192}}, color={0,0,127}));
  connect(IsoVal.y, dowProCon.uChiWatIsoVal)
    annotation (Line(points={{-238,-200},{-226,-200},{-226,97},{-162,97}},
      color={0,0,127}));
  connect(pre2.y, dowProCon.uChiWatReq)
    annotation (Line(points={{-58,70},{-40,70},{-40,30},{-224,30},{-224,94},
      {-162,94}}, color={255,0,255}));
  connect(pre2.y, dowProCon.uConWatReq)
    annotation (Line(points={{-58,70},{-40,70},{-40,30},{-222,30},{-222,92},
      {-162,92}}, color={255,0,255}));
  connect(pre2.y, dowProCon.uChiConIsoVal)
    annotation (Line(points={{-58,70},{-40,70},{-40,30},{-220,30},{-220,89},
      {-162,89}}, color={255,0,255}));
  connect(wseSta.y, dowProCon.uWSE)
    annotation (Line(points={{-358,-240},{-218,-240},{-218,86},{-162,86}},
      color={255,0,255}));
  connect(dowProCon.yDesConWatPumSpe, zerOrdHol1.u)
    annotation (Line(points={{-138,89},{-100,89},{-100,-50},{-82,-50}},
      color={0,0,127}));
  connect(zerOrdHol1.y, dowProCon.uConWatPumSpeSet)
    annotation (Line(points={{-58,-50},{-48,-50},{-48,-130},{-216,-130},
      {-216,83},{-162,83}}, color={0,0,127}));
  connect(zerOrdHol1.y, zerOrdHol2.u)
    annotation (Line(points={{-58,-50},{-48,-50},{-48,-70},{-100,-70},{-100,-90},
      {-82,-90}}, color={0,0,127}));
  connect(zerOrdHol2.y, dowProCon.uConWatPumSpe)
    annotation (Line(points={{-58,-90},{-52,-90},{-52,-110},{-214,-110},{-214,81},
      {-162,81}}, color={0,0,127}));
  connect(booPul1.y, staDow1.u)
    annotation (Line(points={{2,140},{18,140}}, color={255,0,255}));
  connect(chiSta1.y, reaToInt2.u)
    annotation (Line(points={{82,-130},{98,-130}}, color={0,0,127}));
  connect(staDow1.y, chiOneLoa.u2)
    annotation (Line(points={{42,140},{50,140},{50,10},{58,10}},
      color={255,0,255}));
  connect(staDow1.y, chiTwoLoa.u2)
    annotation (Line(points={{42,140},{50,140},{50,-30},{58,-30}},
      color={255,0,255}));
  connect(chiLoa1.y, chiTwoLoa.u3)
    annotation (Line(points={{2,-30},{20,-30},{20,-38},{58,-38}}, color={0,0,127}));
  connect(zerLoa.y, chiOneLoa.u3)
    annotation (Line(points={{2,10},{20,10},{20,2},{58,2}}, color={0,0,127}));
  connect(chiLoa3.y, chiLoa2[1].u1)
    annotation (Line(points={{242,160},{300,160},{300,148},{318,148}},
      color={0,0,127}));
  connect(zerOrdHol6.y, chiLoa2[2].u1)
    annotation (Line(points={{282,140},{300,140},{300,148},{318,148}},
      color={0,0,127}));
  connect(zer3.y, chiLoa2.u3)
    annotation (Line(points={{282,110},{300,110},{300,132},{318,132}},
      color={0,0,127}));
  connect(dowProCon1.yChiDem[2], zerOrdHol6.u)
    annotation (Line(points={{222,116},{240,116},{240,140},{258,140}},
      color={0,0,127}));
  connect(dowProCon1.yChi[1], chiOneSta.u)
    annotation (Line(points={{222,110},{240,110},{240,60},{278,60}},
      color={255,0,255}));
  connect(dowProCon1.yChi[2], chiTwoSta.u)
    annotation (Line(points={{222,112},{242,112},{242,20},{278,20}},
      color={255,0,255}));
  connect(chiOneSta.y, chiLoa2[1].u2)
    annotation (Line(points={{302,60},{310,60},{310,140},{318,140}},
      color={255,0,255}));
  connect(chiTwoSta.y, chiLoa2[2].u2)
    annotation (Line(points={{302,20},{312,20},{312,140},{318,140}},
      color={255,0,255}));
  connect(chiLoa2[2].y, chiTwoLoa.u1)
    annotation (Line(points={{342,140},{350,140},{350,-50},{40,-50},{40,-22},
      {58,-22}}, color={0,0,127}));
  connect(chiLoa2[1].y, zerOrdHol7.u)
    annotation (Line(points={{342,140},{358,140}}, color={0,0,127}));
  connect(zerOrdHol7.y, chiOneLoa.u1)
    annotation (Line(points={{382,140},{390,140},{390,-10},{40,-10},{40,18},
      {58,18}}, color={0,0,127}));
  connect(staDow1.y, dowProCon1.uStaDow)
    annotation (Line(points={{42,140},{50,140},{50,119},{198,119}},
      color={255,0,255}));
  connect(enaPri1.y, dowProCon1.uChiPri)
    annotation (Line(points={{2,90},{52,90},{52,117},{198,117}},
      color={255,127,0}));
  connect(minOPLR1.y, dowProCon1.minOPLR)
    annotation (Line(points={{2,50},{54,50},{54,113.8},{198,113.8}},
      color={0,0,127}));
  connect(chiOneLoa.y, dowProCon1.uChiLoa[1])
    annotation (Line(points={{82,10},{90,10},{90,110.8},{198,110.8}},
      color={0,0,127}));
  connect(chiTwoLoa.y, dowProCon1.uChiLoa[2])
    annotation (Line(points={{82,-30},{92,-30},{92,112.8},{198,112.8}},
      color={0,0,127}));
  connect(chiOneSta.y, dowProCon1.uChi[1])
    annotation (Line(points={{302,60},{310,60},{310,40},{100,40},{100,108},
      {198,108}}, color={255,0,255}));
  connect(chiTwoSta.y, dowProCon1.uChi[2])
    annotation (Line(points={{302,20},{312,20},{312,0},{102,0},{102,110},
      {198,110}}, color={255,0,255}));
  connect(chiWatFlo1.y, dowProCon1.VChiWat_flow)
    annotation (Line(points={{2,-70},{104,-70},{104,106},{198,106}},
      color={0,0,127}));
  connect(staDow1.y, chiSta1.u2)
    annotation (Line(points={{42,140},{50,140},{50,-130},{58,-130}},
      color={255,0,255}));
  connect(staOne1.y, chiSta1.u1)
    annotation (Line(points={{2,-110},{20,-110},{20,-122},{58,-122}},
      color={0,0,127}));
  connect(staTwo1.y, chiSta1.u3)
    annotation (Line(points={{2,-150},{20,-150},{20,-138},{58,-138}},
      color={0,0,127}));
  connect(reaToInt2.y, dowProCon1.uChiSta)
    annotation (Line(points={{122,-130},{130,-130},{130,103},{198,103}},
      color={255,127,0}));
  connect(dowProCon1.yChiHeaCon[1], chiOneHea.u)
    annotation (Line(points={{222,96},{246,96},{246,-70},{278,-70}},
      color={255,0,255}));
  connect(dowProCon1.yChiHeaCon[2], chiTwoHea.u)
    annotation (Line(points={{222,98},{248,98},{248,-110},{278,-110}},
      color={255,0,255}));
  connect(chiOneHea.y, dowProCon1.uChiHeaCon[1])
    annotation (Line(points={{302,-70},{316,-70},{316,-90},{132,-90},{132,99},
      {198,99}}, color={255,0,255}));
  connect(chiTwoHea.y, dowProCon1.uChiHeaCon[2])
    annotation (Line(points={{302,-110},{320,-110},{320,-130},{134,-130},
      {134,101},{198,101}}, color={255,0,255}));
  connect(zerOpe2.y, IsoValOne.u3)
    annotation (Line(points={{2,-190},{20,-190},{20,-198},{58,-198}},
      color={0,0,127}));
  connect(fulOpe1.y, IsoValTwo.u3)
    annotation (Line(points={{2,-230},{20,-230},{20,-238},{58,-238}},
      color={0,0,127}));
  connect(staDow1.y, IsoValOne.u2)
    annotation (Line(points={{42,140},{50,140},{50,-190},{58,-190}},
      color={255,0,255}));
  connect(staDow1.y, IsoValTwo.u2)
    annotation (Line(points={{42,140},{50,140},{50,-230},{58,-230}},
      color={255,0,255}));
  connect(dowProCon1.yChiWatIsoVal, zerOrdHol3.u)
    annotation (Line(points={{222,107},{252,107},{252,-150},{278,-150}},
      color={0,0,127}));
  connect(zerOrdHol3[1].y, IsoValOne.u1)
    annotation (Line(points={{302,-150},{320,-150},{320,-170},{40,-170},{40,-182},
      {58,-182}}, color={0,0,127}));
  connect(zerOrdHol3[2].y, IsoValTwo.u1)
    annotation (Line(points={{302,-150},{320,-150},{320,-170},{40,-170},
      {40,-222},{58,-222}}, color={0,0,127}));
  connect(IsoValOne.y, dowProCon1.uChiWatIsoVal[1])
    annotation (Line(points={{82,-190},{136,-190},{136,96},{198,96}},
      color={0,0,127}));
  connect(IsoValTwo.y, dowProCon1.uChiWatIsoVal[2])
    annotation (Line(points={{82,-230},{138,-230},{138,98},{198,98}},
      color={0,0,127}));
  connect(chiOneSta.y, dowProCon1.uChiWatReq[1])
    annotation (Line(points={{302,60},{310,60},{310,40},{150,40},{150,93},
      {198,93}}, color={255,0,255}));
  connect(chiTwoSta.y, dowProCon1.uChiWatReq[2])
    annotation (Line(points={{302,20},{312,20},{312,0},{152,0},{152,95},
      {198,95}}, color={255,0,255}));
  connect(chiOneSta.y, dowProCon1.uConWatReq[1])
    annotation (Line(points={{302,60},{310,60},{310,40},{154,40},{154,91},
      {198,91}}, color={255,0,255}));
  connect(chiTwoSta.y, dowProCon1.uConWatReq[2])
    annotation (Line(points={{302,20},{312,20},{312,0},{156,0},{156,93},
      {198,93}}, color={255,0,255}));
  connect(chiOneSta.y, dowProCon1.uChiConIsoVal[1])
    annotation (Line(points={{302,60},{310,60},{310,40},{158,40},{158,88},
      {198,88}}, color={255,0,255}));
  connect(chiTwoSta.y, dowProCon1.uChiConIsoVal[2])
    annotation (Line(points={{302,20},{312,20},{312,0},{160,0},{160,90},
      {198,90}}, color={255,0,255}));
  connect(wseSta1.y, dowProCon1.uWSE)
    annotation (Line(points={{2,-270},{170,-270},{170,86},{198,86}},
      color={255,0,255}));
  connect(dowProCon1.yDesConWatPumSpe, zerOrdHol4.u)
    annotation (Line(points={{222,89},{258,89},{258,-190},{278,-190}},
      color={0,0,127}));
  connect(zerOrdHol4.y, zerOrdHol5.u)
    annotation (Line(points={{302,-190},{320,-190},{320,-210},{260,-210},
      {260,-230},{278,-230}}, color={0,0,127}));
  connect(zerOrdHol4.y, dowProCon1.uConWatPumSpeSet)
    annotation (Line(points={{302,-190},{320,-190},{320,-210},{172,-210},
      {172,83},{198,83}}, color={0,0,127}));
  connect(zerOrdHol5.y, dowProCon1.uConWatPumSpe)
    annotation (Line(points={{302,-230},{320,-230},{320,-250},{174,-250},
      {174,81},{198,81}}, color={0,0,127}));

annotation (
 experiment(StopTime=1200, Tolerance=1e-06),
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
        coordinateSystem(preserveAspectRatio=false, extent={{-400,-300},{400,300}})));
end Down;
