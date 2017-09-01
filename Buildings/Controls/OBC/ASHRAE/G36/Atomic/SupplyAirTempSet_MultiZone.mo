within Buildings.Controls.OBC.ASHRAE.G36.Atomic;
block SupplyAirTempSet_MultiZone
  "Supply air temperature setpoint for multizone system"

  parameter Modelica.SIunits.Temperature TSupMin = 285.15
    "Lowest cooling supply air temperature setpoint"
    annotation (Dialog(group="Temperatures"));
  parameter Modelica.SIunits.Temperature TSupMax = 291.15
    "Highest cooling supply air temperature setpoint. It is typically 18 degC (65 degF) in mild and dry climates, 16 degC (60 degF) or lower in humid climates"
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

  CDL.Interfaces.RealInput TOut(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.RealInput TMax(
    min=TSupDes,
    max=TSupMax,
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Maximum cooling supply temperature "
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  CDL.Interfaces.RealInput TSetZones(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Average of heating and cooling setpoint"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply fan status"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  CDL.Interfaces.IntegerInput opeMod "System operation mode"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.RealOutput TSup(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Supply air temperature"
    annotation (Placement(transformation(extent={{140,0},{160,20}}),
        iconTransformation(extent={{100,-10},{120,10}})));


//   fixme: Need a Trim&Response logic to find the T_max
//   parameter Modelica.SIunits.Temperature iniSet = maxSet
//     "Initial setpoint"
//     annotation (Dialog(group="Variables of Trim & Response logic to set maximum supply temperature T_max"));
//   parameter Modelica.SIunits.Temperature maxSet = TSupMax
//     "Maximum setpoint"
//     annotation (Dialog(group="Variables of Trim & Response logic to set maximum supply temperature T_max"));
//   parameter Modelica.SIunits.Temperature minSet = TSupDes
//     "Minimum setpoint"
//     annotation (Dialog(group="Variables of Trim & Response logic to set maximum supply temperature T_max"));
//   parameter Modelica.SIunits.Time delTim = 10*60
//     "Delay timer"
//     annotation(Dialog(group="Variables of Trim & Response logic to set maximum supply temperature T_max"));
//   parameter Modelica.SIunits.Time timSte = 2*60
//     "Time step"
//     annotation(Dialog(group="Variables of Trim & Response logic to set maximum supply temperature T_max"));
//   parameter Integer ignReq = 2
//     "Number of ignored requests for Trim&Response logic "
//     annotation(Dialog(group="Variables of Trim & Response logic to set maximum supply temperature T_max"));
//   parameter Integer numReq = cooReq
//     "Number of cooling requests"
//     annotation(Dialog(group="Variables of Trim & Response logic to set maximum supply temperature T_max"));
//   parameter Modelica.SIunits.Temperature triAmo = 0.1
//     "Trim amount"
//     annotation (Dialog(group="Variables of Trim & Response logic to set maximum supply temperature T_max"));
//   parameter Modelica.SIunits.Temperature resAmo = -0.2
//     "Response amount"
//     annotation (Dialog(group="Variables of Trim & Response logic to set maximum supply temperature T_max"));
//   parameter Modelica.SIunits.Temperature maxRes = -0.6
//     "Maximum response per time interval"
//     annotation (Dialog(group="Variables of Trim & Response logic to set maximum supply temperature T_max"));

protected
  CDL.Continuous.Line lin
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  CDL.Continuous.Sources.Constant minOutTem(k=TOutMin)
    "Lower value of the outdoor air temperature reset range"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  CDL.Continuous.Sources.Constant maxOutTem(k=TOutMax)
    "Higher value of the outdoor air temperature reset range"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  CDL.Continuous.Sources.Constant minSupTem(k=TSupMin)
    "Lowest cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  CDL.Logical.And and2 "Check if it is in Setup or Cool-down mode"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  CDL.Logical.And and1 "Check if it is in Warmup or Setback mode"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  CDL.Continuous.Sources.Constant TSupWarUpSetBac(k=35 + 273.15)
    "Supply temperature setpoint under warm-up and setback mode"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{100,-40},{120,-60}})));
  CDL.Logical.Switch swi2
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  CDL.Continuous.Limiter TDea(
    uMax=24 + 273.15,
    uMin=21 + 273.15)
    "Limiter that outputs the dead band value for the supply air temperature"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  CDL.Logical.Switch swi3 "Check output regarding supply fan status"
    annotation (Placement(transformation(extent={{100,20},{120,0}})));
  CDL.Integers.LessThreshold intLesThr(threshold=Constants.OperationModes.warUpInd)
    "Check if operation mode index is less than warm-up mode index (4)"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  CDL.Integers.GreaterThreshold intGreThr(threshold=Constants.OperationModes.occModInd)
    "Check if operation mode index is greater than occupied mode index (1)"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  CDL.Integers.LessThreshold intLesThr1(threshold=Constants.OperationModes.unoModInd)
    "Check if operation mode index is less than unoccupied mode index (7)"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  CDL.Integers.GreaterThreshold intGreThr1(threshold=Constants.OperationModes.setUpInd)
    "Check if operation mode index is greater than set up mode index (3)"
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));

