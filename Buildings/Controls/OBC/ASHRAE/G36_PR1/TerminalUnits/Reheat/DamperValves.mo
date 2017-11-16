within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat;
block DamperValves
  "Output signals for controlling VAV reheat box damper and valve position"

  parameter Modelica.SIunits.TemperatureDifference dTDisMax=11
    "Zone maximum discharge air temperature above heating setpoint";
  parameter Modelica.SIunits.Temperature TDisMin=283.15
    "Lowest discharge air temperature";

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeVal=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Valve"));

  parameter Real kVal(final unit="1/K")=0.5
    "Gain of controller for valve control"
    annotation(Dialog(group="Valve"));

  parameter Modelica.SIunits.Time TiVal=300
    "Time constant of integrator block for valve control"
    annotation(Dialog(group="Valve",
    enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.SIunits.Time TdVal=0.1
    "Time constant of derivative block for valve control"
    annotation (Dialog(group="Valve",
      enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));



  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeDam=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Damper"));

  parameter Real kDam(final unit="1")=0.5
    "Gain of controller for damper control"
    annotation(Dialog(group="Damper"));

  parameter Modelica.SIunits.Time TiDam=300
    "Time constant of integrator block for damper control"
    annotation(Dialog(group="Damper",
    enable=controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.SIunits.Time TdDam=0.1
    "Time constant of derivative block for damper control"
    annotation (Dialog(group="Damper",
      enable=controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.SIunits.VolumeFlowRate V_flow_nominal(min=1E-10)
    "Nominal volume flow rate, used to normalize control error"
    annotation(Dialog(group="Damper"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    min=0,
    max=1,
    final unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-360,-180},{-320,-140}}),
      iconTransformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    min=0,
    max=1,
    final unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-360,240},{-320,280}}),
      iconTransformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMax(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Active cooling maximum airflow rate"
    annotation (Placement(transformation(extent={{-360,160},{-320,200}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMin(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Active cooling minimum airflow rate"
    annotation (Placement(transformation(extent={{-360,200},{-320,240}}),
      iconTransformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActMin(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Active minimum airflow rate"
    annotation (Placement(transformation(extent={{-360,30},{-320,70}}),
      iconTransformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActHeaMin(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Active heating minimum airflow rate"
    annotation (Placement(transformation(extent={{-360,-320},{-320,-280}}),
      iconTransformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActHeaMax(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Active heating maximum airflow rate"
    annotation (Placement(transformation(extent={{-360,-350},{-320,-310}}),
      iconTransformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Measured discharge airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-360,300},{-320,340}}),
      iconTransformation(extent={{-10,-10},{10,10}},rotation=90,origin={40,-130})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Supply air temperature from central air handler"
    annotation (Placement(transformation(extent={{-360,-70},{-320,-30}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-360,-100},{-320,-60}}),
      iconTransformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRoo(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-360,-290},{-320,-250}}),
      iconTransformation(extent={{-10,-10},{10,10}},origin={-110,-90})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-360,90},{-320,130}}),
      iconTransformation(extent={{-10,-10},{10,10}},rotation=90,origin={-40,-130})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-360,-390},{-320,-350}}),
      iconTransformation(extent={{-120,-120},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(min=0, max=1, final unit="1")
    "Damper position"
    annotation (Placement(transformation(extent={{320,10},{340,30}}),
      iconTransformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaVal(min=0, max=1, final unit="1")
    "Reheater valve position"
    annotation (Placement(transformation(extent={{320,-50},{340,-30}}),
      iconTransformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDisSet(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Discharge airflow setpoint"
    annotation (Placement(transformation(extent={{320,200},{340,220}}),
      iconTransformation(extent={{100,70},{120,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TDisSet(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Discharge airflow setpoint temperature for heating"
    annotation (Placement(transformation(extent={{320,-170},{340,-150}}),
      iconTransformation(extent={{100,-90},{120,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-220,20},{-200,40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-220,-20},{-200,0}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Logical not"
    annotation (Placement(transformation(extent={{-202,100},{-182,120}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if current zone state is deadband"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{-60,180},{-40,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Active airflow setpoint for cooling"
    annotation (Placement(transformation(extent={{-160,250},{-140,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Line conTDisSet
    "Discharge air temperature for heating"
    annotation (Placement(transformation(extent={{-120,-102},{-100,-82}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin3
    "Active airflow setpoint for heating"
    annotation (Placement(transformation(extent={{-80,-330},{-60,-310}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conVal(
    final controllerType=controllerTypeVal,
    final k=kVal,
    final Ti=TiVal,
    final Td=TdVal,
    final yMax=1,
    final yMin=0,
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"),
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter)
    "Hot water valve controller"
    annotation (Placement(transformation(extent={{34,-110},{54,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conDam(
    final controllerType=controllerTypeDam,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam,
    final yMax=1,
    final yMin=0,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    final y_reset=0) "Damper position controller"
    annotation (Placement(transformation(extent={{280,160},{300,180}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Output active cooling airflow according to cooling control signal"
    annotation (Placement(transformation(extent={{140,240},{160,260}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Output active airflow when it is in deadband state"
    annotation (Placement(transformation(extent={{132,20},{152,40}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2 "Acitive heating airflow rate"
    annotation (Placement(transformation(extent={{80,-280},{100,-260}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi4
    "Output active heating airflow according to heating control signal"
    annotation (Placement(transformation(extent={{140,-280},{160,-260}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi5 "Output active cooling airflow "
    annotation (Placement(transformation(extent={{60,180},{80,200}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=3) "Active airflow setpoint"
    annotation (Placement(transformation(extent={{200,200},{220,220}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-280,280},{-260,300}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer1(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{100,220},{120,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer2(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-80,-22},{-60,-2}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer3(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-260,-130},{-240,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer6(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{80,-330},{100,-310}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-220,280},{-200,300}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne2(
    final k=1) "Constant real value"
    annotation (Placement(transformation(extent={{-180,-360},{-160,-340}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHal(
    final k=0.5) "Constant real value"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHal1(
    final k=0.5) "Constant real value"
    annotation (Placement(transformation(extent={{-260,-360},{-240,-340}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=dTDisMax,
    final k=1)
    "Maximum heating discharge temperature"
    annotation (Placement(transformation(extent={{-260,-90},{-240,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final k=1,
    final p=2.8)
    "Zone temperature pluTSetZons 2.8 degC"
    annotation (Placement(transformation(extent={{-260,-280},{-240,-260}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final uHigh=0.05,
    final uLow=0.01)
    "Check if cooling control signal is greater than zero"
    annotation (Placement(transformation(extent={{-280,200},{-260,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3(
    final uHigh=0.05,
    final uLow=0.01)
    "Check if heating control signal is greater than 0"
    annotation (Placement(transformation(extent={{-260,-240},{-240,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys4(
    final uLow=TDisMin - 0.1,
    final uHigh=TDisMin + 0.1)
    "Check if discharge air temperature is greater than lowest discharge air temperature"
    annotation (Placement(transformation(extent={{-240,100},{-220,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys6(
    final uLow=-0.1,
    final uHigh=0.1)
    "Check if supply air temperature is greater than room temperature"
    annotation (Placement(transformation(extent={{-120,170},{-100,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys7(
    final uLow=-0.1,
    final uHigh=0.1)
    "Check if discharge air temperature is greater than room temperature plus 2.8 degC"
    annotation (Placement(transformation(extent={{-80,-280},{-60,-260}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(final k2=-1)
    "Calculate temperature difference between discharge air and room plus 2.8 degC"
    annotation (Placement(transformation(extent={{-120,-280},{-100,-260}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k2=-1)
    "Calculate temperature difference between AHU supply air and room "
    annotation (Placement(transformation(extent={{-160,170},{-140,190}})));
  CDL.Logical.TrueHoldWithReset truHol2(duration=600)
    "Check if the true input holds for certain time"
    annotation (Placement(transformation(extent={{-222,-240},{-202,-220}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(delayTime=600)
    "Check if the true input holds for certain time"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel4(delayTime=600)
    "Check if the true input holds for certain time"
    annotation (Placement(transformation(extent={{-240,200},{-220,220}})));

  CDL.Integers.Equal isUno "Output true if the operation mode is unoccupied"
    annotation (Placement(transformation(extent={{220,-342},{240,-322}})));
  CDL.Integers.Sources.Constant unOcc(k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.unoccupied)
    "Constant signal for unoccupied mode"
    annotation (Placement(transformation(extent={{170,-342},{190,-322}})));
  CDL.Logical.Switch watValPosUno "Output hot water valve position"
    annotation (Placement(transformation(extent={{280,-50},{300,-30}})));
  CDL.Logical.Switch damPosUno "Output damper position"
    annotation (Placement(transformation(extent={{280,40},{300,60}})));
  CDL.Logical.Not not5 "Negation of input signal"
    annotation (Placement(transformation(extent={{202,-282},{222,-262}})));

  CDL.Continuous.Gain VDisSetNor(final k=1/V_flow_nominal)
    "Normalized setpoint for discharge volume flow rate"
    annotation (Placement(transformation(extent={{240,160},{260,180}})));
  CDL.Continuous.Gain VDisNor(final k=1/V_flow_nominal)
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{240,122},{260,142}})));
  CDL.Continuous.Sources.Constant lowDisAirTem(final k=TDisMin)
    "Lowest allowed discharge air temperature"
    annotation (Placement(transformation(extent={{-68,-128},{-48,-108}})));
  CDL.Logical.Switch swi6
    "Output hot water valve position in case of low discharge air temperature"
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}})));
  CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{-68,-84},{-48,-64}})));
  CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  CDL.Logical.Switch swi3
    "Output hot water valve position in case of low discharge air temperature"
    annotation (Placement(transformation(extent={{104,-102},{124,-82}})));
  CDL.Logical.Not not6 "Negation of input signal"
    annotation (Placement(transformation(extent={{-40,-212},{-20,-192}})));
  CDL.Logical.And and1
    annotation (Placement(transformation(extent={{20,-76},{40,-56}})));
equation
  connect(uCoo, lin.u)
    annotation (Line(points={{-340,260},{-162,260}}, color={0,0,127}));
  connect(conZer.y, lin.x1)
    annotation (Line(points={{-259,290},{-240,290},{-240,268},{-162,268}},
      color={0,0,127}));
  connect(VActCooMin, lin.f1)
    annotation (Line(points={{-340,220},{-300,220},{-300,264},{-162,264}},
      color={0,0,127}));
  connect(conOne.y, lin.x2)
    annotation (Line(points={{-199,290},{-180,290},{-180,256},{-162,256}},
      color={0,0,127}));
  connect(VActCooMax, lin.f2)
    annotation (Line(points={{-340,180},{-180,180},{-180,252},{-162,252}},
      color={0,0,127}));
  connect(uCoo, hys2.u)
    annotation (Line(points={{-340,260},{-290,260},{-290,210},{-282,210}},
      color={0,0,127}));
  connect(conZer1.y, swi.u3)
    annotation (Line(points={{121,230},{130,230},{130,242},{138,242}},
      color={0,0,127}));
  connect(VActMin, swi1.u1)
    annotation (Line(points={{-340,50},{30,50},{30,38},{130,38}},
      color={0,0,127}));
  connect(and2.y, swi1.u2)
    annotation (Line(points={{-59,30},{130,30}}, color={255,0,255}));
  connect(conZer2.y, swi1.u3)
    annotation (Line(points={{-59,-12},{-20,-12},{-20,22},{130,22}},
      color={0,0,127}));
  connect(uHea, hys3.u)
    annotation (Line(points={{-340,-160},{-280,-160},{-280,-230},{-262,-230}},
      color={0,0,127}));
  connect(conZer3.y, conTDisSet.x1)
    annotation (Line(points={{-239,-120},{-220,-120},{-220,-84},{-122,-84}},
      color={0,0,127}));
  connect(TSup, conTDisSet.f1)
    annotation (Line(points={{-340,-50},{-160,-50},{-160,-88},{-122,-88}},
      color={0,0,127}));
  connect(uHea, conTDisSet.u)
    annotation (Line(points={{-340,-160},{-140,-160},{-140,-92},{-122,-92}},
      color={0,0,127}));
  connect(conHal.y, conTDisSet.x2)
    annotation (Line(points={{-179,-120},{-160,-120},{-160,-96},{-122,-96}},
      color={0,0,127}));
  connect(addPar.y, conTDisSet.f2)
    annotation (Line(points={{-239,-80},{-136,-80},{-136,-100},{-122,-100}},
      color={0,0,127}));
  connect(THeaSet, addPar.u)
    annotation (Line(points={{-340,-80},{-262,-80}}, color={0,0,127}));
  connect(uHea, lin3.u)
    annotation (Line(points={{-340,-160},{-280,-160},{-280,-320},{-82,-320}},
      color={0,0,127}));
  connect(conHal1.y, lin3.x1)
    annotation (Line(points={{-239,-350},{-200,-350},{-200,-312},{-82,-312}},
      color={0,0,127}));
  connect(conOne2.y, lin3.x2)
    annotation (Line(points={{-159,-350},{-140,-350},{-140,-324},{-82,-324}},
      color={0,0,127}));
  connect(VActHeaMax, lin3.f2)
    annotation (Line(points={{-340,-330},{-120,-330},{-120,-328},{-82,-328}},
      color={0,0,127}));
  connect(VActHeaMin, lin3.f1)
    annotation (Line(points={{-340,-300},{-120,-300},{-120,-316},{-82,-316}},
      color={0,0,127}));
  connect(TRoo, addPar1.u)
    annotation (Line(points={{-340,-270},{-262,-270}}, color={0,0,127}));
  connect(lin3.y, swi2.u1)
    annotation (Line(points={{-59,-320},{40,-320},{40,-262},{78,-262}},
      color={0,0,127}));
  connect(VActHeaMin, swi2.u3)
    annotation (Line(points={{-340,-300},{60,-300},{60,-278},{78,-278}},
      color={0,0,127}));
  connect(TDis, hys4.u)
    annotation (Line(points={{-340,110},{-242,110}},
      color={0,0,127}));
  connect(swi2.y, swi4.u1)
    annotation (Line(points={{101,-270},{112,-270},{112,-262},{138,-262}},
      color={0,0,127}));
  connect(conZer6.y, swi4.u3)
    annotation (Line(points={{101,-320},{120,-320},{120,-278},{138,-278}},
      color={0,0,127}));
  connect(swi.y, mulSum.u[1])
    annotation (Line(points={{161,250},{164,250},{164,214},{182,214},{182,
          214.667},{198,214.667}},
      color={0,0,127}));
  connect(swi1.y, mulSum.u[2])
    annotation (Line(points={{153,30},{168,30},{168,210},{198,210}},
      color={0,0,127}));
  connect(swi4.y, mulSum.u[3])
    annotation (Line(points={{161,-270},{172,-270},{172,205.333},{198,205.333}},
      color={0,0,127}));
  connect(VActMin, swi5.u1)
    annotation (Line(points={{-340,50},{30,50},{30,198},{58,198}},
      color={0,0,127}));
  connect(and4.y, swi5.u2)
    annotation (Line(points={{-39,190},{58,190}},color={255,0,255}));
  connect(lin.y, swi5.u3)
    annotation (Line(points={{-139,260},{40,260},{40,182},{58,182}},
      color={0,0,127}));
  connect(swi5.y, swi.u1)
    annotation (Line(points={{81,190},{94,190},{94,258},{138,258}},
      color={0,0,127}));
  connect(hys4.y, not4.u)
    annotation (Line(points={{-219,110},{-204,110}},
                                                   color={255,0,255}));
  connect(TSup, add2.u1)
    annotation (Line(points={{-340,-50},{-300,-50},{-300,160},{-176,160},
      {-176,186},{-162,186}}, color={0,0,127}));
  connect(TRoo, add2.u2)
    annotation (Line(points={{-340,-270},{-296,-270},{-296,156},{-172,156},
      {-172,174},{-162,174}}, color={0,0,127}));
  connect(add2.y, hys6.u)
    annotation (Line(points={{-139,180},{-122,180}}, color={0,0,127}));
  connect(hys6.y, and4.u2)
    annotation (Line(points={{-99,180},{-80,180},{-80,182},{-62,182}},
      color={255,0,255}));
  connect(conTDisSet.y, add1.u1)
    annotation (Line(points={{-99,-92},{-80,-92},{-80,-240},{-140,-240},{-140,
          -264},{-122,-264}},   color={0,0,127}));
  connect(addPar1.y, add1.u2)
    annotation (Line(points={{-239,-270},{-140,-270},{-140,-276},{-122,-276}},
      color={0,0,127}));
  connect(add1.y, hys7.u)
    annotation (Line(points={{-99,-270},{-90,-270},{-90,-270},{-82,-270}},
      color={0,0,127}));
  connect(mulSum.y, VDisSet)
    annotation (Line(points={{221.7,210},{330,210}}, color={0,0,127}));
  connect(conTDisSet.y, TDisSet)
    annotation (Line(points={{-99,-92},{-80,-92},{-80,-160},{330,-160}},
      color={0,0,127}));
  connect(hys3.y, truHol2.u)
    annotation (Line(points={{-239,-230},{-223,-230}}, color={255,0,255}));
  connect(truHol2.y, swi4.u2)
    annotation (Line(points={{-201,-230},{120,-230},{120,-270},{138,-270}},
      color={255,0,255}));
  connect(hys2.y, truDel4.u)
    annotation (Line(points={{-259,210},{-242,210}}, color={255,0,255}));
  connect(truDel4.y, and4.u1)
    annotation (Line(points={{-219,210},{-80,210},{-80,190},{-62,190}},
      color={255,0,255}));
  connect(truDel4.y, swi.u2)
    annotation (Line(points={{-219,210},{-20,210},{-20,250},{138,250}},
      color={255,0,255}));
  connect(truHol2.y, not2.u)
    annotation (Line(points={{-201,-230},{-180,-230},{-180,-148},{-280,-148},{
          -280,-10},{-222,-10}},
                              color={255,0,255}));
  connect(truDel4.y, not1.u)
    annotation (Line(points={{-219,210},{-200,210},{-200,164},{-304,164},
      {-304,30},{-222,30}}, color={255,0,255}));
  connect(not1.y, and2.u1)
    annotation (Line(points={{-199,30},{-82,30}}, color={255,0,255}));
  connect(not2.y, and2.u2)
    annotation (Line(points={{-199,-10},{-180,-10},{-180,22},{-82,22}},
      color={255,0,255}));
  connect(conVal.u_m, TDis) annotation (Line(points={{44,-112},{44,-144},{-308,-144},
          {-308,110},{-340,110}}, color={0,0,127}));
  connect(hys7.y, swi2.u2)
    annotation (Line(points={{-59,-270},{78,-270}}, color={255,0,255}));

  connect(unOcc.y, isUno.u1)
    annotation (Line(points={{191,-332},{218,-332}}, color={255,127,0}));
  connect(isUno.u2, uOpeMod) annotation (Line(points={{218,-340},{200,-340},{200,
          -370},{-340,-370}}, color={255,127,0}));
  connect(isUno.y, watValPosUno.u2) annotation (Line(points={{241,-332},{266,-332},
          {266,-40},{278,-40}}, color={255,0,255}));
  connect(conZer2.y, watValPosUno.u1) annotation (Line(points={{-59,-12},{-20,-12},
          {-20,-32},{278,-32}},
                              color={0,0,127}));
  connect(watValPosUno.y, yHeaVal)
    annotation (Line(points={{301,-40},{330,-40}}, color={0,0,127}));
  connect(conZer2.y, damPosUno.u1) annotation (Line(points={{-59,-12},{-20,-12},
          {-20,-32},{250,-32},{250,58},{278,58}},
                                             color={0,0,127}));
  connect(conDam.y, damPosUno.u3) annotation (Line(points={{301,170},{310,170},{
          310,76},{272,76},{272,42},{278,42}}, color={0,0,127}));
  connect(damPosUno.y, yDam) annotation (Line(points={{301,50},{308,50},{308,20},
          {330,20}}, color={0,0,127}));
  connect(isUno.y, damPosUno.u2) annotation (Line(points={{241,-332},{266,-332},
          {266,50},{278,50}}, color={255,0,255}));
  connect(isUno.y, not5.u) annotation (Line(points={{241,-332},{266,-332},{266,
          -300},{180,-300},{180,-272},{200,-272}},
                                       color={255,0,255}));
  connect(not5.y, conDam.trigger) annotation (Line(points={{223,-272},{232,-272},
          {232,150},{282,150},{282,158}}, color={255,0,255}));
  connect(mulSum.y, VDisSetNor.u) annotation (Line(points={{221.7,210},{230,210},
          {230,170},{238,170}}, color={0,0,127}));
  connect(VDisSetNor.y, conDam.u_s)
    annotation (Line(points={{261,170},{278,170}}, color={0,0,127}));
  connect(VDis, VDisNor.u) annotation (Line(points={{-340,320},{224,320},{224,132},
          {238,132}}, color={0,0,127}));
  connect(VDisNor.y, conDam.u_m)
    annotation (Line(points={{261,132},{290,132},{290,158}}, color={0,0,127}));
  connect(truHol2.y, or2.u2) annotation (Line(points={{-201,-230},{-88,-230},{
          -88,-82},{-70,-82}}, color={255,0,255}));
  connect(truDel3.y, not3.u)
    annotation (Line(points={{-139,110},{-122,110}}, color={255,0,255}));
  connect(not3.y, or2.u1) annotation (Line(points={{-99,110},{-88,110},{-88,-74},
          {-70,-74}}, color={255,0,255}));
  connect(or2.y, swi6.u2) annotation (Line(points={{-47,-74},{-40,-74},{-40,
          -100},{-32,-100}}, color={255,0,255}));
  connect(conTDisSet.y, swi6.u1)
    annotation (Line(points={{-99,-92},{-32,-92}}, color={0,0,127}));
  connect(swi6.u3, lowDisAirTem.y) annotation (Line(points={{-32,-108},{-40,
          -108},{-40,-118},{-47,-118}}, color={0,0,127}));
  connect(swi3.y, watValPosUno.u3) annotation (Line(points={{125,-92},{200,-92},
          {200,-48},{278,-48}},       color={0,0,127}));
  connect(truHol2.y, not6.u) annotation (Line(points={{-201,-230},{-60,-230},{
          -60,-202},{-42,-202}}, color={255,0,255}));
  connect(not6.y, and1.u2) annotation (Line(points={{-19,-202},{-12,-202},{-12,
          -200},{-4,-200},{-4,-74},{18,-74}},
                    color={255,0,255}));
  connect(and1.y, swi3.u2) annotation (Line(points={{41,-66},{64,-66},{64,-92},{
          102,-92}},   color={255,0,255}));
  connect(conVal.y, swi3.u3)
    annotation (Line(points={{55,-100},{102,-100}}, color={0,0,127}));
  connect(swi3.u1, conZer2.y) annotation (Line(points={{102,-84},{76,-84},{76,-32},
          {-20,-32},{-20,-12},{-59,-12}},    color={0,0,127}));
  connect(not3.y, and1.u1) annotation (Line(points={{-99,110},{-2,110},{-2,-66},
          {18,-66}},color={255,0,255}));
  connect(not4.y, truDel3.u)
    annotation (Line(points={{-181,110},{-162,110}}, color={255,0,255}));
  connect(not5.y, conVal.trigger) annotation (Line(points={{223,-272},{232,-272},
          {232,-152},{36,-152},{36,-112}}, color={255,0,255}));
  connect(swi6.y, conVal.u_s)
    annotation (Line(points={{-9,-100},{32,-100}}, color={0,0,127}));
annotation (
  defaultComponentName="damVal",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-380},{320,380}}),
        graphics={
        Rectangle(
          extent={{-298,298},{158,162}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-298,-42},{158,-138}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-298,138},{158,82}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-298,52},{158,-24}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-298,-182},{158,-358}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-40,298},{154,260}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Active airflow setpoint
in cooling state"),
        Text(
          extent={{92,122},{150,76}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Override if TDis is lower
than TDisMin
(e.g., AHU overcools)"),
        Text(
          extent={{-52,22},{154,-20}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Active airflow setpoint
in deadband state"),
        Text(
          extent={{88,-46},{150,-64}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Valve control"),
        Text(
          extent={{-44,-184},{154,-220}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Active airflow setpoint
in heating state")}),
  Icon(graphics={
        Rectangle(
        extent={{-100,-120},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,96},{-62,82}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMax"),
        Text(
          extent={{-98,78},{-62,64}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMin"),
        Text(
          extent={{-98,58},{-60,44}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMax"),
        Text(
          extent={{-98,36},{-62,24}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMin"),
        Text(
          extent={{-100,12},{-72,6}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin"),
        Text(
          extent={{-100,-8},{-80,-14}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-100,-28},{-80,-34}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHea"),
        Text(
          extent={{-98,-46},{-74,-52}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{-100,-66},{-80,-74}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-11.5,3.5},{11.5,-3.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis",
          origin={-39.5,-99.5},
          rotation=90),
        Text(
          extent={{-100,-88},{-80,-94}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TRoo"),
        Text(
          extent={{-11.5,4.5},{11.5,-4.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={39.5,-99.5},
          rotation=90,
          textString="VDis"),
        Text(
          extent={{72,44},{98,34}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yDam",
          horizontalAlignment=TextAlignment.Right),
        Text(
          extent={{66,-34},{98,-48}},
          lineColor={0,0,127},
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
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="VDisSet"),
        Text(
          extent={{60,-74},{98,-86}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="TDisSet"),
        Text(
          extent={{-98,-106},{-78,-112}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uOpeMod")}),
  Documentation(info="<html>
<p>
This sequence sets the damper and valve position for VAV reheat terminal unit.
The implementation is according to ASHRAE Guideline 36 (G36), PART5.E.6. The
calculation is done following the steps below.
</p>
<ol>
<li>
<p>
When the zone state is cooling (<code>uCoo>0</code>), then the cooling loop output
<code>uCoo</code> shall be mapped to the airflow
setpoint from the cooling minimum <code>VActCooMin</code> to the cooling maximum
<code>VActCooMax</code> airflow setpoints. The hot water valve is closed (<code>yHeaVal=0</code>)
unless the discharge air temperature <code>TDis</code> is below the minimum
setpoint (10 &deg;C).</p>
</li>
<li>
<p>If supply air temperature <code>TSup</code> from the AHU is greater than
room temperature <code>TRoo</code>, cooling supply airflow setpoint shall be
no higher than the minimum.
</p>
</li>
<li>
<p>
When the zone state is Deadband (<code>uCoo=0</code> and <code>uHea=0</code>), then
the active airflow setpoint shall be the minimum airflow setpoint <code>VActMin</code>.
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
to a maximum of <code>dTDisMax</code> above space temperature setpoint. The airflow
setpoint shall be the heating minimum <code>VActHeaMin</code>.</li>
<li>From 50-100%, if the discharge air temperature <code>TDis</code> is
greater than room temperature plus 2.8 Kelvin, the heating loop output <code>uHea</code>
shall reset the airflow setpoint from the heating minimum airflow setpoint
<code>VActHeaMin</code> to the heating maximum airflow setpoint
<code>VActHeaMax</code>.</li>
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
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/TerminalUnits/Reheat/DamperValves.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
September 10, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DamperValves;
