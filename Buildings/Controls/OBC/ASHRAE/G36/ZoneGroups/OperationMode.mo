within Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups;
block OperationMode "Block that outputs the operation mode"

  parameter Integer nZon(min=1) "Number of zones";
  parameter Real preWarCooTim(
    final unit="s",
    final quantity="Time") = 10800
    "Maximum cool-down or warm-up time"
    annotation (__cdl(ValueInReference=True));
  parameter Real TZonFreProOn(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=277.15
    "Threshold temperature to activate the freeze protection mode"
    annotation (__cdl(ValueInReference=True));
  parameter Real TZonFreProOff(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=280.15
    "Threshold temperature to end the freeze protection mode"
    annotation (__cdl(ValueInReference=True));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Occ
    "True: zone scheduled to be occupied"
    annotation (Placement(transformation(extent={{-400,350},{-360,390}}),
        iconTransformation(extent={{-140,160},{-100,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
    final unit="s",
    final quantity="Time")
    "Time to next occupied period"
    annotation (Placement(transformation(extent={{-400,310},{-360,350}}),
      iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput maxCooDowTim(
    final unit="s",
    final quantity="Time") "Maximum cool-down time among all the zones"
    annotation (Placement(transformation(extent={{-400,260},{-360,300}}),
      iconTransformation(extent={{-140,120},{-100,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HigOccCoo
    "True when there is zone with the temperature being higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-400,210},{-360,250}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput maxWarUpTim(
    final unit="s",
    final quantity="Time") "Maximum warm-up time among all the zones"
    annotation (Placement(transformation(extent={{-400,160},{-360,200}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1OccHeaHig
    "True when there is zone with the temperature being lower than the occupied heating setpoint"
    annotation (Placement(transformation(extent={{-400,110},{-360,150}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeWin
    "Total number of zones with opening window"
    annotation (Placement(transformation(extent={{-400,70},{-360,110}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput totColZon
    "Total number of cold zone"
    annotation (Placement(transformation(extent={{-400,10},{-360,50}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SetBac
    "True when the average zone temperature falls below the average unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-400,-40},{-360,0}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1EndSetBac
    "True when the setback mode could end"
    annotation (Placement(transformation(extent={{-400,-70},{-360,-30}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Minimum zone temperature"
    annotation (Placement(transformation(extent={{-400,-140},{-360,-100}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput totHotZon
    "Total number of hot zone"
    annotation (Placement(transformation(extent={{-400,-210},{-360,-170}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SetUp
    "True when the average zone temperature rises above the average unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-400,-260},{-360,-220}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1EndSetUp
    "True when the setup mode could end"
    annotation (Placement(transformation(extent={{-400,-290},{-360,-250}}),
        iconTransformation(extent={{-140,-200},{-100,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yOpeMod
    "Operation mode"
    annotation (Placement(transformation(extent={{360,-18},{400,22}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant occModInd(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Occupied mode "
    annotation (Placement(transformation(extent={{100,340},{120,360}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant unoPerInd(final k=0.0)
    "Index to indicate unoccupied period"
    annotation (Placement(transformation(extent={{0,340},{20,360}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch corCooDowTim "Corrected cool down period"
    annotation (Placement(transformation(extent={{-220,240},{-200,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch corWarUpTim "Corrected warm-up period"
    annotation (Placement(transformation(extent={{-200,140},{-180,160}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(
    final t=4) "Check if the number of cold zones is not less than than 5"
    annotation (Placement(transformation(extent={{-280,20},{-260,40}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "If all zone temperature are higher than unoccupied heating setpoint by a given limit, then the setback mode should be off"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "If all zone temperature are higher than threshold temperature of ending freeze protection, then freeze protection setback mode should be off"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "If all zone temperature are lower than unoccupied cooling setpoint by a given limit, then the setup mode should be off"
    annotation (Placement(transformation(extent={{-100,-200},{-80,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final pre_y_start=true,
    final uHigh=0,
    final uLow=-60)
    "Hysteresis that outputs if the maximum cool-down time is more than the allowed cool-down time"
    annotation (Placement(transformation(extent={{-260,240},{-240,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3(
    final pre_y_start=true,
    final uHigh=0,
    final uLow=-60)
    "Hysteresis that outputs if the maximum warm-up time is more than allowed warm-up time"
    annotation (Placement(transformation(extent={{-260,140},{-240,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub5
    "Calculate differential between time-to-next-occupancy and the cool-down time"
    annotation (Placement(transformation(extent={{-160,240},{-140,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4(
    final pre_y_start=false,
    final uHigh=0,
    final uLow=-60)
    "Hysteresis to check if the cooldown mode could be activated"
    annotation (Placement(transformation(extent={{-120,240},{-100,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys5(
    final pre_y_start=false,
    final uHigh=0,
    final uLow=-60)
    "Hysteresis to activate the warm-up model"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub6
    "Calculate differential between time-to-next-occupancy and the warm-up time"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys9(
    final pre_y_start=false,
    final uLow=-0.1,
    final uHigh=0.1)
    "Hysteresis that outputs if any zone temperature is lower than freeze protection threshold temperature"
    annotation (Placement(transformation(extent={{-180,-100},{-160,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys10(
    final pre_y_start=false,
    final uLow=-0.1,
    final uHigh=0.1)
    "Hysteresis that outputs if all zone temperature are higher than threshold temperature of ending freeze protection"
    annotation (Placement(transformation(extent={{-180,-140},{-160,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxWarCooTime(
    final k=preWarCooTim)
    "Allowed maximum warm-up or cool-down time"
    annotation (Placement(transformation(extent={{-340,190},{-320,210}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr2(
    final t=4) "Check if the number of hot zones is not less than than 5"
    annotation (Placement(transformation(extent={{-280,-200},{-260,-180}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt "Sum of two integer inputs"
    annotation (Placement(transformation(extent={{240,280},{260,300}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt1 "Sum of two integer inputs"
    annotation (Placement(transformation(extent={{276,304},{296,324}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt2 "Sum of two integer inputs"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt3 "Sum of two integer inputs"
    annotation (Placement(transformation(extent={{200,-180},{220,-160}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt4 "Sum of two integer inputs"
    annotation (Placement(transformation(extent={{260,-320},{280,-300}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt5 "Sum of two integer inputs"
    annotation (Placement(transformation(extent={{320,-8},{340,12}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger occMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{200,310},{220,330}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger setBacMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger freProSetBacMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger setUpMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{100,-200},{120,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Get the moment when the warm up time starts "
    annotation (Placement(transformation(extent={{-50,150},{-30,170}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=preWarCooTim)
    "Hold the start time true signal"
    annotation (Placement(transformation(extent={{-20,240},{0,260}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Get the moment when cool down time starts"
    annotation (Placement(transformation(extent={{-48,240},{-28,260}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol1(
    final trueHoldDuration=preWarCooTim)
    "Hold the start time true signal"
    annotation (Placement(transformation(extent={{-20,150},{0,170}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(
    final realTrue=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.warmUp)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{80,170},{100,190}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.coolDown)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{80,260},{100,280}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3(
    final integerTrue=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    "Convert Boolean to Integer "
    annotation (Placement(transformation(extent={{120,-370},{140,-350}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea6(
    final realTrue=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.setUp)
    "Convert Boolean to Real "
    annotation (Placement(transformation(extent={{-20,-200},{0,-180}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea4(
    final realTrue=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.freezeProtection)
    "Convert Boolean to Real "
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea3(
    final realTrue=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.setBack)
    "Convert Boolean to Real "
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Level 3 alarm: freeze protection setback")
    "Generate alarm message"
    annotation (Placement(transformation(extent={{100,-140},{120,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
   annotation (Placement(transformation(extent={{80,-370},{100,-350}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Warm-up period"
    annotation (Placement(transformation(extent={{20,170},{40,190}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Get the start of the cool-down time"
    annotation (Placement(transformation(extent={{-80,240},{-60,260}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Check if the number of cold zone is more than 5 or all zones are cold"
    annotation (Placement(transformation(extent={{-220,20},{-200,40}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    "Check if it is in occupied, cooldown, or warm-up mode"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4
    "Check if the number of hot zone is more than 5 or all zones are hot"
    annotation (Placement(transformation(extent={{-220,-200},{-200,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or5
    "Check if it is in Setback, Setback_freezeProtection, or Setup mode"
    annotation (Placement(transformation(extent={{-20,-350},{0,-330}})));
  Buildings.Controls.OBC.CDL.Logical.Or or6
    "Check if it is in any of the 6 modes except unoccupied mode"
    annotation (Placement(transformation(extent={{40,-370},{60,-350}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch between occupied mode index and unoccupied period index"
    annotation (Placement(transformation(extent={{160,310},{180,330}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi3
    "If the Cool-down, warm-up, or Occupied mode is on, then setback mode should not be activated."
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi4
    "If the Cool-down, warm-up, or Occupied mode is on, then freeze protection setback mode should not be activated."
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi5
    "If the Cool-down, warm-up, or Occupied mode is on, then setup mode should not be activated."
    annotation (Placement(transformation(extent={{60,-200},{80,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5 "Logical not"
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold notOcc(
    final t=1)
    "Check if the operation mode is other than occupied mode"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "True if window open during modes other than occupied mode"
    annotation (Placement(transformation(extent={{160,80},{180,100}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{200,80},{220,100}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert winOpe(
    final message="Level 4 alarm: window open during modes other than occupied mode")
    "Generate alarm message when window open during modes other than occupied mode"
    annotation (Placement(transformation(extent={{240,80},{260,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "If occupied mode is on, then cool down mode should not be activated"
    annotation (Placement(transformation(extent={{140,270},{160,290}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger setBacMod1
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{180,270},{200,290}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "If occupied mode is on, then warm-up mode should not be activated."
    annotation (Placement(transformation(extent={{140,180},{160,200}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger setBacMod2
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{180,180},{200,200}})));
  Buildings.Controls.OBC.CDL.Logical.And and4 "Cool-down period"
    annotation (Placement(transformation(extent={{20,260},{40,280}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Get the start of the warm-up time"
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant totZon(
    final k=nZon) "Total number of zones"
    annotation (Placement(transformation(extent={{-340,-340},{-320,-320}})));
  Buildings.Controls.OBC.CDL.Integers.Equal allCol
    "Check if all zones are cold zone"
    annotation (Placement(transformation(extent={{-280,-10},{-260,10}})));
  Buildings.Controls.OBC.CDL.Integers.Equal allHot
    "Check if all zones are hot zone"
    annotation (Placement(transformation(extent={{-280,-230},{-260,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant actFreProTem(
    final k=TZonFreProOn)
    "Threshold temperature to activate the freeze protection mode"
    annotation (Placement(transformation(extent={{-280,-110},{-260,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant endFreProTem(
    final k=TZonFreProOff)
    "Threshold temperature to end the freeze protection mode"
    annotation (Placement(transformation(extent={{-280,-150},{-260,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Calculate differential between minimum zone temperature and freeze protection threshold temperature"
    annotation (Placement(transformation(extent={{-220,-100},{-200,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "Calculate differential between maximum zone temperature and threshold temperature of ending freeze protection"
    annotation (Placement(transformation(extent={{-220,-140},{-200,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Enough cold zone or the low average zone temperature"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Buildings.Controls.OBC.CDL.Logical.Or or7
    "Enough hot zone or the high average zone temperature"
    annotation (Placement(transformation(extent={{-160,-200},{-140,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub3
    "Calculate the difference between maximum cool down time and the allowed maximum cool down time"
    annotation (Placement(transformation(extent={{-300,240},{-280,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub4
    "Calculate the differential between maximum warm-up time and the allowed maximum warm-up time"
    annotation (Placement(transformation(extent={{-300,140},{-280,160}})));
  Buildings.Controls.OBC.CDL.Logical.Edge endSetBac
    "End setback mode when the input becomes true"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Edge endSetUp
    "End setup mode when the input becomes true"
    annotation (Placement(transformation(extent={{-160,-280},{-140,-260}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr1(
    final  t=1) "Check if there is any zone with opening window"
    annotation (Placement(transformation(extent={{-260,80},{-240,100}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt6
    "Total cold zone and zones with opening window"
    annotation (Placement(transformation(extent={{-330,-10},{-310,10}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt7
    "Total hot zone and zones with opening window"
    annotation (Placement(transformation(extent={{-330,-230},{-310,-210}})));

equation
  connect(swi.y, occMod.u)
    annotation (Line(points={{182,320},{198,320}},
      color={0,0,127}));
  connect(occModInd.y, swi.u1)
    annotation (Line(points={{122,350},{140,350},{140,328},{158,328}},
      color={0,0,127}, pattern=LinePattern.Dash));
  connect(unoPerInd.y, swi.u3)
    annotation (Line(points={{22,350},{50,350},{50,312},{158,312}},
      color={0,0,127}, pattern=LinePattern.Dash));
  connect(intGreThr.y, or1.u1)
    annotation (Line(points={{-258,30},{-222,30}},
      color={255,0,255}));
  connect(lat.y, booToRea3.u)
    annotation (Line(points={{-78,30},{-22,30}},
      color={255,0,255}));
  connect(unoPerInd.y, swi3.u1)
    annotation (Line(points={{22,350},{50,350},{50,38},{58,38}},
      color={0,0,127}, pattern=LinePattern.Dash));
  connect(or3.y, swi3.u2)
    annotation (Line(points={{-118,70},{40,70},{40,30},{58,30}},
      color={255,0,255}));
  connect(lat1.y, booToRea4.u)
    annotation (Line(points={{-78,-90},{-22,-90}},   color={255,0,255}));
  connect(or3.y, swi4.u2)
    annotation (Line(points={{-118,70},{40,70},{40,-90},{58,-90}},
      color={255,0,255}));
  connect(unoPerInd.y, swi4.u1)
    annotation (Line(points={{22,350},{50,350},{50,-82},{58,-82}},
      color={0,0,127}, pattern=LinePattern.Dash));
  connect(lat2.y, booToRea6.u)
    annotation (Line(points={{-78,-190},{-22,-190}},
      color={255,0,255}));
  connect(or3.y, swi5.u2)
    annotation (Line(points={{-118,70},{40,70},{40,-190},{58,-190}},
      color={255,0,255}));
  connect(unoPerInd.y, swi5.u1)
    annotation (Line(points={{22,350},{50,350},{50,-182},{58,-182}},
      color={0,0,127},  pattern=LinePattern.Dash));
  connect(swi3.y, setBacMod.u)
    annotation (Line(points={{82,30},{98,30}},
      color={0,0,127}));
  connect(swi4.y, freProSetBacMod.u)
    annotation (Line(points={{82,-90},{98,-90}}, color={0,0,127}));
  connect(swi5.y, setUpMod.u)
    annotation (Line(points={{82,-190},{98,-190}},
      color={0,0,127}));
  connect(or5.y, or6.u1)
    annotation (Line(points={{2,-340},{20,-340},{20,-360},{38,-360}},
      color={255,0,255}));
  connect(or6.y, not2.u)
    annotation (Line(points={{62,-360},{78,-360}},
      color={255,0,255}));
  connect(not2.y,booToInt3. u)
    annotation (Line(points={{102,-360},{118,-360}},
      color={255,0,255}));
  connect(and1.y,booToRea1. u)
    annotation (Line(points={{42,180},{78,180}}, color={255,0,255}));
  connect(and1.y, or3.u1)
    annotation (Line(points={{42,180},{68,180},{68,112},{-190,112},{-190,78},
      {-142,78}}, color={255,0,255}));
  connect(u1Occ, swi.u2) annotation (Line(points={{-380,370},{-350,370},{-350,320},
          {158,320}}, color={255,0,255}));
  connect(u1Occ, or3.u3) annotation (Line(points={{-380,370},{-350,370},{-350,62},
          {-142,62}}, color={255,0,255}));
  connect(hys2.y, corCooDowTim.u2)
    annotation (Line(points={{-238,250},{-222,250}}, color={255,0,255}));
  connect(hys3.y, corWarUpTim.u2)
    annotation (Line(points={{-238,150},{-202,150}}, color={255,0,255}));
  connect(sub5.y, hys4.u)
    annotation (Line(points={{-138,250},{-122,250}}, color={0,0,127}));
  connect(sub6.y, hys5.u)
    annotation (Line(points={{-138,160},{-122,160}}, color={0,0,127}));
  connect(hys9.y, lat1.u)
    annotation (Line(points={{-158,-90},{-102,-90}},  color={255,0,255}));
  connect(hys10.y, lat1.clr)
    annotation (Line(points={{-158,-130},{-120,-130},{-120,-96},{-102,-96}},
      color={255,0,255}));
  connect(maxWarCooTime.y, corCooDowTim.u3)
    annotation (Line(points={{-318,200},{-230,200},{-230,242},{-222,242}},
      color={0,0,127}));
  connect(maxWarCooTime.y, corWarUpTim.u3)
    annotation (Line(points={{-318,200},{-230,200},{-230,142},{-202,142}},
      color={0,0,127}));
  connect(booToRea3.y, swi3.u3)
    annotation (Line(points={{2,30},{30,30},{30,22},{58,22}},
      color={0,0,127}));
  connect(booToRea4.y, swi4.u3)
    annotation (Line(points={{2,-90},{20,-90},{20,-98},{58,-98}},
      color={0,0,127}));
  connect(booToRea6.y, swi5.u3)
    annotation (Line(points={{2,-190},{20,-190},{20,-198},{58,-198}},
      color={0,0,127}));
  connect(lat1.y, not5.u)
    annotation (Line(points={{-78,-90},{-50,-90},{-50,-130},{-22,-130}},
      color={255,0,255}));
  connect(not5.y, assMes.u)
    annotation (Line(points={{2,-130},{98,-130}},  color={255,0,255}));
  connect(maxCooDowTim, corCooDowTim.u1) annotation (Line(points={{-380,280},{
          -230,280},{-230,258},{-222,258}}, color={0,0,127}));
  connect(maxWarUpTim, corWarUpTim.u1) annotation (Line(points={{-380,180},{
          -220,180},{-220,158},{-202,158}}, color={0,0,127}));
  connect(totColZon, intGreThr.u)
    annotation (Line(points={{-380,30},{-282,30}},   color={255,127,0}));
  connect(totHotZon, intGreThr2.u)
    annotation (Line(points={{-380,-190},{-282,-190}}, color={255,127,0}));
  connect(intGreThr2.y, or4.u1)
    annotation (Line(points={{-258,-190},{-222,-190}}, color={255,0,255}));
  connect(setBacMod.y, addInt2.u1) annotation (Line(points={{122,30},{130,30},{
          130,-34},{138,-34}},  color={255,127,0}));
  connect(freProSetBacMod.y, addInt2.u2) annotation (Line(points={{122,-90},{
          130,-90},{130,-46},{138,-46}}, color={255,127,0}));
  connect(setUpMod.y, addInt3.u2) annotation (Line(points={{122,-190},{180,-190},
          {180,-176},{198,-176}}, color={255,127,0}));
  connect(addInt2.y, addInt3.u1) annotation (Line(points={{162,-40},{180,-40},{
          180,-164},{198,-164}}, color={255,127,0}));
  connect(addInt3.y, addInt4.u1) annotation (Line(points={{222,-170},{240,-170},
          {240,-304},{258,-304}}, color={255,127,0}));
  connect(booToInt3.y, addInt4.u2) annotation (Line(points={{142,-360},{200,
          -360},{200,-316},{258,-316}}, color={255,127,0}));
  connect(addInt5.y, yOpeMod)
    annotation (Line(points={{342,2},{380,2}}, color={255,127,0}));
  connect(notOcc.y, and3.u2) annotation (Line(points={{122,70},{140,70},{140,82},
          {158,82}}, color={255,0,255}));
  connect(and3.y, not1.u)
    annotation (Line(points={{182,90},{198,90}}, color={255,0,255}));
  connect(addInt5.y, notOcc.u) annotation (Line(points={{342,2},{350,2},{350,50},
          {80,50},{80,70},{98,70}},        color={255,127,0}));
  connect(not1.y, winOpe.u)
    annotation (Line(points={{222,90},{238,90}}, color={255,0,255}));
  connect(booToRea.y, swi1.u3) annotation (Line(points={{102,270},{110,270},{
          110,272},{138,272}}, color={0,0,127}));
  connect(u1Occ, swi1.u2) annotation (Line(points={{-380,370},{-350,370},{-350,320},
          {120,320},{120,280},{138,280}}, color={255,0,255}));
  connect(swi1.y, setBacMod1.u)
    annotation (Line(points={{162,280},{178,280}}, color={0,0,127}));
  connect(setBacMod1.y, addInt.u1) annotation (Line(points={{202,280},{220,280},
          {220,296},{238,296}}, color={255,127,0}));
  connect(addInt.y, addInt1.u2) annotation (Line(points={{262,290},{268,290},{
          268,308},{274,308}}, color={255,127,0}));
  connect(occMod.y, addInt1.u1)
    annotation (Line(points={{222,320},{274,320}}, color={255,127,0}));
  connect(addInt1.y, addInt5.u1) annotation (Line(points={{298,314},{306,314},{
          306,8},{318,8}}, color={255,127,0}));
  connect(addInt4.y, addInt5.u2) annotation (Line(points={{282,-310},{306,-310},
          {306,-4},{318,-4}}, color={255,127,0}));
  connect(booToRea1.y, swi2.u3) annotation (Line(points={{102,180},{110,180},{
          110,182},{138,182}}, color={0,0,127}));
  connect(unoPerInd.y, swi1.u1)
    annotation (Line( points={{22,350},{50,350},{50,288},{138,288}},
      color={0,0,127}, pattern=LinePattern.Dash));
  connect(unoPerInd.y, swi2.u1)
    annotation (Line(points={{22,350},{50,350},{50,198},{138,198}},
      color={0,0,127}, pattern=LinePattern.Dash));
  connect(swi2.y, setBacMod2.u)
    annotation (Line(points={{162,190},{178,190}}, color={0,0,127}));
  connect(setBacMod2.y, addInt.u2) annotation (Line(points={{202,190},{230,190},
          {230,284},{238,284}}, color={255,127,0}));
  connect(and4.y, booToRea.u)
    annotation (Line(points={{42,270},{78,270}},   color={255,0,255}));
  connect(and4.y, or3.u2) annotation (Line(points={{42,270},{60,270},{60,120},{
          -200,120},{-200,70},{-142,70}},color={255,0,255}));
  connect(hys4.y, and2.u1)
    annotation (Line(points={{-98,250},{-82,250}}, color={255,0,255}));
  connect(u1OccHeaHig, and5.u2) annotation (Line(points={{-380,130},{-90,130},{-90,
          152},{-82,152}}, color={255,0,255}));
  connect(hys5.y, and5.u1)
    annotation (Line(points={{-98,160},{-82,160}}, color={255,0,255}));
  connect(truFalHol1.u, edg.y)
    annotation (Line(points={{-22,160},{-28,160}}, color={255,0,255}));
  connect(and5.y, edg.u)
    annotation (Line(points={{-58,160},{-52,160}}, color={255,0,255}));
  connect(and2.y, edg1.u)
    annotation (Line(points={{-58,250},{-50,250}}, color={255,0,255}));
  connect(edg1.y, truFalHol.u)
    annotation (Line(points={{-26,250},{-22,250}},color={255,0,255}));
  connect(lat2.y, or5.u1) annotation (Line(points={{-78,-190},{-40,-190},{-40,
          -332},{-22,-332}}, color={255,0,255}));
  connect(lat1.y, or5.u2) annotation (Line(points={{-78,-90},{-50,-90},{-50,
          -340},{-22,-340}}, color={255,0,255}));
  connect(lat.y, or5.u3) annotation (Line(points={{-78,30},{-60,30},{-60,-348},
          {-22,-348}}, color={255,0,255}));
  connect(or3.y, or6.u2) annotation (Line(points={{-118,70},{-70,70},{-70,-368},
          {38,-368}}, color={255,0,255}));
  connect(allCol.y, or1.u2) annotation (Line(points={{-258,0},{-240,0},{-240,22},
          {-222,22}}, color={255,0,255}));
  connect(allHot.y, or4.u2) annotation (Line(points={{-258,-220},{-240,-220},{
          -240,-198},{-222,-198}}, color={255,0,255}));
  connect(totZon.y, allCol.u2) annotation (Line(points={{-318,-330},{-300,-330},
          {-300,-8},{-282,-8}},   color={255,127,0}));
  connect(totZon.y, allHot.u2) annotation (Line(points={{-318,-330},{-300,-330},
          {-300,-228},{-282,-228}}, color={255,127,0}));
  connect(sub2.y, hys9.u)
    annotation (Line(points={{-198,-90},{-182,-90}},   color={0,0,127}));
  connect(sub1.y, hys10.u)
    annotation (Line(points={{-198,-130},{-182,-130}}, color={0,0,127}));
  connect(TZonMin, sub1.u1) annotation (Line(points={{-380,-120},{-240,-120},{
          -240,-124},{-222,-124}}, color={0,0,127}));
  connect(endFreProTem.y, sub1.u2) annotation (Line(points={{-258,-140},{-240,-140},
          {-240,-136},{-222,-136}},       color={0,0,127}));
  connect(or1.y, or2.u1)
    annotation (Line(points={{-198,30},{-162,30}}, color={255,0,255}));
  connect(or2.y, lat.u)
    annotation (Line(points={{-138,30},{-102,30}}, color={255,0,255}));
  connect(u1SetBac, or2.u2) annotation (Line(points={{-380,-20},{-180,-20},{-180,
          22},{-162,22}}, color={255,0,255}));
  connect(or4.y, or7.u1)
    annotation (Line(points={{-198,-190},{-162,-190}}, color={255,0,255}));
  connect(or7.y, lat2.u)
    annotation (Line(points={{-138,-190},{-102,-190}}, color={255,0,255}));
  connect(u1SetUp, or7.u2) annotation (Line(points={{-380,-240},{-180,-240},{-180,
          -198},{-162,-198}}, color={255,0,255}));
  connect(u1Occ, swi2.u2) annotation (Line(points={{-380,370},{-350,370},{-350,320},
          {120,320},{120,190},{138,190}}, color={255,0,255}));
  connect(truFalHol.y, and4.u2)
    annotation (Line(points={{2,250},{10,250},{10,262},{18,262}}, color={255,0,255}));
  connect(hys4.y, and4.u1)
    annotation (Line(points={{-98,250},{-90,250},{-90,270},{18,270}},
      color={255,0,255}));
  connect(truFalHol1.y, and1.u2)
    annotation (Line(points={{2,160},{10,160},{10,172},{18,172}}, color={255,0,255}));
  connect(hys5.y, and1.u1)
    annotation (Line(points={{-98,160},{-90,160},{-90,180},{18,180}},
      color={255,0,255}));
  connect(u1HigOccCoo, and2.u2) annotation (Line(points={{-380,230},{-90,230},{-90,
          242},{-82,242}}, color={255,0,255}));
  connect(maxWarCooTime.y, sub4.u1)
    annotation (Line(points={{-318,200},{-310,200},{-310,156},{-302,156}},
      color={0,0,127}));
  connect(maxWarUpTim, sub4.u2)
    annotation (Line(points={{-380,180},{-340,180},{-340,144},{-302,144}},
      color={0,0,127}));
  connect(sub3.y, hys2.u)
    annotation (Line(points={{-278,250},{-262,250}}, color={0,0,127}));
  connect(sub4.y, hys3.u)
    annotation (Line(points={{-278,150},{-262,150}}, color={0,0,127}));
  connect(u1EndSetBac, endSetBac.u)
    annotation (Line(points={{-380,-50},{-162,-50}}, color={255,0,255}));
  connect(endSetBac.y, lat.clr)
    annotation (Line(points={{-138,-50},{-120,-50},{-120,24},{-102,24}},
      color={255,0,255}));
  connect(u1EndSetUp, endSetUp.u)
    annotation (Line(points={{-380,-270},{-162,-270}}, color={255,0,255}));
  connect(endSetUp.y, lat2.clr)
    annotation (Line(points={{-138,-270},{-120,-270},{-120,-196},{-102,-196}},
      color={255,0,255}));
  connect(uOpeWin, intGreThr1.u)
    annotation (Line(points={{-380,90},{-262,90}}, color={255,127,0}));
  connect(intGreThr1.y, and3.u1)
    annotation (Line(points={{-238,90},{158,90}}, color={255,0,255}));
  connect(totColZon, addInt6.u2)
    annotation (Line(points={{-380,30},{-350,30},{-350,-6},{-332,-6}}, color={255,127,0}));
  connect(uOpeWin, addInt6.u1)
    annotation (Line(points={{-380,90},{-340,90},{-340,6},{-332,6}}, color={255,127,0}));
  connect(addInt6.y, allCol.u1)
    annotation (Line(points={{-308,0},{-282,0}}, color={255,127,0}));
  connect(totHotZon, addInt7.u2)
    annotation (Line(points={{-380,-190},{-350,-190},{-350,-226},{-332,-226}}, color={255,127,0}));
  connect(uOpeWin, addInt7.u1)
    annotation (Line(points={{-380,90},{-340,90},{-340,-214},{-332,-214}}, color={255,127,0}));
  connect(addInt7.y, allHot.u1)
    annotation (Line(points={{-308,-220},{-282,-220}}, color={255,127,0}));
  connect(maxWarCooTime.y, sub3.u1) annotation (Line(points={{-318,200},{-310,200},
          {-310,256},{-302,256}}, color={0,0,127}));
  connect(maxCooDowTim, sub3.u2) annotation (Line(points={{-380,280},{-340,280},
          {-340,244},{-302,244}}, color={0,0,127}));
  connect(tNexOcc, sub5.u2) annotation (Line(points={{-380,330},{-170,330},{-170,
          244},{-162,244}}, color={0,0,127}));
  connect(corCooDowTim.y, sub5.u1) annotation (Line(points={{-198,250},{-180,250},
          {-180,256},{-162,256}}, color={0,0,127}));
  connect(corWarUpTim.y, sub6.u1) annotation (Line(points={{-178,150},{-174,150},
          {-174,166},{-162,166}}, color={0,0,127}));
  connect(tNexOcc, sub6.u2) annotation (Line(points={{-380,330},{-170,330},{-170,
          154},{-162,154}}, color={0,0,127}));
  connect(actFreProTem.y, sub2.u1) annotation (Line(points={{-258,-100},{-250,-100},
          {-250,-84},{-222,-84}}, color={0,0,127}));
  connect(TZonMin, sub2.u2) annotation (Line(points={{-380,-120},{-240,-120},{-240,
          -96},{-222,-96}}, color={0,0,127}));
annotation (
  defaultComponentName = "opeModSel",
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-360,-380},{360,380}}),
        graphics={
        Rectangle(
          extent={{-358,-282},{358,-378}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-358,-182},{358,-278}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-358,-82},{358,-158}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-358,38},{358,-58}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-358,198},{358,122}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-358,298},{358,222}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-358,378},{358,312}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{236,372},{326,354}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Occupied mode"),
        Text(
          extent={{158,10},{242,-12}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Setback mode"),
        Text(
          extent={{150,-226},{222,-248}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Setup mode"),
        Text(
          extent={{214,-338},{318,-368}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Unoccupied mode"),
        Text(
          extent={{180,-94},{352,-122}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Freeze protection setback mode"),
        Text(
          extent={{164,174},{252,150}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Warm-up mode"),
        Text(
          extent={{248,258},{336,230}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Cool-down mode")}),
   Icon(coordinateSystem(extent={{-100,-200},{100,200}}),
        graphics={
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,148},{-44,136}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="maxCooDowTim"),
        Text(
          extent={{-98,106},{-50,96}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="maxWarUpTim"),
        Text(
          extent={{58,12},{96,-10}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yOpeMod"),
        Text(
          extent={{-100,240},{100,200}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-100,168},{-68,152}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="tNexOcc"),
        Text(
          extent={{-100,188},{-76,176}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Occ"),
        Text(
          extent={{-98,128},{-50,116}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1HigOccCoo"),
        Text(
          extent={{-98,86},{-48,74}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1OccHeaHig"),
        Text(
          extent={{-98,26},{-60,16}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="totColZon"),
        Text(
          extent={{-98,-34},{-52,-46}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1EndSetBac"),
        Text(
          extent={{-98,-74},{-64,-84}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonMin"),
        Text(
          extent={{-98,-114},{-62,-124}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="totHotZon"),
        Text(
          extent={{-98,-174},{-52,-186}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1EndSetUp"),
        Text(
          extent={{-98,-14},{-66,-26}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1SetBac"),
        Text(
          extent={{-98,-154},{-66,-166}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1SetUp"),
        Text(
          extent={{-100,46},{-62,36}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeWin")}),
   Documentation(info="<html>
<p>
This block outputs VAV system operating mode. It is implemented according to
ASHRAE guideline G36, section 5.4.3, section 5.4.4, section 5.4.5 and section 5.4.6.
</p>
<p>
Note that, from the user's point of view, schedules can be a set for individual zones,
or they can be set for an entire zone group, depending on how the user interface is
implemented. From the point of view of the BAS, individual zone schedules are
superimposed to create a zone-group schedule, which then drives system behavior.
</p>
<ol>
<li>
All zones in each zone group shall be in the same zone-group operating mode. If one
zone in a zone group is placed in any zone-group operating mode other than unoccupied
mode (due to override, sequence logic, or scheduled occupancy), all zones in that
group shall enter that mode.
</li>
<li>
A zone group may be in only one mode at a given time.
</li>
</ol>
<p>
Each zone group shall have the operating modes shown below.
</p>
<h4>Occupied Mode</h4>
<p>
A zone group is in the <i>occupied mode</i> when
occupancy input <code>u1Occ</code> is true. This input shall be retrieved from
other sequences that specifies occupancy variation and time remaining to the
next occupied period <code>tNexOcc</code>. A zone group could be in the occupied
mode when any of the following is true:
</p>
<ul>
<li>
The time of day is between the zone group's scheduled occupied start and stop times.
</li>
<li>
The schedules have been overriden by the occupant override system.
</li>
<li>
Any zone local override timer is nonzero.
</li>
</ul>
<h4>Warm-up Mode</h4>
<p>
Warm-up mode shall start based on the zone with the longest calculated warm-up
time <code>maxWarUpTim</code> requirement, but no earlier than 3 hours
(<code>preWarCooTim</code>) before the start of the scheduled occupied period,
and shall end at the scheduled occupied start time. Zones where the window switch
indicates that a window is open shall be ignored. Note that for each zone, 
the optimal warm-up time shall be obtained from an <i>Optimal Start</i> sequences,
computed in a separate block. The figure below shows the sequence.
</p>
<p align=\"center\">
<img alt=\"Image of warm-up mode definition\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/ZoneGroups/Warm-upModeDefinition.png\"/>
</p>
<h4>Cooldown Mode</h4>
<p>
Cooldown mode shall start based on the zone with the longest calculated
cooldown time <code>maxCooDowTim</code> requirement, but no earlier than 3 hours
(<code>preWarCooTim</code>) before the start of the scheduled occupied period,
and shall end at the scheduled occupied start time. Zones where the window switch
indicates that a window is open shall be ignored. Note that for each zone,
the optimal cooldown time shall be obtained from an <i>Optimal Start</i> sequences,
computed in a separate block.
</p>
<p align=\"center\">
<img alt=\"Image of cool-down mode definition\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/ZoneGroups/Cool-downModeDefinition.png\"/>
</p>
<h4>Setback Mode</h4>
<p>
During <i>unoccupied mode</i>, if any 5 zones (or all zones, if fewer than 5)
in the zone group fall below their unoccupied heating setpoints, or if the average
zone temperature of the zone group falls below the average unoccupied heating setpoint
(<code>uSetBac</code> becomes true), the zone group shall enter <i>setback mode</i> until
all spaces in the zone group are <i>1</i> &deg;C (<i>2</i> &deg;F) above their
unoccupied setpoints (<code>uEndSetBac</code> becomes true).
</p>
<p align=\"center\">
<img alt=\"Image of setback mode definition\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/ZoneGroups/SetbackModeDefinition.png\"/>
</p>
<h4>Freeze Protection Setback Mode</h4>
<p>
During <i>unoccupied Mode</i>, if any single zone falls below <i>4</i> &deg;C
(<i>40</i> &deg;F), the zone group shall enter <i>setback mode</i> until all zones
are above <i>7</i> &deg;C (<i>45</i> &deg;F), and a Level 3 alarm shall be set.
</p>
<h4>Setup Mode</h4>
<p>
During <i>unoccupied mode</i>, if any 5 zones (or all zones, if fewer than 5)
in the zone group rise above their unoccupied cooling setpoints, or if the average
zone temperature of the zone group rises above the average unoccupied cooling setpoint
(<code>uSetUp</code> becomes true), the zone group shall enter <i>setup mode</i> until
all spaces in the zone group are <i>1</i> &deg;C (<i>2</i> &deg;F) below their
unoccupied setpoints. Zones where the window switch indicates that a window is
open shall be ignored.
</p>
<p align=\"center\">
<img alt=\"Image of setup mode definition\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/ZoneGroups/SetupModeDefinition.png\"/>
</p>
<h4>Unoccupied Mode</h4>
<p>
<i>Unoccupied mode</i> shall be active if the zone group is not in any other mode.
</p>
</html>",revisions="<html>
<ul>
<li>
March 1, 2023, by Michael Wetter:<br/>
Changed constant from <code>0</code> to <code>0.0</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/pull/3267#issuecomment-1450587671\">#3267</a>.
</li>
<li>
June 15, 2020, by Jianjun Hu:<br/>
Upgraded the sequence according to ASHRAE Guideline 36, May 2020 version.
</li>
<li>
April 29, 2020, by Kun Zhang:<br/>
Fixed bug related to activation of warm-up and cool down mode.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1893\">#1893</a>.
</li>
<li>
March 09, 2020, by Jianjun Hu:<br/>
Reimplemented to remove the vector-valued calculations.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1709\">#1709</a>.
</li>
<li>
April 13, 2019, by Michael Wetter:<br/>
Corrected wrong time in the documentation of the parameters.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1409\">#1409</a>.
</li>
<li>
June 19, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end OperationMode;
