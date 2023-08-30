within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences;
block DamperValves
  "Output signals for controlling variable-volume series fan-powered terminal unit"

  parameter Real dTDisZonSetMax(
    final unit="K",
    final quantity="TemperatureDifference")=11
    "Zone maximum discharge air temperature above heating setpoint"
    annotation (__cdl(ValueInReference=true));
  parameter Real maxRat(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Maximum heating-fan airflow setpoint";
  parameter Real VMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone minimum airflow setpoint";
  parameter Real VCooMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone cooling maximum airflow rate";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeVal=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (__cdl(ValueInReference=false), Dialog(group="Valve"));
  parameter Real kVal(final unit="1/K")=0.5
    "Gain of controller for valve control"
    annotation (__cdl(ValueInReference=false), Dialog(group="Valve"));
  parameter Real TiVal(
    final unit="s",
    final quantity="Time")=300
    "Time constant of integrator block for valve control"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Valve",
    enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdVal(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for valve control"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Valve",
      enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeDam=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (__cdl(ValueInReference=false), Dialog(group="Damper"));
  parameter Real kDam(final unit="1")=0.5
    "Gain of controller for damper control"
    annotation (__cdl(ValueInReference=false), Dialog(group="Damper"));
  parameter Real TiDam(
    final unit="s",
    final quantity="Time")=300
    "Time constant of integrator block for damper control"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Damper",
    enable=(controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
         or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdDam(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for damper control"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Damper",
      enable=(controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
           or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real dTHys(
    final unit="K",
    final quantity="TemperatureDifference")=0.25
    "Temperature difference hysteresis below which the temperature difference will be seen as zero"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real looHys(
    final unit="1") = 0.05
    "Loop output hysteresis below which the output will be seen as zero"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real floHys(
    final unit="m3/s") = 0.01
    "Hysteresis for checking airflow rate"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real damPosHys(
    final unit="m3/s") = 0.05
    "Hysteresis for checking damper position"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveFloSet
    "Index of overriding flow setpoint, 1: set to zero; 2: set to cooling maximum; 3: set to minimum flow; 4: set to heating maximum"
    annotation (Placement(transformation(extent={{-380,380},{-340,420}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VPri_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured primary discharge airflow rate"
    annotation (Placement(transformation(extent={{-380,350},{-340,390}}),
      iconTransformation(extent={{-140,150},{-100,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-380,290},{-340,330}}),
        iconTransformation(extent={{-140,120},{-100,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active cooling maximum airflow rate"
    annotation (Placement(transformation(extent={{-380,240},{-340,280}}),
        iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature of the air supplied from central air handler"
    annotation (Placement(transformation(extent={{-380,200},{-340,240}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-380,170},{-340,210}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active minimum airflow rate"
    annotation (Placement(transformation(extent={{-380,140},{-340,180}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint from central air handler"
    annotation (Placement(transformation(extent={{-380,54},{-340,94}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-380,20},{-340,60}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-380,-20},{-340,20}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-380,-50},{-340,-10}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOAMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-380,-160},{-340,-120}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-380,-370},{-340,-330}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Fan
    "Terminal fan status"
    annotation (Placement(transformation(extent={{-380,-410},{-340,-370}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDam(
    final min=0,
    final unit="1")
    "Damper position setpoint"
    annotation (Placement(transformation(extent={{-380,-460},{-340,-420}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VPri_flow_Set(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Discharge airflow setpoint"
    annotation (Placement(transformation(extent={{360,350},{400,390}}),
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
    final quantity="VolumeFlowRate") "Series fan flow rate setpoint"
    annotation (Placement(transformation(extent={{360,-200},{400,-160}}),
        iconTransformation(extent={{100,-182},{140,-142}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Fan
    "Terminal fan command on status"
    annotation (Placement(transformation(extent={{360,-460},{400,-420}}),
        iconTransformation(extent={{100,-210},{140,-170}})));

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
  Buildings.Controls.OBC.CDL.Reals.Switch swi2 "Hot water valve position"
    annotation (Placement(transformation(extent={{300,10},{320,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant nomFlow(final k=
        VCooMax_flow)
    "Nominal volume flow rate"
    annotation (Placement(transformation(extent={{100,240},{120,260}})));
  Buildings.Controls.OBC.CDL.Reals.Divide VDisSet_flowNor
    "Normalized setpoint for discharge volume flow rate"
    annotation (Placement(transformation(extent={{200,270},{220,290}})));
  Buildings.Controls.OBC.CDL.Reals.Divide VPri_flowNor
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{200,210},{220,230}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conDam(
    final controllerType=controllerTypeDam,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam,
    final yMax=1,
    final yMin=0,
    final y_reset=0)
    "Damper position controller"
    annotation (Placement(transformation(extent={{240,270},{260,290}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3 "Air damper position"
    annotation (Placement(transformation(extent={{260,120},{280,140}})));
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
  Buildings.Controls.OBC.CDL.Reals.Line heaFanRat
    "Parallel fan airflow setpoint when zone is in heating state"
    annotation (Placement(transformation(extent={{40,-260},{60,-240}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conHal1(
    final k=0.5)
    "Constant real value"
    annotation (Placement(transformation(extent={{-20,-230},{0,-210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conHal2(
    final k=1)
    "Constant real value"
    annotation (Placement(transformation(extent={{-180,-290},{-160,-270}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxFan(
    final k=maxRat) "Maximum fan rate"
    annotation (Placement(transformation(extent={{-20,-290},{0,-270}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant uno(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    "Constant signal for unoccupied mode"
    annotation (Placement(transformation(extent={{-80,-340},{-60,-320}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isUno
    "Output true if the operation mode is unoccupied"
    annotation (Placement(transformation(extent={{20,-340},{40,-320}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Not in unoccupied mode"
    annotation (Placement(transformation(extent={{200,150},{220,170}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi4
    "Fan setpoint when it is in cooling state and the supply air temperture is high"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1
    "Larger of minimum outdoor airflow setpoint and primary discharge airflow setpoint"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi6
    "Fan setpoint when it is in cooling state"
    annotation (Placement(transformation(extent={{240,-130},{260,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Or cooHea
    "Cooling or heating state"
    annotation (Placement(transformation(extent={{0,-190},{20,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "In deadband state"
    annotation (Placement(transformation(extent={{60,-190},{80,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi7
    "Fan setpoint when it is in deadband state"
    annotation (Placement(transformation(extent={{180,-170},{200,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi8
    "Fan setpoint when it is in heating state"
    annotation (Placement(transformation(extent={{100,-310},{120,-290}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold cloDam(
    final t=damPosHys,
    final h=damPosHys/2)
    "Check if the damper is fully closed before turning on fan"
    annotation (Placement(transformation(extent={{-280,-450},{-260,-430}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(final t=15)
    "Check if the fan has been proven on for a fixed time"
    annotation (Placement(transformation(extent={{-280,-400},{-260,-380}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occ(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Constant signal for occupied mode"
    annotation (Placement(transformation(extent={{-280,-340},{-260,-320}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isOcc
    "Output true if the operation mode is occupied"
    annotation (Placement(transformation(extent={{-220,-340},{-200,-320}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    "Check if it is in heating, cooling state, or it is in occupied mode"
    annotation (Placement(transformation(extent={{-60,-380},{-40,-360}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge"
    annotation (Placement(transformation(extent={{20,-380},{40,-360}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if the fan can turn on"
    annotation (Placement(transformation(extent={{20,-450},{40,-430}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Falling edge"
    annotation (Placement(transformation(extent={{20,-490},{40,-470}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Hold fan on status"
    annotation (Placement(transformation(extent={{80,-450},{100,-430}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat "Close damper"
    annotation (Placement(transformation(extent={{80,-380},{100,-360}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=0,
    final realFalse=1)
    "Boolean to real"
    annotation (Placement(transformation(extent={{160,-380},{180,-360}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    "Ensure damper is fully closed before turning on the fan"
    annotation (Placement(transformation(extent={{320,100},{340,120}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Boolean to real"
    annotation (Placement(transformation(extent={{160,-422},{180,-402}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul1
    "Ensure damper is fully closed before turning on the fan"
    annotation (Placement(transformation(extent={{320,-190},{340,-170}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-200,450},{-180,470}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forZerFlo
    "Check if forcing zone airflow setpoint to zero"
    annotation (Placement(transformation(extent={{-140,470},{-120,490}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forCooMax
    "Check if forcing zone airflow setpoint to cooling maximum"
    annotation (Placement(transformation(extent={{-140,430},{-120,450}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{-200,410},{-180,430}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forMinFlo
    "Check if forcing zone airflow setpoint to minimum flow"
    annotation (Placement(transformation(extent={{-140,390},{-120,410}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal zerFlo(
    final realTrue=0)
    "Force zone airflow setpoint to zero"
    annotation (Placement(transformation(extent={{-80,470},{-60,490}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cooMax(
    final realTrue=VCooMax_flow)
    "Force zone airflow setpoint to cooling maximum"
    annotation (Placement(transformation(extent={{-80,430},{-60,450}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal minFlo(
    final realTrue=VMin_flow)
    "Force zone airflow setpoint to zone minimum flow"
    annotation (Placement(transformation(extent={{-80,390},{-60,410}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    "Add up two inputs"
    annotation (Placement(transformation(extent={{0,410},{20,430}})));
  Buildings.Controls.OBC.CDL.Reals.Add add1 "Add up inputs"
    annotation (Placement(transformation(extent={{60,450},{80,470}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or1
    "Check if the airflow setpoint should be overrided"
    annotation (Placement(transformation(extent={{40,360},{60,380}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi9
    "Airflow setpoint after considering override"
    annotation (Placement(transformation(extent={{120,360},{140,380}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{-200,370},{-180,390}})));
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
    annotation (Line(points={{-58,260},{-10,260},{-10,330},{-2,330}},
        color={255,0,255}));
  connect(lin.y, swi5.u3)
    annotation (Line(points={{-158,310},{-40,310},{-40,322},{-2,322}},
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
  connect(VActMin_flow, swi5.u1) annotation (Line(points={{-360,160},{-20,160},{
          -20,338},{-2,338}}, color={0,0,127}));
  connect(VActMin_flow, lin.f1) annotation (Line(points={{-360,160},{-260,160},{
          -260,314},{-182,314}}, color={0,0,127}));
  connect(VActMin_flow, swi.u3) annotation (Line(points={{-360,160},{-20,160},{-20,
          292},{58,292}},  color={0,0,127}));
  connect(TZon, sub2.u2) annotation (Line(points={{-360,190},{-280,190},{-280,194},
          {-242,194}}, color={0,0,127}));
  connect(swi2.y, yVal)
    annotation (Line(points={{322,20},{380,20}},   color={0,0,127}));
  connect(nomFlow.y, VDisSet_flowNor.u2) annotation (Line(points={{122,250},{180,
          250},{180,274},{198,274}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, conDam.u_s)
    annotation (Line(points={{222,280},{238,280}}, color={0,0,127}));
  connect(VPri_flow, VPri_flowNor.u1) annotation (Line(points={{-360,370},{-320,
          370},{-320,226},{198,226}}, color={0,0,127}));
  connect(nomFlow.y, VPri_flowNor.u2) annotation (Line(points={{122,250},{180,250},
          {180,214},{198,214}}, color={0,0,127}));
  connect(VPri_flowNor.y, conDam.u_m)
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
  connect(conZer3.y, swi3.u1) annotation (Line(points={{-258,110},{20,110},{20,138},
          {258,138}},color={0,0,127}));
  connect(conHal1.y, heaFanRat.x1) annotation (Line(points={{2,-220},{20,-220},{
          20,-242},{38,-242}},  color={0,0,127}));
  connect(uHea, heaFanRat.u) annotation (Line(points={{-360,0},{-310,0},{-310,-250},
          {38,-250}},            color={0,0,127}));
  connect(conHal2.y, heaFanRat.x2) annotation (Line(points={{-158,-280},{-120,-280},
          {-120,-254},{38,-254}},       color={0,0,127}));
  connect(maxFan.y, heaFanRat.f2) annotation (Line(points={{2,-280},{20,-280},{20,
          -258},{38,-258}},     color={0,0,127}));
  connect(uno.y, isUno.u1) annotation (Line(points={{-58,-330},{18,-330}},
                              color={255,127,0}));
  connect(isUno.y, swi2.u2) annotation (Line(points={{42,-330},{130,-330},{130,20},
          {298,20}},     color={255,0,255}));
  connect(isUno.y, swi3.u2) annotation (Line(points={{42,-330},{130,-330},{130,130},
          {258,130}},      color={255,0,255}));
  connect(isUno.y, not2.u) annotation (Line(points={{42,-330},{130,-330},{130,160},
          {198,160}},      color={255,0,255}));
  connect(not2.y, conDam.trigger) annotation (Line(points={{222,160},{244,160},{
          244,268}}, color={255,0,255}));
  connect(greThr2.y, conVal.trigger)
    annotation (Line(points={{-258,0},{-56,0},{-56,28}},   color={255,0,255}));
  connect(conVal.y, swi1.u1) annotation (Line(points={{-38,40},{-20,40},{-20,8},
          {78,8}},  color={0,0,127}));
  connect(conZer3.y, swi1.u3) annotation (Line(points={{-258,110},{20,110},{20,-8},
          {78,-8}},         color={0,0,127}));
  connect(and4.y, swi4.u2) annotation (Line(points={{-58,260},{-10,260},{-10,-80},
          {38,-80}}, color={255,0,255}));
  connect(VOAMin_flow, swi4.u1) annotation (Line(points={{-360,-140},{-300,-140},
          {-300,-72},{38,-72}},color={0,0,127}));
  connect(VOAMin_flow, max1.u2) annotation (Line(points={{-360,-140},{-300,-140},
          {-300,-106},{-162,-106}}, color={0,0,127}));
  connect(max1.y, swi4.u3) annotation (Line(points={{-138,-100},{20,-100},{20,-88},
          {38,-88}}, color={0,0,127}));
  connect(swi4.y, swi6.u1) annotation (Line(points={{62,-80},{220,-80},{220,-112},
          {238,-112}},color={0,0,127}));
  connect(greThr1.y, swi6.u2) annotation (Line(points={{-218,280},{-100,280},{-100,
          -120},{238,-120}}, color={255,0,255}));
  connect(greThr1.y, cooHea.u2) annotation (Line(points={{-218,280},{-100,280},{
          -100,-188},{-2,-188}}, color={255,0,255}));
  connect(greThr2.y, cooHea.u1) annotation (Line(points={{-258,0},{-56,0},{-56,-180},
          {-2,-180}}, color={255,0,255}));
  connect(cooHea.y, not1.u)
    annotation (Line(points={{22,-180},{58,-180}}, color={255,0,255}));
  connect(not1.y, swi7.u2) annotation (Line(points={{82,-180},{100,-180},{100,-160},
          {178,-160}}, color={255,0,255}));
  connect(swi7.y, swi6.u3) annotation (Line(points={{202,-160},{220,-160},{220,-128},
          {238,-128}},color={0,0,127}));
  connect(VOAMin_flow, swi7.u1) annotation (Line(points={{-360,-140},{60,-140},{
          60,-152},{178,-152}}, color={0,0,127}));
  connect(VOAMin_flow, heaFanRat.f1) annotation (Line(points={{-360,-140},{-300,
          -140},{-300,-246},{38,-246}}, color={0,0,127}));
  connect(heaFanRat.y, swi8.u1) annotation (Line(points={{62,-250},{80,-250},{80,
          -292},{98,-292}}, color={0,0,127}));
  connect(greThr2.y, swi8.u2) annotation (Line(points={{-258,0},{-56,0},{-56,-300},
          {98,-300}}, color={255,0,255}));
  connect(VOAMin_flow, swi8.u3) annotation (Line(points={{-360,-140},{-300,-140},
          {-300,-308},{98,-308}},color={0,0,127}));
  connect(swi8.y, swi7.u3) annotation (Line(points={{122,-300},{160,-300},{160,-168},
          {178,-168}}, color={0,0,127}));
  connect(occ.y, isOcc.u1)
    annotation (Line(points={{-258,-330},{-222,-330}}, color={255,127,0}));
  connect(uOpeMod, isOcc.u2) annotation (Line(points={{-360,-350},{-240,-350},{-240,
          -338},{-222,-338}}, color={255,127,0}));
  connect(uOpeMod, isUno.u2) annotation (Line(points={{-360,-350},{0,-350},{0,-338},
          {18,-338}}, color={255,127,0}));
  connect(greThr1.y, or3.u1) annotation (Line(points={{-218,280},{-100,280},{-100,
          -362},{-62,-362}}, color={255,0,255}));
  connect(greThr2.y, or3.u2) annotation (Line(points={{-258,0},{-110,0},{-110,-370},
          {-62,-370}},       color={255,0,255}));
  connect(isOcc.y, or3.u3) annotation (Line(points={{-198,-330},{-120,-330},{-120,
          -378},{-62,-378}}, color={255,0,255}));
  connect(or3.y, edg.u)
    annotation (Line(points={{-38,-370},{18,-370}}, color={255,0,255}));
  connect(edg.y, lat.u)
    annotation (Line(points={{42,-370},{78,-370}}, color={255,0,255}));
  connect(lat.y, booToRea.u)
    annotation (Line(points={{102,-370},{158,-370}}, color={255,0,255}));
  connect(u1Fan, tim.u)
    annotation (Line(points={{-360,-390},{-282,-390}}, color={255,0,255}));
  connect(tim.passed, lat.clr) annotation (Line(points={{-258,-398},{60,-398},{60,
          -376},{78,-376}}, color={255,0,255}));
  connect(uDam, cloDam.u)
    annotation (Line(points={{-360,-440},{-282,-440}}, color={0,0,127}));
  connect(cloDam.y, and2.u1)
    annotation (Line(points={{-258,-440},{18,-440}}, color={255,0,255}));
  connect(or3.y, and2.u2) annotation (Line(points={{-38,-370},{0,-370},{0,-448},
          {18,-448}}, color={255,0,255}));
  connect(or3.y, falEdg.u) annotation (Line(points={{-38,-370},{0,-370},{0,-480},
          {18,-480}}, color={255,0,255}));
  connect(and2.y, lat1.u)
    annotation (Line(points={{42,-440},{78,-440}}, color={255,0,255}));
  connect(falEdg.y, lat1.clr) annotation (Line(points={{42,-480},{60,-480},{60,-446},
          {78,-446}}, color={255,0,255}));
  connect(conDam.y, swi3.u3) annotation (Line(points={{262,280},{280,280},{280,150},
          {240,150},{240,122},{258,122}}, color={0,0,127}));
  connect(swi3.y, mul.u1) annotation (Line(points={{282,130},{300,130},{300,116},
          {318,116}}, color={0,0,127}));
  connect(booToRea.y, mul.u2) annotation (Line(points={{182,-370},{280,-370},{280,
          104},{318,104}}, color={0,0,127}));
  connect(mul.y, yDam)
    annotation (Line(points={{342,110},{380,110}}, color={0,0,127}));
  connect(lat1.y, y1Fan)
    annotation (Line(points={{102,-440},{380,-440}}, color={255,0,255}));
  connect(lat1.y, booToRea1.u) annotation (Line(points={{102,-440},{140,-440},{140,
          -412},{158,-412}}, color={255,0,255}));
  connect(swi6.y, mul1.u1) annotation (Line(points={{262,-120},{300,-120},{300,-174},
          {318,-174}}, color={0,0,127}));
  connect(booToRea1.y, mul1.u2) annotation (Line(points={{182,-412},{300,-412},{
          300,-186},{318,-186}}, color={0,0,127}));
  connect(mul1.y, VFan_flow_Set)
    annotation (Line(points={{342,-180},{380,-180}}, color={0,0,127}));
  connect(oveFloSet,forZerFlo. u1)
    annotation (Line(points={{-360,400},{-220,400},{-220,480},{-142,480}},
          color={255,127,0}));
  connect(conInt.y,forZerFlo. u2) annotation (Line(points={{-178,460},{-160,460},
          {-160,472},{-142,472}},color={255,127,0}));
  connect(oveFloSet,forCooMax. u1) annotation (Line(points={{-360,400},{-220,400},
          {-220,440},{-142,440}},color={255,127,0}));
  connect(conInt1.y,forCooMax. u2) annotation (Line(points={{-178,420},{-160,420},
          {-160,432},{-142,432}}, color={255,127,0}));
  connect(oveFloSet,forMinFlo. u1) annotation (Line(points={{-360,400},{-142,400}},
         color={255,127,0}));
  connect(forZerFlo.y,zerFlo. u)
    annotation (Line(points={{-118,480},{-82,480}},color={255,0,255}));
  connect(forCooMax.y,cooMax. u)
    annotation (Line(points={{-118,440},{-82,440}},color={255,0,255}));
  connect(forMinFlo.y,minFlo. u)
    annotation (Line(points={{-118,400},{-82,400}},color={255,0,255}));
  connect(cooMax.y,add2. u1) annotation (Line(points={{-58,440},{-20,440},{-20,426},
          {-2,426}},color={0,0,127}));
  connect(zerFlo.y,add1. u1) annotation (Line(points={{-58,480},{0,480},{0,466},
          {58,466}}, color={0,0,127}));
  connect(forZerFlo.y,or1. u1) annotation (Line(points={{-118,480},{-100,480},{-100,
          378},{38,378}}, color={255,0,255}));
  connect(forCooMax.y,or1. u2) annotation (Line(points={{-118,440},{-100,440},{-100,
          370},{38,370}}, color={255,0,255}));
  connect(add1.y,swi9. u1) annotation (Line(points={{82,460},{100,460},{100,378},
          {118,378}}, color={0,0,127}));
  connect(add2.y,add1. u2) annotation (Line(points={{22,420},{40,420},{40,454},{
          58,454}}, color={0,0,127}));
  connect(minFlo.y,add2. u2) annotation (Line(points={{-58,400},{-20,400},{-20,414},
          {-2,414}}, color={0,0,127}));
  connect(forMinFlo.y,or1. u3) annotation (Line(points={{-118,400},{-100,400},{-100,
          362},{38,362}},color={255,0,255}));
  connect(conInt2.y,forMinFlo. u2) annotation (Line(points={{-178,380},{-160,380},
          {-160,392},{-142,392}}, color={255,127,0}));
  connect(or1.y, swi9.u2)
    annotation (Line(points={{62,370},{118,370}}, color={255,0,255}));
  connect(swi.y, swi9.u3) annotation (Line(points={{82,300},{100,300},{100,362},
          {118,362}}, color={0,0,127}));
  connect(swi9.y, max1.u1) annotation (Line(points={{142,370},{160,370},{160,-40},
          {-200,-40},{-200,-94},{-162,-94}}, color={0,0,127}));
  connect(swi9.y, VDisSet_flowNor.u1) annotation (Line(points={{142,370},{160,370},
          {160,286},{198,286}}, color={0,0,127}));
  connect(swi9.y, VPri_flow_Set)
    annotation (Line(points={{142,370},{380,370}}, color={0,0,127}));
annotation (
  defaultComponentName="damValFan",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-340,-520},{360,520}}),
        graphics={
        Rectangle(
          extent={{-338,498},{118,162}},
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
          extent={{-336,-64},{118,-138}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-288,-108},{-112,-134}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Series fan rate when in cooling state"),
        Rectangle(
          extent={{-336,-142},{118,-198}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-300,-146},{-112,-172}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Series fan rate when in deadband state"),
        Rectangle(
          extent={{-336,-202},{118,-318}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-292,-202},{-118,-226}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Series fan rate when in heating state"),
        Rectangle(
          extent={{-336,-342},{118,-498}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-296,-466},{-122,-490}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Series fan command on setpoint")}),
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
          extent={{-98,116},{-46,102}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMax_flow"),
        Text(
          extent={{-96,-102},{-46,-118}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VOAMin_flow"),
        Text(
          extent={{-98,34},{-54,24}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin_flow"),
        Text(
          extent={{-100,146},{-80,136}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-98,-46},{-76,-56}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHea"),
        Text(
          extent={{-100,-16},{-62,-26}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{-100,86},{-80,76}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-13.5,4},{13.5,-4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis",
          origin={-87.5,-80}),
        Text(
          extent={{-100,66},{-78,56}},
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
          extent={{-96,-134},{-70,-146}},
          textColor={255,127,27},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{-98,176},{-68,166}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VPri_flow"),
        Text(
          extent={{-100,6},{-68,-4}},
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
          textString="y1Fan"),
        Text(
          extent={{-98,-160},{-74,-174}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="u1Fan"),
        Text(
          extent={{-98,-184},{-44,-196}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDam"),
        Text(
          extent={{-94,194},{-68,182}},
          textColor={255,127,27},
          pattern=LinePattern.Dash,
          textString="oveFloSet")}),
  Documentation(info="<html>
<p>
This sequence sets the series fan flow rate setpoint, damper and valve position for
variable-volume series fan-powered terminal unit.
The implementation is according to Section 5.10.5 of ASHRAE Guideline 36, May 2020. The
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
Fan shall run whenever zone state is heating or cooling state, or if the associated
zone group is in occupied mode. Prior to starting fan, the damper is first driven
fully closed to ensure that the fan is not rotating backward. Once the fan is
proven on (<code>u1Fan=true</code>) for a fixed time delay (15 seconds), the damper
override is released.
</li>
<li>
When the zone stats is cooling (<code>uCoo &gt; 0</code>), the series fan airflow setpoint
shall be the larger of <code>VOAMin_flow</code> and the <code>VPri_flow_Set</code>.
If supply air temperature <code>TSup</code> from the AHU is greater than
room temperature <code>TZon</code>, the series fan airflow setpoint shall be no higher
than <code>VOAMin_flow</code>.
</li>
<li>
When the zone state is Deadband (<code>uCoo=0</code> and <code>uHea=0</code>),
the series fan airflow setpoint shall be equal to <code>VOAMin_flow</code>.
</li>
<li>
When the zone state is Heating (<code>uHea &gt; 0</code>), as the
heating-loop output <code>uHea</code> increases from 50% to 100%, it shall reset
the series fan airflow setpoint from <code>VOAMin_flow</code> to the maximum heating-fan
airflow setpoint <code>maxRat</code>.
</li>
</ul>
</li>
</ol>
<p>The sequences of controlling fan, damper position for variable-volume
series fan-powered terminal unit are described in the following figure below.</p>
<p align=\"center\">
<img alt=\"Image of damper and fan control for variable-volume series fan-powered terminal unit\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/TerminalUnits/SeriesFanVVF/Subsequences/Damper.png\"/>
</p>
<p>
As specified in Section 5.10.7 of ASHRAE Guideline 36, the airflow setpoint could be
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
