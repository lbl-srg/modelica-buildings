within Buildings.Controls.OBC.ChilledBeams.SetPoints;
block ChilledWaterStaticPressureSetpointReset
  "Sequence to generate static pressure setpoint for chilled water loop"

  parameter Integer nVal(
    final min=1)
    "Number of chilled water control valves on chilled beam manifolds";

  parameter Integer nPum(
    final min=1)
    "Number of chilled water pumps in chilled beam system";

  parameter Real valPosLowClo(
    final unit="1",
    displayUnit="1") = 0.45
    "Lower limit for sending one request to Trim-and-Respond logic"
    annotation(Dialog(group="Control valve parameters"));

  parameter Real valPosLowOpe(
    final unit="1",
    displayUnit="1") = 0.5
    "Upper limit for sending one request to Trim-and-Respond logic"
    annotation(Dialog(group="Control valve parameters"));

  parameter Real valPosHigClo(
    final unit="1",
    displayUnit="1") = 0.95
    "Lower limit for sending two requests to Trim-and-Respond logic"
    annotation(Dialog(group="Control valve parameters"));

  parameter Real valPosHigOpe(
    final unit="1",
    displayUnit="1") = 0.99
    "Upper limit for sending two requests to Trim-and-Respond logic"
    annotation(Dialog(group="Control valve parameters"));

  parameter Real chiWatStaPreMax(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="Pressure")
    "Maximum chilled water loop static pressure setpoint"
    annotation(Dialog(group="Trim-and-Respond parameters"));

  parameter Real chiWatStaPreMin(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="Pressure")
    "Minimum chilled water loop static pressure setpoint"
    annotation(Dialog(group="Trim-and-Respond parameters"));

  parameter Real triAmoVal(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference") = -500
    "Static pressure trim amount"
    annotation(Dialog(group="Trim-and-Respond parameters"));

  parameter Real resAmoVal(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference") = 750
    "Static pressure respond amount"
    annotation(Dialog(group="Trim-and-Respond parameters"));

  parameter Real maxResVal(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference") = 1000
    "Static pressure maximum respond amount"
    annotation(Dialog(group="Trim-and-Respond parameters"));

  parameter Real samPerVal(
    final unit="s",
    displayUnit="s",
    final quantity="Duration") = 30
    "Sample period duration"
    annotation(Dialog(group="Trim-and-Respond parameters"));

  parameter Real delTimVal(
    final unit="s",
    displayUnit="min",
    final quantity="Duration") = 120
    "Delay period duration"
    annotation(Dialog(group="Trim-and-Respond parameters"));

  parameter Real thrTimLow(
    final unit="s",
    displayUnit="s",
    final quantity="Duration") = 60
    "Threshold time for generating one request"
    annotation(Dialog(group="Control valve parameters"));

  parameter Real thrTimHig(
    final unit="s",
    displayUnit="s",
    final quantity="Duration") = 30
    "Threshold time for generating two requests"
    annotation(Dialog(group="Control valve parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPumSta[nPum]
    "Pump proven on signal"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uValPos[nVal](
    final unit = fill("1", nVal),
    displayUnit = fill("1", nVal))
    "Chilled water control valve position on chilled beams"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaPreSetPoi(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    "Static pressure setpoint for pumps"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Timer tim[nVal](
    final t=fill(thrTimLow, nVal))
    "Check if threshold time for generating one request has been exceeded"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim1[nVal](
    final t=fill(thrTimHig, nVal))
    "Check if threshold time for generating two requests has been exceeded"
    annotation (Placement(transformation(extent={{-50,-80},{-30,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1[nVal](
    final uLow=fill(valPosLowClo, nVal),
    final uHigh=fill(valPosLowOpe, nVal))
    "Check if chilled water control valve is at limit required to send one request"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nPum)
    "Check if any chilled water pump is enabled"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2[nVal](
    final uLow=fill(valPosHigClo, nVal),
    final uHigh=fill(valPosHigOpe, nVal))
    "Check if chilled water control valve is at limit required to send two requests"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Boolean to Integer conversion"
    annotation (Placement(transformation(extent={{10,-40},{30,-20}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nin=nVal)
    "Multi or"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr2(
    final nin=nVal)
    "Multi or"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1(
    final integerTrue=2)
    "Boolean to Integer conversion"
    annotation (Placement(transformation(extent={{10,-80},{30,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    "Find maximum integer output"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Buildings.Controls.OBC.ASHRAE.G36.Generic.TrimAndRespond triRes(
    final iniSet=chiWatStaPreMax,
    final minSet=chiWatStaPreMin,
    final maxSet=chiWatStaPreMax,
    final delTim=delTimVal,
    final samplePeriod=samPerVal,
    final numIgnReq=0,
    final triAmo=triAmoVal,
    final resAmo=resAmoVal,
    final maxRes=maxResVal)
    "Trim and respond controller for chilled water static pressure setpoint"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));

equation

  connect(uValPos, hys1.u) annotation (Line(points={{-120,-50},{-90,-50},{-90,-30},
          {-82,-30}},color={0,0,127}));

  connect(uValPos, hys2.u) annotation (Line(points={{-120,-50},{-90,-50},{-90,-70},
          {-82,-70}},color={0,0,127}));

  connect(mulOr1.y, booToInt.u)
    annotation (Line(points={{2,-30},{8,-30}},     color={255,0,255}));

  connect(mulOr2.y, booToInt1.u)
    annotation (Line(points={{2,-70},{8,-70}},     color={255,0,255}));

  connect(booToInt.y, maxInt.u1) annotation (Line(points={{32,-30},{36,-30},{36,
          -44},{38,-44}},
                    color={255,127,0}));

  connect(booToInt1.y, maxInt.u2) annotation (Line(points={{32,-70},{36,-70},{36,
          -56},{38,-56}},
                    color={255,127,0}));

  connect(maxInt.y, triRes.numOfReq) annotation (Line(points={{62,-50},{66,-50},
          {66,-8},{68,-8}}, color={255,127,0}));

  connect(triRes.y, yStaPreSetPoi)
    annotation (Line(points={{92,0},{120,0}}, color={0,0,127}));

  connect(uPumSta, mulOr.u[1:nPum]) annotation (Line(points={{-120,50},{-102,50},
          {-102,50},{-82,50}},
                             color={255,0,255}));
  connect(mulOr.y, triRes.uDevSta) annotation (Line(points={{-58,50},{66,50},{66,
          8},{68,8}}, color={255,0,255}));
  connect(hys1.y, tim.u)
    annotation (Line(points={{-58,-30},{-52,-30}}, color={255,0,255}));
  connect(tim.passed, mulOr1.u[1:nVal]) annotation (Line(points={{-28,-38},{-26,-38},
          {-26,-30},{-22,-30}},           color={255,0,255}));
  connect(hys2.y, tim1.u)
    annotation (Line(points={{-58,-70},{-52,-70}}, color={255,0,255}));
  connect(tim1.passed, mulOr2.u[1:nVal]) annotation (Line(points={{-28,-78},{-24,-78},
          {-24,-70},{-22,-70}},           color={255,0,255}));
annotation(defaultComponentName="chiWatStaPreSetRes",
  Icon(coordinateSystem(preserveAspectRatio=false),
          graphics={
            Text(
              extent={{-100,150},{100,110}},
              lineColor={0,0,255},
              textString="%name"),
            Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,48},{-60,32}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uPumSta"),
        Text(
          extent={{-96,-32},{-60,-48}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uValPos"),
        Text(
          extent={{44,16},{98,-14}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yStaPreSetPoi")}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Sequences for calculating chilled water static pressure setpoint in chilled beam 
systems.
</p>
<p>
The trim-and-respond logic is activated if any of the chilled water control valves 
<code>uValPos</code> are open greater than <code>valPosOpe</code> and deactivated
if less than <code>valPosClo</code>. The requests for static pressure reset are
generated as follows:
<ul>
<li>
one request is generated if a control valve is open greater than <code>valPosLowOpe</code>
for <code>thrTimLow</code> continuously.
</li>
<li>
two requests are generated if a control valve is open greater than <code>valPosHigOpe</code>
for <code>thrTimHig</code> continuously.
</li>
<li>
no requests are generated otherwise.
</li>
</ul>
</p>
<p>
The trim-and-respond parameters are as follows:
<br>
<table summary=\"summary\" border=\"1\">
  <tr><th> Variable </th> <th> Value </th> <th> Definition </th> </tr>
  <tr><td>Device</td><td>Any chilled water pump</td> <td>Associated device</td></tr>
  <tr><td>iniSet</td><td><code>chiWatStaPreMax</code></td><td>Initial setpoint</td></tr>
  <tr><td>minSet</td><td><code>chiWatStaPreMin</code></td><td>Minimum setpoint</td></tr>
  <tr><td>maxSet</td><td><code>chiWatStaPreMax</code></td><td>Maximum setpoint</td></tr>
  <tr><td>delTim</td><td><code>delTimVal</code></td><td>Delay timer</td></tr>
  <tr><td>samplePeriod</td><td><code>samPerVal</code></td><td>Time step</td></tr>
  <tr><td>numIgnReq</td><td><code>0</code></td><td>Number of ignored requests</td></tr>
  <tr><td>triAmo</td><td><code>triAmoVal</code></td><td>Trim amount</td></tr>
  <tr><td>resAmo</td><td><code>resAmoVal</code></td><td>Respond amount</td></tr>
  <tr><td>maxRes</td><td><code>maxResVal</code></td><td>Maximum response per time interval</td></tr>
</table>
</p>
</html>",
revisions="<html>
<ul>
<li>
June 16, 2021, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChilledWaterStaticPressureSetpointReset;
