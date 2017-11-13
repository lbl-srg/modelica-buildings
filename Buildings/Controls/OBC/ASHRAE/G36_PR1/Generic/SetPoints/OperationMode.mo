within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints;
block OperationMode "Block that outputs the operation mode"

  parameter Integer numZon(min=1) "Number of zones";
  parameter Modelica.SIunits.Time preWarCooTim = 10800
    "Maximum cool-down/warm-up time";
  parameter Modelica.SIunits.TemperatureDifference bouLim(min=0.5) = 1.1
    "Value limit to indicate the end of setback/setup mode";
  parameter Modelica.SIunits.Temperature freProThrVal = 277.55
    "Threshold zone temperature value to activate freeze protection mode";
  parameter Modelica.SIunits.Temperature freProEndVal = 280.35
    "Threshold zone temperature value to finish the freeze protection mode";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Occupied heating setpoint temperature"
    annotation (Placement(transformation(extent={{-300,70},{-260,110}}),
      iconTransformation(extent={{-120,-32},{-100,-12}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Occupied cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-300,40},{-260,80}}),
      iconTransformation(extent={{-120,-56},{-100,-36}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[numZon](
    each final unit="K",
    each quantity="ThermodynamicTemperature")
    "Temperature of each zone"
    annotation (Placement(transformation(extent={{-300,-30},{-260,10}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TUnoCooSet(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-300,-290},{-260,-250}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TUnoHeaSet(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Unoccupied heating setpoint temperature"
    annotation (Placement(transformation(extent={{-300,-70},{-260,-30}}),
      iconTransformation(extent={{-120,-78},{-100,-58}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput warUpTim[numZon](
    each final unit="s",
    each quantity="Time")
    "Warm-up time retrieved from optimal warm-up block"
    annotation (Placement(transformation(extent={{-300,96},{-260,136}}),
      iconTransformation(extent={{-120,12},{-100,32}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput cooDowTim[numZon](
    each final unit="s",
    each quantity="Time")
    "Cool-down time retrieved from optimal cool-down block"
    annotation (Placement(transformation(extent={{-300,176},{-260,216}}),
      iconTransformation(extent={{-120,34},{-100,54}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
    final unit="s", quantity="Time")
    "Time to next occupied period"
    annotation (Placement(transformation(extent={{-300,240},{-260,280}}),
      iconTransformation(extent={{-120,56},{-100,76}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "True/False if the zones are occupied"
    annotation (Placement(transformation(extent={{-300,280},{-260,320}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWinSta[numZon]
    "Window open/close status"
    annotation (Placement(transformation(extent={{-300,10},{-260,50}}),
      iconTransformation(extent={{-10,-10},{10,10}},rotation=90,origin={0,-110})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yOpeMod "Operation mode"
    annotation (Placement(transformation(extent={{460,-30},{480,-10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant occModInd(
    k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "Occupied mode "
    annotation (Placement(transformation(extent={{200,258},{220,278}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant unoPerInd(final k=0)
    "Index to indicate unoccupied period"
    annotation (Placement(transformation(extent={{200,220},{220,240}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax maxCooTim(final nin=numZon)
    "Find the maximum cool down time"
    annotation (Placement(transformation(extent={{-140,184},{-120,204}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax maxWarTim(final nin=numZon)
    "Find the maximum warm-up time"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch corCooDowTim "Corrected cool down period"
    annotation (Placement(transformation(extent={{0,170},{20,190}})));
  Buildings.Controls.OBC.CDL.Logical.Switch corWarUpTim "Corrected warm-up period"
    annotation (Placement(transformation(extent={{0,150},{20,130}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sum1(final nin=numZon)
    "Sum up number of zones that have temperature being lower than setpoint"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=4.5)
    "Whether or not the number of \"cold\" zone is more than 5"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr1(
    final threshold=numZon-0.5)
    "Whether or not all the zones are \"cold\" zone"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    uLow=-0.5*bouLim,
    uHigh=0.5*bouLim,
    pre_y_start=false)
    "Whether or not the unoccupied heating setpoint is higher than minimum
    zone temperature by bouLim"
    annotation (Placement(transformation(extent={{140,-60},{160,-40}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Whether or not the unoccupied heating setpoint  becomes lower than
    minimum zone temperature: true to false"
    annotation (Placement(transformation(extent={{180,-60},{200,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "If all zone temperature are higher than unoccupied heating setpoint
    by bouLim, then the setback mode should be off."
    annotation (Placement(transformation(extent={{140,-20},{160,0}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "If all zone temperature are higher than freProEndVal, then freeze
    protection setback mode should be off."
    annotation (Placement(transformation(extent={{140,-120},{160,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sum2(final nin=numZon)
    "Sum up number of zones that have temperature being higher than setpoint"
    annotation (Placement(transformation(extent={{0,-220},{20,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr2(threshold=4.5)
    "Whether or not the number of \"hot\" zone is more than 5"
    annotation (Placement(transformation(extent={{40,-220},{60,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr3(
    final threshold=numZon-0.5)
    "Whether or not all the zones are \"hot\" zone"
    annotation (Placement(transformation(extent={{40,-250},{60,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    pre_y_start=false,
    uLow=-0.5*bouLim,
    uHigh=0.5*bouLim)
    "Whether or not the unoccupied cooling setpoint is higher than maximum
    zone temperature by bouLim"
    annotation (Placement(transformation(extent={{140,-260},{160,-240}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    annotation (Placement(transformation(extent={{140,-220},{160,-200}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1
    "Whether or not the unoccupied cooling setpoint  becomes higher than
    maximum zone temperature: true to false"
    annotation (Placement(transformation(extent={{180,-260},{200,-240}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum sumInt(final nin=7) "Sum of inputs"
    annotation (Placement(transformation(extent={{420,-70},{440,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro[numZon]
    "Decide if the cool down time of one zone should be ignored: if window
    open, then output zero, otherwise, output cooDowTim[zone] "
    annotation (Placement(transformation(extent={{-180,180},{-160,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro1[numZon]
    "Decide if the warm-up time of one zone should be ignored: if window
    open, then output zero, otherwise, output warUpTim[zone] "
    annotation (Placement(transformation(extent={{-180,100},{-160,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k1=+1,
    final k2=-1)
    "Calculate the difference between minimum zone temperature and
    unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(
    final k1=+1,
    final k2=-1)
    "Calculate the difference between maximum zone temperature and
    unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{80,-280},{100,-260}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    pre_y_start=true,
    uHigh=0,
    uLow=-60)
    "Whether or not the maximum cool-down time is more than allowed
    cool-down time, with deadband range of 20 seconds"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3(
    pre_y_start=true,
    uHigh=0,
    uLow=-60)
    "Whether or not the maximum warm-up time is more than allowed warm-up
    time, with deadband range of 20 seconds"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add5(
    final k1=-1,
    final k2=+1)
    "Calculate differential between time-to-next-occupancy and the
    cool-down time"
    annotation (Placement(transformation(extent={{60,180},{80,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4(
    pre_y_start=false,
    uHigh=0,
    uLow=-60)
    "Whether or not the cool-down model should be activated, with deadband
    range of 20 s"
    annotation (Placement(transformation(extent={{100,180},{120,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys5(
    pre_y_start=false,
    uHigh=0,
    uLow=-60)
    "Whether or not the warm-up model should be activated, with deadband
    range of 20 s"
    annotation (Placement(transformation(extent={{100,140},{120,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add6(
    final k1=-1,
    final k2=+1)
    "Calculate differential between time-to-next-occupancy and the warm-up time"
    annotation (Placement(transformation(extent={{60,140},{80,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add7(
    final k1=+1,
    final k2=-1)
    "Calculate differential between minimum zone temperature and the
    heating setpoint"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys6(
    pre_y_start=false,
    uLow=-0.1,
    uHigh=0.1) "Whether or not the system should run in warm-up mode"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add8(
    final k1=-1,
    final k2=+1)
    "Calculate differential between maximum zone temperature and the cooling
    setpoint"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys7(
    pre_y_start=false,
    uLow=-0.1,
    uHigh=0.1) "Whether or not the system should run in cool-down mode"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add9[numZon](
    each k1=-1,
    each k2=+1) "Calculate zone temperature difference to setpoint"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys8[numZon](
    each pre_y_start=false,
    each uLow=-0.1,
    each uHigh=0.1)
    "Whether or not the zone temperature is lower then setpoint, with
    deadband of 0.2 degC"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys9(
    pre_y_start=false,
    uLow=-0.1,
    uHigh=0.1)
    "Whether or not any zone temperature is lower than freProThrVal, with
    deadband of 0.2 degC"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    p=freProThrVal,
    final k=-1)
    "Calculate differential between minimum zone temperature and freeze
    protection threshold temperature"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys10(
    pre_y_start=false,
    uLow=-0.1,
    uHigh=0.1)
    "Whether or not all zone temperature are higher than freProEndVal, with
    deadband of 0.2 degC"
    annotation (Placement(transformation(extent={{40,-160},{60,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final k=1,
    p=(-1)*freProEndVal)
    "Calculate differential between maximum zone temperature and the freeze
    protection ending threshold value"
    annotation (Placement(transformation(extent={{0,-160},{20,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add10[numZon](
    each k1=+1,
    each k2=-1) "Calculate zone temperature difference to setpoint"
    annotation (Placement(transformation(extent={{-160,-220},{-140,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys11[numZon](
    each pre_y_start=false,
    each uLow=-0.1,
    each uHigh=0.1)
    "Whether or not the zone temperature is higher than setpoint, with
    deadband of 0.2 degC"
    annotation (Placement(transformation(extent={{-120,-220},{-100,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar2(
    p=preWarCooTim,
    final k=-1)
    "Calculate the differential between maximum cool down time and the
    allowed maximum cool down time"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar3(
    p=preWarCooTim,
    final k=-1)
    "Calculate the differential between maximum warm-up time and the
    allowed maximum warm-up time"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxWarCooTime(
    k=preWarCooTim)
    "Allowed maximum warm-up/cool-down time"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat3
    "Hold true when it should be in warm-up mode"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat4
    "Hold true when it should be in cool-down mode"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger occMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{300,240},{320,260}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger setBacMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{300,-20},{320,0}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger freProSetBacMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{300,-120},{320,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger setUpMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{300,-220},{320,-200}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1(
    integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.warmUp)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{260,140},{280,160}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(
    integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.coolDown)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{260,180},{280,200}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3(
    integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.unoccupied)
    "Convert Boolean to Integer "
    annotation (Placement(transformation(extent={{300,-340},{320,-320}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea6(
    realTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.setUp)
    "Convert Boolean to Real "
    annotation (Placement(transformation(extent={{200,-220},{220,-200}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea5[numZon]
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{-80,-220},{-60,-200}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea4(
    realTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.freezeProtection)
    "Convert Boolean to Real "
    annotation (Placement(transformation(extent={{200,-120},{220,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea3(
    realTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.setBack)
    "Convert Boolean to Real "
    annotation (Placement(transformation(extent={{200,-20},{220,0}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2[numZon]
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    message="Level 3 alarm: freeze protection setback")
    "Generate alarm message"
    annotation (Placement(transformation(extent={{260,-160},{280,-140}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea9[numZon]
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[numZon] "Logical not"
    annotation (Placement(transformation(extent={{-200,20},{-180,40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
   annotation (Placement(transformation(extent={{260,-340},{280,-320}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Whether or not the warm-up time should be activated"
    annotation (Placement(transformation(extent={{200,140},{220,160}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Whether or not the cool-down time should be activated"
    annotation (Placement(transformation(extent={{200,180},{220,200}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Whether or not the number of \"cold\" zone is more than 5 or all
    zones are cold"
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    "Whether or not it is in \"Occupied\"/\"Cool-down\"/\"Warm-up\" mode"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4
    "Whether or not the number of \"hot\" zone is more than 5 or all
    zones are cold"
    annotation (Placement(transformation(extent={{80,-220},{100,-200}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or5
    "If it is in \"Setback\"/\"Setback_freezeProtection\"/\"Setup\" mode"
    annotation (Placement(transformation(extent={{140,-320},{160,-300}})));
  Buildings.Controls.OBC.CDL.Logical.Or or6 "If it is in any of the 6 modes except unoccupied mode"
    annotation (Placement(transformation(extent={{200,-340},{220,-320}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Switch between occupied mode index and unoccupied period index"
    annotation (Placement(transformation(extent={{260,240},{280,260}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[numZon]
    "Decide if the temperature difference to setpoint should be ignored:
    if the zone window is open, then output setpoint temperature, otherwise,
    output zone temperature"
    annotation (Placement(transformation(extent={{-200,2},{-180,-18}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2[numZon]
    "Decide if the temperature difference to setpoint should be ignored:
    if the zone window is open, then output setpoint temperature, otherwise,
    output zone temperature"
    annotation (Placement(transformation(extent={{-200,-200},{-180,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3
    "If the Cool-down/warm-up/Occupied mode is on, then setback mode should
    not be activated."
    annotation (Placement(transformation(extent={{260,-20},{280,0}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi4
    "If the Cool-down/warm-up/Occupied mode is on, then freeze protection
    setback mode should not be activated."
    annotation (Placement(transformation(extent={{260,-120},{280,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi5
    "If the Cool-down/warm-up/Occupied mode is on, then setup mode should
    not be activated."
    annotation (Placement(transformation(extent={{260,-220},{280,-200}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(nout=numZon)
    "Replicate Real input"
    annotation (Placement(transformation(extent={{-200,-80},{-180,-60}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep1(nout=numZon)
    "Replicate Real input"
    annotation (Placement(transformation(extent={{-200,-260},{-180,-240}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin minZonTem(nin=numZon)
    "Find the minimum zone temperature"
    annotation (Placement(transformation(extent={{-140,-130},{-120,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax maxZonTem(nin=numZon)
    "Find the maximum zone temperature"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{140,160},{160,180}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Logical not"
    annotation (Placement(transformation(extent={{140,120},{160,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5 "Logical not"
    annotation (Placement(transformation(extent={{200,-160},{220,-140}})));

equation
  connect(swi.y, occMod.u)
    annotation (Line(points={{281,250},{290,250},{298,250}},
      color={0,0,127}));
  connect(occModInd.y, swi.u1)
    annotation (Line(points={{221,268},{240,268},{240,258},{258,258}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(unoPerInd.y, swi.u3)
    annotation (Line(points={{221,230},{240,230},{240,242},{258,242}},
      color={0,0,127}, pattern=LinePattern.Dash));
  connect(maxCooTim.yMax, corCooDowTim.u1)
    annotation (Line(points={{-119,194},{-12,194},{-12,188},{-2,188}},
      color={0,0,127}));
  connect(booToRea2.y, sum1.u)
    annotation (Line(points={{-19,-10},{-19,-10},{-2,-10}},
      color={0,0,127}));
  connect(booToRea5.y, sum2.u)
    annotation (Line(points={{-59,-210},{-59,-210},{-2,-210}},
      color={0,0,127}));
  connect(uWinSta, swi1.u2)
    annotation (Line(points={{-280,30},{-234,30},{-234,-8},{-202,-8}},
      color={255,0,255}));
  connect(TZon, swi1.u3)
    annotation (Line(points={{-280,-10},{-240,-10},{-240,0},{-202,0}},
      color={0,0,127}));
  connect(uWinSta, swi2.u2)
    annotation (Line(points={{-280,30},{-234,30},{-234,-210},{-202,-210}},
      color={255,0,255}));
  connect(TZon, swi2.u3)
    annotation (Line(points={{-280,-10},{-240,-10},{-240,-202},{-202,-202}},
      color={0,0,127}));
  connect(cooDowTim, pro.u1)
    annotation (Line(points={{-280,196},{-182,196}},
      color={0,0,127}));
  connect(warUpTim, pro1.u1)
    annotation (Line(points={{-280,116},{-182,116}},
      color={0,0,127}));
  connect(booToRea9.y, pro.u2)
    annotation (Line(points={{-139,30},{-139,30},{-120,30},{-120,80},
      {-200,80},{-200,184},{-182,184}}, color={0,0,127}));
  connect(booToRea9.y, pro1.u2)
    annotation (Line(points={{-139,30},{-120,30},{-120,80},{-200,80},
      {-200,104},{-182,104}}, color={0,0,127}));
  connect(swi1.y, add9.u1)
    annotation (Line(points={{-179,-8},{-160,-8},{-160,-4},{-142,-4}},
      color={0,0,127}));
  connect(add9.y, hys8.u)
    annotation (Line(points={{-119,-10},{-82,-10}},  color={0,0,127}));
  connect(hys8.y, booToRea2.u)
    annotation (Line(points={{-59,-10},{-42,-10}},
      color={255,0,255}));
  connect(swi2.y, add10.u1)
    annotation (Line(points={{-179,-210},{-179,-210},{-170,-210},{-170,-204},
      {-162,-204}}, color={0,0,127}));
  connect(add10.y, hys11.u)
    annotation (Line(points={{-139,-210},{-139,-210},{-122,-210}},
      color={0,0,127}));
  connect(hys11.y, booToRea5.u)
    annotation (Line(points={{-99,-210},{-82,-210}}, color={255,0,255}));
  connect(uWinSta, not1.u)
    annotation (Line(points={{-280,30},{-202,30}},
      color={255,0,255}));
  connect(not1.y, booToRea9.u)
    annotation (Line(points={{-179,30},{-162,30}}, color={255,0,255}));
  connect(sum1.y, greEquThr.u)
    annotation (Line(points={{21.7,-10},{38,-10}}, color={0,0,127}));
  connect(sum1.y, greEquThr1.u)
    annotation (Line(points={{21.7,-10},{30,-10},{30,-40},{38,-40}},
      color={0,0,127}));
  connect(greEquThr.y, or1.u1)
    annotation (Line(points={{61,-10},{69.5,-10},{78,-10}},
      color={255,0,255}));
  connect(greEquThr1.y, or1.u2)
    annotation (Line(points={{61,-40},{68,-40},{68,-18},{78,-18}},
      color={255,0,255}));
  connect(or1.y, lat.u)
    annotation (Line(points={{101,-10},{110,-10},{120,-10},{139,-10}},
      color={255,0,255}));
  connect(falEdg.y, lat.u0)
    annotation (Line(points={{201,-50},{220,-50},{220,-30},{120,-30},{120,-16},
      {139,-16}}, color={255,0,255}));
  connect(lat.y, booToRea3.u)
    annotation (Line(points={{161,-10},{198,-10}},
      color={255,0,255}));
  connect(unoPerInd.y, swi3.u1)
    annotation (Line(points={{221,230},{252,230},{252,-2},{258,-2}},
      color={0,0,127}, pattern=LinePattern.Dash));
  connect(or3.y, swi3.u2)
    annotation (Line(points={{101,30},{240,30},{240,-10},{258,-10}},
      color={255,0,255}));
  connect(lat1.y, booToRea4.u)
    annotation (Line(points={{161,-110},{198,-110}}, color={255,0,255}));
  connect(or3.y, swi4.u2)
    annotation (Line(points={{101,30},{112,30},{112,-80},{240,-80},{240,-110},
      {258,-110}},   color={255,0,255}));
  connect(unoPerInd.y, swi4.u1)
    annotation (Line(points={{221,230},{252,230},{252,-102},{258,-102}},
      color={0,0,127}, pattern=LinePattern.Dash));
  connect(sum2.y, greEquThr2.u)
    annotation (Line(points={{21.7,-210},{38,-210}}, color={0,0,127}));
  connect(sum2.y, greEquThr3.u)
    annotation (Line(points={{21.7,-210},{30,-210},{30,-240},{38,-240}},
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
    annotation (Line(points={{161,-210},{198,-210}},
      color={255,0,255}));
  connect(or3.y, swi5.u2)
    annotation (Line(points={{101,30},{112,30},{112,-190},{244,-190},{244,-210},
      {258,-210}}, color={255,0,255}));
  connect(unoPerInd.y, swi5.u1)
    annotation (Line(points={{221,230},{252,230},{252,-202},{258,-202}},
      color={0,0,127},  pattern=LinePattern.Dash));
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
    annotation (Line(points={{161,-110},{180,-110},{180,-150},{120,-150},
      {120,-310},{138,-310}}, color={255,0,255}));
  connect(lat2.y, or5.u3)
    annotation (Line(points={{161,-210},{180,-210},{180,-190},{112,-190},{112,-318},
      {138,-318}}, color={255,0,255}));
  connect(or5.y, or6.u1)
    annotation (Line(points={{161,-310},{180,-310},{180,-330},{198,-330}},
      color={255,0,255}));
  connect(or3.y, or6.u2)
    annotation (Line(points={{101,30},{112,30},{112,-338},{198,-338}},
      color={255,0,255}));
  connect(or6.y, not2.u)
    annotation (Line(points={{221,-330},{258,-330}},
      color={255,0,255}));
  connect(not2.y,booToInt3. u)
    annotation (Line(points={{281,-330},{298,-330}},
      color={255,0,255}));
  connect(sumInt.y, yOpeMod)
    annotation (Line(points={{441.7,-60},{441.7,-60},{450,-60},{450,-20},{470,-20}},
      color={255,127,0}));
  connect(and2.y, booToInt.u)
    annotation (Line(points={{221,190},{258,190}}, color={255,0,255}));
  connect(and1.y, booToInt1.u)
    annotation (Line(points={{221,150},{258,150}}, color={255,0,255}));
  connect(and2.y, or3.u2)
    annotation (Line(points={{221,190},{236,190},{236,64},{64,64},{64,30},{78,30}},
      color={255,0,255}));
  connect(and1.y, or3.u1)
    annotation (Line(points={{221,150},{240,150},{240,60},{70,60},{70,38},{78,38}},
      color={255,0,255}));
  connect(uOcc, swi.u2)
    annotation (Line(points={{-280,300},{28,300},{28,250},{258,250}},
      color={255,0,255}));
  connect(uOcc, or3.u3)
    annotation (Line(points={{-280,300},{28,300},{28,22},{78,22}},
      color={255,0,255}));
  connect(add2.y, hys.u)
    annotation (Line(points={{101,-70},{108,-70},{108,-50},{138,-50}},
      color={0,0,127}));
  connect(TUnoHeaSet, add2.u1)
    annotation (Line(points={{-280,-50},{-36,-50},{-36,-64},{78,-64}},
      color={0,0,127}));
  connect(TUnoCooSet, add1.u2)
    annotation (Line(points={{-280,-270},{-40,-270},{-40,-276},{78,-276}},
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
    annotation (Line(points={{121,190},{198,190}},
      color={255,0,255}));
  connect(tNexOcc, add5.u1)
    annotation (Line(points={{-280,260},{36,260},{36,196},{58,196}},
      color={0,0,127}));
  connect(corCooDowTim.y, add5.u2)
    annotation (Line(points={{21,180},{40,180},{40,184},{58,184}},
      color={0,0,127}));
  connect(tNexOcc, add6.u1)
    annotation (Line(points={{-280,260},{36,260},{36,156},{58,156}},
      color={0,0,127}));
  connect(corWarUpTim.y, add6.u2)
    annotation (Line(points={{21,140},{40,140},{40,144},{58,144}},
      color={0,0,127}));
  connect(add6.y, hys5.u)
    annotation (Line(points={{81,150},{89.5,150},{98,150}}, color={0,0,127}));
  connect(hys5.y, and1.u1)
    annotation (Line(points={{121,150},{198,150}}, color={255,0,255}));
  connect(add7.y, hys6.u)
    annotation (Line(points={{-59,90},{-59,90},{-42,90}}, color={0,0,127}));
  connect(THeaSet, add7.u1)
    annotation (Line(points={{-280,90},{-100,90},{-100,96},{-82,96}},
      color={0,0,127}));
  connect(add8.y, hys7.u)
    annotation (Line(points={{-59,60},{-54,60},{-42,60}}, color={0,0,127}));
  connect(TCooSet, add8.u1)
    annotation (Line(points={{-280,60},{-94,60},{-94,66},{-82,66}},
      color={0,0,127}));
  connect(addPar.y, hys9.u)
    annotation (Line(points={{21,-110},{21,-110},{38,-110}}, color={0,0,127}));
  connect(hys9.y, lat1.u)
    annotation (Line(points={{61,-110},{139,-110}}, color={255,0,255}));
  connect(addPar1.y, hys10.u)
    annotation (Line(points={{21,-150},{38,-150}}, color={0,0,127}));
  connect(hys10.y, lat1.u0)
    annotation (Line(points={{61,-150},{80,-150},{80,-116},{139,-116}},
      color={255,0,255}));
  connect(maxWarTim.yMax, addPar3.u)
    annotation (Line(points={{-119,110},{-100,110},{-100,140},{-82,140}},
      color={0,0,127}));
  connect(addPar2.y, hys2.u)
    annotation (Line(points={{-59,180},{-42,180}}, color={0,0,127}));
  connect(addPar3.y, hys3.u)
    annotation (Line(points={{-59,140},{-42,140}}, color={0,0,127}));
  connect(maxCooTim.yMax, addPar2.u)
    annotation (Line(points={{-119,194},{-110,194},{-100,194},{-100,180},{-82,180}},
      color={0,0,127}));
  connect(maxWarCooTime.y, corCooDowTim.u3)
    annotation (Line(points={{-119,160},{-66,160},{-12,160},{-12,172},{-2,172}},
      color={0,0,127}));
  connect(maxWarTim.yMax, corWarUpTim.u1)
    annotation (Line(points={{-119,110},{-12,110},{-12,132},{-2,132}},
      color={0,0,127}));
  connect(maxWarCooTime.y, corWarUpTim.u3)
    annotation (Line(points={{-119,160},{-66,160},{-12,160},{-12,148},{-2,148}},
      color={0,0,127}));
  connect(TUnoHeaSet, reaRep.u)
    annotation (Line(points={{-280,-50},{-220,-50},{-220,-70},{-202,-70}},
      color={0,0,127}));
  connect(reaRep.y, swi1.u1)
    annotation (Line(points={{-179,-70},{-160,-70},{-160,-40},{-220,-40},{-220,-16},
      {-202,-16}}, color={0,0,127}));
  connect(reaRep.y, add9.u2)
    annotation (Line(points={{-179,-70},{-160,-70},{-160,-40},{-160,-40},{-160,-16},
      {-142,-16}}, color={0,0,127}));
  connect(TUnoCooSet, reaRep1.u)
    annotation (Line(points={{-280,-270},{-240,-270},{-240,-250},{-202,-250}},
      color={0,0,127}));
  connect(reaRep1.y, add10.u2)
    annotation (Line(points={{-179,-250},{-170,-250},{-170,-216},
      {-162,-216}}, color={0,0,127}));
  connect(reaRep1.y, swi2.u1)
    annotation (Line(points={{-179,-250},{-170,-250},{-170,-230},{-220,-230},
      {-220,-218},{-202,-218}}, color={0,0,127}));
  connect(booToRea3.y, swi3.u3)
    annotation (Line(points={{221,-10},{232,-10},{232,-18},{258,-18}},
      color={0,0,127}));
  connect(booToRea4.y, swi4.u3)
    annotation (Line(points={{221,-110},{232,-110},{232,-118},{258,-118}},
      color={0,0,127}));
  connect(booToRea6.y, swi5.u3)
    annotation (Line(points={{221,-210},{240,-210},{240,-218},{258,-218}},
      color={0,0,127}));
  connect(occMod.y, sumInt.u[1])
    annotation (Line(points={{321,250},{408,250},{408,-54},{418,-54}},
      color={255,127,0}));
  connect(booToInt.y, sumInt.u[2])
    annotation (Line(points={{281,190},{402,190},{402,-56},{418,-56}},
      color={255,127,0}));
  connect(booToInt1.y, sumInt.u[3])
    annotation (Line(points={{281,150},{394,150},{394,-58},{418,-58}},
      color={255,127,0}));
  connect(setBacMod.y, sumInt.u[4])
    annotation (Line(points={{321,-10},{386,-10},{386,-60},{418,-60}},
      color={255,127,0}));
  connect(freProSetBacMod.y, sumInt.u[5])
    annotation (Line(points={{321,-110},{386,-110},{386,-62},{418,-62}},
      color={255,127,0}));
  connect(setUpMod.y, sumInt.u[6])
    annotation (Line(points={{321,-210},{394,-210},{394,-64},{418,-64}},
      color={255,127,0}));
  connect(booToInt3.y, sumInt.u[7])
    annotation (Line(points={{321,-330},{404,-330},{404,-66},{418,-66}},
      color={255,127,0}));
  connect(maxZonTem.yMax, add8.u2)
    annotation (Line(points={{-119,-90},{-92,-90},{-92,54},{-82,54}},
      color={0,0,127}));
  connect(maxZonTem.yMax, addPar.u)
    annotation (Line(points={{-119,-90},{-40,-90},{-40,-110},{-2,-110}},
      color={0,0,127}));
  connect(maxZonTem.yMax, add1.u1)
    annotation (Line(points={{-119,-90},{-40,-90},{-40,-264},{78,-264}},
      color={0,0,127}));
  connect(TZon, maxZonTem.u)
    annotation (Line(points={{-280,-10},{-240,-10},{-240,-90},{-142,-90}},
      color={0,0,127}));
  connect(TZon,minZonTem.u)
    annotation (Line(points={{-280,-10},{-240,-10},{-240,-120},{-142,-120}},
      color={0,0,127}));
  connect(minZonTem.yMin, add7.u2)
    annotation (Line(points={{-119,-120},{-98,-120},{-98,84},{-82,84}},
      color={0,0,127}));
  connect(minZonTem.yMin, add2.u2)
    annotation (Line(points={{-119,-120},{-98,-120},{-98,-76},{78,-76}},
      color={0,0,127}));
  connect(minZonTem.yMin, addPar1.u)
    annotation (Line(points={{-119,-120},{-98,-120},{-98,-150},{-2,-150}},
      color={0,0,127}));
  connect(pro.y, maxCooTim.u)
    annotation (Line(points={{-159,190},{-152,190},{-152,194},{-142,194}},
      color={0,0,127}));
  connect(pro1.y, maxWarTim.u)
    annotation (Line(points={{-159,110},{-150,110},{-150,110},{-142,110}},
      color={0,0,127}));
  connect(hys6.y, lat3.u)
    annotation (Line(points={{-19,90},{-1,90}}, color={255,0,255}));
  connect(lat3.y, and1.u2)
    annotation (Line(points={{21,90},{188,90},{188,142},{198,142}},
      color={255,0,255}));
  connect(hys7.y, lat4.u)
    annotation (Line(points={{-19,60},{-1,60}}, color={255,0,255}));
  connect(lat4.y, and2.u2)
    annotation (Line(points={{21,60},{60,60},{60,100},{180,100},{180,182},{198,182}},
      color={255,0,255}));
  connect(hys4.y, not3.u)
    annotation (Line(points={{121,190},{130,190},{130,170},{138,170}},
      color={255,0,255}));
  connect(hys5.y, not4.u)
    annotation (Line(points={{121,150},{128,150},{128,130},{138,130}},
      color={255,0,255}));
  connect(not4.y, lat3.u0)
    annotation (Line(points={{161,130},{170,130},{170,110},{-8,110},{-8,84},{-1,84}},
      color={255,0,255}));
  connect(not3.y, lat4.u0)
    annotation (Line(points={{161,170},{174,170},{174,106},{-12,106},{-12,54},{-1,54}},
      color={255,0,255}));
  connect(lat1.y, not5.u)
    annotation (Line(points={{161,-110},{180,-110},{180,-150},{198,-150}},
      color={255,0,255}));
  connect(not5.y, assMes.u)
    annotation (Line(points={{221,-150},{258,-150}}, color={255,0,255}));

annotation (
  defaultComponentName = "opeModSel",
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-260,-360},{460,320}}),
        graphics={
        Rectangle(
          extent={{-258,-302},{458,-358}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-258,-102},{458,-158}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-258,-182},{458,-278}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-258,18},{458,-78}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-258,318},{458,242}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-258,218},{458,42}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{336,282},{424,242}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Occupied mode"),
        Text(
          extent={{296,-32},{380,-72}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Setback mode"),
        Text(
          extent={{324,-206},{394,-242}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Setup mode"),
        Text(
          extent={{320,-320},{416,-376}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Unoccupied mode"),
        Text(
          extent={{328,-98},{462,-152}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Freeze protection setback mode"),
        Text(
          extent={{302,156},{390,116}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Warm-up mode"),
        Text(
          extent={{306,198},{394,156}},
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
          textString="yOpeMod"),
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
occupied start time. Zones where the window switch indicates that a window
is open shall be ignored. Note that for each zone, the optimal warm-up time
<code>warUpTim</code> shall be obtained from an <i>Optimal Start</i>
sequences, computed in a separate block.
The figure below shows the sequence.
</p>
<p align=\"center\">
<img alt=\"Image of warm-up mode definition\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/Generic/OperationMode/Warm-upModeDefinition.png\"/>
</p>
<h4>Cool-Down Mode</h4>
<p>
Cool-down mode shall start based on the zone with the longest calculated
cool-down time <code>cooDowTim</code> requirement, but no earlier than 3 hours
before the start of the scheduled occupied period, and shall end at the
scheduled occupied start time. Zones where the window switch indicates that a
window is open shall be ignored. Note that the each zone <code>cooDowTim</code>
shall be obtained from an <i>Optimal Start</i> sequences, computed in a
separate block.
</p>
<p align=\"center\">
<img alt=\"Image of cool-down mode definition\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/Generic/OperationMode/Cool-downModeDefinition.png\"/>
</p>
<h4>Setback Mode</h4>
<p>
During <i>unoccupied mode</i>, if any 5 zones (or all zones, if fewer than 5)
in the zone group fall below their unoccupied heating setpoints
<code>TUnoHeaSet</code>, the zone group shall enter <i>setback mode</i> until
all spaces in the zone group are <i>1.1</i> &deg;C (<i>2</i> &deg;F) above their
unoccupied setpoints.
</p>
<p align=\"center\">
<img alt=\"Image of setback mode definition\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/Generic/OperationMode/SetbackModeDefinition.png\"/>
</p>
<h4>Freeze Protection Setback Mode</h4>
<p>
During <i>unoccupied Mode</i>, if any single zone falls below <i>4.4</i> &deg;C
(<i>40</i> &deg;F), the zone group shall enter <i>setback mode</i> until all zones
are above <i>7.2</i> &deg;C (<i>45</i> &deg;F), and a Level 3 alarm
<code>yFreProSta</code> shall be set.
</p>
<h4>Setup Mode</h4>
<p>
During <i>unoccupied mode</i>, if any 5 zones (or all zones, if fewer than 5)
in the zone rise above their unoccupied cooling setpoints <code>TUnoCooSet</code>,
the zone group shall enter <i>setup mode</i> until all spaces in the zone group
are <i>1.1</i> &deg;C (<i>2</i> &deg;F) below their unoccupied setpoints. Zones
where the window switch indicates that a window is open shall be ignored.
</p>
<p align=\"center\">
<img alt=\"Image of setup mode definition\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/Generic/OperationMode/SetupModeDefinition.png\"/>
</p>
<h4>Unoccupied Mode</h4>
<p>
<i>Unoccupied mode</i> shall be active if the zone group is not in any other mode.
</p>
</html>",revisions="<html>
<ul>
<li>
June 19, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end OperationMode;
