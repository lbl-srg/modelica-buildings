within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences;
block Down
  "Generates a stage down signal"

  parameter Boolean primaryOnly = false
    "Is the boiler plant a primary-only, condensing boiler plant?"
    annotation(Dialog(group="Plant type"));

  parameter Integer nSta = 1
    "Number of stages";

  parameter Real fraMinFir = 1.10
    "Fraction of boiler minimum firing ratio that required capacity needs to be
    for minimum firing ratio condition"
    annotation(Dialog(group="Minimum firing rate condition parameters"));

  parameter Real delMinFir(
    final unit="s",
    final displayUnit="s",
    final quantity="Time")= 300
    "Delay for staging based on minimum firing rate of current stage"
    annotation(Dialog(group="Minimum firing rate condition parameters"));

  parameter Real fraDesCap =  0.80
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

  parameter Real sigDif = 0.01
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

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uTyp[nSta]
    "Type vector to identify boiler types in each stage"
    annotation (Placement(transformation(
        extent={{-220,130},{-180,170}},
        rotation=90,
        origin={0,-20}),
      iconTransformation(
        extent={{-140,70},{-100,110}},
        rotation=90)));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCur
    "Current stage index"
    annotation (Placement(transformation(
        extent={{-220,90},{-180,130}},
        rotation=90,
        origin={0,-20}),
      iconTransformation(extent={{-140,50},{-100,90}},
        rotation=90)));

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
      iconTransformation(extent={{-140,50},{-100,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapReq(
    final unit="W",
    final displayUnit="W",
    final quantity="Power")
    "Heating capacity required"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
      iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapMin(
    final unit="W",
    final displayUnit="W",
    final quantity="Power")
    "Minimum firing capacity of current stage"
    annotation (Placement(transformation(extent={{-220,10},{-180,50}}),
      iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapDowDes(
    final unit="W",
    final displayUnit="W",
    final quantity="Power")
    "Design capacity of the next lower available stage"
    annotation (Placement(transformation(extent={{-220,-50},{-180,-10}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPumSpe(
    final unit="1",
    final displayUnit="1") if not primaryOnly
    "Pump speed signal"
    annotation (Placement(transformation(extent={{-220,-100},{-180,-60}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uBypValPos if primaryOnly
    "Bypass valve position"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TPriHotWatRet(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") if not primaryOnly
    "Measured primary hot water return temperature"
    annotation (Placement(transformation(extent={{-220,-140},{-180,-100}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSecHotWatRet(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") if not primaryOnly
    "Measured secondary hot water return temperature"
    annotation (Placement(transformation(extent={{-220,-170},{-180,-130}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yStaDow
    "Stage down signal"
    annotation (Placement(transformation(extent={{180,-10},{200,10}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.FailsafeCondition faiSafCon(
    final delEna=delFaiCon,
    final TDif=TDif,
    final TDifHys=dTemp)
    "Failsafe condition"
    annotation (Placement(transformation(extent={{-160,126},{-140,144}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{-120,124},{-100,144}})));

  Buildings.Controls.OBC.CDL.Continuous.Division div
    "Thermal capacity ratio"
    annotation (Placement(transformation(extent={{-140,34},{-120,54}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=fraMinFir,
    final uHigh=fraMinFir + sigDif)
    "Hysteresis loop"
    annotation (Placement(transformation(extent={{-110,34},{-90,54}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=delMinFir,
    final delayOnInit=true)
    "Enable delay for minimum firing rate condition"
    annotation (Placement(transformation(extent={{-50,34},{-30,54}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2 if primaryOnly
    "Logical Or"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=delBypVal,
    final delayOnInit=true) if primaryOnly
    "Enable delay for bypass valve position condition"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Division div1
    "Thermal capacity ratio"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=fraDesCap,
    final uHigh=fraDesCap + sigDif)
    "Hysteresis loop"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=delDesCapNonConBoi,
    final delayOnInit=true)
    "Enable delay for stage design capacity condition"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));

  Buildings.Controls.OBC.CDL.Logical.And3 and3
    "Logical And"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add4(
    final k2=-1) if not primaryOnly
    "Compare primary and secondary circuit return temperature"
    annotation (Placement(transformation(extent={{-160,-140},{-140,-120}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3(
    final uLow=TCirDif - dTemp,
    final uHigh=TCirDif) if not primaryOnly
    "Hysteresis loop"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(
    final delayTime=delTRetDif,
    final delayOnInit=true) if not primaryOnly
    "Enable delay for return water temperature condition"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 if not primaryOnly
    "Logical And"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1 if not primaryOnly
    "Logical Or"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel4(
    final delayTime=delDesCapConBoi,
    final delayOnInit=true)
    "Enable delay for stage design capacity condition"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi
    "Logical switch"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=true) if not primaryOnly
    "Constant Boolean True source"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(
    final nin=nSta)
    "Identify stage type of next available higher stage"
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nSta]
    "Integer to Real conversion"
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi1 if not primaryOnly
    "Logical switch"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical Not"
    annotation (Placement(transformation(extent={{-80,34},{-60,54}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical Not"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4(
    final uLow=bypValClo,
    final uHigh=bypValClo + sigDif) if primaryOnly
    "Hysteresis loop"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final uLow=0,
    final uHigh=sigDif) if not primaryOnly
    "Hysteresis loop"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Not not4 if not primaryOnly
    "Logical Not"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Real to Integer conversion"
    annotation (Placement(transformation(extent={{-60,-180},{-40,-160}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(
    final threshold=Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types.BoilerTypes.condensingBoiler)
    "Check for non-condensing boilers in stage"
    annotation (Placement(transformation(extent={{-20,-180},{0,-160}})));

equation
  connect(faiSafCon.TSupSet, THotWatSupSet) annotation (Line(points={{-162,139},
          {-170,139},{-170,150},{-200,150}}, color={0,0,127}));
  connect(faiSafCon.TSup, THotWatSup)
    annotation (Line(points={{-162,129},{-170,129},{-170,120},{-200,120}},
                                                     color={0,0,127}));
  connect(div.u2, uCapMin) annotation (Line(points={{-142,38},{-150,38},{-150,30},
          {-200,30}}, color={0,0,127}));
  connect(hys.u, div.y)
    annotation (Line(points={{-112,44},{-118,44}},
                                                 color={0,0,127}));
  connect(or2.u1, truDel.y) annotation (Line(points={{-2,20},{-10,20},{-10,44},{
          -28,44}},  color={255,0,255}));
  connect(truDel1.y, or2.u2) annotation (Line(points={{-58,0},{-20,0},{-20,12},{
          -2,12}},  color={255,0,255}));
  connect(div1.u2, uCapDowDes) annotation (Line(points={{-162,-46},{-172,-46},{-172,
          -30},{-200,-30}}, color={0,0,127}));
  connect(hys1.u, div1.y)
    annotation (Line(points={{-122,-40},{-138,-40}},
                                                   color={0,0,127}));
  connect(and3.y, yStaDow)
    annotation (Line(points={{162,0},{190,0}}, color={255,0,255}));
  connect(and3.u1, not1.y) annotation (Line(points={{138,8},{120,8},{120,134},{-98,
          134}},     color={255,0,255}));
  connect(and3.u2, or2.y) annotation (Line(points={{138,0},{114,0},{114,20},{22,
          20}}, color={255,0,255}));
  connect(add4.u1, TPriHotWatRet) annotation (Line(points={{-162,-124},{-168,
          -124},{-168,-120},{-200,-120}}, color={0,0,127}));
  connect(add4.u2, TSecHotWatRet) annotation (Line(points={{-162,-136},{-168,
          -136},{-168,-150},{-200,-150}}, color={0,0,127}));
  connect(hys3.u, add4.y)
    annotation (Line(points={{-122,-130},{-138,-130}}, color={0,0,127}));
  connect(or1.u1, truDel.y) annotation (Line(points={{-2,-90},{-10,-90},{-10,44},
          {-28,44}}, color={255,0,255}));
  connect(truDel4.y, logSwi.u3) annotation (Line(points={{62,-60},{70,-60},{70,-48},
          {78,-48}}, color={255,0,255}));
  connect(truDel2.y, logSwi.u1)
    annotation (Line(points={{62,-20},{70,-20},{70,-32},{78,-32}},
                                                 color={255,0,255}));
  connect(logSwi.y, and3.u3) annotation (Line(points={{102,-40},{120,-40},{120,-8},
          {138,-8}}, color={255,0,255}));
  connect(intToRea.u, uTyp) annotation (Line(points={{-142,-170},{-150,-170},{-150,
          -220}}, color={255,127,0}));
  connect(intToRea.y, extIndSig.u)
    annotation (Line(points={{-118,-170},{-102,-170}}, color={0,0,127}));
  connect(uCur, extIndSig.index) annotation (Line(points={{-110,-220},{-110,-190},
          {-90,-190},{-90,-182}}, color={255,127,0}));
  connect(con1.y, logSwi1.u1) annotation (Line(points={{102,-70},{112,-70},{112,
          -82},{118,-82}}, color={255,0,255}));
  connect(or1.y, logSwi1.u3) annotation (Line(points={{22,-90},{70,-90},{70,-98},
          {118,-98}}, color={255,0,255}));
  connect(and3.u2, logSwi1.y) annotation (Line(points={{138,0},{114,0},{114,-20},
          {150,-20},{150,-90},{142,-90}}, color={255,0,255}));
  connect(div.u1, uCapReq) annotation (Line(points={{-142,50},{-150,50},{-150,60},
          {-200,60}}, color={0,0,127}));
  connect(div1.u1, uCapReq) annotation (Line(points={{-162,-34},{-166,-34},{-166,
          60},{-200,60}}, color={0,0,127}));
  connect(truDel.u, not2.y)
    annotation (Line(points={{-52,44},{-58,44}}, color={255,0,255}));
  connect(not2.u, hys.y)
    annotation (Line(points={{-82,44},{-88,44}}, color={255,0,255}));
  connect(hys1.y, not3.u)
    annotation (Line(points={{-98,-40},{-82,-40}}, color={255,0,255}));
  connect(not3.y, truDel2.u) annotation (Line(points={{-58,-40},{20,-40},{20,-20},
          {38,-20}}, color={255,0,255}));
  connect(truDel4.u, not3.y) annotation (Line(points={{38,-60},{20,-60},{20,-40},
          {-58,-40}}, color={255,0,255}));
  connect(hys4.u, uBypValPos)
    annotation (Line(points={{-142,0},{-200,0}}, color={0,0,127}));
  connect(hys4.y, truDel1.u)
    annotation (Line(points={{-118,0},{-82,0}}, color={255,0,255}));

  connect(hys2.y, not4.u)
    annotation (Line(points={{-138,-80},{-122,-80}},
                                                   color={255,0,255}));
  connect(extIndSig.y, reaToInt.u)
    annotation (Line(points={{-78,-170},{-62,-170}}, color={0,0,127}));
  connect(intGreThr.u, reaToInt.y)
    annotation (Line(points={{-22,-170},{-38,-170}}, color={255,127,0}));
  connect(intGreThr.y, logSwi.u2) annotation (Line(points={{2,-170},{74,-170},{74,
          -40},{78,-40}}, color={255,0,255}));
  connect(intGreThr.y, logSwi1.u2) annotation (Line(points={{2,-170},{74,-170},{
          74,-90},{118,-90}}, color={255,0,255}));
  connect(faiSafCon.yFaiCon, not1.u)
    annotation (Line(points={{-138,134},{-122,134}}, color={255,0,255}));
  connect(hys2.u, uPumSpe)
    annotation (Line(points={{-162,-80},{-200,-80}}, color={0,0,127}));
  connect(not4.y, and2.u1) annotation (Line(points={{-98,-80},{-90,-80},{-90,-100},
          {-82,-100}}, color={255,0,255}));
  connect(hys3.y, and2.u2) annotation (Line(points={{-98,-130},{-90,-130},{-90,-108},
          {-82,-108}}, color={255,0,255}));
  connect(truDel3.u, and2.y)
    annotation (Line(points={{-42,-100},{-58,-100}}, color={255,0,255}));
  connect(truDel3.y, or1.u2) annotation (Line(points={{-18,-100},{-10,-100},{-10,
          -98},{-2,-98}}, color={255,0,255}));
  annotation(defaultComponentName = "staDow",
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,154},{100,116}},
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
        extent={{-180,-200},{180,180}})),
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
        Primary circuit flow rate <code>VHotWat_flow</code> is at the minimum
        allowed flow rate <code>VMinSet_flow</code> and primary circuit hot
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
