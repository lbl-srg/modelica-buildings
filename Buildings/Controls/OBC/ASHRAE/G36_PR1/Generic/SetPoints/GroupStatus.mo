within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints;
block GroupStatus "Block that outputs the zone group status"

  parameter Integer numZon(final min=1)=5 "number of zones in the zone group";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooTim[numZon](
    final unit="s",
    final quantity="Time")
    "Cool down time"
    annotation (Placement(transformation(extent={{-140,200},{-100,240}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uWarTim[numZon](
    final unit="s",
    final quantity="Time") "Warm-up time"
    annotation (Placement(transformation(extent={{-140,160},{-100,200}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOccHeaHig[numZon]
    "True when the zone temperature is lower than the occupied heating setpoint"
    annotation (Placement(transformation(extent={{-140,120},{-100,160}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHigOccCoo[numZon]
    "True when the zone temperature is higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUnoHeaHig[numZon]
    "True when the zone temperature is lower than the unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSetOff[numZon](
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEndSetBac[numZon]
    "True when the zone could end the setback mode"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHigUnoCoo[numZon]
    "True when the zone temperature is higher than its unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSetOff[numZon](
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-140,-130},{-100,-90}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEndSetUp[numZon]
    "True when the zone could end the setup mode"
    annotation (Placement(transformation(extent={{-140,-160},{-100,-120}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[numZon](
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Zone temperature"
    annotation (Placement(transformation(extent={{-140,-200},{-100,-160}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooTim(
    final unit="s",
    final quantity="Time") "Cool down time"
    annotation (Placement(transformation(extent={{100,200},{140,240}}),
      iconTransformation(extent={{100,90},{140,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yWarTim(
    final unit="s",
    final quantity="Time") "Warm-up time"
    annotation (Placement(transformation(extent={{100,160},{140,200}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOccHeaHig
    "True when the zone temperature is lower than the occupied heating setpoint"
    annotation (Placement(transformation(extent={{100,120},{140,160}}),
      iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHigOccCoo
    "True when the zone temperature is higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{100,80},{140,120}}),
      iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yColZon
    "Total number of cold zones"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
      iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySetBac
    "Run setback mode"
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
      iconTransformation(extent={{100,-10},{140,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndSetBac
    "True when the group should end setback mode"
    annotation (Placement(transformation(extent={{100,-40},{140,0}}),
      iconTransformation(extent={{100,-30},{140,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotZon
    "Total number of hot zones"
    annotation (Placement(transformation(extent={{100,-70},{140,-30}}),
      iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySetUp
    "Run setup mode"
    annotation (Placement(transformation(extent={{100,-110},{140,-70}}),
      iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEndSetUp
    "True when the group should end setup mode"
    annotation (Placement(transformation(extent={{100,-160},{140,-120}}),
      iconTransformation(extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonMax(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Maximum zone temperature in the zone group"
    annotation (Placement(transformation(extent={{100,-200},{140,-160}}),
      iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonMin(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Minimum zone temperature in the zone group"
    annotation (Placement(transformation(extent={{100,-240},{140,-200}}),
      iconTransformation(extent={{100,-130},{140,-90}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.MultiMax cooDowTim(
    final nin=numZon)
    "Longest cooldown time"
    annotation (Placement(transformation(extent={{40,210},{60,230}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax warUpTim(
    final nin=numZon)
    "Longest warm up time"
    annotation (Placement(transformation(extent={{40,170},{60,190}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nu=numZon)
    "Check if there is any zone that the zone temperature is lower than its occupied heating setpoint"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nu=numZon)
    "Check if there is any zone that the zone temperature is higher than its occupied cooling setpoint"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax mulMax(
    final nin=numZon)
    annotation (Placement(transformation(extent={{0,-190},{20,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin(
    final nin=numZon)
    annotation (Placement(transformation(extent={{0,-230},{20,-210}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[numZon]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum totColZon(
    final nin=numZon) "Total number of cold zone"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd endSetBac(
   final nu=numZon)
    "Check if all zones have ended the setback mode"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[numZon]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum totHotZon(
    final nin=numZon) "Total number of hot zones"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd endSetUp(
    final nu=numZon)
    "Check if all zones have ended the setup mode"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sumUnoHea(
    final nin=numZon)
    "Sum of all zones unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback difUnoHea
    "Difference between unoccupied heating setpoint and zone temperature"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div1 "Average difference"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant totZon(
    final k=numZon) "Total number of zones"
    annotation (Placement(transformation(extent={{-78,150},{-58,170}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea "Convert integer to real"
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sumUnoCoo(
    final nin=numZon)
    "Sum of all zones unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sumTem(
    final nin=numZon) "Sum of all zones temperature"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback difUnoCoo
    "Difference between unoccupied cooling setpoint and zone temperature"
    annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div2 "Average difference"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=-0.1,
    final uHigh=0.1)
    "Hysteresis that outputs if the group should run in setback mode"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=-0.1,
    final uHigh=0.1)
    "Hysteresis that outputs if the group should run in setup mode"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));

equation
  connect(mulMax.y, TZonMax)
    annotation (Line(points={{22,-180},{120,-180}}, color={0,0,127}));
  connect(mulMin.y, TZonMin)
    annotation (Line(points={{22,-220},{120,-220}},color={0,0,127}));
  connect(cooDowTim.y, yCooTim)
    annotation (Line(points={{62,220},{120,220}}, color={0,0,127}));
  connect(warUpTim.y, yWarTim)
    annotation (Line(points={{62,180},{120,180}}, color={0,0,127}));
  connect(mulOr.y, yOccHeaHig)
    annotation (Line(points={{62,140},{120,140}}, color={255,0,255}));
  connect(mulOr1.y, yHigOccCoo)
    annotation (Line(points={{62,100},{120,100}}, color={255,0,255}));
  connect(uCooTim, cooDowTim.u)
    annotation (Line(points={{-120,220},{38,220}}, color={0,0,127}));
  connect(uOccHeaHig, mulOr.u)
    annotation (Line(points={{-120,140},{38,140}},color={255,0,255}));
  connect(TZon, mulMax.u)
    annotation (Line(points={{-120,-180},{-2,-180}},color={0,0,127}));
  connect(TZon, mulMin.u)
    annotation (Line(points={{-120,-180},{-80,-180},{-80,-220},{-2,-220}},
      color={0,0,127}));
  connect(uHigOccCoo, mulOr1.u)
    annotation (Line(points={{-120,100},{38,100}},color={255,0,255}));
  connect(uWarTim, warUpTim.u)
    annotation (Line(points={{-120,180},{38,180}}, color={0,0,127}));
  connect(uUnoHeaHig, booToInt.u)
    annotation (Line(points={{-120,60},{-82,60}}, color={255,0,255}));
  connect(totColZon.y, yColZon)
    annotation (Line(points={{62,60},{120,60}}, color={255,127,0}));
  connect(endSetBac.y, yEndSetBac)
    annotation (Line(points={{62,-20},{120,-20}}, color={255,0,255}));
  connect(uHigUnoCoo, booToInt1.u)
    annotation (Line(points={{-120,-50},{-82,-50}}, color={255,0,255}));
  connect(totHotZon.y, yHotZon)
    annotation (Line(points={{62,-50},{120,-50}}, color={255,127,0}));
  connect(endSetUp.y, yEndSetUp)
    annotation (Line(points={{22,-140},{120,-140}}, color={255,0,255}));
  connect(uEndSetUp, endSetUp.u)
    annotation (Line(points={{-120,-140},{-2,-140}},  color={255,0,255}));
  connect(uEndSetBac, endSetBac.u)
    annotation (Line(points={{-120,-20},{38,-20}},  color={255,0,255}));
  connect(booToInt.y, totColZon.u)
    annotation (Line(points={{-58,60},{38,60}},  color={255,0,255}));
  connect(booToInt1.y, totHotZon.u)
    annotation (Line(points={{-58,-50},{38,-50}},color={255,0,255}));
  connect(totZon.y, intToRea.u)
    annotation (Line(points={{-56,160},{-42,160}}, color={255,127,0}));
  connect(sumTem.y, difUnoHea.u2)
    annotation (Line(points={{-58,-160},{-40,-160},{-40,8}}, color={0,0,127}));
  connect(sumTem.y, difUnoCoo.u1) annotation (Line(points={{-58,-160},{-40,-160},
          {-40,-80},{-32,-80}}, color={0,0,127}));
  connect(sumUnoCoo.y, difUnoCoo.u2) annotation (Line(points={{-58,-110},{-20,-110},
          {-20,-92}}, color={0,0,127}));
  connect(sumUnoHea.y, difUnoHea.u1)
    annotation (Line(points={{-58,20},{-52,20}}, color={0,0,127}));
  connect(intToRea.y, div1.u2) annotation (Line(points={{-18,160},{0,160},{0,14},
          {18,14}}, color={0,0,127}));
  connect(intToRea.y, div2.u2) annotation (Line(points={{-18,160},{0,160},{0,-96},
          {18,-96}}, color={0,0,127}));
  connect(difUnoHea.y, div1.u1) annotation (Line(points={{-28,20},{-10,20},{-10,
          26},{18,26}}, color={0,0,127}));
  connect(difUnoCoo.y, div2.u1) annotation (Line(points={{-8,-80},{8,-80},{8,-84},
          {18,-84}}, color={0,0,127}));
  connect(div1.y, hys.u)
    annotation (Line(points={{42,20},{58,20}}, color={0,0,127}));
  connect(hys.y, ySetBac)
    annotation (Line(points={{82,20},{120,20}}, color={255,0,255}));
  connect(div2.y, hys1.u)
    annotation (Line(points={{42,-90},{58,-90}}, color={0,0,127}));
  connect(hys1.y, ySetUp) annotation (Line(points={{82,-90},{92,-90},{92,-90},{120,
          -90}}, color={255,0,255}));
  connect(TCooSetOff, sumUnoCoo.u)
    annotation (Line(points={{-120,-110},{-82,-110}}, color={0,0,127}));
  connect(TZon, sumTem.u) annotation (Line(points={{-120,-180},{-90,-180},{-90,-160},
          {-82,-160}}, color={0,0,127}));
  connect(THeaSetOff, sumUnoHea.u)
    annotation (Line(points={{-120,20},{-82,20}}, color={0,0,127}));

annotation (
  defaultComponentName = "zonGroSta",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(extent={{-100,-100},{100,100}},
                  lineColor={0,0,127},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
          Text(extent={{-120,142},{100,104}},
               lineColor={0,0,255},
               textString="%name"),
        Text(
          extent={{-96,104},{-60,90}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCooTim"),
        Text(
          extent={{62,38},{98,26}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yColZon"),
        Text(
          extent={{-96,88},{-56,76}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uWarTim"),
        Text(
          extent={{-96,70},{-46,54}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOccHeaHig"),
        Text(
          extent={{-96,50},{-46,36}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHigOccCoo"),
        Text(
          extent={{-96,-30},{-44,-46}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHigUnoCoo"),
        Text(
          extent={{-96,-10},{-46,-24}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uEndSetBac"),
        Text(
          extent={{-96,-72},{-48,-86}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uEndSetUp"),
        Text(
          extent={{-96,28},{-46,14}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uUnoHeaHig"),
        Text(
          extent={{-96,-88},{-74,-100}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{64,-88},{98,-102}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonMin"),
        Text(
          extent={{62,-76},{98,-90}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonMax"),
        Text(
          extent={{54,-60},{98,-76}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yEndSetUp"),
        Text(
          extent={{46,0},{98,-16}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yEndSetBac"),
        Text(
          extent={{46,60},{98,44}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yHigOccCoo"),
        Text(
          extent={{46,78},{98,64}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yOccHeaHig"),
        Text(
          extent={{64,102},{98,90}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCooTim"),
        Text(
          extent={{62,90},{98,80}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yWarTim"),
        Text(
          extent={{64,-20},{98,-34}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHotZon"),
        Text(
          extent={{-96,-52},{-46,-68}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSetOff"),
        Text(
          extent={{-96,8},{-48,-6}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSetOff"),
        Text(
          extent={{58,18},{100,6}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="ySetBac"),
        Text(
          extent={{62,-44},{102,-54}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="ySetUp")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-240},{100,240}})),
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
<code>TZon</code>: zone temperature.
</li>
</ul>
<p>
The sequence gives following outputs for zone group level calculation:
</p>
<ul>
<li>
<code>yCooTim</code>: longest cooldown time,
</li>
<li>
<code>yWarTim</code>: longest warm-up time,
</li>
<li>
<code>yOccHeaHig</code>: if the zone temperature is lower than the occupied heating
setpoint, so that the group could be in the warm-up mode,
</li>
<li>
<code>yHigOccCoo</code>: if the zone temperature is higher than the occupied cooling
setpoint, so that the group could be in the cooldown mode,
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
<code>TZonMin</code>: minimum zone temperature in the zone group.
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
