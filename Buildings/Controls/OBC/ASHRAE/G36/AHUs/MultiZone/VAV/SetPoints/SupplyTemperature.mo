within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints;
block SupplyTemperature
  "Supply air temperature setpoint for multi zone system"

  parameter Real TSupCoo_min(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=285.15
    "Lowest cooling supply air temperature setpoint when the outdoor air temperature is at the
    higher value of the reset range and above"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Temperatures"));
  parameter Real TSupCoo_max(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=291.15
    "Highest cooling supply air temperature setpoint. It is typically 18 degC (65 degF) 
    in mild and dry climates, 16 degC (60 degF) or lower in humid climates"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Temperatures"));
  parameter Real TOut_min(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=289.15
    "Lower value of the outdoor air temperature reset range. Typically value is 16 degC (60 degF)"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Temperatures"));
  parameter Real TOut_max(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=294.15
    "Higher value of the outdoor air temperature reset range. Typically value is 21 degC (70 degF)"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Temperatures"));
  parameter Real TSupWarUpSetBac(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=308.15
    "Supply temperature in warm up and set back mode"
    annotation (__cdl(ValueInReference=true),
                Dialog(group="Temperatures"));
  parameter Real delTim(
    final unit="s",
    final quantity="Time") = 600
    "Delay timer"
    annotation(__cdl(ValueInReference=true),
                Dialog(group="Trim and respond logic"));
  parameter Real samplePeriod(
    final unit="s",
    final quantity="Time",
    final min=1E-3) = 120
    "Sample period of component"
    annotation(__cdl(ValueInReference=true),
                Dialog(group="Trim and respond logic"));
  parameter Integer numIgnReq = 2
    "Number of ignorable requests for TrimResponse logic"
    annotation(__cdl(ValueInReference=true),
                Dialog(group="Trim and respond logic"));
  parameter Real triAmo(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 0.1
    "Trim amount"
    annotation (__cdl(ValueInReference=true),
                Dialog(group="Trim and respond logic"));
  parameter Real resAmo(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = -0.2
    "Response amount"
    annotation (__cdl(ValueInReference=true),
                Dialog(group="Trim and respond logic"));
  parameter Real maxRes(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = -0.6
    "Maximum response per time interval"
    annotation (__cdl(ValueInReference=true),
                Dialog(group="Trim and respond logic"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-180,100},{-140,140}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SupFan
    "Supply fan status"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "System operation mode"
    annotation (Placement(transformation(extent={{-180,-140},{-140,-100}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement( transformation(extent={{-180,60},{-140,100}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAirSupSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.ASHRAE.G36.Generic.TrimAndRespond maxSupTemRes(
    final delTim=delTim,
    final iniSet=iniSet,
    final minSet=minSet,
    final maxSet=maxSet,
    final samplePeriod=samplePeriod,
    final numIgnReq=numIgnReq,
    final triAmo=triAmo,
    final resAmo=resAmo,
    final maxRes=maxRes) "Maximum cooling supply temperature reset"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));

protected
  parameter Real TDeaBan(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=273.15+26
    "Default supply temperature setpoint when the AHU is disabled";
  parameter Real iniSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=TSupCoo_max
    "Initial setpoint"
    annotation (Dialog(group="Trim and respond logic"));
  parameter Real maxSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=TSupCoo_max
    "Maximum setpoint"
    annotation (Dialog(group="Trim and respond logic"));
  parameter Real minSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=TSupCoo_min
    "Minimum setpoint"
    annotation (Dialog(group="Trim and respond logic"));

  Buildings.Controls.OBC.CDL.Reals.Line lin
    "Supply temperature distributes linearly between minimum and maximum supply 
    air temperature, according to outdoor temperature"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minOutTem(
    final k=TOut_min)
    "Lower value of the outdoor air temperature reset range"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxOutTem(
    final k=TOut_max)
    "Higher value of the outdoor air temperature reset range"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minSupTem(
    final k=TSupCoo_min)
    "Lowest cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Check if it is in Warmup or Setback mode"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant supTemWarUpSetBac(
    final k=TSupWarUpSetBac)
    "Supply temperature setpoint under warm-up and setback mode"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "If operation mode is warm-up or setback modes, setpoint shall be 35 degC"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    "If operation mode is setup or cool-down, setpoint shall be the lowest cooling supply setpoint"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3
    "Check output regarding supply fan status"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cooDowMod(
    final k=3) "Cooldown mode index"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Integers.LessThreshold intLesThr1(
    final t=6)
    "Check if operation mode index is less than 6 (freeze protection mode)"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr1(
    final t=3)
    "Check if operation mode index is greater than 3 (setup mode)"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Buildings.Controls.OBC.CDL.Integers.LessThreshold intLesThr2(
    final t=3)
    "Check if operation mode index is less than 3 (setup mode)"
    annotation (Placement(transformation(extent={{-60,18},{-40,38}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold  intGreThr2(
    final t=0)
    "Check if operation mode index is greater than 0 (unoccupied mode)"
    annotation (Placement(transformation(extent={{-60,-42},{-40,-22}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if it is in occupied or setup mode"
    annotation (Placement(transformation(extent={{0,18},{20,38}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi4
    "If operation mode is occupied or setup ,mode, setpoint shall be reset"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if it is in cooldown mode"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

  CDL.Reals.Sources.Constant TDea(final k=TDeaBan)
    "Deadband supply temperature setpoint"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
equation
  connect(minOutTem.y, lin.x1)
    annotation (Line(points={{-38,140},{-20,140},{-20,128},{-2,128}},
      color={0,0,127}));
  connect(TOut, lin.u)
    annotation (Line(points={{-160,120},{-2,120}},
      color={0,0,127}));
  connect(maxOutTem.y, lin.x2)
    annotation (Line(points={{-38,100},{-20,100},{-20,116},{-2,116}},
      color={0,0,127}));
  connect(minSupTem.y, lin.f2)
    annotation (Line(points={{-78,60},{-10,60},{-10,112},{-2,112}},
      color={0,0,127}));
  connect(and1.y, swi1.u2)
    annotation (Line(points={{22,-110},{60,-110},{60,-70},{78,-70}},
      color={255,0,255}));
  connect(supTemWarUpSetBac.y, swi1.u1)
    annotation (Line(points={{42,-150},{68,-150},{68,-62},{78,-62}},
      color={0,0,127}));
  connect(minSupTem.y, swi2.u1)
    annotation (Line(points={{-78,60},{-10,60},{-10,-62},{18,-62}},
      color={0,0,127}));
  connect(swi2.y, swi1.u3)
    annotation (Line(points={{42,-70},{50,-70},{50,-78},{78,-78}},
      color={0,0,127}));
  connect(u1SupFan, swi3.u2)
    annotation (Line(points={{-160,0},{98,0}}, color={255,0,255}));
  connect(swi1.y, swi3.u1)
    annotation (Line(points={{102,-70},{110,-70},{110,-40},{90,-40},{90,8},{98,8}},
      color={0,0,127}));
  connect(intLesThr1.y, and1.u1)
    annotation (Line(points={{-38,-110},{-2,-110}},
      color={255,0,255}));
  connect(intGreThr1.y, and1.u2)
    annotation (Line(points={{-38,-150},{-20,-150},{-20,-118},{-2,-118}},
      color={255,0,255}));
  connect(uOpeMod, intLesThr1.u)
    annotation (Line(points={{-160,-120},{-70,-120},{-70,-110},{-62,-110}},
      color={255,127,0}));
  connect(uOpeMod, intGreThr1.u)
    annotation (Line(points={{-160,-120},{-120,-120},{-120,-150},{-62,-150}},
      color={255,127,0}));
  connect(uZonTemResReq, maxSupTemRes.numOfReq)
    annotation (Line(points={{-160,80},{-120,80},{-120,92},{-102,92}},
      color={255,127,0}));
  connect(u1SupFan, maxSupTemRes.uDevSta) annotation (Line(points={{-160,0},{-130,
          0},{-130,108},{-102,108}}, color={255,0,255}));
  connect(maxSupTemRes.y, lin.f1)
    annotation (Line(points={{-78,100},{-70,100},{-70,124},{-2,124}},
      color={0,0,127}));
  connect(swi3.y, TAirSupSet)
    annotation (Line(points={{122,0},{160,0}}, color={0,0,127}));
  connect(cooDowMod.y, intEqu.u2) annotation (Line(points={{-78,-100},{-70,-100},
          {-70,-78},{-62,-78}}, color={255,127,0}));
  connect(uOpeMod, intEqu.u1) annotation (Line(points={{-160,-120},{-120,-120},{
          -120,-70},{-62,-70}}, color={255,127,0}));
  connect(intEqu.y, swi2.u2)
    annotation (Line(points={{-38,-70},{18,-70}}, color={255,0,255}));
  connect(uOpeMod, intLesThr2.u) annotation (Line(points={{-160,-120},{-120,-120},
          {-120,28},{-62,28}}, color={255,127,0}));
  connect(uOpeMod, intGreThr2.u) annotation (Line(points={{-160,-120},{-120,-120},
          {-120,-32},{-62,-32}}, color={255,127,0}));
  connect(intLesThr2.y, and2.u1) annotation (Line(points={{-38,28},{-20,28},{-20,
          28},{-2,28}}, color={255,0,255}));
  connect(intGreThr2.y, and2.u2) annotation (Line(points={{-38,-32},{-20,-32},{-20,
          20},{-2,20}}, color={255,0,255}));
  connect(and2.y, swi4.u2) annotation (Line(points={{22,28},{30,28},{30,60},{38,
          60}}, color={255,0,255}));
  connect(lin.y, swi4.u1) annotation (Line(points={{22,120},{30,120},{30,68},{38,
          68}}, color={0,0,127}));
  connect(swi4.y, swi2.u3) annotation (Line(points={{62,60},{70,60},{70,-40},{10,
          -40},{10,-78},{18,-78}}, color={0,0,127}));

  connect(TDea.y, swi4.u3) annotation (Line(points={{-78,160},{-30,160},{-30,52},
          {38,52}}, color={0,0,127}));
  connect(TDea.y, swi3.u3) annotation (Line(points={{-78,160},{-30,160},{-30,-8},
          {98,-8}}, color={0,0,127}));
annotation (
  defaultComponentName = "conTSupSet",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,80},{-68,64}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TOut"),
        Text(
          extent={{-98,40},{-18,20}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uZonTemResReq"),
        Text(
          extent={{-98,-18},{-52,-42}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1SupFan"),
        Text(
          extent={{-96,-60},{-52,-80}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{44,8},{96,-8}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TAirSupSet"),
        Text(
          extent={{-124,146},{96,108}},
          textColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-180},{140,180}})),
  Documentation(info="<html>
<p>
Block that outputs the supply air temperature setpoint and the coil valve control
inputs for VAV system with multiple zones, implemented according to Section 5.16.2 of
the ASHRAE Guideline G36, May 2020.
</p>
<p>
The control loop is enabled when the supply air fan <code>u1SupFan</code> is proven on,
and disabled and the output set to deadband (no heating, minimum economizer) otherwise.
</p>
<p> The supply air temperature setpoint is computed as follows.</p>

<h4>Setpoints for <code>TSupCoo_min</code>, <code>TSupCoo_max</code>,
<code>TOut_min</code>, <code>TOut_max</code>
</h4>
<p>
Per Section 3.1.4.1, the setpoints are design information.
</p>
<ul>
<li>
The <code>TSupCoo_min</code> should be set no lower than the design coil leaving air
temperature to prevent excessive chilled water temperature reset requests.
</li>
<li>
The <code>TSupCoo_max</code> is typically 18 &deg;C (65 &deg;F) in mild and dry climates
and 16 &deg;C (60 &deg;F) or lower in humid climates. It should not typically be
greater than 18 &deg;C (65 &deg;F).
</li>
<li>
The default range of outdoor air temperature (<code>TOut_min=16&deg;C</code>,
<code>TOut_max=21&deg;C</code>) used to reset the occupied mode <code>TSupSet</code>
was chosen to maximize economizer hours. It may be preferable to use a lower
range of outdoor air temperature (e.g. <code>TOut_min=13&deg;C</code>,
<code>TOut_max=18&deg;C</code>) to minimize fan energy.
</li>
</ul>

<h4>During occupied and Setup modes (<code>uOpeMod=1</code>, <code>uOpeMod=2</code>)</h4>
<p>
The <code>TSupSet</code> shall be reset from <code>TSupCoo_min</code> when the outdoor
air temperature is <code>TOut_max</code> and above, proportionally up to
maximum supply temperature when the outdoor air temperature is <code>TOut_min</code> and
below. The maximum supply temperature shall be reset using trim and respond logic between
<code>TSupCoo_min</code> and <code>TSupCoo_max</code>. Parameters suggested for the
trim and respond logic are shown in the table below. They require adjustment
during the commissioning and tuning phase.
</p>

<table summary=\"summary\" border=\"1\">
<tr><th> Variable </th> <th> Value </th> <th> Definition </th> </tr>
<tr><td>Device</td><td>AHU Supply Fan</td> <td>Associated device</td></tr>
<tr><td>SP0</td><td><code>iniSet</code></td><td>Initial setpoint</td></tr>
<tr><td>SPmin</td><td><code>TSupCoo_min</code></td><td>Minimum setpoint</td></tr>
<tr><td>SPmax</td><td><code>TSupCoo_max</code></td><td>Maximum setpoint</td></tr>
<tr><td>Td</td><td><code>delTim</code></td><td>Delay timer</td></tr>
<tr><td>T</td><td><code>samplePeriod</code></td><td>Time step</td></tr>
<tr><td>I</td><td><code>numIgnReq</code></td><td>Number of ignored requests</td></tr>
<tr><td>R</td><td><code>uZonTemResReq</code></td><td>Number of requests</td></tr>
<tr><td>SPtrim</td><td><code>triAmo</code></td><td>Trim amount</td></tr>
<tr><td>SPres</td><td><code>resAmo</code></td><td>Respond amount</td></tr>
<tr><td>SPres_max</td><td><code>maxRes</code></td><td>Maximum response per time interval</td></tr>
</table>
<br/>

<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/SetPoints/VAVSupTempSet.png\"/>
</p>

<h4>During Cool-down modes (<code>uOpeMod=3</code>)</h4>
<p>
Supply air temperature setpoint <code>TSupSet</code> shall be <code>TSupCoo_min</code>.
</p>
<h4>During Setback and Warmup modes (<code>uOpeMod=4</code>, <code>uOpeMod=5</code>)</h4>
<p>
Supply air temperature setpoint <code>TSupSet</code> shall be <code>TSupWarUpSetBac</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SupplyTemperature;
