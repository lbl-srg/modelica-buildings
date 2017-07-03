within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic;
block OperationModeSelector "Block that outputs the operation mode"

  parameter Integer numOfZon = 10 "Number of zones";

  parameter Modelica.SIunits.Time preWarCooTim = 3*3600
    "Maximum cool-down/warm-up time";

  parameter Real bouLim = 1.1
    "Value limit to indicate the end of setback/setup mode";

  parameter Real freProThrVal = 4.4
    "Threshold zone temperature value to activate freeze protection mode";

  parameter Real freProEndVal = 7.2
    "Threshold zone temperature value to finish the freeze protection mode";

  CDL.Interfaces.RealInput THeaSet(
    final unit="K", quantity="ThermodynamicTemperature")
    "Occupied heating setpoint temperature"
    annotation (Placement(transformation(extent={{-260,70},{-220,110}}),
        iconTransformation(extent={{-120,-32},{-100,-12}})));
  CDL.Interfaces.RealInput TCooSet(
    final unit="K", quantity="ThermodynamicTemperature")
    "Occupied cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-260,40},{-220,80}}),
        iconTransformation(extent={{-120,-56},{-100,-36}})));
  CDL.Interfaces.RealInput TZon[numOfZon](
    final unit="K", quantity="ThermodynamicTemperature")
    "Temperature of each zone"
    annotation (Placement(transformation(extent={{-260,-30},{-220,10}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  CDL.Interfaces.RealInput TUnoCooSet(
    final unit="K", quantity="ThermodynamicTemperature")
    "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-260,-290},{-220,-250}}),
        iconTransformation(extent={{-120,-100},{-100,-80}})));
  CDL.Interfaces.RealInput TUnoHeaSet(
    final unit="K", quantity="ThermodynamicTemperature")
    "Unoccupied heating setpoint temperature"
    annotation (Placement(transformation(extent={{-260,-70},{-220,-30}}),
        iconTransformation(extent={{-120,-78},{-100,-58}})));
  CDL.Interfaces.RealInput warUpTim[numOfZon](
    final unit="s", quantity="Time")
    "Warm-up time retrieved from optimal warm-up block"
    annotation (Placement(transformation(extent={{-260,96},{-220,136}}),
        iconTransformation(extent={{-120,12},{-100,32}})));
  CDL.Interfaces.RealInput cooDowTim[numOfZon](
    final unit="s", quantity="Time")
    "Cool-down time retrieved from optimal control-down block"
    annotation (Placement(transformation(extent={{-260,176},{-220,216}}),
        iconTransformation(extent={{-120,34},{-100,54}})));
  CDL.Interfaces.RealInput tNexOcc(
    final unit="s", quantity="Time")
    "Time to next occupied period" annotation (
      Placement(transformation(extent={{-260,240},{-220,280}}),
        iconTransformation(extent={{-120,56},{-100,76}})));
  CDL.Interfaces.BooleanInput uOcc "True/False if the zones are occupied"
    annotation (Placement(transformation(extent={{-260,280},{-220,320}}),
        iconTransformation(extent={{-120,80},{-100,100}})));
  CDL.Interfaces.BooleanInput uWinSta[numOfZon] "Window open/close status"
    annotation (Placement(transformation(extent={{-260,10},{-220,50}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-110})));
  CDL.Interfaces.IntegerOutput opeMod "Operation mode" annotation (Placement(
        transformation(extent={{460,-30},{480,-10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  CDL.Interfaces.IntegerOutput freProAlaLev "Level 3 alarm: freeze protection"
    annotation (Placement(transformation(extent={{460,-150},{480,-130}}),
        iconTransformation(extent={{100,-60},{120,-40}})));

  CDL.Continuous.Constant occModInd(
    k=Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Constants.OperationModes.occModInd)
    "Occupied mode index"
    annotation (Placement(transformation(extent={{140,290},{160,310}})));
  CDL.Continuous.Constant unoPerInd(final k=0)
    "Index to indicate unoccupied period"
    annotation (Placement(transformation(extent={{-160,220},{-140,240}})));
  CDL.Continuous.MinMax minMax(final nin=numOfZon)
    "Find the maximum cool down time"
    annotation (Placement(transformation(extent={{-140,184},{-120,204}})));
  CDL.Continuous.MinMax minMax1(final nin=numOfZon)
    "Find the maximum warm-up time"
    annotation (Placement(transformation(extent={{-140,104},{-120,124}})));
  CDL.Logical.Switch corCooDowTim "Corrected cool down period"
    annotation (Placement(transformation(extent={{0,170},{20,190}})));
  CDL.Logical.Switch corWarUpTim "Corrected warm-up period"
    annotation (Placement(transformation(extent={{0,150},{20,130}})));
  CDL.Continuous.Gain cooDowInd(
    final k=Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Constants.OperationModes.cooDowInd)
    "Cool down mode: 2nd rank"
    annotation (Placement(transformation(extent={{240,180},{260,200}})));
  CDL.Continuous.Gain warUpInd(
    final k=Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Constants.OperationModes.warUpInd)
    "Warm-up mode: 4th rank"
    annotation (Placement(transformation(extent={{240,140},{260,160}})));
  CDL.Continuous.Sum sum1(nin=numOfZon)
    "Sum up number of zones that have temperature being lower than setpoint"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  CDL.Logical.GreaterEqualThreshold greEquThr(final threshold=5)
    "Whether or not the number of \"cold\" zone is more than 5"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  CDL.Logical.GreaterEqualThreshold greEquThr1(final threshold=numOfZon)
    "Whether or not all the zones are \"cold\" zone"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  CDL.Logical.Hysteresis hys(
    uLow=-0.5*bouLim,
    uHigh=0.5*bouLim,
    pre_y_start=false)
    "Whether or not the unoccupied heating setpoint is higher than minimum 
    zone temperature by bouLim"
    annotation (Placement(transformation(extent={{140,-60},{160,-40}})));
  CDL.Continuous.MinMax minMaxZonTem(final nin=numOfZon)
    "Min/Max of zone temperature among all zones"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  CDL.Continuous.Gain setBacInd(
    final k=Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Constants.OperationModes.setBacInd)
    "Set-back mode: 5th rank"
    annotation (Placement(transformation(extent={{220,-20},{240,0}})));
  CDL.Logical.FallingEdge falEdg
    "Whether or not the unoccupied heating setpoint  becomes lower than 
    minimum zone temperature: true to false"
    annotation (Placement(transformation(extent={{180,-60},{200,-40}})));
  CDL.Logical.Latch lat
    "if all zone temperature are higher than unoccupied heating setpoint 
    by bouLim, then the setback mode should be off."
    annotation (Placement(transformation(extent={{140,-20},{160,0}})));
  CDL.Logical.Latch lat1
    "if all zone temperature are higher than freProEndVal, then freeze 
    protection setback mode should be off."
    annotation (Placement(transformation(extent={{140,-120},{160,-100}})));
  CDL.Continuous.Gain freProSetBacInd(
    final k=Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Constants.OperationModes.freProInd)
    "Freeze protection setback mode: 6th rank"
    annotation (Placement(transformation(extent={{220,-120},{240,-100}})));
  CDL.Continuous.Sum sum2(final nin=numOfZon)
    "Sum up number of zones that have temperature being higher than setpoint"
    annotation (Placement(transformation(extent={{0,-220},{20,-200}})));
  CDL.Logical.GreaterEqualThreshold greEquThr2(threshold=5)
    "Whether or not the number of \"hot\" zone is more than 5"
    annotation (Placement(transformation(extent={{40,-220},{60,-200}})));
  CDL.Logical.GreaterEqualThreshold greEquThr3(final threshold=numOfZon)
    "Whether or not all the zones are \"hot\" zone"
    annotation (Placement(transformation(extent={{40,-250},{60,-230}})));
  CDL.Logical.Hysteresis hys1(
    pre_y_start=false,
    uLow=-0.5*bouLim,
    uHigh=0.5*bouLim)
    "Whether or not the unoccupied cooling setpoint is higher than maximum 
    zone temperature by bouLim"
    annotation (Placement(transformation(extent={{140,-260},{160,-240}})));
  CDL.Logical.Latch lat2
    annotation (Placement(transformation(extent={{140,-220},{160,-200}})));
  CDL.Continuous.Gain setUpInd(
    final k=Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Constants.OperationModes.setUpInd) "Setup mode: 3th rank"
    annotation (Placement(transformation(extent={{220,-220},{240,-200}})));
  CDL.Logical.FallingEdge falEdg1
    "Whether or not the unoccupied cooling setpoint  becomes higher than 
    maximum zone temperature: true to false"
    annotation (Placement(transformation(extent={{180,-260},{200,-240}})));
  CDL.Continuous.Gain unoInd(
    final k=Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Constants.OperationModes.unoModInd)   "Unoccupied mode: 7th rank"
    annotation (Placement(transformation(extent={{220,-320},{240,-300}})));
  CDL.Integers.Add3 add3Int "Sum of the three inputs"
   annotation (Placement(transformation(extent={{360,180},{380,200}})));
  CDL.Integers.Add addInt1 "Sum of the two inputs"
   annotation (Placement(transformation(extent={{360,-70},{380,-50}})));
  CDL.Integers.Add addInt2 "Sum of the two inputs"
    annotation (Placement(transformation(extent={{360,-270},{380,-250}})));
  CDL.Integers.Add3 add3Int1 "Sum of the three inputs"
   annotation (Placement(transformation(extent={{420,-70},{440,-50}})));
  CDL.Continuous.Gain freProAlaInd(k=3) "Freeze protection alarm: level 3"
    annotation (Placement(transformation(extent={{220,-160},{240,-140}})));
  CDL.Continuous.Product pro[numOfZon]
    "Decide if the cool down time of one zone should be ignored: if window 
    open, then output zero, otherwise, output cooDowTim[zone] "
    annotation (Placement(transformation(extent={{-180,180},{-160,200}})));
  CDL.Continuous.Product pro1[numOfZon]
    "Decide if the warm-up time of one zone should be ignored: if window 
    open, then output zero, otherwise, output warUpTim[zone] "
    annotation (Placement(transformation(extent={{-180,100},{-160,120}})));
  CDL.Continuous.Add add2(final k1=+1, final k2=-1)
    "Calculate the difference between minimum zone temperature and 
    unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  CDL.Continuous.Add add1(final k1=+1, final k2=-1)
    "Calculate the difference between maximum zone temperature and 
    unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{80,-280},{100,-260}})));
  CDL.Logical.Hysteresis hys2(
    uLow=-10,
    uHigh=10,
    pre_y_start=true)
    "Whether or not the maximum cool-down time is more than allowed 
    cool-down time, with deadband range of 20 seconds"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  CDL.Logical.Hysteresis hys3(
    uLow=-10,
    uHigh=10,
    pre_y_start=true)
    "Whether or not the maximum warm-up time is more than allowed warm-up 
    time, with deadband range of 20 seconds"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));
  CDL.Continuous.Add add5(final k1=-1, final k2=+1)
    "Calculate differential between time-to-next-occupancy and the 
    cool-down time"
    annotation (Placement(transformation(extent={{60,180},{80,200}})));
  CDL.Logical.Hysteresis hys4(
    pre_y_start=false,
    uLow=-10,
    uHigh=10)
    "Whether or not the cool-down model should be activated, with deadband 
    range of 20 s"
    annotation (Placement(transformation(extent={{100,180},{120,200}})));
  CDL.Logical.Hysteresis hys5(
    pre_y_start=false,
    uLow=-10,
    uHigh=10)
    "Whether or not the warm-up model should be activated, with deadband 
    range of 20 s"
    annotation (Placement(transformation(extent={{100,140},{120,160}})));
  CDL.Continuous.Add add6(final k1=-1, final k2=+1)
    "Calculate differential between time-to-next-occupancy and the warm-up time"
    annotation (Placement(transformation(extent={{60,140},{80,160}})));
  CDL.Continuous.Add add7(final k1=+1, final k2=-1)
    "Calculate differential between minimum zone temperature and the 
    heating setpoint"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  CDL.Logical.Hysteresis hys6(
    pre_y_start=false,
    uLow=-0.1,
    uHigh=0.1) "Whether or not the system should run in warm-up mode"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  CDL.Continuous.Add add8(final k1=-1, final k2=+1)
    "Calculate differential between maximum zone temperature and the cooling 
    setpoint"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  CDL.Logical.Hysteresis hys7(
    pre_y_start=false,
    uLow=-0.1,
    uHigh=0.1) "Whether or not the system should run in cool-down mode"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  CDL.Continuous.Add add9[numOfZon](
    each k1=-1,
    each k2=+1) "Calculate zone temperature difference to setpoint"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  CDL.Logical.Hysteresis hys8[numOfZon](
    each pre_y_start=false,
    each uLow=-0.1,
    each uHigh=0.1)
    "Whether or not the zone temperature is lower then setpoint, with 
    deadband of 0.2 degC"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  CDL.Logical.Hysteresis hys9(
    pre_y_start=false,
    uLow=-0.1,
    uHigh=0.1)
    "Whether or not any zone temperature is lower than freProThrVal, with 
    deadband of 0.2 degC"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  CDL.Continuous.AddParameter addPar(p=freProThrVal, final k=-1)
    "Calculate differential between minimum zone temperature and freeze 
    protection threshold temperature"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  CDL.Logical.Hysteresis hys10(
    pre_y_start=false,
    uLow=-0.1,
    uHigh=0.1)
    "Whether or not all zone temperature are higher than freProEndVal, with 
    deadband of 0.2 degC"
    annotation (Placement(transformation(extent={{40,-160},{60,-140}})));
  CDL.Continuous.AddParameter addPar1(final k=1, p=(-1)*freProEndVal)
    "Calculate differential between maximum zone temperature and the freeze 
    protection ending threshold value"
    annotation (Placement(transformation(extent={{0,-160},{20,-140}})));
  CDL.Continuous.Add add10[numOfZon](
    each k1=+1,
    each k2=-1) "Calculate zone temperature difference to setpoint"
    annotation (Placement(transformation(extent={{-160,-220},{-140,-200}})));
  CDL.Logical.Hysteresis hys11[numOfZon](
    each pre_y_start=false,
    each uLow=-0.1,
    each uHigh=0.1)
    "Whether or not the zone temperature is higher than setpoint, with 
    deadband of 0.2 degC"
    annotation (Placement(transformation(extent={{-120,-220},{-100,-200}})));

  CDL.Continuous.AddParameter addPar2(p=preWarCooTim, final k=-1)
    "Calculate the differential between maximum cool down time and the 
    allowed maximum cool down time"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  CDL.Continuous.AddParameter addPar3(p=preWarCooTim, final k=-1)
    "Calculate the differential between maximum warm-up time and the 
    allowed maximum warm-up time"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  CDL.Continuous.Constant maxWarCooTime(k=preWarCooTim)
    "Allowed maximum warm-up/cool-down time"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));

