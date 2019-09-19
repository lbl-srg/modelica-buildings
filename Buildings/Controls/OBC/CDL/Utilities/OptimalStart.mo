within Buildings.Controls.OBC.CDL.Utilities;
block OptimalStart
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.TemperatureDifference deadband = 0.5
    "Deadband of thermostats";
  parameter Real occupancy[:] = 3600*{8, 18}
    "Occupancy table, each entry switching occupancy on or off";
  parameter Modelica.SIunits.Time maxOptTim = 3600*3
    "Maximum optimal start time";
  parameter Modelica.SIunits.Time minOptTim = 900
    "Minimum optimal start time";
  parameter Modelica.SIunits.Time tOptIni = minOptTim
    "Initial optimal start time";
  parameter Modelica.SIunits.TemperatureSlope temSloHeaIni = 1/3600
    "Initial temperature slope for heating";
  // Modelica.SIunits.TemperatureSlope temSloCoo "Temperature slope for cooling";
  parameter Real n = 3 "Number of days for averaging the temperature slopes";
  Interfaces.RealInput TZon(
    final quantity = "ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=200) "Zone temperature"
    annotation (Placement(transformation(extent={{-340,60},{-300,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Interfaces.RealInput TSetZonHea(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) "Zone setpoint temperature for heating during occupied time"
    annotation (Placement(transformation(extent={{-340,-20},{-300,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealInput TSetZonCoo(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=200) "Zone setpoint temperature for cooling during occupied time"
    annotation (Placement(transformation(extent={{-340,-100},{-300,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Continuous.Sources.ModelTime modTim
    annotation (Placement(transformation(extent={{-240,10},{-220,30}})));
  Continuous.Modulo mod
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  Continuous.Sources.Constant period(k=86400)
    "Period of optimal start calculation algorithm"
    annotation (Placement(transformation(extent={{-240,-30},{-220,-10}})));
  Continuous.Sources.Constant startCal(k=occupancy[1] - maxOptTim)
    annotation (Placement(transformation(extent={{-200,-40},{-180,-20}})));
  Continuous.GreaterEqual greEqu
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Continuous.Hysteresis preHea(uLow=-deadband*0.5, uHigh=deadband*0.5)
    "Comparing zone temperature with heating setpoint"
    annotation (Placement(transformation(extent={{-240,130},{-220,150}})));
  Continuous.Add add(k1=-1, k2=+1)
    annotation (Placement(transformation(extent={{-280,10},{-260,30}})));
  Logical.Latch lat
    "Stop calculation when the zone temperature reaches setpoint"
    annotation (Placement(transformation(extent={{-126,136},{-106,156}})));
  Logical.Timer timHea(reset=true)
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Interfaces.RealOutput tOpt(
    final quantity="Time",
    final unit="s",
    displayUnit="h") "Optimal start time of HVAC system"
    annotation (Placement(transformation(extent={{300,-10},{320,10}}),
                    iconTransformation(extent={{100,-10},{120,10}})));
  Discrete.TriggeredSampler triSam(y_start=minOptTim)
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Logical.FallingEdge falEdg
    "Get the timing when the zone temperature reaches setpoint"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Logical.TrueHoldWithReset truHol(duration(displayUnit="h") = occupancy[2] -
      occupancy[1])
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
  Continuous.Add add1(k1=-1, k2=+1)
    annotation (Placement(transformation(extent={{-280,-40},{-260,-20}})));
  Continuous.LessEqual lesEqu
    annotation (Placement(transformation(extent={{-126,20},{-106,40}})));
  Continuous.Sources.Constant stopCal(k=occupancy[1])
    annotation (Placement(transformation(extent={{-200,26},{-180,46}})));
  Logical.Latch latHea "Stop calculation when it reaches the max start time"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
  Continuous.Hysteresis preCoo(
    uLow=-deadband*0.5,
    uHigh=deadband*0.5,
    pre_y_start=false) "Comparing zone temperature with cooling setpoint"
    annotation (Placement(transformation(extent={{-240,-150},{-220,-130}})));
  Discrete.TriggeredSampler triSam1
    annotation (Placement(transformation(extent={{120,50},{140,70}})));
  Discrete.TriggeredSampler triSam2
    annotation (Placement(transformation(extent={{120,-30},{140,-10}})));
  Continuous.Sources.Constant maxStaTim(k=maxOptTim)
    annotation (Placement(transformation(extent={{220,10},{240,30}})));
  Continuous.Max max
    annotation (Placement(transformation(extent={{222,-30},{242,-10}})));
  Continuous.Min min
    annotation (Placement(transformation(extent={{264,-10},{284,10}})));
  Discrete.MovingMean movMea(n=n, samplePeriod=86400)
    annotation (Placement(transformation(extent={{226,120},{246,140}})));
  Interfaces.BooleanOutput Warmup "Warm-up mode" annotation (Placement(
        transformation(extent={{300,-50},{320,-30}}), iconTransformation(extent=
           {{100,-50},{120,-30}})));
  Interfaces.BooleanOutput Cooldown "Cooldown mode" annotation (Placement(
        transformation(extent={{300,-90},{320,-70}}), iconTransformation(extent=
           {{100,-90},{120,-70}})));
  Logical.Latch lat2
    "Stop calculation when the zone temperature reaches setpoint"
    annotation (Placement(transformation(extent={{-126,-144},{-106,-124}})));
  Logical.Latch latCoo "Stop calculation when it reaches the max start time"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Logical.TrueHoldWithReset truHol1(duration(displayUnit="h") = occupancy[2] -
      occupancy[1])
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Logical.Timer timCoo(reset=true)
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  Discrete.TriggeredSampler triSam3(y_start=minOptTim)
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Discrete.MovingMean movMea1(n=n, samplePeriod=86400)
    annotation (Placement(transformation(extent={{180,-140},{200,-120}})));
  Logical.FallingEdge falEdg1
    "Get the timing when the zone temperature reaches setpoint"
    annotation (Placement(transformation(extent={{-20,-170},{0,-150}})));
  Logical.Not not1
    annotation (Placement(transformation(extent={{-200,130},{-180,150}})));
  Continuous.Division temSloHea "Calculate temperature slope for heating"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));
  Continuous.Division tOptCoo "Calculate optimal start time for heating"
    annotation (Placement(transformation(extent={{220,-140},{240,-120}})));
  Continuous.Division tOptHea "Calculate optimal start time for heating"
    annotation (Placement(transformation(extent={{266,120},{286,140}})));
  Continuous.Sources.Constant tOptMin1(k=minOptTim)
                                                   "Minimum optimal start time"
    annotation (Placement(transformation(extent={{72,-110},{92,-90}})));
  Logical.Switch swi1
    annotation (Placement(transformation(extent={{108,-142},{128,-122}})));
  Continuous.Division temSloCoo "Calculate temperature slope for cooling"
    annotation (Placement(transformation(extent={{144,-140},{164,-120}})));
  Discrete.TriggeredSampler triSam4(y_start=temSloHeaIni)
    annotation (Placement(transformation(extent={{116,120},{136,140}})));
  Continuous.LessEqual lesEqu1
    annotation (Placement(transformation(extent={{162,120},{182,140}})));
  Continuous.Sources.Constant casCoo(k=0)
    annotation (Placement(transformation(extent={{106,150},{126,170}})));
  Logical.Switch swi2
    annotation (Placement(transformation(extent={{196,120},{216,140}})));
  Continuous.Sources.Constant temSloHeaDef(k=temSloHeaIni)
    annotation (Placement(transformation(extent={{156,154},{176,174}})));
equation
  connect(mod.y, greEqu.u1) annotation (Line(points={{-179,0.2},{-169.5,0.2},{
          -169.5,0},{-162,0}},
                         color={0,0,127}));
  connect(add.y, preHea.u)
    annotation (Line(points={{-259,20},{-254,20},{-254,140},{-242,140}},
                                                   color={0,0,127}));
  connect(startCal.y, greEqu.u2) annotation (Line(points={{-179,-30},{-168,-30},
          {-168,-8},{-162,-8}}, color={0,0,127}));
  connect(period.y, mod.u2) annotation (Line(points={{-219,-20},{-210,-20},{
          -210,-6},{-202,-6}},
                      color={0,0,127}));
  connect(modTim.y, mod.u1) annotation (Line(points={{-219,20},{-210,20},{-210,
          6},{-202,6}},     color={0,0,127}));
  connect(TSetZonHea, add.u2) annotation (Line(points={{-320,0},{-294,0},{-294,
          14},{-282,14}}, color={0,0,127}));
  connect(TZon, add.u1) annotation (Line(points={{-320,80},{-294,80},{-294,26},
          {-282,26}}, color={0,0,127}));
  connect(timHea.y, triSam.u)
    annotation (Line(points={{21,130},{38,130}}, color={0,0,127}));
  connect(greEqu.y, lat.u) annotation (Line(points={{-139,0},{-134,0},{-134,146},
          {-127,146}},    color={255,0,255}));
  connect(falEdg.y, triSam.trigger)
    annotation (Line(points={{1,100},{50,100},{50,118.2}}, color={255,0,255}));
  connect(timHea.u, truHol.y)
    annotation (Line(points={{-2,130},{-19,130}}, color={255,0,255}));
  connect(lesEqu.y, latHea.clr) annotation (Line(points={{-105,30},{-96,30},{
          -96,124},{-81,124}},
                           color={255,0,255}));
  connect(lat.y, latHea.u) annotation (Line(points={{-105,146},{-96,146},{-96,
          130},{-81,130}},
                      color={255,0,255}));
  connect(mod.y, lesEqu.u2) annotation (Line(points={{-179,0.2},{-172,0.2},{
          -172,22},{-128,22}},    color={0,0,127}));
  connect(stopCal.y, lesEqu.u1) annotation (Line(points={{-179,36},{-140,36},{
          -140,30},{-128,30}},    color={0,0,127}));
  connect(latHea.y, truHol.u)
    annotation (Line(points={{-59,130},{-41,130}}, color={255,0,255}));
  connect(latHea.y, falEdg.u) annotation (Line(points={{-59,130},{-50,130},{-50,
          100},{-22,100}}, color={255,0,255}));
  connect(add1.y, preCoo.u)
    annotation (Line(points={{-259,-30},{-254,-30},{-254,-140},{-242,-140}},
                                                     color={0,0,127}));
  connect(TSetZonCoo, add1.u2) annotation (Line(points={{-320,-80},{-288,-80},{-288,
          -36},{-282,-36}},      color={0,0,127}));
  connect(TZon, add1.u1) annotation (Line(points={{-320,80},{-294,80},{-294,26},
          {-288,26},{-288,-24},{-282,-24}}, color={0,0,127}));
  connect(greEqu.y, triSam1.trigger) annotation (Line(points={{-139,0},{130,0},{
          130,48.2}},                               color={255,0,255}));
  connect(triSam2.y, max.u2) annotation (Line(points={{141,-20},{176,-20},{176,
          -26},{220,-26}},       color={0,0,127}));
  connect(triSam1.y, max.u1) annotation (Line(points={{141,60},{176,60},{176,-14},
          {220,-14}},            color={0,0,127}));
  connect(maxStaTim.y, min.u1) annotation (Line(points={{241,20},{252,20},{252,
          6},{262,6}},         color={0,0,127}));
  connect(max.y, min.u2) annotation (Line(points={{243,-20},{252,-20},{252,-6},
          {262,-6}},  color={0,0,127}));
  connect(min.y, tOpt) annotation (Line(points={{285,0},{310,0}},
                   color={0,0,127}));
  connect(greEqu.y, lat2.u) annotation (Line(points={{-139,0},{-134,0},{-134,
          -134},{-127,-134}},
                            color={255,0,255}));
  connect(latCoo.y, truHol1.u) annotation (Line(points={{-59,-140},{-50,-140},{-50,
          -130},{-41,-130}}, color={255,0,255}));
  connect(truHol1.y, timCoo.u)
    annotation (Line(points={{-19,-130},{-2,-130}}, color={255,0,255}));
  connect(timCoo.y, triSam3.u)
    annotation (Line(points={{21,-130},{38,-130}}, color={0,0,127}));
  connect(latCoo.y, falEdg1.u) annotation (Line(points={{-59,-140},{-50,-140},{-50,
          -160},{-22,-160}}, color={255,0,255}));
  connect(falEdg1.y, triSam3.trigger) annotation (Line(points={{1,-160},{50,-160},
          {50,-141.8}}, color={255,0,255}));
  connect(lesEqu.y, latCoo.clr) annotation (Line(points={{-105,30},{-96,30},{
          -96,-146},{-81,-146}},
                             color={255,0,255}));
  connect(lat2.y, latCoo.u) annotation (Line(points={{-105,-134},{-92,-134},{
          -92,-140},{-81,-140}},
                       color={255,0,255}));
  connect(preHea.y, not1.u)
    annotation (Line(points={{-219,140},{-202,140}},
                                                   color={255,0,255}));
  connect(not1.y, lat.clr) annotation (Line(points={{-179,140},{-127,140}},
                      color={255,0,255}));
  connect(latHea.y, Warmup) annotation (Line(points={{-59,130},{-50,130},{-50,
          -40},{310,-40}}, color={255,0,255}));
  connect(latCoo.y, Cooldown) annotation (Line(points={{-59,-140},{-50,-140},{
          -50,-180},{280,-180},{280,-80},{310,-80}}, color={255,0,255}));
  connect(add.y, temSloHea.u1) annotation (Line(points={{-259,20},{-254,20},{-254,
          180},{66,180},{66,136},{78,136}},         color={0,0,127}));
  connect(tOptCoo.u1, add1.y) annotation (Line(points={{218,-124},{210,-124},{210,
          -186},{-254,-186},{-254,-30},{-259,-30}}, color={0,0,127}));
  connect(greEqu.y, triSam2.trigger) annotation (Line(points={{-139,0},{-60,0},
          {-60,-48},{130,-48},{130,-31.8}},color={255,0,255}));
  connect(add.y, tOptHea.u1) annotation (Line(points={{-259,20},{-254,20},{-254,
          180},{256,180},{256,136},{264,136}}, color={0,0,127}));
  connect(movMea.y, tOptHea.u2) annotation (Line(points={{247,130},{254,130},{254,
          124},{264,124}}, color={0,0,127}));
  connect(triSam2.u, tOptCoo.y) annotation (Line(points={{118,-20},{100,-20},{100,
          -60},{260,-60},{260,-130},{241,-130}}, color={0,0,127}));
  connect(tOptHea.y, triSam1.u) annotation (Line(points={{287,130},{294,130},{294,
          80},{104,80},{104,60},{118,60}},
                                         color={0,0,127}));
  connect(movMea1.y, tOptCoo.u2) annotation (Line(points={{201,-130},{208,-130},
          {208,-136},{218,-136}}, color={0,0,127}));
  connect(tOptMin1.y, swi1.u1) annotation (Line(points={{93,-100},{98,-100},{98,
          -124},{106,-124}}, color={0,0,127}));
  connect(swi1.u2, Cooldown) annotation (Line(points={{106,-132},{82,-132},{82,
          -180},{280,-180},{280,-80},{310,-80}}, color={255,0,255}));
  connect(triSam3.y, swi1.u3) annotation (Line(points={{61,-130},{70,-130},{70,
          -140},{106,-140}}, color={0,0,127}));
  connect(temSloCoo.y, movMea1.u)
    annotation (Line(points={{165,-130},{178,-130}}, color={0,0,127}));
  connect(temSloCoo.u1, add1.y) annotation (Line(points={{142,-124},{134,-124},{
          134,-186},{-254,-186},{-254,-30},{-259,-30}}, color={0,0,127}));
  connect(swi1.y, temSloCoo.u2) annotation (Line(points={{129,-132},{136,-132},{
          136,-136},{142,-136}}, color={0,0,127}));
  connect(triSam.y, temSloHea.u2) annotation (Line(points={{61,130},{68,130},{68,
          124},{78,124}}, color={0,0,127}));
  connect(preCoo.y, lat2.clr) annotation (Line(points={{-219,-140},{-173.5,-140},
          {-173.5,-140},{-127,-140}}, color={255,0,255}));
  connect(temSloHea.y, triSam4.u)
    annotation (Line(points={{101,130},{114,130}}, color={0,0,127}));
  connect(triSam4.trigger, triSam1.trigger) annotation (Line(points={{126,118.2},
          {126,100},{64,100},{64,0},{130,0},{130,48.2}}, color={255,0,255}));
  connect(triSam4.y, lesEqu1.u1)
    annotation (Line(points={{137,130},{160,130}}, color={0,0,127}));
  connect(casCoo.y, lesEqu1.u2) annotation (Line(points={{127,160},{152,160},{152,
          122},{160,122}}, color={0,0,127}));
  connect(lesEqu1.y, swi2.u2)
    annotation (Line(points={{183,130},{194,130}}, color={255,0,255}));
  connect(swi2.y, movMea.u)
    annotation (Line(points={{217,130},{224,130}}, color={0,0,127}));
  connect(temSloHeaDef.y, swi2.u1) annotation (Line(points={{177,164},{184,164},
          {184,138},{194,138}}, color={0,0,127}));
  connect(triSam4.y, swi2.u3) annotation (Line(points={{137,130},{144,130},{144,
          102},{188,102},{188,122},{194,122}}, color={0,0,127}));
  annotation (            Diagram(coordinateSystem(extent={{-300,-200},{300,200}}),
        graphics={
        Rectangle(
          extent={{-94,170},{168,86}},
          lineColor={175,175,175},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-14,166},{32,160}},
          lineColor={244,125,35},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Heating mode"),
        Rectangle(
          extent={{-94,-100},{168,-194}},
          lineColor={175,175,175},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{24,-102},{68,-108}},
          lineColor={244,125,35},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Cooling mode")}));
end OptimalStart;
