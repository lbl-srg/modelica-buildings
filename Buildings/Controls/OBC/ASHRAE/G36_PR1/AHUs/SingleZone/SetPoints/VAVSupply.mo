within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.SetPoints;
block VAVSupply "Supply air set point for single zone VAV system"

  parameter Modelica.SIunits.Temperature TMax
    "Maximum supply air temperature for heating"
    annotation (Dialog(group="Temperatures"));

  parameter Modelica.SIunits.Temperature TMin
    "Minimum supply air temperature for cooling"
    annotation (Dialog(group="Temperatures"));

  parameter Real yHeaMax(min=0, max=1, unit="1")
    "Maximum fan speed for heating"
    annotation (Dialog(group="Speed"));

  parameter Real yMin(min=0, max=1, unit="1")
    "Minimum fan speed"
    annotation (Dialog(group="Speed"));

  parameter Real yCooMax(min=0, max=1, unit="1") = 1
    "Maximum fan speed for cooling"
    annotation (Dialog(group="Speed"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(min=0, max=1, unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(min=0, max=1, unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetZon(unit="K", displayUnit="degC")
    "Average of heating and cooling setpoints for zone temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(unit="K", displayUnit="degC")
    "Zone temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(unit="K", displayUnit="degC")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaEco(unit="K", displayUnit="degC")
    "Temperature setpoint for heating coil and for economizer"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TCoo(unit="K", displayUnit="degC")
    "Cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(min=0, max=1, unit="1") "Fan speed"
  annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Line TSetCooHig
    "Table to compute the setpoint for cooling for uCoo = 0...1"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Line offSetTSetHea
    "Table to compute the setpoint offset for heating for uCoo = 0...1"
    annotation (Placement(transformation(extent={{0,140},{20,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addTHe "Adder for heating setpoint calculation"
    annotation (Placement(transformation(extent={{60,160},{80,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Line offSetTSetCoo
    "Table to compute the setpoint offset for cooling for uHea = 0...1"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addTCoo "Adder for cooling setpoint calculation"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Add dT(final k2=-1) "Difference zone minus outdoor temperature"
    annotation (Placement(transformation(extent={{-80,-200},{-60,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter yMed(
    p=yCooMax - (yMin - yCooMax)/(0.56 - 5.6)*5.6,
    k=(yMin - yCooMax)/(0.56 - 5.6)) "Fan speed at medium cooling load"
    annotation (Placement(transformation(extent={{-40,-200},{-20,-180}})));
  Buildings.Controls.SetPoints.Table yHea(final table=[0.5,yMin; 1,yHeaMax])
    "Fan speed for heating"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis yMinChe1(
    final uLow=0.2,
    final uHigh=0.3)
    "Check for cooling signal for fan speed"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch switch1
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis yMinChe2(
    final uLow=0.45,
    final uHigh=0.55)
    "Check for cooling signal for fan speed"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch switch2
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis yMinChe3(
    final uLow=0.7,
    final uHigh=0.8)
    "Check for cooling signal for fan speed"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Switch switch3
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add(final k1=-1)
    annotation (Placement(transformation(extent={{0,-240},{20,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1
    annotation (Placement(transformation(extent={{40,-270},{60,-250}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gain(final k=4)
    annotation (Placement(transformation(extent={{-80,-256},{-60,-236}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter yMed1(
    final p=2*yMin,
    final k=-yMin)
    "Fan speed at medium cooling load"
    annotation (Placement(transformation(extent={{-20,-290},{0,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gain1(final k=4)
    annotation (Placement(transformation(extent={{-80,-356},{-60,-336}})));
  Buildings.Controls.OBC.CDL.Continuous.Product product
    annotation (Placement(transformation(extent={{-40,-250},{-20,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter yMed2(
    final p=-3*yCooMax,
    final k=4*yCooMax)
    "Fan speed at medium cooling load"
    annotation (Placement(transformation(extent={{-20,-390},{0,-370}})));
  Buildings.Controls.OBC.CDL.Continuous.Product product1
    annotation (Placement(transformation(extent={{-40,-350},{-20,-330}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k1=4,
    final k2=-1)
    annotation (Placement(transformation(extent={{0,-340},{20,-320}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3
    annotation (Placement(transformation(extent={{40,-370},{60,-350}})));
  Buildings.Controls.OBC.CDL.Continuous.Limiter yMedLim(
    final uMax=yCooMax,
    final uMin=yMin) "Limiter for yMed"
    annotation (Placement(transformation(extent={{-10,-200},{10,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Limiter TDea(uMax=24 + 273.15, uMin=21 + 273.15)
    "Limiter that outputs the dead band value for the supply air temperature"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Line TSetHeaHig
    "Block to compute the setpoint for heating for uHea = 0...1"
    annotation (Placement(transformation(extent={{2,180},{22,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con0(
    final k=0) "Contant that outputs zero"
    annotation (Placement(transformation(extent={{-80,180},{-60,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con25(
    final k=0.25) "Contant that outputs 0.25"
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con05(
    final k=0.5) "Contant that outputs 0.5"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con75(
    final k=0.75) "Contant that outputs 0.75"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conTMax(
    final k=TMax) "Constant that outputs TMax"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conTMin(
    final k=TMin) "Constant that outputs TMin"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add TDeaTMin(
    final k2=-1) "Outputs TDea-TMin"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addTDea(
    final p=-1.1,
    final k=-1)
    "Adds constant offset"
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add TMaxTDea(
    final k2=-1) "Outputs TMax-TDea"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-40,-160},{-20,-140}})));

equation
  connect(offSetTSetHea.u, uCoo)
    annotation (Line(points={{-2,150},{-2,150},{-32,150},{-32,52},{-94,52},
      {-94,40},{-120,40}}, color={0,0,127}));
  connect(offSetTSetHea.y, addTHe.u2)
    annotation (Line(points={{21,150},{21,150},{40,150},{40,164},{58,164}},
      color={0,0,127}));
  connect(addTHe.y, THeaEco)
    annotation (Line(points={{81,170},{92,170},{92,60},{110,60}},
      color={0,0,127}));
  connect(TSetCooHig.y, addTCoo.u1)
    annotation (Line(points={{21,110},{40,110},{40,96},{58,96}},
      color={0,0,127}));
  connect(offSetTSetCoo.y, addTCoo.u2)
    annotation (Line(points={{21,70},{40,70},{40,84},{58,84}},
      color={0,0,127}));
  connect(TSetCooHig.u, uCoo)
    annotation (Line(points={{-2,110},{-2,110},{-22,110},{-32,110},{-32,52},
      {-94,52},{-94,40},{-120,40}}, color={0,0,127}));
  connect(offSetTSetCoo.u, uHea)
    annotation (Line(points={{-2,70},{-2,70},{-20,70},{-60,70},{-90,70},
      {-90,80},{-120,80}}, color={0,0,127}));
  connect(addTCoo.y, TCoo)
    annotation (Line(points={{81,90},{81,90},{84,90},{84,0},{110,0}},
      color={0,0,127}));
  connect(dT.u1, TZon)
    annotation (Line(points={{-82,-184},{-86,-184},{-86,-40},{-120,-40}},
      color={0,0,127}));
  connect(dT.u2, TOut)
    annotation (Line(points={{-82,-196},{-90,-196},{-90,-80},{-120,-80}},
      color={0,0,127}));
  connect(dT.y, yMed.u)
    annotation (Line(points={{-59,-190},{-59,-190},{-42,-190}},
      color={0,0,127}));
  connect(yMinChe1.u, uCoo)
    annotation (Line(points={{-82,-90},{-82,-90},{-94,-90},{-94,40},{-120,40}},
      color={0,0,127}));
  connect(switch2.y, switch1.u3)
    annotation (Line(points={{61,-110},{80,-110},{80,-90},{46,-90},{46,-78},{58,-78}},
      color={0,0,127}));
  connect(yMinChe2.u, uCoo)
    annotation (Line(points={{-82,-120},{-94,-120},{-94,40},{-120,40}},
      color={0,0,127}));
  connect(yMinChe3.u, uCoo)
    annotation (Line(points={{-82,-150},{-94,-150},{-94,40},{-120,40}},
      color={0,0,127}));
  connect(yMedLim.y, add.u1)
    annotation (Line(points={{11,-190},{20,-190},{20,-208},{-50,-208},{-50,-224},
      {-2,-224}}, color={0,0,127}));
  connect(gain.u, uCoo)
    annotation (Line(points={{-82,-246},{-94,-246},{-94,40},{-120,40}},
      color={0,0,127}));
  connect(gain.y, yMed1.u)
    annotation (Line(points={{-59,-246},{-58,-246},{-54,-246},{-54,-280},{-22,-280}},
      color={0,0,127}));
  connect(add.y, add1.u1)
    annotation (Line(points={{21,-230},{32,-230},{32,-254},{38,-254}},
      color={0,0,127}));
  connect(yMed1.y, add1.u2)
    annotation (Line(points={{1,-280},{10,-280},{10,-266},{38,-266}},
      color={0,0,127}));
  connect(add1.y, switch2.u1)
    annotation (Line(points={{61,-260},{72,-260},{72,-126},{28,-126},{28,-102},
      {38,-102}}, color={0,0,127}));
  connect(gain1.u, uCoo)
    annotation (Line(points={{-82,-346},{-94,-346},{-94,40},{-120,40}},
      color={0,0,127}));
  connect(product.u1, yMedLim.y)
    annotation (Line(points={{-42,-234},{-50,-234},{-50,-208},{20,-208},{20,-190},
      {11,-190}}, color={0,0,127}));
  connect(product.y, add.u2)
    annotation (Line(points={{-19,-240},{-12,-240},{-12,-236},{-2,-236}},
      color={0,0,127}));
  connect(product.u2, gain.y)
    annotation (Line(points={{-42,-246},{-59,-246}}, color={0,0,127}));
  connect(yMedLim.y, add2.u1)
    annotation (Line(points={{11,-190},{20,-190},{20,-208},{-50,-208},{-50,-324},
      {-2,-324}}, color={0,0,127}));
  connect(product1.y, add2.u2)
    annotation (Line(points={{-19,-340},{-14,-340},{-14,-336},{-2,-336}},
      color={0,0,127}));
  connect(add2.y, add3.u1)
    annotation (Line(points={{21,-330},{24,-330},{24,-354},{38,-354}},
      color={0,0,127}));
  connect(yMed2.y, add3.u2)
    annotation (Line(points={{1,-380},{22,-380},{22,-366},{38,-366}},
      color={0,0,127}));
  connect(product1.u2, gain1.y)
    annotation (Line(points={{-42,-346},{-59,-346}}, color={0,0,127}));
  connect(product1.u1, yMedLim.y)
    annotation (Line(points={{-42,-334},{-50,-334},{-50,-218},{-50,-208},{20,-208},
      {20,-190},{11,-190}}, color={0,0,127}));
  connect(yMed2.u, uCoo)
    annotation (Line(points={{-22,-380},{-54,-380},{-94,-380},{-94,40},{-120,40}},
      color={0,0,127}));
  connect(add3.y, switch3.u3)
    annotation (Line(points={{61,-360},{76,-360},{76,-168},{4,-168},{4,-158},{18,-158}},
      color={0,0,127}));
  connect(yHea.y, switch1.u1)
    annotation (Line(points={{1,-60},{30,-60},{30,-62},{58,-62}},
      color={0,0,127}));
  connect(switch1.y, y)
    annotation (Line(points={{81,-70},{90,-70},{90,-60},{110,-60}},
      color={0,0,127}));
  connect(yMedLim.y, switch3.u1)
    annotation (Line(points={{11,-190},{20,-190},{20,-170},{0,-170},{0,-142},{18,-142}},
      color={0,0,127}));
  connect(yMedLim.u, yMed.y)
    annotation (Line(points={{-12,-190},{-19,-190}}, color={0,0,127}));
  connect(TDea.u, TSetZon)
    annotation (Line(points={{-82,0},{-82,0},{-120,0}},  color={0,0,127}));
  connect(con0.y, TSetHeaHig.x1)
    annotation (Line(points={{-59,190},{-52,190},{-52,198},{0,198}},
      color={0,0,127}));
  connect(TDea.y, TSetHeaHig.f1)
    annotation (Line(points={{-59,0},{-52,0},{-52,194},{0,194}},
      color={0,0,127}));
  connect(con05.y, TSetHeaHig.x2)
    annotation (Line(points={{-59,120},{-46,120},{-46,186},{0,186}},
      color={0,0,127}));
  connect(conTMax.y, TSetHeaHig.f2)
    annotation (Line(points={{-59,30},{-40,30},{-40,182},{0,182}},
      color={0,0,127}));
  connect(uHea, TSetHeaHig.u)
    annotation (Line(points={{-120,80},{-90,80},{-90,70},{-36,70},{-36,190},
      {0,190}}, color={0,0,127}));
  connect(TSetHeaHig.y, addTHe.u1)
    annotation (Line(points={{23,190},{40,190},{40,176},{58,176}},
      color={0,0,127}));
  connect(con0.y, offSetTSetHea.x1)
    annotation (Line(points={{-59,190},{-56,190},{-56,158},{-2,158}},
      color={0,0,127}));
  connect(con25.y, offSetTSetHea.x2)
    annotation (Line(points={{-59,160},{-54,160},{-54,146},{-2,146}},
      color={0,0,127}));
  connect(con0.y, offSetTSetHea.f1)
    annotation (Line(points={{-59,190},{-56,190},{-56,154},{-2,154}},
      color={0,0,127}));
  connect(yHea.u, uHea)
    annotation (Line(points={{-22,-60},{-90,-60},{-90,80},{-120,80}},
      color={0,0,127}));
  connect(TDea.y, TDeaTMin.u1)
    annotation (Line(points={{-59,0},{-40,0},{-40,-14},{-22,-14}},
      color={0,0,127}));
  connect(conTMin.y, TDeaTMin.u2)
    annotation (Line(points={{-59,-30},{-50,-30},{-50,-26},{-22,-26}},
      color={0,0,127}));
  connect(TDeaTMin.y, addTDea.u)
    annotation (Line(points={{1,-20},{-2,-20},{8,-20}}, color={0,0,127}));
  connect(addTDea.y, offSetTSetHea.f2)
    annotation (Line(points={{31,-20},{34,-20},{34,40},{-14,40},{-14,142},{-2,142}},
      color={0,0,127}));
  connect(TSetCooHig.x1, con05.y)
    annotation (Line(points={{-2,118},{-24,118},{-46,118},{-46,120},{-59,120}},
      color={0,0,127}));
  connect(TSetCooHig.f1, TDea.y)
    annotation (Line(points={{-2,114},{-10,114},{-52,114},{-52,0},{-59,0}},
      color={0,0,127}));
  connect(TSetCooHig.x2, con75.y)
    annotation (Line(points={{-2,106},{-8,106},{-44,106},{-44,90},{-59,90}},
      color={0,0,127}));
  connect(TSetCooHig.f2, conTMin.y)
    annotation (Line(points={{-2,102},{-2,114},{-50,114},{-50,-30},{-59,-30}},
      color={0,0,127}));
  connect(offSetTSetCoo.f1, con0.y)
    annotation (Line(points={{-2,74},{-56,74},{-56,190},{-59,190}},
      color={0,0,127}));
  connect(offSetTSetCoo.x1, con0.y)
    annotation (Line(points={{-2,78},{-56,78},{-56,70},{-56,190},{-59,190}},
      color={0,0,127}));
  connect(offSetTSetCoo.x2, con05.y)
    annotation (Line(points={{-2,66},{-10,66},{-46,66},{-46,120},{-59,120}},
      color={0,0,127}));
  connect(TMaxTDea.u1, conTMax.y)
    annotation (Line(points={{-22,26},{-40,26},{-40,30},{-59,30}},
      color={0,0,127}));
  connect(TDea.y, TMaxTDea.u2)
    annotation (Line(points={{-59,0},{-40,0},{-40,14},{-22,14}},
      color={0,0,127}));
  connect(TMaxTDea.y, offSetTSetCoo.f2)
    annotation (Line(points={{1,20},{10,20},{10,50},{-10,50},{-10,62},{-2,62}},
      color={0,0,127}));
  connect(yMinChe1.y, not1.u)
    annotation (Line(points={{-59,-90},{-42,-90}}, color={255,0,255}));
  connect(not1.y, switch1.u2)
    annotation (Line(points={{-19,-90},{40,-90},{40,-70},{58,-70}},
      color={255,0,255}));
  connect(yMinChe2.y, not2.u)
    annotation (Line(points={{-59,-120},{-42,-120}}, color={255,0,255}));
  connect(not2.y, switch2.u2)
    annotation (Line(points={{-19,-120},{0,-120},{0,-110},{38,-110}},
      color={255,0,255}));
  connect(yMinChe3.y, not3.u)
    annotation (Line(points={{-59,-150},{-42,-150}}, color={255,0,255}));
  connect(not3.y, switch3.u2)
    annotation (Line(points={{-19,-150},{18,-150}}, color={255,0,255}));
  connect(switch3.y, switch2.u3)
    annotation (Line(points={{41,-150},{60,-150},{60,-130},{20,-130},{20,-118},
      {38,-118}}, color={0,0,127}));

annotation (
  defaultComponentName = "setPoiVAV",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255}),
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
      lineColor={0,0,0},
          textString="T"),
    Text(
      extent={{64,-82},{88,-93}},
      lineColor={0,0,0},
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
          extent={{-98,90},{-72,68}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uHea"),
        Text(
          extent={{-96,50},{-70,28}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uCoo"),
        Text(
          extent={{68,72},{94,50}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="THeaEco"),
        Text(
          extent={{68,12},{94,-10}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TCoo"),
        Text(
          extent={{74,-50},{100,-72}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="y"),
        Text(
          extent={{-96,-30},{-70,-52}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZon"),
        Text(
          extent={{-98,-68},{-72,-90}},
          lineColor={0,0,127},
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
      lineColor={0,0,0},
          textString="y"),
        Line(points={{-46,44},{-28,20},{18,20},{28,36},{38,36},{50,54}}, color={
              0,0,0}),
        Line(points={{18,20},{38,20},{50,54},{28,54},{18,20}}, color={0,0,0}),
        Text(
          extent={{-96,12},{-70,-10}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSetZon")}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-420},{100,220}}), graphics={
        Rectangle(
          extent={{-88,-314},{70,-400}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-88,-214},{70,-300}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{32,-304},{68,-286}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="0.25 < y < 0.5"),
        Text(
          extent={{32,-404},{68,-386}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="0.75 < y < 1"),
        Rectangle(
          extent={{-88,-172},{70,-210}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{30,-212},{66,-194}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="0.5 < y < 0.75")}),
      Documentation(info="<html>
<p>
Block that outputs the set points for the supply air temperature for
cooling, heating and economizer control,
and the fan speed for a single zone VAV system.
</p>
<p>
For the temperature set points, the
parameters are the maximum supply air temperature <code>TMax</code>,
and the minimum supply air temperature for cooling <code>TMin</code>.
The deadband temperature is equal to the
average set point for the zone temperature
for heating and cooling, as obtained from the input <code>TSetZon</code>,
constraint to be within <i>21</i>&deg;C (&asymp;<i>70</i> F) and
<i>24</i>&deg;C (&asymp;<i>75</i> F).
The setpoints are computed as shown in the figure below.
Note that the setpoint for the supply air temperature for heating
and for economizer control is the same, and this setpoint is
lower than <code>TMin</code> when the heating loop signal
is zero and the economizer is in cooling mode, as shown in the figure.
</p>
<p>
For the fan speed set point, the
parameters are the maximu fan speed at heating <code>yHeaMax</code>,
the minimum fan speed <code>yMin</code> and
the maximum fan speed for cooling <code>yCooMax</code>.
For a cooling control signal of <code>yCoo &gt; 0.25</code>,
the speed is faster increased the larger the difference is between
the zone temperature minus outdoor temperature <code>TZon-TOut</code>.
The figure below shows the sequence.
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/VAVSingleZoneTSupSet.png\"/>
</p>
<p>
The output <code>TCoo</code> is to be used to control the cooling coil,
and the output
<code>THeaEco</code> is to be used to control the heating coil and the
economizer dampers.
</p>
<p>
Note that the inputs <code>uHea</code> and <code>uCoo</code> must be computed
based on the same temperature sensors and control loops
</p>
</html>", revisions="<html>
<ul>
<li>
April 26, 2017, by Michael Wetter:<br/>
Updated documentation and renamed output signal to <code>THeaEco</code>.
</li>
<li>
January 10, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end VAVSupply;
