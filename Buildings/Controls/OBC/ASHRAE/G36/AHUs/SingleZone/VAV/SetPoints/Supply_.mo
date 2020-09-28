within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints;
block Supply_
  CDL.Interfaces.IntegerInput                        uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-220,350},{-180,390}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  CDL.Continuous.Sources.Constant fanOff(k=0) "Fan off status"
    annotation (Placement(transformation(extent={{40,410},{60,430}})));
  CDL.Logical.Switch fanSpe "Supply fan speed"
    annotation (Placement(transformation(extent={{100,390},{120,410}})));
  CDL.Continuous.SlewRateLimiter ramLim(final raisingSlewRate=1/600, final Td=
        60) "Prevent changes in fan speed of more than 10% per minute"
    annotation (Placement(transformation(extent={{140,390},{160,410}})));
  CDL.Interfaces.RealInput                        TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-220,280},{-180,320}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  CDL.Continuous.Sources.Constant maxDewPoi(final k=TDewSupMax)
    "Maximum supply air dew-point temperature"
    annotation (Placement(transformation(extent={{-160,330},{-140,350}})));
  CDL.Continuous.AddParameter addPar(final p=-1, final k=1)
    "Maximum supply dewpoint temperature minus threshold"
    annotation (Placement(transformation(extent={{-100,330},{-80,350}})));
  CDL.Continuous.AddParameter addPar1(final p=-6, final k=1)
    "Zone temperature minus threshold"
    annotation (Placement(transformation(extent={{-100,290},{-80,310}})));
  CDL.Continuous.AddParameter addPar2(final p=0.5, final k=1)
    "Zone temperature plus threshold"
    annotation (Placement(transformation(extent={{-100,250},{-80,270}})));
  CDL.Continuous.Min endPoiTwo "End point two for specifying medium fan speed"
    annotation (Placement(transformation(extent={{-40,310},{-20,330}})));
  CDL.Continuous.Min endPoiOne "End point one for specifying medium fan speed"
    annotation (Placement(transformation(extent={{-40,230},{-20,250}})));
  CDL.Continuous.Sources.Constant minFanSpe(final k=minSpe) "Minimum fan speed"
    annotation (Placement(transformation(extent={{20,180},{40,200}})));
  CDL.Continuous.Sources.Constant maxCooFanSpe(final k=maxCooSpe)
    "Maximum fan speed for cooling"
    annotation (Placement(transformation(extent={{-60,180},{-40,200}})));
  CDL.Continuous.Line medFanSpe "Medium fan speed"
    annotation (Placement(transformation(extent={{82,270},{102,290}})));
  CDL.Interfaces.RealInput TZonCooSet(
    unit="K",
    displayUnit="degC",
    quantity="ThermodynamicTemperature")
    "Cooling setpoints for zone temperature" annotation (Placement(
        transformation(extent={{-220,-40},{-180,0}}), iconTransformation(extent
          ={{-140,0},{-100,40}})));
  CDL.Interfaces.RealInput TZonHeaSet(
    unit="K",
    displayUnit="degC",
    quantity="ThermodynamicTemperature")
    "Heating setpoints for zone temperature" annotation (Placement(
        transformation(extent={{-220,-70},{-180,-30}}), iconTransformation(
          extent={{-140,0},{-100,40}})));
  CDL.Continuous.Average aveZonSet
    "Average of the zone heating and cooling setpoint"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  CDL.Continuous.Limiter lim(final uMax=24 + 273.15, final uMin=21 + 273.15)
    "Limiter that outputs the dead band value for the supply air temperature"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  CDL.Continuous.Sources.Constant one(final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  CDL.Continuous.Sources.Constant zer(final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  CDL.Interfaces.RealInput                        uHea(
    min=0,
    max=1,
    unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-220,140},{-180,180}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  CDL.Interfaces.RealInput                        uCoo(
    min=0,
    max=1,
    unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-220,70},{-180,110}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  CDL.Continuous.Line heaFanSpe "Fan speed when it is in heating state"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));
  CDL.Continuous.Sources.Constant speOnePoi(final k=spePoiOne)
    "Speed control point one in x-axis of control map"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  CDL.Continuous.Sources.Constant maxHeaFanSpe(final k=maxHeaSpe)
    "Maximum fan speed for heating"
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));
  CDL.Continuous.Sources.Constant speTwoPoi(final k=spePoiTwo)
    "Speed control point two in x-axis of control map"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  CDL.Continuous.Sources.Constant speThrPoi(final k=spePoiThr)
    "Speed control point three in x-axis of control map"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  CDL.Continuous.Sources.Constant speFouPoi(final k=spePoiFou)
    "Speed control point four in x-axis of control map"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  CDL.Continuous.Line cooFanSpe1 "Fan speed when it is in cooling state"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  CDL.Continuous.Line cooFanSpe2(final limitBelow=false)
    "Fan speed when it is in cooling mode"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  CDL.Continuous.Limiter lim1(uMax=maxCooSpe, final uMin=minSpe)
    "Limit the speed"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  CDL.Continuous.Max cooFanSpe "Fan speed when it is in cooling state"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  CDL.Continuous.Max spe "Fan speed"
    annotation (Placement(transformation(extent={{140,120},{160,140}})));
  CDL.Continuous.Line heaSupTem
    "Supply air temperature when it is in heating state"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  CDL.Continuous.Sources.Constant temOnePoi(final k=temPoiOne)
    "Temperature control point one in x-axis of control map"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  CDL.Continuous.Sources.Constant maxSupTem(final k=TSupSetMax)
    "Highest heating supply air temperature"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  CDL.Continuous.Sources.Constant temTwoPoi(final k=temPoiTwo)
    "Temperature control point two in x-axis of control map"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
  CDL.Continuous.Line cooSupTem
    "Supply air temperature when it is in cooling state"
    annotation (Placement(transformation(extent={{20,-150},{40,-130}})));
  CDL.Continuous.Sources.Constant supCooTem(final k=TSupSetMin)
    "Cooling supply air temperature"
    annotation (Placement(transformation(extent={{-120,-190},{-100,-170}})));
  CDL.Continuous.AddParameter addPar3(final p=-1, final k=1)
    "Minimum cooling supply temperature minus threshold"
    annotation (Placement(transformation(extent={{-60,-180},{-40,-160}})));
  CDL.Continuous.Line cooSupTem1
    "Supply air temperature when it is in cooling state"
    annotation (Placement(transformation(extent={{20,-240},{40,-220}})));
  CDL.Continuous.Sources.Constant temThrPoi(final k=temPoiThr)
    "Temperature control point three in x-axis of control map"
    annotation (Placement(transformation(extent={{-60,-220},{-40,-200}})));
  CDL.Continuous.Sources.Constant temFouPoi(final k=temPoiFou)
    "Temperature control point four in x-axis of control map"
    annotation (Placement(transformation(extent={{-120,-270},{-100,-250}})));
  CDL.Continuous.Min min1
    annotation (Placement(transformation(extent={{100,-110},{120,-90}})));
