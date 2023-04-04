within Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups;
block GroupStatus "Block that outputs the zone group status"

  parameter Integer nBuiZon(
    final min=1)=5
    "Total number of zones in building";
  parameter Integer nGroZon(
    final min=1)=nBuiZon
    "Total number of zones in the group";
  parameter Boolean zonGroMsk[nBuiZon]=fill(true, nBuiZon)
    "Boolean array mask of zones included in group";
  parameter Real uLow(
    final unit="K",
    final quantity="TemperatureDifference")=-0.1
    "Low limit of the hysteresis for checking temperature difference"
    annotation (Dialog(tab="Advanced"));
  parameter Real uHigh(
    final unit="K",
    final quantity="TemperatureDifference")=0.1
    "High limit of the hysteresis for checking temperature difference"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput zonOcc[nBuiZon]
    "True when the zone is set to be occupied due to the override"
    annotation (Placement(transformation(extent={{-160,280},{-120,320}}),
      iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Occ[nBuiZon]
    "True when the zone is occupied according to the occupancy schedule"
    annotation (Placement(transformation(extent={{-160,240},{-120,280}}),
        iconTransformation(extent={{-140,150},{-100,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc[nBuiZon](
    final unit=fill("s", nBuiZon),
    final quantity=fill("Time", nBuiZon)) "Time to next occupied period"
    annotation (Placement(transformation(extent={{-160,200},{-120,240}}),
      iconTransformation(extent={{-140,130},{-100,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooTim[nBuiZon](
    final unit=fill("s", nBuiZon),
    final quantity=fill("Time", nBuiZon)) "Cool down time"
    annotation (Placement(transformation(extent={{-160,160},{-120,200}}),
      iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uWarTim[nBuiZon](
    final unit=fill("s", nBuiZon),
    final quantity=fill("Time", nBuiZon)) "Warm-up time"
    annotation (Placement(transformation(extent={{-160,120},{-120,160}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1OccHeaHig[nBuiZon]
    "True when the zone temperature is lower than the occupied heating setpoint"
    annotation (Placement(transformation(extent={{-160,80},{-120,120}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HigOccCoo[nBuiZon]
    "True when the zone temperature is higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-160,40},{-120,80}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1UnoHeaHig[nBuiZon]
    "True when the zone temperature is lower than the unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-160,0},{-120,40}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSetOff[nBuiZon](
    final unit=fill("K", nBuiZon),
    displayUnit=fill("degC", nBuiZon),
    final quantity=fill("ThermodynamicTemperature", nBuiZon))
    "Zone unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-160,-40},{-120,0}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1EndSetBac[nBuiZon]
    "True when the zone could end the setback mode"
    annotation (Placement(transformation(extent={{-160,-80},{-120,-40}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HigUnoCoo[nBuiZon]
    "True when the zone temperature is higher than its unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-160,-110},{-120,-70}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSetOff[nBuiZon](
    final unit=fill("K", nBuiZon),
    displayUnit=fill("degC", nBuiZon),
    final quantity=fill("ThermodynamicTemperature", nBuiZon))
    "Zone unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-160,-170},{-120,-130}}),
      iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1EndSetUp[nBuiZon]
    "True when the zone could end the setup mode"
    annotation (Placement(transformation(extent={{-162,-200},{-122,-160}}),
      iconTransformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[nBuiZon](
    final unit=fill("K", nBuiZon),
    displayUnit=fill("degC", nBuiZon),
    final quantity=fill("ThermodynamicTemperature", nBuiZon)) "Zone temperature"
    annotation (Placement(transformation(extent={{-160,-240},{-120,-200}}),
      iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Win[nBuiZon]
    "Window status, normally closed (true), when windows open, it becomes false. For zone without sensor, it is true"
    annotation (Placement(transformation(extent={{-160,-320},{-120,-280}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput uGroOcc
    "True when the zone group is in occupied mode"
    annotation (Placement(transformation(extent={{120,260},{160,300}}),
      iconTransformation(extent={{100,170},{140,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput nexOcc(
    final quantity="Time",
    final unit="s") "Time to next occupied period"
    annotation (Placement(transformation(extent={{120,200},{160,240}}),
      iconTransformation(extent={{100,150},{140,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooTim(
    final unit="s",
    final quantity="Time") "Cool down time"
    annotation (Placement(transformation(extent={{120,160},{160,200}}),
      iconTransformation(extent={{100,110},{140,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yWarTim(
    final unit="s",
    final quantity="Time") "Warm-up time"
    annotation (Placement(transformation(extent={{120,120},{160,160}}),
      iconTransformation(extent={{100,90},{140,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOccHeaHig
    "True when there is zone with temperature being lower than the occupied heating setpoint"
    annotation (Placement(transformation(extent={{120,80},{160,120}}),
      iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHigOccCoo
    "True when there is zone with temperature being higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{120,40},{160,80}}),
      iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yColZon
    "Total number of cold zones"
    annotation (Placement(transformation(extent={{120,0},{160,40}}),
      iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySetBac
    "Run setback mode"
    annotation (Placement(transformation(extent={{120,-40},{160,0}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndSetBac
    "True when the group should end setback mode"
    annotation (Placement(transformation(extent={{120,-80},{160,-40}}),
      iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotZon
    "Total number of hot zones"
    annotation (Placement(transformation(extent={{120,-110},{160,-70}}),
      iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySetUp
    "Run setup mode"
    annotation (Placement(transformation(extent={{120,-150},{160,-110}}),
      iconTransformation(extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndSetUp
    "True when the group should end setup mode"
    annotation (Placement(transformation(extent={{120,-200},{160,-160}}),
      iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Maximum zone temperature in the zone group"
    annotation (Placement(transformation(extent={{120,-240},{160,-200}}),
      iconTransformation(extent={{100,-150},{140,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Minimum zone temperature in the zone group"
    annotation (Placement(transformation(extent={{120,-280},{160,-240}}),
      iconTransformation(extent={{100,-170},{140,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yOpeWin
    "Total number of open windows"
    annotation (Placement(transformation(extent={{120,-320},{160,-280}}),
      iconTransformation(extent={{100,-210},{140,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[nGroZon] "Logical not"
    annotation (Placement(transformation(extent={{-60,-310},{-40,-290}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.MultiMax cooDowTim(
    final nin=nGroZon)
    "Longest cooldown time"
    annotation (Placement(transformation(extent={{60,170},{80,190}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax warUpTim(
    final nin=nGroZon)
    "Longest warm up time"
    annotation (Placement(transformation(extent={{60,130},{80,150}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nGroZon)
    "Check if there is any zone that the zone temperature is lower than its occupied heating setpoint"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nin=nGroZon)
    "Check if there is any zone that the zone temperature is higher than its occupied cooling setpoint"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax maxTem(
    final nin=nGroZon)
    "Maximum zone temperature in the zone group"
    annotation (Placement(transformation(extent={{20,-230},{40,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin minTem(
    final nin=nGroZon)
    "Minimum zone temperature in the zone group"
    annotation (Placement(transformation(extent={{20,-270},{40,-250}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nGroZon]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum totColZon(
    final nin=nGroZon) "Total number of cold zone"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd endSetBac(
    final nin=nGroZon)
    "Check if all zones have ended the setback mode"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nGroZon]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum totHotZon(
    final nin=nGroZon) "Total number of hot zones"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd endSetUp(
    final nin=nGroZon)
    "Check if all zones have ended the setup mode"
    annotation (Placement(transformation(extent={{18,-190},{38,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sumUnoHea(
    final nin=nGroZon)
    "Sum of all zones unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract difUnoHea
    "Difference between unoccupied heating setpoint and zone temperature"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div1 "Average difference"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant totZon(
    final k=nBuiZon) "Total number of zones"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea "Convert integer to real"
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sumUnoCoo(
    final nin=nGroZon)
    "Sum of all zones unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sumTem(
    final nin=nGroZon)
    "Sum of all zones temperature"
    annotation (Placement(transformation(extent={{-60,-210},{-40,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract difUnoCoo
    "Difference between unoccupied cooling setpoint and zone temperature"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div2 "Average difference"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=uLow,
    final uHigh=uHigh)
    "Hysteresis that outputs if the group should run in setback mode"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=uLow,
    final uHigh=uHigh)
    "Hysteresis that outputs if the group should run in setup mode"
    annotation (Placement(transformation(extent={{80,-140},{100,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin minToNexOcc(
    final nin=nGroZon)
    "Minimum time to next occupied period"
    annotation (Placement(transformation(extent={{-40,210},{-20,230}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr schOcc(
    final nin=nGroZon)
    "Check if the group should be in occupied mode according to the schedule"
    annotation (Placement(transformation(extent={{-40,250},{-20,270}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr oveRidOcc(
    final nin=nGroZon)
    "Check if the group should be in occupied mode according to the zone override"
    annotation (Placement(transformation(extent={{-40,290},{-20,310}})));
  Buildings.Controls.OBC.CDL.Logical.Or groOcc
    "Check if the group should be in occupied mode according to the schedule or the zone override"
    annotation (Placement(transformation(extent={{60,270},{80,290}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2[nGroZon]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{20,-310},{40,-290}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum totOpeWin(
    final nin=nGroZon)
    "Total number of opening windows"
    annotation (Placement(transformation(extent={{60,-310},{80,-290}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=0,
    final realFalse=1)
    "When any zone becomes occpuied, output zero"
    annotation (Placement(transformation(extent={{20,230},{40,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro
    "When it is occupied, output zero"
    annotation (Placement(transformation(extent={{80,210},{100,230}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorFilter zonOccFil(
    final nin=nBuiZon,
    final nout=nGroZon,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-100,290},{-80,310}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorFilter uOccFil(
    final nin=nBuiZon,
    final nout=nGroZon,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-100,250},{-80,270}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorFilter tNexOccFil(
    final nin=nBuiZon,
    final nout=nGroZon,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-100,210},{-80,230}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorFilter uCooTimFil(
    final nin=nBuiZon,
    final nout=nGroZon,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-100,170},{-80,190}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorFilter uWarTimFil(
    final nin=nBuiZon,
    final nout=nGroZon,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorFilter uOccHeaHigFil(
    final nin=nBuiZon,
    final nout=nGroZon,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorFilter uHigOccCooFil(
    final nin=nBuiZon,
    final nout=nGroZon,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorFilter uUnoHeaHigFil(
    final nin=nBuiZon,
    final nout=nGroZon,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorFilter THeaSetOffFil(
    final nin=nBuiZon,
    final nout=nGroZon,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorFilter uEndSetBacFil(
    final nin=nBuiZon,
    final nout=nGroZon,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorFilter uHigUnoCooFil(
    final nin=nBuiZon,
    final nout=nGroZon,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorFilter TCooSetOffFil(
    final nin=nBuiZon,
    final nout=nGroZon,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorFilter uEndSetUpFil(
    final nin=nBuiZon,
    final nout=nGroZon,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-100,-190},{-80,-170}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorFilter TZonFil(
    final nin=nBuiZon,
    final nout=nGroZon,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-100,-230},{-80,-210}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorFilter uWinFil(
    final nin=nBuiZon,
    final nout=nGroZon,
    final msk=zonGroMsk) "Zone group filter"
    annotation (Placement(transformation(extent={{-100,-310},{-80,-290}})));
equation
  connect(maxTem.y, TZonMax)
    annotation (Line(points={{42,-220},{140,-220}}, color={0,0,127}));
  connect(minTem.y, TZonMin)
    annotation (Line(points={{42,-260},{140,-260}},color={0,0,127}));
  connect(cooDowTim.y, yCooTim)
    annotation (Line(points={{82,180},{140,180}}, color={0,0,127}));
  connect(warUpTim.y, yWarTim)
    annotation (Line(points={{82,140},{140,140}}, color={0,0,127}));
  connect(mulOr.y, yOccHeaHig)
    annotation (Line(points={{82,100},{140,100}}, color={255,0,255}));
  connect(mulOr1.y, yHigOccCoo)
    annotation (Line(points={{82,60},{140,60}},   color={255,0,255}));
  connect(totColZon.y, yColZon)
    annotation (Line(points={{82,20},{140,20}}, color={255,127,0}));
  connect(endSetBac.y, yEndSetBac)
    annotation (Line(points={{82,-60},{140,-60}}, color={255,0,255}));
  connect(totHotZon.y, yHotZon)
    annotation (Line(points={{82,-90},{140,-90}},   color={255,127,0}));
  connect(endSetUp.y, yEndSetUp)
    annotation (Line(points={{40,-180},{140,-180}}, color={255,0,255}));
  connect(booToInt.y, totColZon.u)
    annotation (Line(points={{-38,20},{58,20}}, color={255,0,255}));
  connect(booToInt1.y, totHotZon.u)
    annotation (Line(points={{-38,-90},{58,-90}}, color={255,0,255}));
  connect(totZon.y, intToRea.u)
    annotation (Line(points={{-38,120},{-22,120}}, color={255,127,0}));
  connect(sumTem.y, difUnoCoo.u1)
    annotation (Line(points={{-38,-200},{-30,-200},{-30,-114},{-12,-114}},
      color={0,0,127}));
  connect(sumUnoHea.y, difUnoHea.u1)
    annotation (Line(points={{-38,-20},{-30,-20},{-30,-14},{-22,-14}},
      color={0,0,127}));
  connect(intToRea.y, div1.u2)
    annotation (Line(points={{2,120},{20,120},{20,-26},{38,-26}},color={0,0,127}));
  connect(intToRea.y, div2.u2)
    annotation (Line(points={{2,120},{20,120},{20,-136},{38,-136}},color={0,0,127}));
  connect(difUnoHea.y, div1.u1)
    annotation (Line(points={{2,-20},{10,-20},{10,-14},{38,-14}}, color={0,0,127}));
  connect(difUnoCoo.y, div2.u1)
    annotation (Line(points={{12,-120},{28,-120},{28,-124},{38,-124}},
      color={0,0,127}));
  connect(div1.y, hys.u)
    annotation (Line(points={{62,-20},{78,-20}}, color={0,0,127}));
  connect(hys.y, ySetBac)
    annotation (Line(points={{102,-20},{140,-20}},color={255,0,255}));
  connect(div2.y, hys1.u)
    annotation (Line(points={{62,-130},{78,-130}}, color={0,0,127}));
  connect(hys1.y, ySetUp)
    annotation (Line(points={{102,-130},{140,-130}},
      color={255,0,255}));
  connect(groOcc.y, uGroOcc)
    annotation (Line(points={{82,280},{140,280}}, color={255,0,255}));
  connect(oveRidOcc.y, groOcc.u1)
    annotation (Line(points={{-18,300},{0,300},{0,280},{58,280}},
      color={255,0,255}));
  connect(schOcc.y, groOcc.u2)
    annotation (Line(points={{-18,260},{0,260},{0,272},{58,272}},
      color={255,0,255}));
  connect(totOpeWin.y, yOpeWin)
    annotation (Line(points={{82,-300},{140,-300}}, color={255,127,0}));
  connect(booToInt2.y, totOpeWin.u)
    annotation (Line(points={{42,-300},{58,-300}},  color={255,127,0}));
  connect(schOcc.y, booToRea.u)
    annotation (Line(points={{-18,260},{0,260},{0,240},{18,240}},
      color={255,0,255}));
  connect(minToNexOcc.y, pro.u2)
    annotation (Line(points={{-18,220},{0,220},{0,214},{78,214}},
      color={0,0,127}));
  connect(booToRea.y, pro.u1)
    annotation (Line(points={{42,240},{60,240},{60,226},{78,226}},
      color={0,0,127}));
  connect(pro.y, nexOcc)
    annotation (Line(points={{102,220},{140,220}}, color={0,0,127}));
  connect(sumTem.y, difUnoHea.u2)
    annotation (Line(points={{-38,-200},{-30,-200},{-30,-26},{-22,-26}},
      color={0,0,127}));
  connect(sumUnoCoo.y, difUnoCoo.u2)
    annotation (Line(points={{-38,-150},{-20,-150},{-20,-126},{-12,-126}},
      color={0,0,127}));
  connect(u1Occ, uOccFil.u)
    annotation (Line(points={{-140,260},{-102,260}}, color={255,0,255}));
  connect(uWarTim, uWarTimFil.u)
    annotation (Line(points={{-140,140},{-102,140}}, color={0,0,127}));
  connect(u1Win, uWinFil.u)
    annotation (Line(points={{-140,-300},{-102,-300}}, color={255,0,255}));
  connect(zonOcc, zonOccFil.u)
    annotation (Line(points={{-140,300},{-102,300}}, color={255,0,255}));
  connect(zonOccFil.y, oveRidOcc.u)
    annotation (Line(points={{-78,300},{-42,300}}, color={255,0,255}));
  connect(uOccFil.y, schOcc.u)
    annotation (Line(points={{-78,260},{-42,260}}, color={255,0,255}));
  connect(tNexOccFil.y, minToNexOcc.u)
    annotation (Line(points={{-78,220},{-42,220}}, color={0,0,127}));
  connect(tNexOcc, tNexOccFil.u)
    annotation (Line(points={{-140,220},{-102,220}}, color={0,0,127}));
  connect(uCooTim, uCooTimFil.u)
    annotation (Line(points={{-140,180},{-102,180}}, color={0,0,127}));
  connect(uCooTimFil.y, cooDowTim.u)
    annotation (Line(points={{-78,180},{58,180}}, color={0,0,127}));
  connect(uWarTimFil.y, warUpTim.u)
    annotation (Line(points={{-78,140},{58,140}}, color={0,0,127}));
  connect(u1OccHeaHig, uOccHeaHigFil.u)
    annotation (Line(points={{-140,100},{-102,100}}, color={255,0,255}));
  connect(uOccHeaHigFil.y, mulOr.u)
    annotation (Line(points={{-78,100},{58,100}}, color={255,0,255}));
  connect(u1HigOccCoo, uHigOccCooFil.u)
    annotation (Line(points={{-140,60},{-102,60}}, color={255,0,255}));
  connect(uHigOccCooFil.y, mulOr1.u)
    annotation (Line(points={{-78,60},{58,60}}, color={255,0,255}));
  connect(u1UnoHeaHig, uUnoHeaHigFil.u)
    annotation (Line(points={{-140,20},{-102,20}}, color={255,0,255}));
  connect(uUnoHeaHigFil.y, booToInt.u)
    annotation (Line(points={{-78,20},{-62,20}}, color={255,0,255}));
  connect(THeaSetOff, THeaSetOffFil.u)
    annotation (Line(points={{-140,-20},{-102,-20}}, color={0,0,127}));
  connect(THeaSetOffFil.y, sumUnoHea.u)
    annotation (Line(points={{-78,-20},{-62,-20}}, color={0,0,127}));
  connect(u1EndSetBac, uEndSetBacFil.u)
    annotation (Line(points={{-140,-60},{-102,-60}}, color={255,0,255}));
  connect(uEndSetBacFil.y, endSetBac.u)
    annotation (Line(points={{-78,-60},{58,-60}}, color={255,0,255}));
  connect(u1HigUnoCoo, uHigUnoCooFil.u)
    annotation (Line(points={{-140,-90},{-102,-90}}, color={255,0,255}));
  connect(uHigUnoCooFil.y, booToInt1.u)
    annotation (Line(points={{-78,-90},{-62,-90}}, color={255,0,255}));
  connect(TCooSetOff, TCooSetOffFil.u)
    annotation (Line(points={{-140,-150},{-102,-150}}, color={0,0,127}));
  connect(TCooSetOffFil.y, sumUnoCoo.u)
    annotation (Line(points={{-78,-150},{-62,-150}}, color={0,0,127}));
  connect(u1EndSetUp, uEndSetUpFil.u)
    annotation (Line(points={{-142,-180},{-102,-180}}, color={255,0,255}));
  connect(uEndSetUpFil.y, endSetUp.u)
    annotation (Line(points={{-78,-180},{16,-180}}, color={255,0,255}));
  connect(TZon, TZonFil.u)
    annotation (Line(points={{-140,-220},{-102,-220}}, color={0,0,127}));
  connect(TZonFil.y, maxTem.u)
    annotation (Line(points={{-78,-220},{18,-220}}, color={0,0,127}));
  connect(TZonFil.y, sumTem.u) annotation (Line(points={{-78,-220},{-70,-220},{-70,
          -200},{-62,-200}}, color={0,0,127}));
  connect(TZonFil.y, minTem.u) annotation (Line(points={{-78,-220},{-70,-220},{-70,
          -260},{18,-260}}, color={0,0,127}));
  connect(uWinFil.y, not1.u)
    annotation (Line(points={{-78,-300},{-62,-300}}, color={255,0,255}));
  connect(not1.y, booToInt2.u)
    annotation (Line(points={{-38,-300},{18,-300}}, color={255,0,255}));
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
          textString="u1OccHeaHig"),
        Text(
          extent={{-96,38},{-46,24}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1HigOccCoo"),
        Text(
          extent={{-96,-82},{-44,-98}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1HigUnoCoo"),
        Text(
          extent={{-96,-42},{-46,-56}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1EndSetBac"),
        Text(
          extent={{-96,-124},{-48,-138}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1EndSetUp"),
        Text(
          extent={{-96,-4},{-46,-18}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1UnoHeaHig"),
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
          textString="u1Occ"),
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
          textString="u1Win"),
        Text(
          extent={{64,-182},{98,-196}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yOpeWin")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-320},{120,320}})),
Documentation(info="<html>
<p>
This sequence sums up the zone level status calculation to find the outputs that are
needed to define the zone group operation mode.
</p>
<p>
It requires following inputs from zone lelvel calculation:
</p>
<ul>
<li>
<code>zonOcc</code>: if the zone-level local override switch indicates the zone is
occupied,
</li>
<li>
<code>u1Occ</code>: if the zone is occupied according to its occupancy schedule,
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
<code>u1OccHeaHig</code>: if the zone temperature is lower than the occupied
heating setpoint,
</li>
<li>
<code>u1HigOccCoo</code>: if the zone temperature is higher than the occupied
cooling setpoint,
</li>
<li>
<code>u1UnoHeaHig</code>: if the zone temperature is lower than the unoccupied
heating setpoint,
</li>
<li>
<code>THeaSetOff</code>: zone unoccupied heating setpoint,
</li>
<li>
<code>u1EndSetBac</code>: if the zone could end the setback mode,
</li>
<li>
<code>u1HigUnoCoo</code>: if the zone temperature is higher than its unoccupied 
cooling setpoint,
</li>
<li>
<code>TCooSetOff</code>: zone unoccupied cooling setpoint,
</li>
<li>
<code>u1EndSetUp</code>: if the zone could end the setup mode,
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
June 10 15, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end GroupStatus;
