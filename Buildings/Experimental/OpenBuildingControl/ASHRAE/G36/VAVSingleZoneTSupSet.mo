within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36;
block VAVSingleZoneTSupSet
  "Supply air set point for single zone VAV system"

  parameter Modelica.SIunits.Temperature TMax
    "Maximum supply air temperature for heating"
    annotation (Dialog(group="Temperatures"));

  parameter Modelica.SIunits.Temperature TDea(
    min=21+273.15,
    max=24+273.15) "Dead band supply air temperature"
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


  CDL.Interfaces.RealInput uHea(min=0, max=1)
    "Heating control signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  CDL.Interfaces.RealInput uCoo(min=0, max=1)
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  CDL.Interfaces.RealInput TZon(unit="K", displayUnit="degC")
    "Zone temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  CDL.Interfaces.RealInput TOut(unit="K", displayUnit="degC")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  CDL.Interfaces.RealOutput THea(unit="K", displayUnit="degC")
    "Heating supply air temperature setpoint"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  CDL.Interfaces.RealOutput TCoo(unit="K", displayUnit="degC")
    "Cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

  CDL.Interfaces.RealOutput y(min=0, max=1, unit="1") "Fan speed" annotation (Placement(
        transformation(extent={{100,-70},{120,-50}})));

protected
  Controls.SetPoints.Table TSetHeaHig(table=[0.0,TDea; 0.5,TMax])
    "Table to compute the setpoint for heating for uHea = 0...1"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Controls.SetPoints.Table TSetCooHig(table=[0.5,TDea; 0.75,TMin])
    "Table to compute the setpoint for cooling for uCoo = 0...1"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Controls.SetPoints.Table offSetTSetHea(table=[0.0,0; 0.25,-(1.1 + TDea - TMin)])
    "Table to compute the setpoint offset for heating for uCoo = 0...1"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  CDL.Continuous.Add addTHe "Adder for heating setpoint calculation"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Controls.SetPoints.Table offSetTSetCoo(table=[0,0; 0.5,TMax - TDea])
    "Table to compute the setpoint offset for cooling for uHea = 0...1"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  CDL.Continuous.Add addTCoo "Adder for cooling setpoint calculation"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  CDL.Continuous.Add dT(k2=-1) "Difference zone minus outdoor temperature"
    annotation (Placement(transformation(extent={{-80,-200},{-60,-180}})));
  CDL.Continuous.AddParameter yMed(p=yCooMax - (yMin - yCooMax)/(0.56 - 5.6)*5.6,
      k=(yMin - yCooMax)/(0.56 - 5.6))
                                   "Fan speed at medium cooling load"
    annotation (Placement(transformation(extent={{-40,-200},{-20,-180}})));
  Controls.SetPoints.Table yHea(table=[0.5,yMin; 1,yHeaMax])
    "Fan speed for heating"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  CDL.Logical.LessEqualThreshold yMinChe1(threshold=0.25)
    "Check for cooling signal for fan speed"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  CDL.Logical.Switch switch1
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  CDL.Logical.LessEqualThreshold yMinChe2(threshold=0.5)
    "Check for cooling signal for fan speed"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  CDL.Logical.Switch switch2
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  CDL.Logical.LessEqualThreshold yMinChe3(threshold=0.75)
    "Check for cooling signal for fan speed"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  CDL.Logical.Switch switch3
    annotation (Placement(transformation(extent={{-20,-160},{0,-140}})));
  CDL.Continuous.Add add(k1=-1)
    annotation (Placement(transformation(extent={{0,-240},{20,-220}})));
  CDL.Continuous.Add add1
    annotation (Placement(transformation(extent={{40,-270},{60,-250}})));
  CDL.Continuous.Gain gain(k=4)
    annotation (Placement(transformation(extent={{-80,-256},{-60,-236}})));
  CDL.Continuous.AddParameter yMed1(p=2*yMin, k=-yMin)
                                   "Fan speed at medium cooling load"
    annotation (Placement(transformation(extent={{-20,-290},{0,-270}})));
  CDL.Continuous.Gain gain1(k=4)
    annotation (Placement(transformation(extent={{-80,-356},{-60,-336}})));
  CDL.Continuous.Product product
    annotation (Placement(transformation(extent={{-40,-250},{-20,-230}})));
  CDL.Continuous.AddParameter yMed2(p=-3*yCooMax, k=4*yCooMax)
                                   "Fan speed at medium cooling load"
    annotation (Placement(transformation(extent={{-20,-390},{0,-370}})));
  CDL.Continuous.Product product1
    annotation (Placement(transformation(extent={{-40,-350},{-20,-330}})));
  CDL.Continuous.Add add2(k1=4, k2=-1)
    annotation (Placement(transformation(extent={{0,-340},{20,-320}})));
  CDL.Continuous.Add add3
    annotation (Placement(transformation(extent={{40,-370},{60,-350}})));
  CDL.Continuous.Limiter yMedLim(uMax=yCooMax, uMin=yMin) "Limiter for yMed"
    annotation (Placement(transformation(extent={{-10,-200},{10,-180}})));