equation
  connect(minOutTem.y, lin.x1)
    annotation (Line(points={{-39,70},{-10,70},{-10,58},{-2,58}},
      color={0,0,127}));
  connect(TOut, lin.u)
    annotation (Line(points={{-120,10},{-80,10},{-80,50},{-2,50}},
        color={0,0,127}));
  connect(maxOutTem.y, lin.x2)
    annotation (Line(points={{-39,30},{-12,30},{-12,46},{-2,46}},
      color={0,0,127}));
  connect(minSupTem.y, lin.f2)
    annotation (Line(points={{-39,-10},{-10,-10},{-10,42},{-2,42}},
      color={0,0,127}));
  connect(TMax, lin.f1)
    annotation (Line(points={{-120,50},{-82,50},{-82,54},{-2,54}},
      color={0,0,127}));
  connect(and1.y, swi1.u2)
    annotation (Line(points={{61,-90},{80,-90},{80,-50},{98,-50}},
      color={255,0,255}));
  connect(TSupWarUpSetBac.y, swi1.u1)
    annotation (Line(points={{61,-130},{88,-130},{88,-58},{98,-58}},
      color={0,0,127}));
  connect(and2.y, swi2.u2)
    annotation (Line(points={{21,-50},{38,-50}}, color={255,0,255}));
  connect(minSupTem.y, swi2.u1)
    annotation (Line(points={{-39,-10},{32,-10},{32,-42},{38,-42}},
      color={0,0,127}));
  connect(swi2.y, swi1.u3)
    annotation (Line(points={{61,-50},{70,-50},{70,-42},{98,-42}},
      color={0,0,127}));
  connect(lin.y, swi2.u3)
    annotation (Line(points={{21,50},{26,50},{26,-58},{38,-58}},
      color={0,0,127}));
  connect(TSetZones, TDea.u)
    annotation (Line(points={{-120,90},{38,90}}, color={0,0,127}));
  connect(uSupFan, swi3.u2)
    annotation (Line(points={{-120,-30},{-78,-30},{-78,10},{98,10}},
      color={255,0,255}));
  connect(swi1.y, swi3.u1)
    annotation (Line(points={{121,-50},{128,-50},{128,-10},{80,-10},{80,2},{98,2}},
      color={0,0,127}));
  connect(TDea.y, swi3.u3)
    annotation (Line(points={{61,90},{80,90},{80,18},{98,18}},
      color={0,0,127}));
  connect(swi3.y, TSup)
    annotation (Line(points={{121,10},{150,10}},
      color={0,0,127}));
  connect(intLesThr1.y, and1.u1)
    annotation (Line(points={{1,-100},{14,-100},{14,-90},{38,-90}},
      color={255,0,255}));
  connect(intGreThr1.y, and1.u2)
    annotation (Line(points={{1,-130},{20,-130},{20,-98},{38,-98}},
      color={255,0,255}));
  connect(intLesThr.y, and2.u1)
    annotation (Line(points={{-39,-50},{-2,-50}}, color={255,0,255}));
  connect(intGreThr.y, and2.u2)
    annotation (Line(points={{-39,-80},{-20,-80},{-20,-58},{-2,-58}},
      color={255,0,255}));
  connect(opeMod, intLesThr.u)
    annotation (Line(points={{-120,-100},{-80,-100},{-80,-50},{-62,-50}},
      color={255,127,0}));
  connect(opeMod, intGreThr.u)
    annotation (Line(points={{-120,-100},{-80,-100},{-80,-80},{-62,-80}},
      color={255,127,0}));
  connect(opeMod, intLesThr1.u)
    annotation (Line(points={{-120,-100},{-22,-100}}, color={255,127,0}));
  connect(opeMod, intGreThr1.u)
    annotation (Line(points={{-120,-100},{-80,-100},{-80,-130},{-22,-130}},
      color={255,127,0}));