protected
  CDL.Conversions.RealToInteger occMod "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{300,240},{320,260}})));
  CDL.Conversions.RealToInteger cooDowMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{300,180},{320,200}})));
  CDL.Conversions.RealToInteger warUpMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{300,140},{320,160}})));
  CDL.Conversions.RealToInteger setBacMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{300,-20},{320,0}})));
  CDL.Conversions.RealToInteger freProSetBacMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{300,-120},{320,-100}})));
  CDL.Conversions.RealToInteger setUpMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{300,-220},{320,-200}})));
  CDL.Conversions.BooleanToReal booToRea "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{200,140},{220,160}})));
  CDL.Conversions.BooleanToReal booToRea1 "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{200,180},{220,200}})));
  CDL.Conversions.RealToInteger unoMod "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{300,-320},{320,-300}})));
  CDL.Conversions.BooleanToReal booToRea7 "Convert Boolean to Real "
    annotation (Placement(transformation(extent={{180,-320},{200,-300}})));
  CDL.Conversions.BooleanToReal booToRea6 "Convert Boolean to Real "
    annotation (Placement(transformation(extent={{180,-220},{200,-200}})));
  CDL.Conversions.BooleanToReal booToRea5[numOfZon]
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{-80,-220},{-60,-200}})));
  CDL.Conversions.BooleanToReal booToRea4 "Convert Boolean to Real "
    annotation (Placement(transformation(extent={{180,-120},{200,-100}})));
  CDL.Conversions.BooleanToReal booToRea3 "Convert Boolean to Real "
    annotation (Placement(transformation(extent={{180,-20},{200,0}})));
  CDL.Conversions.BooleanToReal booToRea2[numOfZon]
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  CDL.Conversions.BooleanToReal booToRea8 "Convert Boolean to Real "
    annotation (Placement(transformation(extent={{180,-160},{200,-140}})));
  CDL.Conversions.RealToInteger freProAla "Freeze protection alarm"
    annotation (Placement(transformation(extent={{300,-160},{320,-140}})));
  CDL.Conversions.BooleanToReal booToRea9[numOfZon]
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  CDL.Logical.Not not1[numOfZon] "Logical not"
    annotation (Placement(transformation(extent={{-200,20},{-180,40}})));
  CDL.Logical.Not not2 "Logical not"
   annotation (Placement(transformation(extent={{180,-360},{200,-340}})));
  CDL.Logical.And and1 "Whether or not the warm-up time should be activated"
    annotation (Placement(transformation(extent={{140,140},{160,160}})));
  CDL.Logical.And and2 "Whether or not the cool-down time should be activated"
    annotation (Placement(transformation(extent={{140,180},{160,200}})));
  CDL.Logical.Or or1
    "Whether or not the number of \"cold\" zone is more than 5 or all 
    zones are cold"
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  CDL.Logical.Or3 or3
    "Whether or not it is in \"Occupied\"/\"Cool-down\"/\"Warm-up\" mode"
    annotation (Placement(transformation(extent={{80,22},{100,42}})));
  CDL.Logical.Or or4
    "Whether or not the number of \"hot\" zone is more than 5 or all 
    zones are cold"
    annotation (Placement(transformation(extent={{80,-220},{100,-200}})));
  CDL.Logical.Or3 or5
    "If it is in \"Setback\"/\"Setback_freezeProtection\"/\"Setup\" mode"
    annotation (Placement(transformation(extent={{140,-320},{160,-300}})));
  CDL.Logical.Or or6 "If it is in any of the 6 modes except unoccupied mode"
    annotation (Placement(transformation(extent={{140,-360},{160,-340}})));
  CDL.Logical.Switch swi
    "Switch between occupied mode index and unoccupied period index"
    annotation (Placement(transformation(extent={{260,240},{280,260}})));
  CDL.Logical.Switch swi1[numOfZon]
    "Decide if the temperature difference to setpoint should be ignored: 
    if the zone window is open, then output setpoint temperature, otherwise, 
    output zone temperature"
    annotation (Placement(transformation(extent={{-200,-20},{-180,-40}})));
  CDL.Logical.Switch swi2[numOfZon]
    "Decide if the temperature difference to setpoint should be ignored: 
    if the zone window is open, then output setpoint temperature, otherwise, 
    output zone temperature"
    annotation (Placement(transformation(extent={{-200,-200},{-180,-220}})));
  CDL.Logical.Switch swi3
    "If the Cool-down/warm-up/Occupied mode is on, then setback mode should 
    not be activated."
    annotation (Placement(transformation(extent={{260,-20},{280,0}})));
  CDL.Logical.Switch swi4
    "If the Cool-down/warm-up/Occupied mode is on, then freeze protection 
    setback mode should not be activated."
    annotation (Placement(transformation(extent={{260,-120},{280,-100}})));
  CDL.Logical.Switch swi5
    "If the Cool-down/warm-up/Occupied mode is on, then setup mode should 
    not be activated."
    annotation (Placement(transformation(extent={{260,-220},{280,-200}})));

