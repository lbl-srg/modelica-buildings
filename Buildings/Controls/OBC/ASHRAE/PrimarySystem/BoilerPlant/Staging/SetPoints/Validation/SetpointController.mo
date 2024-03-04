within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Validation;
model SetpointController
  "Validates boiler stage status setpoint signal generation for boiler plants"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.SetpointController staSetCon(
    final have_priOnl=false,
    final nBoi=2,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final nSta=3,
    final staMat=[1,0; 0,1; 1,1],
    final boiDesCap={1000000,1500000},
    final boiFirMin={0.2,0.3},
    final boiMinPriPumSpeSta={0,0,0},
    final delStaCha=600,
    final avePer=300,
    final fraNonConBoi=0.9,
    final fraConBoi=1.5,
    final delEffCon=600,
    final TDif=10,
    final delFaiCon=900,
    final sigDif=0.01,
    final TDifHys=1,
    final fraMinFir=1.1,
    final delMinFir=300,
    final fraDesCap=0.8,
    final delDesCapNonConBoi=600,
    final delDesCapConBoi=300,
    final TCirDif=3,
    final delTRetDif=300,
    final dTemp=0.1)
    "Testing staging setpoint controller for condensing boiler plant that is not primary-only"
    annotation (Placement(transformation(extent={{60,140},{80,176}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.SetpointController staSetCon1(
    final have_priOnl=false,
    final nBoi=2,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.nonCondensingBoiler,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.nonCondensingBoiler},
    final nSta=3,
    final staMat=[1,0; 0,1; 1,1],
    final boiDesCap={1000000,1500000},
    final boiFirMin={0.2,0.3},
    final boiMinPriPumSpeSta={0,0,0},
    final delStaCha=600,
    final avePer=300,
    final fraNonConBoi=0.9,
    final fraConBoi=1.5,
    final delEffCon=600,
    final TDif=10,
    final delFaiCon=900,
    final sigDif=0.01,
    final TDifHys=1,
    final fraMinFir=1.1,
    final delMinFir=300,
    final fraDesCap=0.8,
    final delDesCapNonConBoi=600,
    final delDesCapConBoi=300,
    final TCirDif=3,
    final delTRetDif=300,
    final dTemp=0.1)
    "Testing staging setpoint controller for non-condensing boiler plant"
    annotation (Placement(transformation(extent={{60,-100},{80,-64}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.SetpointController staSetCon2(
    final have_priOnl=true,
    final nBoi=2,
    final boiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler},
    final nSta=3,
    final staMat=[1,0; 0,1; 1,1],
    final boiDesCap={1000000,1500000},
    final boiFirMin={0.2,0.3},
    final boiMinPriPumSpeSta={0,0,0},
    final delStaCha=600,
    final avePer=300,
    final fraNonConBoi=0.9,
    final fraConBoi=1.5,
    final delEffCon=600,
    final TDif=10,
    final delFaiCon=900,
    final sigDif=0.01,
    final TDifHys=1,
    final fraMinFir=1.1,
    final delMinFir=300,
    final fraDesCap=0.8,
    final delDesCapNonConBoi=600,
    final delDesCapConBoi=300,
    final TCirDif=3,
    final delTRetDif=300,
    final dTemp=0.1)
    "Testing staging setpoint controller for primary-only, condensing boiler plant"
    annotation (Placement(transformation(extent={{460,140},{480,176}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staCha(
    final trueHoldDuration=900,
    final falseHoldDuration=0)
    "Detect stage change signal"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staCha1(
    final trueHoldDuration=900,
    final falseHoldDuration=0)
    "Detect stage change signal"
    annotation (Placement(transformation(extent={{100,-180},{120,-160}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staCha2(
    final trueHoldDuration=900,
    final falseHoldDuration=0)
    "Detect stage change signal"
    annotation (Placement(transformation(extent={{500,60},{520,80}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staUp(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Detect stage up signal"
    annotation (Placement(transformation(extent={{100,180},{120,200}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staUp1(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Detect stage up signal"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staUp2(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Detect stage up signal"
    annotation (Placement(transformation(extent={{500,180},{520,200}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staDow(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Detect stage down signal"
    annotation (Placement(transformation(extent={{100,120},{120,140}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staDow1(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Detect stage down signal"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold staDow2(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Detect stage down signal"
    annotation (Placement(transformation(extent={{500,120},{520,140}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine THotWatRet(
    final amplitude=7,
    final phase=0,
    final offset=273.15 + 22,
    final freqHz=1/43200)
    "Hot water return temeprature"
    annotation (Placement(transformation(extent={{-80,178},{-60,198}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant boiAva[2](
    final k={true,true})
    "Boiler availability vector"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));

  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol(
    final samplePeriod=10) "Hold stage setpoint for signal feedback"
    annotation (Placement(transformation(extent={{140,148},{160,168}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Integer to Real converter"
    annotation (Placement(transformation(extent={{100,148},{120,168}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Real to Integer converter"
    annotation (Placement(transformation(extent={{180,148},{200,168}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre3
    "Logical pre block"
    annotation (Placement(transformation(extent={{130,60},{150,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant plaSta(
    final k=true)
    "Plant status"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=10,
    final delayOnInit=true)
    "Delay plant enable signal"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THotWatSupSet(
    final k=273.15 + 30)
    "Hot water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zero(
    final k=10^(-10))
    "Constant"
    annotation (Placement(transformation(extent={{-160,110},{-140,130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THotWatSup(
    final k=273.15 + 30)
    "Hot water supply temperature"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VHotWat_flow(
    final k=0.037)
    "Hot water flow rate"
    annotation (Placement(transformation(extent={{-160,170},{-140,190}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THotWatRetSec(
    final k=273.15 + 26)
    "Hot water secondary loop return temperature"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine uPumSpe(
    final amplitude=1,
    final offset=0,
    final freqHz=1/21600)
    "Pump speed signal"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1
    "Falling edge detector"
    annotation (Placement(transformation(extent={{160,-180},{180,-160}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep1(
    final nout=3)
    "Convert input into array"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine THotWatRet1(
    final amplitude=7,
    final phase=0,
    final offset=273.15 + 22,
    final freqHz=1/21600)
    "Hot water return temeprature"
    annotation (Placement(transformation(extent={{-80,-62},{-60,-42}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant boiAva1[2](
    final k={true,true})
    "Boiler availability vector"
    annotation (Placement(transformation(extent={{-160,-230},{-140,-210}})));

  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1(
    final samplePeriod=10)
    "Hold stage setpoint for signal feedback"
    annotation (Placement(transformation(extent={{140,-92},{160,-72}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    "Integer to Real converter"
    annotation (Placement(transformation(extent={{100,-92},{120,-72}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Real to Integer converter"
    annotation (Placement(transformation(extent={{180,-92},{200,-72}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Logical pre block"
    annotation (Placement(transformation(extent={{130,-180},{150,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant plaSta1(
    final k=true)
    "Plant status"
    annotation (Placement(transformation(extent={{-160,-200},{-140,-180}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=10,
    final delayOnInit=true)
    "Delay plant enable signal"
    annotation (Placement(transformation(extent={{-120,-200},{-100,-180}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THotWatSupSet1(
    final k=273.15 + 30)
    "Hot water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zero1(
    final k=10^(-10))
    "Constant"
    annotation (Placement(transformation(extent={{-160,-130},{-140,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THotWatSup1(
    final k=273.15 + 30)
    "Hot water supply temperature"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VHotWat_flow1(
    final k=0.037)
    "Hot water flow rate"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THotWatRetSec1(
    final k=273.15 + 26)
    "Hot water secondary loop return temperature"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine uPumSpe1(
    final amplitude=1,
    final offset=0,
    final freqHz=1/21600) "Pump speed signal"
    annotation (Placement(transformation(extent={{-80,-180},{-60,-160}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg2
    "Falling edge detector"
    annotation (Placement(transformation(extent={{560,60},{580,80}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep2(
    final nout=3)
    "Convert input into array"
    annotation (Placement(transformation(extent={{280,110},{300,130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine THotWatRet2(
    final amplitude=7,
    final phase=0,
    final offset=273.15 + 22,
    final freqHz=1/21600)
    "Hot water return temeprature"
    annotation (Placement(transformation(extent={{320,170},{340,190}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant boiAva2[2](
    final k={true,true})
    "Boiler availability vector"
    annotation (Placement(transformation(extent={{240,10},{260,30}})));

  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol2(
    final samplePeriod=10)
    "Hold stage setpoint for signal feedback"
    annotation (Placement(transformation(extent={{540,148},{560,168}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea2
    "Integer to Real converter"
    annotation (Placement(transformation(extent={{500,148},{520,168}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Real to Integer converter"
    annotation (Placement(transformation(extent={{580,148},{600,168}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2
    "Logical pre block"
    annotation (Placement(transformation(extent={{530,60},{550,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant plaSta2(
    final k=true)
    "Plant status"
    annotation (Placement(transformation(extent={{240,40},{260,60}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=10,
    final delayOnInit=true)
    "Delay plant enable signal"
    annotation (Placement(transformation(extent={{280,40},{300,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THotWatSupSet2(
    final k=273.15 + 30)
    "Hot water supply temperature setpoint"
    annotation (Placement(transformation(extent={{320,202},{340,222}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zero2(
    final k=10^(-10))
    "Constant"
    annotation (Placement(transformation(extent={{240,110},{260,130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THotWatSup2(
    final k=273.15 + 30)
    "Hot water supply temperature"
    annotation (Placement(transformation(extent={{320,130},{340,150}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VHotWat_flow2(
    final k=0.037)
    "Hot water flow rate"
    annotation (Placement(transformation(extent={{240,170},{260,190}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine uPumSpe2(
    final amplitude=1,
    final offset=0,
    final freqHz=1/21600) "Pump speed signal"
    annotation (Placement(transformation(extent={{320,80},{340,100}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Falling edge detector"
    annotation (Placement(transformation(extent={{160,60},{180,80}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=3)
    "Convert input into array"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));

equation
  connect(staSetCon.ySta,intToRea. u)
    annotation (Line(points={{82,164.923},{94,164.923},{94,158},{98,158}},
                                               color={255,127,0}));
  connect(intToRea.y,zerOrdHol. u)
    annotation (Line(points={{122,158},{138,158}},
                                                 color={0,0,127}));
  connect(zerOrdHol.y,reaToInt. u)
    annotation (Line(points={{162,158},{178,158}},
                                                 color={0,0,127}));
  connect(reaToInt.y,staSetCon. u) annotation (Line(points={{202,158},{210,158},
          {210,100},{48,100},{48,146.923},{58,146.923}},
                                     color={255,127,0}));
  connect(staSetCon.yChaEdg, staCha.u) annotation (Line(points={{82,159.385},{
          90,159.385},{90,70},{98,70}},
                            color={255,0,255}));
  connect(staCha.y, pre3.u)
    annotation (Line(points={{122,70},{128,70}}, color={255,0,255}));
  connect(truDel.y,staSetCon. uPla) annotation (Line(points={{-98,50},{32,50},{
          32,149.692},{58,149.692}},
                    color={255,0,255}));
  connect(plaSta.y, truDel.u) annotation (Line(points={{-138,50},{-122,50}},
                     color={255,0,255}));
  connect(pre3.y, falEdg.u)
    annotation (Line(points={{152,70},{158,70}}, color={255,0,255}));
  connect(falEdg.y, staSetCon.uStaChaProEnd) annotation (Line(points={{182,70},
          {190,70},{190,50},{58,50},{58,141.385}},
                                               color={255,0,255}));
  connect(THotWatSupSet.y, staSetCon.THotWatSupSet) annotation (Line(points={{-58,220},
          {-30,220},{-30,174.615},{58,174.615}},  color={0,0,127}));
  connect(THotWatRet.y, staSetCon.THotWatRet) annotation (Line(points={{-58,188},
          {-48,188},{-48,171.846},{58,171.846}},
                                         color={0,0,127}));
  connect(THotWatSup.y, staSetCon.THotWatSup) annotation (Line(points={{-58,140},
          {-40,140},{-40,166.308},{58,166.308}},
                                         color={0,0,127}));
  connect(zero.y, reaRep.u) annotation (Line(points={{-138,120},{-122,120}},
                                 color={0,0,127}));
  connect(reaRep.y, staSetCon.VMinSet_flow) annotation (Line(points={{-98,120},
          {-30,120},{-30,163.538},{58,163.538}},
                                         color={0,0,127}));
  connect(boiAva.y, staSetCon.uBoiAva) annotation (Line(points={{-138,20},{40,
          20},{40,144.154},{58,144.154}},
                              color={255,0,255}));
  connect(VHotWat_flow.y, staSetCon.VHotWat_flow) annotation (Line(points={{-138,
          180},{-100,180},{-100,169.077},{58,169.077}},
                                                color={0,0,127}));
  connect(THotWatRet.y, staSetCon.THotWatRetPri) annotation (Line(points={{-58,188},
          {-48,188},{-48,158},{58,158}}, color={0,0,127}));
  connect(THotWatRetSec.y, staSetCon.THotWatRetSec) annotation (Line(points={{-58,100},
          {-24,100},{-24,155.231},{58,155.231}},
                                              color={0,0,127}));
  connect(uPumSpe.y, staSetCon.uPumSpe) annotation (Line(points={{-58,70},{-16,
          70},{-16,152.462},{58,152.462}},
                               color={0,0,127}));
  connect(staUp.u, staSetCon.yChaUpEdg) annotation (Line(points={{98,190},{90,
          190},{90,162.154},{82,162.154}},
                              color={255,0,255}));
  connect(staDow.u, staSetCon.yChaDowEdg) annotation (Line(points={{98,130},{94,
          130},{94,156.615},{82,156.615}},
                                   color={255,0,255}));
  connect(staSetCon1.ySta, intToRea1.u)
    annotation (Line(points={{82,-75.0769},{94,-75.0769},{94,-82},{98,-82}},
                                                 color={255,127,0}));
  connect(intToRea1.y, zerOrdHol1.u)
    annotation (Line(points={{122,-82},{138,-82}}, color={0,0,127}));
  connect(zerOrdHol1.y, reaToInt1.u)
    annotation (Line(points={{162,-82},{178,-82}}, color={0,0,127}));
  connect(reaToInt1.y, staSetCon1.u) annotation (Line(points={{202,-82},{210,
          -82},{210,-140},{48,-140},{48,-93.0769},{58,-93.0769}},
                                                     color={255,127,0}));
  connect(staSetCon1.yChaEdg, staCha1.u) annotation (Line(points={{82,-80.6154},
          {90,-80.6154},{90,-170},{98,-170}},
                                color={255,0,255}));
  connect(staCha1.y, pre1.u)
    annotation (Line(points={{122,-170},{128,-170}}, color={255,0,255}));
  connect(truDel1.y, staSetCon1.uPla) annotation (Line(points={{-98,-190},{32,
          -190},{32,-90.3077},{58,-90.3077}},
                                color={255,0,255}));
  connect(plaSta1.y, truDel1.u)
    annotation (Line(points={{-138,-190},{-122,-190}}, color={255,0,255}));
  connect(pre1.y, falEdg1.u)
    annotation (Line(points={{152,-170},{158,-170}}, color={255,0,255}));
  connect(falEdg1.y, staSetCon1.uStaChaProEnd) annotation (Line(points={{182,
          -170},{190,-170},{190,-190},{58,-190},{58,-98.6154}},
                                                      color={255,0,255}));
  connect(THotWatSupSet1.y, staSetCon1.THotWatSupSet) annotation (Line(points={{-58,-20},
          {-30,-20},{-30,-65.3846},{58,-65.3846}},color={0,0,127}));
  connect(THotWatRet1.y, staSetCon1.THotWatRet) annotation (Line(points={{-58,-52},
          {-48,-52},{-48,-68.1538},{58,-68.1538}},
                                         color={0,0,127}));
  connect(THotWatSup1.y, staSetCon1.THotWatSup) annotation (Line(points={{-58,
          -100},{-40,-100},{-40,-73.6923},{58,-73.6923}},
                                          color={0,0,127}));
  connect(zero1.y, reaRep1.u)
    annotation (Line(points={{-138,-120},{-122,-120}}, color={0,0,127}));
  connect(reaRep1.y, staSetCon1.VMinSet_flow) annotation (Line(points={{-98,
          -120},{-30,-120},{-30,-76.4615},{58,-76.4615}},
                                          color={0,0,127}));
  connect(boiAva1.y, staSetCon1.uBoiAva) annotation (Line(points={{-138,-220},{
          40,-220},{40,-95.8462},{58,-95.8462}},
                                      color={255,0,255}));
  connect(VHotWat_flow1.y, staSetCon1.VHotWat_flow) annotation (Line(points={{-138,
          -60},{-100,-60},{-100,-70.9231},{58,-70.9231}},
                                                color={0,0,127}));
  connect(THotWatRet1.y, staSetCon1.THotWatRetPri) annotation (Line(points={{-58,-52},
          {-48,-52},{-48,-82},{58,-82}},      color={0,0,127}));
  connect(THotWatRetSec1.y, staSetCon1.THotWatRetSec) annotation (Line(points={{-58,
          -140},{-24,-140},{-24,-84.7692},{58,-84.7692}},
                                                    color={0,0,127}));
  connect(uPumSpe1.y, staSetCon1.uPumSpe) annotation (Line(points={{-58,-170},{
          -16,-170},{-16,-87.5385},{58,-87.5385}},
                                     color={0,0,127}));
  connect(staUp1.u, staSetCon1.yChaUpEdg) annotation (Line(points={{98,-50},{90,
          -50},{90,-77.8462},{82,-77.8462}},
                                   color={255,0,255}));
  connect(staDow1.u, staSetCon1.yChaDowEdg) annotation (Line(points={{98,-110},
          {94,-110},{94,-83.3846},{82,-83.3846}},
                                       color={255,0,255}));
  connect(staSetCon2.ySta, intToRea2.u)
    annotation (Line(points={{482,164.923},{494,164.923},{494,158},{498,158}},
                                                   color={255,127,0}));
  connect(intToRea2.y, zerOrdHol2.u)
    annotation (Line(points={{522,158},{538,158}}, color={0,0,127}));
  connect(zerOrdHol2.y, reaToInt2.u)
    annotation (Line(points={{562,158},{578,158}}, color={0,0,127}));
  connect(reaToInt2.y, staSetCon2.u) annotation (Line(points={{602,158},{610,
          158},{610,100},{448,100},{448,146.923},{458,146.923}},
                                                    color={255,127,0}));
  connect(staSetCon2.yChaEdg, staCha2.u) annotation (Line(points={{482,159.385},
          {490,159.385},{490,70},{498,70}},
                                   color={255,0,255}));
  connect(staCha2.y, pre2.u)
    annotation (Line(points={{522,70},{528,70}}, color={255,0,255}));
  connect(truDel2.y, staSetCon2.uPla) annotation (Line(points={{302,50},{432,50},
          {432,149.692},{458,149.692}},
                                color={255,0,255}));
  connect(plaSta2.y, truDel2.u)
    annotation (Line(points={{262,50},{278,50}}, color={255,0,255}));
  connect(pre2.y, falEdg2.u)
    annotation (Line(points={{552,70},{558,70}}, color={255,0,255}));
  connect(falEdg2.y, staSetCon2.uStaChaProEnd) annotation (Line(points={{582,70},
          {590,70},{590,50},{458,50},{458,141.385}},
                                                 color={255,0,255}));
  connect(THotWatSupSet2.y, staSetCon2.THotWatSupSet) annotation (Line(points={{342,212},
          {370,212},{370,174.615},{458,174.615}},  color={0,0,127}));
  connect(THotWatRet2.y, staSetCon2.THotWatRet) annotation (Line(points={{342,180},
          {352,180},{352,171.846},{458,171.846}},
                                          color={0,0,127}));
  connect(THotWatSup2.y, staSetCon2.THotWatSup) annotation (Line(points={{342,140},
          {360,140},{360,166.308},{458,166.308}},
                                          color={0,0,127}));
  connect(zero2.y, reaRep2.u)
    annotation (Line(points={{262,120},{278,120}}, color={0,0,127}));
  connect(reaRep2.y, staSetCon2.VMinSet_flow) annotation (Line(points={{302,120},
          {370,120},{370,163.538},{458,163.538}},
                                          color={0,0,127}));
  connect(boiAva2.y, staSetCon2.uBoiAva) annotation (Line(points={{262,20},{440,
          20},{440,144.154},{458,144.154}},
                                    color={255,0,255}));
  connect(VHotWat_flow2.y, staSetCon2.VHotWat_flow) annotation (Line(points={{262,180},
          {300,180},{300,169.077},{458,169.077}},
                                               color={0,0,127}));
  connect(staUp2.u, staSetCon2.yChaUpEdg) annotation (Line(points={{498,190},{
          490,190},{490,162.154},{482,162.154}},
                                     color={255,0,255}));
  connect(staDow2.u, staSetCon2.yChaDowEdg) annotation (Line(points={{498,130},
          {494,130},{494,156.615},{482,156.615}},
                                         color={255,0,255}));
  connect(uPumSpe2.y, staSetCon2.uBypValPos) annotation (Line(points={{342,90},
          {380,90},{380,160.769},{458,160.769}},
                                        color={0,0,127}));
annotation (
 experiment(
      StopTime=86400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Validation/SetpointController.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.SetpointController\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.SetpointController</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 2, 2020, by Karthik Devaprasad:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-240},{620,240}})));
end SetpointController;
