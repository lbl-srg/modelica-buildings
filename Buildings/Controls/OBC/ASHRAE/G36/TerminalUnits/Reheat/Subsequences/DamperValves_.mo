within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences;
block DamperValves_
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
    annotation (Placement(transformation(extent={{-360,210},{-320,250}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active cooling minimum airflow rate"
    annotation (Placement(transformation(extent={{-360,290},{-320,330}}),
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
    annotation (Placement(transformation(extent={{-360,-290},{-320,-250}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActHeaMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active heating maximum airflow rate"
    annotation (Placement(transformation(extent={{-360,-320},{-320,-280}}),
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
    annotation (Placement(transformation(extent={{-360,180},{-320,220}}),
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
    annotation (Placement(transformation(extent={{-360,-240},{-320,-200}}),
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
    annotation (Placement(transformation(extent={{-360,-420},{-320,-380}}),
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

  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{-60,220},{-40,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Active airflow setpoint for cooling"
    annotation (Placement(transformation(extent={{-160,270},{-140,290}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conDam(
    final controllerType=controllerTypeDam,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam,
    final yMax=1,
    final yMin=0,
    final y_reset=0) if not have_pressureIndependentDamper
    "Damper position controller"
    annotation (Placement(transformation(extent={{280,220},{300,240}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Output active cooling airflow according to cooling control signal"
    annotation (Placement(transformation(extent={{160,260},{180,280}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi5
    "Airflow setpoint when it is in cooling state"
    annotation (Placement(transformation(extent={{60,290},{80,310}})));

  CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint from central air handler" annotation (
      Placement(transformation(extent={{-360,-40},{-320,0}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  CDL.Logical.Not                        not1 "Not in cooling state"
    annotation (Placement(transformation(extent={{-180,80},{-160,100}})));
  CDL.Logical.Not                        not2 "Not in heating state"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));
  CDL.Logical.And                        and2
    "Check if current zone state is deadband"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  CDL.Logical.Switch                        swi1
    "Airflow setpoint when it is in deadband state"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  CDL.Continuous.Line                        lin3
    "Airflow setpoint when it is in heating state"
    annotation (Placement(transformation(extent={{-100,-280},{-80,-260}})));
  CDL.Logical.Switch                        swi2 "Acitive heating airflow rate"
    annotation (Placement(transformation(extent={{40,-250},{60,-230}})));
  CDL.Continuous.Greater gre(final h=dTHys)
    "Check if the discharge air temperature is greater than zone temperature by a threshold"
    annotation (Placement(transformation(extent={{-180,-210},{-160,-190}})));
  CDL.Continuous.Line                        conTDisHeaSet
    "Discharge air temperature for heating"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  CDL.Logical.Or or2
    "Enable heating coil when it is in heating state, or the discharge air temperature is lower than minimum"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  CDL.Logical.Switch                        swi3
    "Discharge airflow setpoint when heating coil is enabled"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
  CDL.Continuous.PIDWithReset                        conVal(
    final controllerType=controllerTypeVal,
    final k=kVal,
    final Ti=TiVal,
    final Td=TdVal,
    final yMax=1,
    final yMin=0,
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"))
    "Hot water valve controller"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  CDL.Logical.And                        and1
    "Occupied mode and discharge temperature is low"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-280,300},{-260,320}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-220,300},{-200,320}})));
  CDL.Continuous.GreaterThreshold                  greThr1(t=looHys, h=0.5*
        looHys) "Check if it is cooling state"
    annotation (Placement(transformation(extent={{-280,240},{-260,260}})));
  CDL.Continuous.GreaterThreshold                  greThr(final t=dTHys, final
      h=0.5*dTHys)
    "Check if supply air temperature is greater than room temperature"
    annotation (Placement(transformation(extent={{-120,190},{-100,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k2=-1)
    "Calculate temperature difference between AHU supply air and room "
    annotation (Placement(transformation(extent={{-160,190},{-140,210}})));
  Buildings.Controls.OBC.CDL.Logical.Switch watValPosUno "Output hot water valve position"
    annotation (Placement(transformation(extent={{280,-30},{300,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch damPosUno "Output damper position"
    annotation (Placement(transformation(extent={{280,60},{300,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Division VDis_flowNor if
       not have_pressureIndependentDamper
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{240,150},{260,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomFlow(
    final k=V_flow_nominal)
    "Nominal volume flow rate"
    annotation (Placement(transformation(extent={{200,200},{220,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Division VDisSet_flowNor
    "Normalized setpoint for discharge volume flow rate"
    annotation (Placement(transformation(extent={{240,220},{260,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(
    final k=1) if have_pressureIndependentDamper
    "Block that can be disabled so remove the connection"
    annotation (Placement(transformation(extent={{220,120},{240,140}})));

  CDL.Continuous.LessThreshold                     lowMin(final t=TDisMin,
      final h=dTHys)
    "Check if discharge air temperature is less than lowest discharge air temperature"
    annotation (Placement(transformation(extent={{-260,120},{-240,140}})));
  CDL.Continuous.Sources.Constant                        conZer2(final k=0)
               "Constant zero"
    annotation (Placement(transformation(extent={{-120,38},{-100,58}})));
  CDL.Continuous.GreaterThreshold                  greThr2(t=looHys, h=0.5*
        looHys) "Check if it is heating state"
    annotation (Placement(transformation(extent={{-240,-170},{-220,-150}})));
  CDL.Continuous.Sources.Constant                        conHal1(final k=0.5)
                 "Constant real value"
    annotation (Placement(transformation(extent={{-280,-330},{-260,-310}})));
  CDL.Continuous.Sources.Constant                        conOne2(final k=1)
               "Constant real value"
    annotation (Placement(transformation(extent={{-200,-330},{-180,-310}})));
  CDL.Continuous.AddParameter                        addPar1(final k=1, final p
      =3) "Zone temperature plus threshold difference"
    annotation (Placement(transformation(extent={{-240,-230},{-220,-210}})));
  CDL.Continuous.Sources.Constant                        conHal(final k=0.5)
                 "Constant real value"
    annotation (Placement(transformation(extent={{-180,-120},{-160,-100}})));
  CDL.Continuous.Sources.Constant                        conZer3(final k=0)
               "Constant zero"
    annotation (Placement(transformation(extent={{-260,-120},{-240,-100}})));
  CDL.Continuous.AddParameter                        addPar(final p=
        dTDisZonSetMax, final k=1)
    "Maximum heating discharge temperature"
    annotation (Placement(transformation(extent={{-260,-70},{-240,-50}})));
  CDL.Continuous.Sources.Constant                        lowDisAirTem(final k=
        TDisMin)
    "Lowest allowed discharge air temperature"
    annotation (Placement(transformation(extent={{-120,-170},{-100,-150}})));
  CDL.Logical.Switch                        swi4
    "Output hot water valve position in case of low discharge air temperature"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  CDL.Integers.Sources.Constant occMod(final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Constant signal for occupied mode"
    annotation (Placement(transformation(extent={{-280,-370},{-260,-350}})));
  CDL.Integers.Equal                        isOcc
    "Output true if the operation mode is occupied"
    annotation (Placement(transformation(extent={{-220,-370},{-200,-350}})));
equation
  connect(uCoo, lin.u)
    annotation (Line(points={{-340,280},{-162,280}}, color={0,0,127}));
  connect(conZer.y, lin.x1)
    annotation (Line(points={{-258,310},{-240,310},{-240,288},{-162,288}},
      color={0,0,127}));
  connect(VActCooMin_flow, lin.f1)
    annotation (Line(points={{-340,310},{-300,310},{-300,284},{-162,284}},
      color={0,0,127}));
  connect(conOne.y, lin.x2)
    annotation (Line(points={{-198,310},{-180,310},{-180,276},{-162,276}},
      color={0,0,127}));
  connect(VActCooMax_flow, lin.f2)
    annotation (Line(points={{-340,230},{-180,230},{-180,272},{-162,272}},
      color={0,0,127}));
  connect(uCoo, greThr1.u) annotation (Line(points={{-340,280},{-300,280},{-300,
          250},{-282,250}}, color={0,0,127}));
  connect(and4.y, swi5.u2)
    annotation (Line(points={{-38,230},{20,230},{20,300},{58,300}},
                                                 color={255,0,255}));
  connect(lin.y, swi5.u3)
    annotation (Line(points={{-138,280},{40,280},{40,292},{58,292}},
      color={0,0,127}));
  connect(swi5.y, swi.u1)
    annotation (Line(points={{82,300},{140,300},{140,278},{158,278}},
      color={0,0,127}));
  connect(TSup, add2.u1)
    annotation (Line(points={{-340,200},{-180,200},{-180,206},{-162,206}},
                              color={0,0,127}));
  connect(TZon, add2.u2)
    annotation (Line(points={{-340,-220},{-300,-220},{-300,180},{-180,180},{
          -180,194},{-162,194}},
                              color={0,0,127}));
  connect(add2.y, greThr.u)
    annotation (Line(points={{-138,200},{-122,200}}, color={0,0,127}));
  connect(greThr.y, and4.u2) annotation (Line(points={{-98,200},{-80,200},{-80,
          222},{-62,222}}, color={255,0,255}));
  connect(watValPosUno.y, yHeaVal)
    annotation (Line(points={{302,-20},{340,-20}}, color={0,0,127}));
  connect(conDam.y, damPosUno.u3) annotation (Line(points={{302,230},{310,230},{
          310,100},{272,100},{272,62},{278,62}}, color={0,0,127}));
  connect(damPosUno.y, yDam) annotation (Line(points={{302,70},{308,70},{308,40},
          {340,40}}, color={0,0,127}));
  connect(VDis_flow, VDis_flowNor.u1) annotation (Line(points={{-340,340},{190,340},
          {190,166},{238,166}}, color={0,0,127}));
  connect(nomFlow.y, VDis_flowNor.u2) annotation (Line(points={{222,210},{230,210},
          {230,154},{238,154}}, color={0,0,127}));
  connect(VDis_flowNor.y, conDam.u_m)
    annotation (Line(points={{262,160},{290,160},{290,218}}, color={0,0,127}));
  connect(nomFlow.y, VDisSet_flowNor.u2) annotation (Line(points={{222,210},{230,
          210},{230,224},{238,224}},                     color={0,0,127}));
  connect(VDisSet_flowNor.y, conDam.u_s)
    annotation (Line(points={{262,230},{278,230}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, gai.u) annotation (Line(points={{262,230},{270,230},
          {270,180},{210,180},{210,130},{218,130}}, color={0,0,127}));
  connect(gai.y, damPosUno.u3) annotation (Line(points={{242,130},{272,130},{272,
          62},{278,62}}, color={0,0,127}));

  connect(greThr1.y, and4.u1) annotation (Line(points={{-258,250},{-80,250},{
          -80,230},{-62,230}}, color={255,0,255}));
  connect(greThr1.y, swi.u2) annotation (Line(points={{-258,250},{-80,250},{-80,
          270},{158,270}}, color={255,0,255}));
  connect(VActMin_flow, swi5.u1) annotation (Line(points={{-340,70},{0,70},{0,
          308},{58,308}}, color={0,0,127}));
  connect(TDis, lowMin.u)
    annotation (Line(points={{-340,130},{-262,130}}, color={0,0,127}));
  connect(greThr1.y, not1.u) annotation (Line(points={{-258,250},{-200,250},{
          -200,90},{-182,90}}, color={255,0,255}));
  connect(uHea, greThr2.u) annotation (Line(points={{-340,-140},{-290,-140},{
          -290,-160},{-242,-160}}, color={0,0,127}));
  connect(greThr2.y, not2.u) annotation (Line(points={{-218,-160},{-200,-160},{
          -200,50},{-182,50}}, color={255,0,255}));
  connect(not1.y, and2.u1)
    annotation (Line(points={{-158,90},{-122,90}}, color={255,0,255}));
  connect(not2.y, and2.u2) annotation (Line(points={{-158,50},{-140,50},{-140,
          82},{-122,82}}, color={255,0,255}));
  connect(and2.y, swi1.u2)
    annotation (Line(points={{-98,90},{98,90}}, color={255,0,255}));
  connect(VActMin_flow, swi1.u1) annotation (Line(points={{-340,70},{0,70},{0,
          98},{98,98}}, color={0,0,127}));
  connect(conHal1.y, lin3.x1) annotation (Line(points={{-258,-320},{-240,-320},
          {-240,-262},{-102,-262}}, color={0,0,127}));
  connect(VActHeaMin_flow, lin3.f1) annotation (Line(points={{-340,-270},{-300,
          -270},{-300,-266},{-102,-266}}, color={0,0,127}));
  connect(conOne2.y, lin3.x2) annotation (Line(points={{-178,-320},{-160,-320},
          {-160,-274},{-102,-274}}, color={0,0,127}));
  connect(VActHeaMax_flow, lin3.f2) annotation (Line(points={{-340,-300},{-300,
          -300},{-300,-278},{-102,-278}}, color={0,0,127}));
  connect(uHea, lin3.u) annotation (Line(points={{-340,-140},{-290,-140},{-290,
          -270},{-102,-270}}, color={0,0,127}));
  connect(TZon, addPar1.u)
    annotation (Line(points={{-340,-220},{-242,-220}}, color={0,0,127}));
  connect(TDis, gre.u1) annotation (Line(points={{-340,130},{-280,130},{-280,
          -200},{-182,-200}}, color={0,0,127}));
  connect(addPar1.y, gre.u2) annotation (Line(points={{-218,-220},{-200,-220},{
          -200,-208},{-182,-208}}, color={0,0,127}));
  connect(gre.y, swi2.u2) annotation (Line(points={{-158,-200},{-60,-200},{-60,
          -240},{38,-240}}, color={255,0,255}));
  connect(VActHeaMin_flow, swi2.u3) annotation (Line(points={{-340,-270},{-300,
          -270},{-300,-248},{38,-248}}, color={0,0,127}));
  connect(lin3.y, swi2.u1) annotation (Line(points={{-78,-270},{20,-270},{20,
          -232},{38,-232}}, color={0,0,127}));
  connect(swi2.y, swi1.u3) annotation (Line(points={{62,-240},{80,-240},{80,82},
          {98,82}}, color={0,0,127}));
  connect(swi1.y, swi.u3) annotation (Line(points={{122,90},{140,90},{140,262},
          {158,262}}, color={0,0,127}));
  connect(swi.y, VDisSet_flowNor.u1) annotation (Line(points={{182,270},{200,
          270},{200,236},{238,236}}, color={0,0,127}));
  connect(swi.y, VDisSet_flow) annotation (Line(points={{182,270},{200,270},{
          200,260},{340,260}}, color={0,0,127}));
  connect(THeaSet, addPar.u)
    annotation (Line(points={{-340,-60},{-262,-60}}, color={0,0,127}));
  connect(conZer3.y, conTDisHeaSet.x1) annotation (Line(points={{-238,-110},{
          -220,-110},{-220,-72},{-122,-72}}, color={0,0,127}));
  connect(conHal.y, conTDisHeaSet.x2) annotation (Line(points={{-158,-110},{
          -140,-110},{-140,-84},{-122,-84}}, color={0,0,127}));
  connect(TSupSet, conTDisHeaSet.f1) annotation (Line(points={{-340,-20},{-180,
          -20},{-180,-76},{-122,-76}}, color={0,0,127}));
  connect(addPar.y, conTDisHeaSet.f2) annotation (Line(points={{-238,-60},{-190,
          -60},{-190,-88},{-122,-88}}, color={0,0,127}));
  connect(uHea, conTDisHeaSet.u) annotation (Line(points={{-340,-140},{-290,
          -140},{-290,-80},{-122,-80}}, color={0,0,127}));
  connect(greThr2.y, or2.u2) annotation (Line(points={{-218,-160},{-200,-160},{
          -200,-48},{-62,-48}}, color={255,0,255}));
  connect(greThr2.y, swi3.u2) annotation (Line(points={{-218,-160},{-200,-160},
          {-200,-140},{-62,-140}}, color={255,0,255}));
  connect(conTDisHeaSet.y, swi3.u1) annotation (Line(points={{-98,-80},{-80,-80},
          {-80,-132},{-62,-132}}, color={0,0,127}));
  connect(lowDisAirTem.y, swi3.u3) annotation (Line(points={{-98,-160},{-80,
          -160},{-80,-148},{-62,-148}}, color={0,0,127}));
  connect(swi3.y, conVal.u_s)
    annotation (Line(points={{-38,-140},{-2,-140}}, color={0,0,127}));
  connect(TDis, conVal.u_m) annotation (Line(points={{-340,130},{-280,130},{
          -280,-180},{10,-180},{10,-152}}, color={0,0,127}));
  connect(or2.y, conVal.trigger) annotation (Line(points={{-38,-40},{-20,-40},{
          -20,-160},{4,-160},{4,-152}}, color={255,0,255}));
  connect(or2.y, swi4.u2) annotation (Line(points={{-38,-40},{-20,-40},{-20,-80},
          {98,-80}}, color={255,0,255}));
  connect(conVal.y, swi4.u1) annotation (Line(points={{22,-140},{40,-140},{40,
          -72},{98,-72}}, color={0,0,127}));
  connect(conZer2.y, swi4.u3) annotation (Line(points={{-98,48},{20,48},{20,-88},
          {98,-88}}, color={0,0,127}));
  connect(conZer2.y, watValPosUno.u1) annotation (Line(points={{-98,48},{20,48},
          {20,-12},{278,-12}}, color={0,0,127}));
  connect(swi4.y, watValPosUno.u3) annotation (Line(points={{122,-80},{140,-80},
          {140,-28},{278,-28}}, color={0,0,127}));
  connect(uOpeMod, isOcc.u2) annotation (Line(points={{-340,-400},{-240,-400},{
          -240,-368},{-222,-368}}, color={255,127,0}));
  connect(occMod.y, isOcc.u1)
    annotation (Line(points={{-258,-360},{-222,-360}}, color={255,127,0}));
  connect(lowMin.y, and1.u1) annotation (Line(points={{-238,130},{-220,130},{
          -220,0},{-122,0}}, color={255,0,255}));
  connect(isOcc.y, and1.u2) annotation (Line(points={{-198,-360},{-150,-360},{
          -150,-8},{-122,-8}}, color={255,0,255}));
  connect(and1.y, or2.u1) annotation (Line(points={{-98,0},{-80,0},{-80,-40},{
          -62,-40}}, color={255,0,255}));
annotation (
  defaultComponentName="damVal",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-420},{320,
            420}})),
  Icon(coordinateSystem(extent={{-320,-420},{320,420}}),
       graphics={
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
          extent={{-98,68},{-62,54}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMax_flow"),
        Text(
          extent={{-98,88},{-62,74}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMin_flow"),
        Text(
          extent={{-98,-76},{-60,-90}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMax_flow"),
        Text(
          extent={{-98,-54},{-62,-66}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMin_flow"),
        Text(
          extent={{-98,44},{-70,38}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin_flow"),
        Text(
          extent={{-100,102},{-80,96}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-100,-18},{-80,-24}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHea"),
        Text(
          extent={{-100,2},{-76,-4}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{-100,24},{-80,16}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-11.5,3.5},{11.5,-3.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis",
          origin={-41.5,-89.5},
          rotation=90),
        Text(
          extent={{-100,-36},{-80,-42}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          visible=not have_pressureIndependentDamper,
          extent={{-11.5,4.5},{11.5,-4.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={39.5,-85.5},
          rotation=90,
          textString="VDis_flow"),
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
          textString="VDisSet_flow"),
        Text(
          extent={{60,-74},{98,-86}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="TDisHeaSet"),
        Text(
          extent={{-98,-96},{-78,-102}},
          lineColor={0,0,127},
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
When the zone state is cooling (<code>uCoo>0</code>), then the cooling loop output
<code>uCoo</code> shall be mapped to the airflow
setpoint from the cooling minimum <code>VActCooMin_flow</code> to the cooling maximum
<code>VActCooMax_flow</code> airflow setpoints. The hot water valve is closed (<code>yHeaVal=0</code>)
unless the discharge air temperature <code>TDis</code> is below the minimum
setpoint (10 &deg;C).
</li>
<li>
If supply air temperature <code>TSup</code> from the AHU is greater than
room temperature <code>TZon</code>, cooling supply airflow setpoint shall be
no higher than the minimum.
</li>
<li>
When the zone state is Deadband (<code>uCoo=0</code> and <code>uHea=0</code>), then
the active airflow setpoint shall be the minimum airflow setpoint <code>VActMin_flow</code>.
Hot water valve is closed unless the discharge air temperature is below the minimum
setpoint (10 &deg;C).
</li>
<li>
When the zone state is Heating (<code>uHea>0</code>), then
the heating loop shall maintain space temperature at the heating setpoint
as follows:
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
<li>
The hot water valve (or modulating electric heating coil) shall be modulated
to maintain the discharge temperature at setpoint.
</li>
</ul>
</li>
<li>
The VAV damper shall be modulated by a control loop to maintain the measured
airflow at the active setpoint.
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
end DamperValves_;