equation
  connect(offSetTSetHea.u, uCoo) annotation (Line(points={{-22,50},{-22,50},{-32,
          50},{-32,40},{-120,40}},   color={0,0,127}));
  connect(uHea, TSetHeaHig.u)
    annotation (Line(points={{-120,80},{-74,80},{-60,80},{-22,80}},
                                                           color={0,0,127}));
  connect(TSetHeaHig.y, addTHe.u1) annotation (Line(points={{1,80},{20,80},{20,66},
          {38,66}}, color={0,0,127}));
  connect(offSetTSetHea.y, addTHe.u2) annotation (Line(points={{1,50},{1,50},{
          20,50},{20,54},{38,54},{38,54}},
                                color={0,0,127}));
  connect(addTHe.y, THea)
    annotation (Line(points={{61,60},{110,60}}, color={0,0,127}));
  connect(TSetCooHig.y, addTCoo.u1) annotation (Line(points={{1,20},{20,20},{20,
          6},{38,6}},     color={0,0,127}));
  connect(offSetTSetCoo.y, addTCoo.u2) annotation (Line(points={{1,-10},{20,-10},
          {20,-6},{38,-6}},   color={0,0,127}));
  connect(TSetCooHig.u, uCoo) annotation (Line(points={{-22,20},{-22,20},{-32,20},
          {-32,40},{-120,40}},        color={0,0,127}));
  connect(offSetTSetCoo.u, uHea) annotation (Line(points={{-22,-10},{-22,-10},{-36,
          -10},{-36,80},{-120,80}}, color={0,0,127}));
  connect(addTCoo.y, TCoo)
    annotation (Line(points={{61,0},{110,0}},               color={0,0,127}));
  connect(dT.u1, TZon) annotation (Line(points={{-82,-184},{-86,-184},{-86,-40},
          {-120,-40}},
                 color={0,0,127}));
  connect(dT.u2, TOut) annotation (Line(points={{-82,-196},{-90,-196},{-90,-80},
          {-120,-80}},
                 color={0,0,127}));
  connect(dT.y, yMed.u)
    annotation (Line(points={{-59,-190},{-59,-190},{-42,-190}},
                                                             color={0,0,127}));
  connect(yHea.u, uHea) annotation (Line(points={{-22,-70},{-36,-70},{-36,80},{-120,
          80}}, color={0,0,127}));
  connect(yMinChe1.u, uCoo) annotation (Line(points={{-82,-90},{-82,-90},{-94,-90},
          {-94,40},{-120,40}},       color={0,0,127}));
  connect(switch1.u2, yMinChe1.y) annotation (Line(points={{58,-90},{-40,-90},{-59,
          -90}},       color={255,0,255}));
  connect(switch2.y, switch1.u3) annotation (Line(points={{41,-120},{50,-120},{50,
          -98},{58,-98}},   color={0,0,127}));
  connect(yMinChe2.u, uCoo) annotation (Line(points={{-82,-120},{-94,-120},{-94,
          40},{-120,40}}, color={0,0,127}));
  connect(yMinChe3.u, uCoo) annotation (Line(points={{-82,-150},{-94,-150},{-94,
          40},{-120,40}}, color={0,0,127}));
  connect(switch3.y, switch2.u3) annotation (Line(points={{1,-150},{10,-150},{10,
          -128},{18,-128}}, color={0,0,127}));
  connect(yMinChe2.y, switch2.u2) annotation (Line(points={{-59,-120},{-59,-120},
          {18,-120}}, color={255,0,255}));
  connect(yMinChe3.y, switch3.u2) annotation (Line(points={{-59,-150},{-40,-150},
          {-22,-150}}, color={255,0,255}));
  connect(yMedLim.y, add.u1) annotation (Line(points={{11,-190},{20,-190},{20,-208},
          {-50,-208},{-50,-224},{-2,-224}}, color={0,0,127}));
  connect(gain.u, uCoo) annotation (Line(points={{-82,-246},{-94,-246},{-94,40},
          {-120,40}}, color={0,0,127}));
  connect(gain.y, yMed1.u) annotation (Line(points={{-59,-246},{-58,-246},{-54,-246},
          {-54,-280},{-22,-280}}, color={0,0,127}));
  connect(add.y, add1.u1) annotation (Line(points={{21,-230},{32,-230},{32,-254},
          {38,-254}}, color={0,0,127}));
  connect(yMed1.y, add1.u2) annotation (Line(points={{1,-280},{10,-280},{10,-266},
          {38,-266}}, color={0,0,127}));
  connect(add1.y, switch2.u1) annotation (Line(points={{61,-260},{72,-260},{72,-134},
          {8,-134},{8,-112},{18,-112}}, color={0,0,127}));
  connect(gain1.u, uCoo) annotation (Line(points={{-82,-346},{-94,-346},{-94,40},
          {-120,40}}, color={0,0,127}));
  connect(product.u1, yMedLim.y) annotation (Line(points={{-42,-234},{-50,-234},
          {-50,-208},{20,-208},{20,-190},{11,-190}},
                                                 color={0,0,127}));
  connect(product.y, add.u2) annotation (Line(points={{-19,-240},{-12,-240},{-12,
          -236},{-2,-236}}, color={0,0,127}));
  connect(product.u2, gain.y)
    annotation (Line(points={{-42,-246},{-59,-246}}, color={0,0,127}));
  connect(yMedLim.y, add2.u1) annotation (Line(points={{11,-190},{20,-190},{20,-208},
          {-50,-208},{-50,-324},{-2,-324}}, color={0,0,127}));
  connect(product1.y, add2.u2) annotation (Line(points={{-19,-340},{-14,-340},{-14,
          -336},{-2,-336}}, color={0,0,127}));
  connect(add2.y, add3.u1) annotation (Line(points={{21,-330},{24,-330},{24,-354},
          {38,-354}}, color={0,0,127}));
  connect(yMed2.y, add3.u2) annotation (Line(points={{1,-380},{22,-380},{22,-366},
          {38,-366}}, color={0,0,127}));
  connect(product1.u2, gain1.y) annotation (Line(points={{-42,-346},{-59,-346}},
                      color={0,0,127}));
  connect(product1.u1, yMedLim.y) annotation (Line(points={{-42,-334},{-50,-334},
          {-50,-218},{-50,-208},{20,-208},{20,-190},{11,-190}},        color={0,
          0,127}));
  connect(yMed2.u, uCoo) annotation (Line(points={{-22,-380},{-54,-380},{-94,-380},
          {-94,40},{-120,40}}, color={0,0,127}));
  connect(add3.y, switch3.u3) annotation (Line(points={{61,-360},{76,-360},{76,-168},
          {-34,-168},{-34,-158},{-22,-158}}, color={0,0,127}));
  connect(yHea.y, switch1.u1) annotation (Line(points={{1,-70},{18,-70},{40,-70},
          {40,-82},{58,-82}}, color={0,0,127}));
  connect(switch1.y, y) annotation (Line(points={{81,-90},{90,-90},{90,-60},{110,
          -60}}, color={0,0,127}));
  connect(yMedLim.y, switch3.u1) annotation (Line(points={{11,-190},{20,-190},{
          20,-170},{-40,-170},{-40,-142},{-22,-142}},
                                                   color={0,0,127}));
  connect(yMedLim.u, yMed.y)
    annotation (Line(points={{-12,-190},{-19,-190}}, color={0,0,127}));
  annotation (
  defaultComponentName = "setPoiVAV",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                                        graphics={
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
      extent={{-86,2},{-45,-18}},
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
          textString="THea"),
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
        Line(points={{18,20},{38,20},{50,54},{28,54},{18,20}}, color={0,0,0})}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-420},{100,100}}), graphics={
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
Block that outputs the set points for the supply air temperature for heating and cooling
and the fan speed for a single zone VAV system.
</p>
<p>
For the temperature set points, the
parameters are the maximum supply air temperature <code>TMax</code>,
the dead band temperature <code>TDea</code> and the minimum supply air
temperature for cooling <code>TCooMin</code>.
The setpoints are computed as shown in the figure below.
Note that the setpoint for the supply air temperature for heating is
lower than <code>TCooMin</code>, as shown in the figure.
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
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/VAVSingleZoneTSupSet.png\"/>
</p>
<p>
Note that the inputs <code>uHea</code> and <code>uCoo</code> must be computed
based on the same temperature sensors and control loops.
</p>
</html>", revisions="<html>
<ul>
<li>
January 10, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end VAVSingleZoneTSupSet;
