within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences;
block DamperValves
  "Output signals for controlling VAV reheat box damper and valve position"

  parameter Real dTDisZonSetMax(unit="K")=11
    "Zone maximum discharge air temperature above heating setpoint"
    annotation (__cdl(ValueInReference=true));
  parameter Real TDisMin(
    unit="K",
    displayUnit="degC")=283.15
    "Lowest discharge air temperature"
    annotation (__cdl(ValueInReference=true));
  parameter Real VMin_flow(unit="m3/s")
    "Design zone minimum airflow setpoint";
  parameter Real VCooMax_flow(unit="m3/s")
    "Design zone cooling maximum airflow rate";
  parameter Real VHeaMax_flow(unit="m3/s")
    "Design zone heating maximum airflow rate";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeVal=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (__cdl(ValueInReference=false), Dialog(group="Valve"));
  parameter Real kVal(unit="1/K")=0.5
    "Gain of controller for valve control"
    annotation (__cdl(ValueInReference=false), Dialog(group="Valve"));
  parameter Real TiVal(unit="s")=300
    "Time constant of integrator block for valve control"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Valve",
    enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdVal(unit="s")=0.1
    "Time constant of derivative block for valve control"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Valve",
      enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeDam=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (__cdl(ValueInReference=false), Dialog(group="Damper"));
  parameter Real kDam(unit="1")=0.5
    "Gain of controller for damper control"
    annotation (__cdl(ValueInReference=false), Dialog(group="Damper"));
  parameter Real TiDam(unit="s")=300
    "Time constant of integrator block for damper control"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Damper",
    enable=(controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
         or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdDam(unit="s")=0.1
    "Time constant of derivative block for damper control"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Damper",
      enable=(controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
           or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real dTHys(unit="K")=0.25
    "Temperature difference hysteresis below which the temperature difference will be seen as zero"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real looHys(unit="1")=0.01
    "Loop output hysteresis below which the output will be seen as zero"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real iniDam(unit="1")=0.01
    "Initial damper position when the damper control is enabled"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveFloSet
    "Index of overriding flow setpoint, 1: set to zero; 2: set to cooling maximum; 3: set to minimum flow; 4: set to heating maximum"
    annotation (Placement(transformation(extent={{-360,440},{-320,480}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured primary discharge airflow rate"
    annotation (Placement(transformation(extent={{-360,240},{-320,280}}),
      iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active cooling minimum airflow rate"
    annotation (Placement(transformation(extent={{-360,210},{-320,250}}),
        iconTransformation(extent={{-140,120},{-100,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-360,180},{-320,220}}),
        iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active cooling maximum airflow rate"
    annotation (Placement(transformation(extent={{-360,130},{-320,170}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature of the air supplied from central air handler"
    annotation (Placement(transformation(extent={{-360,100},{-320,140}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active minimum airflow rate"
    annotation (Placement(transformation(extent={{-360,60},{-320,100}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Fan
    "AHU supply fan status"
    annotation (Placement(transformation(extent={{-360,10},{-320,50}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-360,-50},{-320,-10}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint from central air handler"
    annotation (Placement(transformation(extent={{-360,-120},{-320,-80}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-360,-210},{-320,-170}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-360,-260},{-320,-220}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-360,-320},{-320,-280}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActHeaMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active heating minimum airflow rate"
    annotation (Placement(transformation(extent={{-360,-370},{-320,-330}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActHeaMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active heating maximum airflow rate"
    annotation (Placement(transformation(extent={{-360,-400},{-320,-360}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-360,-500},{-320,-460}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Commanded discharge airflow setpoint"
    annotation (Placement(transformation(extent={{320,260},{360,300}}),
        iconTransformation(extent={{100,120},{140,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(
    final min=0,
    final max=1,
    final unit="1") "VAV damper commanded position"
    annotation (Placement(transformation(extent={{320,-40},{360,0}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(
    final min=0,
    final max=1,
    final unit="1") "Reheater valve commanded position"
    annotation (Placement(transformation(extent={{320,-120},{360,-80}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TDisSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Discharge airflow setpoint temperature"
    annotation (Placement(transformation(extent={{320,-180},{360,-140}}),
        iconTransformation(extent={{100,-160},{140,-120}})));

  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Active airflow setpoint for cooling"
    annotation (Placement(transformation(extent={{-160,190},{-140,210}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conDam(
    final controllerType=controllerTypeDam,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam,
    final yMax=1,
    final yMin=0,
    final y_reset=iniDam)
    "Damper position controller"
    annotation (Placement(transformation(extent={{280,140},{300,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Output active cooling airflow according to cooling control signal"
    annotation (Placement(transformation(extent={{120,180},{140,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi5
    "Airflow setpoint when it is in cooling state"
    annotation (Placement(transformation(extent={{20,210},{40,230}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Not in cooling state"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Not in heating state"
    annotation (Placement(transformation(extent={{-180,0},{-160,20}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if current zone state is deadband"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Airflow setpoint when it is in deadband state"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin3
    "Airflow setpoint when it is in heating state"
    annotation (Placement(transformation(extent={{-100,-360},{-80,-340}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "Acitive heating airflow rate"
    annotation (Placement(transformation(extent={{20,-330},{40,-310}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre(
    final h=dTHys)
    "Check if the discharge air temperature is greater than zone temperature by a threshold"
    annotation (Placement(transformation(extent={{-180,-290},{-160,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.Line conTDisHeaSet
    "Discharge air temperature for heating"
    annotation (Placement(transformation(extent={{-100,-170},{-80,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Enable heating coil when it is in heating state, or the discharge air temperature is lower than minimum"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi3
    "Discharge airflow setpoint when heating coil is enabled"
    annotation (Placement(transformation(extent={{-40,-220},{-20,-200}})));
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
    annotation (Placement(transformation(extent={{18,-220},{38,-200}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Occupied mode and discharge temperature is low"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-280,220},{-260,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-220,220},{-200,240}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is cooling state"
    annotation (Placement(transformation(extent={{-280,160},{-260,180}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=dTHys,
    final h=0.5*dTHys)
    "Check if supply air temperature is greater than room temperature"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Calculate temperature difference between AHU supply air and room "
    annotation (Placement(transformation(extent={{-160,110},{-140,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch watValPosUno "Output hot water valve position"
    annotation (Placement(transformation(extent={{280,-110},{300,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch damPosUno "Output damper position"
    annotation (Placement(transformation(extent={{280,-30},{300,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide VDis_flowNor
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{240,70},{260,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide VDisSet_flowNor
    "Normalized setpoint for discharge volume flow rate"
    annotation (Placement(transformation(extent={{240,140},{260,160}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lowMin(
    final t=TDisMin,
    final h=dTHys)
    "Check if discharge air temperature is less than lowest discharge air temperature"
    annotation (Placement(transformation(extent={{-260,-40},{-240,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer2(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr2(
    final t=looHys,
    final h=0.8*looHys)
    "Check if it is heating state"
    annotation (Placement(transformation(extent={{-260,-250},{-240,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHal1(
    final k=0.5)
    "Constant real value"
    annotation (Placement(transformation(extent={{-280,-410},{-260,-390}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne2(
    final k=1)
    "Constant real value"
    annotation (Placement(transformation(extent={{-200,-410},{-180,-390}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=3)
    "Zone temperature plus threshold difference"
    annotation (Placement(transformation(extent={{-240,-310},{-220,-290}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHal(
    final k=0.5)
    "Constant real value"
    annotation (Placement(transformation(extent={{-180,-200},{-160,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer3(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-260,-140},{-240,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=dTDisZonSetMax)
    "Maximum heating discharge temperature"
    annotation (Placement(transformation(extent={{-260,-200},{-240,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant lowDisAirTem(
    final k=TDisMin)
    "Lowest allowed discharge air temperature"
    annotation (Placement(transformation(extent={{-180,-250},{-160,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi4
    "Output hot water valve position in case of low discharge air temperature"
    annotation (Placement(transformation(extent={{100,-150},{120,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Constant signal for occupied mode"
    annotation (Placement(transformation(extent={{-280,-450},{-260,-430}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isOcc
    "Output true if the operation mode is occupied"
    annotation (Placement(transformation(extent={{-220,-450},{-200,-430}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant  unOcc(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    "Constant signal for unoccupied mode"
    annotation (Placement(transformation(extent={{40,-450},{60,-430}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isUno
    "Output true if the operation mode is unoccupied"
    annotation (Placement(transformation(extent={{100,-450},{120,-430}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1
    "Ensure the discharge temperature being higher than the minimum"
    annotation (Placement(transformation(extent={{-100,-250},{-80,-230}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-200,430},{-180,450}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forZerFlo
    "Check if forcing zone airflow setpoint to zero"
    annotation (Placement(transformation(extent={{-140,450},{-120,470}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forCooMax
    "Check if forcing zone airflow setpoint to cooling maximum"
    annotation (Placement(transformation(extent={{-140,410},{-120,430}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{-200,390},{-180,410}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forMinFlo
    "Check if forcing zone airflow setpoint to minimum flow"
    annotation (Placement(transformation(extent={{-140,370},{-120,390}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{-200,350},{-180,370}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal zerFlo(
    final realTrue=0)
    "Force zone airflow setpoint to zero"
    annotation (Placement(transformation(extent={{-60,450},{-40,470}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cooMax(
    final realTrue=VCooMax_flow)
    "Force zone airflow setpoint to cooling maximum"
    annotation (Placement(transformation(extent={{-60,410},{-40,430}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal minFlo(
    final realTrue=VMin_flow)
    "Force zone airflow setpoint to zone minimum flow"
    annotation (Placement(transformation(extent={{-60,370},{-40,390}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Add up two inputs"
    annotation (Placement(transformation(extent={{60,390},{80,410}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1
    "Add up inputs"
    annotation (Placement(transformation(extent={{120,430},{140,450}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi6
    "Airflow setpoint after considering override"
    annotation (Placement(transformation(extent={{180,270},{200,290}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    "Check if the airflow setpoint should be overrided"
    annotation (Placement(transformation(extent={{-60,290},{-40,310}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=4)
    "Constant 4"
    annotation (Placement(transformation(extent={{-200,310},{-180,330}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forMinFlo1
    "Check if forcing zone airflow setpoint to minimum flow"
    annotation (Placement(transformation(extent={{-140,330},{-120,350}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal heaMax(
    final realTrue=VHeaMax_flow)
    "Force zone airflow setpoint to zone heating maximum flow"
    annotation (Placement(transformation(extent={{-60,330},{-40,350}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add4
    "Add up two inputs"
    annotation (Placement(transformation(extent={{0,350},{20,370}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Check if the airflow setpoint should be overrided"
    annotation (Placement(transformation(extent={{0,270},{20,290}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooMax1(
    final k=VCooMax_flow)
    "Cooling maximum flow"
    annotation (Placement(transformation(extent={{120,140},{140,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaMax1(
    final k=VHeaMax_flow)
    "Heating maximum flow"
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max2 "Nominal flow"
    annotation (Placement(transformation(extent={{200,120},{220,140}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=600,
    final falseHoldDuration=0)
    "Hold true input for certain time"
    annotation (Placement(transformation(extent={{-220,-250},{-200,-230}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol1(
    final trueHoldDuration=600,
    final falseHoldDuration=0)
    "Hold true input for certain time"
    annotation (Placement(transformation(extent={{-240,160},{-220,180}})));
equation
  connect(uCoo, lin.u)
    annotation (Line(points={{-340,200},{-162,200}}, color={0,0,127}));
  connect(conZer.y, lin.x1)
    annotation (Line(points={{-258,230},{-240,230},{-240,208},{-162,208}},
      color={0,0,127}));
  connect(VActCooMin_flow, lin.f1)
    annotation (Line(points={{-340,230},{-300,230},{-300,204},{-162,204}},
      color={0,0,127}));
  connect(conOne.y, lin.x2)
    annotation (Line(points={{-198,230},{-180,230},{-180,196},{-162,196}},
      color={0,0,127}));
  connect(VActCooMax_flow, lin.f2)
    annotation (Line(points={{-340,150},{-180,150},{-180,192},{-162,192}},
      color={0,0,127}));
  connect(uCoo, greThr1.u) annotation (Line(points={{-340,200},{-300,200},{-300,
          170},{-282,170}}, color={0,0,127}));
  connect(and4.y, swi5.u2)
    annotation (Line(points={{-38,150},{0,150},{0,220},{18,220}},
        color={255,0,255}));
  connect(lin.y, swi5.u3)
    annotation (Line(points={{-138,200},{-40,200},{-40,212},{18,212}},
      color={0,0,127}));
  connect(swi5.y, swi.u1)
    annotation (Line(points={{42,220},{110,220},{110,198},{118,198}},
      color={0,0,127}));
  connect(TSup, sub2.u1)
    annotation (Line(points={{-340,120},{-180,120},{-180,126},{-162,126}},
        color={0,0,127}));
  connect(TZon, sub2.u2)
    annotation (Line(points={{-340,-300},{-300,-300},{-300,100},{-180,100},{-180,
          114},{-162,114}},   color={0,0,127}));
  connect(sub2.y, greThr.u)
    annotation (Line(points={{-138,120},{-122,120}}, color={0,0,127}));
  connect(greThr.y, and4.u2) annotation (Line(points={{-98,120},{-80,120},{-80,142},
          {-62,142}},      color={255,0,255}));
  connect(watValPosUno.y,yVal)
    annotation (Line(points={{302,-100},{340,-100}}, color={0,0,127}));
  connect(conDam.y, damPosUno.u3) annotation (Line(points={{302,150},{310,150},{
          310,20},{272,20},{272,-28},{278,-28}}, color={0,0,127}));
  connect(damPosUno.y, yDam)
    annotation (Line(points={{302,-20},{340,-20}}, color={0,0,127}));
  connect(VDis_flow, VDis_flowNor.u1) annotation (Line(points={{-340,260},{190,260},
          {190,86},{238,86}},   color={0,0,127}));
  connect(VDis_flowNor.y, conDam.u_m)
    annotation (Line(points={{262,80},{290,80},{290,138}},   color={0,0,127}));
  connect(VDisSet_flowNor.y, conDam.u_s)
    annotation (Line(points={{262,150},{278,150}}, color={0,0,127}));
  connect(VActMin_flow, swi5.u1) annotation (Line(points={{-340,80},{-20,80},{-20,
          228},{18,228}}, color={0,0,127}));
  connect(TDis, lowMin.u)
    annotation (Line(points={{-340,-30},{-262,-30}}, color={0,0,127}));
  connect(uHea, greThr2.u) annotation (Line(points={{-340,-240},{-262,-240}},
          color={0,0,127}));
  connect(not1.y, and2.u1)
    annotation (Line(points={{-158,50},{-122,50}},   color={255,0,255}));
  connect(not2.y, and2.u2) annotation (Line(points={{-158,10},{-140,10},{-140,42},
          {-122,42}}, color={255,0,255}));
  connect(and2.y, swi1.u2)
    annotation (Line(points={{-98,50},{78,50}},   color={255,0,255}));
  connect(VActMin_flow, swi1.u1) annotation (Line(points={{-340,80},{-20,80},{-20,
          58},{78,58}},   color={0,0,127}));
  connect(conHal1.y, lin3.x1) annotation (Line(points={{-258,-400},{-240,-400},{
          -240,-342},{-102,-342}},  color={0,0,127}));
  connect(VActHeaMin_flow, lin3.f1) annotation (Line(points={{-340,-350},{-300,-350},
          {-300,-346},{-102,-346}},       color={0,0,127}));
  connect(conOne2.y, lin3.x2) annotation (Line(points={{-178,-400},{-160,-400},{
          -160,-354},{-102,-354}},  color={0,0,127}));
  connect(VActHeaMax_flow, lin3.f2) annotation (Line(points={{-340,-380},{-300,-380},
          {-300,-358},{-102,-358}},       color={0,0,127}));
  connect(uHea, lin3.u) annotation (Line(points={{-340,-240},{-290,-240},{-290,-350},
          {-102,-350}}, color={0,0,127}));
  connect(TZon, addPar1.u)
    annotation (Line(points={{-340,-300},{-242,-300}}, color={0,0,127}));
  connect(TDis, gre.u1) annotation (Line(points={{-340,-30},{-280,-30},{-280,-280},
          {-182,-280}}, color={0,0,127}));
  connect(addPar1.y, gre.u2) annotation (Line(points={{-218,-300},{-200,-300},{-200,
          -288},{-182,-288}}, color={0,0,127}));
  connect(gre.y, swi2.u2) annotation (Line(points={{-158,-280},{-60,-280},{-60,-320},
          {18,-320}}, color={255,0,255}));
  connect(VActHeaMin_flow, swi2.u3) annotation (Line(points={{-340,-350},{-300,-350},
          {-300,-328},{18,-328}},       color={0,0,127}));
  connect(lin3.y, swi2.u1) annotation (Line(points={{-78,-350},{-20,-350},{-20,-312},
          {18,-312}},       color={0,0,127}));
  connect(swi2.y, swi1.u3) annotation (Line(points={{42,-320},{70,-320},{70,42},
          {78,42}}, color={0,0,127}));
  connect(swi1.y, swi.u3) annotation (Line(points={{102,50},{110,50},{110,182},{
          118,182}},  color={0,0,127}));
  connect(THeaSet, addPar.u)
    annotation (Line(points={{-340,-190},{-262,-190}}, color={0,0,127}));
  connect(conZer3.y, conTDisHeaSet.x1) annotation (Line(points={{-238,-130},{-220,
          -130},{-220,-152},{-102,-152}},    color={0,0,127}));
  connect(conHal.y, conTDisHeaSet.x2) annotation (Line(points={{-158,-190},{-120,
          -190},{-120,-164},{-102,-164}},    color={0,0,127}));
  connect(TSupSet, conTDisHeaSet.f1) annotation (Line(points={{-340,-100},{-140,
          -100},{-140,-156},{-102,-156}}, color={0,0,127}));
  connect(addPar.y, conTDisHeaSet.f2) annotation (Line(points={{-238,-190},{-220,
          -190},{-220,-168},{-102,-168}}, color={0,0,127}));
  connect(uHea, conTDisHeaSet.u) annotation (Line(points={{-340,-240},{-290,-240},
          {-290,-160},{-102,-160}},     color={0,0,127}));
  connect(conTDisHeaSet.y, swi3.u1) annotation (Line(points={{-78,-160},{-60,-160},
          {-60,-202},{-42,-202}}, color={0,0,127}));
  connect(swi3.y, conVal.u_s)
    annotation (Line(points={{-18,-210},{16,-210}}, color={0,0,127}));
  connect(TDis, conVal.u_m) annotation (Line(points={{-340,-30},{-280,-30},{
          -280,-260},{28,-260},{28,-222}}, color={0,0,127}));
  connect(or2.y, conVal.trigger) annotation (Line(points={{-38,-60},{-10,-60},{
          -10,-230},{22,-230},{22,-222}}, color={255,0,255}));
  connect(or2.y, swi4.u2) annotation (Line(points={{-38,-60},{-10,-60},{-10,-140},
          {98,-140}},color={255,0,255}));
  connect(conVal.y, swi4.u1) annotation (Line(points={{40,-210},{60,-210},{60,
          -132},{98,-132}}, color={0,0,127}));
  connect(conZer2.y, swi4.u3) annotation (Line(points={{-18,10},{20,10},{20,-148},
          {98,-148}},color={0,0,127}));
  connect(conZer2.y, watValPosUno.u1) annotation (Line(points={{-18,10},{20,10},
          {20,-92},{278,-92}}, color={0,0,127}));
  connect(swi4.y, watValPosUno.u3) annotation (Line(points={{122,-140},{140,-140},
          {140,-108},{278,-108}}, color={0,0,127}));
  connect(uOpeMod, isOcc.u2) annotation (Line(points={{-340,-480},{-240,-480},{-240,
          -448},{-222,-448}}, color={255,127,0}));
  connect(occMod.y, isOcc.u1)
    annotation (Line(points={{-258,-440},{-222,-440}}, color={255,127,0}));
  connect(lowMin.y, and1.u1) annotation (Line(points={{-238,-30},{-122,-30}},
          color={255,0,255}));
  connect(isOcc.y, and1.u2) annotation (Line(points={{-198,-440},{-150,-440},{-150,
          -38},{-122,-38}},    color={255,0,255}));
  connect(and1.y, or2.u1) annotation (Line(points={{-98,-30},{-80,-30},{-80,-60},
          {-62,-60}},color={255,0,255}));
  connect(swi3.y, TDisSet) annotation (Line(points={{-18,-210},{0,-210},{0,-160},
          {340,-160}},color={0,0,127}));
  connect(unOcc.y, isUno.u1)
    annotation (Line(points={{62,-440},{98,-440}}, color={255,127,0}));
  connect(uOpeMod, isUno.u2) annotation (Line(points={{-340,-480},{80,-480},{80,
          -448},{98,-448}}, color={255,127,0}));
  connect(conZer2.y, damPosUno.u1) annotation (Line(points={{-18,10},{20,10},{20,
          -12},{278,-12}},  color={0,0,127}));
  connect(isUno.y, damPosUno.u2) annotation (Line(points={{122,-440},{240,-440},
          {240,-20},{278,-20}}, color={255,0,255}));
  connect(isUno.y, watValPosUno.u2) annotation (Line(points={{122,-440},{240,-440},
          {240,-100},{278,-100}}, color={255,0,255}));
  connect(TSupSet, max1.u1) annotation (Line(points={{-340,-100},{-140,-100},{-140,
          -234},{-102,-234}}, color={0,0,127}));
  connect(lowDisAirTem.y, max1.u2) annotation (Line(points={{-158,-240},{-140,-240},
          {-140,-246},{-102,-246}}, color={0,0,127}));
  connect(oveFloSet,forZerFlo. u1)
    annotation (Line(points={{-340,460},{-142,460}},color={255,127,0}));
  connect(conInt.y,forZerFlo. u2) annotation (Line(points={{-178,440},{-160,440},
          {-160,452},{-142,452}}, color={255,127,0}));
  connect(oveFloSet,forCooMax. u1) annotation (Line(points={{-340,460},{-300,460},
          {-300,420},{-142,420}},color={255,127,0}));
  connect(conInt1.y,forCooMax. u2) annotation (Line(points={{-178,400},{-160,400},
          {-160,412},{-142,412}}, color={255,127,0}));
  connect(oveFloSet,forMinFlo. u1) annotation (Line(points={{-340,460},{-300,460},
          {-300,380},{-142,380}},color={255,127,0}));
  connect(conInt2.y,forMinFlo. u2) annotation (Line(points={{-178,360},{-160,360},
          {-160,372},{-142,372}}, color={255,127,0}));
  connect(forZerFlo.y,zerFlo. u)
    annotation (Line(points={{-118,460},{-62,460}},color={255,0,255}));
  connect(forCooMax.y,cooMax. u)
    annotation (Line(points={{-118,420},{-62,420}},color={255,0,255}));
  connect(forMinFlo.y,minFlo. u)
    annotation (Line(points={{-118,380},{-62,380}},color={255,0,255}));
  connect(zerFlo.y,add1. u1) annotation (Line(points={{-38,460},{0,460},{0,446},
          {118,446}},color={0,0,127}));
  connect(forZerFlo.y,or3. u1) annotation (Line(points={{-118,460},{-104,460},{-104,
          308},{-62,308}}, color={255,0,255}));
  connect(forCooMax.y,or3. u2) annotation (Line(points={{-118,420},{-96,420},{-96,
          300},{-62,300}}, color={255,0,255}));
  connect(forMinFlo.y,or3. u3) annotation (Line(points={{-118,380},{-88,380},{-88,
          292},{-62,292}}, color={255,0,255}));
  connect(add1.y, swi6.u1) annotation (Line(points={{142,440},{160,440},{160,288},
          {178,288}}, color={0,0,127}));
  connect(oveFloSet,forMinFlo1. u1) annotation (Line(points={{-340,460},{-300,460},
          {-300,340},{-142,340}}, color={255,127,0}));
  connect(conInt5.y,forMinFlo1. u2) annotation (Line(points={{-178,320},{-160,320},
          {-160,332},{-142,332}}, color={255,127,0}));
  connect(forMinFlo1.y,heaMax. u)
    annotation (Line(points={{-118,340},{-62,340}}, color={255,0,255}));
  connect(minFlo.y,add4. u1) annotation (Line(points={{-38,380},{-20,380},{-20,366},
          {-2,366}}, color={0,0,127}));
  connect(heaMax.y,add4. u2) annotation (Line(points={{-38,340},{-20,340},{-20,354},
          {-2,354}},color={0,0,127}));
  connect(or3.y,or1. u1) annotation (Line(points={{-38,300},{-20,300},{-20,280},
          {-2,280}}, color={255,0,255}));
  connect(forMinFlo1.y,or1. u2) annotation (Line(points={{-118,340},{-80,340},{-80,
          272},{-2,272}}, color={255,0,255}));
  connect(or1.y, swi6.u2)
    annotation (Line(points={{22,280},{178,280}}, color={255,0,255}));
  connect(add2.y, add1.u2) annotation (Line(points={{82,400},{100,400},{100,434},
          {118,434}}, color={0,0,127}));
  connect(add4.y, add2.u2) annotation (Line(points={{22,360},{40,360},{40,394},{
          58,394}}, color={0,0,127}));
  connect(cooMax.y, add2.u1) annotation (Line(points={{-38,420},{0,420},{0,406},
          {58,406}}, color={0,0,127}));
  connect(swi.y, swi6.u3) annotation (Line(points={{142,190},{160,190},{160,272},
          {178,272}}, color={0,0,127}));
  connect(swi6.y, VDisSet_flowNor.u1) annotation (Line(points={{202,280},{220,280},
          {220,156},{238,156}}, color={0,0,127}));
  connect(swi6.y, VSet_flow)
    annotation (Line(points={{202,280},{340,280}}, color={0,0,127}));
  connect(cooMax1.y, max2.u1) annotation (Line(points={{142,150},{160,150},{160,
          136},{198,136}}, color={0,0,127}));
  connect(heaMax1.y, max2.u2) annotation (Line(points={{142,110},{160,110},{160,
          124},{198,124}}, color={0,0,127}));
  connect(max2.y, VDisSet_flowNor.u2) annotation (Line(points={{222,130},{228,130},
          {228,144},{238,144}}, color={0,0,127}));
  connect(max2.y, VDis_flowNor.u2) annotation (Line(points={{222,130},{228,130},
          {228,74},{238,74}}, color={0,0,127}));
  connect(greThr2.y, truFalHol.u)
    annotation (Line(points={{-238,-240},{-222,-240}}, color={255,0,255}));
  connect(greThr1.y, truFalHol1.u)
    annotation (Line(points={{-258,170},{-242,170}}, color={255,0,255}));
  connect(truFalHol1.y, not1.u) annotation (Line(points={{-218,170},{-200,170},{
          -200,50},{-182,50}}, color={255,0,255}));
  connect(truFalHol1.y, and4.u1) annotation (Line(points={{-218,170},{-80,170},{
          -80,150},{-62,150}}, color={255,0,255}));
  connect(truFalHol1.y, swi.u2) annotation (Line(points={{-218,170},{-80,170},{-80,
          190},{118,190}}, color={255,0,255}));
  connect(truFalHol.y, not2.u) annotation (Line(points={{-198,-240},{-190,-240},
          {-190,10},{-182,10}}, color={255,0,255}));
  connect(truFalHol.y, or2.u2) annotation (Line(points={{-198,-240},{-190,-240},
          {-190,-68},{-62,-68}}, color={255,0,255}));
  connect(truFalHol.y, swi3.u2) annotation (Line(points={{-198,-240},{-190,-240},
          {-190,-210},{-42,-210}}, color={255,0,255}));
  connect(u1Fan, conDam.trigger) annotation (Line(points={{-340,30},{284,30},{284,
          138}}, color={255,0,255}));
  connect(max1.y, swi3.u3) annotation (Line(points={{-78,-240},{-60,-240},{-60,
          -218},{-42,-218}}, color={0,0,127}));
annotation (
  defaultComponentName="damVal",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-500},{320,500}}),
        graphics={
        Rectangle(
          extent={{-318,478},{138,102}},
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
          extent={{-318,-22},{138,-98}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-318,-122},{138,-258}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-318,-282},{138,-418}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-72,136},{102,106}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Airflow setpoint
in cooling state"),
        Text(
          extent={{-390,50},{-218,14}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Airflow setpoint
in deadband state"),
        Text(
          extent={{-60,-20},{114,-60}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Check if discharge temperature
is lower than minimum"),
        Text(
          extent={{16,-222},{132,-258}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Discharge temperature
setpoint"),
        Text(
          extent={{-48,-378},{126,-408}},
          textColor={0,0,127},
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
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,96},{-46,82}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMax_flow"),
        Text(
          extent={{-98,146},{-46,130}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMin_flow"),
        Text(
          extent={{-98,-152},{-48,-168}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMax_flow"),
        Text(
          extent={{-98,-132},{-50,-148}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMin_flow"),
        Text(
          extent={{-98,44},{-54,34}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin_flow"),
        Text(
          extent={{-98,114},{-78,106}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-100,-86},{-80,-94}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHea"),
        Text(
          extent={{-98,-56},{-70,-64}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{-100,64},{-80,56}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-13.5,4},{13.5,-4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis",
          origin={-87.5,-20}),
        Text(
          extent={{-100,-106},{-80,-114}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{68,96},{98,86}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yDam"),
        Text(
          extent={{66,-82},{98,-96}},
          textColor={0,0,127},
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
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="VSet_flow"),
        Text(
          extent={{60,-134},{98,-146}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="TDisHeaSet"),
        Text(
          extent={{-96,-184},{-70,-192}},
          textColor={255,127,27},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{-98,166},{-68,156}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-100,-36},{-68,-44}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSupSet"),
        Text(
          extent={{-98,194},{-72,186}},
          textColor={255,127,27},
          pattern=LinePattern.Dash,
          textString="oveFloSet"),
        Text(
          extent={{-100,16},{-72,4}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Fan")}),
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
<code>VActCooMax_flow</code> airflow setpoints. The heating coil is disabled (<code>yVal=0</code>)
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
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/TerminalUnits/Reheat/Subsequences/DamperValves.png\"/>
</p>
<p>
As specified in Section 5.6.7 of ASHRAE Guideline 36, the airflow setpoint could be
override by providing software switches that interlock to a system-level point to:
</p>
<ol>
<li>
when <code>oveFloSet</code> equals to 1, force the zone airflow setpoint
<code>VSet_flow</code> to zero,
</li>
<li>
when <code>oveFloSet</code> equals to 2, force the zone airflow setpoint
<code>VSet_flow</code> to zone cooling maximum airflow rate
<code>VCooMax_flow</code>,
</li>
<li>
when <code>oveFloSet</code> equals to 3, force the zone airflow setpoint
<code>VSet_flow</code> to zone minimum airflow setpoint
<code>VMin_flow</code>.
</li>
<li>
when <code>oveFloSet</code> equals to 4, force the zone airflow setpoint
<code>VSet_flow</code> to zone heating maximum airflow setpoint
<code>VHeaMax_flow</code>.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
August 24, 2023, by Jianjun Hu:<br/>
Added AHU supply fan status for damper position reset.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3257\">issue 3257</a>.
</li>
<li>
January 12, 2023, by Jianjun Hu:<br/>
Removed the parameter <code>have_preIndDam</code> to exclude the option of using pressure independant damper.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3139\">issue 3139</a>.
</li>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DamperValves;
