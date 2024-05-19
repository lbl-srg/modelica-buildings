within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Validation;
model Controller
    "Validate boiler water pump control sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Controller
    secPumCon(
    final have_varSecPum=true,
    final have_secFloSen=true,
    final nPum=2,
    final nPumPri=2,
    final nBoi=2,
    final nSen=2,
    final nPum_nominal=2,
    final minPumSpe=0.1,
    final maxPumSpe=1,
    final VHotWat_flow_nominal=0.5,
    final maxLocDp=5*6894.75,
    final minLocDp=5*6894.75,
    final offTimThr=180,
    final timPer=600,
    final staCon=-0.03,
    final relFloHys=0.01,
    final k=1,
    final Ti=10,
    final Td=0.1,
    final speConTyp=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.SecondaryPumpSpeedControlTypes.remoteDP)
    "Testing pump configuration 1"
    annotation (Placement(transformation(extent={{-100,140},{-80,180}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Controller
    secPumCon1(
    final have_varSecPum=true,
    final have_secFloSen=true,
    final nPum=2,
    final nPumPri=2,
    final nBoi=2,
    final nSen=2,
    final nPum_nominal=2,
    final minPumSpe=0.1,
    final maxPumSpe=1,
    final VHotWat_flow_nominal=0.5,
    final maxLocDp=10,
    final minLocDp=5,
    final offTimThr=180,
    final timPer=600,
    final staCon=-0.03,
    final relFloHys=0.01,
    final k=1,
    final Ti=0.5,
    final Td=0.1,
    final speConTyp=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.SecondaryPumpSpeedControlTypes.localDP)
    "Testing pump configuration 2"
    annotation (Placement(transformation(extent={{200,130},{220,170}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Controller
    secPumCon2(
    final have_varSecPum=true,
    final have_secFloSen=false,
    final nPum=2,
    final nPumPri=2,
    final nBoi=2,
    final nSen=2,
    final nPum_nominal=2,
    final minPumSpe=0.1,
    final maxPumSpe=1,
    final VHotWat_flow_nominal=0.5,
    final speLim=0.9,
    final speLim1=0.99,
    final speLim2=0.4,
    final timPer1=300,
    final timPer2=60,
    final timPer3=600,
    final maxLocDp=10,
    final minLocDp=5,
    final offTimThr=180,
    final timPer=600,
    final staCon=-0.03,
    final relFloHys=0.01,
    final k=1,
    final Ti=0.5,
    final Td=0.1,
    final speConTyp=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.SecondaryPumpSpeedControlTypes.remoteDP)
    "Testing pump configuration 3"
    annotation (Placement(transformation(extent={{-100,-30},{-80,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Controller
    secPumCon3(
    final have_varSecPum=true,
    final have_secFloSen=false,
    final nPum=2,
    final nPumPri=2,
    final nBoi=2,
    final nSen=2,
    final nPum_nominal=2,
    final minPumSpe=0.1,
    final maxPumSpe=1,
    final VHotWat_flow_nominal=0.5,
    final speLim=0.9,
    final speLim1=0.99,
    final speLim2=0.4,
    final timPer1=300,
    final timPer2=60,
    final timPer3=600,
    final maxLocDp=10,
    final minLocDp=5,
    final offTimThr=180,
    final timPer=600,
    final staCon=-0.03,
    final relFloHys=0.01,
    final k=1,
    final Ti=0.5,
    final Td=0.1,
    final speConTyp=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.SecondaryPumpSpeedControlTypes.localDP)
    "Testing pump configuration 4"
    annotation (Placement(transformation(extent={{200,-50},{220,-10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Controller
    secPumCon4(
    final have_varSecPum=false,
    final nPum=2,
    final nPumPri=2,
    final nBoi=2,
    final nSen=2,
    final nPum_nominal=2,
    final minPumSpe=0.1,
    final maxPumSpe=1,
    final VHotWat_flow_nominal=0.5,
    final maxLocDp=10,
    final minLocDp=5,
    final offTimThr=180,
    final timPer=600,
    final staCon=-0.03,
    final relFloHys=0.01,
    final k=1,
    final Ti=0.5,
    final Td=0.1) "Testing pump configuration 5"
    annotation (Placement(transformation(extent={{-100,-230},{-80,-190}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=1,
    final period=3600,
    final shift=10)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-260,190},{-240,210}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul(
    final amplitude=2,
    final width=1,
    final period=3500,
    final offset=0,
    final shift=10)
    "Real pulse"
    annotation (Placement(transformation(extent={{-270,150},{-250,170}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-240,150},{-220,170}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=1,
    final period=3600,
    final shift=10)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{50,200},{70,220}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{70,160},{90,180}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul1(
    final amplitude=2,
    final width=1,
    final period=3500,
    final offset=0,
    final shift=0)
    "Real pulse"
    annotation (Placement(transformation(extent={{40,160},{60,180}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.9,
    final period=3600,
    final shift=10)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-260,50},{-240,70}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-220,10},{-200,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul2(
    final amplitude=2,
    final width=1,
    final period=3500,
    final offset=0,
    final shift=10)
    "Real pulse"
    annotation (Placement(transformation(extent={{-260,10},{-240,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
    final width=0.9,
    final period=3600,
    final shift=10)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul3(
    final amplitude=2,
    final width=1,
    final period=3500,
    final offset=0,
    final shift=0)
    "Real pulse"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul4(
    final width=1,
    final period=3600,
    final shift=10)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-240,-180},{-220,-160}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt4
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-220,-220},{-200,-200}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul4(
    final amplitude=2,
    final width=1,
    final period=3500,
    final offset=0,
    final shift=0)
    "Real pulse"
    annotation (Placement(transformation(extent={{-250,-220},{-230,-200}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul5(
    final width=0.5,
    final period=900,
    final shift=60)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-240,-260},{-220,-240}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul5(
    final amplitude=0.6,
    final width=0.5,
    final period=3600,
    final offset=0.35,
    final shift=0)
    "Real pulse"
    annotation (Placement(transformation(extent={{-260,100},{-240,120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul6(
    final amplitude=0.6,
    final width=0.5,
    final period=3600,
    final offset=0.35,
    final shift=0)
    "Real pulse"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul7(
    final amplitude=0.6,
    final width=0.5,
    final period=3600,
    final offset=0.35,
    final shift=0)
    "Real pulse"
    annotation (Placement(transformation(extent={{-260,-110},{-240,-90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul8(
    final amplitude=0.6,
    final width=0.5,
    final period=3600,
    final offset=0.35,
    final shift=0)
    "Real pulse"
    annotation (Placement(transformation(extent={{40,-170},{60,-150}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[2](
    final k={2,1})
    "Pump rotation"
    annotation (Placement(transformation(extent={{-150,200},{-130,220}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1[2](
    final pre_u_start=fill(false, 2))
    "Logical pre block"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin[2](
    final amplitude=fill(0.5, 2),
    final freqHz=fill(1/1800, 2),
    final offset=fill(1, 2))
    "Sine signal"
    annotation (Placement(transformation(extent={{-200,120},{-180,140}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin1(
    final amplitude=0.1,
    final freqHz=1/3600,
    final offset=0.25)
    "Sine signal"
    annotation (Placement(transformation(extent={{-200,150},{-180,170}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1[2](
    final k={2,1})
    "Pump rotation"
    annotation (Placement(transformation(extent={{150,190},{170,210}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2[2](
    final pre_u_start=fill(false, 2))
    "Logical pre block"
    annotation (Placement(transformation(extent={{240,140},{260,160}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin2[2](
    final amplitude=fill(0.5, 2),
    final freqHz=fill(1/1800, 2),
    final offset=fill(1, 2))
    "Sine signal"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin3(
    final amplitude=0.1,
    final freqHz=1/3600,
    final offset=0.25)
    "Sine signal"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin4(
    final amplitude=5,
    final freqHz=1/900,
    final offset=7.5)
    "Sine signal"
    annotation (Placement(transformation(extent={{160,70},{180,90}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2[2](
    final k={2,1})
    "Pump rotation"
    annotation (Placement(transformation(extent={{-150,20},{-130,40}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre3[2](
    final pre_u_start=fill(false, 2))
    "Logical pre block"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3[2](
    final k={2,1})
    "Pump rotation"
    annotation (Placement(transformation(extent={{150,10},{170,30}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre4[2](
    final pre_u_start=fill(false, 2))
    "Logical pre block"
    annotation (Placement(transformation(extent={{240,-40},{260,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4[2](
    final k={2,1})
    "Pump rotation"
    annotation (Placement(transformation(extent={{-150,-170},{-130,-150}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre5[2](
    final pre_u_start=fill(false, 2))
    "Logical pre block"
    annotation (Placement(transformation(extent={{-60,-220},{-40,-200}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(
    final k=1)
    "Constant Real source"
    annotation (Placement(transformation(extent={{-190,200},{-170,220}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con3(
    final k=1)
    "Constant Real source"
    annotation (Placement(transformation(extent={{120,110},{140,130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con4(
    final k=1)
    "Constant Real source"
    annotation (Placement(transformation(extent={{-260,-70},{-240,-50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin6[2](
    final amplitude=fill(0.5, 2),
    final freqHz=fill(1/1800, 2),
    final offset=fill(1, 2))
    "Sine signal"
    annotation (Placement(transformation(extent={{-260,-30},{-240,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin5(
    final amplitude=5,
    final freqHz=1/900,
    final offset=7.5)
    "Sine signal"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin7[2](
    final amplitude=fill(0.5, 2),
    final freqHz=fill(1/1800, 2),
    final offset=fill(1, 2))
    "Sine signal"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con6(
    final k=1)
    "Constant Real source"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));

equation
  connect(conInt.y,secPumCon. uPumLeaLag) annotation (Line(points={{-128,210},{-110,
          210},{-110,178.2},{-102,178.2}},
                                       color={255,127,0}));

  connect(secPumCon.yHotWatPum, pre1.u)
    annotation (Line(points={{-78,160},{-62,160}},   color={255,0,255}));

  connect(sin1.y,secPumCon. VHotWat_flow) annotation (Line(points={{-178,160},{-124,
          160},{-124,162},{-102,162}},                       color={0,0,127}));

  connect(sin.y,secPumCon. dpHotWat_remote) annotation (Line(points={{-178,130},
          {-116,130},{-116,150},{-102,150}}, color={0,0,127}));

  connect(conInt1.y,secPumCon1. uPumLeaLag) annotation (Line(points={{172,200},{
          190,200},{190,168.2},{198,168.2}},
                                         color={255,127,0}));

  connect(secPumCon1.yHotWatPum, pre2.u)
    annotation (Line(points={{222,150},{238,150}}, color={255,0,255}));

  connect(sin3.y,secPumCon1. VHotWat_flow) annotation (Line(points={{62,140},{
          70,140},{70,156},{160,156},{160,152},{198,152}},
                                                         color={0,0,127}));

  connect(sin2.y,secPumCon1. dpHotWat_remote) annotation (Line(points={{102,140},
          {198,140}},                     color={0,0,127}));

  connect(sin4.y,secPumCon1. dpHotWat_local) annotation (Line(points={{182,80},{
          194,80},{194,144},{198,144}},   color={0,0,127}));

  connect(conInt2.y,secPumCon2. uPumLeaLag) annotation (Line(points={{-128,30},
          {-110,30},{-110,8.2},{-102,8.2}},
                                         color={255,127,0}));

  connect(conInt3.y,secPumCon3. uPumLeaLag) annotation (Line(points={{172,20},{190,
          20},{190,-11.8},{198,-11.8}},  color={255,127,0}));

  connect(secPumCon3.yHotWatPum,pre4. u)
    annotation (Line(points={{222,-30},{238,-30}}, color={255,0,255}));

  connect(conInt4.y,secPumCon4. uPumLeaLag) annotation (Line(points={{-128,-160},
          {-110,-160},{-110,-191.8},{-102,-191.8}},
                                         color={255,127,0}));

  connect(secPumCon4.yHotWatPum,pre5. u)
    annotation (Line(points={{-78,-210},{-62,-210}},
                                                   color={255,0,255}));

  connect(con1.y,secPumCon. dpHotWatSet) annotation (Line(points={{-168,210},{-164,
          210},{-164,146},{-102,146}},      color={0,0,127}));

  connect(pre1.y,secPumCon. uHotWatPum) annotation (Line(points={{-38,160},{-30,
          160},{-30,200},{-114,200},{-114,174},{-102,174}},       color={255,0,
          255}));

  connect(pre2.y,secPumCon1. uHotWatPum) annotation (Line(points={{262,150},{270,
          150},{270,220},{120,220},{120,164},{198,164}},     color={255,0,255}));

  connect(con3.y,secPumCon1. dpHotWatSet) annotation (Line(points={{142,120},{170,
          120},{170,136},{198,136}},     color={0,0,127}));

  connect(pre3.y,secPumCon2. uHotWatPum) annotation (Line(points={{-18,-10},{
          -10,-10},{-10,60},{-160,60},{-160,4},{-102,4}},       color={255,0,
          255}));

  connect(pre4.y,secPumCon3. uHotWatPum) annotation (Line(points={{262,-30},{270,
          -30},{270,40},{140,40},{140,-16},{198,-16}},       color={255,0,255}));

  connect(pre5.y,secPumCon4. uHotWatPum) annotation (Line(points={{-38,-210},{
          -30,-210},{-30,-140},{-160,-140},{-160,-196},{-102,-196}},
                                                                 color={255,0,
          255}));

  connect(sin6.y,secPumCon2. dpHotWat_remote) annotation (Line(points={{-238,
          -20},{-102,-20}},                   color={0,0,127}));

  connect(con4.y,secPumCon2. dpHotWatSet) annotation (Line(points={{-238,-60},{
          -140,-60},{-140,-24},{-102,-24}},
                                       color={0,0,127}));

  connect(sin5.y,secPumCon3. dpHotWat_local) annotation (Line(points={{62,-40},
          {150,-40},{150,-36},{198,-36}},
                                       color={0,0,127}));

  connect(sin7.y,secPumCon3. dpHotWat_remote) annotation (Line(points={{62,-80},
          {160,-80},{160,-40},{198,-40}}, color={0,0,127}));

  connect(con6.y,secPumCon3. dpHotWatSet) annotation (Line(points={{62,-120},{
          174,-120},{174,-44},{198,-44}},color={0,0,127}));

  connect(booPul.y,secPumCon. uPlaEna) annotation (Line(points={{-238,200},{-200,
          200},{-200,190},{-120,190},{-120,170},{-102,170}}, color={255,0,255}));

  connect(reaToInt.u, pul.y)
    annotation (Line(points={{-242,160},{-248,160}}, color={0,0,127}));

  connect(reaToInt.y,secPumCon. supResReq) annotation (Line(points={{-218,160},{
          -210,160},{-210,180},{-126,180},{-126,166},{-102,166}},     color={255,
          127,0}));

  connect(booPul1.y,secPumCon1. uPlaEna) annotation (Line(points={{72,210},{140,
          210},{140,160},{198,160}}, color={255,0,255}));

  connect(pul1.y, reaToInt1.u)
    annotation (Line(points={{62,170},{68,170}}, color={0,0,127}));

  connect(reaToInt1.y,secPumCon1. supResReq) annotation (Line(points={{92,170},
          {164,170},{164,156},{198,156}},    color={255,127,0}));

  connect(booPul2.y,secPumCon2. uPlaEna) annotation (Line(points={{-238,60},{
          -164,60},{-164,0},{-102,0}},
                                    color={255,0,255}));

  connect(pul2.y, reaToInt2.u)
    annotation (Line(points={{-238,20},{-222,20}}, color={0,0,127}));

  connect(reaToInt2.y,secPumCon2. supResReq) annotation (Line(points={{-198,20},
          {-168,20},{-168,-4},{-102,-4}},     color={255,127,0}));

  connect(booPul3.y,secPumCon3. uPlaEna) annotation (Line(points={{62,40},{134,40},
          {134,-20},{198,-20}},
                            color={255,0,255}));

  connect(pul3.y, reaToInt3.u)
    annotation (Line(points={{62,0},{78,0}},   color={0,0,127}));

  connect(reaToInt3.y,secPumCon3. supResReq) annotation (Line(points={{102,0},{
          128,0},{128,-24},{198,-24}},color={255,127,0}));

  connect(booPul4.y,secPumCon4. uPlaEna) annotation (Line(points={{-218,-170},{
          -164,-170},{-164,-200},{-102,-200}},
                                          color={255,0,255}));

  connect(pul4.y, reaToInt4.u)
    annotation (Line(points={{-228,-210},{-222,-210}}, color={0,0,127}));

  connect(reaToInt4.y,secPumCon4. supResReq) annotation (Line(points={{-198,
          -210},{-180,-210},{-180,-204},{-102,-204}},
                                                    color={255,127,0}));

  connect(booPul4.y,secPumCon4. uPriPumSta[1]) annotation (Line(points={{-218,
          -170},{-164,-170},{-164,-213},{-102,-213}},
                                                    color={255,0,255}));

  connect(booPul5.y,secPumCon4. uPriPumSta[2]) annotation (Line(points={{-218,
          -250},{-170,-250},{-170,-211},{-102,-211}},
                                                    color={255,0,255}));

  connect(pul5.y,secPumCon. uMaxSecPumSpeCon) annotation (Line(points={{-238,110},
          {-110,110},{-110,142},{-102,142}},      color={0,0,127}));

  connect(pul6.y,secPumCon1. uMaxSecPumSpeCon) annotation (Line(points={{82,100},
          {186,100},{186,132},{198,132}}, color={0,0,127}));

  connect(pul7.y,secPumCon2. uMaxSecPumSpeCon) annotation (Line(points={{-238,
          -100},{-110,-100},{-110,-28},{-102,-28}},
                                                color={0,0,127}));

  connect(pul8.y,secPumCon3. uMaxSecPumSpeCon) annotation (Line(points={{62,-160},
          {190,-160},{190,-48},{198,-48}},     color={0,0,127}));

  connect(secPumCon2.yHotWatPum, pre3.u)
    annotation (Line(points={{-78,-10},{-42,-10}}, color={255,0,255}));
annotation (
  experiment(
      StopTime=3600,
      Interval=0.5,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Pumps/SecondaryPumps/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.SecondaryPumps.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 1, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-300,-300},{300,300}})));
end Controller;
