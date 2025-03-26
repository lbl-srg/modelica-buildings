within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences;
block Alarms "Generate alarms of snap-acting controlled dual-duct terminal unit"

  parameter Boolean have_duaSen
    "True: the unit have dual inlet flow sensor";
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

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") if not have_duaSen
    "Measured discharge airflow rate"
    annotation (Placement(transformation(extent={{-280,400},{-240,440}}),
        iconTransformation(extent={{-140,160},{-100,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active airflow setpoint"
    annotation (Placement(transformation(extent={{-280,320},{-240,360}}),
        iconTransformation(extent={{-140,130},{-100,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-280,50},{-240,90}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VColDucDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") if have_duaSen
    "Measured cold-duct discharge airflow rate"
    annotation (Placement(transformation(extent={{-280,-80},{-240,-40}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1CooFan
    "Cooling air handler supply fan status"
    annotation (Placement(transformation(extent={{-280,-140},{-240,-100}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooDam(
    final min=0,
    final unit="1")
    "Cooling damper position setpoint"
    annotation (Placement(transformation(extent={{-280,-250},{-240,-210}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotDucDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") if have_duaSen
    "Measured hot-duct discharge airflow rate"
    annotation (Placement(transformation(extent={{-280,-310},{-240,-270}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HeaFan
    "Heating air handler supply fan status"
    annotation (Placement(transformation(extent={{-280,-370},{-240,-330}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaDam(
    final min=0,
    final unit="1")
    "Heating damper position setpoint"
    annotation (Placement(transformation(extent={{-280,-480},{-240,-440}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowFloAla
    "Low airflow alarms"
    annotation (Placement(transformation(extent={{240,340},{280,380}}),
        iconTransformation(extent={{100,160},{140,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFloSenAla
    if not have_duaSen
    "Airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{240,180},{280,220}}),
        iconTransformation(extent={{100,110},{140,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaDamAla
    if not have_duaSen
    "Leaking dampers alarm, could be heating or cooling damper"
    annotation (Placement(transformation(extent={{240,10},{280,50}}),
        iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yColFloSenAla
    if have_duaSen "Cold-duct airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{240,-80},{280,-40}}),
        iconTransformation(extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yColLeaDamAla
    if have_duaSen "Leaking cold-duct damper alarm"
    annotation (Placement(transformation(extent={{240,-210},{280,-170}}),
        iconTransformation(extent={{100,-120},{140,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotFloSenAla
    if have_duaSen "Hot-duct airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{240,-310},{280,-270}}),
        iconTransformation(extent={{100,-160},{140,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotLeaDamAla
    if have_duaSen "Leaking hot-duct damper alarm"
    annotation (Placement(transformation(extent={{240,-440},{280,-400}}),
        iconTransformation(extent={{100,-190},{140,-150}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=0.5)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-200,380},{-180,400}})));
  Buildings.Controls.OBC.CDL.Reals.Less les(
    final h=floHys)
    "Check if measured airflow is less than threshold"
    annotation (Placement(transformation(extent={{-160,410},{-140,430}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=lowFloTim)
    "Check if the measured airflow has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,410},{-60,430}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=floHys,
    final h=0.5*floHys)
    "Check if setpoint airflow is greater than zero"
    annotation (Placement(transformation(extent={{-180,330},{-160,350}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre(
    final h=floHys)
    "Check if measured airflow is less than threshold"
    annotation (Placement(transformation(extent={{-160,280},{-140,300}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(
    final k=0.7)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-200,300},{-180,320}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=lowFloTim)
    "Check if the measured airflow has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,280},{-60,300}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Measured airflow has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,410},{-20,430}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Measured airflow has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,330},{-20,350}})));
  Buildings.Controls.OBC.CDL.Integers.Switch lowFloAla
    "Low airflow alarm"
    annotation (Placement(transformation(extent={{140,410},{160,430}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=2)
    "Level 2 alarm"
    annotation (Placement(transformation(extent={{80,450},{100,470}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(
    final integerTrue=3)
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{80,330},{100,350}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conInt1(
    final k=staPreMul)
    "Importance multiplier for zone static pressure reset"
    annotation (Placement(transformation(extent={{-120,240},{-100,260}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1
    "Check if the multiplier is greater than zero"
    annotation (Placement(transformation(extent={{-80,240},{-60,260}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Suppress the alarm when multiplier is zero"
    annotation (Placement(transformation(extent={{140,240},{160,260}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt
    "Low flow alarms"
    annotation (Placement(transformation(extent={{200,350},{220,370}})));
  Buildings.Controls.OBC.CDL.Logical.And and8
    "Logical and"
    annotation (Placement(transformation(extent={{0,410},{20,430}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{80,370},{100,390}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Warning: airflow is less than 50% of the setpoint.")
    "Level 2 low airflow alarm"
    annotation (Placement(transformation(extent={{140,370},{160,390}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Logical and"
    annotation (Placement(transformation(extent={{0,330},{20,350}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{80,290},{100,310}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(
    final message="Warning: airflow is less than 70% of the setpoint.")
    "Level 3 low airflow alarm"
    annotation (Placement(transformation(extent={{140,290},{160,310}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooMaxFlo(
    final k=VCooMax_flow) if have_duaSen "Cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-200,-90},{-180,-70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai2(
    final k=0.1) if have_duaSen
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 if have_duaSen
    "Logical not"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=fanOffTim) if have_duaSen
    "Check if the input has been true for more than threshold time"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre1(
    final h=floHys) if have_duaSen
    "Check if measured airflow is greater than threshold"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And and5 if have_duaSen
    "Check if the measured airflow is greater than the threshold and the supply fan is OFF"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 if have_duaSen
    "Logical not"
    annotation (Placement(transformation(extent={{100,-110},{120,-90}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes2(
    final message="Warning: cold-duct airflow sensor should be calibrated.")
    if have_duaSen
    "Level 3 airflow sensor alarm"
    annotation (Placement(transformation(extent={{140,-110},{160,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2(
    final integerTrue=3) if have_duaSen
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{140,-70},{160,-50}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(
    final delayTime=leaFloTim) if have_duaSen
    "Check if the input has been true for more than threshold time"
    annotation (Placement(transformation(extent={{40,-200},{60,-180}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold cloDam(
    final t=damPosHys,
    final h=0.5*damPosHys) "Check if damper position is near zero"
    annotation (Placement(transformation(extent={{-200,-240},{-180,-220}})));
  Buildings.Controls.OBC.CDL.Logical.And leaDamAla if have_duaSen
    "Check if generating leak damper alarms"
    annotation (Placement(transformation(extent={{-40,-200},{-20,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5 if have_duaSen
    "Logical not"
    annotation (Placement(transformation(extent={{100,-240},{120,-220}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes3(
    final message="Warning: the cold-duct damper is leaking.")
    if have_duaSen
    "Level 4 leaking damper alarm"
    annotation (Placement(transformation(extent={{140,-240},{160,-220}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3(
    final integerTrue=4) if have_duaSen
    "Convert boolean true to level 4 alarm"
    annotation (Placement(transformation(extent={{140,-200},{160,-180}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant heaMaxFlo(
    final k=VHeaMax_flow)
    if have_duaSen "Heating maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-200,-320},{-180,-300}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai3(final k=0.1)
    if have_duaSen
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-160,-320},{-140,-300}})));
  Buildings.Controls.OBC.CDL.Logical.Not not6 if have_duaSen
    "Logical not"
    annotation (Placement(transformation(extent={{-200,-360},{-180,-340}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel4(
    final delayTime=fanOffTim) if have_duaSen
    "Check if the input has been true for more than threshold time"
    annotation (Placement(transformation(extent={{20,-300},{40,-280}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre2(
    final h=floHys)
    if have_duaSen
    "Check if measured airflow is greater than threshold"
    annotation (Placement(transformation(extent={{-100,-300},{-80,-280}})));
  Buildings.Controls.OBC.CDL.Logical.And and6 if have_duaSen
    "Check if the measured airflow is greater than the threshold and the supply fan is OFF"
    annotation (Placement(transformation(extent={{-20,-300},{0,-280}})));
  Buildings.Controls.OBC.CDL.Logical.Not not7 if have_duaSen
    "Logical not"
    annotation (Placement(transformation(extent={{100,-340},{120,-320}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes4(
    final message="Warning: hot-duct airflow sensor should be calibrated.")
    if have_duaSen
    "Level 3 airflow sensor alarm"
    annotation (Placement(transformation(extent={{140,-340},{160,-320}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt4(
    final integerTrue=3) if have_duaSen
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{140,-300},{160,-280}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel5(
    final delayTime=leaFloTim) if have_duaSen
    "Check if the input has been true for more than threshold time"
    annotation (Placement(transformation(extent={{40,-430},{60,-410}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold cloDam1(
    final t=damPosHys,
    final h=0.5*damPosHys)
    "Check if damper position is near zero"
    annotation (Placement(transformation(extent={{-200,-470},{-180,-450}})));
  Buildings.Controls.OBC.CDL.Logical.And leaDamAla1 if have_duaSen
    "Check if generating leak damper alarms"
    annotation (Placement(transformation(extent={{-40,-430},{-20,-410}})));
  Buildings.Controls.OBC.CDL.Logical.Not not8 if have_duaSen
    "Logical not"
    annotation (Placement(transformation(extent={{100,-470},{120,-450}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes5(
    final message="Warning: the hot-duct damper is leaking.")
    if have_duaSen
    "Level 4 leaking damper alarm"
    annotation (Placement(transformation(extent={{140,-470},{160,-450}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt5(
    final integerTrue=4) if have_duaSen
    "Convert boolean true to level 4 alarm"
    annotation (Placement(transformation(extent={{140,-430},{160,-410}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooMaxFlo1(
    final k=VCooMax_flow) if not have_duaSen
    "Cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai4(
    final k=0.1)
    if not have_duaSen
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre3(
    final h=floHys)
    if not have_duaSen
    "Check if measured airflow is greater than threshold"
    annotation (Placement(transformation(extent={{-60,190},{-40,210}})));
  Buildings.Controls.OBC.CDL.Logical.And and7 if not have_duaSen
    "Check if the measured airflow is greater than the threshold and the supply fan is OFF"
    annotation (Placement(transformation(extent={{0,190},{20,210}})));
  Buildings.Controls.OBC.CDL.Logical.Not not9 if not have_duaSen
    "Logical not"
    annotation (Placement(transformation(extent={{140,150},{160,170}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes6(
    final message="Warning: airflow sensor should be calibrated.")
    if not have_duaSen
    "Level 3 airflow sensor alarm"
    annotation (Placement(transformation(extent={{180,150},{200,170}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt6(
    final integerTrue=3) if not have_duaSen
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{140,190},{160,210}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 if not have_duaSen
    "Check if there is any supply fan proven on"
    annotation (Placement(transformation(extent={{-200,90},{-180,110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel6(
    final delayTime=fanOffTim) if not have_duaSen
    "Check if the input has been true for more than threshold time"
    annotation (Placement(transformation(extent={{60,190},{80,210}})));
  Buildings.Controls.OBC.CDL.Logical.Not not10 if not have_duaSen
    "Logical not"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel7(
    final delayTime=leaFloTim) if not have_duaSen
    "Check if the input has been true for more than threshold time"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Buildings.Controls.OBC.CDL.Logical.And leaDamAla2 if not have_duaSen
    "Check if generating leak damper alarms"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Logical.And cloBotDam if not have_duaSen
    "Both heating and cooling dampers are closed"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not11 if not have_duaSen
    "Logical not"
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes7(
    final message="Warning: the cold-duct or hot-dcut damper is leaking.")
    if not have_duaSen
    "Level 4 leaking damper alarm"
    annotation (Placement(transformation(extent={{160,-20},{180,0}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt7(
    final integerTrue=4) if not have_duaSen
    "Convert boolean true to level 4 alarm"
    annotation (Placement(transformation(extent={{140,20},{160,40}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2 if have_duaSen
    "Total discharge airflow"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel8(
    final delayTime=lowFloTim)
    "Check if the active flow setpoint has been greater than zero for the threshold time"
    annotation (Placement(transformation(extent={{-120,330},{-100,350}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay fanIni(
    final delayTime=staTim)
    "Check if the AHU supply fan has been enabled for threshold time"
    annotation (Placement(transformation(extent={{-160,220},{-140,240}})));
  Buildings.Controls.OBC.CDL.Logical.And and11
    "True: AHU fan is enabled and the discharge flow is lower than the threshold"
    annotation (Placement(transformation(extent={{-120,280},{-100,300}})));
  Buildings.Controls.OBC.CDL.Logical.And and10
    "True: AHU fan is enabled and the discharge flow is lower than the threshold"
    annotation (Placement(transformation(extent={{-120,410},{-100,430}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Check if there is any supply fan proven on"
    annotation (Placement(transformation(extent={{-200,140},{-180,160}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Occupied mode"
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isOcc
    "Check if current operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{40,330},{60,350}})));
  Buildings.Controls.OBC.CDL.Logical.And and9
    "Logical and"
    annotation (Placement(transformation(extent={{40,410},{60,430}})));
  Buildings.Controls.OBC.CDL.Logical.And leaDamAla3 if not have_duaSen
    "Check if generating leak damper alarms"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Controls.OBC.CDL.Logical.And  leaDamAla4 if have_duaSen
    "Check if generating leak damper alarms"
    annotation (Placement(transformation(extent={{0,-200},{20,-180}})));
  Buildings.Controls.OBC.CDL.Logical.And leaDamAla5 if have_duaSen
    "Check if generating leak damper alarms"
    annotation (Placement(transformation(extent={{0,-430},{20,-410}})));
equation
  connect(VActSet_flow, gai.u) annotation (Line(points={{-260,340},{-210,340},{
          -210,390},{-202,390}}, color={0,0,127}));
  connect(VDis_flow, les.u1)
    annotation (Line(points={{-260,420},{-162,420}}, color={0,0,127}));
  connect(VActSet_flow, greThr.u)
    annotation (Line(points={{-260,340},{-182,340}}, color={0,0,127}));
  connect(VActSet_flow, gai1.u) annotation (Line(points={{-260,340},{-210,340},{
          -210,310},{-202,310}}, color={0,0,127}));
  connect(VDis_flow, gre.u2) annotation (Line(points={{-260,420},{-220,420},{
          -220,282},{-162,282}}, color={0,0,127}));
  connect(gai1.y, gre.u1) annotation (Line(points={{-178,310},{-170,310},{-170,
          290},{-162,290}}, color={0,0,127}));
  connect(truDel.y, and2.u1)
    annotation (Line(points={{-58,420},{-42,420}}, color={255,0,255}));
  connect(truDel1.y, and1.u2) annotation (Line(points={{-58,290},{-50,290},{-50,
          332},{-42,332}}, color={255,0,255}));
  connect(conInt.y, lowFloAla.u1) annotation (Line(points={{102,460},{120,460},{
          120,428},{138,428}}, color={255,127,0}));
  connect(booToInt.y, lowFloAla.u3) annotation (Line(points={{102,340},{120,340},
          {120,412},{138,412}},color={255,127,0}));
  connect(conInt1.y, greThr1.u)
    annotation (Line(points={{-98,250},{-82,250}}, color={0,0,127}));
  connect(greThr1.y, booToInt1.u)
    annotation (Line(points={{-58,250},{138,250}}, color={255,0,255}));
  connect(lowFloAla.y, proInt.u1) annotation (Line(points={{162,420},{180,420},{
          180,366},{198,366}}, color={255,127,0}));
  connect(booToInt1.y, proInt.u2) annotation (Line(points={{162,250},{180,250},{
          180,354},{198,354}},  color={255,127,0}));
  connect(not1.y, assMes.u)
    annotation (Line(points={{102,380},{138,380}}, color={255,0,255}));
  connect(and2.y,and8. u1) annotation (Line(points={{-18,420},{-2,420}},
                          color={255,0,255}));
  connect(greThr1.y,and8. u2) annotation (Line(points={{-58,250},{-10,250},{-10,
          412},{-2,412}}, color={255,0,255}));
  connect(and1.y, and4.u1) annotation (Line(points={{-18,340},{-2,340}},
                    color={255,0,255}));
  connect(greThr1.y, and4.u2) annotation (Line(points={{-58,250},{-10,250},{-10,
          332},{-2,332}}, color={255,0,255}));
  connect(not2.y, assMes1.u)
    annotation (Line(points={{102,300},{138,300}}, color={255,0,255}));
  connect(cooMaxFlo.y, gai2.u)
    annotation (Line(points={{-178,-80},{-162,-80}}, color={0,0,127}));
  connect(u1CooFan, not3.u)
    annotation (Line(points={{-260,-120},{-202,-120}}, color={255,0,255}));
  connect(gai2.y, gre1.u2) annotation (Line(points={{-138,-80},{-120,-80},{-120,
          -68},{-102,-68}}, color={0,0,127}));
  connect(gre1.y, and5.u1)
    annotation (Line(points={{-78,-60},{-22,-60}}, color={255,0,255}));
  connect(not4.y, assMes2.u)
    annotation (Line(points={{122,-100},{138,-100}}, color={255,0,255}));
  connect(booToInt2.y, yColFloSenAla)
    annotation (Line(points={{162,-60},{260,-60}}, color={255,127,0}));
  connect(proInt.y, yLowFloAla)
    annotation (Line(points={{222,360},{260,360}}, color={255,127,0}));
  connect(uCooDam, cloDam.u)
    annotation (Line(points={{-260,-230},{-202,-230}}, color={0,0,127}));
  connect(u1CooFan, leaDamAla.u2) annotation (Line(points={{-260,-120},{-220,-120},
          {-220,-198},{-42,-198}},color={255,0,255}));
  connect(not5.y, assMes3.u)
    annotation (Line(points={{122,-230},{138,-230}}, color={255,0,255}));
  connect(booToInt3.y, yColLeaDamAla)
    annotation (Line(points={{162,-190},{260,-190}}, color={255,127,0}));
  connect(VColDucDis_flow, gre1.u1)
    annotation (Line(points={{-260,-60},{-102,-60}}, color={0,0,127}));
  connect(heaMaxFlo.y, gai3.u)
    annotation (Line(points={{-178,-310},{-162,-310}}, color={0,0,127}));
  connect(u1HeaFan, not6.u)
    annotation (Line(points={{-260,-350},{-202,-350}}, color={255,0,255}));
  connect(gai3.y,gre2. u2) annotation (Line(points={{-138,-310},{-120,-310},{-120,
          -298},{-102,-298}}, color={0,0,127}));
  connect(gre2.y,and6. u1)
    annotation (Line(points={{-78,-290},{-22,-290}}, color={255,0,255}));
  connect(not7.y,assMes4. u)
    annotation (Line(points={{122,-330},{138,-330}}, color={255,0,255}));
  connect(booToInt4.y, yHotFloSenAla)
    annotation (Line(points={{162,-290},{260,-290}}, color={255,127,0}));
  connect(uHeaDam, cloDam1.u)
    annotation (Line(points={{-260,-460},{-202,-460}}, color={0,0,127}));
  connect(u1HeaFan, leaDamAla1.u2) annotation (Line(points={{-260,-350},{-210,-350},
          {-210,-428},{-42,-428}},color={255,0,255}));
  connect(not8.y,assMes5. u)
    annotation (Line(points={{122,-460},{138,-460}}, color={255,0,255}));
  connect(booToInt5.y, yHotLeaDamAla)
    annotation (Line(points={{162,-420},{260,-420}}, color={255,127,0}));
  connect(VHotDucDis_flow, gre2.u1)
    annotation (Line(points={{-260,-290},{-102,-290}}, color={0,0,127}));
  connect(VDis_flow, gre3.u1) annotation (Line(points={{-260,420},{-220,420},{
          -220,200},{-62,200}}, color={0,0,127}));
  connect(u1CooFan, or2.u1) annotation (Line(points={{-260,-120},{-220,-120},{-220,
          100},{-202,100}}, color={255,0,255}));
  connect(u1HeaFan, or2.u2) annotation (Line(points={{-260,-350},{-210,-350},{-210,
          92},{-202,92}}, color={255,0,255}));
  connect(or2.y, not10.u)
    annotation (Line(points={{-178,100},{-62,100}},  color={255,0,255}));
  connect(not9.y, assMes6.u)
    annotation (Line(points={{162,160},{178,160}}, color={255,0,255}));
  connect(booToInt6.y, yFloSenAla)
    annotation (Line(points={{162,200},{260,200}}, color={255,127,0}));
  connect(gai4.y, gre3.u2) annotation (Line(points={{-98,150},{-70,150},{-70,
          192},{-62,192}}, color={0,0,127}));
  connect(cooMaxFlo1.y, gai4.u)
    annotation (Line(points={{-138,150},{-122,150}}, color={0,0,127}));
  connect(or2.y, leaDamAla2.u2) annotation (Line(points={{-178,100},{-160,100},{
          -160,22},{-2,22}}, color={255,0,255}));
  connect(cloDam.y, cloBotDam.u1) annotation (Line(points={{-178,-230},{-70,-230},
          {-70,0},{-42,0}}, color={255,0,255}));
  connect(cloDam1.y, cloBotDam.u2) annotation (Line(points={{-178,-460},{-50,-460},
          {-50,-8},{-42,-8}}, color={255,0,255}));
  connect(not11.y, assMes7.u)
    annotation (Line(points={{142,-10},{158,-10}}, color={255,0,255}));
  connect(booToInt7.y, yLeaDamAla)
    annotation (Line(points={{162,30},{260,30}}, color={255,127,0}));
  connect(VColDucDis_flow, add2.u1) annotation (Line(points={{-260,-60},{-170,-60},
          {-170,-14},{-142,-14}}, color={0,0,127}));
  connect(VHotDucDis_flow, add2.u2) annotation (Line(points={{-260,-290},{-230,-290},
          {-230,-26},{-142,-26}}, color={0,0,127}));
  connect(add2.y, les.u1) annotation (Line(points={{-118,-20},{-80,-20},{-80,180},
          {-226,180},{-226,420},{-162,420}}, color={0,0,127}));
  connect(add2.y, gre.u2) annotation (Line(points={{-118,-20},{-80,-20},{-80,
          180},{-226,180},{-226,282},{-162,282}}, color={0,0,127}));
  connect(add2.y, gre3.u1) annotation (Line(points={{-118,-20},{-80,-20},{-80,200},
          {-62,200}}, color={0,0,127}));
  connect(greThr.y, truDel8.u)
    annotation (Line(points={{-158,340},{-122,340}}, color={255,0,255}));
  connect(truDel8.y, and1.u1)
    annotation (Line(points={{-98,340},{-42,340}}, color={255,0,255}));
  connect(truDel8.y, and2.u2) annotation (Line(points={{-98,340},{-50,340},{-50,
          412},{-42,412}}, color={255,0,255}));
  connect(gre3.y, and7.u1)
    annotation (Line(points={{-38,200},{-2,200}},  color={255,0,255}));
  connect(not10.y, and7.u2) annotation (Line(points={{-38,100},{-10,100},{-10,192},
          {-2,192}},  color={255,0,255}));
  connect(and7.y, truDel6.u)
    annotation (Line(points={{22,200},{58,200}},color={255,0,255}));
  connect(truDel6.y, booToInt6.u)
    annotation (Line(points={{82,200},{138,200}}, color={255,0,255}));
  connect(truDel6.y, not9.u) annotation (Line(points={{82,200},{100,200},{100,160},
          {138,160}},color={255,0,255}));
  connect(truDel7.y, booToInt7.u)
    annotation (Line(points={{102,30},{138,30}},color={255,0,255}));
  connect(truDel7.y, not11.u) annotation (Line(points={{102,30},{110,30},{110,-10},
          {118,-10}},color={255,0,255}));
  connect(gre3.y, leaDamAla2.u1) annotation (Line(points={{-38,200},{-20,200},{-20,
          30},{-2,30}}, color={255,0,255}));
  connect(not3.y, and5.u2) annotation (Line(points={{-178,-120},{-40,-120},{-40,
          -68},{-22,-68}}, color={255,0,255}));
  connect(and5.y, truDel2.u)
    annotation (Line(points={{2,-60},{18,-60}}, color={255,0,255}));
  connect(truDel2.y, booToInt2.u)
    annotation (Line(points={{42,-60},{138,-60}}, color={255,0,255}));
  connect(truDel2.y, not4.u) annotation (Line(points={{42,-60},{80,-60},{80,-100},
          {98,-100}}, color={255,0,255}));
  connect(gre1.y, leaDamAla.u1) annotation (Line(points={{-78,-60},{-60,-60},{-60,
          -190},{-42,-190}}, color={255,0,255}));
  connect(truDel3.y, booToInt3.u)
    annotation (Line(points={{62,-190},{138,-190}}, color={255,0,255}));
  connect(truDel3.y, not5.u) annotation (Line(points={{62,-190},{80,-190},{80,-230},
          {98,-230}}, color={255,0,255}));
  connect(and6.y, truDel4.u)
    annotation (Line(points={{2,-290},{18,-290}}, color={255,0,255}));
  connect(truDel4.y, booToInt4.u)
    annotation (Line(points={{42,-290},{138,-290}}, color={255,0,255}));
  connect(not6.y, and6.u2) annotation (Line(points={{-178,-350},{-40,-350},{-40,
          -298},{-22,-298}}, color={255,0,255}));
  connect(truDel4.y, not7.u) annotation (Line(points={{42,-290},{80,-290},{80,-330},
          {98,-330}}, color={255,0,255}));
  connect(truDel5.y, booToInt5.u)
    annotation (Line(points={{62,-420},{138,-420}}, color={255,0,255}));
  connect(truDel5.y, not8.u) annotation (Line(points={{62,-420},{80,-420},{80,-460},
          {98,-460}}, color={255,0,255}));
  connect(gre2.y, leaDamAla1.u1) annotation (Line(points={{-78,-290},{-60,-290},
          {-60,-420},{-42,-420}}, color={255,0,255}));
  connect(les.y, and10.u1)
    annotation (Line(points={{-138,420},{-122,420}}, color={255,0,255}));
  connect(and10.y, truDel.u)
    annotation (Line(points={{-98,420},{-82,420}}, color={255,0,255}));
  connect(gre.y, and11.u1)
    annotation (Line(points={{-138,290},{-122,290}}, color={255,0,255}));
  connect(and11.y, truDel1.u)
    annotation (Line(points={{-98,290},{-82,290}}, color={255,0,255}));
  connect(fanIni.y, and10.u2) annotation (Line(points={{-138,230},{-130,230},{-130,
          412},{-122,412}}, color={255,0,255}));
  connect(u1CooFan, or1.u1) annotation (Line(points={{-260,-120},{-220,-120},{-220,
          150},{-202,150}}, color={255,0,255}));
  connect(u1HeaFan, or1.u2) annotation (Line(points={{-260,-350},{-210,-350},{-210,
          142},{-202,142}}, color={255,0,255}));
  connect(or1.y, fanIni.u) annotation (Line(points={{-178,150},{-170,150},{-170,
          230},{-162,230}}, color={255,0,255}));
  connect(occMod.y,isOcc. u2) annotation (Line(points={{-178,40},{-140,40},{-140,
          62},{-122,62}}, color={255,127,0}));
  connect(uOpeMod,isOcc. u1)
    annotation (Line(points={{-260,70},{-122,70}}, color={255,127,0}));
  connect(fanIni.y, and11.u2) annotation (Line(points={{-138,230},{-130,230},{
          -130,282},{-122,282}}, color={255,0,255}));
  connect(gai.y, les.u2) annotation (Line(points={{-178,390},{-170,390},{-170,
          412},{-162,412}}, color={0,0,127}));
  connect(and8.y, and9.u1)
    annotation (Line(points={{22,420},{38,420}}, color={255,0,255}));
  connect(and9.y, lowFloAla.u2)
    annotation (Line(points={{62,420},{138,420}}, color={255,0,255}));
  connect(booToInt.u, and3.y)
    annotation (Line(points={{78,340},{62,340}}, color={255,0,255}));
  connect(and9.y, not1.u) annotation (Line(points={{62,420},{70,420},{70,380},{78,
          380}}, color={255,0,255}));
  connect(and3.y, not2.u) annotation (Line(points={{62,340},{70,340},{70,300},{78,
          300}}, color={255,0,255}));
  connect(and4.y, and3.u1)
    annotation (Line(points={{22,340},{38,340}}, color={255,0,255}));
  connect(isOcc.y, and9.u2) annotation (Line(points={{-98,70},{30,70},{30,412},{
          38,412}}, color={255,0,255}));
  connect(isOcc.y, and3.u2) annotation (Line(points={{-98,70},{30,70},{30,332},{
          38,332}}, color={255,0,255}));
  connect(leaDamAla2.y, leaDamAla3.u1)
    annotation (Line(points={{22,30},{38,30}}, color={255,0,255}));
  connect(leaDamAla3.y, truDel7.u)
    annotation (Line(points={{62,30},{78,30}}, color={255,0,255}));
  connect(cloBotDam.y, leaDamAla3.u2) annotation (Line(points={{-18,0},{30,0},{30,
          22},{38,22}}, color={255,0,255}));
  connect(leaDamAla.y, leaDamAla4.u1)
    annotation (Line(points={{-18,-190},{-2,-190}}, color={255,0,255}));
  connect(leaDamAla4.y, truDel3.u)
    annotation (Line(points={{22,-190},{38,-190}}, color={255,0,255}));
  connect(cloDam.y, leaDamAla4.u2) annotation (Line(points={{-178,-230},{-10,-230},
          {-10,-198},{-2,-198}}, color={255,0,255}));
  connect(leaDamAla1.y, leaDamAla5.u1)
    annotation (Line(points={{-18,-420},{-2,-420}}, color={255,0,255}));
  connect(leaDamAla5.y, truDel5.u)
    annotation (Line(points={{22,-420},{38,-420}}, color={255,0,255}));
  connect(cloDam1.y, leaDamAla5.u2) annotation (Line(points={{-178,-460},{-10,-460},
          {-10,-428},{-2,-428}}, color={255,0,255}));
annotation (defaultComponentName="ala",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},{100,200}}),
       graphics={
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
        extent={{-100,240},{100,200}},
        textString="%name",
        textColor={0,0,255}),
        Text(
          extent={{-96,158},{-46,144}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActSet_flow"),
        Text(
          extent={{-98,186},{-58,174}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow",
          visible=not have_duaSen),
        Text(
          extent={{-96,30},{-44,14}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCooDam"),
        Text(
          extent={{-98,58},{-58,44}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1CooFan"),
        Text(
          extent={{46,190},{96,176}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowFloAla"),
        Text(
          extent={{46,140},{96,126}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yFloSenAla",
          visible=not have_duaSen),
        Text(
          extent={{46,110},{96,96}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaDamAla",
          visible=not have_duaSen),
        Text(
          extent={{-98,88},{-28,72}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VColDucDis_flow",
          visible=have_duaSen),
        Text(
          extent={{-96,-160},{-26,-180}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHeaDam"),
        Text(
          extent={{-96,-132},{-56,-146}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1HeaFan"),
        Text(
          extent={{-96,-102},{-26,-118}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VHotDucDis_flow",
          visible=have_duaSen),
        Text(
          extent={{36,-60},{96,-76}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yColFloSenAla",
          visible=have_duaSen),
        Text(
          extent={{34,-90},{98,-106}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yColLeaDamAla",
          visible=have_duaSen),
        Text(
          extent={{36,-130},{96,-146}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHotFloSenAla",
          visible=have_duaSen),
        Text(
          extent={{34,-160},{98,-176}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHotLeaDamAla",
          visible=have_duaSen),
        Text(
          extent={{-100,128},{-50,114}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          visible=not have_duaSen,
          textString="uOpeMod")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-500},{240,500}})),
Documentation(info="<html>
<p>
This block outputs alarms of snap-acting controlled dual-duct terminal unit. The
implementation is according to the Section 5.11.6 of ASHRAE Guideline 36, May 2020.
</p>
<h4>Low airflow</h4>
<ol>
<li>
If the zone is in occupied mode and after the AHU supply fan has been enabled for <code>staTim</code>,
if the measured airflow <code>VDis_flow</code> is less than 70% of setpoint
<code>VActSet_flow</code> for 5 minutes (<code>lowFloTim</code>) while the setpoint
is greater than zero, generate a Level 3 alarm.
</li>
<li>
If the zone is in occupied mode and after the AHU supply fan has been enabled for <code>staTim</code>,
if the measured airflow <code>VDis_flow</code> is less than 50% of setpoint
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
If the unit has dual inlet sensor (<code>have_duaSen=true</code>):
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
</li>
<li>
If the unit has single discharge flow sensor (<code>have_duaSen=false</code>):
<ul>
<li>
If the cooling and heating fans serving the zone have been OFF (<code>u1CooFan=false</code>
and <code>u1HeaFan=false</code>) for 10 minutes (<code>fanOffTim</code>), and the
discharge airflow sensor reading <code>VDis_flow</code>
is above 10% of the cooling maximum airflow setpoint <code>VCooMax_flow</code>,
generate a Level 3 alarm.
</li>
</ul>
</li>
</ul>
<h4>Leaking damper</h4>
<ul>
<li>
If the unit has dual inlet sensor (<code>have_duaSen=true</code>):
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
</li>
<li>
If the unit has single discharge flow sensor (<code>have_duaSen=false</code>):
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
</li>
</ul>
</html>",revisions="<html>
<ul>
<li>
August 29, 2023, by Hongxiang Fu:<br/>
Because of the removal of <code>Logical.And3</code> based on ASHRAE 231P,
replaced it with a stack of two <code>Logical.And</code> blocks.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2465\">#2465</a>.
</li>
<li>
August 23, 2023, by Jianjun Hu:<br/>
Added delay <code>staTim</code> to allow the system becoming stabilized.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3257\">issue 3257</a>.
</li>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Alarms;
