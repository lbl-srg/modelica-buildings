within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences;
block Alarms "Generate alarms of parallel fan-powered terminal unit with variable-volume fan"

  parameter Boolean have_hotWatCoi
    "True: the unit has the hot water coil";
  parameter Real staPreMul
    "Importance multiplier for the zone static pressure reset control loop";
  parameter Real hotWatRes
    "Importance multiplier for the hot water reset control loop"
    annotation (Dialog(enable=have_hotWatCoi));
  parameter Real VCooMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone cooling maximum airflow rate";
  parameter Real lowFloTim(
    final unit="s",
    final quantity="Time")=300
    "Threshold time to check low flow rate"
    annotation (__cdl(ValueInReference=True));
  parameter Real lowTemTim(
    final unit="s",
    final quantity="Time")=600
    "Threshold time to check low discharge temperature"
    annotation (__cdl(ValueInReference=True), Dialog(enable=have_hotWatCoi));
  parameter Real comChaTim(
    final unit="s",
    final quantity="Time")=15
    "Threshold time after fan command change"
    annotation (__cdl(ValueInReference=True));
  parameter Real fanOffTim(
    final unit="s",
    final quantity="Time")=600
    "Threshold time to check fan off"
    annotation (__cdl(ValueInReference=True));
  parameter Real leaFloTim(
    final unit="s",
    final quantity="Time")=600
    "Threshold time to check damper leaking airflow"
    annotation (__cdl(ValueInReference=True));
  parameter Real valCloTim(
    final unit="s",
    final quantity="Time")=900
    "Threshold time to check valve leaking water flow"
    annotation (__cdl(ValueInReference=True));
  parameter Real floHys(
    final quantity="VolumeFlowRate",
    final unit="m3/s")=0.05
    "Near zero flow rate, below which the flow rate or difference will be seen as zero"
    annotation (__cdl(ValueInReference=False), Dialog(tab="Advanced"));
  parameter Real dTHys(
    final unit="K",
    final quantity="TemperatureDifference")=0.25
    "Temperature difference hysteresis below which the temperature difference will be seen as zero"
    annotation (__cdl(ValueInReference=False), Dialog(tab="Advanced"));
  parameter Real damPosHys(
    final unit="1")=0.05
    "Near zero damper position, below which the damper will be seen as closed"
    annotation (__cdl(ValueInReference=False), Dialog(tab="Advanced"));
  parameter Real valPosHys(
    final unit="1")=0.05
    "Near zero valve position, below which the valve will be seen as closed"
    annotation (__cdl(ValueInReference=False), Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VPri_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured primary airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-280,390},{-240,430}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active airflow setpoint"
    annotation (Placement(transformation(extent={{-280,310},{-240,350}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Fan
    "AHU supply fan status"
    annotation (Placement(transformation(extent={{-280,120},{-240,160}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1FanCom
    "Terminal fan command on"
    annotation (Placement(transformation(extent={{-280,40},{-240,80}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1TerFan
    "Terminal fan status"
    annotation (Placement(transformation(extent={{-280,0},{-240,40}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDam(
    final min=0,
    final unit="1")
    "Damper position setpoint"
    annotation (Placement(transformation(extent={{-280,-130},{-240,-90}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uVal(
    final min=0,
    final unit="1")
    "Actual valve position"
    annotation (Placement(transformation(extent={{-280,-180},{-240,-140}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature of the air supplied from central air handler"
    annotation (Placement(transformation(extent={{-280,-250},{-240,-210}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HotPla if have_hotWatCoi
    "Hot water plant status"
    annotation (Placement(transformation(extent={{-280,-290},{-240,-250}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-280,-330},{-240,-290}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDisSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_hotWatCoi
    "Discharge air temperature setpoint"
    annotation (Placement(transformation(extent={{-280,-370},{-240,-330}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowFloAla
    "Low airflow alarms"
    annotation (Placement(transformation(extent={{240,330},{280,370}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFloSenAla
    "Airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{240,180},{280,220}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFanStaAla
    "Fan status alarm"
    annotation (Placement(transformation(extent={{240,70},{280,110}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaDamAla
    "Leaking damper alarm"
    annotation (Placement(transformation(extent={{240,-90},{280,-50}}),
        iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaValAla
    "Leaking valve alarm"
    annotation (Placement(transformation(extent={{240,-200},{280,-160}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowTemAla
    if have_hotWatCoi
    "Low discharge air temperature alarms"
    annotation (Placement(transformation(extent={{240,-390},{280,-350}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=0.5)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-180,370},{-160,390}})));
  Buildings.Controls.OBC.CDL.Continuous.Less les(
    final h=floHys)
    "Check if measured airflow is less than threshold"
    annotation (Placement(transformation(extent={{-120,400},{-100,420}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=lowFloTim)
    "Check if the measured airflow has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,400},{-60,420}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=floHys,
    final h=0.5*floHys)
    "Check if setpoint airflow is greater than zero"
    annotation (Placement(transformation(extent={{-180,320},{-160,340}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre(
    final h=floHys)
    "Check if measured airflow is less than threshold"
    annotation (Placement(transformation(extent={{-120,270},{-100,290}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=0.7)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-180,290},{-160,310}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=lowFloTim)
    "Check if the measured airflow has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,270},{-60,290}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Measured airflow has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,400},{-20,420}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Measured airflow has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,320},{-20,340}})));
  Buildings.Controls.OBC.CDL.Integers.Switch lowFloAla "Low airflow alarm"
    annotation (Placement(transformation(extent={{140,400},{160,420}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=2)
    "Level 2 alarm"
    annotation (Placement(transformation(extent={{80,440},{100,460}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(
    final integerTrue=3)
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{80,320},{100,340}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conInt1(
    final k=staPreMul)
    "Importance multiplier for zone static pressure reset"
    annotation (Placement(transformation(extent={{-120,230},{-100,250}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1
    "Check if the multiplier is greater than zero"
    annotation (Placement(transformation(extent={{-80,230},{-60,250}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Suppress the alarm when multiplier is zero"
    annotation (Placement(transformation(extent={{140,230},{160,250}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt
    "Low flow alarms"
    annotation (Placement(transformation(extent={{200,340},{220,360}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{0,360},{20,380}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{40,360},{60,380}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Warning: airflow is less than 50% of the setpoint.")
    "Level 2 low airflow alarm"
    annotation (Placement(transformation(extent={{80,360},{100,380}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Logical and"
    annotation (Placement(transformation(extent={{20,280},{40,300}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{60,280},{80,300}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(
    final message="Warning: airflow is less than 70% of the setpoint.")
    "Level 3 low airflow alarm"
    annotation (Placement(transformation(extent={{100,280},{120,300}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooMaxFlo(
    final k=VCooMax_flow)
    "Cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-200,170},{-180,190}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(
    final k=0.1)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-160,170},{-140,190}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical not"
    annotation (Placement(transformation(extent={{-200,130},{-180,150}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=fanOffTim)
    "Check if the input has been true for more than threshold time"
    annotation (Placement(transformation(extent={{0,190},{20,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre1(
    final h=floHys)
    "Check if measured airflow is greater than threshold"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Check if the measured airflow is greater than the threshold and the AHU supply fan is OFF"
    annotation (Placement(transformation(extent={{-40,190},{-20,210}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4
    "Logical not"
    annotation (Placement(transformation(extent={{40,160},{60,180}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes2(
    final message="Warning: airflow sensor should be calibrated.")
    "Level 3 airflow sensor alarm"
    annotation (Placement(transformation(extent={{80,160},{100,180}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2(
    final integerTrue=3)
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{140,190},{160,210}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(
    final delayTime=leaFloTim)
    "Check if the input has been true for more than threshold time"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold cloDam(
    final t=damPosHys,
    final h=0.5*damPosHys) "Check if damper position is near zero"
    annotation (Placement(transformation(extent={{-200,-120},{-180,-100}})));
  Buildings.Controls.OBC.CDL.Logical.And3 leaDamAla
    "Check if generating leak damper alarms"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5 "Logical not"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes3(
    final message="Warning: the damper is leaking.")
    "Level 4 leaking damper alarm"
    annotation (Placement(transformation(extent={{140,-120},{160,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt3(
    final integerTrue=4)
    "Convert boolean true to level 4 alarm"
    annotation (Placement(transformation(extent={{140,-80},{160,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Less les1(
    final h=dTHys) if have_hotWatCoi
    "Discharge temperature lower than setpoint by a threshold"
    annotation (Placement(transformation(extent={{-120,-320},{-100,-300}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=-17) if have_hotWatCoi
    "Setpoint temperature minus a threshold"
    annotation (Placement(transformation(extent={{-180,-360},{-160,-340}})));
  Buildings.Controls.OBC.CDL.Continuous.Less les2(
    final h=dTHys) if have_hotWatCoi
    "Discharge temperature lower than setpoint by a threshold"
    annotation (Placement(transformation(extent={{-120,-390},{-100,-370}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(final p=-8.3)
    if have_hotWatCoi
    "Setpoint temperature minus a threshold"
    annotation (Placement(transformation(extent={{-180,-430},{-160,-410}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel4(
    final delayTime=lowTemTim) if have_hotWatCoi
    "Check if the discharge temperature has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-40,-320},{-20,-300}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel5(
    final delayTime=lowTemTim) if have_hotWatCoi
    "Check if the discharge temperature has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-40,-390},{-20,-370}})));
  Buildings.Controls.OBC.CDL.Logical.And and6 if have_hotWatCoi
    "Discharge temperature has been less than threshold and the hot water plant is proven on"
    annotation (Placement(transformation(extent={{-80,-320},{-60,-300}})));
  Buildings.Controls.OBC.CDL.Logical.And and7 if have_hotWatCoi
    "Logical and"
    annotation (Placement(transformation(extent={{0,-360},{20,-340}})));
  Buildings.Controls.OBC.CDL.Logical.Not not6 if have_hotWatCoi
    "Logical not"
    annotation (Placement(transformation(extent={{40,-360},{60,-340}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes4(
    final message="Warning: discharge air temperature is 17 degC less than the setpoint.")
    if have_hotWatCoi
    "Level 2 low discharge air temperature alarm"
    annotation (Placement(transformation(extent={{80,-360},{100,-340}})));
  Buildings.Controls.OBC.CDL.Integers.Switch lowTemAla if have_hotWatCoi
    "Low discharge temperature alarm"
    annotation (Placement(transformation(extent={{140,-320},{160,-300}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=2) if have_hotWatCoi
    "Level 2 alarm"
    annotation (Placement(transformation(extent={{80,-280},{100,-260}})));
  Buildings.Controls.OBC.CDL.Logical.And and8 if have_hotWatCoi
    "Discharge temperature has been less than threshold and the hot water plant is proven on"
    annotation (Placement(transformation(extent={{-80,-390},{-60,-370}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt4(
    final integerTrue=3) if have_hotWatCoi
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{80,-390},{100,-370}})));
  Buildings.Controls.OBC.CDL.Logical.And and9 if have_hotWatCoi
    "Logical and"
    annotation (Placement(transformation(extent={{20,-430},{40,-410}})));
  Buildings.Controls.OBC.CDL.Logical.Not not7 if have_hotWatCoi
    "Logical not"
    annotation (Placement(transformation(extent={{60,-430},{80,-410}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes5(
    final message="Warning: discharge air temperature is 8 degC less than the setpoint.")
    if have_hotWatCoi
    "Level 3 low airflow alarm"
    annotation (Placement(transformation(extent={{100,-430},{120,-410}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conInt3(
    final k=hotWatRes) if have_hotWatCoi
    "Importance multiplier for hot water reset control"
    annotation (Placement(transformation(extent={{-120,-460},{-100,-440}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr2
    if have_hotWatCoi
    "Check if the multiplier is greater than zero"
    annotation (Placement(transformation(extent={{-80,-460},{-60,-440}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt5
    if have_hotWatCoi
    "Suppress the alarm when multiplier is zero"
    annotation (Placement(transformation(extent={{140,-460},{160,-440}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt1 if have_hotWatCoi
    "Low discharge air temperature alarms"
    annotation (Placement(transformation(extent={{200,-380},{220,-360}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel6(
    final delayTime=valCloTim)
    "Check if the input has been true for more than threshold time"
    annotation (Placement(transformation(extent={{40,-190},{60,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold cloVal(
    final t=valPosHys,
    final h=0.5*valPosHys)
    "Check if valve position is near zero"
    annotation (Placement(transformation(extent={{-200,-170},{-180,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar2(
    final p=3)
    "AHU supply temperature plus 3 degree"
    annotation (Placement(transformation(extent={{-200,-240},{-180,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre2(
    final h=dTHys)
    "Discharge temperature greate than AHU supply temperature by a threshold"
    annotation (Placement(transformation(extent={{-140,-210},{-120,-190}})));
  Buildings.Controls.OBC.CDL.Logical.And3 leaValAla "Check if generating leak valve alarms"
    annotation (Placement(transformation(extent={{-20,-190},{0,-170}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt6(
    final integerTrue=4)
    "Convert boolean true to level 4 alarm"
    annotation (Placement(transformation(extent={{140,-190},{160,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not8 "Logical not"
    annotation (Placement(transformation(extent={{100,-230},{120,-210}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes6(
    final message="Warning: the valve is leaking.")
    "Level 4 leaking valve alarm"
    annotation (Placement(transformation(extent={{140,-230},{160,-210}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel7(
    final delayTime=comChaTim)
    "Check if the terminal fan has been commond on for threshold time"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and11
    "Check if the fan has been commond on for threshold time and fan is still off"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=2)
    "Level 2 alarm"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));
  Buildings.Controls.OBC.CDL.Integers.Switch fanStaAla
    "Fan status alarm"
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
  Buildings.Controls.OBC.CDL.Logical.Not not9
    "Logical not"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel8(
    final delayTime=comChaTim)
    "Check if the terminal fan has been commond off for threshold time"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and10
    "Check if the fan has been commond off for threshold time and fan is still on"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt7(
    final integerTrue=4)
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not10
    "Logical not"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes7(
    final message="Warning: fan has been commanded ON but still OFF.")
    "Level 2 fan status alarm"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not11
    "Logical not"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes8(
    final message="Warning: fan has been commanded OFF but still ON.")
    "Level 4 fan status alarm"
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  Buildings.Controls.OBC.CDL.Logical.Not not12
    "Logical not"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel9(
    final delayTime=lowFloTim)
    "Check if the active flow setpoint has been greater than zero for the threshold time"
    annotation (Placement(transformation(extent={{-120,320},{-100,340}})));
equation
  connect(VActSet_flow, gai.u) annotation (Line(points={{-260,330},{-200,330},{-200,
          380},{-182,380}},  color={0,0,127}));
  connect(VPri_flow, les.u1)
    annotation (Line(points={{-260,410},{-122,410}}, color={0,0,127}));
  connect(gai.y, les.u2) annotation (Line(points={{-158,380},{-140,380},{-140,402},
          {-122,402}}, color={0,0,127}));
  connect(les.y, truDel.u)
    annotation (Line(points={{-98,410},{-82,410}}, color={255,0,255}));
  connect(VActSet_flow, greThr.u)
    annotation (Line(points={{-260,330},{-182,330}}, color={0,0,127}));
  connect(VActSet_flow, gai1.u) annotation (Line(points={{-260,330},{-200,330},{
          -200,300},{-182,300}},  color={0,0,127}));
  connect(VPri_flow, gre.u2) annotation (Line(points={{-260,410},{-220,410},{-220,
          272},{-122,272}},      color={0,0,127}));
  connect(gai1.y, gre.u1) annotation (Line(points={{-158,300},{-140,300},{-140,280},
          {-122,280}},      color={0,0,127}));
  connect(gre.y, truDel1.u)
    annotation (Line(points={{-98,280},{-82,280}}, color={255,0,255}));
  connect(truDel.y, and2.u1)
    annotation (Line(points={{-58,410},{-42,410}}, color={255,0,255}));
  connect(truDel1.y, and1.u2) annotation (Line(points={{-58,280},{-50,280},{-50,
          322},{-42,322}}, color={255,0,255}));
  connect(and2.y, lowFloAla.u2)
    annotation (Line(points={{-18,410},{138,410}}, color={255,0,255}));
  connect(conInt.y, lowFloAla.u1) annotation (Line(points={{102,450},{120,450},{
          120,418},{138,418}}, color={255,127,0}));
  connect(and1.y, booToInt.u)
    annotation (Line(points={{-18,330},{78,330}}, color={255,0,255}));
  connect(booToInt.y, lowFloAla.u3) annotation (Line(points={{102,330},{120,330},
          {120,402},{138,402}},color={255,127,0}));
  connect(conInt1.y, greThr1.u)
    annotation (Line(points={{-98,240},{-82,240}}, color={0,0,127}));
  connect(greThr1.y, booToInt1.u)
    annotation (Line(points={{-58,240},{138,240}}, color={255,0,255}));
  connect(lowFloAla.y, proInt.u1) annotation (Line(points={{162,410},{180,410},{
          180,356},{198,356}}, color={255,127,0}));
  connect(booToInt1.y, proInt.u2) annotation (Line(points={{162,240},{180,240},{
          180,344},{198,344}},  color={255,127,0}));
  connect(not1.y, assMes.u)
    annotation (Line(points={{62,370},{78,370}}, color={255,0,255}));
  connect(and3.y, not1.u)
    annotation (Line(points={{22,370},{38,370}}, color={255,0,255}));
  connect(and2.y, and3.u1) annotation (Line(points={{-18,410},{-10,410},{-10,370},
          {-2,370}},      color={255,0,255}));
  connect(greThr1.y, and3.u2) annotation (Line(points={{-58,240},{-10,240},{-10,
          362},{-2,362}}, color={255,0,255}));
  connect(and1.y, and4.u1) annotation (Line(points={{-18,330},{0,330},{0,290},{18,
          290}},    color={255,0,255}));
  connect(greThr1.y, and4.u2) annotation (Line(points={{-58,240},{-10,240},{-10,
          282},{18,282}}, color={255,0,255}));
  connect(and4.y, not2.u)
    annotation (Line(points={{42,290},{58,290}}, color={255,0,255}));
  connect(not2.y, assMes1.u)
    annotation (Line(points={{82,290},{98,290}}, color={255,0,255}));
  connect(cooMaxFlo.y, gai2.u)
    annotation (Line(points={{-178,180},{-162,180}}, color={0,0,127}));
  connect(u1Fan, not3.u)
    annotation (Line(points={{-260,140},{-202,140}}, color={255,0,255}));
  connect(gai2.y, gre1.u2) annotation (Line(points={{-138,180},{-120,180},{-120,
          192},{-102,192}}, color={0,0,127}));
  connect(gre1.y, and5.u1)
    annotation (Line(points={{-78,200},{-42,200}}, color={255,0,255}));
  connect(not4.y, assMes2.u)
    annotation (Line(points={{62,170},{78,170}}, color={255,0,255}));
  connect(booToInt2.y, yFloSenAla)
    annotation (Line(points={{162,200},{260,200}}, color={255,127,0}));
  connect(proInt.y, yLowFloAla)
    annotation (Line(points={{222,350},{260,350}}, color={255,127,0}));
  connect(uDam, cloDam.u)
    annotation (Line(points={{-260,-110},{-202,-110}}, color={0,0,127}));
  connect(u1Fan, leaDamAla.u2) annotation (Line(points={{-260,140},{-220,140},{-220,
          -70},{-22,-70}},color={255,0,255}));
  connect(cloDam.y, leaDamAla.u3) annotation (Line(points={{-178,-110},{-60,-110},
          {-60,-78},{-22,-78}}, color={255,0,255}));
  connect(not5.y, assMes3.u)
    annotation (Line(points={{122,-110},{138,-110}}, color={255,0,255}));
  connect(booToInt3.y, yLeaDamAla)
    annotation (Line(points={{162,-70},{260,-70}}, color={255,127,0}));
  connect(VPri_flow, gre1.u1) annotation (Line(points={{-260,410},{-220,410},{-220,
          200},{-102,200}}, color={0,0,127}));
  connect(TDis, les1.u1)
    annotation (Line(points={{-260,-310},{-122,-310}}, color={0,0,127}));
  connect(TDisSet, addPar.u)
    annotation (Line(points={{-260,-350},{-182,-350}}, color={0,0,127}));
  connect(addPar.y, les1.u2) annotation (Line(points={{-158,-350},{-140,-350},{-140,
          -318},{-122,-318}}, color={0,0,127}));
  connect(TDis, les2.u1) annotation (Line(points={{-260,-310},{-220,-310},{-220,
          -380},{-122,-380}}, color={0,0,127}));
  connect(TDisSet, addPar1.u) annotation (Line(points={{-260,-350},{-200,-350},{
          -200,-420},{-182,-420}}, color={0,0,127}));
  connect(addPar1.y, les2.u2) annotation (Line(points={{-158,-420},{-140,-420},{
          -140,-388},{-122,-388}}, color={0,0,127}));
  connect(conInt2.y, lowTemAla.u1) annotation (Line(points={{102,-270},{120,-270},
          {120,-302},{138,-302}}, color={255,127,0}));
  connect(and7.y, not6.u)
    annotation (Line(points={{22,-350},{38,-350}}, color={255,0,255}));
  connect(not6.y, assMes4.u)
    annotation (Line(points={{62,-350},{78,-350}}, color={255,0,255}));
  connect(booToInt4.y, lowTemAla.u3) annotation (Line(points={{102,-380},{120,-380},
          {120,-318},{138,-318}}, color={255,127,0}));
  connect(and9.y, not7.u)
    annotation (Line(points={{42,-420},{58,-420}}, color={255,0,255}));
  connect(not7.y, assMes5.u)
    annotation (Line(points={{82,-420},{98,-420}}, color={255,0,255}));
  connect(conInt3.y, greThr2.u)
    annotation (Line(points={{-98,-450},{-82,-450}}, color={0,0,127}));
  connect(greThr2.y, booToInt5.u)
    annotation (Line(points={{-58,-450},{138,-450}}, color={255,0,255}));
  connect(lowTemAla.y, proInt1.u1) annotation (Line(points={{162,-310},{180,-310},
          {180,-364},{198,-364}}, color={255,127,0}));
  connect(booToInt5.y, proInt1.u2) annotation (Line(points={{162,-450},{180,-450},
          {180,-376},{198,-376}}, color={255,127,0}));
  connect(greThr2.y, and7.u2) annotation (Line(points={{-58,-450},{-10,-450},{-10,
          -358},{-2,-358}}, color={255,0,255}));
  connect(greThr2.y, and9.u2) annotation (Line(points={{-58,-450},{-10,-450},{-10,
          -428},{18,-428}}, color={255,0,255}));
  connect(proInt1.y, yLowTemAla)
    annotation (Line(points={{222,-370},{260,-370}}, color={255,127,0}));
  connect(uVal, cloVal.u)
    annotation (Line(points={{-260,-160},{-202,-160}}, color={0,0,127}));
  connect(TSup, addPar2.u)
    annotation (Line(points={{-260,-230},{-202,-230}}, color={0,0,127}));
  connect(TDis, gre2.u1) annotation (Line(points={{-260,-310},{-220,-310},{-220,
          -200},{-142,-200}}, color={0,0,127}));
  connect(addPar2.y, gre2.u2) annotation (Line(points={{-178,-230},{-160,-230},{
          -160,-208},{-142,-208}}, color={0,0,127}));
  connect(u1Fan, leaValAla.u2) annotation (Line(points={{-260,140},{-220,140},{-220,
          -180},{-22,-180}},color={255,0,255}));
  connect(gre2.y, leaValAla.u3) annotation (Line(points={{-118,-200},{-60,-200},
          {-60,-188},{-22,-188}}, color={255,0,255}));
  connect(not8.y, assMes6.u)
    annotation (Line(points={{122,-220},{138,-220}}, color={255,0,255}));
  connect(booToInt6.y, yLeaValAla)
    annotation (Line(points={{162,-180},{260,-180}}, color={255,127,0}));
  connect(u1FanCom, truDel7.u)
    annotation (Line(points={{-260,60},{-162,60}}, color={255,0,255}));
  connect(u1FanCom, not9.u) annotation (Line(points={{-260,60},{-200,60},{-200,-10},
          {-182,-10}}, color={255,0,255}));
  connect(not9.y, truDel8.u)
    annotation (Line(points={{-158,-10},{-122,-10}}, color={255,0,255}));
  connect(u1FanCom, and11.u2) annotation (Line(points={{-260,60},{-200,60},{-200,
          90},{-22,90}}, color={255,0,255}));
  connect(truDel7.y, and11.u3) annotation (Line(points={{-138,60},{-120,60},{-120,
          82},{-22,82}}, color={255,0,255}));
  connect(and11.y, fanStaAla.u2)
    annotation (Line(points={{2,90},{138,90}}, color={255,0,255}));
  connect(not9.y, and10.u2) annotation (Line(points={{-158,-10},{-140,-10},{-140,
          20},{-22,20}}, color={255,0,255}));
  connect(truDel8.y, and10.u3) annotation (Line(points={{-98,-10},{-80,-10},{-80,
          12},{-22,12}}, color={255,0,255}));
  connect(and10.y, booToInt7.u)
    annotation (Line(points={{2,20},{78,20}}, color={255,0,255}));
  connect(conInt4.y, fanStaAla.u1) annotation (Line(points={{102,130},{120,130},
          {120,98},{138,98}}, color={255,127,0}));
  connect(booToInt7.y, fanStaAla.u3) annotation (Line(points={{102,20},{120,20},
          {120,82},{138,82}}, color={255,127,0}));
  connect(fanStaAla.y, yFanStaAla)
    annotation (Line(points={{162,90},{260,90}}, color={255,127,0}));
  connect(and11.y, not10.u) annotation (Line(points={{2,90},{20,90},{20,60},{38,
          60}}, color={255,0,255}));
  connect(not10.y, assMes7.u)
    annotation (Line(points={{62,60},{78,60}}, color={255,0,255}));
  connect(not11.y, assMes8.u)
    annotation (Line(points={{62,-10},{78,-10}}, color={255,0,255}));
  connect(and10.y, not11.u) annotation (Line(points={{2,20},{20,20},{20,-10},{38,
          -10}}, color={255,0,255}));
  connect(u1TerFan, not12.u) annotation (Line(points={{-260,20},{-180,20},{-180,
          110},{-162,110}}, color={255,0,255}));
  connect(u1TerFan, and10.u1) annotation (Line(points={{-260,20},{-180,20},{-180,
          28},{-22,28}}, color={255,0,255}));
  connect(not12.y, and11.u1) annotation (Line(points={{-138,110},{-80,110},{-80,
          98},{-22,98}}, color={255,0,255}));
  connect(greThr.y, truDel9.u)
    annotation (Line(points={{-158,330},{-122,330}}, color={255,0,255}));
  connect(truDel9.y, and1.u1)
    annotation (Line(points={{-98,330},{-42,330}}, color={255,0,255}));
  connect(truDel9.y, and2.u2) annotation (Line(points={{-98,330},{-50,330},{-50,
          402},{-42,402}}, color={255,0,255}));
  connect(not3.y, and5.u2) annotation (Line(points={{-178,140},{-50,140},{-50,192},
          {-42,192}}, color={255,0,255}));
  connect(and5.y, truDel2.u)
    annotation (Line(points={{-18,200},{-2,200}}, color={255,0,255}));
  connect(truDel2.y, not4.u) annotation (Line(points={{22,200},{30,200},{30,170},
          {38,170}}, color={255,0,255}));
  connect(truDel2.y, booToInt2.u)
    annotation (Line(points={{22,200},{138,200}}, color={255,0,255}));
  connect(leaDamAla.y, truDel3.u)
    annotation (Line(points={{2,-70},{38,-70}}, color={255,0,255}));
  connect(truDel3.y, booToInt3.u)
    annotation (Line(points={{62,-70},{138,-70}}, color={255,0,255}));
  connect(truDel3.y, not5.u) annotation (Line(points={{62,-70},{80,-70},{80,-110},
          {98,-110}}, color={255,0,255}));
  connect(gre1.y, leaDamAla.u1) annotation (Line(points={{-78,200},{-60,200},{-60,
          -62},{-22,-62}}, color={255,0,255}));
  connect(leaValAla.y, truDel6.u)
    annotation (Line(points={{2,-180},{38,-180}}, color={255,0,255}));
  connect(truDel6.y, booToInt6.u)
    annotation (Line(points={{62,-180},{138,-180}}, color={255,0,255}));
  connect(truDel6.y, not8.u) annotation (Line(points={{62,-180},{80,-180},{80,-220},
          {98,-220}}, color={255,0,255}));
  connect(cloVal.y, leaValAla.u1) annotation (Line(points={{-178,-160},{-60,-160},
          {-60,-172},{-22,-172}}, color={255,0,255}));
  connect(and6.y, truDel4.u)
    annotation (Line(points={{-58,-310},{-42,-310}}, color={255,0,255}));
  connect(truDel4.y, lowTemAla.u2)
    annotation (Line(points={{-18,-310},{138,-310}}, color={255,0,255}));
  connect(and8.y, truDel5.u)
    annotation (Line(points={{-58,-380},{-42,-380}}, color={255,0,255}));
  connect(truDel5.y, booToInt4.u)
    annotation (Line(points={{-18,-380},{78,-380}}, color={255,0,255}));
  connect(les2.y, and8.u1)
    annotation (Line(points={{-98,-380},{-82,-380}}, color={255,0,255}));
  connect(les1.y, and6.u1)
    annotation (Line(points={{-98,-310},{-82,-310}}, color={255,0,255}));
  connect(truDel4.y, and7.u1) annotation (Line(points={{-18,-310},{-10,-310},{-10,
          -350},{-2,-350}}, color={255,0,255}));
  connect(truDel5.y, and9.u1) annotation (Line(points={{-18,-380},{0,-380},{0,-420},
          {18,-420}}, color={255,0,255}));
  connect(u1HotPla, and6.u2) annotation (Line(points={{-260,-270},{-90,-270},{-90,
          -318},{-82,-318}}, color={255,0,255}));
  connect(u1HotPla, and8.u2) annotation (Line(points={{-260,-270},{-90,-270},{-90,
          -388},{-82,-388}}, color={255,0,255}));
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
          extent={{-98,86},{-48,72}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActSet_flow"),
        Text(
          extent={{-100,100},{-60,90}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VPri_flow"),
        Text(
          extent={{-98,6},{-62,-4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDam"),
        Text(
          extent={{-98,66},{-80,56}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Fan"),
        Text(
          extent={{46,98},{96,84}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowFloAla"),
        Text(
          extent={{48,68},{98,54}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yFloSenAla"),
        Text(
          extent={{48,-12},{98,-26}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaDamAla"),
        Text(
          extent={{-98,-14},{-64,-24}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uVal"),
        Text(
          extent={{-100,-34},{-74,-44}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-98,-54},{-66,-66}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          visible=have_hotWatCoi,
          textString="u1HotPla"),
        Text(
          extent={{-100,-74},{-76,-84}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis"),
        Text(
          extent={{-102,-92},{-64,-102}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDisSet",
          visible=have_hotWatCoi),
        Text(
          extent={{48,-42},{98,-56}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaValAla"),
        Text(
          extent={{42,-82},{98,-96}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowTemAla",
          visible=have_hotWatCoi),
        Text(
          extent={{-96,46},{-66,34}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1FanCom"),
        Text(
          extent={{48,30},{98,16}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yFanStaAla"),
        Text(
          extent={{-96,26},{-66,14}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1TerFan")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-480},{240,480}})),
Documentation(info="<html>
<p>
This block outputs alarms of parallel fan-powered terminal unit with variable volume fan.
The implementation is according to the Section 5.8.6 of ASHRAE Guideline 36, May 2020.
</p>
<h4>Low airflow</h4>
<ol>
<li>
If the measured airflow <code>VPri_flow</code> is less than 70% of setpoint
<code>VActSet_flow</code> for 5 minutes (<code>lowFloTim</code>) while the setpoint
is greater than zero, generate a Level 3 alarm.
</li>
<li>
If the measured airflow <code>VPri_flow</code> is less than 50% of setpoint
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
If heating hot-water plant is proven on (<code>u1HotPla=true</code>), and the
discharge temperature (<code>TDis</code>) is 8.3 &deg;C (15 &deg;F) less than the
setpoint (<code>TDisSet</code>) for 10 minuts (<code>lowTemTim</code>), generate a
Level 3 alarm.
</li>
<li>
If heating hot-water plant is proven on (<code>u1HotPla=true</code>), and the
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
<h4>Fan status alarm</h4>
<p>
Fan alarm is indicated by the status input being different from the output command
after a period of 15 seconds after a change in output status.
</p>
<ol>
<li>
Command on (<code>u1FanCom=true</code>), status off (<code>u1TerFan=false</code>),
generate Level 2 alarm.
</li>
<li>
Command off (<code>u1FanCom=false</code>), status on (<code>u1TerFan=true</code>),
generate Level 4 alarm.
</li>
</ol>
<h4>Airflow sensor calibration</h4>
<p>
If the fan serving the zone has been OFF (<code>u1Fan=false</code>) for 10 minutes
(<code>fanOffTim</code>), and airflow sensor reading <code>VPri_flow</code>
is above 10% of the cooling maximum airflow setpoint <code>VCooMax_flow</code>,
generate a Level 3 alarm.
</p>
<h4>Leaking damper</h4>
<p>
If the damper position (<code>uDam</code>) is 0% and airflow sensor reading
<code>VPri_flow</code> is above 10% of the cooling maximum airflow setpoint
<code>VCooMax_flow</code> for 10 minutes (<code>leaFloTim</code>) while the
fan serving the zone is proven on (<code>u1Fan=true</code>), generate a Level
4 alarm.
</p>
<h4>Leaking valve</h4>
<p>
If the valve position (<code>uVal</code>) is 0% for 15 minutes (<code>valCloTim</code>),
discharing air temperature <code>TDis</code> is above AHU supply temperature
<code>TSup</code> by 3 &deg;C (5 &deg;F), and the fan serving the zone is proven
on (<code>u1Fan=true</code>), gemerate a Level 4 alarm.
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
