within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences;
block Alarms "Generate alarms of terminal unit with reheat"

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
    annotation (__cdl(ValueInReference=true));
  parameter Real lowTemTim(
    final unit="s",
    final quantity="Time")=600
    "Threshold time to check low discharge temperature"
    annotation (__cdl(ValueInReference=true), Dialog(enable=have_hotWatCoi));
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
  parameter Real valCloTim(
    final unit="s",
    final quantity="Time")=900
    "Threshold time to check valve leaking water flow"
    annotation (__cdl(ValueInReference=true));
  parameter Real floHys(
    final quantity="VolumeFlowRate",
    final unit="m3/s")=0.05
    "Near zero flow rate, below which the flow rate or difference will be seen as zero"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real dTHys(
    final unit="K",
    final quantity="TemperatureDifference")=0.25
    "Temperature difference hysteresis below which the temperature difference will be seen as zero"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Advanced", enable=have_hotWatCoi));
  parameter Real damPosHys(
    final unit="1")=0.05
    "Near zero damper position, below which the damper will be seen as closed"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real valPosHys(
    final unit="1")=0.05
    "Near zero valve position, below which the valve will be seen as closed"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real staTim(
    final unit="s",
    final quantity="Time")=1800
    "Delay triggering alarms after enabling AHU supply fan"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));

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
    annotation (Placement(transformation(extent={{-280,250},{-240,290}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Fan
    "AHU supply fan status"
    annotation (Placement(transformation(extent={{-280,50},{-240,90}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDam(
    final min=0,
    final unit="1")
    "Damper position setpoint"
    annotation (Placement(transformation(extent={{-280,-60},{-240,-20}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uVal(
    final min=0,
    final unit="1")
    "Actual valve position"
    annotation (Placement(transformation(extent={{-280,-110},{-240,-70}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Air handler supply air temperature"
    annotation (Placement(transformation(extent={{-280,-180},{-240,-140}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HotPla if have_hotWatCoi
    "Hot water plant status"
    annotation (Placement(transformation(extent={{-280,-220},{-240,-180}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-280,-260},{-240,-220}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDisSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_hotWatCoi
    "Discharge air temperature setpoint"
    annotation (Placement(transformation(extent={{-280,-300},{-240,-260}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
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
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaValAla
    "Leaking valve alarm"
    annotation (Placement(transformation(extent={{240,-130},{280,-90}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowTemAla
    if have_hotWatCoi
    "Low discharge air temperature alarms"
    annotation (Placement(transformation(extent={{240,-320},{280,-280}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=0.5)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-200,300},{-180,320}})));
  Buildings.Controls.OBC.CDL.Continuous.Less les(
    final h=floHys)
    "Check if measured airflow is less than threshold"
    annotation (Placement(transformation(extent={{-160,330},{-140,350}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=lowFloTim)
    "Check if the measured airflow has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,330},{-60,350}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(t=floHys,
      final h=0.5*floHys)
    "Check if setpoint airflow is greater than zero"
    annotation (Placement(transformation(extent={{-180,260},{-160,280}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre(
    final h=floHys)
    "Check if measured airflow is less than threshold"
    annotation (Placement(transformation(extent={{-160,200},{-140,220}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=0.7)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-200,220},{-180,240}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=lowFloTim)
    "Check if the measured airflow has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,200},{-60,220}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Measured airflow has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,330},{-20,350}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Measured airflow has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,260},{-20,280}})));
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
    annotation (Placement(transformation(extent={{80,260},{100,280}})));
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
    annotation (Placement(transformation(extent={{0,300},{20,320}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{40,300},{60,320}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Warning: airflow is less than 50% of the setpoint.")
    "Level 2 low airflow alarm"
    annotation (Placement(transformation(extent={{80,300},{100,320}})));
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
    final k=VCooMax_flow)
    "Cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(
    final k=0.1)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical not"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=fanOffTim)
    "Check if the supply fan has been OFF more than threshold time"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre1(
    final h=floHys)
    "Check if measured airflow is greater than threshold"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Logical and"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
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
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold cloDam(
    final t=damPosHys,
    final h=0.5*damPosHys) "Check if damper position is near zero"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And3 leaDamAla
    "Check if generating leak damper alarms"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
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
  Buildings.Controls.OBC.CDL.Continuous.Less les1(
    final h=dTHys) if have_hotWatCoi
    "Discharge temperature lower than setpoint by a threshold"
    annotation (Placement(transformation(extent={{-120,-250},{-100,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=-17) if have_hotWatCoi
    "Setpoint temperature minus a threshold"
    annotation (Placement(transformation(extent={{-180,-290},{-160,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.Less les2(
    final h=dTHys) if have_hotWatCoi
    "Discharge temperature lower than setpoint by a threshold"
    annotation (Placement(transformation(extent={{-120,-320},{-100,-300}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=-8) if have_hotWatCoi
    "Setpoint temperature minus a threshold"
    annotation (Placement(transformation(extent={{-180,-360},{-160,-340}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel4(
    final delayTime=lowTemTim) if have_hotWatCoi
    "Check if the discharge temperature has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,-250},{-60,-230}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel5(
    final delayTime=lowTemTim) if have_hotWatCoi
    "Check if the discharge temperature has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,-320},{-60,-300}})));
  Buildings.Controls.OBC.CDL.Logical.And and6 if have_hotWatCoi
    "Discharge temperature has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,-250},{-20,-230}})));
  Buildings.Controls.OBC.CDL.Logical.And and7 if have_hotWatCoi
    "Logical and"
    annotation (Placement(transformation(extent={{0,-290},{20,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Not not6 if have_hotWatCoi
    "Logical not"
    annotation (Placement(transformation(extent={{40,-290},{60,-270}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes4(
    final message="Warning: discharge air temperature is 17 degC less than the setpoint.")
    if have_hotWatCoi
    "Level 2 low discharge air temperature alarm"
    annotation (Placement(transformation(extent={{80,-290},{100,-270}})));
  Buildings.Controls.OBC.CDL.Integers.Switch lowTemAla if have_hotWatCoi
    "Low discharge temperature alarm"
    annotation (Placement(transformation(extent={{140,-250},{160,-230}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=2) if have_hotWatCoi
    "Level 2 alarm"
    annotation (Placement(transformation(extent={{80,-210},{100,-190}})));
  Buildings.Controls.OBC.CDL.Logical.And and8 if have_hotWatCoi
    "Discharge temperature has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,-320},{-20,-300}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt4(
    final integerTrue=3) if have_hotWatCoi
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{80,-320},{100,-300}})));
  Buildings.Controls.OBC.CDL.Logical.And and9 if have_hotWatCoi
    "Logical and"
    annotation (Placement(transformation(extent={{20,-360},{40,-340}})));
  Buildings.Controls.OBC.CDL.Logical.Not not7 if have_hotWatCoi
    "Logical not"
    annotation (Placement(transformation(extent={{60,-360},{80,-340}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes5(
    final message="Warning: discharge air temperature is 8 degC less than the setpoint.")
    if have_hotWatCoi
    "Level 3 low airflow alarm"
    annotation (Placement(transformation(extent={{100,-360},{120,-340}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conInt3(
    final k=hotWatRes) if have_hotWatCoi
    "Importance multiplier for hot water reset control"
    annotation (Placement(transformation(extent={{-120,-390},{-100,-370}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr2
    if have_hotWatCoi
    "Check if the multiplier is greater than zero"
    annotation (Placement(transformation(extent={{-80,-390},{-60,-370}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt5
    if have_hotWatCoi
    "Suppress the alarm when multiplier is zero"
    annotation (Placement(transformation(extent={{140,-390},{160,-370}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt1 if have_hotWatCoi
    "Low discharge air temperature alarms"
    annotation (Placement(transformation(extent={{200,-310},{220,-290}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel6(
    final delayTime=valCloTim)
    "Check if valve position is closed for more than threshold time"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold cloVal(
    final t=valPosHys,
    final h=0.5*valPosHys)
    "Check if valve position is near zero"
    annotation (Placement(transformation(extent={{-200,-100},{-180,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar2(
    final p=3)
    "AHU supply temperature plus 3 degree"
    annotation (Placement(transformation(extent={{-200,-170},{-180,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre2(
    final h=dTHys)
    "Discharge temperature greate than AHU supply temperature by a threshold"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  Buildings.Controls.OBC.CDL.Logical.And3 leaValAla "Check if generating leak valve alarms"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt6(
    final integerTrue=4)
    "Convert boolean true to level 4 alarm"
    annotation (Placement(transformation(extent={{140,-120},{160,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Not not8 "Logical not"
    annotation (Placement(transformation(extent={{100,-160},{120,-140}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes6(
    final message="Warning: the valve is leaking.")
    "Level 4 leaking valve alarm"
    annotation (Placement(transformation(extent={{140,-160},{160,-140}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel7(
    final delayTime=lowFloTim)
    "Check if the active flow setpoint has been greater than zero for the threshold time"
    annotation (Placement(transformation(extent={{-80,260},{-60,280}})));
  Buildings.Controls.OBC.CDL.Logical.And fanHotPlaOn if have_hotWatCoi
    "True: both the supply fan and the hot water plant are ON"
    annotation (Placement(transformation(extent={{-140,-210},{-120,-190}})));
  Buildings.Controls.OBC.CDL.Logical.And  and10
    "True: AHU fan is enabled and the discharge flow is lower than the threshold"
    annotation (Placement(transformation(extent={{-120,330},{-100,350}})));
  Buildings.Controls.OBC.CDL.Logical.And and11
    "True: AHU fan is enabled and the discharge flow is lower than the threshold"
    annotation (Placement(transformation(extent={{-118,200},{-98,220}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay fanIni(
    final delayTime=staTim)
    "Check if the AHU supply fan has been enabled for threshold time"
    annotation (Placement(transformation(extent={{-198,150},{-178,170}})));
equation
  connect(VActSet_flow, gai.u) annotation (Line(points={{-260,270},{-220,270},{
          -220,310},{-202,310}},  color={0,0,127}));
  connect(VDis_flow, les.u1)
    annotation (Line(points={{-260,340},{-162,340}}, color={0,0,127}));
  connect(gai.y, les.u2) annotation (Line(points={{-178,310},{-170,310},{-170,
          332},{-162,332}}, color={0,0,127}));
  connect(VActSet_flow, greThr.u)
    annotation (Line(points={{-260,270},{-182,270}}, color={0,0,127}));
  connect(VActSet_flow, gai1.u) annotation (Line(points={{-260,270},{-220,270},
          {-220,230},{-202,230}}, color={0,0,127}));
  connect(VDis_flow, gre.u2) annotation (Line(points={{-260,340},{-230,340},{-230,
          202},{-162,202}},      color={0,0,127}));
  connect(gai1.y, gre.u1) annotation (Line(points={{-178,230},{-170,230},{-170,
          210},{-162,210}}, color={0,0,127}));
  connect(truDel.y, and2.u1)
    annotation (Line(points={{-58,340},{-42,340}}, color={255,0,255}));
  connect(truDel1.y, and1.u2) annotation (Line(points={{-58,210},{-50,210},{-50,
          262},{-42,262}}, color={255,0,255}));
  connect(and2.y, lowFloAla.u2)
    annotation (Line(points={{-18,340},{138,340}}, color={255,0,255}));
  connect(conInt.y, lowFloAla.u1) annotation (Line(points={{102,380},{120,380},{
          120,348},{138,348}}, color={255,127,0}));
  connect(and1.y, booToInt.u)
    annotation (Line(points={{-18,270},{78,270}}, color={255,0,255}));
  connect(booToInt.y, lowFloAla.u3) annotation (Line(points={{102,270},{120,270},
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
    annotation (Line(points={{62,310},{78,310}}, color={255,0,255}));
  connect(and3.y, not1.u)
    annotation (Line(points={{22,310},{38,310}}, color={255,0,255}));
  connect(and2.y, and3.u1) annotation (Line(points={{-18,340},{-10,340},{-10,
          310},{-2,310}}, color={255,0,255}));
  connect(greThr1.y, and3.u2) annotation (Line(points={{-58,170},{-10,170},{-10,
          302},{-2,302}}, color={255,0,255}));
  connect(and1.y, and4.u1) annotation (Line(points={{-18,270},{0,270},{0,220},{
          18,220}}, color={255,0,255}));
  connect(greThr1.y, and4.u2) annotation (Line(points={{-58,170},{-10,170},{-10,
          212},{18,212}}, color={255,0,255}));
  connect(and4.y, not2.u)
    annotation (Line(points={{42,220},{58,220}}, color={255,0,255}));
  connect(not2.y, assMes1.u)
    annotation (Line(points={{82,220},{98,220}}, color={255,0,255}));
  connect(cooMaxFlo.y, gai2.u)
    annotation (Line(points={{-178,110},{-162,110}}, color={0,0,127}));
  connect(u1Fan, not3.u)
    annotation (Line(points={{-260,70},{-102,70}}, color={255,0,255}));
  connect(gai2.y, gre1.u2) annotation (Line(points={{-138,110},{-120,110},{-120,
          122},{-102,122}}, color={0,0,127}));
  connect(gre1.y, and5.u1)
    annotation (Line(points={{-78,130},{-42,130}}, color={255,0,255}));
  connect(not4.y, assMes2.u)
    annotation (Line(points={{62,100},{78,100}}, color={255,0,255}));
  connect(booToInt2.y, yFloSenAla)
    annotation (Line(points={{162,130},{260,130}}, color={255,127,0}));
  connect(proInt.y, yLowFloAla)
    annotation (Line(points={{222,280},{260,280}}, color={255,127,0}));
  connect(uDam, cloDam.u)
    annotation (Line(points={{-260,-40},{-202,-40}}, color={0,0,127}));
  connect(u1Fan, leaDamAla.u2) annotation (Line(points={{-260,70},{-220,70},{
          -220,0},{-22,0}}, color={255,0,255}));
  connect(cloDam.y, leaDamAla.u3) annotation (Line(points={{-178,-40},{-80,-40},
          {-80,-8},{-22,-8}},   color={255,0,255}));
  connect(not5.y, assMes3.u)
    annotation (Line(points={{122,-40},{138,-40}},   color={255,0,255}));
  connect(booToInt3.y, yLeaDamAla)
    annotation (Line(points={{162,0},{260,0}}, color={255,127,0}));
  connect(VDis_flow, gre1.u1) annotation (Line(points={{-260,340},{-230,340},{-230,
          130},{-102,130}}, color={0,0,127}));
  connect(TDis, les1.u1)
    annotation (Line(points={{-260,-240},{-122,-240}}, color={0,0,127}));
  connect(TDisSet, addPar.u)
    annotation (Line(points={{-260,-280},{-182,-280}}, color={0,0,127}));
  connect(addPar.y, les1.u2) annotation (Line(points={{-158,-280},{-140,-280},{-140,
          -248},{-122,-248}}, color={0,0,127}));
  connect(TDis, les2.u1) annotation (Line(points={{-260,-240},{-210,-240},{-210,
          -310},{-122,-310}}, color={0,0,127}));
  connect(TDisSet, addPar1.u) annotation (Line(points={{-260,-280},{-200,-280},{
          -200,-350},{-182,-350}}, color={0,0,127}));
  connect(addPar1.y, les2.u2) annotation (Line(points={{-158,-350},{-140,-350},{
          -140,-318},{-122,-318}}, color={0,0,127}));
  connect(les1.y, truDel4.u)
    annotation (Line(points={{-98,-240},{-82,-240}}, color={255,0,255}));
  connect(les2.y, truDel5.u)
    annotation (Line(points={{-98,-310},{-82,-310}}, color={255,0,255}));
  connect(truDel4.y, and6.u1)
    annotation (Line(points={{-58,-240},{-42,-240}}, color={255,0,255}));
  connect(and6.y, lowTemAla.u2)
    annotation (Line(points={{-18,-240},{138,-240}}, color={255,0,255}));
  connect(conInt2.y, lowTemAla.u1) annotation (Line(points={{102,-200},{120,-200},
          {120,-232},{138,-232}}, color={255,127,0}));
  connect(and6.y, and7.u1) annotation (Line(points={{-18,-240},{-10,-240},{-10,-280},
          {-2,-280}}, color={255,0,255}));
  connect(and7.y, not6.u)
    annotation (Line(points={{22,-280},{38,-280}}, color={255,0,255}));
  connect(not6.y, assMes4.u)
    annotation (Line(points={{62,-280},{78,-280}}, color={255,0,255}));
  connect(truDel5.y, and8.u1)
    annotation (Line(points={{-58,-310},{-42,-310}}, color={255,0,255}));
  connect(and8.y, booToInt4.u)
    annotation (Line(points={{-18,-310},{78,-310}}, color={255,0,255}));
  connect(and8.y, and9.u1) annotation (Line(points={{-18,-310},{0,-310},{0,-350},
          {18,-350}}, color={255,0,255}));
  connect(booToInt4.y, lowTemAla.u3) annotation (Line(points={{102,-310},{120,-310},
          {120,-248},{138,-248}}, color={255,127,0}));
  connect(and9.y, not7.u)
    annotation (Line(points={{42,-350},{58,-350}}, color={255,0,255}));
  connect(not7.y, assMes5.u)
    annotation (Line(points={{82,-350},{98,-350}}, color={255,0,255}));
  connect(conInt3.y, greThr2.u)
    annotation (Line(points={{-98,-380},{-82,-380}}, color={0,0,127}));
  connect(greThr2.y, booToInt5.u)
    annotation (Line(points={{-58,-380},{138,-380}}, color={255,0,255}));
  connect(lowTemAla.y, proInt1.u1) annotation (Line(points={{162,-240},{180,-240},
          {180,-294},{198,-294}}, color={255,127,0}));
  connect(booToInt5.y, proInt1.u2) annotation (Line(points={{162,-380},{180,-380},
          {180,-306},{198,-306}}, color={255,127,0}));
  connect(greThr2.y, and7.u2) annotation (Line(points={{-58,-380},{-10,-380},{-10,
          -288},{-2,-288}}, color={255,0,255}));
  connect(greThr2.y, and9.u2) annotation (Line(points={{-58,-380},{-10,-380},{-10,
          -358},{18,-358}}, color={255,0,255}));
  connect(proInt1.y, yLowTemAla)
    annotation (Line(points={{222,-300},{260,-300}}, color={255,127,0}));
  connect(uVal, cloVal.u)
    annotation (Line(points={{-260,-90},{-202,-90}}, color={0,0,127}));
  connect(TSup, addPar2.u)
    annotation (Line(points={{-260,-160},{-202,-160}}, color={0,0,127}));
  connect(TDis, gre2.u1) annotation (Line(points={{-260,-240},{-210,-240},{-210,
          -130},{-142,-130}}, color={0,0,127}));
  connect(addPar2.y, gre2.u2) annotation (Line(points={{-178,-160},{-160,-160},{
          -160,-138},{-142,-138}}, color={0,0,127}));
  connect(not8.y, assMes6.u)
    annotation (Line(points={{122,-150},{138,-150}}, color={255,0,255}));
  connect(booToInt6.y, yLeaValAla)
    annotation (Line(points={{162,-110},{260,-110}}, color={255,127,0}));
  connect(greThr.y, truDel7.u)
    annotation (Line(points={{-158,270},{-82,270}},  color={255,0,255}));
  connect(truDel7.y, and1.u1)
    annotation (Line(points={{-58,270},{-42,270}},  color={255,0,255}));
  connect(truDel7.y, and2.u2) annotation (Line(points={{-58,270},{-50,270},{-50,
          332},{-42,332}},     color={255,0,255}));
  connect(u1HotPla, fanHotPlaOn.u1)
    annotation (Line(points={{-260,-200},{-142,-200}}, color={255,0,255}));
  connect(fanHotPlaOn.y, and6.u2) annotation (Line(points={{-118,-200},{-50,
          -200},{-50,-248},{-42,-248}}, color={255,0,255}));
  connect(fanHotPlaOn.y, and8.u2) annotation (Line(points={{-118,-200},{-50,
          -200},{-50,-318},{-42,-318}}, color={255,0,255}));
  connect(u1Fan, fanHotPlaOn.u2) annotation (Line(points={{-260,70},{-220,70},{
          -220,-208},{-142,-208}}, color={255,0,255}));
  connect(gre1.y, leaDamAla.u1) annotation (Line(points={{-78,130},{-60,130},{
          -60,8},{-22,8}}, color={255,0,255}));
  connect(leaDamAla.y, truDel3.u)
    annotation (Line(points={{2,0},{38,0}}, color={255,0,255}));
  connect(truDel3.y, booToInt3.u)
    annotation (Line(points={{62,0},{138,0}}, color={255,0,255}));
  connect(truDel3.y, not5.u) annotation (Line(points={{62,0},{80,0},{80,-40},{
          98,-40}}, color={255,0,255}));
  connect(not3.y, and5.u2) annotation (Line(points={{-78,70},{-50,70},{-50,122},
          {-42,122}}, color={255,0,255}));
  connect(and5.y, truDel2.u)
    annotation (Line(points={{-18,130},{-2,130}}, color={255,0,255}));
  connect(truDel2.y, not4.u) annotation (Line(points={{22,130},{30,130},{30,100},
          {38,100}}, color={255,0,255}));
  connect(truDel2.y, booToInt2.u)
    annotation (Line(points={{22,130},{138,130}}, color={255,0,255}));
  connect(cloVal.y, leaValAla.u1) annotation (Line(points={{-178,-90},{-40,-90},
          {-40,-102},{-22,-102}}, color={255,0,255}));
  connect(u1Fan, leaValAla.u2) annotation (Line(points={{-260,70},{-220,70},{
          -220,-110},{-22,-110}}, color={255,0,255}));
  connect(gre2.y, leaValAla.u3) annotation (Line(points={{-118,-130},{-40,-130},
          {-40,-118},{-22,-118}}, color={255,0,255}));
  connect(leaValAla.y, truDel6.u)
    annotation (Line(points={{2,-110},{38,-110}}, color={255,0,255}));
  connect(truDel6.y, booToInt6.u)
    annotation (Line(points={{62,-110},{138,-110}}, color={255,0,255}));
  connect(truDel6.y, not8.u) annotation (Line(points={{62,-110},{80,-110},{80,
          -150},{98,-150}}, color={255,0,255}));
  connect(les.y, and10.u1)
    annotation (Line(points={{-138,340},{-122,340}}, color={255,0,255}));
  connect(and10.y, truDel.u)
    annotation (Line(points={{-98,340},{-82,340}}, color={255,0,255}));
  connect(gre.y, and11.u1)
    annotation (Line(points={{-138,210},{-120,210}}, color={255,0,255}));
  connect(and11.y, truDel1.u)
    annotation (Line(points={{-96,210},{-82,210}}, color={255,0,255}));
  connect(u1Fan, fanIni.u) annotation (Line(points={{-260,70},{-220,70},{-220,
          160},{-200,160}},
                       color={255,0,255}));
  connect(fanIni.y, and11.u2) annotation (Line(points={{-176,160},{-130,160},{
          -130,202},{-120,202}},
                            color={255,0,255}));
  connect(fanIni.y, and10.u2) annotation (Line(points={{-176,160},{-130,160},{
          -130,332},{-122,332}},
                            color={255,0,255}));
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
          extent={{-98,66},{-54,54}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActSet_flow"),
        Text(
          extent={{-100,84},{-60,74}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-98,26},{-74,16}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDam"),
        Text(
          extent={{-100,46},{-74,36}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Fan"),
        Text(
          extent={{46,88},{96,74}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowFloAla"),
        Text(
          extent={{48,48},{98,34}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yFloSenAla"),
        Text(
          extent={{48,8},{98,-6}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaDamAla"),
        Text(
          extent={{-98,6},{-80,-4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uVal"),
        Text(
          extent={{-100,-14},{-74,-24}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-98,-34},{-66,-46}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          visible=have_hotWatCoi,
          textString="u1HotPla"),
        Text(
          extent={{-100,-54},{-76,-64}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis"),
        Text(
          extent={{-100,-74},{-70,-84}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDisSet",
          visible=have_hotWatCoi),
        Text(
          extent={{48,-32},{98,-46}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaValAla"),
        Text(
          extent={{42,-72},{98,-86}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowTemAla",
          visible=have_hotWatCoi)}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-400},{240,400}})),
Documentation(info="<html>
<p>
This block outputs alarms of terminal unit with reheat. The implementation is according
to the Section 5.6.6 of ASHRAE Guideline 36, May 2020.
</p>
<h4>Low airflow</h4>
<ol>
<li>
After the AHU supply fan has been enabled for <code>staTim</code>,
if the measured airflow <code>VDis_flow</code> is less than 70% of setpoint
<code>VActSet_flow</code> for 5 minutes (<code>lowFloTim</code>) while the setpoint
is greater than zero, generate a Level 3 alarm.
</li>
<li>
After the AHU supply fan has been enabled for <code>staTim</code>,
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
<h4>Low-discharging air temperature</h4>
<ol>
<li>
If heating hot-water plant is proven on (<code>u1HotPla=true</code>), and the
discharge temperature (<code>TDis</code>) is 8 &deg;C (15 &deg;F) less than the
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
<h4>Airflow sensor calibration</h4>
<p>
If the fan serving the zone has been OFF (<code>u1Fan=false</code>) for 10 minutes
(<code>fanOffTim</code>), and airflow sensor reading <code>VDis_flow</code>
is above 10% of the cooling maximum airflow setpoint <code>VCooMax_flow</code>,
generate a Level 3 alarm.
</p>
<h4>Leaking damper</h4>
<p>
If the damper position (<code>uDam</code>) is 0% and airflow sensor reading
<code>VDis_flow</code> is above 10% of the cooling maximum airflow setpoint
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
