within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences;
block Down
  "Generates a stage down signal"

  parameter Boolean primaryOnly = false
    "Is the boiler plant a primary-only, condensing boiler plant?";

  parameter Integer nSta = 5
    "Number of stages";

  parameter Real fraMinFir(
    final unit="1",
    final displayUnit="1",
    final min=0) = 1.10
    "Fraction of boiler minimum firing ratio that required capacity needs to be
    for minimum firing ratio condition"
    annotation(Dialog(group="Minimum firing rate condition parameters"));

  parameter Real delMinFir(
    final unit="s",
    final displayUnit="s",
    final quantity="Time")= 300
    "Delay for staging based on minimum firing rate of current stage"
    annotation(Dialog(group="Minimum firing rate condition parameters"));

  parameter Real fraDesCap(
    final unit="1",
    final displayUnit="1",
    final min=0,
    final max=1) =  0.80
    "Fraction of design capacity of next lower stage that heating capacity needs
    to be for lower design capacity ratio condition"
    annotation(Dialog(group="Stage design capacity condition parameters"));

  parameter Real delDesCapNonConBoi(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 600
    "Enable delay for lower stage design capacity ratio condition for non-condensing boilers"
    annotation(Evaluate=true,Dialog(enable=not
                                              (primaryOnly), group="Stage design capacity condition parameters"));

  parameter Real delDesCapConBoi(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 300
    "Enable delay for lower stage design capacity ratio condition for condensing boilers"
    annotation(Dialog(group="Stage design capacity condition parameters"));

  parameter Real sigDif(
    final unit="1",
    final displayUnit="1",
    final min=0) = 0.01
    "Hysteresis deadband normalized signals"
    annotation(Dialog(tab="Advanced"));

  parameter Real delBypVal(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 300
    "Enable delay for bypass valve position condition"
    annotation (
      Evaluate=true,
      Dialog(
        enable=primaryOnly,
        group="Bypass valve condition parameters"));

  parameter Real bypValClo = 0
    "Adjustment for signal received when bypass valve is closed"
    annotation (
      Evaluate=true,
      Dialog(
        enable=primaryOnly,
        tab="Advanced"));

  parameter Real TCirDif(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference") = 3
    "Required return water temperature difference between the primary and
    secondary circuits for staging down"
    annotation (
      Evaluate=true,
      Dialog(
        enable=not
                  (primaryOnly),
        group="Return temperature condition parameters"));

  parameter Real delTRetDif(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 300
    "Enable delay for measured hot water return temperature difference condition"
    annotation (
      Evaluate=true,
      Dialog(
        enable=not
                  (primaryOnly),
        group="Return temperature condition parameters"));

  parameter Real dTemp(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference") = 0.1
    "Hysteresis deadband for measured temperatures"
    annotation(Dialog(tab="Advanced"));

  parameter Real TDif(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference") = 10
    "Temperature difference for failsafe condition"
    annotation(Dialog(group="Failsafe condition parameters"));

  parameter Real delFaiCon(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 900
    "Enable delay for the failsafe condition"
    annotation(Dialog(group="Failsafe condition parameters"));

  parameter Real bMinPriPumSpeSta[nSta](
    final unit="1",
    final displayUnit="1",
    final min=0,
    final max=1) = {0,0,0,0,0}
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
    final displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Hot water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-220,130},{-180,170}}),
      iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSup(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{-220,100},{-180,140}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapReq(
    final unit="W",
    final displayUnit="W",
    final quantity="Power")
    "Heating capacity required"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
      iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapMin(
    final unit="W",
    final displayUnit="W",
    final quantity="Power")
    "Minimum firing capacity of current stage"
    annotation (Placement(transformation(extent={{-220,10},{-180,50}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapDowDes(
    final unit="W",
    final displayUnit="W",
    final quantity="Power")
    "Design capacity of the next lower available stage"
    annotation (Placement(transformation(extent={{-220,-50},{-180,-10}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPumSpe(
    final unit="1",
    final displayUnit="1",
    final min=0,
    final max=1) if not primaryOnly
    "Pump speed signal"
    annotation (Placement(transformation(extent={{-220,-80},{-180,-40}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uBypValPos(
    final unit="1",
    final displayUnit="1",
    final min=0,
    final max=1) if primaryOnly
    "Bypass valve position"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TPriHotWatRet(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") if not primaryOnly
    "Measured primary hot water return temperature"
    annotation (Placement(transformation(extent={{-220,-180},{-180,-140}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSecHotWatRet(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") if not primaryOnly
    "Measured secondary hot water return temperature"
    annotation (Placement(transformation(extent={{-220,-210},{-180,-170}}),
      iconTransformation(extent={{-140,-170},{-100,-130}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yStaDow
    "Stage down signal"
    annotation (Placement(transformation(extent={{220,-20},{260,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.FailsafeCondition faiSafCon(
    final delEna=delFaiCon,
    final TDif=TDif,
    final TDifHys=dTemp)
    "Failsafe condition"
    annotation (Placement(transformation(extent={{-160,120},{-140,140}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));

  Buildings.Controls.OBC.CDL.Continuous.Division div
    "Thermal capacity ratio"
    annotation (Placement(transformation(extent={{-150,34},{-130,54}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=fraMinFir,
    final uHigh=fraMinFir + sigDif)
    "Hysteresis loop"
    annotation (Placement(transformation(extent={{-120,34},{-100,54}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2 if primaryOnly
    "Logical Or"
    annotation (Placement(transformation(extent={{60,8},{80,28}})));

  Buildings.Controls.OBC.CDL.Continuous.Division div1
    "Thermal capacity ratio"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=fraDesCap,
    final uHigh=fraDesCap + sigDif)
    "Hysteresis loop"
    annotation (Placement(transformation(extent={{-130,-50},{-110,-30}})));

  Buildings.Controls.OBC.CDL.Logical.And3 and3
    "Logical And"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add4(
    final k2=-1) if not primaryOnly
    "Compare primary and secondary circuit return temperature"
    annotation (Placement(transformation(extent={{-162,-190},{-142,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3(
    final uLow=TCirDif - dTemp,
    final uHigh=TCirDif) if not primaryOnly
    "Hysteresis loop"
    annotation (Placement(transformation(extent={{-132,-190},{-112,-170}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 if not primaryOnly
    "Logical And"
    annotation (Placement(transformation(extent={{-90,-110},{-70,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1 if not primaryOnly
    "Logical Or"
    annotation (Placement(transformation(extent={{60,-108},{80,-88}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi
    "Logical switch"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=true) if not primaryOnly
    "Constant Boolean True source"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(
    final nin=nSta)
    "Identify stage type of current stage"
    annotation (Placement(transformation(extent={{-20,-180},{0,-160}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nSta]
    "Integer to Real conversion"
    annotation (Placement(transformation(extent={{-60,-180},{-40,-160}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi1 if not primaryOnly
    "Logical switch"
    annotation (Placement(transformation(extent={{140,-100},{160,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical Not"
    annotation (Placement(transformation(extent={{-90,34},{-70,54}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical Not"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4(
    final uLow=bypValClo,
    final uHigh=bypValClo + sigDif) if primaryOnly
    "Hysteresis loop"
    annotation (Placement(transformation(extent={{-158,-10},{-138,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final uLow=sigDif,
    final uHigh=2*sigDif) if not primaryOnly
    "Hysteresis loop"
    annotation (Placement(transformation(extent={{-146,-90},{-126,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Not not4 if not primaryOnly
    "Logical Not"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{20,-180},{40,-160}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(
    final threshold=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler)
    "Check for non-condensing boilers in stage"
    annotation (Placement(transformation(extent={{60,-180},{80,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Time since condition has been met"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=delDesCapNonConBoi)
    "Compare time to enable delay"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr1(
    final threshold=delDesCapConBoi)
    "Compare time to enable delay"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim1 if primaryOnly
    "Time since condition has been met"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim2 if not primaryOnly
    "Time since condition has been met"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr2(
    final threshold=delTRetDif) if not primaryOnly
    "Compare time to enable delay"
    annotation (Placement(transformation(extent={{20,-116},{40,-96}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr3(
    final threshold=delBypVal) if primaryOnly
    "Compare time to enable delay"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim3
    "Time since condition has been met"
    annotation (Placement(transformation(extent={{-20,34},{0,54}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr4(
    final threshold=delMinFir)
    "Compare time to enable delay"
    annotation (Placement(transformation(extent={{20,34},{40,54}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig1(
    final nin=nSta) if not primaryOnly
    "Identify stage type of current stage"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2[nSta](
    final k=bMinPriPumSpeSta) if not primaryOnly
    "Signal source for minimum primary pump speed for boiler plant stage"
    annotation (Placement(transformation(extent={{-170,-140},{-150,-120}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k2=-1) if not primaryOnly
    "Compare pump speed signal and minimum pump speed for stage"
    annotation (Placement(transformation(extent={{-174,-90},{-154,-70}})));

  Buildings.Controls.OBC.CDL.Logical.And and1
    "Turn on timer when hysteresis turns on and reset it when hysteresis turns
    off or stage change process is completed"
    annotation (Placement(transformation(extent={{-50,34},{-30,54}})));

  Buildings.Controls.OBC.CDL.Logical.And and4 if primaryOnly
    "Turn on timer when hysteresis turns on and reset it when hysteresis turns
    off or stage change process is completed"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  Buildings.Controls.OBC.CDL.Logical.And and5
    "Turn on timer when hysteresis turns on and reset it when hysteresis turns
    off or stage change process is completed"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));

  Buildings.Controls.OBC.CDL.Logical.And and6 if not primaryOnly
    "Turn on timer when hysteresis turns on and reset it when hysteresis turns
    off or stage change process is completed"
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Not not5
    "Logical Not"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

equation
  connect(faiSafCon.TSupSet, THotWatSupSet) annotation (Line(points={{-162,135},
          {-170,135},{-170,150},{-200,150}}, color={0,0,127}));
  connect(faiSafCon.TSup, THotWatSup)
    annotation (Line(points={{-162,130},{-170,130},{-170,120},{-200,120}},
                                                     color={0,0,127}));
  connect(div.u2, uCapMin) annotation (Line(points={{-152,38},{-160,38},{-160,30},
          {-200,30}}, color={0,0,127}));
  connect(hys.u, div.y)
    annotation (Line(points={{-122,44},{-128,44}},
                                                 color={0,0,127}));
  connect(div1.u2, uCapDowDes) annotation (Line(points={{-162,-46},{-172,-46},{-172,
          -30},{-200,-30}}, color={0,0,127}));
  connect(hys1.u, div1.y)
    annotation (Line(points={{-132,-40},{-138,-40}},
                                                   color={0,0,127}));
  connect(and3.y, yStaDow)
    annotation (Line(points={{202,0},{240,0}}, color={255,0,255}));
  connect(and3.u1, not1.y) annotation (Line(points={{178,8},{150,8},{150,130},{-98,
          130}},     color={255,0,255}));
  connect(and3.u2, or2.y) annotation (Line(points={{178,0},{134,0},{134,18},{82,
          18}}, color={255,0,255}));
  connect(add4.u1, TPriHotWatRet) annotation (Line(points={{-164,-174},{-170,
          -174},{-170,-160},{-200,-160}}, color={0,0,127}));
  connect(add4.u2, TSecHotWatRet) annotation (Line(points={{-164,-186},{-170,
          -186},{-170,-190},{-200,-190}}, color={0,0,127}));
  connect(hys3.u, add4.y)
    annotation (Line(points={{-134,-180},{-140,-180}}, color={0,0,127}));
  connect(logSwi.y, and3.u3) annotation (Line(points={{122,-40},{150,-40},{150,-8},
          {178,-8}}, color={255,0,255}));
  connect(intToRea.u, uTyp) annotation (Line(points={{-62,-170},{-70,-170},{-70,
          -220}}, color={255,127,0}));
  connect(intToRea.y, extIndSig.u)
    annotation (Line(points={{-38,-170},{-22,-170}},   color={0,0,127}));
  connect(uCur, extIndSig.index) annotation (Line(points={{-30,-220},{-30,-190},
          {-10,-190},{-10,-182}}, color={255,127,0}));
  connect(con1.y, logSwi1.u1) annotation (Line(points={{122,-70},{132,-70},{132,
          -82},{138,-82}}, color={255,0,255}));
  connect(or1.y, logSwi1.u3) annotation (Line(points={{82,-98},{138,-98}},
                      color={255,0,255}));
  connect(and3.u2, logSwi1.y) annotation (Line(points={{178,0},{134,0},{134,-20},
          {170,-20},{170,-90},{162,-90}}, color={255,0,255}));
  connect(div.u1, uCapReq) annotation (Line(points={{-152,50},{-160,50},{-160,60},
          {-200,60}}, color={0,0,127}));
  connect(div1.u1, uCapReq) annotation (Line(points={{-162,-34},{-166,-34},{-166,
          60},{-200,60}}, color={0,0,127}));
  connect(not2.u, hys.y)
    annotation (Line(points={{-92,44},{-98,44}}, color={255,0,255}));
  connect(hys1.y, not3.u)
    annotation (Line(points={{-108,-40},{-92,-40}},color={255,0,255}));
  connect(hys4.u, uBypValPos)
    annotation (Line(points={{-160,0},{-200,0}}, color={0,0,127}));
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
  connect(intGreThr.y, logSwi1.u2) annotation (Line(points={{82,-170},{94,-170},
          {94,-90},{138,-90}},color={255,0,255}));
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
  connect(tim.y, greEquThr.u) annotation (Line(points={{2,-40},{50,-40},{50,-20},
          {58,-20}}, color={0,0,127}));
  connect(greEquThr.y, logSwi.u1) annotation (Line(points={{82,-20},{90,-20},{90,
          -32},{98,-32}}, color={255,0,255}));
  connect(greEquThr1.u, tim.y) annotation (Line(points={{58,-60},{50,-60},{50,-40},
          {2,-40}}, color={0,0,127}));
  connect(greEquThr1.y, logSwi.u3) annotation (Line(points={{82,-60},{90,-60},{90,
          -48},{98,-48}}, color={255,0,255}));
  connect(greEquThr2.u, tim2.y) annotation (Line(points={{18,-106},{10,-106},{10,
          -100},{2,-100}}, color={0,0,127}));
  connect(greEquThr2.y, or1.u2)
    annotation (Line(points={{42,-106},{58,-106}}, color={255,0,255}));
  connect(tim1.y, greEquThr3.u)
    annotation (Line(points={{2,0},{18,0}}, color={0,0,127}));
  connect(greEquThr3.y, or2.u2) annotation (Line(points={{42,0},{50,0},{50,10},{
          58,10}}, color={255,0,255}));
  connect(greEquThr4.u, tim3.y)
    annotation (Line(points={{18,44},{2,44}}, color={0,0,127}));
  connect(greEquThr4.y, or2.u1) annotation (Line(points={{42,44},{46,44},{46,18},
          {58,18}}, color={255,0,255}));
  connect(greEquThr4.y, or1.u1) annotation (Line(points={{42,44},{46,44},{46,-98},
          {58,-98}}, color={255,0,255}));
  connect(con2.y, extIndSig1.u)
    annotation (Line(points={{-148,-130},{-142,-130}}, color={0,0,127}));
  connect(uCur, extIndSig1.index) annotation (Line(points={{-30,-220},{-30,-190},
          {-80,-190},{-80,-160},{-130,-160},{-130,-142}}, color={255,127,0}));
  connect(hys2.u, add2.y)
    annotation (Line(points={{-148,-80},{-152,-80}}, color={0,0,127}));
  connect(uPumSpe, add2.u1) annotation (Line(points={{-200,-60},{-176,-60},{
          -176,-74}},       color={0,0,127}));
  connect(extIndSig1.y, add2.u2) annotation (Line(points={{-118,-130},{-112,-130},
          {-112,-110},{-178,-110},{-178,-86},{-176,-86}}, color={0,0,127}));
  connect(tim3.u, and1.y)
    annotation (Line(points={{-22,44},{-28,44}}, color={255,0,255}));
  connect(and1.u1, not2.y)
    annotation (Line(points={{-52,44},{-68,44}}, color={255,0,255}));
  connect(tim1.u, and4.y)
    annotation (Line(points={{-22,0},{-28,0}}, color={255,0,255}));
  connect(and5.y, tim.u)
    annotation (Line(points={{-28,-40},{-22,-40}}, color={255,0,255}));
  connect(tim2.u, and6.y)
    annotation (Line(points={{-22,-100},{-28,-100}}, color={255,0,255}));
  connect(hys4.y, and4.u1)
    annotation (Line(points={{-136,0},{-52,0}}, color={255,0,255}));
  connect(not3.y, and5.u1)
    annotation (Line(points={{-68,-40},{-52,-40}}, color={255,0,255}));
  connect(and2.y, and6.u1)
    annotation (Line(points={{-68,-100},{-52,-100}}, color={255,0,255}));
  connect(not5.u, uStaChaProEnd)
    annotation (Line(points={{-122,90},{-200,90}}, color={255,0,255}));
  connect(not5.y, and1.u2) annotation (Line(points={{-98,90},{-60,90},{-60,36},{
          -52,36}}, color={255,0,255}));
  connect(not5.y, and4.u2) annotation (Line(points={{-98,90},{-60,90},{-60,-8},{
          -52,-8}}, color={255,0,255}));
  connect(not5.y, and5.u2) annotation (Line(points={{-98,90},{-60,90},{-60,-48},
          {-52,-48}}, color={255,0,255}));
  connect(not5.y, and6.u2) annotation (Line(points={{-98,90},{-60,90},{-60,-108},
          {-52,-108}}, color={255,0,255}));

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
          lineColor={0,0,255},
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
      Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-180,-200},{220,180}})),
      Documentation(info="<html>
        <p>
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
        allowed flow rate <code>bMinPriPumSpeSta</code> and primary circuit hot
        water return temperature <code>TPriHotWatRet</code>
        <br>
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
        <br>
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
        <br>
        <li>
        If the plant is a primary-only, condensing type boiler plant,
        <code>primaryOnly</code> is set to <code>true</code> and the block
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
        </p>
        <p>
        The implementation is according to ASHRAE RP1711 March 2020 draft, section 5.3.3.10.
        Timer reset has been implemented according to 5.3.3.10.2.
        </p>
        <p align=\"center\">
        <img alt=\"Validation plot for EfficiencyCondition1\"
        src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/Down1.png\"/>
        <br/>
        Validation plot generated from model <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.Down\">
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.Down</a> for a stage with all condensing boilers.
        </p>
        <p align=\"center\">
        <img alt=\"Validation plot for EfficiencyCondition1\"
        src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/Down2.png\"/>
        <br/>
        Validation plot generated from model <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.Down\">
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.Down</a> for a stage with a non-condensing boiler.
        </p>
        <p align=\"center\">
        <img alt=\"Validation plot for EfficiencyCondition1\"
        src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/Down3.png\"/>
        <br/>
        Validation plot generated from model <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.Down\">
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.Down</a> for a primary-only, condensing-type boiler plant.
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