protected
  CDL.Integers.Sources.Constant                        unoMod(final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    "Unoccupied mode index"
    annotation (Placement(transformation(extent={{-160,390},{-140,410}})));
  CDL.Integers.Equal isUnoMod "Check if it is in unoccupied mode"
    annotation (Placement(transformation(extent={{-120,390},{-100,410}})));
equation
  connect(unoMod.y, isUnoMod.u1)
    annotation (Line(points={{-138,400},{-122,400}}, color={255,127,0}));
  connect(uOpeMod, isUnoMod.u2) annotation (Line(points={{-200,370},{-130,370},
          {-130,392},{-122,392}}, color={255,127,0}));
  connect(isUnoMod.y, fanSpe.u2)
    annotation (Line(points={{-98,400},{98,400}}, color={255,0,255}));
  connect(fanOff.y, fanSpe.u1) annotation (Line(points={{62,420},{80,420},{80,
          408},{98,408}}, color={0,0,127}));
  connect(fanSpe.y, ramLim.u)
    annotation (Line(points={{122,400},{138,400}}, color={0,0,127}));
  connect(maxDewPoi.y, addPar.u)
    annotation (Line(points={{-138,340},{-102,340}}, color={0,0,127}));
  connect(TOut, addPar1.u)
    annotation (Line(points={{-200,300},{-102,300}}, color={0,0,127}));
  connect(TOut, addPar2.u) annotation (Line(points={{-200,300},{-160,300},{-160,
          260},{-102,260}}, color={0,0,127}));
  connect(addPar.y, endPoiTwo.u1) annotation (Line(points={{-78,340},{-60,340},
          {-60,326},{-42,326}}, color={0,0,127}));
  connect(addPar1.y, endPoiTwo.u2) annotation (Line(points={{-78,300},{-60,300},
          {-60,314},{-42,314}}, color={0,0,127}));
  connect(addPar2.y, endPoiOne.u1) annotation (Line(points={{-78,260},{-60,260},
          {-60,246},{-42,246}}, color={0,0,127}));
  connect(maxDewPoi.y, endPoiOne.u2) annotation (Line(points={{-138,340},{-120,
          340},{-120,234},{-42,234}}, color={0,0,127}));
  connect(endPoiTwo.y, medFanSpe.x1) annotation (Line(points={{-18,320},{0,320},
          {0,288},{80,288}}, color={0,0,127}));
  connect(maxCooFanSpe.y, medFanSpe.f1) annotation (Line(points={{-38,190},{0,
          190},{0,284},{80,284}}, color={0,0,127}));
  connect(endPoiOne.y, medFanSpe.x2) annotation (Line(points={{-18,240},{40,240},
          {40,276},{80,276}}, color={0,0,127}));
  connect(minFanSpe.y, medFanSpe.f2) annotation (Line(points={{42,190},{60,190},
          {60,272},{80,272}}, color={0,0,127}));
  connect(TOut, medFanSpe.u) annotation (Line(points={{-200,300},{-160,300},{
          -160,280},{80,280}}, color={0,0,127}));
  connect(TZonCooSet, aveZonSet.u1) annotation (Line(points={{-200,-20},{-140,
          -20},{-140,-24},{-122,-24}}, color={0,0,127}));
  connect(TZonHeaSet, aveZonSet.u2) annotation (Line(points={{-200,-50},{-140,
          -50},{-140,-36},{-122,-36}}, color={0,0,127}));
  connect(aveZonSet.y, lim.u)
    annotation (Line(points={{-98,-30},{18,-30}}, color={0,0,127}));
  connect(uHea, heaFanSpe.u) annotation (Line(points={{-200,160},{-160,160},{
          -160,150},{18,150}}, color={0,0,127}));
  connect(speTwoPoi.y, cooFanSpe1.x1) annotation (Line(points={{-98,120},{-86,
          120},{-86,98},{18,98}}, color={0,0,127}));
  connect(minFanSpe.y, cooFanSpe1.f1) annotation (Line(points={{42,190},{60,190},
          {60,170},{-74,170},{-74,94},{18,94}}, color={0,0,127}));
  connect(speThrPoi.y, cooFanSpe1.x2) annotation (Line(points={{-98,70},{-86,70},
          {-86,86},{18,86}}, color={0,0,127}));
  connect(medFanSpe.y, cooFanSpe1.f2) annotation (Line(points={{104,280},{120,
          280},{120,220},{-68,220},{-68,82},{18,82}}, color={0,0,127}));
  connect(uCoo, cooFanSpe1.u)
    annotation (Line(points={{-200,90},{18,90}}, color={0,0,127}));
  connect(speFouPoi.y, cooFanSpe2.x1) annotation (Line(points={{-38,60},{-20,60},
          {-20,48},{18,48}}, color={0,0,127}));
  connect(medFanSpe.y, cooFanSpe2.f1) annotation (Line(points={{104,280},{120,
          280},{120,220},{-68,220},{-68,44},{18,44}}, color={0,0,127}));
  connect(one.y, cooFanSpe2.x2) annotation (Line(points={{-98,10},{-80,10},{-80,
          36},{18,36}}, color={0,0,127}));
  connect(maxCooFanSpe.y, cooFanSpe2.f2) annotation (Line(points={{-38,190},{0,
          190},{0,32},{18,32}}, color={0,0,127}));
  connect(uCoo, cooFanSpe2.u) annotation (Line(points={{-200,90},{-140,90},{
          -140,40},{18,40}}, color={0,0,127}));
  connect(cooFanSpe2.y, lim1.u)
    annotation (Line(points={{42,40},{58,40}}, color={0,0,127}));
  connect(lim1.y, cooFanSpe.u2) annotation (Line(points={{82,40},{90,40},{90,74},
          {98,74}}, color={0,0,127}));
  connect(cooFanSpe1.y, cooFanSpe.u1) annotation (Line(points={{42,90},{80,90},
          {80,86},{98,86}}, color={0,0,127}));
  connect(cooFanSpe.y, spe.u2) annotation (Line(points={{122,80},{130,80},{130,
          124},{138,124}}, color={0,0,127}));
  connect(heaFanSpe.y, spe.u1) annotation (Line(points={{42,150},{130,150},{130,
          136},{138,136}}, color={0,0,127}));
  connect(uHea, heaSupTem.u) annotation (Line(points={{-200,160},{-160,160},{
          -160,-70},{18,-70}}, color={0,0,127}));
  connect(speOnePoi.y, heaFanSpe.x1) annotation (Line(points={{-38,120},{-20,
          120},{-20,158},{18,158}}, color={0,0,127}));
  connect(minFanSpe.y, heaFanSpe.f1) annotation (Line(points={{42,190},{60,190},
          {60,170},{-74,170},{-74,154},{18,154}}, color={0,0,127}));
  connect(one.y, heaFanSpe.x2) annotation (Line(points={{-98,10},{-80,10},{-80,
          146},{18,146}}, color={0,0,127}));
  connect(maxHeaFanSpe.y, heaFanSpe.f2) annotation (Line(points={{-98,190},{-86,
          190},{-86,142},{18,142}}, color={0,0,127}));
  connect(zer.y, heaSupTem.x1) annotation (Line(points={{-38,10},{-20,10},{-20,
          -62},{18,-62}}, color={0,0,127}));
  connect(lim.y, heaSupTem.f1) annotation (Line(points={{42,-30},{60,-30},{60,
          -50},{-26,-50},{-26,-66},{18,-66}}, color={0,0,127}));
  connect(temOnePoi.y, heaSupTem.x2) annotation (Line(points={{-98,-100},{-80,
          -100},{-80,-74},{18,-74}}, color={0,0,127}));
  connect(maxSupTem.y, heaSupTem.f2) annotation (Line(points={{-38,-100},{-14,
          -100},{-14,-78},{18,-78}}, color={0,0,127}));
  connect(zer.y, cooSupTem.x1) annotation (Line(points={{-38,10},{-20,10},{-20,
          -132},{18,-132}}, color={0,0,127}));
  connect(lim.y, cooSupTem.f1) annotation (Line(points={{42,-30},{60,-30},{60,
          -50},{-26,-50},{-26,-136},{18,-136}}, color={0,0,127}));
  connect(temTwoPoi.y, cooSupTem.x2) annotation (Line(points={{-98,-140},{-80,
          -140},{-80,-144},{18,-144}}, color={0,0,127}));
  connect(supCooTem.y, addPar3.u) annotation (Line(points={{-98,-180},{-80,-180},
          {-80,-170},{-62,-170}}, color={0,0,127}));
  connect(addPar3.y, cooSupTem.f2) annotation (Line(points={{-38,-170},{-14,
          -170},{-14,-148},{18,-148}}, color={0,0,127}));
  connect(temThrPoi.y, cooSupTem1.x1) annotation (Line(points={{-38,-210},{0,
          -210},{0,-222},{18,-222}}, color={0,0,127}));
  connect(lim.y, cooSupTem1.f1) annotation (Line(points={{42,-30},{60,-30},{60,
          -50},{-26,-50},{-26,-226},{18,-226}}, color={0,0,127}));
  connect(temFouPoi.y, cooSupTem1.x2) annotation (Line(points={{-98,-260},{-40,
          -260},{-40,-234},{18,-234}}, color={0,0,127}));
  connect(supCooTem.y, cooSupTem1.f2) annotation (Line(points={{-98,-180},{-80,
          -180},{-80,-238},{18,-238}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,
            -440},{180,440}})), Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-180,-440},{180,440}})));
end Supply_;
