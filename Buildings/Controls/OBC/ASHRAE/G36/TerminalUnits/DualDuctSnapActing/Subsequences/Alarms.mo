within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences;
block Alarms "Generate alarms of snap-acting controlled dual-duct terminal unit"

  parameter Real staPreMul
    "Importance multiplier for the zone static pressure reset control loop";
  parameter Real hotWatRes
    "Importance multiplier for the hot water reset control loop";
  parameter Real VCooZonMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone cooling maximum airflow rate";
  parameter Real lowFloTim(
    final unit="s",
    final quantity="Time")=300
    "Threshold time to check low flow rate";
  parameter Real fanOffTim(
    final unit="s",
    final quantity="Time")=600
    "Threshold time to check fan off";
  parameter Real leaFloTim(
    final unit="s",
    final quantity="Time")=600
    "Threshold time to check damper leaking airflow";
  parameter Real floHys(
    final quantity="VolumeFlowRate",
    final unit="m3/s")=0.05
    "Near zero flow rate, below which the flow rate or difference will be seen as zero"
    annotation (Dialog(tab="Advanced"));
  parameter Real damPosHys(
    final unit="1")=0.05
    "Near zero damper position, below which the damper will be seen as closed"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured discharge airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-280,160},{-240,200}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active airflow setpoint"
    annotation (Placement(transformation(extent={{-280,80},{-240,120}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan
    "AHU supply fan status"
    annotation (Placement(transformation(extent={{-280,-110},{-240,-70}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDam(
    final min=0,
    final unit="1") "Actual damper position"
    annotation (Placement(transformation(extent={{-280,-220},{-240,-180}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowFloAla
    "Low airflow alarms"
    annotation (Placement(transformation(extent={{240,100},{280,140}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFloSenAla
    "Airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{240,-50},{280,-10}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaDamAla
    "Leaking damper alarm"
    annotation (Placement(transformation(extent={{240,-180},{280,-140}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=0.5)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-180,140},{-160,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Less les(
    final h=floHys)
    "Check if measured airflow is less than threshold"
    annotation (Placement(transformation(extent={{-120,170},{-100,190}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=lowFloTim)
    "Check if the measured airflow has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final h=floHys)
    "Check if setpoint airflow is greater than zero"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre(
    final h=floHys)
    "Check if measured airflow is less than threshold"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=0.7)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-180,60},{-160,80}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=lowFloTim)
    "Check if the measured airflow has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Measured airflow has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Measured airflow has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Integers.Switch lowFloAla
    "Low airflow alarm"
    annotation (Placement(transformation(extent={{140,170},{160,190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=2)
    "Level 2 alarm"
    annotation (Placement(transformation(extent={{80,210},{100,230}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(
    final integerTrue=3)
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conInt1(
    final k=staPreMul)
    "Importance multiplier for zone static pressure reset"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1
    "Check if the multiplier is greater than zero"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Suppress the alarm when multiplier is zero"
    annotation (Placement(transformation(extent={{140,0},{160,20}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt
    "Low flow alarms"
    annotation (Placement(transformation(extent={{200,110},{220,130}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Warning: airflow is less than 50% of the setpoint.")
    "Level 2 low airflow alarm"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Logical and"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(
    final message="Warning: airflow is less than 70% of the setpoint.")
    "Level 3 low airflow alarm"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooMaxFlo(
    final k=VCooZonMax_flow)
    "Cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(
    final k=0.1)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical not"
    annotation (Placement(transformation(extent={{-200,-100},{-180,-80}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=fanOffTim)
    "Check if the supply fan has been OFF more than threshold time"
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre1(
    final h=floHys)
    "Check if measured airflow is greater than threshold"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Logical and"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4
    "Logical not"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes2(
    final message="Warning: airflow sensor should be calibrated.")
    "Level 3 airflow sensor alarm"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2(
    final integerTrue=3)
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{140,-40},{160,-20}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(
    final delayTime=leaFloTim)
    "Check if the air flow is above threshold by more than threshold time"
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold cloDam(
    final t=damPosHys,
    final h=0.5*damPosHys) "Check if damper position is near zero"
    annotation (Placement(transformation(extent={{-200,-210},{-180,-190}})));
  Buildings.Controls.OBC.CDL.Logical.And3 leaDamAla
    "Check if generating leak damper alarms"
    annotation (Placement(transformation(extent={{40,-170},{60,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5 "Logical not"
    annotation (Placement(transformation(extent={{100,-210},{120,-190}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes3(
    final message="Warning: the damper is leaking.")
    "Level 4 leaking damper alarm"
    annotation (Placement(transformation(extent={{140,-210},{160,-190}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3(
    final integerTrue=4)
    "Convert boolean true to level 4 alarm"
    annotation (Placement(transformation(extent={{140,-170},{160,-150}})));

equation
  connect(VActSet_flow, gai.u) annotation (Line(points={{-260,100},{-200,100},{-200,
          150},{-182,150}},  color={0,0,127}));
  connect(VDis_flow, les.u1)
    annotation (Line(points={{-260,180},{-122,180}}, color={0,0,127}));
  connect(gai.y, les.u2) annotation (Line(points={{-158,150},{-140,150},{-140,172},
          {-122,172}}, color={0,0,127}));
  connect(les.y, truDel.u)
    annotation (Line(points={{-98,180},{-82,180}}, color={255,0,255}));
  connect(VActSet_flow, greThr.u)
    annotation (Line(points={{-260,100},{-182,100}}, color={0,0,127}));
  connect(VActSet_flow, gai1.u) annotation (Line(points={{-260,100},{-200,100},{
          -200,70},{-182,70}},    color={0,0,127}));
  connect(VDis_flow, gre.u2) annotation (Line(points={{-260,180},{-220,180},{-220,
          42},{-122,42}},        color={0,0,127}));
  connect(gai1.y, gre.u1) annotation (Line(points={{-158,70},{-140,70},{-140,50},
          {-122,50}},       color={0,0,127}));
  connect(gre.y, truDel1.u)
    annotation (Line(points={{-98,50},{-82,50}},   color={255,0,255}));
  connect(truDel.y, and2.u1)
    annotation (Line(points={{-58,180},{-42,180}}, color={255,0,255}));
  connect(greThr.y, and2.u2) annotation (Line(points={{-158,100},{-50,100},{-50,
          172},{-42,172}}, color={255,0,255}));
  connect(greThr.y, and1.u1)
    annotation (Line(points={{-158,100},{-42,100}}, color={255,0,255}));
  connect(truDel1.y, and1.u2) annotation (Line(points={{-58,50},{-50,50},{-50,92},
          {-42,92}},       color={255,0,255}));
  connect(and2.y, lowFloAla.u2)
    annotation (Line(points={{-18,180},{138,180}}, color={255,0,255}));
  connect(conInt.y, lowFloAla.u1) annotation (Line(points={{102,220},{120,220},{
          120,188},{138,188}}, color={255,127,0}));
  connect(and1.y, booToInt.u)
    annotation (Line(points={{-18,100},{78,100}}, color={255,0,255}));
  connect(booToInt.y, lowFloAla.u3) annotation (Line(points={{102,100},{120,100},
          {120,172},{138,172}},color={255,127,0}));
  connect(conInt1.y, greThr1.u)
    annotation (Line(points={{-98,10},{-82,10}},   color={0,0,127}));
  connect(greThr1.y, booToInt1.u)
    annotation (Line(points={{-58,10},{138,10}},   color={255,0,255}));
  connect(lowFloAla.y, proInt.u1) annotation (Line(points={{162,180},{180,180},{
          180,126},{198,126}}, color={255,127,0}));
  connect(booToInt1.y, proInt.u2) annotation (Line(points={{162,10},{180,10},{180,
          114},{198,114}},      color={255,127,0}));
  connect(not1.y, assMes.u)
    annotation (Line(points={{62,140},{78,140}}, color={255,0,255}));
  connect(and3.y, not1.u)
    annotation (Line(points={{22,140},{38,140}}, color={255,0,255}));
  connect(and2.y, and3.u1) annotation (Line(points={{-18,180},{-10,180},{-10,140},
          {-2,140}},      color={255,0,255}));
  connect(greThr1.y, and3.u2) annotation (Line(points={{-58,10},{-10,10},{-10,132},
          {-2,132}},      color={255,0,255}));
  connect(and1.y, and4.u1) annotation (Line(points={{-18,100},{0,100},{0,60},{18,
          60}},     color={255,0,255}));
  connect(greThr1.y, and4.u2) annotation (Line(points={{-58,10},{-10,10},{-10,52},
          {18,52}},       color={255,0,255}));
  connect(and4.y, not2.u)
    annotation (Line(points={{42,60},{58,60}},   color={255,0,255}));
  connect(not2.y, assMes1.u)
    annotation (Line(points={{82,60},{98,60}},   color={255,0,255}));
  connect(cooMaxFlo.y, gai2.u)
    annotation (Line(points={{-178,-50},{-162,-50}}, color={0,0,127}));
  connect(not3.y, truDel2.u)
    annotation (Line(points={{-178,-90},{-162,-90}},   color={255,0,255}));
  connect(uFan, not3.u)
    annotation (Line(points={{-260,-90},{-202,-90}},   color={255,0,255}));
  connect(gai2.y, gre1.u2) annotation (Line(points={{-138,-50},{-120,-50},{-120,
          -38},{-102,-38}}, color={0,0,127}));
  connect(gre1.y, and5.u1)
    annotation (Line(points={{-78,-30},{-22,-30}}, color={255,0,255}));
  connect(truDel2.y, and5.u2) annotation (Line(points={{-138,-90},{-40,-90},{-40,
          -38},{-22,-38}}, color={255,0,255}));
  connect(and5.y, not4.u) annotation (Line(points={{2,-30},{20,-30},{20,-60},{38,
          -60}}, color={255,0,255}));
  connect(not4.y, assMes2.u)
    annotation (Line(points={{62,-60},{78,-60}}, color={255,0,255}));
  connect(and5.y, booToInt2.u)
    annotation (Line(points={{2,-30},{138,-30}}, color={255,0,255}));
  connect(booToInt2.y, yFloSenAla)
    annotation (Line(points={{162,-30},{260,-30}}, color={255,127,0}));
  connect(proInt.y, yLowFloAla)
    annotation (Line(points={{222,120},{260,120}}, color={255,127,0}));
  connect(gre1.y, truDel3.u) annotation (Line(points={{-78,-30},{-60,-30},{-60,-130},
          {-22,-130}}, color={255,0,255}));
  connect(uDam, cloDam.u)
    annotation (Line(points={{-260,-200},{-202,-200}}, color={0,0,127}));
  connect(truDel3.y, leaDamAla.u1) annotation (Line(points={{2,-130},{20,-130},{
          20,-152},{38,-152}}, color={255,0,255}));
  connect(uFan, leaDamAla.u2) annotation (Line(points={{-260,-90},{-220,-90},{-220,
          -160},{38,-160}},      color={255,0,255}));
  connect(cloDam.y, leaDamAla.u3) annotation (Line(points={{-178,-200},{20,-200},
          {20,-168},{38,-168}}, color={255,0,255}));
  connect(not5.y, assMes3.u)
    annotation (Line(points={{122,-200},{138,-200}}, color={255,0,255}));
  connect(leaDamAla.y, not5.u) annotation (Line(points={{62,-160},{80,-160},{80,
          -200},{98,-200}}, color={255,0,255}));
  connect(leaDamAla.y, booToInt3.u)
    annotation (Line(points={{62,-160},{138,-160}}, color={255,0,255}));
  connect(booToInt3.y, yLeaDamAla)
    annotation (Line(points={{162,-160},{260,-160}}, color={255,127,0}));
  connect(VDis_flow, gre1.u1) annotation (Line(points={{-260,180},{-220,180},{-220,
          -30},{-102,-30}}, color={0,0,127}));

annotation (defaultComponentName="ala",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
        extent={{-100,140},{100,100}},
        textString="%name",
        lineColor={0,0,255}),
        Text(
          extent={{-98,46},{-48,32}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActSet_flow"),
        Text(
          extent={{-98,86},{-58,74}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-100,-74},{-72,-84}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDam"),
        Text(
          extent={{-100,-34},{-74,-44}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uFan"),
        Text(
          extent={{46,68},{96,54}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowFloAla"),
        Text(
          extent={{48,8},{98,-6}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yFloSenAla"),
        Text(
          extent={{48,-52},{98,-66}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaDamAla")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-240},{240,240}})),
Documentation(info="<html>
<p>
This block outputs alarms of snap-acting controlled dual-duct terminal unit. The
implementation is according to the Section 5.11.6 of ASHRAE Guideline 36, May 2020.
</p>
<h4>Low airflow</h4>
<ol>
<li>
If the measured airflow <code>VDis_flow</code> is less then 70% of setpoint
<code>VActSet_flow</code> for 5 minutes (<code>lowFloTim</code>) while the setpoint
is greater than zero, generate a Level 3 alarm.
</li>
<li>
If the measured airflow <code>VDis_flow</code> is less then 50% of setpoint
<code>VActSet_flow</code> for 5 minutes (<code>lowFloTim</code>) while the setpoint
is greater than zero, generate a Level 2 alarm.
</li>
<li>
If a zone has an importance multiplier (<code>staPreMul</code>) of 0 for its
static pressure reset Trim-Respond control loop, low airflow alarms shall be
suppressed for that zone.
</li>
</ol>
<h4>Airflow sensor calibration</h4>
<p>
If the fan serving the zone has been OFF (<code>uFan=false</code>) for 10 minutes
(<code>fanOffTim</code>), and airflow sensor reading <code>VDis_flow</code>
is above 10% of the cooling maximum airflow setpoint <code>VCooZonMax_flow</code>,
generate a Level 3 alarm.
</p>
<h4>Leaking damper</h4>
<p>
If the damper position (<code>uDam</code>) is 0% and airflow sensor reading
<code>VDis_flow</code> is above 10% of the cooling maximum airflow setpoint
<code>VCooZonMax_flow</code> for 10 minutes (<code>leaFloTim</code>) while the
fan serving the zone is proven on (<code>uFan=true</code>), generate a Level
4 alarm.
</p>
</html>",revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Alarms;