annotation (
  defaultComponentName = "supAirTemSet",
  Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,92},{-50,68}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSetZones"),
        Text(
          extent={{-96,8},{-64,-8}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TOut"),
        Text(
          extent={{-96,50},{-64,34}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TMax"),
        Text(
          extent={{-96,-28},{-52,-52}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uSupFan"),
        Text(
          extent={{-96,-70},{-52,-90}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="opeMod"),
        Text(
          extent={{70,6},{98,-10}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-124,146},{96,108}},
          lineColor={0,0,255},
          textString="%name")}),
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{140,100}})),
  Documentation(info="<html>
<p>
This block output supply air temperature for VAV system with multiple zone. It 
is implemented according to the ASHRAE Guideline G36, PART5.N.2 (Supply air 
temperature control).
</p>
<p>
Control loop is enabled when supply air fan <code>uSupFan</code> is proven on, 
and disabled and output set to Deadband otherwise. 
</p>
<p> Supply air temperature setpoint should be defined as following.</p>
<h4>Setpoints for <code>TSupMin</code>, <code>TSupMax</code>, 
<code>TSupDes</code>, <code>TOutMin</code>, <code>TOutMax</code></h4>
The default range of outdoor air temperature (<code>TOutMin=16&deg;C</code>, 
<code>TOutMax=21&deg;C</code>) used to reset the occupied mode <code>TSup</code>
was chosen to maximize economizer hours. It may be preferable to use a lower 
range of outdoor air temperature (e.g. <code>TOutMin=13&deg;C</code>, 
<code>TOutMax=18&deg;C</code>) to minimize fan energy.
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

<h4>During occupied mode (<code>opeMod=1</code>)</h4>
The <code>TSup</code> shall be reset from <code>TSupMin</code> when the outdoor
air temperature is <code>TOutMax</code> and above, proportionally up to 
<code>TMax</code> when the outdoor air temperature is <code>TOutMin</code> and 
below. The <code>TMax</code> shall be reset using Trim-Respond logic between
<code>TSupDes</code> and <code>TSupMax</code>. Parameters suggested for the
Trim-Respond logic are shown in follow table. They would require adjustment 
during the commissioning/tuning phase.

<table summary=\"summary\" border=\"1\">
<tr><th> Variable </th> <th> Value </th> <th> Definition </th> </tr>
<tr><td>Device</td><td>AHU Supply Fan</td> <td>Associated device</td></tr>
<tr><td><code>SP0</code></td><td><code>SPmax</code></td><td>Initial setpoint</td></tr>
<tr><td><code>SPmin</code></td><td><code>TSupDes</code></td><td>Minimum setpoint</td></tr>
<tr><td><code>SPmax</code></td><td><code>TSupMax</code></td><td>Maximum setpoint</td></tr>
<tr><td><code>Td</code></td><td><code>10 minutes</code></td><td>Delay timer</td></tr>
<tr><td><code>T</code></td><td><code>2 minutes</code></td><td>Time step</td></tr>
<tr><td><code>I</code></td><td><code>2</code></td><td>Number of ignored requests</td></tr>
<tr><td><code>R</code></td><td>Zone cooling requests</td><td>Number of requests</td></tr>
<tr><td><code>SPtrim</code></td><td><code>+0.1&deg;C</code></td><td>Trim amount</td></tr>
<tr><td><code>SPres</code></td><td><code>-0.2&deg;C</code></td><td>Respond amount</td></tr>
<tr><td><code>SPres_max</code></td><td><code>-0.6&deg;C</code></td><td>Maximum response per time interval</td></tr>
</table>
<br/>

<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/Atomic/SupplyAirTemperatureSet.png\"/>
</p>

<h4>During Setup and Cool-down modes (<code>opeMod=2</code>, <code>opeMod=3</code>)</h4>
Supply air temperature setpoint <code>TSup</code> shall be <code>TSupMin</code>.

<h4>During Setback and Warmup modes (<code>opeMod=4</code>, <code>opeMod=5</code>)</h4>
Supply air temperature setpoint <code>TSup</code> shall be <code>35&deg;C</code>.

<h4>References</h4>
<p>
<a href=\"http://gpc36.savemyenergy.com/public-files/\">BSR.
<i>ASHRAE Guideline 36P, High Performance Sequences of Operation for HVAC 
systems</i>. First Public Review Draft (June 2016)</a>
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
end SupplyAirTempSet_MultiZone;
