within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences;
block Enable "Sequence for enabling and disabling tower fan"

  parameter Integer nChi=2 "Total number of chillers";
  parameter Integer nTowCel=4 "Total number of cooling tower cells";
  parameter Real fanSpeChe(
     final unit="1")= 0.01
     "Lower threshold value to check fan speed";
  parameter Real fanSpeMin(
    final unit="1",
    final min=0,
    final max=1) = 0.1 "Minimum tower fan speed";
  parameter Real cheMinFanSpe(
    final quantity="Time",
    final unit="s")=300
    "Threshold time for checking duration when tower fan equals to the minimum tower fan speed"
    annotation (Dialog(tab="Advanced"));
  parameter Real cheMaxTowSpe(
    final quantity="Time",
    final unit="s")=300
    "Threshold time for checking duration when any enabled chiller maximum cooling speed equals to the minimum tower fan speed"
    annotation (Dialog(tab="Advanced"));
  parameter Real cheTowOff(
    final quantity="Time",
    final unit="s")=60
    "Threshold time for checking duration when there is no enabled tower fan"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxTowSpeSet[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Maximum cooling tower speed setpoint from each chiller head pressure control loop"
    annotation (Placement(transformation(extent={{-320,190},{-280,230}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uFanSpe(
    final min=0,
    final max=1,
    final unit="1") "Measured tower fan speed"
    annotation (Placement(transformation(extent={{-320,100},{-280,140}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTowSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Setpoint of tower temperature, could be condenser water return or supply temperature"
    annotation (Placement(transformation(extent={{-320,20},{-280,60}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TTow(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured tower temperature, could be condenser water return or supply temperature"
    annotation (Placement(transformation(extent={{-320,-30},{-280,10}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTow[nTowCel]
    "Cooling tower operating status: true=running tower cell"
    annotation (Placement(transformation(extent={{-320,-140},{-280,-100}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uConWatPumNum
    "Number of enabled condenser water pumps"
    annotation (Placement(transformation(extent={{-320,-180},{-280,-140}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTow
    "Tower fan status: true=enable any number of fans; false=disable all fans"
    annotation (Placement(transformation(extent={{280,-230},{320,-190}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Subtract sub0[nChi]
    "Difference between enabled chiller head pressure control maximum tower speed and the minimum tower speed"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys[nChi](
    final uLow=fill(fanSpeChe, nChi),
    final uHigh=fill(2*fanSpeChe, nChi))
    "Check if chiller head pressure control maximum tower speed is greater than the minimum tower speed "
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nChi)
    "Check if any enabled chiller head pressure control maximum tower speed equals to the minimum tower speed"
    annotation (Placement(transformation(extent={{-20,150},{0,170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[nChi] "Logical not"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=cheMaxTowSpe,
    final delayOnInit=true)
    "Count the time when the chiller head pressure control maximum tower speed equals tower minimum speed"
    annotation (Placement(transformation(extent={{20,150},{40,170}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys1[nChi](
    final uLow=fill(fanSpeChe, nChi),
    final uHigh=fill(2*fanSpeChe, nChi))
    "Check if chiller has been enabled, an enabled chiller will have the head pressure control maximum cooling tower speed that is greater than zero"
    annotation (Placement(transformation(extent={{-240,200},{-220,220}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{-200,170},{-180,190}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "Difference between tower fan speed and the minimum fan speed"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys2(
    final uLow=fanSpeChe,
    final uHigh=2*fanSpeChe)
    "Check if tower fan speed is greater than minimum speed"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Check if tower fan speed equals to the minimum speed"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    "Difference between the return water temperature and the adjusted setpoint"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys3(
    final uLow=0.1,
    final uHigh=0.15)
    "Check if tower temperature is a delta below setpoint"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Tower fans have been at minimum speed for a threshold time and tower return water temperature drops below a adjusted setpoint"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Logical.Or disTow
    "Check if the tower fans should be disabled"
    annotation (Placement(transformation(extent={{60,150},{80,170}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nin=nTowCel)
    "True when any tower fan is enaled"
    annotation (Placement(transformation(extent={{-240,-130},{-220,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "No enabled tower fan"
    annotation (Placement(transformation(extent={{-160,-130},{-140,-110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=cheTowOff,
    final delayOnInit=true)
    "Count the time when all tower cells are off"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub3
    "Difference between the return water temperature and the adjusted setpoint"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys4(
    final uLow=0.1,
    final uHigh=0.15)
    "Check if tower temperature is above the adjusted setpoint"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nin=nChi)
    "Check if all enabled chillers head pressure control maximum tower speed are greater than tower minimum speed"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Logical.And enaTow
    "Check if tower fans should be enabled"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check integer number equality"
    annotation (Placement(transformation(extent={{-100,-170},{-80,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=0) "Zero constant"
    annotation (Placement(transformation(extent={{-160,-210},{-140,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minTowSpe[nChi](
    final k=fill(fanSpeMin, nChi))
    "Minimum tower speed"
    annotation (Placement(transformation(extent={{-240,70},{-220,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one[nChi](
    final k=fill(1, nChi)) "Constant one"
    annotation (Placement(transformation(extent={{-240,140},{-220,160}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=5/9) "Tower temperature setpoint plus 1 degF"
    annotation (Placement(transformation(extent={{-240,-80},{-220,-60}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar1(
    final p=-5/9)
    "Temperature of a delta value below the tower temperature setpoint"
    annotation (Placement(transformation(extent={{-240,30},{-220,50}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=cheMinFanSpe,
    final delayOnInit=true)
    "Count the time when the tower fan is at minimum speed"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi2 "Logical switch"
    annotation (Placement(transformation(extent={{240,-170},{260,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant disFan1(
    final k=false)
    "Disable tower fan when no condenser water pump is ON"
    annotation (Placement(transformation(extent={{120,-210},{140,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1 "Logical switch"
    annotation (Placement(transformation(extent={{200,-100},{220,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Or chaTow
    "Tower fan should be enabled or disabled"
    annotation (Placement(transformation(extent={{140,-20},{160,0}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Logical and"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi3
    "Logical switch"
    annotation (Placement(transformation(extent={{140,150},{160,170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{80,200},{100,220}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre2
    "Break algebraic loop"
    annotation (Placement(transformation(extent={{240,-220},{260,-200}})));

equation
  connect(sub0.y, hys.u)
    annotation (Line(points={{-138,160},{-122,160}}, color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{-98,160},{-62,160}},color={255,0,255}));
  connect(mulOr.y, truDel2.u)
    annotation (Line(points={{2,160},{18,160}}, color={255,0,255}));
  connect(uMaxTowSpeSet, hys1.u)
    annotation (Line(points={{-300,210},{-242,210}}, color={0,0,127}));
  connect(hys1.y, swi.u2)
    annotation (Line(points={{-218,210},{-210,210},{-210,180},{-202,180}},
      color={255,0,255}));
  connect(uMaxTowSpeSet, swi.u1)
    annotation (Line(points={{-300,210},{-260,210},{-260,188},{-202,188}},
      color={0,0,127}));
  connect(one.y, swi.u3)
    annotation (Line(points={{-218,150},{-210,150},{-210,172},{-202,172}},
      color={0,0,127}));
  connect(swi.y, sub0.u1)
    annotation (Line(points={{-178,180},{-170,180},{-170,166},{-162,166}},
      color={0,0,127}));
  connect(uFanSpe, sub1.u1)
    annotation (Line(points={{-300,120},{-200,120},{-200,106},{-162,106}},
     color={0,0,127}));
  connect(sub1.y, hys2.u)
    annotation (Line(points={{-138,100},{-122,100}}, color={0,0,127}));
  connect(hys2.y, not2.u)
    annotation (Line(points={{-98,100},{-62,100}},color={255,0,255}));
  connect(sub2.y, hys3.u)
    annotation (Line(points={{-138,20},{-122,20}}, color={0,0,127}));
  connect(hys3.y, and2.u2)
    annotation (Line(points={{-98,20},{10,20},{10,92},{18,92}}, color={255,0,255}));
  connect(and2.y, disTow.u2)
    annotation (Line(points={{42,100},{50,100},{50,152},{58,152}},
      color={255,0,255}));
  connect(mulOr1.y, not3.u)
    annotation (Line(points={{-218,-120},{-162,-120}}, color={255,0,255}));
  connect(not3.y, truDel.u)
    annotation (Line(points={{-138,-120},{-122,-120}}, color={255,0,255}));
  connect(TTow, sub3.u1)
    annotation (Line(points={{-300,-10},{-180,-10},{-180,-34},{-162,-34}},
      color={0,0,127}));
  connect(sub3.y, hys4.u)
    annotation (Line(points={{-138,-40},{-122,-40}}, color={0,0,127}));
  connect(not1.y, mulOr.u)
    annotation (Line(points={{-38,160},{-22,160}}, color={255,0,255}));
  connect(hys.y, mulAnd.u)
    annotation (Line(points={{-98,160},{-80,160},{-80,-10},{-62,-10}},
      color={255,0,255}));
  connect(uTow, mulOr1.u)
    annotation (Line(points={{-300,-120},{-242,-120}}, color={255,0,255}));
  connect(uConWatPumNum, intEqu.u1)
    annotation (Line(points={{-300,-160},{-102,-160}}, color={255,127,0}));
  connect(conInt.y, intEqu.u2)
    annotation (Line(points={{-138,-200},{-120,-200},{-120,-168},{-102,-168}},
      color={255,127,0}));
  connect(TTowSet, addPar1.u)
    annotation (Line(points={{-300,40},{-242,40}}, color={0,0,127}));
  connect(addPar1.y, sub2.u1)
    annotation (Line(points={{-218,40},{-180,40},{-180,26},{-162,26}},color={0,0,127}));
  connect(TTowSet, addPar.u)
    annotation (Line(points={{-300,40},{-260,40},{-260,-70},{-242,-70}}, color={0,0,127}));
  connect(not2.y, truDel1.u)
    annotation (Line(points={{-38,100},{-22,100}}, color={255,0,255}));
  connect(disFan1.y, logSwi2.u1)
    annotation (Line(points={{142,-200},{160,-200},{160,-152},{238,-152}},
      color={255,0,255}));
  connect(intEqu.y, logSwi2.u2)
    annotation (Line(points={{-78,-160},{238,-160}},
      color={255,0,255}));
  connect(mulOr1.y, logSwi1.u3)
    annotation (Line(points={{-218,-120},{-200,-120},{-200,-98},{198,-98}},
      color={255,0,255}));
  connect(chaTow.y, logSwi1.u2)
    annotation (Line(points={{162,-10},{170,-10},{170,-90},{198,-90}},
      color={255,0,255}));
  connect(logSwi1.y, logSwi2.u3)
    annotation (Line(points={{222,-90},{230,-90},{230,-168},{238,-168}},
      color={255,0,255}));
  connect(addPar.y, sub3.u2) annotation (Line(points={{-218,-70},{-200,-70},{-200,
          -46},{-162,-46}},color={0,0,127}));
  connect(TTow, sub2.u2) annotation (Line(points={{-300,-10},{-180,-10},{-180,14},
          {-162,14}}, color={0,0,127}));
  connect(minTowSpe.y, sub0.u2) annotation (Line(points={{-218,80},{-180,80},{-180,
          154},{-162,154}}, color={0,0,127}));
  connect(minTowSpe[1].y, sub1.u2) annotation (Line(points={{-218,80},{-180,80},
          {-180,94},{-162,94}},  color={0,0,127}));
  connect(enaTow.u1, and1.y)
    annotation (Line(points={{58,-10},{22,-10}}, color={255,0,255}));
  connect(disTow.y, logSwi3.u2)
    annotation (Line(points={{82,160},{138,160}}, color={255,0,255}));
  connect(con.y, logSwi3.u1) annotation (Line(points={{102,210},{120,210},{120,168},
          {138,168}}, color={255,0,255}));
  connect(enaTow.y, logSwi3.u3) annotation (Line(points={{82,-10},{120,-10},{120,
          152},{138,152}}, color={255,0,255}));
  connect(logSwi3.y, logSwi1.u1) annotation (Line(points={{162,160},{180,160},{180,
          -82},{198,-82}}, color={255,0,255}));
  connect(enaTow.y, chaTow.u1)
    annotation (Line(points={{82,-10},{138,-10}}, color={255,0,255}));
  connect(disTow.y, chaTow.u2) annotation (Line(points={{82,160},{100,160},{100,
          -18},{138,-18}}, color={255,0,255}));
  connect(mulAnd.y, and1.u1)
    annotation (Line(points={{-38,-10},{-2,-10}}, color={255,0,255}));
  connect(hys4.y, and1.u2) annotation (Line(points={{-98,-40},{-20,-40},{-20,-18},
          {-2,-18}}, color={255,0,255}));
  connect(truDel.y, enaTow.u2) annotation (Line(points={{-98,-120},{40,-120},{40,
          -18},{58,-18}}, color={255,0,255}));
  connect(truDel1.y, and2.u1)
    annotation (Line(points={{2,100},{18,100}}, color={255,0,255}));
  connect(truDel2.y, disTow.u1)
    annotation (Line(points={{42,160},{58,160}}, color={255,0,255}));
  connect(logSwi2.y, pre2.u) annotation (Line(points={{262,-160},{270,-160},{270,
          -180},{230,-180},{230,-210},{238,-210}}, color={255,0,255}));
  connect(pre2.y, yTow)
    annotation (Line(points={{262,-210},{300,-210}}, color={255,0,255}));
annotation (
  defaultComponentName="enaTow",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-280,-240},{280,240}}), graphics={
          Rectangle(
          extent={{-278,58},{278,-138}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Rectangle(
          extent={{-278,238},{278,62}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Rectangle(
          extent={{-278,-142},{278,-238}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
          extent={{146,226},{250,212}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Disable tower fans"),
          Text(
          extent={{144,46},{238,30}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Enable tower fans"),
          Text(
          extent={{-114,-214},{94,-230}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Disable tower fans when no running condenser water pump")}),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),
Documentation(info="<html>
<p>
Block that outputs signal <code>yTowSta</code> for enabling and disabling cooling tower 
fan. This is implemented according to ASHRAE Guideline36-2021,
section 5.20.12.2, item a.11-l2.
</p>
<ol>
<li>
Disable the tower fans if either:
<ul>
<li>
Any enabled chiller’s head pressure control maximum tower fan speed <code>uMaxTowSpeSet</code> 
has equaled tower minimum speed <code>fanSpeMin</code> for 5 minutes, or
</li>
<li>
Tower fans <code>uFanSpe</code> have been at minimum speed <code>fanSpeMin</code> for 
5 minutes and tower temperature <code>TTow</code> drops below setpoint 
<code>TTowSet</code> minus 1 &deg;F. 
</li>
</ul>
</li>
<li>
Enable the tower fans if:
<ul>
<li>
They have been off (<code>uTow=false</code>) for at least 1 minute, and
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
</li>
<li>
When all condenser water pumps are commanded OFF, disable the PID loop and
stop all tower fans.
</li>
</ol>
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
