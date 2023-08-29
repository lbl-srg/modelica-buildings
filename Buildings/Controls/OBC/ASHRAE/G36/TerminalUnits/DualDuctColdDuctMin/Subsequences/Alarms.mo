within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences;
block Alarms "Generate alarms of dual-duct terminal unit with cold-duct minimum control"

  parameter Real staPreMul
    "Importance multiplier for the zone static pressure reset control loop";
  parameter Real VCooMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone cooling maximum airflow rate";
  parameter Real VHeaMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone heating maximum airflow rate";
  parameter Real lowFloTim(
    final unit="s",
    final quantity="Time")=300
    "Threshold time to check low flow rate"
    annotation (__cdl(ValueInReference=true));
  parameter Real fanOffTim(
    final unit="s",
    final quantity="Time")=600
    "Threshold time to check fan off"
    annotation (__cdl(ValueInReference=true));
  parameter Real leaFloTim(
    final unit="s",
    final quantity="Time")=600
    "Threshold time to check damper leaking airflow"
    annotation (__cdl(ValueInReference=true));
  parameter Real floHys(
    final quantity="VolumeFlowRate",
    final unit="m3/s")=0.05
    "Near zero flow rate, below which the flow rate or difference will be seen as zero"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real damPosHys(
    final unit="1")=0.05
    "Near zero damper position, below which the damper will be seen as closed"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real staTim(
    final unit="s",
    final quantity="Time")=1800
    "Delay triggering alarms after enabling AHU supply fan"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active airflow setpoint"
    annotation (Placement(transformation(extent={{-280,220},{-240,260}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VColDucDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured cold-duct discharge airflow rate"
    annotation (Placement(transformation(extent={{-280,30},{-240,70}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1CooFan
    "Cooling air handler supply fan status"
    annotation (Placement(transformation(extent={{-280,-30},{-240,10}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-280,-70},{-240,-30}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooDam(
    final min=0,
    final unit="1")
    "Cold-duct air damper position setpoint"
    annotation (Placement(transformation(extent={{-280,-160},{-240,-120}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotDucDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured hot-duct discharge airflow rate"
    annotation (Placement(transformation(extent={{-280,-200},{-240,-160}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HeaFan
    "Heating air handler supply fan status"
    annotation (Placement(transformation(extent={{-280,-260},{-240,-220}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaDam(
    final min=0,
    final unit="1")
    "Hot-duct air damper position setpoint"
    annotation (Placement(transformation(extent={{-280,-370},{-240,-330}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowFloAla
    "Low airflow alarms"
    annotation (Placement(transformation(extent={{240,240},{280,280}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yColFloSenAla
     "Cold-duct airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{240,30},{280,70}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yColLeaDamAla
     "Leaking cold-duct damper alarm"
    annotation (Placement(transformation(extent={{240,-100},{280,-60}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotFloSenAla
     "Hot-duct airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{240,-200},{280,-160}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotLeaDamAla
     "Leaking hot-duct damper alarm"
    annotation (Placement(transformation(extent={{240,-330},{280,-290}}),
        iconTransformation(extent={{100,-90},{140,-50}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=0.5)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-200,280},{-180,300}})));
  Buildings.Controls.OBC.CDL.Reals.Less les(
    final h=floHys)
    "Check if measured airflow is less than threshold"
    annotation (Placement(transformation(extent={{-160,310},{-140,330}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=lowFloTim)
    "Check if the measured airflow has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,310},{-60,330}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=floHys,
    final h=0.5*floHys)
    "Check if setpoint airflow is greater than zero"
    annotation (Placement(transformation(extent={{-180,230},{-160,250}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre(
    final h=floHys)
    "Check if measured airflow is less than threshold"
    annotation (Placement(transformation(extent={{-160,180},{-140,200}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(
    final k=0.7)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-200,200},{-180,220}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=lowFloTim)
    "Check if the measured airflow has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,180},{-60,200}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Measured airflow has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,310},{-20,330}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Measured airflow has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,230},{-20,250}})));
  Buildings.Controls.OBC.CDL.Integers.Switch lowFloAla
    "Low airflow alarm"
    annotation (Placement(transformation(extent={{140,310},{160,330}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=2)
    "Level 2 alarm"
    annotation (Placement(transformation(extent={{80,350},{100,370}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(
    final integerTrue=3)
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{80,230},{100,250}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conInt1(
    final k=staPreMul)
    "Importance multiplier for zone static pressure reset"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1
    "Check if the multiplier is greater than zero"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Suppress the alarm when multiplier is zero"
    annotation (Placement(transformation(extent={{140,140},{160,160}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt
    "Low flow alarms"
    annotation (Placement(transformation(extent={{200,250},{220,270}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and3
    "Logical and"
    annotation (Placement(transformation(extent={{20,310},{40,330}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{80,270},{100,290}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Warning: airflow is less than 50% of the setpoint.")
    "Level 2 low airflow alarm"
    annotation (Placement(transformation(extent={{140,270},{160,290}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and4
    "Logical and"
    annotation (Placement(transformation(extent={{20,230},{40,250}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{80,190},{100,210}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(
    final message="Warning: airflow is less than 70% of the setpoint.")
    "Level 3 low airflow alarm"
    annotation (Placement(transformation(extent={{140,190},{160,210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooMaxFlo(
    final k=VCooMax_flow)  "Cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-180,20},{-160,40}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai2(
    final k=0.1)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical not"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=fanOffTim)
    "Check if the input has been true for more than threshold time"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre1(
    final h=floHys)
    "Check if measured airflow is greater than threshold"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Check if the measured airflow is greater than the threshold and the supply fan is OFF"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4
    "Logical not"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes2(
    final message="Warning: cold-duct airflow sensor should be calibrated.")
    "Level 3 airflow sensor alarm"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2(
    final integerTrue=3)
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{160,40},{180,60}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(
    final delayTime=leaFloTim)
    "Check if the input has been true for more than threshold time"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold cloDam(
    final t=damPosHys,
    final h=0.5*damPosHys) "Check if damper position is near zero"
    annotation (Placement(transformation(extent={{-180,-150},{-160,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And3 leaDamAla
    "Check if generating leak damper alarms"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5
    "Logical not"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes3(
    final message="Warning: the cold-duct damper is leaking.")
    "Level 4 leaking damper alarm"
    annotation (Placement(transformation(extent={{160,-130},{180,-110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3(
    final integerTrue=4)
    "Convert boolean true to level 4 alarm"
    annotation (Placement(transformation(extent={{160,-90},{180,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant heaMaxFlo(
    final k=VHeaMax_flow)
     "Heating maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-180,-210},{-160,-190}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai3(final k=0.1)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-140,-210},{-120,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Not not6
    "Logical not"
    annotation (Placement(transformation(extent={{-180,-250},{-160,-230}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel4(
    final delayTime=fanOffTim)
    "Check if the input has been true for more than threshold time"
    annotation (Placement(transformation(extent={{20,-190},{40,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre2(
    final h=floHys)
    "Check if measured airflow is greater than threshold"
    annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));
  Buildings.Controls.OBC.CDL.Logical.And and6
    "Check if the measured airflow is greater than the threshold and the supply fan is OFF"
    annotation (Placement(transformation(extent={{-20,-190},{0,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not7
    "Logical not"
    annotation (Placement(transformation(extent={{60,-220},{80,-200}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes4(
    final message="Warning: hot-duct airflow sensor should be calibrated.")
    "Level 3 airflow sensor alarm"
    annotation (Placement(transformation(extent={{100,-220},{120,-200}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt4(
    final integerTrue=3)
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{160,-190},{180,-170}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel5(
    final delayTime=leaFloTim)
    "Check if the input has been true for more than threshold time"
    annotation (Placement(transformation(extent={{60,-320},{80,-300}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold cloDam1(
    final t=damPosHys,
    final h=0.5*damPosHys)
    "Check if damper position is near zero"
    annotation (Placement(transformation(extent={{-180,-360},{-160,-340}})));
  Buildings.Controls.OBC.CDL.Logical.And3 leaDamAla1
    "Check if generating leak damper alarms"
    annotation (Placement(transformation(extent={{0,-320},{20,-300}})));
  Buildings.Controls.OBC.CDL.Logical.Not not8
    "Logical not"
    annotation (Placement(transformation(extent={{120,-360},{140,-340}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes5(
    final message="Warning: the hot-duct damper is leaking.")
    "Level 4 leaking damper alarm"
    annotation (Placement(transformation(extent={{160,-360},{180,-340}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt5(
    final integerTrue=4)
    "Convert boolean true to level 4 alarm"
    annotation (Placement(transformation(extent={{160,-320},{180,-300}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    "Total discharge airflow"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel6(
    final delayTime=lowFloTim)
    "Check if the active flow setpoint has been greater than zero for the threshold time"
    annotation (Placement(transformation(extent={{-120,230},{-100,250}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay fanIni(
    final delayTime=staTim)
    "Check if the AHU supply fan has been enabled for threshold time"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  Buildings.Controls.OBC.CDL.Logical.And  and11
    "True: AHU fan is enabled and the discharge flow is lower than the threshold"
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));
  Buildings.Controls.OBC.CDL.Logical.And  and10
    "True: AHU fan is enabled and the discharge flow is lower than the threshold"
    annotation (Placement(transformation(extent={{-120,310},{-100,330}})));
  Buildings.Controls.OBC.CDL.Logical.Or fanOn
    "Check if any AHU supply fan is enabled"
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Occupied mode"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isOcc
    "Check if current operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation
  connect(VActSet_flow, gai.u) annotation (Line(points={{-260,240},{-210,240},{
          -210,290},{-202,290}},
                             color={0,0,127}));
  connect(VActSet_flow, greThr.u)
    annotation (Line(points={{-260,240},{-182,240}}, color={0,0,127}));
  connect(VActSet_flow, gai1.u) annotation (Line(points={{-260,240},{-210,240},{
          -210,210},{-202,210}},  color={0,0,127}));
  connect(gai1.y, gre.u1) annotation (Line(points={{-178,210},{-170,210},{-170,
          190},{-162,190}}, color={0,0,127}));
  connect(truDel.y, and2.u1)
    annotation (Line(points={{-58,320},{-42,320}}, color={255,0,255}));
  connect(truDel1.y, and1.u2) annotation (Line(points={{-58,190},{-50,190},{-50,
          232},{-42,232}}, color={255,0,255}));
  connect(conInt.y, lowFloAla.u1) annotation (Line(points={{102,360},{120,360},{
          120,328},{138,328}}, color={255,127,0}));
  connect(booToInt.y, lowFloAla.u3) annotation (Line(points={{102,240},{120,240},
          {120,312},{138,312}},color={255,127,0}));
  connect(conInt1.y, greThr1.u)
    annotation (Line(points={{-98,150},{-82,150}}, color={0,0,127}));
  connect(greThr1.y, booToInt1.u)
    annotation (Line(points={{-58,150},{138,150}}, color={255,0,255}));
  connect(lowFloAla.y, proInt.u1) annotation (Line(points={{162,320},{180,320},{
          180,266},{198,266}}, color={255,127,0}));
  connect(booToInt1.y, proInt.u2) annotation (Line(points={{162,150},{180,150},{
          180,254},{198,254}},  color={255,127,0}));
  connect(not1.y, assMes.u)
    annotation (Line(points={{102,280},{138,280}}, color={255,0,255}));
  connect(and2.y, and3.u1) annotation (Line(points={{-18,320},{-10,320},{-10,328},
          {18,328}},      color={255,0,255}));
  connect(greThr1.y, and3.u2) annotation (Line(points={{-58,150},{0,150},{0,320},
          {18,320}},      color={255,0,255}));
  connect(and1.y, and4.u1) annotation (Line(points={{-18,240},{-10,240},{-10,248},
          {18,248}},color={255,0,255}));
  connect(greThr1.y, and4.u2) annotation (Line(points={{-58,150},{0,150},{0,240},
          {18,240}},      color={255,0,255}));
  connect(not2.y, assMes1.u)
    annotation (Line(points={{102,200},{138,200}}, color={255,0,255}));
  connect(cooMaxFlo.y, gai2.u)
    annotation (Line(points={{-158,30},{-142,30}},   color={0,0,127}));
  connect(u1CooFan, not3.u)
    annotation (Line(points={{-260,-10},{-182,-10}}, color={255,0,255}));
  connect(gai2.y, gre1.u2) annotation (Line(points={{-118,30},{-100,30},{-100,42},
          {-82,42}},        color={0,0,127}));
  connect(gre1.y, and5.u1)
    annotation (Line(points={{-58,50},{-22,50}}, color={255,0,255}));
  connect(not4.y, assMes2.u)
    annotation (Line(points={{82,20},{98,20}}, color={255,0,255}));
  connect(booToInt2.y, yColFloSenAla)
    annotation (Line(points={{182,50},{260,50}}, color={255,127,0}));
  connect(proInt.y, yLowFloAla)
    annotation (Line(points={{222,260},{260,260}}, color={255,127,0}));
  connect(uCooDam, cloDam.u)
    annotation (Line(points={{-260,-140},{-182,-140}}, color={0,0,127}));
  connect(u1CooFan, leaDamAla.u2) annotation (Line(points={{-260,-10},{-210,-10},
          {-210,-80},{-2,-80}}, color={255,0,255}));
  connect(cloDam.y, leaDamAla.u3) annotation (Line(points={{-158,-140},{-20,-140},
          {-20,-88},{-2,-88}},  color={255,0,255}));
  connect(not5.y, assMes3.u)
    annotation (Line(points={{142,-120},{158,-120}}, color={255,0,255}));
  connect(booToInt3.y, yColLeaDamAla)
    annotation (Line(points={{182,-80},{260,-80}},   color={255,127,0}));
  connect(VColDucDis_flow, gre1.u1)
    annotation (Line(points={{-260,50},{-82,50}},    color={0,0,127}));
  connect(heaMaxFlo.y, gai3.u)
    annotation (Line(points={{-158,-200},{-142,-200}}, color={0,0,127}));
  connect(u1HeaFan, not6.u)
    annotation (Line(points={{-260,-240},{-182,-240}}, color={255,0,255}));
  connect(gai3.y,gre2. u2) annotation (Line(points={{-118,-200},{-100,-200},{-100,
          -188},{-82,-188}},  color={0,0,127}));
  connect(gre2.y,and6. u1)
    annotation (Line(points={{-58,-180},{-22,-180}}, color={255,0,255}));
  connect(not7.y,assMes4. u)
    annotation (Line(points={{82,-210},{98,-210}}, color={255,0,255}));
  connect(booToInt4.y, yHotFloSenAla)
    annotation (Line(points={{182,-180},{260,-180}}, color={255,127,0}));
  connect(uHeaDam, cloDam1.u)
    annotation (Line(points={{-260,-350},{-182,-350}}, color={0,0,127}));
  connect(u1HeaFan, leaDamAla1.u2) annotation (Line(points={{-260,-240},{-220,-240},
          {-220,-310},{-2,-310}}, color={255,0,255}));
  connect(cloDam1.y, leaDamAla1.u3) annotation (Line(points={{-158,-350},{-20,-350},
          {-20,-318},{-2,-318}},color={255,0,255}));
  connect(not8.y,assMes5. u)
    annotation (Line(points={{142,-350},{158,-350}}, color={255,0,255}));
  connect(booToInt5.y, yHotLeaDamAla)
    annotation (Line(points={{182,-310},{260,-310}}, color={255,127,0}));
  connect(VHotDucDis_flow, gre2.u1)
    annotation (Line(points={{-260,-180},{-82,-180}},  color={0,0,127}));
  connect(VColDucDis_flow, add2.u1) annotation (Line(points={{-260,50},{-120,50},
          {-120,96},{-102,96}},   color={0,0,127}));
  connect(VHotDucDis_flow, add2.u2) annotation (Line(points={{-260,-180},{-110,-180},
          {-110,84},{-102,84}},   color={0,0,127}));
  connect(add2.y, les.u1) annotation (Line(points={{-78,90},{-60,90},{-60,120},{
          -220,120},{-220,320},{-162,320}},  color={0,0,127}));
  connect(add2.y, gre.u2) annotation (Line(points={{-78,90},{-60,90},{-60,120},
          {-220,120},{-220,182},{-162,182}}, color={0,0,127}));
  connect(greThr.y, truDel6.u)
    annotation (Line(points={{-158,240},{-122,240}}, color={255,0,255}));
  connect(truDel6.y, and1.u1)
    annotation (Line(points={{-98,240},{-42,240}}, color={255,0,255}));
  connect(truDel6.y, and2.u2) annotation (Line(points={{-98,240},{-50,240},{-50,
          312},{-42,312}}, color={255,0,255}));
  connect(leaDamAla.y, truDel3.u)
    annotation (Line(points={{22,-80},{58,-80}}, color={255,0,255}));
  connect(truDel3.y, booToInt3.u)
    annotation (Line(points={{82,-80},{158,-80}}, color={255,0,255}));
  connect(truDel3.y, not5.u) annotation (Line(points={{82,-80},{100,-80},{100,-120},
          {118,-120}}, color={255,0,255}));
  connect(not3.y, and5.u2) annotation (Line(points={{-158,-10},{-40,-10},{-40,42},
          {-22,42}}, color={255,0,255}));
  connect(and5.y, truDel2.u)
    annotation (Line(points={{2,50},{18,50}}, color={255,0,255}));
  connect(truDel2.y, booToInt2.u)
    annotation (Line(points={{42,50},{158,50}}, color={255,0,255}));
  connect(truDel2.y, not4.u) annotation (Line(points={{42,50},{50,50},{50,20},{58,
          20}}, color={255,0,255}));
  connect(gre1.y, leaDamAla.u1) annotation (Line(points={{-58,50},{-30,50},{-30,
          -72},{-2,-72}}, color={255,0,255}));
  connect(leaDamAla1.y, truDel5.u)
    annotation (Line(points={{22,-310},{58,-310}}, color={255,0,255}));
  connect(truDel5.y, booToInt5.u)
    annotation (Line(points={{82,-310},{158,-310}}, color={255,0,255}));
  connect(truDel5.y, not8.u) annotation (Line(points={{82,-310},{100,-310},{100,
          -350},{118,-350}}, color={255,0,255}));
  connect(and6.y, truDel4.u)
    annotation (Line(points={{2,-180},{18,-180}}, color={255,0,255}));
  connect(truDel4.y, booToInt4.u)
    annotation (Line(points={{42,-180},{158,-180}}, color={255,0,255}));
  connect(not6.y, and6.u2) annotation (Line(points={{-158,-240},{-40,-240},{-40,
          -188},{-22,-188}}, color={255,0,255}));
  connect(gre2.y, leaDamAla1.u1) annotation (Line(points={{-58,-180},{-30,-180},
          {-30,-302},{-2,-302}}, color={255,0,255}));
  connect(truDel4.y, not7.u) annotation (Line(points={{42,-180},{50,-180},{50,-210},
          {58,-210}}, color={255,0,255}));
  connect(les.y, and10.u1)
    annotation (Line(points={{-138,320},{-122,320}}, color={255,0,255}));
  connect(and10.y, truDel.u)
    annotation (Line(points={{-98,320},{-82,320}}, color={255,0,255}));
  connect(gre.y, and11.u1)
    annotation (Line(points={{-138,190},{-122,190}}, color={255,0,255}));
  connect(and11.y, truDel1.u)
    annotation (Line(points={{-98,190},{-82,190}}, color={255,0,255}));
  connect(fanOn.y, fanIni.u)
    annotation (Line(points={{-178,90},{-162,90}}, color={255,0,255}));
  connect(fanIni.y, and10.u2) annotation (Line(points={{-138,90},{-130,90},{
          -130,312},{-122,312}}, color={255,0,255}));
  connect(u1CooFan, fanOn.u2) annotation (Line(points={{-260,-10},{-210,-10},{-210,
          82},{-202,82}}, color={255,0,255}));
  connect(u1HeaFan, fanOn.u1) annotation (Line(points={{-260,-240},{-220,-240},{
          -220,90},{-202,90}}, color={255,0,255}));
  connect(uOpeMod,isOcc. u1)
    annotation (Line(points={{-260,-50},{-82,-50}},    color={255,127,0}));
  connect(occMod.y, isOcc.u2) annotation (Line(points={{-138,-100},{-100,-100},{
          -100,-58},{-82,-58}}, color={255,127,0}));
  connect(isOcc.y, and3.u3) annotation (Line(points={{-58,-50},{10,-50},{10,312},
          {18,312}}, color={255,0,255}));
  connect(isOcc.y, and4.u3) annotation (Line(points={{-58,-50},{10,-50},{10,232},
          {18,232}}, color={255,0,255}));
  connect(and3.y, not1.u) annotation (Line(points={{42,320},{60,320},{60,280},{78,
          280}}, color={255,0,255}));
  connect(and3.y, lowFloAla.u2)
    annotation (Line(points={{42,320},{138,320}}, color={255,0,255}));
  connect(and4.y, booToInt.u)
    annotation (Line(points={{42,240},{78,240}}, color={255,0,255}));
  connect(and4.y, not2.u) annotation (Line(points={{42,240},{60,240},{60,200},{78,
          200}}, color={255,0,255}));
  connect(fanIni.y, and11.u2) annotation (Line(points={{-138,90},{-130,90},{
          -130,182},{-122,182}}, color={255,0,255}));
  connect(gai.y, les.u2) annotation (Line(points={{-178,290},{-170,290},{-170,
          312},{-162,312}}, color={0,0,127}));
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
          extent={{-96,98},{-46,84}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActSet_flow"),
        Text(
          extent={{-98,-12},{-38,-28}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCooDam"),
        Text(
          extent={{-98,48},{-50,34}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1CooFan"),
        Text(
          extent={{46,90},{96,76}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowFloAla"),
        Text(
          extent={{-98,68},{-28,52}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VColDucDis_flow"),
        Text(
          extent={{-100,-72},{-28,-90}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHeaDam"),
        Text(
          extent={{-96,-52},{-52,-68}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1HeaFan"),
        Text(
          extent={{-98,-30},{-12,-50}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VHotDucDis_flow"),
        Text(
          extent={{36,40},{96,24}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yColFloSenAla"),
        Text(
          extent={{34,10},{98,-6}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yColLeaDamAla"),
        Text(
          extent={{36,-30},{96,-46}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHotFloSenAla"),
        Text(
          extent={{34,-60},{98,-76}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHotLeaDamAla"),
        Text(
          extent={{-98,18},{-48,2}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-380},{240,380}})),
Documentation(info="<html>
<p>
This block outputs alarms of dual-duct terminal unit with cold-duct minimum control. The
implementation is according to the Section 5.14.6 of ASHRAE Guideline 36, May 2020.
Note that the sequence uses two airflow sensors, one at each inlet.
</p>
<h4>Low airflow</h4>
<ol>
<li>
If the zone is in occupied mode and after the AHU supply fan has been enabled for <code>staTim</code>,
if the measured airflow (<code>VColDucDis_flow</code> plus <code>VHotDucDis_flow</code>) is less than 70% of setpoint
<code>VActSet_flow</code> for 5 minutes (<code>lowFloTim</code>) while the setpoint
is greater than zero, generate a Level 3 alarm.
</li>
<li>
If the zone is in occupied mode and after the AHU supply fan has been enabled for <code>staTim</code>,
if the measured airflow (<code>VColDucDis_flow</code> plus <code>VHotDucDis_flow</code>) is less than 50% of setpoint
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
If the cooling fan serving the zone has been OFF (<code>u1CooFan=false</code>) for 10 minutes
(<code>fanOffTim</code>), and the cold-duct airflow sensor reading <code>VColDucDis_flow</code>
is above 10% of the cooling maximum airflow setpoint <code>VCooMax_flow</code>,
generate a Level 3 alarm.
</li>
<li>
If the heating fan serving the zone has been OFF (<code>u1HeaFan=false</code>) for 10 minutes
(<code>fanOffTim</code>), and the hot-duct airflow sensor reading <code>VHotDucDis_flow</code>
is above 10% of the heating maximum airflow setpoint <code>VHeaMax_flow</code>,
generate a Level 3 alarm.
</li>
</ul>
<h4>Leaking damper</h4>
<ul>
<li>
If the cooling damper position (<code>uCooDam</code>) is 0% and airflow sensor reading
<code>VColDucDis_flow</code> is above 10% of the cooling maximum airflow setpoint
<code>VCooMax_flow</code> for 10 minutes (<code>leaFloTim</code>) while the
fan serving the zone is proven on (<code>u1CooFan=true</code>), generate a Level
4 alarm.
</li>
<li>
If the heating damper position (<code>uHeaDam</code>) is 0% and airflow sensor reading
<code>VHotDucDis_flow</code> is above 10% of the heating maximum airflow setpoint
<code>VHeaMax_flow</code> for 10 minutes (<code>leaFloTim</code>) while the
fan serving the zone is proven on (<code>u1HeaFan=true</code>), generate a Level
4 alarm.
</li>
</ul>
</html>",revisions="<html>
<ul>
<li>
August 23, 2023, by Jianjun Hu:<br/>
Added delay <code>staTim</code> to allow the system becoming stablized.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3257\">issue 3257</a>.
</li>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Alarms;
