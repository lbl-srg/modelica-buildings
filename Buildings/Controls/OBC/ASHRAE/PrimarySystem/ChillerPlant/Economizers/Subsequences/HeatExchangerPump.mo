within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences;
block HeatExchangerPump
  "Pump control for economizer when the chilled water flow is controlled by a variable speed heat exchanger pump"
  parameter Real minSpe = 0.1 "Minimum pump speed";
  parameter Real desSpe = 0.9 "Design pump speed";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-200,120},{-160,160}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE
    "True: waterside economizer is enabled"
    annotation (Placement(transformation(extent={{-200,90},{-160,130}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPum
    "True: heat exchanger pump is proven on"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEntWSE(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature upstream of the economizer"
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEntHex(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water temperature entering heat exchanger"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatIsoVal(
    final min=0,
    final max=1,
    final unit="1") "Economizer condensing water isolation valve position"
    annotation (Placement(transformation(extent={{160,90},{200,130}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumOn
    "Heat exchanger pump command on"
    annotation (Placement(transformation(extent={{160,50},{200,90}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPumSpe(
    final min=0,
    final max=1,
    final unit="1") "Heat exchanger pump speed setpoint"
    annotation (Placement(transformation(extent={{160,10},{200,50}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal conWatIso
    "Condensing water isolation valve position"
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub "Temperature difference"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=1.11,
    final h=0.44)
    "Check if the temperature difference is greater than 2 degF (1.11 degK)"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1(
    final t=0.56,
    final h=0.45)
    "Check if the temperature difference is greater than 1 degF (0.56 degK)"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Switch resSpeReq1
    "Pump speed reset request"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant two(
    final k=2) "Constant two"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant one(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Buildings.Controls.OBC.CDL.Integers.Switch resSpeReq
    "Pump speed reset request"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.TrimAndRespond resSpe(
    final iniSet=desSpe,
    final minSet=minSpe,
    final maxSet=desSpe,
    final delTim=900,
    final samplePeriod=120,
    final numIgnReq=0,
    final triAmo=0.02,
    final resAmo=-0.03,
    final maxRes=-0.06)
    "Reset pump speed"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul "Pump Speed"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Waterside economizer commanded on"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
equation
  connect(conWatIso.y, yConWatIsoVal)
    annotation (Line(points={{62,110},{180,110}}, color={0,0,127}));
  connect(TEntWSE, sub.u1) annotation (Line(points={{-180,20},{-150,20},{-150,-4},
          {-142,-4}}, color={0,0,127}));
  connect(TEntHex, sub.u2) annotation (Line(points={{-180,-40},{-150,-40},{-150,
          -16},{-142,-16}}, color={0,0,127}));
  connect(sub.y, greThr.u)
    annotation (Line(points={{-118,-10},{-102,-10}}, color={0,0,127}));
  connect(sub.y, greThr1.u) annotation (Line(points={{-118,-10},{-110,-10},{-110,
          -90},{-102,-90}}, color={0,0,127}));
  connect(greThr1.y, resSpeReq1.u2)
    annotation (Line(points={{-78,-90},{-42,-90}}, color={255,0,255}));
  connect(zer.y, resSpeReq1.u3) annotation (Line(points={{-78,-130},{-60,-130},{
          -60,-98},{-42,-98}}, color={255,127,0}));
  connect(greThr.y, resSpeReq.u2)
    annotation (Line(points={{-78,-10},{18,-10}},color={255,0,255}));
  connect(two.y, resSpeReq.u1) annotation (Line(points={{-78,30},{0,30},{0,-2},{
          18,-2}},   color={255,127,0}));
  connect(resSpeReq1.y, resSpeReq.u3) annotation (Line(points={{-18,-90},{0,-90},
          {0,-18},{18,-18}},  color={255,127,0}));
  connect(one.y, resSpeReq1.u1) annotation (Line(points={{-78,-50},{-60,-50},{-60,
          -82},{-42,-82}}, color={255,127,0}));
  connect(resSpeReq.y,resSpe. numOfReq) annotation (Line(points={{42,-10},{50,-10},
          {50,-18},{58,-18}}, color={255,127,0}));
  connect(uPum,resSpe. uDevSta) annotation (Line(points={{-180,60},{50,60},{50,-2},
          {58,-2}}, color={255,0,255}));
  connect(resSpe.y, mul.u2) annotation (Line(points={{82,-10},{100,-10},{100,24},
          {118,24}},color={0,0,127}));
  connect(conWatIso.y, mul.u1) annotation (Line(points={{62,110},{100,110},{100,
          36},{118,36}}, color={0,0,127}));
  connect(mul.y, yPumSpe)
    annotation (Line(points={{142,30},{180,30}}, color={0,0,127}));
  connect(uWSE, and1.u1)
    annotation (Line(points={{-180,110},{-102,110}}, color={255,0,255}));
  connect(and1.y, conWatIso.u)
    annotation (Line(points={{-78,110},{38,110}}, color={255,0,255}));
  connect(and1.y, yPumOn) annotation (Line(points={{-78,110},{20,110},{20,70},{180,
          70}}, color={255,0,255}));
  connect(uPla, and1.u2) annotation (Line(points={{-180,140},{-120,140},{-120,102},
          {-102,102}}, color={255,0,255}));
annotation (defaultComponentName = "wsePum",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,160}})),
  Documentation(info="<html>
<p>
It implements the control of the waterside economizer valves when the chilled water
flow through the economizer is controlled by variable speed heat exchanger pump.
It is implemented according to ASHRAE Guideline36-2021, section 5.20.3.7-10. 
</p>
<p>
When economizer is enabled (<code>uWSE=true</code>), start next condenser water
pump and (or) adjust the pump speed
(see <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller</a>),
open the condenser water isolation valve to the heat exchanger (<codE>yConWatIsoVal=1</code>),
and enable the chilled water heat exchanger pump.
</p>
<p>
The economizer heat exchanger pump speed reset requests shall be generated based
on the difference between chilled water return temperature upstream of the economizer
and economizer heat exchanger entering chilled water temperature.
</p>
<ol>
<li>
If the temperature difference exceeeds 2 &deg;F (1.11 &deg;K), send 2 requests
until the difference is less than 1.2 &deg;F (0.67 &deg;F).
</li>
<li>
Else if the temperature difference exceeds 1 &deg;F (0.56 &deg;K), send 1 request
until the difference is less than 0.2 &deg;F (0.11 &deg;K).
</li>
<li>
Else send 0 requests.
</li>
</ol>
<p>
When the heat exchanger pump is proven on, the pump speed shall be reset using
Trim and Respond logic with the following parameters:
</p>

<table summary=\"summary\" border=\"1\">
<tr><th> Variable </th> <th> Value </th> <th> Definition </th> </tr>
<tr><td>Device</td><td>Economizer heat exchanger pump proven on</td> <td>Associated device</td></tr>
<tr><td>SP0</td><td>Pump design speed (<code>desSpe</code>)</td><td>Initial setpoint</td></tr>
<tr><td>SPmin</td><td>Pump minimum speed (<code>minSpe</code>)</td><td>Minimum setpoint</td></tr>
<tr><td>SPmax</td><td>Pump design speed (<code>desSpe</code>)</td><td>Maximum setpoint</td></tr>
<tr><td>Td</td><td>15 minutes</td><td>Delay timer</td></tr>
<tr><td>T</td><td>2 minutes</td><td>Time step</td></tr>
<tr><td>I</td><td>0</td><td>Number of ignored requests</td></tr>
<tr><td>R</td><td>Pump speed reset requests</td><td>Number of requests</td></tr>
<tr><td>SPtrim</td><td>2%</td><td>Trim amount</td></tr>
<tr><td>SPres</td><td>-3%</td><td>Respond amount</td></tr>
<tr><td>SPres_max</td><td>-6%</td><td>Maximum response per time interval</td></tr>
</table>
<br/>

<p>
When economizer is disabled (<code>uWSE=false</code>), the chilled water heat
exchanger pump shall be disabled, the heat exchanger condenser water isolation
valve fully closed (<codE>yConWatIsoVal=0</code>), and the last lag condenser water pump disabled
and (or) change the pump speed 
see <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller</a>).
</p>
</html>",
revisions="<html>
<ul>
<li>
July 14, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatExchangerPump;
