within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat;
block DamperValves
  "Output signals for controlling VAV reheat box damper and valve position"

  parameter Real dTDisZonSetMax(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=11
    "Zone maximum discharge air temperature above heating setpoint";
  parameter Real TDisMin(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=283.15
    "Lowest discharge air temperature";

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeVal=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Valve"));

  parameter Real kVal(final unit="1/K")=0.5
    "Gain of controller for valve control"
    annotation(Dialog(group="Valve"));

  parameter Real TiVal(
    final unit="s",
    final quantity="Time")=300
    "Time constant of integrator block for valve control"
    annotation(Dialog(group="Valve",
    enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdVal(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for valve control"
    annotation (Dialog(group="Valve",
      enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Boolean have_pressureIndependentDamper = true
    "True: the VAV damper is pressure independent (with built-in flow controller)"
    annotation(Dialog(group="Damper"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeDam=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Damper"));

  parameter Real kDam(final unit="1")=0.5
    "Gain of controller for damper control"
    annotation(Dialog(group="Damper"));

  parameter Real TiDam(
    final unit="s",
    final quantity="Time")=300
    "Time constant of integrator block for damper control"
    annotation(Dialog(group="Damper",
    enable=controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdDam(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for damper control"
    annotation (Dialog(group="Damper",
      enable=controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real V_flow_nominal(
    final unit="m3/s",
    final quantity="VolumeFlowRate",
    final min=1E-10)
    "Nominal volume flow rate, used to normalize control error"
    annotation(Dialog(group="Damper"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-360,-160},{-320,-120}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-360,260},{-320,300}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active cooling maximum airflow rate"
    annotation (Placement(transformation(extent={{-360,180},{-320,220}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active cooling minimum airflow rate"
    annotation (Placement(transformation(extent={{-360,220},{-320,260}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active minimum airflow rate"
    annotation (Placement(transformation(extent={{-360,50},{-320,90}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActHeaMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active heating minimum airflow rate"
    annotation (Placement(transformation(extent={{-360,-300},{-320,-260}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActHeaMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active heating maximum airflow rate"
    annotation (Placement(transformation(extent={{-360,-330},{-320,-290}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") if not have_pressureIndependentDamper
    "Measured discharge airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-360,320},{-320,360}}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={40,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature from central air handler"
    annotation (Placement(transformation(extent={{-360,-50},{-320,-10}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-360,-80},{-320,-40}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-360,-270},{-320,-230}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-360,110},{-320,150}}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={-40,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-360,-370},{-320,-330}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(
    final min=0,
    final max=1,
    final unit="1") "Signal for VAV damper"
    annotation (Placement(transformation(extent={{320,20},{360,60}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaVal(
    final min=0,
    final max=1,
    final unit="1")
    "Reheater valve position"
    annotation (Placement(transformation(extent={{320,-40},{360,0}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDisSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Discharge airflow setpoint"
    annotation (Placement(transformation(extent={{320,240},{360,280}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TDisHeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Discharge airflow setpoint temperature for heating"
    annotation (Placement(transformation(extent={{320,-160},{360,-120}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-220,40},{-200,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-220,0},{-200,20}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Logical not"
    annotation (Placement(transformation(extent={{-202,120},{-182,140}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if current zone state is deadband"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{-60,200},{-40,220}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin
    "Active airflow setpoint for cooling"
    annotation (Placement(transformation(extent={{-160,270},{-140,290}})));
  Buildings.Controls.OBC.CDL.Reals.Line conTDisHeaSet
    "Discharge air temperature for heating"
    annotation (Placement(transformation(extent={{-120,-82},{-100,-62}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin3
    "Active airflow setpoint for heating"
    annotation (Placement(transformation(extent={{-80,-310},{-60,-290}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conVal(
    final controllerType=controllerTypeVal,
    final k=kVal,
    final Ti=TiVal,
    final Td=TdVal,
    final yMax=1,
    final yMin=0,
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"))
    "Hot water valve controller"
    annotation (Placement(transformation(extent={{34,-90},{54,-70}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conDam(
    final controllerType=controllerTypeDam,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam,
    final yMax=1,
    final yMin=0,
    final y_reset=0) if not have_pressureIndependentDamper
    "Damper position controller"
    annotation (Placement(transformation(extent={{280,220},{300,240}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Output active cooling airflow according to cooling control signal"
    annotation (Placement(transformation(extent={{140,260},{160,280}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1 "Output active airflow when it is in deadband state"
    annotation (Placement(transformation(extent={{132,40},{152,60}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2 "Acitive heating airflow rate"
    annotation (Placement(transformation(extent={{80,-260},{100,-240}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi4
    "Output active heating airflow according to heating control signal"
    annotation (Placement(transformation(extent={{140,-260},{160,-240}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi5 "Output active cooling airflow "
    annotation (Placement(transformation(extent={{60,200},{80,220}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-280,300},{-260,320}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer1(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{100,240},{120,260}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer2(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-80,-2},{-60,18}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer3(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-260,-110},{-240,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer6(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{80,-310},{100,-290}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conOne(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-220,300},{-200,320}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conOne2(
    final k=1) "Constant real value"
    annotation (Placement(transformation(extent={{-180,-340},{-160,-320}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conHal(
    final k=0.5) "Constant real value"
    annotation (Placement(transformation(extent={{-200,-110},{-180,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conHal1(
    final k=0.5) "Constant real value"
    annotation (Placement(transformation(extent={{-260,-340},{-240,-320}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=dTDisZonSetMax)
    "Maximum heating discharge temperature"
    annotation (Placement(transformation(extent={{-260,-70},{-240,-50}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar1(
    final p=2.8)
    "Zone temperature pluTZonSets 2.8 degC"
    annotation (Placement(transformation(extent={{-260,-260},{-240,-240}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys2(
    final uHigh=0.05,
    final uLow=0.01)
    "Check if cooling control signal is greater than zero"
    annotation (Placement(transformation(extent={{-280,220},{-260,240}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys3(
    final uHigh=0.05,
    final uLow=0.01)
    "Check if heating control signal is greater than 0"
    annotation (Placement(transformation(extent={{-260,-220},{-240,-200}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys4(
    final uLow=TDisMin - 0.1,
    final uHigh=TDisMin + 0.1)
    "Check if discharge air temperature is greater than lowest discharge air temperature"
    annotation (Placement(transformation(extent={{-240,120},{-220,140}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys6(
    final uLow=-0.1,
    final uHigh=0.1)
    "Check if supply air temperature is greater than room temperature"
    annotation (Placement(transformation(extent={{-120,190},{-100,210}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys7(
    final uLow=-0.1,
    final uHigh=0.1)
    "Check if discharge air temperature is greater than room temperature plus 2.8 degC"
    annotation (Placement(transformation(extent={{-80,-260},{-60,-240}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "Calculate temperature difference between discharge air and room plus 2.8 degC"
    annotation (Placement(transformation(extent={{-120,-260},{-100,-240}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    "Calculate temperature difference between AHU supply air and room "
    annotation (Placement(transformation(extent={{-160,190},{-140,210}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truHol2(
    final falseHoldDuration=0, trueHoldDuration=600)
    "Check if the true input holds for certain time"
    annotation (Placement(transformation(extent={{-222,-220},{-202,-200}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(delayTime=600)
    "Check if the true input holds for certain time"
    annotation (Placement(transformation(extent={{-160,120},{-140,140}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel4(delayTime=600)
    "Check if the true input holds for certain time"
    annotation (Placement(transformation(extent={{-240,220},{-220,240}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isUno "Output true if the operation mode is unoccupied"
    annotation (Placement(transformation(extent={{220,-322},{240,-302}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant unOcc(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.unoccupied)
    "Constant signal for unoccupied mode"
    annotation (Placement(transformation(extent={{170,-322},{190,-302}})));
  Buildings.Controls.OBC.CDL.Reals.Switch watValPosUno "Output hot water valve position"
    annotation (Placement(transformation(extent={{280,-30},{300,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch damPosUno "Output damper position"
    annotation (Placement(transformation(extent={{280,60},{300,80}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5 "Negation of input signal"
    annotation (Placement(transformation(extent={{200,-260},{220,-240}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant lowDisAirTem(
    final k=TDisMin)
    "Lowest allowed discharge air temperature"
    annotation (Placement(transformation(extent={{-68,-108},{-48,-88}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi6
    "Output hot water valve position in case of low discharge air temperature"
    annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical not"
    annotation (Placement(transformation(extent={{-68,-64},{-48,-44}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3
    "Output hot water valve position in case of low discharge air temperature"
    annotation (Placement(transformation(extent={{104,-82},{124,-62}})));
  Buildings.Controls.OBC.CDL.Logical.Not not6 "Negation of input signal"
    annotation (Placement(transformation(extent={{-40,-192},{-20,-172}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Check if it is not in heating mode and the discharge temperature is not too low"
    annotation (Placement(transformation(extent={{20,-56},{40,-36}})));
  Buildings.Controls.OBC.CDL.Reals.Add add3 "Active airflow setpoint"
    annotation (Placement(transformation(extent={{200,250},{220,270}})));
  Buildings.Controls.OBC.CDL.Reals.Add add4 "Active airflow set point"
    annotation (Placement(transformation(extent={{180,40},{200,60}})));
  Buildings.Controls.OBC.CDL.Reals.Divide VDis_flowNor
    if not have_pressureIndependentDamper
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{240,150},{260,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant nomFlow(
    final k=V_flow_nominal)
    "Nominal volume flow rate"
    annotation (Placement(transformation(extent={{200,200},{220,220}})));
  Buildings.Controls.OBC.CDL.Reals.Divide VDisSet_flowNor
    "Normalized setpoint for discharge volume flow rate"
    annotation (Placement(transformation(extent={{240,220},{260,240}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(final k=1)
    if have_pressureIndependentDamper
    "Block that can be disabled so remove the connection"
    annotation (Placement(transformation(extent={{240,120},{260,140}})));

equation
  connect(uCoo, lin.u)
    annotation (Line(points={{-340,280},{-162,280}}, color={0,0,127}));
  connect(conZer.y, lin.x1)
    annotation (Line(points={{-258,310},{-240,310},{-240,288},{-162,288}},
      color={0,0,127}));
  connect(VActCooMin_flow, lin.f1)
    annotation (Line(points={{-340,240},{-300,240},{-300,284},{-162,284}},
      color={0,0,127}));
  connect(conOne.y, lin.x2)
    annotation (Line(points={{-198,310},{-180,310},{-180,276},{-162,276}},
      color={0,0,127}));
  connect(VActCooMax_flow, lin.f2)
    annotation (Line(points={{-340,200},{-180,200},{-180,272},{-162,272}},
      color={0,0,127}));
  connect(uCoo, hys2.u)
    annotation (Line(points={{-340,280},{-290,280},{-290,230},{-282,230}},
      color={0,0,127}));
  connect(conZer1.y, swi.u3)
    annotation (Line(points={{122,250},{130,250},{130,262},{138,262}},
      color={0,0,127}));
  connect(VActMin_flow, swi1.u1)
    annotation (Line(points={{-340,70},{30,70},{30,58},{130,58}},
      color={0,0,127}));
  connect(and2.y, swi1.u2)
    annotation (Line(points={{-58,50},{130,50}}, color={255,0,255}));
  connect(conZer2.y, swi1.u3)
    annotation (Line(points={{-58,8},{-20,8},{-20,42},{130,42}},
      color={0,0,127}));
  connect(uHea, hys3.u)
    annotation (Line(points={{-340,-140},{-280,-140},{-280,-210},{-262,-210}},
      color={0,0,127}));
  connect(conZer3.y, conTDisHeaSet.x1)
    annotation (Line(points={{-238,-100},{-220,-100},{-220,-64},{-122,-64}},
      color={0,0,127}));
  connect(TSup, conTDisHeaSet.f1)
    annotation (Line(points={{-340,-30},{-160,-30},{-160,-68},{-122,-68}},
      color={0,0,127}));
  connect(uHea, conTDisHeaSet.u)
    annotation (Line(points={{-340,-140},{-140,-140},{-140,-72},{-122,-72}},
      color={0,0,127}));
  connect(conHal.y, conTDisHeaSet.x2)
    annotation (Line(points={{-178,-100},{-160,-100},{-160,-76},{-122,-76}},
      color={0,0,127}));
  connect(addPar.y, conTDisHeaSet.f2)
    annotation (Line(points={{-238,-60},{-136,-60},{-136,-80},{-122,-80}},
      color={0,0,127}));
  connect(THeaSet, addPar.u)
    annotation (Line(points={{-340,-60},{-262,-60}}, color={0,0,127}));
  connect(uHea, lin3.u)
    annotation (Line(points={{-340,-140},{-280,-140},{-280,-300},{-82,-300}},
      color={0,0,127}));
  connect(conHal1.y, lin3.x1)
    annotation (Line(points={{-238,-330},{-200,-330},{-200,-292},{-82,-292}},
      color={0,0,127}));
  connect(conOne2.y, lin3.x2)
    annotation (Line(points={{-158,-330},{-140,-330},{-140,-304},{-82,-304}},
      color={0,0,127}));
  connect(VActHeaMax_flow, lin3.f2)
    annotation (Line(points={{-340,-310},{-120,-310},{-120,-308},{-82,-308}},
      color={0,0,127}));
  connect(VActHeaMin_flow, lin3.f1)
    annotation (Line(points={{-340,-280},{-120,-280},{-120,-296},{-82,-296}},
      color={0,0,127}));
  connect(TZon, addPar1.u)
    annotation (Line(points={{-340,-250},{-262,-250}}, color={0,0,127}));
  connect(lin3.y, swi2.u1)
    annotation (Line(points={{-58,-300},{40,-300},{40,-242},{78,-242}},
      color={0,0,127}));
  connect(VActHeaMin_flow, swi2.u3)
    annotation (Line(points={{-340,-280},{60,-280},{60,-258},{78,-258}},
      color={0,0,127}));
  connect(TDis, hys4.u)
    annotation (Line(points={{-340,130},{-242,130}},
      color={0,0,127}));
  connect(swi2.y, swi4.u1)
    annotation (Line(points={{102,-250},{112,-250},{112,-242},{138,-242}},
      color={0,0,127}));
  connect(conZer6.y, swi4.u3)
    annotation (Line(points={{102,-300},{120,-300},{120,-258},{138,-258}},
      color={0,0,127}));
  connect(VActMin_flow, swi5.u1)
    annotation (Line(points={{-340,70},{30,70},{30,218},{58,218}},
      color={0,0,127}));
  connect(and4.y, swi5.u2)
    annotation (Line(points={{-38,210},{58,210}},color={255,0,255}));
  connect(lin.y, swi5.u3)
    annotation (Line(points={{-138,280},{40,280},{40,202},{58,202}},
      color={0,0,127}));
  connect(swi5.y, swi.u1)
    annotation (Line(points={{82,210},{94,210},{94,278},{138,278}},
      color={0,0,127}));
  connect(hys4.y, not4.u)
    annotation (Line(points={{-218,130},{-204,130}}, color={255,0,255}));
  connect(TSup, sub2.u1)
    annotation (Line(points={{-340,-30},{-300,-30},{-300,180},{-176,180},{-176,206},
          {-162,206}},        color={0,0,127}));
  connect(TZon, sub2.u2)
    annotation (Line(points={{-340,-250},{-296,-250},{-296,176},{-172,176},{-172,
          194},{-162,194}},   color={0,0,127}));
  connect(sub2.y, hys6.u)
    annotation (Line(points={{-138,200},{-122,200}}, color={0,0,127}));
  connect(hys6.y, and4.u2)
    annotation (Line(points={{-98,200},{-80,200},{-80,202},{-62,202}},
      color={255,0,255}));
  connect(conTDisHeaSet.y, sub1.u1)
    annotation (Line(points={{-98,-72},{-80,-72},{-80,-220},{-140,-220},{-140,-244},
          {-122,-244}},          color={0,0,127}));
  connect(addPar1.y, sub1.u2)
    annotation (Line(points={{-238,-250},{-140,-250},{-140,-256},{-122,-256}},
      color={0,0,127}));
  connect(sub1.y, hys7.u)
    annotation (Line(points={{-98,-250},{-82,-250}},
      color={0,0,127}));
  connect(conTDisHeaSet.y, TDisHeaSet)
    annotation (Line(points={{-98,-72},{-80,-72},{-80,-140},{340,-140}},
      color={0,0,127}));
  connect(hys3.y, truHol2.u)
    annotation (Line(points={{-238,-210},{-224,-210}}, color={255,0,255}));
  connect(truHol2.y, swi4.u2)
    annotation (Line(points={{-200,-210},{120,-210},{120,-250},{138,-250}},
      color={255,0,255}));
  connect(hys2.y, truDel4.u)
    annotation (Line(points={{-258,230},{-242,230}}, color={255,0,255}));
  connect(truDel4.y, and4.u1)
    annotation (Line(points={{-218,230},{-80,230},{-80,210},{-62,210}},
      color={255,0,255}));
  connect(truDel4.y, swi.u2)
    annotation (Line(points={{-218,230},{-20,230},{-20,270},{138,270}},
      color={255,0,255}));
  connect(truHol2.y, not2.u)
    annotation (Line(points={{-200,-210},{-180,-210},{-180,-128},{-280,-128},{-280,
          10},{-222,10}}, color={255,0,255}));
  connect(truDel4.y, not1.u)
    annotation (Line(points={{-218,230},{-200,230},{-200,184},{-304,184},{-304,50},
          {-222,50}}, color={255,0,255}));
  connect(not1.y, and2.u1)
    annotation (Line(points={{-198,50},{-82,50}}, color={255,0,255}));
  connect(not2.y, and2.u2)
    annotation (Line(points={{-198,10},{-180,10},{-180,42},{-82,42}},
      color={255,0,255}));
  connect(conVal.u_m, TDis) annotation (Line(points={{44,-92},{44,-124},{-308,-124},
          {-308,130},{-340,130}}, color={0,0,127}));
  connect(hys7.y, swi2.u2)
    annotation (Line(points={{-58,-250},{78,-250}}, color={255,0,255}));
  connect(unOcc.y, isUno.u1)
    annotation (Line(points={{192,-312},{218,-312}}, color={255,127,0}));
  connect(isUno.u2, uOpeMod) annotation (Line(points={{218,-320},{200,-320},{200,
          -350},{-340,-350}}, color={255,127,0}));
  connect(isUno.y, watValPosUno.u2) annotation (Line(points={{242,-312},{266,-312},
          {266,-20},{278,-20}}, color={255,0,255}));
  connect(conZer2.y, watValPosUno.u1) annotation (Line(points={{-58,8},{-20,8},{
          -20,-12},{278,-12}},  color={0,0,127}));
  connect(watValPosUno.y, yHeaVal)
    annotation (Line(points={{302,-20},{340,-20}}, color={0,0,127}));
  connect(conZer2.y, damPosUno.u1) annotation (Line(points={{-58,8},{-20,8},{-20,
          -12},{250,-12},{250,78},{278,78}}, color={0,0,127}));
  connect(conDam.y, damPosUno.u3) annotation (Line(points={{302,230},{310,230},{
          310,100},{272,100},{272,62},{278,62}}, color={0,0,127}));
  connect(damPosUno.y, yDam) annotation (Line(points={{302,70},{308,70},{308,40},
          {340,40}}, color={0,0,127}));
  connect(isUno.y, damPosUno.u2) annotation (Line(points={{242,-312},{266,-312},
          {266,70},{278,70}}, color={255,0,255}));
  connect(isUno.y, not5.u) annotation (Line(points={{242,-312},{266,-312},{266,-280},
          {180,-280},{180,-250},{198,-250}}, color={255,0,255}));
  connect(not5.y, conDam.trigger) annotation (Line(points={{222,-250},{232,-250},
          {232,176},{284,176},{284,218}}, color={255,0,255}));
  connect(truHol2.y, or2.u2) annotation (Line(points={{-200,-210},{-88,-210},{-88,
          -62},{-70,-62}},     color={255,0,255}));
  connect(truDel3.y, not3.u)
    annotation (Line(points={{-138,130},{-122,130}}, color={255,0,255}));
  connect(not3.y, or2.u1) annotation (Line(points={{-98,130},{-88,130},{-88,-54},
          {-70,-54}}, color={255,0,255}));
  connect(or2.y, swi6.u2) annotation (Line(points={{-46,-54},{-40,-54},{-40,-80},
          {-32,-80}}, color={255,0,255}));
  connect(conTDisHeaSet.y, swi6.u1)
    annotation (Line(points={{-98,-72},{-32,-72}}, color={0,0,127}));
  connect(swi6.u3, lowDisAirTem.y) annotation (Line(points={{-32,-88},{-40,-88},
          {-40,-98},{-46,-98}}, color={0,0,127}));
  connect(swi3.y, watValPosUno.u3) annotation (Line(points={{126,-72},{200,-72},
          {200,-28},{278,-28}}, color={0,0,127}));
  connect(truHol2.y, not6.u) annotation (Line(points={{-200,-210},{-60,-210},{-60,
          -182},{-42,-182}}, color={255,0,255}));
  connect(not6.y, and1.u2) annotation (Line(points={{-18,-182},{0,-182},{0,-54},
          {18,-54}},color={255,0,255}));
  connect(and1.y, swi3.u2) annotation (Line(points={{42,-46},{64,-46},{64,-72},{
          102,-72}}, color={255,0,255}));
  connect(conVal.y, swi3.u3)
    annotation (Line(points={{56,-80},{102,-80}},   color={0,0,127}));
  connect(swi3.u1, conZer2.y) annotation (Line(points={{102,-64},{76,-64},{76,-12},
          {-20,-12},{-20,8},{-58,8}}, color={0,0,127}));
  connect(not3.y, and1.u1) annotation (Line(points={{-98,130},{0,130},{0,-46},{18,
          -46}}, color={255,0,255}));
  connect(not4.y, truDel3.u)
    annotation (Line(points={{-180,130},{-162,130}}, color={255,0,255}));
  connect(not5.y, conVal.trigger) annotation (Line(points={{222,-250},{232,-250},
          {232,-132},{38,-132},{38,-92}},  color={255,0,255}));
  connect(swi6.y, conVal.u_s)
    annotation (Line(points={{-8,-80},{32,-80}},   color={0,0,127}));
  connect(swi1.y, add4.u1) annotation (Line(points={{154,50},{168,50},{168,56},{
          178,56}}, color={0,0,127}));
  connect(swi4.y, add4.u2) annotation (Line(points={{162,-250},{170,-250},{170,44},
          {178,44}}, color={0,0,127}));
  connect(swi.y, add3.u1) annotation (Line(points={{162,270},{180,270},{180,266},
          {198,266}}, color={0,0,127}));
  connect(add4.y, add3.u2) annotation (Line(points={{202,50},{220,50},{220,80},{
          180,80},{180,254},{198,254}}, color={0,0,127}));
  connect(add3.y, VDisSet_flow)
    annotation (Line(points={{222,260},{340,260}}, color={0,0,127}));
  connect(VDis_flow, VDis_flowNor.u1) annotation (Line(points={{-340,340},{190,340},
          {190,166},{238,166}}, color={0,0,127}));
  connect(nomFlow.y, VDis_flowNor.u2) annotation (Line(points={{222,210},{230,210},
          {230,154},{238,154}}, color={0,0,127}));
  connect(VDis_flowNor.y, conDam.u_m)
    annotation (Line(points={{262,160},{290,160},{290,218}}, color={0,0,127}));
  connect(nomFlow.y, VDisSet_flowNor.u2) annotation (Line(points={{222,210},{230,
          210},{230,224},{238,224}},                     color={0,0,127}));
  connect(add3.y, VDisSet_flowNor.u1) annotation (Line(points={{222,260},{230,260},
          {230,236},{238,236}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, conDam.u_s)
    annotation (Line(points={{262,230},{278,230}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, gai.u) annotation (Line(points={{262,230},{270,230},
          {270,180},{210,180},{210,130},{238,130}}, color={0,0,127}));
  connect(gai.y, damPosUno.u3) annotation (Line(points={{262,130},{272,130},{
          272,62},{278,62}},
                         color={0,0,127}));

annotation (
  defaultComponentName="damVal",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-360},{320,360}}),
        graphics={
        Rectangle(
          extent={{-298,318},{158,182}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-298,-22},{158,-118}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-298,158},{158,102}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-298,72},{158,-4}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-298,-162},{158,-338}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-40,318},{154,280}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Active airflow setpoint
in cooling state"),
        Text(
          extent={{32,136},{216,104}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Override if TDis is lower than TDisMin
(e.g., AHU overcools)"),
        Text(
          extent={{-52,42},{154,0}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Active airflow setpoint
in deadband state"),
        Text(
          extent={{88,-26},{150,-44}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Valve control"),
        Text(
          extent={{-44,-164},{154,-200}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Active airflow setpoint
in heating state")}),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,68},{-62,54}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMax_flow"),
        Text(
          extent={{-98,88},{-62,74}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMin_flow"),
        Text(
          extent={{-98,-76},{-60,-90}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMax_flow"),
        Text(
          extent={{-98,-54},{-62,-66}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMin_flow"),
        Text(
          extent={{-98,44},{-70,38}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin_flow"),
        Text(
          extent={{-100,102},{-80,96}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-100,-18},{-80,-24}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHea"),
        Text(
          extent={{-100,2},{-76,-4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{-100,24},{-80,16}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-11.5,3.5},{11.5,-3.5}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis",
          origin={-41.5,-89.5},
          rotation=90),
        Text(
          extent={{-100,-36},{-80,-42}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          visible=not have_pressureIndependentDamper,
          extent={{-11.5,4.5},{11.5,-4.5}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={39.5,-85.5},
          rotation=90,
          textString="VDis_flow"),
        Text(
          extent={{72,44},{98,34}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yDam",
          horizontalAlignment=TextAlignment.Right),
        Text(
          extent={{66,-34},{98,-48}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yHeaVal"),
        Line(points={{-50,64},{-50,-48},{62,-48}}, color={95,95,95}),
        Line(
          points={{-50,14},{-26,-18},{-2,-18},{-2,-22},{14,-22},{14,-16},{62,48}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{-2,-22},{-2,-48}},
          color={215,215,215},
          pattern=LinePattern.Dash),
        Line(
          points={{-26,-18},{-26,36}},
          color={215,215,215},
          pattern=LinePattern.Dash),
        Line(
          points={{-26,36},{-50,36}},
          color={95,95,95},
          thickness=0.5),
        Line(
          points={{-26,36},{-2,-48}},
          color={95,95,95},
          thickness=0.5),
    Polygon(
      points={{-64,-58},{-42,-52},{-42,-64},{-64,-58}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Line(points={{-2,-58},{-60,-58}}, color={95,95,95}),
    Line(points={{16,-58},{78,-58}},  color={95,95,95}),
    Polygon(
      points={{80,-58},{58,-52},{58,-64},{80,-58}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
        Text(
          extent={{60,88},{98,76}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="VDisSet_flow"),
        Text(
          extent={{60,-74},{98,-86}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="TDisHeaSet"),
        Text(
          extent={{-98,-96},{-78,-102}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uOpeMod")}),
  Documentation(info="<html>
<p>
This sequence sets the damper and valve position for VAV reheat terminal unit.
The implementation is according to ASHRAE Guideline 36 (G36), PART 5.E.6. The
calculation is done following the steps below.
</p>
<ol>
<li>
<p>
When the zone state is cooling (<code>uCoo>0</code>), then the cooling loop output
<code>uCoo</code> shall be mapped to the airflow
setpoint from the cooling minimum <code>VActCooMin_flow</code> to the cooling maximum
<code>VActCooMax_flow</code> airflow setpoints. The hot water valve is closed (<code>yHeaVal=0</code>)
unless the discharge air temperature <code>TDis</code> is below the minimum
setpoint (10 &deg;C).</p>
</li>
<li>
<p>If supply air temperature <code>TSup</code> from the AHU is greater than
room temperature <code>TZon</code>, cooling supply airflow setpoint shall be
no higher than the minimum.
</p>
</li>
<li>
<p>
When the zone state is Deadband (<code>uCoo=0</code> and <code>uHea=0</code>), then
the active airflow setpoint shall be the minimum airflow setpoint <code>VActMin_flow</code>.
Hot water valve is closed unless the discharge air temperature is below the minimum
setpoint (10 &deg;C).
</p>
</li>
<li>
<p>
When the zone state is Heating (<code>uHea>0</code>), then
the heating loop shall maintain space temperature at the heating setpoint
as follows:</p>
<ul>
<li>From 0-50%, the heating loop output <code>uHea</code> shall reset the
discharge temperature setpoint from current AHU SAT setpoint <code>TSup</code>
to a maximum of <code>dTDisZonSetMax</code> above space temperature setpoint. The airflow
setpoint shall be the heating minimum <code>VActHeaMin_flow</code>.</li>
<li>From 50-100%, if the discharge air temperature <code>TDis</code> is
greater than room temperature plus 2.8 Kelvin, the heating loop output <code>uHea</code>
shall reset the airflow setpoint from the heating minimum airflow setpoint
<code>VActHeaMin_flow</code> to the heating maximum airflow setpoint
<code>VActHeaMax_flow</code>.</li>
</ul>
</li>
<li>
<p>The hot water valve (or modulating electric heating coil) shall be modulated
to maintain the discharge temperature at setpoint.
</p>
</li>
<li>
<p>
The VAV damper shall be modulated by a control loop to maintain the measured
airflow at the active setpoint.
</p>
</li>
</ol>

<p>The sequences of controlling damper and valve position for VAV reheat terminal
unit are described in the following figure below.</p>
<p align=\"center\">
<img alt=\"Image of damper and valve control for VAV reheat terminal unit\"
src=\"modelica://Buildings/Resources/Images/Obsolete/Controls/OBC/ASHRAE/G36_PR1/TerminalUnits/Reheat/DamperValves.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
April 18, 2020, by Jianjun Hu:<br/>
Added option to check if the VAV damper is pressure independent.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">#1873</a>.
</li>
<li>
March 11, 2020, by Jianjun Hu:<br/>
Replaced multisum block with add blocks, replaced gain block used for normalization
with division block.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1830\">#1830</a>.
</li>
<li>
September 10, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DamperValves;
