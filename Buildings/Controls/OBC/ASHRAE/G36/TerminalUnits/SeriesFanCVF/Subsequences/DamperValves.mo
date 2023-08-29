within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanCVF.Subsequences;
block DamperValves
  "Output signals for controlling constant-volume series fan-powered terminal unit"

  parameter Real dTDisZonSetMax(
    final unit="K",
    final quantity="TemperatureDifference")=11
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
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeVal=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (__cdl(ValueInReference=false), Dialog(group="Valve"));
  parameter Real kVal(final unit="1/K")=0.5
    "Gain of controller for valve control"
    annotation (__cdl(ValueInReference=false),Dialog(group="Valve"));
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
    annotation (Placement(transformation(extent={{-360,280},{-320,320}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VPri_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Measured primary airflow rate"
    annotation (Placement(transformation(extent={{-360,240},{-320,280}}),
      iconTransformation(extent={{-140,130},{-100,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-360,180},{-320,220}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
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
    annotation (Placement(transformation(extent={{-360,90},{-320,130}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-360,60},{-320,100}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active minimum airflow rate"
    annotation (Placement(transformation(extent={{-360,30},{-320,70}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint from central air handler"
    annotation (Placement(transformation(extent={{-360,-56},{-320,-16}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-360,-90},{-320,-50}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-360,-130},{-320,-90}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-360,-160},{-320,-120}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-360,-220},{-320,-180}}),
        iconTransformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Fan
    "Terminal fan status"
    annotation (Placement(transformation(extent={{-360,-310},{-320,-270}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDam(
    final min=0,
    final unit="1")
    "Damper position setpoint"
    annotation (Placement(transformation(extent={{-360,-360},{-320,-320}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VPri_flow_Set(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Primary airflow setpoint"
    annotation (Placement(transformation(extent={{320,250},{360,290}}),
        iconTransformation(extent={{100,120},{140,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(
    final min=0,
    final max=1,
    final unit="1") "VAV damper commanded position"
    annotation (Placement(transformation(extent={{320,-20},{360,20}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaDisSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Discharge airflow setpoint temperature for heating"
    annotation (Placement(transformation(extent={{320,-60},{360,-20}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(
    final min=0,
    final max=1,
    final unit="1") "Hot water valve commanded position"
    annotation (Placement(transformation(extent={{320,-110},{360,-70}}),
        iconTransformation(extent={{100,-160},{140,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Fan
    "Terminal fan command on"
    annotation (Placement(transformation(extent={{320,-360},{360,-320}}),
        iconTransformation(extent={{100,-210},{140,-170}})));

  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin
    "Active airflow setpoint for cooling"
    annotation (Placement(transformation(extent={{-160,190},{-140,210}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Output active cooling airflow according to cooling control signal"
    annotation (Placement(transformation(extent={{80,180},{100,200}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi5
    "Airflow setpoint when it is in cooling state"
    annotation (Placement(transformation(extent={{20,210},{40,230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-280,220},{-260,240}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conOne(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-220,220},{-200,240}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is cooling state"
    annotation (Placement(transformation(extent={{-220,160},{-200,180}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=dTHys,
    final h=0.5*dTHys)
    "Check if supply air temperature is greater than room temperature"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    "Calculate temperature difference between AHU supply air and room "
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr2(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is heating state"
    annotation (Placement(transformation(extent={{-260,-120},{-240,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer3(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-260,-10},{-240,10}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=dTDisZonSetMax)
    "Maximum heating discharge temperature"
    annotation (Placement(transformation(extent={{-260,-80},{-240,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conHal(
    final k=1)
    "Constant real value"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Line conTDisHeaSet
    "Discharge air temperature for heating"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
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
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Hot water valve position, close the valve when the zone is not in heating state"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant unOcc(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    "Constant signal for unoccupied mode"
    annotation (Placement(transformation(extent={{40,-180},{60,-160}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isUno
    "Output true if the operation mode is unoccupied"
    annotation (Placement(transformation(extent={{100,-180},{120,-160}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2 "Hot water valve position"
    annotation (Placement(transformation(extent={{280,-100},{300,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant nomFlow(final k=
        VCooMax_flow)
    "Nominal volume flow rate"
    annotation (Placement(transformation(extent={{160,130},{180,150}})));
  Buildings.Controls.OBC.CDL.Reals.Divide VDisSet_flowNor
    "Normalized setpoint for discharge volume flow rate"
    annotation (Placement(transformation(extent={{220,160},{240,180}})));
  Buildings.Controls.OBC.CDL.Reals.Divide VDis_flowNor
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{220,100},{240,120}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conDam(
    final controllerType=controllerTypeDam,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam,
    final yMax=1,
    final yMin=0,
    final y_reset=0)
    "Damper position controller"
    annotation (Placement(transformation(extent={{260,160},{280,180}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3 "Air damper position"
    annotation (Placement(transformation(extent={{240,10},{260,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Not in unoccupied mode"
    annotation (Placement(transformation(extent={{180,50},{200,70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat "Close damper"
    annotation (Placement(transformation(extent={{100,-280},{120,-260}})));

  Buildings.Controls.OBC.CDL.Reals.LessThreshold cloDam(
    final t=damPosHys,
    final h=damPosHys/2)
    "Check if the damper is fully closed before turning on fan"
    annotation (Placement(transformation(extent={{-260,-350},{-240,-330}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    "Check if it is in heating, cooling state, or it is in occupied mode"
    annotation (Placement(transformation(extent={{-40,-280},{-20,-260}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occ(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Constant signal for occupied mode"
    annotation (Placement(transformation(extent={{-260,-248},{-240,-228}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isOcc
    "Output true if the operation mode is occupied"
    annotation (Placement(transformation(extent={{-200,-240},{-180,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge"
    annotation (Placement(transformation(extent={{40,-280},{60,-260}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=15)
    "Check if the fan has been proven on for a fixed time"
    annotation (Placement(transformation(extent={{-260,-300},{-240,-280}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=0,
    final realFalse=1)
    "Boolean to real"
    annotation (Placement(transformation(extent={{180,-280},{200,-260}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    "Ensure damper is fully closed before turning on the fan"
    annotation (Placement(transformation(extent={{280,-10},{300,10}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if the fan can turn on"
    annotation (Placement(transformation(extent={{40,-350},{60,-330}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Hold fan on status"
    annotation (Placement(transformation(extent={{100,-350},{120,-330}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Falling edge"
    annotation (Placement(transformation(extent={{40,-390},{60,-370}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-180,350},{-160,370}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forZerFlo
    "Check if forcing zone airflow setpoint to zero"
    annotation (Placement(transformation(extent={{-120,370},{-100,390}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forCooMax
    "Check if forcing zone airflow setpoint to cooling maximum"
    annotation (Placement(transformation(extent={{-120,330},{-100,350}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{-180,310},{-160,330}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forMinFlo
    "Check if forcing zone airflow setpoint to minimum flow"
    annotation (Placement(transformation(extent={{-120,290},{-100,310}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{-180,270},{-160,290}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal zerFlo(final realTrue=0)
    "Force zone airflow setpoint to zero"
    annotation (Placement(transformation(extent={{-60,370},{-40,390}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cooMax(
    final realTrue=VCooMax_flow)
    "Force zone airflow setpoint to cooling maximum"
    annotation (Placement(transformation(extent={{-60,330},{-40,350}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal minFlo(
    final realTrue=VMin_flow)
    "Force zone airflow setpoint to zone minimum flow"
    annotation (Placement(transformation(extent={{-60,290},{-40,310}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2 "Add up two inputs"
    annotation (Placement(transformation(extent={{20,310},{40,330}})));
  Buildings.Controls.OBC.CDL.Reals.Add add1 "Add up inputs"
    annotation (Placement(transformation(extent={{80,350},{100,370}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi8
    "Airflow setpoint after considering override"
    annotation (Placement(transformation(extent={{140,260},{160,280}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or1
    "Check if the airflow setpoint should be overrided"
    annotation (Placement(transformation(extent={{60,260},{80,280}})));
equation
  connect(uCoo, lin.u)
    annotation (Line(points={{-340,200},{-162,200}}, color={0,0,127}));
  connect(conZer.y, lin.x1)
    annotation (Line(points={{-258,230},{-240,230},{-240,208},{-162,208}},
      color={0,0,127}));
  connect(conOne.y, lin.x2)
    annotation (Line(points={{-198,230},{-180,230},{-180,196},{-162,196}},
      color={0,0,127}));
  connect(VActCooMax_flow, lin.f2)
    annotation (Line(points={{-340,150},{-180,150},{-180,192},{-162,192}},
      color={0,0,127}));
  connect(uCoo, greThr1.u) annotation (Line(points={{-340,200},{-280,200},{-280,
          170},{-222,170}}, color={0,0,127}));
  connect(and4.y, swi5.u2)
    annotation (Line(points={{-18,150},{10,150},{10,220},{18,220}},
        color={255,0,255}));
  connect(lin.y, swi5.u3)
    annotation (Line(points={{-138,200},{-20,200},{-20,212},{18,212}},
      color={0,0,127}));
  connect(swi5.y, swi.u1)
    annotation (Line(points={{42,220},{60,220},{60,198},{78,198}},
      color={0,0,127}));
  connect(TSup, sub2.u1)
    annotation (Line(points={{-340,110},{-260,110},{-260,96},{-162,96}},
        color={0,0,127}));
  connect(sub2.y, greThr.u)
    annotation (Line(points={{-138,90},{-122,90}},   color={0,0,127}));
  connect(greThr.y, and4.u2) annotation (Line(points={{-98,90},{-60,90},{-60,142},
          {-42,142}}, color={255,0,255}));
  connect(greThr1.y, and4.u1) annotation (Line(points={{-198,170},{-80,170},{-80,
          150},{-42,150}},     color={255,0,255}));
  connect(greThr1.y, swi.u2) annotation (Line(points={{-198,170},{-80,170},{-80,
          190},{78,190}},  color={255,0,255}));
  connect(VActMin_flow, swi5.u1) annotation (Line(points={{-340,50},{0,50},{0,228},
          {18,228}},      color={0,0,127}));
  connect(VActMin_flow, lin.f1) annotation (Line(points={{-340,50},{-240,50},{-240,
          204},{-162,204}}, color={0,0,127}));
  connect(uHea, greThr2.u)
    annotation (Line(points={{-340,-110},{-262,-110}}, color={0,0,127}));
  connect(VActMin_flow, swi.u3) annotation (Line(points={{-340,50},{0,50},{0,182},
          {78,182}}, color={0,0,127}));
  connect(conZer3.y, conTDisHeaSet.x1) annotation (Line(points={{-238,0},{-140,0},
          {-140,-32},{-122,-32}},   color={0,0,127}));
  connect(TSupSet, conTDisHeaSet.f1)
    annotation (Line(points={{-340,-36},{-122,-36}}, color={0,0,127}));
  connect(uHea, conTDisHeaSet.u) annotation (Line(points={{-340,-110},{-280,-110},
          {-280,-40},{-122,-40}}, color={0,0,127}));
  connect(conHal.y, conTDisHeaSet.x2) annotation (Line(points={{-158,-70},{-140,
          -70},{-140,-44},{-122,-44}}, color={0,0,127}));
  connect(THeaSet, addPar.u)
    annotation (Line(points={{-340,-70},{-262,-70}}, color={0,0,127}));
  connect(addPar.y, conTDisHeaSet.f2) annotation (Line(points={{-238,-70},{-220,
          -70},{-220,-48},{-122,-48}}, color={0,0,127}));
  connect(greThr2.y, conVal.trigger) annotation (Line(points={{-238,-110},{-36,-110},
          {-36,-82}}, color={255,0,255}));
  connect(TZon, sub2.u2) annotation (Line(points={{-340,80},{-260,80},{-260,84},
          {-162,84}},  color={0,0,127}));
  connect(TDis, conVal.u_m) annotation (Line(points={{-340,-140},{-30,-140},{-30,
          -82}}, color={0,0,127}));
  connect(conTDisHeaSet.y, conVal.u_s) annotation (Line(points={{-98,-40},{-60,-40},
          {-60,-70},{-42,-70}}, color={0,0,127}));
  connect(conTDisHeaSet.y, THeaDisSet)
    annotation (Line(points={{-98,-40},{340,-40}}, color={0,0,127}));
  connect(greThr2.y, swi1.u2)
    annotation (Line(points={{-238,-110},{98,-110}}, color={255,0,255}));
  connect(conVal.y, swi1.u1) annotation (Line(points={{-18,-70},{20,-70},{20,-102},
          {98,-102}},color={0,0,127}));
  connect(unOcc.y, isUno.u1)
    annotation (Line(points={{62,-170},{98,-170}}, color={255,127,0}));
  connect(uOpeMod, isUno.u2) annotation (Line(points={{-340,-200},{80,-200},{80,
          -178},{98,-178}}, color={255,127,0}));
  connect(isUno.y, swi2.u2) annotation (Line(points={{122,-170},{140,-170},{140,
          -90},{278,-90}}, color={255,0,255}));
  connect(conZer3.y, swi1.u3) annotation (Line(points={{-238,0},{40,0},{40,-118},
          {98,-118}},color={0,0,127}));
  connect(conZer3.y, swi2.u1) annotation (Line(points={{-238,0},{40,0},{40,-82},
          {278,-82}}, color={0,0,127}));
  connect(swi1.y, swi2.u3) annotation (Line(points={{122,-110},{200,-110},{200,-98},
          {278,-98}}, color={0,0,127}));
  connect(swi2.y, yVal)
    annotation (Line(points={{302,-90},{340,-90}}, color={0,0,127}));
  connect(nomFlow.y, VDisSet_flowNor.u2) annotation (Line(points={{182,140},{200,
          140},{200,164},{218,164}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, conDam.u_s)
    annotation (Line(points={{242,170},{258,170}}, color={0,0,127}));
  connect(VPri_flow, VDis_flowNor.u1) annotation (Line(points={{-340,260},{-300,
          260},{-300,116},{218,116}}, color={0,0,127}));
  connect(nomFlow.y, VDis_flowNor.u2) annotation (Line(points={{182,140},{200,140},
          {200,104},{218,104}}, color={0,0,127}));
  connect(isUno.y, swi3.u2) annotation (Line(points={{122,-170},{140,-170},{140,
          20},{238,20}}, color={255,0,255}));
  connect(conZer3.y, swi3.u1) annotation (Line(points={{-238,0},{40,0},{40,28},{
          238,28}},  color={0,0,127}));
  connect(conDam.y, swi3.u3) annotation (Line(points={{282,170},{300,170},{300,80},
          {220,80},{220,12},{238,12}},  color={0,0,127}));
  connect(VDis_flowNor.y, conDam.u_m)
    annotation (Line(points={{242,110},{270,110},{270,158}}, color={0,0,127}));
  connect(isUno.y, not1.u) annotation (Line(points={{122,-170},{140,-170},{140,60},
          {178,60}},  color={255,0,255}));
  connect(not1.y, conDam.trigger) annotation (Line(points={{202,60},{264,60},{264,
          158}},     color={255,0,255}));
  connect(uDam, cloDam.u)
    annotation (Line(points={{-340,-340},{-262,-340}}, color={0,0,127}));
  connect(uOpeMod, isOcc.u1) annotation (Line(points={{-340,-200},{-220,-200},{-220,
          -230},{-202,-230}}, color={255,127,0}));
  connect(occ.y, isOcc.u2)
    annotation (Line(points={{-238,-238},{-202,-238}}, color={255,127,0}));
  connect(greThr1.y, or3.u1) annotation (Line(points={{-198,170},{-80,170},{-80,
          -262},{-42,-262}}, color={255,0,255}));
  connect(greThr2.y, or3.u2) annotation (Line(points={{-238,-110},{-100,-110},{-100,
          -270},{-42,-270}}, color={255,0,255}));
  connect(isOcc.y, or3.u3) annotation (Line(points={{-178,-230},{-120,-230},{-120,
          -278},{-42,-278}}, color={255,0,255}));
  connect(or3.y, edg.u)
    annotation (Line(points={{-18,-270},{38,-270}}, color={255,0,255}));
  connect(edg.y, lat.u)
    annotation (Line(points={{62,-270},{98,-270}}, color={255,0,255}));
  connect(u1Fan, tim.u)
    annotation (Line(points={{-340,-290},{-262,-290}}, color={255,0,255}));
  connect(tim.passed, lat.clr) annotation (Line(points={{-238,-298},{80,-298},{80,
          -276},{98,-276}}, color={255,0,255}));
  connect(lat.y, booToRea.u)
    annotation (Line(points={{122,-270},{178,-270}}, color={255,0,255}));
  connect(booToRea.y, mul.u2) annotation (Line(points={{202,-270},{240,-270},{240,
          -6},{278,-6}}, color={0,0,127}));
  connect(swi3.y, mul.u1) annotation (Line(points={{262,20},{270,20},{270,6},{278,
          6}},  color={0,0,127}));
  connect(mul.y, yDam)
    annotation (Line(points={{302,0},{340,0}},   color={0,0,127}));
  connect(cloDam.y, and2.u1)
    annotation (Line(points={{-238,-340},{38,-340}}, color={255,0,255}));
  connect(or3.y, and2.u2) annotation (Line(points={{-18,-270},{0,-270},{0,-348},
          {38,-348}}, color={255,0,255}));
  connect(and2.y, lat1.u)
    annotation (Line(points={{62,-340},{98,-340}}, color={255,0,255}));
  connect(or3.y, falEdg.u) annotation (Line(points={{-18,-270},{0,-270},{0,-380},
          {38,-380}}, color={255,0,255}));
  connect(falEdg.y, lat1.clr) annotation (Line(points={{62,-380},{80,-380},{80,-346},
          {98,-346}}, color={255,0,255}));
  connect(lat1.y, y1Fan)
    annotation (Line(points={{122,-340},{340,-340}}, color={255,0,255}));
  connect(oveFloSet,forZerFlo. u1)
    annotation (Line(points={{-340,300},{-200,300},{-200,380},{-122,380}},
          color={255,127,0}));
  connect(conInt.y,forZerFlo. u2) annotation (Line(points={{-158,360},{-140,360},
          {-140,372},{-122,372}},color={255,127,0}));
  connect(oveFloSet,forCooMax. u1) annotation (Line(points={{-340,300},{-200,300},
          {-200,340},{-122,340}},color={255,127,0}));
  connect(conInt1.y,forCooMax. u2) annotation (Line(points={{-158,320},{-140,320},
          {-140,332},{-122,332}}, color={255,127,0}));
  connect(oveFloSet,forMinFlo. u1) annotation (Line(points={{-340,300},{-122,300}},
         color={255,127,0}));
  connect(conInt2.y,forMinFlo. u2) annotation (Line(points={{-158,280},{-140,280},
          {-140,292},{-122,292}}, color={255,127,0}));
  connect(forZerFlo.y,zerFlo. u)
    annotation (Line(points={{-98,380},{-62,380}}, color={255,0,255}));
  connect(forCooMax.y,cooMax. u)
    annotation (Line(points={{-98,340},{-62,340}}, color={255,0,255}));
  connect(forMinFlo.y,minFlo. u)
    annotation (Line(points={{-98,300},{-62,300}}, color={255,0,255}));
  connect(cooMax.y,add2. u1) annotation (Line(points={{-38,340},{0,340},{0,326},
          {18,326}},color={0,0,127}));
  connect(zerFlo.y,add1. u1) annotation (Line(points={{-38,380},{20,380},{20,366},
          {78,366}}, color={0,0,127}));
  connect(forZerFlo.y,or1. u1) annotation (Line(points={{-98,380},{-80,380},{-80,
          278},{58,278}}, color={255,0,255}));
  connect(forCooMax.y,or1. u2) annotation (Line(points={{-98,340},{-80,340},{-80,
          270},{58,270}}, color={255,0,255}));
  connect(add1.y,swi8. u1) annotation (Line(points={{102,360},{120,360},{120,278},
          {138,278}}, color={0,0,127}));
  connect(add2.y,add1. u2) annotation (Line(points={{42,320},{60,320},{60,354},{
          78,354}}, color={0,0,127}));
  connect(minFlo.y,add2. u2) annotation (Line(points={{-38,300},{0,300},{0,314},
          {18,314}}, color={0,0,127}));
  connect(forMinFlo.y,or1. u3) annotation (Line(points={{-98,300},{-80,300},{-80,
          262},{58,262}},color={255,0,255}));
  connect(or1.y, swi8.u2)
    annotation (Line(points={{82,270},{138,270}}, color={255,0,255}));
  connect(swi.y, swi8.u3) annotation (Line(points={{102,190},{120,190},{120,262},
          {138,262}}, color={0,0,127}));
  connect(swi8.y, VDisSet_flowNor.u1) annotation (Line(points={{162,270},{200,270},
          {200,176},{218,176}}, color={0,0,127}));
  connect(swi8.y, VPri_flow_Set)
    annotation (Line(points={{162,270},{340,270}}, color={0,0,127}));
annotation (
  defaultComponentName="damValFan",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-400},{320,400}}),
        graphics={
        Rectangle(
          extent={{-318,398},{138,62}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-152,258},{-24,236}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Discharge airflow setpoint"),
        Rectangle(
          extent={{-318,-22},{138,-158}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-10,-132},{106,-148}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Heating coil control"),
        Rectangle(
          extent={{-318,-224},{138,-398}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-246,-374},{-130,-390}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Terminal fan control")}),
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
          extent={{-96,-182},{-46,-198}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDam"),
        Text(
          extent={{-98,14},{-54,4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin_flow"),
        Text(
          extent={{-100,126},{-80,116}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-98,-64},{-78,-76}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHea"),
        Text(
          extent={{-98,-34},{-60,-44}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{-100,64},{-80,56}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-12.5,6},{12.5,-6}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis",
          origin={-88.5,-102}),
        Text(
          extent={{-100,44},{-80,36}},
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
          extent={{66,-132},{98,-146}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yVal"),
        Line(points={{-38,64},{-38,-48},{74,-48}}, color={95,95,95}),
        Line(
          points={{-38,60},{10,-48}},
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
          extent={{60,-84},{98,-96}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="TDisHeaSet"),
        Text(
          extent={{-96,-124},{-60,-136}},
          textColor={255,127,27},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{-98,156},{-68,146}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VPri_flow"),
        Text(
          extent={{-100,-16},{-68,-24}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSupSet"),
        Text(
          extent={{64,-180},{96,-194}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="y1Fan"),
        Line(
          points={{-38,-22},{26,-22},{78,60}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{74,60},{-38,60}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Text(
          extent={{-98,-152},{-70,-168}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="u1Fan"),
        Text(
          extent={{-96,196},{-60,184}},
          textColor={255,127,27},
          pattern=LinePattern.Dash,
          textString="oveFloSet")}),
  Documentation(info="<html>
<p>
This sequence sets the fan status, damper and valve position for constant-volume
series fan-powered terminal unit.
The implementation is according to Section 5.9.5 of ASHRAE Guideline 36, May 2020. The
calculation is done following the steps below.
</p>
<ol>
<li>
When the zone state is cooling (<code>uCoo &gt; 0</code>), then the cooling loop output
<code>uCoo</code> shall be mapped to the airflow
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
the active airflow setpoint shall be the minimum airflow setpoint <code>VActMin_flow</code>.
The heating coil is disabled (<code>yVal=0</code>).
</li>
<li>
When the zone state is Heating (<code>uHea &gt; 0</code>),
<ul>
<li>
As the heating-loop output <code>uHea</code> increases from 0% to 100%, it shall reset
the discharge temperature <code>THeaDisSet</code> from the current AHU setpoint
temperature <code>TSupSet</code> to a maximum of <code>dTDisZonSetMax</code>
above space temperature setpoint.
</li>
<li>
The airflow setpoint shall be the minimum flow <code>VActMin_flow</code>.
</li>
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
Fan control
<ul>
<li>
Fan shall run whenever zone state is heating or cooling state, or if the associated
zone group is in occupied mode. Prior to starting fan, the damper is first driven
fully closed to ensure that the fan is not rotating backward. Once the fan is
proven on (<code>u1Fan=true</code>) for a fixed time delay (15 seconds), the damper
override is released.
</li>
</ul>
</li>
</ol>
<p>The sequences of controlling fan, damper position for constant-volume
series fan-powered terminal unit are described in the following figure below.</p>
<p align=\"center\">
<img alt=\"Image of damper and valve control for constant-volume series fan-powered terminal unit\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/TerminalUnits/SeriesFanCVF/Subsequences/Damper.png\"/>
</p>
<p>
As specified in Section 5.9.7 of ASHRAE Guideline 36, the airflow setpoint could be
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
