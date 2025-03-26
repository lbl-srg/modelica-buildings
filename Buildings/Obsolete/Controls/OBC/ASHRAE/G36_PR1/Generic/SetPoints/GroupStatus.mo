within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints;
block GroupStatus "Block that outputs the zone group status"

  parameter Integer numZon(
    final min=1)=5 "Number of zones in building";
  parameter Integer numZonGro(
    final min=1)=numZon "Number of zones in group";
  parameter Boolean zonGroMsk[numZon]=fill(true, numZon)
    "Boolean array mask of zones included in group";

  parameter Real uLow=-0.1
    "Low limit of the hysteresis for checking temperature difference"
    annotation (Dialog(tab="Advanced"));
  parameter Real uHigh=0.1
    "High limit of the hysteresis for checking temperature difference"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput zonOcc[numZon]
    "True when the zone is set to be occupied due to the override"
    annotation (Placement(transformation(extent={{-180,280},{-140,320}}),
      iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc[numZon]
    "True when the zone is occupied according to the occupancy schedule"
    annotation (Placement(transformation(extent={{-180,240},{-140,280}}),
        iconTransformation(extent={{-140,150},{-100,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc[numZon](
    final unit=fill("s", numZon),
    final quantity=fill("Time", numZon)) "Time to next occupied period"
    annotation (Placement(transformation(extent={{-180,200},{-140,240}}),
      iconTransformation(extent={{-140,130},{-100,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooTim[numZon](
    final unit=fill("s", numZon),
    final quantity=fill("Time", numZon)) "Cool down time"
    annotation (Placement(transformation(extent={{-180,160},{-140,200}}),
      iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uWarTim[numZon](
    final unit=fill("s", numZon),
    final quantity=fill("Time", numZon)) "Warm-up time"
    annotation (Placement(transformation(extent={{-180,120},{-140,160}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOccHeaHig[numZon]
    "True when the zone temperature is lower than the occupied heating setpoint"
    annotation (Placement(transformation(extent={{-180,80},{-140,120}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHigOccCoo[numZon]
    "True when the zone temperature is higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUnoHeaHig[numZon]
    "True when the zone temperature is lower than the unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-180,0},{-140,40}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSetOff[numZon](
    final unit=fill("K", numZon),
    displayUnit=fill("degC", numZon),
    final quantity=fill("ThermodynamicTemperature", numZon))
    "Zone unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEndSetBac[numZon]
    "True when the zone could end the setback mode"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHigUnoCoo[numZon]
    "True when the zone temperature is higher than its unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-180,-110},{-140,-70}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSetOff[numZon](
    final unit=fill("K", numZon),
    displayUnit=fill("degC", numZon),
    final quantity=fill("ThermodynamicTemperature", numZon))
    "Zone unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-180,-170},{-140,-130}}),
      iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEndSetUp[numZon]
    "True when the zone could end the setup mode"
    annotation (Placement(transformation(extent={{-180,-200},{-140,-160}}),
      iconTransformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[numZon](
    final unit=fill("K", numZon),
    displayUnit=fill("degC", numZon),
    final quantity=fill("ThermodynamicTemperature", numZon)) "Zone temperature"
    annotation (Placement(transformation(extent={{-180,-240},{-140,-200}}),
      iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin[numZon]
    "True when the window is open, false when the window is close or the zone does not have window status sensor"
    annotation (Placement(transformation(extent={{-180,-320},{-140,-280}}),
      iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput uGroOcc
    "True when the zone group is in occupied mode"
    annotation (Placement(transformation(extent={{100,260},{140,300}}),
      iconTransformation(extent={{100,170},{140,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput nexOcc(
    final quantity="Time",
    final unit="s") "Time to next occupied period"
    annotation (Placement(transformation(extent={{100,200},{140,240}}),
      iconTransformation(extent={{100,150},{140,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooTim(
    final unit="s",
    final quantity="Time") "Cool down time"
    annotation (Placement(transformation(extent={{100,160},{140,200}}),
      iconTransformation(extent={{100,110},{140,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yWarTim(
    final unit="s",
    final quantity="Time") "Warm-up time"
    annotation (Placement(transformation(extent={{100,120},{140,160}}),
      iconTransformation(extent={{100,90},{140,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOccHeaHig
    "True when there is zone with temperature being lower than the occupied heating setpoint"
    annotation (Placement(transformation(extent={{100,80},{140,120}}),
      iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHigOccCoo
    "True when there is zone with temperature being higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
      iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yColZon
    "Total number of cold zones"
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
      iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySetBac
    "Run setback mode"
    annotation (Placement(transformation(extent={{100,-40},{140,0}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndSetBac
    "True when the group should end setback mode"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
      iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotZon
    "Total number of hot zones"
    annotation (Placement(transformation(extent={{100,-110},{140,-70}}),
      iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySetUp
    "Run setup mode"
    annotation (Placement(transformation(extent={{100,-150},{140,-110}}),
      iconTransformation(extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndSetUp
    "True when the group should end setup mode"
    annotation (Placement(transformation(extent={{100,-200},{140,-160}}),
      iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Maximum zone temperature in the zone group"
    annotation (Placement(transformation(extent={{100,-240},{140,-200}}),
      iconTransformation(extent={{100,-150},{140,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Minimum zone temperature in the zone group"
    annotation (Placement(transformation(extent={{100,-280},{140,-240}}),
      iconTransformation(extent={{100,-170},{140,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yOpeWin
    "Total number of open windows"
    annotation (Placement(transformation(extent={{100,-320},{140,-280}}),
      iconTransformation(extent={{100,-210},{140,-170}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysSetBac(final uLow=uLow,
      final uHigh=uHigh)
    "Hysteresis that outputs if the group should run in setback mode"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysSetUp(final uLow=uLow,
      final uHigh=uHigh)
    "Hysteresis that outputs if the group should run in setup mode"
    annotation (Placement(transformation(extent={{60,-140},{80,-120}})));

protected
    Buildings.Controls.OBC.CDL.Routing.BooleanVectorFilter zonOccFil(
    final nin=numZon,
    final nout=numZonGro,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-120,290},{-100,310}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorFilter uOccFil(
    final nin=numZon,
    final nout=numZonGro,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-120,250},{-100,270}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorFilter tNexOccFil(
    final nin=numZon,
    final nout=numZonGro,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-120,210},{-100,230}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorFilter uCooTimFil(
    final nin=numZon,
    final nout=numZonGro,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-120,170},{-100,190}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorFilter uWarTimFil(
    final nin=numZon,
    final nout=numZonGro,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorFilter uOccHeaHigFil(
    final nin=numZon,
    final nout=numZonGro,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorFilter uHigOccCooFil(
    final nin=numZon,
    final nout=numZonGro,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorFilter uUnoHeaHigFil(
    final nin=numZon,
    final nout=numZonGro,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorFilter THeaSetOffFil(
    final nin=numZon,
    final nout=numZonGro,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorFilter uEndSetBacFil(
    final nin=numZon,
    final nout=numZonGro,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorFilter uHigUnoCooFil(
    final nin=numZon,
    final nout=numZonGro,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorFilter TCooSetOffFil(
    final nin=numZon,
    final nout=numZonGro,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorFilter uEndSetUpFil(
    final nin=numZon,
    final nout=numZonGro,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-120,-190},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorFilter TZonFil(
    final nin=numZon,
    final nout=numZonGro,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-120,-230},{-100,-210}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorFilter uWinFil(
    final nin=numZon,
    final nout=numZonGro,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-120,-310},{-100,-290}})));

  Buildings.Controls.OBC.CDL.Reals.MultiMax cooDowTim(
    final nin=numZonGro)
    "Longest cooldown time"
    annotation (Placement(transformation(extent={{40,170},{60,190}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax warUpTim(
    final nin=numZonGro)
    "Longest warm up time"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=numZonGro)
    "Check if there is any zone that the zone temperature is lower than its occupied heating setpoint"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nin=numZonGro)
    "Check if there is any zone that the zone temperature is higher than its occupied cooling setpoint"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax maxTem(
    final nin=numZonGro)
    "Maximum zone temperature in the zone group"
    annotation (Placement(transformation(extent={{0,-230},{20,-210}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMin minTem(
    final nin=numZonGro)
    "Minimum zone temperature in the zone group"
    annotation (Placement(transformation(extent={{0,-270},{20,-250}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[numZonGro]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum totColZon(
    final nin=numZonGro) "Total number of cold zone"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd endSetBac(
    final nin=numZonGro)
    "Check if all zones have ended the setback mode"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[numZonGro]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum totHotZon(
    final nin=numZonGro) "Total number of hot zones"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd endSetUp(
    final nin=numZonGro)
    "Check if all zones have ended the setup mode"
    annotation (Placement(transformation(extent={{-2,-190},{18,-170}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum sumUnoHea(
    final nin=numZonGro)
    "Sum of all zones unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract difUnoHea
    "Difference between unoccupied heating setpoint and zone temperature"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div1 "Average difference"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant totZon(
    final k=numZonGro) "Total number of zones"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea "Convert integer to real"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum sumUnoCoo(
    final nin=numZonGro)
    "Sum of all zones unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum sumTem(
    final nin=numZonGro)
    "Sum of all zones temperature"
    annotation (Placement(transformation(extent={{-80,-210},{-60,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract difUnoCoo
    "Difference between unoccupied cooling setpoint and zone temperature"
    annotation (Placement(transformation(extent={{-30,-130},{-10,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div2 "Average difference"
    annotation (Placement(transformation(extent={{20,-140},{40,-120}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMin minToNexOcc(
    final nin=numZonGro)
    "Minimum time to next occupied period"
    annotation (Placement(transformation(extent={{-60,210},{-40,230}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr schOcc(
    final nin=numZonGro)
    "Check if the group should be in occupied mode according to the schedule"
    annotation (Placement(transformation(extent={{-60,250},{-40,270}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr oveRidOcc(
    final nin=numZonGro)
    "Check if the group should be in occupied mode according to the zone override"
    annotation (Placement(transformation(extent={{-60,290},{-40,310}})));
  Buildings.Controls.OBC.CDL.Logical.Or groOcc
    "Check if the group should be in occupied mode according to the schedule or the zone override"
    annotation (Placement(transformation(extent={{40,270},{60,290}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2[numZonGro]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-60,-310},{-40,-290}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum totOpeWin(
    final nin=numZonGro)
    "Total number of opening windows"
    annotation (Placement(transformation(extent={{40,-310},{60,-290}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=0,
    final realFalse=1)
    "When any zone becomes occpuied, output zero"
    annotation (Placement(transformation(extent={{0,230},{20,250}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply proOcc
    "When it is occupied, output zero"
    annotation (Placement(transformation(extent={{60,210},{80,230}})));

equation
  connect(maxTem.y, TZonMax)
    annotation (Line(points={{22,-220},{120,-220}}, color={0,0,127}));
  connect(minTem.y, TZonMin)
    annotation (Line(points={{22,-260},{120,-260}},color={0,0,127}));
  connect(cooDowTim.y, yCooTim)
    annotation (Line(points={{62,180},{120,180}}, color={0,0,127}));
  connect(warUpTim.y, yWarTim)
    annotation (Line(points={{62,140},{120,140}}, color={0,0,127}));
  connect(mulOr.y, yOccHeaHig)
    annotation (Line(points={{62,100},{120,100}}, color={255,0,255}));
  connect(mulOr1.y, yHigOccCoo)
    annotation (Line(points={{62,60},{120,60}},   color={255,0,255}));
  connect(totColZon.y, yColZon)
    annotation (Line(points={{62,20},{120,20}}, color={255,127,0}));
  connect(endSetBac.y, yEndSetBac)
    annotation (Line(points={{62,-60},{120,-60}}, color={255,0,255}));
  connect(totHotZon.y, yHotZon)
    annotation (Line(points={{62,-90},{120,-90}},   color={255,127,0}));
  connect(endSetUp.y, yEndSetUp)
    annotation (Line(points={{20,-180},{120,-180}}, color={255,0,255}));
  connect(booToInt.y, totColZon.u)
    annotation (Line(points={{-58,20},{38,20}}, color={255,0,255}));
  connect(booToInt1.y, totHotZon.u)
    annotation (Line(points={{-58,-90},{38,-90}}, color={255,0,255}));
  connect(totZon.y, intToRea.u)
    annotation (Line(points={{-58,120},{-42,120}}, color={255,127,0}));
  connect(sumTem.y, difUnoCoo.u1) annotation (Line(points={{-58,-200},{-50,-200},
          {-50,-114},{-32,-114}}, color={0,0,127}));
  connect(sumUnoHea.y, difUnoHea.u1)
    annotation (Line(points={{-58,-20},{-50,-20},{-50,-14},{-42,-14}},
                                                   color={0,0,127}));
  connect(intToRea.y, div1.u2) annotation (Line(points={{-18,120},{0,120},{0,-26},
          {18,-26}},color={0,0,127}));
  connect(intToRea.y, div2.u2) annotation (Line(points={{-18,120},{0,120},{0,-136},
          {18,-136}},color={0,0,127}));
  connect(difUnoHea.y, div1.u1) annotation (Line(points={{-18,-20},{-10,-20},{
          -10,-14},{18,-14}},
                          color={0,0,127}));
  connect(difUnoCoo.y, div2.u1) annotation (Line(points={{-8,-120},{8,-120},{8,-124},
          {18,-124}},color={0,0,127}));
  connect(div1.y, hysSetBac.u)
    annotation (Line(points={{42,-20},{58,-20}}, color={0,0,127}));
  connect(hysSetBac.y, ySetBac)
    annotation (Line(points={{82,-20},{120,-20}}, color={255,0,255}));
  connect(div2.y, hysSetUp.u)
    annotation (Line(points={{42,-130},{58,-130}}, color={0,0,127}));
  connect(hysSetUp.y, ySetUp)
    annotation (Line(points={{82,-130},{120,-130}}, color={255,0,255}));
  connect(groOcc.y, uGroOcc) annotation (Line(points={{62,280},{120,280}},
          color={255,0,255}));
  connect(oveRidOcc.y, groOcc.u1) annotation (Line(points={{-38,300},{-20,300},{
          -20,280},{38,280}}, color={255,0,255}));
  connect(schOcc.y, groOcc.u2) annotation (Line(points={{-38,260},{-20,260},{-20,
          272},{38,272}}, color={255,0,255}));
  connect(totOpeWin.y, yOpeWin)
    annotation (Line(points={{62,-300},{120,-300}}, color={255,127,0}));
  connect(booToInt2.y, totOpeWin.u)
    annotation (Line(points={{-38,-300},{38,-300}}, color={255,127,0}));
  connect(schOcc.y, booToRea.u) annotation (Line(points={{-38,260},{-20,260},{-20,
          240},{-2,240}}, color={255,0,255}));
  connect(minToNexOcc.y, proOcc.u2) annotation (Line(points={{-38,220},{-20,220},
          {-20,214},{58,214}}, color={0,0,127}));
  connect(booToRea.y, proOcc.u1) annotation (Line(points={{22,240},{40,240},{40,
          226},{58,226}}, color={0,0,127}));
  connect(proOcc.y, nexOcc) annotation (Line(points={{82,220},{94,220},{94,220},
          {120,220}}, color={0,0,127}));
  connect(zonOcc, zonOccFil.u)
    annotation (Line(points={{-160,300},{-122,300}}, color={255,0,255}));
  connect(uOcc, uOccFil.u)
    annotation (Line(points={{-160,260},{-122,260}}, color={255,0,255}));
  connect(zonOccFil.y, oveRidOcc.u)
    annotation (Line(points={{-98,300},{-62,300}}, color={255,0,255}));
  connect(uOccFil.y, schOcc.u)
    annotation (Line(points={{-98,260},{-62,260}}, color={255,0,255}));
  connect(tNexOcc, tNexOccFil.u)
    annotation (Line(points={{-160,220},{-122,220}}, color={0,0,127}));
  connect(tNexOccFil.y, minToNexOcc.u)
    annotation (Line(points={{-98,220},{-62,220}}, color={0,0,127}));
  connect(uCooTim, uCooTimFil.u)
    annotation (Line(points={{-160,180},{-122,180}}, color={0,0,127}));
  connect(uCooTimFil.y, cooDowTim.u)
    annotation (Line(points={{-98,180},{38,180}}, color={0,0,127}));
  connect(uWarTim, uWarTimFil.u)
    annotation (Line(points={{-160,140},{-122,140}}, color={0,0,127}));
  connect(uWarTimFil.y, warUpTim.u)
    annotation (Line(points={{-98,140},{38,140}}, color={0,0,127}));
  connect(uOccHeaHig, uOccHeaHigFil.u)
    annotation (Line(points={{-160,100},{-122,100}}, color={255,0,255}));
  connect(uOccHeaHigFil.y, mulOr.u)
    annotation (Line(points={{-98,100},{38,100}}, color={255,0,255}));
  connect(uHigOccCoo, uHigOccCooFil.u)
    annotation (Line(points={{-160,60},{-122,60}}, color={255,0,255}));
  connect(uHigOccCooFil.y, mulOr1.u)
    annotation (Line(points={{-98,60},{38,60}}, color={255,0,255}));
  connect(uUnoHeaHig, uUnoHeaHigFil.u)
    annotation (Line(points={{-160,20},{-122,20}}, color={255,0,255}));
  connect(uUnoHeaHigFil.y, booToInt.u)
    annotation (Line(points={{-98,20},{-82,20}}, color={255,0,255}));
  connect(THeaSetOff, THeaSetOffFil.u)
    annotation (Line(points={{-160,-20},{-122,-20}}, color={0,0,127}));
  connect(THeaSetOffFil.y, sumUnoHea.u)
    annotation (Line(points={{-98,-20},{-82,-20}}, color={0,0,127}));
  connect(uEndSetBac, uEndSetBacFil.u)
    annotation (Line(points={{-160,-60},{-122,-60}}, color={255,0,255}));
  connect(uEndSetBacFil.y, endSetBac.u)
    annotation (Line(points={{-98,-60},{38,-60}}, color={255,0,255}));
  connect(uHigUnoCoo, uHigUnoCooFil.u)
    annotation (Line(points={{-160,-90},{-122,-90}}, color={255,0,255}));
  connect(uHigUnoCooFil.y, booToInt1.u)
    annotation (Line(points={{-98,-90},{-82,-90}}, color={255,0,255}));
  connect(TCooSetOff, TCooSetOffFil.u)
    annotation (Line(points={{-160,-150},{-122,-150}}, color={0,0,127}));
  connect(TCooSetOffFil.y, sumUnoCoo.u)
    annotation (Line(points={{-98,-150},{-82,-150}}, color={0,0,127}));
  connect(uEndSetUp, uEndSetUpFil.u)
    annotation (Line(points={{-160,-180},{-122,-180}}, color={255,0,255}));
  connect(uEndSetUpFil.y, endSetUp.u)
    annotation (Line(points={{-98,-180},{-4,-180}}, color={255,0,255}));
  connect(TZon, TZonFil.u)
    annotation (Line(points={{-160,-220},{-122,-220}}, color={0,0,127}));
  connect(TZonFil.y, sumTem.u) annotation (Line(points={{-98,-220},{-90,-220},{-90,
          -200},{-82,-200}}, color={0,0,127}));
  connect(TZonFil.y, maxTem.u)
    annotation (Line(points={{-98,-220},{-2,-220}}, color={0,0,127}));
  connect(TZonFil.y, minTem.u) annotation (Line(points={{-98,-220},{-90,-220},{-90,
          -260},{-2,-260}}, color={0,0,127}));
  connect(uWin, uWinFil.u)
    annotation (Line(points={{-160,-300},{-122,-300}}, color={255,0,255}));
  connect(uWinFil.y, booToInt2.u)
    annotation (Line(points={{-98,-300},{-62,-300}}, color={255,0,255}));

  connect(sumTem.y, difUnoHea.u2) annotation (Line(points={{-58,-200},{-50,-200},
          {-50,-26},{-42,-26}}, color={0,0,127}));
  connect(sumUnoCoo.y, difUnoCoo.u2) annotation (Line(points={{-58,-150},{-40,
          -150},{-40,-126},{-32,-126}}, color={0,0,127}));
annotation (
  defaultComponentName = "groSta",
  Icon(coordinateSystem(extent={{-100,-200},{100,200}}),
       graphics={
        Rectangle(extent={{-100,-200},{100,200}},
                  lineColor={0,0,127},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
        Text(extent={{-120,250},{100,212}},
             textColor={0,0,255},
             textString="%name"),
        Text(
          extent={{-98,116},{-56,102}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCooTim"),
        Text(
          extent={{62,28},{98,16}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yColZon"),
        Text(
          extent={{-98,96},{-58,84}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uWarTim"),
        Text(
          extent={{-96,58},{-46,42}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOccHeaHig"),
        Text(
          extent={{-96,38},{-46,24}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHigOccCoo"),
        Text(
          extent={{-96,-82},{-44,-98}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHigUnoCoo"),
        Text(
          extent={{-96,-42},{-46,-56}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uEndSetBac"),
        Text(
          extent={{-96,-124},{-48,-138}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uEndSetUp"),
        Text(
          extent={{-96,-4},{-46,-18}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uUnoHeaHig"),
        Text(
          extent={{-96,-164},{-74,-176}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{64,-142},{98,-156}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonMin"),
        Text(
          extent={{62,-122},{98,-136}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonMax"),
        Text(
          extent={{54,-82},{98,-98}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yEndSetUp"),
        Text(
          extent={{46,-10},{98,-26}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yEndSetBac"),
        Text(
          extent={{46,60},{98,44}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yHigOccCoo"),
        Text(
          extent={{46,78},{98,64}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yOccHeaHig"),
        Text(
          extent={{64,138},{98,126}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCooTim"),
        Text(
          extent={{62,116},{98,106}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yWarTim"),
        Text(
          extent={{64,-42},{98,-56}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHotZon"),
        Text(
          extent={{-98,-104},{-48,-120}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSetOff"),
        Text(
          extent={{-98,-24},{-50,-38}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSetOff"),
        Text(
          extent={{58,8},{100,-4}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="ySetBac"),
        Text(
          extent={{62,-66},{102,-76}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="ySetUp"),
        Text(
          extent={{-98,156},{-56,142}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="tNexOcc"),
        Text(
          extent={{-98,198},{-62,186}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="ZonOcc"),
        Text(
          extent={{-98,178},{-72,164}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOcc"),
        Text(
          extent={{64,178},{98,166}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="nexOcc"),
        Text(
          extent={{58,200},{98,186}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uGroOcc"),
        Text(
          extent={{-100,-184},{-70,-196}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uWin"),
        Text(
          extent={{64,-182},{98,-196}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yOpeWin")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-320},{100,320}})),
Documentation(info="<html>
<p>
This sequence sums up the zone level status calculation to find the outputs that are
needed to define the zone group operation mode.
</p>
<p>
It requires following inputs from zone level controller:
</p>
<ul>
<li>
<code>zonOcc</code>: if the zone-level local override switch indicates the zone is
occupied,
</li>
<li>
<code>uOcc</code>: if the zone is occupied according to its occupancy schedule,
</li>
<li>
<code>tNexOcc</code>: time to next occupied period,
</li>
<li>
<code>uCooTim</code>: required cooldown time,
</li>
<li>
<code>uWarTim</code>: required warm-up time,
</li>
<li>
<code>uOccHeaHig</code>: if the zone temperature is lower than the occupied
heating setpoint,
</li>
<li>
<code>uHigOccCoo</code>: if the zone temperature is higher than the occupied
cooling setpoint,
</li>
<li>
<code>uUnoHeaHig</code>: if the zone temperature is lower than the unoccupied
heating setpoint,
</li>
<li>
<code>THeaSetOff</code>: zone unoccupied heating setpoint,
</li>
<li>
<code>uEndSetBac</code>: if the zone could end the setback mode,
</li>
<li>
<code>uHigUnoCoo</code>: if the zone temperature is higher than its unoccupied 
cooling setpoint,
</li>
<li>
<code>TCooSetOff</code>: zone unoccupied cooling setpoint,
</li>
<li>
<code>uEndSetUp</code>: if the zone could end the setup mode,
</li>
<li>
<code>TZon</code>: zone temperature,
</li>
<li>
<code>uWin</code>: True when the window is open, false when the window is close
or the zone does not have window status sensor.
</li>
</ul>
<p>
The sequence gives following outputs for zone group level calculation:
</p>
<ul>
<li>
<code>uGroOcc</code>: the zone group should be in occupied mode when there is any
zone becoming occupied according its schedule or due to the local override,
</li>
<li>
<code>nexOcc</code>: the shortest time to the next occupied period among all the
zones in the group,
</li>
<li>
<code>yCooTim</code>: longest cooldown time,
</li>
<li>
<code>yWarTim</code>: longest warm-up time,
</li>
<li>
<code>yOccHeaHig</code>: if there is zone with temperature being lower than the
occupied heating setpoint, so the group could be in the warm-up mode,
</li>
<li>
<code>yHigOccCoo</code>: if there is zone with temperature being higher than the
occupied cooling setpoint, so the group could be in the cooldown mode,
</li>
<li>
<code>yColZon</code>: total number of zones that the temperature is lower than the
unoccupied heating setpoint,
</li>
<li>
<code>ySetBac</code>: check if the group could be into setback mode due to that
the average zone temperature is lower than the average unoccupied heating setpoint,
</li>
<li>
<code>yEndSetBac</code>: check if the group should end setback mode due to that
all the zone temperature are above their unoccupied heating setpoint by a limited
value,
</li>
<li>
<code>yHotZon</code>: total number of zones that the temperature is higher than the
unoccupied cooling setpoint,
</li>
<li>
<code>ySetUp</code>: check if the group could be into setup mode due to that
the average zone temperature is higher than the average unoccupied cooling setpoint,
</li>
<li>
<code>yEndSetUp</code>: check if the group should end setup mode due to that
all the zone temperature are below their unoccupied cooling setpoint by a limited
value,
</li>
<li>
<code>TZonMax</code>: maximum zone temperature in the zone group,
</li>
<li>
<code>TZonMin</code>: minimum zone temperature in the zone group,
</li>
<li>
<code>yOpeWin</code>: total number of opening windows.
</li>
</ul>
</html>",revisions="<html>
<ul>
<li>
June 25, 2021, by Baptiste Ravache:<br/>
Add filters to select which zones are used in group.
</li>
<li>
June 15, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end GroupStatus;
