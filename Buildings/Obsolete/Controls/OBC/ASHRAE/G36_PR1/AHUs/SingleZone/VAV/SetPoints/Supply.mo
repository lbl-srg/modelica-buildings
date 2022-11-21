within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints;
block Supply "Supply air set point for single zone VAV system"

  parameter Real TSupSetMax(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Maximum supply air temperature for heating"
    annotation (Dialog(group="Temperatures"));

  parameter Real TSupSetMin(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
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
    annotation (Placement(transformation(extent={{-140,90},{-100,130}}),
        iconTransformation(extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(min=0, max=1, unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonSet(unit="K", displayUnit="degC")
    "Average of heating and cooling setpoints for zone temperature"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
        iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(unit="K", displayUnit="degC")
    "Zone temperature"
    annotation (Placement(transformation(extent={{-140,-30},{-100,10}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(unit="K", displayUnit="degC")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupHeaEco(unit="K", displayUnit="degC")
    "Temperature setpoint for heating coil and for economizer"
    annotation (Placement(transformation(extent={{160,80},{200,120}}),
        iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupCoo(unit="K", displayUnit="degC")
    "Cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{160,20},{200,60}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(min=0, max=1, unit="1") "Fan speed"
  annotation (Placement(transformation(extent={{160,-80},{200,-40}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan "Supply fan status"
    annotation (Placement(transformation(extent={{-140,-160},{-100,-120}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch switch "Switch to assign control signal"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant fanOff(k=0) "Fan off status"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Min yFanHeaCoo "Fan speed due to heating or cooling"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1) "Maximum fan speed"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Line TSetCooHig
    "Table to compute the setpoint for cooling for uCoo = 0...1"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Line offSetTSetHea
    "Table to compute the setpoint offset for heating for uCoo = 0...1"
    annotation (Placement(transformation(extent={{0,170},{20,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addTHe
    "Adder for heating setpoint calculation"
    annotation (Placement(transformation(extent={{60,190},{80,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Line offSetTSetCoo
    "Table to compute the setpoint offset for cooling for uHea = 0...1"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addTSupCoo
    "Adder for cooling setpoint calculation"
    annotation (Placement(transformation(extent={{60,110},{80,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dT
    "Difference zone minus outdoor temperature"
    annotation (Placement(transformation(extent={{-70,-130},{-50,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=(yMin - yCooMax)/(0.56 - 5.6))
    "Gain factor"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter yMed(
    final p=yCooMax - (yMin - yCooMax)/(0.56 - 5.6)*5.6)
    "Fan speed at medium cooling load"
    annotation (Placement(transformation(extent={{-8,-130},{12,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Limiter yMedLim(
    final uMax=yCooMax,
    final uMin=yMin) "Limiter for yMed"
    annotation (Placement(transformation(extent={{28,-130},{48,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Limiter TDea(
    final uMax=24 + 273.15,
    final uMin=21 + 273.15)
    "Limiter that outputs the dead band value for the supply air temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Line TSetHeaHig
    "Block to compute the setpoint for heating for uHea = 0...1"
    annotation (Placement(transformation(extent={{2,210},{22,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con0(
    final k=0) "Contant that outputs zero"
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con25(
    final k=0.25) "Contant that outputs 0.25"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con05(
    final k=0.5) "Contant that outputs 0.5"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con75(
    final k=0.75) "Contant that outputs 0.75"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conTSupSetMax(
    final k=TSupSetMax) "Constant that outputs TSupSetMax"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conTSupSetMin(
    final k=TSupSetMin) "Constant that outputs TSupSetMin"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract TDeaTSupSetMin
    "Outputs TDea-TSupSetMin"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=-1)
    "Gain factor"
    annotation (Placement(transformation(extent={{10,0},{30,20}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addTDea(
    final p=-1.1)
    "Adds constant offset"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract TSupSetMaxTDea
    "Outputs TSupSetMax-TDea"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Line yHea "Fan speed for heating"
    annotation (Placement(transformation(extent={{4,-60},{24,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin050(
    final limitBelow=true,
    final limitAbove=true)
    "Linear increase in control signal for 0 < yCoo < 0.75"
    annotation (Placement(transformation(extent={{-20,-202},{0,-182}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con025(
    final k=0.25) "Constant signal"
    annotation (Placement(transformation(extent={{-80,-176},{-60,-156}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=0.5) "Constant signal"
    annotation (Placement(transformation(extent={{-80,-232},{-60,-212}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
    final k=1) "Constant signal"
    annotation (Placement(transformation(extent={{0,-320},{20,-300}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=0) "Constant signal"
    annotation (Placement(transformation(extent={{-80,-206},{-60,-186}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(
    final k=yCooMax - yMin) "Constant signal"
    annotation (Placement(transformation(extent={{-76,-288},{-56,-268}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dY075
    "Change in control signal above yMedLim for y > 0.75"
    annotation (Placement(transformation(extent={{-36,-294},{-16,-274}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin075(
    final limitBelow=true,
    final limitAbove=true)
    "Linear increase in control signal for 0.75 < yCoo"
    annotation (Placement(transformation(extent={{34,-294},{54,-274}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con5(
    final k=0.75) "Constant signal"
    annotation (Placement(transformation(extent={{0,-286},{20,-266}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con6(
    final k=0) "Constant signal"
    annotation (Placement(transformation(extent={{0,-350},{20,-330}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter yOffSet(
    final p=-yMin)
    "Subtract yMin so that all control signals can be added"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Add addHeaCoo
    "Add heating control signal and offset due to cooling"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add offCoo
    "Offset of control signal (relative to heating signal) for cooling"
    annotation (Placement(transformation(extent={{40,-202},{60,-182}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con7(final k=0.5)
    "Contant that outputs 0.5"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minSpe(final k=yMin)
    "Contant that outputs minimum fan speed"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne(final k=1)
    "Contant that outputs 1"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxHeaSpe(final k=yHeaMax)
    "Contant that outputs maximum fan speed for heating"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

equation
  connect(offSetTSetHea.u, uCoo)
    annotation (Line(points={{-2,180},{-32,180},{-32,82},{-94,82},{-94,70},{-120,
          70}},            color={0,0,127}));
  connect(offSetTSetHea.y, addTHe.u2)
    annotation (Line(points={{22,180},{40,180},{40,194},{58,194}},
      color={0,0,127}));
  connect(addTHe.y, TSupHeaEco)
    annotation (Line(points={{82,200},{92,200},{92,100},{180,100}},
      color={0,0,127}));
  connect(TSetCooHig.y, addTSupCoo.u1)
    annotation (Line(points={{22,140},{40,140},{40,126},{58,126}},
      color={0,0,127}));
  connect(offSetTSetCoo.y, addTSupCoo.u2)
    annotation (Line(points={{22,100},{40,100},{40,114},{58,114}},
      color={0,0,127}));
  connect(TSetCooHig.u, uCoo)
    annotation (Line(points={{-2,140},{-32,140},{-32,82},{-94,82},{-94,70},{-120,
          70}},                     color={0,0,127}));
  connect(offSetTSetCoo.u, uHea)
    annotation (Line(points={{-2,100},{-88,100},{-88,110},{-120,110}},
                           color={0,0,127}));
  connect(addTSupCoo.y, TSupCoo)
    annotation (Line(points={{82,120},{84,120},{84,40},{180,40}},
      color={0,0,127}));
  connect(dT.u1, TZon)
    annotation (Line(points={{-72,-114},{-86,-114},{-86,-10},{-120,-10}},
      color={0,0,127}));
  connect(dT.u2, TOut)
    annotation (Line(points={{-72,-126},{-88,-126},{-88,-80},{-120,-80}},
      color={0,0,127}));
  connect(yMedLim.u, yMed.y)
    annotation (Line(points={{26,-120},{14,-120}},   color={0,0,127}));
  connect(TDea.u, TZonSet)
    annotation (Line(points={{-82,30},{-120,30}},        color={0,0,127}));
  connect(TDea.y, TSetHeaHig.f1)
    annotation (Line(points={{-58,30},{-52,30},{-52,224},{0,224}},
      color={0,0,127}));
  connect(con05.y, TSetHeaHig.x2)
    annotation (Line(points={{-58,150},{-46,150},{-46,216},{0,216}},
      color={0,0,127}));
  connect(conTSupSetMax.y, TSetHeaHig.f2)
    annotation (Line(points={{-58,60},{-40,60},{-40,212},{0,212}},
      color={0,0,127}));
  connect(uHea, TSetHeaHig.u)
    annotation (Line(points={{-120,110},{-88,110},{-88,102},{-36,102},{-36,220},
          {0,220}}, color={0,0,127}));
  connect(TSetHeaHig.y, addTHe.u1)
    annotation (Line(points={{24,220},{40,220},{40,206},{58,206}},
      color={0,0,127}));
  connect(con0.y, offSetTSetHea.x1)
    annotation (Line(points={{-58,220},{-56,220},{-56,188},{-2,188}},
      color={0,0,127}));
  connect(con25.y, offSetTSetHea.x2)
    annotation (Line(points={{-58,180},{-34,180},{-34,176},{-2,176}},
      color={0,0,127}));
  connect(con0.y, offSetTSetHea.f1)
    annotation (Line(points={{-58,220},{-56,220},{-56,184},{-2,184}},
      color={0,0,127}));
  connect(TDea.y, TDeaTSupSetMin.u1)
    annotation (Line(points={{-58,30},{-40,30},{-40,16},{-22,16}},
      color={0,0,127}));
  connect(conTSupSetMin.y, TDeaTSupSetMin.u2)
    annotation (Line(points={{-58,0},{-40,0},{-40,4},{-22,4}},
      color={0,0,127}));
  connect(addTDea.y, offSetTSetHea.f2)
    annotation (Line(points={{62,10},{70,10},{70,70},{-14,70},{-14,172},{-2,172}},
      color={0,0,127}));
  connect(TSetCooHig.x1, con05.y)
    annotation (Line(points={{-2,148},{-30,148},{-30,150},{-58,150}},
      color={0,0,127}));
  connect(TSetCooHig.f1, TDea.y)
    annotation (Line(points={{-2,144},{-52,144},{-52,30},{-58,30}},
      color={0,0,127}));
  connect(TSetCooHig.x2, con75.y)
    annotation (Line(points={{-2,136},{-44,136},{-44,120},{-58,120}},
      color={0,0,127}));
  connect(TSetCooHig.f2, conTSupSetMin.y)
    annotation (Line(points={{-2,132},{-50,132},{-50,0},{-58,0}},
      color={0,0,127}));
  connect(offSetTSetCoo.f1, con0.y)
    annotation (Line(points={{-2,104},{-56,104},{-56,220},{-58,220}},
      color={0,0,127}));
  connect(offSetTSetCoo.x1, con0.y)
    annotation (Line(points={{-2,108},{-56,108},{-56,220},{-58,220}},
      color={0,0,127}));
  connect(offSetTSetCoo.x2, con05.y)
    annotation (Line(points={{-2,96},{-46,96},{-46,150},{-58,150}},
      color={0,0,127}));
  connect(TSupSetMaxTDea.u1, conTSupSetMax.y)
    annotation (Line(points={{-22,56},{-40,56},{-40,60},{-58,60}},
      color={0,0,127}));
  connect(TDea.y, TSupSetMaxTDea.u2)
    annotation (Line(points={{-58,30},{-40,30},{-40,44},{-22,44}},
      color={0,0,127}));
  connect(TSupSetMaxTDea.y, offSetTSetCoo.f2)
    annotation (Line(points={{2,50},{10,50},{10,80},{-10,80},{-10,92},{-2,92}},
      color={0,0,127}));
  connect(uCoo, lin050.u) annotation (Line(points={{-120,70},{-94,70},{-94,-146},
          {-38,-146},{-38,-192},{-22,-192}}, color={0,0,127}));
  connect(dY075.u1, con4.y)
    annotation (Line(points={{-38,-278},{-54,-278}}, color={0,0,127}));
  connect(lin075.x2, con2.y) annotation (Line(points={{32,-288},{24,-288},{24,-310},
          {22,-310}}, color={0,0,127}));
  connect(lin075.x1, con5.y)
    annotation (Line(points={{32,-276},{22,-276}}, color={0,0,127}));
  connect(uCoo, lin075.u) annotation (Line(points={{-120,70},{-90,70},{-90,-252},
          {24,-252},{24,-284},{32,-284}}, color={0,0,127}));
  connect(yMedLim.y, yOffSet.u)
    annotation (Line(points={{50,-120},{58,-120}}, color={0,0,127}));
  connect(dY075.u2, yOffSet.y) annotation (Line(points={{-38,-290},{-42,-290},{-42,
          -160},{94,-160},{94,-120},{82,-120}}, color={0,0,127}));
  connect(offCoo.u1, lin050.y) annotation (Line(points={{38,-186},{20,-186},{20,
          -192},{2,-192}}, color={0,0,127}));
  connect(offCoo.u2, lin075.y) annotation (Line(points={{38,-198},{34,-198},{34,
          -256},{60,-256},{60,-284},{56,-284}}, color={0,0,127}));
  connect(offCoo.y, addHeaCoo.u2) annotation (Line(points={{62,-192},{100,-192},
          {100,-80},{30,-80},{30,-66},{38,-66}}, color={0,0,127}));
  connect(lin050.x2, con1.y) annotation (Line(points={{-22,-196},{-46,-196},{-46,
          -222},{-58,-222}}, color={0,0,127}));
  connect(con025.y, lin050.x1) annotation (Line(points={{-58,-166},{-52,-166},{-52,
          -184},{-22,-184}}, color={0,0,127}));
  connect(lin050.f2, yOffSet.y) annotation (Line(points={{-22,-200},{-42,-200},{
          -42,-160},{94,-160},{94,-120},{82,-120}}, color={0,0,127}));
  connect(con3.y, lin050.f1) annotation (Line(points={{-58,-196},{-50,-196},{-50,
          -188},{-22,-188}}, color={0,0,127}));
  connect(dY075.y, lin075.f2) annotation (Line(points={{-14,-284},{-8,-284},{-8,
          -292},{32,-292}}, color={0,0,127}));
  connect(con6.y, lin075.f1) annotation (Line(points={{22,-340},{24,-340},{24,-280},
          {32,-280}}, color={0,0,127}));
  connect(TSetHeaHig.x1, con0.y) annotation (Line(points={{0,228},{-56,228},{-56,
          220},{-58,220}}, color={0,0,127}));
  connect(con7.y, yHea.x1) annotation (Line(points={{-18,-30},{-6,-30},{-6,-42},
          {2,-42}}, color={0,0,127}));
  connect(minSpe.y, yHea.f1) annotation (Line(points={{-58,-30},{-56,-30},{-56,-46},
          {2,-46}},  color={0,0,127}));
  connect(uHea, yHea.u) annotation (Line(points={{-120,110},{-94,110},{-94,-50},
          {2,-50}},  color={0,0,127}));
  connect(conOne.y, yHea.x2) annotation (Line(points={{-58,-70},{-56,-70},{-56,-54},
          {2,-54}},  color={0,0,127}));
  connect(maxHeaSpe.y, yHea.f2) annotation (Line(points={{-18,-70},{-6,-70},{-6,
          -58},{2,-58}}, color={0,0,127}));
  connect(yHea.y, addHeaCoo.u1) annotation (Line(points={{26,-50},{32,-50},{32,-54},
          {38,-54}}, color={0,0,127}));
  connect(uFan, switch.u2) annotation (Line(points={{-120,-140},{106,-140},{106,
          -60},{118,-60}}, color={255,0,255}));
  connect(fanOff.y, switch.u3)
    annotation (Line(points={{102,20},{112,20},{112,-68},{118,-68}}, color={0,0,127}));
  connect(switch.y, y) annotation (Line(points={{142,-60},{180,-60}},
                 color={0,0,127}));
  connect(one.y, yFanHeaCoo.u1) annotation (Line(points={{62,-20},{70,-20},{70,-24},
          {78,-24}}, color={0,0,127}));
  connect(addHeaCoo.y, yFanHeaCoo.u2) annotation (Line(points={{62,-60},{70,-60},
          {70,-36},{78,-36}}, color={0,0,127}));
  connect(yFanHeaCoo.y, switch.u1) annotation (Line(points={{102,-30},{116,-30},
          {116,-52},{118,-52}}, color={0,0,127}));
  connect(TDeaTSupSetMin.y, gai.u)
    annotation (Line(points={{2,10},{8,10}}, color={0,0,127}));
  connect(gai.y, addTDea.u)
    annotation (Line(points={{32,10},{38,10}}, color={0,0,127}));
  connect(dT.y, gai1.u)
    annotation (Line(points={{-48,-120},{-42,-120}}, color={0,0,127}));
  connect(gai1.y, yMed.u)
    annotation (Line(points={{-18,-120},{-10,-120}}, color={0,0,127}));

annotation (
  defaultComponentName = "setPoiVAV",
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,120}}),
    graphics={
        Rectangle(
        extent={{-100,-120},{100,120}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-150,174},{150,134}},
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
          extent={{-98,104},{-72,82}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uHea"),
        Text(
          extent={{-98,68},{-72,46}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uCoo"),
        Text(
          extent={{68,72},{94,50}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSupHeaEco"),
        Text(
          extent={{68,12},{94,-10}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSupCoo"),
        Text(
          extent={{74,-50},{100,-72}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="y"),
        Text(
          extent={{-96,-12},{-70,-34}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZon"),
        Text(
          extent={{-98,-50},{-72,-72}},
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
          extent={{-96,30},{-70,8}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonSet"),
        Text(
          extent={{-98,-82},{-72,-104}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uFan")}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-360},{160,240}}), graphics={
        Rectangle(
          extent={{-82,-152},{84,-248}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{46,-252},{82,-234}},
          textColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="0.25 < yCoo < 0.5"),
        Text(
          extent={{46,-316},{82,-298}},
          textColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="0.75 < yCoo < 1"),
        Rectangle(
          extent={{-76,-100},{88,-138}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{46,-142},{82,-124}},
          textColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="0.5 < yCoo < 0.75"),
        Rectangle(
          extent={{-84,-16},{26,-86}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-16,-78},{14,-72}},
          textColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="heating"),
        Text(
          extent={{-74,-98},{96,-90}},
          textColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="For cooling, compute the change relative to yMin, and then add the heating and
cooling control signals to output yFan"),
        Rectangle(
          extent={{-82,-256},{84,-356}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}),
      Documentation(info="<html>
<p>
Block that outputs the set points for the supply air temperature for
cooling, heating and economizer control,
and the fan speed for a single zone VAV system.
</p>
<p>
For the temperature set points, the
parameters are the maximum supply air temperature <code>TSupSetMax</code>,
and the minimum supply air temperature for cooling <code>TSupSetMin</code>.
The deadband temperature is equal to the
average set point for the zone temperature
for heating and cooling, as obtained from the input <code>TZonSet</code>,
constraint to be within <i>21</i>&deg;C (&asymp;<i>70</i> F) and
<i>24</i>&deg;C (&asymp;<i>75</i> F).
The setpoints are computed as shown in the figure below.
Note that the setpoint for the supply air temperature for heating
and for economizer control is the same, and this setpoint is
lower than <code>TSupSetMin</code> when the heating loop signal
is zero and the economizer is in cooling mode, as shown in the figure.
</p>
<p>
For the fan speed set point, the
parameters are the maximu fan speed at heating <code>yHeaMax</code>,
the minimum fan speed <code>yMin</code> and
the maximum fan speed for cooling <code>yCooMax</code>.
For a cooling control signal of <code>uCoo &gt; 0.25</code>,
the speed is faster increased the larger the difference is between
the zone temperature minus outdoor temperature <code>TZon-TOut</code>.
The figure below shows the sequence.
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/SetPoints/Supply.png\"/>
</p>
<p>
The output <code>TSupCoo</code> is to be used to control the cooling coil,
and the output
<code>TSupHeaEco</code> is to be used to control the heating coil and the
economizer dampers.
</p>
<p>
Note that the inputs <code>uHea</code> and <code>uCoo</code> must be computed
based on the same temperature sensors and control loops.
</p>
</html>", revisions="<html>
<ul>
<li>
April 30, 2021, by Michael Wetter:<br/>
Added limiter to fan signal.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2475\">issue 2475</a>.
</li>
<li>
August 1, 2019, by Kun Zhang:<br/>
Added a switch for fan control.
</li>
<li>
March 21, 2019, by Jianjun Hu:<br/>
Used line block to avoid use of block that is not in CDL.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1389\">issue 1389</a>.
</li>
<li>
March 25, 2018, by Michael Wetter:<br/>
Revised implementation of fan speed control signal calculation
to remove the hysteresis blocks.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1153\">issue 1153</a>.
</li>
<li>
April 26, 2017, by Michael Wetter:<br/>
Updated documentation and renamed output signal to <code>TSupHeaEco</code>.
</li>
<li>
January 10, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Supply;
