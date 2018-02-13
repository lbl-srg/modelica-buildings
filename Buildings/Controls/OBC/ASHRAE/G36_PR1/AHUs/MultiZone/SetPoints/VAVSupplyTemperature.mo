within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints;
block VAVSupplyTemperature
  "Supply air temperature setpoint for multi zone system"

  parameter Modelica.SIunits.Temperature TSupMin = 285.15
    "Lowest cooling supply air temperature setpoint"
    annotation (Dialog(group="Temperatures"));
  parameter Modelica.SIunits.Temperature TSupMax = 291.15
    "Highest cooling supply air temperature setpoint. It is typically 18 degC (65 degF) 
    in mild and dry climates, 16 degC (60 degF) or lower in humid climates"
    annotation (Dialog(group="Temperatures"));
  parameter Modelica.SIunits.Temperature TSupDes = 286.15
    "Nominal supply air temperature setpoint"
    annotation (Dialog(group="Temperatures"));
  parameter Modelica.SIunits.Temperature TOutMin = 289.15
    "Lower value of the outdoor air temperature reset range. Typically value is 16 degC (60 degF)"
    annotation (Dialog(group="Temperatures"));
  parameter Modelica.SIunits.Temperature TOutMax = 294.15
    "Higher value of the outdoor air temperature reset range. Typically value is 21 degC (70 degF)"
    annotation (Dialog(group="Temperatures"));
  parameter Modelica.SIunits.Temperature iniSet = maxSet
    "Initial setpoint"
    annotation (Dialog(group="Trim and respond logic"));
  parameter Modelica.SIunits.Temperature maxSet = TSupMax
    "Maximum setpoint"
    annotation (Dialog(group="Trim and respond logic"));
  parameter Modelica.SIunits.Temperature minSet = TSupDes
    "Minimum setpoint"
    annotation (Dialog(group="Trim and respond logic"));
  parameter Modelica.SIunits.Time delTim = 600
    "Delay timer"
    annotation(Dialog(group="Trim and respond logic"));
  parameter Modelica.SIunits.Time samplePeriod(min=1E-3) = 120
    "Sample period of component"
    annotation(Dialog(group="Trim and respond logic"));
  parameter Integer numIgnReq = 2
    "Number of ignorable requests for TrimResponse logic"
    annotation(Dialog(group="Trim and respond logic"));
  parameter Modelica.SIunits.TemperatureDifference triAmo = 0.1
    "Trim amount"
    annotation (Dialog(group="Trim and respond logic"));
  parameter Modelica.SIunits.TemperatureDifference resAmo = -0.2
    "Response amount"
    annotation (Dialog(group="Trim and respond logic"));
  parameter Modelica.SIunits.TemperatureDifference maxRes = -0.6
    "Maximum response per time interval"
    annotation (Dialog(group="Trim and respond logic"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
      iconTransformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetZones(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Average of heating and cooling setpoint"
    annotation (Placement(transformation(extent={{-180,70},{-140,110}}),
      iconTransformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan
    "Supply fan status"
    annotation (Placement(transformation(extent={{-180,-50},{-140,-10}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "System operation mode"
    annotation (Placement(transformation(extent={{-180,-120},{-140,-80}}),
      iconTransformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement( transformation(extent={{-180,0},{-140,40}}),
      iconTransformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSetSup(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Setpoint for supply air temperature"
    annotation (Placement(transformation(extent={{140,-10},{160,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.TrimAndRespond maxSupTemRes(
    final delTim=delTim,
    final iniSet=iniSet,
    final minSet=minSet,
    final maxSet=maxSet,
    final samplePeriod=samplePeriod,
    final numIgnReq=numIgnReq,
    final triAmo=triAmo,
    final resAmo=resAmo,
    final maxRes=maxRes) "Maximum cooling supply temperature reset"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Supply temperature distributes linearly between minimum and maximum supply 
    air temperature, according to outdoor temperature"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minOutTem(k=TOutMin)
    "Lower value of the outdoor air temperature reset range"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxOutTem(k=TOutMax)
    "Higher value of the outdoor air temperature reset range"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minSupTem(k=TSupMin)
    "Lowest cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if it is in Setup or Cool-down mode"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Check if it is in Warmup or Setback mode"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupWarUpSetBac(k=35 + 273.15)
    "Supply temperature setpoint under warm-up and setback mode"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "If operation mode is setup or cool-down, setpoint shall be 35 degC"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    "If operation mode is setup or cool-down, setpoint shall be TSupMin"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Limiter TDea(
    uMax=24 + 273.15,
    uMin=21 + 273.15)
    "Limiter that outputs the dead band value for the supply air temperature"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3
    "Check output regarding supply fan status"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Integers.LessThreshold intLesThr(
    threshold=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.warmUp)
    "Check if operation mode index is less than warm-up mode index (4)"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(
    threshold=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "Check if operation mode index is greater than occupied mode index (1)"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Integers.LessThreshold intLesThr1(
    threshold=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.unoccupied)
    "Check if operation mode index is less than unoccupied mode index (7)"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr1(
    threshold=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.setUp)
    "Check if operation mode index is greater than set up mode index (3)"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));

equation
  connect(minOutTem.y, lin.x1)
    annotation (Line(points={{-19,70},{0,70},{0,58},{18,58}},
      color={0,0,127}));
  connect(TOut, lin.u)
    annotation (Line(points={{-160,60},{-100,60},{-100,50},{18,50}},
      color={0,0,127}));
  connect(maxOutTem.y, lin.x2)
    annotation (Line(points={{-19,30},{0,30},{0,46},{18,46}},
      color={0,0,127}));
  connect(minSupTem.y, lin.f2)
    annotation (Line(points={{-79,-10},{10,-10},{10,42},{18,42}},
      color={0,0,127}));
  connect(and1.y, swi1.u2)
    annotation (Line(points={{41,-90},{60,-90},{60,-50},{78,-50}},
      color={255,0,255}));
  connect(TSupWarUpSetBac.y, swi1.u1)
    annotation (Line(points={{41,-120},{68,-120},{68,-42},{78,-42}},
      color={0,0,127}));
  connect(and2.y, swi2.u2)
    annotation (Line(points={{-19,-50},{18,-50}},color={255,0,255}));
  connect(minSupTem.y, swi2.u1)
    annotation (Line(points={{-79,-10},{0,-10},{0,-42},{18,-42}},
      color={0,0,127}));
  connect(swi2.y, swi1.u3)
    annotation (Line(points={{41,-50},{50,-50},{50,-58},{78,-58}},
      color={0,0,127}));
  connect(TSetZones, TDea.u)
    annotation (Line(points={{-160,90},{-102,90}},
      color={0,0,127}));
  connect(uSupFan, swi3.u2)
    annotation (Line(points={{-160,-30},{-120,-30},{-120,10},{-60,10},{-60,0},
      {78,0}}, color={255,0,255}));
  connect(swi1.y, swi3.u1)
    annotation (Line(points={{101,-50},{110,-50},{110,-20},{68,-20},{68,8},{78,8}},
      color={0,0,127}));
  connect(TDea.y, swi3.u3)
    annotation (Line(points={{-79,90},{60,90},{60,-8},{78,-8}},
      color={0,0,127}));
  connect(intLesThr1.y, and1.u1)
    annotation (Line(points={{-19,-90},{18,-90}},
      color={255,0,255}));
  connect(intGreThr1.y, and1.u2)
    annotation (Line(points={{-19,-120},{0,-120},{0,-98},{18,-98}},
      color={255,0,255}));
  connect(intLesThr.y, and2.u1)
    annotation (Line(points={{-79,-50},{-42,-50}},color={255,0,255}));
  connect(intGreThr.y, and2.u2)
    annotation (Line(points={{-79,-80},{-60,-80},{-60,-58},{-42,-58}},
      color={255,0,255}));
  connect(uOpeMod, intLesThr.u)
    annotation (Line(points={{-160,-100},{-120,-100},{-120,-50},{-102,-50}},
      color={255,127,0}));
  connect(uOpeMod, intGreThr.u)
    annotation (Line(points={{-160,-100},{-120,-100},{-120,-80},{-102,-80}},
      color={255,127,0}));
  connect(uOpeMod, intLesThr1.u)
    annotation (Line(points={{-160,-100},{-60,-100},{-60,-90},{-42,-90}},
      color={255,127,0}));
  connect(uOpeMod, intGreThr1.u)
    annotation (Line(points={{-160,-100},{-120,-100},{-120,-120},{-42,-120}},
      color={255,127,0}));
  connect(lin.y, swi2.u3)
    annotation (Line(points={{41,50},{50,50},{50,-30},{8,-30},{8,-58},{18,-58}},
      color={0,0,127}));
  connect(uZonTemResReq, maxSupTemRes.numOfReq)
    annotation (Line(points={{-160,20},{-112,20},{-112,22},{-102,22}},
      color={255,127,0}));
  connect(uSupFan, maxSupTemRes.uDevSta)
    annotation (Line(points={{-160,-30},{-120,-30},{-120,38},{-102,38}},
      color={255,0,255}));
  connect(maxSupTemRes.y, lin.f1)
    annotation (Line(points={{-79,30},{-60,30},{-60,54},{18,54}},
      color={0,0,127}));
  connect(swi3.y, TSetSup)
    annotation (Line(points={{101,0},{150,0}},   color={0,0,127}));

annotation (
  defaultComponentName = "conTSetSup",
  Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-94,92},{-42,66}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSetZones"),
        Text(
          extent={{-96,46},{-68,34}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TOut"),
        Text(
          extent={{-94,-22},{-14,-58}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uZonTemResReq"),
        Text(
          extent={{-94,12},{-48,-12}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uSupFan"),
        Text(
          extent={{-94,-70},{-50,-90}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{68,8},{96,-8}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSetSup"),
        Text(
          extent={{-124,146},{96,108}},
          lineColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,120}})),
  Documentation(info="<html>
<p>
Block that outputs the supply air temperature setpoint and the coil valve control
inputs for VAV system with multiple zones, implemented according to the ASHRAE
Guideline G36, PART5.N.2 (Supply air temperature control).
</p>
<p>
The control loop is enabled when the supply air fan <code>uSupFan</code> is proven on,
and disabled and the output set to Deadband otherwise.
</p>
<p> The supply air temperature setpoint is computed as follows.</p>
<h4>Setpoints for <code>TSupMin</code>, <code>TSupMax</code>,
<code>TSupDes</code>, <code>TOutMin</code>, <code>TOutMax</code></h4>
<p>
The default range of outdoor air temperature (<code>TOutMin=16&deg;C</code>,
<code>TOutMax=21&deg;C</code>) used to reset the occupied mode <code>TSetSup</code>
was chosen to maximize economizer hours. It may be preferable to use a lower
range of outdoor air temperature (e.g. <code>TOutMin=13&deg;C</code>,
<code>TOutMax=18&deg;C</code>) to minimize fan energy.
</p>
<p>
The <code>TSupMin</code> variable is used during warm weather when little reheat
is expected to minimize fan energy. It should not be set too low or it may cause
excessive chilled water temperature reset requests which will reduce chiller
plant efficiency. It should be set no lower than the design coil leaving air
temperature.
</p>
<p>
The <code>TSupMax</code> variable is typically 18 &deg;C in mild and dry climate,
16 &deg;C or lower in humid climates. It should not typically be greater than
18 &deg;C since this may lead to excessive fan energy that can offset the mechanical
cooling savings from economizer operation.
</p>

<h4>During occupied mode (<code>uOpeMod=1</code>)</h4>
<p>
The <code>TSetSup</code> shall be reset from <code>TSupMin</code> when the outdoor
air temperature is <code>TOutMax</code> and above, proportionally up to
<code>TMax</code> when the outdoor air temperature is <code>TOutMin</code> and
below. The <code>TMax</code> shall be reset using trim and respond logic between
<code>TSupDes</code> and <code>TSupMax</code>. Parameters suggested for the
trim and respond logic are shown in the table below. They require adjustment
during the commissioning and tuning phase.
</p>

<table summary=\"summary\" border=\"1\">
<tr><th> Variable </th> <th> Value </th> <th> Definition </th> </tr>
<tr><td>Device</td><td>AHU Supply Fan</td> <td>Associated device</td></tr>
<tr><td>SP0</td><td><code>iniSet</code></td><td>Initial setpoint</td></tr>
<tr><td>SPmin</td><td><code>TSupMin</code></td><td>Minimum setpoint</td></tr>
<tr><td>SPmax</td><td><code>TSupMax</code></td><td>Maximum setpoint</td></tr>
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
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/VAVMultiZoneSupTempSet.png\"/>
</p>

<h4>During Setup and Cool-down modes (<code>uOpeMod=2</code>, <code>uOpeMod=3</code>)</h4>
<p>
Supply air temperature setpoint <code>TSetSup</code> shall be <code>TSupMin</code>.
</p>
<h4>During Setback and Warmup modes (<code>uOpeMod=4</code>, <code>uOpeMod=5</code>)</h4>
<p>
Supply air temperature setpoint <code>TSetSup</code> shall be <code>35&deg;C</code>.
</p>

<h4>Valves control</h4>
<p>
Supply air temperature shall be controlled to setpoint using a control loop whose
output is mapped to sequence the hot water valve or modulating electric heating
coil (if applicable) or chilled water valves.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 11, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end VAVSupplyTemperature;
