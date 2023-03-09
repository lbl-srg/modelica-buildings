within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences;
block Alarms "Generate alarms of cooling only terminal unit"

  parameter Real staPreMul
    "Importance multiplier for the zone static pressure reset control loop";
  parameter Real VCooMax_flow(
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
    "Threshold time to check leaking flow";
  parameter Real floHys(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Near zero flow rate, below which the flow rate or difference will be seen as zero"
    annotation (Dialog(tab="Advanced"));
  parameter Real damPosHys(
    final unit="1")
    "Near zero damper position, below which the damper will be seen as closed"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Measured discharge airflow rate"
    annotation (Placement(transformation(extent={{-280,150},{-240,190}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active airflow setpoint"
    annotation (Placement(transformation(extent={{-280,70},{-240,110}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Fan
    "AHU supply fan status"
    annotation (Placement(transformation(extent={{-280,-120},{-240,-80}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDam(
    final min=0,
    final unit="1")
    "Damper position setpoint"
    annotation (Placement(transformation(extent={{-280,-230},{-240,-190}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowFloAla
    "Low airflow alarms"
    annotation (Placement(transformation(extent={{240,130},{280,170}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFloSenAla
    "Airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{240,-60},{280,-20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaDamAla
    "Leaking damper alarm"
    annotation (Placement(transformation(extent={{240,-190},{280,-150}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=0.5)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Less les(
    final h=floHys)
    "Check if measured airflow is less than threshold"
    annotation (Placement(transformation(extent={{-120,160},{-100,180}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=lowFloTim)
    "Check if the measured airflow has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=floHys,
    final h=0.5*floHys)
    "Check if setpoint airflow is greater than zero"
    annotation (Placement(transformation(extent={{-180,80},{-160,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre(
    final h=floHys)
    "Check if measured airflow is less than threshold"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=0.7)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=lowFloTim)
    "Check if the measured airflow has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Measured airflow has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,160},{-20,180}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Measured airflow has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Integers.Switch lowFloAla
    "Low airflow alarm"
    annotation (Placement(transformation(extent={{140,160},{160,180}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=2)
    "Level 2 alarm"
    annotation (Placement(transformation(extent={{80,200},{100,220}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(
    final integerTrue=3)
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conInt1(
    final k=staPreMul)
    "Importance multiplier for zone static pressure reset"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1
    "Check if the multiplier is greater than zero"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Suppress the alarm when multiplier is zero"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt
    "Low flow alarms"
    annotation (Placement(transformation(extent={{200,140},{220,160}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Warning: airflow is less than 50% of the setpoint.")
    "Level 2 low airflow alarm"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Logical and"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(
    final message="Warning: airflow is less than 70% of the setpoint.")
    "Level 3 low airflow alarm"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooMaxFlo(
    final k=VCooMax_flow)
    "Cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-200,-70},{-180,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(
    final k=0.1)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical not"
    annotation (Placement(transformation(extent={{-200,-110},{-180,-90}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=fanOffTim)
    "Check if the input has been true for more than threshold time"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre1(
    final h=floHys)
    "Check if measured airflow is greater than threshold"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Check if the measured airflow is greater than the threshold and the supply fan is OFF"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4
    "Logical not"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes2(
    final message="Warning: airflow sensor should be calibrated.")
    "Level 3 airflow sensor alarm"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2(
    final integerTrue=3)
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(
    final delayTime=leaFloTim)
    "Check if the input has been true for more than threshold time"
    annotation (Placement(transformation(extent={{20,-180},{40,-160}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold cloDam(
    final t=damPosHys,
    final h=0.5*damPosHys)
    "Check if damper position is near zero"
    annotation (Placement(transformation(extent={{-200,-220},{-180,-200}})));
  Buildings.Controls.OBC.CDL.Logical.And3 leaDamAla
    "Check if generating leak damper alarms"
    annotation (Placement(transformation(extent={{-40,-180},{-20,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5 "Logical not"
    annotation (Placement(transformation(extent={{100,-220},{120,-200}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes3(
    final message="Warning: the damper is leaking.")
    "Level 4 leaking damper alarm"
    annotation (Placement(transformation(extent={{140,-220},{160,-200}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3(
    final integerTrue=4)
    "Convert boolean true to level 4 alarm"
    annotation (Placement(transformation(extent={{140,-180},{160,-160}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel4(
    final delayTime=lowFloTim)
    "Check if the active flow setpoint has been greater than zero for the threshold time"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
equation
  connect(VActSet_flow, gai.u) annotation (Line(points={{-260,90},{-200,90},{-200,
          140},{-182,140}},      color={0,0,127}));
  connect(VDis_flow, les.u1)
    annotation (Line(points={{-260,170},{-122,170}}, color={0,0,127}));
  connect(gai.y, les.u2) annotation (Line(points={{-158,140},{-140,140},{-140,162},
          {-122,162}},      color={0,0,127}));
  connect(les.y, truDel.u)
    annotation (Line(points={{-98,170},{-82,170}}, color={255,0,255}));
  connect(VActSet_flow, greThr.u)
    annotation (Line(points={{-260,90},{-182,90}},   color={0,0,127}));
  connect(VActSet_flow, gai1.u) annotation (Line(points={{-260,90},{-200,90},{-200,
          60},{-182,60}},         color={0,0,127}));
  connect(VDis_flow, gre.u2) annotation (Line(points={{-260,170},{-220,170},{-220,
          32},{-122,32}},        color={0,0,127}));
  connect(gai1.y, gre.u1) annotation (Line(points={{-158,60},{-140,60},{-140,40},
          {-122,40}},       color={0,0,127}));
  connect(gre.y, truDel1.u)
    annotation (Line(points={{-98,40},{-82,40}},   color={255,0,255}));
  connect(truDel.y, and2.u1)
    annotation (Line(points={{-58,170},{-42,170}}, color={255,0,255}));
  connect(truDel1.y, and1.u2) annotation (Line(points={{-58,40},{-50,40},{-50,82},
          {-42,82}},       color={255,0,255}));
  connect(and2.y, lowFloAla.u2)
    annotation (Line(points={{-18,170},{138,170}}, color={255,0,255}));
  connect(conInt.y, lowFloAla.u1) annotation (Line(points={{102,210},{120,210},{
          120,178},{138,178}}, color={255,127,0}));
  connect(and1.y, booToInt.u)
    annotation (Line(points={{-18,90},{78,90}},   color={255,0,255}));
  connect(booToInt.y, lowFloAla.u3) annotation (Line(points={{102,90},{120,90},{
          120,162},{138,162}}, color={255,127,0}));
  connect(conInt1.y, greThr1.u)
    annotation (Line(points={{-98,0},{-82,0}},     color={0,0,127}));
  connect(greThr1.y, booToInt1.u)
    annotation (Line(points={{-58,0},{138,0}},     color={255,0,255}));
  connect(lowFloAla.y, proInt.u1) annotation (Line(points={{162,170},{180,170},{
          180,156},{198,156}}, color={255,127,0}));
  connect(booToInt1.y, proInt.u2) annotation (Line(points={{162,0},{180,0},{180,
          144},{198,144}},      color={255,127,0}));
  connect(not1.y, assMes.u)
    annotation (Line(points={{62,130},{78,130}}, color={255,0,255}));
  connect(and3.y, not1.u)
    annotation (Line(points={{22,130},{38,130}}, color={255,0,255}));
  connect(and2.y, and3.u1) annotation (Line(points={{-18,170},{-10,170},{-10,130},
          {-2,130}},      color={255,0,255}));
  connect(greThr1.y, and3.u2) annotation (Line(points={{-58,0},{-10,0},{-10,122},
          {-2,122}},      color={255,0,255}));
  connect(and1.y, and4.u1) annotation (Line(points={{-18,90},{0,90},{0,50},{18,50}},
                    color={255,0,255}));
  connect(greThr1.y, and4.u2) annotation (Line(points={{-58,0},{-10,0},{-10,42},
          {18,42}},       color={255,0,255}));
  connect(and4.y, not2.u)
    annotation (Line(points={{42,50},{58,50}},   color={255,0,255}));
  connect(not2.y, assMes1.u)
    annotation (Line(points={{82,50},{98,50}},   color={255,0,255}));
  connect(cooMaxFlo.y, gai2.u)
    annotation (Line(points={{-178,-60},{-162,-60}}, color={0,0,127}));
  connect(u1Fan, not3.u)
    annotation (Line(points={{-260,-100},{-202,-100}}, color={255,0,255}));
  connect(gai2.y, gre1.u2) annotation (Line(points={{-138,-60},{-120,-60},{-120,
          -48},{-102,-48}}, color={0,0,127}));
  connect(VDis_flow, gre1.u1) annotation (Line(points={{-260,170},{-220,170},{-220,
          -40},{-102,-40}}, color={0,0,127}));
  connect(not4.y, assMes2.u)
    annotation (Line(points={{62,-70},{78,-70}}, color={255,0,255}));
  connect(booToInt2.y, yFloSenAla)
    annotation (Line(points={{162,-40},{260,-40}}, color={255,127,0}));
  connect(proInt.y, yLowFloAla)
    annotation (Line(points={{222,150},{260,150}}, color={255,127,0}));
  connect(uDam, cloDam.u)
    annotation (Line(points={{-260,-210},{-202,-210}}, color={0,0,127}));
  connect(u1Fan, leaDamAla.u2) annotation (Line(points={{-260,-100},{-220,-100},
          {-220,-170},{-42,-170}},color={255,0,255}));
  connect(cloDam.y, leaDamAla.u3) annotation (Line(points={{-178,-210},{-100,-210},
          {-100,-178},{-42,-178}}, color={255,0,255}));
  connect(not5.y, assMes3.u)
    annotation (Line(points={{122,-210},{138,-210}}, color={255,0,255}));
  connect(booToInt3.y, yLeaDamAla)
    annotation (Line(points={{162,-170},{260,-170}}, color={255,127,0}));
  connect(greThr.y, truDel4.u)
    annotation (Line(points={{-158,90},{-122,90}}, color={255,0,255}));
  connect(truDel4.y, and1.u1)
    annotation (Line(points={{-98,90},{-42,90}}, color={255,0,255}));
  connect(truDel4.y, and2.u2) annotation (Line(points={{-98,90},{-50,90},{-50,162},
          {-42,162}}, color={255,0,255}));
  connect(truDel2.y, booToInt2.u)
    annotation (Line(points={{22,-40},{138,-40}}, color={255,0,255}));
  connect(truDel2.y, not4.u) annotation (Line(points={{22,-40},{30,-40},{30,-70},
          {38,-70}}, color={255,0,255}));
  connect(and5.y, truDel2.u)
    annotation (Line(points={{-18,-40},{-2,-40}}, color={255,0,255}));
  connect(gre1.y, and5.u1)
    annotation (Line(points={{-78,-40},{-42,-40}}, color={255,0,255}));
  connect(not3.y, and5.u2) annotation (Line(points={{-178,-100},{-60,-100},{-60,
          -48},{-42,-48}}, color={255,0,255}));
  connect(gre1.y, leaDamAla.u1) annotation (Line(points={{-78,-40},{-70,-40},{-70,
          -162},{-42,-162}}, color={255,0,255}));
  connect(leaDamAla.y, truDel3.u)
    annotation (Line(points={{-18,-170},{18,-170}}, color={255,0,255}));
  connect(truDel3.y, booToInt3.u)
    annotation (Line(points={{42,-170},{138,-170}}, color={255,0,255}));
  connect(truDel3.y, not5.u) annotation (Line(points={{42,-170},{80,-170},{80,-210},
          {98,-210}}, color={255,0,255}));
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
        textColor={0,0,255}),
        Text(
          extent={{-98,46},{-48,32}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActSet_flow"),
        Text(
          extent={{-98,84},{-58,74}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-100,-74},{-72,-84}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDam"),
        Text(
          extent={{-100,-34},{-74,-44}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uFan"),
        Text(
          extent={{46,68},{96,54}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowFloAla"),
        Text(
          extent={{48,8},{98,-6}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yFloSenAla"),
        Text(
          extent={{48,-50},{98,-64}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaDamAla")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-240},{240,240}})),
Documentation(info="<html>
<p>
This block outputs alarms of cooling only terminal unit. The implementation is according
to the Section 5.5.6 of ASHRAE Guideline 36, May 2020.
</p>
<h4>Low airflow alarm</h4>
<ol>
<li>
If the measured airflow <code>VDis_flow</code> is less than 70% of setpoint
<code>VActSet_flow</code> for 5 minutes (<code>lowFloTim</code>) while the setpoint
is greater than zero, generate a Level 3 alarm.
</li>
<li>
If the measured airflow <code>VDis_flow</code> is less than 50% of setpoint
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
is above 10% of the cooling maximum airflow setpoint <code>VCooMax_flow</code>,
generate a Level 3 alarm.
</p>
<h4>Leaking damper</h4>
<p>
If the damper position (<code>uDam</code>) is 0% and airflow sensor reading
<code>VDis_flow</code> is above 10% of the cooling maximum airflow setpoint
<code>VCooMax_flow</code> for 10 minutes (<code>leaFloTim</code>) while the
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
