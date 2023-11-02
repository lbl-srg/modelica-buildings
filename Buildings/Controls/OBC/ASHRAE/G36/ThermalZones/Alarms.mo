within Buildings.Controls.OBC.ASHRAE.G36.ThermalZones;
block Alarms "Zone level alarms"

  parameter Real timChe(
    final unit="s",
    final quantity="Time")=600
    "Threshold time to check temperature difference"
    annotation (__cdl(ValueInReference=true));
  parameter Boolean have_CO2Sen=false
    "True: the zone has CO2 sensor"
    annotation (__cdl(ValueInReference=false), Dialog(group="CO2 concentration alarm"));
  parameter Real modChe(
    final unit="s",
    final quantity="Time")=7200
    "Threshold time to check unoccupied time"
    annotation (__cdl(ValueInReference=true),
                Dialog(group="CO2 concentration alarm", enable=have_CO2Sen));
  parameter Real CO2Set=894
    "CO2 setpoint in ppm"
    annotation (__cdl(ValueInReference=true), Dialog(group="CO2 concentration alarm", enable=have_CO2Sen));
  parameter Real dTHys(
    final unit="K",
    final quantity="TemperatureDifference")=0.25
    "Delta between the temperature hysteresis high and low limit"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real ppmHys(
    final unit="1")=25
    "Hysteresis to check CO2 concentration"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced", enable=have_CO2Sen));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Measured zone temperature"
    annotation (Placement(transformation(extent={{-240,200},{-200,240}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Zone cooling setpoint"
    annotation (Placement(transformation(extent={{-240,160},{-200,200}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Zone heating setpoint"
    annotation (Placement(transformation(extent={{-240,86},{-200,126}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ResSet
    "True: zone setpoint temperature is being resetted"
    annotation (Placement(transformation(extent={{-240,0},{-200,40}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-240,-60},{-200,-20}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2(
    final unit="1") if have_CO2Sen
    "Measured CO2 concentration"
    annotation (Placement(transformation(extent={{-240,-180},{-200,-140}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yTemAla
    "Zone temperature alarm"
    annotation (Placement(transformation(extent={{240,120},{280,160}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yCO2Ala if have_CO2Sen
    "CO2 concentration alarm"
    annotation (Placement(transformation(extent={{240,-200},{280,-160}}),
        iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract lowTem
    "Zone temperature below the heating setpoint"
    annotation (Placement(transformation(extent={{-170,90},{-150,110}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold twoDegLow(
    final t=2,
    final h=dTHys)
    "Check if the zone temperature is 2 degC lower than the heating setpoint"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold thrDegLow(
    final t=3,
    final h=dTHys)
    "Check if the zone temperature is 3 degC lower than the heating setpoint"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract higTem
    "Zone temperature above the cooling setpoint"
    annotation (Placement(transformation(extent={{-170,210},{-150,230}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold twoDegHig(
    final t=2,
    final h=dTHys)
    "Check if the zone temperature is 2 degC higher than the cooling setpoint"
    annotation (Placement(transformation(extent={{-120,210},{-100,230}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold thrDegHig(
    final t=3,
    final h=dTHys)
    "Check if the zone temperature is 3 degC higher than the cooling setpoint"
    annotation (Placement(transformation(extent={{-120,170},{-100,190}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert higTemAla3(
    final message="Warning: zone temperature is 2 degC higher than the cooling setpoint")
    "Level 3 high temperature alarm"
    annotation (Placement(transformation(extent={{200,210},{220,230}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{160,210},{180,230}})));
  Buildings.Controls.OBC.CDL.Logical.Not notSupTemAla
    "Do not suppress temperature alarms"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if alarms should be generated"
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Check if alarms should be generated"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Check if alarms should be generated"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Check if alarms should be generated"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(
    final integerTrue=3)
    "Level 3 high temperature alarm"
    annotation (Placement(transformation(extent={{0,210},{20,230}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2(
    final integerTrue=3)
    "Level 3 low temperature alarm"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Integers.Equal levThrHig
    "Check if generating level 3 high temperature alarm"
    annotation (Placement(transformation(extent={{120,210},{140,230}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant levTwo(
    final k=2) "Level 2 alarm"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant levThr(
    final k=3) "Level 3 alarm"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert higTemAla2(
    final message="Warning: zone temperature is 3 degC higher than the cooling setpoint")
    "Level 2 high temperature alarm"
    annotation (Placement(transformation(extent={{200,170},{220,190}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{160,170},{180,190}})));
  Buildings.Controls.OBC.CDL.Integers.Equal levTwoHig
    "Check if generating level 2 high temperature alarm"
    annotation (Placement(transformation(extent={{120,170},{140,190}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert lowTemAla3(
    final message="Warning: zone temperature is 2 degC lower than the heating setpoint")
    "Level 3 low temperature alarm"
    annotation (Placement(transformation(extent={{200,90},{220,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{160,90},{180,110}})));
  Buildings.Controls.OBC.CDL.Integers.Equal levThrLow
    "Check if generating level 3 low temperature alarm"
    annotation (Placement(transformation(extent={{120,90},{140,110}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert lowTemAla2(
    final message="Warning: zone temperature is 3 degC lower than the heating setpoint")
    "Level 2 low temperature alarm"
    annotation (Placement(transformation(extent={{200,50},{220,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Logical not"
    annotation (Placement(transformation(extent={{160,50},{180,70}})));
  Buildings.Controls.OBC.CDL.Integers.Equal levTwoLow
    "Check if generating level 2 low temperature alarm"
    annotation (Placement(transformation(extent={{120,50},{140,70}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final t=300,
    final h=ppmHys) if have_CO2Sen
    "Check if the CO2 concentration is less than threshold"
    annotation (Placement(transformation(extent={{-40,-190},{-20,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=600,
    final h=ppmHys) if have_CO2Sen
    "Check if the CO2 concentration is greater than threshold"
    annotation (Placement(transformation(extent={{-120,-170},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Logical.And and5 if have_CO2Sen
    "Check if it has been in unoccupied mode for long time and CO2 concentration exceeds threshold"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert lowTemAla4(
    final message="Warning: the zone CO2 concentration exceeds 600 ppm in unoccupied mode. The CO2 sensor may be out of calibration.")
    if have_CO2Sen "Level 3 CO2 alarm"
    annotation (Placement(transformation(extent={{200,-130},{220,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5 if have_CO2Sen "Logical not"
    annotation (Placement(transformation(extent={{160,-130},{180,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final t=1.1*CO2Set,
    final h=ppmHys) if have_CO2Sen
    "Check if the CO2 concentration exceeds setpoint plus 10%"
    annotation (Placement(transformation(extent={{-120,-230},{-100,-210}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt4(
    final integerTrue=3) if have_CO2Sen
    "Level 3 CO2 concentration alarm"
    annotation (Placement(transformation(extent={{80,-170},{100,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not6 if have_CO2Sen "Logical not"
    annotation (Placement(transformation(extent={{0,-230},{20,-210}})));
  Buildings.Controls.OBC.CDL.Logical.And and6 if have_CO2Sen
    "Check if it has been in unoccupied mode for long time and CO2 concentration exceeds threshold"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt5(
    final integerTrue=2) if have_CO2Sen
    "Level 2 CO2 concentration alarm"
    annotation (Placement(transformation(extent={{80,-210},{100,-190}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert lowTemAla5(
    final message="Warning: the zone CO2 concentration exceeds setpoint plus 10%.")
    if have_CO2Sen "Level 2 CO2 alarm"
    annotation (Placement(transformation(extent={{200,-230},{220,-210}})));
  Buildings.Controls.OBC.CDL.Integers.Add temAla
    "Zone temperature alarm"
    annotation (Placement(transformation(extent={{140,130},{160,150}})));
  Buildings.Controls.OBC.CDL.Integers.Add co2Ala if have_CO2Sen
    "CO2 concentration alarm"
    annotation (Placement(transformation(extent={{140,-190},{160,-170}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tenMinDur(
    final delayTime=timChe)
    "Check if it has been over threshold time"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tenMinDur1(
    final delayTime=timChe)
    "Check if it has been over threshold time"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tenMinDur2(
    final delayTime=timChe)
    "Check if it has been over threshold time"
    annotation (Placement(transformation(extent={{-40,210},{-20,230}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tenMinDur3(
    final delayTime=timChe)
    "Check if it has been over threshold time"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cooDowMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.coolDown)
    "Cool down mode"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant warUpMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.warmUp)
    "Warm-up mode"
    annotation (Placement(transformation(extent={{-180,-70},{-160,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3
    "Check if current operation mode is setback mode"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu4
    "Check if current operation mode is warmup mode"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Cooldown or warm-up mode"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Check if the zone temperature alarms should be suppressed"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1 if have_CO2Sen
    "Check if current operation mode is warmup mode"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant unoMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    if have_CO2Sen "Unoccupied mode"
    annotation (Placement(transformation(extent={{-180,-130},{-160,-110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay twoHou(
    final delayTime=modChe) if have_CO2Sen
    "Check if it has been in unoccupied mode by threshold time"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Or or3 if have_CO2Sen
    "Check if should generate level 3 alarm"
    annotation (Placement(transformation(extent={{0,-130},{20,-110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay tenMinDur4(
    final delayTime=timChe) if have_CO2Sen
    "Check if it has been over threshold time"
    annotation (Placement(transformation(extent={{-80,-230},{-60,-210}})));
  Buildings.Controls.OBC.CDL.Integers.Switch higTemAla
    "High temperature alarms"
    annotation (Placement(transformation(extent={{60,170},{80,190}})));
  Buildings.Controls.OBC.CDL.Integers.Switch lowTemAla
    "Low temperature alarms"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

equation
  connect(lowTem.y, twoDegLow.u)
    annotation (Line(points={{-148,100},{-122,100}}, color={0,0,127}));
  connect(lowTem.y, thrDegLow.u) annotation (Line(points={{-148,100},{-140,100},
          {-140,60},{-122,60}}, color={0,0,127}));
  connect(higTem.y, twoDegHig.u)
    annotation (Line(points={{-148,220},{-122,220}}, color={0,0,127}));
  connect(higTem.y, thrDegHig.u) annotation (Line(points={{-148,220},{-140,220},
          {-140,180},{-122,180}}, color={0,0,127}));
  connect(TZon, higTem.u1)
    annotation (Line(points={{-220,220},{-180,220},{-180,226},{-172,226}}, color={0,0,127}));
  connect(TCooSet, higTem.u2) annotation (Line(points={{-220,180},{-190,180},{-190,
          214},{-172,214}}, color={0,0,127}));
  connect(THeaSet, lowTem.u1)
    annotation (Line(points={{-220,106},{-172,106}}, color={0,0,127}));
  connect(cooDowMod.y, intEqu3.u1)
    annotation (Line(points={{-158,-20},{-122,-20}}, color={255,127,0}));
  connect(warUpMod.y, intEqu4.u1)
    annotation (Line(points={{-158,-60},{-122,-60}}, color={255,127,0}));
  connect(uOpeMod, intEqu3.u2) annotation (Line(points={{-220,-40},{-140,-40},{-140,
          -28},{-122,-28}}, color={255,127,0}));
  connect(uOpeMod, intEqu4.u2) annotation (Line(points={{-220,-40},{-140,-40},{-140,
          -68},{-122,-68}}, color={255,127,0}));
  connect(intEqu3.y, or2.u1)
    annotation (Line(points={{-98,-20},{-82,-20}}, color={255,0,255}));
  connect(intEqu4.y, or2.u2) annotation (Line(points={{-98,-60},{-90,-60},{-90,-28},
          {-82,-28}},color={255,0,255}));
  connect(u1ResSet, or1.u1)
    annotation (Line(points={{-220,20},{-42,20}}, color={255,0,255}));
  connect(or2.y, or1.u2) annotation (Line(points={{-58,-20},{-50,-20},{-50,12},
          {-42,12}},color={255,0,255}));
  connect(or1.y, notSupTemAla.u)
    annotation (Line(points={{-18,20},{-2,20}}, color={255,0,255}));
  connect(twoDegHig.y, and2.u1)
    annotation (Line(points={{-98,220},{-82,220}}, color={255,0,255}));
  connect(thrDegHig.y, and1.u1)
    annotation (Line(points={{-98,180},{-82,180}}, color={255,0,255}));
  connect(twoDegLow.y, and3.u1)
    annotation (Line(points={{-98,100},{-82,100}}, color={255,0,255}));
  connect(thrDegLow.y, and4.u1)
    annotation (Line(points={{-98,60},{-82,60}}, color={255,0,255}));
  connect(and2.y, tenMinDur2.u)
    annotation (Line(points={{-58,220},{-42,220}}, color={255,0,255}));
  connect(and1.y, tenMinDur3.u)
    annotation (Line(points={{-58,180},{-42,180}}, color={255,0,255}));
  connect(and3.y, tenMinDur.u)
    annotation (Line(points={{-58,100},{-42,100}}, color={255,0,255}));
  connect(and4.y, tenMinDur1.u)
    annotation (Line(points={{-58,60},{-42,60}}, color={255,0,255}));
  connect(not1.y, higTemAla3.u)
    annotation (Line(points={{182,220},{198,220}}, color={255,0,255}));
  connect(tenMinDur2.y, booToInt.u)
    annotation (Line(points={{-18,220},{-2,220}}, color={255,0,255}));
  connect(tenMinDur.y, booToInt2.u)
    annotation (Line(points={{-18,100},{-2,100}}, color={255,0,255}));
  connect(notSupTemAla.y, and2.u2) annotation (Line(points={{22,20},{30,20},{30,
          40},{-90,40},{-90,212},{-82,212}}, color={255,0,255}));
  connect(notSupTemAla.y, and1.u2) annotation (Line(points={{22,20},{30,20},{30,
          40},{-90,40},{-90,172},{-82,172}}, color={255,0,255}));
  connect(notSupTemAla.y, and3.u2) annotation (Line(points={{22,20},{30,20},{30,
          40},{-90,40},{-90,92},{-82,92}},   color={255,0,255}));
  connect(notSupTemAla.y, and4.u2) annotation (Line(points={{22,20},{30,20},{30,
          40},{-90,40},{-90,52},{-82,52}}, color={255,0,255}));
  connect(not2.y, higTemAla2.u)
    annotation (Line(points={{182,180},{198,180}}, color={255,0,255}));
  connect(not3.y, lowTemAla3.u)
    annotation (Line(points={{182,100},{198,100}}, color={255,0,255}));
  connect(not4.y, lowTemAla2.u)
    annotation (Line(points={{182,60},{198,60}}, color={255,0,255}));
  connect(levThrHig.y, not1.u)
    annotation (Line(points={{142,220},{158,220}}, color={255,0,255}));
  connect(levTwoHig.y, not2.u)
    annotation (Line(points={{142,180},{158,180}}, color={255,0,255}));
  connect(levThrLow.y, not3.u)
    annotation (Line(points={{142,100},{158,100}}, color={255,0,255}));
  connect(levTwoLow.y, not4.u)
    annotation (Line(points={{142,60},{158,60}}, color={255,0,255}));
  connect(levThr.y, levThrHig.u2) annotation (Line(points={{22,-20},{90,-20},{
          90,212},{118,212}}, color={255,127,0}));
  connect(levThr.y, levThrLow.u2) annotation (Line(points={{22,-20},{90,-20},{
          90,92},{118,92}}, color={255,127,0}));
  connect(levTwo.y, levTwoHig.u2) annotation (Line(points={{22,-60},{110,-60},{
          110,172},{118,172}}, color={255,127,0}));
  connect(levTwo.y, levTwoLow.u2) annotation (Line(points={{22,-60},{110,-60},{
          110,52},{118,52}}, color={255,127,0}));
  connect(unoMod.y, intEqu1.u1)
    annotation (Line(points={{-158,-120},{-122,-120}}, color={255,127,0}));
  connect(uOpeMod, intEqu1.u2) annotation (Line(points={{-220,-40},{-140,-40},{-140,
          -128},{-122,-128}}, color={255,127,0}));
  connect(ppmCO2, greThr.u)
    annotation (Line(points={{-220,-160},{-122,-160}}, color={0,0,127}));
  connect(intEqu1.y, twoHou.u)
    annotation (Line(points={{-98,-120},{-82,-120}}, color={255,0,255}));
  connect(twoHou.y, and5.u1)
    annotation (Line(points={{-58,-120},{-42,-120}}, color={255,0,255}));
  connect(greThr.y, and5.u2) annotation (Line(points={{-98,-160},{-50,-160},{-50,
          -128},{-42,-128}}, color={255,0,255}));
  connect(ppmCO2, lesThr.u) annotation (Line(points={{-220,-160},{-180,-160},{-180,
          -180},{-42,-180}}, color={0,0,127}));
  connect(and5.y, or3.u1)
    annotation (Line(points={{-18,-120},{-2,-120}}, color={255,0,255}));
  connect(lesThr.y, or3.u2) annotation (Line(points={{-18,-180},{-10,-180},{-10,
          -128},{-2,-128}}, color={255,0,255}));
  connect(not5.y, lowTemAla4.u)
    annotation (Line(points={{182,-120},{198,-120}}, color={255,0,255}));
  connect(greThr1.y, tenMinDur4.u)
    annotation (Line(points={{-98,-220},{-82,-220}}, color={255,0,255}));
  connect(ppmCO2, greThr1.u) annotation (Line(points={{-220,-160},{-180,-160},{-180,
          -220},{-122,-220}}, color={0,0,127}));
  connect(or3.y, and6.u1)
    annotation (Line(points={{22,-120},{38,-120}}, color={255,0,255}));
  connect(tenMinDur4.y, not6.u)
    annotation (Line(points={{-58,-220},{-2,-220}}, color={255,0,255}));
  connect(not6.y, and6.u2) annotation (Line(points={{22,-220},{30,-220},{30,-128},
          {38,-128}}, color={255,0,255}));
  connect(and6.y, not5.u)
    annotation (Line(points={{62,-120},{158,-120}}, color={255,0,255}));
  connect(and6.y, booToInt4.u) annotation (Line(points={{62,-120},{70,-120},{70,
          -160},{78,-160}}, color={255,0,255}));
  connect(tenMinDur4.y, booToInt5.u) annotation (Line(points={{-58,-220},{-20,-220},
          {-20,-200},{78,-200}}, color={255,0,255}));
  connect(not6.y, lowTemAla5.u)
    annotation (Line(points={{22,-220},{198,-220}}, color={255,0,255}));
  connect(booToInt4.y, co2Ala.u1) annotation (Line(points={{102,-160},{120,-160},
          {120,-174},{138,-174}}, color={255,127,0}));
  connect(booToInt5.y, co2Ala.u2) annotation (Line(points={{102,-200},{120,-200},
          {120,-186},{138,-186}}, color={255,127,0}));
  connect(temAla.y, yTemAla)
    annotation (Line(points={{162,140},{260,140}}, color={255,127,0}));
  connect(co2Ala.y, yCO2Ala)
    annotation (Line(points={{162,-180},{260,-180}}, color={255,127,0}));
  connect(TZon, lowTem.u2) annotation (Line(points={{-220,220},{-180,220},{-180,
          94},{-172,94}},           color={0,0,127}));
  connect(tenMinDur3.y, higTemAla.u2)
    annotation (Line(points={{-18,180},{58,180}}, color={255,0,255}));
  connect(tenMinDur1.y, lowTemAla.u2)
    annotation (Line(points={{-18,60},{58,60}}, color={255,0,255}));
  connect(levTwo.y, higTemAla.u1) annotation (Line(points={{22,-60},{40,-60},{40,
          188},{58,188}}, color={255,127,0}));
  connect(levTwo.y, lowTemAla.u1) annotation (Line(points={{22,-60},{40,-60},{40,
          68},{58,68}}, color={255,127,0}));
  connect(booToInt.y, higTemAla.u3) annotation (Line(points={{22,220},{50,220},{
          50,172},{58,172}}, color={255,127,0}));
  connect(booToInt2.y, lowTemAla.u3) annotation (Line(points={{22,100},{50,100},
          {50,52},{58,52}}, color={255,127,0}));
  connect(higTemAla.y, levTwoHig.u1)
    annotation (Line(points={{82,180},{118,180}}, color={255,127,0}));
  connect(higTemAla.y, levThrHig.u1) annotation (Line(points={{82,180},{100,180},
          {100,220},{118,220}}, color={255,127,0}));
  connect(higTemAla.y, temAla.u1) annotation (Line(points={{82,180},{100,180},{100,
          146},{138,146}}, color={255,127,0}));
  connect(lowTemAla.y, levTwoLow.u1)
    annotation (Line(points={{82,60},{118,60}}, color={255,127,0}));
  connect(lowTemAla.y, levThrLow.u1) annotation (Line(points={{82,60},{100,60},{
          100,100},{118,100}}, color={255,127,0}));
  connect(lowTemAla.y, temAla.u2) annotation (Line(points={{82,60},{100,60},{100,
          134},{138,134}}, color={255,127,0}));

annotation (defaultComponentName="zonAla",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
        extent={{-100,140},{100,100}},
        textString="%name",
        textColor={0,0,255}),
        Text(
          extent={{-98,68},{-64,52}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSet"),
        Text(
          extent={{-100,94},{-76,84}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-98,38},{-64,22}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{62,48},{98,32}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yTemAla"),
        Text(
          visible=have_CO2Sen,
          extent={{62,-32},{98,-48}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yCO2Ala"),
        Text(
          extent={{-98,-40},{-58,-56}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          visible=have_CO2Sen,
          extent={{-98,-72},{-62,-88}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ppmCO2"),
        Text(
          extent={{-98,-12},{-62,-28}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1ResSet")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-260},{240,260}})),
Documentation(info="<html>
<p>
This block outputs zone alarms. The implementation is according to the ASHRAE
Guideline 36, Section 5.3.6.
</p>
<h4>Zone temperature alarm</h4>
<ol>
<li>
High-temperature alarm
<ul>
<li>
If the zone temperature <code>TZon</code> is 2 &deg;C (3 &deg;F) above the cooling
setpoint <code>TCooSet</code> for 10 minutes (<code>timChe</code>),
generate Level 3 alarm.
</li>
<li>
If the zone temperature <code>TZon</code> is 3 &deg;C (5 &deg;F) above the cooling
setpoint <code>TCooSet</code> for 10 minutes (<code>timChe</code>),
generate Level 2 alarm.
</li>
</ul>
</li>
<li>
Low-temperature alarm
<ul>
<li>
If the zone temperature <code>TZon</code> is 2 &deg;C (3 &deg;F) below the heating
setpoint <code>THeaSet</code> for 10 minutes (<code>timChe</code>),
generate Level 3 alarm.
</li>
<li>
If the zone temperature <code>TZon</code> is 3 &deg;C (5 &deg;F) below the heating
setpoint <code>THeaSet</code> for 10 minutes (<code>timChe</code>),
generate Level 2 alarm.
</li>
</ul>
</li>
<li>
Suppress zone temperature alarms as follows:
<ul>
<li>
After zone setpoint is changed per Section 5.1.20 of Guideline 36,
<code>uResSet=true</code>.
</li>
<li>
While zone group is in warm-up or cooldown modes.
</li>
</ul>
</li>
</ol>
<h4>For zones with CO2 sensors:</h4>
<ul>
<li>
If the CO2 concentration <code>ppmCO2</code> is less than 300 ppm, or the zone is
in unoccupied mode for more than 2 hours (<code>modChe</code>) and zone CO2
concentration exceeds 600 ppm, generate a Level 3 alarm. The alarm text shall
identify the sensor and indicate that it may be out of calibration.
</li>
<li>
If the CO2 concentration exceeds setpoint (<code>CO2Set</code>) plus 10% for more
than 10 minutes (<code>timChe</code>), generate a Level 2 alarm.
</li>
</ul>
</html>",revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Alarms;
