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
    annotation (Placement(transformation(extent={{-70,-128},{-50,-108}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter yMed(
    p=yCooMax - (yMin - yCooMax)/(0.56 - 5.6)*5.6,
    k=(yMin - yCooMax)/(0.56 - 5.6)) "Fan speed at medium cooling load"
    annotation (Placement(transformation(extent={{-30,-128},{-10,-108}})));
  Buildings.Controls.SetPoints.Table yHea(final table=[0.5,yMin; 1,yHeaMax])
    "Fan speed for heating"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Limiter yMedLim(
    final uMax=yCooMax,
    final uMin=yMin) "Limiter for yMed"
    annotation (Placement(transformation(extent={{0,-128},{20,-108}})));
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
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
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

protected
  Buildings.Controls.OBC.CDL.Continuous.Line lin050(
    final limitBelow=true,
    final limitAbove=true)
    "Linear increase in control signal for 0 < yCoo < 0.75"
    annotation (Placement(transformation(extent={{-20,-202},{0,-182}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con025(
    final k=0.25) "Constant signal"
    annotation (Placement(transformation(extent={{-80,-212},{-60,-192}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=0.5) "Constant signal"
    annotation (Placement(transformation(extent={{-80,-180},{-60,-160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
    final k=1) "Constant signal"
    annotation (Placement(transformation(extent={{0,-320},{20,-300}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=0) "Constant signal"
    annotation (Placement(transformation(extent={{-80,-242},{-60,-222}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(
    final k=yCooMax - yMin) "Constant signal"
    annotation (Placement(transformation(extent={{-76,-288},{-56,-268}})));
  Buildings.Controls.OBC.CDL.Continuous.Add dY075(
    final k2=-1,
    final k1=1)
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
    final p=-yMin, k=1)
    "Subtract yMin so that all control signals can be added"
    annotation (Placement(transformation(extent={{36,-128},{56,-108}})));

  Buildings.Controls.OBC.CDL.Continuous.Add addHeaCoo(
    final k1=1,
    final k2=1)
    "Add heating control signal and offset due to cooling"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add offCoo(
    final k1=1,
    final k2=1)
    "Offset of control signal (relative to heating signal) for cooling"
    annotation (Placement(transformation(extent={{40,-202},{60,-182}})));
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
    annotation (Line(points={{-2,110},{-32,110},{-32,52},{-94,52},{-94,40},{-120,
          40}},                     color={0,0,127}));
  connect(offSetTSetCoo.u, uHea)
    annotation (Line(points={{-2,70},{-88,70},{-88,80},{-120,80}},
                           color={0,0,127}));
  connect(addTCoo.y, TCoo)
    annotation (Line(points={{81,90},{81,90},{84,90},{84,0},{110,0}},
      color={0,0,127}));
  connect(dT.u1, TZon)
    annotation (Line(points={{-72,-112},{-86,-112},{-86,-40},{-120,-40}},
      color={0,0,127}));
  connect(dT.u2, TOut)
    annotation (Line(points={{-72,-124},{-88,-124},{-88,-80},{-120,-80}},
      color={0,0,127}));
  connect(dT.y, yMed.u)
    annotation (Line(points={{-49,-118},{-32,-118}},
      color={0,0,127}));
  connect(yMedLim.u, yMed.y)
    annotation (Line(points={{-2,-118},{-9,-118}},   color={0,0,127}));
  connect(TDea.u, TSetZon)
    annotation (Line(points={{-82,0},{-82,0},{-120,0}},  color={0,0,127}));
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
    annotation (Line(points={{-120,80},{-88,80},{-88,72},{-36,72},{-36,190},{0,190}},
                color={0,0,127}));
  connect(TSetHeaHig.y, addTHe.u1)
    annotation (Line(points={{23,190},{40,190},{40,176},{58,176}},
      color={0,0,127}));
  connect(con0.y, offSetTSetHea.x1)
    annotation (Line(points={{-59,190},{-56,190},{-56,158},{-2,158}},
      color={0,0,127}));
  connect(con25.y, offSetTSetHea.x2)
    annotation (Line(points={{-59,150},{-34,150},{-34,146},{-2,146}},
      color={0,0,127}));
  connect(con0.y, offSetTSetHea.f1)
    annotation (Line(points={{-59,190},{-56,190},{-56,154},{-2,154}},
      color={0,0,127}));
  connect(yHea.u, uHea)
    annotation (Line(points={{-22,-60},{-88,-60},{-88,80},{-120,80}},
      color={0,0,127}));
  connect(TDea.y, TDeaTMin.u1)
    annotation (Line(points={{-59,0},{-40,0},{-40,-14},{-22,-14}},
      color={0,0,127}));
  connect(conTMin.y, TDeaTMin.u2)
    annotation (Line(points={{-59,-30},{-40,-30},{-40,-26},{-22,-26}},
      color={0,0,127}));
  connect(TDeaTMin.y, addTDea.u)
    annotation (Line(points={{1,-20},{-2,-20},{8,-20}}, color={0,0,127}));
  connect(addTDea.y, offSetTSetHea.f2)
    annotation (Line(points={{31,-20},{34,-20},{34,40},{-14,40},{-14,142},{-2,142}},
      color={0,0,127}));
  connect(TSetCooHig.x1, con05.y)
    annotation (Line(points={{-2,118},{-30,118},{-30,120},{-59,120}},
      color={0,0,127}));
  connect(TSetCooHig.f1, TDea.y)
    annotation (Line(points={{-2,114},{-52,114},{-52,0},{-59,0}},
      color={0,0,127}));
  connect(TSetCooHig.x2, con75.y)
    annotation (Line(points={{-2,106},{-44,106},{-44,90},{-59,90}},
      color={0,0,127}));
  connect(TSetCooHig.f2, conTMin.y)
    annotation (Line(points={{-2,102},{-50,102},{-50,-30},{-59,-30}},
      color={0,0,127}));
  connect(offSetTSetCoo.f1, con0.y)
    annotation (Line(points={{-2,74},{-56,74},{-56,190},{-59,190}},
      color={0,0,127}));
  connect(offSetTSetCoo.x1, con0.y)
    annotation (Line(points={{-2,78},{-56,78},{-56,190},{-59,190}},
      color={0,0,127}));
  connect(offSetTSetCoo.x2, con05.y)
    annotation (Line(points={{-2,66},{-46,66},{-46,120},{-59,120}},
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

  connect(uCoo, lin050.u) annotation (Line(points={{-120,40},{-94,40},{-94,-154},
          {-38,-154},{-38,-192},{-22,-192}}, color={0,0,127}));
  connect(dY075.u1, con4.y)
    annotation (Line(points={{-38,-278},{-55,-278}}, color={0,0,127}));
  connect(lin075.x2, con2.y) annotation (Line(points={{32,-288},{24,-288},{24,-310},
          {21,-310}}, color={0,0,127}));
  connect(lin075.x1, con5.y)
    annotation (Line(points={{32,-276},{21,-276}}, color={0,0,127}));
  connect(uCoo, lin075.u) annotation (Line(points={{-120,40},{-90,40},{-90,-260},
          {24,-260},{24,-284},{32,-284}}, color={0,0,127}));
  connect(yMedLim.y, yOffSet.u)
    annotation (Line(points={{21,-118},{34,-118}}, color={0,0,127}));
  connect(dY075.u2, yOffSet.y) annotation (Line(points={{-38,-290},{-42,-290},{-42,
          -160},{70,-160},{70,-118},{57,-118}}, color={0,0,127}));
  connect(addHeaCoo.u1, yHea.y) annotation (Line(points={{58,-54},{20,-54},{20,
          -60},{1,-60}},
                    color={0,0,127}));
  connect(offCoo.u1, lin050.y) annotation (Line(points={{38,-186},{20,-186},{20,
          -192},{1,-192}}, color={0,0,127}));
  connect(offCoo.u2, lin075.y) annotation (Line(points={{38,-198},{34,-198},{34,
          -256},{60,-256},{60,-284},{55,-284}}, color={0,0,127}));
  connect(offCoo.y, addHeaCoo.u2) annotation (Line(points={{61,-192},{90,-192},{
          90,-92},{48,-92},{48,-66},{58,-66}}, color={0,0,127}));
  connect(addHeaCoo.y, y) annotation (Line(points={{81,-60},{90,-60},{90,-60},{110,
          -60}}, color={0,0,127}));
  connect(lin050.x2, con1.y) annotation (Line(points={{-22,-196},{-44,-196},{-44,
          -170},{-59,-170}}, color={0,0,127}));
  connect(con025.y, lin050.x1) annotation (Line(points={{-59,-202},{-52,-202},{-52,
          -184},{-22,-184}}, color={0,0,127}));
  connect(lin050.f2, yOffSet.y) annotation (Line(points={{-22,-200},{-32,-200},{
          -32,-160},{70,-160},{70,-118},{57,-118}}, color={0,0,127}));
  connect(con3.y, lin050.f1) annotation (Line(points={{-59,-232},{-28,-232},{-28,
          -188},{-22,-188}}, color={0,0,127}));
  connect(dY075.y, lin075.f2) annotation (Line(points={{-15,-284},{-8,-284},{-8,
          -292},{32,-292}}, color={0,0,127}));
  connect(con6.y, lin075.f1) annotation (Line(points={{21,-340},{24,-340},{24,-280},
          {32,-280}}, color={0,0,127}));
  connect(TSetHeaHig.x1, con0.y) annotation (Line(points={{0,198},{-56,198},{-56,
          190},{-59,190}}, color={0,0,127}));
annotation (
  defaultComponentName = "setPoiVAV",
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
    graphics={
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
        extent={{-100,-360},{100,220}}), graphics={
        Rectangle(
          extent={{-82,-152},{84,-248}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{46,-252},{82,-234}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="0.25 < yCoo < 0.5"),
        Text(
          extent={{46,-316},{82,-298}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="0.75 < yCoo < 1"),
        Rectangle(
          extent={{-84,-100},{80,-138}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{28,-142},{64,-124}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="0.5 < yCoo < 0.75"),
        Rectangle(
          extent={{-80,-46},{16,-80}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-16,-78},{14,-72}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="heating"),
        Text(
          extent={{-82,-98},{88,-90}},
          lineColor={0,0,0},
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
For a cooling control signal of <code>uCoo &gt; 0.25</code>,
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
based on the same temperature sensors and control loops.
</p>
</html>", revisions="<html>
<ul>
<li>
March 25, 2018, by Michael Wetter:<br/>
Revised implementation of fan speed control signal calculation
to remove the hysteresis blocks.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1153\">issue 1153</a>.
</li>
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
