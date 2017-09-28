within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat;
block DamperValve
  "Output signals for controlling VAV reheat box damper and valve position"

  parameter Modelica.SIunits.TemperatureDifference maxDTem=11
    "Zone maximum discharge air temperature above heating setpoint";
  parameter Modelica.SIunits.Temperature minDisTem=283.15
    "Lowest discharge air temperature";
  parameter Real kWatVal=0.1
    "Gain of controller for valve control when zone state is cooling or deadband"
    annotation(Dialog(group="Controller parameter"));
  parameter Modelica.SIunits.Time TiWatVal=120
    "Time constant of Integrator block for valve control when zone state is cooling or deadband"
    annotation(Dialog(group="Controller parameter"));
  parameter Real kDam=0.1
    "Gain of controller for damper control"
    annotation(Dialog(group="Controller parameter"));
  parameter Modelica.SIunits.Time TiDam=120
    "Time constant of Integrator block for damper control"
    annotation(Dialog(group="Controller parameter"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(min=0, max=1, unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-360,-180},{-320,-140}}),
      iconTransformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(min=0, max=1, unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-360,240},{-320,280}}),
      iconTransformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMax(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Active cooling maximum"
    annotation (Placement(transformation(extent={{-360,160},{-320,200}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMin(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Active cooling minimum"
    annotation (Placement(transformation(extent={{-360,200},{-320,240}}),
      iconTransformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActMin(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Active minimum"
    annotation (Placement(transformation(extent={{-360,30},{-320,70}}),
      iconTransformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActHeaMin(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Active heating minimum"
    annotation (Placement(transformation(extent={{-360,-320},{-320,-280}}),
      iconTransformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActHeaMax(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Active heating maximum"
    annotation (Placement(transformation(extent={{-360,-350},{-320,-310}}),
      iconTransformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Measured discharge airflow rate"
    annotation (Placement(transformation(extent={{-360,300},{-320,340}}),
      iconTransformation(extent={{-10,-10},{10,10}},rotation=90,origin={40,-110})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "AHU supply air temperature"
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
    "Current discharge air temperature"
    annotation (Placement(transformation(extent={{-360,90},{-320,130}}),
      iconTransformation(extent={{-10,-10},{10,10}},rotation=90,origin={-40,-110})));
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
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{200,-240},{220,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Logical not"
    annotation (Placement(transformation(extent={{-182,80},{-162,100}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5 "Logical not"
    annotation (Placement(transformation(extent={{-220,-200},{-200,-180}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Check if heating control signal is between 0 and 0.5"
    annotation (Placement(transformation(extent={{-160,-200},{-140,-180}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if current zone state is deadband"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 "Logical and"
    annotation (Placement(transformation(extent={{0,-280},{20,-260}})));
  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{0,180},{20,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Active airflow setpoint for cooling"
    annotation (Placement(transformation(extent={{-160,250},{-140,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin1
    "Discharge air temperature for heating"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin2
    "Hot water valve position"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin3
    "Active airflow setpoint for heating"
    annotation (Placement(transformation(extent={{-80,-330},{-60,-310}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID limPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yMax=1,
    yMin=0,
    k=kWatVal,
    Ti=TiWatVal) "Hot water valve position"
    annotation (Placement(transformation(extent={{-160,120},{-140,140}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID damPosCon(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yMax=1,
    yMin=0,
    k=kDam,
    Ti=TiDam) "Damper position controller"
    annotation (Placement(transformation(extent={{260,340},{280,360}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Output active cooling airflow according to cooling control signal"
    annotation (Placement(transformation(extent={{142,240},{162,260}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Output active airflow when it is in deadband state"
    annotation (Placement(transformation(extent={{140,20},{160,40}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2 "Acitive heating airflow rate"
    annotation (Placement(transformation(extent={{80,-280},{100,-260}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3
    "Output hot water valve position in case of low discharge air temperature"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi4
    "Output active heating airflow according to heating control signal"
    annotation (Placement(transformation(extent={{140,-280},{160,-260}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi5 "Output active cooling airflow "
    annotation (Placement(transformation(extent={{60,200},{80,180}})));
  Buildings.Controls.OBC.CDL.Logical.Switch watValPos "Output hot water valve position"
    annotation (Placement(transformation(extent={{260,-110},{280,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=3) "Active airflow setpoint"
    annotation (Placement(transformation(extent={{200,200},{220,220}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-280,280},{-260,300}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer1(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-160,170},{-140,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer2(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-80,-22},{-60,-2}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer3(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-260,-130},{-240,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer4(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer5(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer6(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{80,-330},{100,-310}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-220,280},{-200,300}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne1(
    final k=1) "Constant real value"
    annotation (Placement(transformation(extent={{0,-130},{20,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne2(
    final k=1) "Constant real value"
    annotation (Placement(transformation(extent={{-180,-360},{-160,-340}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHal(
    final k=0.5) "Constant real value"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHal1(
    final k=0.5) "Constant real value"
    annotation (Placement(transformation(extent={{-260,-360},{-240,-340}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant lowDisAirTem(
    final k=minDisTem)
    "Lowest allowed discharge air temperature"
    annotation (Placement(transformation(extent={{-260,120},{-240,140}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=maxDTem,
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
    final uLow=minDisTem - 0.1,
    final uHigh=minDisTem + 0.1)
    "Check if discharge air temperature is greater than lowest discharge air temperature"
    annotation (Placement(transformation(extent={{-220,80},{-200,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys5(
    final uLow=0.49,
    final uHigh=0.51)
    "Check if heating control signal is greater than 0.5"
    annotation (Placement(transformation(extent={{-260,-200},{-240,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys6(
    final uLow=-0.1,
    final uHigh=0.1)
    "Check if supply air temperature is greater than room temperature"
    annotation (Placement(transformation(extent={{-60,170},{-40,190}})));
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
    annotation (Placement(transformation(extent={{-100,170},{-80,190}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(delayTime=600)
    "Check if the true input holds for certain time"
    annotation (Placement(transformation(extent={{-220,-240},{-200,-220}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(delayTime=600)
    "Check if the true input holds for certain time"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel4(delayTime=600)
    "Check if the true input holds for certain time"
    annotation (Placement(transformation(extent={{-240,200},{-220,220}})));

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
    annotation (Line(points={{-139,180},{-120,180},{-120,242},{140,242}},
      color={0,0,127}));
  connect(VActMin, swi1.u1)
    annotation (Line(points={{-340,50},{-20,50},{-20,38},{138,38}},
      color={0,0,127}));
  connect(and2.y, swi1.u2)
    annotation (Line(points={{-59,30},{138,30}}, color={255,0,255}));
  connect(conZer2.y, swi1.u3)
    annotation (Line(points={{-59,-12},{-20,-12},{-20,22},{138,22}},
      color={0,0,127}));
  connect(uHea, hys5.u)
    annotation (Line(points={{-340,-160},{-280,-160},{-280,-190},{-262,-190}},
      color={0,0,127}));
  connect(uHea, hys3.u)
    annotation (Line(points={{-340,-160},{-280,-160},{-280,-230},{-262,-230}},
      color={0,0,127}));
  connect(conZer3.y, lin1.x1)
    annotation (Line(points={{-239,-120},{-220,-120},{-220,-92},{-122,-92}},
      color={0,0,127}));
  connect(TSup, lin1.f1)
    annotation (Line(points={{-340,-50},{-160,-50},{-160,-96},{-122,-96}},
      color={0,0,127}));
  connect(uHea, lin1.u)
    annotation (Line(points={{-340,-160},{-140,-160},{-140,-100},{-122,-100}},
      color={0,0,127}));
  connect(conHal.y, lin1.x2)
    annotation (Line(points={{-179,-120},{-160,-120},{-160,-104},{-122,-104}},
      color={0,0,127}));
  connect(addPar.y, lin1.f2)
    annotation (Line(points={{-239,-80},{-136,-80},{-136,-108},{-122,-108}},
      color={0,0,127}));
  connect(THeaSet, addPar.u)
    annotation (Line(points={{-340,-80},{-262,-80}}, color={0,0,127}));
  connect(TSup, lin2.x1)
    annotation (Line(points={{-340,-50},{-20,-50},{-20,-92},{78,-92}},
      color={0,0,127}));
  connect(conZer4.y, lin2.f1)
    annotation (Line(points={{-39,-120},{-20,-120},{-20,-96},{78,-96}},
      color={0,0,127}));
  connect(lin1.y, lin2.u)
    annotation (Line(points={{-99,-100},{78,-100}}, color={0,0,127}));
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
  connect(and1.y, and3.u1)
    annotation (Line(points={{-139,-190},{-20,-190},{-20,-270},{-2,-270}},
      color={255,0,255}));
  connect(lin3.y, swi2.u1)
    annotation (Line(points={{-59,-320},{40,-320},{40,-262},{78,-262}},
      color={0,0,127}));
  connect(and3.y, swi2.u2)
    annotation (Line(points={{21,-270},{78,-270}}, color={255,0,255}));
  connect(VActHeaMin, swi2.u3)
    annotation (Line(points={{-340,-300},{60,-300},{60,-278},{78,-278}},
      color={0,0,127}));
  connect(lowDisAirTem.y, limPID.u_s)
    annotation (Line(points={{-239,130},{-162,130}}, color={0,0,127}));
  connect(TDis, limPID.u_m)
    annotation (Line(points={{-340,110},{-150,110},{-150,118}},
      color={0,0,127}));
  connect(TDis, hys4.u)
    annotation (Line(points={{-340,110},{-260,110},{-260,90},{-222,90}},
      color={0,0,127}));
  connect(limPID.y, swi3.u1)
    annotation (Line(points={{-139,130},{-20,130},{-20,128},{78,128}},
      color={0,0,127}));
  connect(conZer5.y, swi3.u3)
    annotation (Line(points={{-59,90},{-20,90},{-20,112},{78,112}},
      color={0,0,127}));
  connect(swi2.y, swi4.u1)
    annotation (Line(points={{101,-270},{112,-270},{112,-262},{138,-262}},
      color={0,0,127}));
  connect(conZer6.y, swi4.u3)
    annotation (Line(points={{101,-320},{120,-320},{120,-278},{138,-278}},
      color={0,0,127}));
  connect(swi.y, mulSum.u[1])
    annotation (Line(points={{163,250},{174,250},{174,214.667},{198,214.667}},
      color={0,0,127}));
  connect(swi1.y, mulSum.u[2])
    annotation (Line(points={{161,30},{180,30},{180,210},{198,210}},
      color={0,0,127}));
  connect(swi4.y, mulSum.u[3])
    annotation (Line(points={{161,-270},{186,-270},{186,205.333},{198,205.333}},
      color={0,0,127}));
  connect(mulSum.y, damPosCon.u_s)
    annotation (Line(points={{221.7,210},{240,210},{240,350},{258,350}},
      color={0,0,127}));
  connect(VDis, damPosCon.u_m)
    annotation (Line(points={{-340,320},{270,320},{270,338}},
      color={0,0,127}));
  connect(not3.y, watValPos.u2)
    annotation (Line(points={{221,-230},{240,-230},{240,-100},{258,-100}},
      color={255,0,255}));
  connect(lin2.y, watValPos.u3)
    annotation (Line(points={{101,-100},{200,-100},{200,-108},{258,-108}},
      color={0,0,127}));
  connect(swi3.y, watValPos.u1)
    annotation (Line(points={{101,120},{200,120},{200,-92},{258,-92}},
      color={0,0,127}));
  connect(watValPos.y, yHeaVal)
    annotation (Line(points={{281,-100},{300,-100},{300,-40},{330,-40}},
      color={0,0,127}));
  connect(damPosCon.y, yDam)
    annotation (Line(points={{281,350},{300,350},{300,20},{330,20}},
      color={0,0,127}));
  connect(addPar.y, lin2.x2)
    annotation (Line(points={{-239,-80},{40,-80},{40,-104},{78,-104}},
      color={0,0,127}));
  connect(conOne1.y, lin2.f2)
    annotation (Line(points={{21,-120},{40,-120},{40,-108},{78,-108}},
      color={0,0,127}));
  connect(VActMin, swi5.u1)
    annotation (Line(points={{-340,50},{40,50},{40,182},{58,182}},
      color={0,0,127}));
  connect(and4.y, swi5.u2)
    annotation (Line(points={{21,190},{58,190}}, color={255,0,255}));
  connect(lin.y, swi5.u3)
    annotation (Line(points={{-139,260},{40,260},{40,198},{58,198}},
      color={0,0,127}));
  connect(swi5.y, swi.u1)
    annotation (Line(points={{81,190},{100,190},{100,258},{140,258}},
      color={0,0,127}));
  connect(hys4.y, not4.u)
    annotation (Line(points={{-199,90},{-184,90}}, color={255,0,255}));
  connect(hys5.y, not5.u)
    annotation (Line(points={{-239,-190},{-222,-190}}, color={255,0,255}));
  connect(not5.y, and1.u1)
    annotation (Line(points={{-199,-190},{-162,-190}}, color={255,0,255}));
  connect(TSup, add2.u1)
    annotation (Line(points={{-340,-50},{-300,-50},{-300,160},{-114,160},{-114,186},
      {-102,186}}, color={0,0,127}));
  connect(TRoo, add2.u2)
    annotation (Line(points={{-340,-270},{-296,-270},{-296,156},{-110,156},{-110,174},
      {-102,174}}, color={0,0,127}));
  connect(add2.y, hys6.u)
    annotation (Line(points={{-79,180},{-62,180}}, color={0,0,127}));
  connect(hys6.y, and4.u2)
    annotation (Line(points={{-39,180},{-20,180},{-20,182},{-2,182}},
      color={255,0,255}));
  connect(lin1.y, add1.u1)
    annotation (Line(points={{-99,-100},{-80,-100},{-80,-240},{-140,-240},{-140,-264},
      {-122,-264}}, color={0,0,127}));
  connect(addPar1.y, add1.u2)
    annotation (Line(points={{-239,-270},{-140,-270},{-140,-276},{-122,-276}},
      color={0,0,127}));
  connect(add1.y, hys7.u)
    annotation (Line(points={{-99,-270},{-90,-270},{-90,-270},{-82,-270}},
      color={0,0,127}));
  connect(hys7.y, and3.u2)
    annotation (Line(points={{-59,-270},{-40,-270},{-40,-278},{-2,-278}},
      color={255,0,255}));
  connect(mulSum.y, VDisSet)
    annotation (Line(points={{221.7,210},{330,210}}, color={0,0,127}));
  connect(lin1.y, TDisSet)
    annotation (Line(points={{-99,-100},{-80,-100},{-80,-160},{330,-160}},
      color={0,0,127}));
  connect(hys3.y, truDel.u)
    annotation (Line(points={{-239,-230},{-222,-230}}, color={255,0,255}));
  connect(truDel.y, and1.u2)
    annotation (Line(points={{-199,-230},{-180,-230},{-180,-198},{-162,-198}},
      color={255,0,255}));
  connect(truDel.y, not3.u)
    annotation (Line(points={{-199,-230},{198,-230}}, color={255,0,255}));
  connect(truDel.y, swi4.u2)
    annotation (Line(points={{-199,-230},{120,-230},{120,-270},{138,-270}},
      color={255,0,255}));
  connect(not4.y, truDel3.u)
    annotation (Line(points={{-161,90},{-142,90}}, color={255,0,255}));
  connect(truDel3.y, swi3.u2)
    annotation (Line(points={{-119,90},{-100,90},{-100,120},{78,120}},
      color={255,0,255}));
  connect(hys2.y, truDel4.u)
    annotation (Line(points={{-259,210},{-242,210}}, color={255,0,255}));
  connect(truDel4.y, and4.u1)
    annotation (Line(points={{-219,210},{-20,210},{-20,190},{-2,190}},
      color={255,0,255}));
  connect(truDel4.y, swi.u2)
    annotation (Line(points={{-219,210},{-20,210},{-20,250},{140,250}},
      color={255,0,255}));
  connect(truDel.y, not2.u)
    annotation (Line(points={{-199,-230},{-180,-230},{-180,-148},{-280,-148},
      {-280,-10},{-222,-10}}, color={255,0,255}));
  connect(truDel4.y, not1.u)
    annotation (Line(points={{-219,210},{-200,210},{-200,164},{-304,164},
      {-304,30},{-222,30}}, color={255,0,255}));
  connect(not1.y, and2.u1)
    annotation (Line(points={{-199,30},{-82,30}}, color={255,0,255}));
  connect(not2.y, and2.u2)
    annotation (Line(points={{-199,-10},{-180,-10},{-180,22},{-82,22}},
      color={255,0,255}));

annotation (
  defaultComponentName="damVal_RehBox",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-380},{320,380}}),
        graphics={
        Rectangle(
          extent={{-298,298},{158,162}},
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
          extent={{-298,58},{158,-18}},
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
          extent={{-298,-182},{158,-358}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-40,298},{154,260}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Active airflow setpoint
in cooling state"),
        Text(
          extent={{38,106},{150,82}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Hot water valve control"),
        Text(
          extent={{-52,22},{154,-20}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Active airflow setpoint
in deadband state"),
        Text(
          extent={{-46,-44},{152,-80}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Hot water valve control
in heating state"),
        Text(
          extent={{-44,-184},{154,-220}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Active airflow setpoint
in heating state")}),
  Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
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
          origin={-39.5,-85.5},
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
          origin={39.5,-85.5},
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
          textString="TDisSet")}),
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
When the zone state is Deadband (<code>uCoo=0</code>, <code>uHea=0</code>, then
The active airflow setpoint shall be the minimum airflow setpoint <code>VActMin</code>.
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
to a maximum of <code>maxDTem</code> above space temperature setpoint. The airflow
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
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/TerminalUnits/DamperValveRehBox.png\"/>
</p>

<h4>References</h4>
<p>
<a href=\"http://gpc36.savemyenergy.com/public-files/\">BSR (ANSI Board of
Standards Review)/ASHRAE Guideline 36P,
<i>High Performance Sequences of Operation for HVAC systems</i>.
First Public Review Draft (June 2016)</a>
</p>

</html>", revisions="<html>
<ul>
<li>
September 10, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DamperValve;
