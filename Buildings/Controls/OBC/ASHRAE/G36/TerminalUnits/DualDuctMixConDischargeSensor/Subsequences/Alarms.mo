within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConDischargeSensor.Subsequences;
block Alarms
  "Generate alarms of dual-duct terminal unit using mixing control with discharge flow sensor"

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
    final quantity="VolumeFlowRate") "Measured discharge airflow rate"
    annotation (Placement(transformation(extent={{-280,190},{-240,230}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active airflow setpoint"
    annotation (Placement(transformation(extent={{-280,110},{-240,150}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1CooFan
    "Cooling air handler supply fan status"
    annotation (Placement(transformation(extent={{-280,-100},{-240,-60}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HeaFan
    "Heating air handler supply fan status"
    annotation (Placement(transformation(extent={{-280,-170},{-240,-130}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooDam(
    final min=0,
    final unit="1")
    "Cooling damper position setpoint"
    annotation (Placement(transformation(extent={{-280,-230},{-240,-190}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaDam(
    final min=0,
    final unit="1")
    "Heating damper position setpoint"
    annotation (Placement(transformation(extent={{-280,-270},{-240,-230}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowFloAla
    "Low airflow alarms"
    annotation (Placement(transformation(extent={{240,130},{280,170}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFloSenAla
    "Airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{240,-30},{280,10}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaDamAla
    "Leaking dampers alarm, could be heating or cooling damper"
    annotation (Placement(transformation(extent={{240,-200},{280,-160}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=0.5)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-180,170},{-160,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Less les(
    final h=floHys)
    "Check if measured airflow is less than threshold"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=lowFloTim)
    "Check if the measured airflow has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,200},{-60,220}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=floHys,
    final h=0.5*floHys)
    "Check if setpoint airflow is greater than zero"
    annotation (Placement(transformation(extent={{-180,120},{-160,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre(
    final h=floHys)
    "Check if measured airflow is less than threshold"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=0.7)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=lowFloTim)
    "Check if the measured airflow has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Measured airflow has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,200},{-20,220}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Measured airflow has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
  Buildings.Controls.OBC.CDL.Integers.Switch lowFloAla
    "Low airflow alarm"
    annotation (Placement(transformation(extent={{140,200},{160,220}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=2)
    "Level 2 alarm"
    annotation (Placement(transformation(extent={{80,240},{100,260}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(
    final integerTrue=3)
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conInt1(
    final k=staPreMul)
    "Importance multiplier for zone static pressure reset"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1
    "Check if the multiplier is greater than zero"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Suppress the alarm when multiplier is zero"
    annotation (Placement(transformation(extent={{140,30},{160,50}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt
    "Low flow alarms"
    annotation (Placement(transformation(extent={{200,140},{220,160}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{0,160},{20,180}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{40,160},{60,180}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Warning: airflow is less than 50% of the setpoint.")
    "Level 2 low airflow alarm"
    annotation (Placement(transformation(extent={{80,160},{100,180}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Logical and"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(
    final message="Warning: airflow is less than 70% of the setpoint.")
    "Level 3 low airflow alarm"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold cloDam(
    final t=damPosHys,
    final h=0.5*damPosHys) "Check if damper position is near zero"
    annotation (Placement(transformation(extent={{-200,-220},{-180,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold cloDam1(
    final t=damPosHys,
    final h=0.5*damPosHys)
    "Check if damper position is near zero"
    annotation (Placement(transformation(extent={{-200,-260},{-180,-240}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooMaxFlo1(
    final k=VCooMax_flow)
    "Cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-180,-60},{-160,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai4(
    final k=0.1)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre3(
    final h=floHys)
    "Check if measured airflow is greater than threshold"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Logical.And and7
    "Check if the measured airflow is greater than the threshold and the supply fan is OFF"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Controls.OBC.CDL.Logical.Not not9
    "Logical not"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes6(
    final message="Warning: airflow sensor should be calibrated.")
    "Level 3 airflow sensor alarm"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt6(
    final integerTrue=3)
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{140,-20},{160,0}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if there is any supply fan proven on"
    annotation (Placement(transformation(extent={{-180,-120},{-160,-100}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel6(
    final delayTime=fanOffTim)
    "Check if the input has been true for more than threshold time"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Controls.OBC.CDL.Logical.Not not10
    "Logical not"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel7(
    final delayTime=leaFloTim)
    "Check if the input has been true for more than threshold time"
    annotation (Placement(transformation(extent={{40,-190},{60,-170}})));
  Buildings.Controls.OBC.CDL.Logical.And3 leaDamAla2
    "Check if generating leak damper alarms"
    annotation (Placement(transformation(extent={{-20,-190},{0,-170}})));
  Buildings.Controls.OBC.CDL.Logical.And cloBotDam
    "Both heating and cooling dampers are closed"
    annotation (Placement(transformation(extent={{-120,-220},{-100,-200}})));
  Buildings.Controls.OBC.CDL.Logical.Not not11
    "Logical not"
    annotation (Placement(transformation(extent={{100,-230},{120,-210}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes7(
    final message="Warning: the cold-duct or hot-dcut damper is leaking.")
    "Level 4 leaking damper alarm"
    annotation (Placement(transformation(extent={{140,-230},{160,-210}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt7(
    final integerTrue=4)
    "Convert boolean true to level 4 alarm"
    annotation (Placement(transformation(extent={{140,-190},{160,-170}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=lowFloTim)
    "Check if the active flow setpoint has been greater than zero for the threshold time"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
equation
  connect(VActSet_flow, gai.u) annotation (Line(points={{-260,130},{-200,130},{-200,
          180},{-182,180}},  color={0,0,127}));
  connect(VDis_flow, les.u1)
    annotation (Line(points={{-260,210},{-122,210}}, color={0,0,127}));
  connect(gai.y, les.u2) annotation (Line(points={{-158,180},{-140,180},{-140,202},
          {-122,202}}, color={0,0,127}));
  connect(les.y, truDel.u)
    annotation (Line(points={{-98,210},{-82,210}}, color={255,0,255}));
  connect(VActSet_flow, greThr.u)
    annotation (Line(points={{-260,130},{-182,130}}, color={0,0,127}));
  connect(VActSet_flow, gai1.u) annotation (Line(points={{-260,130},{-200,130},{
          -200,100},{-182,100}},  color={0,0,127}));
  connect(VDis_flow, gre.u2) annotation (Line(points={{-260,210},{-220,210},{-220,
          72},{-122,72}},        color={0,0,127}));
  connect(gai1.y, gre.u1) annotation (Line(points={{-158,100},{-140,100},{-140,80},
          {-122,80}},       color={0,0,127}));
  connect(gre.y, truDel1.u)
    annotation (Line(points={{-98,80},{-82,80}},   color={255,0,255}));
  connect(truDel.y, and2.u1)
    annotation (Line(points={{-58,210},{-42,210}}, color={255,0,255}));
  connect(truDel1.y, and1.u2) annotation (Line(points={{-58,80},{-50,80},{-50,122},
          {-42,122}},      color={255,0,255}));
  connect(and2.y, lowFloAla.u2)
    annotation (Line(points={{-18,210},{138,210}}, color={255,0,255}));
  connect(conInt.y, lowFloAla.u1) annotation (Line(points={{102,250},{120,250},{
          120,218},{138,218}}, color={255,127,0}));
  connect(and1.y, booToInt.u)
    annotation (Line(points={{-18,130},{78,130}}, color={255,0,255}));
  connect(booToInt.y, lowFloAla.u3) annotation (Line(points={{102,130},{120,130},
          {120,202},{138,202}},color={255,127,0}));
  connect(conInt1.y, greThr1.u)
    annotation (Line(points={{-98,40},{-82,40}},   color={0,0,127}));
  connect(greThr1.y, booToInt1.u)
    annotation (Line(points={{-58,40},{138,40}},   color={255,0,255}));
  connect(lowFloAla.y, proInt.u1) annotation (Line(points={{162,210},{180,210},{
          180,156},{198,156}}, color={255,127,0}));
  connect(booToInt1.y, proInt.u2) annotation (Line(points={{162,40},{180,40},{180,
          144},{198,144}},      color={255,127,0}));
  connect(not1.y, assMes.u)
    annotation (Line(points={{62,170},{78,170}}, color={255,0,255}));
  connect(and3.y, not1.u)
    annotation (Line(points={{22,170},{38,170}}, color={255,0,255}));
  connect(and2.y, and3.u1) annotation (Line(points={{-18,210},{-10,210},{-10,170},
          {-2,170}},      color={255,0,255}));
  connect(greThr1.y, and3.u2) annotation (Line(points={{-58,40},{-10,40},{-10,162},
          {-2,162}},      color={255,0,255}));
  connect(and1.y, and4.u1) annotation (Line(points={{-18,130},{0,130},{0,90},{18,
          90}},     color={255,0,255}));
  connect(greThr1.y, and4.u2) annotation (Line(points={{-58,40},{-10,40},{-10,82},
          {18,82}},       color={255,0,255}));
  connect(and4.y, not2.u)
    annotation (Line(points={{42,90},{58,90}},   color={255,0,255}));
  connect(not2.y, assMes1.u)
    annotation (Line(points={{82,90},{98,90}},   color={255,0,255}));
  connect(proInt.y, yLowFloAla)
    annotation (Line(points={{222,150},{260,150}}, color={255,127,0}));
  connect(uCooDam, cloDam.u)
    annotation (Line(points={{-260,-210},{-202,-210}}, color={0,0,127}));
  connect(uHeaDam, cloDam1.u)
    annotation (Line(points={{-260,-250},{-202,-250}}, color={0,0,127}));
  connect(VDis_flow, gre3.u1) annotation (Line(points={{-260,210},{-220,210},{-220,
          -10},{-82,-10}}, color={0,0,127}));
  connect(gre3.y, and7.u1)
    annotation (Line(points={{-58,-10},{-22,-10}},color={255,0,255}));
  connect(u1CooFan, or2.u1) annotation (Line(points={{-260,-80},{-200,-80},{-200,
          -110},{-182,-110}}, color={255,0,255}));
  connect(u1HeaFan, or2.u2) annotation (Line(points={{-260,-150},{-200,-150},{-200,
          -118},{-182,-118}}, color={255,0,255}));
  connect(or2.y, not10.u)
    annotation (Line(points={{-158,-110},{-122,-110}}, color={255,0,255}));
  connect(not9.y, assMes6.u)
    annotation (Line(points={{122,-40},{138,-40}}, color={255,0,255}));
  connect(booToInt6.y, yFloSenAla)
    annotation (Line(points={{162,-10},{260,-10}}, color={255,127,0}));
  connect(gai4.y, gre3.u2) annotation (Line(points={{-118,-50},{-100,-50},{-100,
          -18},{-82,-18}}, color={0,0,127}));
  connect(cooMaxFlo1.y, gai4.u)
    annotation (Line(points={{-158,-50},{-142,-50}}, color={0,0,127}));
  connect(cloBotDam.y, leaDamAla2.u3) annotation (Line(points={{-98,-210},{-80,-210},
          {-80,-188},{-22,-188}}, color={255,0,255}));
  connect(or2.y, leaDamAla2.u2) annotation (Line(points={{-158,-110},{-140,-110},
          {-140,-180},{-22,-180}}, color={255,0,255}));
  connect(cloDam.y, cloBotDam.u1) annotation (Line(points={{-178,-210},{-122,-210}},
                            color={255,0,255}));
  connect(cloDam1.y, cloBotDam.u2) annotation (Line(points={{-178,-250},{-140,-250},
          {-140,-218},{-122,-218}}, color={255,0,255}));
  connect(not11.y, assMes7.u)
    annotation (Line(points={{122,-220},{138,-220}}, color={255,0,255}));
  connect(booToInt7.y, yLeaDamAla)
    annotation (Line(points={{162,-180},{260,-180}}, color={255,127,0}));
  connect(greThr.y, truDel2.u)
    annotation (Line(points={{-158,130},{-122,130}}, color={255,0,255}));
  connect(truDel2.y, and1.u1)
    annotation (Line(points={{-98,130},{-42,130}}, color={255,0,255}));
  connect(truDel2.y, and2.u2) annotation (Line(points={{-98,130},{-50,130},{-50,
          202},{-42,202}}, color={255,0,255}));
  connect(not10.y, and7.u2) annotation (Line(points={{-98,-110},{-40,-110},{-40,
          -18},{-22,-18}}, color={255,0,255}));
  connect(and7.y, truDel6.u)
    annotation (Line(points={{2,-10},{38,-10}}, color={255,0,255}));
  connect(truDel6.y, booToInt6.u)
    annotation (Line(points={{62,-10},{138,-10}}, color={255,0,255}));
  connect(truDel6.y, not9.u) annotation (Line(points={{62,-10},{80,-10},{80,-40},
          {98,-40}}, color={255,0,255}));
  connect(leaDamAla2.y, truDel7.u)
    annotation (Line(points={{2,-180},{38,-180}}, color={255,0,255}));
  connect(truDel7.y, booToInt7.u)
    annotation (Line(points={{62,-180},{138,-180}}, color={255,0,255}));
  connect(truDel7.y, not11.u) annotation (Line(points={{62,-180},{80,-180},{80,-220},
          {98,-220}}, color={255,0,255}));
  connect(gre3.y, leaDamAla2.u1) annotation (Line(points={{-58,-10},{-50,-10},{-50,
          -172},{-22,-172}}, color={255,0,255}));
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
          extent={{-96,68},{-46,54}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActSet_flow"),
        Text(
          extent={{-98,96},{-58,84}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-98,-10},{-36,-30}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCooDam"),
        Text(
          extent={{-98,18},{-58,4}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1CooFan"),
        Text(
          extent={{46,90},{96,76}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowFloAla"),
        Text(
          extent={{46,10},{96,-4}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yFloSenAla"),
        Text(
          extent={{36,-68},{96,-84}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaDamAla"),
        Text(
          extent={{-98,-80},{-42,-96}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHeaDam"),
        Text(
          extent={{-98,-52},{-58,-66}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1HeaFan")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-280},{240,280}})),
Documentation(info="<html>
<p>
This block outputs alarms of dual-duct terminal unit using mixing control with discharge flow sensor.
The implementation is according to the Section 5.13.6 of ASHRAE Guideline 36, May 2020.
</p>
<h4>Low airflow</h4>
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
<ul>
<li>
If the cooling and heating fans serving the zone have been OFF (<code>u1CooFan=false</code>
and <code>u1HeaFan=false</code>) for 10 minutes (<code>fanOffTim</code>), and the
discharge airflow sensor reading <code>VDis_flow</code>
is above 10% of the cooling maximum airflow setpoint <code>VCooMax_flow</code>,
generate a Level 3 alarm.
</li>
</ul>
<h4>Leaking damper</h4>
<ul>
<li>
If the cooling and heating damper position (<code>uCooDam</code> and <code>uHeaDam</code>)
are 0% and airflow sensor reading
<code>VDis_flow</code> is above 10% of the cooling maximum airflow setpoint
<code>VCooMax_flow</code> for 10 minutes (<code>leaFloTim</code>) while the
fan serving the zone is proven on (<code>u1CooFan=true</code> or <code>u1HeaFan=true</code>),
generate a Level 4 alarm.
</li>
</ul>
</html>",revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Alarms;
