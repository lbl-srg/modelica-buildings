within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences;
block DamperValves
  "Output signals for controlling variable-volume parallel fan-powered terminal unit"

  parameter Real dTDisZonSetMax(unit="K")=11
    "Zone maximum discharge air temperature above heating setpoint"
    annotation (__cdl(ValueInReference=true));
  parameter Real VMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone minimum airflow setpoint";
  parameter Real VCooMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone cooling maximum airflow rate";
  parameter Real minRat(unit="m3/s")
    "Lowest parallel fan rate when it receives the lowest signal from BAS";
  parameter Real maxRat(unit="m3/s")
    "Maximum heating-fan airflow setpoint";
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
  parameter Real looHys(unit="1")=0.05
    "Loop output hysteresis below which the output will be seen as zero"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real floHys(unit="m3/s")=0.01
    "Hysteresis for checking airflow rate"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real iniDam(unit="1")=0.01
    "Initial damper position when the damper control is enabled"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveFloSet
    "Index of overriding flow setpoint, 1: set to zero; 2: set to cooling maximum; 3: set to minimum flow; 4: set to heating maximum"
    annotation (Placement(transformation(extent={{-380,400},{-340,440}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VPri_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured primary discharge airflow rate"
    annotation (Placement(transformation(extent={{-380,350},{-340,390}}),
      iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-380,290},{-340,330}}),
        iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active cooling maximum airflow rate"
    annotation (Placement(transformation(extent={{-380,240},{-340,280}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature of the air supplied from central air handler"
    annotation (Placement(transformation(extent={{-380,200},{-340,240}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-380,170},{-340,210}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active minimum airflow rate"
    annotation (Placement(transformation(extent={{-380,140},{-340,180}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Fan
    "AHU supply fan status"
    annotation (Placement(transformation(extent={{-380,110},{-340,150}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint from central air handler"
    annotation (Placement(transformation(extent={{-380,54},{-340,94}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-380,20},{-340,60}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-380,-20},{-340,20}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-380,-50},{-340,-10}}),
      iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOAMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-380,-130},{-340,-90}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-380,-230},{-340,-190}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VPri_flow_Set(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Discharge airflow setpoint"
    annotation (Placement(transformation(extent={{360,370},{400,410}}),
        iconTransformation(extent={{100,120},{140,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(
    final min=0,
    final max=1,
    final unit="1") "VAV damper commanded position"
    annotation (Placement(transformation(extent={{360,90},{400,130}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaDisSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Discharge airflow setpoint temperature for heating"
    annotation (Placement(transformation(extent={{360,50},{400,90}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(
    final min=0,
    final max=1,
    final unit="1") "Hot water valve commanded position"
    annotation (Placement(transformation(extent={{360,0},{400,40}}),
        iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VFan_flow_Set(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Paralle fan flow rate setpoint"
    annotation (Placement(transformation(extent={{360,-260},{400,-220}}),
        iconTransformation(extent={{100,-182},{140,-142}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Fan
    "Terminal fan command on"
    annotation (Placement(transformation(extent={{360,-320},{400,-280}}),
        iconTransformation(extent={{100,-210},{140,-170}})));

protected
  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{-80,250},{-60,270}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin
    "Active airflow setpoint for cooling"
    annotation (Placement(transformation(extent={{-180,300},{-160,320}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Output active cooling airflow according to cooling control signal"
    annotation (Placement(transformation(extent={{60,290},{80,310}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi5
    "Airflow setpoint when it is in cooling state"
    annotation (Placement(transformation(extent={{0,320},{20,340}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-300,330},{-280,350}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conOne(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-240,330},{-220,350}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is cooling state"
    annotation (Placement(transformation(extent={{-240,270},{-220,290}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=dTHys,
    final h=0.5*dTHys)
    "Check if supply air temperature is greater than room temperature"
    annotation (Placement(transformation(extent={{-200,190},{-180,210}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    "Calculate temperature difference between AHU supply air and room "
    annotation (Placement(transformation(extent={{-240,190},{-220,210}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    "Hot water valve position"
    annotation (Placement(transformation(extent={{300,10},{320,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant nomFlow(
    final k=VCooMax_flow)
    "Nominal volume flow rate"
    annotation (Placement(transformation(extent={{60,240},{80,260}})));
  Buildings.Controls.OBC.CDL.Reals.Divide VDisSet_flowNor
    "Normalized setpoint for discharge volume flow rate"
    annotation (Placement(transformation(extent={{200,270},{220,290}})));
  Buildings.Controls.OBC.CDL.Reals.Divide VDis_flowNor
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{200,210},{220,230}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conDam(
    final controllerType=controllerTypeDam,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam,
    final yMax=1,
    final yMin=0,
    final y_reset=iniDam)
    "Damper position controller"
    annotation (Placement(transformation(extent={{240,270},{260,290}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3 "Air damper position"
    annotation (Placement(transformation(extent={{300,100},{320,120}})));
  Buildings.Controls.OBC.CDL.Reals.Line conTDisHeaSet
    "Discharge air temperature for heating"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=dTDisZonSetMax)
    "Maximum heating discharge temperature"
    annotation (Placement(transformation(extent={{-280,30},{-260,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conHal(
    final k=0.5)
    "Constant real value"
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr2(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is heating state"
    annotation (Placement(transformation(extent={{-280,-10},{-260,10}})));
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
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer3(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-280,100},{-260,120}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Hot water valve position, close the valve when the zone is not in heating state"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occ(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Constant signal for occupied mode"
    annotation (Placement(transformation(extent={{-280,-190},{-260,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minFan(
    final k=minRat) "Minimum fan rate"
    annotation (Placement(transformation(extent={{-280,-80},{-260,-60}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(
    final k=0.5) "Gain factor"
    annotation (Placement(transformation(extent={{-240,-80},{-220,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Minimum outdoor airflow setpoint minus the half of minimum fan rate"
    annotation (Placement(transformation(extent={{-180,-60},{-160,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre(
    final h=floHys)
    "Check if primary discharge airflow rate is below threshold"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Keep true output until condition change"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isOcc
    "Output true if the operation mode is occupied"
    annotation (Placement(transformation(extent={{-180,-220},{-160,-200}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "It is in occupied mode and the zone is in cooling state"
    annotation (Placement(transformation(extent={{-60,-220},{-40,-200}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre1(
    final h=floHys)
    "Check if primary discharge airflow rate is above threshold"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi4
    "Parallel fan flow rate setpoint"
    annotation (Placement(transformation(extent={{260,-220},{280,-200}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "Fan flow rate setpoint"
    annotation (Placement(transformation(extent={{40,-160},{60,-140}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1 "Ensure positive value"
    annotation (Placement(transformation(extent={{100,-140},{120,-120}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    "Parallel fan rate when the zone state is cooling"
    annotation (Placement(transformation(extent={{200,-120},{220,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Or cooHea "Cooling or heating state"
    annotation (Placement(transformation(extent={{-60,-310},{-40,-290}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "In deadband state"
    annotation (Placement(transformation(extent={{40,-310},{60,-290}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi6
    "Parallel fan flow rate setpoint when the zone is in deadband state"
    annotation (Placement(transformation(extent={{220,-310},{240,-290}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre2(
    final h=floHys)
    "Check if primary discharge airflow rate setpoint is below threshold"
    annotation (Placement(transformation(extent={{-60,-270},{-40,-250}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{40,-270},{60,-250}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul1
    "Fan rate when zone is in deadband state"
    annotation (Placement(transformation(extent={{160,-280},{180,-260}})));
  Buildings.Controls.OBC.CDL.Reals.Line heaFanRat
    "Parallel fan airflow setpoint when zone is in heating state"
    annotation (Placement(transformation(extent={{40,-420},{60,-400}})));
  Buildings.Controls.OBC.CDL.Reals.Max max2
    "Ensure the fan flow rate setpoint is greater than minimum value"
    annotation (Placement(transformation(extent={{-180,-390},{-160,-370}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conHal1(
    final k=0.5)
    "Constant real value"
    annotation (Placement(transformation(extent={{-60,-390},{-40,-370}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conHal2(
    final k=1)
    "Constant real value"
    annotation (Placement(transformation(extent={{-180,-450},{-160,-430}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxFan(
    final k=maxRat) "Maximum fan rate"
    annotation (Placement(transformation(extent={{-60,-450},{-40,-430}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{40,-360},{60,-340}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul2
    "Ensure zero rate when it is not in heating state"
    annotation (Placement(transformation(extent={{160,-380},{180,-360}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant uno(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    "Constant signal for unoccupied mode"
    annotation (Placement(transformation(extent={{-280,-470},{-260,-450}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isUno
    "Output true if the operation mode is unoccupied"
    annotation (Placement(transformation(extent={{-180,-510},{-160,-490}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi7
    "Parallel fan flow rate setpoint"
    annotation (Placement(transformation(extent={{320,-250},{340,-230}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr3(
    final t=floHys,
    final h=floHys/2)
    "Terminal fan command on status"
    annotation (Placement(transformation(extent={{320,-310},{340,-290}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-200,470},{-180,490}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forZerFlo
    "Check if forcing zone airflow setpoint to zero"
    annotation (Placement(transformation(extent={{-140,490},{-120,510}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forCooMax
    "Check if forcing zone airflow setpoint to cooling maximum"
    annotation (Placement(transformation(extent={{-140,450},{-120,470}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{-200,430},{-180,450}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forMinFlo
    "Check if forcing zone airflow setpoint to minimum flow"
    annotation (Placement(transformation(extent={{-140,410},{-120,430}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{-200,390},{-180,410}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal zerFlo(
    final realTrue=0)
    "Force zone airflow setpoint to zero"
    annotation (Placement(transformation(extent={{-80,490},{-60,510}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cooMax(
    final realTrue=VCooMax_flow)
    "Force zone airflow setpoint to cooling maximum"
    annotation (Placement(transformation(extent={{-80,450},{-60,470}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal minFlo(
    final realTrue=VMin_flow)
    "Force zone airflow setpoint to zone minimum flow"
    annotation (Placement(transformation(extent={{-80,410},{-60,430}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2 "Add up two inputs"
    annotation (Placement(transformation(extent={{0,430},{20,450}})));
  Buildings.Controls.OBC.CDL.Reals.Add add1 "Add up inputs"
    annotation (Placement(transformation(extent={{40,470},{60,490}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi8
    "Airflow setpoint after considering override"
    annotation (Placement(transformation(extent={{100,380},{120,400}})));
  Buildings.Controls.OBC.CDL.Logical.Or or3
    "Check if the airflow setpoint should be overrided"
    annotation (Placement(transformation(extent={{-80,360},{-60,380}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if the airflow setpoint should be overrided"
    annotation (Placement(transformation(extent={{40,380},{60,400}})));

equation
  connect(uCoo, lin.u)
    annotation (Line(points={{-360,310},{-182,310}}, color={0,0,127}));
  connect(conZer.y, lin.x1)
    annotation (Line(points={{-278,340},{-260,340},{-260,318},{-182,318}},
      color={0,0,127}));
  connect(conOne.y, lin.x2)
    annotation (Line(points={{-218,340},{-200,340},{-200,306},{-182,306}},
      color={0,0,127}));
  connect(VActCooMax_flow, lin.f2)
    annotation (Line(points={{-360,260},{-200,260},{-200,302},{-182,302}},
      color={0,0,127}));
  connect(uCoo, greThr1.u) annotation (Line(points={{-360,310},{-300,310},{-300,
          280},{-242,280}}, color={0,0,127}));
  connect(and4.y, swi5.u2)
    annotation (Line(points={{-58,260},{-40,260},{-40,330},{-2,330}},
        color={255,0,255}));
  connect(lin.y, swi5.u3)
    annotation (Line(points={{-158,310},{-20,310},{-20,322},{-2,322}},
      color={0,0,127}));
  connect(swi5.y, swi.u1)
    annotation (Line(points={{22,330},{40,330},{40,308},{58,308}},
      color={0,0,127}));
  connect(TSup, sub2.u1)
    annotation (Line(points={{-360,220},{-280,220},{-280,206},{-242,206}},
        color={0,0,127}));
  connect(sub2.y, greThr.u)
    annotation (Line(points={{-218,200},{-202,200}}, color={0,0,127}));
  connect(greThr.y, and4.u2) annotation (Line(points={{-178,200},{-140,200},{-140,
          252},{-82,252}}, color={255,0,255}));
  connect(greThr1.y, and4.u1) annotation (Line(points={{-218,280},{-100,280},{-100,
          260},{-82,260}},     color={255,0,255}));
  connect(greThr1.y, swi.u2) annotation (Line(points={{-218,280},{-100,280},{-100,
          300},{58,300}},  color={255,0,255}));
  connect(VActMin_flow, swi5.u1) annotation (Line(points={{-360,160},{-30,160},{
          -30,338},{-2,338}}, color={0,0,127}));
  connect(VActMin_flow, lin.f1) annotation (Line(points={{-360,160},{-260,160},{
          -260,314},{-182,314}}, color={0,0,127}));
  connect(VActMin_flow, swi.u3) annotation (Line(points={{-360,160},{-30,160},{-30,
          292},{58,292}},  color={0,0,127}));
  connect(TZon, sub2.u2) annotation (Line(points={{-360,190},{-280,190},{-280,194},
          {-242,194}}, color={0,0,127}));
  connect(swi2.y, yVal)
    annotation (Line(points={{322,20},{380,20}},   color={0,0,127}));
  connect(nomFlow.y, VDisSet_flowNor.u2) annotation (Line(points={{82,250},{180,
          250},{180,274},{198,274}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, conDam.u_s)
    annotation (Line(points={{222,280},{238,280}}, color={0,0,127}));
  connect(VPri_flow, VDis_flowNor.u1) annotation (Line(points={{-360,370},{-320,
          370},{-320,226},{198,226}}, color={0,0,127}));
  connect(nomFlow.y, VDis_flowNor.u2) annotation (Line(points={{82,250},{180,250},
          {180,214},{198,214}}, color={0,0,127}));
  connect(swi3.y, yDam)
    annotation (Line(points={{322,110},{380,110}}, color={0,0,127}));
  connect(VDis_flowNor.y, conDam.u_m)
    annotation (Line(points={{222,220},{250,220},{250,268}}, color={0,0,127}));
  connect(THeaSet, addPar.u)
    annotation (Line(points={{-360,40},{-282,40}},   color={0,0,127}));
  connect(conZer3.y, conTDisHeaSet.x1) annotation (Line(points={{-258,110},{-160,
          110},{-160,78},{-142,78}},   color={0,0,127}));
  connect(TSupSet, conTDisHeaSet.f1)
    annotation (Line(points={{-360,74},{-142,74}},   color={0,0,127}));
  connect(uHea, conTDisHeaSet.u) annotation (Line(points={{-360,0},{-310,0},{-310,
          70},{-142,70}},       color={0,0,127}));
  connect(conHal.y, conTDisHeaSet.x2) annotation (Line(points={{-178,40},{-160,40},
          {-160,66},{-142,66}},        color={0,0,127}));
  connect(addPar.y, conTDisHeaSet.f2) annotation (Line(points={{-258,40},{-240,40},
          {-240,62},{-142,62}},        color={0,0,127}));
  connect(conTDisHeaSet.y, conVal.u_s) annotation (Line(points={{-118,70},{-80,70},
          {-80,40},{-62,40}},       color={0,0,127}));
  connect(TDis, conVal.u_m) annotation (Line(points={{-360,-30},{-50,-30},{-50,28}},
                 color={0,0,127}));
  connect(uHea, greThr2.u)
    annotation (Line(points={{-360,0},{-282,0}},   color={0,0,127}));
  connect(greThr2.y, swi1.u2)
    annotation (Line(points={{-258,0},{78,0}},   color={255,0,255}));
  connect(swi1.y, swi2.u3) annotation (Line(points={{102,0},{240,0},{240,12},{298,
          12}},     color={0,0,127}));
  connect(conZer3.y, swi2.u1) annotation (Line(points={{-258,110},{20,110},{20,28},
          {298,28}},  color={0,0,127}));
  connect(conTDisHeaSet.y, THeaDisSet)
    annotation (Line(points={{-118,70},{380,70}},  color={0,0,127}));
  connect(conDam.y, swi3.u3) annotation (Line(points={{262,280},{280,280},{280,
          102},{298,102}}, color={0,0,127}));
  connect(conZer3.y, swi3.u1) annotation (Line(points={{-258,110},{20,110},{20,
          118},{298,118}}, color={0,0,127}));
  connect(minFan.y, gai1.u)
    annotation (Line(points={{-258,-70},{-242,-70}}, color={0,0,127}));
  connect(gai1.y, sub.u2) annotation (Line(points={{-218,-70},{-200,-70},{-200,-56},
          {-182,-56}}, color={0,0,127}));
  connect(VOAMin_flow, sub.u1) annotation (Line(points={{-360,-110},{-300,-110},
          {-300,-44},{-182,-44}}, color={0,0,127}));
  connect(sub.y, gre.u1) annotation (Line(points={{-158,-50},{-140,-50},{-140,-90},
          {-62,-90}}, color={0,0,127}));
  connect(VPri_flow, gre.u2) annotation (Line(points={{-360,370},{-320,370},{-320,
          -98},{-62,-98}}, color={0,0,127}));
  connect(occ.y, isOcc.u2) annotation (Line(points={{-258,-180},{-220,-180},{-220,
          -218},{-182,-218}}, color={255,127,0}));
  connect(uOpeMod, isOcc.u1)
    annotation (Line(points={{-360,-210},{-182,-210}}, color={255,127,0}));
  connect(isOcc.y, and1.u1)
    annotation (Line(points={{-158,-210},{-62,-210}}, color={255,0,255}));
  connect(greThr1.y, and1.u2) annotation (Line(points={{-218,280},{-100,280},{-100,
          -218},{-62,-218}}, color={255,0,255}));
  connect(VOAMin_flow, gre1.u2) annotation (Line(points={{-360,-110},{-300,-110},
          {-300,-128},{-62,-128}}, color={0,0,127}));
  connect(VPri_flow, gre1.u1) annotation (Line(points={{-360,370},{-320,370},{-320,
          -120},{-62,-120}}, color={0,0,127}));
  connect(gre.y, lat.u)
    annotation (Line(points={{-38,-90},{38,-90}},   color={255,0,255}));
  connect(gre1.y, lat.clr) annotation (Line(points={{-38,-120},{0,-120},{0,-96},
          {38,-96}}, color={255,0,255}));
  connect(and1.y, swi4.u2)
    annotation (Line(points={{-38,-210},{258,-210}}, color={255,0,255}));
  connect(VOAMin_flow, sub1.u1) annotation (Line(points={{-360,-110},{-300,-110},
          {-300,-144},{38,-144}}, color={0,0,127}));
  connect(sub1.y, max1.u2) annotation (Line(points={{62,-150},{80,-150},{80,-136},
          {98,-136}}, color={0,0,127}));
  connect(conZer3.y, max1.u1) annotation (Line(points={{-258,110},{20,110},{20,-124},
          {98,-124}}, color={0,0,127}));
  connect(lat.y, booToRea.u)
    annotation (Line(points={{62,-90},{98,-90}},  color={255,0,255}));
  connect(booToRea.y, mul.u1) annotation (Line(points={{122,-90},{160,-90},{160,
          -104},{198,-104}}, color={0,0,127}));
  connect(max1.y, mul.u2) annotation (Line(points={{122,-130},{140,-130},{140,-116},
          {198,-116}}, color={0,0,127}));
  connect(mul.y, swi4.u1) annotation (Line(points={{222,-110},{240,-110},{240,-202},
          {258,-202}}, color={0,0,127}));
  connect(VOAMin_flow, gre2.u1) annotation (Line(points={{-360,-110},{-300,-110},
          {-300,-260},{-62,-260}}, color={0,0,127}));
  connect(gre2.y, booToRea1.u)
    annotation (Line(points={{-38,-260},{38,-260}}, color={255,0,255}));
  connect(max1.y, mul1.u1) annotation (Line(points={{122,-130},{140,-130},{140,-264},
          {158,-264}}, color={0,0,127}));
  connect(booToRea1.y, mul1.u2) annotation (Line(points={{62,-260},{120,-260},{120,
          -276},{158,-276}}, color={0,0,127}));
  connect(greThr2.y, cooHea.u2) annotation (Line(points={{-258,0},{-120,0},{-120,
          -308},{-62,-308}}, color={255,0,255}));
  connect(greThr1.y, cooHea.u1) annotation (Line(points={{-218,280},{-100,280},{
          -100,-300},{-62,-300}},color={255,0,255}));
  connect(cooHea.y, not1.u)
    annotation (Line(points={{-38,-300},{38,-300}}, color={255,0,255}));
  connect(mul1.y, swi6.u1) annotation (Line(points={{182,-270},{200,-270},{200,-292},
          {218,-292}}, color={0,0,127}));
  connect(not1.y, swi6.u2)
    annotation (Line(points={{62,-300},{218,-300}}, color={255,0,255}));
  connect(swi6.y, swi4.u3) annotation (Line(points={{242,-300},{250,-300},{250,-218},
          {258,-218}}, color={0,0,127}));
  connect(conHal1.y, heaFanRat.x1) annotation (Line(points={{-38,-380},{20,-380},
          {20,-402},{38,-402}}, color={0,0,127}));
  connect(mul1.y, max2.u2) annotation (Line(points={{182,-270},{200,-270},{200,-322},
          {-260,-322},{-260,-386},{-182,-386}}, color={0,0,127}));
  connect(minFan.y, max2.u1) annotation (Line(points={{-258,-70},{-250,-70},{-250,
          -374},{-182,-374}}, color={0,0,127}));
  connect(max2.y, heaFanRat.f1) annotation (Line(points={{-158,-380},{-120,-380},
          {-120,-406},{38,-406}}, color={0,0,127}));
  connect(uHea, heaFanRat.u) annotation (Line(points={{-360,0},{-310,0},{-310,-410},
          {38,-410}},            color={0,0,127}));
  connect(conHal2.y, heaFanRat.x2) annotation (Line(points={{-158,-440},{-120,-440},
          {-120,-414},{38,-414}},       color={0,0,127}));
  connect(maxFan.y, heaFanRat.f2) annotation (Line(points={{-38,-440},{20,-440},
          {20,-418},{38,-418}}, color={0,0,127}));
  connect(greThr2.y, booToRea2.u) annotation (Line(points={{-258,0},{-120,0},{-120,
          -350},{38,-350}},       color={255,0,255}));
  connect(booToRea2.y, mul2.u1) annotation (Line(points={{62,-350},{140,-350},{140,
          -364},{158,-364}},     color={0,0,127}));
  connect(heaFanRat.y, mul2.u2) annotation (Line(points={{62,-410},{140,-410},{140,
          -376},{158,-376}},     color={0,0,127}));
  connect(mul2.y, swi6.u3) annotation (Line(points={{182,-370},{210,-370},{210,-308},
          {218,-308}},       color={0,0,127}));
  connect(uno.y, isUno.u1) annotation (Line(points={{-258,-460},{-220,-460},{-220,
          -500},{-182,-500}}, color={255,127,0}));
  connect(uOpeMod, isUno.u2) annotation (Line(points={{-360,-210},{-320,-210},{-320,
          -508},{-182,-508}}, color={255,127,0}));
  connect(isUno.y, swi2.u2) annotation (Line(points={{-158,-500},{130,-500},{130,
          20},{298,20}}, color={255,0,255}));
  connect(isUno.y, swi3.u2) annotation (Line(points={{-158,-500},{130,-500},{
          130,110},{298,110}}, color={255,0,255}));
  connect(isUno.y, swi7.u2) annotation (Line(points={{-158,-500},{130,-500},{130,
          -240},{318,-240}}, color={255,0,255}));
  connect(swi4.y, swi7.u3) annotation (Line(points={{282,-210},{300,-210},{300,-248},
          {318,-248}}, color={0,0,127}));
  connect(conZer3.y, swi7.u1) annotation (Line(points={{-258,110},{20,110},{20,-232},
          {318,-232}}, color={0,0,127}));
  connect(swi7.y, VFan_flow_Set)
    annotation (Line(points={{342,-240},{380,-240}}, color={0,0,127}));
  connect(greThr2.y, conVal.trigger)
    annotation (Line(points={{-258,0},{-56,0},{-56,28}},   color={255,0,255}));
  connect(swi7.y, greThr3.u) annotation (Line(points={{342,-240},{350,-240},{350,
          -280},{300,-280},{300,-300},{318,-300}}, color={0,0,127}));
  connect(greThr3.y, y1Fan)
    annotation (Line(points={{342,-300},{380,-300}}, color={255,0,255}));
  connect(conVal.y, swi1.u1) annotation (Line(points={{-38,40},{0,40},{0,8},{78,
          8}},     color={0,0,127}));
  connect(conZer3.y, swi1.u3) annotation (Line(points={{-258,110},{20,110},{20,-8},
          {78,-8}}, color={0,0,127}));
  connect(oveFloSet,forZerFlo. u1)
    annotation (Line(points={{-360,420},{-220,420},{-220,500},{-142,500}},
          color={255,127,0}));
  connect(conInt.y,forZerFlo. u2) annotation (Line(points={{-178,480},{-160,480},
          {-160,492},{-142,492}},color={255,127,0}));
  connect(oveFloSet,forCooMax. u1) annotation (Line(points={{-360,420},{-220,420},
          {-220,460},{-142,460}},color={255,127,0}));
  connect(conInt1.y,forCooMax. u2) annotation (Line(points={{-178,440},{-160,440},
          {-160,452},{-142,452}}, color={255,127,0}));
  connect(oveFloSet,forMinFlo. u1) annotation (Line(points={{-360,420},{-142,420}},
         color={255,127,0}));
  connect(conInt2.y,forMinFlo. u2) annotation (Line(points={{-178,400},{-160,400},
          {-160,412},{-142,412}}, color={255,127,0}));
  connect(forZerFlo.y,zerFlo. u)
    annotation (Line(points={{-118,500},{-82,500}},color={255,0,255}));
  connect(forCooMax.y,cooMax. u)
    annotation (Line(points={{-118,460},{-82,460}},color={255,0,255}));
  connect(forMinFlo.y,minFlo. u)
    annotation (Line(points={{-118,420},{-82,420}},color={255,0,255}));
  connect(cooMax.y,add2. u1) annotation (Line(points={{-58,460},{-20,460},{-20,446},
          {-2,446}},color={0,0,127}));
  connect(zerFlo.y,add1. u1) annotation (Line(points={{-58,500},{0,500},{0,486},
          {38,486}}, color={0,0,127}));
  connect(forZerFlo.y,or3. u1) annotation (Line(points={{-118,500},{-100,500},{-100,
          370},{-82,370}},color={255,0,255}));
  connect(forCooMax.y,or3. u2) annotation (Line(points={{-118,460},{-100,460},{-100,
          362},{-82,362}},color={255,0,255}));
  connect(add1.y,swi8. u1) annotation (Line(points={{62,480},{80,480},{80,398},{
          98,398}},   color={0,0,127}));
  connect(add2.y,add1. u2) annotation (Line(points={{22,440},{30,440},{30,474},{
          38,474}}, color={0,0,127}));
  connect(minFlo.y,add2. u2) annotation (Line(points={{-58,420},{-20,420},{-20,434},
          {-2,434}}, color={0,0,127}));
  connect(swi.y, swi8.u3) annotation (Line(points={{82,300},{90,300},{90,382},{98,
          382}}, color={0,0,127}));
  connect(swi8.y, VPri_flow_Set)
    annotation (Line(points={{122,390},{380,390}}, color={0,0,127}));
  connect(swi8.y, VDisSet_flowNor.u1) annotation (Line(points={{122,390},{140,390},
          {140,286},{198,286}}, color={0,0,127}));
  connect(swi8.y, gre2.u2) annotation (Line(points={{122,390},{140,390},{140,-40},
          {-80,-40},{-80,-268},{-62,-268}}, color={0,0,127}));
  connect(swi8.y, sub1.u2) annotation (Line(points={{122,390},{140,390},{140,-40},
          {-80,-40},{-80,-156},{38,-156}}, color={0,0,127}));
  connect(u1Fan, conDam.trigger) annotation (Line(points={{-360,130},{244,130},{
          244,268}}, color={255,0,255}));
  connect(or2.y, swi8.u2)
    annotation (Line(points={{62,390},{98,390}}, color={255,0,255}));
  connect(or3.y, or2.u2) annotation (Line(points={{-58,370},{20,370},{20,382},{38,
          382}}, color={255,0,255}));
  connect(forMinFlo.y, or2.u1) annotation (Line(points={{-118,420},{-100,420},{-100,
          390},{38,390}}, color={255,0,255}));
annotation (
  defaultComponentName="damValFan",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-340,-520},{360,520}}),
        graphics={
        Rectangle(
          extent={{-338,518},{118,162}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-74,204},{104,162}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Primary discharge airflow setpoint
and the damper position setpoint"),
        Rectangle(
          extent={{-338,118},{118,-38}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-38,108},{106,80}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Hot water valve position"),
        Rectangle(
          extent={{-338,-42},{116,-218}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-270,-144},{-94,-170}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Parallel fan rate when in cooling state"),
        Rectangle(
          extent={{-338,-220},{116,-316}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-298,-270},{-110,-296}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Parallel fan rate when in deadband state"),
        Rectangle(
          extent={{-338,-324},{116,-458}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-302,-330},{-128,-354}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Parallel fan rate when in heating state")}),
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
          extent={{-98,106},{-46,92}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMax_flow"),
        Text(
          extent={{-98,-132},{-48,-148}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VOAMin_flow"),
        Text(
          extent={{-98,14},{-54,4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin_flow"),
        Text(
          extent={{-100,136},{-80,126}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-98,-76},{-76,-86}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHea"),
        Text(
          extent={{-100,-46},{-62,-56}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{-100,76},{-80,66}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-13.5,4},{13.5,-4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis",
          origin={-87.5,-110}),
        Text(
          extent={{-100,46},{-78,36}},
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
          extent={{68,-112},{98,-124}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yVal"),
        Line(points={{-38,64},{-38,-48},{74,-48}}, color={95,95,95}),
        Line(
          points={{-16,60},{10,-48}},
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
          textString="VPri_flow_Set"),
        Text(
          extent={{54,-84},{98,-96}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="TDisHeaSet"),
        Text(
          extent={{-96,-184},{-70,-196}},
          textColor={255,127,27},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{-98,166},{-68,156}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VPri_flow"),
        Text(
          extent={{-100,-24},{-68,-34}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSupSet"),
        Text(
          extent={{42,-152},{98,-168}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="VFan_flow_Set"),
        Line(
          points={{-38,-22},{26,-22},{78,60}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{-16,-6},{-38,26}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Line(
          points={{-16,60},{-38,60}},
          color={95,95,95},
          thickness=0.5),
        Line(
          points={{-16,-6},{26,-6}},
          color={28,108,200},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{26,-6},{36,-28},{40,-28},{40,-48}},
          color={28,108,200},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Text(
          extent={{64,-180},{96,-194}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yFan"),
        Text(
          extent={{-96,194},{-70,182}},
          textColor={255,127,27},
          pattern=LinePattern.Dash,
          textString="oveFloSet"),
        Text(
          extent={{-98,-2},{-66,-16}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Fan")}),
  Documentation(info="<html>
<p>
This sequence sets the parallel fan flow rate setpoint, damper and valve position for
variable-volume parallel fan-powered terminal unit.
The implementation is according to Section 5.8.5 of ASHRAE Guideline 36, May 2020. The
calculation is done following the steps below.
</p>
<ol>
<li>
When the zone state is cooling (<code>uCoo &gt; 0</code>), then the cooling loop output
<code>uCoo</code> shall be mapped to the primary airflow
setpoint from the minimum <code>VActMin_flow</code> to the cooling maximum
<code>VActCooMax_flow</code> airflow setpoints.
The heating coil is disabled (<code>yVal=0</code>).
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
the primary airflow setpoint shall be the minimum airflow setpoint <code>VActMin_flow</code>.
The heating coil is disabled (<code>yVal=0</code>).
</li>
<li>
When the zone state is Heating (<code>uHea &gt; 0</code>),
<ul>
<li>
As the heating-loop output <code>uHea</code> increases from 0% to 50%, it shall reset
the discharge temperature <code>THeaDisSet</code> from the current AHU setpoint
temperature <code>TSupSet</code> to a maximum of <code>dTDisZonSetMax</code>
above space temperature setpoint.
</li>
<li>
The primary airflow setpoint shall be the minimum flow <code>VActMin_flow</code>.
</li>
<li>
The heating coil shall be modulated to maintain the discharge temperature at setpoint.
</li>
</ul>
</li>
<li>
The VAV damper shall be modulated by a control loop to maintain the measured primary
airflow at the setpoint.
</li>
<li>
Fan control
<ul>
<li>
When the zone stats is cooling (<code>uCoo &gt; 0</code>), in occupied mode only, the
parallel fan starts when primary airflow (<code>VPri_flow</code>) drops below the
the minimum outdoor airflow setpoint <code>VOAMin_flow</code> 
(if using California Title 24, it should be the zone absolute minimum outdoor airflow rate)
minus half of the minium fan
rate <code>minRat</code> and shuts off when primary airflow rises above the
<code>VOAMin_flow</code> (or the zone absolute minimum outdoor airflow rate). Fan airflow rate
set point is equal to the minimum outdoor airflow rate
minus the current primary airflow set point <code>VPri_flow_Set</code>.
</li>
<li>
When the zone state is Deadband (<code>uCoo=0</code> and <code>uHea=0</code>), 
the parallel fan starts when primary airflow (<code>VPri_flow</code>) is below the
minimum outdoor airflow <code>VOAMin_flow</code> (or if using California Title 24,
the zone absolute minimum outdoor airflow rate). The fan flow rate setpoint
is equal to the minimum outdoor airflow rate minus the current primary airflow setpoint
<code>VPri_flow_Set</code>.
</li>
<li>
When the zone state is Heating (<code>uHea &gt; 0</code>), fan shall run. As the
heating-loop output <code>uHea</code> increases from 50% to 100%, it shall reset
the fan airflow setpoint from the setpoint required in deadband proportionally
up to the maximum heating-fan airflow setpoint <code>maxRat</code>.
</li>
</ul>
</li>
</ol>
<p>The sequences of controlling damper and the parallel fan for the
unit are described in the following figure below.</p>
<p align=\"center\">
<img alt=\"Image of damper control for variable-volume parallel fan-powered terminal unit\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/TerminalUnits/ParallelFanVVF/Subsequences/Dampers.png\"/>
</p>
<p>
As specified in Section 5.8.7 of ASHRAE Guideline 36, the airflow setpoint could be
override by providing software switches that interlock to a system-level point to:
</p>
<ol>
<li>
when <code>oveFloSet</code> equals to 1, force the zone airflow setpoint
<code>VPri_flow_Set</code> to zero,
</li>
<li>
when <code>oveFloSet</code> equals to 2, force the zone airflow setpoint
<code>VPri_flow_Set</code> to zone cooling maximum airflow rate
<code>VCooMax_flow</code>,
</li>
<li>
when <code>oveFloSet</code> equals to 3, force the zone airflow setpoint
<code>VPri_flow_Set</code> to zone minimum airflow setpoint
<code>VMin_flow</code>.
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