equation
  connect(swi.y, occMod.u)
    annotation (Line(points={{281,250},{290,250},{298,250}},
      color={0,0,127}));
  connect(occModInd.y, swi.u1)
    annotation (Line(points={{161,300},{200,300},{200,258},{258,258}},
      color={0,0,127}));
  connect(unoPerInd.y, swi.u3)
    annotation (Line(points={{-139,230},{182,230},{182,242},{258,242}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(minMax.yMax, corCooDowTim.u1)
    annotation (Line(points={{-119,200},{-12,200},{-12,188},{-2,188}},
      color={0,0,127}));
  connect(booToRea1.y,cooDowInd. u)
    annotation (Line(points={{221,190},{238,190}},
      color={0,0,127}));
  connect(booToRea.y,warUpInd. u)
    annotation (Line(points={{221,150},{221,150},{238,150}},
      color={0,0,127}));

  for i in 1:numOfZon loop
    connect(booToRea2[i].y, sum1.u[i])
      annotation (Line(points={{-19,-10},{-19,-10},{-2,-10}},
        color={0,0,127}));
    connect(booToRea5[i].y, sum2.u[i])
      annotation (Line(points={{-59,-210},{-59,-210},{-2,-210}},
        color={0,0,127}));
    connect(uWinSta[i], swi1[i].u2)
      annotation (Line(points={{-240,30},{-214,30},
            {-214,-8},{-214,-30},{-202,-30}}, color={255,0,255}));
    connect(TUnoHeaSet, swi1[i].u1)
      annotation (Line(points={{-240,-50},{-210,-50},{-210,-38},{-202,-38}},
        color={0,0,127}));
    connect(TZon[i], swi1[i].u3)
      annotation (Line(points={{-240,-10},{-210,-10}, {-210,-22},{-202,-22}},
        color={0,0,127}));
    connect(uWinSta[i], swi2[i].u2)
      annotation (Line(points={{-240,30},{-214,30},{-214,-100},{-214,-210},{-202,-210}},
        color={255,0,255}));
    connect(TUnoCooSet, swi2[i].u1)
      annotation (Line(points={{-240,-270},{-212,-270}, {-212,-218},{-202,-218}},
        color={0,0,127}));
    connect(TZon[i], swi2[i].u3)
      annotation (Line(points={{-240,-10},{-212,-10},{-212,-202},{-202,-202}},
        color={0,0,127}));
    connect(cooDowTim[i], pro[i].u1)
      annotation (Line(points={{-240,196},{-240,196}, {-182,196}},
        color={0,0,127}));
    connect(warUpTim[i], pro1[i].u1)
      annotation (Line(points={{-240,116},{-240,116},{-182,116}},
        color={0,0,127}));
    connect(pro[i].y, minMax.u[i])
      annotation (Line(points={{-159,190},{-150,190},{-150,194},{-142,194}},
        color={0,0,127}));
    connect(pro1[i].y, minMax1.u[i])
      annotation (Line(points={{-159,110},{-150,110},{-150,114},{-142,114}},
        color={0,0,127}));
    connect(booToRea9[i].y, pro[i].u2)
      annotation (Line(points={{-139,30},{-139,30},{-120,30},{-120,80},
        {-200,80},{-200,184},{-182,184}}, color={0,0,127}));
    connect(booToRea9[i].y, pro1[i].u2)
      annotation (Line(points={{-139,30},{-120,
            30},{-120,80},{-200,80},{-200,104},{-182,104}}, color={0,0,127}));
    connect(swi1[i].y, add9[i].u1)
      annotation (Line(points={{-179,-30},{-179,-30}, {-164,-30},{-164,-4},
        {-142,-4}}, color={0,0,127}));
    connect(TUnoHeaSet, add9[i].u2)
      annotation (Line(points={{-240,-50},{-198,-50},{-156,-50},{-156,-16},
        {-142,-16}}, color={0,0,127}));
    connect(add9[i].y, hys8[i].u)
      annotation (Line(points={{-119,-10},{-82,-10}},  color={0,0,127}));
    connect(hys8[i].y, booToRea2[i].u)
      annotation (Line(points={{-59,-10},{-50,-10}, {-42,-10}},
        color={255,0,255}));
    connect(swi2[i].y, add10[i].u1)
      annotation (Line(points={{-179,-210},{-179,-210},{-170,-210},{-170,-204},
        {-162,-204}}, color={0,0,127}));
    connect(TUnoCooSet, add10[i].u2)
      annotation (Line(points={{-240,-270},{-240,-270},{-170,-270},{-170,-216},
        {-162,-216}}, color={0,0,127}));
    connect(add10[i].y, hys11[i].u)
      annotation (Line(points={{-139,-210},{-139,-210},{-122,-210}},
        color={0,0,127}));
    connect(hys11[i].y, booToRea5[i].u)
      annotation (Line(points={{-99,-210},{-82,-210}}, color={255,0,255}));
    connect(uWinSta[i], not1[i].u)
      annotation (Line(points={{-240,30},{-222,30},{-202,30}},
        color={255,0,255}));
    connect(not1[i].y, booToRea9[i].u)
      annotation (Line(points={{-179,30},{-162,30}},           color={255,0,255}));
  end for;

  connect(sum1.y, greEquThr.u)
    annotation (Line(points={{21,-10},{38,-10}}, color={0,0,127}));
  connect(sum1.y, greEquThr1.u)
    annotation (Line(points={{21,-10},{30,-10},{30,-40},{38,-40}},
      color={0,0,127}));
  connect(greEquThr.y, or1.u1)
    annotation (Line(points={{61,-10},{69.5,-10},{78,-10}},
      color={255,0,255}));
  connect(greEquThr1.y, or1.u2)
    annotation (Line(points={{61,-40},{68,-40},{68,-18},{78,-18}},
      color={255,0,255}));
  connect(TZon, minMaxZonTem.u[1:numOfZon])
    annotation (Line(points={{-240,-10}, {-160,-10},{-160,-80},{-142,-80}},
      color={0,0,127}));
  connect(or1.y, lat.u)
    annotation (Line(points={{101,-10},{110,-10},{120,-10},{139,-10}},
      color={255,0,255}));
  connect(falEdg.y, lat.u0)
    annotation (Line(points={{201,-50},{220,-50},{220,-30},
          {120,-30},{120,-16},{139,-16}},      color={255,0,255}));
  connect(lat.y, booToRea3.u)
    annotation (Line(points={{161,-10},{169.5,-10},{178,-10}},
      color={255,0,255}));
  connect(booToRea3.y,setBacInd. u)
    annotation (Line(points={{201,-10},{209.5,-10},{218,-10}},
      color={0,0,127}));
  connect(unoPerInd.y, swi3.u1)
    annotation (Line(points={{-139,230},{-139,230},{182,230},{182,30},
      {252,30},{252,-2},{258,-2}},  color={0,0,127},
      pattern=LinePattern.Dash));
  connect(or3.y, swi3.u2)
    annotation (Line(points={{101,32},{101,32},{250,32},{250,-10},{258,-10}},
      color={255,0,255}));
  connect(setBacInd.y, swi3.u3)
    annotation (Line(points={{241,-10},{248,-10},{248,-18},{258,-18}},
      color={0,0,127}));
  connect(lat1.y, booToRea4.u)
    annotation (Line(points={{161,-110},{178,-110}}, color={255,0,255}));
  connect(booToRea4.y, freProSetBacInd.u)
    annotation (Line(points={{201,-110},{210,-110},{218,-110}},
      color={0,0,127}));
  connect(freProSetBacInd.y, swi4.u3)
    annotation (Line(points={{241,-110},{246,-110},{246,-118},{258,-118}},
      color={0,0,127}));
  connect(or3.y, swi4.u2)
    annotation (Line(points={{101,32},{101,32},{112,32},{112,-80},{248,-80},
      {248,-110},{258,-110}}, color={255,0,255}));
  connect(unoPerInd.y, swi4.u1)
    annotation (Line(points={{-139,230},{-139,230},{182,230},{182,30},
      {114,30},{114,-78},{250,-78},{250,-102},{258,-102}},
      color={0,0,127}, pattern=LinePattern.Dash));
  connect(sum2.y, greEquThr2.u)
    annotation (Line(points={{21,-210},{38,-210}}, color={0,0,127}));
  connect(sum2.y, greEquThr3.u)
    annotation (Line(points={{21,-210},{30,-210},{30,-240},{38,-240}},
      color={0,0,127}));
  connect(greEquThr2.y, or4.u1)
    annotation (Line(points={{61,-210},{78,-210}}, color={255,0,255}));
  connect(greEquThr3.y, or4.u2)
    annotation (Line(points={{61,-240},{68,-240},{68,-218},{78,-218}},
      color={255,0,255}));
  connect(hys1.y, falEdg1.u)
    annotation (Line(points={{161,-250},{178,-250}}, color={255,0,255}));
  connect(or4.y, lat2.u)
    annotation (Line(points={{101,-210},{139,-210}}, color={255,0,255}));
  connect(falEdg1.y, lat2.u0)
    annotation (Line(points={{201,-250},{220,-250},{220,-228},{120,-228},
      {120,-216},{139,-216}}, color={255,0,255}));
  connect(lat2.y, booToRea6.u)
    annotation (Line(points={{161,-210},{170,-210},{178,-210}},
      color={255,0,255}));
  connect(booToRea6.y, setUpInd.u)
    annotation (Line(points={{201,-210},{210,-210},{218,-210}},
      color={0,0,127}));
  connect(setUpInd.y, swi5.u3)
    annotation (Line(points={{241,-210},{248,-210},{248,-218},{258,-218}},
      color={0,0,127}));
  connect(or3.y, swi5.u2)
    annotation (Line(points={{101,32},{101,32},{112,32},{112,-180},{250,-180},
      {250,-210},{258,-210}},  color={255,0,255}));
  connect(unoPerInd.y, swi5.u1)
    annotation (Line(points={{-139,230},{-139,230},{182,230},{182,30},{114,30},
      {114,-182},{252,-182},{252,-202},{258,-202}},  color={0,0,127},
      pattern=LinePattern.Dash));
  connect(swi3.y, setBacMod.u)
    annotation (Line(points={{281,-10},{289.5,-10},{298,-10}},
      color={0,0,127}));
  connect(swi4.y, freProSetBacMod.u)
    annotation (Line(points={{281,-110},{298,-110}}, color={0,0,127}));
  connect(swi5.y, setUpMod.u)
    annotation (Line(points={{281,-210},{289.5,-210},{298,-210}},
      color={0,0,127}));
  connect(lat.y, or5.u1)
    annotation (Line(points={{161,-10},{168,-10},{168,20},{112,20},{112,-302},
      {138,-302}}, color={255,0,255}));
  connect(lat1.y, or5.u2)
    annotation (Line(points={{161,-110},{168,-110},{168,-90},{112,-90},
      {112,-310},{138,-310}},  color={255,0,255}));
  connect(lat2.y, or5.u3)
    annotation (Line(points={{161,-210},{166,-210},{166,-190},{112,-190},
      {112,-318},{138,-318}},  color={255,0,255}));
  connect(or5.y, or6.u1)
    annotation (Line(points={{161,-310},{166,-310},{166,-332},{114,-332},
      {114,-350},{128,-350},{138,-350}}, color={255,0,255}));
  connect(or3.y, or6.u2)
    annotation (Line(points={{101,32},{101,32},{112,32},{112,-358},{138,-358}},
      color={255,0,255}));
  connect(or6.y, not2.u)
    annotation (Line(points={{161,-350},{170,-350},{178,-350}},
      color={255,0,255}));
  connect(not2.y, booToRea7.u)
    annotation (Line(points={{201,-350},{220,-350},{220,-332},{172,-332},
      {172,-310},{178,-310}}, color={255,0,255}));
  connect(booToRea7.y, unoInd.u)
    annotation (Line(points={{201,-310},{218,-310}}, color={0,0,127}));
  connect(unoInd.y, unoMod.u)
    annotation (Line(points={{241,-310},{269.5,-310}, {298,-310}},
      color={0,0,127}));
  connect(occMod.y, add3Int.u1)
    annotation (Line(points={{321,250},{340,250},{340,198},{358,198}},
      color={255,127,0}));
  connect(cooDowMod.y, add3Int.u2)
    annotation (Line(points={{321,190},{340,190},{358,190}},
      color={255,127,0}));
  connect(warUpMod.y, add3Int.u3)
    annotation (Line(points={{321,150},{330,150},{340,150},{340,182},{358,182}},
      color={255,127,0}));
  connect(setBacMod.y, addInt1.u1)
    annotation (Line(points={{321,-10},{340,-10},{340,-54},{358,-54}},
      color={255,127,0}));
  connect(freProSetBacMod.y, addInt1.u2)
    annotation (Line(points={{321,-110},{330,-110},{340,-110},{340,-66},
      {358,-66}},  color={255,127,0}));
  connect(setUpMod.y, addInt2.u1)
    annotation (Line(points={{321,-210},{340,-210}, {340,-254},{358,-254}},
      color={255,127,0}));
  connect(unoMod.y, addInt2.u2)
    annotation (Line(points={{321,-310},{340,-310},{340,-266},{358,-266}},
      color={255,127,0}));
  connect(add3Int.y, add3Int1.u1)
    annotation (Line(points={{381,190},{400,190},{400,-52},{418,-52}},
      color={255,127,0}));
  connect(addInt1.y, add3Int1.u2)
    annotation (Line(points={{381,-60},{394,-60},{418,-60}},color={255,127,0}));
  connect(addInt2.y, add3Int1.u3)
    annotation (Line(points={{381,-260},{400,-260},{400,-68},{418,-68}},
      color={255,127,0}));
  connect(add3Int1.y, opeMod)
    annotation (Line(points={{441,-60},{444,-60},{450,-60},{450,-20},{470,-20}},
      color={255,127,0}));
  connect(lat1.y, booToRea8.u)
    annotation (Line(points={{161,-110},{168,-110},{168,-150},{178,-150}},
      color={255,0,255}));
  connect(booToRea8.y, freProAlaInd.u)
    annotation (Line(points={{201,-150},{209.5,-150},{218,-150}},
      color={0,0,127}));
  connect(freProAlaInd.y, freProAla.u)
    annotation (Line(points={{241,-150},{270,-150},{298,-150}}, color={0,0,127}));
  connect(freProAla.y, freProAlaLev)
    annotation (Line(points={{321,-150},{330,-150},{340,-150},{340,-140},
      {470,-140}}, color={255,127,0}));
  connect(cooDowInd.y, cooDowMod.u)
    annotation (Line(points={{261,190},{261,190},{298,190}}, color={0,0,127}));
  connect(warUpInd.y, warUpMod.u)
    annotation (Line(points={{261,150},{280,150},{298,150}}, color={0,0,127}));
  connect(and2.y, booToRea1.u)
    annotation (Line(points={{161,190},{198,190}}, color={255,0,255}));
  connect(and1.y, booToRea.u)
    annotation (Line(points={{161,150},{198,150}}, color={255,0,255}));
  connect(and2.y, or3.u2)
    annotation (Line(points={{161,190},{161,190},{176,190},
      {176,60},{40,60},{40,32},{78,32}}, color={255,0,255}));
  connect(and1.y, or3.u1)
    annotation (Line(points={{161,150},{161,150},{178,150},
          {178,58},{42,58},{42,40},{78,40}}, color={255,0,255}));
  connect(uOcc, swi.u2)
    annotation (Line(points={{-240,300},{-240,300},{38,300},
          {38,250},{258,250}}, color={255,0,255}));
  connect(uOcc, or3.u3)
    annotation (Line(points={{-240,300},{-240,300},{38,300},
          {38,24},{78,24}},color={255,0,255}));
  connect(minMaxZonTem.yMin, add2.u2)
    annotation (Line(points={{-119,-86},{0,-86},{0,-76},{78,-76}},
      color={0,0,127}));
  connect(add2.y, hys.u)
    annotation (Line(points={{101,-70},{108,-70},{108,-50},{138,-50}},
      color={0,0,127}));
  connect(TUnoHeaSet, add2.u1)
    annotation (Line(points={{-240,-50},{-240,-50},{0,-50},{0,-64},{78,-64}},
      color={0,0,127}));
  connect(minMaxZonTem.yMax, add1.u1)
    annotation (Line(points={{-119,-74},{-40,-74},{-40,-264},{78,-264}},
      color={0,0,127}));
  connect(TUnoCooSet, add1.u2)
    annotation (Line(points={{-240,-270},{-40,-270},{-40,-276},{78,-276}},
      color={0,0,127}));
  connect(add1.y, hys1.u)
    annotation (Line(points={{101,-270},{108,-270},{108,-250},{138,-250}},
      color={0,0,127}));
  connect(hys.y, falEdg.u)
    annotation (Line(points={{161,-50},{178,-50}}, color={255,0,255}));
  connect(hys2.y, corCooDowTim.u2)
    annotation (Line(points={{-19,180},{-19,180},{-2,180}}, color={255,0,255}));
  connect(hys3.y, corWarUpTim.u2)
    annotation (Line(points={{-19,140},{-19,140},{-2,140}}, color={255,0,255}));
  connect(add5.y, hys4.u)
    annotation (Line(points={{81,190},{89.5,190},{98,190}}, color={0,0,127}));
  connect(hys4.y, and2.u1)
    annotation (Line(points={{121,190},{129.5,190},{138,190}},
      color={255,0,255}));
  connect(tNexOcc, add5.u1)
    annotation (Line(points={{-240,260},{-240,260},{36,260},{36,196},{58,196}},
      color={0,0,127}));
  connect(corCooDowTim.y, add5.u2)
    annotation (Line(points={{21,180},{40,180},{40,184},{58,184}},
      color={0,0,127}));
  connect(tNexOcc, add6.u1)
    annotation (Line(points={{-240,260},{-240,260},{36,260},{36,156},{58,156}},
      color={0,0,127}));
  connect(corWarUpTim.y, add6.u2)
    annotation (Line(points={{21,140},{40,140},{40,144},{58,144}},
      color={0,0,127}));
  connect(add6.y, hys5.u)
    annotation (Line(points={{81,150},{89.5,150},{98,150}}, color={0,0,127}));
  connect(hys5.y, and1.u1)
    annotation (Line(points={{121,150},{129.5,150},{138,150}},color={255,0,255}));
  connect(minMaxZonTem.yMin, add7.u2)
    annotation (Line(points={{-119,-86},{-100,-86},{-100,84},{-82,84}},
      color={0,0,127}));
  connect(add7.y, hys6.u)
    annotation (Line(points={{-59,90},{-59,90},{-42,90}}, color={0,0,127}));
  connect(hys6.y, and1.u2)
    annotation (Line(points={{-19,90},{-19,90},{130,90},{130,142},{138,142}},
                  color={255,0,255}));
  connect(THeaSet, add7.u1)
    annotation (Line(points={{-240,90},{-170,90},{-100,90},
          {-100,96},{-82,96}}, color={0,0,127}));
  connect(minMaxZonTem.yMax, add8.u2)
    annotation (Line(points={{-119,-74},{-96,-74},
          {-96,54},{-82,54}}, color={0,0,127}));
  connect(add8.y, hys7.u)
    annotation (Line(points={{-59,60},{-54,60},{-42,60}}, color={0,0,127}));
  connect(hys7.y, and2.u2)
    annotation (Line(points={{-19,60},{-2,60},{-2,92},{128,92},{128,182},
      {138,182}}, color={255,0,255}));
  connect(TCooSet, add8.u1)
    annotation (Line(points={{-240,60},{-240,60},{-96,60},{-96,66},{-82,66}},
      color={0,0,127}));
  connect(minMaxZonTem.yMax, addPar.u)
    annotation (Line(points={{-119,-74},{-119,-74},{-40,-74},{-40,-110},
      {-2,-110}}, color={0,0,127}));
  connect(addPar.y, hys9.u)
    annotation (Line(points={{21,-110},{21,-110},{38,-110}}, color={0,0,127}));
  connect(hys9.y, lat1.u)
    annotation (Line(points={{61,-110},{139,-110}}, color={255,0,255}));
  connect(minMaxZonTem.yMin, addPar1.u)
    annotation (Line(points={{-119,-86},{-119,-86},{-36,-86},{-36,-148},
      {-36,-150},{-2,-150}}, color={0,0,127}));
  connect(addPar1.y, hys10.u)
    annotation (Line(points={{21,-150},{38,-150}}, color={0,0,127}));
  connect(hys10.y, lat1.u0)
    annotation (Line(points={{61,-150},{80,-150},{80,-116},
          {139,-116}}, color={255,0,255}));
  connect(minMax1.yMax, addPar3.u)
    annotation (Line(points={{-119,120},{-119,
          120},{-100,120},{-100,140},{-82,140}}, color={0,0,127}));
  connect(addPar2.y, hys2.u)
    annotation (Line(points={{-59,180},{-42,180}}, color={0,0,127}));
  connect(addPar3.y, hys3.u)
    annotation (Line(points={{-59,140},{-42,140}}, color={0,0,127}));
  connect(minMax.yMax, addPar2.u)
    annotation (Line(points={{-119,200},{-110,200},
          {-100,200},{-100,180},{-82,180}}, color={0,0,127}));
  connect(maxWarCooTime.y, corCooDowTim.u3)
    annotation (Line(points={{-119,160},
          {-66,160},{-12,160},{-12,172},{-2,172}}, color={0,0,127}));
  connect(minMax1.yMax, corWarUpTim.u1)
    annotation (Line(points={{-119,120},{
          -119,120},{-12,120},{-12,132},{-2,132}}, color={0,0,127}));
  connect(maxWarCooTime.y, corWarUpTim.u3)
    annotation (Line(points={{-119,160},
          {-66,160},{-12,160},{-12,148},{-2,148}}, color={0,0,127}));
  annotation (
  defaultComponentName = "opeModSel",
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-360},{460,320}}),
        graphics={
        Rectangle(
          extent={{-220,-294},{460,-360}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-220,-100},{460,-166}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-220,-192},{460,-280}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-220,22},{460,-90}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-220,320},{460,240}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-220,222},{460,42}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{368,316},{456,276}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Occupied mode"),
        Text(
          extent={{384,18},{454,-18}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Setback mode"),
        Text(
          extent={{382,-196},{452,-232}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Setup mode"),
        Text(
          extent={{358,-298},{454,-354}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Unoccupied mode"),
        Text(
          extent={{328,-94},{462,-148}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Freeze protection setback mode"),
        Text(
          extent={{366,100},{454,60}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Warm-up mode"),
        Text(
          extent={{364,148},{452,106}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Cool-down mode")}),
   Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,58},{-46,34}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="cooDowTim"),
        Text(
          extent={{-96,36},{-48,12}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="warUpTim"),
        Text(
          extent={{-96,12},{-58,-10}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="zonTem"),
        Text(
          extent={{-96,-50},{-28,-86}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="unoHeaSetTem"),
        Text(
          extent={{-96,-74},{-28,-106}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="unoCooSetTem"),
        Text(
          extent={{56,12},{94,-10}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="opeMode"),
        Text(
          extent={{56,-38},{94,-60}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="freProAla"),
        Text(
          extent={{-96,-2},{-28,-38}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="occHeaSetTem"),
        Text(
          extent={{-96,-28},{-28,-64}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="occCooSetTem"),
        Text(
          extent={{-120,144},{100,106}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-96,74},{-56,56}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="tNexOcc"),
        Text(
          extent={{-96,98},{-64,82}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uOcc"),
        Text(
          extent={{-20,7},{20,-7}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uWinSta",
          origin={0,-75},
          rotation=90)}),
   Documentation(info="<html>
<p>
This block outputs VAV system operation mode. It is implemented according to
ASHRAE guideline G36, PART5.C.6 (zone group operating modes).
The block has the modes listed below.
</p>
<h4>Occupied Mode</h4>
<p>
A Zone Group is in the <i>occupied mode</i> when
occupancy input <code>uOcc</code> is true. This input shall be retrieved from
other sequences that specifies occupancy variation and time remaining to the
next occupied period <code>tNexOcc</code>.
</p>
<h4>Warmup Mode</h4>
<p>
Warmup mode shall start based on the zone with the longest calculated warm up
time <code>warUpTim</code> requirement, but no earlier than 3 hours before
the start of the scheduled occupied period, and shall end at the scheduled
occupied start hour. Zones where the window switch indicates that a window
is open shall be ignored. Note that for each zone, the optimal warm-up time
<code>warUpTim</code> shall be obtained from an <i>Optimal Start</i>
sequences, computed in a separate block.
The figure below shows the sequence.
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/OperationModeSelector/Warm-upModeDefinition.png\"/>
</p>
<h4>Cool-Down Mode</h4>
<p>
Cool-down mode shall start based on the zone with the longest calculated
cool-down time <code>cooDowTim</code> requirement, but no earlier than 3 hours
before the start of the scheduled occupied period, and shall end at the
scheduled occupied start hour. Zones where the window switch indicates that a
window is open shall be ignored. Note that the each zone <code>cooDowTim</code>
shall be obtained from an <i>Optimal Start</i>
sequences, computed in a separate block.
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/OperationModeSelector/Cool-downModeDefinition.png\"/>
</p>
<h4>Setback Mode</h4>
<p>
During <i>unoccupied mode</i>, if any 5 zones (or all zones,
if fewer than 5) in the zone group fall below their unoccupied heating setpoints
<code>TUnoHeaSet</code>, the zone group shall enter <i>setback mode</i> until
all spaces in the zone group are <i>1.1</i>&deg;C (<i>2</i> F) above their unoccupied setpoints.
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/OperationModeSelector/SetbackModeDefinition.png\"/>
</p>
<h4>Freeze Protection Setback Mode</h4>
<p>
During <i>unoccupied Mode</i>, if
any single zone falls below <i>4.4</i>&deg;C (<i>40</i> F), the zone group shall enter
<i>setback mode</i> until all zones are above <i>7.2</i>&deg;C (<i>45</i> F),
and a Level 3 alarm <code>yFreProAla</code> shall be set.
</p>
<h4>Setup Mode</h4>
<p>
During <i>unoccupied mode</i>, if any 5 zones (or all zones,
if fewer than 5) in the zone rise above their unoccupied cooling setpoints
<code>TUnoCooSet</code>, the zone group shall enter <i>setup mode</i> until
all spaces in the zone group are <i>1.1</i>&deg;C (<i>2</i> F) below their unoccupied setpoints.
Zones where the window switch indicates that a window is open shall be ignored.
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/OperationModeSelector/SetupModeDefinition.png\"/>
</p>
<h4>Unoccupied Mode</h4>
<p>
<i>Unoccupied mode</i> shall be active if the zone group is not in any other mode.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 19, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end OperationModeSelector;
