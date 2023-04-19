within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints;
block Supply "Supply air set point for single zone VAV system"

  parameter Real TSup_max(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Maximum supply air temperature for heating"
    annotation (Dialog(group="Temperatures"));
  parameter Real TSup_min(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Minimum supply air temperature for cooling"
    annotation (Dialog(group="Temperatures"));
  parameter Real TSupDew_max(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Maximum supply air dew-point temperature. It's typically only needed in humid type “A” climates. A typical value is 17°C. 
    For mild and dry climates, a high set point (e.g. 24°C) should be entered for maximum efficiency"
    annotation (Dialog(group="Temperatures"));
  parameter Real TSupDea_min(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=294.15
    "Minimum supply temperature when it is in deadband state"
    annotation (__cdl(ValueInReference=True), Dialog(group="Temperatures"));
  parameter Real TSupDea_max(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=297.15
    "Maximum supply temperature when it is in deadband state"
    annotation (__cdl(ValueInReference=True), Dialog(group="Temperatures"));
  parameter Real maxHeaSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Maximum fan speed for heating"
    annotation (Dialog(group="Speed"));
  parameter Real maxCooSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Maximum fan speed for cooling"
    annotation (Dialog(group="Speed"));
  parameter Real minSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Minimum fan speed"
    annotation (Dialog(group="Speed"));
  parameter Real looHys(
    final unit="1")=0.01
    "Loop output hysteresis below which the output will be seen as zero"
    annotation (__cdl(ValueInReference=False), Dialog(tab="Advanced"));
  parameter Real temPoiOne(
    final unit="1",
    final min=0,
    final max=1)=0.5
    "Point 1 on x-axis of control map for temperature control, when it is in heating state"
    annotation (__cdl(ValueInReference=True),
                Dialog(tab="Advanced", group="Temperatures"));
  parameter Real temPoiTwo(
    final unit="1",
    final min=0,
    final max=1)=0.25
    "Point 2 on x-axis of control map for temperature control, when it is in cooling state"
    annotation (__cdl(ValueInReference=True),
                Dialog(tab="Advanced", group="Temperatures"));
  parameter Real temPoiThr(
    final unit="1",
    final min=0,
    final max=1)=0.5
    "Point 3 on x-axis of control map for temperature control, when it is in cooling state"
    annotation (__cdl(ValueInReference=True),
                Dialog(tab="Advanced", group="Temperatures"));
  parameter Real temPoiFou(
    final unit="1",
    final min=0,
    final max=1)=0.75
    "Point 4 on x-axis of control map for temperature control, when it is in cooling state"
    annotation (__cdl(ValueInReference=True),
                Dialog(tab="Advanced", group="Temperatures"));
  parameter Real spePoiOne(
    final unit="1",
    final min=0,
    final max=1)=0.5
    "Point 1 on x-axis of control map for speed control, when it is in heating state"
    annotation (__cdl(ValueInReference=True),
                Dialog(tab="Advanced", group="Speed"));
  parameter Real spePoiTwo(
    final unit="1",
    final min=0,
    final max=1)=0.25
    "Point 2 on x-axis of control map for speed control, when it is in cooling state"
    annotation (__cdl(ValueInReference=True),
                Dialog(tab="Advanced", group="Speed"));
  parameter Real spePoiThr(
    final unit="1",
    final min=0,
    final max=1)=0.5
    "Point 3 on x-axis of control map for speed control, when it is in cooling state"
    annotation (__cdl(ValueInReference=True),
                Dialog(tab="Advanced", group="Speed"));
  parameter Real spePoiFou(
    final unit="1",
    final min=0,
    final max=1)=0.75
    "Point 4 on x-axis of control map for speed control, when it is in cooling state"
    annotation (__cdl(ValueInReference=True),
                Dialog(tab="Advanced", group="Speed"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-220,290},{-180,330}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature"
    annotation (Placement(transformation(extent={{-220,220},{-180,260}}),
        iconTransformation(extent={{-140,44},{-100,84}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-220,140},{-180,180}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-220,80},{-180,120}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-220,10},{-180,50}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Cooling setpoints for zone temperature"
    annotation (Placement(transformation(extent={{-220,-120},{-180,-80}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Heating setpoints for zone temperature"
    annotation (Placement(transformation(extent={{-220,-160},{-180,-120}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final min=0,
    final max=1,
    final unit="1") "Fan speed"
    annotation (Placement(transformation(extent={{180,320},{220,360}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1SupFan
    "Supply fan commanded status"
    annotation (Placement(transformation(extent={{180,280},{220,320}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupHeaEcoSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature setpoint for heating coil and for economizer"
    annotation (Placement(transformation(extent={{180,-220},{220,-180}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{180,-300},{220,-260}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant fanOff(
    final k=0)
    "Fan off status"
    annotation (Placement(transformation(extent={{40,350},{60,370}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch fanSpe "Supply fan speed"
    annotation (Placement(transformation(extent={{100,330},{120,350}})));
  Buildings.Controls.OBC.CDL.Continuous.LimitSlewRate ramLim(
    final raisingSlewRate=1/600,
    final Td=60)
    "Prevent changes in fan speed of more than 10% per minute"
    annotation (Placement(transformation(extent={{140,330},{160,350}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxDewPoi(
    final k=TSupDew_max)
    "Maximum supply air dew-point temperature"
    annotation (Placement(transformation(extent={{-160,270},{-140,290}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=-1)
    "Maximum supply dewpoint temperature minus threshold"
    annotation (Placement(transformation(extent={{-100,270},{-80,290}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=-6)
    "Zone temperature minus threshold"
    annotation (Placement(transformation(extent={{-100,230},{-80,250}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar2(
    final p=0.5)
    "Zone temperature plus threshold"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Min endPoiTwo
    "End point two for specifying medium fan speed"
    annotation (Placement(transformation(extent={{-40,250},{-20,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Min endPoiOne
    "End point one for specifying medium fan speed"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minFanSpe(
    final k=minSpe)
    "Minimum fan speed"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxCooFanSpe(
    final k=maxCooSpe)
    "Maximum fan speed for cooling"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Line medFanSpe
    "Medium fan speed"
    annotation (Placement(transformation(extent={{80,210},{100,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Average aveZonSet
    "Average of the zone heating and cooling setpoint"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Limiter lim(
    final uMax=TSupDea_max,
    final uMin=TSupDea_min)
    "Limiter that outputs the dead band value for the supply air temperature"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Line heaFanSpe
    "Fan speed when it is in heating state"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant speOnePoi(
    final k=spePoiOne)
    "Speed control point one in x-axis of control map"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxHeaFanSpe(
    final k=maxHeaSpe)
    "Maximum fan speed for heating"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant speTwoPoi(
    final k=spePoiTwo)
    "Speed control point two in x-axis of control map"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant speThrPoi(
    final k=spePoiThr)
    "Speed control point three in x-axis of control map"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant speFouPoi(
    final k=spePoiFou)
    "Speed control point four in x-axis of control map"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Line cooFanSpe1
    "Fan speed when it is in cooling state"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Line cooFanSpe2
    "Fan speed when it is in cooling mode"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Max spe
    "Fan speed"
    annotation (Placement(transformation(extent={{140,60},{160,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Line heaSupTem
    "Supply air temperature when it is in heating state"
    annotation (Placement(transformation(extent={{60,-160},{80,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant temOnePoi(
    final k=temPoiOne)
    "Temperature control point one in x-axis of control map"
    annotation (Placement(transformation(extent={{-120,-190},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxSupTem(
    final k=TSup_max)
    "Highest heating supply air temperature"
    annotation (Placement(transformation(extent={{-40,-190},{-20,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant temTwoPoi(
    final k=temPoiTwo)
    "Temperature control point two in x-axis of control map"
    annotation (Placement(transformation(extent={{-120,-270},{-100,-250}})));
  Buildings.Controls.OBC.CDL.Continuous.Line cooSupTem
    "Supply air temperature when it is in cooling state"
    annotation (Placement(transformation(extent={{60,-250},{80,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant supCooTem(
    final k=TSup_min)
    "Cooling supply air temperature"
    annotation (Placement(transformation(extent={{-120,-310},{-100,-290}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar3(
    final p=-1)
    "Minimum cooling supply temperature minus threshold"
    annotation (Placement(transformation(extent={{-40,-280},{-20,-260}})));
  Buildings.Controls.OBC.CDL.Continuous.Line cooSupTem1
    "Supply air temperature when it is in cooling state"
    annotation (Placement(transformation(extent={{60,-340},{80,-320}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant temThrPoi(
    final k=temPoiThr)
    "Temperature control point three in x-axis of control map"
    annotation (Placement(transformation(extent={{-40,-320},{-20,-300}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant temFouPoi(
    final k=temPoiFou)
    "Temperature control point four in x-axis of control map"
    annotation (Placement(transformation(extent={{-120,-370},{-100,-350}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch cooFan
    "Fan speed when it is in cooling state"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold heaSta(
    final t=looHys,
    final h=0.8*looHys)
    "Check if it is in heating state"
    annotation (Placement(transformation(extent={{-40,-230},{-20,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch supTemSet
    "Supply temperature setpoint"
    annotation (Placement(transformation(extent={{120,-210},{140,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch supTemSet1
    "Supply temperature setpoint"
    annotation (Placement(transformation(extent={{120,-290},{140,-270}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant unoMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    "Unoccupied mode index"
    annotation (Placement(transformation(extent={{-160,330},{-140,350}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isUnoMod
    "Check if it is in unoccupied mode"
    annotation (Placement(transformation(extent={{-120,330},{-100,350}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Supply fan status"
    annotation (Placement(transformation(extent={{40,290},{60,310}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre(
    final h=spePoiFou - spePoiThr)
    "Check setpoint section"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));

equation
  connect(unoMod.y, isUnoMod.u1)
    annotation (Line(points={{-138,340},{-122,340}}, color={255,127,0}));
  connect(uOpeMod, isUnoMod.u2) annotation (Line(points={{-200,310},{-130,310},{
          -130,332},{-122,332}},  color={255,127,0}));
  connect(isUnoMod.y, fanSpe.u2)
    annotation (Line(points={{-98,340},{98,340}}, color={255,0,255}));
  connect(fanOff.y, fanSpe.u1) annotation (Line(points={{62,360},{80,360},{80,348},
          {98,348}},      color={0,0,127}));
  connect(fanSpe.y, ramLim.u)
    annotation (Line(points={{122,340},{138,340}}, color={0,0,127}));
  connect(maxDewPoi.y, addPar.u)
    annotation (Line(points={{-138,280},{-102,280}}, color={0,0,127}));
  connect(addPar.y, endPoiTwo.u1) annotation (Line(points={{-78,280},{-60,280},{
          -60,266},{-42,266}},  color={0,0,127}));
  connect(addPar1.y, endPoiTwo.u2) annotation (Line(points={{-78,240},{-60,240},
          {-60,254},{-42,254}}, color={0,0,127}));
  connect(addPar2.y, endPoiOne.u1) annotation (Line(points={{-78,200},{-60,200},
          {-60,186},{-42,186}}, color={0,0,127}));
  connect(maxDewPoi.y, endPoiOne.u2) annotation (Line(points={{-138,280},{-120,280},
          {-120,174},{-42,174}},      color={0,0,127}));
  connect(endPoiTwo.y, medFanSpe.x1) annotation (Line(points={{-18,260},{0,260},
          {0,228},{78,228}}, color={0,0,127}));
  connect(maxCooFanSpe.y, medFanSpe.f1) annotation (Line(points={{-18,130},{0,130},
          {0,224},{78,224}},      color={0,0,127}));
  connect(endPoiOne.y, medFanSpe.x2) annotation (Line(points={{-18,180},{40,180},
          {40,216},{78,216}}, color={0,0,127}));
  connect(minFanSpe.y, medFanSpe.f2) annotation (Line(points={{42,130},{60,130},
          {60,212},{78,212}}, color={0,0,127}));
  connect(TOut, medFanSpe.u) annotation (Line(points={{-200,160},{-160,160},{-160,
          220},{78,220}},      color={0,0,127}));
  connect(TCooSet, aveZonSet.u1) annotation (Line(points={{-200,-100},{-150,-100},
          {-150,-114},{-122,-114}}, color={0,0,127}));
  connect(THeaSet, aveZonSet.u2) annotation (Line(points={{-200,-140},{-150,-140},
          {-150,-126},{-122,-126}}, color={0,0,127}));
  connect(aveZonSet.y, lim.u)
    annotation (Line(points={{-98,-120},{-62,-120}},  color={0,0,127}));
  connect(uHea, heaFanSpe.u) annotation (Line(points={{-200,100},{-160,100},{-160,
          90},{58,90}},        color={0,0,127}));
  connect(speTwoPoi.y, cooFanSpe1.x1) annotation (Line(points={{-98,60},{-84,60},
          {-84,38},{58,38}},      color={0,0,127}));
  connect(minFanSpe.y, cooFanSpe1.f1) annotation (Line(points={{42,130},{60,130},
          {60,110},{-68,110},{-68,34},{58,34}}, color={0,0,127}));
  connect(speThrPoi.y, cooFanSpe1.x2) annotation (Line(points={{-98,10},{-86,10},
          {-86,26},{58,26}}, color={0,0,127}));
  connect(medFanSpe.y, cooFanSpe1.f2) annotation (Line(points={{102,220},{120,220},
          {120,160},{-60,160},{-60,22},{58,22}},      color={0,0,127}));
  connect(uCoo, cooFanSpe1.u)
    annotation (Line(points={{-200,30},{58,30}}, color={0,0,127}));
  connect(speFouPoi.y, cooFanSpe2.x1) annotation (Line(points={{-98,-40},{-68,-40},
          {-68,-52},{58,-52}}, color={0,0,127}));
  connect(medFanSpe.y, cooFanSpe2.f1) annotation (Line(points={{102,220},{120,220},
          {120,160},{-60,160},{-60,-56},{58,-56}},    color={0,0,127}));
  connect(one.y, cooFanSpe2.x2) annotation (Line(points={{-98,-90},{-76,-90},{-76,
          -64},{58,-64}},  color={0,0,127}));
  connect(maxCooFanSpe.y, cooFanSpe2.f2) annotation (Line(points={{-18,130},{0,130},
          {0,-68},{58,-68}},    color={0,0,127}));
  connect(uCoo, cooFanSpe2.u) annotation (Line(points={{-200,30},{-140,30},{-140,
          -60},{58,-60}},    color={0,0,127}));
  connect(heaFanSpe.y, spe.u1) annotation (Line(points={{82,90},{130,90},{130,76},
          {138,76}},       color={0,0,127}));
  connect(uHea, heaSupTem.u) annotation (Line(points={{-200,100},{-160,100},{-160,
          -150},{58,-150}},    color={0,0,127}));
  connect(speOnePoi.y, heaFanSpe.x1) annotation (Line(points={{-18,60},{40,60},{
          40,98},{58,98}},          color={0,0,127}));
  connect(minFanSpe.y, heaFanSpe.f1) annotation (Line(points={{42,130},{60,130},
          {60,110},{-68,110},{-68,94},{58,94}},   color={0,0,127}));
  connect(one.y, heaFanSpe.x2) annotation (Line(points={{-98,-90},{-76,-90},{-76,
          86},{58,86}},   color={0,0,127}));
  connect(maxHeaFanSpe.y, heaFanSpe.f2) annotation (Line(points={{-98,130},{-84,
          130},{-84,82},{58,82}},   color={0,0,127}));
  connect(zer.y, heaSupTem.x1) annotation (Line(points={{-18,-90},{30,-90},{30,-142},
          {58,-142}},     color={0,0,127}));
  connect(lim.y, heaSupTem.f1) annotation (Line(points={{-38,-120},{20,-120},{20,
          -146},{58,-146}},                   color={0,0,127}));
  connect(temOnePoi.y, heaSupTem.x2) annotation (Line(points={{-98,-180},{-80,-180},
          {-80,-154},{58,-154}},     color={0,0,127}));
  connect(maxSupTem.y, heaSupTem.f2) annotation (Line(points={{-18,-180},{40,-180},
          {40,-158},{58,-158}},      color={0,0,127}));
  connect(zer.y, cooSupTem.x1) annotation (Line(points={{-18,-90},{30,-90},{30,-232},
          {58,-232}},       color={0,0,127}));
  connect(lim.y, cooSupTem.f1) annotation (Line(points={{-38,-120},{20,-120},{20,
          -236},{58,-236}},                     color={0,0,127}));
  connect(temTwoPoi.y, cooSupTem.x2) annotation (Line(points={{-98,-260},{-80,-260},
          {-80,-244},{58,-244}},       color={0,0,127}));
  connect(supCooTem.y, addPar3.u) annotation (Line(points={{-98,-300},{-80,-300},
          {-80,-270},{-42,-270}}, color={0,0,127}));
  connect(addPar3.y, cooSupTem.f2) annotation (Line(points={{-18,-270},{10,-270},
          {10,-248},{58,-248}},        color={0,0,127}));
  connect(temThrPoi.y, cooSupTem1.x1) annotation (Line(points={{-18,-310},{10,-310},
          {10,-322},{58,-322}},      color={0,0,127}));
  connect(lim.y, cooSupTem1.f1) annotation (Line(points={{-38,-120},{20,-120},{20,
          -326},{58,-326}},                     color={0,0,127}));
  connect(temFouPoi.y, cooSupTem1.x2) annotation (Line(points={{-98,-360},{20,-360},
          {20,-334},{58,-334}},        color={0,0,127}));
  connect(supCooTem.y, cooSupTem1.f2) annotation (Line(points={{-98,-300},{-80,-300},
          {-80,-338},{58,-338}},       color={0,0,127}));
  connect(cooFanSpe1.y, cooFan.u1) annotation (Line(points={{82,30},{90,30},{90,
          -2},{98,-2}}, color={0,0,127}));
  connect(cooFanSpe2.y, cooFan.u3) annotation (Line(points={{82,-60},{90,-60},{90,
          -18},{98,-18}}, color={0,0,127}));
  connect(cooFan.y, spe.u2) annotation (Line(points={{122,-10},{130,-10},{130,64},
          {138,64}}, color={0,0,127}));
  connect(uHea, heaSta.u) annotation (Line(points={{-200,100},{-160,100},{-160,-220},
          {-42,-220}}, color={0,0,127}));
  connect(heaSta.y, supTemSet.u2) annotation (Line(points={{-18,-220},{40,-220},
          {40,-200},{118,-200}}, color={255,0,255}));
  connect(heaSupTem.y, supTemSet.u1) annotation (Line(points={{82,-150},{90,-150},
          {90,-192},{118,-192}}, color={0,0,127}));
  connect(cooSupTem.y, supTemSet.u3) annotation (Line(points={{82,-240},{100,-240},
          {100,-208},{118,-208}}, color={0,0,127}));
  connect(heaSta.y, supTemSet1.u2) annotation (Line(points={{-18,-220},{40,-220},
          {40,-280},{118,-280}}, color={255,0,255}));
  connect(cooSupTem1.y, supTemSet1.u3) annotation (Line(points={{82,-330},{100,-330},
          {100,-288},{118,-288}}, color={0,0,127}));
  connect(heaSupTem.y, supTemSet1.u1) annotation (Line(points={{82,-150},{90,-150},
          {90,-272},{118,-272}}, color={0,0,127}));
  connect(spe.y, fanSpe.u3) annotation (Line(points={{162,70},{170,70},{170,260},
          {80,260},{80,332},{98,332}}, color={0,0,127}));
  connect(ramLim.y, y)
    annotation (Line(points={{162,340},{200,340}}, color={0,0,127}));
  connect(supTemSet.y, TSupHeaEcoSet)
    annotation (Line(points={{142,-200},{200,-200}}, color={0,0,127}));
  connect(supTemSet1.y, TSupCooSet)
    annotation (Line(points={{142,-280},{200,-280}}, color={0,0,127}));
  connect(uCoo, cooSupTem.u) annotation (Line(points={{-200,30},{-140,30},{-140,
          -240},{58,-240}}, color={0,0,127}));
  connect(uCoo, cooSupTem1.u) annotation (Line(points={{-200,30},{-140,30},{-140,
          -330},{58,-330}}, color={0,0,127}));
  connect(TZon, addPar1.u)
    annotation (Line(points={{-200,240},{-102,240}}, color={0,0,127}));
  connect(TZon, addPar2.u) annotation (Line(points={{-200,240},{-140,240},{-140,
          200},{-102,200}}, color={0,0,127}));
  connect(isUnoMod.y, not1.u) annotation (Line(points={{-98,340},{20,340},{20,300},
          {38,300}}, color={255,0,255}));
  connect(not1.y, y1SupFan)
    annotation (Line(points={{62,300},{200,300}}, color={255,0,255}));
  connect(speFouPoi.y, gre.u1) annotation (Line(points={{-98,-40},{-68,-40},{-68,
          -10},{18,-10}}, color={0,0,127}));
  connect(uCoo, gre.u2) annotation (Line(points={{-200,30},{-140,30},{-140,-18},
          {18,-18}}, color={0,0,127}));
  connect(gre.y, cooFan.u2)
    annotation (Line(points={{42,-10},{98,-10}}, color={255,0,255}));
annotation (defaultComponentName = "setPoiVAV",
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
    Polygon(
      points={{80,-76},{58,-70},{58,-82},{80,-76}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Line(points={{8,-76},{78,-76}},   color={95,95,95}),
    Line(points={{-54,-22},{-54,-62}},color={95,95,95}),
    Polygon(
      points={{-54,0},{-60,-22},{-48,-22},{-54,0}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Text(
      extent={{-88,-6},{-47,-26}},
      textColor={0,0,0},
          textString="T"),
    Text(
      extent={{64,-82},{88,-93}},
      textColor={0,0,0},
          textString="u"),
        Line(
          points={{-44,-6},{-30,-6},{-14,-42},{26,-42},{38,-62},{60,-62}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{-44,-6},{-30,-6},{-14,-42},{2,-42},{18,-66},{60,-66}},
          color={255,0,0},
          pattern=LinePattern.Dot,
          thickness=0.5),
    Line(points={{-4,-76},{-60,-76}}, color={95,95,95}),
    Polygon(
      points={{-64,-76},{-42,-70},{-42,-82},{-64,-76}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,16},{-76,6}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uHea"),
        Text(
          extent={{-100,-14},{-80,-24}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uCoo"),
        Text(
          extent={{52,8},{98,-6}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSupHeaEcoSet"),
        Text(
          extent={{62,-54},{98,-66}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSupCooSet"),
        Text(
          extent={{86,86},{100,76}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="y"),
        Text(
          extent={{-98,-54},{-72,-64}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TCooSet"),
        Text(
          extent={{-100,46},{-80,36}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TOut"),
    Line(points={{-54,50},{-54,10}},  color={95,95,95}),
    Polygon(
      points={{-54,72},{-60,50},{-48,50},{-54,72}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Text(
      extent={{-88,68},{-47,48}},
      textColor={0,0,0},
          textString="y"),
        Line(points={{-46,44},{-28,20},{18,20},{28,36},{38,36},{50,54}}, color={
              0,0,0}),
        Line(points={{18,20},{38,20},{50,54},{28,54},{18,20}}, color={0,0,0}),
        Text(
          extent={{-96,96},{-66,86}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uOpeMod"),
        Text(
          extent={{-98,-84},{-72,-96}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="THeaSet"),
        Text(
          extent={{-100,68},{-80,58}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZon"),
        Text(
          extent={{70,46},{98,36}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="y1SupFan")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-380},{180,380}})),
  Documentation(info="<html>
<p>
Block that outputs the set points for the supply air temperature for
cooling, heating and economizer control, and the fan speed for a single zone VAV system.
The implementation is according to the Section 5.18.4 of ASHRAE Guideline 36, May 2020.
</p> 

<h4>Fan speed setpoint</h4>
<p>
The supply fan shall run whenever the unit is in any mode other than unoccupied mode.
Also, a ramp function should be applied to prevent changes in fan speed of more
than 10% per minute.
</p>
<h5>Minimum, medium, and maximum fan speeds shall be as follows:</h5>
<ol>
<li>
Minimum speed <code>minSpe</code>, maximum cooling speed <code>maxCooSpe</code>, and 
maximum heatng speed <code>maxHeaSpe</code> shall be given per Section 3.2.2.1 of
ASHRAE Guideline 36.
</li>
<li>
Medium fan speed shall be reset linearly based on outdoor air temperature
<code>TOut</code> from <code>minSpe</code> when outdoor air temperature is greater
than or equal to Endpoint 1 to <code>maxCooSpe</code> when <code>TOut</code> is
less than or equal to Endpoint 2.
<ul>
<li>
Endpoint 1: the lesser of zone temperature <code>TZon</code> plus 0.5 &deg;C (1 &deg;F)
and maximum supply air dew point <code>TSupDew_max</code>.
</li>
<li>
Endpoint 2: the lesser of zone temperature <code>TZon</code> minus 6 &deg;C (10 &deg;F)
and maximum supply air dew point <code>TSupDew_max</code> minus 1 &deg;C (2 &deg;F).
</li>
</ul>
</li>
</ol>

<h5>Control mapping</h5>
<ol>
<li>
For a heating-loop signal <code>uHea</code> of 100% to <code>spePoiOne</code> (default 50%), 
fan speed is reset from <code>maxHeaSpe</code> to <code>minSpe</code>.
</li>
<li>
For a heating-loop signal <code>uHea</code> of <code>spePoiOne</code> to 0%,
fan speed set point is <code>minSpe</code>.
</li>
<li>
In deadband (<code>uHea=0</code>, <code>uCoo=0</code>), fan speed set point is
<code>minSpe</code>.
</li>
<li>
For a cooling-loop signal <code>uCoo</code> of 0% to <code>spePoiTwo</code> (default 25%),
fan speed is <code>minSpe</code>.
</li>
<li>
For a cooling-loop signal <code>uCoo</code> of <code>spePoiTwo</code> to <code>spePoiThr</code>
(default 50%), fan speed is reset from <code>minSpe</code> to medium fan speed.
</li>
<li>
For a cooling-loop signal <code>uCoo</code> of <code>spePoiThr</code> to <code>spePoiFou</code> 
(default 75%), fan speed is medium.
</li>
<li>
For a cooling-loop signal of <code>uCoo</code> <code>spePoiFou</code> to 100%, fan speed
is reset from medium to <code>maxCooSpe</code>.
</li>
</ol>

<p>
The figure below shows the sequence.
</p>
<p align=\"center\">
<img alt=\"Image of speed reset\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/SetPoints/Supply_Speed.png\"/>
</p>

<h4>Supply temperature setpoints</h4>
<p>
The output <code>TSupCooSet</code> is to be used to control the cooling coil,
and the output
<code>TSupHeaEcoSet</code> is to be used to control the heating coil and the
economizer dampers.
</p>
<p>
When it is in deadband state, the output <code>TSupCooSet</code> and <code>TSupHeaEcoSet</code>
shall be average of the zone heating setpoint <code>THeaSet</code> and the zone
cooling setpoint <code>TCooSet</code> but shall be no lower than <code>TSupDea_min</code>,
21 &deg;C (70 &deg;F),
and no higher than <code>TSupDea_max</code>, 24 &deg;C (75 &deg;F),
</p>
<h5>Control mapping</h5>
<ol>
<li>
For a heating-loop signal <code>uHea</code> of 100% to <code>temPoiOne</code> (default 50%), 
<code>TSupHeaEcoSet</code> should be <code>TSup_max</code>.
</li>
<li>
For a heating-loop signal <code>uHea</code> of <code>temPoiOne</code> to 0%, 
<code>TSupHeaEcoSet</code> is reset from <code>TSup_max</code> to the deadband value.
</li>
<li>
In deadband (<code>uHea=0</code>, <code>uCoo=0</code>), <code>TSupHeaEcoSet</code> is
the deadband value.
</li>
<li>
For a cooling-loop signal <code>uCoo</code> of 0% to <code>temPoiTwo</code> (default 25%),
<code>TSupHeaEcoSet</code> is reset from deadband value to <code>TSup_min</code> minus
1 &deg;C (2 &deg;F), while <code>TSupCooSet</code> is the deadband value.
</li>
<li>
For a cooling-loop signal <code>uCoo</code> of <code>temPoiTwo</code> to <code>temPoiThr</code> (default 50%),
<code>TSupHeaEcoSet</code> and <code>TSupCooSet</code> are unchanged.
</li>
<li>
For a cooling-loop signal <code>uCoo</code> of <code>temPoiThr</code> to <code>temPoiFou</code> (default 75%),
<code>TSupHeaEcoSet</code> remains at <code>TSup_min</code> minus
1 &deg;C (2 &deg;F), while <code>TSupCooSet</code> is reset from the deadband value
to <code>TSup_min</code>.
</li>
<li>
For a cooling-loop signal <code>uCoo</code> of <code>temPoiFou</code> to 100%,
<code>TSupHeaEcoSet</code> and <code>TSupCooSet</code> are unchanged.
</li>
</ol>

<p>
The figure below shows the sequence.
</p>
<p align=\"center\">
<img alt=\"Image of temperature reset\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/SetPoints/Supply_Temperature.png\"/>
</p>



<p>
Note that the inputs <code>uHea</code> and <code>uCoo</code> must be computed
based on the same temperature sensors and control loops.
</p>
</html>", revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Supply;
