within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences;
block Enable "Sequence for enabling and disabling tower fan"

  parameter Integer nChi=2 "Total number of chillers";
  parameter Integer nTowCel=4 "Total number of cooling tower cells";
  parameter Real fanSpeChe = 0.01 "Lower threshold value to check fan speed";
  parameter Real fanSpeMin = 0.1 "Minimum tower fan speed";
  parameter Real cheMinFanSpe(final quantity="Time", final unit="s")=300
    "Threshold time for checking duration when tower fan equals to the minimum tower fan speed"
    annotation (Dialog(tab="Advanced"));
  parameter Real cheMaxTowSpe(final quantity="Time", final unit="s")=300
    "Threshold time for checking duration when any enabled chiller maximum cooling speed equals to the minimum tower fan speed"
    annotation (Dialog(tab="Advanced"));
  parameter Real cheTowOff(final quantity="Time", final unit="s")=60
    "Threshold time for checking duration when there is no enabled tower fan"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxTowSpeSet[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Maximum cooling tower speed setpoint from each chiller head pressure control loop"
    annotation (Placement(transformation(extent={{-220,160},{-180,200}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uFanSpe(
    final min=0,
    final max=1,
    final unit="1") "Measured tower fan speed"
    annotation (Placement(transformation(extent={{-220,100},{-180,140}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTowSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Setpoint of tower temperature, could be condenser water return or supply temperature"
    annotation (Placement(transformation(extent={{-220,20},{-180,60}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTow(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured tower temperature, could be condenser water return or supply temperature"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTow[nTowCel]
    "Cooling tower operating status: true=running tower cell"
    annotation (Placement(transformation(extent={{-220,-140},{-180,-100}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uConWatPumNum
    "Number of enabled condenser water pumps"
    annotation (Placement(transformation(extent={{-220,-180},{-180,-140}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTow
    "Tower fan status: true=enable any number of fans; false=disable all fans"
    annotation (Placement(transformation(extent={{180,-180},{220,-140}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub0[nChi]
    "DIfference between enabled chiller head pressure control maximum tower speed and the minimum tower speed"
    annotation (Placement(transformation(extent={{-70,150},{-50,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys[nChi](
    final uLow=fill(fanSpeChe, nChi),
    final uHigh=fill(2*fanSpeChe, nChi))
    "Check if chiller head pressure control maximum tower speed is greater than the minimum tower speed "
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(final nin=nChi)
    "Check if any enabled chiller head pressure control maximum tower speed equals to the minimum tower speed"
    annotation (Placement(transformation(extent={{40,150},{60,170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[nChi] "Logical not"
    annotation (Placement(transformation(extent={{0,150},{20,170}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=cheMaxTowSpe)
    "Count the time when the chiller head pressure control maximum tower speed equals tower minimum speed"
    annotation (Placement(transformation(extent={{80,150},{100,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1[nChi](
    final uLow=fill(fanSpeChe, nChi),
    final uHigh=fill(2*fanSpeChe, nChi))
    "Check if chiller has been enabled, an enabled chiller will have the head pressure control maximum cooling tower speed that is greater than zero"
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "Difference between tower fan speed and the minimum fan speed"
    annotation (Placement(transformation(extent={{-90,110},{-70,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final uLow=fanSpeChe,
    final uHigh=2*fanSpeChe)
    "Check if tower fan speed is greater than minimum speed"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Check if tower fan speed equals to the minimum speed"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Difference between the return water temperature and the adjusted setpoint"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3(
    final uLow=0.1, final uHigh=0.15)
    "Check if tower temperature is a delta below setpoint"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Tower fans have been at minimum speed for a threshold time and tower return water temperature drops below a adjusted setpoint"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Logical.Or disTow "Disable tower fans"
    annotation (Placement(transformation(extent={{120,110},{140,130}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(final nin=nTowCel)
    "True when any tower fan is enaled"
    annotation (Placement(transformation(extent={{-140,-130},{-120,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "No enabled tower fan"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1(
    final t=cheTowOff)
    "Count the time when all tower cells are off"
    annotation (Placement(transformation(extent={{-20,-130},{0,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub3
    "Difference between the return water temperature and the adjusted setpoint"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4(
    final uLow=0.1,
    final uHigh=0.15)
    "Check if tower temperature is above the adjusted setpoint"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(final nin=nChi)
    "Check if all enabled chillers head pressure control maximum tower speed are greater than tower minimum speed"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.And3 enaTow
    "Check if tower fans should be enabled"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check integer number equality"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=0) "Zero constant"
    annotation (Placement(transformation(extent={{-140,-190},{-120,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTowSpe[nChi](
    final k=fill(fanSpeMin, nChi))
    "Minimum tower speed"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one[nChi](
    final k=fill(1, nChi)) "Constant one"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=5/9) "Tower temperature setpoint plus 1 degF"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=-5/9)
    "Temperature of a delta value below the tower temperature setpoint"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim2(
    final t=cheMinFanSpe)
    "Count the time when the tower fan is at minimum speed"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi2 "Logical switch"
    annotation (Placement(transformation(extent={{140,-170},{160,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant disFan1(
    final k=false)
    "Disable tower fan when no condenser water pump is ON"
    annotation (Placement(transformation(extent={{80,-190},{100,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1 "Logical switch"
    annotation (Placement(transformation(extent={{140,-100},{160,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Or chaTow "Change tower status"
    annotation (Placement(transformation(extent={{120,30},{140,50}})));

equation
  connect(sub0.y, hys.u)
    annotation (Line(points={{-48,160},{-42,160}}, color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{-18,160},{-2,160}}, color={255,0,255}));
  connect(mulOr.y, tim.u)
    annotation (Line(points={{62,160},{78,160}},   color={255,0,255}));
  connect(uMaxTowSpeSet, hys1.u)
    annotation (Line(points={{-200,180},{-142,180}}, color={0,0,127}));
  connect(hys1.y, swi.u2)
    annotation (Line(points={{-118,180},{-110,180},{-110,160},{-102,160}},
      color={255,0,255}));
  connect(uMaxTowSpeSet, swi.u1)
    annotation (Line(points={{-200,180},{-160,180},{-160,168},{-102,168}},
      color={0,0,127}));
  connect(one.y, swi.u3)
    annotation (Line(points={{-118,140},{-110,140},{-110,152},{-102,152}},
      color={0,0,127}));
  connect(swi.y, sub0.u1)
    annotation (Line(points={{-78,160},{-76,160},{-76,166},{-72,166}},
                                                   color={0,0,127}));
  connect(uFanSpe, sub1.u1)
    annotation (Line(points={{-200,120},{-146,120},{-146,126},{-92,126}},
                                                    color={0,0,127}));
  connect(sub1.y, hys2.u)
    annotation (Line(points={{-68,120},{-42,120}}, color={0,0,127}));
  connect(hys2.y, not2.u)
    annotation (Line(points={{-18,120},{-2,120}}, color={255,0,255}));
  connect(sub2.y, hys3.u)
    annotation (Line(points={{-68,40},{-42,40}}, color={0,0,127}));
  connect(hys3.y, and2.u2)
    annotation (Line(points={{-18,40},{70,40},{70,72},{78,72}}, color={255,0,255}));
  connect(and2.y, disTow.u2)
    annotation (Line(points={{102,80},{110,80},{110,112},{118,112}},
      color={255,0,255}));
  connect(mulOr1.y, not3.u)
    annotation (Line(points={{-118,-120},{-62,-120}},  color={255,0,255}));
  connect(not3.y, tim1.u)
    annotation (Line(points={{-38,-120},{-22,-120}}, color={255,0,255}));
  connect(TTow, sub3.u1)
    annotation (Line(points={{-200,0},{-80,0},{-80,-34},{-62,-34}},
      color={0,0,127}));
  connect(sub3.y, hys4.u)
    annotation (Line(points={{-38,-40},{18,-40}},  color={0,0,127}));
  connect(mulAnd.y, enaTow.u1)
    annotation (Line(points={{42,0},{50,0},{50,-32},{58,-32}}, color={255,0,255}));
  connect(hys4.y, enaTow.u2)
    annotation (Line(points={{42,-40},{58,-40}}, color={255,0,255}));
  connect(not1.y, mulOr.u)
    annotation (Line(points={{22,160},{38,160}}, color={255,0,255}));
  connect(hys.y, mulAnd.u)
    annotation (Line(points={{-18,160},{-10,160},{-10,0},{18,0}}, color={255,0,255}));
  connect(uTow, mulOr1.u)
    annotation (Line(points={{-200,-120},{-142,-120}}, color={255,0,255}));
  connect(uConWatPumNum, intEqu.u1)
    annotation (Line(points={{-200,-160},{-82,-160}},  color={255,127,0}));
  connect(conInt.y, intEqu.u2)
    annotation (Line(points={{-118,-180},{-100,-180},{-100,-168},{-82,-168}},
      color={255,127,0}));
  connect(TTowSet, addPar1.u)
    annotation (Line(points={{-200,40},{-172,40},{-172,40},{-142,40}}, color={0,0,127}));
  connect(addPar1.y, sub2.u1)
    annotation (Line(points={{-118,40},{-106,40},{-106,46},{-92,46}}, color={0,0,127}));
  connect(TTowSet, addPar.u)
    annotation (Line(points={{-200,40},{-160,40},{-160,-80},{-142,-80}}, color={0,0,127}));
  connect(not2.y, tim2.u)
    annotation (Line(points={{22,120},{38,120}}, color={255,0,255}));
  connect(disFan1.y, logSwi2.u1)
    annotation (Line(points={{102,-180},{120,-180},{120,-152},{138,-152}},
      color={255,0,255}));
  connect(intEqu.y, logSwi2.u2)
    annotation (Line(points={{-58,-160},{138,-160}},
      color={255,0,255}));
  connect(logSwi2.y, yTow)
    annotation (Line(points={{162,-160},{200,-160}}, color={255,0,255}));
  connect(mulOr1.y, logSwi1.u3)
    annotation (Line(points={{-118,-120},{-100,-120},{-100,-98},{138,-98}},
      color={255,0,255}));
  connect(enaTow.y, chaTow.u2)
    annotation (Line(points={{82,-40},{100,-40},{100,32},{118,32}}, color={255,0,255}));
  connect(disTow.y, chaTow.u1)
    annotation (Line(points={{142,120},{150,120},{150,60},{100,60},{100,40},
      {118,40}}, color={255,0,255}));
  connect(chaTow.y, logSwi1.u2)
    annotation (Line(points={{142,40},{150,40},{150,-60},{120,-60},{120,-90},
      {138,-90}}, color={255,0,255}));
  connect(logSwi1.y, logSwi2.u3)
    annotation (Line(points={{162,-90},{170,-90},{170,-140},{130,-140},{130,-168},
      {138,-168}}, color={255,0,255}));
  connect(enaTow.y, logSwi1.u1)
    annotation (Line(points={{82,-40},{100,-40},{100,-82},{138,-82}},
      color={255,0,255}));
  connect(tim2.passed, and2.u1) annotation (Line(points={{62,112},{70,112},{70,80},
          {78,80}}, color={255,0,255}));
  connect(tim.passed, disTow.u1) annotation (Line(points={{102,152},{110,152},{110,
          120},{118,120}}, color={255,0,255}));
  connect(tim1.passed, enaTow.u3) annotation (Line(points={{2,-128},{50,-128},{50,
          -48},{58,-48}}, color={255,0,255}));
  connect(addPar.y, sub3.u2) annotation (Line(points={{-118,-80},{-80,-80},{-80,
          -46},{-62,-46}}, color={0,0,127}));
  connect(TTow, sub2.u2) annotation (Line(points={{-200,0},{-100,0},{-100,34},{-92,
          34}}, color={0,0,127}));
  connect(minTowSpe.y, sub0.u2) annotation (Line(points={{-118,80},{-60,80},{-60,
          142},{-76,142},{-76,154},{-72,154}}, color={0,0,127}));
  connect(minTowSpe[1].y, sub1.u2) annotation (Line(points={{-118,80},{-102,80},
          {-102,114},{-92,114}}, color={0,0,127}));

annotation (
  defaultComponentName="enaTow",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-180,-200},{180,200}}), graphics={
          Rectangle(
          extent={{-178,18},{178,-138}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Rectangle(
          extent={{-178,198},{178,22}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Rectangle(
          extent={{-178,-142},{178,-198}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{74,194},{152,184}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Disable tower fans"),
          Text(
          extent={{72,14},{150,4}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Enable tower fans"),
          Text(
          extent={{-104,-178},{68,-198}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Disable tower fans when no running condenser water pump")}),
  Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name")}),
Documentation(info="<html>
<p>
Block that outputs signal <code>yTowSta</code> for enabling and disabling cooling tower 
fan. This is implemented according to ASHRAE RP-1711 Advanced Sequences of Operation for 
HVAC Systems Phase II – Central Plants and Hydronic Systems (Draft on March 23, 
2020), section 5.2.12.2, item 2.j-l.
</p>
<p>
1. Disable the tower fans if either:
</p>
<ul>
<li>
Any enabled chiller’s head pressure control maximum tower fan speed <code>uMaxTowSpeSet</code> 
has equaled tower minimum speed <code>fanSpeMin</code> for 5 minutes, or
</li>
<li>
Tower fans <code>uTowSpe</code> have been at minimum speed <code>fanSpeMin</code> for 
5 minutes and tower temperature <code>TTow</code> drops below setpoint 
<code>TTowSet</code> minus 1 &deg;F. 
</li>
</ul>
<p>
2. Enable the tower fans if:
</p>
<ul>
<li>
They have been off (<code>uTowSta=false</code>) for at least 1 minute, and
</li>
<li>
The tower temperature <code>TTow</code> rises above setpoint <code>TTowSet</code>
by 1 &deg;F, and
</li>
<li>
All enabled chillers’ head pressure control maximum tower fan speed <code>uMaxTowSpeSet</code> 
are greater than tower minimum speed <code>fanSpeMin</code>.
</li>
</ul>
<p>
3. When all condenser water pumps are commanded OFF, disable the PID loop and
stop all tower fans.
</p>
<p>
Note that the tower temperature <code>TTow</code> could be condenser water return 
temperature or condenser water supply temperature, depending on whether the fan 
speed control is to maintain return temperature or supply temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
August 9, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Enable;
