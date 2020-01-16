within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints;
block OperationMode_rei "Block that outputs the operation mode"

  parameter Integer numZon(min=1) "Number of zones";
  parameter Real preWarCooTim(unit="s") = 10800
    "Maximum cool-down or warm-up time";
  parameter Real TZonFreProOn(unit="K") = 277.55
    "Threshold zone temperature value to activate freeze protection mode";
  parameter Real TZonFreProOff(unit="K") = 280.35
    "Threshold zone temperature value to finish the freeze protection mode";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Zone occupancy status: true=occupied, false=unoccupied"
    annotation (Placement(transformation(extent={{-300,280},{-260,320}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
    final unit="s", quantity="Time")
    "Time to next occupied period"
    annotation (Placement(transformation(extent={{-300,240},{-260,280}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput cooDowTim(
    final unit="s",
    final quantity="Time")
    "Cool-down time retrieved from optimal cool-down block"
    annotation (Placement(transformation(extent={{-300,180},{-260,220}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput warUpTim(
    final unit="s",
    final quantity="Time") "Warm-up time retrieved from optimal warm-up block"
    annotation (Placement(transformation(extent={{-300,100},{-260,140}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput occHeaHigMin
    "True when the occupied heating setpoint temperature is higher than the minimum zone temperature"
    annotation (Placement(transformation(extent={{-300,60},{-260,100}}),
        iconTransformation(extent={{-20,-20},{20,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput maxHigOccCoo
    "True when the maximum zone temperature is higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-300,30},{-260,70}}),
        iconTransformation(extent={{-20,-20},{20,20}})));
  CDL.Interfaces.BooleanInput unoHeaHigMin
    "True when the unoccupied heating setpoint is higher than minimum zone temperature"
    annotation (Placement(transformation(extent={{-300,-90},{-260,-50}}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
  CDL.Interfaces.RealInput TZonMax(each final unit="K", each quantity="ThermodynamicTemperature")
    "Maximum zone temperature" annotation (Placement(transformation(extent={{-300,
            -130},{-260,-90}}), iconTransformation(extent={{-140,-70},{-100,-30}})));
  CDL.Interfaces.RealInput TZonMin(each final unit="K", each quantity="ThermodynamicTemperature")
    "Minimum zone temperature" annotation (Placement(transformation(extent={{-300,
            -170},{-260,-130}}), iconTransformation(extent={{-140,-70},{-100,-30}})));
  CDL.Interfaces.BooleanInput maxHigUnoCoo
    "True when the maximum zone temperature is higher than unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-300,-290},{-260,-250}}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
  CDL.Interfaces.IntegerInput totColZon "Total number of cold zone" annotation (
     Placement(transformation(extent={{-300,-30},{-260,10}}),
        iconTransformation(extent={{-646,-20},{-606,20}})));
  CDL.Interfaces.IntegerInput totHotZon "Total number of hot zone" annotation (
      Placement(transformation(extent={{-302,-230},{-262,-190}}),
        iconTransformation(extent={{-646,-20},{-606,20}})));



  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yOpeMod "Operation mode"
    annotation (Placement(transformation(extent={{460,-40},{500,0}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant occModInd(
    k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "Occupied mode "
    annotation (Placement(transformation(extent={{200,270},{220,290}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant unoPerInd(final k=0)
    "Index to indicate unoccupied period"
    annotation (Placement(transformation(extent={{100,220},{120,240}})));
  Buildings.Controls.OBC.CDL.Logical.Switch corCooDowTim "Corrected cool down period"
    annotation (Placement(transformation(extent={{-20,170},{0,190}})));
  Buildings.Controls.OBC.CDL.Logical.Switch corWarUpTim "Corrected warm-up period"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
  CDL.Integers.GreaterThreshold                               intGreThr(final
      threshold=4) "Check if the number of cold zones is not less than than 5"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  CDL.Integers.GreaterThreshold                               intGreThr1(final
      threshold=numZon - 1)
    "Check if all zones are cold zone"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Check if the unoccupied heating setpoint becomes lower than minimum zone temperature: true to false"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "If all zone temperature are higher than unoccupied heating setpoint
    by a given limit, then the setback mode should be off"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "If all zone temperature are higher than threshold temperature of ending freeze protection, 
    then freeze protection setback mode should be off"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "If all zone temperature are lower than unoccupied cooling setpoint
    by a given limit, then the setup mode should be off"
    annotation (Placement(transformation(extent={{-40,-220},{-20,-200}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1
    "Check if the unoccupied cooling setpoint becomes higher than maximum zone temperature: true to false"
    annotation (Placement(transformation(extent={{-100,-260},{-80,-240}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    pre_y_start=true,
    uHigh=0,
    uLow=-60)
    "Hysteresis that outputs if the maximum cool-down time is more than the allowed cool-down time"
    annotation (Placement(transformation(extent={{-100,170},{-80,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3(
    pre_y_start=true,
    uHigh=0,
    uLow=-60)
    "Hysteresis that outputs if the maximum warm-up time is more than allowed warm-up time"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add5(
    final k1=-1,
    final k2=+1)
    "Calculate differential between time-to-next-occupancy and the cool-down time"
    annotation (Placement(transformation(extent={{40,180},{60,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4(
    pre_y_start=false,
    uHigh=0,
    uLow=-60)
    "Hysteresis to activate the cool-down model"
    annotation (Placement(transformation(extent={{80,180},{100,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys5(
    pre_y_start=false,
    uHigh=0,
    uLow=-60)
    "Hysteresis to activate the warm-up model"
    annotation (Placement(transformation(extent={{80,140},{100,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add6(
    final k1=-1,
    final k2=+1)
    "Calculate differential between time-to-next-occupancy and the warm-up time"
    annotation (Placement(transformation(extent={{40,140},{60,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys9(
    pre_y_start=false,
    uLow=-0.1,
    uHigh=0.1)
    "Hysteresis that outputs if any zone temperature is lower than freeze protection threshold temperature"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    p=TZonFreProOn,
    final k=-1)
    "Calculate differential between minimum zone temperature and freeze protection threshold temperature"
    annotation (Placement(transformation(extent={{-180,-120},{-160,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys10(
    pre_y_start=false,
    uLow=-0.1,
    uHigh=0.1)
    "Hysteresis that outputs if all zone temperature are higher than threshold temperature of ending freeze protection"
    annotation (Placement(transformation(extent={{-140,-160},{-120,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final k=1,
    p=(-1)*TZonFreProOff)
    "Calculate differential between maximum zone temperature and threshold temperature of ending freeze protection"
    annotation (Placement(transformation(extent={{-180,-160},{-160,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar2(
    p=preWarCooTim,
    final k=-1)
    "Calculate the differential between maximum cool down time and the allowed maximum cool down time"
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar3(
    p=preWarCooTim,
    final k=-1)
    "Calculate the differential between maximum warm-up time and the allowed maximum warm-up time"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxWarCooTime(
    k=preWarCooTim)
    "Allowed maximum warm-up or cool-down time"
    annotation (Placement(transformation(extent={{-200,150},{-180,170}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat3
    "Hold true when it should be in warm-up mode"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat4
    "Hold true when it should be in cool-down mode"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));


  CDL.Integers.GreaterThreshold                               intGreThr2(final
      threshold=4) "Check if the number of hot zones is not less than than 5"
    annotation (Placement(transformation(extent={{-180,-220},{-160,-200}})));
  CDL.Integers.GreaterThreshold                               intGreThr3(final
      threshold=numZon - 1) "Check if all zones are hot zone"
    annotation (Placement(transformation(extent={{-180,-250},{-160,-230}})));
  CDL.Integers.Add addInt "Sum of two integer inputs"
    annotation (Placement(transformation(extent={{300,160},{320,180}})));
  CDL.Integers.Add addInt1 "Sum of two integer inputs"
    annotation (Placement(transformation(extent={{360,210},{380,230}})));
  CDL.Integers.Add addInt2 "Sum of two integer inputs"
    annotation (Placement(transformation(extent={{240,-90},{260,-70}})));
  CDL.Integers.Add addInt3 "Sum of two integer inputs"
    annotation (Placement(transformation(extent={{280,-200},{300,-180}})));
  CDL.Integers.Add addInt4 "Sum of two integer inputs"
    annotation (Placement(transformation(extent={{320,-290},{340,-270}})));
  CDL.Integers.Add addInt5 "Sum of two integer inputs"
    annotation (Placement(transformation(extent={{420,-30},{440,-10}})));
protected
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger occMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{300,240},{320,260}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger setBacMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{200,-20},{220,0}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger freProSetBacMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{200,-120},{220,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger setUpMod
    "Convert Real number to Integer number"
    annotation (Placement(transformation(extent={{200,-220},{220,-200}})));
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
    annotation (Placement(transformation(extent={{220,-340},{240,-320}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea6(
    realTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.setUp)
    "Convert Boolean to Real "
    annotation (Placement(transformation(extent={{60,-220},{80,-200}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea4(
    realTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.freezeProtection)
    "Convert Boolean to Real "
    annotation (Placement(transformation(extent={{60,-120},{80,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea3(
    realTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.setBack)
    "Convert Boolean to Real "
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    message="Level 3 alarm: freeze protection setback")
    "Generate alarm message"
    annotation (Placement(transformation(extent={{100,-160},{120,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
   annotation (Placement(transformation(extent={{180,-340},{200,-320}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Check if the warm-up time should be activated"
    annotation (Placement(transformation(extent={{200,140},{220,160}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Check if the cool-down time should be activated"
    annotation (Placement(transformation(extent={{200,180},{220,200}})));
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
    annotation (Placement(transformation(extent={{260,240},{280,260}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3
    "If the Cool-down, warm-up, or Occupied mode is on, then setback mode should not be activated."
    annotation (Placement(transformation(extent={{160,-20},{180,0}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi4
    "If the Cool-down, warm-up, or Occupied mode is on, then freeze protection setback mode should not be activated."
    annotation (Placement(transformation(extent={{160,-120},{180,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi5
    "If the Cool-down, warm-up, or Occupied mode is on, then setup mode should not be activated."
    annotation (Placement(transformation(extent={{160,-220},{180,-200}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{120,160},{140,180}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Logical not"
    annotation (Placement(transformation(extent={{120,120},{140,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5 "Logical not"
    annotation (Placement(transformation(extent={{60,-160},{80,-140}})));

equation
  connect(swi.y, occMod.u)
    annotation (Line(points={{282,250},{282,250},{298,250}},
      color={0,0,127}));
  connect(occModInd.y, swi.u1)
    annotation (Line(points={{222,280},{240,280},{240,258},{258,258}},
      color={0,0,127}, pattern=LinePattern.Dash));
  connect(unoPerInd.y, swi.u3)
    annotation (Line(points={{122,230},{150,230},{150,242},{258,242}},
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
    annotation (Line(points={{122,230},{150,230},{150,-2},{158,-2}},
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
    annotation (Line(points={{122,230},{150,230},{150,-102},{158,-102}},
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
    annotation (Line(points={{122,230},{150,230},{150,-202},{158,-202}},
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
  connect(and2.y, booToInt.u)
    annotation (Line(points={{222,190},{258,190}}, color={255,0,255}));
  connect(and1.y, booToInt1.u)
    annotation (Line(points={{222,150},{258,150}}, color={255,0,255}));
  connect(and2.y, or3.u2)
    annotation (Line(points={{222,190},{230,190},{230,70},{-20,70},{-20,30},{-2,
          30}},
      color={255,0,255}));
  connect(and1.y, or3.u1)
    annotation (Line(points={{222,150},{240,150},{240,60},{-10,60},{-10,38},{-2,
          38}},
      color={255,0,255}));
  connect(uOcc, swi.u2)
    annotation (Line(points={{-280,300},{-220,300},{-220,250},{258,250}},
      color={255,0,255}));
  connect(uOcc, or3.u3)
    annotation (Line(points={{-280,300},{-220,300},{-220,22},{-2,22}},
      color={255,0,255}));
  connect(hys2.y, corCooDowTim.u2)
    annotation (Line(points={{-78,180},{-22,180}},          color={255,0,255}));
  connect(hys3.y, corWarUpTim.u2)
    annotation (Line(points={{-78,140},{-22,140}},          color={255,0,255}));
  connect(add5.y, hys4.u)
    annotation (Line(points={{62,190},{78,190}},            color={0,0,127}));
  connect(hys4.y, and2.u1)
    annotation (Line(points={{102,190},{198,190}},
      color={255,0,255}));
  connect(tNexOcc, add5.u1)
    annotation (Line(points={{-280,260},{20,260},{20,196},{38,196}},
      color={0,0,127}));
  connect(corCooDowTim.y, add5.u2)
    annotation (Line(points={{2,180},{30,180},{30,184},{38,184}},
      color={0,0,127}));
  connect(tNexOcc, add6.u1)
    annotation (Line(points={{-280,260},{20,260},{20,156},{38,156}},
      color={0,0,127}));
  connect(corWarUpTim.y, add6.u2)
    annotation (Line(points={{2,140},{20,140},{20,144},{38,144}},
      color={0,0,127}));
  connect(add6.y, hys5.u)
    annotation (Line(points={{62,150},{78,150}},            color={0,0,127}));
  connect(hys5.y, and1.u1)
    annotation (Line(points={{102,150},{198,150}}, color={255,0,255}));
  connect(addPar.y, hys9.u)
    annotation (Line(points={{-158,-110},{-142,-110}},       color={0,0,127}));
  connect(hys9.y, lat1.u)
    annotation (Line(points={{-118,-110},{-42,-110}},
                                                    color={255,0,255}));
  connect(addPar1.y, hys10.u)
    annotation (Line(points={{-158,-150},{-142,-150}},
                                                   color={0,0,127}));
  connect(hys10.y, lat1.clr)
    annotation (Line(points={{-118,-150},{-80,-150},{-80,-116},{-42,-116}},
      color={255,0,255}));
  connect(addPar2.y, hys2.u)
    annotation (Line(points={{-118,180},{-102,180}},
                                                   color={0,0,127}));
  connect(addPar3.y, hys3.u)
    annotation (Line(points={{-118,140},{-102,140}},
                                                   color={0,0,127}));
  connect(maxWarCooTime.y, corCooDowTim.u3)
    annotation (Line(points={{-178,160},{-60,160},{-60,172},{-22,172}},
      color={0,0,127}));
  connect(maxWarCooTime.y, corWarUpTim.u3)
    annotation (Line(points={{-178,160},{-60,160},{-60,132},{-22,132}},
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
  connect(lat3.y, and1.u2)
    annotation (Line(points={{-78,80},{188,80},{188,142},{198,142}},
      color={255,0,255}));
  connect(lat4.y, and2.u2)
    annotation (Line(points={{-78,50},{-30,50},{-30,90},{180,90},{180,182},{198,
          182}},
      color={255,0,255}));
  connect(hys4.y, not3.u)
    annotation (Line(points={{102,190},{110,190},{110,170},{118,170}},
      color={255,0,255}));
  connect(hys5.y, not4.u)
    annotation (Line(points={{102,150},{110,150},{110,130},{118,130}},
      color={255,0,255}));
  connect(not4.y, lat3.clr)
    annotation (Line(points={{142,130},{160,130},{160,110},{-140,110},{-140,74},
          {-102,74}},
                color={255,0,255}));
  connect(not3.y, lat4.clr)
    annotation (Line(points={{142,170},{170,170},{170,100},{-160,100},{-160,44},
          {-102,44}},
                color={255,0,255}));
  connect(lat1.y, not5.u)
    annotation (Line(points={{-18,-110},{0,-110},{0,-150},{58,-150}},
      color={255,0,255}));
  connect(not5.y, assMes.u)
    annotation (Line(points={{82,-150},{98,-150}},   color={255,0,255}));

  connect(cooDowTim, addPar2.u) annotation (Line(points={{-280,200},{-160,200},{
          -160,180},{-142,180}}, color={0,0,127}));
  connect(cooDowTim, corCooDowTim.u1) annotation (Line(points={{-280,200},{-60,200},
          {-60,188},{-22,188}}, color={0,0,127}));
  connect(warUpTim, addPar3.u) annotation (Line(points={{-280,120},{-160,120},{-160,
          140},{-142,140}}, color={0,0,127}));
  connect(warUpTim, corWarUpTim.u1) annotation (Line(points={{-280,120},{-40,120},
          {-40,148},{-22,148}}, color={0,0,127}));
  connect(occHeaHigMin, lat3.u)
    annotation (Line(points={{-280,80},{-102,80}}, color={255,0,255}));
  connect(maxHigOccCoo, lat4.u)
    annotation (Line(points={{-280,50},{-102,50}}, color={255,0,255}));
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
    annotation (Line(points={{-282,-210},{-182,-210}}, color={255,127,0}));
  connect(totHotZon, intGreThr3.u) annotation (Line(points={{-282,-210},{-220,-210},
          {-220,-240},{-182,-240}}, color={255,127,0}));
  connect(intGreThr2.y, or4.u1)
    annotation (Line(points={{-158,-210},{-102,-210}}, color={255,0,255}));
  connect(intGreThr3.y, or4.u2) annotation (Line(points={{-158,-240},{-120,-240},
          {-120,-218},{-102,-218}}, color={255,0,255}));
  connect(booToInt.y, addInt.u1) annotation (Line(points={{282,190},{290,190},{290,
          176},{298,176}}, color={255,127,0}));
  connect(booToInt1.y, addInt.u2) annotation (Line(points={{282,150},{290,150},{
          290,164},{298,164}}, color={255,127,0}));
  connect(occMod.y, addInt1.u1) annotation (Line(points={{322,250},{340,250},{340,
          226},{358,226}}, color={255,127,0}));
  connect(addInt.y, addInt1.u2) annotation (Line(points={{322,170},{340,170},{340,
          214},{358,214}}, color={255,127,0}));
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
  connect(addInt1.y, addInt5.u1) annotation (Line(points={{382,220},{400,220},{400,
          -14},{418,-14}}, color={255,127,0}));
  connect(addInt4.y, addInt5.u2) annotation (Line(points={{342,-280},{400,-280},
          {400,-26},{418,-26}}, color={255,127,0}));
  connect(addInt5.y, yOpeMod)
    annotation (Line(points={{442,-20},{480,-20}}, color={255,127,0}));
annotation (
  defaultComponentName = "opeModSel",
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-260,-360},{460,320}}),
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
          extent={{-258,158},{458,82}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-258,238},{458,162}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-258,318},{458,242}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{336,302},{426,284}},
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
          extent={{250,140},{338,116}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Warm-up mode"),
        Text(
          extent={{188,232},{276,204}},
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
          extent={{-96,64},{-46,40}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="cooDowTim"),
        Text(
          extent={{-96,42},{-48,18}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="warUpTim"),
        Text(
          extent={{-96,-38},{-58,-60}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="zonTem"),
        Text(
          extent={{-96,-50},{-28,-86}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonHeaSetUnoTem"),
        Text(
          extent={{-96,-74},{-28,-106}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonCooSetUnoTem"),
        Text(
          extent={{56,12},{94,-10}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yOpeMod"),
        Text(
          extent={{-96,18},{-28,-18}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonHeaSetOccTem"),
        Text(
          extent={{-96,0},{-28,-36}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonCooSetOccTem"),
        Text(
          extent={{-120,144},{100,106}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-96,80},{-56,62}},
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
end OperationMode_rei;
