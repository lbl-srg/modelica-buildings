within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences;
block Alarms "Generate alarms of terminal unit with reheat"

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
  parameter Real lowTemTim(
    final unit="s",
    final quantity="Time")=600
    "Threshold time to check low discharge temperature";
  parameter Real fanOffTim(
    final unit="s",
    final quantity="Time")=600
    "Threshold time to check fan off";
  parameter Real leaFloTim(
    final unit="s",
    final quantity="Time")=600
    "Threshold time to check damper leaking airflow";
  parameter Real valCloTim(
    final unit="s",
    final quantity="Time")=900
    "Threshold time to check valve leaking water flow";
  parameter Real floHys(
    final quantity="VolumeFlowRate",
    final unit="m3/s")=0.05
    "Near zero flow rate, below which the flow rate or difference will be seen as zero"
    annotation (Dialog(tab="Advanced"));
  parameter Real dTHys(
    final unit="K",
    final quantity="TemperatureDifference")=0.25
    "Temperature difference hysteresis below which the temperature difference will be seen as zero"
    annotation (Dialog(tab="Advanced"));
  parameter Real damPosHys(
    final unit="1")=0.05
    "Near zero damper position, below which the damper will be seen as closed"
    annotation (Dialog(tab="Advanced"));
  parameter Real valPosHys(
    final unit="1")=0.05
    "Near zero valve position, below which the valve will be seen as closed"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured discharge airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-280,320},{-240,360}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active airflow setpoint"
    annotation (Placement(transformation(extent={{-280,240},{-240,280}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan
    "Supply fan status"
    annotation (Placement(transformation(extent={{-280,50},{-240,90}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDam(
    final min=0,
    final unit="1") "Actual damper position"
    annotation (Placement(transformation(extent={{-280,-60},{-240,-20}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowFloAla
    "Low airflow alarms"
    annotation (Placement(transformation(extent={{240,260},{280,300}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFloSenAla
    "Airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{240,110},{280,150}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaDamAla
    "Leaking damper alarm"
    annotation (Placement(transformation(extent={{240,-20},{280,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=0.5)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-180,300},{-160,320}})));
  Buildings.Controls.OBC.CDL.Continuous.Less les(
    final h=floHys)
    "Check if measured airflow is less than threshold"
    annotation (Placement(transformation(extent={{-120,330},{-100,350}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=lowFloTim)
    "Check if the measured airflow has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,330},{-60,350}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final h=floHys)
    "Check if setpoint airflow is greater than zero"
    annotation (Placement(transformation(extent={{-180,250},{-160,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre(
    final h=floHys)
    "Check if measured airflow is less than threshold"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=0.7)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-180,220},{-160,240}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=lowFloTim)
    "Check if the measured airflow has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,200},{-60,220}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Measured airflow has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,330},{-20,350}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Measured airflow has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,250},{-20,270}})));
  Buildings.Controls.OBC.CDL.Integers.Switch lowFloAla
    "Low airflow alarm"
    annotation (Placement(transformation(extent={{140,330},{160,350}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=2)
    "Level 2 alarm"
    annotation (Placement(transformation(extent={{80,370},{100,390}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(
    final integerTrue=3)
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{80,250},{100,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conInt1(
    final k=staPreMul)
    "Importance multiplier for zone static pressure reset"
    annotation (Placement(transformation(extent={{-120,160},{-100,180}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1
    "Check if the multiplier is greater than zero"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Suppress the alarm when multiplier is zero"
    annotation (Placement(transformation(extent={{140,160},{160,180}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt
    "Low flow alarms"
    annotation (Placement(transformation(extent={{200,270},{220,290}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{0,290},{20,310}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{40,290},{60,310}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Warning: airflow is less than 50% of the setpoint.")
    "Level 2 low airflow alarm"
    annotation (Placement(transformation(extent={{80,290},{100,310}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Logical and"
    annotation (Placement(transformation(extent={{20,210},{40,230}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{60,210},{80,230}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(
    final message="Warning: airflow is less than 70% of the setpoint.")
    "Level 3 low airflow alarm"
    annotation (Placement(transformation(extent={{100,210},{120,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooMaxFlo(
    final k=VCooZonMax_flow)
    "Cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(
    final k=0.1)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical not"
    annotation (Placement(transformation(extent={{-200,60},{-180,80}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=fanOffTim)
    "Check if the supply fan has been OFF more than threshold time"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre1(
    final h=floHys)
    "Check if measured airflow is greater than threshold"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Logical and"
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4
    "Logical not"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes2(
    final message="Warning: airflow sensor should be calibrated.")
    "Level 3 airflow sensor alarm"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2(
    final integerTrue=3)
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{140,120},{160,140}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(
    final delayTime=leaFloTim)
    "Check if the air flow is above threshold by more than threshold time"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold cloDam(
    final t=damPosHys,
    final h=0.5*damPosHys) "Check if damper position is near zero"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And3 leaDamAla
    "Check if generating leak damper alarms"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5 "Logical not"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes3(
    final message="Warning: the damper is leaking.")
    "Level 4 leaking damper alarm"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3(
    final integerTrue=4)
    "Convert boolean true to level 4 alarm"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));

equation
  connect(VActSet_flow, gai.u) annotation (Line(points={{-260,260},{-200,260},{-200,
          310},{-182,310}},  color={0,0,127}));
  connect(VDis_flow, les.u1)
    annotation (Line(points={{-260,340},{-122,340}}, color={0,0,127}));
  connect(gai.y, les.u2) annotation (Line(points={{-158,310},{-140,310},{-140,332},
          {-122,332}}, color={0,0,127}));
  connect(les.y, truDel.u)
    annotation (Line(points={{-98,340},{-82,340}}, color={255,0,255}));
  connect(VActSet_flow, greThr.u)
    annotation (Line(points={{-260,260},{-182,260}}, color={0,0,127}));
  connect(VActSet_flow, gai1.u) annotation (Line(points={{-260,260},{-200,260},{
          -200,230},{-182,230}},  color={0,0,127}));
  connect(VDis_flow, gre.u2) annotation (Line(points={{-260,340},{-220,340},{-220,
          202},{-122,202}},      color={0,0,127}));
  connect(gai1.y, gre.u1) annotation (Line(points={{-158,230},{-140,230},{-140,210},
          {-122,210}},      color={0,0,127}));
  connect(gre.y, truDel1.u)
    annotation (Line(points={{-98,210},{-82,210}}, color={255,0,255}));
  connect(truDel.y, and2.u1)
    annotation (Line(points={{-58,340},{-42,340}}, color={255,0,255}));
  connect(greThr.y, and2.u2) annotation (Line(points={{-158,260},{-50,260},{-50,
          332},{-42,332}}, color={255,0,255}));
  connect(greThr.y, and1.u1)
    annotation (Line(points={{-158,260},{-42,260}}, color={255,0,255}));
  connect(truDel1.y, and1.u2) annotation (Line(points={{-58,210},{-50,210},{-50,
          252},{-42,252}}, color={255,0,255}));
  connect(and2.y, lowFloAla.u2)
    annotation (Line(points={{-18,340},{138,340}}, color={255,0,255}));
  connect(conInt.y, lowFloAla.u1) annotation (Line(points={{102,380},{120,380},{
          120,348},{138,348}}, color={255,127,0}));
  connect(and1.y, booToInt.u)
    annotation (Line(points={{-18,260},{78,260}}, color={255,0,255}));
  connect(booToInt.y, lowFloAla.u3) annotation (Line(points={{102,260},{120,260},
          {120,332},{138,332}},color={255,127,0}));
  connect(conInt1.y, greThr1.u)
    annotation (Line(points={{-98,170},{-82,170}}, color={0,0,127}));
  connect(greThr1.y, booToInt1.u)
    annotation (Line(points={{-58,170},{138,170}}, color={255,0,255}));
  connect(lowFloAla.y, proInt.u1) annotation (Line(points={{162,340},{180,340},{
          180,286},{198,286}}, color={255,127,0}));
  connect(booToInt1.y, proInt.u2) annotation (Line(points={{162,170},{180,170},{
          180,274},{198,274}},  color={255,127,0}));
  connect(not1.y, assMes.u)
    annotation (Line(points={{62,300},{78,300}}, color={255,0,255}));
  connect(and3.y, not1.u)
    annotation (Line(points={{22,300},{38,300}}, color={255,0,255}));
  connect(and2.y, and3.u1) annotation (Line(points={{-18,340},{-10,340},{-10,300},
          {-2,300}},      color={255,0,255}));
  connect(greThr1.y, and3.u2) annotation (Line(points={{-58,170},{-10,170},{-10,
          292},{-2,292}}, color={255,0,255}));
  connect(and1.y, and4.u1) annotation (Line(points={{-18,260},{0,260},{0,220},{18,
          220}},    color={255,0,255}));
  connect(greThr1.y, and4.u2) annotation (Line(points={{-58,170},{-10,170},{-10,
          212},{18,212}}, color={255,0,255}));
  connect(and4.y, not2.u)
    annotation (Line(points={{42,220},{58,220}}, color={255,0,255}));
  connect(not2.y, assMes1.u)
    annotation (Line(points={{82,220},{98,220}}, color={255,0,255}));
  connect(cooMaxFlo.y, gai2.u)
    annotation (Line(points={{-178,110},{-162,110}}, color={0,0,127}));
  connect(not3.y, truDel2.u)
    annotation (Line(points={{-178,70},{-162,70}},     color={255,0,255}));
  connect(uFan, not3.u)
    annotation (Line(points={{-260,70},{-202,70}},     color={255,0,255}));
  connect(gai2.y, gre1.u2) annotation (Line(points={{-138,110},{-120,110},{-120,
          122},{-102,122}}, color={0,0,127}));
  connect(gre1.y, and5.u1)
    annotation (Line(points={{-78,130},{-22,130}}, color={255,0,255}));
  connect(truDel2.y, and5.u2) annotation (Line(points={{-138,70},{-40,70},{-40,122},
          {-22,122}},      color={255,0,255}));
  connect(and5.y, not4.u) annotation (Line(points={{2,130},{20,130},{20,100},{38,
          100}}, color={255,0,255}));
  connect(not4.y, assMes2.u)
    annotation (Line(points={{62,100},{78,100}}, color={255,0,255}));
  connect(and5.y, booToInt2.u)
    annotation (Line(points={{2,130},{138,130}}, color={255,0,255}));
  connect(booToInt2.y, yFloSenAla)
    annotation (Line(points={{162,130},{260,130}}, color={255,127,0}));
  connect(proInt.y, yLowFloAla)
    annotation (Line(points={{222,280},{260,280}}, color={255,127,0}));
  connect(gre1.y, truDel3.u) annotation (Line(points={{-78,130},{-60,130},{-60,30},
          {-22,30}},   color={255,0,255}));
  connect(uDam, cloDam.u)
    annotation (Line(points={{-260,-40},{-202,-40}},   color={0,0,127}));
  connect(truDel3.y, leaDamAla.u1) annotation (Line(points={{2,30},{20,30},{20,8},
          {38,8}},             color={255,0,255}));
  connect(uFan, leaDamAla.u2) annotation (Line(points={{-260,70},{-220,70},{-220,
          0},{38,0}},            color={255,0,255}));
  connect(cloDam.y, leaDamAla.u3) annotation (Line(points={{-178,-40},{20,-40},{
          20,-8},{38,-8}},      color={255,0,255}));
  connect(not5.y, assMes3.u)
    annotation (Line(points={{122,-40},{138,-40}},   color={255,0,255}));
  connect(leaDamAla.y, not5.u) annotation (Line(points={{62,0},{80,0},{80,-40},{
          98,-40}},         color={255,0,255}));
  connect(leaDamAla.y, booToInt3.u)
    annotation (Line(points={{62,0},{138,0}}, color={255,0,255}));
  connect(booToInt3.y, yLeaDamAla)
    annotation (Line(points={{162,0},{260,0}}, color={255,127,0}));
  connect(VDis_flow, gre1.u1) annotation (Line(points={{-260,340},{-220,340},{-220,
          130},{-102,130}}, color={0,0,127}));

annotation (defaultComponentName="rehBoxAla",
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
          extent={{-98,66},{-48,52}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActSet_flow"),
        Text(
          extent={{-98,84},{-58,74}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-100,26},{-72,16}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDam"),
        Text(
          extent={{-100,46},{-74,36}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uFan"),
        Text(
          extent={{46,88},{96,74}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowFloAla"),
        Text(
          extent={{48,48},{98,34}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yFloSenAla"),
        Text(
          extent={{48,8},{98,-6}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaDamAla"),
        Text(
          extent={{-100,6},{-78,-4}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uVal"),
        Text(
          extent={{-100,-14},{-74,-24}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-98,-34},{-66,-46}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHotPla"),
        Text(
          extent={{-100,-54},{-76,-64}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis"),
        Text(
          extent={{-100,-74},{-62,-84}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDisSet"),
        Text(
          extent={{48,-32},{98,-46}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaValAla"),
        Text(
          extent={{42,-72},{98,-86}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowTemAla")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-400},{240,400}})),
Documentation(info="<html>
<p>
This block outputs alarms of terminal unit with reheat. The implementation is according
to the Section 5.6.6 of ASHRAE Guideline 36, May 2020.
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
<h4>Low-discharging air temperature</h4>
<ol>
<li>
If heating hot-water plant is proven on (<code>uHotPla=true</code>), and the
discharge temperature (<code>TDis</code>) is 8 &deg;C (15 &deg;F) less than the
setpoint (<code>TDisSet</code>) for 10 minuts (<code>lowTemTim</code>), generate a
Level 3 alarm.
</li>
<li>
If heating hot-water plant is proven on (<code>uHotPla=true</code>), and the
discharge temperature (<code>TDis</code>) is 17 &deg;C (30 &deg;F) less than the
setpoint (<code>TDisSet</code>) for 10 minuts (<code>lowTemTim</code>), generate a
Level 2 alarm.
</li>
<li>
If a zone has an importance multiplier (<code>hotWatRes</code>) of 0 for its
hot-water reset Trim-Respond control loop, low discharing air temperature alarms
shall be suppressed for that zone.
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
<h4>Leaking valve</h4>
<p>
If the valve position (<code>uVal</code>) is 0% for 15 minutes (<code>valCloTim</code>),
discharing air temperature <code>TDis</code> is above AHU supply temperature
<code>TSup</code> by 3 &deg;C (5 &deg;F), and the fan serving the zone is proven
on (<code>uFan=true</code>), gemerate a Level 4 alarm.
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
