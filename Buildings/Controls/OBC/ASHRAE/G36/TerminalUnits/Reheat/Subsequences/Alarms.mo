within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences;
block Alarms "Generate alarms of terminal unit with reheat"

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Heating coil type"
    annotation (__cdl(ValueInReference=false));
  parameter Real staPreMul
    "Importance multiplier for the zone static pressure reset control loop";
  parameter Real hotWatRes
    "Importance multiplier for the hot water reset control loop"
    annotation (Dialog(enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased));
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
    annotation (__cdl(ValueInReference=true), Dialog(enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased));
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
                Dialog(tab="Advanced", enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased));
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
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active airflow setpoint"
    annotation (Placement(transformation(extent={{-280,250},{-240,290}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Fan
    "AHU supply fan status"
    annotation (Placement(transformation(extent={{-280,50},{-240,90}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-280,10},{-240,50}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDam(
    final min=0,
    final unit="1")
    "Damper position setpoint"
    annotation (Placement(transformation(extent={{-280,-70},{-240,-30}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uVal(
    final min=0,
    final unit="1")
    "Actual valve position"
    annotation (Placement(transformation(extent={{-280,-110},{-240,-70}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Air handler supply air temperature"
    annotation (Placement(transformation(extent={{-280,-180},{-240,-140}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HotPla if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Hot water plant status"
    annotation (Placement(transformation(extent={{-280,-220},{-240,-180}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-280,-260},{-240,-220}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDisSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Discharge air temperature setpoint"
    annotation (Placement(transformation(extent={{-280,-300},{-240,-260}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowFloAla
    "Low airflow alarms"
    annotation (Placement(transformation(extent={{240,250},{280,290}}),
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
    if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Low discharge air temperature alarms"
    annotation (Placement(transformation(extent={{240,-340},{280,-300}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=0.5)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-200,300},{-180,320}})));
  Buildings.Controls.OBC.CDL.Reals.Less les(
    final h=floHys)
    "Check if measured airflow is less than threshold"
    annotation (Placement(transformation(extent={{-160,330},{-140,350}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=lowFloTim)
    "Check if the measured airflow has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,330},{-60,350}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(t=floHys,
      final h=0.5*floHys)
    "Check if setpoint airflow is greater than zero"
    annotation (Placement(transformation(extent={{-180,260},{-160,280}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre(
    final h=floHys)
    "Check if measured airflow is less than threshold"
    annotation (Placement(transformation(extent={{-160,200},{-140,220}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(
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
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conInt1(
    final k=staPreMul)
    "Importance multiplier for zone static pressure reset"
    annotation (Placement(transformation(extent={{-120,160},{-100,180}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1
    "Check if the multiplier is greater than zero"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Suppress the alarm when multiplier is zero"
    annotation (Placement(transformation(extent={{140,160},{160,180}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt
    "Low flow alarms"
    annotation (Placement(transformation(extent={{200,260},{220,280}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Logical and"
    annotation (Placement(transformation(extent={{0,330},{20,350}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{80,300},{100,320}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Warning: airflow is less than 50% of the setpoint.")
    "Level 2 low airflow alarm"
    annotation (Placement(transformation(extent={{140,300},{160,320}})));
  Buildings.Controls.OBC.CDL.Logical.And and12
    "Logical and"
    annotation (Placement(transformation(extent={{0,260},{20,280}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{80,220},{100,240}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(
    final message="Warning: airflow is less than 70% of the setpoint.")
    "Level 3 low airflow alarm"
    annotation (Placement(transformation(extent={{140,220},{160,240}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooMaxFlo(
    final k=VCooMax_flow)
    "Cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai2(
    final k=0.1)
    "Percentage of the setpoint"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical not"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=fanOffTim)
    "Check if the supply fan has been OFF more than threshold time"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre1(
    final h=floHys)
    "Check if measured airflow is greater than threshold"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Logical and"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4
    "Logical not"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes2(
    final message="Warning: airflow sensor should be calibrated.")
    "Level 3 airflow sensor alarm"
    annotation (Placement(transformation(extent={{140,90},{160,110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2(
    final integerTrue=3)
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{140,120},{160,140}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(
    final delayTime=leaFloTim)
    "Check if the air flow is above threshold by more than threshold time"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold cloDam(
    final t=damPosHys,
    final h=0.5*damPosHys) "Check if damper position is near zero"
    annotation (Placement(transformation(extent={{-200,-60},{-180,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And leaDamAla
    "Check if generating leak damper alarms"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
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
  Buildings.Controls.OBC.CDL.Reals.Less les1(
    final h=dTHys) if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Discharge temperature lower than setpoint by a threshold"
    annotation (Placement(transformation(extent={{-120,-250},{-100,-230}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=-17) if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Setpoint temperature minus a threshold"
    annotation (Placement(transformation(extent={{-180,-290},{-160,-270}})));
  Buildings.Controls.OBC.CDL.Reals.Less les2(
    final h=dTHys) if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Discharge temperature lower than setpoint by a threshold"
    annotation (Placement(transformation(extent={{-120,-320},{-100,-300}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar1(
    final p=-8) if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Setpoint temperature minus a threshold"
    annotation (Placement(transformation(extent={{-180,-360},{-160,-340}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel4(
    final delayTime=lowTemTim) if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Check if the discharge temperature has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,-250},{-60,-230}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel5(
    final delayTime=lowTemTim) if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Check if the discharge temperature has been less than threshold value for threshold time"
    annotation (Placement(transformation(extent={{-80,-320},{-60,-300}})));
  Buildings.Controls.OBC.CDL.Logical.And and6 if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Discharge temperature has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,-250},{-20,-230}})));
  Buildings.Controls.OBC.CDL.Logical.And and7 if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Logical and"
    annotation (Placement(transformation(extent={{0,-250},{20,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Not not6 if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Logical not"
    annotation (Placement(transformation(extent={{140,-290},{160,-270}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes4(
    final message="Warning: discharge air temperature is 17 degC less than the setpoint.")
    if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Level 2 low discharge air temperature alarm"
    annotation (Placement(transformation(extent={{180,-290},{200,-270}})));
  Buildings.Controls.OBC.CDL.Integers.Switch lowTemAla if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Low discharge temperature alarm"
    annotation (Placement(transformation(extent={{140,-250},{160,-230}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=2) if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Level 2 alarm"
    annotation (Placement(transformation(extent={{80,-210},{100,-190}})));
  Buildings.Controls.OBC.CDL.Logical.And and8 if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Discharge temperature has been less than threshold value for sufficient time"
    annotation (Placement(transformation(extent={{-40,-320},{-20,-300}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt4(
    final integerTrue=3) if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Convert boolean true to level 3 alarm"
    annotation (Placement(transformation(extent={{80,-320},{100,-300}})));
  Buildings.Controls.OBC.CDL.Logical.And and9 if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Logical and"
    annotation (Placement(transformation(extent={{0,-320},{20,-300}})));
  Buildings.Controls.OBC.CDL.Logical.Not not7 if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Logical not"
    annotation (Placement(transformation(extent={{140,-360},{160,-340}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes5(
    final message="Warning: discharge air temperature is 8 degC less than the setpoint.")
    if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Level 3 low airflow alarm"
    annotation (Placement(transformation(extent={{200,-360},{220,-340}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conInt3(
    final k=hotWatRes) if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Importance multiplier for hot water reset control"
    annotation (Placement(transformation(extent={{-120,-390},{-100,-370}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr2
    if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Check if the multiplier is greater than zero"
    annotation (Placement(transformation(extent={{-80,-390},{-60,-370}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt5
    if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Suppress the alarm when multiplier is zero"
    annotation (Placement(transformation(extent={{140,-390},{160,-370}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply proInt1 if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Low discharge air temperature alarms"
    annotation (Placement(transformation(extent={{200,-330},{220,-310}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel6(
    final delayTime=valCloTim)
    "Check if valve position is closed for more than threshold time"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold cloVal(
    final t=valPosHys,
    final h=0.5*valPosHys)
    "Check if valve position is near zero"
    annotation (Placement(transformation(extent={{-200,-100},{-180,-80}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar2(
    final p=3)
    "AHU supply temperature plus 3 degree"
    annotation (Placement(transformation(extent={{-200,-170},{-180,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre2(
    final h=dTHys)
    "Discharge temperature greate than AHU supply temperature by a threshold"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And leaValAla
    "Check if generating leak valve alarms"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
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
  Buildings.Controls.OBC.CDL.Logical.And fanHotPlaOn if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "True: both the supply fan and the hot water plant are ON"
    annotation (Placement(transformation(extent={{-140,-210},{-120,-190}})));
  Buildings.Controls.OBC.CDL.Logical.And  and10
    "True: AHU fan is enabled and the discharge flow is lower than the threshold"
    annotation (Placement(transformation(extent={{-120,330},{-100,350}})));
  Buildings.Controls.OBC.CDL.Logical.And and11
    "True: AHU fan is enabled and the discharge flow is lower than the threshold"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay fanIni(
    final delayTime=staTim)
    "Check if the AHU supply fan has been enabled for threshold time"
    annotation (Placement(transformation(extent={{-198,150},{-178,170}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isOcc
    "Check if current operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Occupied mode"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{40,260},{60,280}})));
  Buildings.Controls.OBC.CDL.Logical.And and13
    "Logical and"
    annotation (Placement(transformation(extent={{40,330},{60,350}})));
  Buildings.Controls.OBC.CDL.Logical.And leaDamAla1
    "Check if generating leak damper alarms"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.And leaValAla1
    "Check if generating leak valve alarms"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Buildings.Controls.OBC.CDL.Logical.And and14 if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Logical and"
    annotation (Placement(transformation(extent={{40,-320},{60,-300}})));
  Buildings.Controls.OBC.CDL.Logical.And and15 if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Logical and"
    annotation (Placement(transformation(extent={{40,-250},{60,-230}})));
equation
  connect(VActSet_flow, gai.u) annotation (Line(points={{-260,270},{-220,270},{
          -220,310},{-202,310}},  color={0,0,127}));
  connect(VDis_flow, les.u1)
    annotation (Line(points={{-260,340},{-162,340}}, color={0,0,127}));
  connect(VActSet_flow, greThr.u)
    annotation (Line(points={{-260,270},{-182,270}}, color={0,0,127}));
  connect(VActSet_flow, gai1.u) annotation (Line(points={{-260,270},{-220,270},
          {-220,230},{-202,230}}, color={0,0,127}));
  connect(VDis_flow, gre.u2) annotation (Line(points={{-260,340},{-230,340},{
          -230,202},{-162,202}}, color={0,0,127}));
  connect(gai1.y, gre.u1) annotation (Line(points={{-178,230},{-170,230},{-170,
          210},{-162,210}}, color={0,0,127}));
  connect(truDel.y, and2.u1)
    annotation (Line(points={{-58,340},{-42,340}}, color={255,0,255}));
  connect(truDel1.y, and1.u2) annotation (Line(points={{-58,210},{-50,210},{-50,
          262},{-42,262}}, color={255,0,255}));
  connect(conInt.y, lowFloAla.u1) annotation (Line(points={{102,380},{120,380},{
          120,348},{138,348}}, color={255,127,0}));
  connect(booToInt.y, lowFloAla.u3) annotation (Line(points={{102,270},{120,270},
          {120,332},{138,332}},color={255,127,0}));
  connect(conInt1.y, greThr1.u)
    annotation (Line(points={{-98,170},{-82,170}}, color={0,0,127}));
  connect(greThr1.y, booToInt1.u)
    annotation (Line(points={{-58,170},{138,170}}, color={255,0,255}));
  connect(lowFloAla.y, proInt.u1) annotation (Line(points={{162,340},{180,340},{
          180,276},{198,276}}, color={255,127,0}));
  connect(booToInt1.y, proInt.u2) annotation (Line(points={{162,170},{180,170},{
          180,264},{198,264}},  color={255,127,0}));
  connect(not1.y, assMes.u)
    annotation (Line(points={{102,310},{138,310}}, color={255,0,255}));
  connect(and2.y,and4. u1) annotation (Line(points={{-18,340},{-2,340}},
                          color={255,0,255}));
  connect(greThr1.y,and4. u2) annotation (Line(points={{-58,170},{-10,170},{-10,
          332},{-2,332}}, color={255,0,255}));
  connect(and1.y, and12.u1)
    annotation (Line(points={{-18,270},{-2,270}}, color={255,0,255}));
  connect(greThr1.y, and12.u2) annotation (Line(points={{-58,170},{-10,170},{-10,
          262},{-2,262}}, color={255,0,255}));
  connect(not2.y, assMes1.u)
    annotation (Line(points={{102,230},{138,230}}, color={255,0,255}));
  connect(cooMaxFlo.y, gai2.u)
    annotation (Line(points={{-178,110},{-162,110}}, color={0,0,127}));
  connect(u1Fan, not3.u)
    annotation (Line(points={{-260,70},{-102,70}}, color={255,0,255}));
  connect(gai2.y, gre1.u2) annotation (Line(points={{-138,110},{-120,110},{-120,
          122},{-102,122}}, color={0,0,127}));
  connect(gre1.y, and5.u1)
    annotation (Line(points={{-78,130},{-42,130}}, color={255,0,255}));
  connect(not4.y, assMes2.u)
    annotation (Line(points={{122,100},{138,100}}, color={255,0,255}));
  connect(booToInt2.y, yFloSenAla)
    annotation (Line(points={{162,130},{260,130}}, color={255,127,0}));
  connect(proInt.y, yLowFloAla)
    annotation (Line(points={{222,270},{260,270}}, color={255,127,0}));
  connect(uDam, cloDam.u)
    annotation (Line(points={{-260,-50},{-202,-50}}, color={0,0,127}));
  connect(u1Fan, leaDamAla.u2) annotation (Line(points={{-260,70},{-220,70},{-220,
          -8},{-42,-8}},    color={255,0,255}));
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
  connect(conInt2.y, lowTemAla.u1) annotation (Line(points={{102,-200},{120,-200},
          {120,-232},{138,-232}}, color={255,127,0}));
  connect(not6.y, assMes4.u)
    annotation (Line(points={{162,-280},{178,-280}}, color={255,0,255}));
  connect(truDel5.y, and8.u1)
    annotation (Line(points={{-58,-310},{-42,-310}}, color={255,0,255}));
  connect(and8.y, and9.u1) annotation (Line(points={{-18,-310},{-2,-310}},
                      color={255,0,255}));
  connect(booToInt4.y, lowTemAla.u3) annotation (Line(points={{102,-310},{120,
          -310},{120,-248},{138,-248}}, color={255,127,0}));
  connect(not7.y, assMes5.u)
    annotation (Line(points={{162,-350},{198,-350}}, color={255,0,255}));
  connect(conInt3.y, greThr2.u)
    annotation (Line(points={{-98,-380},{-82,-380}}, color={0,0,127}));
  connect(greThr2.y, booToInt5.u)
    annotation (Line(points={{-58,-380},{138,-380}}, color={255,0,255}));
  connect(lowTemAla.y, proInt1.u1) annotation (Line(points={{162,-240},{170,-240},
          {170,-314},{198,-314}}, color={255,127,0}));
  connect(booToInt5.y, proInt1.u2) annotation (Line(points={{162,-380},{170,-380},
          {170,-326},{198,-326}}, color={255,127,0}));
  connect(greThr2.y, and7.u2) annotation (Line(points={{-58,-380},{-10,-380},{-10,
          -248},{-2,-248}}, color={255,0,255}));
  connect(greThr2.y, and9.u2) annotation (Line(points={{-58,-380},{-10,-380},{-10,
          -318},{-2,-318}}, color={255,0,255}));
  connect(proInt1.y, yLowTemAla)
    annotation (Line(points={{222,-320},{260,-320}}, color={255,127,0}));
  connect(uVal, cloVal.u)
    annotation (Line(points={{-260,-90},{-202,-90}}, color={0,0,127}));
  connect(TSup, addPar2.u)
    annotation (Line(points={{-260,-160},{-202,-160}}, color={0,0,127}));
  connect(TDis, gre2.u1) annotation (Line(points={{-260,-240},{-210,-240},{-210,
          -140},{-142,-140}}, color={0,0,127}));
  connect(addPar2.y, gre2.u2) annotation (Line(points={{-178,-160},{-160,-160},{
          -160,-148},{-142,-148}}, color={0,0,127}));
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
  connect(gre1.y, leaDamAla.u1) annotation (Line(points={{-78,130},{-60,130},{-60,
          0},{-42,0}},     color={255,0,255}));
  connect(not3.y, and5.u2) annotation (Line(points={{-78,70},{-50,70},{-50,122},
          {-42,122}}, color={255,0,255}));
  connect(and5.y, truDel2.u)
    annotation (Line(points={{-18,130},{38,130}}, color={255,0,255}));
  connect(cloVal.y, leaValAla.u1) annotation (Line(points={{-178,-90},{-60,-90},
          {-60,-110},{-42,-110}}, color={255,0,255}));
  connect(u1Fan, leaValAla.u2) annotation (Line(points={{-260,70},{-220,70},{-220,
          -118},{-42,-118}},      color={255,0,255}));
  connect(les.y, and10.u1)
    annotation (Line(points={{-138,340},{-122,340}}, color={255,0,255}));
  connect(and10.y, truDel.u)
    annotation (Line(points={{-98,340},{-82,340}}, color={255,0,255}));
  connect(gre.y, and11.u1)
    annotation (Line(points={{-138,210},{-122,210}}, color={255,0,255}));
  connect(and11.y, truDel1.u)
    annotation (Line(points={{-98,210},{-82,210}}, color={255,0,255}));
  connect(u1Fan, fanIni.u) annotation (Line(points={{-260,70},{-220,70},{-220,
          160},{-200,160}}, color={255,0,255}));
  connect(fanIni.y, and11.u2) annotation (Line(points={{-176,160},{-130,160},{
          -130,202},{-122,202}}, color={255,0,255}));
  connect(fanIni.y, and10.u2) annotation (Line(points={{-176,160},{-130,160},{
          -130,332},{-122,332}}, color={255,0,255}));
  connect(uOpeMod, isOcc.u1)
    annotation (Line(points={{-260,30},{-102,30}}, color={255,127,0}));
  connect(occMod.y, isOcc.u2) annotation (Line(points={{-138,-30},{-120,-30},{-120,
          22},{-102,22}}, color={255,127,0}));
  connect(and6.y, and7.u1)
    annotation (Line(points={{-18,-240},{-2,-240}}, color={255,0,255}));
  connect(truDel3.y, booToInt3.u)
    annotation (Line(points={{62,0},{138,0}}, color={255,0,255}));
  connect(truDel3.y, not5.u) annotation (Line(points={{62,0},{80,0},{80,-40},{
          98,-40}}, color={255,0,255}));
  connect(truDel6.y, booToInt6.u)
    annotation (Line(points={{62,-110},{138,-110}}, color={255,0,255}));
  connect(truDel6.y, not8.u) annotation (Line(points={{62,-110},{80,-110},{80,
          -150},{98,-150}}, color={255,0,255}));
  connect(truDel2.y, booToInt2.u)
    annotation (Line(points={{62,130},{138,130}}, color={255,0,255}));
  connect(truDel2.y, not4.u) annotation (Line(points={{62,130},{80,130},{80,100},
          {98,100}}, color={255,0,255}));
  connect(gai.y, les.u2) annotation (Line(points={{-178,310},{-170,310},{-170,
          332},{-162,332}}, color={0,0,127}));
  connect(and4.y, and13.u1)
    annotation (Line(points={{22,340},{38,340}}, color={255,0,255}));
  connect(and12.y, and3.u1)
    annotation (Line(points={{22,270},{38,270}}, color={255,0,255}));
  connect(and3.y, booToInt.u)
    annotation (Line(points={{62,270},{78,270}}, color={255,0,255}));
  connect(and13.y, lowFloAla.u2)
    annotation (Line(points={{62,340},{138,340}}, color={255,0,255}));
  connect(and13.y, not1.u) annotation (Line(points={{62,340},{70,340},{70,310},{
          78,310}}, color={255,0,255}));
  connect(and3.y, not2.u) annotation (Line(points={{62,270},{70,270},{70,230},{78,
          230}}, color={255,0,255}));
  connect(isOcc.y, and13.u2) annotation (Line(points={{-78,30},{30,30},{30,332},
          {38,332}}, color={255,0,255}));
  connect(isOcc.y, and3.u2) annotation (Line(points={{-78,30},{30,30},{30,262},{
          38,262}}, color={255,0,255}));
  connect(leaDamAla.y, leaDamAla1.u1)
    annotation (Line(points={{-18,0},{-2,0}}, color={255,0,255}));
  connect(leaDamAla1.y, truDel3.u)
    annotation (Line(points={{22,0},{38,0}}, color={255,0,255}));
  connect(leaValAla.y, leaValAla1.u1)
    annotation (Line(points={{-18,-110},{-2,-110}}, color={255,0,255}));
  connect(leaValAla1.y, truDel6.u)
    annotation (Line(points={{22,-110},{38,-110}}, color={255,0,255}));
  connect(cloDam.y, leaDamAla1.u2) annotation (Line(points={{-178,-50},{-10,-50},
          {-10,-8},{-2,-8}}, color={255,0,255}));
  connect(gre2.y, leaValAla1.u2) annotation (Line(points={{-118,-140},{-10,-140},
          {-10,-118},{-2,-118}}, color={255,0,255}));
  connect(and7.y, and15.u1)
    annotation (Line(points={{22,-240},{38,-240}}, color={255,0,255}));
  connect(and9.y, and14.u1)
    annotation (Line(points={{22,-310},{38,-310}}, color={255,0,255}));
  connect(and14.y, booToInt4.u)
    annotation (Line(points={{62,-310},{78,-310}}, color={255,0,255}));
  connect(and15.y, lowTemAla.u2)
    annotation (Line(points={{62,-240},{138,-240}}, color={255,0,255}));
  connect(isOcc.y, and15.u2) annotation (Line(points={{-78,30},{30,30},{30,-248},
          {38,-248}}, color={255,0,255}));
  connect(isOcc.y, and14.u2) annotation (Line(points={{-78,30},{30,30},{30,-318},
          {38,-318}}, color={255,0,255}));
  connect(and15.y, not6.u) annotation (Line(points={{62,-240},{70,-240},{70,
          -280},{138,-280}}, color={255,0,255}));
  connect(and14.y, not7.u) annotation (Line(points={{62,-310},{70,-310},{70,
          -350},{138,-350}}, color={255,0,255}));
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
          extent={{-98,76},{-54,64}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActSet_flow"),
        Text(
          extent={{-100,94},{-60,84}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-98,16},{-74,6}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDam"),
        Text(
          extent={{-100,56},{-74,46}},
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
          extent={{-98,-4},{-80,-14}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uVal"),
        Text(
          extent={{-100,-24},{-74,-34}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-98,-44},{-66,-56}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          visible=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased,
          textString="u1HotPla"),
        Text(
          extent={{-100,-64},{-76,-74}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis"),
        Text(
          extent={{-100,-84},{-70,-94}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDisSet",
          visible=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased),
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
          visible=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased),
        Text(
          extent={{-98,36},{-60,24}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-400},{240,400}})),
Documentation(info="<html>
<p>
This block outputs alarms of terminal unit with reheat. The implementation is according
to the Section 5.6.6 of ASHRAE Guideline 36, May 2020.
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
<h4>Low-discharging air temperature</h4>
<ol>
<li>
If the zone is in occupied mode
and if heating hot-water plant is proven on (<code>u1HotPla=true</code>), and the
discharge temperature (<code>TDis</code>) is 8 &deg;C (15 &deg;F) less than the
setpoint (<code>TDisSet</code>) for 10 minuts (<code>lowTemTim</code>), generate a
Level 3 alarm.
</li>
<li>
If the zone is in occupied mode
and if heating hot-water plant is proven on (<code>u1HotPla=true</code>), and the
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
August 29, 2023, by Hongxiang Fu:<br/>
Because of the removal of <code>Logical.And3</code> based on ASHRAE 231P,
replaced it with a stack of two <code>Logical.And</code> blocks.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2465\">#2465</a>.
</li>
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
