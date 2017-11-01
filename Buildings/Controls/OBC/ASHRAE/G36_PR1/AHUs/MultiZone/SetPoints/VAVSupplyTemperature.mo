within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints;
block VAVSupplyTemperature
  "Supply air temperature setpoint for multi zone system"
  parameter Real uHeaMax(min=-0.9)=-0.25
    "Upper limit of controller signal when heating coil is off. Require -1 < uHeaMax < uCooMin < 1."
    annotation (Evaluate=true, Dialog(tab="Valve control"));
  parameter Real uCooMin(max=0.9)=0.25
    "Lower limit of controller signal when cooling coil is off. Require -1 < uHeaMax < uCooMin < 1."
    annotation (Evaluate=true, Dialog(tab="Valve control"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
      Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for supply air temperature signal"
    annotation (Evaluate=true, Dialog(tab="Valve control"));
  parameter Real kPTSup=0.05
    "Gain of controller for supply air temperature signal"
    annotation (Evaluate=true,  Dialog(tab="Valve control"));
  parameter Modelica.SIunits.Time TiTSup=300
    "Time constant of integrator block for supply temperature control signal"
    annotation (Evaluate=true, Dialog(tab="Valve control"));

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
  parameter Integer ignReq = 2
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
    annotation (Placement(transformation(extent={{-180,130},{-140,170}}),
      iconTransformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetZones(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Average of heating and cooling setpoint"
    annotation (Placement(transformation(extent={{-180,160},{-140,200}}),
      iconTransformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-180,-140},{-140,-100}}),
      iconTransformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan "Supply fan status"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod "System operation mode"
    annotation (Placement(transformation(extent={{-180,-30},{-140,10}}),
      iconTransformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement( transformation(extent={{-180,90},{-140,130}}),
      iconTransformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSetSup(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Setpoint for supply air temperature"
    annotation (Placement(transformation(extent={{140,80},{160,100}}),
      iconTransformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea(
    final min=0,
    final max=1,
    final unit="1")
    "Control signal for heating"
    annotation (Placement(transformation(extent={{140,-130},{160,-110}}),
      iconTransformation(extent={{100,-30},{120,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo(
    final min=0,
    final max=1,
    final unit="1") "Control signal for cooling"
    annotation (Placement(transformation(extent={{140,-170},{160,-150}}),
      iconTransformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput uTSup(
    final min=0,
    final max=1,
    final unit="1") "Supply temperature control signal"
    annotation (Placement(transformation(extent={{140,-90},{160,-70}}),
      iconTransformation(extent={{100,10},{120,30}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.TrimAndRespond maxSupTemRes(
    final delTim=delTim,
    final iniSet=iniSet,
    final minSet=minSet,
    final maxSet=maxSet,
    final samplePeriod=samplePeriod,
    final numIgnReq=ignReq,
    final triAmo=triAmo,
    final resAmo=resAmo,
    final maxRes=maxRes) "Maximum cooling supply temperature reset"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Line lin
  "Supply temperature distributes linearly between TSupMin and TSupMax, according to Tout"
    annotation (Placement(transformation(extent={{20,130},{40,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minOutTem(k=TOutMin)
    "Lower value of the outdoor air temperature reset range"
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxOutTem(k=TOutMax)
    "Higher value of the outdoor air temperature reset range"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minSupTem(k=TSupMin)
    "Lowest cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Check if it is in Setup or Cool-down mode"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Check if it is in Warmup or Setback mode"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupWarUpSetBac(k=35 + 273.15)
    "Supply temperature setpoint under warm-up and setback mode"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "If operation mode is setup or cool-down, setpoint shall be 35 degC"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    "If operation mode is setup or cool-down, setpoint shall be TSupMin"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Limiter TDea(
    uMax=24 + 273.15,
    uMin=21 + 273.15)
    "Limiter that outputs the dead band value for the supply air temperature"
    annotation (Placement(transformation(extent={{-100,170},{-80,190}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3 "Check output regarding supply fan status"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Controls.OBC.CDL.Integers.LessThreshold intLesThr(threshold=Constants.OperationModes.warmUp)
    "Check if operation mode index is less than warm-up mode index (4)"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(threshold=Constants.OperationModes.occupied)
    "Check if operation mode index is greater than occupied mode index (1)"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.CDL.Integers.LessThreshold intLesThr1(threshold=Constants.OperationModes.unoccupied)
    "Check if operation mode index is less than unoccupied mode index (7)"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr1(threshold=Constants.OperationModes.setUp)
    "Check if operation mode index is greater than set up mode index (3)"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTSup(
    final controllerType=controllerType,
    final k=kPTSup,
    final Ti=TiTSup,
    final yMax=1,
    final yMin=-1,
    final y_reset=0,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Disabled)
    "Controller for supply air temperature control signal (to be used by heating coil, cooling coil and economizer)"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain conSigTSupInv(final k=-1)
    "Inverts control signal"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uHeaMaxCon(
    final k=uHeaMax)
    "Constant signal to map control action"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant negOne(final k=-1)
    "Negative unity signal"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uCooMinCon(
    final k=uCooMin)
    "Constant signal to map control action"
    annotation (Placement(transformation(extent={{20,-170},{40,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Zero control signal"
    annotation (Placement(transformation(extent={{-60,-210},{-40,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1)
    "Unity signal"
    annotation (Placement(transformation(extent={{20,-210},{40,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Line conSigCoo(
    final limitBelow=true,
    final limitAbove=false)
    "Cooling control signal"
    annotation (Placement(transformation(extent={{100,-170},{120,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Line conSigHea(
    final limitBelow=false,
    final limitAbove=true)
    "Heating control signal"
    annotation (Placement(transformation(extent={{100,-130},{120,-110}})));

equation
  connect(minOutTem.y, lin.x1)
    annotation (Line(points={{-19,160},{0,160},{0,148},{18,148}},
      color={0,0,127}));
  connect(TOut, lin.u)
    annotation (Line(points={{-160,150},{-100,150},{-100,140},{18,140}},
      color={0,0,127}));
  connect(maxOutTem.y, lin.x2)
    annotation (Line(points={{-19,120},{0,120},{0,136},{18,136}},
      color={0,0,127}));
  connect(minSupTem.y, lin.f2)
    annotation (Line(points={{-79,80},{10,80},{10,132},{18,132}},
      color={0,0,127}));
  connect(and1.y, swi1.u2)
    annotation (Line(points={{41,0},{60,0},{60,40},{78,40}},
      color={255,0,255}));
  connect(TSupWarUpSetBac.y, swi1.u1)
    annotation (Line(points={{41,-30},{68,-30},{68,48},{78,48}},
      color={0,0,127}));
  connect(and2.y, swi2.u2)
    annotation (Line(points={{-19,40},{18,40}},  color={255,0,255}));
  connect(minSupTem.y, swi2.u1)
    annotation (Line(points={{-79,80},{0,80},{0,48},{18,48}},
      color={0,0,127}));
  connect(swi2.y, swi1.u3)
    annotation (Line(points={{41,40},{50,40},{50,32},{78,32}},
      color={0,0,127}));
  connect(TSetZones, TDea.u)
    annotation (Line(points={{-160,180},{-102,180}},
      color={0,0,127}));
  connect(uSupFan, swi3.u2)
    annotation (Line(points={{-160,60},{-120,60},{-120,100},{-60,100},{-60,90},
      {78,90}}, color={255,0,255}));
  connect(swi1.y, swi3.u1)
    annotation (Line(points={{101,40},{110,40},{110,70},{68,70},{68,98},{78,98}},
      color={0,0,127}));
  connect(TDea.y, swi3.u3)
    annotation (Line(points={{-79,180},{60,180},{60,82},{78,82}},
      color={0,0,127}));
  connect(intLesThr1.y, and1.u1)
    annotation (Line(points={{-19,0},{18,0}},
      color={255,0,255}));
  connect(intGreThr1.y, and1.u2)
    annotation (Line(points={{-19,-30},{0,-30},{0,-8},{18,-8}},
      color={255,0,255}));
  connect(intLesThr.y, and2.u1)
    annotation (Line(points={{-79,40},{-42,40}},  color={255,0,255}));
  connect(intGreThr.y, and2.u2)
    annotation (Line(points={{-79,10},{-60,10},{-60,32},{-42,32}},
      color={255,0,255}));
  connect(uOpeMod, intLesThr.u)
    annotation (Line(points={{-160,-10},{-120,-10},{-120,40},{-102,40}},
      color={255,127,0}));
  connect(uOpeMod, intGreThr.u)
    annotation (Line(points={{-160,-10},{-120,-10},{-120,10},{-102,10}},
      color={255,127,0}));
  connect(uOpeMod, intLesThr1.u)
    annotation (Line(points={{-160,-10},{-60,-10},{-60,0},{-42,0}},
      color={255,127,0}));
  connect(uOpeMod, intGreThr1.u)
    annotation (Line(points={{-160,-10},{-120,-10},{-120,-30},{-42,-30}},
      color={255,127,0}));
  connect(lin.y, swi2.u3)
    annotation (Line(points={{41,140},{50,140},{50,60},{8,60},{8,32},{18,32}},
      color={0,0,127}));
  connect(uZonTemResReq, maxSupTemRes.numOfReq)
    annotation (Line(points={{-160,110},{-112,110},{-112,112},{-102,112}},
      color={255,127,0}));
  connect(uSupFan, maxSupTemRes.uDevSta)
    annotation (Line(points={{-160,60},{-120,60},{-120,128},{-102,128}},
      color={255,0,255}));
  connect(maxSupTemRes.y, lin.f1)
    annotation (Line(points={{-79,120},{-60,120},{-60,144},{18,144}},
      color={0,0,127}));
  connect(swi3.y, TSetSup)
    annotation (Line(points={{101,90},{150,90}}, color={0,0,127}));
  connect(conTSup.y, conSigTSupInv.u)
    annotation (Line(points={{-79,-80},{-62,-80}}, color={0,0,127}));
  connect(conSigTSupInv.y, swi.u1)
    annotation (Line(points={{-39,-80},{-20,-80},{-20,-72},{18,-72}},
      color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{-39,-200},{-20,-200},{-20,-88},{18,-88}},
      color={0,0,127}));
  connect(uSupFan, swi.u2)
    annotation (Line(points={{-160,60},{-126,60},{-126,-60},{0,-60},{0,-80},
      {18,-80}}, color={255,0,255}));
  connect(swi3.y, conTSup.u_s)
    annotation (Line(points={{101,90},{120,90},{120,-56},{-120,-56},{-120,-80},
          {-102,-80}},
                   color={0,0,127}));
  connect(TSup, conTSup.u_m)
    annotation (Line(points={{-160,-120},{-90,-120},{-90,-92}}, color={0,0,127}));
  connect(negOne.y, conSigHea.x1)
    annotation (Line(points={{-39,-120},{0,-120},{0,-100},{80,-100},{80,-112},
      {98,-112}}, color={0,0,127}));
  connect(one.y, conSigHea.f1)
    annotation (Line(points={{41,-200},{80,-200},{80,-116},{98,-116}},
      color={0,0,127}));
  connect(swi.y, conSigHea.u)
    annotation (Line(points={{41,-80},{70,-80},{70,-120},{98,-120}},
      color={0,0,127}));
  connect(swi.y, conSigCoo.u)
    annotation (Line(points={{41,-80},{70,-80},{70,-160},{98,-160}},
      color={0,0,127}));
  connect(uHeaMaxCon.y, conSigHea.x2)
    annotation (Line(points={{41,-120},{60,-120},{60,-124},{98,-124}},
      color={0,0,127}));
  connect(zer.y, conSigHea.f2)
    annotation (Line(points={{-39,-200},{-20,-200},{-20,-140},{60,-140},{60,-128},
      {98,-128}}, color={0,0,127}));
  connect(uCooMinCon.y, conSigCoo.x1)
    annotation (Line(points={{41,-160},{50,-160},{50,-152},{98,-152}},
      color={0,0,127}));
  connect(zer.y, conSigCoo.f1)
    annotation (Line(points={{-39,-200},{-20,-200},{-20,-140},{60,-140},{60,-156},
      {98,-156}}, color={0,0,127}));
  connect(one.y, conSigCoo.x2)
    annotation (Line(points={{41,-200},{80,-200},{80,-164},{98,-164}},
      color={0,0,127}));
  connect(one.y, conSigCoo.f2)
    annotation (Line(points={{41,-200},{80,-200},{80,-168},{98,-168}},
      color={0,0,127}));
  connect(conSigHea.y, yHea)
    annotation (Line(points={{121,-120},{150,-120}}, color={0,0,127}));
  connect(conSigCoo.y, yCoo)
    annotation (Line(points={{121,-160},{150,-160}}, color={0,0,127}));
  connect(swi.y, uTSup)
    annotation (Line(points={{41,-80},{150,-80}}, color={0,0,127}));

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
          extent={{-96,58},{-68,46}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TOut"),
        Text(
          extent={{-94,-32},{-14,-68}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uZonTemResReq"),
        Text(
          extent={{-94,-8},{-48,-32}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uSupFan"),
        Text(
          extent={{-94,-70},{-50,-90}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{68,68},{96,52}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSetSup"),
        Text(
          extent={{-124,146},{96,108}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-96,28},{-64,14}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{74,26},{96,14}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uTSup"),
        Text(
          extent={{76,-12},{96,-22}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yHea"),
        Text(
          extent={{76,-54},{96,-64}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCoo")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-220},{140,200}})),
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

<h4>During occupied mode (<code>opeMod=1</code>)</h4>
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
<tr><td>SP0</td><td>SPmax</td><td>Initial setpoint</td></tr>
<tr><td>SPmin</td><td>TSupDes</td><td>Minimum setpoint</td></tr>
<tr><td>SPmax</td><td>TSupMax</td><td>Maximum setpoint</td></tr>
<tr><td>Td</td><td>10 minutes</td><td>Delay timer</td></tr>
<tr><td>T</td><td>2 minutes</td><td>Time step</td></tr>
<tr><td>I</td><td>2</td><td>Number of ignored requests</td></tr>
<tr><td>R</td><td>Zone cooling requests</td><td>Number of requests</td></tr>
<tr><td>SPtrim</td><td>+0.1&deg;C</td><td>Trim amount</td></tr>
<tr><td>SPres</td><td>-0.2&deg;C</td><td>Respond amount</td></tr>
<tr><td>SPres_max</td><td>-0.6&deg;C</td><td>Maximum response per time interval</td></tr>
</table>
<br/>

<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/VAVMultiZoneSupTempSet.png\"/>
</p>

<h4>During Setup and Cool-down modes (<code>opeMod=2</code>, <code>opeMod=3</code>)</h4>
<p>
Supply air temperature setpoint <code>TSetSup</code> shall be <code>TSupMin</code>.
</p>
<h4>During Setback and Warmup modes (<code>opeMod=4</code>, <code>opeMod=5</code>)</h4>
<p>
Supply air temperature setpoint <code>TSetSup</code> shall be <code>35&deg;C</code>.
</p>

<h4>Valves control</h4>
<p>
Supply air temperature shall be controlled to setpoint using a control loop whose
output is mapped to sequence the hot water valve or modulating electric heating
coil (if applicable), chilled water valves.
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
