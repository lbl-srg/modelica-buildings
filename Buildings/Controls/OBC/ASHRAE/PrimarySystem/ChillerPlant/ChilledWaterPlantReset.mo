within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block ChilledWaterPlantReset
  "Sequences to generate chilled water plant reset"

  parameter Integer num = 2 "Total number of chilled water pumps";
  parameter Modelica.SIunits.Time holTim = 900
    "Time to fix plant reset value";
  parameter Real iniSet = 0 "Initial setpoint"
    annotation (Dialog(group="Trim and respond parameters"));
  parameter Real minSet = 0 "Minimum setpoint"
    annotation (Dialog(group="Trim and respond parameters"));
  parameter Real maxSet = 1 "Maximum setpoint"
    annotation (Dialog(group="Trim and respond parameters"));
  parameter Modelica.SIunits.Time delTim = 900
    "Delay time after which trim and respond is activated"
    annotation (Dialog(group="Trim and respond parameters"));
  parameter Modelica.SIunits.Time samplePeriod = 300
    "Sample period time"
    annotation (Dialog(group="Trim and respond parameters"));
  parameter Integer numIgnReq = 2
    "Number of ignored requests"
    annotation (Dialog(group="Trim and respond parameters"));
  parameter Real triAmo = -0.02 "Trim amount"
    annotation (Dialog(group="Trim and respond parameters"));
  parameter Real resAmo = 0.03
    "Respond amount (must be opposite in to triAmo)"
    annotation (Dialog(group="Trim and respond parameters"));
  parameter Real maxRes = 0.07
    "Maximum response per time interval (same sign as resAmo)"
    annotation (Dialog(group="Trim and respond parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput TChiWatSupResReq
    "Cooling chilled water supply temperature setpoint reset request"
    annotation (Placement(transformation(extent={{-180,10},{-140,50}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Chiller stage"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[num]
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatPlaRes(
    final min=0,
    final max=1,
    final unit="1") "Chilled water plant reset"
    annotation (Placement(transformation(extent={{120,-10},{140,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.TrimAndRespond triRes(
    final iniSet=iniSet,
    final minSet=minSet,
    final maxSet=maxSet,
    final delTim=delTim,
    final samplePeriod=samplePeriod,
    final numIgnReq=numIgnReq,
    final triAmo=triAmo,
    final resAmo=resAmo,
    final maxRes=maxRes) "Calculate chilled water plant reset"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "Sample last reset value when there is chiller stage change"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Check if the input changes from false to true"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Logical.TrueHoldWithReset truHol(
    final duration=holTim)
    "Hold the true input with given time"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Switch plant reset value depends on if there is chiller stage change"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Integers.Change cha
    "Check if there is chiller stage change"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Not not1[num] "Logical not"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nu=num) "Logical and"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

equation
  connect(not1.y, mulAnd.u)
    annotation (Line(points={{-99,60},{-82,60}}, color={255,0,255}));
  connect(TChiWatSupResReq, triRes.numOfReq)
    annotation (Line(points={{-160,30},{-10,30},{-10,52},{-2,52}},
      color={255,127,0}));
  connect(mulAnd.y, not2.u)
    annotation (Line(points={{-58.3,60},{-42,60}}, color={255,0,255}));
  connect(not2.y, triRes.uDevSta)
    annotation (Line(points={{-19,60},{-10,60},{-10,68},{-2,68}},
      color={255,0,255}));
  connect(uChiWatPum, not1.u)
    annotation (Line(points={{-160,60},{-122,60}}, color={255,0,255}));
  connect(triRes.y, triSam.u)
    annotation (Line(points={{21,60},{38,60}}, color={0,0,127}));
  connect(truHol.y, swi.u2)
    annotation (Line(points={{41,0},{78,0}}, color={255,0,255}));
  connect(triRes.y, swi.u3)
    annotation (Line(points={{21,60},{30,60},{30,80},{66,80},{66,-8},
      {78,-8}}, color={0,0,127}));
  connect(triSam.y, swi.u1)
    annotation (Line(points={{61,60},{70,60},{70,8},{78,8}}, color={0,0,127}));
  connect(swi.y, yChiWatPlaRes)
    annotation (Line(points={{101,0},{130,0}}, color={0,0,127}));
  connect(edg.y, triSam.trigger)
    annotation (Line(points={{41,30},{50,30},{50,48.2}}, color={255,0,255}));
  connect(uChiSta, cha.u)
    annotation (Line(points={{-160,0},{-142,0},{-142,0},{-122,0}},
      color={255,127,0}));
  connect(cha.y, truHol.u)
    annotation (Line(points={{-99,0},{19,0}}, color={255,0,255}));
  connect(cha.y, edg.u)
    annotation (Line(points={{-99,0},{0,0},{0,30},{18,30}},
        color={255,0,255}));

annotation (
  defaultComponentName="chiWatPlaRes",
  Diagram(coordinateSystem(preserveAspectRatio=false,
  extent={{-140,-60},{120,100}}), graphics={Rectangle(
          extent={{-138,18},{98,-58}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Rectangle(
          extent={{-138,98},{98,22}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Text(
          extent={{10,-46},{94,-58}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255},
          textString="Check if there is chiller stage change"),
          Text(
          extent={{-70,100},{82,84}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Calculate the plant reset, hold its last value when there is chiller stage change")}),
  Icon(graphics={Text(
          extent={{-100,150},{100,110}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-92,68},{-34,56}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiWatPum"),
        Text(
          extent={{-94,12},{-10,-10}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TChiWatSupResReq"),
        Text(
          extent={{-94,-52},{-56,-66}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiSta"),
        Text(
          extent={{38,12},{96,-12}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiWatPlaRes")}),
Documentation(info="<html>
<p>
Block that output chilled water plant reset <code>yChiWatPlaRes</code> according
to ASHRAE Fundamentals of Chilled Water Plant 
Design and Control SDL, Chapter 7, Appendix B, 1.01.B.10.
</p>
<p>
a. Chilled water plant reset <code>yChiWatPlaRes</code> shall be reset 
using trim-respond logic with following parameters:
</p>
<table summary=\"summary\" border=\"1\">
<tr><th> Variable </th> <th> Value </th> <th> Definition </th> </tr>
<tr><td>Device</td><td>Any chilled water pump</td> <td>Associated device</td></tr>
<tr><td>SP0</td><td><code>iniSet</code></td><td>Initial setpoint</td></tr>
<tr><td>SPmin</td><td><code>minSet</code></td><td>Minimum setpoint</td></tr>
<tr><td>SPmax</td><td><code>maxSet</code></td><td>Maximum setpoint</td></tr>
<tr><td>Td</td><td><code>delTim</code></td><td>Delay timer</td></tr>
<tr><td>T</td><td><code>samplePeriod</code></td><td>Time step</td></tr>
<tr><td>I</td><td><code>numIgnReq</code></td><td>Number of ignored requests</td></tr>
<tr><td>R</td><td><code>TChiWatSupResReq</code></td><td>Number of requests</td></tr>
<tr><td>SPtrim</td><td><code>triAmo</code></td><td>Trim amount</td></tr>
<tr><td>SPres</td><td><code>resAmo</code></td><td>Respond amount</td></tr>
<tr><td>SPres_max</td><td><code>maxRes</code></td><td>Maximum response per time interval</td></tr>
</table>
<br/>
<p>
b. Chilled water plant reset <code>yChiWatPlaRes</code> shall be disabled and 
value fixed at its last value for <code>holTim</code> after the plant stages
<code>uChiSta</code> up or down.
</p>
</html>", revisions="<html>
<ul>
<li>
March 14, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChilledWaterPlantReset;
