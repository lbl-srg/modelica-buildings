within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences;
block DamperValves
  "Output signals for controlling VAV reheat box damper and valve position"

  parameter Real dTDisZonSetMax(
    final unit="K",
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
  parameter Boolean have_preIndDam = true
    "True: the VAV damper is pressure independent (with built-in flow controller)"
    annotation(Dialog(group="Damper"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeDam=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Damper", enable=not have_preIndDam));
  parameter Real kDam(final unit="1")=0.5
    "Gain of controller for damper control"
    annotation(Dialog(group="Damper", enable=not have_preIndDam));
  parameter Real TiDam(
    final unit="s",
    final quantity="Time")=300
    "Time constant of integrator block for damper control"
    annotation(Dialog(group="Damper",
    enable=not have_preIndDam
           and (controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdDam(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for damper control"
    annotation (Dialog(group="Damper",
      enable=not have_preIndDam
             and (controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
                  or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real V_flow_nominal(
    final unit="m3/s",
    final quantity="VolumeFlowRate",
    final min=1E-10)
    "Nominal volume flow rate, used to normalize control error"
    annotation(Dialog(group="Damper"));
  parameter Real dTHys(
    final unit="K",
    final quantity="TemperatureDifference")=0.25
    "Temperature difference hysteresis below which the temperature difference will be seen as zero"
    annotation (Dialog(tab="Advanced"));
  parameter Real looHys(
    final unit="1") = 0.05
    "Loop output hysteresis below which the output will be seen as zero"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") if not have_preIndDam
    "Measured primary discharge airflow rate"
    annotation (Placement(transformation(extent={{-360,340},{-320,380}}),
      iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active cooling minimum airflow rate"
    annotation (Placement(transformation(extent={{-360,310},{-320,350}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-360,280},{-320,320}}),
        iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active cooling maximum airflow rate"
    annotation (Placement(transformation(extent={{-360,230},{-320,270}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature of the air supplied from central air handler"
    annotation (Placement(transformation(extent={{-360,200},{-320,240}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active minimum airflow rate"
    annotation (Placement(transformation(extent={{-360,160},{-320,200}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-360,50},{-320,90}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint from central air handler"
    annotation (Placement(transformation(extent={{-360,-20},{-320,20}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-360,-110},{-320,-70}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-360,-160},{-320,-120}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-360,-220},{-320,-180}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActHeaMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active heating minimum airflow rate"
    annotation (Placement(transformation(extent={{-360,-270},{-320,-230}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActHeaMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active heating maximum airflow rate"
    annotation (Placement(transformation(extent={{-360,-300},{-320,-260}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-360,-400},{-320,-360}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDisSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Discharge airflow setpoint"
    annotation (Placement(transformation(extent={{320,260},{360,300}}),
        iconTransformation(extent={{100,120},{140,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(
    final min=0,
    final max=1,
    final unit="1") "VAV damper commanded position"
    annotation (Placement(transformation(extent={{320,60},{360,100}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(
    final min=0,
    final max=1,
    final unit="1") "Reheater valve commanded position"
    annotation (Placement(transformation(extent={{320,-20},{360,20}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TDisSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Discharge airflow setpoint temperature"
    annotation (Placement(transformation(extent={{320,-80},{360,-40}}),
        iconTransformation(extent={{100,-160},{140,-120}})));

  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{-60,240},{-40,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Active airflow setpoint for cooling"
    annotation (Placement(transformation(extent={{-160,290},{-140,310}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conDam(
    final controllerType=controllerTypeDam,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam,
    final yMax=1,
    final yMin=0,
    final y_reset=0) if not have_preIndDam
    "Damper position controller"
    annotation (Placement(transformation(extent={{280,240},{300,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Output active cooling airflow according to cooling control signal"
    annotation (Placement(transformation(extent={{160,280},{180,300}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi5
    "Airflow setpoint when it is in cooling state"
    annotation (Placement(transformation(extent={{60,310},{80,330}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Not in cooling state"
    annotation (Placement(transformation(extent={{-180,140},{-160,160}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Not in heating state"
    annotation (Placement(transformation(extent={{-180,100},{-160,120}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if current zone state is deadband"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Airflow setpoint when it is in deadband state"
    annotation (Placement(transformation(extent={{100,140},{120,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin3
    "Airflow setpoint when it is in heating state"
    annotation (Placement(transformation(extent={{-100,-260},{-80,-240}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "Acitive heating airflow rate"
    annotation (Placement(transformation(extent={{20,-230},{40,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre(
    final h=dTHys)
    "Check if the discharge air temperature is greater than zone temperature by a threshold"
    annotation (Placement(transformation(extent={{-180,-190},{-160,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Line conTDisHeaSet
    "Discharge air temperature for heating"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Enable heating coil when it is in heating state, or the discharge air temperature is lower than minimum"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi3
    "Discharge airflow setpoint when heating coil is enabled"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conVal(
    final controllerType=controllerTypeVal,
    final k=kVal,
    final Ti=TiVal,
    final Td=TdVal,
    final yMax=1,
    final yMin=0,
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"))
    "Hot water valve controller"
    annotation (Placement(transformation(extent={{20,-120},{40,-100}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Occupied mode and discharge temperature is low"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-280,320},{-260,340}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-220,320},{-200,340}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is cooling state"
    annotation (Placement(transformation(extent={{-280,260},{-260,280}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=dTHys,
    final h=0.5*dTHys)
    "Check if supply air temperature is greater than room temperature"
    annotation (Placement(transformation(extent={{-120,210},{-100,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Calculate temperature difference between AHU supply air and room "
    annotation (Placement(transformation(extent={{-160,210},{-140,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch watValPosUno "Output hot water valve position"
    annotation (Placement(transformation(extent={{280,-10},{300,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch damPosUno "Output damper position"
    annotation (Placement(transformation(extent={{280,70},{300,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide VDis_flowNor
    if not have_preIndDam
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{240,170},{260,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomFlow(
    final k=V_flow_nominal)
    "Nominal volume flow rate"
    annotation (Placement(transformation(extent={{200,220},{220,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide VDisSet_flowNor
    "Normalized setpoint for discharge volume flow rate"
    annotation (Placement(transformation(extent={{240,240},{260,260}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=1) if have_preIndDam
    "Block that can be disabled so remove the connection"
    annotation (Placement(transformation(extent={{220,140},{240,160}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lowMin(
    final t=TDisMin,
    final h=dTHys)
    "Check if discharge air temperature is less than lowest discharge air temperature"
    annotation (Placement(transformation(extent={{-260,60},{-240,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer2(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr2(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is heating state"
    annotation (Placement(transformation(extent={{-240,-150},{-220,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHal1(
    final k=0.5)
    "Constant real value"
    annotation (Placement(transformation(extent={{-280,-310},{-260,-290}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne2(
    final k=1)
    "Constant real value"
    annotation (Placement(transformation(extent={{-200,-310},{-180,-290}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=3)
    "Zone temperature plus threshold difference"
    annotation (Placement(transformation(extent={{-240,-210},{-220,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHal(
    final k=0.5)
    "Constant real value"
    annotation (Placement(transformation(extent={{-180,-100},{-160,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer3(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-260,-40},{-240,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=dTDisZonSetMax)
    "Maximum heating discharge temperature"
    annotation (Placement(transformation(extent={{-260,-100},{-240,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant lowDisAirTem(
    final k=TDisMin)
    "Lowest allowed discharge air temperature"
    annotation (Placement(transformation(extent={{-180,-150},{-160,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi4
    "Output hot water valve position in case of low discharge air temperature"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Constant signal for occupied mode"
    annotation (Placement(transformation(extent={{-280,-350},{-260,-330}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isOcc
    "Output true if the operation mode is occupied"
    annotation (Placement(transformation(extent={{-220,-350},{-200,-330}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant  unOcc(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    "Constant signal for unoccupied mode"
    annotation (Placement(transformation(extent={{40,-350},{60,-330}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isUno
    "Output true if the operation mode is unoccupied"
    annotation (Placement(transformation(extent={{100,-350},{120,-330}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1
    "Ensure the discharge temperature being higher than the minimum"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));
equation
  connect(uCoo, lin.u)
    annotation (Line(points={{-340,300},{-162,300}}, color={0,0,127}));
  connect(conZer.y, lin.x1)
    annotation (Line(points={{-258,330},{-240,330},{-240,308},{-162,308}},
      color={0,0,127}));
  connect(VActCooMin_flow, lin.f1)
    annotation (Line(points={{-340,330},{-300,330},{-300,304},{-162,304}},
      color={0,0,127}));
  connect(conOne.y, lin.x2)
    annotation (Line(points={{-198,330},{-180,330},{-180,296},{-162,296}},
      color={0,0,127}));
  connect(VActCooMax_flow, lin.f2)
    annotation (Line(points={{-340,250},{-180,250},{-180,292},{-162,292}},
      color={0,0,127}));
  connect(uCoo, greThr1.u) annotation (Line(points={{-340,300},{-300,300},{-300,
          270},{-282,270}}, color={0,0,127}));
  connect(and4.y, swi5.u2)
    annotation (Line(points={{-38,250},{20,250},{20,320},{58,320}},
        color={255,0,255}));
  connect(lin.y, swi5.u3)
    annotation (Line(points={{-138,300},{40,300},{40,312},{58,312}},
      color={0,0,127}));
  connect(swi5.y, swi.u1)
    annotation (Line(points={{82,320},{140,320},{140,298},{158,298}},
      color={0,0,127}));
  connect(TSup, sub2.u1)
    annotation (Line(points={{-340,220},{-180,220},{-180,226},{-162,226}},
        color={0,0,127}));
  connect(TZon, sub2.u2)
    annotation (Line(points={{-340,-200},{-300,-200},{-300,200},{-180,200},{-180,
          214},{-162,214}},   color={0,0,127}));
  connect(sub2.y, greThr.u)
    annotation (Line(points={{-138,220},{-122,220}}, color={0,0,127}));
  connect(greThr.y, and4.u2) annotation (Line(points={{-98,220},{-80,220},{-80,242},
          {-62,242}},      color={255,0,255}));
  connect(watValPosUno.y,yVal)
    annotation (Line(points={{302,0},{340,0}},     color={0,0,127}));
  connect(conDam.y, damPosUno.u3) annotation (Line(points={{302,250},{310,250},{
          310,120},{272,120},{272,72},{278,72}}, color={0,0,127}));
  connect(damPosUno.y, yDam)
    annotation (Line(points={{302,80},{340,80}}, color={0,0,127}));
  connect(VDis_flow, VDis_flowNor.u1) annotation (Line(points={{-340,360},{190,360},
          {190,186},{238,186}}, color={0,0,127}));
  connect(nomFlow.y, VDis_flowNor.u2) annotation (Line(points={{222,230},{230,230},
          {230,174},{238,174}}, color={0,0,127}));
  connect(VDis_flowNor.y, conDam.u_m)
    annotation (Line(points={{262,180},{290,180},{290,238}}, color={0,0,127}));
  connect(nomFlow.y, VDisSet_flowNor.u2) annotation (Line(points={{222,230},{230,
          230},{230,244},{238,244}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, conDam.u_s)
    annotation (Line(points={{262,250},{278,250}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, gai.u) annotation (Line(points={{262,250},{270,250},
          {270,200},{210,200},{210,150},{218,150}}, color={0,0,127}));
  connect(gai.y, damPosUno.u3) annotation (Line(points={{242,150},{272,150},{272,
          72},{278,72}}, color={0,0,127}));
  connect(greThr1.y, and4.u1) annotation (Line(points={{-258,270},{-80,270},{-80,
          250},{-62,250}},     color={255,0,255}));
  connect(greThr1.y, swi.u2) annotation (Line(points={{-258,270},{-80,270},{-80,
          290},{158,290}}, color={255,0,255}));
  connect(VActMin_flow, swi5.u1) annotation (Line(points={{-340,180},{0,180},{0,
          328},{58,328}}, color={0,0,127}));
  connect(TDis, lowMin.u)
    annotation (Line(points={{-340,70},{-262,70}},   color={0,0,127}));
  connect(greThr1.y, not1.u) annotation (Line(points={{-258,270},{-200,270},{-200,
          150},{-182,150}},    color={255,0,255}));
  connect(uHea, greThr2.u) annotation (Line(points={{-340,-140},{-242,-140}},
                                   color={0,0,127}));
  connect(greThr2.y, not2.u) annotation (Line(points={{-218,-140},{-200,-140},{-200,
          110},{-182,110}},    color={255,0,255}));
  connect(not1.y, and2.u1)
    annotation (Line(points={{-158,150},{-122,150}}, color={255,0,255}));
  connect(not2.y, and2.u2) annotation (Line(points={{-158,110},{-140,110},{-140,
          142},{-122,142}}, color={255,0,255}));
  connect(and2.y, swi1.u2)
    annotation (Line(points={{-98,150},{98,150}}, color={255,0,255}));
  connect(VActMin_flow, swi1.u1) annotation (Line(points={{-340,180},{0,180},{0,
          158},{98,158}}, color={0,0,127}));
  connect(conHal1.y, lin3.x1) annotation (Line(points={{-258,-300},{-240,-300},{
          -240,-242},{-102,-242}},  color={0,0,127}));
  connect(VActHeaMin_flow, lin3.f1) annotation (Line(points={{-340,-250},{-300,-250},
          {-300,-246},{-102,-246}},       color={0,0,127}));
  connect(conOne2.y, lin3.x2) annotation (Line(points={{-178,-300},{-160,-300},{
          -160,-254},{-102,-254}},  color={0,0,127}));
  connect(VActHeaMax_flow, lin3.f2) annotation (Line(points={{-340,-280},{-300,-280},
          {-300,-258},{-102,-258}},       color={0,0,127}));
  connect(uHea, lin3.u) annotation (Line(points={{-340,-140},{-290,-140},{-290,-250},
          {-102,-250}},       color={0,0,127}));
  connect(TZon, addPar1.u)
    annotation (Line(points={{-340,-200},{-242,-200}}, color={0,0,127}));
  connect(TDis, gre.u1) annotation (Line(points={{-340,70},{-280,70},{-280,-180},
          {-182,-180}},       color={0,0,127}));
  connect(addPar1.y, gre.u2) annotation (Line(points={{-218,-200},{-200,-200},{-200,
          -188},{-182,-188}},      color={0,0,127}));
  connect(gre.y, swi2.u2) annotation (Line(points={{-158,-180},{-60,-180},{-60,-220},
          {18,-220}},       color={255,0,255}));
  connect(VActHeaMin_flow, swi2.u3) annotation (Line(points={{-340,-250},{-300,-250},
          {-300,-228},{18,-228}},       color={0,0,127}));
  connect(lin3.y, swi2.u1) annotation (Line(points={{-78,-250},{-20,-250},{-20,-212},
          {18,-212}},       color={0,0,127}));
  connect(swi2.y, swi1.u3) annotation (Line(points={{42,-220},{80,-220},{80,142},
          {98,142}},color={0,0,127}));
  connect(swi1.y, swi.u3) annotation (Line(points={{122,150},{140,150},{140,282},
          {158,282}}, color={0,0,127}));
  connect(swi.y, VDisSet_flowNor.u1) annotation (Line(points={{182,290},{200,290},
          {200,256},{238,256}},      color={0,0,127}));
  connect(swi.y, VDisSet_flow) annotation (Line(points={{182,290},{200,290},{200,
          280},{340,280}},     color={0,0,127}));
  connect(THeaSet, addPar.u)
    annotation (Line(points={{-340,-90},{-262,-90}}, color={0,0,127}));
  connect(conZer3.y, conTDisHeaSet.x1) annotation (Line(points={{-238,-30},{-220,
          -30},{-220,-52},{-102,-52}},       color={0,0,127}));
  connect(conHal.y, conTDisHeaSet.x2) annotation (Line(points={{-158,-90},{-120,
          -90},{-120,-64},{-102,-64}},       color={0,0,127}));
  connect(TSupSet, conTDisHeaSet.f1) annotation (Line(points={{-340,0},{-140,0},
          {-140,-56},{-102,-56}},      color={0,0,127}));
  connect(addPar.y, conTDisHeaSet.f2) annotation (Line(points={{-238,-90},{-220,
          -90},{-220,-68},{-102,-68}}, color={0,0,127}));
  connect(uHea, conTDisHeaSet.u) annotation (Line(points={{-340,-140},{-290,-140},
          {-290,-60},{-102,-60}},       color={0,0,127}));
  connect(greThr2.y, or2.u2) annotation (Line(points={{-218,-140},{-200,-140},{-200,
          32},{-62,32}},        color={255,0,255}));
  connect(greThr2.y, swi3.u2) annotation (Line(points={{-218,-140},{-200,-140},{
          -200,-110},{-42,-110}},  color={255,0,255}));
  connect(conTDisHeaSet.y, swi3.u1) annotation (Line(points={{-78,-60},{-60,-60},
          {-60,-102},{-42,-102}}, color={0,0,127}));
  connect(swi3.y, conVal.u_s)
    annotation (Line(points={{-18,-110},{18,-110}}, color={0,0,127}));
  connect(TDis, conVal.u_m) annotation (Line(points={{-340,70},{-280,70},{-280,-160},
          {30,-160},{30,-122}},            color={0,0,127}));
  connect(or2.y, conVal.trigger) annotation (Line(points={{-38,40},{-10,40},{-10,
          -130},{24,-130},{24,-122}},   color={255,0,255}));
  connect(or2.y, swi4.u2) annotation (Line(points={{-38,40},{-10,40},{-10,-40},{
          98,-40}},  color={255,0,255}));
  connect(conVal.y, swi4.u1) annotation (Line(points={{42,-110},{60,-110},{60,-32},
          {98,-32}},      color={0,0,127}));
  connect(conZer2.y, swi4.u3) annotation (Line(points={{-18,110},{20,110},{20,-48},
          {98,-48}}, color={0,0,127}));
  connect(conZer2.y, watValPosUno.u1) annotation (Line(points={{-18,110},{20,110},
          {20,8},{278,8}},     color={0,0,127}));
  connect(swi4.y, watValPosUno.u3) annotation (Line(points={{122,-40},{140,-40},
          {140,-8},{278,-8}},   color={0,0,127}));
  connect(uOpeMod, isOcc.u2) annotation (Line(points={{-340,-380},{-240,-380},{-240,
          -348},{-222,-348}},      color={255,127,0}));
  connect(occMod.y, isOcc.u1)
    annotation (Line(points={{-258,-340},{-222,-340}}, color={255,127,0}));
  connect(lowMin.y, and1.u1) annotation (Line(points={{-238,70},{-122,70}},
                             color={255,0,255}));
  connect(isOcc.y, and1.u2) annotation (Line(points={{-198,-340},{-150,-340},{-150,
          62},{-122,62}},      color={255,0,255}));
  connect(and1.y, or2.u1) annotation (Line(points={{-98,70},{-80,70},{-80,40},{-62,
          40}},      color={255,0,255}));
  connect(swi3.y, TDisSet) annotation (Line(points={{-18,-110},{0,-110},{0,-60},
          {340,-60}}, color={0,0,127}));
  connect(unOcc.y, isUno.u1)
    annotation (Line(points={{62,-340},{98,-340}}, color={255,127,0}));
  connect(uOpeMod, isUno.u2) annotation (Line(points={{-340,-380},{80,-380},{80,
          -348},{98,-348}}, color={255,127,0}));
  connect(conZer2.y, damPosUno.u1) annotation (Line(points={{-18,110},{20,110},{
          20,88},{278,88}}, color={0,0,127}));
  connect(isUno.y, damPosUno.u2) annotation (Line(points={{122,-340},{240,-340},
          {240,80},{278,80}}, color={255,0,255}));
  connect(isUno.y, watValPosUno.u2) annotation (Line(points={{122,-340},{240,-340},
          {240,0},{278,0}}, color={255,0,255}));
  connect(isUno.y, conDam.trigger) annotation (Line(points={{122,-340},{240,-340},
          {240,128},{284,128},{284,238}}, color={255,0,255}));
  connect(TSupSet, max1.u1) annotation (Line(points={{-340,0},{-140,0},{-140,-134},
          {-102,-134}}, color={0,0,127}));
  connect(lowDisAirTem.y, max1.u2) annotation (Line(points={{-158,-140},{-140,-140},
          {-140,-146},{-102,-146}}, color={0,0,127}));
  connect(max1.y, swi3.u3) annotation (Line(points={{-78,-140},{-60,-140},{-60,-118},
          {-42,-118}}, color={0,0,127}));
annotation (
  defaultComponentName="damVal",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-400},{320,400}}),
        graphics={
        Rectangle(
          extent={{-318,378},{138,202}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-318,178},{138,102}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-318,78},{138,2}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-318,-22},{138,-158}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-318,-182},{138,-318}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-48,236},{126,206}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Airflow setpoint
in cooling state"),
        Text(
          extent={{-390,150},{-218,114}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Airflow setpoint
in deadband state"),
        Text(
          extent={{-60,80},{114,40}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Check if discharge temperature
is lower than minimum"),
        Text(
          extent={{16,-122},{132,-158}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Discharge temperature
setpoint"),
        Text(
          extent={{-48,-278},{126,-308}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Airflow setpoint
in heating state")}),
  Icon(coordinateSystem(extent={{-100,-200},{100,200}}),
       graphics={
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,240},{100,200}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,106},{-46,92}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMax_flow"),
        Text(
          extent={{-98,166},{-46,150}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMin_flow"),
        Text(
          extent={{-98,-152},{-48,-168}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMax_flow"),
        Text(
          extent={{-98,-132},{-50,-148}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMin_flow"),
        Text(
          extent={{-98,44},{-54,34}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin_flow"),
        Text(
          extent={{-98,134},{-78,126}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-100,-76},{-80,-84}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHea"),
        Text(
          extent={{-98,-46},{-60,-54}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{-100,74},{-80,66}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-13.5,4},{13.5,-4}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis",
          origin={-87.5,10}),
        Text(
          extent={{-100,-106},{-80,-114}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          visible=not have_preIndDam,
          extent={{-11.5,4.5},{11.5,-4.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={39.5,-85.5},
          rotation=90,
          textString="VDis_flow"),
        Text(
          extent={{68,96},{98,86}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yDam"),
        Text(
          extent={{66,-82},{98,-96}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yVal"),
        Line(points={{-38,64},{-38,-48},{74,-48}}, color={95,95,95}),
        Line(
          points={{-38,14},{-14,-18},{10,-18},{10,-22},{26,-22},{26,-16},{74,48}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{10,-22},{10,-48}},
          color={215,215,215},
          pattern=LinePattern.Dash),
        Line(
          points={{-14,-18},{-14,36}},
          color={215,215,215},
          pattern=LinePattern.Dash),
        Line(
          points={{-14,36},{-38,36}},
          color={95,95,95},
          thickness=0.5),
        Line(
          points={{-14,36},{10,-48}},
          color={95,95,95},
          thickness=0.5),
    Polygon(
      points={{-52,-58},{-30,-52},{-30,-64},{-52,-58}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Line(points={{10,-58},{-48,-58}}, color={95,95,95}),
    Line(points={{28,-58},{90,-58}},  color={95,95,95}),
    Polygon(
      points={{92,-58},{70,-52},{70,-64},{92,-58}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
        Text(
          extent={{56,148},{98,136}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="VDisSet_flow"),
        Text(
          extent={{60,-134},{98,-146}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="TDisHeaSet"),
        Text(
          extent={{-96,-184},{-70,-192}},
          lineColor={255,127,27},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{-98,196},{-68,186}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-100,-16},{-68,-24}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSupSet")}),
  Documentation(info="<html>
<p>
This sequence sets the damper and valve position for VAV reheat terminal unit.
The implementation is according to Section 5.6.5 of ASHRAE Guideline 36, May 2020. The
calculation is done following the steps below.
</p>
<ol>
<li>
When the zone state is cooling (<code>uCoo &gt; 0</code>), then the cooling loop output
<code>uCoo</code> shall be mapped to the airflow
setpoint from the cooling minimum <code>VActCooMin_flow</code> to the cooling maximum
<code>VActCooMax_flow</code> airflow setpoints. The heating coil is disabled (<code>yHeaVal=0</code>)
unless the discharge air temperature <code>TDis</code> is below the minimum
setpoint (10 &deg;C).
<ul>
<li>
If supply air temperature <code>TSup</code> from the AHU is greater than
room temperature <code>TZon</code>, cooling supply airflow setpoint shall be
no higher than the minimum.
</li>
</ul>
</li>
<li>
When the zone state is Deadband (<code>uCoo=0</code> and <code>uHea=0</code>), then
the active airflow setpoint shall be the minimum airflow setpoint <code>VActMin_flow</code>.
The heating coil is disabled unless the discharge air temperature is below the minimum
setpoint (10 &deg;C).
</li>
<li>
When the zone state is Heating (<code>uHea &gt; 0</code>), then the heating loop shall
maintain space temperature at the heating setpoint as follows:
<ul>
<li>
From 0% to 50%, the heating loop output <code>uHea</code> shall reset the
discharge temperature setpoint from current AHU SAT setpoint <code>TSupSet</code>
to a maximum of <code>dTDisZonSetMax</code> above space temperature setpoint. The airflow
setpoint shall be the heating minimum <code>VActHeaMin_flow</code>.
</li>
<li>
From 50% to 100%, if the discharge air temperature <code>TDis</code> is
greater than room temperature plus 3 Kelvin, the heating loop output <code>uHea</code>
shall reset the airflow setpoint from the heating minimum airflow setpoint
<code>VActHeaMin_flow</code> to the heating maximum airflow setpoint
<code>VActHeaMax_flow</code>.</li>
<li>
The heating coil shall be modulated to maintain the discharge temperature at setpoint.
</li>
</ul>
</li>
<li>
The VAV damper shall be modulated by a control loop to maintain the measured
airflow at the active setpoint.
</li>
<li>
In occupied mode, the heating coil shall be modulated a discharge temperature
no lower than 10 &deg;C (50 &deg;F).
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
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DamperValves;
