within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences;
block Down
  "Generates a stage down signal"

  parameter Boolean have_priOnl = false
    "Is the boiler plant primary-only?
    True: The boiler plant is primary-only;
    False: The boiler plant is primary-secondary";

  parameter Boolean have_allNonCon
    "Are all the boilers in the plant non-condensing boilers?";

  parameter Integer nSta = 5
    "Number of stages";

  parameter Real fraMinFir(
    final unit="1",
    displayUnit="1",
    final min=0) = 1.10
    "Fraction of boiler minimum firing ratio that required capacity needs to be
    for minimum firing ratio condition"
    annotation(Dialog(group="Minimum firing rate condition parameters"));

  parameter Real delMinFir(
    final unit="s",
    displayUnit="s",
    final quantity="Time")= 300
    "Delay for staging based on minimum firing rate of current stage"
    annotation(Dialog(group="Minimum firing rate condition parameters"));

  parameter Real fraDesCap(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=1) =  0.80
    "Fraction of design capacity of next lower stage that heating capacity needs
    to be for lower design capacity ratio condition"
    annotation(Dialog(group="Stage design capacity condition parameters"));

  parameter Real delDesCapNonConBoi(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 600
    "Enable delay for lower stage design capacity ratio condition for non-condensing boilers"
    annotation(Evaluate=true,Dialog(enable=not
                                              (have_priOnl), group="Stage design capacity condition parameters"));

  parameter Real delDesCapConBoi(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Enable delay for lower stage design capacity ratio condition for condensing boilers"
    annotation(Dialog(group="Stage design capacity condition parameters"));

  parameter Real sigDif(
    final unit="1",
    displayUnit="1",
    final min=0) = 0.01
    "Hysteresis deadband normalized signals"
    annotation(Dialog(tab="Advanced"));

  parameter Real delBypVal(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Enable delay for bypass valve position condition"
    annotation (
      Evaluate=true,
      Dialog(
        enable=have_priOnl,
        group="Bypass valve condition parameters"));

  parameter Real bypValClo = 0
    "Adjustment for signal received when bypass valve is closed"
    annotation (
      Evaluate=true,
      Dialog(
        enable=have_priOnl,
        tab="Advanced"));

  parameter Real TCirDif(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 3
    "Required return water temperature difference between the primary and
    secondary circuits for staging down"
    annotation (
      Evaluate=true,
      Dialog(
        enable=not
                  (have_priOnl),
        group="Return temperature condition parameters"));

  parameter Real delTRetDif(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Enable delay for measured hot water return temperature difference condition"
    annotation (
      Evaluate=true,
      Dialog(
        enable=not
                  (have_priOnl),
        group="Return temperature condition parameters"));

  parameter Real dTemp(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 0.1
    "Hysteresis deadband for measured temperatures"
    annotation(Dialog(tab="Advanced"));

  parameter Real TDif(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 10
    "Temperature difference for failsafe condition"
    annotation(Dialog(group="Failsafe condition parameters"));

  parameter Real delFaiCon(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 900
    "Enable delay for the failsafe condition"
    annotation(Dialog(group="Failsafe condition parameters"));

  parameter Real boiMinPriPumSpeSta[nSta](
    final unit=fill("1",nSta),
    displayUnit=fill("1",nSta),
    final min=fill(0,nSta),
    final max=fill(1,nSta)) = {0,0,0,0,0}
    "Minimum primary pump speed for the boiler plant stage";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaChaProEnd
    "Signal indicating end of stage change process"
    annotation (Placement(transformation(extent={{-220,70},{-180,110}}),
      iconTransformation(extent={{-140,160},{-100,200}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uTyp[nSta]
    "Type vector to identify boiler types in each stage"
    annotation (Placement(transformation(
        extent={{-220,130},{-180,170}},
        rotation=90,
        origin={80,-20}),
      iconTransformation(extent={{-140,130},{-100,170}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCur
    "Current stage index"
    annotation (Placement(transformation(
        extent={{-220,90},{-180,130}},
        rotation=90,
        origin={80,-20}),
      iconTransformation(extent={{-140,100},{-100,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSupSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Hot water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-220,130},{-180,170}}),
      iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSup(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{-220,100},{-180,140}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapReq(
    final unit="W",
    displayUnit="W",
    final quantity="Power")
    "Heating capacity required"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
      iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapMin(
    final unit="W",
    displayUnit="W",
    final quantity="Power")
    "Minimum firing capacity of current stage"
    annotation (Placement(transformation(extent={{-220,10},{-180,50}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapDowDes(
    final unit="W",
    displayUnit="W",
    final quantity="Power")
    "Design capacity of the next lower available stage"
    annotation (Placement(transformation(extent={{-220,-50},{-180,-10}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPumSpe(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=1) if not have_priOnl and not have_allNonCon
    "Pump speed signal"
    annotation (Placement(transformation(extent={{-220,-80},{-180,-40}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uBypValPos(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=1) if have_priOnl
    "Bypass valve position"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TPriHotWatRet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    if not have_priOnl and not have_allNonCon
    "Measured primary hot water return temperature"
    annotation (Placement(transformation(extent={{-220,-180},{-180,-140}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSecHotWatRet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    if not have_priOnl and not have_allNonCon
    "Measured secondary hot water return temperature"
    annotation (Placement(transformation(extent={{-220,-210},{-180,-170}}),
      iconTransformation(extent={{-140,-170},{-100,-130}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yStaDow
    "Stage down signal"
    annotation (Placement(transformation(extent={{220,-20},{260,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.FailsafeCondition faiSafCon(
    final delEna=delFaiCon,
    final TDif=TDif,
    final TDifHys=dTemp)
    "Failsafe condition"
    annotation (Placement(transformation(extent={{-160,120},{-140,140}})));

protected
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Check failsafe condition and previous stage design capacity for staging down"
    annotation (Placement(transformation(extent={{140,40},{160,60}})));

  Buildings.Controls.OBC.CDL.Logical.And and7
    "Check current stage minimum capacity and one of bypass valve position or pump 
    speed for staging down"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter addParDivZer(
    final p=1e-6)
    "Add small value to input signal to prevent divide by zero"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter addParDivZer1(
    final p=1e-6)
    "Add small value to input signal to prevent divide by zero"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));

  Buildings.Controls.OBC.CDL.Reals.Divide div
    "Thermal capacity ratio"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow=fraMinFir,
    final uHigh=fraMinFir + sigDif)
    "Hysteresis loop"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2 if have_priOnl
    "Logical Or"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));

  Buildings.Controls.OBC.CDL.Reals.Divide div1
    "Thermal capacity ratio"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys1(
    final uLow=fraDesCap,
    final uHigh=fraDesCap + sigDif)
    "Hysteresis loop"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub4
    if not have_priOnl and not have_allNonCon
    "Compare primary and secondary circuit return temperature"
    annotation (Placement(transformation(extent={{-162,-190},{-142,-170}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys3(
    final uLow=TCirDif - dTemp,
    final uHigh=TCirDif) if not have_priOnl and not have_allNonCon
    "Hysteresis loop"
    annotation (Placement(transformation(extent={{-132,-190},{-112,-170}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    if not have_priOnl and not have_allNonCon
    "Logical And"
    annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1
    if not have_priOnl and not have_allNonCon
    "Logical Or"
    annotation (Placement(transformation(extent={{50,-110},{70,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi
    "Logical switch"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=true) if not have_priOnl and have_allNonCon
    "Constant Boolean True source"
    annotation (Placement(transformation(extent={{140,-40},{160,-20}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(
    final nin=nSta)
    "Identify stage type of current stage"
    annotation (Placement(transformation(extent={{-20,-180},{0,-160}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nSta]
    "Integer to Real conversion"
    annotation (Placement(transformation(extent={{-60,-180},{-40,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Or or3
    if not have_priOnl and not have_allNonCon
    "Logical or"
    annotation (Placement(transformation(extent={{140,-110},{160,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical Not"
    annotation (Placement(transformation(extent={{-52,50},{-32,70}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical Not"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys4(
    final uLow=bypValClo,
    final uHigh=bypValClo + sigDif) if have_priOnl
    "Hysteresis loop"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys2(
    final uLow=sigDif,
    final uHigh=2*sigDif) if not have_priOnl and not have_allNonCon
    "Hysteresis loop"
    annotation (Placement(transformation(extent={{-146,-90},{-126,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Not not4
    if not have_priOnl and not have_allNonCon
    "Logical Not"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{20,-180},{40,-160}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(
    final t=Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types.BoilerTypes.condensingBoiler)
    "Check for non-condensing boilers in stage"
    annotation (Placement(transformation(extent={{60,-180},{80,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=delDesCapNonConBoi)
    "Time since condition has been met"
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim1(
    final t=delBypVal) if have_priOnl
    "Time since condition has been met"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim2(
    final t=delTRetDif) if not have_priOnl and not have_allNonCon
    "Time since condition has been met"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim3(
    final t=delMinFir)
    "Time since condition has been met"
    annotation (Placement(transformation(extent={{10,40},{30,60}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig1(
    final nin=nSta) if not have_priOnl and not have_allNonCon
    "Identify stage type of current stage"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2[nSta](
    final k=boiMinPriPumSpeSta) if not have_priOnl and not have_allNonCon
    "Signal source for minimum primary pump speed for boiler plant stage"
    annotation (Placement(transformation(extent={{-170,-140},{-150,-120}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    if not have_priOnl and not have_allNonCon
    "Compare pump speed signal and minimum pump speed for stage"
    annotation (Placement(transformation(extent={{-174,-90},{-154,-70}})));

  Buildings.Controls.OBC.CDL.Logical.And and1
    "Turn on timer when hysteresis turns on and reset it when hysteresis turns
    off or stage change process is completed"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

  Buildings.Controls.OBC.CDL.Logical.And and4 if have_priOnl
    "Turn on timer when hysteresis turns on and reset it when hysteresis turns
    off or stage change process is completed"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Controls.OBC.CDL.Logical.And and5
    "Turn on timer when hysteresis turns on and reset it when hysteresis turns
    off or stage change process is completed"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

  Buildings.Controls.OBC.CDL.Logical.And and6
    if not have_priOnl and not have_allNonCon
    "Turn on timer when hysteresis turns on and reset it when hysteresis turns
    off or stage change process is completed"
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Not not5
    "Logical Not"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim4(
    final t=delDesCapConBoi)
    "Time since condition has been met"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));

equation
  connect(faiSafCon.TSupSet, THotWatSupSet) annotation (Line(points={{-162,135},
          {-170,135},{-170,150},{-200,150}}, color={0,0,127}));
  connect(faiSafCon.TSup, THotWatSup)
    annotation (Line(points={{-162,130},{-170,130},{-170,120},{-200,120}},
                                                     color={0,0,127}));
  connect(hys.u, div.y)
    annotation (Line(points={{-92,60},{-98,60}}, color={0,0,127}));
  connect(hys1.u, div1.y)
    annotation (Line(points={{-92,-40},{-98,-40}}, color={0,0,127}));
  connect(sub4.u1, TPriHotWatRet) annotation (Line(points={{-164,-174},{-170,
          -174},{-170,-160},{-200,-160}}, color={0,0,127}));
  connect(sub4.u2, TSecHotWatRet) annotation (Line(points={{-164,-186},{-170,
          -186},{-170,-190},{-200,-190}}, color={0,0,127}));
  connect(hys3.u,sub4. y)
    annotation (Line(points={{-134,-180},{-140,-180}}, color={0,0,127}));
  connect(intToRea.u, uTyp) annotation (Line(points={{-62,-170},{-70,-170},{-70,
          -220}}, color={255,127,0}));
  connect(intToRea.y, extIndSig.u)
    annotation (Line(points={{-38,-170},{-22,-170}},   color={0,0,127}));
  connect(uCur, extIndSig.index) annotation (Line(points={{-30,-220},{-30,-190},
          {-10,-190},{-10,-182}}, color={255,127,0}));
  connect(div.u1, uCapReq) annotation (Line(points={{-122,66},{-172,66},{-172,
          60},{-200,60}},
                      color={0,0,127}));
  connect(div1.u1, uCapReq) annotation (Line(points={{-122,-34},{-130,-34},{
          -130,14},{-172,14},{-172,60},{-200,60}},
                          color={0,0,127}));
  connect(not2.u, hys.y)
    annotation (Line(points={{-54,60},{-68,60}}, color={255,0,255}));
  connect(hys1.y, not3.u)
    annotation (Line(points={{-68,-40},{-52,-40}}, color={255,0,255}));
  connect(hys4.u, uBypValPos)
    annotation (Line(points={{-92,0},{-200,0}},  color={0,0,127}));
  connect(hys2.y, not4.u)
    annotation (Line(points={{-124,-80},{-122,-80}},
                                                   color={255,0,255}));
  connect(extIndSig.y, reaToInt.u)
    annotation (Line(points={{2,-170},{18,-170}},    color={0,0,127}));
  connect(intGreThr.u, reaToInt.y)
    annotation (Line(points={{58,-170},{42,-170}},   color={255,127,0}));
  connect(intGreThr.y, logSwi.u2) annotation (Line(points={{82,-170},{94,-170},{
          94,-40},{98,-40}},
                          color={255,0,255}));
  connect(intGreThr.y, or3.u2) annotation (Line(points={{82,-170},{94,-170},{94,
          -108},{138,-108}}, color={255,0,255}));
  connect(faiSafCon.yFaiCon, not1.u)
    annotation (Line(points={{-138,130},{-130,130},{-130,130},{-122,130}},
                                                     color={255,0,255}));
  connect(not4.y, and2.u1) annotation (Line(points={{-98,-80},{-96,-80},{-96,-100},
          {-92,-100}}, color={255,0,255}));
  connect(hys3.y, and2.u2) annotation (Line(points={{-110,-180},{-98,-180},{-98,
          -108},{-92,-108}},
                       color={255,0,255}));
  connect(uStaChaProEnd, faiSafCon.uStaChaProEnd) annotation (Line(points={{-200,
          90},{-166,90},{-166,125},{-162,125}}, color={255,0,255}));
  connect(con2.y, extIndSig1.u)
    annotation (Line(points={{-148,-130},{-142,-130}}, color={0,0,127}));
  connect(uCur, extIndSig1.index) annotation (Line(points={{-30,-220},{-30,-190},
          {-80,-190},{-80,-160},{-130,-160},{-130,-142}}, color={255,127,0}));
  connect(hys2.u,sub2. y)
    annotation (Line(points={{-148,-80},{-152,-80}}, color={0,0,127}));
  connect(uPumSpe,sub2. u1) annotation (Line(points={{-200,-60},{-176,-60},{
          -176,-74}},       color={0,0,127}));
  connect(extIndSig1.y,sub2. u2) annotation (Line(points={{-118,-130},{-112,-130},
          {-112,-110},{-178,-110},{-178,-86},{-176,-86}}, color={0,0,127}));
  connect(tim3.u, and1.y)
    annotation (Line(points={{8,50},{2,50}},     color={255,0,255}));
  connect(and1.u1, not2.y)
    annotation (Line(points={{-22,50},{-26,50},{-26,60},{-30,60}},
                                                 color={255,0,255}));
  connect(tim1.u, and4.y)
    annotation (Line(points={{8,0},{2,0}},     color={255,0,255}));
  connect(and5.y, tim.u)
    annotation (Line(points={{2,-30},{38,-30},{38,-20},{48,-20}},
                                                   color={255,0,255}));
  connect(tim2.u, and6.y)
    annotation (Line(points={{-22,-100},{-28,-100}}, color={255,0,255}));
  connect(hys4.y, and4.u1)
    annotation (Line(points={{-68,0},{-22,0}},  color={255,0,255}));
  connect(and2.y, and6.u1)
    annotation (Line(points={{-68,-100},{-52,-100}}, color={255,0,255}));
  connect(not5.u, uStaChaProEnd)
    annotation (Line(points={{-122,90},{-200,90}}, color={255,0,255}));
  connect(not5.y, and1.u2) annotation (Line(points={{-98,90},{-60,90},{-60,42},
          {-22,42}},color={255,0,255}));
  connect(not5.y, and4.u2) annotation (Line(points={{-98,90},{-60,90},{-60,-8},
          {-22,-8}},color={255,0,255}));
  connect(not5.y, and6.u2) annotation (Line(points={{-98,90},{-60,90},{-60,-108},
          {-52,-108}}, color={255,0,255}));

  connect(tim3.passed, or2.u1) annotation (Line(points={{32,42},{40,42},{40,20},
          {58,20}},color={255,0,255}));
  connect(tim3.passed, or1.u1) annotation (Line(points={{32,42},{40,42},{40,
          -100},{48,-100}},
                     color={255,0,255}));
  connect(tim1.passed, or2.u2) annotation (Line(points={{32,-8},{46,-8},{46,12},
          {58,12}},color={255,0,255}));
  connect(and5.y, tim4.u) annotation (Line(points={{2,-30},{38,-30},{38,-60},{
          48,-60}}, color={255,0,255}));
  connect(tim.passed, logSwi.u1) annotation (Line(points={{72,-28},{90,-28},{90,
          -32},{98,-32}}, color={255,0,255}));
  connect(tim4.passed, logSwi.u3) annotation (Line(points={{72,-68},{90,-68},{90,
          -48},{98,-48}}, color={255,0,255}));
  connect(tim2.passed, or1.u2) annotation (Line(points={{2,-108},{48,-108}},
                      color={255,0,255}));
  connect(uCapMin, addParDivZer.u) annotation (Line(points={{-200,30},{-162,30}},
                                color={0,0,127}));
  connect(addParDivZer.y, div.u2) annotation (Line(points={{-138,30},{-130,30},
          {-130,54},{-122,54}},                    color={0,0,127}));
  connect(uCapDowDes, addParDivZer1.u) annotation (Line(points={{-200,-30},{
          -176,-30},{-176,-50},{-162,-50}},
                                       color={0,0,127}));
  connect(addParDivZer1.y, div1.u2) annotation (Line(points={{-138,-50},{-130,
          -50},{-130,-46},{-122,-46}},                  color={0,0,127}));
  connect(and7.y, yStaDow)
    annotation (Line(points={{202,0},{240,0}}, color={255,0,255}));
  connect(or3.y, and7.u2) annotation (Line(points={{162,-100},{170,-100},{170,
          -8},{178,-8}}, color={255,0,255}));
  connect(or2.y, and7.u2) annotation (Line(points={{82,20},{120,20},{120,-8},{
          178,-8}},
                color={255,0,255}));
  connect(and3.y, and7.u1) annotation (Line(points={{162,50},{170,50},{170,0},{178,
          0}}, color={255,0,255}));
  connect(logSwi.y, and3.u2) annotation (Line(points={{122,-40},{130,-40},{130,42},
          {138,42}}, color={255,0,255}));
  connect(not1.y, and3.u1) annotation (Line(points={{-98,130},{130,130},{130,50},
          {138,50}}, color={255,0,255}));
  connect(not5.y, and5.u1) annotation (Line(points={{-98,90},{-60,90},{-60,-8},
          {-26,-8},{-26,-30},{-22,-30}}, color={255,0,255}));
  connect(and5.u2, not3.y) annotation (Line(points={{-22,-38},{-26,-38},{-26,
          -40},{-28,-40}}, color={255,0,255}));
  connect(or1.y, or3.u1)
    annotation (Line(points={{72,-100},{138,-100}}, color={255,0,255}));
  connect(con1.y, and7.u2) annotation (Line(points={{162,-30},{170,-30},{170,-8},
          {178,-8}}, color={255,0,255}));
annotation(defaultComponentName = "staDow",
  Icon(coordinateSystem(extent={{-100,-160},{100,190}}),
      graphics={
        Rectangle(
          extent={{-100,-160},{100,190}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,244},{100,206}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-80,-10},{-20,-22}},
          lineColor={0,0,127}),
        Rectangle(
          extent={{-80,-28},{-20,-40}},
          lineColor={0,0,127}),
        Rectangle(
          extent={{-76,-22},{-72,-28}},
          lineColor={0,0,127}),
        Rectangle(
          extent={{-28,-22},{-24,-28}},
          lineColor={0,0,127}),
        Rectangle(
          extent={{20,-10},{80,-22}},
          lineColor={0,0,127}),
        Rectangle(
          extent={{20,-28},{80,-40}},
          lineColor={0,0,127}),
        Rectangle(
          extent={{24,-22},{28,-28}},
          lineColor={0,0,127}),
        Rectangle(
          extent={{72,-22},{76,-28}},
          lineColor={0,0,127}),
        Rectangle(
          extent={{-80,30},{-20,18}},
          lineColor={0,0,127}),
        Rectangle(
          extent={{-80,12},{-20,0}},
          lineColor={0,0,127}),
        Rectangle(
          extent={{-76,18},{-72,12}},
          lineColor={0,0,127}),
        Rectangle(
          extent={{-28,18},{-24,12}},
          lineColor={0,0,127})}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
        extent={{-180,-200},{220,180}})),
  Documentation(info="<html>
<ol>
<li>
If the current stage <code>uCur</code> has only condensing boilers, the
block outputs a boolean stage down signal <code>yStaDow</code> when all
the following are true:
<ul>
<li>
<ul>
<li>
Required heating capacity <code>uCapReq</code> is lower than <code>fraMinFir</code>
times the minimum firing rate <code>uCapMin</code> of the current stage
for a time period <code>delMinFir</code>, or
</li>
<li>
Primary circuit pump speed <code>uPumSpe</code> is at the minimum
allowed flow rate <code>boiMinPriPumSpeSta</code> and primary circuit hot
water return temperature <code>TPriHotWatRet</code>
exceeds the secondary circuit hot water return temperature <code>TSecHotWatRet</code> by 
<code>TCirDif</code> for a time period <code>delTRetDiff</code>.
</li>
</ul>
</li>
<li>
Failsafe condition is not <code>true</code>.
</li>
<li>
Required heating capacity <code>uCapReq</code> is less than <code>fraDesCap</code>
times the design capacity <code>uCapDowDes</code> of the next available
lower stage for a time period <code>delDesCapConBoi</code>.
</li>
</ul>
</li>
<li>
If the current stage <code>uCur</code> has a non-condensing boiler, the
block outputs a boolean stage down signal <code>yStaDow</code> when all
the following are true:
<ul>
<li>
Failsafe condition is not <code>true</code>.
</li>
<li>
Required heating capacity <code>uCapReq</code> is less than <code>fraDesCap</code>
times the design capacity <code>uCapDowDes</code> of the next available
lower stage for a time period <code>delDesCapNonConBoi</code>.
</li>
</ul>
</li>
<li>
If the plant is a primary-only, condensing type boiler plant,
<code>have_priOnl</code> is set to <code>true</code> and the block
outputs a boolean stage down signal <code>yStaDow</code>
when all the following are true:
<ul>
<li>
<ul>
<li>
Required heating capacity <code>uCapReq</code> is lower than <code>fraMinFir</code>
times the minimum firing rate <code>uCapMin</code> of the current stage
for a time period <code>delMinFir</code>, or
</li>
<li>
The minimum flow bypass valve position <code>uBypValPos</code> is greater
than <code>bypValClo</code>% open for a time period <code>delBypVal</code>.
</li>
</ul>
</li>
<li>
Failsafe condition is not <code>true</code>.
</li>
<li>
Required heating capacity <code>uCapReq</code> is less than <code>fraDesCap</code>
times the design capacity <code>uCapDowDes</code> of the next available
lower stage for a time period <code>delDesCapConBoi</code>.
</li>
</ul>
</li>
</ol>
<p>
The implementation is according to ASHRAE Guideline 36, 2021, section 5.21.3.9.
Timer reset has been implemented according to 5.21.3.9, item b.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 27, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end Down;
