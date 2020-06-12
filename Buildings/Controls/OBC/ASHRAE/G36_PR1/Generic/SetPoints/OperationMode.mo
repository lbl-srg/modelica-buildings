within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints;
block OperationMode "Block that outputs the operation mode"

  parameter Boolean have_winSen
    "Check if the zone has window status sensor"
    annotation(Dialog(group="Sensors"));
  parameter Integer numZon(min=1) "Number of zones";
  parameter Real preWarCooTim(unit="s") = 10800
    "Maximum cool-down or warm-up time";
  parameter Real TZonFreProOn(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") = 277.55
    "Threshold zone temperature value to activate freeze protection mode";
  parameter Real TZonFreProOff(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") = 280.35
    "Threshold zone temperature value to finish the freeze protection mode";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Zone occupancy status: true=occupied, false=unoccupied"
    annotation (Placement(transformation(extent={{-300,310},{-260,350}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
    final unit="s",
    final quantity="Time")
    "Time to next occupied period"
    annotation (Placement(transformation(extent={{-300,270},{-260,310}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput maxCooDowTim(
    final unit="s",
    final quantity="Time") "Maximum cool-down time among all the zones"
    annotation (Placement(transformation(extent={{-300,210},{-260,250}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput maxWarUpTim(
    final unit="s",
    final quantity="Time") "Maximum warm-up time among all the zones"
    annotation (Placement(transformation(extent={{-300,130},{-260,170}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOccHeaHig
    "True when the occupied heating setpoint temperature is higher than the zone temperature"
    annotation (Placement(transformation(extent={{-300,90},{-260,130}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHigOccCoo
    "True when the zone temperature is higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-300,60},{-260,100}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWinSta if have_winSen
    "Window status: true=open, false=close"
    annotation (Placement(transformation(extent={{-300,30},{-260,70}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput totColZon
    "Total number of cold zone"
    annotation (Placement(transformation(extent={{-300,-30},{-260,10}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput unoHeaHigMin
    "True when the unoccupied heating setpoint is higher than minimum zone temperature"
    annotation (Placement(transformation(extent={{-300,-90},{-260,-50}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonMax(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Maximum zone temperature"
    annotation (Placement(transformation(extent={{-300,-130},{-260,-90}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonMin(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Minimum zone temperature"
    annotation (Placement(transformation(extent={{-300,-170},{-260,-130}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput totHotZon
    "Total number of hot zone"
    annotation (Placement(transformation(extent={{-300,-230},{-260,-190}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput maxHigUnoCoo
    "True when the maximum zone temperature is higher than unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-300,-290},{-260,-250}}),
        iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yOpeMod
    "Operation mode"
    annotation (Placement(transformation(extent={{460,-40},{500,0}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant occModInd(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "Occupied mode "
    annotation (Placement(transformation(extent={{200,300},{220,320}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant unoPerInd(
    final k=0)
    "Index to indicate unoccupied period"
    annotation (Placement(transformation(extent={{100,250},{120,270}})));
  Buildings.Controls.OBC.CDL.Logical.Switch corCooDowTim "Corrected cool down period"
    annotation (Placement(transformation(extent={{-104,200},{-84,220}})));
  Buildings.Controls.OBC.CDL.Logical.Switch corWarUpTim "Corrected warm-up period"
    annotation (Placement(transformation(extent={{-104,130},{-84,150}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(
    final threshold=4) "Check if the number of cold zones is not less than than 5"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr1(
    final threshold=numZon - 1)
    "Check if all zones are cold zone"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Check if the unoccupied heating setpoint becomes lower than minimum zone temperature: true to false"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "If all zone temperature are higher than unoccupied heating setpoint by a given limit, then the setback mode should be off"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "If all zone temperature are higher than threshold temperature of ending freeze protection, then freeze protection setback mode should be off"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "If all zone temperature are lower than unoccupied cooling setpoint by a given limit, then the setup mode should be off"
    annotation (Placement(transformation(extent={{-40,-220},{-20,-200}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1
    "Check if the unoccupied cooling setpoint becomes higher than maximum zone temperature: true to false"
    annotation (Placement(transformation(extent={{-100,-260},{-80,-240}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final pre_y_start=true,
    final uHigh=0,
    final uLow=-60)
    "Hysteresis that outputs if the maximum cool-down time is more than the allowed cool-down time"
    annotation (Placement(transformation(extent={{-146,200},{-126,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3(
    final pre_y_start=true,
    final uHigh=0,
    final uLow=-60)
    "Hysteresis that outputs if the maximum warm-up time is more than allowed warm-up time"
    annotation (Placement(transformation(extent={{-146,130},{-126,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add5(
    final k1=-1)
    "Calculate differential between time-to-next-occupancy and the cool-down time"
    annotation (Placement(transformation(extent={{-56,210},{-36,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4(
    final pre_y_start=false,
    final uHigh=0,
    final uLow=-60)
    "Hysteresis to activate the cool-down model"
    annotation (Placement(transformation(extent={{-22,210},{-2,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys5(
    final pre_y_start=false,
    final uHigh=0,
    final uLow=-60)
    "Hysteresis to activate the warm-up model"
    annotation (Placement(transformation(extent={{-22,140},{-2,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add6(
    final k1=-1)
    "Calculate differential between time-to-next-occupancy and the warm-up time"
    annotation (Placement(transformation(extent={{-56,140},{-36,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys9(
    final pre_y_start=false,
    final uLow=-0.1,
    final uHigh=0.1)
    "Hysteresis that outputs if any zone temperature is lower than freeze protection threshold temperature"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=TZonFreProOn,
    final k=-1)
    "Calculate differential between minimum zone temperature and freeze protection threshold temperature"
    annotation (Placement(transformation(extent={{-180,-120},{-160,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys10(
    final pre_y_start=false,
    final uLow=-0.1,
    final uHigh=0.1)
    "Hysteresis that outputs if all zone temperature are higher than threshold temperature of ending freeze protection"
    annotation (Placement(transformation(extent={{-140,-160},{-120,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final k=1,
    final p=(-1)*TZonFreProOff)
    "Calculate differential between maximum zone temperature and threshold temperature of ending freeze protection"
    annotation (Placement(transformation(extent={{-180,-160},{-160,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar2(
    final p=preWarCooTim,
    final k=-1)
    "Calculate the differential between maximum cool down time and the allowed maximum cool down time"
    annotation (Placement(transformation(extent={{-178,200},{-158,220}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar3(
    final p=preWarCooTim,
    final k=-1)
    "Calculate the differential between maximum warm-up time and the allowed maximum warm-up time"
    annotation (Placement(transformation(extent={{-178,130},{-158,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxWarCooTime(
    final k=preWarCooTim)
    "Allowed maximum warm-up or cool-down time"
    annotation (Placement(transformation(extent={{-214,180},{-194,200}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr2(
    final threshold=4) "Check if the number of hot zones is not less than than 5"
    annotation (Placement(transformation(extent={{-180,-220},{-160,-200}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr3(
    final threshold=numZon - 1) "Check if all zones are hot zone"
    annotation (Placement(transformation(extent={{-180,-250},{-160,-230}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt "Sum of two integer inputs"
    annotation (Placement(transformation(extent={{340,240},{360,260}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt1 "Sum of two integer inputs"
    annotation (Placement(transformation(extent={{376,264},{396,284}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt2 "Sum of two integer inputs"
    annotation (Placement(transformation(extent={{240,-90},{260,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt3 "Sum of two integer inputs"
    annotation (Placement(transformation(extent={{280,-200},{300,-180}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt4 "Sum of two integer inputs"
    annotation (Placement(transformation(extent={{320,-290},{340,-270}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt5 "Sum of two integer inputs"
    annotation (Placement(transformation(extent={{420,-30},{440,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger occMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{300,270},{320,290}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger setBacMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{200,-20},{220,0}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger freProSetBacMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{200,-120},{220,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger setUpMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{200,-220},{220,-200}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Get the moment when the warm up time starts "
    annotation (Placement(transformation(extent={{50,140},{70,160}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(trueHoldDuration=preWarCooTim)
    "Hold the start time true signal"
    annotation (Placement(transformation(extent={{82,210},{102,230}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Get the moment when cool down time starts"
    annotation (Placement(transformation(extent={{50,210},{70,230}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol1(trueHoldDuration=preWarCooTim)
    "Hold the start time true signal"
    annotation (Placement(transformation(extent={{82,140},{102,160}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(realTrue=
        Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.warmUp)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{180,140},{200,160}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(realTrue=
        Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.coolDown)
    "Convert Boolean to Integer number"
    annotation (Placement(transformation(extent={{178,210},{198,230}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3(
    final integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.unoccupied)
    "Convert Boolean to Integer "
    annotation (Placement(transformation(extent={{220,-340},{240,-320}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea6(
    final realTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.setUp)
    "Convert Boolean to Real "
    annotation (Placement(transformation(extent={{60,-220},{80,-200}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea4(
    final realTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.freezeProtection)
    "Convert Boolean to Real "
    annotation (Placement(transformation(extent={{60,-120},{80,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea3(
    final realTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.setBack)
    "Convert Boolean to Real "
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Level 3 alarm: freeze protection setback")
    "Generate alarm message"
    annotation (Placement(transformation(extent={{100,-160},{120,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
   annotation (Placement(transformation(extent={{180,-340},{200,-320}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Warm-up period"
    annotation (Placement(transformation(extent={{122,140},{142,160}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Get the start of the cool-down time"
    annotation (Placement(transformation(extent={{20,210},{40,230}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Check if the number of cold zone is more than 5 or all zones are cold"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    "Check if it is in Occupied, Cool-down, or Warm-up mode"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4
    "Check if the number of hot zone is more than 5 or all zones are cold"
    annotation (Placement(transformation(extent={{-100,-220},{-80,-200}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or5
    "Check if it is in Setback, Setback_freezeProtection, or Setup mode"
    annotation (Placement(transformation(extent={{60,-320},{80,-300}})));
  Buildings.Controls.OBC.CDL.Logical.Or or6
    "Check if it is in any of the 6 modes except unoccupied mode"
    annotation (Placement(transformation(extent={{120,-340},{140,-320}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Switch between occupied mode index and unoccupied period index"
    annotation (Placement(transformation(extent={{260,270},{280,290}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3
    "If the Cool-down, warm-up, or Occupied mode is on, then setback mode should not be activated."
    annotation (Placement(transformation(extent={{160,-20},{180,0}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi4
    "If the Cool-down, warm-up, or Occupied mode is on, then freeze protection setback mode should not be activated."
    annotation (Placement(transformation(extent={{160,-120},{180,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi5
    "If the Cool-down, warm-up, or Occupied mode is on, then setup mode should not be activated."
    annotation (Placement(transformation(extent={{160,-220},{180,-200}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5 "Logical not"
    annotation (Placement(transformation(extent={{60,-160},{80,-140}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold notOcc(
    final threshold=1) if have_winSen
    "Check if the operation mode is other than occupied mode"
    annotation (Placement(transformation(extent={{200,20},{220,40}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 if have_winSen
    "True if window open during modes other than occupied mode"
    annotation (Placement(transformation(extent={{260,40},{280,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 if have_winSen "Logical not"
    annotation (Placement(transformation(extent={{300,40},{320,60}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert winOpe(
    final message="Level 4 alarm: window open during modes other than occupied mode") if
       have_winSen
    "Generate alarm message when window open during modes other than occupied mode"
    annotation (Placement(transformation(extent={{340,40},{360,60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "If occupied mode is on, then cool down mode should not be activated"
    annotation (Placement(transformation(extent={{250,212},{270,232}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger setBacMod1
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{288,212},{308,232}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    "If occupied mode is on, then warm-up mode should not be activated."
    annotation (Placement(transformation(extent={{252,142},{272,162}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger setBacMod2
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{288,142},{308,162}})));
  Buildings.Controls.OBC.CDL.Logical.And and4 "Cool-down period"
    annotation (Placement(transformation(extent={{122,210},{142,230}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Get the start of the warm-up time"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));

equation
  connect(swi.y, occMod.u)
    annotation (Line(points={{282,280},{298,280}},
      color={0,0,127}));
  connect(occModInd.y, swi.u1)
    annotation (Line(points={{222,310},{240,310},{240,288},{258,288}},
      color={0,0,127}, pattern=LinePattern.Dash));
  connect(unoPerInd.y, swi.u3)
    annotation (Line(points={{122,260},{150,260},{150,272},{258,272}},
      color={0,0,127}, pattern=LinePattern.Dash));
  connect(intGreThr.y, or1.u1)
    annotation (Line(points={{-158,-10},{-102,-10}},
      color={255,0,255}));
  connect(intGreThr1.y, or1.u2)
    annotation (Line(points={{-158,-40},{-120,-40},{-120,-18},{-102,-18}},
      color={255,0,255}));
  connect(or1.y, lat.u)
    annotation (Line(points={{-78,-10},{-42,-10}},
      color={255,0,255}));
  connect(falEdg.y, lat.clr)
    annotation (Line(points={{-78,-50},{-60,-50},{-60,-16},{-42,-16}},
                  color={255,0,255}));
  connect(lat.y, booToRea3.u)
    annotation (Line(points={{-18,-10},{58,-10}},
      color={255,0,255}));
  connect(unoPerInd.y, swi3.u1)
    annotation (Line(points={{122,260},{150,260},{150,-2},{158,-2}},
      color={0,0,127}, pattern=LinePattern.Dash));
  connect(or3.y, swi3.u2)
    annotation (Line(points={{22,30},{140,30},{140,-10},{158,-10}},
      color={255,0,255}));
  connect(lat1.y, booToRea4.u)
    annotation (Line(points={{-18,-110},{58,-110}},  color={255,0,255}));
  connect(or3.y, swi4.u2)
    annotation (Line(points={{22,30},{140,30},{140,-110},{158,-110}},
                     color={255,0,255}));
  connect(unoPerInd.y, swi4.u1)
    annotation (Line(points={{122,260},{150,260},{150,-102},{158,-102}},
      color={0,0,127}, pattern=LinePattern.Dash));
  connect(or4.y, lat2.u)
    annotation (Line(points={{-78,-210},{-42,-210}}, color={255,0,255}));
  connect(falEdg1.y, lat2.clr)
    annotation (Line(points={{-78,-250},{-60,-250},{-60,-216},{-42,-216}},
                              color={255,0,255}));
  connect(lat2.y, booToRea6.u)
    annotation (Line(points={{-18,-210},{58,-210}},
      color={255,0,255}));
  connect(or3.y, swi5.u2)
    annotation (Line(points={{22,30},{140,30},{140,-210},{158,-210}},
                              color={255,0,255}));
  connect(unoPerInd.y, swi5.u1)
    annotation (Line(points={{122,260},{150,260},{150,-202},{158,-202}},
      color={0,0,127},  pattern=LinePattern.Dash));
  connect(swi3.y, setBacMod.u)
    annotation (Line(points={{182,-10},{198,-10}},
      color={0,0,127}));
  connect(swi4.y, freProSetBacMod.u)
    annotation (Line(points={{182,-110},{198,-110}}, color={0,0,127}));
  connect(swi5.y, setUpMod.u)
    annotation (Line(points={{182,-210},{198,-210}},
      color={0,0,127}));
  connect(lat.y, or5.u1)
    annotation (Line(points={{-18,-10},{10,-10},{10,-302},{58,-302}},
                   color={255,0,255}));
  connect(lat1.y, or5.u2)
    annotation (Line(points={{-18,-110},{0,-110},{0,-310},{58,-310}},
                              color={255,0,255}));
  connect(lat2.y, or5.u3)
    annotation (Line(points={{-18,-210},{20,-210},{20,-318},{58,-318}},
                              color={255,0,255}));
  connect(or5.y, or6.u1)
    annotation (Line(points={{82,-310},{100,-310},{100,-330},{118,-330}},
      color={255,0,255}));
  connect(or3.y, or6.u2)
    annotation (Line(points={{22,30},{40,30},{40,-338},{118,-338}},
      color={255,0,255}));
  connect(or6.y, not2.u)
    annotation (Line(points={{142,-330},{178,-330}},
      color={255,0,255}));
  connect(not2.y,booToInt3. u)
    annotation (Line(points={{202,-330},{218,-330}},
      color={255,0,255}));
  connect(and1.y,booToRea1. u)
    annotation (Line(points={{144,150},{178,150}}, color={255,0,255}));
  connect(and1.y, or3.u1)
    annotation (Line(points={{144,150},{156,150},{156,64},{-20,64},{-20,38},{-2,
          38}},
      color={255,0,255}));
  connect(uOcc, swi.u2)
    annotation (Line(points={{-280,330},{-220,330},{-220,280},{258,280}},
      color={255,0,255}));
  connect(uOcc, or3.u3)
    annotation (Line(points={{-280,330},{-220,330},{-220,22},{-2,22}},
      color={255,0,255}));
  connect(hys2.y, corCooDowTim.u2)
    annotation (Line(points={{-124,210},{-106,210}},        color={255,0,255}));
  connect(hys3.y, corWarUpTim.u2)
    annotation (Line(points={{-124,140},{-106,140}},        color={255,0,255}));
  connect(add5.y, hys4.u)
    annotation (Line(points={{-34,220},{-24,220}},          color={0,0,127}));
  connect(tNexOcc, add5.u1)
    annotation (Line(points={{-280,290},{-76,290},{-76,226},{-58,226}},
      color={0,0,127}));
  connect(corCooDowTim.y, add5.u2)
    annotation (Line(points={{-82,210},{-66,210},{-66,214},{-58,214}},
      color={0,0,127}));
  connect(tNexOcc, add6.u1)
    annotation (Line(points={{-280,290},{-76,290},{-76,156},{-58,156}},
      color={0,0,127}));
  connect(corWarUpTim.y, add6.u2)
    annotation (Line(points={{-82,140},{-76,140},{-76,144},{-58,144}},
      color={0,0,127}));
  connect(add6.y, hys5.u)
    annotation (Line(points={{-34,150},{-24,150}},          color={0,0,127}));
  connect(addPar.y, hys9.u)
    annotation (Line(points={{-158,-110},{-142,-110}},       color={0,0,127}));
  connect(hys9.y, lat1.u)
    annotation (Line(points={{-118,-110},{-42,-110}}, color={255,0,255}));
  connect(addPar1.y, hys10.u)
    annotation (Line(points={{-158,-150},{-142,-150}}, color={0,0,127}));
  connect(hys10.y, lat1.clr)
    annotation (Line(points={{-118,-150},{-80,-150},{-80,-116},{-42,-116}},
      color={255,0,255}));
  connect(addPar2.y, hys2.u)
    annotation (Line(points={{-156,210},{-148,210}}, color={0,0,127}));
  connect(addPar3.y, hys3.u)
    annotation (Line(points={{-156,140},{-148,140}}, color={0,0,127}));
  connect(maxWarCooTime.y, corCooDowTim.u3)
    annotation (Line(points={{-192,190},{-120,190},{-120,202},{-106,202}},
      color={0,0,127}));
  connect(maxWarCooTime.y, corWarUpTim.u3)
    annotation (Line(points={{-192,190},{-120,190},{-120,132},{-106,132}},
      color={0,0,127}));
  connect(booToRea3.y, swi3.u3)
    annotation (Line(points={{82,-10},{100,-10},{100,-18},{158,-18}},
      color={0,0,127}));
  connect(booToRea4.y, swi4.u3)
    annotation (Line(points={{82,-110},{100,-110},{100,-118},{158,-118}},
      color={0,0,127}));
  connect(booToRea6.y, swi5.u3)
    annotation (Line(points={{82,-210},{100,-210},{100,-218},{158,-218}},
      color={0,0,127}));
  connect(lat1.y, not5.u)
    annotation (Line(points={{-18,-110},{0,-110},{0,-150},{58,-150}},
      color={255,0,255}));
  connect(not5.y, assMes.u)
    annotation (Line(points={{82,-150},{98,-150}},   color={255,0,255}));
  connect(maxCooDowTim, addPar2.u) annotation (Line(points={{-280,230},{-188,
          230},{-188,210},{-180,210}}, color={0,0,127}));
  connect(maxCooDowTim, corCooDowTim.u1) annotation (Line(points={{-280,230},{
          -116,230},{-116,218},{-106,218}}, color={0,0,127}));
  connect(maxWarUpTim, addPar3.u) annotation (Line(points={{-280,150},{-230,150},
          {-230,140},{-180,140}}, color={0,0,127}));
  connect(maxWarUpTim, corWarUpTim.u1) annotation (Line(points={{-280,150},{
          -230,150},{-230,164},{-114,164},{-114,148},{-106,148}},
                                     color={0,0,127}));
  connect(unoHeaHigMin, falEdg.u) annotation (Line(points={{-280,-70},{-120,-70},
          {-120,-50},{-102,-50}}, color={255,0,255}));
  connect(TZonMax, addPar.u)
    annotation (Line(points={{-280,-110},{-182,-110}}, color={0,0,127}));
  connect(TZonMin, addPar1.u)
    annotation (Line(points={{-280,-150},{-182,-150}}, color={0,0,127}));
  connect(maxHigUnoCoo, falEdg1.u) annotation (Line(points={{-280,-270},{-120,-270},
          {-120,-250},{-102,-250}}, color={255,0,255}));
  connect(totColZon, intGreThr.u)
    annotation (Line(points={{-280,-10},{-182,-10}}, color={255,127,0}));
  connect(totColZon, intGreThr1.u) annotation (Line(points={{-280,-10},{-220,-10},
          {-220,-40},{-182,-40}}, color={255,127,0}));
  connect(totHotZon, intGreThr2.u)
    annotation (Line(points={{-280,-210},{-182,-210}}, color={255,127,0}));
  connect(totHotZon, intGreThr3.u) annotation (Line(points={{-280,-210},{-220,
          -210},{-220,-240},{-182,-240}}, color={255,127,0}));
  connect(intGreThr2.y, or4.u1)
    annotation (Line(points={{-158,-210},{-102,-210}}, color={255,0,255}));
  connect(intGreThr3.y, or4.u2) annotation (Line(points={{-158,-240},{-120,-240},
          {-120,-218},{-102,-218}}, color={255,0,255}));
  connect(setBacMod.y, addInt2.u1) annotation (Line(points={{222,-10},{230,-10},
          {230,-74},{238,-74}}, color={255,127,0}));
  connect(freProSetBacMod.y, addInt2.u2) annotation (Line(points={{222,-110},{230,
          -110},{230,-86},{238,-86}}, color={255,127,0}));
  connect(setUpMod.y, addInt3.u2) annotation (Line(points={{222,-210},{260,-210},
          {260,-196},{278,-196}}, color={255,127,0}));
  connect(addInt2.y, addInt3.u1) annotation (Line(points={{262,-80},{270,-80},{270,
          -184},{278,-184}}, color={255,127,0}));
  connect(addInt3.y, addInt4.u1) annotation (Line(points={{302,-190},{310,-190},
          {310,-274},{318,-274}}, color={255,127,0}));
  connect(booToInt3.y, addInt4.u2) annotation (Line(points={{242,-330},{300,-330},
          {300,-286},{318,-286}}, color={255,127,0}));
  connect(addInt5.y, yOpeMod)
    annotation (Line(points={{442,-20},{480,-20}}, color={255,127,0}));
  connect(uWinSta, and3.u1)
    annotation (Line(points={{-280,50},{258,50}}, color={255,0,255}));
  connect(notOcc.y, and3.u2) annotation (Line(points={{222,30},{240,30},{240,42},
          {258,42}}, color={255,0,255}));
  connect(and3.y, not1.u)
    annotation (Line(points={{282,50},{298,50}}, color={255,0,255}));
  connect(addInt5.y, notOcc.u) annotation (Line(points={{442,-20},{450,-20},{450,
          10},{180,10},{180,30},{198,30}}, color={255,127,0}));
  connect(not1.y, winOpe.u)
    annotation (Line(points={{322,50},{338,50}}, color={255,0,255}));
  connect(booToRea.y, swi1.u3) annotation (Line(points={{200,220},{210,220},{
          210,214},{248,214}}, color={0,0,127}));
  connect(uOcc, swi1.u2) annotation (Line(points={{-280,330},{-220,330},{-220,
          242},{216,242},{216,222},{248,222}}, color={255,0,255}));
  connect(swi1.y, setBacMod1.u)
    annotation (Line(points={{272,222},{286,222}}, color={0,0,127}));
  connect(setBacMod1.y, addInt.u1) annotation (Line(points={{310,222},{322,222},
          {322,256},{338,256}}, color={255,127,0}));
  connect(addInt.y, addInt1.u2) annotation (Line(points={{362,250},{368,250},{
          368,268},{374,268}}, color={255,127,0}));
  connect(occMod.y, addInt1.u1)
    annotation (Line(points={{322,280},{374,280}}, color={255,127,0}));
  connect(addInt1.y, addInt5.u1) annotation (Line(points={{398,274},{406,274},{
          406,-14},{418,-14}}, color={255,127,0}));
  connect(addInt4.y, addInt5.u2) annotation (Line(points={{342,-280},{406,-280},
          {406,-26},{418,-26}}, color={255,127,0}));
  connect(booToRea1.y, swi2.u3) annotation (Line(points={{202,150},{212,150},{
          212,144},{250,144}}, color={0,0,127}));
  connect(swi2.u2, swi1.u2) annotation (Line(points={{250,152},{216,152},{216,
          222},{248,222}},                     color={255,0,255}));
  connect(unoPerInd.y, swi1.u1) annotation (Line(
      points={{122,260},{228,260},{228,230},{248,230}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(unoPerInd.y, swi2.u1) annotation (Line(
      points={{122,260},{228,260},{228,160},{250,160}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(swi2.y, setBacMod2.u)
    annotation (Line(points={{274,152},{286,152}}, color={0,0,127}));
  connect(setBacMod2.y, addInt.u2) annotation (Line(points={{310,152},{328,152},
          {328,244},{338,244}}, color={255,127,0}));
  connect(and4.y, booToRea.u)
    annotation (Line(points={{144,220},{176,220}}, color={255,0,255}));
  connect(and4.y, or3.u2) annotation (Line(points={{144,220},{164,220},{164,72},
          {-30,72},{-30,30},{-2,30}}, color={255,0,255}));
  connect(truFalHol.y, and4.u1)
    annotation (Line(points={{104,220},{120,220}}, color={255,0,255}));
  connect(hys4.y, and4.u2) annotation (Line(points={{0,220},{4,220},{4,206},{
          110,206},{110,212},{120,212}}, color={255,0,255}));
  connect(truFalHol1.y, and1.u1)
    annotation (Line(points={{104,150},{120,150}}, color={255,0,255}));
  connect(hys5.y, and1.u2) annotation (Line(points={{0,150},{4,150},{4,132},{
          110,132},{110,142},{120,142}}, color={255,0,255}));
  connect(hys4.y, and2.u1)
    annotation (Line(points={{0,220},{18,220}}, color={255,0,255}));
  connect(uHigOccCoo, and2.u2) annotation (Line(points={{-280,80},{10,80},{10,212},
          {18,212}}, color={255,0,255}));
  connect(uOccHeaHig, and5.u2) annotation (Line(points={{-280,110},{14,110},{14,
          142},{18,142}}, color={255,0,255}));
  connect(hys5.y, and5.u1)
    annotation (Line(points={{0,150},{18,150}}, color={255,0,255}));
  connect(truFalHol1.u, edg.y)
    annotation (Line(points={{80,150},{72,150}}, color={255,0,255}));
  connect(and5.y, edg.u)
    annotation (Line(points={{42,150},{48,150}}, color={255,0,255}));
  connect(and2.y, edg1.u)
    annotation (Line(points={{42,220},{48,220}}, color={255,0,255}));
  connect(edg1.y, truFalHol.u) annotation (Line(points={{72,220},{76,220},{76,220},
          {80,220}}, color={255,0,255}));

annotation (
  defaultComponentName = "opeModSel",
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-260,-360},{460,360}}),
        graphics={
        Rectangle(
          extent={{-258,-282},{458,-358}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-258,-202},{458,-278}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-258,-82},{458,-158}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-258,-2},{458,-78}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-258,188},{458,112}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-258,268},{458,192}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-258,348},{458,272}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{336,332},{426,314}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Occupied mode"),
        Text(
          extent={{296,-32},{380,-54}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Setback mode"),
        Text(
          extent={{324,-224},{396,-246}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Setup mode"),
        Text(
          extent={{314,-308},{418,-338}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Unoccupied mode"),
        Text(
          extent={{280,-114},{452,-142}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Freeze protection setback mode"),
        Text(
          extent={{264,140},{352,116}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Warm-up mode"),
        Text(
          extent={{348,218},{436,190}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Cool-down mode")}),
   Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,80},{-52,68}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="maxCooDowTim"),
        Text(
          extent={{-98,64},{-56,54}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="maxWarUpTim"),
        Text(
          extent={{58,12},{96,-10}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yOpeMod"),
        Text(
          extent={{-120,144},{100,106}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,94},{-74,82}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="tNexOcc"),
        Text(
          extent={{-100,104},{-82,96}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uOcc"),
        Text(
          extent={{-98,42},{-50,30}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="occHeaHigMin"),
        Text(
          extent={{-98,24},{-48,12}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="maxHigOccCoo"),
        Text(
          extent={{-98,-14},{-60,-24}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="totColZon"),
        Text(
          extent={{-98,-32},{-48,-44}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="unoHeaHigMin"),
        Text(
          extent={{-98,-56},{-70,-64}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonMax"),
        Text(
          extent={{-100,-76},{-70,-84}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonMin"),
        Text(
          extent={{-98,-96},{-66,-104}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="totHotZon"),
        Text(
          extent={{-98,-112},{-48,-124}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="maxHigUnoCoo"),
        Text(
          visible=have_winSen,
          extent={{-98,8},{-68,-4}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uWinSta")}),
   Documentation(info="<html>
<p>
This block outputs VAV system operation mode. It is implemented according to
ASHRAE guideline G36, PART 5.C.6 (zone group operating modes).
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
<code>TZonHeaSetUno</code>, the zone group shall enter <i>setback mode</i> until
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
in the zone group rise above their unoccupied cooling setpoints <code>TZonCooSetUno</code>,
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
